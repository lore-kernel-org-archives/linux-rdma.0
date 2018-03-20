From: Sinan Kaya <okaya@codeaurora.org>
Subject: [PATCH v4 5/6] IB/nes: Eliminate duplicate barriers on weakly-ordered archs
Date: Mon, 19 Mar 2018 22:47:47 -0400
Message-ID: <1521514068-8856-6-git-send-email-okaya@codeaurora.org>
References: <1521514068-8856-1-git-send-email-okaya@codeaurora.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521514068-8856-1-git-send-email-okaya@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, timur@codeaurora.org, sulrich@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Sinan Kaya <okaya@codeaurora.org>, Faisal Latif <faisal.latif@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Code includes barrier() followed by writel(). writel() already has a
barrier on some architectures like arm64.

This ends up CPU observing two barriers back to back before executing the
register write.

Create a new wrapper function with relaxed write operator. Use the new
wrapper when a write is following a barrier().

Signed-off-by: Sinan Kaya <okaya@codeaurora.org>
---
 drivers/infiniband/hw/nes/nes.h       |  5 +++++
 drivers/infiniband/hw/nes/nes_hw.c    | 21 ++++++++++++++-------
 drivers/infiniband/hw/nes/nes_mgt.c   | 15 ++++++++++-----
 drivers/infiniband/hw/nes/nes_nic.c   |  2 +-
 drivers/infiniband/hw/nes/nes_utils.c |  3 ++-
 drivers/infiniband/hw/nes/nes_verbs.c |  5 +++--
 6 files changed, 35 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes.h b/drivers/infiniband/hw/nes/nes.h
index 00c27291..85e007d 100644
--- a/drivers/infiniband/hw/nes/nes.h
+++ b/drivers/infiniband/hw/nes/nes.h
@@ -387,6 +387,11 @@ static inline void nes_write_indexed(struct nes_device *nesdev, u32 reg_index, u
 	spin_unlock_irqrestore(&nesdev->indexed_regs_lock, flags);
 }
 
+static inline void nes_write32_relaxed(void __iomem *addr, u32 val)
+{
+	writel_relaxed(val, addr);
+}
+
 static inline void nes_write32(void __iomem *addr, u32 val)
 {
 	writel(val, addr);
diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index 18a7de1..568e17d 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -1257,7 +1257,8 @@ int nes_destroy_cqp(struct nes_device *nesdev)
 
 	barrier();
 	/* Ring doorbell (5 WQEs) */
-	nes_write32(nesdev->regs+NES_WQE_ALLOC, 0x05800000 | nesdev->cqp.qp_id);
+	nes_write32_relaxed(nesdev->regs+NES_WQE_ALLOC,
+			    0x05800000 | nesdev->cqp.qp_id);
 
 	spin_unlock_irqrestore(&nesdev->cqp.lock, flags);
 
@@ -1594,7 +1595,8 @@ static void nes_replenish_nic_rq(struct nes_vnic *nesvnic)
 			atomic_dec(&nesvnic->rx_skbs_needed);
 			barrier();
 			if (++rx_wqes_posted == 255) {
-				nes_write32(nesdev->regs+NES_WQE_ALLOC, (rx_wqes_posted << 24) | nesnic->qp_id);
+				nes_write32_relaxed(nesdev->regs+NES_WQE_ALLOC,
+				       (rx_wqes_posted << 24) | nesnic->qp_id);
 				rx_wqes_posted = 0;
 			}
 		} else {
@@ -1612,7 +1614,8 @@ static void nes_replenish_nic_rq(struct nes_vnic *nesvnic)
 	} while (atomic_read(&nesvnic->rx_skbs_needed));
 	barrier();
 	if (rx_wqes_posted)
-		nes_write32(nesdev->regs+NES_WQE_ALLOC, (rx_wqes_posted << 24) | nesnic->qp_id);
+		nes_write32_relaxed(nesdev->regs+NES_WQE_ALLOC,
+				    (rx_wqes_posted << 24) | nesnic->qp_id);
 	nesnic->replenishing_rq = 0;
 }
 
@@ -1795,7 +1798,8 @@ int nes_init_nic_qp(struct nes_device *nesdev, struct net_device *netdev)
 	barrier();
 
 	/* Ring doorbell (2 WQEs) */
-	nes_write32(nesdev->regs+NES_WQE_ALLOC, 0x02800000 | nesdev->cqp.qp_id);
+	nes_write32_relaxed(nesdev->regs+NES_WQE_ALLOC,
+			    0x02800000 | nesdev->cqp.qp_id);
 
 	spin_unlock_irqrestore(&nesdev->cqp.lock, flags);
 	nes_debug(NES_DBG_INIT, "Waiting for create NIC QP%u to complete.\n",
@@ -1844,7 +1848,8 @@ int nes_init_nic_qp(struct nes_device *nesdev, struct net_device *netdev)
 	do {
 		counter = min(wqe_count, ((u32)255));
 		wqe_count -= counter;
-		nes_write32(nesdev->regs+NES_WQE_ALLOC, (counter << 24) | nesvnic->nic.qp_id);
+		nes_write32_relaxed(nesdev->regs+NES_WQE_ALLOC,
+				    (counter << 24) | nesvnic->nic.qp_id);
 	} while (wqe_count);
 	timer_setup(&nesvnic->rq_wqes_timer, nes_rq_wqes_timeout, 0);
 	nes_debug(NES_DBG_INIT, "NAPI support Enabled\n");
@@ -1988,7 +1993,8 @@ void nes_destroy_nic_qp(struct nes_vnic *nesvnic)
 	barrier();
 
 	/* Ring doorbell (2 WQEs) */
-	nes_write32(nesdev->regs+NES_WQE_ALLOC, 0x02800000 | nesdev->cqp.qp_id);
+	nes_write32_relaxed(nesdev->regs+NES_WQE_ALLOC,
+			    0x02800000 | nesdev->cqp.qp_id);
 
 	spin_unlock_irqrestore(&nesdev->cqp.lock, flags);
 	nes_debug(NES_DBG_SHUTDOWN, "Waiting for CQP, cqp_head=%u, cqp.sq_head=%u,"
@@ -3064,7 +3070,8 @@ static void nes_cqp_ce_handler(struct nes_device *nesdev, struct nes_hw_cq *cq)
 				cqp_request, le32_to_cpu(cqp_wqe->wqe_words[NES_CQP_WQE_OPCODE_IDX])&0x3f, head);
 		/* Ring doorbell (1 WQEs) */
 		barrier();
-		nes_write32(nesdev->regs+NES_WQE_ALLOC, 0x01800000 | nesdev->cqp.qp_id);
+		nes_write32_relaxed(nesdev->regs+NES_WQE_ALLOC,
+				    0x01800000 | nesdev->cqp.qp_id);
 	}
 	spin_unlock_irqrestore(&nesdev->cqp.lock, flags);
 
diff --git a/drivers/infiniband/hw/nes/nes_mgt.c b/drivers/infiniband/hw/nes/nes_mgt.c
index 21e0ebd..5c5073c 100644
--- a/drivers/infiniband/hw/nes/nes_mgt.c
+++ b/drivers/infiniband/hw/nes/nes_mgt.c
@@ -96,7 +96,8 @@ static void nes_replenish_mgt_rq(struct nes_vnic_mgt *mgtvnic)
 			atomic_dec(&mgtvnic->rx_skbs_needed);
 			barrier();
 			if (++rx_wqes_posted == 255) {
-				nes_write32(nesdev->regs + NES_WQE_ALLOC, (rx_wqes_posted << 24) | nesmgt->qp_id);
+				nes_write32_relaxed(nesdev->regs + NES_WQE_ALLOC,
+					(rx_wqes_posted << 24) | nesmgt->qp_id);
 				rx_wqes_posted = 0;
 			}
 		} else {
@@ -115,7 +116,8 @@ static void nes_replenish_mgt_rq(struct nes_vnic_mgt *mgtvnic)
 	} while (atomic_read(&mgtvnic->rx_skbs_needed));
 	barrier();
 	if (rx_wqes_posted)
-		nes_write32(nesdev->regs + NES_WQE_ALLOC, (rx_wqes_posted << 24) | nesmgt->qp_id);
+		nes_write32_relaxed(nesdev->regs + NES_WQE_ALLOC,
+				    (rx_wqes_posted << 24) | nesmgt->qp_id);
 	nesmgt->replenishing_rq = 0;
 }
 
@@ -995,7 +997,8 @@ int nes_init_mgt_qp(struct nes_device *nesdev, struct net_device *netdev, struct
 		barrier();
 
 		/* Ring doorbell (2 WQEs) */
-		nes_write32(nesdev->regs + NES_WQE_ALLOC, 0x02800000 | nesdev->cqp.qp_id);
+		nes_write32_relaxed(nesdev->regs + NES_WQE_ALLOC,
+				    0x02800000 | nesdev->cqp.qp_id);
 
 		spin_unlock_irqrestore(&nesdev->cqp.lock, flags);
 		nes_debug(NES_DBG_INIT, "Waiting for create MGT QP%u to complete.\n",
@@ -1050,7 +1053,8 @@ int nes_init_mgt_qp(struct nes_device *nesdev, struct net_device *netdev, struct
 		do {
 			counter = min(wqe_count, ((u32)255));
 			wqe_count -= counter;
-			nes_write32(nesdev->regs + NES_WQE_ALLOC, (counter << 24) | mgtvnic->mgt.qp_id);
+			nes_write32_relaxed(nesdev->regs + NES_WQE_ALLOC,
+					(counter << 24) | mgtvnic->mgt.qp_id);
 		} while (wqe_count);
 
 		nes_write32(nesdev->regs + NES_CQE_ALLOC, NES_CQE_ALLOC_NOTIFY_NEXT |
@@ -1124,7 +1128,8 @@ void nes_destroy_mgt(struct nes_vnic *nesvnic)
 		barrier();
 
 		/* Ring doorbell (2 WQEs) */
-		nes_write32(nesdev->regs + NES_WQE_ALLOC, 0x02800000 | nesdev->cqp.qp_id);
+		nes_write32_relaxed(nesdev->regs + NES_WQE_ALLOC,
+				    0x02800000 | nesdev->cqp.qp_id);
 
 		spin_unlock_irqrestore(&nesdev->cqp.lock, flags);
 		nes_debug(NES_DBG_SHUTDOWN, "Waiting for CQP, cqp_head=%u, cqp.sq_head=%u,"
diff --git a/drivers/infiniband/hw/nes/nes_nic.c b/drivers/infiniband/hw/nes/nes_nic.c
index 0a75164..0653da0 100644
--- a/drivers/infiniband/hw/nes/nes_nic.c
+++ b/drivers/infiniband/hw/nes/nes_nic.c
@@ -683,7 +683,7 @@ static int nes_netdev_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 	barrier();
 
 	if (wqe_count)
-		nes_write32(nesdev->regs+NES_WQE_ALLOC,
+		nes_write32_relaxed(nesdev->regs+NES_WQE_ALLOC,
 				(wqe_count << 24) | (1 << 23) | nesvnic->nic.qp_id);
 
 	netif_trans_update(netdev);
diff --git a/drivers/infiniband/hw/nes/nes_utils.c b/drivers/infiniband/hw/nes/nes_utils.c
index 21b4a83..79a3d98 100644
--- a/drivers/infiniband/hw/nes/nes_utils.c
+++ b/drivers/infiniband/hw/nes/nes_utils.c
@@ -661,7 +661,8 @@ void nes_post_cqp_request(struct nes_device *nesdev,
 		barrier();
 
 		/* Ring doorbell (1 WQEs) */
-		nes_write32(nesdev->regs+NES_WQE_ALLOC, 0x01800000 | nesdev->cqp.qp_id);
+		nes_write32_relaxed(nesdev->regs+NES_WQE_ALLOC,
+				    0x01800000 | nesdev->cqp.qp_id);
 
 		barrier();
 	} else {
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 162475a..87f8635 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -3310,7 +3310,7 @@ static int nes_post_send(struct ib_qp *ibqp, struct ib_send_wr *ib_wr,
 	while (wqe_count) {
 		counter = min(wqe_count, ((u32)255));
 		wqe_count -= counter;
-		nes_write32(nesdev->regs + NES_WQE_ALLOC,
+		nes_write32_relaxed(nesdev->regs + NES_WQE_ALLOC,
 				(counter << 24) | 0x00800000 | nesqp->hwqp.qp_id);
 	}
 
@@ -3404,7 +3404,8 @@ static int nes_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *ib_wr,
 	while (wqe_count) {
 		counter = min(wqe_count, ((u32)255));
 		wqe_count -= counter;
-		nes_write32(nesdev->regs+NES_WQE_ALLOC, (counter<<24) | nesqp->hwqp.qp_id);
+		nes_write32_relaxed(nesdev->regs+NES_WQE_ALLOC,
+				    (counter<<24) | nesqp->hwqp.qp_id);
 	}
 
 	spin_unlock_irqrestore(&nesqp->lock, flags);
-- 
2.7.4
