From: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDMA/nes: change state to closing after FIN
Date: Sat, 14 Aug 2010 16:05:04 -0500
Message-ID: <20100814210504.GA5300@FLATIF-MOBL3>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When driver receives an AE for FIN receive indication, it closes the connection
without changing the state of the connection in the hardware to closing. By
changing the state to closing, hardware will do normal close sequence.

Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_hw.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index 679dd01..a63934c 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -3469,8 +3469,19 @@ static void nes_process_iwarp_aeqe(struct nes_device *nesdev,
 		case NES_AEQE_AEID_LLP_FIN_RECEIVED:
 			if (nesqp->term_flags)
 				return; /* Ignore it, wait for close complete */
-
 			if (atomic_inc_return(&nesqp->close_timer_started) == 1) {
+				if ((tcp_state == NES_AEQE_TCP_STATE_CLOSE_WAIT) &&
+					(nesqp->ibqp_state == IB_QPS_RTS)) {
+					spin_lock_irqsave(&nesqp->lock, flags);
+					nesqp->hw_iwarp_state = iwarp_state;
+					nesqp->hw_tcp_state = tcp_state;
+					nesqp->last_aeq = async_event_id;
+					next_iwarp_state = NES_CQP_QP_IWARP_STATE_CLOSING;
+					nesqp->hw_iwarp_state = NES_AEQE_IWARP_STATE_CLOSING;
+					spin_unlock_irqrestore(&nesqp->lock, flags);
+					nes_hw_modify_qp(nesdev, nesqp, next_iwarp_state, 0, 0);
+					nes_cm_disconn(nesqp);
+				}
 				nesqp->cm_id->add_ref(nesqp->cm_id);
 				schedule_nes_timer(nesqp->cm_node, (struct sk_buff *)nesqp,
 						NES_TIMER_TYPE_CLOSE, 1, 0);
@@ -3480,7 +3491,6 @@ static void nes_process_iwarp_aeqe(struct nes_device *nesdev,
 						nesqp->hwqp.qp_id, atomic_read(&nesqp->refcount),
 						async_event_id, nesqp->last_aeq, tcp_state);
 			}
-
 			break;
 		case NES_AEQE_AEID_LLP_CLOSE_COMPLETE:
 			if (nesqp->term_flags) {
-- 
1.6.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
