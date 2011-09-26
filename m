From: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/3] RDMA/nes: Fix terminate connection
Date: Sun, 25 Sep 2011 20:27:52 -0500
Message-ID: <20110926012752.GA2204@FLATIF-MOBL4>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fixes a crash that occurs during close when error async event is received.
Terminate message is not sent to the remote node if already processing close.

Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Faisal Latif <Faisal.Latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_hw.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index 08c1948..da2548d 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -3559,9 +3559,9 @@ static void nes_process_iwarp_aeqe(struct nes_device *nesdev,
 
 	aeqe_cq_id = le32_to_cpu(aeqe->aeqe_words[NES_AEQE_COMP_QP_CQ_ID_IDX]);
 	if (aeq_info & NES_AEQE_QP) {
-		if ((!nes_is_resource_allocated(nesadapter, nesadapter->allocated_qps,
-				aeqe_cq_id)) ||
-				(atomic_read(&nesqp->close_timer_started)))
+		if (!nes_is_resource_allocated(nesadapter,
+				nesadapter->allocated_qps,
+				aeqe_cq_id))
 			return;
 	}
 
@@ -3572,8 +3572,7 @@ static void nes_process_iwarp_aeqe(struct nes_device *nesdev,
 
 			if (atomic_inc_return(&nesqp->close_timer_started) == 1) {
 				if ((tcp_state == NES_AEQE_TCP_STATE_CLOSE_WAIT) &&
-					(nesqp->ibqp_state == IB_QPS_RTS) &&
-					((nesadapter->eeprom_version >> 16) != NES_A0)) {
+					(nesqp->ibqp_state == IB_QPS_RTS)) {
 					spin_lock_irqsave(&nesqp->lock, flags);
 					nesqp->hw_iwarp_state = iwarp_state;
 					nesqp->hw_tcp_state = tcp_state;
@@ -3600,9 +3599,10 @@ static void nes_process_iwarp_aeqe(struct nes_device *nesdev,
 				return;
 			}
 			spin_lock_irqsave(&nesqp->lock, flags);
-			nesqp->hw_iwarp_state = NES_AEQE_IWARP_STATE_CLOSING;
+			nesqp->hw_iwarp_state = iwarp_state;
+			nesqp->hw_tcp_state = tcp_state;
+			nesqp->last_aeq = async_event_id;
 			spin_unlock_irqrestore(&nesqp->lock, flags);
-			nes_hw_modify_qp(nesdev, nesqp, NES_CQP_QP_IWARP_STATE_CLOSING, 0, 0);
 			nes_cm_disconn(nesqp);
 			break;
 
@@ -3700,7 +3700,9 @@ static void nes_process_iwarp_aeqe(struct nes_device *nesdev,
 		case NES_AEQE_AEID_ROE_INVALID_RDMA_WRITE_OR_READ_RESP:
 			printk(KERN_ERR PFX "QP[%u] async_event_id=0x%04X IB_EVENT_QP_FATAL\n",
 					nesqp->hwqp.qp_id, async_event_id);
-			nes_terminate_connection(nesdev, nesqp, aeqe, IB_EVENT_QP_FATAL);
+			if (!atomic_read(&nesqp->close_timer_started)) {
+				nes_terminate_connection(nesdev, nesqp, aeqe, IB_EVENT_QP_FATAL);
+			}
 			break;
 
 		case NES_AEQE_AEID_CQ_OPERATION_ERROR:
-- 
1.7.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
