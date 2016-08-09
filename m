From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC ABI V3 5/7] RDMA/core: Add initialize and cleanup of common types
Date: Tue,  9 Aug 2016 19:39:33 +0300
Message-ID: <1470760775-6813-6-git-send-email-matanb@mellanox.com>
References: <1470760775-6813-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1470760775-6813-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The new ABI infrastructure introduced types per driver. Since current
drivers use common types, we mimics the current release ucontext
process using the new process.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h           |   9 ++-
 drivers/infiniband/core/uverbs_ioctl_cmd.c |  91 +++++++++++++++++++++++++
 drivers/infiniband/core/uverbs_main.c      | 102 ++---------------------------
 include/rdma/uverbs_ioctl_cmd.h            |  33 ++++++++++
 4 files changed, 136 insertions(+), 99 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 86be861..b65a865 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -174,8 +174,6 @@ struct ib_ucq_object {
 	u32			async_events_reported;
 };
 
-void idr_remove_uobj(struct ib_uobject *uobj);
-
 struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
 					struct ib_device *ib_dev,
 					int is_async);
@@ -197,6 +195,13 @@ void ib_uverbs_event_handler(struct ib_event_handler *handler,
 void ib_uverbs_dealloc_xrcd(struct ib_uverbs_device *dev, struct ib_xrcd *xrcd);
 
 int uverbs_dealloc_mw(struct ib_mw *mw);
+void ib_uverbs_release_ucq(struct ib_uverbs_file *file,
+			   struct ib_uverbs_event_file *ev_file,
+			   struct ib_ucq_object *uobj);
+void ib_uverbs_release_uevent(struct ib_uverbs_file *file,
+			      struct ib_uevent_object *uobj);
+void ib_uverbs_detach_umcast(struct ib_qp *qp,
+			     struct ib_uqp_object *uobj);
 
 struct ib_uverbs_flow_spec {
 	union {
diff --git a/drivers/infiniband/core/uverbs_ioctl_cmd.c b/drivers/infiniband/core/uverbs_ioctl_cmd.c
index ce68cfc..af93569 100644
--- a/drivers/infiniband/core/uverbs_ioctl_cmd.c
+++ b/drivers/infiniband/core/uverbs_ioctl_cmd.c
@@ -31,8 +31,11 @@
  */
 
 #include <rdma/uverbs_ioctl_cmd.h>
+#include <rdma/ib_user_verbs.h>
 #include <rdma/ib_verbs.h>
 #include <linux/bug.h>
+#include <linux/file.h>
+#include "rdma_core.h"
 #include "uverbs.h"
 
 #define IB_UVERBS_VENDOR_FLAG	0x8000
@@ -76,3 +79,91 @@ int uverbs_action_std_ctx_handle(struct ib_device *ib_dev,
 }
 EXPORT_SYMBOL(uverbs_action_std_ctx_handle);
 
+void uverbs_free_ah(const struct uverbs_type_alloc_action *uobject_type,
+		    struct ib_uobject *uobject)
+{
+	ib_destroy_ah((struct ib_ah *)uobject->object);
+}
+EXPORT_SYMBOL(uverbs_free_ah);
+
+void uverbs_free_flow(const struct uverbs_type_alloc_action *type_alloc_action,
+		      struct ib_uobject *uobject)
+{
+	ib_destroy_flow((struct ib_flow *)uobject->object);
+}
+EXPORT_SYMBOL(uverbs_free_flow);
+
+void uverbs_free_mw(const struct uverbs_type_alloc_action *type_alloc_action,
+		    struct ib_uobject *uobject)
+{
+	uverbs_dealloc_mw((struct ib_mw *)uobject->object);
+}
+EXPORT_SYMBOL(uverbs_free_mw);
+
+void uverbs_free_qp(const struct uverbs_type_alloc_action *type_alloc_action,
+		    struct ib_uobject *uobject)
+{
+	struct ib_qp *qp = uobject->object;
+	struct ib_uqp_object *uqp =
+		container_of(uobject, struct ib_uqp_object, uevent.uobject);
+
+	if (qp != qp->real_qp) {
+		ib_close_qp(qp);
+	} else {
+		ib_uverbs_detach_umcast(qp, uqp);
+		ib_destroy_qp(qp);
+	}
+	ib_uverbs_release_uevent(uobject->context->ufile, &uqp->uevent);
+}
+EXPORT_SYMBOL(uverbs_free_qp);
+
+void uverbs_free_srq(const struct uverbs_type_alloc_action *type_alloc_action,
+		     struct ib_uobject *uobject)
+{
+	struct ib_srq *srq = uobject->object;
+	struct ib_uevent_object *uevent =
+		container_of(uobject, struct ib_uevent_object, uobject);
+
+	ib_destroy_srq(srq);
+	ib_uverbs_release_uevent(uobject->context->ufile, uevent);
+}
+EXPORT_SYMBOL(uverbs_free_srq);
+
+void uverbs_free_cq(const struct uverbs_type_alloc_action *type_alloc_action,
+		    struct ib_uobject *uobject)
+{
+	struct ib_cq *cq = uobject->object;
+	struct ib_uverbs_event_file *ev_file = cq->cq_context;
+	struct ib_ucq_object *ucq =
+		container_of(uobject, struct ib_ucq_object, uobject);
+
+	ib_destroy_cq(cq);
+	ib_uverbs_release_ucq(uobject->context->ufile, ev_file, ucq);
+}
+EXPORT_SYMBOL(uverbs_free_cq);
+
+void uverbs_free_mr(const struct uverbs_type_alloc_action *type_alloc_action,
+		    struct ib_uobject *uobject)
+{
+	ib_dereg_mr((struct ib_mr *)uobject->object);
+}
+EXPORT_SYMBOL(uverbs_free_mr);
+
+void uverbs_free_xrcd(const struct uverbs_type_alloc_action *type_alloc_action,
+		      struct ib_uobject *uobject)
+{
+	struct ib_xrcd *xrcd = uobject->object;
+
+	mutex_lock(&uobject->context->ufile->device->xrcd_tree_mutex);
+	ib_uverbs_dealloc_xrcd(uobject->context->ufile->device, xrcd);
+	mutex_unlock(&uobject->context->ufile->device->xrcd_tree_mutex);
+}
+EXPORT_SYMBOL(uverbs_free_xrcd);
+
+void uverbs_free_pd(const struct uverbs_type_alloc_action *type_alloc_action,
+		    struct ib_uobject *uobject)
+{
+	ib_dealloc_pd((struct ib_pd *)uobject->object);
+}
+EXPORT_SYMBOL(uverbs_free_pd);
+
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index fa51568..4fd35ca 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -52,6 +52,7 @@
 #include <rdma/rdma_ioctl.h>
 
 #include "uverbs.h"
+#include "rdma_core.h"
 
 MODULE_AUTHOR("Roland Dreier");
 MODULE_DESCRIPTION("InfiniBand userspace verbs access");
@@ -195,8 +196,8 @@ void ib_uverbs_release_uevent(struct ib_uverbs_file *file,
 	spin_unlock_irq(&file->async_file->lock);
 }
 
-static void ib_uverbs_detach_umcast(struct ib_qp *qp,
-				    struct ib_uqp_object *uobj)
+void ib_uverbs_detach_umcast(struct ib_qp *qp,
+			     struct ib_uqp_object *uobj)
 {
 	struct ib_uverbs_mcast_entry *mcast, *tmp;
 
@@ -210,103 +211,10 @@ static void ib_uverbs_detach_umcast(struct ib_qp *qp,
 static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 				      struct ib_ucontext *context)
 {
-	struct ib_uobject *uobj, *tmp;
-
 	down_write(&file->close_sem);
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
+						context->device->types_group);
 	put_pid(context->tgid);
 	up_write(&file->close_sem);
 
diff --git a/include/rdma/uverbs_ioctl_cmd.h b/include/rdma/uverbs_ioctl_cmd.h
index 19806df..083d805 100644
--- a/include/rdma/uverbs_ioctl_cmd.h
+++ b/include/rdma/uverbs_ioctl_cmd.h
@@ -64,5 +64,38 @@ struct uverbs_action_std_ctx_handler {
 	void *priv;
 };
 
+void uverbs_free_ah(const struct uverbs_type_alloc_action *type_alloc_action,
+		    struct ib_uobject *uobject);
+void uverbs_free_flow(const struct uverbs_type_alloc_action *type_alloc_action,
+		      struct ib_uobject *uobject);
+void uverbs_free_mw(const struct uverbs_type_alloc_action *type_alloc_action,
+		    struct ib_uobject *uobject);
+void uverbs_free_qp(const struct uverbs_type_alloc_action *type_alloc_action,
+		    struct ib_uobject *uobject);
+void uverbs_free_srq(const struct uverbs_type_alloc_action *type_alloc_action,
+		     struct ib_uobject *uobject);
+void uverbs_free_cq(const struct uverbs_type_alloc_action *type_alloc_action,
+		    struct ib_uobject *uobject);
+void uverbs_free_mr(const struct uverbs_type_alloc_action *type_alloc_action,
+		    struct ib_uobject *uobject);
+void uverbs_free_xrcd(const struct uverbs_type_alloc_action *type_alloc_action,
+		      struct ib_uobject *uobject);
+void uverbs_free_pd(const struct uverbs_type_alloc_action *type_alloc_action,
+		    struct ib_uobject *uobject);
+
+enum uverbs_common_types {
+	UVERBS_TYPE_DEVICE, /* Don't use IDRs here */
+	UVERBS_TYPE_PD,
+	UVERBS_TYPE_CQ,
+	UVERBS_TYPE_QP,
+	UVERBS_TYPE_SRQ,
+	UVERBS_TYPE_AH,
+	UVERBS_TYPE_MR,
+	UVERBS_TYPE_MW,
+	UVERBS_TYPE_FLOW,
+	UVERBS_TYPE_XRCD,
+	UVERBS_TYPE_LAST,
+};
+
 #endif
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
