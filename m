From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 7/7] IB/core: Use the new IDR and locking infrastructure in uverbs_cmd
Date: Wed, 11 Jan 2017 12:53:53 +0200
Message-ID: <1484132033-3346-8-git-send-email-matanb@mellanox.com>
References: <1484132033-3346-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1484132033-3346-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
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
    Its release function and release context are serialized by the
    infrastructure.
(*) The live flag is no longer required as we first allocate an IDR
      and assign a NULL object. When we actually want to enable this
      IDR, we replace the NULL with the actual object.
(*) The handler may need to assign the user_handle field of the
      uobject explicitly.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/rdma_core.c          |    5 +
 drivers/infiniband/core/rdma_core.h          |    2 +
 drivers/infiniband/core/uverbs.h             |   11 +-
 drivers/infiniband/core/uverbs_cmd.c         | 1112 ++++++++------------------
 drivers/infiniband/core/uverbs_main.c        |  251 ++----
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |    4 +
 drivers/infiniband/hw/cxgb4/provider.c       |    4 +
 drivers/infiniband/hw/hns/hns_roce_main.c    |    4 +
 drivers/infiniband/hw/i40iw/i40iw_verbs.c    |    4 +
 drivers/infiniband/hw/mlx4/main.c            |    4 +
 drivers/infiniband/hw/mlx5/main.c            |    4 +
 drivers/infiniband/hw/mthca/mthca_provider.c |    4 +
 drivers/infiniband/hw/nes/nes_verbs.c        |    4 +
 drivers/infiniband/hw/ocrdma/ocrdma_main.c   |    4 +
 drivers/infiniband/hw/usnic/usnic_ib_main.c  |    4 +
 drivers/infiniband/sw/rdmavt/vt.c            |    4 +
 drivers/infiniband/sw/rxe/rxe_verbs.c        |    4 +
 include/rdma/ib_verbs.h                      |   16 +-
 18 files changed, 486 insertions(+), 959 deletions(-)

diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index 4654c74..5b40120 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -63,6 +63,11 @@ static struct ib_uobject *get_uobj_rcu(int id, struct ib_ucontext *context)
 	return uobj;
 }
 
+bool uverbs_is_live(struct ib_uobject *uobj)
+{
+	return uobj == get_uobj_rcu(uobj->id, uobj->context);
+}
+
 struct ib_ucontext_lock {
 	struct kref  ref;
 	/* locking the uobjects_list */
diff --git a/drivers/infiniband/core/rdma_core.h b/drivers/infiniband/core/rdma_core.h
index d06bae6..b149471 100644
--- a/drivers/infiniband/core/rdma_core.h
+++ b/drivers/infiniband/core/rdma_core.h
@@ -54,6 +54,8 @@ struct ib_uobject *uverbs_get_uobject_from_context(const struct uverbs_type_allo
 						   enum uverbs_idr_access access,
 						   unsigned int id);
 
+/* Check if the object is still alive. This must be called within RCU */
+bool uverbs_is_live(struct ib_uobject *uobj);
 void uverbs_finalize_object(struct ib_uobject *uobj,
 			    enum uverbs_idr_access access,
 			    bool success);
diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 1940bb9..70661bd 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -158,6 +158,8 @@ struct ib_usrq_object {
 
 struct ib_uqp_object {
 	struct ib_uevent_object	uevent;
+	/* lock for mcast list */
+	struct mutex		mcast_lock;
 	struct list_head 	mcast_list;
 	struct ib_uxrcd_object *uxrcd;
 };
@@ -175,14 +177,13 @@ struct ib_ucq_object {
 	u32			async_events_reported;
 };
 
-void idr_remove_uobj(struct ib_uobject *uobj);
 extern const struct file_operations uverbs_event_fops;
 
-struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
-					struct ib_device *ib_dev,
-					int is_async);
+void ib_uverbs_init_event_file(struct ib_uverbs_event_file *ev_file,
+			       struct ib_uverbs_file *uverbs_file);
+struct file *ib_uverbs_alloc_async_event_file(struct ib_uverbs_file *uverbs_file,
+					      struct ib_device *ib_dev);
 void ib_uverbs_free_async_event_file(struct ib_uverbs_file *uverbs_file);
-struct ib_uverbs_event_file *ib_uverbs_lookup_comp_file(int fd);
 
 void ib_uverbs_release_ucq(struct ib_uverbs_file *file,
 			   struct ib_uverbs_event_file *ev_file,
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 9e3c7db..339d564 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -40,269 +40,67 @@
 
 #include <linux/uaccess.h>
 
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
+#define idr_get_xxxx(_type, _access, _handle, _context) ({		\
+	const struct uverbs_type * const type = &uverbs_type_## _type;	\
+	struct ib_uobject *uobj = uverbs_get_uobject_from_context(		\
+					type->alloc,			\
+					_context, _access, _handle);	\
+									\
+	IS_ERR(uobj) ? NULL : uobj->object; })
 
 static struct ib_pd *idr_read_pd(int pd_handle, struct ib_ucontext *context)
 {
-	return idr_read_obj(pd_handle, context, 0);
+	return idr_get_xxxx(pd, UVERBS_ACCESS_READ, pd_handle, context);
 }
 
-static void put_pd_read(struct ib_pd *pd)
+static struct ib_cq *idr_read_cq(int cq_handle, struct ib_ucontext *context)
 {
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
-static void put_ah_read(struct ib_ah *ah)
-{
-	put_uobj_read(ah->uobject);
+	return idr_get_xxxx(cq, UVERBS_ACCESS_READ, cq_handle, context);
 }
 
 static struct ib_ah *idr_read_ah(int ah_handle, struct ib_ucontext *context)
 {
-	return idr_read_obj(ah_handle, context, 0);
+	return idr_get_xxxx(ah, UVERBS_ACCESS_READ, ah_handle, context);
 }
 
 static struct ib_qp *idr_read_qp(int qp_handle, struct ib_ucontext *context)
 {
-	return idr_read_obj(qp_handle, context, 0);
+	return idr_get_xxxx(qp, UVERBS_ACCESS_READ, qp_handle, context);
 }
 
 static struct ib_wq *idr_read_wq(int wq_handle, struct ib_ucontext *context)
 {
-	return idr_read_obj(wq_handle, context, 0);
-}
-
-static void put_wq_read(struct ib_wq *wq)
-{
-	put_uobj_read(wq->uobject);
+	return idr_get_xxxx(wq, UVERBS_ACCESS_READ, wq_handle, context);
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
+	return idr_get_xxxx(rwq_ind_table, UVERBS_ACCESS_READ,
+			    ind_table_handle, context);
 }
 
 static struct ib_srq *idr_read_srq(int srq_handle, struct ib_ucontext *context)
 {
-	return idr_read_obj(srq_handle, context, 0);
-}
-
-static void put_srq_read(struct ib_srq *srq)
-{
-	put_uobj_read(srq->uobject);
+	return idr_get_xxxx(srq, UVERBS_ACCESS_READ, srq_handle, context);
 }
 
 static struct ib_xrcd *idr_read_xrcd(int xrcd_handle, struct ib_ucontext *context,
 				     struct ib_uobject **uobj)
 {
-	*uobj = idr_read_uobj(xrcd_handle, context, 0);
+	*uobj = uverbs_get_uobject_from_context(uverbs_type_xrcd.alloc,
+						context, UVERBS_ACCESS_READ,
+						xrcd_handle);
 	return *uobj ? (*uobj)->object : NULL;
 }
 
-static void put_xrcd_read(struct ib_uobject *uobj)
-{
-	put_uobj_read(uobj);
-}
 ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 			      struct ib_device *ib_dev,
 			      const char __user *buf,
@@ -339,17 +137,12 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
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
+	/* ufile is required when some objects are released */
+	ucontext->ufile = file;
+	ret = uverbs_initialize_ucontext(ucontext);
+	if (ret)
+		goto err_ctx;
+
 	rcu_read_lock();
 	ucontext->tgid = get_task_pid(current->group_leader, PIDTYPE_PID);
 	rcu_read_unlock();
@@ -373,7 +166,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 		goto err_free;
 	resp.async_fd = ret;
 
-	filp = ib_uverbs_alloc_event_file(file, ib_dev, 1);
+	filp = ib_uverbs_alloc_async_event_file(file, ib_dev);
 	if (IS_ERR(filp)) {
 		ret = PTR_ERR(filp);
 		goto err_fd;
@@ -402,6 +195,8 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 
 err_free:
 	put_pid(ucontext->tgid);
+	uverbs_release_ucontext(ucontext);
+err_ctx:
 	ib_dev->dealloc_ucontext(ucontext);
 
 err:
@@ -553,12 +348,10 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 		   (unsigned long) cmd.response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
-	uobj = kmalloc(sizeof *uobj, GFP_KERNEL);
-	if (!uobj)
-		return -ENOMEM;
-
-	init_uobj(uobj, 0, file->ucontext, &pd_lock_class);
-	down_write(&uobj->mutex);
+	uobj = uverbs_get_uobject_from_context(uverbs_type_pd.alloc, file->ucontext,
+					       UVERBS_ACCESS_NEW, 0);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
 
 	pd = ib_dev->alloc_pd(ib_dev, file->ucontext, &udata);
 	if (IS_ERR(pd)) {
@@ -570,12 +363,7 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
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
 
@@ -585,24 +373,14 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 		goto err_copy;
 	}
 
-	mutex_lock(&file->mutex);
-	list_add_tail(&uobj->list, &file->ucontext->pd_list);
-	mutex_unlock(&file->mutex);
-
-	uobj->live = 1;
-
-	up_write(&uobj->mutex);
+	uverbs_finalize_object(uobj, UVERBS_ACCESS_NEW, true);
 
 	return in_len;
 
 err_copy:
-	idr_remove_uobj(uobj);
-
-err_idr:
 	ib_dealloc_pd(pd);
-
 err:
-	put_uobj_write(uobj);
+	uverbs_finalize_object(uobj, UVERBS_ACCESS_NEW, false);
 	return ret;
 }
 
@@ -619,9 +397,11 @@ ssize_t ib_uverbs_dealloc_pd(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(cmd.pd_handle, file->ucontext);
-	if (!uobj)
-		return -EINVAL;
+	uobj = uverbs_get_uobject_from_context(uverbs_type_pd.alloc, file->ucontext,
+					       UVERBS_ACCESS_DESTROY,
+					       cmd.pd_handle);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
 	pd = uobj->object;
 
 	if (atomic_read(&pd->usecnt)) {
@@ -634,21 +414,12 @@ ssize_t ib_uverbs_dealloc_pd(struct ib_uverbs_file *file,
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
+	uverbs_finalize_object(uobj, UVERBS_ACCESS_DESTROY, true);
 
 	return in_len;
 
 err_put:
-	put_uobj_write(uobj);
+	uverbs_finalize_object(uobj, UVERBS_ACCESS_DESTROY, false);
 	return ret;
 }
 
@@ -786,16 +557,14 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 		}
 	}
 
-	obj = kmalloc(sizeof *obj, GFP_KERNEL);
-	if (!obj) {
-		ret = -ENOMEM;
+	obj = (struct ib_uxrcd_object *)
+		uverbs_get_uobject_from_context(uverbs_type_xrcd.alloc, file->ucontext,
+						UVERBS_ACCESS_NEW, 0);
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
@@ -813,10 +582,6 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 
 	atomic_set(&obj->refcnt, 0);
 	obj->uobject.object = xrcd;
-	ret = idr_add_uobj(&obj->uobject);
-	if (ret)
-		goto err_idr;
-
 	memset(&resp, 0, sizeof resp);
 	resp.xrcd_handle = obj->uobject.id;
 
@@ -825,7 +590,7 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 			/* create new inode/xrcd table entry */
 			ret = xrcd_table_insert(file->device, inode, xrcd);
 			if (ret)
-				goto err_insert_xrcd;
+				goto err_dealloc_xrcd;
 		}
 		atomic_inc(&xrcd->usecnt);
 	}
@@ -839,12 +604,7 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 	if (f.file)
 		fdput(f);
 
-	mutex_lock(&file->mutex);
-	list_add_tail(&obj->uobject.list, &file->ucontext->xrcd_list);
-	mutex_unlock(&file->mutex);
-
-	obj->uobject.live = 1;
-	up_write(&obj->uobject.mutex);
+	uverbs_finalize_object(&obj->uobject, UVERBS_ACCESS_NEW, true);
 
 	mutex_unlock(&file->device->xrcd_tree_mutex);
 	return in_len;
@@ -856,14 +616,11 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
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
+	uverbs_finalize_object(&obj->uobject, UVERBS_ACCESS_NEW, false);
 
 err_tree_mutex_unlock:
 	if (f.file)
@@ -884,24 +641,25 @@ ssize_t ib_uverbs_close_xrcd(struct ib_uverbs_file *file,
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
+	uobj = uverbs_get_uobject_from_context(uverbs_type_xrcd.alloc, file->ucontext,
+					       UVERBS_ACCESS_DESTROY,
+					       cmd.xrcd_handle);
+	if (IS_ERR(uobj)) {
+		mutex_unlock(&file->device->xrcd_tree_mutex);
+		return PTR_ERR(uobj);
 	}
 
 	xrcd  = uobj->object;
 	inode = xrcd->inode;
 	obj   = container_of(uobj, struct ib_uxrcd_object, uobject);
 	if (atomic_read(&obj->refcnt)) {
-		put_uobj_write(uobj);
 		ret = -EBUSY;
 		goto out;
 	}
@@ -909,30 +667,24 @@ ssize_t ib_uverbs_close_xrcd(struct ib_uverbs_file *file,
 	if (!inode || atomic_dec_and_test(&xrcd->usecnt)) {
 		ret = ib_dealloc_xrcd(uobj->object);
 		if (!ret)
-			uobj->live = 0;
+			uverbs_finalize_object(uobj, UVERBS_ACCESS_DESTROY, true);
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
+		uverbs_finalize_object(uobj, UVERBS_ACCESS_DESTROY, false);
 	mutex_unlock(&file->device->xrcd_tree_mutex);
 	return ret;
 }
@@ -982,12 +734,10 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
-	uobj = kmalloc(sizeof *uobj, GFP_KERNEL);
-	if (!uobj)
-		return -ENOMEM;
-
-	init_uobj(uobj, 0, file->ucontext, &mr_lock_class);
-	down_write(&uobj->mutex);
+	uobj = uverbs_get_uobject_from_context(uverbs_type_mr.alloc, file->ucontext,
+					       UVERBS_ACCESS_NEW, 0);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
 
 	pd = idr_read_pd(cmd.pd_handle, file->ucontext);
 	if (!pd) {
@@ -1017,9 +767,6 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 	atomic_inc(&pd->usecnt);
 
 	uobj->object = mr;
-	ret = idr_add_uobj(uobj);
-	if (ret)
-		goto err_unreg;
 
 	memset(&resp, 0, sizeof resp);
 	resp.lkey      = mr->lkey;
@@ -1032,29 +779,20 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 		goto err_copy;
 	}
 
-	put_pd_read(pd);
-
-	mutex_lock(&file->mutex);
-	list_add_tail(&uobj->list, &file->ucontext->mr_list);
-	mutex_unlock(&file->mutex);
-
-	uobj->live = 1;
+	uverbs_finalize_object(pd->uobject, UVERBS_ACCESS_READ, true);
 
-	up_write(&uobj->mutex);
+	uverbs_finalize_object(uobj, UVERBS_ACCESS_NEW, true);
 
 	return in_len;
 
 err_copy:
-	idr_remove_uobj(uobj);
-
-err_unreg:
 	ib_dereg_mr(mr);
 
 err_put:
-	put_pd_read(pd);
+	uverbs_finalize_object(pd->uobject, UVERBS_ACCESS_READ, false);
 
 err_free:
-	put_uobj_write(uobj);
+	uverbs_finalize_object(uobj, UVERBS_ACCESS_NEW, false);
 	return ret;
 }
 
@@ -1090,10 +828,11 @@ ssize_t ib_uverbs_rereg_mr(struct ib_uverbs_file *file,
 	     (cmd.start & ~PAGE_MASK) != (cmd.hca_va & ~PAGE_MASK)))
 			return -EINVAL;
 
-	uobj = idr_write_uobj(cmd.mr_handle, file->ucontext);
-
-	if (!uobj)
-		return -EINVAL;
+	uobj = uverbs_get_uobject_from_context(uverbs_type_mr.alloc, file->ucontext,
+					       UVERBS_ACCESS_WRITE,
+					       cmd.mr_handle);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
 
 	mr = uobj->object;
 
@@ -1137,11 +876,11 @@ ssize_t ib_uverbs_rereg_mr(struct ib_uverbs_file *file,
 
 put_uobj_pd:
 	if (cmd.flags & IB_MR_REREG_PD)
-		put_pd_read(pd);
+		uverbs_finalize_object(pd->uobject,
+				       UVERBS_ACCESS_READ, ret == in_len);
 
 put_uobjs:
-
-	put_uobj_write(mr->uobject);
+	uverbs_finalize_object(uobj, UVERBS_ACCESS_WRITE, ret == in_len);
 
 	return ret;
 }
@@ -1159,28 +898,22 @@ ssize_t ib_uverbs_dereg_mr(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(cmd.mr_handle, file->ucontext);
-	if (!uobj)
-		return -EINVAL;
+	uobj = uverbs_get_uobject_from_context(uverbs_type_mr.alloc, file->ucontext,
+					       UVERBS_ACCESS_DESTROY,
+					       cmd.mr_handle);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
 
 	mr = uobj->object;
 
 	ret = ib_dereg_mr(mr);
-	if (!ret)
-		uobj->live = 0;
-
-	put_uobj_write(uobj);
 
-	if (ret)
+	if (ret) {
+		uverbs_finalize_object(uobj, UVERBS_ACCESS_DESTROY, false);
 		return ret;
+	}
 
-	idr_remove_uobj(uobj);
-
-	mutex_lock(&file->mutex);
-	list_del(&uobj->list);
-	mutex_unlock(&file->mutex);
-
-	put_uobj(uobj);
+	uverbs_finalize_object(uobj, UVERBS_ACCESS_DESTROY, true);
 
 	return in_len;
 }
@@ -1204,12 +937,10 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof(cmd)))
 		return -EFAULT;
 
-	uobj = kmalloc(sizeof(*uobj), GFP_KERNEL);
-	if (!uobj)
-		return -ENOMEM;
-
-	init_uobj(uobj, 0, file->ucontext, &mw_lock_class);
-	down_write(&uobj->mutex);
+	uobj = uverbs_get_uobject_from_context(uverbs_type_mw.alloc, file->ucontext,
+					       UVERBS_ACCESS_NEW, 0);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
 
 	pd = idr_read_pd(cmd.pd_handle, file->ucontext);
 	if (!pd) {
@@ -1234,9 +965,6 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 	atomic_inc(&pd->usecnt);
 
 	uobj->object = mw;
-	ret = idr_add_uobj(uobj);
-	if (ret)
-		goto err_unalloc;
 
 	memset(&resp, 0, sizeof(resp));
 	resp.rkey      = mw->rkey;
@@ -1248,29 +976,17 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
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
+	uverbs_finalize_object(pd->uobject, UVERBS_ACCESS_READ, true);
+	uverbs_finalize_object(uobj, UVERBS_ACCESS_NEW, true);
 
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
+	uverbs_finalize_object(pd->uobject, UVERBS_ACCESS_READ, false);
 err_free:
-	put_uobj_write(uobj);
+	uverbs_finalize_object(uobj, UVERBS_ACCESS_NEW, false);
 	return ret;
 }
 
@@ -1287,28 +1003,21 @@ ssize_t ib_uverbs_dealloc_mw(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof(cmd)))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(cmd.mw_handle, file->ucontext);
-	if (!uobj)
-		return -EINVAL;
+	uobj = uverbs_get_uobject_from_context(uverbs_type_mw.alloc, file->ucontext,
+					       UVERBS_ACCESS_DESTROY,
+					       cmd.mw_handle);
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
+		uverbs_finalize_object(uobj, UVERBS_ACCESS_DESTROY, false);
 		return ret;
+	}
 
-	idr_remove_uobj(uobj);
-
-	mutex_lock(&file->mutex);
-	list_del(&uobj->list);
-	mutex_unlock(&file->mutex);
-
-	put_uobj(uobj);
+	uverbs_finalize_object(uobj, UVERBS_ACCESS_DESTROY, true);
 
 	return in_len;
 }
@@ -1320,8 +1029,8 @@ ssize_t ib_uverbs_create_comp_channel(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_create_comp_channel	   cmd;
 	struct ib_uverbs_create_comp_channel_resp  resp;
-	struct file				  *filp;
-	int ret;
+	struct ib_uobject			  *uobj;
+	struct ib_uverbs_event_file		  *ev_file;
 
 	if (out_len < sizeof resp)
 		return -ENOSPC;
@@ -1329,25 +1038,24 @@ ssize_t ib_uverbs_create_comp_channel(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	ret = get_unused_fd_flags(O_CLOEXEC);
-	if (ret < 0)
-		return ret;
-	resp.fd = ret;
+	uobj = uverbs_get_uobject_from_context(uverbs_type_comp_channel.alloc,
+					       file->ucontext,
+					       UVERBS_ACCESS_NEW, 0);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
 
-	filp = ib_uverbs_alloc_event_file(file, ib_dev, 0);
-	if (IS_ERR(filp)) {
-		put_unused_fd(resp.fd);
-		return PTR_ERR(filp);
-	}
+	resp.fd = uobj->id;
+
+	ev_file = uverbs_fd_uobj_to_priv(uobj);
+	ib_uverbs_init_event_file(ev_file, file);
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp)) {
-		put_unused_fd(resp.fd);
-		fput(filp);
+		uverbs_finalize_object(uobj, UVERBS_ACCESS_NEW, false);
 		return -EFAULT;
 	}
 
-	fd_install(resp.fd, filp);
+	uverbs_finalize_object(uobj, UVERBS_ACCESS_NEW, true);
 	return in_len;
 }
 
@@ -1365,6 +1073,7 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 				       void *context)
 {
 	struct ib_ucq_object           *obj;
+	struct ib_uobject	       *ev_uobj = NULL;
 	struct ib_uverbs_event_file    *ev_file = NULL;
 	struct ib_cq                   *cq;
 	int                             ret;
@@ -1374,21 +1083,27 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 	if (cmd->comp_vector >= file->device->num_comp_vectors)
 		return ERR_PTR(-EINVAL);
 
-	obj = kmalloc(sizeof *obj, GFP_KERNEL);
-	if (!obj)
-		return ERR_PTR(-ENOMEM);
-
-	init_uobj(&obj->uobject, cmd->user_handle, file->ucontext, &cq_lock_class);
-	down_write(&obj->uobject.mutex);
+	obj = (struct ib_ucq_object *)uverbs_get_uobject_from_context(
+						uverbs_type_cq.alloc,
+						file->ucontext,
+						UVERBS_ACCESS_NEW, 0);
+	if (IS_ERR(obj))
+		return obj;
 
 	if (cmd->comp_channel >= 0) {
-		ev_file = ib_uverbs_lookup_comp_file(cmd->comp_channel);
-		if (!ev_file) {
-			ret = -EINVAL;
+		ev_uobj = uverbs_get_uobject_from_context(uverbs_type_comp_channel.alloc,
+							  file->ucontext,
+							  UVERBS_ACCESS_READ,
+							  cmd->comp_channel);
+		if (IS_ERR(ev_uobj)) {
+			ret = PTR_ERR(ev_uobj);
 			goto err;
 		}
+		ev_file = uverbs_fd_uobj_to_priv(ev_uobj);
+		kref_get(&ev_file->ref);
 	}
 
+	obj->uobject.user_handle = cmd->user_handle;
 	obj->uverbs_file	   = file;
 	obj->comp_events_reported  = 0;
 	obj->async_events_reported = 0;
@@ -1401,8 +1116,7 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 	if (cmd_sz > offsetof(typeof(*cmd), flags) + sizeof(cmd->flags))
 		attr.flags = cmd->flags;
 
-	cq = ib_dev->create_cq(ib_dev, &attr,
-					     file->ucontext, uhw);
+	cq = ib_dev->create_cq(ib_dev, &attr, file->ucontext, uhw);
 	if (IS_ERR(cq)) {
 		ret = PTR_ERR(cq);
 		goto err_file;
@@ -1416,10 +1130,6 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 	atomic_set(&cq->usecnt, 0);
 
 	obj->uobject.object = cq;
-	ret = idr_add_uobj(&obj->uobject);
-	if (ret)
-		goto err_free;
-
 	memset(&resp, 0, sizeof resp);
 	resp.base.cq_handle = obj->uobject.id;
 	resp.base.cqe       = cq->cqe;
@@ -1431,28 +1141,20 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
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
+		uverbs_finalize_object(ev_uobj, UVERBS_ACCESS_READ, true);
+	uverbs_finalize_object(&obj->uobject, UVERBS_ACCESS_NEW, true);
 
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
+		uverbs_finalize_object(ev_uobj, UVERBS_ACCESS_READ, false);
 err:
-	put_uobj_write(&obj->uobject);
+	uverbs_finalize_object(&obj->uobject, UVERBS_ACCESS_NEW, false);
 
 	return ERR_PTR(ret);
 }
@@ -1575,7 +1277,7 @@ ssize_t ib_uverbs_resize_cq(struct ib_uverbs_file *file,
 		   (unsigned long) cmd.response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
-	cq = idr_read_cq(cmd.cq_handle, file->ucontext, 0);
+	cq = idr_read_cq(cmd.cq_handle, file->ucontext);
 	if (!cq)
 		return -EINVAL;
 
@@ -1590,7 +1292,7 @@ ssize_t ib_uverbs_resize_cq(struct ib_uverbs_file *file,
 		ret = -EFAULT;
 
 out:
-	put_cq_read(cq);
+	uverbs_finalize_object(cq->uobject, UVERBS_ACCESS_READ, !ret);
 
 	return ret ? ret : in_len;
 }
@@ -1637,7 +1339,7 @@ ssize_t ib_uverbs_poll_cq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	cq = idr_read_cq(cmd.cq_handle, file->ucontext, 0);
+	cq = idr_read_cq(cmd.cq_handle, file->ucontext);
 	if (!cq)
 		return -EINVAL;
 
@@ -1669,7 +1371,8 @@ ssize_t ib_uverbs_poll_cq(struct ib_uverbs_file *file,
 	ret = in_len;
 
 out_put:
-	put_cq_read(cq);
+	uverbs_finalize_object(cq->uobject, UVERBS_ACCESS_READ,
+			       ret == in_len);
 	return ret;
 }
 
@@ -1684,14 +1387,14 @@ ssize_t ib_uverbs_req_notify_cq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	cq = idr_read_cq(cmd.cq_handle, file->ucontext, 0);
+	cq = idr_read_cq(cmd.cq_handle, file->ucontext);
 	if (!cq)
 		return -EINVAL;
 
 	ib_req_notify_cq(cq, cmd.solicited_only ?
 			 IB_CQ_SOLICITED : IB_CQ_NEXT_COMP);
 
-	put_cq_read(cq);
+	uverbs_finalize_object(cq->uobject, UVERBS_ACCESS_READ, true);
 
 	return in_len;
 }
@@ -1712,36 +1415,30 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(cmd.cq_handle, file->ucontext);
-	if (!uobj)
-		return -EINVAL;
+	uobj = uverbs_get_uobject_from_context(uverbs_type_cq.alloc,
+					       file->ucontext,
+					       UVERBS_ACCESS_DESTROY,
+					       cmd.cq_handle);
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
+		uverbs_finalize_object(uobj, UVERBS_ACCESS_DESTROY, false);
 		return ret;
-
-	idr_remove_uobj(uobj);
-
-	mutex_lock(&file->mutex);
-	list_del(&uobj->list);
-	mutex_unlock(&file->mutex);
+	}
 
 	ib_uverbs_release_ucq(file, ev_file, obj);
+	uverbs_finalize_object(uobj, UVERBS_ACCESS_DESTROY, true);
 
 	memset(&resp, 0, sizeof resp);
 	resp.comp_events_reported  = obj->comp_events_reported;
 	resp.async_events_reported = obj->async_events_reported;
 
-	put_uobj(uobj);
-
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp))
 		return -EFAULT;
@@ -1777,13 +1474,16 @@ static int create_qp(struct ib_uverbs_file *file,
 	if (cmd->qp_type == IB_QPT_RAW_PACKET && !capable(CAP_NET_RAW))
 		return -EPERM;
 
-	obj = kzalloc(sizeof *obj, GFP_KERNEL);
-	if (!obj)
-		return -ENOMEM;
+	obj = (struct ib_uqp_object *)uverbs_get_uobject_from_context(
+						uverbs_type_qp.alloc,
+						file->ucontext,
+						UVERBS_ACCESS_NEW, 0);
+	if (IS_ERR(obj))
+		return PTR_ERR(obj);
+	obj->uxrcd = NULL;
+	obj->uevent.uobject.user_handle = cmd->user_handle;
+	mutex_init(&obj->mcast_lock);
 
-	init_uobj(&obj->uevent.uobject, cmd->user_handle, file->ucontext,
-		  &qp_lock_class);
-	down_write(&obj->uevent.uobject.mutex);
 	if (cmd_sz >= offsetof(typeof(*cmd), rwq_ind_tbl_handle) +
 		      sizeof(cmd->rwq_ind_tbl_handle) &&
 		      (cmd->comp_mask & IB_UVERBS_CREATE_QP_MASK_IND_TABLE)) {
@@ -1836,7 +1536,7 @@ static int create_qp(struct ib_uverbs_file *file,
 			if (!ind_tbl) {
 				if (cmd->recv_cq_handle != cmd->send_cq_handle) {
 					rcq = idr_read_cq(cmd->recv_cq_handle,
-							  file->ucontext, 0);
+							  file->ucontext);
 					if (!rcq) {
 						ret = -EINVAL;
 						goto err_put;
@@ -1846,7 +1546,7 @@ static int create_qp(struct ib_uverbs_file *file,
 		}
 
 		if (has_sq)
-			scq = idr_read_cq(cmd->send_cq_handle, file->ucontext, !!rcq);
+			scq = idr_read_cq(cmd->send_cq_handle, file->ucontext);
 		if (!ind_tbl)
 			rcq = rcq ?: scq;
 		pd  = idr_read_pd(cmd->pd_handle, file->ucontext);
@@ -1935,9 +1635,6 @@ static int create_qp(struct ib_uverbs_file *file,
 	qp->uobject = &obj->uevent.uobject;
 
 	obj->uevent.uobject.object = qp;
-	ret = idr_add_uobj(&obj->uevent.uobject);
-	if (ret)
-		goto err_destroy;
 
 	memset(&resp, 0, sizeof resp);
 	resp.base.qpn             = qp->qp_num;
@@ -1959,50 +1656,42 @@ static int create_qp(struct ib_uverbs_file *file,
 		obj->uxrcd = container_of(xrcd_uobj, struct ib_uxrcd_object,
 					  uobject);
 		atomic_inc(&obj->uxrcd->refcnt);
-		put_xrcd_read(xrcd_uobj);
+		uverbs_finalize_object(xrcd_uobj, UVERBS_ACCESS_READ, true);
 	}
 
 	if (pd)
-		put_pd_read(pd);
+		uverbs_finalize_object(pd->uobject, UVERBS_ACCESS_READ, true);
 	if (scq)
-		put_cq_read(scq);
+		uverbs_finalize_object(scq->uobject, UVERBS_ACCESS_READ, true);
 	if (rcq && rcq != scq)
-		put_cq_read(rcq);
+		uverbs_finalize_object(rcq->uobject, UVERBS_ACCESS_READ, true);
 	if (srq)
-		put_srq_read(srq);
+		uverbs_finalize_object(srq->uobject, UVERBS_ACCESS_READ, true);
 	if (ind_tbl)
-		put_rwq_indirection_table_read(ind_tbl);
+		uverbs_finalize_object(ind_tbl->uobject, UVERBS_ACCESS_READ, true);
 
-	mutex_lock(&file->mutex);
-	list_add_tail(&obj->uevent.uobject.list, &file->ucontext->qp_list);
-	mutex_unlock(&file->mutex);
-
-	obj->uevent.uobject.live = 1;
-
-	up_write(&obj->uevent.uobject.mutex);
+	uverbs_finalize_object(&obj->uevent.uobject, UVERBS_ACCESS_NEW, true);
 
 	return 0;
-err_cb:
-	idr_remove_uobj(&obj->uevent.uobject);
 
-err_destroy:
+err_cb:
 	ib_destroy_qp(qp);
 
 err_put:
 	if (xrcd)
-		put_xrcd_read(xrcd_uobj);
+		uverbs_finalize_object(xrcd_uobj, UVERBS_ACCESS_READ, false);
 	if (pd)
-		put_pd_read(pd);
+		uverbs_finalize_object(pd->uobject, UVERBS_ACCESS_READ, false);
 	if (scq)
-		put_cq_read(scq);
+		uverbs_finalize_object(scq->uobject, UVERBS_ACCESS_READ, false);
 	if (rcq && rcq != scq)
-		put_cq_read(rcq);
+		uverbs_finalize_object(rcq->uobject, UVERBS_ACCESS_READ, false);
 	if (srq)
-		put_srq_read(srq);
+		uverbs_finalize_object(srq->uobject, UVERBS_ACCESS_READ, false);
 	if (ind_tbl)
-		put_rwq_indirection_table_read(ind_tbl);
+		uverbs_finalize_object(ind_tbl->uobject, UVERBS_ACCESS_READ, false);
 
-	put_uobj_write(&obj->uevent.uobject);
+	uverbs_finalize_object(&obj->uevent.uobject, UVERBS_ACCESS_NEW, false);
 	return ret;
 }
 
@@ -2138,12 +1827,12 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
 		   (unsigned long) cmd.response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
-	obj = kmalloc(sizeof *obj, GFP_KERNEL);
-	if (!obj)
-		return -ENOMEM;
-
-	init_uobj(&obj->uevent.uobject, cmd.user_handle, file->ucontext, &qp_lock_class);
-	down_write(&obj->uevent.uobject.mutex);
+	obj = (struct ib_uqp_object *)uverbs_get_uobject_from_context(
+						uverbs_type_qp.alloc,
+						file->ucontext,
+						UVERBS_ACCESS_NEW, 0);
+	if (IS_ERR(obj))
+		return PTR_ERR(obj);
 
 	xrcd = idr_read_xrcd(cmd.pd_handle, file->ucontext, &xrcd_uobj);
 	if (!xrcd) {
@@ -2163,15 +1852,13 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
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
+	obj->uevent.uobject.user_handle = cmd.user_handle;
 
 	memset(&resp, 0, sizeof resp);
 	resp.qpn       = qp->qp_num;
@@ -2180,32 +1867,23 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
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
+	uverbs_finalize_object(xrcd_uobj, UVERBS_ACCESS_READ, true);
 
-	up_write(&obj->uevent.uobject.mutex);
+	uverbs_finalize_object(&obj->uevent.uobject, UVERBS_ACCESS_NEW, true);
 
 	return in_len;
 
-err_remove:
-	idr_remove_uobj(&obj->uevent.uobject);
-
 err_destroy:
 	ib_destroy_qp(qp);
-
+err_xrcd:
+	uverbs_finalize_object(xrcd_uobj, UVERBS_ACCESS_READ, false);
 err_put:
-	put_xrcd_read(xrcd_uobj);
-	put_uobj_write(&obj->uevent.uobject);
+	uverbs_finalize_object(&obj->uevent.uobject, UVERBS_ACCESS_NEW, false);
 	return ret;
 }
 
@@ -2238,9 +1916,7 @@ ssize_t ib_uverbs_query_qp(struct ib_uverbs_file *file,
 	}
 
 	ret = ib_query_qp(qp, attr, cmd.attr_mask, init_attr);
-
-	put_qp_read(qp);
-
+	uverbs_finalize_object(qp->uobject, UVERBS_ACCESS_READ, !ret);
 	if (ret)
 		goto out;
 
@@ -2407,7 +2083,7 @@ static int modify_qp(struct ib_uverbs_file *file,
 	}
 
 release_qp:
-	put_qp_read(qp);
+	uverbs_finalize_object(qp->uobject, UVERBS_ACCESS_READ, !ret);
 
 out:
 	kfree(attr);
@@ -2494,40 +2170,34 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 
 	memset(&resp, 0, sizeof resp);
 
-	uobj = idr_write_uobj(cmd.qp_handle, file->ucontext);
-	if (!uobj)
-		return -EINVAL;
+	uobj = uverbs_get_uobject_from_context(uverbs_type_qp.alloc, file->ucontext,
+					       UVERBS_ACCESS_DESTROY,
+					       cmd.qp_handle);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
+
 	qp  = uobj->object;
 	obj = container_of(uobj, struct ib_uqp_object, uevent.uobject);
 
 	if (!list_empty(&obj->mcast_list)) {
-		put_uobj_write(uobj);
+		uverbs_finalize_object(uobj, UVERBS_ACCESS_DESTROY, false);
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
+		uverbs_finalize_object(uobj, UVERBS_ACCESS_DESTROY, false);
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
+	uverbs_finalize_object(uobj, UVERBS_ACCESS_DESTROY, true);
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp))
@@ -2714,11 +2384,13 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 		ret = -EFAULT;
 
 out_put:
-	put_qp_read(qp);
+	uverbs_finalize_object(qp->uobject, UVERBS_ACCESS_READ, !ret);
 
 	while (wr) {
 		if (is_ud && ud_wr(wr)->ah)
-			put_ah_read(ud_wr(wr)->ah);
+			uverbs_finalize_object(ud_wr(wr)->ah->uobject,
+					       UVERBS_ACCESS_READ, !ret);
+
 		next = wr->next;
 		kfree(wr);
 		wr = next;
@@ -2842,14 +2514,14 @@ ssize_t ib_uverbs_post_recv(struct ib_uverbs_file *file,
 	resp.bad_wr = 0;
 	ret = qp->device->post_recv(qp->real_qp, wr, &bad_wr);
 
-	put_qp_read(qp);
-
-	if (ret)
+	uverbs_finalize_object(qp->uobject, UVERBS_ACCESS_READ, !ret);
+	if (ret) {
 		for (next = wr; next; next = next->next) {
 			++resp.bad_wr;
 			if (next == bad_wr)
 				break;
 		}
+	}
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp))
@@ -2892,7 +2564,7 @@ ssize_t ib_uverbs_post_srq_recv(struct ib_uverbs_file *file,
 	resp.bad_wr = 0;
 	ret = srq->device->post_srq_recv(srq, wr, &bad_wr);
 
-	put_srq_read(srq);
+	uverbs_finalize_object(srq->uobject, UVERBS_ACCESS_READ, !ret);
 
 	if (ret)
 		for (next = wr; next; next = next->next) {
@@ -2939,12 +2611,11 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 		   (unsigned long)cmd.response + sizeof(resp),
 		   in_len - sizeof(cmd), out_len - sizeof(resp));
 
-	uobj = kmalloc(sizeof *uobj, GFP_KERNEL);
-	if (!uobj)
-		return -ENOMEM;
-
-	init_uobj(uobj, cmd.user_handle, file->ucontext, &ah_lock_class);
-	down_write(&uobj->mutex);
+	uobj = uverbs_get_uobject_from_context(uverbs_type_ah.alloc,
+					       file->ucontext,
+					       UVERBS_ACCESS_NEW, 0);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
 
 	pd = idr_read_pd(cmd.pd_handle, file->ucontext);
 	if (!pd) {
@@ -2976,12 +2647,9 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
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
@@ -2990,29 +2658,19 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
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
+	uverbs_finalize_object(pd->uobject, UVERBS_ACCESS_READ, true);
+	uverbs_finalize_object(uobj, UVERBS_ACCESS_NEW, true);
 
 	return in_len;
 
 err_copy:
-	idr_remove_uobj(uobj);
-
-err_destroy:
 	ib_destroy_ah(ah);
 
 err_put:
-	put_pd_read(pd);
+	uverbs_finalize_object(pd->uobject, UVERBS_ACCESS_READ, false);
 
 err:
-	put_uobj_write(uobj);
+	uverbs_finalize_object(uobj, UVERBS_ACCESS_NEW, false);
 	return ret;
 }
 
@@ -3028,29 +2686,22 @@ ssize_t ib_uverbs_destroy_ah(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(cmd.ah_handle, file->ucontext);
-	if (!uobj)
-		return -EINVAL;
+	uobj = uverbs_get_uobject_from_context(uverbs_type_ah.alloc, file->ucontext,
+					       UVERBS_ACCESS_DESTROY,
+					       cmd.ah_handle);
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
+		uverbs_finalize_object(uobj, UVERBS_ACCESS_DESTROY, false);
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
+		uverbs_finalize_object(uobj, UVERBS_ACCESS_DESTROY, true);
+		return in_len;
+	}
 }
 
 ssize_t ib_uverbs_attach_mcast(struct ib_uverbs_file *file,
@@ -3067,12 +2718,13 @@ ssize_t ib_uverbs_attach_mcast(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	qp = idr_write_qp(cmd.qp_handle, file->ucontext);
+	qp = idr_read_qp(cmd.qp_handle, file->ucontext);
 	if (!qp)
 		return -EINVAL;
 
 	obj = container_of(qp->uobject, struct ib_uqp_object, uevent.uobject);
 
+	mutex_lock(&obj->mcast_lock);
 	list_for_each_entry(mcast, &obj->mcast_list, list)
 		if (cmd.mlid == mcast->lid &&
 		    !memcmp(cmd.gid, mcast->gid.raw, sizeof mcast->gid.raw)) {
@@ -3096,8 +2748,8 @@ ssize_t ib_uverbs_attach_mcast(struct ib_uverbs_file *file,
 		kfree(mcast);
 
 out_put:
-	put_qp_write(qp);
-
+	mutex_unlock(&obj->mcast_lock);
+	uverbs_finalize_object(qp->uobject, UVERBS_ACCESS_READ, !ret);
 	return ret ? ret : in_len;
 }
 
@@ -3115,16 +2767,17 @@ ssize_t ib_uverbs_detach_mcast(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	qp = idr_write_qp(cmd.qp_handle, file->ucontext);
+	qp = idr_read_qp(cmd.qp_handle, file->ucontext);
 	if (!qp)
 		return -EINVAL;
 
+	obj = container_of(qp->uobject, struct ib_uqp_object, uevent.uobject);
+	mutex_lock(&obj->mcast_lock);
+
 	ret = ib_detach_mcast(qp, (union ib_gid *) cmd.gid, cmd.mlid);
 	if (ret)
 		goto out_put;
 
-	obj = container_of(qp->uobject, struct ib_uqp_object, uevent.uobject);
-
 	list_for_each_entry(mcast, &obj->mcast_list, list)
 		if (cmd.mlid == mcast->lid &&
 		    !memcmp(cmd.gid, mcast->gid.raw, sizeof mcast->gid.raw)) {
@@ -3134,8 +2787,8 @@ ssize_t ib_uverbs_detach_mcast(struct ib_uverbs_file *file,
 		}
 
 out_put:
-	put_qp_write(qp);
-
+	mutex_unlock(&obj->mcast_lock);
+	uverbs_finalize_object(qp->uobject, UVERBS_ACCESS_READ, !ret);
 	return ret ? ret : in_len;
 }
 
@@ -3296,20 +2949,20 @@ int ib_uverbs_ex_create_wq(struct ib_uverbs_file *file,
 	if (cmd.comp_mask)
 		return -EOPNOTSUPP;
 
-	obj = kmalloc(sizeof(*obj), GFP_KERNEL);
-	if (!obj)
-		return -ENOMEM;
+	obj = (struct ib_uwq_object *)uverbs_get_uobject_from_context(
+						uverbs_type_wq.alloc,
+						file->ucontext,
+						UVERBS_ACCESS_NEW, 0);
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
@@ -3341,9 +2994,6 @@ int ib_uverbs_ex_create_wq(struct ib_uverbs_file *file,
 	atomic_inc(&cq->usecnt);
 	wq->uobject = &obj->uevent.uobject;
 	obj->uevent.uobject.object = wq;
-	err = idr_add_uobj(&obj->uevent.uobject);
-	if (err)
-		goto destroy_wq;
 
 	memset(&resp, 0, sizeof(resp));
 	resp.wq_handle = obj->uevent.uobject.id;
@@ -3356,27 +3006,19 @@ int ib_uverbs_ex_create_wq(struct ib_uverbs_file *file,
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
+	uverbs_finalize_object(pd->uobject, UVERBS_ACCESS_READ, true);
+	uverbs_finalize_object(cq->uobject, UVERBS_ACCESS_READ, true);
+	uverbs_finalize_object(&obj->uevent.uobject, UVERBS_ACCESS_NEW, true);
 	return 0;
 
 err_copy:
-	idr_remove_uobj(&obj->uevent.uobject);
-destroy_wq:
 	ib_destroy_wq(wq);
 err_put_cq:
-	put_cq_read(cq);
+	uverbs_finalize_object(cq->uobject, UVERBS_ACCESS_READ, false);
 err_put_pd:
-	put_pd_read(pd);
+	uverbs_finalize_object(pd->uobject, UVERBS_ACCESS_READ, false);
 err_uobj:
-	put_uobj_write(&obj->uevent.uobject);
+	uverbs_finalize_object(&obj->uevent.uobject, UVERBS_ACCESS_NEW, false);
 
 	return err;
 }
@@ -3417,30 +3059,23 @@ int ib_uverbs_ex_destroy_wq(struct ib_uverbs_file *file,
 		return -EOPNOTSUPP;
 
 	resp.response_length = required_resp_len;
-	uobj = idr_write_uobj(cmd.wq_handle,
-			      file->ucontext);
-	if (!uobj)
-		return -EINVAL;
+	uobj = uverbs_get_uobject_from_context(uverbs_type_ah.alloc, file->ucontext,
+					       UVERBS_ACCESS_DESTROY,
+					       cmd.wq_handle);
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
+		uverbs_finalize_object(uobj, UVERBS_ACCESS_DESTROY, false);
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
+	uverbs_finalize_object(uobj, UVERBS_ACCESS_DESTROY, true);
 
 	ret = ib_copy_to_udata(ucore, &resp, resp.response_length);
 	if (ret)
@@ -3486,7 +3121,7 @@ int ib_uverbs_ex_modify_wq(struct ib_uverbs_file *file,
 	wq_attr.curr_wq_state = cmd.curr_wq_state;
 	wq_attr.wq_state = cmd.wq_state;
 	ret = wq->device->modify_wq(wq, &wq_attr, cmd.attr_mask, uhw);
-	put_wq_read(wq);
+	uverbs_finalize_object(wq->uobject, UVERBS_ACCESS_READ, !ret);
 	return ret;
 }
 
@@ -3573,14 +3208,15 @@ int ib_uverbs_ex_create_rwq_ind_table(struct ib_uverbs_file *file,
 		wqs[num_read_wqs] = wq;
 	}
 
-	uobj = kmalloc(sizeof(*uobj), GFP_KERNEL);
-	if (!uobj) {
-		err = -ENOMEM;
+	uobj = uverbs_get_uobject_from_context(uverbs_type_rwq_ind_table.alloc,
+					       file->ucontext,
+					       UVERBS_ACCESS_NEW,
+					       0);
+	if (IS_ERR(uobj)) {
+		err = PTR_ERR(uobj);
 		goto put_wqs;
 	}
 
-	init_uobj(uobj, 0, file->ucontext, &rwq_ind_table_lock_class);
-	down_write(&uobj->mutex);
 	init_attr.log_ind_tbl_size = cmd.log_ind_tbl_size;
 	init_attr.ind_tbl = wqs;
 	rwq_ind_tbl = ib_dev->create_rwq_ind_table(ib_dev, &init_attr, uhw);
@@ -3600,10 +3236,6 @@ int ib_uverbs_ex_create_rwq_ind_table(struct ib_uverbs_file *file,
 	for (i = 0; i < num_wq_handles; i++)
 		atomic_inc(&wqs[i]->usecnt);
 
-	err = idr_add_uobj(uobj);
-	if (err)
-		goto destroy_ind_tbl;
-
 	resp.ind_tbl_handle = uobj->id;
 	resp.ind_tbl_num = rwq_ind_tbl->ind_tbl_num;
 	resp.response_length = required_resp_len;
@@ -3616,26 +3248,18 @@ int ib_uverbs_ex_create_rwq_ind_table(struct ib_uverbs_file *file,
 	kfree(wqs_handles);
 
 	for (j = 0; j < num_read_wqs; j++)
-		put_wq_read(wqs[j]);
-
-	mutex_lock(&file->mutex);
-	list_add_tail(&uobj->list, &file->ucontext->rwq_ind_tbl_list);
-	mutex_unlock(&file->mutex);
-
-	uobj->live = 1;
+		uverbs_finalize_object(wqs[j]->uobject, UVERBS_ACCESS_READ, true);
 
-	up_write(&uobj->mutex);
+	uverbs_finalize_object(uobj, UVERBS_ACCESS_NEW, true);
 	return 0;
 
 err_copy:
-	idr_remove_uobj(uobj);
-destroy_ind_tbl:
 	ib_destroy_rwq_ind_table(rwq_ind_tbl);
 err_uobj:
-	put_uobj_write(uobj);
+	uverbs_finalize_object(uobj, UVERBS_ACCESS_NEW, false);
 put_wqs:
 	for (j = 0; j < num_read_wqs; j++)
-		put_wq_read(wqs[j]);
+		uverbs_finalize_object(wqs[j]->uobject, UVERBS_ACCESS_READ, false);
 err_free:
 	kfree(wqs_handles);
 	kfree(wqs);
@@ -3671,29 +3295,23 @@ int ib_uverbs_ex_destroy_rwq_ind_table(struct ib_uverbs_file *file,
 	if (cmd.comp_mask)
 		return -EOPNOTSUPP;
 
-	uobj = idr_write_uobj(cmd.ind_tbl_handle,
-			      file->ucontext);
-	if (!uobj)
-		return -EINVAL;
+	uobj = uverbs_get_uobject_from_context(uverbs_type_rwq_ind_table.alloc,
+					       file->ucontext,
+					       UVERBS_ACCESS_DESTROY,
+					       cmd.ind_tbl_handle);
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
+		uverbs_finalize_object(uobj, UVERBS_ACCESS_DESTROY, false);
 		return ret;
+	}
 
-	idr_remove_uobj(uobj);
-
-	mutex_lock(&file->mutex);
-	list_del(&uobj->list);
-	mutex_unlock(&file->mutex);
-
-	put_uobj(uobj);
+	uverbs_finalize_object(uobj, UVERBS_ACCESS_DESTROY, true);
 	kfree(ind_tbl);
 	return ret;
 }
@@ -3769,13 +3387,12 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 		kern_flow_attr = &cmd.flow_attr;
 	}
 
-	uobj = kmalloc(sizeof(*uobj), GFP_KERNEL);
-	if (!uobj) {
-		err = -ENOMEM;
+	uobj = uverbs_get_uobject_from_context(uverbs_type_flow.alloc, file->ucontext,
+					       UVERBS_ACCESS_NEW, 0);
+	if (IS_ERR(uobj)) {
+		err = PTR_ERR(uobj);
 		goto err_free_attr;
 	}
-	init_uobj(uobj, 0, file->ucontext, &rule_lock_class);
-	down_write(&uobj->mutex);
 
 	qp = idr_read_qp(cmd.qp_handle, file->ucontext);
 	if (!qp) {
@@ -3826,10 +3443,6 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 	flow_id->uobject = uobj;
 	uobj->object = flow_id;
 
-	err = idr_add_uobj(uobj);
-	if (err)
-		goto destroy_flow;
-
 	memset(&resp, 0, sizeof(resp));
 	resp.flow_handle = uobj->id;
 
@@ -3838,28 +3451,20 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
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
+	uverbs_finalize_object(qp->uobject, UVERBS_ACCESS_READ, true);
+	uverbs_finalize_object(uobj, UVERBS_ACCESS_NEW, true);
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
+	uverbs_finalize_object(qp->uobject, UVERBS_ACCESS_READ, false);
 err_uobj:
-	put_uobj_write(uobj);
+	uverbs_finalize_object(uobj, UVERBS_ACCESS_NEW, false);
 err_free_attr:
 	if (cmd.flow_attr.num_of_specs)
 		kfree(kern_flow_attr);
@@ -3886,25 +3491,17 @@ int ib_uverbs_ex_destroy_flow(struct ib_uverbs_file *file,
 	if (cmd.comp_mask)
 		return -EINVAL;
 
-	uobj = idr_write_uobj(cmd.flow_handle, file->ucontext);
-	if (!uobj)
-		return -EINVAL;
+	uobj = uverbs_get_uobject_from_context(uverbs_type_flow.alloc,
+					       file->ucontext,
+					       UVERBS_ACCESS_DESTROY,
+					       cmd.flow_handle);
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
-
+	uverbs_finalize_object(uobj, UVERBS_ACCESS_DESTROY, !ret);
 	return ret;
 }
 
@@ -3921,12 +3518,12 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	struct ib_srq_init_attr          attr;
 	int ret;
 
-	obj = kmalloc(sizeof *obj, GFP_KERNEL);
-	if (!obj)
-		return -ENOMEM;
-
-	init_uobj(&obj->uevent.uobject, cmd->user_handle, file->ucontext, &srq_lock_class);
-	down_write(&obj->uevent.uobject.mutex);
+	obj = (struct ib_usrq_object *)uverbs_get_uobject_from_context(
+						uverbs_type_srq.alloc,
+						file->ucontext,
+						UVERBS_ACCESS_NEW, 0);
+	if (IS_ERR(obj))
+		return PTR_ERR(obj);
 
 	if (cmd->srq_type == IB_SRQT_XRC) {
 		attr.ext.xrc.xrcd  = idr_read_xrcd(cmd->xrcd_handle, file->ucontext, &xrcd_uobj);
@@ -3938,7 +3535,7 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 		obj->uxrcd = container_of(xrcd_uobj, struct ib_uxrcd_object, uobject);
 		atomic_inc(&obj->uxrcd->refcnt);
 
-		attr.ext.xrc.cq  = idr_read_cq(cmd->cq_handle, file->ucontext, 0);
+		attr.ext.xrc.cq  = idr_read_cq(cmd->cq_handle, file->ucontext);
 		if (!attr.ext.xrc.cq) {
 			ret = -EINVAL;
 			goto err_put_xrcd;
@@ -3985,9 +3582,7 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	atomic_set(&srq->usecnt, 0);
 
 	obj->uevent.uobject.object = srq;
-	ret = idr_add_uobj(&obj->uevent.uobject);
-	if (ret)
-		goto err_destroy;
+	obj->uevent.uobject.user_handle = cmd->user_handle;
 
 	memset(&resp, 0, sizeof resp);
 	resp.srq_handle = obj->uevent.uobject.id;
@@ -4003,42 +3598,34 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	}
 
 	if (cmd->srq_type == IB_SRQT_XRC) {
-		put_uobj_read(xrcd_uobj);
-		put_cq_read(attr.ext.xrc.cq);
+		uverbs_finalize_object(xrcd_uobj, UVERBS_ACCESS_READ, true);
+		uverbs_finalize_object(attr.ext.xrc.cq->uobject,
+				       UVERBS_ACCESS_READ, true);
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
+	uverbs_finalize_object(pd->uobject, UVERBS_ACCESS_READ, true);
+	uverbs_finalize_object(&obj->uevent.uobject, UVERBS_ACCESS_NEW, true);
 
 	return 0;
 
 err_copy:
-	idr_remove_uobj(&obj->uevent.uobject);
-
-err_destroy:
 	ib_destroy_srq(srq);
 
 err_put:
-	put_pd_read(pd);
+	uverbs_finalize_object(pd->uobject, UVERBS_ACCESS_READ, false);
 
 err_put_cq:
 	if (cmd->srq_type == IB_SRQT_XRC)
-		put_cq_read(attr.ext.xrc.cq);
+		uverbs_finalize_object(attr.ext.xrc.cq->uobject,
+				       UVERBS_ACCESS_READ, false);
 
 err_put_xrcd:
 	if (cmd->srq_type == IB_SRQT_XRC) {
 		atomic_dec(&obj->uxrcd->refcnt);
-		put_uobj_read(xrcd_uobj);
+		uverbs_finalize_object(xrcd_uobj, UVERBS_ACCESS_READ, false);
 	}
 
 err:
-	put_uobj_write(&obj->uevent.uobject);
+	uverbs_finalize_object(&obj->uevent.uobject, UVERBS_ACCESS_NEW, false);
 	return ret;
 }
 
@@ -4132,8 +3719,7 @@ ssize_t ib_uverbs_modify_srq(struct ib_uverbs_file *file,
 
 	ret = srq->device->modify_srq(srq, &attr, cmd.attr_mask, &udata);
 
-	put_srq_read(srq);
-
+	uverbs_finalize_object(srq->uobject, UVERBS_ACCESS_READ, !ret);
 	return ret ? ret : in_len;
 }
 
@@ -4160,8 +3746,7 @@ ssize_t ib_uverbs_query_srq(struct ib_uverbs_file *file,
 
 	ret = ib_query_srq(srq, &attr);
 
-	put_srq_read(srq);
-
+	uverbs_finalize_object(srq->uobject, UVERBS_ACCESS_READ, !ret);
 	if (ret)
 		return ret;
 
@@ -4195,39 +3780,34 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(cmd.srq_handle, file->ucontext);
-	if (!uobj)
-		return -EINVAL;
+	uobj = uverbs_get_uobject_from_context(uverbs_type_srq.alloc,
+					       file->ucontext,
+					       UVERBS_ACCESS_DESTROY,
+					       cmd.srq_handle);
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
+		uverbs_finalize_object(uobj, UVERBS_ACCESS_DESTROY, false);
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
+	uverbs_finalize_object(uobj, UVERBS_ACCESS_DESTROY, true);
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp))
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 75c30d9..d7c189f 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -51,6 +51,7 @@
 #include <rdma/ib.h>
 
 #include "uverbs.h"
+#include "rdma_core.h"
 
 MODULE_AUTHOR("Roland Dreier");
 MODULE_DESCRIPTION("InfiniBand userspace verbs access");
@@ -154,7 +155,7 @@ static void ib_uverbs_release_dev(struct kobject *kobj)
 	.release = ib_uverbs_release_dev,
 };
 
-static void ib_uverbs_release_event_file(struct kref *ref)
+static void ib_uverbs_release_async_event_file(struct kref *ref)
 {
 	struct ib_uverbs_event_file *file =
 		container_of(ref, struct ib_uverbs_event_file, ref);
@@ -162,6 +163,14 @@ static void ib_uverbs_release_event_file(struct kref *ref)
 	kfree(file);
 }
 
+static void ib_uverbs_release_event_file(struct kref *ref)
+{
+	struct ib_uverbs_event_file *file =
+		container_of(ref, struct ib_uverbs_event_file, ref);
+
+	uverbs_cleanup_fd(file);
+}
+
 void ib_uverbs_release_ucq(struct ib_uverbs_file *file,
 			  struct ib_uverbs_event_file *ev_file,
 			  struct ib_ucq_object *uobj)
@@ -215,120 +224,8 @@ void ib_uverbs_detach_umcast(struct ib_qp *qp,
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
-		if (qp == qp->real_qp)
-			ib_uverbs_detach_umcast(qp, uqp);
-		ib_destroy_qp(qp);
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
+	uverbs_cleanup_ucontext(context, context->device->specs_root);
 	put_pid(context->tgid);
 
 	return context->device->dealloc_ucontext(context);
@@ -447,7 +344,7 @@ static int ib_uverbs_event_fasync(int fd, struct file *filp, int on)
 	return fasync_helper(fd, filp, on, &file->async_queue);
 }
 
-static int ib_uverbs_event_close(struct inode *inode, struct file *filp)
+static int ib_uverbs_async_event_close(struct inode *inode, struct file *filp)
 {
 	struct ib_uverbs_event_file *file = filp->private_data;
 	struct ib_uverbs_event *entry, *tmp;
@@ -472,6 +369,26 @@ static int ib_uverbs_event_close(struct inode *inode, struct file *filp)
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
+	uverbs_close_fd(filp);
+	kref_put(&file->uverbs_file->ref, ib_uverbs_release_file);
 	kref_put(&file->ref, ib_uverbs_release_event_file);
 
 	return 0;
@@ -486,6 +403,15 @@ static int ib_uverbs_event_close(struct inode *inode, struct file *filp)
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
@@ -570,7 +496,8 @@ void ib_uverbs_qp_event_handler(struct ib_event *event, void *context_ptr)
 	struct ib_uevent_object *uobj;
 
 	/* for XRC target qp's, check that qp is live */
-	if (!event->element.qp->uobject || !event->element.qp->uobject->live)
+	if (!event->element.qp->uobject ||
+	    !uverbs_is_live(event->element.qp->uobject))
 		return;
 
 	uobj = container_of(event->element.qp->uobject,
@@ -615,22 +542,13 @@ void ib_uverbs_event_handler(struct ib_event_handler *handler,
 
 void ib_uverbs_free_async_event_file(struct ib_uverbs_file *file)
 {
-	kref_put(&file->async_file->ref, ib_uverbs_release_event_file);
+	kref_put(&file->async_file->ref, ib_uverbs_release_async_event_file);
 	file->async_file = NULL;
 }
 
-struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
-					struct ib_device	*ib_dev,
-					int is_async)
+void ib_uverbs_init_event_file(struct ib_uverbs_event_file *ev_file,
+			       struct ib_uverbs_file *uverbs_file)
 {
-	struct ib_uverbs_event_file *ev_file;
-	struct file *filp;
-	int ret;
-
-	ev_file = kzalloc(sizeof(*ev_file), GFP_KERNEL);
-	if (!ev_file)
-		return ERR_PTR(-ENOMEM);
-
 	kref_init(&ev_file->ref);
 	spin_lock_init(&ev_file->lock);
 	INIT_LIST_HEAD(&ev_file->event_list);
@@ -639,8 +557,22 @@ struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
 	kref_get(&ev_file->uverbs_file->ref);
 	ev_file->async_queue = NULL;
 	ev_file->is_closed   = 0;
+	ev_file->is_async   = 0;
+}
 
-	filp = anon_inode_getfile("[infinibandevent]", &uverbs_event_fops,
+struct file *ib_uverbs_alloc_async_event_file(struct ib_uverbs_file *uverbs_file,
+					      struct ib_device	*ib_dev)
+{
+	struct ib_uverbs_event_file *ev_file;
+	struct file *filp;
+	int ret;
+
+	ev_file = kzalloc(sizeof(*ev_file), GFP_KERNEL);
+	if (!ev_file)
+		return ERR_PTR(-ENOMEM);
+
+	ib_uverbs_init_event_file(ev_file, uverbs_file);
+	filp = anon_inode_getfile("[infinibandevent]", &uverbs_async_event_fops,
 				  ev_file, O_RDONLY);
 	if (IS_ERR(filp))
 		goto err_put_refs;
@@ -650,26 +582,25 @@ struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
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
 
@@ -679,35 +610,6 @@ struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
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
@@ -999,7 +901,8 @@ static int ib_uverbs_close(struct inode *inode, struct file *filp)
 	mutex_unlock(&file->device->lists_mutex);
 
 	if (file->async_file)
-		kref_put(&file->async_file->ref, ib_uverbs_release_event_file);
+		kref_put(&file->async_file->ref,
+			 ib_uverbs_release_async_event_file);
 
 	kref_put(&file->ref, ib_uverbs_release_file);
 	kobject_put(&dev->kobj);
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 9d5fe18..a3274f7 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -53,6 +53,7 @@
 #include <rdma/ib_smi.h>
 #include <rdma/ib_umem.h>
 #include <rdma/ib_user_verbs.h>
+#include <rdma/uverbs_ioctl_cmd.h>
 
 #include "cxio_hal.h"
 #include "iwch.h"
@@ -1361,6 +1362,8 @@ static void get_dev_fw_ver_str(struct ib_device *ibdev, char *str,
 	snprintf(str, str_len, "%s", info.fw_version);
 }
 
+DECLARE_UVERBS_TYPES_GROUP(root, &uverbs_common_types);
+
 int iwch_register_device(struct iwch_dev *dev)
 {
 	int ret;
@@ -1454,6 +1457,7 @@ int iwch_register_device(struct iwch_dev *dev)
 	memcpy(dev->ibdev.iwcm->ifname, dev->rdev.t3cdev_p->lldev->name,
 	       sizeof(dev->ibdev.iwcm->ifname));
 
+	dev->ibdev.specs_root = (struct uverbs_root *)&root;
 	ret = ib_register_device(&dev->ibdev, NULL);
 	if (ret)
 		goto bail1;
diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index 49b51b7..693c13f 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -51,6 +51,7 @@
 #include <rdma/ib_smi.h>
 #include <rdma/ib_umem.h>
 #include <rdma/ib_user_verbs.h>
+#include <rdma/uverbs_ioctl_cmd.h>
 
 #include "iw_cxgb4.h"
 
@@ -530,6 +531,8 @@ static void get_dev_fw_str(struct ib_device *dev, char *str,
 		 FW_HDR_FW_VER_BUILD_G(c4iw_dev->rdev.lldi.fw_vers));
 }
 
+DECLARE_UVERBS_TYPES_GROUP(root, &uverbs_common_types);
+
 int c4iw_register_device(struct c4iw_dev *dev)
 {
 	int ret;
@@ -625,6 +628,7 @@ int c4iw_register_device(struct c4iw_dev *dev)
 	memcpy(dev->ibdev.iwcm->ifname, dev->rdev.lldi.ports[0]->name,
 	       sizeof(dev->ibdev.iwcm->ifname));
 
+	dev->ibdev.specs_root = (struct uverbs_root *)&root;
 	ret = ib_register_device(&dev->ibdev, NULL);
 	if (ret)
 		goto bail1;
diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index 4953d9c..72870a2 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -36,6 +36,7 @@
 #include <rdma/ib_smi.h>
 #include <rdma/ib_user_verbs.h>
 #include <rdma/ib_cache.h>
+#include <rdma/uverbs_ioctl_cmd.h>
 #include "hns_roce_common.h"
 #include "hns_roce_device.h"
 #include <rdma/hns-abi.h>
@@ -422,6 +423,8 @@ static void hns_roce_unregister_device(struct hns_roce_dev *hr_dev)
 	ib_unregister_device(&hr_dev->ib_dev);
 }
 
+DECLARE_UVERBS_TYPES_GROUP(root, &uverbs_common_types);
+
 static int hns_roce_register_device(struct hns_roce_dev *hr_dev)
 {
 	int ret;
@@ -505,6 +508,7 @@ static int hns_roce_register_device(struct hns_roce_dev *hr_dev)
 	/* OTHERS */
 	ib_dev->get_port_immutable	= hns_roce_port_immutable;
 
+	dev->ib_dev.specs_root = (struct uverbs_root *)&root;
 	ret = ib_register_device(ib_dev, NULL);
 	if (ret) {
 		dev_err(dev, "ib_register_device failed!\n");
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 29e97df..deeb47a 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -43,6 +43,7 @@
 #include <rdma/ib_verbs.h>
 #include <rdma/iw_cm.h>
 #include <rdma/ib_user_verbs.h>
+#include <rdma/uverbs_ioctl_cmd.h>
 #include <rdma/ib_umem.h>
 #include "i40iw.h"
 
@@ -2869,6 +2870,8 @@ void i40iw_destroy_rdma_device(struct i40iw_ib_device *iwibdev)
 	ib_dealloc_device(&iwibdev->ibdev);
 }
 
+DECLARE_UVERBS_TYPES_GROUP(root, &uverbs_common_types);
+
 /**
  * i40iw_register_rdma_device - register iwarp device to IB
  * @iwdev: iwarp device
@@ -2883,6 +2886,7 @@ int i40iw_register_rdma_device(struct i40iw_device *iwdev)
 		return -ENOMEM;
 	iwibdev = iwdev->iwibdev;
 
+	iwibdev->ibdev.specs_root = (struct uverbs_root *)&root;
 	ret = ib_register_device(&iwibdev->ibdev, NULL);
 	if (ret)
 		goto error;
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 7031a8dd..9d6b13b 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -45,6 +45,7 @@
 
 #include <rdma/ib_smi.h>
 #include <rdma/ib_user_verbs.h>
+#include <rdma/uverbs_ioctl_cmd.h>
 #include <rdma/ib_addr.h>
 #include <rdma/ib_cache.h>
 
@@ -2570,6 +2571,8 @@ static void get_fw_ver_str(struct ib_device *device, char *str,
 		 (int) dev->dev->caps.fw_ver & 0xffff);
 }
 
+DECLARE_UVERBS_TYPES_GROUP(root, &uverbs_common_types);
+
 static void *mlx4_ib_add(struct mlx4_dev *dev)
 {
 	struct mlx4_ib_dev *ibdev;
@@ -2852,6 +2855,7 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	if (mlx4_ib_alloc_diag_counters(ibdev))
 		goto err_steer_free_bitmap;
 
+	ibdev->ib_dev.specs_root = (struct uverbs_root *)&root;
 	if (ib_register_device(&ibdev->ib_dev, NULL))
 		goto err_diag_counters;
 
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index d566f67..b0d307d 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -54,6 +54,7 @@
 #include <linux/etherdevice.h>
 #include <linux/mlx5/fs.h>
 #include "mlx5_ib.h"
+#include <rdma/uverbs_ioctl_cmd.h>
 
 #define DRIVER_NAME "mlx5_ib"
 #define DRIVER_VERSION "2.2-1"
@@ -3027,6 +3028,8 @@ static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
 	return ARRAY_SIZE(names);
 }
 
+DECLARE_UVERBS_TYPES_GROUP(root, &uverbs_common_types);
+
 static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 {
 	struct mlx5_ib_dev *dev;
@@ -3237,6 +3240,7 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	if (err)
 		goto err_odp;
 
+	dev->ib_dev.specs_root = (struct uverbs_root *)&root;
 	err = ib_register_device(&dev->ib_dev, NULL);
 	if (err)
 		goto err_q_cnt;
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index d317087..304c47c 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -37,6 +37,7 @@
 #include <rdma/ib_smi.h>
 #include <rdma/ib_umem.h>
 #include <rdma/ib_user_verbs.h>
+#include <rdma/uverbs_ioctl_cmd.h>
 
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -1189,6 +1190,8 @@ static void get_dev_fw_str(struct ib_device *device, char *str,
 		 (int) dev->fw_ver & 0xffff);
 }
 
+DECLARE_UVERBS_TYPES_GROUP(root, &uverbs_common_types);
+
 int mthca_register_device(struct mthca_dev *dev)
 {
 	int ret;
@@ -1296,6 +1299,7 @@ int mthca_register_device(struct mthca_dev *dev)
 
 	mutex_init(&dev->cap_mask_mutex);
 
+	dev->ib_dev.specs_root = (struct uverbs_root *)&root;
 	ret = ib_register_device(&dev->ib_dev, NULL);
 	if (ret)
 		return ret;
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index aff9fb1..c6829cd 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -41,6 +41,7 @@
 #include <rdma/ib_verbs.h>
 #include <rdma/iw_cm.h>
 #include <rdma/ib_user_verbs.h>
+#include <rdma/uverbs_ioctl_cmd.h>
 
 #include "nes.h"
 
@@ -3862,6 +3863,8 @@ void nes_destroy_ofa_device(struct nes_ib_device *nesibdev)
 }
 
 
+DECLARE_UVERBS_TYPES_GROUP(root, &uverbs_common_types);
+
 /**
  * nes_register_ofa_device
  */
@@ -3872,6 +3875,7 @@ int nes_register_ofa_device(struct nes_ib_device *nesibdev)
 	struct nes_adapter *nesadapter = nesdev->nesadapter;
 	int i, ret;
 
+	nesvnic->nesibdev->ibdev.specs_root = (struct uverbs_root *)&root;
 	ret = ib_register_device(&nesvnic->nesibdev->ibdev, NULL);
 	if (ret) {
 		return ret;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 8960715..539f512 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -44,6 +44,7 @@
 #include <linux/idr.h>
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_user_verbs.h>
+#include <rdma/uverbs_ioctl_cmd.h>
 #include <rdma/ib_addr.h>
 #include <rdma/ib_mad.h>
 
@@ -115,6 +116,8 @@ static void get_dev_fw_str(struct ib_device *device, char *str,
 	snprintf(str, str_len, "%s", &dev->attr.fw_ver[0]);
 }
 
+DECLARE_UVERBS_TYPES_GROUP(root, &uverbs_common_types);
+
 static int ocrdma_register_device(struct ocrdma_dev *dev)
 {
 	strlcpy(dev->ibdev.name, "ocrdma%d", IB_DEVICE_NAME_MAX);
@@ -218,6 +221,7 @@ static int ocrdma_register_device(struct ocrdma_dev *dev)
 		dev->ibdev.destroy_srq = ocrdma_destroy_srq;
 		dev->ibdev.post_srq_recv = ocrdma_post_srq_recv;
 	}
+	dev->ibdev.specs_root = (struct uverbs_root *)&root;
 	return ib_register_device(&dev->ibdev, NULL);
 }
 
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infiniband/hw/usnic/usnic_ib_main.c
index 0a89a95..19ff7f7 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
@@ -48,6 +48,7 @@
 #include <linux/netdevice.h>
 
 #include <rdma/ib_user_verbs.h>
+#include <rdma/uverbs_ioctl_cmd.h>
 #include <rdma/ib_addr.h>
 
 #include "usnic_abi.h"
@@ -346,6 +347,8 @@ static void usnic_get_dev_fw_str(struct ib_device *device,
 	snprintf(str, str_len, "%s", info.fw_version);
 }
 
+DECLARE_UVERBS_TYPES_GROUP(root, &uverbs_common_types);
+
 /* Start of PF discovery section */
 static void *usnic_ib_device_add(struct pci_dev *dev)
 {
@@ -432,6 +435,7 @@ static void *usnic_ib_device_add(struct pci_dev *dev)
 	us_ibdev->ib_dev.get_dev_fw_str     = usnic_get_dev_fw_str;
 
 
+	us_ibdev->ib_dev.specs_root = (struct uverbs_root *)&root;
 	if (ib_register_device(&us_ibdev->ib_dev, NULL))
 		goto err_fwd_dealloc;
 
diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index d430c2f..c8b4a05 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -47,6 +47,7 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <rdma/uverbs_ioctl_cmd.h>
 #include "vt.h"
 #include "trace.h"
 
@@ -714,6 +715,8 @@ static noinline int check_support(struct rvt_dev_info *rdi, int verb)
 	return 0;
 }
 
+DECLARE_UVERBS_TYPES_GROUP(root, &uverbs_common_types);
+
 /**
  * rvt_register_device - register a driver
  * @rdi: main dev structure for all of rdmavt operations
@@ -826,6 +829,7 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 	rdi->ibdev.num_comp_vectors = 1;
 
 	/* We are now good to announce we exist */
+	rdi->ibdev.specs_root = (struct uverbs_root *)&root;
 	ret =  ib_register_device(&rdi->ibdev, rdi->driver_f.port_callback);
 	if (ret) {
 		rvt_pr_err(rdi, "Failed to register driver with ib core.\n");
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index beb7021..df1c975 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -34,6 +34,7 @@
 #include "rxe.h"
 #include "rxe_loc.h"
 #include "rxe_queue.h"
+#include <rdma/uverbs_ioctl_cmd.h>
 
 static int rxe_query_device(struct ib_device *dev,
 			    struct ib_device_attr *attr,
@@ -1221,6 +1222,8 @@ static ssize_t rxe_show_parent(struct device *device,
 	&dev_attr_parent,
 };
 
+DECLARE_UVERBS_TYPES_GROUP(root, &uverbs_common_types);
+
 int rxe_register_device(struct rxe_dev *rxe)
 {
 	int err;
@@ -1318,6 +1321,7 @@ int rxe_register_device(struct rxe_dev *rxe)
 	dev->attach_mcast = rxe_attach_mcast;
 	dev->detach_mcast = rxe_detach_mcast;
 
+	dev->specs_root = (struct uverbs_root *)&root;
 	err = ib_register_device(dev, NULL);
 	if (err) {
 		pr_warn("rxe_register_device failed, err = %d\n", err);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 7992fcd..9025090 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1336,17 +1336,6 @@ struct ib_fmr_attr {
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
-	struct kref		ref;
-	struct rw_semaphore	mutex;		/* protects .live */
 	struct rw_semaphore	usecnt;		/* protects exclusive access */
 	struct rcu_head		rcu;		/* kfree_rcu() overhead */
-	int			live;
 
 	const struct uverbs_type_alloc_action *type;
 	struct ib_ucontext_lock	*uobjects_lock;
@@ -2141,6 +2127,8 @@ struct ib_device {
 	 */
 	int (*get_port_immutable)(struct ib_device *, u8, struct ib_port_immutable *);
 	void (*get_dev_fw_str)(struct ib_device *, char *str, size_t str_len);
+
+	struct uverbs_root                      *specs_root;
 };
 
 struct ib_client {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
