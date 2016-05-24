From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC ABI 7/8] IB/core: Refactor idr to a shared file
Date: Tue, 24 May 2016 17:35:25 +0300
Message-ID: <1464100526-31730-8-git-send-email-leonro@mellanox.com>
References: <1464100526-31730-1-git-send-email-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464100526-31730-1-git-send-email-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Currently, there are two code paths that could get user-space object
handles and use them. In order to share code and avoid duplications,
we export the idr management to an external file.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/Makefile            |   2 +-
 drivers/infiniband/core/uverbs.h            |  44 ++-
 drivers/infiniband/core/uverbs_cmd.c        | 558 ++++++++--------------------
 drivers/infiniband/core/uverbs_cmd_common.c | 280 ++++++++++++++
 drivers/infiniband/core/uverbs_main.c       |  18 +-
 5 files changed, 491 insertions(+), 411 deletions(-)
 create mode 100644 drivers/infiniband/core/uverbs_cmd_common.c

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index 3d8a423..2d976e3f 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -35,4 +35,4 @@ ib_umad-y :=			user_mad.o
 ib_ucm-y :=			ucm.o
 
 ib_uverbs-y :=			uverbs_main.o uverbs_cmd.o uverbs_marshall.o \
-				uverbs_nl.o
+				uverbs_nl.o uverbs_cmd_common.o
diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index c8d8700..1f121dc 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -193,8 +193,6 @@ extern struct idr ib_uverbs_srq_idr;
 extern struct idr ib_uverbs_xrcd_idr;
 extern struct idr ib_uverbs_rule_idr;
 
-void idr_remove_uobj(struct idr *idp, struct ib_uobject *uobj);
-
 struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
 					struct ib_device *ib_dev,
 					int is_async);
@@ -233,6 +231,48 @@ struct ib_uverbs_flow_spec {
 	};
 };
 
+struct uverbs_lock_class {
+	struct lock_class_key	key;
+	char			name[16];
+};
+
+extern struct uverbs_lock_class pd_lock_class;
+extern struct uverbs_lock_class mr_lock_class;
+extern struct uverbs_lock_class mw_lock_class;
+extern struct uverbs_lock_class cq_lock_class;
+extern struct uverbs_lock_class qp_lock_class;
+extern struct uverbs_lock_class ah_lock_class;
+extern struct uverbs_lock_class srq_lock_class;
+extern struct uverbs_lock_class xrcd_lock_class;
+extern struct uverbs_lock_class rule_lock_class;
+
+void ib_init_uobj(struct ib_uobject *uobj, u64 user_handle,
+		  struct ib_ucontext *context, struct uverbs_lock_class *c);
+void ib_put_uobj(struct ib_uobject *uobj);
+void ib_put_uobj_read(struct ib_uobject *uobj);
+void ib_put_uobj_write(struct ib_uobject *uobj);
+int ib_idr_add_uobj(struct idr *idr, struct ib_uobject *uobj);
+void ib_idr_remove_uobj(struct idr *idr, struct ib_uobject *uobj);
+struct ib_uobject *ib_idr_read_uobj(struct idr *idr, int id,
+				    struct ib_ucontext *context, int nested);
+struct ib_uobject *ib_idr_write_uobj(struct idr *idr, int id,
+				     struct ib_ucontext *context);
+struct ib_pd *ib_idr_read_pd(int pd_handle, struct ib_ucontext *context);
+void ib_put_read_pd(struct ib_pd *pd);
+struct ib_cq *ib_idr_read_cq(int cq_handle, struct ib_ucontext *context, int nested);
+void ib_put_read_cq(struct ib_cq *cq);
+struct ib_ah *ib_idr_read_ah(int ah_handle, struct ib_ucontext *context);
+void ib_put_read_ah(struct ib_ah *ah);
+struct ib_qp *ib_idr_read_qp(int qp_handle, struct ib_ucontext *context);
+struct ib_qp *ib_idr_write_qp(int qp_handle, struct ib_ucontext *context);
+void ib_put_read_qp(struct ib_qp *qp);
+void ib_put_write_qp(struct ib_qp *qp);
+struct ib_srq *ib_idr_read_srq(int srq_handle, struct ib_ucontext *context);
+void ib_put_read_srq(struct ib_srq *srq);
+struct ib_xrcd *ib_idr_read_xrcd(int xrcd_handle, struct ib_ucontext *context,
+				 struct ib_uobject **uobj);
+void ib_put_xrcd_read(struct ib_uobject *uobj);
+
 #define IB_UVERBS_DECLARE_CMD(name)					\
 	ssize_t ib_uverbs_##name(struct ib_uverbs_file *file,		\
 				 struct ib_device *ib_dev,              \
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 03e39c2..c5a31b3 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -43,246 +43,6 @@
 #include "uverbs.h"
 #include "core_priv.h"
 
-struct uverbs_lock_class {
-	struct lock_class_key	key;
-	char			name[16];
-};
-
-static struct uverbs_lock_class pd_lock_class	= { .name = "PD-uobj" };
-static struct uverbs_lock_class mr_lock_class	= { .name = "MR-uobj" };
-static struct uverbs_lock_class mw_lock_class	= { .name = "MW-uobj" };
-static struct uverbs_lock_class cq_lock_class	= { .name = "CQ-uobj" };
-static struct uverbs_lock_class qp_lock_class	= { .name = "QP-uobj" };
-static struct uverbs_lock_class ah_lock_class	= { .name = "AH-uobj" };
-static struct uverbs_lock_class srq_lock_class	= { .name = "SRQ-uobj" };
-static struct uverbs_lock_class xrcd_lock_class = { .name = "XRCD-uobj" };
-static struct uverbs_lock_class rule_lock_class = { .name = "RULE-uobj" };
-
-/*
- * The ib_uobject locking scheme is as follows:
- *
- * - ib_uverbs_idr_lock protects the uverbs idrs themselves, so it
- *   needs to be held during all idr write operations.  When an object is
- *   looked up, a reference must be taken on the object's kref before
- *   dropping this lock.  For read operations, the rcu_read_lock()
- *   and rcu_write_lock() but similarly the kref reference is grabbed
- *   before the rcu_read_unlock().
- *
- * - Each object also has an rwsem.  This rwsem must be held for
- *   reading while an operation that uses the object is performed.
- *   For example, while registering an MR, the associated PD's
- *   uobject.mutex must be held for reading.  The rwsem must be held
- *   for writing while initializing or destroying an object.
- *
- * - In addition, each object has a "live" flag.  If this flag is not
- *   set, then lookups of the object will fail even if it is found in
- *   the idr.  This handles a reader that blocks and does not acquire
- *   the rwsem until after the object is destroyed.  The destroy
- *   operation will set the live flag to 0 and then drop the rwsem;
- *   this will allow the reader to acquire the rwsem, see that the
- *   live flag is 0, and then drop the rwsem and its reference to
- *   object.  The underlying storage will not be freed until the last
- *   reference to the object is dropped.
- */
-
-static void init_uobj(struct ib_uobject *uobj, u64 user_handle,
-		      struct ib_ucontext *context, struct uverbs_lock_class *c)
-{
-	uobj->user_handle = user_handle;
-	uobj->context     = context;
-	kref_init(&uobj->ref);
-	init_rwsem(&uobj->mutex);
-	lockdep_set_class_and_name(&uobj->mutex, &c->key, c->name);
-	uobj->live        = 0;
-}
-
-static void release_uobj(struct kref *kref)
-{
-	kfree_rcu(container_of(kref, struct ib_uobject, ref), rcu);
-}
-
-static void put_uobj(struct ib_uobject *uobj)
-{
-	kref_put(&uobj->ref, release_uobj);
-}
-
-static void put_uobj_read(struct ib_uobject *uobj)
-{
-	up_read(&uobj->mutex);
-	put_uobj(uobj);
-}
-
-static void put_uobj_write(struct ib_uobject *uobj)
-{
-	up_write(&uobj->mutex);
-	put_uobj(uobj);
-}
-
-static int idr_add_uobj(struct idr *idr, struct ib_uobject *uobj)
-{
-	int ret;
-
-	idr_preload(GFP_KERNEL);
-	spin_lock(&ib_uverbs_idr_lock);
-
-	ret = idr_alloc(idr, uobj, 0, 0, GFP_NOWAIT);
-	if (ret >= 0)
-		uobj->id = ret;
-
-	spin_unlock(&ib_uverbs_idr_lock);
-	idr_preload_end();
-
-	return ret < 0 ? ret : 0;
-}
-
-void idr_remove_uobj(struct idr *idr, struct ib_uobject *uobj)
-{
-	spin_lock(&ib_uverbs_idr_lock);
-	idr_remove(idr, uobj->id);
-	spin_unlock(&ib_uverbs_idr_lock);
-}
-
-static struct ib_uobject *__idr_get_uobj(struct idr *idr, int id,
-					 struct ib_ucontext *context)
-{
-	struct ib_uobject *uobj;
-
-	rcu_read_lock();
-	uobj = idr_find(idr, id);
-	if (uobj) {
-		if (uobj->context == context)
-			kref_get(&uobj->ref);
-		else
-			uobj = NULL;
-	}
-	rcu_read_unlock();
-
-	return uobj;
-}
-
-static struct ib_uobject *idr_read_uobj(struct idr *idr, int id,
-					struct ib_ucontext *context, int nested)
-{
-	struct ib_uobject *uobj;
-
-	uobj = __idr_get_uobj(idr, id, context);
-	if (!uobj)
-		return NULL;
-
-	if (nested)
-		down_read_nested(&uobj->mutex, SINGLE_DEPTH_NESTING);
-	else
-		down_read(&uobj->mutex);
-	if (!uobj->live) {
-		put_uobj_read(uobj);
-		return NULL;
-	}
-
-	return uobj;
-}
-
-static struct ib_uobject *idr_write_uobj(struct idr *idr, int id,
-					 struct ib_ucontext *context)
-{
-	struct ib_uobject *uobj;
-
-	uobj = __idr_get_uobj(idr, id, context);
-	if (!uobj)
-		return NULL;
-
-	down_write(&uobj->mutex);
-	if (!uobj->live) {
-		put_uobj_write(uobj);
-		return NULL;
-	}
-
-	return uobj;
-}
-
-static void *idr_read_obj(struct idr *idr, int id, struct ib_ucontext *context,
-			  int nested)
-{
-	struct ib_uobject *uobj;
-
-	uobj = idr_read_uobj(idr, id, context, nested);
-	return uobj ? uobj->object : NULL;
-}
-
-static struct ib_pd *idr_read_pd(int pd_handle, struct ib_ucontext *context)
-{
-	return idr_read_obj(&ib_uverbs_pd_idr, pd_handle, context, 0);
-}
-
-static void put_pd_read(struct ib_pd *pd)
-{
-	put_uobj_read(pd->uobject);
-}
-
-static struct ib_cq *idr_read_cq(int cq_handle, struct ib_ucontext *context, int nested)
-{
-	return idr_read_obj(&ib_uverbs_cq_idr, cq_handle, context, nested);
-}
-
-static void put_cq_read(struct ib_cq *cq)
-{
-	put_uobj_read(cq->uobject);
-}
-
-static struct ib_ah *idr_read_ah(int ah_handle, struct ib_ucontext *context)
-{
-	return idr_read_obj(&ib_uverbs_ah_idr, ah_handle, context, 0);
-}
-
-static void put_ah_read(struct ib_ah *ah)
-{
-	put_uobj_read(ah->uobject);
-}
-
-static struct ib_qp *idr_read_qp(int qp_handle, struct ib_ucontext *context)
-{
-	return idr_read_obj(&ib_uverbs_qp_idr, qp_handle, context, 0);
-}
-
-static struct ib_qp *idr_write_qp(int qp_handle, struct ib_ucontext *context)
-{
-	struct ib_uobject *uobj;
-
-	uobj = idr_write_uobj(&ib_uverbs_qp_idr, qp_handle, context);
-	return uobj ? uobj->object : NULL;
-}
-
-static void put_qp_read(struct ib_qp *qp)
-{
-	put_uobj_read(qp->uobject);
-}
-
-static void put_qp_write(struct ib_qp *qp)
-{
-	put_uobj_write(qp->uobject);
-}
-
-static struct ib_srq *idr_read_srq(int srq_handle, struct ib_ucontext *context)
-{
-	return idr_read_obj(&ib_uverbs_srq_idr, srq_handle, context, 0);
-}
-
-static void put_srq_read(struct ib_srq *srq)
-{
-	put_uobj_read(srq->uobject);
-}
-
-static struct ib_xrcd *idr_read_xrcd(int xrcd_handle, struct ib_ucontext *context,
-				     struct ib_uobject **uobj)
-{
-	*uobj = idr_read_uobj(&ib_uverbs_xrcd_idr, xrcd_handle, context, 0);
-	return *uobj ? (*uobj)->object : NULL;
-}
-
-static void put_xrcd_read(struct ib_uobject *uobj)
-{
-	put_uobj_read(uobj);
-}
-
 ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 			      struct ib_device *ib_dev,
 			      const char __user *buf,
@@ -535,7 +295,7 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 	if (!uobj)
 		return -ENOMEM;
 
-	init_uobj(uobj, 0, file->ucontext, &pd_lock_class);
+	ib_init_uobj(uobj, 0, file->ucontext, &pd_lock_class);
 	down_write(&uobj->mutex);
 
 	pd = ib_dev->alloc_pd(ib_dev, file->ucontext, &udata);
@@ -550,7 +310,7 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 	atomic_set(&pd->usecnt, 0);
 
 	uobj->object = pd;
-	ret = idr_add_uobj(&ib_uverbs_pd_idr, uobj);
+	ret = ib_idr_add_uobj(&ib_uverbs_pd_idr, uobj);
 	if (ret)
 		goto err_idr;
 
@@ -574,13 +334,13 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 	return in_len;
 
 err_copy:
-	idr_remove_uobj(&ib_uverbs_pd_idr, uobj);
+	ib_idr_remove_uobj(&ib_uverbs_pd_idr, uobj);
 
 err_idr:
 	ib_dealloc_pd(pd);
 
 err:
-	put_uobj_write(uobj);
+	ib_put_uobj_write(uobj);
 	return ret;
 }
 
@@ -597,7 +357,7 @@ ssize_t ib_uverbs_dealloc_pd(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(&ib_uverbs_pd_idr, cmd.pd_handle, file->ucontext);
+	uobj = ib_idr_write_uobj(&ib_uverbs_pd_idr, cmd.pd_handle, file->ucontext);
 	if (!uobj)
 		return -EINVAL;
 	pd = uobj->object;
@@ -613,20 +373,20 @@ ssize_t ib_uverbs_dealloc_pd(struct ib_uverbs_file *file,
 		goto err_put;
 
 	uobj->live = 0;
-	put_uobj_write(uobj);
+	ib_put_uobj_write(uobj);
 
-	idr_remove_uobj(&ib_uverbs_pd_idr, uobj);
+	ib_idr_remove_uobj(&ib_uverbs_pd_idr, uobj);
 
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
 	mutex_unlock(&file->mutex);
 
-	put_uobj(uobj);
+	ib_put_uobj(uobj);
 
 	return in_len;
 
 err_put:
-	put_uobj_write(uobj);
+	ib_put_uobj_write(uobj);
 	return ret;
 }
 
@@ -770,7 +530,7 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 		goto err_tree_mutex_unlock;
 	}
 
-	init_uobj(&obj->uobject, 0, file->ucontext, &xrcd_lock_class);
+	ib_init_uobj(&obj->uobject, 0, file->ucontext, &xrcd_lock_class);
 
 	down_write(&obj->uobject.mutex);
 
@@ -791,7 +551,7 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 
 	atomic_set(&obj->refcnt, 0);
 	obj->uobject.object = xrcd;
-	ret = idr_add_uobj(&ib_uverbs_xrcd_idr, &obj->uobject);
+	ret = ib_idr_add_uobj(&ib_uverbs_xrcd_idr, &obj->uobject);
 	if (ret)
 		goto err_idr;
 
@@ -835,13 +595,13 @@ err_copy:
 	}
 
 err_insert_xrcd:
-	idr_remove_uobj(&ib_uverbs_xrcd_idr, &obj->uobject);
+	ib_idr_remove_uobj(&ib_uverbs_xrcd_idr, &obj->uobject);
 
 err_idr:
 	ib_dealloc_xrcd(xrcd);
 
 err:
-	put_uobj_write(&obj->uobject);
+	ib_put_uobj_write(&obj->uobject);
 
 err_tree_mutex_unlock:
 	if (f.file)
@@ -869,7 +629,7 @@ ssize_t ib_uverbs_close_xrcd(struct ib_uverbs_file *file,
 		return -EFAULT;
 
 	mutex_lock(&file->device->xrcd_tree_mutex);
-	uobj = idr_write_uobj(&ib_uverbs_xrcd_idr, cmd.xrcd_handle, file->ucontext);
+	uobj = ib_idr_write_uobj(&ib_uverbs_xrcd_idr, cmd.xrcd_handle, file->ucontext);
 	if (!uobj) {
 		ret = -EINVAL;
 		goto out;
@@ -879,7 +639,7 @@ ssize_t ib_uverbs_close_xrcd(struct ib_uverbs_file *file,
 	inode = xrcd->inode;
 	obj   = container_of(uobj, struct ib_uxrcd_object, uobject);
 	if (atomic_read(&obj->refcnt)) {
-		put_uobj_write(uobj);
+		ib_put_uobj_write(uobj);
 		ret = -EBUSY;
 		goto out;
 	}
@@ -894,7 +654,7 @@ ssize_t ib_uverbs_close_xrcd(struct ib_uverbs_file *file,
 	if (inode && ret)
 		atomic_inc(&xrcd->usecnt);
 
-	put_uobj_write(uobj);
+	ib_put_uobj_write(uobj);
 
 	if (ret)
 		goto out;
@@ -902,12 +662,12 @@ ssize_t ib_uverbs_close_xrcd(struct ib_uverbs_file *file,
 	if (inode && !live)
 		xrcd_table_delete(file->device, inode);
 
-	idr_remove_uobj(&ib_uverbs_xrcd_idr, uobj);
+	ib_idr_remove_uobj(&ib_uverbs_xrcd_idr, uobj);
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
 	mutex_unlock(&file->mutex);
 
-	put_uobj(uobj);
+	ib_put_uobj(uobj);
 	ret = in_len;
 
 out:
@@ -964,10 +724,10 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 	if (!uobj)
 		return -ENOMEM;
 
-	init_uobj(uobj, 0, file->ucontext, &mr_lock_class);
+	ib_init_uobj(uobj, 0, file->ucontext, &mr_lock_class);
 	down_write(&uobj->mutex);
 
-	pd = idr_read_pd(cmd.pd_handle, file->ucontext);
+	pd = ib_idr_read_pd(cmd.pd_handle, file->ucontext);
 	if (!pd) {
 		ret = -EINVAL;
 		goto err_free;
@@ -995,7 +755,7 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 	atomic_inc(&pd->usecnt);
 
 	uobj->object = mr;
-	ret = idr_add_uobj(&ib_uverbs_mr_idr, uobj);
+	ret = ib_idr_add_uobj(&ib_uverbs_mr_idr, uobj);
 	if (ret)
 		goto err_unreg;
 
@@ -1010,7 +770,7 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 		goto err_copy;
 	}
 
-	put_pd_read(pd);
+	ib_put_read_pd(pd);
 
 	mutex_lock(&file->mutex);
 	list_add_tail(&uobj->list, &file->ucontext->mr_list);
@@ -1023,16 +783,16 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 	return in_len;
 
 err_copy:
-	idr_remove_uobj(&ib_uverbs_mr_idr, uobj);
+	ib_idr_remove_uobj(&ib_uverbs_mr_idr, uobj);
 
 err_unreg:
 	ib_dereg_mr(mr);
 
 err_put:
-	put_pd_read(pd);
+	ib_put_read_pd(pd);
 
 err_free:
-	put_uobj_write(uobj);
+	ib_put_uobj_write(uobj);
 	return ret;
 }
 
@@ -1068,8 +828,8 @@ ssize_t ib_uverbs_rereg_mr(struct ib_uverbs_file *file,
 	     (cmd.start & ~PAGE_MASK) != (cmd.hca_va & ~PAGE_MASK)))
 			return -EINVAL;
 
-	uobj = idr_write_uobj(&ib_uverbs_mr_idr, cmd.mr_handle,
-			      file->ucontext);
+	uobj = ib_idr_write_uobj(&ib_uverbs_mr_idr, cmd.mr_handle,
+				 file->ucontext);
 
 	if (!uobj)
 		return -EINVAL;
@@ -1079,14 +839,14 @@ ssize_t ib_uverbs_rereg_mr(struct ib_uverbs_file *file,
 	if (cmd.flags & IB_MR_REREG_ACCESS) {
 		ret = ib_check_mr_access(cmd.access_flags);
 		if (ret)
-			goto put_uobjs;
+			goto ib_put_uobjs;
 	}
 
 	if (cmd.flags & IB_MR_REREG_PD) {
-		pd = idr_read_pd(cmd.pd_handle, file->ucontext);
+		pd = ib_idr_read_pd(cmd.pd_handle, file->ucontext);
 		if (!pd) {
 			ret = -EINVAL;
-			goto put_uobjs;
+			goto ib_put_uobjs;
 		}
 	}
 
@@ -1101,7 +861,7 @@ ssize_t ib_uverbs_rereg_mr(struct ib_uverbs_file *file,
 			atomic_dec(&old_pd->usecnt);
 		}
 	} else {
-		goto put_uobj_pd;
+		goto ib_put_uobj_pd;
 	}
 
 	memset(&resp, 0, sizeof(resp));
@@ -1114,13 +874,13 @@ ssize_t ib_uverbs_rereg_mr(struct ib_uverbs_file *file,
 	else
 		ret = in_len;
 
-put_uobj_pd:
+ib_put_uobj_pd:
 	if (cmd.flags & IB_MR_REREG_PD)
-		put_pd_read(pd);
+		ib_put_read_pd(pd);
 
-put_uobjs:
+ib_put_uobjs:
 
-	put_uobj_write(mr->uobject);
+	ib_put_uobj_write(mr->uobject);
 
 	return ret;
 }
@@ -1138,7 +898,7 @@ ssize_t ib_uverbs_dereg_mr(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(&ib_uverbs_mr_idr, cmd.mr_handle, file->ucontext);
+	uobj = ib_idr_write_uobj(&ib_uverbs_mr_idr, cmd.mr_handle, file->ucontext);
 	if (!uobj)
 		return -EINVAL;
 
@@ -1148,18 +908,18 @@ ssize_t ib_uverbs_dereg_mr(struct ib_uverbs_file *file,
 	if (!ret)
 		uobj->live = 0;
 
-	put_uobj_write(uobj);
+	ib_put_uobj_write(uobj);
 
 	if (ret)
 		return ret;
 
-	idr_remove_uobj(&ib_uverbs_mr_idr, uobj);
+	ib_idr_remove_uobj(&ib_uverbs_mr_idr, uobj);
 
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
 	mutex_unlock(&file->mutex);
 
-	put_uobj(uobj);
+	ib_put_uobj(uobj);
 
 	return in_len;
 }
@@ -1187,10 +947,10 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 	if (!uobj)
 		return -ENOMEM;
 
-	init_uobj(uobj, 0, file->ucontext, &mw_lock_class);
+	ib_init_uobj(uobj, 0, file->ucontext, &mw_lock_class);
 	down_write(&uobj->mutex);
 
-	pd = idr_read_pd(cmd.pd_handle, file->ucontext);
+	pd = ib_idr_read_pd(cmd.pd_handle, file->ucontext);
 	if (!pd) {
 		ret = -EINVAL;
 		goto err_free;
@@ -1213,7 +973,7 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 	atomic_inc(&pd->usecnt);
 
 	uobj->object = mw;
-	ret = idr_add_uobj(&ib_uverbs_mw_idr, uobj);
+	ret = ib_idr_add_uobj(&ib_uverbs_mw_idr, uobj);
 	if (ret)
 		goto err_unalloc;
 
@@ -1227,7 +987,7 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 		goto err_copy;
 	}
 
-	put_pd_read(pd);
+	ib_put_read_pd(pd);
 
 	mutex_lock(&file->mutex);
 	list_add_tail(&uobj->list, &file->ucontext->mw_list);
@@ -1240,16 +1000,16 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 	return in_len;
 
 err_copy:
-	idr_remove_uobj(&ib_uverbs_mw_idr, uobj);
+	ib_idr_remove_uobj(&ib_uverbs_mw_idr, uobj);
 
 err_unalloc:
 	uverbs_dealloc_mw(mw);
 
 err_put:
-	put_pd_read(pd);
+	ib_put_read_pd(pd);
 
 err_free:
-	put_uobj_write(uobj);
+	ib_put_uobj_write(uobj);
 	return ret;
 }
 
@@ -1266,7 +1026,7 @@ ssize_t ib_uverbs_dealloc_mw(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof(cmd)))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(&ib_uverbs_mw_idr, cmd.mw_handle, file->ucontext);
+	uobj = ib_idr_write_uobj(&ib_uverbs_mw_idr, cmd.mw_handle, file->ucontext);
 	if (!uobj)
 		return -EINVAL;
 
@@ -1276,18 +1036,18 @@ ssize_t ib_uverbs_dealloc_mw(struct ib_uverbs_file *file,
 	if (!ret)
 		uobj->live = 0;
 
-	put_uobj_write(uobj);
+	ib_put_uobj_write(uobj);
 
 	if (ret)
 		return ret;
 
-	idr_remove_uobj(&ib_uverbs_mw_idr, uobj);
+	ib_idr_remove_uobj(&ib_uverbs_mw_idr, uobj);
 
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
 	mutex_unlock(&file->mutex);
 
-	put_uobj(uobj);
+	ib_put_uobj(uobj);
 
 	return in_len;
 }
@@ -1357,7 +1117,7 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 	if (!obj)
 		return ERR_PTR(-ENOMEM);
 
-	init_uobj(&obj->uobject, cmd->user_handle, file->ucontext, &cq_lock_class);
+	ib_init_uobj(&obj->uobject, cmd->user_handle, file->ucontext, &cq_lock_class);
 	down_write(&obj->uobject.mutex);
 
 	if (cmd->comp_channel >= 0) {
@@ -1395,7 +1155,7 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 	atomic_set(&cq->usecnt, 0);
 
 	obj->uobject.object = cq;
-	ret = idr_add_uobj(&ib_uverbs_cq_idr, &obj->uobject);
+	ret = ib_idr_add_uobj(&ib_uverbs_cq_idr, &obj->uobject);
 	if (ret)
 		goto err_free;
 
@@ -1421,7 +1181,7 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 	return obj;
 
 err_cb:
-	idr_remove_uobj(&ib_uverbs_cq_idr, &obj->uobject);
+	ib_idr_remove_uobj(&ib_uverbs_cq_idr, &obj->uobject);
 
 err_free:
 	ib_destroy_cq(cq);
@@ -1431,7 +1191,7 @@ err_file:
 		ib_uverbs_release_ucq(file, ev_file, obj);
 
 err:
-	put_uobj_write(&obj->uobject);
+	ib_put_uobj_write(&obj->uobject);
 
 	return ERR_PTR(ret);
 }
@@ -1554,7 +1314,7 @@ ssize_t ib_uverbs_resize_cq(struct ib_uverbs_file *file,
 		   (unsigned long) cmd.response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
-	cq = idr_read_cq(cmd.cq_handle, file->ucontext, 0);
+	cq = ib_idr_read_cq(cmd.cq_handle, file->ucontext, 0);
 	if (!cq)
 		return -EINVAL;
 
@@ -1569,7 +1329,7 @@ ssize_t ib_uverbs_resize_cq(struct ib_uverbs_file *file,
 		ret = -EFAULT;
 
 out:
-	put_cq_read(cq);
+	ib_put_read_cq(cq);
 
 	return ret ? ret : in_len;
 }
@@ -1616,7 +1376,7 @@ ssize_t ib_uverbs_poll_cq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	cq = idr_read_cq(cmd.cq_handle, file->ucontext, 0);
+	cq = ib_idr_read_cq(cmd.cq_handle, file->ucontext, 0);
 	if (!cq)
 		return -EINVAL;
 
@@ -1648,7 +1408,7 @@ ssize_t ib_uverbs_poll_cq(struct ib_uverbs_file *file,
 	ret = in_len;
 
 out_put:
-	put_cq_read(cq);
+	ib_put_read_cq(cq);
 	return ret;
 }
 
@@ -1663,14 +1423,14 @@ ssize_t ib_uverbs_req_notify_cq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	cq = idr_read_cq(cmd.cq_handle, file->ucontext, 0);
+	cq = ib_idr_read_cq(cmd.cq_handle, file->ucontext, 0);
 	if (!cq)
 		return -EINVAL;
 
 	ib_req_notify_cq(cq, cmd.solicited_only ?
 			 IB_CQ_SOLICITED : IB_CQ_NEXT_COMP);
 
-	put_cq_read(cq);
+	ib_put_read_cq(cq);
 
 	return in_len;
 }
@@ -1691,7 +1451,7 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(&ib_uverbs_cq_idr, cmd.cq_handle, file->ucontext);
+	uobj = ib_idr_write_uobj(&ib_uverbs_cq_idr, cmd.cq_handle, file->ucontext);
 	if (!uobj)
 		return -EINVAL;
 	cq      = uobj->object;
@@ -1702,12 +1462,12 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
 	if (!ret)
 		uobj->live = 0;
 
-	put_uobj_write(uobj);
+	ib_put_uobj_write(uobj);
 
 	if (ret)
 		return ret;
 
-	idr_remove_uobj(&ib_uverbs_cq_idr, uobj);
+	ib_idr_remove_uobj(&ib_uverbs_cq_idr, uobj);
 
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
@@ -1719,7 +1479,7 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
 	resp.comp_events_reported  = obj->comp_events_reported;
 	resp.async_events_reported = obj->async_events_reported;
 
-	put_uobj(uobj);
+	ib_put_uobj(uobj);
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp))
@@ -1758,13 +1518,13 @@ static int create_qp(struct ib_uverbs_file *file,
 	if (!obj)
 		return -ENOMEM;
 
-	init_uobj(&obj->uevent.uobject, cmd->user_handle, file->ucontext,
-		  &qp_lock_class);
+	ib_init_uobj(&obj->uevent.uobject, cmd->user_handle, file->ucontext,
+		     &qp_lock_class);
 	down_write(&obj->uevent.uobject.mutex);
 
 	if (cmd->qp_type == IB_QPT_XRC_TGT) {
-		xrcd = idr_read_xrcd(cmd->pd_handle, file->ucontext,
-				     &xrcd_uobj);
+		xrcd = ib_idr_read_xrcd(cmd->pd_handle, file->ucontext,
+					&xrcd_uobj);
 		if (!xrcd) {
 			ret = -EINVAL;
 			goto err_put;
@@ -1776,8 +1536,8 @@ static int create_qp(struct ib_uverbs_file *file,
 			cmd->max_recv_sge = 0;
 		} else {
 			if (cmd->is_srq) {
-				srq = idr_read_srq(cmd->srq_handle,
-						   file->ucontext);
+				srq = ib_idr_read_srq(cmd->srq_handle,
+						      file->ucontext);
 				if (!srq || srq->srq_type != IB_SRQT_BASIC) {
 					ret = -EINVAL;
 					goto err_put;
@@ -1785,8 +1545,8 @@ static int create_qp(struct ib_uverbs_file *file,
 			}
 
 			if (cmd->recv_cq_handle != cmd->send_cq_handle) {
-				rcq = idr_read_cq(cmd->recv_cq_handle,
-						  file->ucontext, 0);
+				rcq = ib_idr_read_cq(cmd->recv_cq_handle,
+						     file->ucontext, 0);
 				if (!rcq) {
 					ret = -EINVAL;
 					goto err_put;
@@ -1794,9 +1554,9 @@ static int create_qp(struct ib_uverbs_file *file,
 			}
 		}
 
-		scq = idr_read_cq(cmd->send_cq_handle, file->ucontext, !!rcq);
+		scq = ib_idr_read_cq(cmd->send_cq_handle, file->ucontext, !!rcq);
 		rcq = rcq ?: scq;
-		pd  = idr_read_pd(cmd->pd_handle, file->ucontext);
+		pd  = ib_idr_read_pd(cmd->pd_handle, file->ucontext);
 		if (!pd || !scq) {
 			ret = -EINVAL;
 			goto err_put;
@@ -1878,7 +1638,7 @@ static int create_qp(struct ib_uverbs_file *file,
 	qp->uobject = &obj->uevent.uobject;
 
 	obj->uevent.uobject.object = qp;
-	ret = idr_add_uobj(&ib_uverbs_qp_idr, &obj->uevent.uobject);
+	ret = ib_idr_add_uobj(&ib_uverbs_qp_idr, &obj->uevent.uobject);
 	if (ret)
 		goto err_destroy;
 
@@ -1902,17 +1662,17 @@ static int create_qp(struct ib_uverbs_file *file,
 		obj->uxrcd = container_of(xrcd_uobj, struct ib_uxrcd_object,
 					  uobject);
 		atomic_inc(&obj->uxrcd->refcnt);
-		put_xrcd_read(xrcd_uobj);
+		ib_put_xrcd_read(xrcd_uobj);
 	}
 
 	if (pd)
-		put_pd_read(pd);
+		ib_put_read_pd(pd);
 	if (scq)
-		put_cq_read(scq);
+		ib_put_read_cq(scq);
 	if (rcq && rcq != scq)
-		put_cq_read(rcq);
+		ib_put_read_cq(rcq);
 	if (srq)
-		put_srq_read(srq);
+		ib_put_read_srq(srq);
 
 	mutex_lock(&file->mutex);
 	list_add_tail(&obj->uevent.uobject.list, &file->ucontext->qp_list);
@@ -1924,24 +1684,24 @@ static int create_qp(struct ib_uverbs_file *file,
 
 	return 0;
 err_cb:
-	idr_remove_uobj(&ib_uverbs_qp_idr, &obj->uevent.uobject);
+	ib_idr_remove_uobj(&ib_uverbs_qp_idr, &obj->uevent.uobject);
 
 err_destroy:
 	ib_destroy_qp(qp);
 
 err_put:
 	if (xrcd)
-		put_xrcd_read(xrcd_uobj);
+		ib_put_xrcd_read(xrcd_uobj);
 	if (pd)
-		put_pd_read(pd);
+		ib_put_read_pd(pd);
 	if (scq)
-		put_cq_read(scq);
+		ib_put_read_cq(scq);
 	if (rcq && rcq != scq)
-		put_cq_read(rcq);
+		ib_put_read_cq(rcq);
 	if (srq)
-		put_srq_read(srq);
+		ib_put_read_srq(srq);
 
-	put_uobj_write(&obj->uevent.uobject);
+	ib_put_uobj_write(&obj->uevent.uobject);
 	return ret;
 }
 
@@ -2081,10 +1841,10 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
 	if (!obj)
 		return -ENOMEM;
 
-	init_uobj(&obj->uevent.uobject, cmd.user_handle, file->ucontext, &qp_lock_class);
+	ib_init_uobj(&obj->uevent.uobject, cmd.user_handle, file->ucontext, &qp_lock_class);
 	down_write(&obj->uevent.uobject.mutex);
 
-	xrcd = idr_read_xrcd(cmd.pd_handle, file->ucontext, &xrcd_uobj);
+	xrcd = ib_idr_read_xrcd(cmd.pd_handle, file->ucontext, &xrcd_uobj);
 	if (!xrcd) {
 		ret = -EINVAL;
 		goto err_put;
@@ -2108,7 +1868,7 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
 	qp->uobject = &obj->uevent.uobject;
 
 	obj->uevent.uobject.object = qp;
-	ret = idr_add_uobj(&ib_uverbs_qp_idr, &obj->uevent.uobject);
+	ret = ib_idr_add_uobj(&ib_uverbs_qp_idr, &obj->uevent.uobject);
 	if (ret)
 		goto err_destroy;
 
@@ -2124,7 +1884,7 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
 
 	obj->uxrcd = container_of(xrcd_uobj, struct ib_uxrcd_object, uobject);
 	atomic_inc(&obj->uxrcd->refcnt);
-	put_xrcd_read(xrcd_uobj);
+	ib_put_xrcd_read(xrcd_uobj);
 
 	mutex_lock(&file->mutex);
 	list_add_tail(&obj->uevent.uobject.list, &file->ucontext->qp_list);
@@ -2137,14 +1897,14 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
 	return in_len;
 
 err_remove:
-	idr_remove_uobj(&ib_uverbs_qp_idr, &obj->uevent.uobject);
+	ib_idr_remove_uobj(&ib_uverbs_qp_idr, &obj->uevent.uobject);
 
 err_destroy:
 	ib_destroy_qp(qp);
 
 err_put:
-	put_xrcd_read(xrcd_uobj);
-	put_uobj_write(&obj->uevent.uobject);
+	ib_put_xrcd_read(xrcd_uobj);
+	ib_put_uobj_write(&obj->uevent.uobject);
 	return ret;
 }
 
@@ -2170,7 +1930,7 @@ ssize_t ib_uverbs_query_qp(struct ib_uverbs_file *file,
 		goto out;
 	}
 
-	qp = idr_read_qp(cmd.qp_handle, file->ucontext);
+	qp = ib_idr_read_qp(cmd.qp_handle, file->ucontext);
 	if (!qp) {
 		ret = -EINVAL;
 		goto out;
@@ -2178,7 +1938,7 @@ ssize_t ib_uverbs_query_qp(struct ib_uverbs_file *file,
 
 	ret = ib_query_qp(qp, attr, cmd.attr_mask, init_attr);
 
-	put_qp_read(qp);
+	ib_put_read_qp(qp);
 
 	if (ret)
 		goto out;
@@ -2284,7 +2044,7 @@ ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
 	if (!attr)
 		return -ENOMEM;
 
-	qp = idr_read_qp(cmd.qp_handle, file->ucontext);
+	qp = ib_idr_read_qp(cmd.qp_handle, file->ucontext);
 	if (!qp) {
 		ret = -EINVAL;
 		goto out;
@@ -2352,7 +2112,7 @@ ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
 	ret = in_len;
 
 release_qp:
-	put_qp_read(qp);
+	ib_put_read_qp(qp);
 
 out:
 	kfree(attr);
@@ -2377,14 +2137,14 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 
 	memset(&resp, 0, sizeof resp);
 
-	uobj = idr_write_uobj(&ib_uverbs_qp_idr, cmd.qp_handle, file->ucontext);
+	uobj = ib_idr_write_uobj(&ib_uverbs_qp_idr, cmd.qp_handle, file->ucontext);
 	if (!uobj)
 		return -EINVAL;
 	qp  = uobj->object;
 	obj = container_of(uobj, struct ib_uqp_object, uevent.uobject);
 
 	if (!list_empty(&obj->mcast_list)) {
-		put_uobj_write(uobj);
+		ib_put_uobj_write(uobj);
 		return -EBUSY;
 	}
 
@@ -2392,7 +2152,7 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 	if (!ret)
 		uobj->live = 0;
 
-	put_uobj_write(uobj);
+	ib_put_uobj_write(uobj);
 
 	if (ret)
 		return ret;
@@ -2400,7 +2160,7 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 	if (obj->uxrcd)
 		atomic_dec(&obj->uxrcd->refcnt);
 
-	idr_remove_uobj(&ib_uverbs_qp_idr, uobj);
+	ib_idr_remove_uobj(&ib_uverbs_qp_idr, uobj);
 
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
@@ -2410,7 +2170,7 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 
 	resp.events_reported = obj->uevent.events_reported;
 
-	put_uobj(uobj);
+	ib_put_uobj(uobj);
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp))
@@ -2454,7 +2214,7 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 	if (!user_wr)
 		return -ENOMEM;
 
-	qp = idr_read_qp(cmd.qp_handle, file->ucontext);
+	qp = ib_idr_read_qp(cmd.qp_handle, file->ucontext);
 	if (!qp)
 		goto out;
 
@@ -2490,7 +2250,7 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 				goto out_put;
 			}
 
-			ud->ah = idr_read_ah(user_wr->wr.ud.ah, file->ucontext);
+			ud->ah = ib_idr_read_ah(user_wr->wr.ud.ah, file->ucontext);
 			if (!ud->ah) {
 				kfree(ud);
 				ret = -EINVAL;
@@ -2597,11 +2357,11 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 		ret = -EFAULT;
 
 out_put:
-	put_qp_read(qp);
+	ib_put_read_qp(qp);
 
 	while (wr) {
 		if (is_ud && ud_wr(wr)->ah)
-			put_ah_read(ud_wr(wr)->ah);
+			ib_put_read_ah(ud_wr(wr)->ah);
 		next = wr->next;
 		kfree(wr);
 		wr = next;
@@ -2718,14 +2478,14 @@ ssize_t ib_uverbs_post_recv(struct ib_uverbs_file *file,
 	if (IS_ERR(wr))
 		return PTR_ERR(wr);
 
-	qp = idr_read_qp(cmd.qp_handle, file->ucontext);
+	qp = ib_idr_read_qp(cmd.qp_handle, file->ucontext);
 	if (!qp)
 		goto out;
 
 	resp.bad_wr = 0;
 	ret = qp->device->post_recv(qp->real_qp, wr, &bad_wr);
 
-	put_qp_read(qp);
+	ib_put_read_qp(qp);
 
 	if (ret)
 		for (next = wr; next; next = next->next) {
@@ -2768,14 +2528,14 @@ ssize_t ib_uverbs_post_srq_recv(struct ib_uverbs_file *file,
 	if (IS_ERR(wr))
 		return PTR_ERR(wr);
 
-	srq = idr_read_srq(cmd.srq_handle, file->ucontext);
+	srq = ib_idr_read_srq(cmd.srq_handle, file->ucontext);
 	if (!srq)
 		goto out;
 
 	resp.bad_wr = 0;
 	ret = srq->device->post_srq_recv(srq, wr, &bad_wr);
 
-	put_srq_read(srq);
+	ib_put_read_srq(srq);
 
 	if (ret)
 		for (next = wr; next; next = next->next) {
@@ -2821,10 +2581,10 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	if (!uobj)
 		return -ENOMEM;
 
-	init_uobj(uobj, cmd.user_handle, file->ucontext, &ah_lock_class);
+	ib_init_uobj(uobj, cmd.user_handle, file->ucontext, &ah_lock_class);
 	down_write(&uobj->mutex);
 
-	pd = idr_read_pd(cmd.pd_handle, file->ucontext);
+	pd = ib_idr_read_pd(cmd.pd_handle, file->ucontext);
 	if (!pd) {
 		ret = -EINVAL;
 		goto err;
@@ -2852,7 +2612,7 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	ah->uobject  = uobj;
 	uobj->object = ah;
 
-	ret = idr_add_uobj(&ib_uverbs_ah_idr, uobj);
+	ret = ib_idr_add_uobj(&ib_uverbs_ah_idr, uobj);
 	if (ret)
 		goto err_destroy;
 
@@ -2864,7 +2624,7 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 		goto err_copy;
 	}
 
-	put_pd_read(pd);
+	ib_put_read_pd(pd);
 
 	mutex_lock(&file->mutex);
 	list_add_tail(&uobj->list, &file->ucontext->ah_list);
@@ -2877,16 +2637,16 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	return in_len;
 
 err_copy:
-	idr_remove_uobj(&ib_uverbs_ah_idr, uobj);
+	ib_idr_remove_uobj(&ib_uverbs_ah_idr, uobj);
 
 err_destroy:
 	ib_destroy_ah(ah);
 
 err_put:
-	put_pd_read(pd);
+	ib_put_read_pd(pd);
 
 err:
-	put_uobj_write(uobj);
+	ib_put_uobj_write(uobj);
 	return ret;
 }
 
@@ -2902,7 +2662,7 @@ ssize_t ib_uverbs_destroy_ah(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(&ib_uverbs_ah_idr, cmd.ah_handle, file->ucontext);
+	uobj = ib_idr_write_uobj(&ib_uverbs_ah_idr, cmd.ah_handle, file->ucontext);
 	if (!uobj)
 		return -EINVAL;
 	ah = uobj->object;
@@ -2911,18 +2671,18 @@ ssize_t ib_uverbs_destroy_ah(struct ib_uverbs_file *file,
 	if (!ret)
 		uobj->live = 0;
 
-	put_uobj_write(uobj);
+	ib_put_uobj_write(uobj);
 
 	if (ret)
 		return ret;
 
-	idr_remove_uobj(&ib_uverbs_ah_idr, uobj);
+	ib_idr_remove_uobj(&ib_uverbs_ah_idr, uobj);
 
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
 	mutex_unlock(&file->mutex);
 
-	put_uobj(uobj);
+	ib_put_uobj(uobj);
 
 	return in_len;
 }
@@ -2941,7 +2701,7 @@ ssize_t ib_uverbs_attach_mcast(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	qp = idr_write_qp(cmd.qp_handle, file->ucontext);
+	qp = ib_idr_write_qp(cmd.qp_handle, file->ucontext);
 	if (!qp)
 		return -EINVAL;
 
@@ -2970,7 +2730,7 @@ ssize_t ib_uverbs_attach_mcast(struct ib_uverbs_file *file,
 		kfree(mcast);
 
 out_put:
-	put_qp_write(qp);
+	ib_put_write_qp(qp);
 
 	return ret ? ret : in_len;
 }
@@ -2989,7 +2749,7 @@ ssize_t ib_uverbs_detach_mcast(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	qp = idr_write_qp(cmd.qp_handle, file->ucontext);
+	qp = ib_idr_write_qp(cmd.qp_handle, file->ucontext);
 	if (!qp)
 		return -EINVAL;
 
@@ -3008,7 +2768,7 @@ ssize_t ib_uverbs_detach_mcast(struct ib_uverbs_file *file,
 		}
 
 out_put:
-	put_qp_write(qp);
+	ib_put_write_qp(qp);
 
 	return ret ? ret : in_len;
 }
@@ -3133,10 +2893,10 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 		err = -ENOMEM;
 		goto err_free_attr;
 	}
-	init_uobj(uobj, 0, file->ucontext, &rule_lock_class);
+	ib_init_uobj(uobj, 0, file->ucontext, &rule_lock_class);
 	down_write(&uobj->mutex);
 
-	qp = idr_read_qp(cmd.qp_handle, file->ucontext);
+	qp = ib_idr_read_qp(cmd.qp_handle, file->ucontext);
 	if (!qp) {
 		err = -EINVAL;
 		goto err_uobj;
@@ -3185,7 +2945,7 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 	flow_id->uobject = uobj;
 	uobj->object = flow_id;
 
-	err = idr_add_uobj(&ib_uverbs_rule_idr, uobj);
+	err = ib_idr_add_uobj(&ib_uverbs_rule_idr, uobj);
 	if (err)
 		goto destroy_flow;
 
@@ -3197,7 +2957,7 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 	if (err)
 		goto err_copy;
 
-	put_qp_read(qp);
+	ib_put_read_qp(qp);
 	mutex_lock(&file->mutex);
 	list_add_tail(&uobj->list, &file->ucontext->rule_list);
 	mutex_unlock(&file->mutex);
@@ -3210,15 +2970,15 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 		kfree(kern_flow_attr);
 	return 0;
 err_copy:
-	idr_remove_uobj(&ib_uverbs_rule_idr, uobj);
+	ib_idr_remove_uobj(&ib_uverbs_rule_idr, uobj);
 destroy_flow:
 	ib_destroy_flow(flow_id);
 err_free:
 	kfree(flow_attr);
 err_put:
-	put_qp_read(qp);
+	ib_put_read_qp(qp);
 err_uobj:
-	put_uobj_write(uobj);
+	ib_put_uobj_write(uobj);
 err_free_attr:
 	if (cmd.flow_attr.num_of_specs)
 		kfree(kern_flow_attr);
@@ -3245,8 +3005,8 @@ int ib_uverbs_ex_destroy_flow(struct ib_uverbs_file *file,
 	if (cmd.comp_mask)
 		return -EINVAL;
 
-	uobj = idr_write_uobj(&ib_uverbs_rule_idr, cmd.flow_handle,
-			      file->ucontext);
+	uobj = ib_idr_write_uobj(&ib_uverbs_rule_idr, cmd.flow_handle,
+				 file->ucontext);
 	if (!uobj)
 		return -EINVAL;
 	flow_id = uobj->object;
@@ -3255,15 +3015,15 @@ int ib_uverbs_ex_destroy_flow(struct ib_uverbs_file *file,
 	if (!ret)
 		uobj->live = 0;
 
-	put_uobj_write(uobj);
+	ib_put_uobj_write(uobj);
 
-	idr_remove_uobj(&ib_uverbs_rule_idr, uobj);
+	ib_idr_remove_uobj(&ib_uverbs_rule_idr, uobj);
 
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
 	mutex_unlock(&file->mutex);
 
-	put_uobj(uobj);
+	ib_put_uobj(uobj);
 
 	return ret;
 }
@@ -3285,11 +3045,11 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	if (!obj)
 		return -ENOMEM;
 
-	init_uobj(&obj->uevent.uobject, cmd->user_handle, file->ucontext, &srq_lock_class);
+	ib_init_uobj(&obj->uevent.uobject, cmd->user_handle, file->ucontext, &srq_lock_class);
 	down_write(&obj->uevent.uobject.mutex);
 
 	if (cmd->srq_type == IB_SRQT_XRC) {
-		attr.ext.xrc.xrcd  = idr_read_xrcd(cmd->xrcd_handle, file->ucontext, &xrcd_uobj);
+		attr.ext.xrc.xrcd  = ib_idr_read_xrcd(cmd->xrcd_handle, file->ucontext, &xrcd_uobj);
 		if (!attr.ext.xrc.xrcd) {
 			ret = -EINVAL;
 			goto err;
@@ -3298,14 +3058,14 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 		obj->uxrcd = container_of(xrcd_uobj, struct ib_uxrcd_object, uobject);
 		atomic_inc(&obj->uxrcd->refcnt);
 
-		attr.ext.xrc.cq  = idr_read_cq(cmd->cq_handle, file->ucontext, 0);
+		attr.ext.xrc.cq  = ib_idr_read_cq(cmd->cq_handle, file->ucontext, 0);
 		if (!attr.ext.xrc.cq) {
 			ret = -EINVAL;
 			goto err_put_xrcd;
 		}
 	}
 
-	pd  = idr_read_pd(cmd->pd_handle, file->ucontext);
+	pd  = ib_idr_read_pd(cmd->pd_handle, file->ucontext);
 	if (!pd) {
 		ret = -EINVAL;
 		goto err_put_cq;
@@ -3345,7 +3105,7 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	atomic_set(&srq->usecnt, 0);
 
 	obj->uevent.uobject.object = srq;
-	ret = idr_add_uobj(&ib_uverbs_srq_idr, &obj->uevent.uobject);
+	ret = ib_idr_add_uobj(&ib_uverbs_srq_idr, &obj->uevent.uobject);
 	if (ret)
 		goto err_destroy;
 
@@ -3363,10 +3123,10 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	}
 
 	if (cmd->srq_type == IB_SRQT_XRC) {
-		put_uobj_read(xrcd_uobj);
-		put_cq_read(attr.ext.xrc.cq);
+		ib_put_uobj_read(xrcd_uobj);
+		ib_put_read_cq(attr.ext.xrc.cq);
 	}
-	put_pd_read(pd);
+	ib_put_read_pd(pd);
 
 	mutex_lock(&file->mutex);
 	list_add_tail(&obj->uevent.uobject.list, &file->ucontext->srq_list);
@@ -3379,26 +3139,26 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	return 0;
 
 err_copy:
-	idr_remove_uobj(&ib_uverbs_srq_idr, &obj->uevent.uobject);
+	ib_idr_remove_uobj(&ib_uverbs_srq_idr, &obj->uevent.uobject);
 
 err_destroy:
 	ib_destroy_srq(srq);
 
 err_put:
-	put_pd_read(pd);
+	ib_put_read_pd(pd);
 
 err_put_cq:
 	if (cmd->srq_type == IB_SRQT_XRC)
-		put_cq_read(attr.ext.xrc.cq);
+		ib_put_read_cq(attr.ext.xrc.cq);
 
 err_put_xrcd:
 	if (cmd->srq_type == IB_SRQT_XRC) {
 		atomic_dec(&obj->uxrcd->refcnt);
-		put_uobj_read(xrcd_uobj);
+		ib_put_uobj_read(xrcd_uobj);
 	}
 
 err:
-	put_uobj_write(&obj->uevent.uobject);
+	ib_put_uobj_write(&obj->uevent.uobject);
 	return ret;
 }
 
@@ -3483,7 +3243,7 @@ ssize_t ib_uverbs_modify_srq(struct ib_uverbs_file *file,
 	INIT_UDATA(&udata, buf + sizeof cmd, NULL, in_len - sizeof cmd,
 		   out_len);
 
-	srq = idr_read_srq(cmd.srq_handle, file->ucontext);
+	srq = ib_idr_read_srq(cmd.srq_handle, file->ucontext);
 	if (!srq)
 		return -EINVAL;
 
@@ -3492,7 +3252,7 @@ ssize_t ib_uverbs_modify_srq(struct ib_uverbs_file *file,
 
 	ret = srq->device->modify_srq(srq, &attr, cmd.attr_mask, &udata);
 
-	put_srq_read(srq);
+	ib_put_read_srq(srq);
 
 	return ret ? ret : in_len;
 }
@@ -3514,13 +3274,13 @@ ssize_t ib_uverbs_query_srq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	srq = idr_read_srq(cmd.srq_handle, file->ucontext);
+	srq = ib_idr_read_srq(cmd.srq_handle, file->ucontext);
 	if (!srq)
 		return -EINVAL;
 
 	ret = ib_query_srq(srq, &attr);
 
-	put_srq_read(srq);
+	ib_put_read_srq(srq);
 
 	if (ret)
 		return ret;
@@ -3555,7 +3315,7 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(&ib_uverbs_srq_idr, cmd.srq_handle, file->ucontext);
+	uobj = ib_idr_write_uobj(&ib_uverbs_srq_idr, cmd.srq_handle, file->ucontext);
 	if (!uobj)
 		return -EINVAL;
 	srq = uobj->object;
@@ -3566,7 +3326,7 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	if (!ret)
 		uobj->live = 0;
 
-	put_uobj_write(uobj);
+	ib_put_uobj_write(uobj);
 
 	if (ret)
 		return ret;
@@ -3576,7 +3336,7 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 		atomic_dec(&us->uxrcd->refcnt);
 	}
 
-	idr_remove_uobj(&ib_uverbs_srq_idr, uobj);
+	ib_idr_remove_uobj(&ib_uverbs_srq_idr, uobj);
 
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
@@ -3587,7 +3347,7 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	memset(&resp, 0, sizeof resp);
 	resp.events_reported = obj->events_reported;
 
-	put_uobj(uobj);
+	ib_put_uobj(uobj);
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp))
diff --git a/drivers/infiniband/core/uverbs_cmd_common.c b/drivers/infiniband/core/uverbs_cmd_common.c
new file mode 100644
index 0000000..f2526f5
--- /dev/null
+++ b/drivers/infiniband/core/uverbs_cmd_common.c
@@ -0,0 +1,280 @@
+/*
+ * Copyright (c) 2005 Topspin Communications.  All rights reserved.
+ * Copyright (c) 2005, 2006, 2007 Cisco Systems.  All rights reserved.
+ * Copyright (c) 2005 PathScale, Inc.  All rights reserved.
+ * Copyright (c) 2006 Mellanox Technologies.  All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/slab.h>
+#include <linux/sched.h>
+
+#include <linux/uaccess.h>
+
+#include "uverbs.h"
+#include "core_priv.h"
+
+struct uverbs_lock_class pd_lock_class	= { .name = "PD-uobj" };
+struct uverbs_lock_class mr_lock_class	= { .name = "MR-uobj" };
+struct uverbs_lock_class mw_lock_class	= { .name = "MW-uobj" };
+struct uverbs_lock_class cq_lock_class	= { .name = "CQ-uobj" };
+struct uverbs_lock_class qp_lock_class	= { .name = "QP-uobj" };
+struct uverbs_lock_class ah_lock_class	= { .name = "AH-uobj" };
+struct uverbs_lock_class srq_lock_class	= { .name = "SRQ-uobj" };
+struct uverbs_lock_class xrcd_lock_class = { .name = "XRCD-uobj" };
+struct uverbs_lock_class rule_lock_class = { .name = "RULE-uobj" };
+
+/*
+ * The ib_uobject locking scheme is as follows:
+ *
+ * - ib_uverbs_idr_lock protects the uverbs idrs themselves, so it
+ *   needs to be held during all idr write operations.  When an object is
+ *   looked up, a reference must be taken on the object's kref before
+ *   dropping this lock.  For read operations, the rcu_read_lock()
+ *   and rcu_write_lock() but similarly the kref reference is grabbed
+ *   before the rcu_read_unlock().
+ *
+ * - Each object also has an rwsem.  This rwsem must be held for
+ *   reading while an operation that uses the object is performed.
+ *   For example, while registering an MR, the associated PD's
+ *   uobject.mutex must be held for reading.  The rwsem must be held
+ *   for writing while initializing or destroying an object.
+ *
+ * - In addition, each object has a "live" flag.  If this flag is not
+ *   set, then lookups of the object will fail even if it is found in
+ *   the idr.  This handles a reader that blocks and does not acquire
+ *   the rwsem until after the object is destroyed.  The destroy
+ *   operation will set the live flag to 0 and then drop the rwsem;
+ *   this will allow the reader to acquire the rwsem, see that the
+ *   live flag is 0, and then drop the rwsem and its reference to
+ *   object.  The underlying storage will not be freed until the last
+ *   reference to the object is dropped.
+ */
+
+void ib_init_uobj(struct ib_uobject *uobj, u64 user_handle,
+		  struct ib_ucontext *context, struct uverbs_lock_class *c)
+{
+	uobj->user_handle = user_handle;
+	uobj->context     = context;
+	kref_init(&uobj->ref);
+	init_rwsem(&uobj->mutex);
+	lockdep_set_class_and_name(&uobj->mutex, &c->key, c->name);
+	uobj->live        = 0;
+}
+
+static void release_uobj(struct kref *kref)
+{
+	kfree_rcu(container_of(kref, struct ib_uobject, ref), rcu);
+}
+
+void ib_put_uobj(struct ib_uobject *uobj)
+{
+	kref_put(&uobj->ref, release_uobj);
+}
+
+void ib_put_uobj_read(struct ib_uobject *uobj)
+{
+	up_read(&uobj->mutex);
+	ib_put_uobj(uobj);
+}
+
+void ib_put_uobj_write(struct ib_uobject *uobj)
+{
+	up_write(&uobj->mutex);
+	ib_put_uobj(uobj);
+}
+
+int ib_idr_add_uobj(struct idr *idr, struct ib_uobject *uobj)
+{
+	int ret;
+
+	idr_preload(GFP_KERNEL);
+	spin_lock(&ib_uverbs_idr_lock);
+
+	ret = idr_alloc(idr, uobj, 0, 0, GFP_NOWAIT);
+	if (ret >= 0)
+		uobj->id = ret;
+
+	spin_unlock(&ib_uverbs_idr_lock);
+	idr_preload_end();
+
+	return ret < 0 ? ret : 0;
+}
+
+void ib_idr_remove_uobj(struct idr *idr, struct ib_uobject *uobj)
+{
+	spin_lock(&ib_uverbs_idr_lock);
+	idr_remove(idr, uobj->id);
+	spin_unlock(&ib_uverbs_idr_lock);
+}
+
+static struct ib_uobject *__idr_get_uobj(struct idr *idr, int id,
+					 struct ib_ucontext *context)
+{
+	struct ib_uobject *uobj;
+
+	rcu_read_lock();
+	uobj = idr_find(idr, id);
+	if (uobj) {
+		if (uobj->context == context)
+			kref_get(&uobj->ref);
+		else
+			uobj = NULL;
+	}
+	rcu_read_unlock();
+
+	return uobj;
+}
+
+struct ib_uobject *ib_idr_read_uobj(struct idr *idr, int id,
+				    struct ib_ucontext *context, int nested)
+{
+	struct ib_uobject *uobj;
+
+	uobj = __idr_get_uobj(idr, id, context);
+	if (!uobj)
+		return NULL;
+
+	if (nested)
+		down_read_nested(&uobj->mutex, SINGLE_DEPTH_NESTING);
+	else
+		down_read(&uobj->mutex);
+	if (!uobj->live) {
+		ib_put_uobj_read(uobj);
+		return NULL;
+	}
+
+	return uobj;
+}
+
+struct ib_uobject *ib_idr_write_uobj(struct idr *idr, int id,
+				     struct ib_ucontext *context)
+{
+	struct ib_uobject *uobj;
+
+	uobj = __idr_get_uobj(idr, id, context);
+	if (!uobj)
+		return NULL;
+
+	down_write(&uobj->mutex);
+	if (!uobj->live) {
+		ib_put_uobj_write(uobj);
+		return NULL;
+	}
+
+	return uobj;
+}
+
+static void *idr_read_obj(struct idr *idr, int id, struct ib_ucontext *context,
+			  int nested)
+{
+	struct ib_uobject *uobj;
+
+	uobj = ib_idr_read_uobj(idr, id, context, nested);
+	return uobj ? uobj->object : NULL;
+}
+
+struct ib_pd *ib_idr_read_pd(int pd_handle, struct ib_ucontext *context)
+{
+	return idr_read_obj(&ib_uverbs_pd_idr, pd_handle, context, 0);
+}
+
+void ib_put_read_pd(struct ib_pd *pd)
+{
+	ib_put_uobj_read(pd->uobject);
+}
+
+struct ib_cq *ib_idr_read_cq(int cq_handle, struct ib_ucontext *context, int nested)
+{
+	return idr_read_obj(&ib_uverbs_cq_idr, cq_handle, context, nested);
+}
+
+void ib_put_read_cq(struct ib_cq *cq)
+{
+	ib_put_uobj_read(cq->uobject);
+}
+
+struct ib_ah *ib_idr_read_ah(int ah_handle, struct ib_ucontext *context)
+{
+	return idr_read_obj(&ib_uverbs_ah_idr, ah_handle, context, 0);
+}
+
+void ib_put_read_ah(struct ib_ah *ah)
+{
+	ib_put_uobj_read(ah->uobject);
+}
+
+struct ib_qp *ib_idr_read_qp(int qp_handle, struct ib_ucontext *context)
+{
+	return idr_read_obj(&ib_uverbs_qp_idr, qp_handle, context, 0);
+}
+
+struct ib_qp *ib_idr_write_qp(int qp_handle, struct ib_ucontext *context)
+{
+	struct ib_uobject *uobj;
+
+	uobj = ib_idr_write_uobj(&ib_uverbs_qp_idr, qp_handle, context);
+	return uobj ? uobj->object : NULL;
+}
+
+void ib_put_read_qp(struct ib_qp *qp)
+{
+	ib_put_uobj_read(qp->uobject);
+}
+
+void ib_put_write_qp(struct ib_qp *qp)
+{
+	ib_put_uobj_write(qp->uobject);
+}
+
+struct ib_srq *ib_idr_read_srq(int srq_handle, struct ib_ucontext *context)
+{
+	return idr_read_obj(&ib_uverbs_srq_idr, srq_handle, context, 0);
+}
+
+void ib_put_read_srq(struct ib_srq *srq)
+{
+	ib_put_uobj_read(srq->uobject);
+}
+
+struct ib_xrcd *ib_idr_read_xrcd(int xrcd_handle, struct ib_ucontext *context,
+				 struct ib_uobject **uobj)
+{
+	*uobj = ib_idr_read_uobj(&ib_uverbs_xrcd_idr, xrcd_handle, context, 0);
+	return *uobj ? (*uobj)->object : NULL;
+}
+
+void ib_put_xrcd_read(struct ib_uobject *uobj)
+{
+	ib_put_uobj_read(uobj);
+}
+
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 2f49eb7..f5dc276 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -228,7 +228,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 	list_for_each_entry_safe(uobj, tmp, &context->ah_list, list) {
 		struct ib_ah *ah = uobj->object;
 
-		idr_remove_uobj(&ib_uverbs_ah_idr, uobj);
+		ib_idr_remove_uobj(&ib_uverbs_ah_idr, uobj);
 		ib_destroy_ah(ah);
 		kfree(uobj);
 	}
@@ -237,7 +237,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 	list_for_each_entry_safe(uobj, tmp, &context->mw_list, list) {
 		struct ib_mw *mw = uobj->object;
 
-		idr_remove_uobj(&ib_uverbs_mw_idr, uobj);
+		ib_idr_remove_uobj(&ib_uverbs_mw_idr, uobj);
 		uverbs_dealloc_mw(mw);
 		kfree(uobj);
 	}
@@ -245,7 +245,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 	list_for_each_entry_safe(uobj, tmp, &context->rule_list, list) {
 		struct ib_flow *flow_id = uobj->object;
 
-		idr_remove_uobj(&ib_uverbs_rule_idr, uobj);
+		ib_idr_remove_uobj(&ib_uverbs_rule_idr, uobj);
 		ib_destroy_flow(flow_id);
 		kfree(uobj);
 	}
@@ -255,7 +255,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		struct ib_uqp_object *uqp =
 			container_of(uobj, struct ib_uqp_object, uevent.uobject);
 
-		idr_remove_uobj(&ib_uverbs_qp_idr, uobj);
+		ib_idr_remove_uobj(&ib_uverbs_qp_idr, uobj);
 		if (qp != qp->real_qp) {
 			ib_close_qp(qp);
 		} else {
@@ -271,7 +271,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		struct ib_uevent_object *uevent =
 			container_of(uobj, struct ib_uevent_object, uobject);
 
-		idr_remove_uobj(&ib_uverbs_srq_idr, uobj);
+		ib_idr_remove_uobj(&ib_uverbs_srq_idr, uobj);
 		ib_destroy_srq(srq);
 		ib_uverbs_release_uevent(file, uevent);
 		kfree(uevent);
@@ -283,7 +283,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		struct ib_ucq_object *ucq =
 			container_of(uobj, struct ib_ucq_object, uobject);
 
-		idr_remove_uobj(&ib_uverbs_cq_idr, uobj);
+		ib_idr_remove_uobj(&ib_uverbs_cq_idr, uobj);
 		ib_destroy_cq(cq);
 		ib_uverbs_release_ucq(file, ev_file, ucq);
 		kfree(ucq);
@@ -292,7 +292,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 	list_for_each_entry_safe(uobj, tmp, &context->mr_list, list) {
 		struct ib_mr *mr = uobj->object;
 
-		idr_remove_uobj(&ib_uverbs_mr_idr, uobj);
+		ib_idr_remove_uobj(&ib_uverbs_mr_idr, uobj);
 		ib_dereg_mr(mr);
 		kfree(uobj);
 	}
@@ -303,7 +303,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		struct ib_uxrcd_object *uxrcd =
 			container_of(uobj, struct ib_uxrcd_object, uobject);
 
-		idr_remove_uobj(&ib_uverbs_xrcd_idr, uobj);
+		ib_idr_remove_uobj(&ib_uverbs_xrcd_idr, uobj);
 		ib_uverbs_dealloc_xrcd(file->device, xrcd);
 		kfree(uxrcd);
 	}
@@ -312,7 +312,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 	list_for_each_entry_safe(uobj, tmp, &context->pd_list, list) {
 		struct ib_pd *pd = uobj->object;
 
-		idr_remove_uobj(&ib_uverbs_pd_idr, uobj);
+		ib_idr_remove_uobj(&ib_uverbs_pd_idr, uobj);
 		ib_dealloc_pd(pd);
 		kfree(uobj);
 	}
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
