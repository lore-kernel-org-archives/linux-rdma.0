From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V3 for-next 4/7] IB/core: Change idr objects to use the new schema
Date: Tue,  4 Apr 2017 13:31:44 +0300
Message-ID: <1491301907-32290-5-git-send-email-matanb@mellanox.com>
References: <1491301907-32290-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1491301907-32290-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This changes only the handlers which deals with idr based objects to
use the new idr allocation, fetching and destruction schema.
This patch consists of the following changes:
(1) Allocation, fetching and destruction is done via idr ops.
(2) Context initializing and release is done through
    uverbs_initialize_ucontext and uverbs_cleanup_ucontext.
(3) Ditching the live flag. Mostly, this is pretty straight
    forward. The only place that is a bit trickier is in
    ib_uverbs_open_qp. Commit [1] added code to check whether
    the uobject is already live and initialized. This mostly
    happens because of a race between open_qp and events.
    We delayed assigning the uobject's pointer in order to
    eliminate this race without using the live variable.

[1] commit a040f95dc819
	("IB/core: Fix XRC race condition in ib_uverbs_open_qp")

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/rdma_core.h   |   15 +
 drivers/infiniband/core/uverbs.h      |    2 -
 drivers/infiniband/core/uverbs_cmd.c  | 1311 ++++++++-------------------------
 drivers/infiniband/core/uverbs_main.c |  142 +---
 include/rdma/ib_verbs.h               |   13 -
 include/rdma/uverbs_std_types.h       |   63 ++
 6 files changed, 402 insertions(+), 1144 deletions(-)

diff --git a/drivers/infiniband/core/rdma_core.h b/drivers/infiniband/core/rdma_core.h
index ab665a6..0247bb5 100644
--- a/drivers/infiniband/core/rdma_core.h
+++ b/drivers/infiniband/core/rdma_core.h
@@ -52,4 +52,19 @@
 void uverbs_cleanup_ucontext(struct ib_ucontext *ucontext, bool device_removed);
 void uverbs_initialize_ucontext(struct ib_ucontext *ucontext);
 
+/*
+ * uverbs_uobject_get is called in order to increase the reference count on
+ * an uobject. This is useful when a handler wants to keep the uobject's memory
+ * alive, regardless if this uobject is still alive in the context's objects
+ * repository. Objects are put via uverbs_uobject_put.
+ */
+void uverbs_uobject_get(struct ib_uobject *uobject);
+
+/*
+ * In order to indicate we no longer needs this uobject, uverbs_uobject_put
+ * is called. When the reference count is decreased, the uobject is freed.
+ * For example, this is used when attaching a completion channel to a CQ.
+ */
+void uverbs_uobject_put(struct ib_uobject *uobject);
+
 #endif /* RDMA_CORE_H */
diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index cf0519d..3660278 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -180,8 +180,6 @@ struct ib_ucq_object {
 	u32			async_events_reported;
 };
 
-void idr_remove_uobj(struct ib_uobject *uobj);
-
 struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
 					struct ib_device *ib_dev,
 					int is_async);
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 79de69d..2f258aa 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -40,269 +40,13 @@
 
 #include <linux/uaccess.h>
 
+#include <rdma/uverbs_types.h>
+#include <rdma/uverbs_std_types.h>
+#include "rdma_core.h"
+
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
-static struct uverbs_lock_class wq_lock_class = { .name = "WQ-uobj" };
-static struct uverbs_lock_class rwq_ind_table_lock_class = { .name = "IND_TBL-uobj" };
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
-static int idr_add_uobj(struct ib_uobject *uobj)
-{
-	int ret;
-
-	idr_preload(GFP_KERNEL);
-	spin_lock(&uobj->context->ufile->idr_lock);
-
-	ret = idr_alloc(&uobj->context->ufile->idr, uobj, 0, 0, GFP_NOWAIT);
-	if (ret >= 0)
-		uobj->id = ret;
-
-	spin_unlock(&uobj->context->ufile->idr_lock);
-	idr_preload_end();
-
-	return ret < 0 ? ret : 0;
-}
-
-void idr_remove_uobj(struct ib_uobject *uobj)
-{
-	spin_lock(&uobj->context->ufile->idr_lock);
-	idr_remove(&uobj->context->ufile->idr, uobj->id);
-	spin_unlock(&uobj->context->ufile->idr_lock);
-}
-
-static struct ib_uobject *__idr_get_uobj(int id, struct ib_ucontext *context)
-{
-	struct ib_uobject *uobj;
-
-	rcu_read_lock();
-	uobj = idr_find(&context->ufile->idr, id);
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
-static struct ib_uobject *idr_read_uobj(int id, struct ib_ucontext *context,
-					int nested)
-{
-	struct ib_uobject *uobj;
-
-	uobj = __idr_get_uobj(id, context);
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
-static struct ib_uobject *idr_write_uobj(int id, struct ib_ucontext *context)
-{
-	struct ib_uobject *uobj;
-
-	uobj = __idr_get_uobj(id, context);
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
-static void *idr_read_obj(int id, struct ib_ucontext *context,
-			  int nested)
-{
-	struct ib_uobject *uobj;
-
-	uobj = idr_read_uobj(id, context, nested);
-	return uobj ? uobj->object : NULL;
-}
-
-static struct ib_pd *idr_read_pd(int pd_handle, struct ib_ucontext *context)
-{
-	return idr_read_obj(pd_handle, context, 0);
-}
-
-static void put_pd_read(struct ib_pd *pd)
-{
-	put_uobj_read(pd->uobject);
-}
-
-static struct ib_cq *idr_read_cq(int cq_handle, struct ib_ucontext *context, int nested)
-{
-	return idr_read_obj(cq_handle, context, nested);
-}
-
-static void put_cq_read(struct ib_cq *cq)
-{
-	put_uobj_read(cq->uobject);
-}
-
-static struct ib_ah *idr_read_ah(int ah_handle, struct ib_ucontext *context)
-{
-	return idr_read_obj(ah_handle, context, 0);
-}
-
-static void put_ah_read(struct ib_ah *ah)
-{
-	put_uobj_read(ah->uobject);
-}
-
-static struct ib_qp *idr_read_qp(int qp_handle, struct ib_ucontext *context)
-{
-	return idr_read_obj(qp_handle, context, 0);
-}
-
-static struct ib_wq *idr_read_wq(int wq_handle, struct ib_ucontext *context)
-{
-	return idr_read_obj(wq_handle, context, 0);
-}
-
-static void put_wq_read(struct ib_wq *wq)
-{
-	put_uobj_read(wq->uobject);
-}
-
-static struct ib_rwq_ind_table *idr_read_rwq_indirection_table(int ind_table_handle,
-							       struct ib_ucontext *context)
-{
-	return idr_read_obj(ind_table_handle, context, 0);
-}
-
-static void put_rwq_indirection_table_read(struct ib_rwq_ind_table *ind_table)
-{
-	put_uobj_read(ind_table->uobject);
-}
-
-static struct ib_qp *idr_write_qp(int qp_handle, struct ib_ucontext *context)
-{
-	struct ib_uobject *uobj;
-
-	uobj = idr_write_uobj(qp_handle, context);
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
-	return idr_read_obj(srq_handle, context, 0);
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
-	*uobj = idr_read_uobj(xrcd_handle, context, 0);
-	return *uobj ? (*uobj)->object : NULL;
-}
-
-static void put_xrcd_read(struct ib_uobject *uobj)
-{
-	put_uobj_read(uobj);
-}
 ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 			      struct ib_device *ib_dev,
 			      const char __user *buf,
@@ -347,17 +91,8 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 	ucontext->cg_obj = cg_obj;
 	/* ufile is required when some objects are released */
 	ucontext->ufile = file;
-	INIT_LIST_HEAD(&ucontext->pd_list);
-	INIT_LIST_HEAD(&ucontext->mr_list);
-	INIT_LIST_HEAD(&ucontext->mw_list);
-	INIT_LIST_HEAD(&ucontext->cq_list);
-	INIT_LIST_HEAD(&ucontext->qp_list);
-	INIT_LIST_HEAD(&ucontext->srq_list);
-	INIT_LIST_HEAD(&ucontext->ah_list);
-	INIT_LIST_HEAD(&ucontext->wq_list);
-	INIT_LIST_HEAD(&ucontext->rwq_ind_tbl_list);
-	INIT_LIST_HEAD(&ucontext->xrcd_list);
-	INIT_LIST_HEAD(&ucontext->rule_list);
+	uverbs_initialize_ucontext(ucontext);
+
 	rcu_read_lock();
 	ucontext->tgid = get_task_pid(current->group_leader, PIDTYPE_PID);
 	rcu_read_unlock();
@@ -564,19 +299,9 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 		   (unsigned long) cmd.response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
-	uobj = kmalloc(sizeof *uobj, GFP_KERNEL);
-	if (!uobj)
-		return -ENOMEM;
-
-	init_uobj(uobj, 0, file->ucontext, &pd_lock_class);
-	ret = ib_rdmacg_try_charge(&uobj->cg_obj, ib_dev,
-				   RDMACG_RESOURCE_HCA_OBJECT);
-	if (ret) {
-		kfree(uobj);
-		return ret;
-	}
-
-	down_write(&uobj->mutex);
+	uobj  = uobj_alloc(uobj_get_type(pd), file->ucontext);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
 
 	pd = ib_dev->alloc_pd(ib_dev, file->ucontext, &udata);
 	if (IS_ERR(pd)) {
@@ -590,10 +315,6 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 	atomic_set(&pd->usecnt, 0);
 
 	uobj->object = pd;
-	ret = idr_add_uobj(uobj);
-	if (ret)
-		goto err_idr;
-
 	memset(&resp, 0, sizeof resp);
 	resp.pd_handle = uobj->id;
 
@@ -603,25 +324,15 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 		goto err_copy;
 	}
 
-	mutex_lock(&file->mutex);
-	list_add_tail(&uobj->list, &file->ucontext->pd_list);
-	mutex_unlock(&file->mutex);
-
-	uobj->live = 1;
-
-	up_write(&uobj->mutex);
+	uobj_alloc_commit(uobj);
 
 	return in_len;
 
 err_copy:
-	idr_remove_uobj(uobj);
-
-err_idr:
 	ib_dealloc_pd(pd);
 
 err:
-	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_RESOURCE_HCA_OBJECT);
-	put_uobj_write(uobj);
+	uobj_alloc_abort(uobj);
 	return ret;
 }
 
@@ -632,45 +343,19 @@ ssize_t ib_uverbs_dealloc_pd(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_dealloc_pd cmd;
 	struct ib_uobject          *uobj;
-	struct ib_pd		   *pd;
 	int                         ret;
 
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(cmd.pd_handle, file->ucontext);
-	if (!uobj)
-		return -EINVAL;
-	pd = uobj->object;
+	uobj  = uobj_get_write(uobj_get_type(pd), cmd.pd_handle,
+			       file->ucontext);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
 
-	if (atomic_read(&pd->usecnt)) {
-		ret = -EBUSY;
-		goto err_put;
-	}
+	ret = uobj_remove_commit(uobj);
 
-	ret = pd->device->dealloc_pd(uobj->object);
-	WARN_ONCE(ret, "Infiniband HW driver failed dealloc_pd");
-	if (ret)
-		goto err_put;
-
-	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_RESOURCE_HCA_OBJECT);
-
-	uobj->live = 0;
-	put_uobj_write(uobj);
-
-	idr_remove_uobj(uobj);
-
-	mutex_lock(&file->mutex);
-	list_del(&uobj->list);
-	mutex_unlock(&file->mutex);
-
-	put_uobj(uobj);
-
-	return in_len;
-
-err_put:
-	put_uobj_write(uobj);
-	return ret;
+	return ret ?: in_len;
 }
 
 struct xrcd_table_entry {
@@ -807,16 +492,13 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 		}
 	}
 
-	obj = kmalloc(sizeof *obj, GFP_KERNEL);
-	if (!obj) {
-		ret = -ENOMEM;
+	obj  = (struct ib_uxrcd_object *)uobj_alloc(uobj_get_type(xrcd),
+						    file->ucontext);
+	if (IS_ERR(obj)) {
+		ret = PTR_ERR(obj);
 		goto err_tree_mutex_unlock;
 	}
 
-	init_uobj(&obj->uobject, 0, file->ucontext, &xrcd_lock_class);
-
-	down_write(&obj->uobject.mutex);
-
 	if (!xrcd) {
 		xrcd = ib_dev->alloc_xrcd(ib_dev, file->ucontext, &udata);
 		if (IS_ERR(xrcd)) {
@@ -834,10 +516,6 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 
 	atomic_set(&obj->refcnt, 0);
 	obj->uobject.object = xrcd;
-	ret = idr_add_uobj(&obj->uobject);
-	if (ret)
-		goto err_idr;
-
 	memset(&resp, 0, sizeof resp);
 	resp.xrcd_handle = obj->uobject.id;
 
@@ -846,7 +524,7 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 			/* create new inode/xrcd table entry */
 			ret = xrcd_table_insert(file->device, inode, xrcd);
 			if (ret)
-				goto err_insert_xrcd;
+				goto err_dealloc_xrcd;
 		}
 		atomic_inc(&xrcd->usecnt);
 	}
@@ -860,12 +538,7 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 	if (f.file)
 		fdput(f);
 
-	mutex_lock(&file->mutex);
-	list_add_tail(&obj->uobject.list, &file->ucontext->xrcd_list);
-	mutex_unlock(&file->mutex);
-
-	obj->uobject.live = 1;
-	up_write(&obj->uobject.mutex);
+	uobj_alloc_commit(&obj->uobject);
 
 	mutex_unlock(&file->device->xrcd_tree_mutex);
 	return in_len;
@@ -877,14 +550,11 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 		atomic_dec(&xrcd->usecnt);
 	}
 
-err_insert_xrcd:
-	idr_remove_uobj(&obj->uobject);
-
-err_idr:
+err_dealloc_xrcd:
 	ib_dealloc_xrcd(xrcd);
 
 err:
-	put_uobj_write(&obj->uobject);
+	uobj_alloc_abort(&obj->uobject);
 
 err_tree_mutex_unlock:
 	if (f.file)
@@ -902,60 +572,20 @@ ssize_t ib_uverbs_close_xrcd(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_close_xrcd cmd;
 	struct ib_uobject           *uobj;
-	struct ib_xrcd              *xrcd = NULL;
-	struct inode                *inode = NULL;
-	struct ib_uxrcd_object      *obj;
-	int                         live;
 	int                         ret = 0;
 
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	mutex_lock(&file->device->xrcd_tree_mutex);
-	uobj = idr_write_uobj(cmd.xrcd_handle, file->ucontext);
-	if (!uobj) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	xrcd  = uobj->object;
-	inode = xrcd->inode;
-	obj   = container_of(uobj, struct ib_uxrcd_object, uobject);
-	if (atomic_read(&obj->refcnt)) {
-		put_uobj_write(uobj);
-		ret = -EBUSY;
-		goto out;
-	}
-
-	if (!inode || atomic_dec_and_test(&xrcd->usecnt)) {
-		ret = ib_dealloc_xrcd(uobj->object);
-		if (!ret)
-			uobj->live = 0;
+	uobj  = uobj_get_write(uobj_get_type(xrcd), cmd.xrcd_handle,
+			       file->ucontext);
+	if (IS_ERR(uobj)) {
+		mutex_unlock(&file->device->xrcd_tree_mutex);
+		return PTR_ERR(uobj);
 	}
 
-	live = uobj->live;
-	if (inode && ret)
-		atomic_inc(&xrcd->usecnt);
-
-	put_uobj_write(uobj);
-
-	if (ret)
-		goto out;
-
-	if (inode && !live)
-		xrcd_table_delete(file->device, inode);
-
-	idr_remove_uobj(uobj);
-	mutex_lock(&file->mutex);
-	list_del(&uobj->list);
-	mutex_unlock(&file->mutex);
-
-	put_uobj(uobj);
-	ret = in_len;
-
-out:
-	mutex_unlock(&file->device->xrcd_tree_mutex);
-	return ret;
+	ret = uobj_remove_commit(uobj);
+	return ret ?: in_len;
 }
 
 int ib_uverbs_dealloc_xrcd(struct ib_uverbs_device *dev,
@@ -1009,14 +639,11 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
-	uobj = kmalloc(sizeof *uobj, GFP_KERNEL);
-	if (!uobj)
-		return -ENOMEM;
-
-	init_uobj(uobj, 0, file->ucontext, &mr_lock_class);
-	down_write(&uobj->mutex);
+	uobj  = uobj_alloc(uobj_get_type(mr), file->ucontext);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
 
-	pd = idr_read_pd(cmd.pd_handle, file->ucontext);
+	pd = uobj_get_obj_read(pd, cmd.pd_handle, file->ucontext);
 	if (!pd) {
 		ret = -EINVAL;
 		goto err_free;
@@ -1030,10 +657,6 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 			goto err_put;
 		}
 	}
-	ret = ib_rdmacg_try_charge(&uobj->cg_obj, ib_dev,
-				   RDMACG_RESOURCE_HCA_OBJECT);
-	if (ret)
-		goto err_charge;
 
 	mr = pd->device->reg_user_mr(pd, cmd.start, cmd.length, cmd.hca_va,
 				     cmd.access_flags, &udata);
@@ -1048,9 +671,6 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 	atomic_inc(&pd->usecnt);
 
 	uobj->object = mr;
-	ret = idr_add_uobj(uobj);
-	if (ret)
-		goto err_unreg;
 
 	memset(&resp, 0, sizeof resp);
 	resp.lkey      = mr->lkey;
@@ -1063,32 +683,20 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 		goto err_copy;
 	}
 
-	put_pd_read(pd);
-
-	mutex_lock(&file->mutex);
-	list_add_tail(&uobj->list, &file->ucontext->mr_list);
-	mutex_unlock(&file->mutex);
+	uobj_put_obj_read(pd);
 
-	uobj->live = 1;
-
-	up_write(&uobj->mutex);
+	uobj_alloc_commit(uobj);
 
 	return in_len;
 
 err_copy:
-	idr_remove_uobj(uobj);
-
-err_unreg:
 	ib_dereg_mr(mr);
 
 err_put:
-	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_RESOURCE_HCA_OBJECT);
-
-err_charge:
-	put_pd_read(pd);
+	uobj_put_obj_read(pd);
 
 err_free:
-	put_uobj_write(uobj);
+	uobj_alloc_abort(uobj);
 	return ret;
 }
 
@@ -1124,10 +732,10 @@ ssize_t ib_uverbs_rereg_mr(struct ib_uverbs_file *file,
 	     (cmd.start & ~PAGE_MASK) != (cmd.hca_va & ~PAGE_MASK)))
 			return -EINVAL;
 
-	uobj = idr_write_uobj(cmd.mr_handle, file->ucontext);
-
-	if (!uobj)
-		return -EINVAL;
+	uobj  = uobj_get_write(uobj_get_type(mr), cmd.mr_handle,
+			       file->ucontext);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
 
 	mr = uobj->object;
 
@@ -1138,7 +746,7 @@ ssize_t ib_uverbs_rereg_mr(struct ib_uverbs_file *file,
 	}
 
 	if (cmd.flags & IB_MR_REREG_PD) {
-		pd = idr_read_pd(cmd.pd_handle, file->ucontext);
+		pd = uobj_get_obj_read(pd, cmd.pd_handle, file->ucontext);
 		if (!pd) {
 			ret = -EINVAL;
 			goto put_uobjs;
@@ -1171,11 +779,10 @@ ssize_t ib_uverbs_rereg_mr(struct ib_uverbs_file *file,
 
 put_uobj_pd:
 	if (cmd.flags & IB_MR_REREG_PD)
-		put_pd_read(pd);
+		uobj_put_obj_read(pd);
 
 put_uobjs:
-
-	put_uobj_write(mr->uobject);
+	uobj_put_write(uobj);
 
 	return ret;
 }
@@ -1186,38 +793,20 @@ ssize_t ib_uverbs_dereg_mr(struct ib_uverbs_file *file,
 			   int out_len)
 {
 	struct ib_uverbs_dereg_mr cmd;
-	struct ib_mr             *mr;
 	struct ib_uobject	 *uobj;
 	int                       ret = -EINVAL;
 
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(cmd.mr_handle, file->ucontext);
-	if (!uobj)
-		return -EINVAL;
-
-	mr = uobj->object;
-
-	ret = ib_dereg_mr(mr);
-	if (!ret)
-		uobj->live = 0;
-
-	put_uobj_write(uobj);
+	uobj  = uobj_get_write(uobj_get_type(mr), cmd.mr_handle,
+			       file->ucontext);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
 
-	if (ret)
-		return ret;
+	ret = uobj_remove_commit(uobj);
 
-	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_RESOURCE_HCA_OBJECT);
-	idr_remove_uobj(uobj);
-
-	mutex_lock(&file->mutex);
-	list_del(&uobj->list);
-	mutex_unlock(&file->mutex);
-
-	put_uobj(uobj);
-
-	return in_len;
+	return ret ?: in_len;
 }
 
 ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
@@ -1239,14 +828,11 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof(cmd)))
 		return -EFAULT;
 
-	uobj = kmalloc(sizeof(*uobj), GFP_KERNEL);
-	if (!uobj)
-		return -ENOMEM;
+	uobj  = uobj_alloc(uobj_get_type(mw), file->ucontext);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
 
-	init_uobj(uobj, 0, file->ucontext, &mw_lock_class);
-	down_write(&uobj->mutex);
-
-	pd = idr_read_pd(cmd.pd_handle, file->ucontext);
+	pd = uobj_get_obj_read(pd, cmd.pd_handle, file->ucontext);
 	if (!pd) {
 		ret = -EINVAL;
 		goto err_free;
@@ -1257,11 +843,6 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 		   in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
 		   out_len - sizeof(resp));
 
-	ret = ib_rdmacg_try_charge(&uobj->cg_obj, ib_dev,
-				   RDMACG_RESOURCE_HCA_OBJECT);
-	if (ret)
-		goto err_charge;
-
 	mw = pd->device->alloc_mw(pd, cmd.mw_type, &udata);
 	if (IS_ERR(mw)) {
 		ret = PTR_ERR(mw);
@@ -1274,9 +855,6 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 	atomic_inc(&pd->usecnt);
 
 	uobj->object = mw;
-	ret = idr_add_uobj(uobj);
-	if (ret)
-		goto err_unalloc;
 
 	memset(&resp, 0, sizeof(resp));
 	resp.rkey      = mw->rkey;
@@ -1288,32 +866,17 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 		goto err_copy;
 	}
 
-	put_pd_read(pd);
-
-	mutex_lock(&file->mutex);
-	list_add_tail(&uobj->list, &file->ucontext->mw_list);
-	mutex_unlock(&file->mutex);
-
-	uobj->live = 1;
-
-	up_write(&uobj->mutex);
+	uobj_put_obj_read(pd);
+	uobj_alloc_commit(uobj);
 
 	return in_len;
 
 err_copy:
-	idr_remove_uobj(uobj);
-
-err_unalloc:
 	uverbs_dealloc_mw(mw);
-
 err_put:
-	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_RESOURCE_HCA_OBJECT);
-
-err_charge:
-	put_pd_read(pd);
-
+	uobj_put_obj_read(pd);
 err_free:
-	put_uobj_write(uobj);
+	uobj_alloc_abort(uobj);
 	return ret;
 }
 
@@ -1323,38 +886,19 @@ ssize_t ib_uverbs_dealloc_mw(struct ib_uverbs_file *file,
 			     int out_len)
 {
 	struct ib_uverbs_dealloc_mw cmd;
-	struct ib_mw               *mw;
 	struct ib_uobject	   *uobj;
 	int                         ret = -EINVAL;
 
 	if (copy_from_user(&cmd, buf, sizeof(cmd)))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(cmd.mw_handle, file->ucontext);
-	if (!uobj)
-		return -EINVAL;
-
-	mw = uobj->object;
+	uobj  = uobj_get_write(uobj_get_type(mw), cmd.mw_handle,
+			       file->ucontext);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
 
-	ret = uverbs_dealloc_mw(mw);
-	if (!ret)
-		uobj->live = 0;
-
-	put_uobj_write(uobj);
-
-	if (ret)
-		return ret;
-
-	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_RESOURCE_HCA_OBJECT);
-	idr_remove_uobj(uobj);
-
-	mutex_lock(&file->mutex);
-	list_del(&uobj->list);
-	mutex_unlock(&file->mutex);
-
-	put_uobj(uobj);
-
-	return in_len;
+	ret = uobj_remove_commit(uobj);
+	return ret ?: in_len;
 }
 
 ssize_t ib_uverbs_create_comp_channel(struct ib_uverbs_file *file,
@@ -1418,12 +962,10 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 	if (cmd->comp_vector >= file->device->num_comp_vectors)
 		return ERR_PTR(-EINVAL);
 
-	obj = kmalloc(sizeof *obj, GFP_KERNEL);
-	if (!obj)
-		return ERR_PTR(-ENOMEM);
-
-	init_uobj(&obj->uobject, cmd->user_handle, file->ucontext, &cq_lock_class);
-	down_write(&obj->uobject.mutex);
+	obj  = (struct ib_ucq_object *)uobj_alloc(uobj_get_type(cq),
+						  file->ucontext);
+	if (IS_ERR(obj))
+		return obj;
 
 	if (cmd->comp_channel >= 0) {
 		ev_file = ib_uverbs_lookup_comp_file(cmd->comp_channel);
@@ -1433,6 +975,7 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 		}
 	}
 
+	obj->uobject.user_handle = cmd->user_handle;
 	obj->uverbs_file	   = file;
 	obj->comp_events_reported  = 0;
 	obj->async_events_reported = 0;
@@ -1445,13 +988,7 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 	if (cmd_sz > offsetof(typeof(*cmd), flags) + sizeof(cmd->flags))
 		attr.flags = cmd->flags;
 
-	ret = ib_rdmacg_try_charge(&obj->uobject.cg_obj, ib_dev,
-				   RDMACG_RESOURCE_HCA_OBJECT);
-	if (ret)
-		goto err_charge;
-
-	cq = ib_dev->create_cq(ib_dev, &attr,
-					     file->ucontext, uhw);
+	cq = ib_dev->create_cq(ib_dev, &attr, file->ucontext, uhw);
 	if (IS_ERR(cq)) {
 		ret = PTR_ERR(cq);
 		goto err_file;
@@ -1465,10 +1002,6 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 	atomic_set(&cq->usecnt, 0);
 
 	obj->uobject.object = cq;
-	ret = idr_add_uobj(&obj->uobject);
-	if (ret)
-		goto err_free;
-
 	memset(&resp, 0, sizeof resp);
 	resp.base.cq_handle = obj->uobject.id;
 	resp.base.cqe       = cq->cqe;
@@ -1480,32 +1013,19 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 	if (ret)
 		goto err_cb;
 
-	mutex_lock(&file->mutex);
-	list_add_tail(&obj->uobject.list, &file->ucontext->cq_list);
-	mutex_unlock(&file->mutex);
-
-	obj->uobject.live = 1;
-
-	up_write(&obj->uobject.mutex);
+	uobj_alloc_commit(&obj->uobject);
 
 	return obj;
 
 err_cb:
-	idr_remove_uobj(&obj->uobject);
-
-err_free:
 	ib_destroy_cq(cq);
 
 err_file:
-	ib_rdmacg_uncharge(&obj->uobject.cg_obj, ib_dev,
-			   RDMACG_RESOURCE_HCA_OBJECT);
-
-err_charge:
 	if (ev_file)
 		ib_uverbs_release_ucq(file, ev_file, obj);
 
 err:
-	put_uobj_write(&obj->uobject);
+	uobj_alloc_abort(&obj->uobject);
 
 	return ERR_PTR(ret);
 }
@@ -1628,7 +1148,7 @@ ssize_t ib_uverbs_resize_cq(struct ib_uverbs_file *file,
 		   (unsigned long) cmd.response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
-	cq = idr_read_cq(cmd.cq_handle, file->ucontext, 0);
+	cq = uobj_get_obj_read(cq, cmd.cq_handle, file->ucontext);
 	if (!cq)
 		return -EINVAL;
 
@@ -1643,7 +1163,7 @@ ssize_t ib_uverbs_resize_cq(struct ib_uverbs_file *file,
 		ret = -EFAULT;
 
 out:
-	put_cq_read(cq);
+	uobj_put_obj_read(cq);
 
 	return ret ? ret : in_len;
 }
@@ -1690,7 +1210,7 @@ ssize_t ib_uverbs_poll_cq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	cq = idr_read_cq(cmd.cq_handle, file->ucontext, 0);
+	cq = uobj_get_obj_read(cq, cmd.cq_handle, file->ucontext);
 	if (!cq)
 		return -EINVAL;
 
@@ -1722,7 +1242,7 @@ ssize_t ib_uverbs_poll_cq(struct ib_uverbs_file *file,
 	ret = in_len;
 
 out_put:
-	put_cq_read(cq);
+	uobj_put_obj_read(cq);
 	return ret;
 }
 
@@ -1737,14 +1257,14 @@ ssize_t ib_uverbs_req_notify_cq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	cq = idr_read_cq(cmd.cq_handle, file->ucontext, 0);
+	cq = uobj_get_obj_read(cq, cmd.cq_handle, file->ucontext);
 	if (!cq)
 		return -EINVAL;
 
 	ib_req_notify_cq(cq, cmd.solicited_only ?
 			 IB_CQ_SOLICITED : IB_CQ_NEXT_COMP);
 
-	put_cq_read(cq);
+	uobj_put_obj_read(cq);
 
 	return in_len;
 }
@@ -1765,37 +1285,32 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(cmd.cq_handle, file->ucontext);
-	if (!uobj)
-		return -EINVAL;
+	uobj  = uobj_get_write(uobj_get_type(cq), cmd.cq_handle,
+			       file->ucontext);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
+
+	/*
+	 * Make sure we don't free the memory in remove_commit as we still
+	 * needs the uobject memory to create the response.
+	 */
+	uverbs_uobject_get(uobj);
 	cq      = uobj->object;
 	ev_file = cq->cq_context;
 	obj     = container_of(cq->uobject, struct ib_ucq_object, uobject);
 
-	ret = ib_destroy_cq(cq);
-	if (!ret)
-		uobj->live = 0;
-
-	put_uobj_write(uobj);
+	memset(&resp, 0, sizeof(resp));
 
-	if (ret)
+	ret = uobj_remove_commit(uobj);
+	if (ret) {
+		uverbs_uobject_put(uobj);
 		return ret;
+	}
 
-	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_RESOURCE_HCA_OBJECT);
-	idr_remove_uobj(uobj);
-
-	mutex_lock(&file->mutex);
-	list_del(&uobj->list);
-	mutex_unlock(&file->mutex);
-
-	ib_uverbs_release_ucq(file, ev_file, obj);
-
-	memset(&resp, 0, sizeof resp);
 	resp.comp_events_reported  = obj->comp_events_reported;
 	resp.async_events_reported = obj->async_events_reported;
 
-	put_uobj(uobj);
-
+	uverbs_uobject_put(uobj);
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp))
 		return -EFAULT;
@@ -1817,7 +1332,7 @@ static int create_qp(struct ib_uverbs_file *file,
 	struct ib_device		*device;
 	struct ib_pd			*pd = NULL;
 	struct ib_xrcd			*xrcd = NULL;
-	struct ib_uobject		*uninitialized_var(xrcd_uobj);
+	struct ib_uobject		*xrcd_uobj = ERR_PTR(-ENOENT);
 	struct ib_cq			*scq = NULL, *rcq = NULL;
 	struct ib_srq			*srq = NULL;
 	struct ib_qp			*qp;
@@ -1831,18 +1346,19 @@ static int create_qp(struct ib_uverbs_file *file,
 	if (cmd->qp_type == IB_QPT_RAW_PACKET && !capable(CAP_NET_RAW))
 		return -EPERM;
 
-	obj = kzalloc(sizeof *obj, GFP_KERNEL);
-	if (!obj)
-		return -ENOMEM;
+	obj  = (struct ib_uqp_object *)uobj_alloc(uobj_get_type(qp),
+						  file->ucontext);
+	if (IS_ERR(obj))
+		return PTR_ERR(obj);
+	obj->uxrcd = NULL;
+	obj->uevent.uobject.user_handle = cmd->user_handle;
 
-	init_uobj(&obj->uevent.uobject, cmd->user_handle, file->ucontext,
-		  &qp_lock_class);
-	down_write(&obj->uevent.uobject.mutex);
 	if (cmd_sz >= offsetof(typeof(*cmd), rwq_ind_tbl_handle) +
 		      sizeof(cmd->rwq_ind_tbl_handle) &&
 		      (cmd->comp_mask & IB_UVERBS_CREATE_QP_MASK_IND_TABLE)) {
-		ind_tbl = idr_read_rwq_indirection_table(cmd->rwq_ind_tbl_handle,
-							 file->ucontext);
+		ind_tbl = uobj_get_obj_read(rwq_ind_table,
+					    cmd->rwq_ind_tbl_handle,
+					    file->ucontext);
 		if (!ind_tbl) {
 			ret = -EINVAL;
 			goto err_put;
@@ -1866,8 +1382,15 @@ static int create_qp(struct ib_uverbs_file *file,
 		has_sq = false;
 
 	if (cmd->qp_type == IB_QPT_XRC_TGT) {
-		xrcd = idr_read_xrcd(cmd->pd_handle, file->ucontext,
-				     &xrcd_uobj);
+		xrcd_uobj = uobj_get_read(uobj_get_type(xrcd), cmd->pd_handle,
+					  file->ucontext);
+
+		if (IS_ERR(xrcd_uobj)) {
+			ret = -EINVAL;
+			goto err_put;
+		}
+
+		xrcd = (struct ib_xrcd *)xrcd_uobj->object;
 		if (!xrcd) {
 			ret = -EINVAL;
 			goto err_put;
@@ -1879,8 +1402,8 @@ static int create_qp(struct ib_uverbs_file *file,
 			cmd->max_recv_sge = 0;
 		} else {
 			if (cmd->is_srq) {
-				srq = idr_read_srq(cmd->srq_handle,
-						   file->ucontext);
+				srq = uobj_get_obj_read(srq, cmd->srq_handle,
+							file->ucontext);
 				if (!srq || srq->srq_type != IB_SRQT_BASIC) {
 					ret = -EINVAL;
 					goto err_put;
@@ -1889,8 +1412,8 @@ static int create_qp(struct ib_uverbs_file *file,
 
 			if (!ind_tbl) {
 				if (cmd->recv_cq_handle != cmd->send_cq_handle) {
-					rcq = idr_read_cq(cmd->recv_cq_handle,
-							  file->ucontext, 0);
+					rcq = uobj_get_obj_read(cq, cmd->recv_cq_handle,
+								file->ucontext);
 					if (!rcq) {
 						ret = -EINVAL;
 						goto err_put;
@@ -1900,10 +1423,11 @@ static int create_qp(struct ib_uverbs_file *file,
 		}
 
 		if (has_sq)
-			scq = idr_read_cq(cmd->send_cq_handle, file->ucontext, !!rcq);
+			scq = uobj_get_obj_read(cq, cmd->send_cq_handle,
+						file->ucontext);
 		if (!ind_tbl)
 			rcq = rcq ?: scq;
-		pd  = idr_read_pd(cmd->pd_handle, file->ucontext);
+		pd  = uobj_get_obj_read(pd, cmd->pd_handle, file->ucontext);
 		if (!pd || (!scq && has_sq)) {
 			ret = -EINVAL;
 			goto err_put;
@@ -1955,11 +1479,6 @@ static int create_qp(struct ib_uverbs_file *file,
 			goto err_put;
 		}
 
-	ret = ib_rdmacg_try_charge(&obj->uevent.uobject.cg_obj, device,
-				   RDMACG_RESOURCE_HCA_OBJECT);
-	if (ret)
-		goto err_put;
-
 	if (cmd->qp_type == IB_QPT_XRC_TGT)
 		qp = ib_create_qp(pd, &attr);
 	else
@@ -1967,7 +1486,7 @@ static int create_qp(struct ib_uverbs_file *file,
 
 	if (IS_ERR(qp)) {
 		ret = PTR_ERR(qp);
-		goto err_create;
+		goto err_put;
 	}
 
 	if (cmd->qp_type != IB_QPT_XRC_TGT) {
@@ -1995,9 +1514,6 @@ static int create_qp(struct ib_uverbs_file *file,
 	qp->uobject = &obj->uevent.uobject;
 
 	obj->uevent.uobject.object = qp;
-	ret = idr_add_uobj(&obj->uevent.uobject);
-	if (ret)
-		goto err_destroy;
 
 	memset(&resp, 0, sizeof resp);
 	resp.base.qpn             = qp->qp_num;
@@ -2019,54 +1535,41 @@ static int create_qp(struct ib_uverbs_file *file,
 		obj->uxrcd = container_of(xrcd_uobj, struct ib_uxrcd_object,
 					  uobject);
 		atomic_inc(&obj->uxrcd->refcnt);
-		put_xrcd_read(xrcd_uobj);
+		uobj_put_read(xrcd_uobj);
 	}
 
 	if (pd)
-		put_pd_read(pd);
+		uobj_put_obj_read(pd);
 	if (scq)
-		put_cq_read(scq);
+		uobj_put_obj_read(scq);
 	if (rcq && rcq != scq)
-		put_cq_read(rcq);
+		uobj_put_obj_read(rcq);
 	if (srq)
-		put_srq_read(srq);
+		uobj_put_obj_read(srq);
 	if (ind_tbl)
-		put_rwq_indirection_table_read(ind_tbl);
-
-	mutex_lock(&file->mutex);
-	list_add_tail(&obj->uevent.uobject.list, &file->ucontext->qp_list);
-	mutex_unlock(&file->mutex);
-
-	obj->uevent.uobject.live = 1;
+		uobj_put_obj_read(ind_tbl);
 
-	up_write(&obj->uevent.uobject.mutex);
+	uobj_alloc_commit(&obj->uevent.uobject);
 
 	return 0;
 err_cb:
-	idr_remove_uobj(&obj->uevent.uobject);
-
-err_destroy:
 	ib_destroy_qp(qp);
 
-err_create:
-	ib_rdmacg_uncharge(&obj->uevent.uobject.cg_obj, device,
-			   RDMACG_RESOURCE_HCA_OBJECT);
-
 err_put:
-	if (xrcd)
-		put_xrcd_read(xrcd_uobj);
+	if (!IS_ERR(xrcd_uobj))
+		uobj_put_read(xrcd_uobj);
 	if (pd)
-		put_pd_read(pd);
+		uobj_put_obj_read(pd);
 	if (scq)
-		put_cq_read(scq);
+		uobj_put_obj_read(scq);
 	if (rcq && rcq != scq)
-		put_cq_read(rcq);
+		uobj_put_obj_read(rcq);
 	if (srq)
-		put_srq_read(srq);
+		uobj_put_obj_read(srq);
 	if (ind_tbl)
-		put_rwq_indirection_table_read(ind_tbl);
+		uobj_put_obj_read(ind_tbl);
 
-	put_uobj_write(&obj->uevent.uobject);
+	uobj_alloc_abort(&obj->uevent.uobject);
 	return ret;
 }
 
@@ -2202,17 +1705,22 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
 		   (unsigned long) cmd.response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
-	obj = kmalloc(sizeof *obj, GFP_KERNEL);
-	if (!obj)
-		return -ENOMEM;
+	obj  = (struct ib_uqp_object *)uobj_alloc(uobj_get_type(qp),
+						  file->ucontext);
+	if (IS_ERR(obj))
+		return PTR_ERR(obj);
 
-	init_uobj(&obj->uevent.uobject, cmd.user_handle, file->ucontext, &qp_lock_class);
-	down_write(&obj->uevent.uobject.mutex);
+	xrcd_uobj = uobj_get_read(uobj_get_type(xrcd), cmd.pd_handle,
+				  file->ucontext);
+	if (IS_ERR(xrcd_uobj)) {
+		ret = -EINVAL;
+		goto err_put;
+	}
 
-	xrcd = idr_read_xrcd(cmd.pd_handle, file->ucontext, &xrcd_uobj);
+	xrcd = (struct ib_xrcd *)xrcd_uobj->object;
 	if (!xrcd) {
 		ret = -EINVAL;
-		goto err_put;
+		goto err_xrcd;
 	}
 
 	attr.event_handler = ib_uverbs_qp_event_handler;
@@ -2227,15 +1735,11 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
 	qp = ib_open_qp(xrcd, &attr);
 	if (IS_ERR(qp)) {
 		ret = PTR_ERR(qp);
-		goto err_put;
+		goto err_xrcd;
 	}
 
-	qp->uobject = &obj->uevent.uobject;
-
 	obj->uevent.uobject.object = qp;
-	ret = idr_add_uobj(&obj->uevent.uobject);
-	if (ret)
-		goto err_destroy;
+	obj->uevent.uobject.user_handle = cmd.user_handle;
 
 	memset(&resp, 0, sizeof resp);
 	resp.qpn       = qp->qp_num;
@@ -2244,32 +1748,25 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp)) {
 		ret = -EFAULT;
-		goto err_remove;
+		goto err_destroy;
 	}
 
 	obj->uxrcd = container_of(xrcd_uobj, struct ib_uxrcd_object, uobject);
 	atomic_inc(&obj->uxrcd->refcnt);
-	put_xrcd_read(xrcd_uobj);
-
-	mutex_lock(&file->mutex);
-	list_add_tail(&obj->uevent.uobject.list, &file->ucontext->qp_list);
-	mutex_unlock(&file->mutex);
+	qp->uobject = &obj->uevent.uobject;
+	uobj_put_read(xrcd_uobj);
 
-	obj->uevent.uobject.live = 1;
 
-	up_write(&obj->uevent.uobject.mutex);
+	uobj_alloc_commit(&obj->uevent.uobject);
 
 	return in_len;
 
-err_remove:
-	idr_remove_uobj(&obj->uevent.uobject);
-
 err_destroy:
 	ib_destroy_qp(qp);
-
+err_xrcd:
+	uobj_put_read(xrcd_uobj);
 err_put:
-	put_xrcd_read(xrcd_uobj);
-	put_uobj_write(&obj->uevent.uobject);
+	uobj_alloc_abort(&obj->uevent.uobject);
 	return ret;
 }
 
@@ -2295,7 +1792,7 @@ ssize_t ib_uverbs_query_qp(struct ib_uverbs_file *file,
 		goto out;
 	}
 
-	qp = idr_read_qp(cmd.qp_handle, file->ucontext);
+	qp = uobj_get_obj_read(qp, cmd.qp_handle, file->ucontext);
 	if (!qp) {
 		ret = -EINVAL;
 		goto out;
@@ -2303,7 +1800,7 @@ ssize_t ib_uverbs_query_qp(struct ib_uverbs_file *file,
 
 	ret = ib_query_qp(qp, attr, cmd.attr_mask, init_attr);
 
-	put_qp_read(qp);
+	uobj_put_obj_read(qp);
 
 	if (ret)
 		goto out;
@@ -2399,7 +1896,7 @@ static int modify_qp(struct ib_uverbs_file *file,
 	if (!attr)
 		return -ENOMEM;
 
-	qp = idr_read_qp(cmd->base.qp_handle, file->ucontext);
+	qp = uobj_get_obj_read(qp, cmd->base.qp_handle, file->ucontext);
 	if (!qp) {
 		ret = -EINVAL;
 		goto out;
@@ -2471,7 +1968,7 @@ static int modify_qp(struct ib_uverbs_file *file,
 	}
 
 release_qp:
-	put_qp_read(qp);
+	uobj_put_obj_read(qp);
 
 out:
 	kfree(attr);
@@ -2558,42 +2055,27 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 
 	memset(&resp, 0, sizeof resp);
 
-	uobj = idr_write_uobj(cmd.qp_handle, file->ucontext);
-	if (!uobj)
-		return -EINVAL;
+	uobj  = uobj_get_write(uobj_get_type(qp), cmd.qp_handle,
+			       file->ucontext);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
+
 	qp  = uobj->object;
 	obj = container_of(uobj, struct ib_uqp_object, uevent.uobject);
+	/*
+	 * Make sure we don't free the memory in remove_commit as we still
+	 * needs the uobject memory to create the response.
+	 */
+	uverbs_uobject_get(uobj);
 
-	if (!list_empty(&obj->mcast_list)) {
-		put_uobj_write(uobj);
-		return -EBUSY;
-	}
-
-	ret = ib_destroy_qp(qp);
-	if (!ret)
-		uobj->live = 0;
-
-	put_uobj_write(uobj);
-
-	if (ret)
+	ret = uobj_remove_commit(uobj);
+	if (ret) {
+		uverbs_uobject_put(uobj);
 		return ret;
-
-	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_RESOURCE_HCA_OBJECT);
-
-	if (obj->uxrcd)
-		atomic_dec(&obj->uxrcd->refcnt);
-
-	idr_remove_uobj(uobj);
-
-	mutex_lock(&file->mutex);
-	list_del(&uobj->list);
-	mutex_unlock(&file->mutex);
-
-	ib_uverbs_release_uevent(file, &obj->uevent);
+	}
 
 	resp.events_reported = obj->uevent.events_reported;
-
-	put_uobj(uobj);
+	uverbs_uobject_put(uobj);
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp))
@@ -2637,7 +2119,7 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 	if (!user_wr)
 		return -ENOMEM;
 
-	qp = idr_read_qp(cmd.qp_handle, file->ucontext);
+	qp = uobj_get_obj_read(qp, cmd.qp_handle, file->ucontext);
 	if (!qp)
 		goto out;
 
@@ -2673,7 +2155,8 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 				goto out_put;
 			}
 
-			ud->ah = idr_read_ah(user_wr->wr.ud.ah, file->ucontext);
+			ud->ah = uobj_get_obj_read(ah, user_wr->wr.ud.ah,
+						   file->ucontext);
 			if (!ud->ah) {
 				kfree(ud);
 				ret = -EINVAL;
@@ -2780,11 +2263,11 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 		ret = -EFAULT;
 
 out_put:
-	put_qp_read(qp);
+	uobj_put_obj_read(qp);
 
 	while (wr) {
 		if (is_ud && ud_wr(wr)->ah)
-			put_ah_read(ud_wr(wr)->ah);
+			uobj_put_obj_read(ud_wr(wr)->ah);
 		next = wr->next;
 		kfree(wr);
 		wr = next;
@@ -2901,21 +2384,21 @@ ssize_t ib_uverbs_post_recv(struct ib_uverbs_file *file,
 	if (IS_ERR(wr))
 		return PTR_ERR(wr);
 
-	qp = idr_read_qp(cmd.qp_handle, file->ucontext);
+	qp = uobj_get_obj_read(qp, cmd.qp_handle, file->ucontext);
 	if (!qp)
 		goto out;
 
 	resp.bad_wr = 0;
 	ret = qp->device->post_recv(qp->real_qp, wr, &bad_wr);
 
-	put_qp_read(qp);
-
-	if (ret)
+	uobj_put_obj_read(qp);
+	if (ret) {
 		for (next = wr; next; next = next->next) {
 			++resp.bad_wr;
 			if (next == bad_wr)
 				break;
 		}
+	}
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp))
@@ -2951,14 +2434,14 @@ ssize_t ib_uverbs_post_srq_recv(struct ib_uverbs_file *file,
 	if (IS_ERR(wr))
 		return PTR_ERR(wr);
 
-	srq = idr_read_srq(cmd.srq_handle, file->ucontext);
+	srq = uobj_get_obj_read(srq, cmd.srq_handle, file->ucontext);
 	if (!srq)
 		goto out;
 
 	resp.bad_wr = 0;
 	ret = srq->device->post_srq_recv(srq, wr, &bad_wr);
 
-	put_srq_read(srq);
+	uobj_put_obj_read(srq);
 
 	if (ret)
 		for (next = wr; next; next = next->next) {
@@ -3005,14 +2488,11 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 		   (unsigned long)cmd.response + sizeof(resp),
 		   in_len - sizeof(cmd), out_len - sizeof(resp));
 
-	uobj = kmalloc(sizeof *uobj, GFP_KERNEL);
-	if (!uobj)
-		return -ENOMEM;
-
-	init_uobj(uobj, cmd.user_handle, file->ucontext, &ah_lock_class);
-	down_write(&uobj->mutex);
+	uobj  = uobj_alloc(uobj_get_type(ah), file->ucontext);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
 
-	pd = idr_read_pd(cmd.pd_handle, file->ucontext);
+	pd = uobj_get_obj_read(pd, cmd.pd_handle, file->ucontext);
 	if (!pd) {
 		ret = -EINVAL;
 		goto err;
@@ -3031,28 +2511,20 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	memset(&attr.dmac, 0, sizeof(attr.dmac));
 	memcpy(attr.grh.dgid.raw, cmd.attr.grh.dgid, 16);
 
-	ret = ib_rdmacg_try_charge(&uobj->cg_obj, ib_dev,
-				   RDMACG_RESOURCE_HCA_OBJECT);
-	if (ret)
-		goto err_charge;
-
 	ah = pd->device->create_ah(pd, &attr, &udata);
 
 	if (IS_ERR(ah)) {
 		ret = PTR_ERR(ah);
-		goto err_create;
+		goto err_put;
 	}
 
 	ah->device  = pd->device;
 	ah->pd      = pd;
 	atomic_inc(&pd->usecnt);
 	ah->uobject  = uobj;
+	uobj->user_handle = cmd.user_handle;
 	uobj->object = ah;
 
-	ret = idr_add_uobj(uobj);
-	if (ret)
-		goto err_destroy;
-
 	resp.ah_handle = uobj->id;
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
@@ -3061,32 +2533,19 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 		goto err_copy;
 	}
 
-	put_pd_read(pd);
-
-	mutex_lock(&file->mutex);
-	list_add_tail(&uobj->list, &file->ucontext->ah_list);
-	mutex_unlock(&file->mutex);
-
-	uobj->live = 1;
-
-	up_write(&uobj->mutex);
+	uobj_put_obj_read(pd);
+	uobj_alloc_commit(uobj);
 
 	return in_len;
 
 err_copy:
-	idr_remove_uobj(uobj);
-
-err_destroy:
 	ib_destroy_ah(ah);
 
-err_create:
-	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_RESOURCE_HCA_OBJECT);
-
-err_charge:
-	put_pd_read(pd);
+err_put:
+	uobj_put_obj_read(pd);
 
 err:
-	put_uobj_write(uobj);
+	uobj_alloc_abort(uobj);
 	return ret;
 }
 
@@ -3095,37 +2554,19 @@ ssize_t ib_uverbs_destroy_ah(struct ib_uverbs_file *file,
 			     const char __user *buf, int in_len, int out_len)
 {
 	struct ib_uverbs_destroy_ah cmd;
-	struct ib_ah		   *ah;
 	struct ib_uobject	   *uobj;
 	int			    ret;
 
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(cmd.ah_handle, file->ucontext);
-	if (!uobj)
-		return -EINVAL;
-	ah = uobj->object;
-
-	ret = ib_destroy_ah(ah);
-	if (!ret)
-		uobj->live = 0;
-
-	put_uobj_write(uobj);
-
-	if (ret)
-		return ret;
-
-	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_RESOURCE_HCA_OBJECT);
-	idr_remove_uobj(uobj);
-
-	mutex_lock(&file->mutex);
-	list_del(&uobj->list);
-	mutex_unlock(&file->mutex);
+	uobj  = uobj_get_write(uobj_get_type(ah), cmd.ah_handle,
+			       file->ucontext);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
 
-	put_uobj(uobj);
-
-	return in_len;
+	ret = uobj_remove_commit(uobj);
+	return ret ?: in_len;
 }
 
 ssize_t ib_uverbs_attach_mcast(struct ib_uverbs_file *file,
@@ -3142,7 +2583,7 @@ ssize_t ib_uverbs_attach_mcast(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	qp = idr_write_qp(cmd.qp_handle, file->ucontext);
+	qp = uobj_get_obj_read(qp, cmd.qp_handle, file->ucontext);
 	if (!qp)
 		return -EINVAL;
 
@@ -3171,7 +2612,7 @@ ssize_t ib_uverbs_attach_mcast(struct ib_uverbs_file *file,
 		kfree(mcast);
 
 out_put:
-	put_qp_write(qp);
+	uobj_put_obj_read(qp);
 
 	return ret ? ret : in_len;
 }
@@ -3190,16 +2631,16 @@ ssize_t ib_uverbs_detach_mcast(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	qp = idr_write_qp(cmd.qp_handle, file->ucontext);
+	qp = uobj_get_obj_read(qp, cmd.qp_handle, file->ucontext);
 	if (!qp)
 		return -EINVAL;
 
+	obj = container_of(qp->uobject, struct ib_uqp_object, uevent.uobject);
+
 	ret = ib_detach_mcast(qp, (union ib_gid *) cmd.gid, cmd.mlid);
 	if (ret)
 		goto out_put;
 
-	obj = container_of(qp->uobject, struct ib_uqp_object, uevent.uobject);
-
 	list_for_each_entry(mcast, &obj->mcast_list, list)
 		if (cmd.mlid == mcast->lid &&
 		    !memcmp(cmd.gid, mcast->gid.raw, sizeof mcast->gid.raw)) {
@@ -3209,8 +2650,7 @@ ssize_t ib_uverbs_detach_mcast(struct ib_uverbs_file *file,
 		}
 
 out_put:
-	put_qp_write(qp);
-
+	uobj_put_obj_read(qp);
 	return ret ? ret : in_len;
 }
 
@@ -3402,20 +2842,18 @@ int ib_uverbs_ex_create_wq(struct ib_uverbs_file *file,
 	if (cmd.comp_mask)
 		return -EOPNOTSUPP;
 
-	obj = kmalloc(sizeof(*obj), GFP_KERNEL);
-	if (!obj)
-		return -ENOMEM;
+	obj  = (struct ib_uwq_object *)uobj_alloc(uobj_get_type(wq),
+						  file->ucontext);
+	if (IS_ERR(obj))
+		return PTR_ERR(obj);
 
-	init_uobj(&obj->uevent.uobject, cmd.user_handle, file->ucontext,
-		  &wq_lock_class);
-	down_write(&obj->uevent.uobject.mutex);
-	pd  = idr_read_pd(cmd.pd_handle, file->ucontext);
+	pd  = uobj_get_obj_read(pd, cmd.pd_handle, file->ucontext);
 	if (!pd) {
 		err = -EINVAL;
 		goto err_uobj;
 	}
 
-	cq = idr_read_cq(cmd.cq_handle, file->ucontext, 0);
+	cq = uobj_get_obj_read(cq, cmd.cq_handle, file->ucontext);
 	if (!cq) {
 		err = -EINVAL;
 		goto err_put_pd;
@@ -3450,9 +2888,6 @@ int ib_uverbs_ex_create_wq(struct ib_uverbs_file *file,
 	atomic_inc(&cq->usecnt);
 	wq->uobject = &obj->uevent.uobject;
 	obj->uevent.uobject.object = wq;
-	err = idr_add_uobj(&obj->uevent.uobject);
-	if (err)
-		goto destroy_wq;
 
 	memset(&resp, 0, sizeof(resp));
 	resp.wq_handle = obj->uevent.uobject.id;
@@ -3465,27 +2900,19 @@ int ib_uverbs_ex_create_wq(struct ib_uverbs_file *file,
 	if (err)
 		goto err_copy;
 
-	put_pd_read(pd);
-	put_cq_read(cq);
-
-	mutex_lock(&file->mutex);
-	list_add_tail(&obj->uevent.uobject.list, &file->ucontext->wq_list);
-	mutex_unlock(&file->mutex);
-
-	obj->uevent.uobject.live = 1;
-	up_write(&obj->uevent.uobject.mutex);
+	uobj_put_obj_read(pd);
+	uobj_put_obj_read(cq);
+	uobj_alloc_commit(&obj->uevent.uobject);
 	return 0;
 
 err_copy:
-	idr_remove_uobj(&obj->uevent.uobject);
-destroy_wq:
 	ib_destroy_wq(wq);
 err_put_cq:
-	put_cq_read(cq);
+	uobj_put_obj_read(cq);
 err_put_pd:
-	put_pd_read(pd);
+	uobj_put_obj_read(pd);
 err_uobj:
-	put_uobj_write(&obj->uevent.uobject);
+	uobj_alloc_abort(&obj->uevent.uobject);
 
 	return err;
 }
@@ -3526,31 +2953,27 @@ int ib_uverbs_ex_destroy_wq(struct ib_uverbs_file *file,
 		return -EOPNOTSUPP;
 
 	resp.response_length = required_resp_len;
-	uobj = idr_write_uobj(cmd.wq_handle,
-			      file->ucontext);
-	if (!uobj)
-		return -EINVAL;
+	uobj  = uobj_get_write(uobj_get_type(wq), cmd.wq_handle,
+			       file->ucontext);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
 
 	wq = uobj->object;
 	obj = container_of(uobj, struct ib_uwq_object, uevent.uobject);
-	ret = ib_destroy_wq(wq);
-	if (!ret)
-		uobj->live = 0;
+	/*
+	 * Make sure we don't free the memory in remove_commit as we still
+	 * needs the uobject memory to create the response.
+	 */
+	uverbs_uobject_get(uobj);
 
-	put_uobj_write(uobj);
-	if (ret)
+	ret = uobj_remove_commit(uobj);
+	if (ret) {
+		uverbs_uobject_put(uobj);
 		return ret;
+	}
 
-	idr_remove_uobj(uobj);
-
-	mutex_lock(&file->mutex);
-	list_del(&uobj->list);
-	mutex_unlock(&file->mutex);
-
-	ib_uverbs_release_uevent(file, &obj->uevent);
 	resp.events_reported = obj->uevent.events_reported;
-	put_uobj(uobj);
-
+	uverbs_uobject_put(uobj);
 	ret = ib_copy_to_udata(ucore, &resp, resp.response_length);
 	if (ret)
 		return ret;
@@ -3588,7 +3011,7 @@ int ib_uverbs_ex_modify_wq(struct ib_uverbs_file *file,
 	if (cmd.attr_mask > (IB_WQ_STATE | IB_WQ_CUR_STATE | IB_WQ_FLAGS))
 		return -EINVAL;
 
-	wq = idr_read_wq(cmd.wq_handle, file->ucontext);
+	wq = uobj_get_obj_read(wq, cmd.wq_handle, file->ucontext);
 	if (!wq)
 		return -EINVAL;
 
@@ -3599,7 +3022,7 @@ int ib_uverbs_ex_modify_wq(struct ib_uverbs_file *file,
 		wq_attr.flags_mask = cmd.flags_mask;
 	}
 	ret = wq->device->modify_wq(wq, &wq_attr, cmd.attr_mask, uhw);
-	put_wq_read(wq);
+	uobj_put_obj_read(wq);
 	return ret;
 }
 
@@ -3677,7 +3100,8 @@ int ib_uverbs_ex_create_rwq_ind_table(struct ib_uverbs_file *file,
 
 	for (num_read_wqs = 0; num_read_wqs < num_wq_handles;
 			num_read_wqs++) {
-		wq = idr_read_wq(wqs_handles[num_read_wqs], file->ucontext);
+		wq = uobj_get_obj_read(wq, wqs_handles[num_read_wqs],
+				       file->ucontext);
 		if (!wq) {
 			err = -EINVAL;
 			goto put_wqs;
@@ -3686,14 +3110,12 @@ int ib_uverbs_ex_create_rwq_ind_table(struct ib_uverbs_file *file,
 		wqs[num_read_wqs] = wq;
 	}
 
-	uobj = kmalloc(sizeof(*uobj), GFP_KERNEL);
-	if (!uobj) {
-		err = -ENOMEM;
+	uobj  = uobj_alloc(uobj_get_type(rwq_ind_table), file->ucontext);
+	if (IS_ERR(uobj)) {
+		err = PTR_ERR(uobj);
 		goto put_wqs;
 	}
 
-	init_uobj(uobj, 0, file->ucontext, &rwq_ind_table_lock_class);
-	down_write(&uobj->mutex);
 	init_attr.log_ind_tbl_size = cmd.log_ind_tbl_size;
 	init_attr.ind_tbl = wqs;
 	rwq_ind_tbl = ib_dev->create_rwq_ind_table(ib_dev, &init_attr, uhw);
@@ -3713,10 +3135,6 @@ int ib_uverbs_ex_create_rwq_ind_table(struct ib_uverbs_file *file,
 	for (i = 0; i < num_wq_handles; i++)
 		atomic_inc(&wqs[i]->usecnt);
 
-	err = idr_add_uobj(uobj);
-	if (err)
-		goto destroy_ind_tbl;
-
 	resp.ind_tbl_handle = uobj->id;
 	resp.ind_tbl_num = rwq_ind_tbl->ind_tbl_num;
 	resp.response_length = required_resp_len;
@@ -3729,26 +3147,18 @@ int ib_uverbs_ex_create_rwq_ind_table(struct ib_uverbs_file *file,
 	kfree(wqs_handles);
 
 	for (j = 0; j < num_read_wqs; j++)
-		put_wq_read(wqs[j]);
-
-	mutex_lock(&file->mutex);
-	list_add_tail(&uobj->list, &file->ucontext->rwq_ind_tbl_list);
-	mutex_unlock(&file->mutex);
+		uobj_put_obj_read(wqs[j]);
 
-	uobj->live = 1;
-
-	up_write(&uobj->mutex);
+	uobj_alloc_commit(uobj);
 	return 0;
 
 err_copy:
-	idr_remove_uobj(uobj);
-destroy_ind_tbl:
 	ib_destroy_rwq_ind_table(rwq_ind_tbl);
 err_uobj:
-	put_uobj_write(uobj);
+	uobj_alloc_abort(uobj);
 put_wqs:
 	for (j = 0; j < num_read_wqs; j++)
-		put_wq_read(wqs[j]);
+		uobj_put_obj_read(wqs[j]);
 err_free:
 	kfree(wqs_handles);
 	kfree(wqs);
@@ -3761,10 +3171,8 @@ int ib_uverbs_ex_destroy_rwq_ind_table(struct ib_uverbs_file *file,
 				       struct ib_udata *uhw)
 {
 	struct ib_uverbs_ex_destroy_rwq_ind_table	cmd = {};
-	struct ib_rwq_ind_table *rwq_ind_tbl;
 	struct ib_uobject		*uobj;
 	int			ret;
-	struct ib_wq	**ind_tbl;
 	size_t required_cmd_sz;
 
 	required_cmd_sz = offsetof(typeof(cmd), ind_tbl_handle) + sizeof(cmd.ind_tbl_handle);
@@ -3784,31 +3192,12 @@ int ib_uverbs_ex_destroy_rwq_ind_table(struct ib_uverbs_file *file,
 	if (cmd.comp_mask)
 		return -EOPNOTSUPP;
 
-	uobj = idr_write_uobj(cmd.ind_tbl_handle,
-			      file->ucontext);
-	if (!uobj)
-		return -EINVAL;
-	rwq_ind_tbl = uobj->object;
-	ind_tbl = rwq_ind_tbl->ind_tbl;
-
-	ret = ib_destroy_rwq_ind_table(rwq_ind_tbl);
-	if (!ret)
-		uobj->live = 0;
-
-	put_uobj_write(uobj);
-
-	if (ret)
-		return ret;
-
-	idr_remove_uobj(uobj);
-
-	mutex_lock(&file->mutex);
-	list_del(&uobj->list);
-	mutex_unlock(&file->mutex);
+	uobj  = uobj_get_write(uobj_get_type(rwq_ind_table), cmd.ind_tbl_handle,
+			       file->ucontext);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
 
-	put_uobj(uobj);
-	kfree(ind_tbl);
-	return ret;
+	return uobj_remove_commit(uobj);
 }
 
 int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
@@ -3882,15 +3271,13 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 		kern_flow_attr = &cmd.flow_attr;
 	}
 
-	uobj = kmalloc(sizeof(*uobj), GFP_KERNEL);
-	if (!uobj) {
-		err = -ENOMEM;
+	uobj  = uobj_alloc(uobj_get_type(flow), file->ucontext);
+	if (IS_ERR(uobj)) {
+		err = PTR_ERR(uobj);
 		goto err_free_attr;
 	}
-	init_uobj(uobj, 0, file->ucontext, &rule_lock_class);
-	down_write(&uobj->mutex);
 
-	qp = idr_read_qp(cmd.qp_handle, file->ucontext);
+	qp = uobj_get_obj_read(qp, cmd.qp_handle, file->ucontext);
 	if (!qp) {
 		err = -EINVAL;
 		goto err_uobj;
@@ -3931,24 +3318,14 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 		err = -EINVAL;
 		goto err_free;
 	}
-
-	err = ib_rdmacg_try_charge(&uobj->cg_obj, ib_dev,
-				   RDMACG_RESOURCE_HCA_OBJECT);
-	if (err)
-		goto err_free;
-
 	flow_id = ib_create_flow(qp, flow_attr, IB_FLOW_DOMAIN_USER);
 	if (IS_ERR(flow_id)) {
 		err = PTR_ERR(flow_id);
-		goto err_create;
+		goto err_free;
 	}
 	flow_id->uobject = uobj;
 	uobj->object = flow_id;
 
-	err = idr_add_uobj(uobj);
-	if (err)
-		goto destroy_flow;
-
 	memset(&resp, 0, sizeof(resp));
 	resp.flow_handle = uobj->id;
 
@@ -3957,30 +3334,20 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 	if (err)
 		goto err_copy;
 
-	put_qp_read(qp);
-	mutex_lock(&file->mutex);
-	list_add_tail(&uobj->list, &file->ucontext->rule_list);
-	mutex_unlock(&file->mutex);
-
-	uobj->live = 1;
-
-	up_write(&uobj->mutex);
+	uobj_put_obj_read(qp);
+	uobj_alloc_commit(uobj);
 	kfree(flow_attr);
 	if (cmd.flow_attr.num_of_specs)
 		kfree(kern_flow_attr);
 	return 0;
 err_copy:
-	idr_remove_uobj(uobj);
-destroy_flow:
 	ib_destroy_flow(flow_id);
-err_create:
-	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_RESOURCE_HCA_OBJECT);
 err_free:
 	kfree(flow_attr);
 err_put:
-	put_qp_read(qp);
+	uobj_put_obj_read(qp);
 err_uobj:
-	put_uobj_write(uobj);
+	uobj_alloc_abort(uobj);
 err_free_attr:
 	if (cmd.flow_attr.num_of_specs)
 		kfree(kern_flow_attr);
@@ -3993,7 +3360,6 @@ int ib_uverbs_ex_destroy_flow(struct ib_uverbs_file *file,
 			      struct ib_udata *uhw)
 {
 	struct ib_uverbs_destroy_flow	cmd;
-	struct ib_flow			*flow_id;
 	struct ib_uobject		*uobj;
 	int				ret;
 
@@ -4007,28 +3373,12 @@ int ib_uverbs_ex_destroy_flow(struct ib_uverbs_file *file,
 	if (cmd.comp_mask)
 		return -EINVAL;
 
-	uobj = idr_write_uobj(cmd.flow_handle, file->ucontext);
-	if (!uobj)
-		return -EINVAL;
-	flow_id = uobj->object;
-
-	ret = ib_destroy_flow(flow_id);
-	if (!ret) {
-		ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev,
-				   RDMACG_RESOURCE_HCA_OBJECT);
-		uobj->live = 0;
-	}
-
-	put_uobj_write(uobj);
-
-	idr_remove_uobj(uobj);
-
-	mutex_lock(&file->mutex);
-	list_del(&uobj->list);
-	mutex_unlock(&file->mutex);
-
-	put_uobj(uobj);
+	uobj  = uobj_get_write(uobj_get_type(flow), cmd.flow_handle,
+			       file->ucontext);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
 
+	ret = uobj_remove_commit(uobj);
 	return ret;
 }
 
@@ -4045,31 +3395,37 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	struct ib_srq_init_attr          attr;
 	int ret;
 
-	obj = kmalloc(sizeof *obj, GFP_KERNEL);
-	if (!obj)
-		return -ENOMEM;
-
-	init_uobj(&obj->uevent.uobject, cmd->user_handle, file->ucontext, &srq_lock_class);
-	down_write(&obj->uevent.uobject.mutex);
+	obj  = (struct ib_usrq_object *)uobj_alloc(uobj_get_type(srq),
+						   file->ucontext);
+	if (IS_ERR(obj))
+		return PTR_ERR(obj);
 
 	if (cmd->srq_type == IB_SRQT_XRC) {
-		attr.ext.xrc.xrcd  = idr_read_xrcd(cmd->xrcd_handle, file->ucontext, &xrcd_uobj);
-		if (!attr.ext.xrc.xrcd) {
+		xrcd_uobj = uobj_get_read(uobj_get_type(xrcd), cmd->xrcd_handle,
+					  file->ucontext);
+		if (IS_ERR(xrcd_uobj)) {
 			ret = -EINVAL;
 			goto err;
 		}
 
+		attr.ext.xrc.xrcd = (struct ib_xrcd *)xrcd_uobj->object;
+		if (!attr.ext.xrc.xrcd) {
+			ret = -EINVAL;
+			goto err_put_xrcd;
+		}
+
 		obj->uxrcd = container_of(xrcd_uobj, struct ib_uxrcd_object, uobject);
 		atomic_inc(&obj->uxrcd->refcnt);
 
-		attr.ext.xrc.cq  = idr_read_cq(cmd->cq_handle, file->ucontext, 0);
+		attr.ext.xrc.cq  = uobj_get_obj_read(cq, cmd->cq_handle,
+						     file->ucontext);
 		if (!attr.ext.xrc.cq) {
 			ret = -EINVAL;
 			goto err_put_xrcd;
 		}
 	}
 
-	pd  = idr_read_pd(cmd->pd_handle, file->ucontext);
+	pd  = uobj_get_obj_read(pd, cmd->pd_handle, file->ucontext);
 	if (!pd) {
 		ret = -EINVAL;
 		goto err_put_cq;
@@ -4085,11 +3441,6 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	obj->uevent.events_reported = 0;
 	INIT_LIST_HEAD(&obj->uevent.event_list);
 
-	ret = ib_rdmacg_try_charge(&obj->uevent.uobject.cg_obj, ib_dev,
-				   RDMACG_RESOURCE_HCA_OBJECT);
-	if (ret)
-		goto err_put_cq;
-
 	srq = pd->device->create_srq(pd, &attr, udata);
 	if (IS_ERR(srq)) {
 		ret = PTR_ERR(srq);
@@ -4114,9 +3465,7 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	atomic_set(&srq->usecnt, 0);
 
 	obj->uevent.uobject.object = srq;
-	ret = idr_add_uobj(&obj->uevent.uobject);
-	if (ret)
-		goto err_destroy;
+	obj->uevent.uobject.user_handle = cmd->user_handle;
 
 	memset(&resp, 0, sizeof resp);
 	resp.srq_handle = obj->uevent.uobject.id;
@@ -4132,44 +3481,32 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	}
 
 	if (cmd->srq_type == IB_SRQT_XRC) {
-		put_uobj_read(xrcd_uobj);
-		put_cq_read(attr.ext.xrc.cq);
+		uobj_put_read(xrcd_uobj);
+		uobj_put_obj_read(attr.ext.xrc.cq);
 	}
-	put_pd_read(pd);
-
-	mutex_lock(&file->mutex);
-	list_add_tail(&obj->uevent.uobject.list, &file->ucontext->srq_list);
-	mutex_unlock(&file->mutex);
-
-	obj->uevent.uobject.live = 1;
-
-	up_write(&obj->uevent.uobject.mutex);
+	uobj_put_obj_read(pd);
+	uobj_alloc_commit(&obj->uevent.uobject);
 
 	return 0;
 
 err_copy:
-	idr_remove_uobj(&obj->uevent.uobject);
-
-err_destroy:
 	ib_destroy_srq(srq);
 
 err_put:
-	ib_rdmacg_uncharge(&obj->uevent.uobject.cg_obj, ib_dev,
-			   RDMACG_RESOURCE_HCA_OBJECT);
-	put_pd_read(pd);
+	uobj_put_obj_read(pd);
 
 err_put_cq:
 	if (cmd->srq_type == IB_SRQT_XRC)
-		put_cq_read(attr.ext.xrc.cq);
+		uobj_put_obj_read(attr.ext.xrc.cq);
 
 err_put_xrcd:
 	if (cmd->srq_type == IB_SRQT_XRC) {
 		atomic_dec(&obj->uxrcd->refcnt);
-		put_uobj_read(xrcd_uobj);
+		uobj_put_read(xrcd_uobj);
 	}
 
 err:
-	put_uobj_write(&obj->uevent.uobject);
+	uobj_alloc_abort(&obj->uevent.uobject);
 	return ret;
 }
 
@@ -4254,7 +3591,7 @@ ssize_t ib_uverbs_modify_srq(struct ib_uverbs_file *file,
 	INIT_UDATA(&udata, buf + sizeof cmd, NULL, in_len - sizeof cmd,
 		   out_len);
 
-	srq = idr_read_srq(cmd.srq_handle, file->ucontext);
+	srq = uobj_get_obj_read(srq, cmd.srq_handle, file->ucontext);
 	if (!srq)
 		return -EINVAL;
 
@@ -4263,7 +3600,7 @@ ssize_t ib_uverbs_modify_srq(struct ib_uverbs_file *file,
 
 	ret = srq->device->modify_srq(srq, &attr, cmd.attr_mask, &udata);
 
-	put_srq_read(srq);
+	uobj_put_obj_read(srq);
 
 	return ret ? ret : in_len;
 }
@@ -4285,13 +3622,13 @@ ssize_t ib_uverbs_query_srq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	srq = idr_read_srq(cmd.srq_handle, file->ucontext);
+	srq = uobj_get_obj_read(srq, cmd.srq_handle, file->ucontext);
 	if (!srq)
 		return -EINVAL;
 
 	ret = ib_query_srq(srq, &attr);
 
-	put_srq_read(srq);
+	uobj_put_obj_read(srq);
 
 	if (ret)
 		return ret;
@@ -4320,53 +3657,39 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	struct ib_srq               	 *srq;
 	struct ib_uevent_object        	 *obj;
 	int                         	  ret = -EINVAL;
-	struct ib_usrq_object		 *us;
 	enum ib_srq_type		  srq_type;
 
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(cmd.srq_handle, file->ucontext);
-	if (!uobj)
-		return -EINVAL;
+	uobj  = uobj_get_write(uobj_get_type(srq), cmd.srq_handle,
+			       file->ucontext);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
+
 	srq = uobj->object;
 	obj = container_of(uobj, struct ib_uevent_object, uobject);
 	srq_type = srq->srq_type;
+	/*
+	 * Make sure we don't free the memory in remove_commit as we still
+	 * needs the uobject memory to create the response.
+	 */
+	uverbs_uobject_get(uobj);
 
-	ret = ib_destroy_srq(srq);
-	if (!ret)
-		uobj->live = 0;
-
-	put_uobj_write(uobj);
+	memset(&resp, 0, sizeof(resp));
 
-	if (ret)
+	ret = uobj_remove_commit(uobj);
+	if (ret) {
+		uverbs_uobject_put(uobj);
 		return ret;
-
-	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_RESOURCE_HCA_OBJECT);
-
-	if (srq_type == IB_SRQT_XRC) {
-		us = container_of(obj, struct ib_usrq_object, uevent);
-		atomic_dec(&us->uxrcd->refcnt);
 	}
-
-	idr_remove_uobj(uobj);
-
-	mutex_lock(&file->mutex);
-	list_del(&uobj->list);
-	mutex_unlock(&file->mutex);
-
-	ib_uverbs_release_uevent(file, obj);
-
-	memset(&resp, 0, sizeof resp);
 	resp.events_reported = obj->events_reported;
+	uverbs_uobject_put(uobj);
+	if (copy_to_user((void __user *)(unsigned long)cmd.response,
+			 &resp, sizeof(resp)))
+		return -EFAULT;
 
-	put_uobj(uobj);
-
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp))
-		ret = -EFAULT;
-
-	return ret ? ret : in_len;
+	return in_len;
 }
 
 int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index e1db678..7ccb525 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -52,6 +52,7 @@
 
 #include "uverbs.h"
 #include "core_priv.h"
+#include "rdma_core.h"
 
 MODULE_AUTHOR("Roland Dreier");
 MODULE_DESCRIPTION("InfiniBand userspace verbs access");
@@ -214,140 +215,11 @@ void ib_uverbs_detach_umcast(struct ib_qp *qp,
 }
 
 static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
-				      struct ib_ucontext *context)
+				      struct ib_ucontext *context,
+				      bool device_removed)
 {
-	struct ib_uobject *uobj, *tmp;
-
 	context->closing = 1;
-
-	list_for_each_entry_safe(uobj, tmp, &context->ah_list, list) {
-		struct ib_ah *ah = uobj->object;
-
-		idr_remove_uobj(uobj);
-		ib_destroy_ah(ah);
-		ib_rdmacg_uncharge(&uobj->cg_obj, context->device,
-				   RDMACG_RESOURCE_HCA_OBJECT);
-		kfree(uobj);
-	}
-
-	/* Remove MWs before QPs, in order to support type 2A MWs. */
-	list_for_each_entry_safe(uobj, tmp, &context->mw_list, list) {
-		struct ib_mw *mw = uobj->object;
-
-		idr_remove_uobj(uobj);
-		uverbs_dealloc_mw(mw);
-		ib_rdmacg_uncharge(&uobj->cg_obj, context->device,
-				   RDMACG_RESOURCE_HCA_OBJECT);
-		kfree(uobj);
-	}
-
-	list_for_each_entry_safe(uobj, tmp, &context->rule_list, list) {
-		struct ib_flow *flow_id = uobj->object;
-
-		idr_remove_uobj(uobj);
-		ib_destroy_flow(flow_id);
-		ib_rdmacg_uncharge(&uobj->cg_obj, context->device,
-				   RDMACG_RESOURCE_HCA_OBJECT);
-		kfree(uobj);
-	}
-
-	list_for_each_entry_safe(uobj, tmp, &context->qp_list, list) {
-		struct ib_qp *qp = uobj->object;
-		struct ib_uqp_object *uqp =
-			container_of(uobj, struct ib_uqp_object, uevent.uobject);
-
-		idr_remove_uobj(uobj);
-		if (qp == qp->real_qp)
-			ib_uverbs_detach_umcast(qp, uqp);
-		ib_destroy_qp(qp);
-		ib_rdmacg_uncharge(&uobj->cg_obj, context->device,
-				   RDMACG_RESOURCE_HCA_OBJECT);
-		ib_uverbs_release_uevent(file, &uqp->uevent);
-		kfree(uqp);
-	}
-
-	list_for_each_entry_safe(uobj, tmp, &context->rwq_ind_tbl_list, list) {
-		struct ib_rwq_ind_table *rwq_ind_tbl = uobj->object;
-		struct ib_wq **ind_tbl = rwq_ind_tbl->ind_tbl;
-
-		idr_remove_uobj(uobj);
-		ib_destroy_rwq_ind_table(rwq_ind_tbl);
-		kfree(ind_tbl);
-		kfree(uobj);
-	}
-
-	list_for_each_entry_safe(uobj, tmp, &context->wq_list, list) {
-		struct ib_wq *wq = uobj->object;
-		struct ib_uwq_object *uwq =
-			container_of(uobj, struct ib_uwq_object, uevent.uobject);
-
-		idr_remove_uobj(uobj);
-		ib_destroy_wq(wq);
-		ib_uverbs_release_uevent(file, &uwq->uevent);
-		kfree(uwq);
-	}
-
-	list_for_each_entry_safe(uobj, tmp, &context->srq_list, list) {
-		struct ib_srq *srq = uobj->object;
-		struct ib_uevent_object *uevent =
-			container_of(uobj, struct ib_uevent_object, uobject);
-
-		idr_remove_uobj(uobj);
-		ib_destroy_srq(srq);
-		ib_rdmacg_uncharge(&uobj->cg_obj, context->device,
-				   RDMACG_RESOURCE_HCA_OBJECT);
-		ib_uverbs_release_uevent(file, uevent);
-		kfree(uevent);
-	}
-
-	list_for_each_entry_safe(uobj, tmp, &context->cq_list, list) {
-		struct ib_cq *cq = uobj->object;
-		struct ib_uverbs_event_file *ev_file = cq->cq_context;
-		struct ib_ucq_object *ucq =
-			container_of(uobj, struct ib_ucq_object, uobject);
-
-		idr_remove_uobj(uobj);
-		ib_destroy_cq(cq);
-		ib_rdmacg_uncharge(&uobj->cg_obj, context->device,
-				   RDMACG_RESOURCE_HCA_OBJECT);
-		ib_uverbs_release_ucq(file, ev_file, ucq);
-		kfree(ucq);
-	}
-
-	list_for_each_entry_safe(uobj, tmp, &context->mr_list, list) {
-		struct ib_mr *mr = uobj->object;
-
-		idr_remove_uobj(uobj);
-		ib_dereg_mr(mr);
-		ib_rdmacg_uncharge(&uobj->cg_obj, context->device,
-				   RDMACG_RESOURCE_HCA_OBJECT);
-		kfree(uobj);
-	}
-
-	mutex_lock(&file->device->xrcd_tree_mutex);
-	list_for_each_entry_safe(uobj, tmp, &context->xrcd_list, list) {
-		struct ib_xrcd *xrcd = uobj->object;
-		struct ib_uxrcd_object *uxrcd =
-			container_of(uobj, struct ib_uxrcd_object, uobject);
-
-		idr_remove_uobj(uobj);
-		ib_uverbs_dealloc_xrcd(file->device, xrcd,
-				       file->ucontext ? RDMA_REMOVE_CLOSE :
-				       RDMA_REMOVE_DRIVER_REMOVE);
-		kfree(uxrcd);
-	}
-	mutex_unlock(&file->device->xrcd_tree_mutex);
-
-	list_for_each_entry_safe(uobj, tmp, &context->pd_list, list) {
-		struct ib_pd *pd = uobj->object;
-
-		idr_remove_uobj(uobj);
-		ib_dealloc_pd(pd);
-		ib_rdmacg_uncharge(&uobj->cg_obj, context->device,
-				   RDMACG_RESOURCE_HCA_OBJECT);
-		kfree(uobj);
-	}
-
+	uverbs_cleanup_ucontext(context, device_removed);
 	put_pid(context->tgid);
 
 	ib_rdmacg_uncharge(&context->cg_obj, context->device,
@@ -592,7 +464,7 @@ void ib_uverbs_qp_event_handler(struct ib_event *event, void *context_ptr)
 	struct ib_uevent_object *uobj;
 
 	/* for XRC target qp's, check that qp is live */
-	if (!event->element.qp->uobject || !event->element.qp->uobject->live)
+	if (!event->element.qp->uobject)
 		return;
 
 	uobj = container_of(event->element.qp->uobject,
@@ -1010,7 +882,7 @@ static int ib_uverbs_close(struct inode *inode, struct file *filp)
 
 	mutex_lock(&file->cleanup_mutex);
 	if (file->ucontext) {
-		ib_uverbs_cleanup_ucontext(file, file->ucontext);
+		ib_uverbs_cleanup_ucontext(file, file->ucontext, false);
 		file->ucontext = NULL;
 	}
 	mutex_unlock(&file->cleanup_mutex);
@@ -1260,7 +1132,7 @@ static void ib_uverbs_free_hw_resources(struct ib_uverbs_device *uverbs_dev,
 			 * (e.g mmput).
 			 */
 			ib_dev->disassociate_ucontext(ucontext);
-			ib_uverbs_cleanup_ucontext(file, ucontext);
+			ib_uverbs_cleanup_ucontext(file, ucontext, true);
 		}
 
 		mutex_lock(&uverbs_dev->lists_mutex);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index d3efd22..2e8f661 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1377,17 +1377,6 @@ struct ib_rdmacg_object {
 struct ib_ucontext {
 	struct ib_device       *device;
 	struct ib_uverbs_file  *ufile;
-	struct list_head	pd_list;
-	struct list_head	mr_list;
-	struct list_head	mw_list;
-	struct list_head	cq_list;
-	struct list_head	qp_list;
-	struct list_head	srq_list;
-	struct list_head	ah_list;
-	struct list_head	xrcd_list;
-	struct list_head	rule_list;
-	struct list_head	wq_list;
-	struct list_head	rwq_ind_tbl_list;
 	int			closing;
 
 	/* locking the uobjects_list */
@@ -1426,10 +1415,8 @@ struct ib_uobject {
 	struct ib_rdmacg_object	cg_obj;		/* rdmacg object */
 	int			id;		/* index into kernel idr */
 	struct kref		ref;
-	struct rw_semaphore	mutex;		/* protects .live */
 	atomic_t		usecnt;		/* protects exclusive access */
 	struct rcu_head		rcu;		/* kfree_rcu() overhead */
-	int			live;
 
 	const struct uverbs_obj_type *type;
 };
diff --git a/include/rdma/uverbs_std_types.h b/include/rdma/uverbs_std_types.h
index 2edb776..8885664 100644
--- a/include/rdma/uverbs_std_types.h
+++ b/include/rdma/uverbs_std_types.h
@@ -46,5 +46,68 @@
 extern const struct uverbs_obj_idr_type uverbs_type_attrs_mw;
 extern const struct uverbs_obj_idr_type uverbs_type_attrs_pd;
 extern const struct uverbs_obj_idr_type uverbs_type_attrs_xrcd;
+
+static inline struct ib_uobject *__uobj_get(const struct uverbs_obj_type *type,
+					    bool write,
+					    struct ib_ucontext *ucontext,
+					    int id)
+{
+	return rdma_lookup_get_uobject(type, ucontext, id, write);
+}
+
+#define uobj_get_type(_type) uverbs_type_attrs_##_type.type
+
+#define uobj_get_read(_type, _id, _ucontext)				\
+	 __uobj_get(&(_type), false, _ucontext, _id)
+
+#define uobj_get_obj_read(_type, _id, _ucontext)			\
+({									\
+	struct ib_uobject *uobj =					\
+		__uobj_get(&uobj_get_type(_type),			\
+			   false, _ucontext, _id);			\
+									\
+	(struct ib_##_type *)(IS_ERR(uobj) ? NULL : uobj->object);	\
+})
+
+#define uobj_get_write(_type, _id, _ucontext)				\
+	 __uobj_get(&(_type), true, _ucontext, _id)
+
+static inline void uobj_put_read(struct ib_uobject *uobj)
+{
+	rdma_lookup_put_uobject(uobj, false);
+}
+
+#define uobj_put_obj_read(_obj)					\
+	uobj_put_read((_obj)->uobject)
+
+static inline void uobj_put_write(struct ib_uobject *uobj)
+{
+	rdma_lookup_put_uobject(uobj, true);
+}
+
+static inline int __must_check uobj_remove_commit(struct ib_uobject *uobj)
+{
+	return rdma_remove_commit_uobject(uobj);
+}
+
+static inline void uobj_alloc_commit(struct ib_uobject *uobj)
+{
+	rdma_alloc_commit_uobject(uobj);
+}
+
+static inline void uobj_alloc_abort(struct ib_uobject *uobj)
+{
+	rdma_alloc_abort_uobject(uobj);
+}
+
+static inline struct ib_uobject *__uobj_alloc(const struct uverbs_obj_type *type,
+					      struct ib_ucontext *ucontext)
+{
+	return rdma_alloc_begin_uobject(type, ucontext);
+}
+
+#define uobj_alloc(_type, ucontext)	\
+	__uobj_alloc(&(_type), ucontext)
+
 #endif
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
