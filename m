From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 for-next 4/7] IB/core: Change idr objects to use the new schema
Date: Wed,  1 Feb 2017 14:39:02 +0200
Message-ID: <1485952745-58476-5-git-send-email-matanb@mellanox.com>
References: <1485952745-58476-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485952745-58476-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
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
 drivers/infiniband/core/uverbs.h      |   2 -
 drivers/infiniband/core/uverbs_cmd.c  | 909 ++++++++++------------------------
 drivers/infiniband/core/uverbs_main.c | 124 +----
 include/rdma/ib_verbs.h               |  13 -
 4 files changed, 260 insertions(+), 788 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index dd8048f..1e31ad8 100644
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
index 29c621d..17c6dcf 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -40,177 +40,29 @@
 
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
+#define idr_get_xxxx(_type, _write, _handle, _context) ({		\
+	const struct uverbs_obj_idr_type * const type =			\
+			&uverbs_type_attrs_##_type;			\
+	struct ib_uobject *uobj = type->type.ops->lookup_get(&type->type, \
+					_context, _handle, _write);	\
+									\
+	IS_ERR(uobj) ? NULL : uobj->object; })
 
 static void put_uobj_read(struct ib_uobject *uobj)
 {
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
+	uobj->type->ops->lookup_put(uobj, false);
 }
 
 static struct ib_pd *idr_read_pd(int pd_handle, struct ib_ucontext *context)
 {
-	return idr_read_obj(pd_handle, context, 0);
+	return idr_get_xxxx(pd, false, pd_handle, context);
 }
 
 static void put_pd_read(struct ib_pd *pd)
@@ -218,9 +70,9 @@ static void put_pd_read(struct ib_pd *pd)
 	put_uobj_read(pd->uobject);
 }
 
-static struct ib_cq *idr_read_cq(int cq_handle, struct ib_ucontext *context, int nested)
+static struct ib_cq *idr_read_cq(int cq_handle, struct ib_ucontext *context)
 {
-	return idr_read_obj(cq_handle, context, nested);
+	return idr_get_xxxx(cq, false, cq_handle, context);
 }
 
 static void put_cq_read(struct ib_cq *cq)
@@ -230,7 +82,7 @@ static void put_cq_read(struct ib_cq *cq)
 
 static struct ib_ah *idr_read_ah(int ah_handle, struct ib_ucontext *context)
 {
-	return idr_read_obj(ah_handle, context, 0);
+	return idr_get_xxxx(ah, false, ah_handle, context);
 }
 
 static void put_ah_read(struct ib_ah *ah)
@@ -240,12 +92,12 @@ static void put_ah_read(struct ib_ah *ah)
 
 static struct ib_qp *idr_read_qp(int qp_handle, struct ib_ucontext *context)
 {
-	return idr_read_obj(qp_handle, context, 0);
+	return idr_get_xxxx(qp, false, qp_handle, context);
 }
 
 static struct ib_wq *idr_read_wq(int wq_handle, struct ib_ucontext *context)
 {
-	return idr_read_obj(wq_handle, context, 0);
+	return idr_get_xxxx(wq, false, wq_handle, context);
 }
 
 static void put_wq_read(struct ib_wq *wq)
@@ -256,7 +108,8 @@ static void put_wq_read(struct ib_wq *wq)
 static struct ib_rwq_ind_table *idr_read_rwq_indirection_table(int ind_table_handle,
 							       struct ib_ucontext *context)
 {
-	return idr_read_obj(ind_table_handle, context, 0);
+	return idr_get_xxxx(rwq_ind_table, false,
+			    ind_table_handle, context);
 }
 
 static void put_rwq_indirection_table_read(struct ib_rwq_ind_table *ind_table)
@@ -264,39 +117,28 @@ static void put_rwq_indirection_table_read(struct ib_rwq_ind_table *ind_table)
 	put_uobj_read(ind_table->uobject);
 }
 
-static struct ib_qp *idr_write_qp(int qp_handle, struct ib_ucontext *context)
-{
-	struct ib_uobject *uobj;
-
-	uobj = idr_write_uobj(qp_handle, context);
-	return uobj ? uobj->object : NULL;
-}
-
 static void put_qp_read(struct ib_qp *qp)
 {
 	put_uobj_read(qp->uobject);
 }
 
-static void put_qp_write(struct ib_qp *qp)
+static void put_srq_read(struct ib_srq *srq)
 {
-	put_uobj_write(qp->uobject);
+	put_uobj_read(srq->uobject);
 }
 
 static struct ib_srq *idr_read_srq(int srq_handle, struct ib_ucontext *context)
 {
-	return idr_read_obj(srq_handle, context, 0);
-}
-
-static void put_srq_read(struct ib_srq *srq)
-{
-	put_uobj_read(srq->uobject);
+	return idr_get_xxxx(srq, false, srq_handle, context);
 }
 
 static struct ib_xrcd *idr_read_xrcd(int xrcd_handle, struct ib_ucontext *context,
 				     struct ib_uobject **uobj)
 {
-	*uobj = idr_read_uobj(xrcd_handle, context, 0);
-	return *uobj ? (*uobj)->object : NULL;
+	*uobj = uverbs_type_attrs_xrcd.type.ops->lookup_get(&uverbs_type_attrs_xrcd.type,
+							context, xrcd_handle,
+							false);
+	return IS_ERR(*uobj) ? NULL : (*uobj)->object;
 }
 
 static void put_xrcd_read(struct ib_uobject *uobj)
@@ -341,17 +183,8 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 	ucontext->device = ib_dev;
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
@@ -555,12 +388,10 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 		   (unsigned long) cmd.response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
-	uobj = kmalloc(sizeof *uobj, GFP_KERNEL);
-	if (!uobj)
-		return -ENOMEM;
-
-	init_uobj(uobj, 0, file->ucontext, &pd_lock_class);
-	down_write(&uobj->mutex);
+	uobj = uverbs_type_attrs_pd.type.ops->alloc_begin(&uverbs_type_attrs_pd.type,
+						      file->ucontext);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
 
 	pd = ib_dev->alloc_pd(ib_dev, file->ucontext, &udata);
 	if (IS_ERR(pd)) {
@@ -574,10 +405,6 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 	atomic_set(&pd->usecnt, 0);
 
 	uobj->object = pd;
-	ret = idr_add_uobj(uobj);
-	if (ret)
-		goto err_idr;
-
 	memset(&resp, 0, sizeof resp);
 	resp.pd_handle = uobj->id;
 
@@ -587,24 +414,15 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 		goto err_copy;
 	}
 
-	mutex_lock(&file->mutex);
-	list_add_tail(&uobj->list, &file->ucontext->pd_list);
-	mutex_unlock(&file->mutex);
-
-	uobj->live = 1;
-
-	up_write(&uobj->mutex);
+	uobj->type->ops->alloc_commit(uobj);
 
 	return in_len;
 
 err_copy:
-	idr_remove_uobj(uobj);
-
-err_idr:
 	ib_dealloc_pd(pd);
 
 err:
-	put_uobj_write(uobj);
+	uobj->type->ops->alloc_abort(uobj);
 	return ret;
 }
 
@@ -621,9 +439,11 @@ ssize_t ib_uverbs_dealloc_pd(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(cmd.pd_handle, file->ucontext);
-	if (!uobj)
-		return -EINVAL;
+	uobj = uverbs_type_attrs_pd.type.ops->lookup_get(&uverbs_type_attrs_pd.type,
+						     file->ucontext,
+						     cmd.pd_handle, true);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
 	pd = uobj->object;
 
 	if (atomic_read(&pd->usecnt)) {
@@ -636,21 +456,12 @@ ssize_t ib_uverbs_dealloc_pd(struct ib_uverbs_file *file,
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
+	uobj->type->ops->destroy_commit(uobj);
 
 	return in_len;
 
 err_put:
-	put_uobj_write(uobj);
+	uobj->type->ops->lookup_put(uobj, true);
 	return ret;
 }
 
@@ -788,16 +599,14 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 		}
 	}
 
-	obj = kmalloc(sizeof *obj, GFP_KERNEL);
-	if (!obj) {
-		ret = -ENOMEM;
+	obj = (struct ib_uxrcd_object *)
+		uverbs_type_attrs_xrcd.type.ops->alloc_begin(&uverbs_type_attrs_xrcd.type,
+							 file->ucontext);
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
@@ -815,10 +624,6 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 
 	atomic_set(&obj->refcnt, 0);
 	obj->uobject.object = xrcd;
-	ret = idr_add_uobj(&obj->uobject);
-	if (ret)
-		goto err_idr;
-
 	memset(&resp, 0, sizeof resp);
 	resp.xrcd_handle = obj->uobject.id;
 
@@ -827,7 +632,7 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 			/* create new inode/xrcd table entry */
 			ret = xrcd_table_insert(file->device, inode, xrcd);
 			if (ret)
-				goto err_insert_xrcd;
+				goto err_dealloc_xrcd;
 		}
 		atomic_inc(&xrcd->usecnt);
 	}
@@ -841,12 +646,7 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 	if (f.file)
 		fdput(f);
 
-	mutex_lock(&file->mutex);
-	list_add_tail(&obj->uobject.list, &file->ucontext->xrcd_list);
-	mutex_unlock(&file->mutex);
-
-	obj->uobject.live = 1;
-	up_write(&obj->uobject.mutex);
+	(&obj->uobject)->type->ops->alloc_commit(&obj->uobject);
 
 	mutex_unlock(&file->device->xrcd_tree_mutex);
 	return in_len;
@@ -858,14 +658,11 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
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
+	(&obj->uobject)->type->ops->alloc_abort(&obj->uobject);
 
 err_tree_mutex_unlock:
 	if (f.file)
@@ -886,57 +683,50 @@ ssize_t ib_uverbs_close_xrcd(struct ib_uverbs_file *file,
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
+	uobj = uverbs_type_attrs_xrcd.type.ops->lookup_get(&uverbs_type_attrs_xrcd.type,
+						       file->ucontext,
+						       cmd.xrcd_handle, true);
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
 
 	if (!inode || atomic_dec_and_test(&xrcd->usecnt)) {
 		ret = ib_dealloc_xrcd(uobj->object);
-		if (!ret)
-			uobj->live = 0;
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
-	ret = in_len;
-
 out:
+	if (!ret)
+		uobj->type->ops->destroy_commit(uobj);
+	else
+		uobj->type->ops->lookup_put(uobj, true);
 	mutex_unlock(&file->device->xrcd_tree_mutex);
-	return ret;
+	return ret ?: in_len;
 }
 
 void ib_uverbs_dealloc_xrcd(struct ib_uverbs_device *dev,
@@ -984,12 +774,10 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
-	uobj = kmalloc(sizeof *uobj, GFP_KERNEL);
-	if (!uobj)
-		return -ENOMEM;
-
-	init_uobj(uobj, 0, file->ucontext, &mr_lock_class);
-	down_write(&uobj->mutex);
+	uobj = uverbs_type_attrs_mr.type.ops->alloc_begin(&uverbs_type_attrs_mr.type,
+						      file->ucontext);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
 
 	pd = idr_read_pd(cmd.pd_handle, file->ucontext);
 	if (!pd) {
@@ -1019,9 +807,6 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 	atomic_inc(&pd->usecnt);
 
 	uobj->object = mr;
-	ret = idr_add_uobj(uobj);
-	if (ret)
-		goto err_unreg;
 
 	memset(&resp, 0, sizeof resp);
 	resp.lkey      = mr->lkey;
@@ -1036,27 +821,18 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 
 	put_pd_read(pd);
 
-	mutex_lock(&file->mutex);
-	list_add_tail(&uobj->list, &file->ucontext->mr_list);
-	mutex_unlock(&file->mutex);
-
-	uobj->live = 1;
-
-	up_write(&uobj->mutex);
+	uobj->type->ops->alloc_commit(uobj);
 
 	return in_len;
 
 err_copy:
-	idr_remove_uobj(uobj);
-
-err_unreg:
 	ib_dereg_mr(mr);
 
 err_put:
 	put_pd_read(pd);
 
 err_free:
-	put_uobj_write(uobj);
+	uobj->type->ops->alloc_abort(uobj);
 	return ret;
 }
 
@@ -1092,10 +868,11 @@ ssize_t ib_uverbs_rereg_mr(struct ib_uverbs_file *file,
 	     (cmd.start & ~PAGE_MASK) != (cmd.hca_va & ~PAGE_MASK)))
 			return -EINVAL;
 
-	uobj = idr_write_uobj(cmd.mr_handle, file->ucontext);
-
-	if (!uobj)
-		return -EINVAL;
+	uobj = uverbs_type_attrs_mr.type.ops->lookup_get(&uverbs_type_attrs_mr.type,
+						     file->ucontext,
+						     cmd.mr_handle, true);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
 
 	mr = uobj->object;
 
@@ -1142,8 +919,7 @@ ssize_t ib_uverbs_rereg_mr(struct ib_uverbs_file *file,
 		put_pd_read(pd);
 
 put_uobjs:
-
-	put_uobj_write(mr->uobject);
+	uobj->type->ops->lookup_put(uobj, true);
 
 	return ret;
 }
@@ -1161,28 +937,22 @@ ssize_t ib_uverbs_dereg_mr(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(cmd.mr_handle, file->ucontext);
-	if (!uobj)
-		return -EINVAL;
+	uobj = uverbs_type_attrs_mr.type.ops->lookup_get(&uverbs_type_attrs_mr.type,
+						     file->ucontext,
+						     cmd.mr_handle, true);
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
+		uobj->type->ops->lookup_put(uobj, true);
 		return ret;
+	}
 
-	idr_remove_uobj(uobj);
-
-	mutex_lock(&file->mutex);
-	list_del(&uobj->list);
-	mutex_unlock(&file->mutex);
-
-	put_uobj(uobj);
+	uobj->type->ops->destroy_commit(uobj);
 
 	return in_len;
 }
@@ -1206,12 +976,10 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof(cmd)))
 		return -EFAULT;
 
-	uobj = kmalloc(sizeof(*uobj), GFP_KERNEL);
-	if (!uobj)
-		return -ENOMEM;
-
-	init_uobj(uobj, 0, file->ucontext, &mw_lock_class);
-	down_write(&uobj->mutex);
+	uobj = uverbs_type_attrs_mw.type.ops->alloc_begin(&uverbs_type_attrs_mw.type,
+						      file->ucontext);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
 
 	pd = idr_read_pd(cmd.pd_handle, file->ucontext);
 	if (!pd) {
@@ -1236,9 +1004,6 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 	atomic_inc(&pd->usecnt);
 
 	uobj->object = mw;
-	ret = idr_add_uobj(uobj);
-	if (ret)
-		goto err_unalloc;
 
 	memset(&resp, 0, sizeof(resp));
 	resp.rkey      = mw->rkey;
@@ -1251,28 +1016,16 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 	}
 
 	put_pd_read(pd);
-
-	mutex_lock(&file->mutex);
-	list_add_tail(&uobj->list, &file->ucontext->mw_list);
-	mutex_unlock(&file->mutex);
-
-	uobj->live = 1;
-
-	up_write(&uobj->mutex);
+	uobj->type->ops->alloc_commit(uobj);
 
 	return in_len;
 
 err_copy:
-	idr_remove_uobj(uobj);
-
-err_unalloc:
 	uverbs_dealloc_mw(mw);
-
 err_put:
 	put_pd_read(pd);
-
 err_free:
-	put_uobj_write(uobj);
+	uobj->type->ops->alloc_abort(uobj);
 	return ret;
 }
 
@@ -1289,28 +1042,21 @@ ssize_t ib_uverbs_dealloc_mw(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof(cmd)))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(cmd.mw_handle, file->ucontext);
-	if (!uobj)
-		return -EINVAL;
+	uobj = uverbs_type_attrs_mw.type.ops->lookup_get(&uverbs_type_attrs_mw.type,
+						     file->ucontext,
+						     cmd.mw_handle, true);
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
+		uobj->type->ops->lookup_put(uobj, true);
 		return ret;
+	}
 
-	idr_remove_uobj(uobj);
-
-	mutex_lock(&file->mutex);
-	list_del(&uobj->list);
-	mutex_unlock(&file->mutex);
-
-	put_uobj(uobj);
+	uobj->type->ops->destroy_commit(uobj);
 
 	return in_len;
 }
@@ -1376,12 +1122,11 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 	if (cmd->comp_vector >= file->device->num_comp_vectors)
 		return ERR_PTR(-EINVAL);
 
-	obj = kmalloc(sizeof *obj, GFP_KERNEL);
-	if (!obj)
-		return ERR_PTR(-ENOMEM);
-
-	init_uobj(&obj->uobject, cmd->user_handle, file->ucontext, &cq_lock_class);
-	down_write(&obj->uobject.mutex);
+	obj = (struct ib_ucq_object *)
+		uverbs_type_attrs_cq.type.ops->alloc_begin(&uverbs_type_attrs_cq.type,
+						       file->ucontext);
+	if (IS_ERR(obj))
+		return obj;
 
 	if (cmd->comp_channel >= 0) {
 		ev_file = ib_uverbs_lookup_comp_file(cmd->comp_channel);
@@ -1391,6 +1136,7 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 		}
 	}
 
+	obj->uobject.user_handle = cmd->user_handle;
 	obj->uverbs_file	   = file;
 	obj->comp_events_reported  = 0;
 	obj->async_events_reported = 0;
@@ -1403,8 +1149,7 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 	if (cmd_sz > offsetof(typeof(*cmd), flags) + sizeof(cmd->flags))
 		attr.flags = cmd->flags;
 
-	cq = ib_dev->create_cq(ib_dev, &attr,
-					     file->ucontext, uhw);
+	cq = ib_dev->create_cq(ib_dev, &attr, file->ucontext, uhw);
 	if (IS_ERR(cq)) {
 		ret = PTR_ERR(cq);
 		goto err_file;
@@ -1418,10 +1163,6 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 	atomic_set(&cq->usecnt, 0);
 
 	obj->uobject.object = cq;
-	ret = idr_add_uobj(&obj->uobject);
-	if (ret)
-		goto err_free;
-
 	memset(&resp, 0, sizeof resp);
 	resp.base.cq_handle = obj->uobject.id;
 	resp.base.cqe       = cq->cqe;
@@ -1433,20 +1174,11 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 	if (ret)
 		goto err_cb;
 
-	mutex_lock(&file->mutex);
-	list_add_tail(&obj->uobject.list, &file->ucontext->cq_list);
-	mutex_unlock(&file->mutex);
-
-	obj->uobject.live = 1;
-
-	up_write(&obj->uobject.mutex);
+	(&obj->uobject)->type->ops->alloc_commit(&obj->uobject);
 
 	return obj;
 
 err_cb:
-	idr_remove_uobj(&obj->uobject);
-
-err_free:
 	ib_destroy_cq(cq);
 
 err_file:
@@ -1454,7 +1186,7 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 		ib_uverbs_release_ucq(file, ev_file, obj);
 
 err:
-	put_uobj_write(&obj->uobject);
+	(&obj->uobject)->type->ops->alloc_abort(&obj->uobject);
 
 	return ERR_PTR(ret);
 }
@@ -1577,7 +1309,7 @@ ssize_t ib_uverbs_resize_cq(struct ib_uverbs_file *file,
 		   (unsigned long) cmd.response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
-	cq = idr_read_cq(cmd.cq_handle, file->ucontext, 0);
+	cq = idr_read_cq(cmd.cq_handle, file->ucontext);
 	if (!cq)
 		return -EINVAL;
 
@@ -1639,7 +1371,7 @@ ssize_t ib_uverbs_poll_cq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	cq = idr_read_cq(cmd.cq_handle, file->ucontext, 0);
+	cq = idr_read_cq(cmd.cq_handle, file->ucontext);
 	if (!cq)
 		return -EINVAL;
 
@@ -1686,7 +1418,7 @@ ssize_t ib_uverbs_req_notify_cq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	cq = idr_read_cq(cmd.cq_handle, file->ucontext, 0);
+	cq = idr_read_cq(cmd.cq_handle, file->ucontext);
 	if (!cq)
 		return -EINVAL;
 
@@ -1714,36 +1446,29 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(cmd.cq_handle, file->ucontext);
-	if (!uobj)
-		return -EINVAL;
+	uobj = uverbs_type_attrs_cq.type.ops->lookup_get(&uverbs_type_attrs_cq.type,
+						     file->ucontext,
+						     cmd.cq_handle, true);
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
+		uobj->type->ops->lookup_put(uobj, true);
 		return ret;
-
-	idr_remove_uobj(uobj);
-
-	mutex_lock(&file->mutex);
-	list_del(&uobj->list);
-	mutex_unlock(&file->mutex);
+	}
 
 	ib_uverbs_release_ucq(file, ev_file, obj);
+	uobj->type->ops->destroy_commit(uobj);
 
 	memset(&resp, 0, sizeof resp);
 	resp.comp_events_reported  = obj->comp_events_reported;
 	resp.async_events_reported = obj->async_events_reported;
 
-	put_uobj(uobj);
-
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp))
 		return -EFAULT;
@@ -1779,13 +1504,14 @@ static int create_qp(struct ib_uverbs_file *file,
 	if (cmd->qp_type == IB_QPT_RAW_PACKET && !capable(CAP_NET_RAW))
 		return -EPERM;
 
-	obj = kzalloc(sizeof *obj, GFP_KERNEL);
-	if (!obj)
-		return -ENOMEM;
+	obj = (struct ib_uqp_object *)
+		uverbs_type_attrs_qp.type.ops->alloc_begin(&uverbs_type_attrs_qp.type,
+						       file->ucontext);
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
@@ -1838,7 +1564,7 @@ static int create_qp(struct ib_uverbs_file *file,
 			if (!ind_tbl) {
 				if (cmd->recv_cq_handle != cmd->send_cq_handle) {
 					rcq = idr_read_cq(cmd->recv_cq_handle,
-							  file->ucontext, 0);
+							  file->ucontext);
 					if (!rcq) {
 						ret = -EINVAL;
 						goto err_put;
@@ -1848,7 +1574,7 @@ static int create_qp(struct ib_uverbs_file *file,
 		}
 
 		if (has_sq)
-			scq = idr_read_cq(cmd->send_cq_handle, file->ucontext, !!rcq);
+			scq = idr_read_cq(cmd->send_cq_handle, file->ucontext);
 		if (!ind_tbl)
 			rcq = rcq ?: scq;
 		pd  = idr_read_pd(cmd->pd_handle, file->ucontext);
@@ -1937,9 +1663,6 @@ static int create_qp(struct ib_uverbs_file *file,
 	qp->uobject = &obj->uevent.uobject;
 
 	obj->uevent.uobject.object = qp;
-	ret = idr_add_uobj(&obj->uevent.uobject);
-	if (ret)
-		goto err_destroy;
 
 	memset(&resp, 0, sizeof resp);
 	resp.base.qpn             = qp->qp_num;
@@ -1975,19 +1698,10 @@ static int create_qp(struct ib_uverbs_file *file,
 	if (ind_tbl)
 		put_rwq_indirection_table_read(ind_tbl);
 
-	mutex_lock(&file->mutex);
-	list_add_tail(&obj->uevent.uobject.list, &file->ucontext->qp_list);
-	mutex_unlock(&file->mutex);
-
-	obj->uevent.uobject.live = 1;
-
-	up_write(&obj->uevent.uobject.mutex);
+	(&obj->uevent.uobject)->type->ops->alloc_commit(&obj->uevent.uobject);
 
 	return 0;
 err_cb:
-	idr_remove_uobj(&obj->uevent.uobject);
-
-err_destroy:
 	ib_destroy_qp(qp);
 
 err_put:
@@ -2004,7 +1718,7 @@ static int create_qp(struct ib_uverbs_file *file,
 	if (ind_tbl)
 		put_rwq_indirection_table_read(ind_tbl);
 
-	put_uobj_write(&obj->uevent.uobject);
+	(&obj->uevent.uobject)->type->ops->alloc_abort(&obj->uevent.uobject);
 	return ret;
 }
 
@@ -2140,12 +1854,11 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
 		   (unsigned long) cmd.response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
-	obj = kmalloc(sizeof *obj, GFP_KERNEL);
-	if (!obj)
-		return -ENOMEM;
-
-	init_uobj(&obj->uevent.uobject, cmd.user_handle, file->ucontext, &qp_lock_class);
-	down_write(&obj->uevent.uobject.mutex);
+	obj = (struct ib_uqp_object *)
+		uverbs_type_attrs_qp.type.ops->alloc_begin(&uverbs_type_attrs_qp.type,
+						       file->ucontext);
+	if (IS_ERR(obj))
+		return PTR_ERR(obj);
 
 	xrcd = idr_read_xrcd(cmd.pd_handle, file->ucontext, &xrcd_uobj);
 	if (!xrcd) {
@@ -2165,15 +1878,11 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
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
@@ -2182,32 +1891,25 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp)) {
 		ret = -EFAULT;
-		goto err_remove;
+		goto err_destroy;
 	}
 
 	obj->uxrcd = container_of(xrcd_uobj, struct ib_uxrcd_object, uobject);
 	atomic_inc(&obj->uxrcd->refcnt);
+	qp->uobject = &obj->uevent.uobject;
 	put_xrcd_read(xrcd_uobj);
 
-	mutex_lock(&file->mutex);
-	list_add_tail(&obj->uevent.uobject.list, &file->ucontext->qp_list);
-	mutex_unlock(&file->mutex);
-
-	obj->uevent.uobject.live = 1;
 
-	up_write(&obj->uevent.uobject.mutex);
+	(&obj->uevent.uobject)->type->ops->alloc_commit(&obj->uevent.uobject);
 
 	return in_len;
 
-err_remove:
-	idr_remove_uobj(&obj->uevent.uobject);
-
 err_destroy:
 	ib_destroy_qp(qp);
-
-err_put:
+err_xrcd:
 	put_xrcd_read(xrcd_uobj);
-	put_uobj_write(&obj->uevent.uobject);
+err_put:
+	(&obj->uevent.uobject)->type->ops->alloc_abort(&obj->uevent.uobject);
 	return ret;
 }
 
@@ -2496,40 +2198,34 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 
 	memset(&resp, 0, sizeof resp);
 
-	uobj = idr_write_uobj(cmd.qp_handle, file->ucontext);
-	if (!uobj)
-		return -EINVAL;
+	uobj = uverbs_type_attrs_qp.type.ops->lookup_get(&uverbs_type_attrs_qp.type,
+						     file->ucontext,
+						     cmd.qp_handle, true);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
+
 	qp  = uobj->object;
 	obj = container_of(uobj, struct ib_uqp_object, uevent.uobject);
 
 	if (!list_empty(&obj->mcast_list)) {
-		put_uobj_write(uobj);
+		uobj->type->ops->lookup_put(uobj, true);
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
+		uobj->type->ops->lookup_put(uobj, true);
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
+	uobj->type->ops->destroy_commit(uobj);
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp))
@@ -2845,13 +2541,13 @@ ssize_t ib_uverbs_post_recv(struct ib_uverbs_file *file,
 	ret = qp->device->post_recv(qp->real_qp, wr, &bad_wr);
 
 	put_qp_read(qp);
-
-	if (ret)
+	if (ret) {
 		for (next = wr; next; next = next->next) {
 			++resp.bad_wr;
 			if (next == bad_wr)
 				break;
 		}
+	}
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp))
@@ -2941,12 +2637,10 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 		   (unsigned long)cmd.response + sizeof(resp),
 		   in_len - sizeof(cmd), out_len - sizeof(resp));
 
-	uobj = kmalloc(sizeof *uobj, GFP_KERNEL);
-	if (!uobj)
-		return -ENOMEM;
-
-	init_uobj(uobj, cmd.user_handle, file->ucontext, &ah_lock_class);
-	down_write(&uobj->mutex);
+	uobj = uverbs_type_attrs_ah.type.ops->alloc_begin(&uverbs_type_attrs_ah.type,
+						      file->ucontext);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
 
 	pd = idr_read_pd(cmd.pd_handle, file->ucontext);
 	if (!pd) {
@@ -2978,12 +2672,9 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
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
@@ -2993,28 +2684,18 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	}
 
 	put_pd_read(pd);
-
-	mutex_lock(&file->mutex);
-	list_add_tail(&uobj->list, &file->ucontext->ah_list);
-	mutex_unlock(&file->mutex);
-
-	uobj->live = 1;
-
-	up_write(&uobj->mutex);
+	uobj->type->ops->alloc_commit(uobj);
 
 	return in_len;
 
 err_copy:
-	idr_remove_uobj(uobj);
-
-err_destroy:
 	ib_destroy_ah(ah);
 
 err_put:
 	put_pd_read(pd);
 
 err:
-	put_uobj_write(uobj);
+	uobj->type->ops->alloc_abort(uobj);
 	return ret;
 }
 
@@ -3030,28 +2711,21 @@ ssize_t ib_uverbs_destroy_ah(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(cmd.ah_handle, file->ucontext);
-	if (!uobj)
-		return -EINVAL;
+	uobj = uverbs_type_attrs_ah.type.ops->lookup_get(&uverbs_type_attrs_ah.type,
+						     file->ucontext,
+						     cmd.ah_handle, true);
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
+		uobj->type->ops->lookup_put(uobj, true);
 		return ret;
+	}
 
-	idr_remove_uobj(uobj);
-
-	mutex_lock(&file->mutex);
-	list_del(&uobj->list);
-	mutex_unlock(&file->mutex);
-
-	put_uobj(uobj);
-
+	uobj->type->ops->destroy_commit(uobj);
 	return in_len;
 }
 
@@ -3069,7 +2743,7 @@ ssize_t ib_uverbs_attach_mcast(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	qp = idr_write_qp(cmd.qp_handle, file->ucontext);
+	qp = idr_read_qp(cmd.qp_handle, file->ucontext);
 	if (!qp)
 		return -EINVAL;
 
@@ -3098,7 +2772,7 @@ ssize_t ib_uverbs_attach_mcast(struct ib_uverbs_file *file,
 		kfree(mcast);
 
 out_put:
-	put_qp_write(qp);
+	put_qp_read(qp);
 
 	return ret ? ret : in_len;
 }
@@ -3117,16 +2791,16 @@ ssize_t ib_uverbs_detach_mcast(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	qp = idr_write_qp(cmd.qp_handle, file->ucontext);
+	qp = idr_read_qp(cmd.qp_handle, file->ucontext);
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
@@ -3136,8 +2810,7 @@ ssize_t ib_uverbs_detach_mcast(struct ib_uverbs_file *file,
 		}
 
 out_put:
-	put_qp_write(qp);
-
+	put_qp_read(qp);
 	return ret ? ret : in_len;
 }
 
@@ -3298,20 +2971,19 @@ int ib_uverbs_ex_create_wq(struct ib_uverbs_file *file,
 	if (cmd.comp_mask)
 		return -EOPNOTSUPP;
 
-	obj = kmalloc(sizeof(*obj), GFP_KERNEL);
-	if (!obj)
-		return -ENOMEM;
+	obj = (struct ib_uwq_object *)
+		uverbs_type_attrs_wq.type.ops->alloc_begin(&uverbs_type_attrs_wq.type,
+						       file->ucontext);
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
@@ -3343,9 +3015,6 @@ int ib_uverbs_ex_create_wq(struct ib_uverbs_file *file,
 	atomic_inc(&cq->usecnt);
 	wq->uobject = &obj->uevent.uobject;
 	obj->uevent.uobject.object = wq;
-	err = idr_add_uobj(&obj->uevent.uobject);
-	if (err)
-		goto destroy_wq;
 
 	memset(&resp, 0, sizeof(resp));
 	resp.wq_handle = obj->uevent.uobject.id;
@@ -3360,25 +3029,17 @@ int ib_uverbs_ex_create_wq(struct ib_uverbs_file *file,
 
 	put_pd_read(pd);
 	put_cq_read(cq);
-
-	mutex_lock(&file->mutex);
-	list_add_tail(&obj->uevent.uobject.list, &file->ucontext->wq_list);
-	mutex_unlock(&file->mutex);
-
-	obj->uevent.uobject.live = 1;
-	up_write(&obj->uevent.uobject.mutex);
+	(&obj->uevent.uobject)->type->ops->alloc_commit(&obj->uevent.uobject);
 	return 0;
 
 err_copy:
-	idr_remove_uobj(&obj->uevent.uobject);
-destroy_wq:
 	ib_destroy_wq(wq);
 err_put_cq:
 	put_cq_read(cq);
 err_put_pd:
 	put_pd_read(pd);
 err_uobj:
-	put_uobj_write(&obj->uevent.uobject);
+	(&obj->uevent.uobject)->type->ops->alloc_abort(&obj->uevent.uobject);
 
 	return err;
 }
@@ -3419,30 +3080,23 @@ int ib_uverbs_ex_destroy_wq(struct ib_uverbs_file *file,
 		return -EOPNOTSUPP;
 
 	resp.response_length = required_resp_len;
-	uobj = idr_write_uobj(cmd.wq_handle,
-			      file->ucontext);
-	if (!uobj)
-		return -EINVAL;
+	uobj = uverbs_type_attrs_ah.type.ops->lookup_get(&uverbs_type_attrs_ah.type,
+						     file->ucontext,
+						     cmd.wq_handle, true);
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
+		uobj->type->ops->lookup_put(uobj, true);
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
+	uobj->type->ops->destroy_commit(uobj);
 
 	ret = ib_copy_to_udata(ucore, &resp, resp.response_length);
 	if (ret)
@@ -3575,14 +3229,13 @@ int ib_uverbs_ex_create_rwq_ind_table(struct ib_uverbs_file *file,
 		wqs[num_read_wqs] = wq;
 	}
 
-	uobj = kmalloc(sizeof(*uobj), GFP_KERNEL);
-	if (!uobj) {
-		err = -ENOMEM;
+	uobj = uverbs_type_attrs_rwq_ind_table.type.ops->alloc_begin(&uverbs_type_attrs_rwq_ind_table.type,
+								 file->ucontext);
+	if (IS_ERR(uobj)) {
+		err = PTR_ERR(uobj);
 		goto put_wqs;
 	}
 
-	init_uobj(uobj, 0, file->ucontext, &rwq_ind_table_lock_class);
-	down_write(&uobj->mutex);
 	init_attr.log_ind_tbl_size = cmd.log_ind_tbl_size;
 	init_attr.ind_tbl = wqs;
 	rwq_ind_tbl = ib_dev->create_rwq_ind_table(ib_dev, &init_attr, uhw);
@@ -3602,10 +3255,6 @@ int ib_uverbs_ex_create_rwq_ind_table(struct ib_uverbs_file *file,
 	for (i = 0; i < num_wq_handles; i++)
 		atomic_inc(&wqs[i]->usecnt);
 
-	err = idr_add_uobj(uobj);
-	if (err)
-		goto destroy_ind_tbl;
-
 	resp.ind_tbl_handle = uobj->id;
 	resp.ind_tbl_num = rwq_ind_tbl->ind_tbl_num;
 	resp.response_length = required_resp_len;
@@ -3620,21 +3269,13 @@ int ib_uverbs_ex_create_rwq_ind_table(struct ib_uverbs_file *file,
 	for (j = 0; j < num_read_wqs; j++)
 		put_wq_read(wqs[j]);
 
-	mutex_lock(&file->mutex);
-	list_add_tail(&uobj->list, &file->ucontext->rwq_ind_tbl_list);
-	mutex_unlock(&file->mutex);
-
-	uobj->live = 1;
-
-	up_write(&uobj->mutex);
+	uobj->type->ops->alloc_commit(uobj);
 	return 0;
 
 err_copy:
-	idr_remove_uobj(uobj);
-destroy_ind_tbl:
 	ib_destroy_rwq_ind_table(rwq_ind_tbl);
 err_uobj:
-	put_uobj_write(uobj);
+	uobj->type->ops->alloc_abort(uobj);
 put_wqs:
 	for (j = 0; j < num_read_wqs; j++)
 		put_wq_read(wqs[j]);
@@ -3673,29 +3314,23 @@ int ib_uverbs_ex_destroy_rwq_ind_table(struct ib_uverbs_file *file,
 	if (cmd.comp_mask)
 		return -EOPNOTSUPP;
 
-	uobj = idr_write_uobj(cmd.ind_tbl_handle,
-			      file->ucontext);
-	if (!uobj)
-		return -EINVAL;
+	uobj = uverbs_type_attrs_rwq_ind_table.type.ops->lookup_get(&uverbs_type_attrs_rwq_ind_table.type,
+								file->ucontext,
+								cmd.ind_tbl_handle,
+								true);
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
+		uobj->type->ops->lookup_put(uobj, true);
 		return ret;
+	}
 
-	idr_remove_uobj(uobj);
-
-	mutex_lock(&file->mutex);
-	list_del(&uobj->list);
-	mutex_unlock(&file->mutex);
-
-	put_uobj(uobj);
+	uobj->type->ops->destroy_commit(uobj);
 	kfree(ind_tbl);
 	return ret;
 }
@@ -3771,13 +3406,12 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 		kern_flow_attr = &cmd.flow_attr;
 	}
 
-	uobj = kmalloc(sizeof(*uobj), GFP_KERNEL);
-	if (!uobj) {
-		err = -ENOMEM;
+	uobj = uverbs_type_attrs_flow.type.ops->alloc_begin(&uverbs_type_attrs_flow.type,
+							file->ucontext);
+	if (IS_ERR(uobj)) {
+		err = PTR_ERR(uobj);
 		goto err_free_attr;
 	}
-	init_uobj(uobj, 0, file->ucontext, &rule_lock_class);
-	down_write(&uobj->mutex);
 
 	qp = idr_read_qp(cmd.qp_handle, file->ucontext);
 	if (!qp) {
@@ -3828,10 +3462,6 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 	flow_id->uobject = uobj;
 	uobj->object = flow_id;
 
-	err = idr_add_uobj(uobj);
-	if (err)
-		goto destroy_flow;
-
 	memset(&resp, 0, sizeof(resp));
 	resp.flow_handle = uobj->id;
 
@@ -3841,27 +3471,19 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 		goto err_copy;
 
 	put_qp_read(qp);
-	mutex_lock(&file->mutex);
-	list_add_tail(&uobj->list, &file->ucontext->rule_list);
-	mutex_unlock(&file->mutex);
-
-	uobj->live = 1;
-
-	up_write(&uobj->mutex);
+	uobj->type->ops->alloc_commit(uobj);
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
 	put_qp_read(qp);
 err_uobj:
-	put_uobj_write(uobj);
+	uobj->type->ops->alloc_abort(uobj);
 err_free_attr:
 	if (cmd.flow_attr.num_of_specs)
 		kfree(kern_flow_attr);
@@ -3888,25 +3510,19 @@ int ib_uverbs_ex_destroy_flow(struct ib_uverbs_file *file,
 	if (cmd.comp_mask)
 		return -EINVAL;
 
-	uobj = idr_write_uobj(cmd.flow_handle, file->ucontext);
-	if (!uobj)
-		return -EINVAL;
+	uobj = uverbs_type_attrs_flow.type.ops->lookup_get(&uverbs_type_attrs_flow.type,
+						       file->ucontext,
+						       cmd.flow_handle, true);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
+
 	flow_id = uobj->object;
 
 	ret = ib_destroy_flow(flow_id);
 	if (!ret)
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
+		uobj->type->ops->destroy_commit(uobj);
+	else
+		uobj->type->ops->lookup_put(uobj, true);
 	return ret;
 }
 
@@ -3923,12 +3539,11 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	struct ib_srq_init_attr          attr;
 	int ret;
 
-	obj = kmalloc(sizeof *obj, GFP_KERNEL);
-	if (!obj)
-		return -ENOMEM;
-
-	init_uobj(&obj->uevent.uobject, cmd->user_handle, file->ucontext, &srq_lock_class);
-	down_write(&obj->uevent.uobject.mutex);
+	obj = (struct ib_usrq_object *)
+		uverbs_type_attrs_srq.type.ops->alloc_begin(&uverbs_type_attrs_srq.type,
+							file->ucontext);
+	if (IS_ERR(obj))
+		return PTR_ERR(obj);
 
 	if (cmd->srq_type == IB_SRQT_XRC) {
 		attr.ext.xrc.xrcd  = idr_read_xrcd(cmd->xrcd_handle, file->ucontext, &xrcd_uobj);
@@ -3940,7 +3555,7 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 		obj->uxrcd = container_of(xrcd_uobj, struct ib_uxrcd_object, uobject);
 		atomic_inc(&obj->uxrcd->refcnt);
 
-		attr.ext.xrc.cq  = idr_read_cq(cmd->cq_handle, file->ucontext, 0);
+		attr.ext.xrc.cq  = idr_read_cq(cmd->cq_handle, file->ucontext);
 		if (!attr.ext.xrc.cq) {
 			ret = -EINVAL;
 			goto err_put_xrcd;
@@ -3987,9 +3602,7 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	atomic_set(&srq->usecnt, 0);
 
 	obj->uevent.uobject.object = srq;
-	ret = idr_add_uobj(&obj->uevent.uobject);
-	if (ret)
-		goto err_destroy;
+	obj->uevent.uobject.user_handle = cmd->user_handle;
 
 	memset(&resp, 0, sizeof resp);
 	resp.srq_handle = obj->uevent.uobject.id;
@@ -4005,25 +3618,15 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	}
 
 	if (cmd->srq_type == IB_SRQT_XRC) {
-		put_uobj_read(xrcd_uobj);
+		put_xrcd_read(xrcd_uobj);
 		put_cq_read(attr.ext.xrc.cq);
 	}
 	put_pd_read(pd);
-
-	mutex_lock(&file->mutex);
-	list_add_tail(&obj->uevent.uobject.list, &file->ucontext->srq_list);
-	mutex_unlock(&file->mutex);
-
-	obj->uevent.uobject.live = 1;
-
-	up_write(&obj->uevent.uobject.mutex);
+	(&obj->uevent.uobject)->type->ops->alloc_commit(&obj->uevent.uobject);
 
 	return 0;
 
 err_copy:
-	idr_remove_uobj(&obj->uevent.uobject);
-
-err_destroy:
 	ib_destroy_srq(srq);
 
 err_put:
@@ -4036,11 +3639,11 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 err_put_xrcd:
 	if (cmd->srq_type == IB_SRQT_XRC) {
 		atomic_dec(&obj->uxrcd->refcnt);
-		put_uobj_read(xrcd_uobj);
+		put_xrcd_read(xrcd_uobj);
 	}
 
 err:
-	put_uobj_write(&obj->uevent.uobject);
+	(&obj->uevent.uobject)->type->ops->alloc_abort(&obj->uevent.uobject);
 	return ret;
 }
 
@@ -4197,39 +3800,33 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(cmd.srq_handle, file->ucontext);
-	if (!uobj)
-		return -EINVAL;
+	uobj = uverbs_type_attrs_srq.type.ops->lookup_get(&uverbs_type_attrs_srq.type,
+						      file->ucontext,
+						      cmd.srq_handle, true);
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
+		uobj->type->ops->lookup_put(uobj, true);
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
+	uobj->type->ops->destroy_commit(uobj);
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp))
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index ba8b1eb..0eb4538 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -51,6 +51,7 @@
 #include <rdma/ib.h>
 
 #include "uverbs.h"
+#include "rdma_core.h"
 
 MODULE_AUTHOR("Roland Dreier");
 MODULE_DESCRIPTION("InfiniBand userspace verbs access");
@@ -213,122 +214,11 @@ void ib_uverbs_detach_umcast(struct ib_qp *qp,
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
+	uverbs_cleanup_ucontext(context, device_removed);
 	put_pid(context->tgid);
 
 	return context->device->dealloc_ucontext(context);
@@ -570,7 +460,7 @@ void ib_uverbs_qp_event_handler(struct ib_event *event, void *context_ptr)
 	struct ib_uevent_object *uobj;
 
 	/* for XRC target qp's, check that qp is live */
-	if (!event->element.qp->uobject || !event->element.qp->uobject->live)
+	if (!event->element.qp->uobject)
 		return;
 
 	uobj = container_of(event->element.qp->uobject,
@@ -988,7 +878,7 @@ static int ib_uverbs_close(struct inode *inode, struct file *filp)
 
 	mutex_lock(&file->cleanup_mutex);
 	if (file->ucontext) {
-		ib_uverbs_cleanup_ucontext(file, file->ucontext);
+		ib_uverbs_cleanup_ucontext(file, file->ucontext, false);
 		file->ucontext = NULL;
 	}
 	mutex_unlock(&file->cleanup_mutex);
@@ -1238,7 +1128,7 @@ static void ib_uverbs_free_hw_resources(struct ib_uverbs_device *uverbs_dev,
 			 * (e.g mmput).
 			 */
 			ib_dev->disassociate_ucontext(ucontext);
-			ib_uverbs_cleanup_ucontext(file, ucontext);
+			ib_uverbs_cleanup_ucontext(file, ucontext, true);
 		}
 
 		mutex_lock(&uverbs_dev->lists_mutex);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 4a2a0fc..7ddb08f 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1334,17 +1334,6 @@ struct ib_fmr_attr {
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
@@ -1377,10 +1366,8 @@ struct ib_uobject {
 	struct list_head	list;		/* link to context's list */
 	int			id;		/* index into kernel idr */
 	struct kref		ref;
-	struct rw_semaphore	mutex;		/* protects .live */
 	struct rw_semaphore	currently_used;	/* protects exclusive access */
 	struct rcu_head		rcu;		/* kfree_rcu() overhead */
-	int			live;
 
 	const struct uverbs_obj_type *type;
 };
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
