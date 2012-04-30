From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/2] IB/uverbs: Make lockdep output more readable
Date: Mon, 30 Apr 2012 12:57:37 -0700
Message-ID: <1335815858-27833-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

Add names for our lockdep classes, so instead of having to decipher
lockdep output with mysterious names:

    Chain exists of:
      key#14 --> key#11 --> key#13

lockdep will give us something nicer:

    Chain exists of:
      SRQ-uobj --> PD-uobj --> CQ-uobj

Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c |   39 +++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 4d27e4c..85231e2 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -41,13 +41,18 @@
 
 #include "uverbs.h"
 
-static struct lock_class_key pd_lock_key;
-static struct lock_class_key mr_lock_key;
-static struct lock_class_key cq_lock_key;
-static struct lock_class_key qp_lock_key;
-static struct lock_class_key ah_lock_key;
-static struct lock_class_key srq_lock_key;
-static struct lock_class_key xrcd_lock_key;
+struct uverbs_lock_class {
+	struct lock_class_key	key;
+	char			name[16];
+};
+
+static struct uverbs_lock_class pd_lock_class	= { .name = "PD-uobj" };
+static struct uverbs_lock_class mr_lock_class	= { .name = "MR-uobj" };
+static struct uverbs_lock_class cq_lock_class	= { .name = "CQ-uobj" };
+static struct uverbs_lock_class qp_lock_class	= { .name = "QP-uobj" };
+static struct uverbs_lock_class ah_lock_class	= { .name = "AH-uobj" };
+static struct uverbs_lock_class srq_lock_class	= { .name = "SRQ-uobj" };
+static struct uverbs_lock_class xrcd_lock_class = { .name = "XRCD-uobj" };
 
 #define INIT_UDATA(udata, ibuf, obuf, ilen, olen)			\
 	do {								\
@@ -83,13 +88,13 @@ static struct lock_class_key xrcd_lock_key;
  */
 
 static void init_uobj(struct ib_uobject *uobj, u64 user_handle,
-		      struct ib_ucontext *context, struct lock_class_key *key)
+		      struct ib_ucontext *context, struct uverbs_lock_class *c)
 {
 	uobj->user_handle = user_handle;
 	uobj->context     = context;
 	kref_init(&uobj->ref);
 	init_rwsem(&uobj->mutex);
-	lockdep_set_class(&uobj->mutex, key);
+	lockdep_set_class_and_name(&uobj->mutex, &c->key, c->name);
 	uobj->live        = 0;
 }
 
@@ -522,7 +527,7 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 	if (!uobj)
 		return -ENOMEM;
 
-	init_uobj(uobj, 0, file->ucontext, &pd_lock_key);
+	init_uobj(uobj, 0, file->ucontext, &pd_lock_class);
 	down_write(&uobj->mutex);
 
 	pd = file->device->ib_dev->alloc_pd(file->device->ib_dev,
@@ -750,7 +755,7 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 		goto err_tree_mutex_unlock;
 	}
 
-	init_uobj(&obj->uobject, 0, file->ucontext, &xrcd_lock_key);
+	init_uobj(&obj->uobject, 0, file->ucontext, &xrcd_lock_class);
 
 	down_write(&obj->uobject.mutex);
 
@@ -947,7 +952,7 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 	if (!uobj)
 		return -ENOMEM;
 
-	init_uobj(uobj, 0, file->ucontext, &mr_lock_key);
+	init_uobj(uobj, 0, file->ucontext, &mr_lock_class);
 	down_write(&uobj->mutex);
 
 	pd = idr_read_pd(cmd.pd_handle, file->ucontext);
@@ -1115,7 +1120,7 @@ ssize_t ib_uverbs_create_cq(struct ib_uverbs_file *file,
 	if (!obj)
 		return -ENOMEM;
 
-	init_uobj(&obj->uobject, cmd.user_handle, file->ucontext, &cq_lock_key);
+	init_uobj(&obj->uobject, cmd.user_handle, file->ucontext, &cq_lock_class);
 	down_write(&obj->uobject.mutex);
 
 	if (cmd.comp_channel >= 0) {
@@ -1407,7 +1412,7 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 	if (!obj)
 		return -ENOMEM;
 
-	init_uobj(&obj->uevent.uobject, cmd.user_handle, file->ucontext, &qp_lock_key);
+	init_uobj(&obj->uevent.uobject, cmd.user_handle, file->ucontext, &qp_lock_class);
 	down_write(&obj->uevent.uobject.mutex);
 
 	if (cmd.qp_type == IB_QPT_XRC_TGT) {
@@ -1585,7 +1590,7 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
 	if (!obj)
 		return -ENOMEM;
 
-	init_uobj(&obj->uevent.uobject, cmd.user_handle, file->ucontext, &qp_lock_key);
+	init_uobj(&obj->uevent.uobject, cmd.user_handle, file->ucontext, &qp_lock_class);
 	down_write(&obj->uevent.uobject.mutex);
 
 	xrcd = idr_read_xrcd(cmd.pd_handle, file->ucontext, &xrcd_uobj);
@@ -2272,7 +2277,7 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	if (!uobj)
 		return -ENOMEM;
 
-	init_uobj(uobj, cmd.user_handle, file->ucontext, &ah_lock_key);
+	init_uobj(uobj, cmd.user_handle, file->ucontext, &ah_lock_class);
 	down_write(&uobj->mutex);
 
 	pd = idr_read_pd(cmd.pd_handle, file->ucontext);
@@ -2476,7 +2481,7 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	if (!obj)
 		return -ENOMEM;
 
-	init_uobj(&obj->uevent.uobject, cmd->user_handle, file->ucontext, &srq_lock_key);
+	init_uobj(&obj->uevent.uobject, cmd->user_handle, file->ucontext, &srq_lock_class);
 	down_write(&obj->uevent.uobject.mutex);
 
 	pd  = idr_read_pd(cmd->pd_handle, file->ucontext);
-- 
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
