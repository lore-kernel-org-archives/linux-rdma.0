From: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 10/11] RDMA/nes: FIN during MPA startup causes timeout
Date: Wed, 9 Dec 2009 16:43:22 -0600
Message-ID: <20091209224322.GA127304@flatif-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

A FIN that is received during an MPA start up sequence causes a timeout in
iwcm.c.  The connection has not been completely closed so the iwcm code is
waiting for resources to be cleaned up.  This closes the connection so
everything cleans up correctly.

Signed-off-by: Don Wood <donald.e.wood-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_cm.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index b139806..4acf04a 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -1354,13 +1354,20 @@ static void handle_fin_pkt(struct nes_cm_node *cm_node)
 	case NES_CM_STATE_SYN_RCVD:
 	case NES_CM_STATE_SYN_SENT:
 	case NES_CM_STATE_ESTABLISHED:
-	case NES_CM_STATE_MPAREQ_SENT:
 	case NES_CM_STATE_MPAREJ_RCVD:
 		cm_node->tcp_cntxt.rcv_nxt++;
 		cleanup_retrans_entry(cm_node);
 		cm_node->state = NES_CM_STATE_LAST_ACK;
 		send_fin(cm_node, NULL);
 		break;
+	case NES_CM_STATE_MPAREQ_SENT:
+		create_event(cm_node, NES_CM_EVENT_ABORTED);
+		cm_node->tcp_cntxt.rcv_nxt++;
+		cleanup_retrans_entry(cm_node);
+		cm_node->state = NES_CM_STATE_CLOSED;
+		add_ref_cm_node(cm_node);
+		send_reset(cm_node, NULL);
+		break;
 	case NES_CM_STATE_FIN_WAIT1:
 		cm_node->tcp_cntxt.rcv_nxt++;
 		cleanup_retrans_entry(cm_node);
-- 
1.5.3.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
