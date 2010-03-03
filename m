From: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDMA/nes: clear stall bit before destroying nic qp
Date: Wed, 3 Mar 2010 13:13:28 -0600
Message-ID: <20100303191328.GA4272@ctung-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Clear the stall bit to drop any incoming packets while destroying
nic qp.  This will prevent a chip resource leak.

Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_hw.c |    8 ++++++++
 drivers/infiniband/hw/nes/nes_hw.h |    1 +
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index ce7f538..9250755 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -1899,9 +1899,14 @@ void nes_destroy_nic_qp(struct nes_vnic *nesvnic)
 	u16  wqe_fragment_index;
 	u64 wqe_frag;
 	u32 cqp_head;
+	u32 wqm_cfg0;
 	unsigned long flags;
 	int ret;
 
+	/* clear wqe stall before destroying NIC QP */
+	wqm_cfg0 = nes_read_indexed(nesdev, NES_IDX_WQM_CONFIG0);
+	nes_write_indexed(nesdev, NES_IDX_WQM_CONFIG0, wqm_cfg0 & 0xFFFF7FFF);
+
 	/* Free remaining NIC receive buffers */
 	while (nesvnic->nic.rq_head != nesvnic->nic.rq_tail) {
 		nic_rqe   = &nesvnic->nic.rq_vbase[nesvnic->nic.rq_tail];
@@ -2020,6 +2025,9 @@ void nes_destroy_nic_qp(struct nes_vnic *nesvnic)
 
 	pci_free_consistent(nesdev->pcidev, nesvnic->nic_mem_size, nesvnic->nic_vbase,
 			nesvnic->nic_pbase);
+
+	/* restore old wqm_cfg0 value */
+	nes_write_indexed(nesdev, NES_IDX_WQM_CONFIG0, wqm_cfg0);
 }
 
 /**
diff --git a/drivers/infiniband/hw/nes/nes_hw.h b/drivers/infiniband/hw/nes/nes_hw.h
index 9b1e7f8..bbbfe9f 100644
--- a/drivers/infiniband/hw/nes/nes_hw.h
+++ b/drivers/infiniband/hw/nes/nes_hw.h
@@ -160,6 +160,7 @@ enum indexed_regs {
 	NES_IDX_ENDNODE0_NSTAT_TX_OCTETS_HI = 0x7004,
 	NES_IDX_ENDNODE0_NSTAT_TX_FRAMES_LO = 0x7008,
 	NES_IDX_ENDNODE0_NSTAT_TX_FRAMES_HI = 0x700c,
+	NES_IDX_WQM_CONFIG0 = 0x5000,
 	NES_IDX_WQM_CONFIG1 = 0x5004,
 	NES_IDX_CM_CONFIG = 0x5100,
 	NES_IDX_NIC_LOGPORT_TO_PHYPORT = 0x6000,
-- 
1.6.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
