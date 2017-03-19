From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 for-next 1/7] IB/core: Refactor idr to be per uverbs_file
Date: Sun, 19 Mar 2017 17:58:59 +0200
Message-ID: <1489939145-125246-2-git-send-email-matanb@mellanox.com>
References: <1489939145-125246-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489939145-125246-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The current code creates an idr per type. Since types are currently
common for all drivers and known in advance, this was good enough.
However, the proposed ioctl based infrastructure allows each driver
to declare only some of the common types and declare its own specific
types.

Thus, we decided to implement idr to be per uverbs_file.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h      |  19 ++---
 drivers/infiniband/core/uverbs_cmd.c  | 153 +++++++++++++++++-----------------
 drivers/infiniband/core/uverbs_main.c |  45 ++++------
 include/rdma/ib_verbs.h               |   1 +
 4 files changed, 95 insertions(+), 123 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 455034a..662a592 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -123,6 +123,10 @@ struct ib_uverbs_file {
 	struct ib_uverbs_event_file	       *async_file;
 	struct list_head			list;
 	int					is_closed;
+
+	struct idr		idr;
+	/* spinlock protects write access to idr */
+	spinlock_t		idr_lock;
 };
 
 struct ib_uverbs_event {
@@ -176,20 +180,7 @@ struct ib_ucq_object {
 	u32			async_events_reported;
 };
 
-extern spinlock_t ib_uverbs_idr_lock;
-extern struct idr ib_uverbs_pd_idr;
-extern struct idr ib_uverbs_mr_idr;
-extern struct idr ib_uverbs_mw_idr;
-extern struct idr ib_uverbs_ah_idr;
-extern struct idr ib_uverbs_cq_idr;
-extern struct idr ib_uverbs_qp_idr;
-extern struct idr ib_uverbs_srq_idr;
-extern struct idr ib_uverbs_xrcd_idr;
-extern struct idr ib_uverbs_rule_idr;
-extern struct idr ib_uverbs_wq_idr;
-extern struct idr ib_uverbs_rwq_ind_tbl_idr;
-
-void idr_remove_uobj(struct idr *idp, struct ib_uobject *uobj);
+void idr_remove_uobj(struct ib_uobject *uobj);
 
 struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
 					struct ib_device *ib_dev,
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 7007822..29c621d 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -120,37 +120,36 @@ static void put_uobj_write(struct ib_uobject *uobj)
 	put_uobj(uobj);
 }
 
-static int idr_add_uobj(struct idr *idr, struct ib_uobject *uobj)
+static int idr_add_uobj(struct ib_uobject *uobj)
 {
 	int ret;
 
 	idr_preload(GFP_KERNEL);
-	spin_lock(&ib_uverbs_idr_lock);
+	spin_lock(&uobj->context->ufile->idr_lock);
 
-	ret = idr_alloc(idr, uobj, 0, 0, GFP_NOWAIT);
+	ret = idr_alloc(&uobj->context->ufile->idr, uobj, 0, 0, GFP_NOWAIT);
 	if (ret >= 0)
 		uobj->id = ret;
 
-	spin_unlock(&ib_uverbs_idr_lock);
+	spin_unlock(&uobj->context->ufile->idr_lock);
 	idr_preload_end();
 
 	return ret < 0 ? ret : 0;
 }
 
-void idr_remove_uobj(struct idr *idr, struct ib_uobject *uobj)
+void idr_remove_uobj(struct ib_uobject *uobj)
 {
-	spin_lock(&ib_uverbs_idr_lock);
-	idr_remove(idr, uobj->id);
-	spin_unlock(&ib_uverbs_idr_lock);
+	spin_lock(&uobj->context->ufile->idr_lock);
+	idr_remove(&uobj->context->ufile->idr, uobj->id);
+	spin_unlock(&uobj->context->ufile->idr_lock);
 }
 
-static struct ib_uobject *__idr_get_uobj(struct idr *idr, int id,
-					 struct ib_ucontext *context)
+static struct ib_uobject *__idr_get_uobj(int id, struct ib_ucontext *context)
 {
 	struct ib_uobject *uobj;
 
 	rcu_read_lock();
-	uobj = idr_find(idr, id);
+	uobj = idr_find(&context->ufile->idr, id);
 	if (uobj) {
 		if (uobj->context == context)
 			kref_get(&uobj->ref);
@@ -162,12 +161,12 @@ static struct ib_uobject *__idr_get_uobj(struct idr *idr, int id,
 	return uobj;
 }
 
-static struct ib_uobject *idr_read_uobj(struct idr *idr, int id,
-					struct ib_ucontext *context, int nested)
+static struct ib_uobject *idr_read_uobj(int id, struct ib_ucontext *context,
+					int nested)
 {
 	struct ib_uobject *uobj;
 
-	uobj = __idr_get_uobj(idr, id, context);
+	uobj = __idr_get_uobj(id, context);
 	if (!uobj)
 		return NULL;
 
@@ -183,12 +182,11 @@ static struct ib_uobject *idr_read_uobj(struct idr *idr, int id,
 	return uobj;
 }
 
-static struct ib_uobject *idr_write_uobj(struct idr *idr, int id,
-					 struct ib_ucontext *context)
+static struct ib_uobject *idr_write_uobj(int id, struct ib_ucontext *context)
 {
 	struct ib_uobject *uobj;
 
-	uobj = __idr_get_uobj(idr, id, context);
+	uobj = __idr_get_uobj(id, context);
 	if (!uobj)
 		return NULL;
 
@@ -201,18 +199,18 @@ static struct ib_uobject *idr_write_uobj(struct idr *idr, int id,
 	return uobj;
 }
 
-static void *idr_read_obj(struct idr *idr, int id, struct ib_ucontext *context,
+static void *idr_read_obj(int id, struct ib_ucontext *context,
 			  int nested)
 {
 	struct ib_uobject *uobj;
 
-	uobj = idr_read_uobj(idr, id, context, nested);
+	uobj = idr_read_uobj(id, context, nested);
 	return uobj ? uobj->object : NULL;
 }
 
 static struct ib_pd *idr_read_pd(int pd_handle, struct ib_ucontext *context)
 {
-	return idr_read_obj(&ib_uverbs_pd_idr, pd_handle, context, 0);
+	return idr_read_obj(pd_handle, context, 0);
 }
 
 static void put_pd_read(struct ib_pd *pd)
@@ -222,7 +220,7 @@ static void put_pd_read(struct ib_pd *pd)
 
 static struct ib_cq *idr_read_cq(int cq_handle, struct ib_ucontext *context, int nested)
 {
-	return idr_read_obj(&ib_uverbs_cq_idr, cq_handle, context, nested);
+	return idr_read_obj(cq_handle, context, nested);
 }
 
 static void put_cq_read(struct ib_cq *cq)
@@ -232,7 +230,7 @@ static void put_cq_read(struct ib_cq *cq)
 
 static struct ib_ah *idr_read_ah(int ah_handle, struct ib_ucontext *context)
 {
-	return idr_read_obj(&ib_uverbs_ah_idr, ah_handle, context, 0);
+	return idr_read_obj(ah_handle, context, 0);
 }
 
 static void put_ah_read(struct ib_ah *ah)
@@ -242,12 +240,12 @@ static void put_ah_read(struct ib_ah *ah)
 
 static struct ib_qp *idr_read_qp(int qp_handle, struct ib_ucontext *context)
 {
-	return idr_read_obj(&ib_uverbs_qp_idr, qp_handle, context, 0);
+	return idr_read_obj(qp_handle, context, 0);
 }
 
 static struct ib_wq *idr_read_wq(int wq_handle, struct ib_ucontext *context)
 {
-	return idr_read_obj(&ib_uverbs_wq_idr, wq_handle, context, 0);
+	return idr_read_obj(wq_handle, context, 0);
 }
 
 static void put_wq_read(struct ib_wq *wq)
@@ -258,7 +256,7 @@ static void put_wq_read(struct ib_wq *wq)
 static struct ib_rwq_ind_table *idr_read_rwq_indirection_table(int ind_table_handle,
 							       struct ib_ucontext *context)
 {
-	return idr_read_obj(&ib_uverbs_rwq_ind_tbl_idr, ind_table_handle, context, 0);
+	return idr_read_obj(ind_table_handle, context, 0);
 }
 
 static void put_rwq_indirection_table_read(struct ib_rwq_ind_table *ind_table)
@@ -270,7 +268,7 @@ static struct ib_qp *idr_write_qp(int qp_handle, struct ib_ucontext *context)
 {
 	struct ib_uobject *uobj;
 
-	uobj = idr_write_uobj(&ib_uverbs_qp_idr, qp_handle, context);
+	uobj = idr_write_uobj(qp_handle, context);
 	return uobj ? uobj->object : NULL;
 }
 
@@ -286,7 +284,7 @@ static void put_qp_write(struct ib_qp *qp)
 
 static struct ib_srq *idr_read_srq(int srq_handle, struct ib_ucontext *context)
 {
-	return idr_read_obj(&ib_uverbs_srq_idr, srq_handle, context, 0);
+	return idr_read_obj(srq_handle, context, 0);
 }
 
 static void put_srq_read(struct ib_srq *srq)
@@ -297,7 +295,7 @@ static void put_srq_read(struct ib_srq *srq)
 static struct ib_xrcd *idr_read_xrcd(int xrcd_handle, struct ib_ucontext *context,
 				     struct ib_uobject **uobj)
 {
-	*uobj = idr_read_uobj(&ib_uverbs_xrcd_idr, xrcd_handle, context, 0);
+	*uobj = idr_read_uobj(xrcd_handle, context, 0);
 	return *uobj ? (*uobj)->object : NULL;
 }
 
@@ -305,7 +303,6 @@ static void put_xrcd_read(struct ib_uobject *uobj)
 {
 	put_uobj_read(uobj);
 }
-
 ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 			      struct ib_device *ib_dev,
 			      const char __user *buf,
@@ -342,6 +339,8 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 	}
 
 	ucontext->device = ib_dev;
+	/* ufile is required when some objects are released */
+	ucontext->ufile = file;
 	INIT_LIST_HEAD(&ucontext->pd_list);
 	INIT_LIST_HEAD(&ucontext->mr_list);
 	INIT_LIST_HEAD(&ucontext->mw_list);
@@ -575,7 +574,7 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 	atomic_set(&pd->usecnt, 0);
 
 	uobj->object = pd;
-	ret = idr_add_uobj(&ib_uverbs_pd_idr, uobj);
+	ret = idr_add_uobj(uobj);
 	if (ret)
 		goto err_idr;
 
@@ -599,7 +598,7 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 	return in_len;
 
 err_copy:
-	idr_remove_uobj(&ib_uverbs_pd_idr, uobj);
+	idr_remove_uobj(uobj);
 
 err_idr:
 	ib_dealloc_pd(pd);
@@ -622,7 +621,7 @@ ssize_t ib_uverbs_dealloc_pd(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(&ib_uverbs_pd_idr, cmd.pd_handle, file->ucontext);
+	uobj = idr_write_uobj(cmd.pd_handle, file->ucontext);
 	if (!uobj)
 		return -EINVAL;
 	pd = uobj->object;
@@ -640,7 +639,7 @@ ssize_t ib_uverbs_dealloc_pd(struct ib_uverbs_file *file,
 	uobj->live = 0;
 	put_uobj_write(uobj);
 
-	idr_remove_uobj(&ib_uverbs_pd_idr, uobj);
+	idr_remove_uobj(uobj);
 
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
@@ -816,7 +815,7 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 
 	atomic_set(&obj->refcnt, 0);
 	obj->uobject.object = xrcd;
-	ret = idr_add_uobj(&ib_uverbs_xrcd_idr, &obj->uobject);
+	ret = idr_add_uobj(&obj->uobject);
 	if (ret)
 		goto err_idr;
 
@@ -860,7 +859,7 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 	}
 
 err_insert_xrcd:
-	idr_remove_uobj(&ib_uverbs_xrcd_idr, &obj->uobject);
+	idr_remove_uobj(&obj->uobject);
 
 err_idr:
 	ib_dealloc_xrcd(xrcd);
@@ -894,7 +893,7 @@ ssize_t ib_uverbs_close_xrcd(struct ib_uverbs_file *file,
 		return -EFAULT;
 
 	mutex_lock(&file->device->xrcd_tree_mutex);
-	uobj = idr_write_uobj(&ib_uverbs_xrcd_idr, cmd.xrcd_handle, file->ucontext);
+	uobj = idr_write_uobj(cmd.xrcd_handle, file->ucontext);
 	if (!uobj) {
 		ret = -EINVAL;
 		goto out;
@@ -927,7 +926,7 @@ ssize_t ib_uverbs_close_xrcd(struct ib_uverbs_file *file,
 	if (inode && !live)
 		xrcd_table_delete(file->device, inode);
 
-	idr_remove_uobj(&ib_uverbs_xrcd_idr, uobj);
+	idr_remove_uobj(uobj);
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
 	mutex_unlock(&file->mutex);
@@ -1020,7 +1019,7 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 	atomic_inc(&pd->usecnt);
 
 	uobj->object = mr;
-	ret = idr_add_uobj(&ib_uverbs_mr_idr, uobj);
+	ret = idr_add_uobj(uobj);
 	if (ret)
 		goto err_unreg;
 
@@ -1048,7 +1047,7 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 	return in_len;
 
 err_copy:
-	idr_remove_uobj(&ib_uverbs_mr_idr, uobj);
+	idr_remove_uobj(uobj);
 
 err_unreg:
 	ib_dereg_mr(mr);
@@ -1093,8 +1092,7 @@ ssize_t ib_uverbs_rereg_mr(struct ib_uverbs_file *file,
 	     (cmd.start & ~PAGE_MASK) != (cmd.hca_va & ~PAGE_MASK)))
 			return -EINVAL;
 
-	uobj = idr_write_uobj(&ib_uverbs_mr_idr, cmd.mr_handle,
-			      file->ucontext);
+	uobj = idr_write_uobj(cmd.mr_handle, file->ucontext);
 
 	if (!uobj)
 		return -EINVAL;
@@ -1163,7 +1161,7 @@ ssize_t ib_uverbs_dereg_mr(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(&ib_uverbs_mr_idr, cmd.mr_handle, file->ucontext);
+	uobj = idr_write_uobj(cmd.mr_handle, file->ucontext);
 	if (!uobj)
 		return -EINVAL;
 
@@ -1178,7 +1176,7 @@ ssize_t ib_uverbs_dereg_mr(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
-	idr_remove_uobj(&ib_uverbs_mr_idr, uobj);
+	idr_remove_uobj(uobj);
 
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
@@ -1238,7 +1236,7 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 	atomic_inc(&pd->usecnt);
 
 	uobj->object = mw;
-	ret = idr_add_uobj(&ib_uverbs_mw_idr, uobj);
+	ret = idr_add_uobj(uobj);
 	if (ret)
 		goto err_unalloc;
 
@@ -1265,7 +1263,7 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 	return in_len;
 
 err_copy:
-	idr_remove_uobj(&ib_uverbs_mw_idr, uobj);
+	idr_remove_uobj(uobj);
 
 err_unalloc:
 	uverbs_dealloc_mw(mw);
@@ -1291,7 +1289,7 @@ ssize_t ib_uverbs_dealloc_mw(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof(cmd)))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(&ib_uverbs_mw_idr, cmd.mw_handle, file->ucontext);
+	uobj = idr_write_uobj(cmd.mw_handle, file->ucontext);
 	if (!uobj)
 		return -EINVAL;
 
@@ -1306,7 +1304,7 @@ ssize_t ib_uverbs_dealloc_mw(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
-	idr_remove_uobj(&ib_uverbs_mw_idr, uobj);
+	idr_remove_uobj(uobj);
 
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
@@ -1420,7 +1418,7 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 	atomic_set(&cq->usecnt, 0);
 
 	obj->uobject.object = cq;
-	ret = idr_add_uobj(&ib_uverbs_cq_idr, &obj->uobject);
+	ret = idr_add_uobj(&obj->uobject);
 	if (ret)
 		goto err_free;
 
@@ -1446,7 +1444,7 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 	return obj;
 
 err_cb:
-	idr_remove_uobj(&ib_uverbs_cq_idr, &obj->uobject);
+	idr_remove_uobj(&obj->uobject);
 
 err_free:
 	ib_destroy_cq(cq);
@@ -1716,7 +1714,7 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(&ib_uverbs_cq_idr, cmd.cq_handle, file->ucontext);
+	uobj = idr_write_uobj(cmd.cq_handle, file->ucontext);
 	if (!uobj)
 		return -EINVAL;
 	cq      = uobj->object;
@@ -1732,7 +1730,7 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
-	idr_remove_uobj(&ib_uverbs_cq_idr, uobj);
+	idr_remove_uobj(uobj);
 
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
@@ -1939,7 +1937,7 @@ static int create_qp(struct ib_uverbs_file *file,
 	qp->uobject = &obj->uevent.uobject;
 
 	obj->uevent.uobject.object = qp;
-	ret = idr_add_uobj(&ib_uverbs_qp_idr, &obj->uevent.uobject);
+	ret = idr_add_uobj(&obj->uevent.uobject);
 	if (ret)
 		goto err_destroy;
 
@@ -1987,7 +1985,7 @@ static int create_qp(struct ib_uverbs_file *file,
 
 	return 0;
 err_cb:
-	idr_remove_uobj(&ib_uverbs_qp_idr, &obj->uevent.uobject);
+	idr_remove_uobj(&obj->uevent.uobject);
 
 err_destroy:
 	ib_destroy_qp(qp);
@@ -2173,7 +2171,7 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
 	qp->uobject = &obj->uevent.uobject;
 
 	obj->uevent.uobject.object = qp;
-	ret = idr_add_uobj(&ib_uverbs_qp_idr, &obj->uevent.uobject);
+	ret = idr_add_uobj(&obj->uevent.uobject);
 	if (ret)
 		goto err_destroy;
 
@@ -2202,7 +2200,7 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
 	return in_len;
 
 err_remove:
-	idr_remove_uobj(&ib_uverbs_qp_idr, &obj->uevent.uobject);
+	idr_remove_uobj(&obj->uevent.uobject);
 
 err_destroy:
 	ib_destroy_qp(qp);
@@ -2498,7 +2496,7 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 
 	memset(&resp, 0, sizeof resp);
 
-	uobj = idr_write_uobj(&ib_uverbs_qp_idr, cmd.qp_handle, file->ucontext);
+	uobj = idr_write_uobj(cmd.qp_handle, file->ucontext);
 	if (!uobj)
 		return -EINVAL;
 	qp  = uobj->object;
@@ -2521,7 +2519,7 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 	if (obj->uxrcd)
 		atomic_dec(&obj->uxrcd->refcnt);
 
-	idr_remove_uobj(&ib_uverbs_qp_idr, uobj);
+	idr_remove_uobj(uobj);
 
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
@@ -2982,7 +2980,7 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	ah->uobject  = uobj;
 	uobj->object = ah;
 
-	ret = idr_add_uobj(&ib_uverbs_ah_idr, uobj);
+	ret = idr_add_uobj(uobj);
 	if (ret)
 		goto err_destroy;
 
@@ -3007,7 +3005,7 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	return in_len;
 
 err_copy:
-	idr_remove_uobj(&ib_uverbs_ah_idr, uobj);
+	idr_remove_uobj(uobj);
 
 err_destroy:
 	ib_destroy_ah(ah);
@@ -3032,7 +3030,7 @@ ssize_t ib_uverbs_destroy_ah(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(&ib_uverbs_ah_idr, cmd.ah_handle, file->ucontext);
+	uobj = idr_write_uobj(cmd.ah_handle, file->ucontext);
 	if (!uobj)
 		return -EINVAL;
 	ah = uobj->object;
@@ -3046,7 +3044,7 @@ ssize_t ib_uverbs_destroy_ah(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
-	idr_remove_uobj(&ib_uverbs_ah_idr, uobj);
+	idr_remove_uobj(uobj);
 
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
@@ -3345,7 +3343,7 @@ int ib_uverbs_ex_create_wq(struct ib_uverbs_file *file,
 	atomic_inc(&cq->usecnt);
 	wq->uobject = &obj->uevent.uobject;
 	obj->uevent.uobject.object = wq;
-	err = idr_add_uobj(&ib_uverbs_wq_idr, &obj->uevent.uobject);
+	err = idr_add_uobj(&obj->uevent.uobject);
 	if (err)
 		goto destroy_wq;
 
@@ -3372,7 +3370,7 @@ int ib_uverbs_ex_create_wq(struct ib_uverbs_file *file,
 	return 0;
 
 err_copy:
-	idr_remove_uobj(&ib_uverbs_wq_idr, &obj->uevent.uobject);
+	idr_remove_uobj(&obj->uevent.uobject);
 destroy_wq:
 	ib_destroy_wq(wq);
 err_put_cq:
@@ -3421,7 +3419,7 @@ int ib_uverbs_ex_destroy_wq(struct ib_uverbs_file *file,
 		return -EOPNOTSUPP;
 
 	resp.response_length = required_resp_len;
-	uobj = idr_write_uobj(&ib_uverbs_wq_idr, cmd.wq_handle,
+	uobj = idr_write_uobj(cmd.wq_handle,
 			      file->ucontext);
 	if (!uobj)
 		return -EINVAL;
@@ -3436,7 +3434,7 @@ int ib_uverbs_ex_destroy_wq(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
-	idr_remove_uobj(&ib_uverbs_wq_idr, uobj);
+	idr_remove_uobj(uobj);
 
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
@@ -3604,7 +3602,7 @@ int ib_uverbs_ex_create_rwq_ind_table(struct ib_uverbs_file *file,
 	for (i = 0; i < num_wq_handles; i++)
 		atomic_inc(&wqs[i]->usecnt);
 
-	err = idr_add_uobj(&ib_uverbs_rwq_ind_tbl_idr, uobj);
+	err = idr_add_uobj(uobj);
 	if (err)
 		goto destroy_ind_tbl;
 
@@ -3632,7 +3630,7 @@ int ib_uverbs_ex_create_rwq_ind_table(struct ib_uverbs_file *file,
 	return 0;
 
 err_copy:
-	idr_remove_uobj(&ib_uverbs_rwq_ind_tbl_idr, uobj);
+	idr_remove_uobj(uobj);
 destroy_ind_tbl:
 	ib_destroy_rwq_ind_table(rwq_ind_tbl);
 err_uobj:
@@ -3675,7 +3673,7 @@ int ib_uverbs_ex_destroy_rwq_ind_table(struct ib_uverbs_file *file,
 	if (cmd.comp_mask)
 		return -EOPNOTSUPP;
 
-	uobj = idr_write_uobj(&ib_uverbs_rwq_ind_tbl_idr, cmd.ind_tbl_handle,
+	uobj = idr_write_uobj(cmd.ind_tbl_handle,
 			      file->ucontext);
 	if (!uobj)
 		return -EINVAL;
@@ -3691,7 +3689,7 @@ int ib_uverbs_ex_destroy_rwq_ind_table(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
-	idr_remove_uobj(&ib_uverbs_rwq_ind_tbl_idr, uobj);
+	idr_remove_uobj(uobj);
 
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
@@ -3830,7 +3828,7 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 	flow_id->uobject = uobj;
 	uobj->object = flow_id;
 
-	err = idr_add_uobj(&ib_uverbs_rule_idr, uobj);
+	err = idr_add_uobj(uobj);
 	if (err)
 		goto destroy_flow;
 
@@ -3855,7 +3853,7 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 		kfree(kern_flow_attr);
 	return 0;
 err_copy:
-	idr_remove_uobj(&ib_uverbs_rule_idr, uobj);
+	idr_remove_uobj(uobj);
 destroy_flow:
 	ib_destroy_flow(flow_id);
 err_free:
@@ -3890,8 +3888,7 @@ int ib_uverbs_ex_destroy_flow(struct ib_uverbs_file *file,
 	if (cmd.comp_mask)
 		return -EINVAL;
 
-	uobj = idr_write_uobj(&ib_uverbs_rule_idr, cmd.flow_handle,
-			      file->ucontext);
+	uobj = idr_write_uobj(cmd.flow_handle, file->ucontext);
 	if (!uobj)
 		return -EINVAL;
 	flow_id = uobj->object;
@@ -3902,7 +3899,7 @@ int ib_uverbs_ex_destroy_flow(struct ib_uverbs_file *file,
 
 	put_uobj_write(uobj);
 
-	idr_remove_uobj(&ib_uverbs_rule_idr, uobj);
+	idr_remove_uobj(uobj);
 
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
@@ -3990,7 +3987,7 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	atomic_set(&srq->usecnt, 0);
 
 	obj->uevent.uobject.object = srq;
-	ret = idr_add_uobj(&ib_uverbs_srq_idr, &obj->uevent.uobject);
+	ret = idr_add_uobj(&obj->uevent.uobject);
 	if (ret)
 		goto err_destroy;
 
@@ -4024,7 +4021,7 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	return 0;
 
 err_copy:
-	idr_remove_uobj(&ib_uverbs_srq_idr, &obj->uevent.uobject);
+	idr_remove_uobj(&obj->uevent.uobject);
 
 err_destroy:
 	ib_destroy_srq(srq);
@@ -4200,7 +4197,7 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(&ib_uverbs_srq_idr, cmd.srq_handle, file->ucontext);
+	uobj = idr_write_uobj(cmd.srq_handle, file->ucontext);
 	if (!uobj)
 		return -EINVAL;
 	srq = uobj->object;
@@ -4221,7 +4218,7 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 		atomic_dec(&us->uxrcd->refcnt);
 	}
 
-	idr_remove_uobj(&ib_uverbs_srq_idr, uobj);
+	idr_remove_uobj(uobj);
 
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index b3f95d4..8344afd 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -66,19 +66,6 @@ enum {
 
 static struct class *uverbs_class;
 
-DEFINE_SPINLOCK(ib_uverbs_idr_lock);
-DEFINE_IDR(ib_uverbs_pd_idr);
-DEFINE_IDR(ib_uverbs_mr_idr);
-DEFINE_IDR(ib_uverbs_mw_idr);
-DEFINE_IDR(ib_uverbs_ah_idr);
-DEFINE_IDR(ib_uverbs_cq_idr);
-DEFINE_IDR(ib_uverbs_qp_idr);
-DEFINE_IDR(ib_uverbs_srq_idr);
-DEFINE_IDR(ib_uverbs_xrcd_idr);
-DEFINE_IDR(ib_uverbs_rule_idr);
-DEFINE_IDR(ib_uverbs_wq_idr);
-DEFINE_IDR(ib_uverbs_rwq_ind_tbl_idr);
-
 static DEFINE_SPINLOCK(map_lock);
 static DECLARE_BITMAP(dev_map, IB_UVERBS_MAX_DEVICES);
 
@@ -235,7 +222,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 	list_for_each_entry_safe(uobj, tmp, &context->ah_list, list) {
 		struct ib_ah *ah = uobj->object;
 
-		idr_remove_uobj(&ib_uverbs_ah_idr, uobj);
+		idr_remove_uobj(uobj);
 		ib_destroy_ah(ah);
 		kfree(uobj);
 	}
@@ -244,7 +231,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 	list_for_each_entry_safe(uobj, tmp, &context->mw_list, list) {
 		struct ib_mw *mw = uobj->object;
 
-		idr_remove_uobj(&ib_uverbs_mw_idr, uobj);
+		idr_remove_uobj(uobj);
 		uverbs_dealloc_mw(mw);
 		kfree(uobj);
 	}
@@ -252,7 +239,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 	list_for_each_entry_safe(uobj, tmp, &context->rule_list, list) {
 		struct ib_flow *flow_id = uobj->object;
 
-		idr_remove_uobj(&ib_uverbs_rule_idr, uobj);
+		idr_remove_uobj(uobj);
 		ib_destroy_flow(flow_id);
 		kfree(uobj);
 	}
@@ -262,7 +249,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		struct ib_uqp_object *uqp =
 			container_of(uobj, struct ib_uqp_object, uevent.uobject);
 
-		idr_remove_uobj(&ib_uverbs_qp_idr, uobj);
+		idr_remove_uobj(uobj);
 		if (qp == qp->real_qp)
 			ib_uverbs_detach_umcast(qp, uqp);
 		ib_destroy_qp(qp);
@@ -274,7 +261,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		struct ib_rwq_ind_table *rwq_ind_tbl = uobj->object;
 		struct ib_wq **ind_tbl = rwq_ind_tbl->ind_tbl;
 
-		idr_remove_uobj(&ib_uverbs_rwq_ind_tbl_idr, uobj);
+		idr_remove_uobj(uobj);
 		ib_destroy_rwq_ind_table(rwq_ind_tbl);
 		kfree(ind_tbl);
 		kfree(uobj);
@@ -285,7 +272,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		struct ib_uwq_object *uwq =
 			container_of(uobj, struct ib_uwq_object, uevent.uobject);
 
-		idr_remove_uobj(&ib_uverbs_wq_idr, uobj);
+		idr_remove_uobj(uobj);
 		ib_destroy_wq(wq);
 		ib_uverbs_release_uevent(file, &uwq->uevent);
 		kfree(uwq);
@@ -296,7 +283,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		struct ib_uevent_object *uevent =
 			container_of(uobj, struct ib_uevent_object, uobject);
 
-		idr_remove_uobj(&ib_uverbs_srq_idr, uobj);
+		idr_remove_uobj(uobj);
 		ib_destroy_srq(srq);
 		ib_uverbs_release_uevent(file, uevent);
 		kfree(uevent);
@@ -308,7 +295,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		struct ib_ucq_object *ucq =
 			container_of(uobj, struct ib_ucq_object, uobject);
 
-		idr_remove_uobj(&ib_uverbs_cq_idr, uobj);
+		idr_remove_uobj(uobj);
 		ib_destroy_cq(cq);
 		ib_uverbs_release_ucq(file, ev_file, ucq);
 		kfree(ucq);
@@ -317,7 +304,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 	list_for_each_entry_safe(uobj, tmp, &context->mr_list, list) {
 		struct ib_mr *mr = uobj->object;
 
-		idr_remove_uobj(&ib_uverbs_mr_idr, uobj);
+		idr_remove_uobj(uobj);
 		ib_dereg_mr(mr);
 		kfree(uobj);
 	}
@@ -328,7 +315,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		struct ib_uxrcd_object *uxrcd =
 			container_of(uobj, struct ib_uxrcd_object, uobject);
 
-		idr_remove_uobj(&ib_uverbs_xrcd_idr, uobj);
+		idr_remove_uobj(uobj);
 		ib_uverbs_dealloc_xrcd(file->device, xrcd);
 		kfree(uxrcd);
 	}
@@ -337,7 +324,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 	list_for_each_entry_safe(uobj, tmp, &context->pd_list, list) {
 		struct ib_pd *pd = uobj->object;
 
-		idr_remove_uobj(&ib_uverbs_pd_idr, uobj);
+		idr_remove_uobj(uobj);
 		ib_dealloc_pd(pd);
 		kfree(uobj);
 	}
@@ -966,6 +953,8 @@ static int ib_uverbs_open(struct inode *inode, struct file *filp)
 	}
 
 	file->device	 = dev;
+	spin_lock_init(&file->idr_lock);
+	idr_init(&file->idr);
 	file->ucontext	 = NULL;
 	file->async_file = NULL;
 	kref_init(&file->ref);
@@ -1003,6 +992,7 @@ static int ib_uverbs_close(struct inode *inode, struct file *filp)
 		file->ucontext = NULL;
 	}
 	mutex_unlock(&file->cleanup_mutex);
+	idr_destroy(&file->idr);
 
 	mutex_lock(&file->device->lists_mutex);
 	if (!file->is_closed) {
@@ -1376,13 +1366,6 @@ static void __exit ib_uverbs_cleanup(void)
 	unregister_chrdev_region(IB_UVERBS_BASE_DEV, IB_UVERBS_MAX_DEVICES);
 	if (overflow_maj)
 		unregister_chrdev_region(overflow_maj, IB_UVERBS_MAX_DEVICES);
-	idr_destroy(&ib_uverbs_pd_idr);
-	idr_destroy(&ib_uverbs_mr_idr);
-	idr_destroy(&ib_uverbs_mw_idr);
-	idr_destroy(&ib_uverbs_ah_idr);
-	idr_destroy(&ib_uverbs_cq_idr);
-	idr_destroy(&ib_uverbs_qp_idr);
-	idr_destroy(&ib_uverbs_srq_idr);
 }
 
 module_init(ib_uverbs_init);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 8c61532..ccacc7e 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1347,6 +1347,7 @@ struct ib_fmr_attr {
 
 struct ib_ucontext {
 	struct ib_device       *device;
+	struct ib_uverbs_file  *ufile;
 	struct list_head	pd_list;
 	struct list_head	mr_list;
 	struct list_head	mw_list;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
