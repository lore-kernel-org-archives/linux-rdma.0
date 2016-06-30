From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC ABI V1 7/8] RDMA/core: Change locking of ib_uobject
Date: Thu, 30 Jun 2016 16:39:30 +0300
Message-ID: <1467293971-25688-8-git-send-email-matanb@mellanox.com>
References: <1467293971-25688-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467293971-25688-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch presents some concept about lockless scheme. It's only
intended to open discussion and still misses some crucial parts.

Every ib_uobject has a usecnt atomic variable. Single rwsem in
ib_uverbs_file (protect destruction of device from execution of
commands).

For every command execution:
  a. Check if device is available (as of today, with srcu)
  b. Take down_read(&file->close_sem)
  c. <User is now protected from closing the process and ib-dev
     destruction>
  d. When an object is used -> use uverbs_lock_object function
     implemented in this patch.
       i .If the object isn't available (-EBUSY)
  e. Unlock with uverbs_unlock_object (implemented in this patch)
  f. Release up_read(&file->close_sem)

Disassociate/process destruction:
  * In disassociate, do thee following for every process
  1. Grab down_write(&file->close_sem)
  2. Release all objects from context, ordered by type list (call free
     function the driver has specified)
  3. Release up_write(&file->close_sem)

ib_uobjects are lockless. If two commands are executed in
parallel and one need exclusive access (WRITE/DESTROY) -> one
command will fail. User-space needs to either synchronize or do
something productive with the failure.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uidr.c       | 11 +-----
 drivers/infiniband/core/uobject.c    |  6 +--
 drivers/infiniband/core/uobject.h    |  4 +-
 drivers/infiniband/core/uverbs_cmd.c | 72 +++++++++++++++---------------------
 include/rdma/ib_verbs.h              |  1 -
 5 files changed, 35 insertions(+), 59 deletions(-)

diff --git a/drivers/infiniband/core/uidr.c b/drivers/infiniband/core/uidr.c
index 72c4c77..6018717 100644
--- a/drivers/infiniband/core/uidr.c
+++ b/drivers/infiniband/core/uidr.c
@@ -88,7 +88,7 @@ struct ib_uobject *uverbs_get_type_from_idr(struct uverbs_uobject_type *type,
 		if (!uobj)
 			return ERR_PTR(-ENOMEM);
 
-		init_uobj(uobj, 0, ucontext, &type->lock_class);
+		init_uobj(uobj, 0, ucontext);
 
 		/* lock idr */
 		ret = ib_uverbs_uobject_add(uobj, type);
@@ -213,10 +213,6 @@ static struct ib_uobject *idr_read_uobj(int id, struct ib_ucontext *context,
 	if (!uobj)
 		return NULL;
 
-	if (nested)
-		down_read_nested(&uobj->mutex, SINGLE_DEPTH_NESTING);
-	else
-		down_read(&uobj->mutex);
 	if (!uobj->live) {
 		put_uobj_read(uobj);
 		return NULL;
@@ -233,11 +229,8 @@ struct ib_uobject *idr_write_uobj(int id, struct ib_ucontext *context)
 	if (!uobj)
 		return NULL;
 
-	down_write(&uobj->mutex);
-	if (!uobj->live) {
-		put_uobj_write(uobj);
+	if (!uobj->live)
 		return NULL;
-	}
 
 	return uobj;
 }
diff --git a/drivers/infiniband/core/uobject.c b/drivers/infiniband/core/uobject.c
index c3d1098..ed862e8 100644
--- a/drivers/infiniband/core/uobject.c
+++ b/drivers/infiniband/core/uobject.c
@@ -179,13 +179,11 @@ void ib_uverbs_uobject_enable(struct ib_uobject *uobject)
  */
 
 void init_uobj(struct ib_uobject *uobj, u64 user_handle,
-	       struct ib_ucontext *context, struct uverbs_lock_class *c)
+	       struct ib_ucontext *context)
 {
 	uobj->user_handle = user_handle;
 	uobj->context     = context;
 	kref_init(&uobj->ref);
-	init_rwsem(&uobj->mutex);
-	lockdep_set_class_and_name(&uobj->mutex, &c->key, c->name);
 	uobj->live        = 0;
 }
 
@@ -201,12 +199,10 @@ void put_uobj(struct ib_uobject *uobj)
 
 void put_uobj_read(struct ib_uobject *uobj)
 {
-	up_read(&uobj->mutex);
 	put_uobj(uobj);
 }
 
 void put_uobj_write(struct ib_uobject *uobj)
 {
-	up_write(&uobj->mutex);
 	put_uobj(uobj);
 }
diff --git a/drivers/infiniband/core/uobject.h b/drivers/infiniband/core/uobject.h
index 13fdaef..3514a1b 100644
--- a/drivers/infiniband/core/uobject.h
+++ b/drivers/infiniband/core/uobject.h
@@ -48,12 +48,12 @@ struct uverbs_uobject_type {
 		     struct ib_uobject *uobject,
 		     struct ib_ucontext *ucontext);
 	u16			obj_type;
-	struct uverbs_lock_class lock_class;
 };
 
 /* embed in ucontext per type */
 struct uverbs_uobject_list {
 	struct uverbs_uobject_type	*type;
+	/* TODO: replace with hash for faster access */
 	struct list_head		list;
 	struct list_head		type_list;
 };
@@ -64,7 +64,7 @@ void ib_uverbs_uobject_remove(struct ib_uobject *uobject);
 void ib_uverbs_uobject_enable(struct ib_uobject *uobject);
 
 void init_uobj(struct ib_uobject *uobj, u64 user_handle,
-	       struct ib_ucontext *context, struct uverbs_lock_class *c);
+	       struct ib_ucontext *context);
 
 void release_uobj(struct kref *kref);
 void put_uobj(struct ib_uobject *uobj);
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 22406fe..148e26e 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -46,16 +46,6 @@
 
 #include "core_priv.h"
 
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
 ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 			      struct ib_device *ib_dev,
 			      const char __user *buf,
@@ -308,8 +298,8 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 	if (!uobj)
 		return -ENOMEM;
 
-	init_uobj(uobj, 0, file->ucontext, &pd_lock_class);
-	down_write(&uobj->mutex);
+	down_read(&file->close_sem);
+	init_uobj(uobj, 0, file->ucontext);
 
 	pd = ib_dev->alloc_pd(ib_dev, file->ucontext, &udata);
 	if (IS_ERR(pd)) {
@@ -342,7 +332,7 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 
 	uobj->live = 1;
 
-	up_write(&uobj->mutex);
+	up_read(&file->close_sem);
 
 	return in_len;
 
@@ -543,9 +533,8 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 		goto err_tree_mutex_unlock;
 	}
 
-	init_uobj(&obj->uobject, 0, file->ucontext, &xrcd_lock_class);
-
-	down_write(&obj->uobject.mutex);
+	down_read(&file->close_sem);
+	init_uobj(&obj->uobject, 0, file->ucontext);
 
 	if (!xrcd) {
 		xrcd = ib_dev->alloc_xrcd(ib_dev, file->ucontext, &udata);
@@ -595,7 +584,7 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 	mutex_unlock(&file->mutex);
 
 	obj->uobject.live = 1;
-	up_write(&obj->uobject.mutex);
+	up_read(&file->close_sem);
 
 	mutex_unlock(&file->device->xrcd_tree_mutex);
 	return in_len;
@@ -737,8 +726,8 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 	if (!uobj)
 		return -ENOMEM;
 
-	init_uobj(uobj, 0, file->ucontext, &mr_lock_class);
-	down_write(&uobj->mutex);
+	down_read(&file->close_sem);
+	init_uobj(uobj, 0, file->ucontext);
 
 	pd = idr_read_pd(cmd.pd_handle, file->ucontext);
 	if (!pd) {
@@ -791,7 +780,7 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 
 	uobj->live = 1;
 
-	up_write(&uobj->mutex);
+	up_read(&file->close_sem);
 
 	return in_len;
 
@@ -959,8 +948,8 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 	if (!uobj)
 		return -ENOMEM;
 
-	init_uobj(uobj, 0, file->ucontext, &mw_lock_class);
-	down_write(&uobj->mutex);
+	down_read(&file->close_sem);
+	init_uobj(uobj, 0, file->ucontext);
 
 	pd = idr_read_pd(cmd.pd_handle, file->ucontext);
 	if (!pd) {
@@ -1007,7 +996,7 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 
 	uobj->live = 1;
 
-	up_write(&uobj->mutex);
+	up_read(&file->close_sem);
 
 	return in_len;
 
@@ -1129,8 +1118,8 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 	if (!obj)
 		return ERR_PTR(-ENOMEM);
 
-	init_uobj(&obj->uobject, cmd->user_handle, file->ucontext, &cq_lock_class);
-	down_write(&obj->uobject.mutex);
+	down_read(&file->close_sem);
+	init_uobj(&obj->uobject, cmd->user_handle, file->ucontext);
 
 	if (cmd->comp_channel >= 0) {
 		ev_file = ib_uverbs_lookup_comp_file(cmd->comp_channel);
@@ -1188,7 +1177,7 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 
 	obj->uobject.live = 1;
 
-	up_write(&obj->uobject.mutex);
+	up_read(&file->close_sem);
 
 	return obj;
 
@@ -1530,9 +1519,8 @@ static int create_qp(struct ib_uverbs_file *file,
 	if (!obj)
 		return -ENOMEM;
 
-	init_uobj(&obj->uevent.uobject, cmd->user_handle, file->ucontext,
-		  &qp_lock_class);
-	down_write(&obj->uevent.uobject.mutex);
+	down_read(&file->close_sem);
+	init_uobj(&obj->uevent.uobject, cmd->user_handle, file->ucontext);
 
 	if (cmd->qp_type == IB_QPT_XRC_TGT) {
 		xrcd = idr_read_xrcd(cmd->pd_handle, file->ucontext,
@@ -1692,7 +1680,7 @@ static int create_qp(struct ib_uverbs_file *file,
 
 	obj->uevent.uobject.live = 1;
 
-	up_write(&obj->uevent.uobject.mutex);
+	up_read(&file->close_sem);
 
 	return 0;
 err_cb:
@@ -1853,8 +1841,8 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
 	if (!obj)
 		return -ENOMEM;
 
-	init_uobj(&obj->uevent.uobject, cmd.user_handle, file->ucontext, &qp_lock_class);
-	down_write(&obj->uevent.uobject.mutex);
+	down_read(&file->close_sem);
+	init_uobj(&obj->uevent.uobject, cmd.user_handle, file->ucontext);
 
 	xrcd = idr_read_xrcd(cmd.pd_handle, file->ucontext, &xrcd_uobj);
 	if (!xrcd) {
@@ -1904,7 +1892,7 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
 
 	obj->uevent.uobject.live = 1;
 
-	up_write(&obj->uevent.uobject.mutex);
+	up_read(&file->close_sem);
 
 	return in_len;
 
@@ -2593,8 +2581,8 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	if (!uobj)
 		return -ENOMEM;
 
-	init_uobj(uobj, cmd.user_handle, file->ucontext, &ah_lock_class);
-	down_write(&uobj->mutex);
+	down_read(&file->close_sem);
+	init_uobj(uobj, cmd.user_handle, file->ucontext);
 
 	pd = idr_read_pd(cmd.pd_handle, file->ucontext);
 	if (!pd) {
@@ -2644,7 +2632,7 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 
 	uobj->live = 1;
 
-	up_write(&uobj->mutex);
+	up_read(&file->close_sem);
 
 	return in_len;
 
@@ -2904,8 +2892,8 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 		err = -ENOMEM;
 		goto err_free_attr;
 	}
-	init_uobj(uobj, 0, file->ucontext, &rule_lock_class);
-	down_write(&uobj->mutex);
+	down_read(&file->close_sem);
+	init_uobj(uobj, 0, file->ucontext);
 
 	qp = idr_read_qp(cmd.qp_handle, file->ucontext);
 	if (!qp) {
@@ -2975,7 +2963,7 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 
 	uobj->live = 1;
 
-	up_write(&uobj->mutex);
+	up_read(&file->close_sem);
 	kfree(flow_attr);
 	if (cmd.flow_attr.num_of_specs)
 		kfree(kern_flow_attr);
@@ -3055,8 +3043,8 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	if (!obj)
 		return -ENOMEM;
 
-	init_uobj(&obj->uevent.uobject, cmd->user_handle, file->ucontext, &srq_lock_class);
-	down_write(&obj->uevent.uobject.mutex);
+	down_read(&file->close_sem);
+	init_uobj(&obj->uevent.uobject, cmd->user_handle, file->ucontext);
 
 	if (cmd->srq_type == IB_SRQT_XRC) {
 		attr.ext.xrc.xrcd  = idr_read_xrcd(cmd->xrcd_handle, file->ucontext, &xrcd_uobj);
@@ -3144,7 +3132,7 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 
 	obj->uevent.uobject.live = 1;
 
-	up_write(&obj->uevent.uobject.mutex);
+	up_read(&file->close_sem);
 
 	return 0;
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index e402473..84d72d2 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1356,7 +1356,6 @@ struct ib_uobject {
 	int			id;		/* index into kernel idr */
 	struct kref		ref;
 	atomic_t		usecnt;
-	struct rw_semaphore	mutex;		/* protects .live */
 	struct rcu_head		rcu;		/* kfree_rcu() overhead */
 	int			live;
 	/* List of object under uverbs_object_type */
-- 
2.5.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
