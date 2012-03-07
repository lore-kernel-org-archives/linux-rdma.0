From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH v3] iw_cm: reject connect requests if cmid is not in LISTEN
Date: Wed, 07 Mar 2012 16:48:11 -0600
Message-ID: <20120307224809.7641.13115.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When destroying a listening cmid, the iwcm first marks the state of
the cmid as DESTROYING, then releases the lock and calls into the
iwarp provider to destroy the endpoint.  Since the cmid is not locked,
its possible for the iwarp provider to pass a connection request event
to the iwcm, which will be silently dropped by the iwcm.  This causes
the iwarp provider to never free up the resources from this connection
because the assumption is the iwcm will accept or reject this connection.

The solution is to reject these connection requests.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/core/iwcm.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.c
index 1a696f7..0bb99bb 100644
--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -624,17 +624,6 @@ static void cm_conn_req_handler(struct iwcm_id_private *listen_id_priv,
 	 */
 	BUG_ON(iw_event->status);
 
-	/*
-	 * We could be destroying the listening id. If so, ignore this
-	 * upcall.
-	 */
-	spin_lock_irqsave(&listen_id_priv->lock, flags);
-	if (listen_id_priv->state != IW_CM_STATE_LISTEN) {
-		spin_unlock_irqrestore(&listen_id_priv->lock, flags);
-		goto out;
-	}
-	spin_unlock_irqrestore(&listen_id_priv->lock, flags);
-
 	cm_id = iw_create_cm_id(listen_id_priv->id.device,
 				listen_id_priv->id.cm_handler,
 				listen_id_priv->id.context);
@@ -649,6 +638,19 @@ static void cm_conn_req_handler(struct iwcm_id_private *listen_id_priv,
 	cm_id_priv = container_of(cm_id, struct iwcm_id_private, id);
 	cm_id_priv->state = IW_CM_STATE_CONN_RECV;
 
+	/*
+	 * We could be destroying the listening id. If so, ignore this
+	 * upcall.
+	 */
+	spin_lock_irqsave(&listen_id_priv->lock, flags);
+	if (listen_id_priv->state != IW_CM_STATE_LISTEN) {
+		spin_unlock_irqrestore(&listen_id_priv->lock, flags);
+		iw_cm_reject(cm_id, NULL, 0);
+		iw_destroy_cm_id(cm_id);
+		goto out;
+	}
+	spin_unlock_irqrestore(&listen_id_priv->lock, flags);
+
 	ret = alloc_work_entries(cm_id_priv, 3);
 	if (ret) {
 		iw_cm_reject(cm_id, NULL, 0);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
