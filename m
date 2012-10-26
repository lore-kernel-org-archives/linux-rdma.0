From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 04/19] ib_srp: Suppress superfluous error messages
Date: Fri, 26 Oct 2012 14:47:45 +0200
Message-ID: <508A8671.8030507@acm.org>
References: <508A85BB.1000505@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <508A85BB.1000505-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Keep track of the connection state. Only report QP errors while
connected. Only invoke ib_send_cm_dreq() when connected such that
invoking srp_disconnect_target() after having received a DREQ
does not cause an error message to be printed.

Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   43 +++++++++++++++++++++++++++--------
 drivers/infiniband/ulp/srp/ib_srp.h |    1 +
 2 files changed, 35 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 87f0bfd..01b6cd7 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -428,17 +428,34 @@ static int srp_send_req(struct srp_target_port *target)
 	return status;
 }
 
+static bool srp_change_conn_state(struct srp_target_port *target,
+				  bool connected)
+{
+	bool changed = false;
+
+	spin_lock_irq(&target->lock);
+	if (target->connected != connected) {
+		target->connected = connected;
+		changed = true;
+	}
+	spin_unlock_irq(&target->lock);
+
+	return changed;
+}
+
 static void srp_disconnect_target(struct srp_target_port *target)
 {
-	/* XXX should send SRP_I_LOGOUT request */
+	if (srp_change_conn_state(target, false)) {
+		/* XXX should send SRP_I_LOGOUT request */
 
-	init_completion(&target->done);
-	if (ib_send_cm_dreq(target->cm_id, NULL, 0)) {
-		shost_printk(KERN_DEBUG, target->scsi_host,
-			     PFX "Sending CM DREQ failed\n");
-		return;
+		init_completion(&target->done);
+		if (ib_send_cm_dreq(target->cm_id, NULL, 0)) {
+			shost_printk(KERN_DEBUG, target->scsi_host,
+				     PFX "Sending CM DREQ failed\n");
+		} else {
+			wait_for_completion(&target->done);
+		}
 	}
-	wait_for_completion(&target->done);
 }
 
 static bool srp_change_state(struct srp_target_port *target,
@@ -515,6 +532,8 @@ static int srp_connect_target(struct srp_target_port *target)
 	int retries = 3;
 	int ret;
 
+	WARN_ON(target->connected);
+
 	target->qp_in_error = false;
 
 	ret = srp_lookup_path(target);
@@ -536,6 +555,7 @@ static int srp_connect_target(struct srp_target_port *target)
 		 */
 		switch (target->status) {
 		case 0:
+			srp_change_conn_state(target, true);
 			return 0;
 
 		case SRP_PORT_REDIRECT:
@@ -1273,8 +1293,11 @@ static void srp_handle_qp_err(enum ib_wc_status wc_status,
 			      enum ib_wc_opcode wc_opcode,
 			      struct srp_target_port *target)
 {
-	shost_printk(KERN_ERR, target->scsi_host, PFX "failed %s status %d\n",
-		     wc_opcode & IB_WC_RECV ? "receive" : "send", wc_status);
+	if (target->connected)
+		shost_printk(KERN_ERR, target->scsi_host,
+			     PFX "failed %s status %d\n",
+			     wc_opcode & IB_WC_RECV ? "receive" : "send",
+			     wc_status);
 	target->qp_in_error = true;
 }
 
@@ -1634,6 +1657,7 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 	case IB_CM_DREQ_RECEIVED:
 		shost_printk(KERN_WARNING, target->scsi_host,
 			     PFX "DREQ received - connection closed\n");
+		srp_change_conn_state(target, false);
 		if (ib_send_cm_drep(cm_id, NULL, 0))
 			shost_printk(KERN_ERR, target->scsi_host,
 				     PFX "Sending CM DREP failed\n");
@@ -1950,6 +1974,7 @@ static int srp_add_target(struct srp_host *host, struct srp_target_port *target)
 	spin_unlock(&host->target_lock);
 
 	target->state = SRP_TARGET_LIVE;
+	target->connected = false;
 
 	scsi_scan_target(&target->scsi_host->shost_gendev,
 			 0, target->scsi_id, SCAN_WILD_CARD, 0);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 02dc3ac..ef95fa4 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -163,6 +163,7 @@ struct srp_target_port {
 	int			path_query_id;
 
 	u32			rq_tmo_jiffies;
+	bool			connected;
 
 	struct ib_cm_id	       *cm_id;
 
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
