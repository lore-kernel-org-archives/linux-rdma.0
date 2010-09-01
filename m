From: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDMA/nes: Modified FIN handling causes hang in A0 cards
Date: Wed, 1 Sep 2010 10:43:11 -0500
Message-ID: <20100901154311.GA7040@FLATIF-MOBL3>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The changing state to CLOSING when FIN is received causes A0 cards to hang and
the interface will not be active. Now in the FIN handling, a check is made
if it is A0 card or not.

Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_hw.c |    3 ++-
 drivers/infiniband/hw/nes/nes_hw.h |    1 +
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index bfdad33..57fc45a 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -3468,7 +3468,8 @@ static void nes_process_iwarp_aeqe(struct nes_device *nesdev,
 				return; /* Ignore it, wait for close complete */
 			if (atomic_inc_return(&nesqp->close_timer_started) == 1) {
 				if ((tcp_state == NES_AEQE_TCP_STATE_CLOSE_WAIT) &&
-					(nesqp->ibqp_state == IB_QPS_RTS)) {
+					(nesqp->ibqp_state == IB_QPS_RTS) &&
+					((nesadapter->eeprom_version >> 16) != NES_A0)) {
 					spin_lock_irqsave(&nesqp->lock, flags);
 					nesqp->hw_iwarp_state = iwarp_state;
 					nesqp->hw_tcp_state = tcp_state;
diff --git a/drivers/infiniband/hw/nes/nes_hw.h b/drivers/infiniband/hw/nes/nes_hw.h
index aa9183d..1204c34 100644
--- a/drivers/infiniband/hw/nes/nes_hw.h
+++ b/drivers/infiniband/hw/nes/nes_hw.h
@@ -45,6 +45,7 @@
 #define NES_PHY_TYPE_KR	       9
 
 #define NES_MULTICAST_PF_MAX 8
+#define NES_A0 3
 
 enum pci_regs {
 	NES_INT_STAT = 0x0000,
-- 
1.6.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
