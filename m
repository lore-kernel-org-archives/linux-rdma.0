From: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDMA/nes: double CLOSE event indication crash
Date: Sat, 14 Aug 2010 16:04:56 -0500
Message-ID: <20100814210456.GA7116@FLATIF-MOBL3>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

During a stress testing in a large cluster, multiple close event is detected
and BUG() is hit in core. The cause is that active node gave up while waitings
for MPA response from the peer and tried to close the connection by sending RST.
The passive node driver receives the RST but is waiting for MPA response from
user. When MPA accept is receives, the driver send offloads the connection and
sends CLOSE event. The driver get an AE indicating RESET receive and also send
CLOSE event causing BUG() to hit in the core. RESET handling and sending CLOSE
events are fixed.

Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_cm.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 986d6f3..10e4bde 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -502,7 +502,9 @@ int schedule_nes_timer(struct nes_cm_node *cm_node, struct sk_buff *skb,
 static void nes_retrans_expired(struct nes_cm_node *cm_node)
 {
 	struct iw_cm_id *cm_id = cm_node->cm_id;
-	switch (cm_node->state) {
+	enum nes_cm_node_state    state = cm_node->state;
+	cm_node->state = NES_CM_STATE_CLOSED;
+	switch (state) {
 	case NES_CM_STATE_SYN_RCVD:
 	case NES_CM_STATE_CLOSING:
 		rem_ref_cm_node(cm_node->cm_core, cm_node);
@@ -511,7 +513,6 @@ static void nes_retrans_expired(struct nes_cm_node *cm_node)
 	case NES_CM_STATE_FIN_WAIT1:
 		if (cm_node->cm_id)
 			cm_id->rem_ref(cm_id);
-		cm_node->state = NES_CM_STATE_CLOSED;
 		send_reset(cm_node, NULL);
 		break;
 	default:
@@ -1439,9 +1440,6 @@ static void handle_rst_pkt(struct nes_cm_node *cm_node, struct sk_buff *skb,
 		break;
 	case NES_CM_STATE_MPAREQ_RCVD:
 		passive_state = atomic_add_return(1, &cm_node->passive_state);
-		if (passive_state ==  NES_SEND_RESET_EVENT)
-			create_event(cm_node, NES_CM_EVENT_RESET);
-		cm_node->state = NES_CM_STATE_CLOSED;
 		dev_kfree_skb_any(skb);
 		break;
 	case NES_CM_STATE_ESTABLISHED:
@@ -1456,6 +1454,7 @@ static void handle_rst_pkt(struct nes_cm_node *cm_node, struct sk_buff *skb,
 	case NES_CM_STATE_CLOSED:
 		drop_packet(skb);
 		break;
+	case NES_CM_STATE_FIN_WAIT2:
 	case NES_CM_STATE_FIN_WAIT1:
 	case NES_CM_STATE_LAST_ACK:
 		cm_node->cm_id->rem_ref(cm_node->cm_id);
@@ -2781,6 +2780,12 @@ int nes_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 		return -EINVAL;
 	}
 
+	passive_state = atomic_add_return(1, &cm_node->passive_state);
+	if (passive_state == NES_SEND_RESET_EVENT) {
+		rem_ref_cm_node(cm_node->cm_core, cm_node);
+		return -ECONNRESET;
+	}
+
 	/* associate the node with the QP */
 	nesqp->cm_node = (void *)cm_node;
 	cm_node->nesqp = nesqp;
@@ -2983,9 +2988,6 @@ int nes_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 		printk(KERN_ERR "%s[%u] OFA CM event_handler returned, "
 			"ret=%d\n", __func__, __LINE__, ret);
 
-	passive_state = atomic_add_return(1, &cm_node->passive_state);
-	if (passive_state == NES_SEND_RESET_EVENT)
-		create_event(cm_node, NES_CM_EVENT_RESET);
 	return 0;
 }
 
-- 
1.6.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
