From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC ABI V3 2/7] RDMA/core: Refactor IDR to be per-device
Date: Tue,  9 Aug 2016 19:39:30 +0300
Message-ID: <1470760775-6813-3-git-send-email-matanb@mellanox.com>
References: <1470760775-6813-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1470760775-6813-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The current code creates an IDR per type. Since types are currently
common for all vendors and known in advance, this was good enough.
However, the proposed ioctl based infrastructure allows each vendor
to declare only some of the common types and declare its own specific
types.

Thus, we decided to implement IDR to be per device and refactor it to
use a new file.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/device.c      |  14 ++++
 drivers/infiniband/core/uverbs.h      |  14 +---
 drivers/infiniband/core/uverbs_cmd.c  | 149 ++++++++++++++++------------------
 drivers/infiniband/core/uverbs_main.c |  36 ++------
 include/rdma/ib_verbs.h               |   4 +
 5 files changed, 100 insertions(+), 117 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 5516fb0..b0135c2 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -168,11 +168,23 @@ static int alloc_name(char *name)
 	return 0;
 }
 
+static void ib_device_allocate_idrs(struct ib_device *device)
+{
+	spin_lock_init(&device->idr_lock);
+	idr_init(&device->idr);
+}
+
+static void ib_device_destroy_idrs(struct ib_device *device)
+{
+	idr_destroy(&device->idr);
+}
+
 static void ib_device_release(struct device *device)
 {
 	struct ib_device *dev = container_of(device, struct ib_device, dev);
 
 	ib_cache_release_one(dev);
+	ib_device_destroy_idrs(dev);
 	kfree(dev->port_immutable);
 	kfree(dev);
 }
@@ -219,6 +231,8 @@ struct ib_device *ib_alloc_device(size_t size)
 	if (!device)
 		return NULL;
 
+	ib_device_allocate_idrs(device);
+
 	device->dev.class = &ib_class;
 	device_initialize(&device->dev);
 
diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 612ccfd..60d7c3d 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -38,7 +38,6 @@
 #define UVERBS_H
 
 #include <linux/kref.h>
-#include <linux/idr.h>
 #include <linux/mutex.h>
 #include <linux/completion.h>
 #include <linux/cdev.h>
@@ -171,18 +170,7 @@ struct ib_ucq_object {
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
-
-void idr_remove_uobj(struct idr *idp, struct ib_uobject *uobj);
+void idr_remove_uobj(struct ib_uobject *uobj);
 
 struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
 					struct ib_device *ib_dev,
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 1a8babb..6af2c29 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -118,37 +118,36 @@ static void put_uobj_write(struct ib_uobject *uobj)
 	put_uobj(uobj);
 }
 
-static int idr_add_uobj(struct idr *idr, struct ib_uobject *uobj)
+int idr_add_uobj(struct ib_uobject *uobj)
 {
 	int ret;
 
 	idr_preload(GFP_KERNEL);
-	spin_lock(&ib_uverbs_idr_lock);
+	spin_lock(&uobj->context->device->idr_lock);
 
-	ret = idr_alloc(idr, uobj, 0, 0, GFP_NOWAIT);
+	ret = idr_alloc(&uobj->context->device->idr, uobj, 0, 0, GFP_NOWAIT);
 	if (ret >= 0)
 		uobj->id = ret;
 
-	spin_unlock(&ib_uverbs_idr_lock);
+	spin_unlock(&uobj->context->device->idr_lock);
 	idr_preload_end();
 
 	return ret < 0 ? ret : 0;
 }
 
-void idr_remove_uobj(struct idr *idr, struct ib_uobject *uobj)
+void idr_remove_uobj(struct ib_uobject *uobj)
 {
-	spin_lock(&ib_uverbs_idr_lock);
-	idr_remove(idr, uobj->id);
-	spin_unlock(&ib_uverbs_idr_lock);
+	spin_lock(&uobj->context->device->idr_lock);
+	idr_remove(&uobj->context->device->idr, uobj->id);
+	spin_unlock(&uobj->context->device->idr_lock);
 }
 
-static struct ib_uobject *__idr_get_uobj(struct idr *idr, int id,
-					 struct ib_ucontext *context)
+static struct ib_uobject *__idr_get_uobj(int id, struct ib_ucontext *context)
 {
 	struct ib_uobject *uobj;
 
 	rcu_read_lock();
-	uobj = idr_find(idr, id);
+	uobj = idr_find(&context->device->idr, id);
 	if (uobj) {
 		if (uobj->context == context)
 			kref_get(&uobj->ref);
@@ -160,12 +159,12 @@ static struct ib_uobject *__idr_get_uobj(struct idr *idr, int id,
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
 
@@ -181,12 +180,11 @@ static struct ib_uobject *idr_read_uobj(struct idr *idr, int id,
 	return uobj;
 }
 
-static struct ib_uobject *idr_write_uobj(struct idr *idr, int id,
-					 struct ib_ucontext *context)
+struct ib_uobject *idr_write_uobj(int id, struct ib_ucontext *context)
 {
 	struct ib_uobject *uobj;
 
-	uobj = __idr_get_uobj(idr, id, context);
+	uobj = __idr_get_uobj(id, context);
 	if (!uobj)
 		return NULL;
 
@@ -199,18 +197,18 @@ static struct ib_uobject *idr_write_uobj(struct idr *idr, int id,
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
 
-static struct ib_pd *idr_read_pd(int pd_handle, struct ib_ucontext *context)
+struct ib_pd *idr_read_pd(int pd_handle, struct ib_ucontext *context)
 {
-	return idr_read_obj(&ib_uverbs_pd_idr, pd_handle, context, 0);
+	return idr_read_obj(pd_handle, context, 0);
 }
 
 static void put_pd_read(struct ib_pd *pd)
@@ -220,7 +218,7 @@ static void put_pd_read(struct ib_pd *pd)
 
 static struct ib_cq *idr_read_cq(int cq_handle, struct ib_ucontext *context, int nested)
 {
-	return idr_read_obj(&ib_uverbs_cq_idr, cq_handle, context, nested);
+	return idr_read_obj(cq_handle, context, nested);
 }
 
 static void put_cq_read(struct ib_cq *cq)
@@ -228,26 +226,26 @@ static void put_cq_read(struct ib_cq *cq)
 	put_uobj_read(cq->uobject);
 }
 
-static struct ib_ah *idr_read_ah(int ah_handle, struct ib_ucontext *context)
+static void put_ah_read(struct ib_ah *ah)
 {
-	return idr_read_obj(&ib_uverbs_ah_idr, ah_handle, context, 0);
+	put_uobj_read(ah->uobject);
 }
 
-static void put_ah_read(struct ib_ah *ah)
+struct ib_ah *idr_read_ah(int ah_handle, struct ib_ucontext *context)
 {
-	put_uobj_read(ah->uobject);
+	return idr_read_obj(ah_handle, context, 0);
 }
 
-static struct ib_qp *idr_read_qp(int qp_handle, struct ib_ucontext *context)
+struct ib_qp *idr_read_qp(int qp_handle, struct ib_ucontext *context)
 {
-	return idr_read_obj(&ib_uverbs_qp_idr, qp_handle, context, 0);
+	return idr_read_obj(qp_handle, context, 0);
 }
 
-static struct ib_qp *idr_write_qp(int qp_handle, struct ib_ucontext *context)
+struct ib_qp *idr_write_qp(int qp_handle, struct ib_ucontext *context)
 {
 	struct ib_uobject *uobj;
 
-	uobj = idr_write_uobj(&ib_uverbs_qp_idr, qp_handle, context);
+	uobj = idr_write_uobj(qp_handle, context);
 	return uobj ? uobj->object : NULL;
 }
 
@@ -261,9 +259,9 @@ static void put_qp_write(struct ib_qp *qp)
 	put_uobj_write(qp->uobject);
 }
 
-static struct ib_srq *idr_read_srq(int srq_handle, struct ib_ucontext *context)
+struct ib_srq *idr_read_srq(int srq_handle, struct ib_ucontext *context)
 {
-	return idr_read_obj(&ib_uverbs_srq_idr, srq_handle, context, 0);
+	return idr_read_obj(srq_handle, context, 0);
 }
 
 static void put_srq_read(struct ib_srq *srq)
@@ -271,10 +269,10 @@ static void put_srq_read(struct ib_srq *srq)
 	put_uobj_read(srq->uobject);
 }
 
-static struct ib_xrcd *idr_read_xrcd(int xrcd_handle, struct ib_ucontext *context,
-				     struct ib_uobject **uobj)
+struct ib_xrcd *idr_read_xrcd(int xrcd_handle, struct ib_ucontext *context,
+			      struct ib_uobject **uobj)
 {
-	*uobj = idr_read_uobj(&ib_uverbs_xrcd_idr, xrcd_handle, context, 0);
+	*uobj = idr_read_uobj(xrcd_handle, context, 0);
 	return *uobj ? (*uobj)->object : NULL;
 }
 
@@ -282,7 +280,6 @@ static void put_xrcd_read(struct ib_uobject *uobj)
 {
 	put_uobj_read(uobj);
 }
-
 ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 			      struct ib_device *ib_dev,
 			      const char __user *buf,
@@ -550,7 +547,7 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 	atomic_set(&pd->usecnt, 0);
 
 	uobj->object = pd;
-	ret = idr_add_uobj(&ib_uverbs_pd_idr, uobj);
+	ret = idr_add_uobj(uobj);
 	if (ret)
 		goto err_idr;
 
@@ -574,7 +571,7 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 	return in_len;
 
 err_copy:
-	idr_remove_uobj(&ib_uverbs_pd_idr, uobj);
+	idr_remove_uobj(uobj);
 
 err_idr:
 	ib_dealloc_pd(pd);
@@ -597,7 +594,7 @@ ssize_t ib_uverbs_dealloc_pd(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(&ib_uverbs_pd_idr, cmd.pd_handle, file->ucontext);
+	uobj = idr_write_uobj(cmd.pd_handle, file->ucontext);
 	if (!uobj)
 		return -EINVAL;
 	pd = uobj->object;
@@ -615,7 +612,7 @@ ssize_t ib_uverbs_dealloc_pd(struct ib_uverbs_file *file,
 	uobj->live = 0;
 	put_uobj_write(uobj);
 
-	idr_remove_uobj(&ib_uverbs_pd_idr, uobj);
+	idr_remove_uobj(uobj);
 
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
@@ -791,7 +788,7 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 
 	atomic_set(&obj->refcnt, 0);
 	obj->uobject.object = xrcd;
-	ret = idr_add_uobj(&ib_uverbs_xrcd_idr, &obj->uobject);
+	ret = idr_add_uobj(&obj->uobject);
 	if (ret)
 		goto err_idr;
 
@@ -835,7 +832,7 @@ err_copy:
 	}
 
 err_insert_xrcd:
-	idr_remove_uobj(&ib_uverbs_xrcd_idr, &obj->uobject);
+	idr_remove_uobj(&obj->uobject);
 
 err_idr:
 	ib_dealloc_xrcd(xrcd);
@@ -869,7 +866,7 @@ ssize_t ib_uverbs_close_xrcd(struct ib_uverbs_file *file,
 		return -EFAULT;
 
 	mutex_lock(&file->device->xrcd_tree_mutex);
-	uobj = idr_write_uobj(&ib_uverbs_xrcd_idr, cmd.xrcd_handle, file->ucontext);
+	uobj = idr_write_uobj(cmd.xrcd_handle, file->ucontext);
 	if (!uobj) {
 		ret = -EINVAL;
 		goto out;
@@ -902,7 +899,7 @@ ssize_t ib_uverbs_close_xrcd(struct ib_uverbs_file *file,
 	if (inode && !live)
 		xrcd_table_delete(file->device, inode);
 
-	idr_remove_uobj(&ib_uverbs_xrcd_idr, uobj);
+	idr_remove_uobj(uobj);
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
 	mutex_unlock(&file->mutex);
@@ -995,7 +992,7 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 	atomic_inc(&pd->usecnt);
 
 	uobj->object = mr;
-	ret = idr_add_uobj(&ib_uverbs_mr_idr, uobj);
+	ret = idr_add_uobj(uobj);
 	if (ret)
 		goto err_unreg;
 
@@ -1023,7 +1020,7 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 	return in_len;
 
 err_copy:
-	idr_remove_uobj(&ib_uverbs_mr_idr, uobj);
+	idr_remove_uobj(uobj);
 
 err_unreg:
 	ib_dereg_mr(mr);
@@ -1068,8 +1065,7 @@ ssize_t ib_uverbs_rereg_mr(struct ib_uverbs_file *file,
 	     (cmd.start & ~PAGE_MASK) != (cmd.hca_va & ~PAGE_MASK)))
 			return -EINVAL;
 
-	uobj = idr_write_uobj(&ib_uverbs_mr_idr, cmd.mr_handle,
-			      file->ucontext);
+	uobj = idr_write_uobj(cmd.mr_handle, file->ucontext);
 
 	if (!uobj)
 		return -EINVAL;
@@ -1138,7 +1134,7 @@ ssize_t ib_uverbs_dereg_mr(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(&ib_uverbs_mr_idr, cmd.mr_handle, file->ucontext);
+	uobj = idr_write_uobj(cmd.mr_handle, file->ucontext);
 	if (!uobj)
 		return -EINVAL;
 
@@ -1153,7 +1149,7 @@ ssize_t ib_uverbs_dereg_mr(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
-	idr_remove_uobj(&ib_uverbs_mr_idr, uobj);
+	idr_remove_uobj(uobj);
 
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
@@ -1213,7 +1209,7 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 	atomic_inc(&pd->usecnt);
 
 	uobj->object = mw;
-	ret = idr_add_uobj(&ib_uverbs_mw_idr, uobj);
+	ret = idr_add_uobj(uobj);
 	if (ret)
 		goto err_unalloc;
 
@@ -1240,7 +1236,7 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 	return in_len;
 
 err_copy:
-	idr_remove_uobj(&ib_uverbs_mw_idr, uobj);
+	idr_remove_uobj(uobj);
 
 err_unalloc:
 	uverbs_dealloc_mw(mw);
@@ -1266,7 +1262,7 @@ ssize_t ib_uverbs_dealloc_mw(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof(cmd)))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(&ib_uverbs_mw_idr, cmd.mw_handle, file->ucontext);
+	uobj = idr_write_uobj(cmd.mw_handle, file->ucontext);
 	if (!uobj)
 		return -EINVAL;
 
@@ -1281,7 +1277,7 @@ ssize_t ib_uverbs_dealloc_mw(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
-	idr_remove_uobj(&ib_uverbs_mw_idr, uobj);
+	idr_remove_uobj(uobj);
 
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
@@ -1395,7 +1391,7 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 	atomic_set(&cq->usecnt, 0);
 
 	obj->uobject.object = cq;
-	ret = idr_add_uobj(&ib_uverbs_cq_idr, &obj->uobject);
+	ret = idr_add_uobj(&obj->uobject);
 	if (ret)
 		goto err_free;
 
@@ -1421,7 +1417,7 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 	return obj;
 
 err_cb:
-	idr_remove_uobj(&ib_uverbs_cq_idr, &obj->uobject);
+	idr_remove_uobj(&obj->uobject);
 
 err_free:
 	ib_destroy_cq(cq);
@@ -1691,7 +1687,7 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(&ib_uverbs_cq_idr, cmd.cq_handle, file->ucontext);
+	uobj = idr_write_uobj(cmd.cq_handle, file->ucontext);
 	if (!uobj)
 		return -EINVAL;
 	cq      = uobj->object;
@@ -1707,7 +1703,7 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
-	idr_remove_uobj(&ib_uverbs_cq_idr, uobj);
+	idr_remove_uobj(uobj);
 
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
@@ -1878,7 +1874,7 @@ static int create_qp(struct ib_uverbs_file *file,
 	qp->uobject = &obj->uevent.uobject;
 
 	obj->uevent.uobject.object = qp;
-	ret = idr_add_uobj(&ib_uverbs_qp_idr, &obj->uevent.uobject);
+	ret = idr_add_uobj(&obj->uevent.uobject);
 	if (ret)
 		goto err_destroy;
 
@@ -1924,7 +1920,7 @@ static int create_qp(struct ib_uverbs_file *file,
 
 	return 0;
 err_cb:
-	idr_remove_uobj(&ib_uverbs_qp_idr, &obj->uevent.uobject);
+	idr_remove_uobj(&obj->uevent.uobject);
 
 err_destroy:
 	ib_destroy_qp(qp);
@@ -2108,7 +2104,7 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
 	qp->uobject = &obj->uevent.uobject;
 
 	obj->uevent.uobject.object = qp;
-	ret = idr_add_uobj(&ib_uverbs_qp_idr, &obj->uevent.uobject);
+	ret = idr_add_uobj(&obj->uevent.uobject);
 	if (ret)
 		goto err_destroy;
 
@@ -2137,7 +2133,7 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
 	return in_len;
 
 err_remove:
-	idr_remove_uobj(&ib_uverbs_qp_idr, &obj->uevent.uobject);
+	idr_remove_uobj(&obj->uevent.uobject);
 
 err_destroy:
 	ib_destroy_qp(qp);
@@ -2377,7 +2373,7 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 
 	memset(&resp, 0, sizeof resp);
 
-	uobj = idr_write_uobj(&ib_uverbs_qp_idr, cmd.qp_handle, file->ucontext);
+	uobj = idr_write_uobj(cmd.qp_handle, file->ucontext);
 	if (!uobj)
 		return -EINVAL;
 	qp  = uobj->object;
@@ -2400,7 +2396,7 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 	if (obj->uxrcd)
 		atomic_dec(&obj->uxrcd->refcnt);
 
-	idr_remove_uobj(&ib_uverbs_qp_idr, uobj);
+	idr_remove_uobj(uobj);
 
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
@@ -2852,7 +2848,7 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	ah->uobject  = uobj;
 	uobj->object = ah;
 
-	ret = idr_add_uobj(&ib_uverbs_ah_idr, uobj);
+	ret = idr_add_uobj(uobj);
 	if (ret)
 		goto err_destroy;
 
@@ -2877,7 +2873,7 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	return in_len;
 
 err_copy:
-	idr_remove_uobj(&ib_uverbs_ah_idr, uobj);
+	idr_remove_uobj(uobj);
 
 err_destroy:
 	ib_destroy_ah(ah);
@@ -2902,7 +2898,7 @@ ssize_t ib_uverbs_destroy_ah(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(&ib_uverbs_ah_idr, cmd.ah_handle, file->ucontext);
+	uobj = idr_write_uobj(cmd.ah_handle, file->ucontext);
 	if (!uobj)
 		return -EINVAL;
 	ah = uobj->object;
@@ -2916,7 +2912,7 @@ ssize_t ib_uverbs_destroy_ah(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
-	idr_remove_uobj(&ib_uverbs_ah_idr, uobj);
+	idr_remove_uobj(uobj);
 
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
@@ -3184,7 +3180,7 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 	flow_id->uobject = uobj;
 	uobj->object = flow_id;
 
-	err = idr_add_uobj(&ib_uverbs_rule_idr, uobj);
+	err = idr_add_uobj(uobj);
 	if (err)
 		goto destroy_flow;
 
@@ -3209,7 +3205,7 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 		kfree(kern_flow_attr);
 	return 0;
 err_copy:
-	idr_remove_uobj(&ib_uverbs_rule_idr, uobj);
+	idr_remove_uobj(uobj);
 destroy_flow:
 	ib_destroy_flow(flow_id);
 err_free:
@@ -3244,8 +3240,7 @@ int ib_uverbs_ex_destroy_flow(struct ib_uverbs_file *file,
 	if (cmd.comp_mask)
 		return -EINVAL;
 
-	uobj = idr_write_uobj(&ib_uverbs_rule_idr, cmd.flow_handle,
-			      file->ucontext);
+	uobj = idr_write_uobj(cmd.flow_handle, file->ucontext);
 	if (!uobj)
 		return -EINVAL;
 	flow_id = uobj->object;
@@ -3256,7 +3251,7 @@ int ib_uverbs_ex_destroy_flow(struct ib_uverbs_file *file,
 
 	put_uobj_write(uobj);
 
-	idr_remove_uobj(&ib_uverbs_rule_idr, uobj);
+	idr_remove_uobj(uobj);
 
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
@@ -3344,7 +3339,7 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	atomic_set(&srq->usecnt, 0);
 
 	obj->uevent.uobject.object = srq;
-	ret = idr_add_uobj(&ib_uverbs_srq_idr, &obj->uevent.uobject);
+	ret = idr_add_uobj(&obj->uevent.uobject);
 	if (ret)
 		goto err_destroy;
 
@@ -3378,7 +3373,7 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	return 0;
 
 err_copy:
-	idr_remove_uobj(&ib_uverbs_srq_idr, &obj->uevent.uobject);
+	idr_remove_uobj(&obj->uevent.uobject);
 
 err_destroy:
 	ib_destroy_srq(srq);
@@ -3554,7 +3549,7 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(&ib_uverbs_srq_idr, cmd.srq_handle, file->ucontext);
+	uobj = idr_write_uobj(cmd.srq_handle, file->ucontext);
 	if (!uobj)
 		return -EINVAL;
 	srq = uobj->object;
@@ -3575,7 +3570,7 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 		atomic_dec(&us->uxrcd->refcnt);
 	}
 
-	idr_remove_uobj(&ib_uverbs_srq_idr, uobj);
+	idr_remove_uobj(uobj);
 
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 31f422a..333ed70 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -66,17 +66,6 @@ enum {
 
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
-
 static DEFINE_SPINLOCK(map_lock);
 static DECLARE_BITMAP(dev_map, IB_UVERBS_MAX_DEVICES);
 
@@ -227,7 +216,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 	list_for_each_entry_safe(uobj, tmp, &context->ah_list, list) {
 		struct ib_ah *ah = uobj->object;
 
-		idr_remove_uobj(&ib_uverbs_ah_idr, uobj);
+		idr_remove_uobj(uobj);
 		ib_destroy_ah(ah);
 		kfree(uobj);
 	}
@@ -236,7 +225,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 	list_for_each_entry_safe(uobj, tmp, &context->mw_list, list) {
 		struct ib_mw *mw = uobj->object;
 
-		idr_remove_uobj(&ib_uverbs_mw_idr, uobj);
+		idr_remove_uobj(uobj);
 		uverbs_dealloc_mw(mw);
 		kfree(uobj);
 	}
@@ -244,7 +233,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 	list_for_each_entry_safe(uobj, tmp, &context->rule_list, list) {
 		struct ib_flow *flow_id = uobj->object;
 
-		idr_remove_uobj(&ib_uverbs_rule_idr, uobj);
+		idr_remove_uobj(uobj);
 		ib_destroy_flow(flow_id);
 		kfree(uobj);
 	}
@@ -254,7 +243,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		struct ib_uqp_object *uqp =
 			container_of(uobj, struct ib_uqp_object, uevent.uobject);
 
-		idr_remove_uobj(&ib_uverbs_qp_idr, uobj);
+		idr_remove_uobj(uobj);
 		if (qp != qp->real_qp) {
 			ib_close_qp(qp);
 		} else {
@@ -270,7 +259,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		struct ib_uevent_object *uevent =
 			container_of(uobj, struct ib_uevent_object, uobject);
 
-		idr_remove_uobj(&ib_uverbs_srq_idr, uobj);
+		idr_remove_uobj(uobj);
 		ib_destroy_srq(srq);
 		ib_uverbs_release_uevent(file, uevent);
 		kfree(uevent);
@@ -282,7 +271,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		struct ib_ucq_object *ucq =
 			container_of(uobj, struct ib_ucq_object, uobject);
 
-		idr_remove_uobj(&ib_uverbs_cq_idr, uobj);
+		idr_remove_uobj(uobj);
 		ib_destroy_cq(cq);
 		ib_uverbs_release_ucq(file, ev_file, ucq);
 		kfree(ucq);
@@ -291,7 +280,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 	list_for_each_entry_safe(uobj, tmp, &context->mr_list, list) {
 		struct ib_mr *mr = uobj->object;
 
-		idr_remove_uobj(&ib_uverbs_mr_idr, uobj);
+		idr_remove_uobj(uobj);
 		ib_dereg_mr(mr);
 		kfree(uobj);
 	}
@@ -302,7 +291,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		struct ib_uxrcd_object *uxrcd =
 			container_of(uobj, struct ib_uxrcd_object, uobject);
 
-		idr_remove_uobj(&ib_uverbs_xrcd_idr, uobj);
+		idr_remove_uobj(uobj);
 		ib_uverbs_dealloc_xrcd(file->device, xrcd);
 		kfree(uxrcd);
 	}
@@ -311,7 +300,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 	list_for_each_entry_safe(uobj, tmp, &context->pd_list, list) {
 		struct ib_pd *pd = uobj->object;
 
-		idr_remove_uobj(&ib_uverbs_pd_idr, uobj);
+		idr_remove_uobj(uobj);
 		ib_dealloc_pd(pd);
 		kfree(uobj);
 	}
@@ -1326,13 +1315,6 @@ static void __exit ib_uverbs_cleanup(void)
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
index 432bed5..14bfe3b 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1706,6 +1706,10 @@ struct ib_device {
 
 	struct iw_cm_verbs	     *iwcm;
 
+	struct idr		idr;
+	/* Global lock in use to safely release device IDR */
+	spinlock_t		idr_lock;
+
 	/**
 	 * alloc_hw_stats - Allocate a struct rdma_hw_stats and fill in the
 	 *   driver initialized data.  The struct is kfree()'ed by the sysfs
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
