From: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 07/11] RDMA/nes: Xansation test crash on cm_node ref_count
Date: Wed, 9 Dec 2009 16:41:43 -0600
Message-ID: <20091209224143.GA127092@flatif-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Running Xansation test, active side node crashed.
The problem started from passive side. It generated stag which was
0. The passive side sent TERMINATE instead of MPA REJECT msg. On the
active side, it receives TERMINATE and sends connect_err() and set the
cm_node state to CLOSED. The passive side sends FIN + ACK after TERMINATE.
Active side in handle_ack_pkt() and send_reset(). send_reset()
consumes 1 cm_node's ref_count. Because the cm_node is in CLOSED state, which
means that cm_node will be destroyed after completion of the connect_err()
indication, cm will crash after send_reset().

Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_cm.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 20e21f1..a258168 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -1610,6 +1610,7 @@ static void handle_syn_pkt(struct nes_cm_node *cm_node, struct sk_buff *skb,
 		break;
 	case NES_CM_STATE_CLOSED:
 		cleanup_retrans_entry(cm_node);
+		add_ref_cm_node(cm_node);
 		send_reset(cm_node, skb);
 		break;
 	case NES_CM_STATE_TSA:
@@ -1661,9 +1662,15 @@ static void handle_synack_pkt(struct nes_cm_node *cm_node, struct sk_buff *skb,
 		passive_open_err(cm_node, skb, 1);
 		break;
 	case NES_CM_STATE_LISTENING:
+		cm_node->tcp_cntxt.loc_seq_num = ntohl(tcph->ack_seq);
+		cleanup_retrans_entry(cm_node);
+		cm_node->state = NES_CM_STATE_CLOSED;
+		send_reset(cm_node, skb);
+		break;
 	case NES_CM_STATE_CLOSED:
 		cm_node->tcp_cntxt.loc_seq_num = ntohl(tcph->ack_seq);
 		cleanup_retrans_entry(cm_node);
+		add_ref_cm_node(cm_node);
 		send_reset(cm_node, skb);
 		break;
 	case NES_CM_STATE_ESTABLISHED:
@@ -1732,8 +1739,13 @@ static int handle_ack_pkt(struct nes_cm_node *cm_node, struct sk_buff *skb,
 			dev_kfree_skb_any(skb);
 		break;
 	case NES_CM_STATE_LISTENING:
+		cleanup_retrans_entry(cm_node);
+		cm_node->state = NES_CM_STATE_CLOSED;
+		send_reset(cm_node, skb);
+		break;
 	case NES_CM_STATE_CLOSED:
 		cleanup_retrans_entry(cm_node);
+		add_ref_cm_node(cm_node);
 		send_reset(cm_node, skb);
 		break;
 	case NES_CM_STATE_LAST_ACK:
@@ -2193,8 +2205,11 @@ static int mini_cm_close(struct nes_cm_core *cm_core, struct nes_cm_node *cm_nod
 	case NES_CM_STATE_CLOSING:
 		ret = -1;
 		break;
-	case NES_CM_STATE_MPAREJ_RCVD:
 	case NES_CM_STATE_LISTENING:
+		cleanup_retrans_entry(cm_node);
+		send_reset(cm_node, NULL);
+		break;
+	case NES_CM_STATE_MPAREJ_RCVD:
 	case NES_CM_STATE_UNKNOWN:
 	case NES_CM_STATE_INITED:
 	case NES_CM_STATE_CLOSED:
-- 
1.5.3.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
