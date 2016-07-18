From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 1/3] iw_cm: free cm_id resources on the last deref
Date: Mon, 18 Jul 2016 13:44:37 -0700
Message-ID: <93c3c47c16406ef00184011948424a9597e4c6b8.1468879135.git.swise@opengridcomputing.com>
References: <cover.1468879135.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1468879135.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Remove the complicated logic to free the cm_id resources in iw_cm event
handlers vs when an application thread destroys the device.  I'm not sure
why this code was written, but simply allowing the last deref to free
the memory is cleaner.  It also prevents a deadlock when applications
try to destroy cm_id's in their cm event handler function.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/core/iwcm.c | 41 ++++++-----------------------------------
 1 file changed, 6 insertions(+), 35 deletions(-)

diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.c
index f057204..20a94ed 100644
--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -183,15 +183,14 @@ static void free_cm_id(struct iwcm_id_private *cm_id_priv)
 
 /*
  * Release a reference on cm_id. If the last reference is being
- * released, enable the waiting thread (in iw_destroy_cm_id) to
- * get woken up, and return 1 if a thread is already waiting.
+ * released, free the cm_id and return 1.
  */
 static int iwcm_deref_id(struct iwcm_id_private *cm_id_priv)
 {
 	BUG_ON(atomic_read(&cm_id_priv->refcount)==0);
 	if (atomic_dec_and_test(&cm_id_priv->refcount)) {
 		BUG_ON(!list_empty(&cm_id_priv->work_list));
-		complete(&cm_id_priv->destroy_comp);
+		free_cm_id(cm_id_priv);
 		return 1;
 	}
 
@@ -208,19 +207,10 @@ static void add_ref(struct iw_cm_id *cm_id)
 static void rem_ref(struct iw_cm_id *cm_id)
 {
 	struct iwcm_id_private *cm_id_priv;
-	int cb_destroy;
 
 	cm_id_priv = container_of(cm_id, struct iwcm_id_private, id);
 
-	/*
-	 * Test bit before deref in case the cm_id gets freed on another
-	 * thread.
-	 */
-	cb_destroy = test_bit(IWCM_F_CALLBACK_DESTROY, &cm_id_priv->flags);
-	if (iwcm_deref_id(cm_id_priv) && cb_destroy) {
-		BUG_ON(!list_empty(&cm_id_priv->work_list));
-		free_cm_id(cm_id_priv);
-	}
+	(void)iwcm_deref_id(cm_id_priv);
 }
 
 static int cm_event_handler(struct iw_cm_id *cm_id, struct iw_cm_event *event);
@@ -433,13 +423,7 @@ void iw_destroy_cm_id(struct iw_cm_id *cm_id)
 	struct iwcm_id_private *cm_id_priv;
 
 	cm_id_priv = container_of(cm_id, struct iwcm_id_private, id);
-	BUG_ON(test_bit(IWCM_F_CALLBACK_DESTROY, &cm_id_priv->flags));
-
 	destroy_cm_id(cm_id);
-
-	wait_for_completion(&cm_id_priv->destroy_comp);
-
-	free_cm_id(cm_id_priv);
 }
 EXPORT_SYMBOL(iw_destroy_cm_id);
 
@@ -809,10 +793,7 @@ static void cm_conn_req_handler(struct iwcm_id_private *listen_id_priv,
 	ret = cm_id->cm_handler(cm_id, iw_event);
 	if (ret) {
 		iw_cm_reject(cm_id, NULL, 0);
-		set_bit(IWCM_F_CALLBACK_DESTROY, &cm_id_priv->flags);
-		destroy_cm_id(cm_id);
-		if (atomic_read(&cm_id_priv->refcount)==0)
-			free_cm_id(cm_id_priv);
+		iw_destroy_cm_id(cm_id);
 	}
 
 out:
@@ -1000,7 +981,6 @@ static void cm_work_handler(struct work_struct *_work)
 	unsigned long flags;
 	int empty;
 	int ret = 0;
-	int destroy_id;
 
 	spin_lock_irqsave(&cm_id_priv->lock, flags);
 	empty = list_empty(&cm_id_priv->work_list);
@@ -1014,19 +994,10 @@ static void cm_work_handler(struct work_struct *_work)
 		spin_unlock_irqrestore(&cm_id_priv->lock, flags);
 
 		ret = process_event(cm_id_priv, &levent);
-		if (ret) {
-			set_bit(IWCM_F_CALLBACK_DESTROY, &cm_id_priv->flags);
+		if (ret)
 			destroy_cm_id(&cm_id_priv->id);
-		}
-		BUG_ON(atomic_read(&cm_id_priv->refcount)==0);
-		destroy_id = test_bit(IWCM_F_CALLBACK_DESTROY, &cm_id_priv->flags);
-		if (iwcm_deref_id(cm_id_priv)) {
-			if (destroy_id) {
-				BUG_ON(!list_empty(&cm_id_priv->work_list));
-				free_cm_id(cm_id_priv);
-			}
+		if (iwcm_deref_id(cm_id_priv))
 			return;
-		}
 		if (empty)
 			return;
 		spin_lock_irqsave(&cm_id_priv->lock, flags);
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
