From: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/3] RDMA/nes: Support for Packed And Unaligned fpdus
Date: Sun, 25 Sep 2011 20:34:00 -0500
Message-ID: <20110926013400.GA4132@FLATIF-MOBL4>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Support for Packed and Unaligned (PAU) fpdus is needed for interoperability
between NES and other non-NES nodes. When the NES hardware detects a PAU
frame, it will pass it to the driver to process the frame. NES driver creates
a new frame for each FPDU and forwards it to the hardware to be sent to its
associated qp.

Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Faisal Latif <Faisal.Latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/Makefile    |    2 +-
 drivers/infiniband/hw/nes/nes.c       |    8 +-
 drivers/infiniband/hw/nes/nes.h       |   16 +-
 drivers/infiniband/hw/nes/nes_cm.c    |   20 +-
 drivers/infiniband/hw/nes/nes_cm.h    |    2 +
 drivers/infiniband/hw/nes/nes_hw.c    |   73 ++-
 drivers/infiniband/hw/nes/nes_hw.h    |   35 +-
 drivers/infiniband/hw/nes/nes_mgt.c   | 1160 +++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/nes/nes_mgt.h   |   97 +++
 drivers/infiniband/hw/nes/nes_nic.c   |    4 +
 drivers/infiniband/hw/nes/nes_utils.c |   53 ++-
 drivers/infiniband/hw/nes/nes_verbs.c |    3 +-
 drivers/infiniband/hw/nes/nes_verbs.h |    9 +-
 13 files changed, 1432 insertions(+), 50 deletions(-)
 create mode 100644 drivers/infiniband/hw/nes/nes_mgt.c
 create mode 100644 drivers/infiniband/hw/nes/nes_mgt.h

diff --git a/drivers/infiniband/hw/nes/Makefile b/drivers/infiniband/hw/nes/Makefile
index 3514851..97820c2 100644
--- a/drivers/infiniband/hw/nes/Makefile
+++ b/drivers/infiniband/hw/nes/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_INFINIBAND_NES) += iw_nes.o
 
-iw_nes-objs := nes.o nes_hw.o nes_nic.o nes_utils.o nes_verbs.o nes_cm.o
+iw_nes-objs := nes.o nes_hw.o nes_nic.o nes_utils.o nes_verbs.o nes_cm.o nes_mgt.o
diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
index 2d668c6..5965b3d 100644
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -84,7 +84,7 @@ module_param(send_first, int, 0644);
 MODULE_PARM_DESC(send_first, "Send RDMA Message First on Active Connection");
 
 
-unsigned int nes_drv_opt = 0;
+unsigned int nes_drv_opt = NES_DRV_OPT_DISABLE_INT_MOD | NES_DRV_OPT_ENABLE_PAU;
 module_param(nes_drv_opt, int, 0644);
 MODULE_PARM_DESC(nes_drv_opt, "Driver option parameters");
 
@@ -130,9 +130,6 @@ static struct notifier_block nes_net_notifier = {
 	.notifier_call = nes_net_event
 };
 
-
-
-
 /**
  * nes_inetaddr_event
  */
@@ -321,6 +318,9 @@ void nes_rem_ref(struct ib_qp *ibqp)
 	}
 
 	if (atomic_dec_and_test(&nesqp->refcount)) {
+		if (nesqp->pau_mode)
+			nes_destroy_pau_qp(nesdev, nesqp);
+
 		/* Destroy the QP */
 		cqp_request = nes_get_cqp_request(nesdev);
 		if (cqp_request == NULL) {
diff --git a/drivers/infiniband/hw/nes/nes.h b/drivers/infiniband/hw/nes/nes.h
index 6fe7987..27716e9 100644
--- a/drivers/infiniband/hw/nes/nes.h
+++ b/drivers/infiniband/hw/nes/nes.h
@@ -102,6 +102,7 @@
 #define NES_DRV_OPT_NO_INLINE_DATA       0x00000080
 #define NES_DRV_OPT_DISABLE_INT_MOD      0x00000100
 #define NES_DRV_OPT_DISABLE_VIRT_WQ      0x00000200
+#define NES_DRV_OPT_ENABLE_PAU           0x00000400
 
 #define NES_AEQ_EVENT_TIMEOUT         2500
 #define NES_DISCONNECT_EVENT_TIMEOUT  2000
@@ -162,6 +163,7 @@ do { \
 #include "nes_context.h"
 #include "nes_user.h"
 #include "nes_cm.h"
+#include "nes_mgt.h"
 
 extern int max_mtu;
 #define max_frame_len (max_mtu+ETH_HLEN)
@@ -202,6 +204,8 @@ extern atomic_t cm_nodes_created;
 extern atomic_t cm_nodes_destroyed;
 extern atomic_t cm_accel_dropped_pkts;
 extern atomic_t cm_resets_recvd;
+extern atomic_t pau_qps_created;
+extern atomic_t pau_qps_destroyed;
 
 extern u32 int_mod_timer_init;
 extern u32 int_mod_cq_depth_256;
@@ -273,6 +277,14 @@ struct nes_device {
 	u8                     link_recheck;
 };
 
+/* Receive skb private area - must fit in skb->cb area */
+struct nes_rskb_cb {
+	u64                    busaddr;
+	u32                    maplen;
+	u32                    seqnum;
+	u8                     *data_start;
+	struct nes_qp          *nesqp;
+};
 
 static inline __le32 get_crc_value(struct nes_v4_quad *nes_quad)
 {
@@ -305,8 +317,8 @@ set_wqe_32bit_value(__le32 *wqe_words, u32 index, u32 value)
 static inline void
 nes_fill_init_cqp_wqe(struct nes_hw_cqp_wqe *cqp_wqe, struct nes_device *nesdev)
 {
-	set_wqe_64bit_value(cqp_wqe->wqe_words, NES_CQP_WQE_COMP_CTX_LOW_IDX,
-			(u64)((unsigned long) &nesdev->cqp));
+	cqp_wqe->wqe_words[NES_CQP_WQE_COMP_CTX_LOW_IDX]       = 0;
+	cqp_wqe->wqe_words[NES_CQP_WQE_COMP_CTX_HIGH_IDX]      = 0;
 	cqp_wqe->wqe_words[NES_CQP_WQE_COMP_SCRATCH_LOW_IDX]   = 0;
 	cqp_wqe->wqe_words[NES_CQP_WQE_COMP_SCRATCH_HIGH_IDX]  = 0;
 	cqp_wqe->wqe_words[NES_CQP_STAG_WQE_PBL_BLK_COUNT_IDX] = 0;
diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 0bfb588..ebf2c00 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -156,6 +156,16 @@ atomic_t cm_connecteds;
 atomic_t cm_connect_reqs;
 atomic_t cm_rejects;
 
+int nes_add_ref_cm_node(struct nes_cm_node *cm_node)
+{
+	return add_ref_cm_node(cm_node);
+}
+
+int nes_rem_ref_cm_node(struct nes_cm_node *cm_node)
+{
+	return rem_ref_cm_node(cm_node->cm_core, cm_node);
+}
+
 
 /**
  * create_event
@@ -2559,9 +2569,13 @@ static int mini_cm_recv_pkt(struct nes_cm_core *cm_core,
 			}
 			add_ref_cm_node(cm_node);
 		} else if (cm_node->state == NES_CM_STATE_TSA) {
-			rem_ref_cm_node(cm_core, cm_node);
-			atomic_inc(&cm_accel_dropped_pkts);
-			dev_kfree_skb_any(skb);
+			if (cm_node->nesqp->pau_mode)
+				nes_queue_mgt_skbs(skb, nesvnic, cm_node->nesqp);
+			else {
+				rem_ref_cm_node(cm_core, cm_node);
+				atomic_inc(&cm_accel_dropped_pkts);
+				dev_kfree_skb_any(skb);
+			}
 			break;
 		}
 		skb_reset_network_header(skb);
diff --git a/drivers/infiniband/hw/nes/nes_cm.h b/drivers/infiniband/hw/nes/nes_cm.h
index 85f53d9..bdfa1fb 100644
--- a/drivers/infiniband/hw/nes/nes_cm.h
+++ b/drivers/infiniband/hw/nes/nes_cm.h
@@ -461,5 +461,7 @@ int nes_destroy_listen(struct iw_cm_id *);
 int nes_cm_recv(struct sk_buff *, struct net_device *);
 int nes_cm_start(void);
 int nes_cm_stop(void);
+int nes_add_ref_cm_node(struct nes_cm_node *cm_node);
+int nes_rem_ref_cm_node(struct nes_cm_node *cm_node);
 
 #endif			/* NES_CM_H */
diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index fb6ba7e..048bf4b 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -1564,6 +1564,7 @@ static void nes_replenish_nic_rq(struct nes_vnic *nesvnic)
 	struct nes_hw_nic_rq_wqe *nic_rqe;
 	struct nes_hw_nic *nesnic;
 	struct nes_device *nesdev;
+	struct nes_rskb_cb *cb;
 	u32 rx_wqes_posted = 0;
 
 	nesnic = &nesvnic->nic;
@@ -1589,6 +1590,9 @@ static void nes_replenish_nic_rq(struct nes_vnic *nesvnic)
 
 			bus_address = pci_map_single(nesdev->pcidev,
 					skb->data, nesvnic->max_frame_size, PCI_DMA_FROMDEVICE);
+			cb = (struct nes_rskb_cb *)&skb->cb[0];
+			cb->busaddr = bus_address;
+			cb->maplen = nesvnic->max_frame_size;
 
 			nic_rqe = &nesnic->rq_vbase[nesvnic->nic.rq_head];
 			nic_rqe->wqe_words[NES_NIC_RQ_WQE_LENGTH_1_0_IDX] =
@@ -1678,6 +1682,7 @@ int nes_init_nic_qp(struct nes_device *nesdev, struct net_device *netdev)
 	u32 cqp_head;
 	u32 counter;
 	u32 wqe_count;
+	struct nes_rskb_cb *cb;
 	u8 jumbomode=0;
 
 	/* Allocate fragment, SQ, RQ, and CQ; Reuse CEQ based on the PCI function */
@@ -1854,6 +1859,9 @@ int nes_init_nic_qp(struct nes_device *nesdev, struct net_device *netdev)
 
 		pmem = pci_map_single(nesdev->pcidev, skb->data,
 				nesvnic->max_frame_size, PCI_DMA_FROMDEVICE);
+		cb = (struct nes_rskb_cb *)&skb->cb[0];
+		cb->busaddr = pmem;
+		cb->maplen = nesvnic->max_frame_size;
 
 		nic_rqe = &nesvnic->nic.rq_vbase[counter];
 		nic_rqe->wqe_words[NES_NIC_RQ_WQE_LENGTH_1_0_IDX] = cpu_to_le32(nesvnic->max_frame_size);
@@ -1882,6 +1890,13 @@ int nes_init_nic_qp(struct nes_device *nesdev, struct net_device *netdev)
 			jumbomode = 1;
 		nes_nic_init_timer_defaults(nesdev, jumbomode);
 	}
+	if ((nesdev->nesadapter->allow_unaligned_fpdus) &&
+		(nes_init_mgt_qp(nesdev, netdev, nesvnic))) {
+			nes_debug(NES_DBG_INIT, "%s: Out of memory for pau nic\n", netdev->name);
+			nes_destroy_nic_qp(nesvnic);
+		return -ENOMEM;
+	}
+
 	nesvnic->lro_mgr.max_aggr       = nes_lro_max_aggr;
 	nesvnic->lro_mgr.max_desc       = NES_MAX_LRO_DESCRIPTORS;
 	nesvnic->lro_mgr.lro_arr        = nesvnic->lro_desc;
@@ -1904,28 +1919,29 @@ void nes_destroy_nic_qp(struct nes_vnic *nesvnic)
 	struct nes_device *nesdev = nesvnic->nesdev;
 	struct nes_hw_cqp_wqe *cqp_wqe;
 	struct nes_hw_nic_sq_wqe *nic_sqe;
-	struct nes_hw_nic_rq_wqe *nic_rqe;
 	__le16 *wqe_fragment_length;
 	u16  wqe_fragment_index;
-	u64 wqe_frag;
 	u32 cqp_head;
 	u32 wqm_cfg0;
 	unsigned long flags;
+	struct sk_buff *rx_skb;
+	struct nes_rskb_cb *cb;
 	int ret;
 
+	if (nesdev->nesadapter->allow_unaligned_fpdus)
+		nes_destroy_mgt(nesvnic);
+
 	/* clear wqe stall before destroying NIC QP */
 	wqm_cfg0 = nes_read_indexed(nesdev, NES_IDX_WQM_CONFIG0);
 	nes_write_indexed(nesdev, NES_IDX_WQM_CONFIG0, wqm_cfg0 & 0xFFFF7FFF);
 
 	/* Free remaining NIC receive buffers */
 	while (nesvnic->nic.rq_head != nesvnic->nic.rq_tail) {
-		nic_rqe   = &nesvnic->nic.rq_vbase[nesvnic->nic.rq_tail];
-		wqe_frag  = (u64)le32_to_cpu(
-			nic_rqe->wqe_words[NES_NIC_RQ_WQE_FRAG0_LOW_IDX]);
-		wqe_frag |= ((u64)le32_to_cpu(
-			nic_rqe->wqe_words[NES_NIC_RQ_WQE_FRAG0_HIGH_IDX]))<<32;
-		pci_unmap_single(nesdev->pcidev, (dma_addr_t)wqe_frag,
-				nesvnic->max_frame_size, PCI_DMA_FROMDEVICE);
+		rx_skb = nesvnic->nic.rx_skb[nesvnic->nic.rq_tail];
+		cb = (struct nes_rskb_cb *)&rx_skb->cb[0];
+		pci_unmap_single(nesdev->pcidev, cb->busaddr, cb->maplen,
+			PCI_DMA_FROMDEVICE);
+
 		dev_kfree_skb(nesvnic->nic.rx_skb[nesvnic->nic.rq_tail++]);
 		nesvnic->nic.rq_tail &= (nesvnic->nic.rq_size - 1);
 	}
@@ -2784,6 +2800,7 @@ void nes_nic_ce_handler(struct nes_device *nesdev, struct nes_hw_nic_cq *cq)
 	struct nes_hw_nic_sq_wqe *nic_sqe;
 	struct sk_buff *skb;
 	struct sk_buff *rx_skb;
+	struct nes_rskb_cb *cb;
 	__le16 *wqe_fragment_length;
 	u32 head;
 	u32 cq_size;
@@ -2868,6 +2885,8 @@ void nes_nic_ce_handler(struct nes_device *nesdev, struct nes_hw_nic_cq *cq)
 				bus_address += ((u64)le32_to_cpu(nic_rqe->wqe_words[NES_NIC_RQ_WQE_FRAG0_HIGH_IDX])) << 32;
 				pci_unmap_single(nesdev->pcidev, bus_address,
 						nesvnic->max_frame_size, PCI_DMA_FROMDEVICE);
+				cb = (struct nes_rskb_cb *)&rx_skb->cb[0];
+				cb->busaddr = 0;
 				/* rx_skb->tail = rx_skb->data + rx_pkt_size; */
 				/* rx_skb->len = rx_pkt_size; */
 				rx_skb->len = 0;  /* TODO: see if this is necessary */
@@ -2992,6 +3011,7 @@ skip_rx_indicate0:
 }
 
 
+
 /**
  * nes_cqp_ce_handler
  */
@@ -3006,6 +3026,8 @@ static void nes_cqp_ce_handler(struct nes_device *nesdev, struct nes_hw_cq *cq)
 	u32 cq_size;
 	u32 cqe_count=0;
 	u32 error_code;
+	u32 opcode;
+	u32 ctx_index;
 	/* u32 counter; */
 
 	head = cq->cq_head;
@@ -3016,12 +3038,9 @@ static void nes_cqp_ce_handler(struct nes_device *nesdev, struct nes_hw_cq *cq)
 		/* nes_debug(NES_DBG_CQP, "head=%u cqe_words=%08X\n", head,
 			  le32_to_cpu(cq->cq_vbase[head].cqe_words[NES_CQE_OPCODE_IDX])); */
 
-		if (le32_to_cpu(cq->cq_vbase[head].cqe_words[NES_CQE_OPCODE_IDX]) & NES_CQE_VALID) {
-			u64temp = (((u64)(le32_to_cpu(cq->cq_vbase[head].
-					cqe_words[NES_CQE_COMP_COMP_CTX_HIGH_IDX]))) << 32) |
-					((u64)(le32_to_cpu(cq->cq_vbase[head].
-					cqe_words[NES_CQE_COMP_COMP_CTX_LOW_IDX])));
-			cqp = *((struct nes_hw_cqp **)&u64temp);
+		opcode = le32_to_cpu(cq->cq_vbase[head].cqe_words[NES_CQE_OPCODE_IDX]);
+		if (opcode & NES_CQE_VALID) {
+			cqp = &nesdev->cqp;
 
 			error_code = le32_to_cpu(cq->cq_vbase[head].cqe_words[NES_CQE_ERROR_CODE_IDX]);
 			if (error_code) {
@@ -3030,15 +3049,14 @@ static void nes_cqp_ce_handler(struct nes_device *nesdev, struct nes_hw_cq *cq)
 						le32_to_cpu(cq->cq_vbase[head].cqe_words[NES_CQE_OPCODE_IDX])&0x3f,
 						(u16)(error_code >> 16),
 						(u16)error_code);
-				nes_debug(NES_DBG_CQP, "cqp: qp_id=%u, sq_head=%u, sq_tail=%u\n",
-						cqp->qp_id, cqp->sq_head, cqp->sq_tail);
 			}
 
-			u64temp = (((u64)(le32_to_cpu(nesdev->cqp.sq_vbase[cqp->sq_tail].
-					wqe_words[NES_CQP_WQE_COMP_SCRATCH_HIGH_IDX]))) << 32) |
-					((u64)(le32_to_cpu(nesdev->cqp.sq_vbase[cqp->sq_tail].
-					wqe_words[NES_CQP_WQE_COMP_SCRATCH_LOW_IDX])));
-			cqp_request = *((struct nes_cqp_request **)&u64temp);
+			u64temp = (((u64)(le32_to_cpu(cq->cq_vbase[head].
+					cqe_words[NES_CQE_COMP_COMP_CTX_HIGH_IDX]))) << 32) |
+					((u64)(le32_to_cpu(cq->cq_vbase[head].
+					cqe_words[NES_CQE_COMP_COMP_CTX_LOW_IDX])));
+
+			cqp_request = (struct nes_cqp_request *)(unsigned long)u64temp;
 			if (cqp_request) {
 				if (cqp_request->waiting) {
 					/* nes_debug(NES_DBG_CQP, "%s: Waking up requestor\n"); */
@@ -3084,9 +3102,15 @@ static void nes_cqp_ce_handler(struct nes_device *nesdev, struct nes_hw_cq *cq)
 		cqp_wqe = &nesdev->cqp.sq_vbase[head];
 		memcpy(cqp_wqe, &cqp_request->cqp_wqe, sizeof(*cqp_wqe));
 		barrier();
-		cqp_wqe->wqe_words[NES_CQP_WQE_COMP_SCRATCH_LOW_IDX] =
+
+		opcode = cqp_wqe->wqe_words[NES_CQP_WQE_OPCODE_IDX];
+		if ((opcode & NES_CQP_OPCODE_MASK) == NES_CQP_DOWNLOAD_SEGMENT)
+			ctx_index = NES_CQP_WQE_DL_COMP_CTX_LOW_IDX;
+		else
+			ctx_index = NES_CQP_WQE_COMP_CTX_LOW_IDX;
+		cqp_wqe->wqe_words[ctx_index] =
 			cpu_to_le32((u32)((unsigned long)cqp_request));
-		cqp_wqe->wqe_words[NES_CQP_WQE_COMP_SCRATCH_HIGH_IDX] =
+		cqp_wqe->wqe_words[ctx_index + 1] =
 			cpu_to_le32((u32)(upper_32_bits((unsigned long)cqp_request)));
 		nes_debug(NES_DBG_CQP, "CQP request %p (opcode 0x%02X) put on CQPs SQ wqe%u.\n",
 				cqp_request, le32_to_cpu(cqp_wqe->wqe_words[NES_CQP_WQE_OPCODE_IDX])&0x3f, head);
@@ -3102,7 +3126,6 @@ static void nes_cqp_ce_handler(struct nes_device *nesdev, struct nes_hw_cq *cq)
 	nes_read32(nesdev->regs+NES_CQE_ALLOC);
 }
 
-
 static u8 *locate_mpa(u8 *pkt, u32 aeq_info)
 {
 	if (aeq_info & NES_AEQE_Q2_DATA_ETHERNET) {
diff --git a/drivers/infiniband/hw/nes/nes_hw.h b/drivers/infiniband/hw/nes/nes_hw.h
index c324147..0b590e1 100644
--- a/drivers/infiniband/hw/nes/nes_hw.h
+++ b/drivers/infiniband/hw/nes/nes_hw.h
@@ -47,6 +47,11 @@
 #define NES_MULTICAST_PF_MAX 8
 #define NES_A0 3
 
+#define NES_ENABLE_PAU 0x07000001
+#define NES_DISABLE_PAU 0x07000000
+#define NES_PAU_COUNTER 10
+#define NES_CQP_OPCODE_MASK 0x3f
+
 enum pci_regs {
 	NES_INT_STAT = 0x0000,
 	NES_INT_MASK = 0x0004,
@@ -73,8 +78,10 @@ enum indexed_regs {
 	NES_IDX_QP_CONTROL = 0x0040,
 	NES_IDX_FLM_CONTROL = 0x0080,
 	NES_IDX_INT_CPU_STATUS = 0x00a0,
+	NES_IDX_GPR_TRIGGER = 0x00bc,
 	NES_IDX_GPIO_CONTROL = 0x00f0,
 	NES_IDX_GPIO_DATA = 0x00f4,
+	NES_IDX_GPR2 = 0x010c,
 	NES_IDX_TCP_CONFIG0 = 0x01e4,
 	NES_IDX_TCP_TIMER_CONFIG = 0x01ec,
 	NES_IDX_TCP_NOW = 0x01f0,
@@ -202,6 +209,7 @@ enum nes_cqp_opcodes {
 	NES_CQP_REGISTER_SHARED_STAG = 0x0c,
 	NES_CQP_DEALLOCATE_STAG = 0x0d,
 	NES_CQP_MANAGE_ARP_CACHE = 0x0f,
+	NES_CQP_DOWNLOAD_SEGMENT = 0x10,
 	NES_CQP_SUSPEND_QPS = 0x11,
 	NES_CQP_UPLOAD_CONTEXT = 0x13,
 	NES_CQP_CREATE_CEQ = 0x16,
@@ -210,7 +218,8 @@ enum nes_cqp_opcodes {
 	NES_CQP_DESTROY_AEQ = 0x1b,
 	NES_CQP_LMI_ACCESS = 0x20,
 	NES_CQP_FLUSH_WQES = 0x22,
-	NES_CQP_MANAGE_APBVT = 0x23
+	NES_CQP_MANAGE_APBVT = 0x23,
+	NES_CQP_MANAGE_QUAD_HASH = 0x25
 };
 
 enum nes_cqp_wqe_word_idx {
@@ -222,6 +231,14 @@ enum nes_cqp_wqe_word_idx {
 	NES_CQP_WQE_COMP_SCRATCH_HIGH_IDX = 5,
 };
 
+enum nes_cqp_wqe_word_download_idx { /* format differs from other cqp ops */
+	NES_CQP_WQE_DL_OPCODE_IDX = 0,
+	NES_CQP_WQE_DL_COMP_CTX_LOW_IDX = 1,
+	NES_CQP_WQE_DL_COMP_CTX_HIGH_IDX = 2,
+	NES_CQP_WQE_DL_LENGTH_0_TOTAL_IDX = 3
+	/* For index values 4-15 use NES_NIC_SQ_WQE_ values */
+};
+
 enum nes_cqp_cq_wqeword_idx {
 	NES_CQP_CQ_WQE_PBL_LOW_IDX = 6,
 	NES_CQP_CQ_WQE_PBL_HIGH_IDX = 7,
@@ -242,6 +259,7 @@ enum nes_cqp_stag_wqeword_idx {
 	NES_CQP_STAG_WQE_PBL_LEN_IDX = 14
 };
 
+#define NES_CQP_OP_LOGICAL_PORT_SHIFT 26
 #define NES_CQP_OP_IWARP_STATE_SHIFT 28
 #define NES_CQP_OP_TERMLEN_SHIFT     28
 
@@ -599,6 +617,7 @@ enum nes_nic_sq_wqe_bits {
 
 enum nes_nic_cqe_word_idx {
 	NES_NIC_CQE_ACCQP_ID_IDX = 0,
+	NES_NIC_CQE_HASH_RCVNXT = 1,
 	NES_NIC_CQE_TAG_PKT_TYPE_IDX = 2,
 	NES_NIC_CQE_MISC_IDX = 3,
 };
@@ -1005,6 +1024,11 @@ struct nes_arp_entry {
 #define NES_NIC_CQ_DOWNWARD_TREND   16
 #define NES_PFT_SIZE		    48
 
+#define NES_MGT_WQ_COUNT 32
+#define NES_MGT_CTX_SIZE ((NES_NIC_CTX_RQ_SIZE_32) | (NES_NIC_CTX_SQ_SIZE_32))
+#define NES_MGT_QP_OFFSET 36
+#define NES_MGT_QP_COUNT 4
+
 struct nes_hw_tune_timer {
     /* u16 cq_count; */
     u16 threshold_low;
@@ -1118,6 +1142,7 @@ struct nes_adapter {
 	u32 et_rate_sample_interval;
 	u32 timer_int_limit;
 	u32 wqm_quanta;
+	u8 allow_unaligned_fpdus;
 
 	/* Adapter base MAC address */
 	u32 mac_addr_low;
@@ -1251,6 +1276,14 @@ struct nes_vnic {
 	enum ib_event_type delayed_event;
 	enum ib_event_type last_dispatched_event;
 	spinlock_t port_ibevent_lock;
+	u32 mgt_mem_size;
+	void *mgt_vbase;
+	dma_addr_t mgt_pbase;
+	struct nes_vnic_mgt *mgtvnic[NES_MGT_QP_COUNT];
+	struct task_struct *mgt_thread;
+	wait_queue_head_t mgt_wait_queue;
+	struct sk_buff_head mgt_skb_list;
+
 };
 
 struct nes_ib_device {
diff --git a/drivers/infiniband/hw/nes/nes_mgt.c b/drivers/infiniband/hw/nes/nes_mgt.c
new file mode 100644
index 0000000..74ab926
--- /dev/null
+++ b/drivers/infiniband/hw/nes/nes_mgt.c
@@ -0,0 +1,1160 @@
+/*
+ * Copyright (c) 2006 - 2009 Intel-NE, Inc.  All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ */
+
+#include <linux/skbuff.h>
+#include <linux/etherdevice.h>
+#include <linux/kthread.h>
+#include <linux/ip.h>
+#include <linux/tcp.h>
+#include <net/tcp.h>
+#include "nes.h"
+#include "nes_mgt.h"
+
+atomic_t pau_qps_created;
+atomic_t pau_qps_destroyed;
+
+void nes_replenish_mgt_rq(struct nes_vnic_mgt *mgtvnic)
+{
+	unsigned long flags;
+	dma_addr_t bus_address;
+	struct sk_buff *skb;
+	struct nes_hw_nic_rq_wqe *nic_rqe;
+	struct nes_hw_mgt *nesmgt;
+	struct nes_device *nesdev;
+	struct nes_rskb_cb *cb;
+	u32 rx_wqes_posted = 0;
+
+	nesmgt = &mgtvnic->mgt;
+	nesdev = mgtvnic->nesvnic->nesdev;
+	spin_lock_irqsave(&nesmgt->rq_lock, flags);
+	if (nesmgt->replenishing_rq != 0) {
+		if (((nesmgt->rq_size - 1) == atomic_read(&mgtvnic->rx_skbs_needed)) &&
+		    (atomic_read(&mgtvnic->rx_skb_timer_running) == 0)) {
+			atomic_set(&mgtvnic->rx_skb_timer_running, 1);
+			spin_unlock_irqrestore(&nesmgt->rq_lock, flags);
+			mgtvnic->rq_wqes_timer.expires = jiffies + (HZ / 2);      /* 1/2 second */
+			add_timer(&mgtvnic->rq_wqes_timer);
+		} else {
+			spin_unlock_irqrestore(&nesmgt->rq_lock, flags);
+		}
+		return;
+	}
+	nesmgt->replenishing_rq = 1;
+	spin_unlock_irqrestore(&nesmgt->rq_lock, flags);
+	do {
+		skb = dev_alloc_skb(mgtvnic->nesvnic->max_frame_size);
+		if (skb) {
+			skb->dev = mgtvnic->nesvnic->netdev;
+
+			bus_address = pci_map_single(nesdev->pcidev,
+						     skb->data, mgtvnic->nesvnic->max_frame_size, PCI_DMA_FROMDEVICE);
+			cb = (struct nes_rskb_cb *)&skb->cb[0];
+			cb->busaddr = bus_address;
+			cb->maplen = mgtvnic->nesvnic->max_frame_size;
+
+			nic_rqe = &nesmgt->rq_vbase[mgtvnic->mgt.rq_head];
+			nic_rqe->wqe_words[NES_NIC_RQ_WQE_LENGTH_1_0_IDX] =
+				cpu_to_le32(mgtvnic->nesvnic->max_frame_size);
+			nic_rqe->wqe_words[NES_NIC_RQ_WQE_LENGTH_3_2_IDX] = 0;
+			nic_rqe->wqe_words[NES_NIC_RQ_WQE_FRAG0_LOW_IDX] =
+				cpu_to_le32((u32)bus_address);
+			nic_rqe->wqe_words[NES_NIC_RQ_WQE_FRAG0_HIGH_IDX] =
+				cpu_to_le32((u32)((u64)bus_address >> 32));
+			nesmgt->rx_skb[nesmgt->rq_head] = skb;
+			nesmgt->rq_head++;
+			nesmgt->rq_head &= nesmgt->rq_size - 1;
+			atomic_dec(&mgtvnic->rx_skbs_needed);
+			barrier();
+			if (++rx_wqes_posted == 255) {
+				nes_write32(nesdev->regs + NES_WQE_ALLOC, (rx_wqes_posted << 24) | nesmgt->qp_id);
+				rx_wqes_posted = 0;
+			}
+		} else {
+			spin_lock_irqsave(&nesmgt->rq_lock, flags);
+			if (((nesmgt->rq_size - 1) == atomic_read(&mgtvnic->rx_skbs_needed)) &&
+			    (atomic_read(&mgtvnic->rx_skb_timer_running) == 0)) {
+				atomic_set(&mgtvnic->rx_skb_timer_running, 1);
+				spin_unlock_irqrestore(&nesmgt->rq_lock, flags);
+				mgtvnic->rq_wqes_timer.expires = jiffies + (HZ / 2);      /* 1/2 second */
+				add_timer(&mgtvnic->rq_wqes_timer);
+			} else {
+				spin_unlock_irqrestore(&nesmgt->rq_lock, flags);
+			}
+			break;
+		}
+	} while (atomic_read(&mgtvnic->rx_skbs_needed));
+	barrier();
+	if (rx_wqes_posted)
+		nes_write32(nesdev->regs + NES_WQE_ALLOC, (rx_wqes_posted << 24) | nesmgt->qp_id);
+	nesmgt->replenishing_rq = 0;
+}
+
+/**
+ * nes_mgt_rq_wqes_timeout
+ */
+void nes_mgt_rq_wqes_timeout(unsigned long parm)
+{
+	struct nes_vnic_mgt *mgtvnic = (struct nes_vnic_mgt *)parm;
+
+	atomic_set(&mgtvnic->rx_skb_timer_running, 0);
+	if (atomic_read(&mgtvnic->rx_skbs_needed))
+		nes_replenish_mgt_rq(mgtvnic);
+}
+
+/**
+ * nes_mgt_free_skb - unmap and free skb
+ */
+void nes_mgt_free_skb(struct nes_device *nesdev, struct sk_buff *skb, u32 dir)
+{
+	struct nes_rskb_cb *cb;
+
+	cb = (struct nes_rskb_cb *)&skb->cb[0];
+	pci_unmap_single(nesdev->pcidev, cb->busaddr, cb->maplen, dir);
+	cb->busaddr = 0;
+	dev_kfree_skb_any(skb);
+}
+
+/**
+ * nes_download_callback - handle download completions
+ */
+void nes_download_callback(struct nes_device *nesdev, struct nes_cqp_request *cqp_request)
+{
+	struct pau_fpdu_info *fpdu_info = cqp_request->cqp_callback_pointer;
+	struct nes_qp *nesqp = fpdu_info->nesqp;
+	struct sk_buff *skb;
+	int i;
+
+	for (i = 0; i < fpdu_info->frag_cnt; i++) {
+		skb = fpdu_info->frags[i].skb;
+		if (fpdu_info->frags[i].cmplt) {
+			nes_mgt_free_skb(nesdev, skb, PCI_DMA_TODEVICE);
+			nes_rem_ref_cm_node(nesqp->cm_node);
+		}
+	}
+
+	if (fpdu_info->hdr_vbase)
+		pci_free_consistent(nesdev->pcidev, fpdu_info->hdr_len,
+				    fpdu_info->hdr_vbase, fpdu_info->hdr_pbase);
+	kfree(fpdu_info);
+}
+
+/**
+ * nes_get_seq - Get the seq, ack_seq and window from the packet
+ */
+u32 nes_get_seq(struct sk_buff *skb, u32 *ack, u16 *wnd, u32 *fin_rcvd, u32 *rst_rcvd)
+{
+	struct nes_rskb_cb *cb = (struct nes_rskb_cb *)&skb->cb[0];
+	struct iphdr *iph = (struct iphdr *)(cb->data_start + ETH_HLEN);
+	struct tcphdr *tcph = (struct tcphdr *)(((char *)iph) + (4 * iph->ihl));
+
+	*ack = be32_to_cpu(tcph->ack_seq);
+	*wnd = be16_to_cpu(tcph->window);
+	*fin_rcvd = tcph->fin;
+	*rst_rcvd = tcph->rst;
+	return be32_to_cpu(tcph->seq);
+}
+
+/**
+ * nes_get_next_skb - Get the next skb based on where current skb is in the queue
+ */
+struct sk_buff *nes_get_next_skb(struct nes_device *nesdev, struct nes_qp *nesqp, struct sk_buff *skb,
+				 u32 nextseq, u32 *ack, u16 *wnd, u32 *fin_rcvd, u32 *rst_rcvd)
+{
+	u32 seq;
+	bool processacks;
+	struct sk_buff *old_skb;
+
+	if (skb) {
+		/* Continue processing fpdu */
+		if (skb->next == (struct sk_buff *)&nesqp->pau_list)
+			goto out;
+		skb = skb->next;
+		processacks = false;
+	} else {
+		/* Starting a new one */
+		if (skb_queue_empty(&nesqp->pau_list))
+			goto out;
+		skb = skb_peek(&nesqp->pau_list);
+		processacks = true;
+	}
+
+	while (1) {
+		seq = nes_get_seq(skb, ack, wnd, fin_rcvd, rst_rcvd);
+		if (seq == nextseq) {
+			if (skb->len || processacks)
+				break;
+		} else if (after(seq, nextseq)) {
+			goto out;
+		}
+
+		if (skb->next == (struct sk_buff *)&nesqp->pau_list)
+			goto out;
+
+		old_skb = skb;
+		skb = skb->next;
+		skb_unlink(old_skb, &nesqp->pau_list);
+		nes_mgt_free_skb(nesdev, old_skb, PCI_DMA_TODEVICE);
+		nes_rem_ref_cm_node(nesqp->cm_node);
+	}
+	return skb;
+
+out:
+	return NULL;
+}
+
+/**
+ * get_fpdu_info - Find the next complete fpdu and return its fragments.
+ */
+int get_fpdu_info(struct nes_device *nesdev, struct nes_qp *nesqp, struct pau_fpdu_info **pau_fpdu_info)
+{
+	struct sk_buff *skb;
+	struct iphdr *iph;
+	struct tcphdr *tcph;
+	struct nes_rskb_cb *cb;
+	struct pau_fpdu_info *fpdu_info = NULL;
+	struct pau_fpdu_frag frags[MAX_FPDU_FRAGS];
+	unsigned long flags;
+	u32 fpdu_len = 0;
+	u32 tmp_len;
+	int frag_cnt = 0;
+	u32 tot_len;
+	u32 frag_tot;
+	u32 ack;
+	u32 fin_rcvd;
+	u32 rst_rcvd;
+	u16 wnd;
+	int i;
+	int rc = 0;
+
+	*pau_fpdu_info = NULL;
+
+	spin_lock_irqsave(&nesqp->pau_lock, flags);
+	skb = nes_get_next_skb(nesdev, nesqp, NULL, nesqp->pau_rcv_nxt, &ack, &wnd, &fin_rcvd, &rst_rcvd);
+	if (!skb) {
+		spin_unlock_irqrestore(&nesqp->pau_lock, flags);
+		goto out;
+	}
+	cb = (struct nes_rskb_cb *)&skb->cb[0];
+	if (skb->len) {
+		fpdu_len = (u32)be16_to_cpu(*(u16 *)skb->data) + MPA_FRAMING;
+		fpdu_len = (fpdu_len + 3) & 0xfffffffc;
+		tmp_len = fpdu_len;
+
+		/* See if we have all of the fpdu */
+		frag_tot = 0;
+		memset(&frags, 0, sizeof frags);
+		for (i = 0; i < MAX_FPDU_FRAGS; i++) {
+			frags[i].physaddr = cb->busaddr;
+			frags[i].physaddr += skb->data - cb->data_start;
+			frags[i].frag_len = min(tmp_len, skb->len);
+			frags[i].skb = skb;
+			frags[i].cmplt = (skb->len == frags[i].frag_len);
+			frag_tot += frags[i].frag_len;
+			frag_cnt++;
+
+			tmp_len -= frags[i].frag_len;
+			if (tmp_len == 0)
+				break;
+
+			skb = nes_get_next_skb(nesdev, nesqp, skb,
+					       nesqp->pau_rcv_nxt + frag_tot, &ack, &wnd, &fin_rcvd, &rst_rcvd);
+			if (!skb) {
+				spin_unlock_irqrestore(&nesqp->pau_lock, flags);
+				goto out;
+			} else if (rst_rcvd) {
+				/* rst received in the middle of fpdu */
+				for (; i >= 0; i--) {
+					skb_unlink(frags[i].skb, &nesqp->pau_list);
+					nes_mgt_free_skb(nesdev, frags[i].skb, PCI_DMA_TODEVICE);
+				}
+				cb = (struct nes_rskb_cb *)&skb->cb[0];
+				frags[0].physaddr = cb->busaddr;
+				frags[0].physaddr += skb->data - cb->data_start;
+				frags[0].frag_len = skb->len;
+				frags[0].skb = skb;
+				frags[0].cmplt = true;
+				frag_cnt = 1;
+				break;
+			}
+
+			cb = (struct nes_rskb_cb *)&skb->cb[0];
+		}
+	} else {
+		/* no data */
+		frags[0].physaddr = cb->busaddr;
+		frags[0].frag_len = 0;
+		frags[0].skb = skb;
+		frags[0].cmplt = true;
+		frag_cnt = 1;
+	}
+
+	spin_unlock_irqrestore(&nesqp->pau_lock, flags);
+
+	/* Found one */
+	fpdu_info = kzalloc(sizeof(*fpdu_info), GFP_ATOMIC);
+	if (fpdu_info == NULL) {
+		nes_debug(NES_DBG_PAU, "Failed to alloc a fpdu_info.\n");
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	fpdu_info->cqp_request = nes_get_cqp_request(nesdev);
+	if (fpdu_info->cqp_request == NULL) {
+		nes_debug(NES_DBG_PAU, "Failed to get a cqp_request.\n");
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	cb = (struct nes_rskb_cb *)&frags[0].skb->cb[0];
+	iph = (struct iphdr *)(cb->data_start + ETH_HLEN);
+	tcph = (struct tcphdr *)(((char *)iph) + (4 * iph->ihl));
+	fpdu_info->hdr_len = (((unsigned char *)tcph) + 4 * (tcph->doff)) - cb->data_start;
+	fpdu_info->data_len = fpdu_len;
+	tot_len = fpdu_info->hdr_len + fpdu_len - ETH_HLEN;
+
+	if (frags[0].cmplt) {
+		fpdu_info->hdr_pbase = cb->busaddr;
+		fpdu_info->hdr_vbase = NULL;
+	} else {
+		fpdu_info->hdr_vbase = pci_alloc_consistent(nesdev->pcidev,
+							    fpdu_info->hdr_len, &fpdu_info->hdr_pbase);
+		if (!fpdu_info->hdr_vbase) {
+			nes_debug(NES_DBG_PAU, "Unable to allocate memory for pau first frag\n");
+			rc = -ENOMEM;
+			goto out;
+		}
+
+		/* Copy hdrs, adjusting len and seqnum */
+		memcpy(fpdu_info->hdr_vbase, cb->data_start, fpdu_info->hdr_len);
+		iph = (struct iphdr *)(fpdu_info->hdr_vbase + ETH_HLEN);
+		tcph = (struct tcphdr *)(((char *)iph) + (4 * iph->ihl));
+	}
+
+	iph->tot_len = cpu_to_be16(tot_len);
+	iph->saddr = cpu_to_be32(0x7f000001);
+
+	tcph->seq = cpu_to_be32(nesqp->pau_rcv_nxt);
+	tcph->ack_seq = cpu_to_be32(ack);
+	tcph->window = cpu_to_be16(wnd);
+
+	nesqp->pau_rcv_nxt += fpdu_len + fin_rcvd;
+
+	memcpy(fpdu_info->frags, frags, sizeof(fpdu_info->frags));
+	fpdu_info->frag_cnt = frag_cnt;
+	fpdu_info->nesqp = nesqp;
+	*pau_fpdu_info = fpdu_info;
+
+	/* Update skb's for next pass */
+	for (i = 0; i < frag_cnt; i++) {
+		cb = (struct nes_rskb_cb *)&frags[i].skb->cb[0];
+		skb_pull(frags[i].skb, frags[i].frag_len);
+
+		if (frags[i].skb->len == 0) {
+			/* Pull skb off the list - it will be freed in the callback */
+			spin_lock_irqsave(&nesqp->pau_lock, flags);
+			skb_unlink(frags[i].skb, &nesqp->pau_list);
+			spin_unlock_irqrestore(&nesqp->pau_lock, flags);
+		} else {
+			/* Last skb still has data so update the seq */
+			iph = (struct iphdr *)(cb->data_start + ETH_HLEN);
+			tcph = (struct tcphdr *)(((char *)iph) + (4 * iph->ihl));
+			tcph->seq = cpu_to_be32(nesqp->pau_rcv_nxt);
+		}
+	}
+
+out:
+	if (rc) {
+		if (fpdu_info) {
+			if (fpdu_info->cqp_request)
+				nes_put_cqp_request(nesdev, fpdu_info->cqp_request);
+			kfree(fpdu_info);
+		}
+	}
+	return rc;
+}
+
+/**
+ * forward_fpdu - send complete fpdus, one at a time
+ */
+int forward_fpdus(struct nes_vnic *nesvnic, struct nes_qp *nesqp)
+{
+	struct nes_device *nesdev = nesvnic->nesdev;
+	struct pau_fpdu_info *fpdu_info;
+	struct nes_hw_cqp_wqe *cqp_wqe;
+	struct nes_cqp_request *cqp_request;
+	u64 u64tmp;
+	u32 u32tmp;
+	int rc;
+
+	while (1) {
+		rc = get_fpdu_info(nesdev, nesqp, &fpdu_info);
+		if (fpdu_info == NULL)
+			return rc;
+
+		cqp_request = fpdu_info->cqp_request;
+		cqp_wqe = &cqp_request->cqp_wqe;
+		nes_fill_init_cqp_wqe(cqp_wqe, nesdev);
+		set_wqe_32bit_value(cqp_wqe->wqe_words, NES_CQP_WQE_DL_OPCODE_IDX,
+				    NES_CQP_DOWNLOAD_SEGMENT |
+				    (((u32)nesvnic->logical_port) << NES_CQP_OP_LOGICAL_PORT_SHIFT));
+
+		u32tmp = fpdu_info->hdr_len << 16;
+		u32tmp |= fpdu_info->hdr_len + (u32)fpdu_info->data_len;
+		set_wqe_32bit_value(cqp_wqe->wqe_words, NES_CQP_WQE_DL_LENGTH_0_TOTAL_IDX,
+				    cpu_to_le32(u32tmp));
+
+		u32tmp = (fpdu_info->frags[1].frag_len << 16) | fpdu_info->frags[0].frag_len;
+		set_wqe_32bit_value(cqp_wqe->wqe_words, NES_NIC_SQ_WQE_LENGTH_2_1_IDX,
+				    cpu_to_le32(u32tmp));
+
+		u32tmp = (fpdu_info->frags[3].frag_len << 16) | fpdu_info->frags[2].frag_len;
+		set_wqe_32bit_value(cqp_wqe->wqe_words, NES_NIC_SQ_WQE_LENGTH_4_3_IDX,
+				    cpu_to_le32(u32tmp));
+
+		u64tmp = (u64)fpdu_info->hdr_pbase;
+		set_wqe_32bit_value(cqp_wqe->wqe_words, NES_NIC_SQ_WQE_FRAG0_LOW_IDX,
+				    cpu_to_le32((u32)u64tmp));
+		set_wqe_32bit_value(cqp_wqe->wqe_words, NES_NIC_SQ_WQE_FRAG0_HIGH_IDX,
+				    cpu_to_le32((u32)(u64tmp >> 32)));
+
+		set_wqe_32bit_value(cqp_wqe->wqe_words, NES_NIC_SQ_WQE_FRAG1_LOW_IDX,
+				    cpu_to_le32((u32)fpdu_info->frags[0].physaddr));
+		set_wqe_32bit_value(cqp_wqe->wqe_words, NES_NIC_SQ_WQE_FRAG1_HIGH_IDX,
+				    cpu_to_le32((u32)(fpdu_info->frags[0].physaddr >> 32)));
+
+		set_wqe_32bit_value(cqp_wqe->wqe_words, NES_NIC_SQ_WQE_FRAG2_LOW_IDX,
+				    cpu_to_le32((u32)fpdu_info->frags[1].physaddr));
+		set_wqe_32bit_value(cqp_wqe->wqe_words, NES_NIC_SQ_WQE_FRAG2_HIGH_IDX,
+				    cpu_to_le32((u32)(fpdu_info->frags[1].physaddr >> 32)));
+
+		set_wqe_32bit_value(cqp_wqe->wqe_words, NES_NIC_SQ_WQE_FRAG3_LOW_IDX,
+				    cpu_to_le32((u32)fpdu_info->frags[2].physaddr));
+		set_wqe_32bit_value(cqp_wqe->wqe_words, NES_NIC_SQ_WQE_FRAG3_HIGH_IDX,
+				    cpu_to_le32((u32)(fpdu_info->frags[2].physaddr >> 32)));
+
+		set_wqe_32bit_value(cqp_wqe->wqe_words, NES_NIC_SQ_WQE_FRAG4_LOW_IDX,
+				    cpu_to_le32((u32)fpdu_info->frags[3].physaddr));
+		set_wqe_32bit_value(cqp_wqe->wqe_words, NES_NIC_SQ_WQE_FRAG4_HIGH_IDX,
+				    cpu_to_le32((u32)(fpdu_info->frags[3].physaddr >> 32)));
+
+		cqp_request->cqp_callback_pointer = fpdu_info;
+		cqp_request->callback = 1;
+		cqp_request->cqp_callback = nes_download_callback;
+
+		atomic_set(&cqp_request->refcount, 1);
+		nes_post_cqp_request(nesdev, cqp_request);
+	}
+
+	return 0;
+}
+
+void process_fpdus(struct nes_vnic *nesvnic, struct nes_qp *nesqp)
+{
+	int again = 1;
+	unsigned long flags;
+
+	do {
+		/* Ignore rc - if it failed, tcp retries will cause it to try again */
+		forward_fpdus(nesvnic, nesqp);
+
+		spin_lock_irqsave(&nesqp->pau_lock, flags);
+		if (nesqp->pau_pending) {
+			nesqp->pau_pending = 0;
+		} else {
+			nesqp->pau_busy = 0;
+			again = 0;
+		}
+
+		spin_unlock_irqrestore(&nesqp->pau_lock, flags);
+	} while (again);
+}
+
+/**
+ * queue_fpdus - Handle fpdu's that hw passed up to sw
+ */
+void queue_fpdus(struct sk_buff *skb, struct nes_vnic *nesvnic, struct nes_qp *nesqp)
+{
+	struct sk_buff *tmpskb;
+	struct nes_rskb_cb *cb;
+	struct iphdr *iph;
+	struct tcphdr *tcph;
+	unsigned char *tcph_end;
+	u32 rcv_nxt;
+	u32 rcv_wnd;
+	u32 seqnum;
+	u32 len;
+	bool process_it = false;
+	unsigned long flags;
+
+	/* Move data ptr to after tcp header */
+	iph = (struct iphdr *)skb->data;
+	tcph = (struct tcphdr *)(((char *)iph) + (4 * iph->ihl));
+	seqnum = be32_to_cpu(tcph->seq);
+	tcph_end = (((char *)tcph) + (4 * tcph->doff));
+
+	len = be16_to_cpu(iph->tot_len);
+	if (skb->len > len)
+		skb_trim(skb, len);
+	skb_pull(skb, tcph_end - skb->data);
+
+	/* Initialize tracking values */
+	cb = (struct nes_rskb_cb *)&skb->cb[0];
+	cb->seqnum = seqnum;
+
+	/* Make sure data is in the receive window */
+	rcv_nxt = nesqp->pau_rcv_nxt;
+	rcv_wnd = le32_to_cpu(nesqp->nesqp_context->rcv_wnd);
+	if (!between(seqnum, rcv_nxt, (rcv_nxt + rcv_wnd))) {
+		nes_mgt_free_skb(nesvnic->nesdev, skb, PCI_DMA_TODEVICE);
+		nes_rem_ref_cm_node(nesqp->cm_node);
+		return;
+	}
+
+	spin_lock_irqsave(&nesqp->pau_lock, flags);
+
+	if (nesqp->pau_busy)
+		nesqp->pau_pending = 1;
+	else
+		nesqp->pau_busy = 1;
+
+	/* Queue skb by sequence number */
+	if (skb_queue_len(&nesqp->pau_list) == 0) {
+		skb_queue_head(&nesqp->pau_list, skb);
+	} else {
+		tmpskb = nesqp->pau_list.next;
+		while (tmpskb != (struct sk_buff *)&nesqp->pau_list) {
+			cb = (struct nes_rskb_cb *)&tmpskb->cb[0];
+			if (before(seqnum, cb->seqnum))
+				break;
+			tmpskb = tmpskb->next;
+		}
+		skb_insert(tmpskb, skb, &nesqp->pau_list);
+	}
+	if (nesqp->pau_state == PAU_READY)
+		process_it = true;
+	spin_unlock_irqrestore(&nesqp->pau_lock, flags);
+
+	if (process_it)
+		process_fpdus(nesvnic, nesqp);
+
+	return;
+}
+
+/**
+ * mgt_thread - Handle mgt skbs in a safe context
+ */
+int mgt_thread(void *context)
+{
+	struct nes_vnic *nesvnic = context;
+	struct sk_buff *skb;
+	struct nes_rskb_cb *cb;
+
+	while (!kthread_should_stop()) {
+		wait_event_interruptible(nesvnic->mgt_wait_queue,
+					 skb_queue_len(&nesvnic->mgt_skb_list) || kthread_should_stop());
+		while ((skb_queue_len(&nesvnic->mgt_skb_list)) && !kthread_should_stop()) {
+			skb = skb_dequeue(&nesvnic->mgt_skb_list);
+			cb = (struct nes_rskb_cb *)&skb->cb[0];
+			cb->data_start = skb->data - ETH_HLEN;
+			cb->busaddr = pci_map_single(nesvnic->nesdev->pcidev, cb->data_start,
+						     nesvnic->max_frame_size, PCI_DMA_TODEVICE);
+			queue_fpdus(skb, nesvnic, cb->nesqp);
+		}
+	}
+
+	/* Closing down so delete any entries on the queue */
+	while (skb_queue_len(&nesvnic->mgt_skb_list)) {
+		skb = skb_dequeue(&nesvnic->mgt_skb_list);
+		cb = (struct nes_rskb_cb *)&skb->cb[0];
+		nes_rem_ref_cm_node(cb->nesqp->cm_node);
+		dev_kfree_skb_any(skb);
+	}
+	return 0;
+}
+
+/**
+ * nes_queue_skbs - Queue skb so it can be handled in a thread context
+ */
+void nes_queue_mgt_skbs(struct sk_buff *skb, struct nes_vnic *nesvnic, struct nes_qp *nesqp)
+{
+	struct nes_rskb_cb *cb;
+
+	cb = (struct nes_rskb_cb *)&skb->cb[0];
+	cb->nesqp = nesqp;
+	skb_queue_tail(&nesvnic->mgt_skb_list, skb);
+	wake_up_interruptible(&nesvnic->mgt_wait_queue);
+}
+
+void nes_destroy_pau_qp(struct nes_device *nesdev, struct nes_qp *nesqp)
+{
+	struct sk_buff *skb;
+	unsigned long flags;
+	atomic_inc(&pau_qps_destroyed);
+
+	/* Free packets that have not yet been forwarded */
+	/* Lock is acquired by skb_dequeue when removing the skb */
+	spin_lock_irqsave(&nesqp->pau_lock, flags);
+	while (skb_queue_len(&nesqp->pau_list)) {
+		skb = skb_dequeue(&nesqp->pau_list);
+		nes_mgt_free_skb(nesdev, skb, PCI_DMA_TODEVICE);
+		nes_rem_ref_cm_node(nesqp->cm_node);
+	}
+	spin_unlock_irqrestore(&nesqp->pau_lock, flags);
+}
+
+void nes_chg_qh_handler(struct nes_device *nesdev, struct nes_cqp_request *cqp_request)
+{
+	struct pau_qh_chg *qh_chg = cqp_request->cqp_callback_pointer;
+	struct nes_cqp_request *new_request;
+	struct nes_hw_cqp_wqe *cqp_wqe;
+	struct nes_adapter *nesadapter;
+	struct nes_qp *nesqp;
+	struct nes_v4_quad nes_quad;
+	u32 crc_value;
+	u64 u64temp;
+
+	nesadapter = nesdev->nesadapter;
+	nesqp = qh_chg->nesqp;
+
+	/* Should we handle the bad completion */
+	if (cqp_request->major_code) {
+		printk(KERN_ERR PFX "Invalid cqp_request major_code=0x%x\n",
+		       cqp_request->major_code);
+		WARN_ON(1);
+	}
+
+	switch (nesqp->pau_state) {
+	case PAU_DEL_QH:
+		/* Old hash code deleted, now set the new one */
+		nesqp->pau_state = PAU_ADD_LB_QH;
+		new_request = nes_get_cqp_request(nesdev);
+		if (new_request == NULL) {
+			nes_debug(NES_DBG_PAU, "Failed to get a new_request.\n");
+			WARN_ON(1);
+			return;
+		}
+
+		memset(&nes_quad, 0, sizeof(nes_quad));
+		nes_quad.DstIpAdrIndex =
+			cpu_to_le32((u32)PCI_FUNC(nesdev->pcidev->devfn) << 24);
+		nes_quad.SrcIpadr = cpu_to_be32(0x7f000001);
+		nes_quad.TcpPorts[0] = cpu_to_be16(nesqp->nesqp_context->tcpPorts[1]);
+		nes_quad.TcpPorts[1] = cpu_to_be16(nesqp->nesqp_context->tcpPorts[0]);
+
+		/* Produce hash key */
+		crc_value = get_crc_value(&nes_quad);
+		nesqp->hte_index = cpu_to_be32(crc_value ^ 0xffffffff);
+		nes_debug(NES_DBG_PAU, "new HTE Index = 0x%08X, CRC = 0x%08X\n",
+			  nesqp->hte_index, nesqp->hte_index & nesadapter->hte_index_mask);
+
+		nesqp->hte_index &= nesadapter->hte_index_mask;
+		nesqp->nesqp_context->hte_index = cpu_to_le32(nesqp->hte_index);
+		nesqp->nesqp_context->ip0 = cpu_to_le32(0x7f000001);
+		nesqp->nesqp_context->rcv_nxt = cpu_to_le32(nesqp->pau_rcv_nxt);
+
+		cqp_wqe = &new_request->cqp_wqe;
+		nes_fill_init_cqp_wqe(cqp_wqe, nesdev);
+		set_wqe_32bit_value(cqp_wqe->wqe_words,
+				    NES_CQP_WQE_OPCODE_IDX, NES_CQP_MANAGE_QUAD_HASH |
+				    NES_CQP_QP_TYPE_IWARP | NES_CQP_QP_CONTEXT_VALID | NES_CQP_QP_IWARP_STATE_RTS);
+		set_wqe_32bit_value(cqp_wqe->wqe_words, NES_CQP_WQE_ID_IDX, nesqp->hwqp.qp_id);
+		u64temp = (u64)nesqp->nesqp_context_pbase;
+		set_wqe_64bit_value(cqp_wqe->wqe_words, NES_CQP_QP_WQE_CONTEXT_LOW_IDX, u64temp);
+
+		nes_debug(NES_DBG_PAU, "Waiting for CQP completion for adding the quad hash.\n");
+
+		new_request->cqp_callback_pointer = qh_chg;
+		new_request->callback = 1;
+		new_request->cqp_callback = nes_chg_qh_handler;
+		atomic_set(&new_request->refcount, 1);
+		nes_post_cqp_request(nesdev, new_request);
+		break;
+
+	case PAU_ADD_LB_QH:
+		/* Start processing the queued fpdu's */
+		nesqp->pau_state = PAU_READY;
+		process_fpdus(qh_chg->nesvnic, qh_chg->nesqp);
+		kfree(qh_chg);
+		break;
+	}
+}
+
+/**
+ * nes_change_quad_hash
+ */
+int nes_change_quad_hash(struct nes_device *nesdev,
+			 struct nes_vnic *nesvnic, struct nes_qp *nesqp)
+{
+	struct nes_cqp_request *cqp_request = NULL;
+	struct pau_qh_chg *qh_chg = NULL;
+	u64 u64temp;
+	struct nes_hw_cqp_wqe *cqp_wqe;
+	int ret = 0;
+
+	cqp_request = nes_get_cqp_request(nesdev);
+	if (cqp_request == NULL) {
+		nes_debug(NES_DBG_PAU, "Failed to get a cqp_request.\n");
+		ret = -ENOMEM;
+		goto chg_qh_err;
+	}
+
+	qh_chg = kmalloc(sizeof *qh_chg, GFP_ATOMIC);
+	if (qh_chg == NULL) {
+		nes_debug(NES_DBG_PAU, "Failed to get a cqp_request.\n");
+		ret = -ENOMEM;
+		goto chg_qh_err;
+	}
+	qh_chg->nesdev = nesdev;
+	qh_chg->nesvnic = nesvnic;
+	qh_chg->nesqp = nesqp;
+	nesqp->pau_state = PAU_DEL_QH;
+
+	cqp_wqe = &cqp_request->cqp_wqe;
+	nes_fill_init_cqp_wqe(cqp_wqe, nesdev);
+	set_wqe_32bit_value(cqp_wqe->wqe_words,
+			    NES_CQP_WQE_OPCODE_IDX, NES_CQP_MANAGE_QUAD_HASH | NES_CQP_QP_DEL_HTE |
+			    NES_CQP_QP_TYPE_IWARP | NES_CQP_QP_CONTEXT_VALID | NES_CQP_QP_IWARP_STATE_RTS);
+	set_wqe_32bit_value(cqp_wqe->wqe_words, NES_CQP_WQE_ID_IDX, nesqp->hwqp.qp_id);
+	u64temp = (u64)nesqp->nesqp_context_pbase;
+	set_wqe_64bit_value(cqp_wqe->wqe_words, NES_CQP_QP_WQE_CONTEXT_LOW_IDX, u64temp);
+
+	nes_debug(NES_DBG_PAU, "Waiting for CQP completion for deleting the quad hash.\n");
+
+	cqp_request->cqp_callback_pointer = qh_chg;
+	cqp_request->callback = 1;
+	cqp_request->cqp_callback = nes_chg_qh_handler;
+	atomic_set(&cqp_request->refcount, 1);
+	nes_post_cqp_request(nesdev, cqp_request);
+
+	return ret;
+
+chg_qh_err:
+	kfree(qh_chg);
+	if (cqp_request)
+		nes_put_cqp_request(nesdev, cqp_request);
+	return ret;
+}
+
+/**
+ * nes_mgt_ce_handler
+ * This management code deals with any packed and unaligned (pau) fpdu's
+ * that the hardware cannot handle.
+ */
+void nes_mgt_ce_handler(struct nes_device *nesdev, struct nes_hw_nic_cq *cq)
+{
+	struct nes_vnic_mgt *mgtvnic = container_of(cq, struct nes_vnic_mgt, mgt_cq);
+	struct nes_adapter *nesadapter = nesdev->nesadapter;
+	u32 head;
+	u32 cq_size;
+	u32 cqe_count = 0;
+	u32 cqe_misc;
+	u32 qp_id = 0;
+	u32 skbs_needed;
+	unsigned long context;
+	struct nes_qp *nesqp;
+	struct sk_buff *rx_skb;
+	struct nes_rskb_cb *cb;
+
+	head = cq->cq_head;
+	cq_size = cq->cq_size;
+
+	while (1) {
+		cqe_misc = le32_to_cpu(cq->cq_vbase[head].cqe_words[NES_NIC_CQE_MISC_IDX]);
+		if (!(cqe_misc & NES_NIC_CQE_VALID))
+			break;
+
+		nesqp = NULL;
+		if (cqe_misc & NES_NIC_CQE_ACCQP_VALID) {
+			qp_id = le32_to_cpu(cq->cq_vbase[head].cqe_words[NES_NIC_CQE_ACCQP_ID_IDX]);
+			qp_id &= 0x001fffff;
+			if (qp_id < nesadapter->max_qp) {
+				context = (unsigned long)nesadapter->qp_table[qp_id - NES_FIRST_QPN];
+				nesqp = (struct nes_qp *)context;
+			}
+		}
+
+		if (nesqp) {
+			if (nesqp->pau_mode == false) {
+				nesqp->pau_mode = true; /* First time for this qp */
+				nesqp->pau_rcv_nxt = le32_to_cpu(
+					cq->cq_vbase[head].cqe_words[NES_NIC_CQE_HASH_RCVNXT]);
+				skb_queue_head_init(&nesqp->pau_list);
+				spin_lock_init(&nesqp->pau_lock);
+				atomic_inc(&pau_qps_created);
+				nes_change_quad_hash(nesdev, mgtvnic->nesvnic, nesqp);
+			}
+
+			rx_skb = mgtvnic->mgt.rx_skb[mgtvnic->mgt.rq_tail];
+			rx_skb->len = 0;
+			skb_put(rx_skb, cqe_misc & 0x0000ffff);
+			rx_skb->protocol = eth_type_trans(rx_skb, mgtvnic->nesvnic->netdev);
+			cb = (struct nes_rskb_cb *)&rx_skb->cb[0];
+			pci_unmap_single(nesdev->pcidev, cb->busaddr, cb->maplen, PCI_DMA_FROMDEVICE);
+			cb->busaddr = 0;
+			mgtvnic->mgt.rq_tail++;
+			mgtvnic->mgt.rq_tail &= mgtvnic->mgt.rq_size - 1;
+
+			nes_add_ref_cm_node(nesqp->cm_node);
+			nes_queue_mgt_skbs(rx_skb, mgtvnic->nesvnic, nesqp);
+		} else {
+			printk(KERN_ERR PFX "Invalid QP %d for packed/unaligned handling\n", qp_id);
+		}
+
+		cq->cq_vbase[head].cqe_words[NES_NIC_CQE_MISC_IDX] = 0;
+		cqe_count++;
+		if (++head >= cq_size)
+			head = 0;
+
+		if (cqe_count == 255) {
+			/* Replenish mgt CQ */
+			nes_write32(nesdev->regs + NES_CQE_ALLOC, cq->cq_number | (cqe_count << 16));
+			nesdev->currcq_count += cqe_count;
+			cqe_count = 0;
+		}
+
+		skbs_needed = atomic_inc_return(&mgtvnic->rx_skbs_needed);
+		if (skbs_needed > (mgtvnic->mgt.rq_size >> 1))
+			nes_replenish_mgt_rq(mgtvnic);
+	}
+
+	cq->cq_head = head;
+	nes_write32(nesdev->regs + NES_CQE_ALLOC, NES_CQE_ALLOC_NOTIFY_NEXT |
+		    cq->cq_number | (cqe_count << 16));
+	nes_read32(nesdev->regs + NES_CQE_ALLOC);
+	nesdev->currcq_count += cqe_count;
+}
+
+/**
+ * nes_init_mgt_qp
+ */
+int nes_init_mgt_qp(struct nes_device *nesdev, struct net_device *netdev, struct nes_vnic *nesvnic)
+{
+	struct nes_vnic_mgt *mgtvnic;
+	u32 counter;
+	void *vmem;
+	dma_addr_t pmem;
+	struct nes_hw_cqp_wqe *cqp_wqe;
+	u32 cqp_head;
+	unsigned long flags;
+	struct nes_hw_nic_qp_context *mgt_context;
+	u64 u64temp;
+	struct nes_hw_nic_rq_wqe *mgt_rqe;
+	struct sk_buff *skb;
+	u32 wqe_count;
+	struct nes_rskb_cb *cb;
+	u32 mgt_mem_size;
+	void *mgt_vbase;
+	dma_addr_t mgt_pbase;
+	int i;
+	int ret;
+
+	/* Allocate space the all mgt QPs once */
+	mgtvnic = kzalloc(NES_MGT_QP_COUNT * sizeof(struct nes_vnic_mgt), GFP_KERNEL);
+	if (mgtvnic == NULL) {
+		nes_debug(NES_DBG_INIT, "Unable to allocate memory for mgt structure\n");
+		return -ENOMEM;
+	}
+
+	/* Allocate fragment, RQ, and CQ; Reuse CEQ based on the PCI function */
+	/* We are not sending from this NIC so sq is not allocated */
+	mgt_mem_size = 256 +
+		       (NES_MGT_WQ_COUNT * sizeof(struct nes_hw_nic_rq_wqe)) +
+		       (NES_MGT_WQ_COUNT * sizeof(struct nes_hw_nic_cqe)) +
+		       sizeof(struct nes_hw_nic_qp_context);
+	mgt_mem_size = (mgt_mem_size + PAGE_SIZE - 1) & ~(PAGE_SIZE - 1);
+	mgt_vbase = pci_alloc_consistent(nesdev->pcidev, NES_MGT_QP_COUNT * mgt_mem_size, &mgt_pbase);
+	if (!mgt_vbase) {
+		kfree(mgtvnic);
+		nes_debug(NES_DBG_INIT, "Unable to allocate memory for mgt host descriptor rings\n");
+		return -ENOMEM;
+	}
+
+	nesvnic->mgt_mem_size = NES_MGT_QP_COUNT * mgt_mem_size;
+	nesvnic->mgt_vbase = mgt_vbase;
+	nesvnic->mgt_pbase = mgt_pbase;
+
+	skb_queue_head_init(&nesvnic->mgt_skb_list);
+	init_waitqueue_head(&nesvnic->mgt_wait_queue);
+	nesvnic->mgt_thread = kthread_run(mgt_thread, nesvnic, "nes_mgt_thread");
+
+	for (i = 0; i < NES_MGT_QP_COUNT; i++) {
+		mgtvnic->nesvnic = nesvnic;
+		mgtvnic->mgt.qp_id = nesdev->mac_index + NES_MGT_QP_OFFSET + i;
+		memset(mgt_vbase, 0, mgt_mem_size);
+		nes_debug(NES_DBG_INIT, "Allocated mgt QP structures at %p (phys = %016lX), size = %u.\n",
+			  mgt_vbase, (unsigned long)mgt_pbase, mgt_mem_size);
+
+		vmem = (void *)(((unsigned long)mgt_vbase + (256 - 1)) &
+				~(unsigned long)(256 - 1));
+		pmem = (dma_addr_t)(((unsigned long long)mgt_pbase + (256 - 1)) &
+				    ~(unsigned long long)(256 - 1));
+
+		spin_lock_init(&mgtvnic->mgt.rq_lock);
+
+		/* setup the RQ */
+		mgtvnic->mgt.rq_vbase = vmem;
+		mgtvnic->mgt.rq_pbase = pmem;
+		mgtvnic->mgt.rq_head = 0;
+		mgtvnic->mgt.rq_tail = 0;
+		mgtvnic->mgt.rq_size = NES_MGT_WQ_COUNT;
+
+		/* setup the CQ */
+		vmem += (NES_MGT_WQ_COUNT * sizeof(struct nes_hw_nic_rq_wqe));
+		pmem += (NES_MGT_WQ_COUNT * sizeof(struct nes_hw_nic_rq_wqe));
+
+		mgtvnic->mgt_cq.cq_number = mgtvnic->mgt.qp_id;
+		mgtvnic->mgt_cq.cq_vbase = vmem;
+		mgtvnic->mgt_cq.cq_pbase = pmem;
+		mgtvnic->mgt_cq.cq_head = 0;
+		mgtvnic->mgt_cq.cq_size = NES_MGT_WQ_COUNT;
+
+		mgtvnic->mgt_cq.ce_handler = nes_mgt_ce_handler;
+
+		/* Send CreateCQ request to CQP */
+		spin_lock_irqsave(&nesdev->cqp.lock, flags);
+		cqp_head = nesdev->cqp.sq_head;
+
+		cqp_wqe = &nesdev->cqp.sq_vbase[cqp_head];
+		nes_fill_init_cqp_wqe(cqp_wqe, nesdev);
+
+		cqp_wqe->wqe_words[NES_CQP_WQE_OPCODE_IDX] = cpu_to_le32(
+			NES_CQP_CREATE_CQ | NES_CQP_CQ_CEQ_VALID |
+			((u32)mgtvnic->mgt_cq.cq_size << 16));
+		cqp_wqe->wqe_words[NES_CQP_WQE_ID_IDX] = cpu_to_le32(
+			mgtvnic->mgt_cq.cq_number | ((u32)nesdev->ceq_index << 16));
+		u64temp = (u64)mgtvnic->mgt_cq.cq_pbase;
+		set_wqe_64bit_value(cqp_wqe->wqe_words, NES_CQP_CQ_WQE_PBL_LOW_IDX, u64temp);
+		cqp_wqe->wqe_words[NES_CQP_CQ_WQE_CQ_CONTEXT_HIGH_IDX] = 0;
+		u64temp = (unsigned long)&mgtvnic->mgt_cq;
+		cqp_wqe->wqe_words[NES_CQP_CQ_WQE_CQ_CONTEXT_LOW_IDX] = cpu_to_le32((u32)(u64temp >> 1));
+		cqp_wqe->wqe_words[NES_CQP_CQ_WQE_CQ_CONTEXT_HIGH_IDX] =
+			cpu_to_le32(((u32)((u64temp) >> 33)) & 0x7FFFFFFF);
+		cqp_wqe->wqe_words[NES_CQP_CQ_WQE_DOORBELL_INDEX_HIGH_IDX] = 0;
+
+		if (++cqp_head >= nesdev->cqp.sq_size)
+			cqp_head = 0;
+		cqp_wqe = &nesdev->cqp.sq_vbase[cqp_head];
+		nes_fill_init_cqp_wqe(cqp_wqe, nesdev);
+
+		/* Send CreateQP request to CQP */
+		mgt_context = (void *)(&mgtvnic->mgt_cq.cq_vbase[mgtvnic->mgt_cq.cq_size]);
+		mgt_context->context_words[NES_NIC_CTX_MISC_IDX] =
+			cpu_to_le32((u32)NES_MGT_CTX_SIZE |
+				    ((u32)PCI_FUNC(nesdev->pcidev->devfn) << 12));
+		nes_debug(NES_DBG_INIT, "RX_WINDOW_BUFFER_PAGE_TABLE_SIZE = 0x%08X, RX_WINDOW_BUFFER_SIZE = 0x%08X\n",
+			  nes_read_indexed(nesdev, NES_IDX_RX_WINDOW_BUFFER_PAGE_TABLE_SIZE),
+			  nes_read_indexed(nesdev, NES_IDX_RX_WINDOW_BUFFER_SIZE));
+		if (nes_read_indexed(nesdev, NES_IDX_RX_WINDOW_BUFFER_SIZE) != 0)
+			mgt_context->context_words[NES_NIC_CTX_MISC_IDX] |= cpu_to_le32(NES_NIC_BACK_STORE);
+
+		u64temp = (u64)mgtvnic->mgt.rq_pbase;
+		mgt_context->context_words[NES_NIC_CTX_SQ_LOW_IDX] = cpu_to_le32((u32)u64temp);
+		mgt_context->context_words[NES_NIC_CTX_SQ_HIGH_IDX] = cpu_to_le32((u32)(u64temp >> 32));
+		u64temp = (u64)mgtvnic->mgt.rq_pbase;
+		mgt_context->context_words[NES_NIC_CTX_RQ_LOW_IDX] = cpu_to_le32((u32)u64temp);
+		mgt_context->context_words[NES_NIC_CTX_RQ_HIGH_IDX] = cpu_to_le32((u32)(u64temp >> 32));
+
+		cqp_wqe->wqe_words[NES_CQP_WQE_OPCODE_IDX] = cpu_to_le32(NES_CQP_CREATE_QP |
+									 NES_CQP_QP_TYPE_NIC);
+		cqp_wqe->wqe_words[NES_CQP_WQE_ID_IDX] = cpu_to_le32(mgtvnic->mgt.qp_id);
+		u64temp = (u64)mgtvnic->mgt_cq.cq_pbase +
+			  (mgtvnic->mgt_cq.cq_size * sizeof(struct nes_hw_nic_cqe));
+		set_wqe_64bit_value(cqp_wqe->wqe_words, NES_CQP_QP_WQE_CONTEXT_LOW_IDX, u64temp);
+
+		if (++cqp_head >= nesdev->cqp.sq_size)
+			cqp_head = 0;
+		nesdev->cqp.sq_head = cqp_head;
+
+		barrier();
+
+		/* Ring doorbell (2 WQEs) */
+		nes_write32(nesdev->regs + NES_WQE_ALLOC, 0x02800000 | nesdev->cqp.qp_id);
+
+		spin_unlock_irqrestore(&nesdev->cqp.lock, flags);
+		nes_debug(NES_DBG_INIT, "Waiting for create MGT QP%u to complete.\n",
+			  mgtvnic->mgt.qp_id);
+
+		ret = wait_event_timeout(nesdev->cqp.waitq, (nesdev->cqp.sq_tail == cqp_head),
+					 NES_EVENT_TIMEOUT);
+		nes_debug(NES_DBG_INIT, "Create MGT QP%u completed, wait_event_timeout ret = %u.\n",
+			  mgtvnic->mgt.qp_id, ret);
+		if (!ret) {
+			nes_debug(NES_DBG_INIT, "MGT QP%u create timeout expired\n", mgtvnic->mgt.qp_id);
+			if (i == 0) {
+				pci_free_consistent(nesdev->pcidev, nesvnic->mgt_mem_size, nesvnic->mgt_vbase,
+						    nesvnic->mgt_pbase);
+				kfree(mgtvnic);
+			} else {
+				nes_destroy_mgt(nesvnic);
+			}
+			return -EIO;
+		}
+
+		/* Populate the RQ */
+		for (counter = 0; counter < (NES_MGT_WQ_COUNT - 1); counter++) {
+			skb = dev_alloc_skb(nesvnic->max_frame_size);
+			if (!skb) {
+				nes_debug(NES_DBG_INIT, "%s: out of memory for receive skb\n", netdev->name);
+				return -ENOMEM;
+			}
+
+			skb->dev = netdev;
+
+			pmem = pci_map_single(nesdev->pcidev, skb->data,
+					      nesvnic->max_frame_size, PCI_DMA_FROMDEVICE);
+			cb = (struct nes_rskb_cb *)&skb->cb[0];
+			cb->busaddr = pmem;
+			cb->maplen = nesvnic->max_frame_size;
+
+			mgt_rqe = &mgtvnic->mgt.rq_vbase[counter];
+			mgt_rqe->wqe_words[NES_NIC_RQ_WQE_LENGTH_1_0_IDX] = cpu_to_le32((u32)nesvnic->max_frame_size);
+			mgt_rqe->wqe_words[NES_NIC_RQ_WQE_LENGTH_3_2_IDX] = 0;
+			mgt_rqe->wqe_words[NES_NIC_RQ_WQE_FRAG0_LOW_IDX] = cpu_to_le32((u32)pmem);
+			mgt_rqe->wqe_words[NES_NIC_RQ_WQE_FRAG0_HIGH_IDX] = cpu_to_le32((u32)((u64)pmem >> 32));
+			mgtvnic->mgt.rx_skb[counter] = skb;
+		}
+
+		init_timer(&mgtvnic->rq_wqes_timer);
+		mgtvnic->rq_wqes_timer.function = nes_mgt_rq_wqes_timeout;
+		mgtvnic->rq_wqes_timer.data = (unsigned long)mgtvnic;
+
+		wqe_count = NES_MGT_WQ_COUNT - 1;
+		mgtvnic->mgt.rq_head = wqe_count;
+		barrier();
+		do {
+			counter = min(wqe_count, ((u32)255));
+			wqe_count -= counter;
+			nes_write32(nesdev->regs + NES_WQE_ALLOC, (counter << 24) | mgtvnic->mgt.qp_id);
+		} while (wqe_count);
+
+		nes_write32(nesdev->regs + NES_CQE_ALLOC, NES_CQE_ALLOC_NOTIFY_NEXT |
+			    mgtvnic->mgt_cq.cq_number);
+		nes_read32(nesdev->regs + NES_CQE_ALLOC);
+
+		mgt_vbase += mgt_mem_size;
+		mgt_pbase += mgt_mem_size;
+		nesvnic->mgtvnic[i] = mgtvnic++;
+	}
+	return 0;
+}
+
+
+void nes_destroy_mgt(struct nes_vnic *nesvnic)
+{
+	struct nes_device *nesdev = nesvnic->nesdev;
+	struct nes_vnic_mgt *mgtvnic;
+	struct nes_vnic_mgt *first_mgtvnic;
+	unsigned long flags;
+	struct nes_hw_cqp_wqe *cqp_wqe;
+	u32 cqp_head;
+	struct sk_buff *rx_skb;
+	int i;
+	int ret;
+
+	kthread_stop(nesvnic->mgt_thread);
+
+	/* Free remaining NIC receive buffers */
+	first_mgtvnic = nesvnic->mgtvnic[0];
+	for (i = 0; i < NES_MGT_QP_COUNT; i++) {
+		mgtvnic = nesvnic->mgtvnic[i];
+		if (mgtvnic == NULL)
+			continue;
+
+		while (mgtvnic->mgt.rq_head != mgtvnic->mgt.rq_tail) {
+			rx_skb = mgtvnic->mgt.rx_skb[mgtvnic->mgt.rq_tail];
+			nes_mgt_free_skb(nesdev, rx_skb, PCI_DMA_FROMDEVICE);
+			mgtvnic->mgt.rq_tail++;
+			mgtvnic->mgt.rq_tail &= (mgtvnic->mgt.rq_size - 1);
+		}
+
+		spin_lock_irqsave(&nesdev->cqp.lock, flags);
+
+		/* Destroy NIC QP */
+		cqp_head = nesdev->cqp.sq_head;
+		cqp_wqe = &nesdev->cqp.sq_vbase[cqp_head];
+		nes_fill_init_cqp_wqe(cqp_wqe, nesdev);
+
+		set_wqe_32bit_value(cqp_wqe->wqe_words, NES_CQP_WQE_OPCODE_IDX,
+				    (NES_CQP_DESTROY_QP | NES_CQP_QP_TYPE_NIC));
+		set_wqe_32bit_value(cqp_wqe->wqe_words, NES_CQP_WQE_ID_IDX,
+				    mgtvnic->mgt.qp_id);
+
+		if (++cqp_head >= nesdev->cqp.sq_size)
+			cqp_head = 0;
+
+		cqp_wqe = &nesdev->cqp.sq_vbase[cqp_head];
+
+		/* Destroy NIC CQ */
+		nes_fill_init_cqp_wqe(cqp_wqe, nesdev);
+		set_wqe_32bit_value(cqp_wqe->wqe_words, NES_CQP_WQE_OPCODE_IDX,
+				    (NES_CQP_DESTROY_CQ | ((u32)mgtvnic->mgt_cq.cq_size << 16)));
+		set_wqe_32bit_value(cqp_wqe->wqe_words, NES_CQP_WQE_ID_IDX,
+				    (mgtvnic->mgt_cq.cq_number | ((u32)nesdev->ceq_index << 16)));
+
+		if (++cqp_head >= nesdev->cqp.sq_size)
+			cqp_head = 0;
+
+		nesdev->cqp.sq_head = cqp_head;
+		barrier();
+
+		/* Ring doorbell (2 WQEs) */
+		nes_write32(nesdev->regs + NES_WQE_ALLOC, 0x02800000 | nesdev->cqp.qp_id);
+
+		spin_unlock_irqrestore(&nesdev->cqp.lock, flags);
+		nes_debug(NES_DBG_SHUTDOWN, "Waiting for CQP, cqp_head=%u, cqp.sq_head=%u,"
+			  " cqp.sq_tail=%u, cqp.sq_size=%u\n",
+			  cqp_head, nesdev->cqp.sq_head,
+			  nesdev->cqp.sq_tail, nesdev->cqp.sq_size);
+
+		ret = wait_event_timeout(nesdev->cqp.waitq, (nesdev->cqp.sq_tail == cqp_head),
+					 NES_EVENT_TIMEOUT);
+
+		nes_debug(NES_DBG_SHUTDOWN, "Destroy MGT QP returned, wait_event_timeout ret = %u, cqp_head=%u,"
+			  " cqp.sq_head=%u, cqp.sq_tail=%u\n",
+			  ret, cqp_head, nesdev->cqp.sq_head, nesdev->cqp.sq_tail);
+		if (!ret)
+			nes_debug(NES_DBG_SHUTDOWN, "MGT QP%u destroy timeout expired\n",
+				  mgtvnic->mgt.qp_id);
+
+		nesvnic->mgtvnic[i] = NULL;
+	}
+
+	if (nesvnic->mgt_vbase) {
+		pci_free_consistent(nesdev->pcidev, nesvnic->mgt_mem_size, nesvnic->mgt_vbase,
+				    nesvnic->mgt_pbase);
+		nesvnic->mgt_vbase = NULL;
+		nesvnic->mgt_pbase = 0;
+	}
+
+	kfree(first_mgtvnic);
+}
diff --git a/drivers/infiniband/hw/nes/nes_mgt.h b/drivers/infiniband/hw/nes/nes_mgt.h
new file mode 100644
index 0000000..8c8af25
--- /dev/null
+++ b/drivers/infiniband/hw/nes/nes_mgt.h
@@ -0,0 +1,97 @@
+/*
+* Copyright (c) 2010 Intel-NE, Inc.  All rights reserved.
+*
+* This software is available to you under a choice of one of two
+* licenses.  You may choose to be licensed under the terms of the GNU
+* General Public License (GPL) Version 2, available from the file
+* COPYING in the main directory of this source tree, or the
+* OpenIB.org BSD license below:
+*
+*     Redistribution and use in source and binary forms, with or
+*     without modification, are permitted provided that the following
+*     conditions are met:
+*
+*      - Redistributions of source code must retain the above
+*        copyright notice, this list of conditions and the following
+*        disclaimer.
+*
+*      - Redistributions in binary form must reproduce the above
+*        copyright notice, this list of conditions and the following
+*        disclaimer in the documentation and/or other materials
+*        provided with the distribution.
+*
+* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+* BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+* ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+* CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+* SOFTWARE.
+*/
+
+#ifndef __NES_MGT_H
+#define __NES_MGT_H
+
+#define MPA_FRAMING 6	/* length is 2 bytes, crc is 4 bytes */
+
+int nes_init_mgt_qp(struct nes_device *nesdev, struct net_device *netdev, struct nes_vnic *nesvnic);
+void nes_queue_mgt_skbs(struct sk_buff *skb, struct nes_vnic *nesvnic, struct nes_qp *nesqp);
+void nes_destroy_mgt(struct nes_vnic *nesvnic);
+void nes_destroy_pau_qp(struct nes_device *nesdev, struct nes_qp *nesqp);
+
+struct nes_hw_mgt {
+	struct nes_hw_nic_rq_wqe *rq_vbase;	/* virtual address of rq */
+	dma_addr_t rq_pbase;			/* PCI memory for host rings */
+	struct sk_buff *rx_skb[NES_NIC_WQ_SIZE];
+	u16 qp_id;
+	u16 sq_head;
+	u16 rq_head;
+	u16 rq_tail;
+	u16 rq_size;
+	u8 replenishing_rq;
+	u8 reserved;
+	spinlock_t rq_lock;
+};
+
+struct nes_vnic_mgt {
+	struct nes_vnic        *nesvnic;
+	struct nes_hw_mgt      mgt;
+	struct nes_hw_nic_cq   mgt_cq;
+	atomic_t               rx_skbs_needed;
+	struct timer_list      rq_wqes_timer;
+	atomic_t               rx_skb_timer_running;
+};
+
+#define MAX_FPDU_FRAGS 4
+struct pau_fpdu_frag {
+	struct sk_buff         *skb;
+	u64                    physaddr;
+	u32                    frag_len;
+	bool                   cmplt;
+};
+
+struct pau_fpdu_info {
+	struct nes_qp          *nesqp;
+	struct nes_cqp_request *cqp_request;
+	void                   *hdr_vbase;
+	dma_addr_t             hdr_pbase;
+	int                    hdr_len;
+	u16                    data_len;
+	u16                    frag_cnt;
+	struct pau_fpdu_frag   frags[MAX_FPDU_FRAGS];
+};
+
+enum pau_qh_state {
+	PAU_DEL_QH,
+	PAU_ADD_LB_QH,
+	PAU_READY
+};
+
+struct pau_qh_chg {
+	struct nes_device *nesdev;
+	struct nes_vnic *nesvnic;
+	struct nes_qp *nesqp;
+};
+
+#endif          /* __NES_MGT_H */
diff --git a/drivers/infiniband/hw/nes/nes_nic.c b/drivers/infiniband/hw/nes/nes_nic.c
index 9d7ffeb..64f91d8 100644
--- a/drivers/infiniband/hw/nes/nes_nic.c
+++ b/drivers/infiniband/hw/nes/nes_nic.c
@@ -1090,6 +1090,8 @@ static const char nes_ethtool_stringset[][ETH_GSTRING_LEN] = {
 	"LRO aggregated",
 	"LRO flushed",
 	"LRO no_desc",
+	"PAU CreateQPs",
+	"PAU DestroyQPs",
 };
 #define NES_ETHTOOL_STAT_COUNT  ARRAY_SIZE(nes_ethtool_stringset)
 
@@ -1305,6 +1307,8 @@ static void nes_netdev_get_ethtool_stats(struct net_device *netdev,
 	target_stat_values[++index] = nesvnic->lro_mgr.stats.aggregated;
 	target_stat_values[++index] = nesvnic->lro_mgr.stats.flushed;
 	target_stat_values[++index] = nesvnic->lro_mgr.stats.no_desc;
+	target_stat_values[++index] = atomic_read(&pau_qps_created);
+	target_stat_values[++index] = atomic_read(&pau_qps_destroyed);
 }
 
 /**
diff --git a/drivers/infiniband/hw/nes/nes_utils.c b/drivers/infiniband/hw/nes/nes_utils.c
index f9c417c..cd10968 100644
--- a/drivers/infiniband/hw/nes/nes_utils.c
+++ b/drivers/infiniband/hw/nes/nes_utils.c
@@ -51,13 +51,34 @@
 
 #include "nes.h"
 
-
-
 static u16 nes_read16_eeprom(void __iomem *addr, u16 offset);
 
 u32 mh_detected;
 u32 mh_pauses_sent;
 
+u32 nes_set_pau(struct nes_device *nesdev)
+{
+	u32 ret = 0;
+	u32 counter;
+
+	nes_write_indexed(nesdev, NES_IDX_GPR2, NES_ENABLE_PAU);
+	nes_write_indexed(nesdev, NES_IDX_GPR_TRIGGER, 1);
+
+	for (counter = 0; counter < NES_PAU_COUNTER; counter++) {
+		udelay(30);
+		if (!nes_read_indexed(nesdev, NES_IDX_GPR2)) {
+			printk(KERN_INFO PFX "PAU is supported.\n");
+			break;
+		}
+		nes_write_indexed(nesdev, NES_IDX_GPR_TRIGGER, 1);
+	}
+	if (counter == NES_PAU_COUNTER) {
+		printk(KERN_INFO PFX "PAU is not supported.\n");
+		return -EPERM;
+	}
+	return ret;
+}
+
 /**
  * nes_read_eeprom_values -
  */
@@ -187,6 +208,11 @@ int nes_read_eeprom_values(struct nes_device *nesdev, struct nes_adapter *nesada
 		if (((major_ver == 3) && (minor_ver >= 16)) || (major_ver > 3))
 			nesadapter->send_term_ok = 1;
 
+		if (nes_drv_opt & NES_DRV_OPT_ENABLE_PAU) {
+			if (!nes_set_pau(nesdev))
+				nesadapter->allow_unaligned_fpdus = 1;
+		}
+
 		nesadapter->firmware_version = (((u32)(u8)(eeprom_data>>8))  <<  16) +
 				(u32)((u8)eeprom_data);
 
@@ -594,6 +620,7 @@ void nes_put_cqp_request(struct nes_device *nesdev,
 		nes_free_cqp_request(nesdev, cqp_request);
 }
 
+
 /**
  * nes_post_cqp_request
  */
@@ -604,6 +631,8 @@ void nes_post_cqp_request(struct nes_device *nesdev,
 	unsigned long flags;
 	u32 cqp_head;
 	u64 u64temp;
+	u32 opcode;
+	int ctx_index = NES_CQP_WQE_COMP_CTX_LOW_IDX;
 
 	spin_lock_irqsave(&nesdev->cqp.lock, flags);
 
@@ -614,17 +643,20 @@ void nes_post_cqp_request(struct nes_device *nesdev,
 		nesdev->cqp.sq_head &= nesdev->cqp.sq_size-1;
 		cqp_wqe = &nesdev->cqp.sq_vbase[cqp_head];
 		memcpy(cqp_wqe, &cqp_request->cqp_wqe, sizeof(*cqp_wqe));
+		opcode = le32_to_cpu(cqp_wqe->wqe_words[NES_CQP_WQE_OPCODE_IDX]);
+		if ((opcode & NES_CQP_OPCODE_MASK) == NES_CQP_DOWNLOAD_SEGMENT)
+			ctx_index = NES_CQP_WQE_DL_COMP_CTX_LOW_IDX;
 		barrier();
 		u64temp = (unsigned long)cqp_request;
-		set_wqe_64bit_value(cqp_wqe->wqe_words, NES_CQP_WQE_COMP_SCRATCH_LOW_IDX,
-				    u64temp);
+		set_wqe_64bit_value(cqp_wqe->wqe_words, ctx_index, u64temp);
 		nes_debug(NES_DBG_CQP, "CQP request (opcode 0x%02X), line 1 = 0x%08X put on CQPs SQ,"
-				" request = %p, cqp_head = %u, cqp_tail = %u, cqp_size = %u,"
-				" waiting = %d, refcount = %d.\n",
-				le32_to_cpu(cqp_wqe->wqe_words[NES_CQP_WQE_OPCODE_IDX])&0x3f,
-				le32_to_cpu(cqp_wqe->wqe_words[NES_CQP_WQE_ID_IDX]), cqp_request,
-				nesdev->cqp.sq_head, nesdev->cqp.sq_tail, nesdev->cqp.sq_size,
-				cqp_request->waiting, atomic_read(&cqp_request->refcount));
+			" request = %p, cqp_head = %u, cqp_tail = %u, cqp_size = %u,"
+			" waiting = %d, refcount = %d.\n",
+			opcode & NES_CQP_OPCODE_MASK,
+			le32_to_cpu(cqp_wqe->wqe_words[NES_CQP_WQE_ID_IDX]), cqp_request,
+			nesdev->cqp.sq_head, nesdev->cqp.sq_tail, nesdev->cqp.sq_size,
+			cqp_request->waiting, atomic_read(&cqp_request->refcount));
+
 		barrier();
 
 		/* Ring doorbell (1 WQEs) */
@@ -645,7 +677,6 @@ void nes_post_cqp_request(struct nes_device *nesdev,
 	return;
 }
 
-
 /**
  * nes_arp_table
  */
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 9f2f7d4..99e0109 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -1458,7 +1458,7 @@ static int nes_destroy_qp(struct ib_qp *ibqp)
 	struct ib_qp_attr attr;
 	struct iw_cm_id *cm_id;
 	struct iw_cm_event cm_event;
-	int ret;
+	int ret = 0;
 
 	atomic_inc(&sw_qps_destroyed);
 	nesqp->destroyed = 1;
@@ -1511,7 +1511,6 @@ static int nes_destroy_qp(struct ib_qp *ibqp)
 		if ((nesqp->nesrcq) && (nesqp->nesrcq != nesqp->nesscq))
 			nes_clean_cq(nesqp, nesqp->nesrcq);
 	}
-
 	nes_rem_ref(&nesqp->ibqp);
 	return 0;
 }
diff --git a/drivers/infiniband/hw/nes/nes_verbs.h b/drivers/infiniband/hw/nes/nes_verbs.h
index 854316d..fe6b6e9 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.h
+++ b/drivers/infiniband/hw/nes/nes_verbs.h
@@ -155,6 +155,7 @@ struct nes_qp {
 	u32                   mmap_sq_db_index;
 	u32                   mmap_rq_db_index;
 	spinlock_t            lock;
+	spinlock_t            pau_lock;
 	struct nes_qp_context *nesqp_context;
 	dma_addr_t            nesqp_context_pbase;
 	void	              *pbl_vbase;
@@ -162,6 +163,8 @@ struct nes_qp {
 	struct page           *page;
 	struct timer_list     terminate_timer;
 	enum ib_event_type    terminate_eventtype;
+	struct sk_buff_head   pau_list;
+	u32                   pau_rcv_nxt;
 	u16                   active_conn:1;
 	u16                   skip_lsmm:1;
 	u16                   user_mode:1;
@@ -169,7 +172,8 @@ struct nes_qp {
 	u16                   flush_issued:1;
 	u16                   destroyed:1;
 	u16                   sig_all:1;
-	u16                   rsvd:9;
+	u16                   pau_mode:1;
+	u16                   rsvd:8;
 	u16                   private_data_len;
 	u16                   term_sq_flush_code;
 	u16                   term_rq_flush_code;
@@ -177,5 +181,8 @@ struct nes_qp {
 	u8                    hw_tcp_state;
 	u8                    term_flags;
 	u8                    sq_kmapped;
+	u8                    pau_busy;
+	u8                    pau_pending;
+	u8                    pau_state;
 };
 #endif			/* NES_VERBS_H */
-- 
1.7.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
