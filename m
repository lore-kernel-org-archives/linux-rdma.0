From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC ABI V6 06/14] IB/core: Use the new IDR and locking infrastructure in uverbs_cmd
Date: Sun, 11 Dec 2016 14:58:00 +0200
Message-ID: <1481461088-56355-7-git-send-email-matanb@mellanox.com>
References: <1481461088-56355-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1481461088-56355-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The new infrastructure introduced a new locking and objects scheme.
We rewrite the current uverbs_cmd handlers to use them. The new
infrastructure needs a types definition in order to figure out how
to allocate/free resources, which is defined in upstream patches.

This patch refactores the following things:
(*) Instead of having a list per type, we use the ucontext's list
(*) The locking semantics are changed:
      Two commands might try to lock the same object. If this object
      is locked for exclusive object, any concurrent access will get
      -EBUSY. This makes the user serialize access.
(*) The completion channel FD is created by using the infrastructure.
    It's release function and release context are serialized by the
    infrastructure.
(*) The live flag is no longer required.
(*) User may need to assign the user_handle explicitly.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h      |   12 +-
 drivers/infiniband/core/uverbs_cmd.c  | 1163 ++++++++++++---------------------
 drivers/infiniband/core/uverbs_main.c |  232 ++-----
 drivers/infiniband/hw/mlx5/main.c     |    4 +
 include/rdma/ib_verbs.h               |   16 +-
 5 files changed, 480 insertions(+), 947 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 05e9e83..64f8658 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -175,15 +175,12 @@ struct ib_ucq_object {
 	u32			async_events_reported;
 };
 
-void idr_remove_uobj(struct ib_uobject *uobj);
 extern const struct file_operations uverbs_event_fops;
 
-struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
-					struct ib_device *ib_dev,
-					int is_async);
+struct file *ib_uverbs_alloc_async_event_file(struct ib_uverbs_file *uverbs_file,
+					      struct ib_device *ib_dev);
 void ib_uverbs_release_file(struct kref *ref);
 void ib_uverbs_free_async_event_file(struct ib_uverbs_file *uverbs_file);
-struct ib_uverbs_event_file *ib_uverbs_lookup_comp_file(int fd);
 
 void ib_uverbs_release_ucq(struct ib_uverbs_file *file,
 			   struct ib_uverbs_event_file *ev_file,
@@ -201,6 +198,11 @@ void ib_uverbs_event_handler(struct ib_event_handler *handler,
 void ib_uverbs_dealloc_xrcd(struct ib_uverbs_device *dev, struct ib_xrcd *xrcd);
 
 int uverbs_dealloc_mw(struct ib_mw *mw);
+void ib_uverbs_release_ucq(struct ib_uverbs_file *file,
+			   struct ib_uverbs_event_file *ev_file,
+			   struct ib_ucq_object *uobj);
+void ib_uverbs_release_uevent(struct ib_uverbs_file *file,
+			      struct ib_uevent_object *uobj);
 void ib_uverbs_detach_umcast(struct ib_qp *qp,
 			     struct ib_uqp_object *uobj);
 
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 84daf2c..79a1a8b 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -40,269 +40,73 @@
 
 #include <asm/uaccess.h>
 
+#include <rdma/uverbs_ioctl.h>
+#include <rdma/uverbs_ioctl_cmd.h>
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
-	spin_lock(&uobj->context->device->idr_lock);
-
-	ret = idr_alloc(&uobj->context->device->idr, uobj, 0, 0, GFP_NOWAIT);
-	if (ret >= 0)
-		uobj->id = ret;
-
-	spin_unlock(&uobj->context->device->idr_lock);
-	idr_preload_end();
-
-	return ret < 0 ? ret : 0;
-}
-
-void idr_remove_uobj(struct ib_uobject *uobj)
-{
-	spin_lock(&uobj->context->device->idr_lock);
-	idr_remove(&uobj->context->device->idr, uobj->id);
-	spin_unlock(&uobj->context->device->idr_lock);
-}
-
-static struct ib_uobject *__idr_get_uobj(int id, struct ib_ucontext *context)
-{
-	struct ib_uobject *uobj;
-
-	rcu_read_lock();
-	uobj = idr_find(&context->device->idr, id);
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
+#define fld_concat(a, b) a##b
+#define idr_get_xxxx(_type, _access, _handle, _context) ({		\
+	const struct uverbs_type * const type = &uverbs_type_## _type;	\
+	struct ib_uobject *uobj = uverbs_get_type_from_idr(		\
+					type->alloc,			\
+					_context, _access, _handle);	\
+									\
+	IS_ERR(uobj) ? NULL : uobj->object; })
 
 static struct ib_pd *idr_read_pd(int pd_handle, struct ib_ucontext *context)
 {
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
+	return idr_get_xxxx(pd, UVERBS_IDR_ACCESS_READ, pd_handle, context);
 }
 
-static void put_cq_read(struct ib_cq *cq)
+static struct ib_cq *idr_read_cq(int cq_handle, struct ib_ucontext *context)
 {
-	put_uobj_read(cq->uobject);
-}
-
-static void put_ah_read(struct ib_ah *ah)
-{
-	put_uobj_read(ah->uobject);
+	return idr_get_xxxx(cq, UVERBS_IDR_ACCESS_READ, cq_handle, context);
 }
 
 static struct ib_ah *idr_read_ah(int ah_handle, struct ib_ucontext *context)
 {
-	return idr_read_obj(ah_handle, context, 0);
+	return idr_get_xxxx(ah, UVERBS_IDR_ACCESS_READ, ah_handle, context);
 }
 
 static struct ib_qp *idr_read_qp(int qp_handle, struct ib_ucontext *context)
 {
-	return idr_read_obj(qp_handle, context, 0);
+	return idr_get_xxxx(qp, UVERBS_IDR_ACCESS_READ, qp_handle, context);
 }
 
 static struct ib_wq *idr_read_wq(int wq_handle, struct ib_ucontext *context)
 {
-	return idr_read_obj(wq_handle, context, 0);
-}
-
-static void put_wq_read(struct ib_wq *wq)
-{
-	put_uobj_read(wq->uobject);
+	return idr_get_xxxx(wq, UVERBS_IDR_ACCESS_READ, wq_handle, context);
 }
 
 static struct ib_rwq_ind_table *idr_read_rwq_indirection_table(int ind_table_handle,
 							       struct ib_ucontext *context)
 {
-	return idr_read_obj(ind_table_handle, context, 0);
-}
-
-static void put_rwq_indirection_table_read(struct ib_rwq_ind_table *ind_table)
-{
-	put_uobj_read(ind_table->uobject);
+	return idr_get_xxxx(rwq_ind_table, UVERBS_IDR_ACCESS_READ,
+			    ind_table_handle, context);
 }
 
 static struct ib_qp *idr_write_qp(int qp_handle, struct ib_ucontext *context)
 {
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
+	return idr_get_xxxx(qp, UVERBS_IDR_ACCESS_WRITE, qp_handle, context);
 }
 
 static struct ib_srq *idr_read_srq(int srq_handle, struct ib_ucontext *context)
 {
-	return idr_read_obj(srq_handle, context, 0);
-}
-
-static void put_srq_read(struct ib_srq *srq)
-{
-	put_uobj_read(srq->uobject);
+	return idr_get_xxxx(srq, UVERBS_IDR_ACCESS_WRITE, srq_handle, context);
 }
 
 static struct ib_xrcd *idr_read_xrcd(int xrcd_handle, struct ib_ucontext *context,
 				     struct ib_uobject **uobj)
 {
-	*uobj = idr_read_uobj(xrcd_handle, context, 0);
+	*uobj = uverbs_get_type_from_idr(uverbs_type_xrcd.alloc,
+					 context, UVERBS_IDR_ACCESS_READ,
+					 xrcd_handle);
 	return *uobj ? (*uobj)->object : NULL;
 }
 
-static void put_xrcd_read(struct ib_uobject *uobj)
-{
-	put_uobj_read(uobj);
-}
 ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 			      struct ib_device *ib_dev,
 			      const char __user *buf,
@@ -339,17 +143,11 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 	}
 
 	ucontext->device = ib_dev;
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
+	ucontext->ufile = file;
+	ret = ib_uverbs_uobject_type_initialize_ucontext(ucontext);
+	if (ret)
+		goto err_ctx;
+
 	rcu_read_lock();
 	ucontext->tgid = get_task_pid(current->group_leader, PIDTYPE_PID);
 	rcu_read_unlock();
@@ -373,7 +171,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 		goto err_free;
 	resp.async_fd = ret;
 
-	filp = ib_uverbs_alloc_event_file(file, ib_dev, 1);
+	filp = ib_uverbs_alloc_async_event_file(file, ib_dev);
 	if (IS_ERR(filp)) {
 		ret = PTR_ERR(filp);
 		goto err_fd;
@@ -386,6 +184,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 	}
 
 	file->ucontext = ucontext;
+	ucontext->ufile = file;
 
 	fd_install(resp.async_fd, filp);
 
@@ -402,6 +201,8 @@ err_fd:
 
 err_free:
 	put_pid(ucontext->tgid);
+	ib_uverbs_uobject_type_release_ucontext(ucontext);
+err_ctx:
 	ib_dev->dealloc_ucontext(ucontext);
 
 err:
@@ -553,12 +354,10 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 		   (unsigned long) cmd.response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
-	uobj = kmalloc(sizeof *uobj, GFP_KERNEL);
-	if (!uobj)
-		return -ENOMEM;
-
-	init_uobj(uobj, 0, file->ucontext, &pd_lock_class);
-	down_write(&uobj->mutex);
+	uobj = uverbs_get_type_from_idr(uverbs_type_pd.alloc, file->ucontext,
+					UVERBS_IDR_ACCESS_NEW, 0);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
 
 	pd = ib_dev->alloc_pd(ib_dev, file->ucontext, &udata);
 	if (IS_ERR(pd)) {
@@ -570,12 +369,7 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 	pd->uobject = uobj;
 	pd->__internal_mr = NULL;
 	atomic_set(&pd->usecnt, 0);
-
 	uobj->object = pd;
-	ret = idr_add_uobj(uobj);
-	if (ret)
-		goto err_idr;
-
 	memset(&resp, 0, sizeof resp);
 	resp.pd_handle = uobj->id;
 
@@ -585,24 +379,14 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 		goto err_copy;
 	}
 
-	mutex_lock(&file->mutex);
-	list_add_tail(&uobj->list, &file->ucontext->pd_list);
-	mutex_unlock(&file->mutex);
-
-	uobj->live = 1;
-
-	up_write(&uobj->mutex);
+	uverbs_commit_object(uobj, UVERBS_IDR_ACCESS_NEW);
 
 	return in_len;
 
 err_copy:
-	idr_remove_uobj(uobj);
-
-err_idr:
 	ib_dealloc_pd(pd);
-
 err:
-	put_uobj_write(uobj);
+	uverbs_rollback_object(uobj, UVERBS_IDR_ACCESS_NEW);
 	return ret;
 }
 
@@ -619,9 +403,11 @@ ssize_t ib_uverbs_dealloc_pd(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(cmd.pd_handle, file->ucontext);
-	if (!uobj)
-		return -EINVAL;
+	uobj = uverbs_get_type_from_idr(uverbs_type_pd.alloc, file->ucontext,
+					UVERBS_IDR_ACCESS_DESTROY,
+					cmd.pd_handle);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
 	pd = uobj->object;
 
 	if (atomic_read(&pd->usecnt)) {
@@ -634,21 +420,12 @@ ssize_t ib_uverbs_dealloc_pd(struct ib_uverbs_file *file,
 	if (ret)
 		goto err_put;
 
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
+	uverbs_commit_object(uobj, UVERBS_IDR_ACCESS_DESTROY);
 
 	return in_len;
 
 err_put:
-	put_uobj_write(uobj);
+	uverbs_rollback_object(uobj, UVERBS_IDR_ACCESS_DESTROY);
 	return ret;
 }
 
@@ -786,15 +563,11 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 		}
 	}
 
-	obj = kmalloc(sizeof *obj, GFP_KERNEL);
-	if (!obj) {
-		ret = -ENOMEM;
-		goto err_tree_mutex_unlock;
-	}
-
-	init_uobj(&obj->uobject, 0, file->ucontext, &xrcd_lock_class);
-
-	down_write(&obj->uobject.mutex);
+	obj = (struct ib_uxrcd_object *)
+		uverbs_get_type_from_idr(uverbs_type_xrcd.alloc, file->ucontext,
+					 UVERBS_IDR_ACCESS_NEW, 0);
+	if (IS_ERR(obj))
+		return PTR_ERR(obj);
 
 	if (!xrcd) {
 		xrcd = ib_dev->alloc_xrcd(ib_dev, file->ucontext, &udata);
@@ -813,10 +586,6 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 
 	atomic_set(&obj->refcnt, 0);
 	obj->uobject.object = xrcd;
-	ret = idr_add_uobj(&obj->uobject);
-	if (ret)
-		goto err_idr;
-
 	memset(&resp, 0, sizeof resp);
 	resp.xrcd_handle = obj->uobject.id;
 
@@ -825,7 +594,7 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 			/* create new inode/xrcd table entry */
 			ret = xrcd_table_insert(file->device, inode, xrcd);
 			if (ret)
-				goto err_insert_xrcd;
+				goto err_dealloc_xrcd;
 		}
 		atomic_inc(&xrcd->usecnt);
 	}
@@ -839,12 +608,7 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 	if (f.file)
 		fdput(f);
 
-	mutex_lock(&file->mutex);
-	list_add_tail(&obj->uobject.list, &file->ucontext->xrcd_list);
-	mutex_unlock(&file->mutex);
-
-	obj->uobject.live = 1;
-	up_write(&obj->uobject.mutex);
+	uverbs_commit_object(&obj->uobject, UVERBS_IDR_ACCESS_NEW);
 
 	mutex_unlock(&file->device->xrcd_tree_mutex);
 	return in_len;
@@ -856,14 +620,11 @@ err_copy:
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
+	uverbs_rollback_object(&obj->uobject, UVERBS_IDR_ACCESS_NEW);
 
 err_tree_mutex_unlock:
 	if (f.file)
@@ -884,24 +645,23 @@ ssize_t ib_uverbs_close_xrcd(struct ib_uverbs_file *file,
 	struct ib_xrcd              *xrcd = NULL;
 	struct inode                *inode = NULL;
 	struct ib_uxrcd_object      *obj;
-	int                         live;
 	int                         ret = 0;
+	bool			    destroyed = false;
 
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
 	mutex_lock(&file->device->xrcd_tree_mutex);
-	uobj = idr_write_uobj(cmd.xrcd_handle, file->ucontext);
-	if (!uobj) {
-		ret = -EINVAL;
-		goto out;
-	}
+	uobj = uverbs_get_type_from_idr(uverbs_type_xrcd.alloc, file->ucontext,
+					UVERBS_IDR_ACCESS_DESTROY,
+					cmd.xrcd_handle);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
 
 	xrcd  = uobj->object;
 	inode = xrcd->inode;
 	obj   = container_of(uobj, struct ib_uxrcd_object, uobject);
 	if (atomic_read(&obj->refcnt)) {
-		put_uobj_write(uobj);
 		ret = -EBUSY;
 		goto out;
 	}
@@ -909,30 +669,24 @@ ssize_t ib_uverbs_close_xrcd(struct ib_uverbs_file *file,
 	if (!inode || atomic_dec_and_test(&xrcd->usecnt)) {
 		ret = ib_dealloc_xrcd(uobj->object);
 		if (!ret)
-			uobj->live = 0;
+			uverbs_commit_object(uobj, UVERBS_IDR_ACCESS_DESTROY);
+		destroyed = !ret;
 	}
 
-	live = uobj->live;
 	if (inode && ret)
 		atomic_inc(&xrcd->usecnt);
 
-	put_uobj_write(uobj);
-
 	if (ret)
 		goto out;
 
-	if (inode && !live)
+	if (inode && destroyed)
 		xrcd_table_delete(file->device, inode);
 
-	idr_remove_uobj(uobj);
-	mutex_lock(&file->mutex);
-	list_del(&uobj->list);
-	mutex_unlock(&file->mutex);
-
-	put_uobj(uobj);
 	ret = in_len;
 
 out:
+	if (!destroyed)
+		uverbs_rollback_object(uobj, UVERBS_IDR_ACCESS_DESTROY);
 	mutex_unlock(&file->device->xrcd_tree_mutex);
 	return ret;
 }
@@ -982,12 +736,10 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
-	uobj = kmalloc(sizeof *uobj, GFP_KERNEL);
-	if (!uobj)
-		return -ENOMEM;
-
-	init_uobj(uobj, 0, file->ucontext, &mr_lock_class);
-	down_write(&uobj->mutex);
+	uobj = uverbs_get_type_from_idr(uverbs_type_mr.alloc, file->ucontext,
+					UVERBS_IDR_ACCESS_NEW, 0);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
 
 	pd = idr_read_pd(cmd.pd_handle, file->ucontext);
 	if (!pd) {
@@ -1017,9 +769,6 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 	atomic_inc(&pd->usecnt);
 
 	uobj->object = mr;
-	ret = idr_add_uobj(uobj);
-	if (ret)
-		goto err_unreg;
 
 	memset(&resp, 0, sizeof resp);
 	resp.lkey      = mr->lkey;
@@ -1032,29 +781,20 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 		goto err_copy;
 	}
 
-	put_pd_read(pd);
-
-	mutex_lock(&file->mutex);
-	list_add_tail(&uobj->list, &file->ucontext->mr_list);
-	mutex_unlock(&file->mutex);
-
-	uobj->live = 1;
+	uverbs_commit_object(pd->uobject, UVERBS_IDR_ACCESS_READ);
 
-	up_write(&uobj->mutex);
+	uverbs_commit_object(uobj, UVERBS_IDR_ACCESS_NEW);
 
 	return in_len;
 
 err_copy:
-	idr_remove_uobj(uobj);
-
-err_unreg:
 	ib_dereg_mr(mr);
 
 err_put:
-	put_pd_read(pd);
+	uverbs_rollback_object(pd->uobject, UVERBS_IDR_ACCESS_READ);
 
 err_free:
-	put_uobj_write(uobj);
+	uverbs_rollback_object(uobj, UVERBS_IDR_ACCESS_NEW);
 	return ret;
 }
 
@@ -1090,10 +830,10 @@ ssize_t ib_uverbs_rereg_mr(struct ib_uverbs_file *file,
 	     (cmd.start & ~PAGE_MASK) != (cmd.hca_va & ~PAGE_MASK)))
 			return -EINVAL;
 
-	uobj = idr_write_uobj(cmd.mr_handle, file->ucontext);
-
-	if (!uobj)
-		return -EINVAL;
+	uobj = uverbs_get_type_from_idr(uverbs_type_mr.alloc, file->ucontext,
+					UVERBS_IDR_ACCESS_WRITE, cmd.mr_handle);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
 
 	mr = uobj->object;
 
@@ -1136,12 +876,23 @@ ssize_t ib_uverbs_rereg_mr(struct ib_uverbs_file *file,
 		ret = in_len;
 
 put_uobj_pd:
-	if (cmd.flags & IB_MR_REREG_PD)
-		put_pd_read(pd);
+	if (cmd.flags & IB_MR_REREG_PD) {
+		if (ret == in_len)
+			uverbs_commit_object(pd->uobject,
+					     UVERBS_IDR_ACCESS_READ);
+		else
+			uverbs_rollback_object(pd->uobject,
+					       UVERBS_IDR_ACCESS_READ);
+	}
 
 put_uobjs:
 
-	put_uobj_write(mr->uobject);
+	if (ret == in_len)
+		uverbs_commit_object(uobj,
+				     UVERBS_IDR_ACCESS_WRITE);
+	else
+		uverbs_rollback_object(pd->uobject,
+				       UVERBS_IDR_ACCESS_WRITE);
 
 	return ret;
 }
@@ -1159,28 +910,22 @@ ssize_t ib_uverbs_dereg_mr(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(cmd.mr_handle, file->ucontext);
-	if (!uobj)
-		return -EINVAL;
+	uobj = uverbs_get_type_from_idr(uverbs_type_mr.alloc, file->ucontext,
+					UVERBS_IDR_ACCESS_DESTROY,
+					cmd.mr_handle);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
 
 	mr = uobj->object;
 
 	ret = ib_dereg_mr(mr);
-	if (!ret)
-		uobj->live = 0;
 
-	put_uobj_write(uobj);
-
-	if (ret)
+	if (ret) {
+		uverbs_rollback_object(uobj, UVERBS_IDR_ACCESS_DESTROY);
 		return ret;
+	}
 
-	idr_remove_uobj(uobj);
-
-	mutex_lock(&file->mutex);
-	list_del(&uobj->list);
-	mutex_unlock(&file->mutex);
-
-	put_uobj(uobj);
+	uverbs_commit_object(uobj, UVERBS_IDR_ACCESS_DESTROY);
 
 	return in_len;
 }
@@ -1204,12 +949,10 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof(cmd)))
 		return -EFAULT;
 
-	uobj = kmalloc(sizeof(*uobj), GFP_KERNEL);
-	if (!uobj)
-		return -ENOMEM;
-
-	init_uobj(uobj, 0, file->ucontext, &mw_lock_class);
-	down_write(&uobj->mutex);
+	uobj = uverbs_get_type_from_idr(uverbs_type_mw.alloc, file->ucontext,
+					UVERBS_IDR_ACCESS_NEW, 0);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
 
 	pd = idr_read_pd(cmd.pd_handle, file->ucontext);
 	if (!pd) {
@@ -1234,9 +977,6 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 	atomic_inc(&pd->usecnt);
 
 	uobj->object = mw;
-	ret = idr_add_uobj(uobj);
-	if (ret)
-		goto err_unalloc;
 
 	memset(&resp, 0, sizeof(resp));
 	resp.rkey      = mw->rkey;
@@ -1248,29 +988,17 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
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
+	uverbs_commit_object(pd->uobject, UVERBS_IDR_ACCESS_READ);
+	uverbs_commit_object(uobj, UVERBS_IDR_ACCESS_NEW);
 
 	return in_len;
 
 err_copy:
-	idr_remove_uobj(uobj);
-
-err_unalloc:
 	uverbs_dealloc_mw(mw);
-
 err_put:
-	put_pd_read(pd);
-
+	uverbs_rollback_object(pd->uobject, UVERBS_IDR_ACCESS_READ);
 err_free:
-	put_uobj_write(uobj);
+	uverbs_rollback_object(uobj, UVERBS_IDR_ACCESS_NEW);
 	return ret;
 }
 
@@ -1287,28 +1015,21 @@ ssize_t ib_uverbs_dealloc_mw(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof(cmd)))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(cmd.mw_handle, file->ucontext);
-	if (!uobj)
-		return -EINVAL;
+	uobj = uverbs_get_type_from_idr(uverbs_type_mw.alloc, file->ucontext,
+					UVERBS_IDR_ACCESS_DESTROY,
+					cmd.mw_handle);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
 
 	mw = uobj->object;
 
 	ret = uverbs_dealloc_mw(mw);
-	if (!ret)
-		uobj->live = 0;
-
-	put_uobj_write(uobj);
-
-	if (ret)
+	if (ret) {
+		uverbs_rollback_object(uobj, UVERBS_IDR_ACCESS_DESTROY);
 		return ret;
+	}
 
-	idr_remove_uobj(uobj);
-
-	mutex_lock(&file->mutex);
-	list_del(&uobj->list);
-	mutex_unlock(&file->mutex);
-
-	put_uobj(uobj);
+	uverbs_commit_object(uobj, UVERBS_IDR_ACCESS_DESTROY);
 
 	return in_len;
 }
@@ -1320,8 +1041,8 @@ ssize_t ib_uverbs_create_comp_channel(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_create_comp_channel	   cmd;
 	struct ib_uverbs_create_comp_channel_resp  resp;
-	struct file				  *filp;
-	int ret;
+	struct ib_uobject			  *uobj;
+	struct ib_uverbs_event_file		  *ev_file;
 
 	if (out_len < sizeof resp)
 		return -ENOSPC;
@@ -1329,25 +1050,30 @@ ssize_t ib_uverbs_create_comp_channel(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	ret = get_unused_fd_flags(O_CLOEXEC);
-	if (ret < 0)
-		return ret;
-	resp.fd = ret;
+	uobj = uverbs_get_type_from_fd(uverbs_type_comp_channel.alloc,
+				       file->ucontext,
+				       UVERBS_IDR_ACCESS_NEW, 0);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
 
-	filp = ib_uverbs_alloc_event_file(file, ib_dev, 0);
-	if (IS_ERR(filp)) {
-		put_unused_fd(resp.fd);
-		return PTR_ERR(filp);
-	}
+	resp.fd = uobj->id;
+
+	ev_file = uverbs_fd_to_priv(uobj);
+	kref_init(&ev_file->ref);
+	spin_lock_init(&ev_file->lock);
+	INIT_LIST_HEAD(&ev_file->event_list);
+	init_waitqueue_head(&ev_file->poll_wait);
+	ev_file->async_queue = NULL;
+	ev_file->uverbs_file = file;
+	ev_file->is_closed   = 0;
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp)) {
-		put_unused_fd(resp.fd);
-		fput(filp);
+		uverbs_rollback_object(uobj, UVERBS_IDR_ACCESS_NEW);
 		return -EFAULT;
 	}
 
-	fd_install(resp.fd, filp);
+	uverbs_commit_object(uobj, UVERBS_IDR_ACCESS_NEW);
 	return in_len;
 }
 
@@ -1365,6 +1091,7 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 				       void *context)
 {
 	struct ib_ucq_object           *obj;
+	struct ib_uobject	       *ev_uobj = NULL;
 	struct ib_uverbs_event_file    *ev_file = NULL;
 	struct ib_cq                   *cq;
 	int                             ret;
@@ -1374,21 +1101,27 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 	if (cmd->comp_vector >= file->device->num_comp_vectors)
 		return ERR_PTR(-EINVAL);
 
-	obj = kmalloc(sizeof *obj, GFP_KERNEL);
-	if (!obj)
-		return ERR_PTR(-ENOMEM);
-
-	init_uobj(&obj->uobject, cmd->user_handle, file->ucontext, &cq_lock_class);
-	down_write(&obj->uobject.mutex);
+	obj = (struct ib_ucq_object *)uverbs_get_type_from_idr(
+						uverbs_type_cq.alloc,
+						file->ucontext,
+						UVERBS_IDR_ACCESS_NEW, 0);
+	if (IS_ERR(obj))
+		return obj;
 
 	if (cmd->comp_channel >= 0) {
-		ev_file = ib_uverbs_lookup_comp_file(cmd->comp_channel);
-		if (!ev_file) {
+		ev_uobj = uverbs_get_type_from_fd(uverbs_type_comp_channel.alloc,
+						  file->ucontext,
+						  UVERBS_IDR_ACCESS_READ,
+						  cmd->comp_channel);
+		if (IS_ERR(ev_uobj)) {
 			ret = -EINVAL;
 			goto err;
 		}
+		ev_file = uverbs_fd_to_priv(ev_uobj);
+		kref_get(&ev_file->ref);
 	}
 
+	obj->uobject.user_handle = cmd->user_handle;
 	obj->uverbs_file	   = file;
 	obj->comp_events_reported  = 0;
 	obj->async_events_reported = 0;
@@ -1416,10 +1149,6 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 	atomic_set(&cq->usecnt, 0);
 
 	obj->uobject.object = cq;
-	ret = idr_add_uobj(&obj->uobject);
-	if (ret)
-		goto err_free;
-
 	memset(&resp, 0, sizeof resp);
 	resp.base.cq_handle = obj->uobject.id;
 	resp.base.cqe       = cq->cqe;
@@ -1431,28 +1160,20 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 	if (ret)
 		goto err_cb;
 
-	mutex_lock(&file->mutex);
-	list_add_tail(&obj->uobject.list, &file->ucontext->cq_list);
-	mutex_unlock(&file->mutex);
-
-	obj->uobject.live = 1;
-
-	up_write(&obj->uobject.mutex);
+	if (ev_uobj)
+		uverbs_commit_object(ev_uobj, UVERBS_IDR_ACCESS_READ);
+	uverbs_commit_object(&obj->uobject, UVERBS_IDR_ACCESS_NEW);
 
 	return obj;
 
 err_cb:
-	idr_remove_uobj(&obj->uobject);
-
-err_free:
 	ib_destroy_cq(cq);
 
 err_file:
-	if (ev_file)
-		ib_uverbs_release_ucq(file, ev_file, obj);
-
+	if (ev_uobj)
+		uverbs_rollback_object(ev_uobj, UVERBS_IDR_ACCESS_READ);
 err:
-	put_uobj_write(&obj->uobject);
+	uverbs_rollback_object(&obj->uobject, UVERBS_IDR_ACCESS_NEW);
 
 	return ERR_PTR(ret);
 }
@@ -1575,7 +1296,7 @@ ssize_t ib_uverbs_resize_cq(struct ib_uverbs_file *file,
 		   (unsigned long) cmd.response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
-	cq = idr_read_cq(cmd.cq_handle, file->ucontext, 0);
+	cq = idr_read_cq(cmd.cq_handle, file->ucontext);
 	if (!cq)
 		return -EINVAL;
 
@@ -1590,7 +1311,10 @@ ssize_t ib_uverbs_resize_cq(struct ib_uverbs_file *file,
 		ret = -EFAULT;
 
 out:
-	put_cq_read(cq);
+	if (!ret)
+		uverbs_commit_object(cq->uobject, UVERBS_IDR_ACCESS_READ);
+	else
+		uverbs_rollback_object(cq->uobject, UVERBS_IDR_ACCESS_READ);
 
 	return ret ? ret : in_len;
 }
@@ -1637,7 +1361,7 @@ ssize_t ib_uverbs_poll_cq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	cq = idr_read_cq(cmd.cq_handle, file->ucontext, 0);
+	cq = idr_read_cq(cmd.cq_handle, file->ucontext);
 	if (!cq)
 		return -EINVAL;
 
@@ -1669,7 +1393,10 @@ ssize_t ib_uverbs_poll_cq(struct ib_uverbs_file *file,
 	ret = in_len;
 
 out_put:
-	put_cq_read(cq);
+	if (ret == in_len)
+		uverbs_commit_object(cq->uobject, UVERBS_IDR_ACCESS_READ);
+	else
+		uverbs_rollback_object(cq->uobject, UVERBS_IDR_ACCESS_READ);
 	return ret;
 }
 
@@ -1684,14 +1411,14 @@ ssize_t ib_uverbs_req_notify_cq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	cq = idr_read_cq(cmd.cq_handle, file->ucontext, 0);
+	cq = idr_read_cq(cmd.cq_handle, file->ucontext);
 	if (!cq)
 		return -EINVAL;
 
 	ib_req_notify_cq(cq, cmd.solicited_only ?
 			 IB_CQ_SOLICITED : IB_CQ_NEXT_COMP);
 
-	put_cq_read(cq);
+	uverbs_commit_object(cq->uobject, UVERBS_IDR_ACCESS_READ);
 
 	return in_len;
 }
@@ -1712,36 +1439,29 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(cmd.cq_handle, file->ucontext);
-	if (!uobj)
-		return -EINVAL;
+	uobj = uverbs_get_type_from_idr(uverbs_type_cq.alloc,
+					file->ucontext,
+					UVERBS_IDR_ACCESS_DESTROY,
+					cmd.cq_handle);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
+
 	cq      = uobj->object;
 	ev_file = cq->cq_context;
 	obj     = container_of(cq->uobject, struct ib_ucq_object, uobject);
 
 	ret = ib_destroy_cq(cq);
-	if (!ret)
-		uobj->live = 0;
-
-	put_uobj_write(uobj);
-
-	if (ret)
+	if (ret) {
+		uverbs_rollback_object(uobj, UVERBS_IDR_ACCESS_DESTROY);
 		return ret;
+	}
 
-	idr_remove_uobj(uobj);
-
-	mutex_lock(&file->mutex);
-	list_del(&uobj->list);
-	mutex_unlock(&file->mutex);
-
-	ib_uverbs_release_ucq(file, ev_file, obj);
+	uverbs_commit_object(uobj, UVERBS_IDR_ACCESS_DESTROY);
 
 	memset(&resp, 0, sizeof resp);
 	resp.comp_events_reported  = obj->comp_events_reported;
 	resp.async_events_reported = obj->async_events_reported;
 
-	put_uobj(uobj);
-
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp))
 		return -EFAULT;
@@ -1777,13 +1497,15 @@ static int create_qp(struct ib_uverbs_file *file,
 	if (cmd->qp_type == IB_QPT_RAW_PACKET && !capable(CAP_NET_RAW))
 		return -EPERM;
 
-	obj = kzalloc(sizeof *obj, GFP_KERNEL);
-	if (!obj)
-		return -ENOMEM;
+	obj = (struct ib_uqp_object *)uverbs_get_type_from_idr(
+						uverbs_type_qp.alloc,
+						file->ucontext,
+						UVERBS_IDR_ACCESS_NEW, 0);
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
@@ -1836,7 +1558,7 @@ static int create_qp(struct ib_uverbs_file *file,
 			if (!ind_tbl) {
 				if (cmd->recv_cq_handle != cmd->send_cq_handle) {
 					rcq = idr_read_cq(cmd->recv_cq_handle,
-							  file->ucontext, 0);
+							  file->ucontext);
 					if (!rcq) {
 						ret = -EINVAL;
 						goto err_put;
@@ -1846,7 +1568,7 @@ static int create_qp(struct ib_uverbs_file *file,
 		}
 
 		if (has_sq)
-			scq = idr_read_cq(cmd->send_cq_handle, file->ucontext, !!rcq);
+			scq = idr_read_cq(cmd->send_cq_handle, file->ucontext);
 		if (!ind_tbl)
 			rcq = rcq ?: scq;
 		pd  = idr_read_pd(cmd->pd_handle, file->ucontext);
@@ -1935,9 +1657,6 @@ static int create_qp(struct ib_uverbs_file *file,
 	qp->uobject = &obj->uevent.uobject;
 
 	obj->uevent.uobject.object = qp;
-	ret = idr_add_uobj(&obj->uevent.uobject);
-	if (ret)
-		goto err_destroy;
 
 	memset(&resp, 0, sizeof resp);
 	resp.base.qpn             = qp->qp_num;
@@ -1959,50 +1678,42 @@ static int create_qp(struct ib_uverbs_file *file,
 		obj->uxrcd = container_of(xrcd_uobj, struct ib_uxrcd_object,
 					  uobject);
 		atomic_inc(&obj->uxrcd->refcnt);
-		put_xrcd_read(xrcd_uobj);
+		uverbs_commit_object(xrcd_uobj, UVERBS_IDR_ACCESS_READ);
 	}
 
 	if (pd)
-		put_pd_read(pd);
+		uverbs_commit_object(pd->uobject, UVERBS_IDR_ACCESS_READ);
 	if (scq)
-		put_cq_read(scq);
+		uverbs_commit_object(scq->uobject, UVERBS_IDR_ACCESS_READ);
 	if (rcq && rcq != scq)
-		put_cq_read(rcq);
+		uverbs_commit_object(rcq->uobject, UVERBS_IDR_ACCESS_READ);
 	if (srq)
-		put_srq_read(srq);
+		uverbs_commit_object(srq->uobject, UVERBS_IDR_ACCESS_READ);
 	if (ind_tbl)
-		put_rwq_indirection_table_read(ind_tbl);
+		uverbs_commit_object(ind_tbl->uobject, UVERBS_IDR_ACCESS_READ);
 
-	mutex_lock(&file->mutex);
-	list_add_tail(&obj->uevent.uobject.list, &file->ucontext->qp_list);
-	mutex_unlock(&file->mutex);
-
-	obj->uevent.uobject.live = 1;
-
-	up_write(&obj->uevent.uobject.mutex);
+	uverbs_commit_object(&obj->uevent.uobject, UVERBS_IDR_ACCESS_NEW);
 
 	return 0;
-err_cb:
-	idr_remove_uobj(&obj->uevent.uobject);
 
-err_destroy:
+err_cb:
 	ib_destroy_qp(qp);
 
 err_put:
 	if (xrcd)
-		put_xrcd_read(xrcd_uobj);
+		uverbs_rollback_object(xrcd_uobj, UVERBS_IDR_ACCESS_READ);
 	if (pd)
-		put_pd_read(pd);
+		uverbs_rollback_object(pd->uobject, UVERBS_IDR_ACCESS_READ);
 	if (scq)
-		put_cq_read(scq);
+		uverbs_rollback_object(scq->uobject, UVERBS_IDR_ACCESS_READ);
 	if (rcq && rcq != scq)
-		put_cq_read(rcq);
+		uverbs_rollback_object(rcq->uobject, UVERBS_IDR_ACCESS_READ);
 	if (srq)
-		put_srq_read(srq);
+		uverbs_rollback_object(srq->uobject, UVERBS_IDR_ACCESS_READ);
 	if (ind_tbl)
-		put_rwq_indirection_table_read(ind_tbl);
+		uverbs_rollback_object(ind_tbl->uobject, UVERBS_IDR_ACCESS_READ);
 
-	put_uobj_write(&obj->uevent.uobject);
+	uverbs_rollback_object(&obj->uevent.uobject, UVERBS_IDR_ACCESS_NEW);
 	return ret;
 }
 
@@ -2138,12 +1849,13 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
 		   (unsigned long) cmd.response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
-	obj = kmalloc(sizeof *obj, GFP_KERNEL);
-	if (!obj)
-		return -ENOMEM;
-
-	init_uobj(&obj->uevent.uobject, cmd.user_handle, file->ucontext, &qp_lock_class);
-	down_write(&obj->uevent.uobject.mutex);
+	obj = (struct ib_uqp_object *)uverbs_get_type_from_idr(
+						uverbs_type_qp.alloc,
+						file->ucontext,
+						UVERBS_IDR_ACCESS_NEW, 0);
+	if (IS_ERR(obj))
+		return PTR_ERR(obj);
+	obj->uxrcd = NULL;
 
 	xrcd = idr_read_xrcd(cmd.pd_handle, file->ucontext, &xrcd_uobj);
 	if (!xrcd) {
@@ -2163,15 +1875,12 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
 	qp = ib_open_qp(xrcd, &attr);
 	if (IS_ERR(qp)) {
 		ret = PTR_ERR(qp);
-		goto err_put;
+		goto err_xrcd;
 	}
 
 	qp->uobject = &obj->uevent.uobject;
 
 	obj->uevent.uobject.object = qp;
-	ret = idr_add_uobj(&obj->uevent.uobject);
-	if (ret)
-		goto err_destroy;
 
 	memset(&resp, 0, sizeof resp);
 	resp.qpn       = qp->qp_num;
@@ -2180,32 +1889,23 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
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
-
-	obj->uevent.uobject.live = 1;
+	uverbs_commit_object(xrcd_uobj, UVERBS_IDR_ACCESS_READ);
 
-	up_write(&obj->uevent.uobject.mutex);
+	uverbs_commit_object(&obj->uevent.uobject, UVERBS_IDR_ACCESS_NEW);
 
 	return in_len;
 
-err_remove:
-	idr_remove_uobj(&obj->uevent.uobject);
-
 err_destroy:
 	ib_destroy_qp(qp);
-
+err_xrcd:
+	uverbs_rollback_object(xrcd_uobj, UVERBS_IDR_ACCESS_READ);
 err_put:
-	put_xrcd_read(xrcd_uobj);
-	put_uobj_write(&obj->uevent.uobject);
+	uverbs_rollback_object(&obj->uevent.uobject, UVERBS_IDR_ACCESS_WRITE);
 	return ret;
 }
 
@@ -2238,11 +1938,10 @@ ssize_t ib_uverbs_query_qp(struct ib_uverbs_file *file,
 	}
 
 	ret = ib_query_qp(qp, attr, cmd.attr_mask, init_attr);
-
-	put_qp_read(qp);
-
 	if (ret)
-		goto out;
+		goto out_query;
+
+	uverbs_commit_object(qp->uobject, UVERBS_IDR_ACCESS_READ);
 
 	memset(&resp, 0, sizeof resp);
 
@@ -2308,6 +2007,10 @@ out:
 	kfree(init_attr);
 
 	return ret ? ret : in_len;
+
+out_query:
+	uverbs_rollback_object(qp->uobject, UVERBS_IDR_ACCESS_READ);
+	return ret;
 }
 
 /* Remove ignored fields set in the attribute mask */
@@ -2413,7 +2116,10 @@ ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
 	ret = in_len;
 
 release_qp:
-	put_qp_read(qp);
+	if (ret == in_len)
+		uverbs_commit_object(qp->uobject, UVERBS_IDR_ACCESS_READ);
+	else
+		uverbs_rollback_object(qp->uobject, UVERBS_IDR_ACCESS_READ);
 
 out:
 	kfree(attr);
@@ -2438,40 +2144,34 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 
 	memset(&resp, 0, sizeof resp);
 
-	uobj = idr_write_uobj(cmd.qp_handle, file->ucontext);
-	if (!uobj)
-		return -EINVAL;
+	uobj = uverbs_get_type_from_idr(uverbs_type_qp.alloc, file->ucontext,
+					UVERBS_IDR_ACCESS_DESTROY,
+					cmd.qp_handle);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
+
 	qp  = uobj->object;
 	obj = container_of(uobj, struct ib_uqp_object, uevent.uobject);
 
 	if (!list_empty(&obj->mcast_list)) {
-		put_uobj_write(uobj);
+		uverbs_rollback_object(uobj, UVERBS_IDR_ACCESS_DESTROY);
 		return -EBUSY;
 	}
 
 	ret = ib_destroy_qp(qp);
-	if (!ret)
-		uobj->live = 0;
-
-	put_uobj_write(uobj);
-
-	if (ret)
+	if (ret) {
+		uverbs_rollback_object(uobj, UVERBS_IDR_ACCESS_DESTROY);
 		return ret;
+	}
 
 	if (obj->uxrcd)
 		atomic_dec(&obj->uxrcd->refcnt);
 
-	idr_remove_uobj(uobj);
-
-	mutex_lock(&file->mutex);
-	list_del(&uobj->list);
-	mutex_unlock(&file->mutex);
-
 	ib_uverbs_release_uevent(file, &obj->uevent);
 
 	resp.events_reported = obj->uevent.events_reported;
 
-	put_uobj(uobj);
+	uverbs_commit_object(uobj, UVERBS_IDR_ACCESS_DESTROY);
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp))
@@ -2658,11 +2358,20 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 		ret = -EFAULT;
 
 out_put:
-	put_qp_read(qp);
+	if (ret)
+		uverbs_rollback_object(qp->uobject, UVERBS_IDR_ACCESS_READ);
+	else
+		uverbs_commit_object(qp->uobject, UVERBS_IDR_ACCESS_READ);
 
 	while (wr) {
-		if (is_ud && ud_wr(wr)->ah)
-			put_ah_read(ud_wr(wr)->ah);
+		if (is_ud && ud_wr(wr)->ah) {
+			if (ret)
+				uverbs_rollback_object(ud_wr(wr)->ah->uobject,
+						       UVERBS_IDR_ACCESS_READ);
+			else
+				uverbs_commit_object(ud_wr(wr)->ah->uobject,
+						     UVERBS_IDR_ACCESS_READ);
+		}
 		next = wr->next;
 		kfree(wr);
 		wr = next;
@@ -2786,14 +2495,16 @@ ssize_t ib_uverbs_post_recv(struct ib_uverbs_file *file,
 	resp.bad_wr = 0;
 	ret = qp->device->post_recv(qp->real_qp, wr, &bad_wr);
 
-	put_qp_read(qp);
-
-	if (ret)
+	if (ret) {
+		uverbs_rollback_object(qp->uobject, UVERBS_IDR_ACCESS_READ);
 		for (next = wr; next; next = next->next) {
 			++resp.bad_wr;
 			if (next == bad_wr)
 				break;
 		}
+	} else {
+		uverbs_commit_object(qp->uobject, UVERBS_IDR_ACCESS_READ);
+	}
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp))
@@ -2836,7 +2547,10 @@ ssize_t ib_uverbs_post_srq_recv(struct ib_uverbs_file *file,
 	resp.bad_wr = 0;
 	ret = srq->device->post_srq_recv(srq, wr, &bad_wr);
 
-	put_srq_read(srq);
+	if (!ret)
+		uverbs_commit_object(srq->uobject, UVERBS_IDR_ACCESS_READ);
+	else
+		uverbs_rollback_object(srq->uobject, UVERBS_IDR_ACCESS_READ);
 
 	if (ret)
 		for (next = wr; next; next = next->next) {
@@ -2878,12 +2592,11 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = kmalloc(sizeof *uobj, GFP_KERNEL);
-	if (!uobj)
-		return -ENOMEM;
-
-	init_uobj(uobj, cmd.user_handle, file->ucontext, &ah_lock_class);
-	down_write(&uobj->mutex);
+	uobj = uverbs_get_type_from_fd(uverbs_type_ah.alloc,
+				       file->ucontext,
+				       UVERBS_IDR_ACCESS_NEW, 0);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
 
 	pd = idr_read_pd(cmd.pd_handle, file->ucontext);
 	if (!pd) {
@@ -2913,10 +2626,6 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	ah->uobject  = uobj;
 	uobj->object = ah;
 
-	ret = idr_add_uobj(uobj);
-	if (ret)
-		goto err_destroy;
-
 	resp.ah_handle = uobj->id;
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
@@ -2925,29 +2634,23 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 		goto err_copy;
 	}
 
-	put_pd_read(pd);
-
-	mutex_lock(&file->mutex);
-	list_add_tail(&uobj->list, &file->ucontext->ah_list);
-	mutex_unlock(&file->mutex);
-
-	uobj->live = 1;
+	if (ret)
+		uverbs_rollback_object(pd->uobject, UVERBS_IDR_ACCESS_READ);
+	else
+		uverbs_commit_object(pd->uobject, UVERBS_IDR_ACCESS_READ);
 
-	up_write(&uobj->mutex);
+	uverbs_commit_object(uobj, UVERBS_IDR_ACCESS_NEW);
 
 	return in_len;
 
 err_copy:
-	idr_remove_uobj(uobj);
-
-err_destroy:
 	ib_destroy_ah(ah);
 
 err_put:
-	put_pd_read(pd);
+	uverbs_rollback_object(pd->uobject, UVERBS_IDR_ACCESS_READ);
 
 err:
-	put_uobj_write(uobj);
+	uverbs_rollback_object(uobj, UVERBS_IDR_ACCESS_NEW);
 	return ret;
 }
 
@@ -2963,29 +2666,22 @@ ssize_t ib_uverbs_destroy_ah(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(cmd.ah_handle, file->ucontext);
-	if (!uobj)
-		return -EINVAL;
+	uobj = uverbs_get_type_from_idr(uverbs_type_ah.alloc, file->ucontext,
+					UVERBS_IDR_ACCESS_DESTROY,
+					cmd.ah_handle);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
+
 	ah = uobj->object;
 
 	ret = ib_destroy_ah(ah);
-	if (!ret)
-		uobj->live = 0;
-
-	put_uobj_write(uobj);
-
-	if (ret)
+	if (ret) {
+		uverbs_rollback_object(uobj, UVERBS_IDR_ACCESS_DESTROY);
 		return ret;
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
+	} else {
+		uverbs_commit_object(uobj, UVERBS_IDR_ACCESS_DESTROY);
+		return in_len;
+	}
 }
 
 ssize_t ib_uverbs_attach_mcast(struct ib_uverbs_file *file,
@@ -3031,9 +2727,13 @@ ssize_t ib_uverbs_attach_mcast(struct ib_uverbs_file *file,
 		kfree(mcast);
 
 out_put:
-	put_qp_write(qp);
+	if (ret) {
+		uverbs_rollback_object(qp->uobject, UVERBS_IDR_ACCESS_WRITE);
+		return ret;
+	}
 
-	return ret ? ret : in_len;
+	uverbs_commit_object(qp->uobject, UVERBS_IDR_ACCESS_WRITE);
+	return in_len;
 }
 
 ssize_t ib_uverbs_detach_mcast(struct ib_uverbs_file *file,
@@ -3069,9 +2769,13 @@ ssize_t ib_uverbs_detach_mcast(struct ib_uverbs_file *file,
 		}
 
 out_put:
-	put_qp_write(qp);
+	if (ret) {
+		uverbs_rollback_object(qp->uobject, UVERBS_IDR_ACCESS_WRITE);
+		return ret;
+	}
 
-	return ret ? ret : in_len;
+	uverbs_commit_object(qp->uobject, UVERBS_IDR_ACCESS_WRITE);
+	return in_len;
 }
 
 static size_t kern_spec_filter_sz(struct ib_uverbs_flow_spec_hdr *spec)
@@ -3214,20 +2918,20 @@ int ib_uverbs_ex_create_wq(struct ib_uverbs_file *file,
 	if (cmd.comp_mask)
 		return -EOPNOTSUPP;
 
-	obj = kmalloc(sizeof(*obj), GFP_KERNEL);
-	if (!obj)
-		return -ENOMEM;
+	obj = (struct ib_uwq_object *)uverbs_get_type_from_idr(
+						uverbs_type_wq.alloc,
+						file->ucontext,
+						UVERBS_IDR_ACCESS_NEW, 0);
+	if (IS_ERR(obj))
+		return PTR_ERR(obj);
 
-	init_uobj(&obj->uevent.uobject, cmd.user_handle, file->ucontext,
-		  &wq_lock_class);
-	down_write(&obj->uevent.uobject.mutex);
 	pd  = idr_read_pd(cmd.pd_handle, file->ucontext);
 	if (!pd) {
 		err = -EINVAL;
 		goto err_uobj;
 	}
 
-	cq = idr_read_cq(cmd.cq_handle, file->ucontext, 0);
+	cq = idr_read_cq(cmd.cq_handle, file->ucontext);
 	if (!cq) {
 		err = -EINVAL;
 		goto err_put_pd;
@@ -3259,9 +2963,6 @@ int ib_uverbs_ex_create_wq(struct ib_uverbs_file *file,
 	atomic_inc(&cq->usecnt);
 	wq->uobject = &obj->uevent.uobject;
 	obj->uevent.uobject.object = wq;
-	err = idr_add_uobj(&obj->uevent.uobject);
-	if (err)
-		goto destroy_wq;
 
 	memset(&resp, 0, sizeof(resp));
 	resp.wq_handle = obj->uevent.uobject.id;
@@ -3274,27 +2975,19 @@ int ib_uverbs_ex_create_wq(struct ib_uverbs_file *file,
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
+	uverbs_commit_object(pd->uobject, UVERBS_IDR_ACCESS_READ);
+	uverbs_commit_object(cq->uobject, UVERBS_IDR_ACCESS_READ);
+	uverbs_commit_object(&obj->uevent.uobject, UVERBS_IDR_ACCESS_NEW);
 	return 0;
 
 err_copy:
-	idr_remove_uobj(&obj->uevent.uobject);
-destroy_wq:
 	ib_destroy_wq(wq);
 err_put_cq:
-	put_cq_read(cq);
+	uverbs_rollback_object(cq->uobject, UVERBS_IDR_ACCESS_READ);
 err_put_pd:
-	put_pd_read(pd);
+	uverbs_rollback_object(pd->uobject, UVERBS_IDR_ACCESS_READ);
 err_uobj:
-	put_uobj_write(&obj->uevent.uobject);
+	uverbs_rollback_object(&obj->uevent.uobject, UVERBS_IDR_ACCESS_NEW);
 
 	return err;
 }
@@ -3335,30 +3028,23 @@ int ib_uverbs_ex_destroy_wq(struct ib_uverbs_file *file,
 		return -EOPNOTSUPP;
 
 	resp.response_length = required_resp_len;
-	uobj = idr_write_uobj(cmd.wq_handle,
-			      file->ucontext);
-	if (!uobj)
-		return -EINVAL;
+	uobj = uverbs_get_type_from_idr(uverbs_type_ah.alloc, file->ucontext,
+					UVERBS_IDR_ACCESS_DESTROY,
+					cmd.wq_handle);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
 
 	wq = uobj->object;
 	obj = container_of(uobj, struct ib_uwq_object, uevent.uobject);
 	ret = ib_destroy_wq(wq);
-	if (!ret)
-		uobj->live = 0;
-
-	put_uobj_write(uobj);
-	if (ret)
+	if (ret) {
+		uverbs_rollback_object(uobj, UVERBS_IDR_ACCESS_DESTROY);
 		return ret;
-
-	idr_remove_uobj(uobj);
-
-	mutex_lock(&file->mutex);
-	list_del(&uobj->list);
-	mutex_unlock(&file->mutex);
+	}
 
 	ib_uverbs_release_uevent(file, &obj->uevent);
 	resp.events_reported = obj->uevent.events_reported;
-	put_uobj(uobj);
+	uverbs_commit_object(uobj, UVERBS_IDR_ACCESS_DESTROY);
 
 	ret = ib_copy_to_udata(ucore, &resp, resp.response_length);
 	if (ret)
@@ -3404,7 +3090,10 @@ int ib_uverbs_ex_modify_wq(struct ib_uverbs_file *file,
 	wq_attr.curr_wq_state = cmd.curr_wq_state;
 	wq_attr.wq_state = cmd.wq_state;
 	ret = wq->device->modify_wq(wq, &wq_attr, cmd.attr_mask, uhw);
-	put_wq_read(wq);
+	if (ret)
+		uverbs_rollback_object(wq->uobject, UVERBS_IDR_ACCESS_READ);
+	else
+		uverbs_commit_object(wq->uobject, UVERBS_IDR_ACCESS_READ);
 	return ret;
 }
 
@@ -3491,14 +3180,15 @@ int ib_uverbs_ex_create_rwq_ind_table(struct ib_uverbs_file *file,
 		wqs[num_read_wqs] = wq;
 	}
 
-	uobj = kmalloc(sizeof(*uobj), GFP_KERNEL);
-	if (!uobj) {
+	uobj = uverbs_get_type_from_idr(uverbs_type_rwq_ind_table.alloc,
+					file->ucontext,
+					UVERBS_IDR_ACCESS_NEW,
+					0);
+	if (IS_ERR(uobj)) {
 		err = -ENOMEM;
 		goto put_wqs;
 	}
 
-	init_uobj(uobj, 0, file->ucontext, &rwq_ind_table_lock_class);
-	down_write(&uobj->mutex);
 	init_attr.log_ind_tbl_size = cmd.log_ind_tbl_size;
 	init_attr.ind_tbl = wqs;
 	rwq_ind_tbl = ib_dev->create_rwq_ind_table(ib_dev, &init_attr, uhw);
@@ -3518,10 +3208,6 @@ int ib_uverbs_ex_create_rwq_ind_table(struct ib_uverbs_file *file,
 	for (i = 0; i < num_wq_handles; i++)
 		atomic_inc(&wqs[i]->usecnt);
 
-	err = idr_add_uobj(uobj);
-	if (err)
-		goto destroy_ind_tbl;
-
 	resp.ind_tbl_handle = uobj->id;
 	resp.ind_tbl_num = rwq_ind_tbl->ind_tbl_num;
 	resp.response_length = required_resp_len;
@@ -3534,26 +3220,18 @@ int ib_uverbs_ex_create_rwq_ind_table(struct ib_uverbs_file *file,
 	kfree(wqs_handles);
 
 	for (j = 0; j < num_read_wqs; j++)
-		put_wq_read(wqs[j]);
-
-	mutex_lock(&file->mutex);
-	list_add_tail(&uobj->list, &file->ucontext->rwq_ind_tbl_list);
-	mutex_unlock(&file->mutex);
-
-	uobj->live = 1;
+		uverbs_commit_object(wqs[j]->uobject, UVERBS_IDR_ACCESS_READ);
 
-	up_write(&uobj->mutex);
+	uverbs_commit_object(uobj, UVERBS_IDR_ACCESS_NEW);
 	return 0;
 
 err_copy:
-	idr_remove_uobj(uobj);
-destroy_ind_tbl:
 	ib_destroy_rwq_ind_table(rwq_ind_tbl);
 err_uobj:
-	put_uobj_write(uobj);
+	uverbs_rollback_object(uobj, UVERBS_IDR_ACCESS_NEW);
 put_wqs:
 	for (j = 0; j < num_read_wqs; j++)
-		put_wq_read(wqs[j]);
+		uverbs_rollback_object(wqs[j]->uobject, UVERBS_IDR_ACCESS_READ);
 err_free:
 	kfree(wqs_handles);
 	kfree(wqs);
@@ -3589,29 +3267,23 @@ int ib_uverbs_ex_destroy_rwq_ind_table(struct ib_uverbs_file *file,
 	if (cmd.comp_mask)
 		return -EOPNOTSUPP;
 
-	uobj = idr_write_uobj(cmd.ind_tbl_handle,
-			      file->ucontext);
-	if (!uobj)
-		return -EINVAL;
+	uobj = uverbs_get_type_from_idr(uverbs_type_rwq_ind_table.alloc,
+					file->ucontext,
+					UVERBS_IDR_ACCESS_DESTROY,
+					cmd.ind_tbl_handle);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
+
 	rwq_ind_tbl = uobj->object;
 	ind_tbl = rwq_ind_tbl->ind_tbl;
 
 	ret = ib_destroy_rwq_ind_table(rwq_ind_tbl);
-	if (!ret)
-		uobj->live = 0;
-
-	put_uobj_write(uobj);
-
-	if (ret)
+	if (ret) {
+		uverbs_rollback_object(uobj, UVERBS_IDR_ACCESS_DESTROY);
 		return ret;
+	}
 
-	idr_remove_uobj(uobj);
-
-	mutex_lock(&file->mutex);
-	list_del(&uobj->list);
-	mutex_unlock(&file->mutex);
-
-	put_uobj(uobj);
+	uverbs_commit_object(uobj, UVERBS_IDR_ACCESS_DESTROY);
 	kfree(ind_tbl);
 	return ret;
 }
@@ -3687,13 +3359,12 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 		kern_flow_attr = &cmd.flow_attr;
 	}
 
-	uobj = kmalloc(sizeof(*uobj), GFP_KERNEL);
-	if (!uobj) {
+	uobj = uverbs_get_type_from_idr(uverbs_type_flow.alloc, file->ucontext,
+					UVERBS_IDR_ACCESS_NEW, 0);
+	if (IS_ERR(uobj)) {
 		err = -ENOMEM;
 		goto err_free_attr;
 	}
-	init_uobj(uobj, 0, file->ucontext, &rule_lock_class);
-	down_write(&uobj->mutex);
 
 	qp = idr_read_qp(cmd.qp_handle, file->ucontext);
 	if (!qp) {
@@ -3745,10 +3416,6 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 	flow_id->uobject = uobj;
 	uobj->object = flow_id;
 
-	err = idr_add_uobj(uobj);
-	if (err)
-		goto destroy_flow;
-
 	memset(&resp, 0, sizeof(resp));
 	resp.flow_handle = uobj->id;
 
@@ -3757,28 +3424,20 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
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
+	uverbs_commit_object(qp->uobject, UVERBS_IDR_ACCESS_READ);
+	uverbs_commit_object(uobj, UVERBS_IDR_ACCESS_NEW);
 	kfree(flow_attr);
 	if (cmd.flow_attr.num_of_specs)
 		kfree(kern_flow_attr);
 	return 0;
 err_copy:
-	idr_remove_uobj(uobj);
-destroy_flow:
 	ib_destroy_flow(flow_id);
 err_free:
 	kfree(flow_attr);
 err_put:
-	put_qp_read(qp);
+	uverbs_rollback_object(qp->uobject, UVERBS_IDR_ACCESS_READ);
 err_uobj:
-	put_uobj_write(uobj);
+	uverbs_rollback_object(uobj, UVERBS_IDR_ACCESS_NEW);
 err_free_attr:
 	if (cmd.flow_attr.num_of_specs)
 		kfree(kern_flow_attr);
@@ -3805,25 +3464,22 @@ int ib_uverbs_ex_destroy_flow(struct ib_uverbs_file *file,
 	if (cmd.comp_mask)
 		return -EINVAL;
 
-	uobj = idr_write_uobj(cmd.flow_handle, file->ucontext);
-	if (!uobj)
-		return -EINVAL;
+	uobj = uverbs_get_type_from_idr(uverbs_type_flow.alloc,
+					file->ucontext,
+					UVERBS_IDR_ACCESS_DESTROY,
+					cmd.flow_handle);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
+
 	flow_id = uobj->object;
 
 	ret = ib_destroy_flow(flow_id);
-	if (!ret)
-		uobj->live = 0;
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
+	if (ret) {
+		uverbs_rollback_object(uobj, UVERBS_IDR_ACCESS_DESTROY);
+		return ret;
+	}
 
+	uverbs_commit_object(uobj, UVERBS_IDR_ACCESS_DESTROY);
 	return ret;
 }
 
@@ -3840,12 +3496,12 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	struct ib_srq_init_attr          attr;
 	int ret;
 
-	obj = kmalloc(sizeof *obj, GFP_KERNEL);
-	if (!obj)
-		return -ENOMEM;
-
-	init_uobj(&obj->uevent.uobject, cmd->user_handle, file->ucontext, &srq_lock_class);
-	down_write(&obj->uevent.uobject.mutex);
+	obj = (struct ib_usrq_object *)uverbs_get_type_from_idr(
+						uverbs_type_srq.alloc,
+						file->ucontext,
+						UVERBS_IDR_ACCESS_NEW, 0);
+	if (IS_ERR(obj))
+		return PTR_ERR(obj);
 
 	if (cmd->srq_type == IB_SRQT_XRC) {
 		attr.ext.xrc.xrcd  = idr_read_xrcd(cmd->xrcd_handle, file->ucontext, &xrcd_uobj);
@@ -3857,7 +3513,7 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 		obj->uxrcd = container_of(xrcd_uobj, struct ib_uxrcd_object, uobject);
 		atomic_inc(&obj->uxrcd->refcnt);
 
-		attr.ext.xrc.cq  = idr_read_cq(cmd->cq_handle, file->ucontext, 0);
+		attr.ext.xrc.cq  = idr_read_cq(cmd->cq_handle, file->ucontext);
 		if (!attr.ext.xrc.cq) {
 			ret = -EINVAL;
 			goto err_put_xrcd;
@@ -3904,9 +3560,7 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	atomic_set(&srq->usecnt, 0);
 
 	obj->uevent.uobject.object = srq;
-	ret = idr_add_uobj(&obj->uevent.uobject);
-	if (ret)
-		goto err_destroy;
+	obj->uevent.uobject.user_handle = cmd->user_handle;
 
 	memset(&resp, 0, sizeof resp);
 	resp.srq_handle = obj->uevent.uobject.id;
@@ -3922,42 +3576,34 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	}
 
 	if (cmd->srq_type == IB_SRQT_XRC) {
-		put_uobj_read(xrcd_uobj);
-		put_cq_read(attr.ext.xrc.cq);
+		uverbs_commit_object(xrcd_uobj, UVERBS_IDR_ACCESS_READ);
+		uverbs_commit_object(attr.ext.xrc.cq->uobject,
+				     UVERBS_IDR_ACCESS_READ);
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
+	uverbs_commit_object(pd->uobject, UVERBS_IDR_ACCESS_READ);
+	uverbs_commit_object(&obj->uevent.uobject, UVERBS_IDR_ACCESS_NEW);
 
 	return 0;
 
 err_copy:
-	idr_remove_uobj(&obj->uevent.uobject);
-
-err_destroy:
 	ib_destroy_srq(srq);
 
 err_put:
-	put_pd_read(pd);
+	uverbs_rollback_object(pd->uobject, UVERBS_IDR_ACCESS_READ);
 
 err_put_cq:
 	if (cmd->srq_type == IB_SRQT_XRC)
-		put_cq_read(attr.ext.xrc.cq);
+		uverbs_rollback_object(attr.ext.xrc.cq->uobject,
+				       UVERBS_IDR_ACCESS_READ);
 
 err_put_xrcd:
 	if (cmd->srq_type == IB_SRQT_XRC) {
 		atomic_dec(&obj->uxrcd->refcnt);
-		put_uobj_read(xrcd_uobj);
+		uverbs_rollback_object(xrcd_uobj, UVERBS_IDR_ACCESS_READ);
 	}
 
 err:
-	put_uobj_write(&obj->uevent.uobject);
+	uverbs_rollback_object(&obj->uevent.uobject, UVERBS_IDR_ACCESS_NEW);
 	return ret;
 }
 
@@ -4051,9 +3697,13 @@ ssize_t ib_uverbs_modify_srq(struct ib_uverbs_file *file,
 
 	ret = srq->device->modify_srq(srq, &attr, cmd.attr_mask, &udata);
 
-	put_srq_read(srq);
+	if (ret) {
+		uverbs_rollback_object(srq->uobject, UVERBS_IDR_ACCESS_READ);
+		return ret;
+	}
 
-	return ret ? ret : in_len;
+	uverbs_commit_object(srq->uobject, UVERBS_IDR_ACCESS_READ);
+	return in_len;
 }
 
 ssize_t ib_uverbs_query_srq(struct ib_uverbs_file *file,
@@ -4079,10 +3729,12 @@ ssize_t ib_uverbs_query_srq(struct ib_uverbs_file *file,
 
 	ret = ib_query_srq(srq, &attr);
 
-	put_srq_read(srq);
-
-	if (ret)
+	if (ret) {
+		uverbs_rollback_object(srq->uobject, UVERBS_IDR_ACCESS_READ);
 		return ret;
+	}
+
+	uverbs_commit_object(srq->uobject, UVERBS_IDR_ACCESS_READ);
 
 	memset(&resp, 0, sizeof resp);
 
@@ -4114,39 +3766,34 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(cmd.srq_handle, file->ucontext);
-	if (!uobj)
-		return -EINVAL;
+	uobj = uverbs_get_type_from_idr(uverbs_type_srq.alloc,
+					file->ucontext,
+					UVERBS_IDR_ACCESS_DESTROY,
+					cmd.srq_handle);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
+
 	srq = uobj->object;
 	obj = container_of(uobj, struct ib_uevent_object, uobject);
 	srq_type = srq->srq_type;
 
 	ret = ib_destroy_srq(srq);
-	if (!ret)
-		uobj->live = 0;
-
-	put_uobj_write(uobj);
-
-	if (ret)
+	if (ret) {
+		uverbs_rollback_object(uobj, UVERBS_IDR_ACCESS_DESTROY);
 		return ret;
+	}
 
 	if (srq_type == IB_SRQT_XRC) {
 		us = container_of(obj, struct ib_usrq_object, uevent);
 		atomic_dec(&us->uxrcd->refcnt);
 	}
 
-	idr_remove_uobj(uobj);
-
-	mutex_lock(&file->mutex);
-	list_del(&uobj->list);
-	mutex_unlock(&file->mutex);
-
 	ib_uverbs_release_uevent(file, obj);
 
 	memset(&resp, 0, sizeof resp);
 	resp.events_reported = obj->events_reported;
 
-	put_uobj(uobj);
+	uverbs_commit_object(uobj, UVERBS_IDR_ACCESS_DESTROY);
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp))
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index b560c88..d3dacdd 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -51,6 +51,7 @@
 #include <rdma/ib.h>
 
 #include "uverbs.h"
+#include "rdma_core.h"
 
 MODULE_AUTHOR("Roland Dreier");
 MODULE_DESCRIPTION("InfiniBand userspace verbs access");
@@ -153,7 +154,7 @@ static struct kobj_type ib_uverbs_dev_ktype = {
 	.release = ib_uverbs_release_dev,
 };
 
-static void ib_uverbs_release_event_file(struct kref *ref)
+static void ib_uverbs_release_async_event_file(struct kref *ref)
 {
 	struct ib_uverbs_event_file *file =
 		container_of(ref, struct ib_uverbs_event_file, ref);
@@ -161,6 +162,14 @@ static void ib_uverbs_release_event_file(struct kref *ref)
 	kfree(file);
 }
 
+static void ib_uverbs_release_event_file(struct kref *ref)
+{
+	struct ib_uverbs_event_file *file =
+		container_of(ref, struct ib_uverbs_event_file, ref);
+
+	ib_uverbs_cleanup_fd(file);
+}
+
 void ib_uverbs_release_ucq(struct ib_uverbs_file *file,
 			  struct ib_uverbs_event_file *ev_file,
 			  struct ib_ucq_object *uobj)
@@ -214,123 +223,9 @@ void ib_uverbs_detach_umcast(struct ib_qp *qp,
 static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 				      struct ib_ucontext *context)
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
-		kfree(uobj);
-	}
-
-	/* Remove MWs before QPs, in order to support type 2A MWs. */
-	list_for_each_entry_safe(uobj, tmp, &context->mw_list, list) {
-		struct ib_mw *mw = uobj->object;
-
-		idr_remove_uobj(uobj);
-		uverbs_dealloc_mw(mw);
-		kfree(uobj);
-	}
-
-	list_for_each_entry_safe(uobj, tmp, &context->rule_list, list) {
-		struct ib_flow *flow_id = uobj->object;
-
-		idr_remove_uobj(uobj);
-		ib_destroy_flow(flow_id);
-		kfree(uobj);
-	}
-
-	list_for_each_entry_safe(uobj, tmp, &context->qp_list, list) {
-		struct ib_qp *qp = uobj->object;
-		struct ib_uqp_object *uqp =
-			container_of(uobj, struct ib_uqp_object, uevent.uobject);
-
-		idr_remove_uobj(uobj);
-		if (qp != qp->real_qp) {
-			ib_close_qp(qp);
-		} else {
-			ib_uverbs_detach_umcast(qp, uqp);
-			ib_destroy_qp(qp);
-		}
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
-		ib_uverbs_release_ucq(file, ev_file, ucq);
-		kfree(ucq);
-	}
-
-	list_for_each_entry_safe(uobj, tmp, &context->mr_list, list) {
-		struct ib_mr *mr = uobj->object;
-
-		idr_remove_uobj(uobj);
-		ib_dereg_mr(mr);
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
-		ib_uverbs_dealloc_xrcd(file->device, xrcd);
-		kfree(uxrcd);
-	}
-	mutex_unlock(&file->device->xrcd_tree_mutex);
-
-	list_for_each_entry_safe(uobj, tmp, &context->pd_list, list) {
-		struct ib_pd *pd = uobj->object;
-
-		idr_remove_uobj(uobj);
-		ib_dealloc_pd(pd);
-		kfree(uobj);
-	}
-
+	ib_uverbs_uobject_type_cleanup_ucontext(context,
+						context->device->specs_root);
 	put_pid(context->tgid);
 
 	return context->device->dealloc_ucontext(context);
@@ -449,7 +344,7 @@ static int ib_uverbs_event_fasync(int fd, struct file *filp, int on)
 	return fasync_helper(fd, filp, on, &file->async_queue);
 }
 
-static int ib_uverbs_event_close(struct inode *inode, struct file *filp)
+static int ib_uverbs_async_event_close(struct inode *inode, struct file *filp)
 {
 	struct ib_uverbs_event_file *file = filp->private_data;
 	struct ib_uverbs_event *entry, *tmp;
@@ -474,6 +369,25 @@ static int ib_uverbs_event_close(struct inode *inode, struct file *filp)
 	mutex_unlock(&file->uverbs_file->device->lists_mutex);
 
 	kref_put(&file->uverbs_file->ref, ib_uverbs_release_file);
+	kref_put(&file->ref, ib_uverbs_release_async_event_file);
+
+	return 0;
+}
+
+static int ib_uverbs_event_close(struct inode *inode, struct file *filp)
+{
+	struct ib_uverbs_event_file *file = filp->private_data;
+	struct ib_uverbs_event *entry, *tmp;
+
+	spin_lock_irq(&file->lock);
+	list_for_each_entry_safe(entry, tmp, &file->event_list, list) {
+		if (entry->counter)
+			list_del(&entry->obj_list);
+		kfree(entry);
+	}
+	spin_unlock_irq(&file->lock);
+
+	ib_uverbs_close_fd(filp);
 	kref_put(&file->ref, ib_uverbs_release_event_file);
 
 	return 0;
@@ -488,6 +402,15 @@ const struct file_operations uverbs_event_fops = {
 	.llseek	 = no_llseek,
 };
 
+static const struct file_operations uverbs_async_event_fops = {
+	.owner	 = THIS_MODULE,
+	.read	 = ib_uverbs_event_read,
+	.poll    = ib_uverbs_event_poll,
+	.release = ib_uverbs_async_event_close,
+	.fasync  = ib_uverbs_event_fasync,
+	.llseek	 = no_llseek,
+};
+
 void ib_uverbs_comp_handler(struct ib_cq *cq, void *cq_context)
 {
 	struct ib_uverbs_event_file    *file = cq_context;
@@ -572,7 +495,8 @@ void ib_uverbs_qp_event_handler(struct ib_event *event, void *context_ptr)
 	struct ib_uevent_object *uobj;
 
 	/* for XRC target qp's, check that qp is live */
-	if (!event->element.qp->uobject || !event->element.qp->uobject->live)
+	if (!event->element.qp->uobject ||
+	    !uverbs_is_live(event->element.qp->uobject))
 		return;
 
 	uobj = container_of(event->element.qp->uobject,
@@ -617,13 +541,12 @@ void ib_uverbs_event_handler(struct ib_event_handler *handler,
 
 void ib_uverbs_free_async_event_file(struct ib_uverbs_file *file)
 {
-	kref_put(&file->async_file->ref, ib_uverbs_release_event_file);
+	kref_put(&file->async_file->ref, ib_uverbs_release_async_event_file);
 	file->async_file = NULL;
 }
 
-struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
-					struct ib_device	*ib_dev,
-					int is_async)
+struct file *ib_uverbs_alloc_async_event_file(struct ib_uverbs_file *uverbs_file,
+					      struct ib_device	*ib_dev)
 {
 	struct ib_uverbs_event_file *ev_file;
 	struct file *filp;
@@ -642,7 +565,7 @@ struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
 	ev_file->async_queue = NULL;
 	ev_file->is_closed   = 0;
 
-	filp = anon_inode_getfile("[infinibandevent]", &uverbs_event_fops,
+	filp = anon_inode_getfile("[infinibandevent]", &uverbs_async_event_fops,
 				  ev_file, O_RDONLY);
 	if (IS_ERR(filp))
 		goto err_put_refs;
@@ -652,26 +575,25 @@ struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
 		      &uverbs_file->device->uverbs_events_file_list);
 	mutex_unlock(&uverbs_file->device->lists_mutex);
 
-	if (is_async) {
-		WARN_ON(uverbs_file->async_file);
-		uverbs_file->async_file = ev_file;
-		kref_get(&uverbs_file->async_file->ref);
-		INIT_IB_EVENT_HANDLER(&uverbs_file->event_handler,
-				      ib_dev,
-				      ib_uverbs_event_handler);
-		ret = ib_register_event_handler(&uverbs_file->event_handler);
-		if (ret)
-			goto err_put_file;
-
-		/* At that point async file stuff was fully set */
-		ev_file->is_async = 1;
-	}
+	WARN_ON(uverbs_file->async_file);
+	uverbs_file->async_file = ev_file;
+	kref_get(&uverbs_file->async_file->ref);
+	INIT_IB_EVENT_HANDLER(&uverbs_file->event_handler,
+			      ib_dev,
+			      ib_uverbs_event_handler);
+	ret = ib_register_event_handler(&uverbs_file->event_handler);
+	if (ret)
+		goto err_put_file;
+
+	/* At that point async file stuff was fully set */
+	ev_file->is_async = 1;
 
 	return filp;
 
 err_put_file:
 	fput(filp);
-	kref_put(&uverbs_file->async_file->ref, ib_uverbs_release_event_file);
+	kref_put(&uverbs_file->async_file->ref,
+		 ib_uverbs_release_async_event_file);
 	uverbs_file->async_file = NULL;
 	return ERR_PTR(ret);
 
@@ -681,35 +603,6 @@ err_put_refs:
 	return filp;
 }
 
-/*
- * Look up a completion event file by FD.  If lookup is successful,
- * takes a ref to the event file struct that it returns; if
- * unsuccessful, returns NULL.
- */
-struct ib_uverbs_event_file *ib_uverbs_lookup_comp_file(int fd)
-{
-	struct ib_uverbs_event_file *ev_file = NULL;
-	struct fd f = fdget(fd);
-
-	if (!f.file)
-		return NULL;
-
-	if (f.file->f_op != &uverbs_event_fops)
-		goto out;
-
-	ev_file = f.file->private_data;
-	if (ev_file->is_async) {
-		ev_file = NULL;
-		goto out;
-	}
-
-	kref_get(&ev_file->ref);
-
-out:
-	fdput(f);
-	return ev_file;
-}
-
 static int verify_command_mask(struct ib_device *ib_dev, __u32 command)
 {
 	u64 mask;
@@ -998,7 +891,8 @@ static int ib_uverbs_close(struct inode *inode, struct file *filp)
 	mutex_unlock(&file->device->lists_mutex);
 
 	if (file->async_file)
-		kref_put(&file->async_file->ref, ib_uverbs_release_event_file);
+		kref_put(&file->async_file->ref,
+			 ib_uverbs_release_async_event_file);
 
 	kref_put(&file->ref, ib_uverbs_release_file);
 	kobject_put(&dev->kobj);
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index f4160d5..a10b203 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -55,6 +55,7 @@
 #include <linux/etherdevice.h>
 #include <linux/mlx5/fs.h>
 #include "mlx5_ib.h"
+#include <rdma/uverbs_ioctl_cmd.h>
 
 #define DRIVER_NAME "mlx5_ib"
 #define DRIVER_VERSION "2.2-1"
@@ -2918,6 +2919,8 @@ free:
 	return ARRAY_SIZE(names);
 }
 
+DECLARE_UVERBS_TYPES_GROUP(root, &uverbs_common_types);
+
 static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 {
 	struct mlx5_ib_dev *dev;
@@ -3128,6 +3131,7 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	if (err)
 		goto err_odp;
 
+	dev->ib_dev.specs_root = (struct uverbs_root *)&root;
 	err = ib_register_device(&dev->ib_dev, NULL);
 	if (err)
 		goto err_q_cnt;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 282b0ba..f8eeca4 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1334,17 +1334,6 @@ struct ib_ucontext_lock;
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
 
 	/* lock for uobjects list */
@@ -1378,11 +1367,8 @@ struct ib_uobject {
 	void		       *object;		/* containing object */
 	struct list_head	list;		/* link to context's list */
 	int			id;		/* index into kernel idr/fd */
-	struct kref             ref;
 	struct rw_semaphore	usecnt;		/* protects exclusive access */
-	struct rw_semaphore     mutex;          /* protects .live */
 	struct rcu_head		rcu;		/* kfree_rcu() overhead */
-	int			live;
 
 	const struct uverbs_type_alloc_action *type;
 	struct ib_ucontext_lock	*uobjects_lock;
@@ -2116,7 +2102,7 @@ struct ib_device {
 	void (*get_dev_fw_str)(struct ib_device *, char *str, size_t str_len);
 	struct list_head type_list;
 
-	const struct uverbs_types_group	*types_group;
+	struct uverbs_root                      *specs_root;
 };
 
 struct ib_client {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
