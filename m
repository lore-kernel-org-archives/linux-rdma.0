From: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/9] RDMA/nes: Add support for IB_WR_*INV
Date: Tue, 1 Dec 2009 16:19:49 -0600
Message-ID: <20091201221949.GA4152@ctung-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Add support for IB_WR_SEND_WITH_INV, IB_WR_RDMA_READ_WITH_INV
and IB_WR_LOCAL_INV.

Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_verbs.c |  203 ++++++++++++++++++---------------
 1 files changed, 113 insertions(+), 90 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 0b17c01..499dd78 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -3373,18 +3373,12 @@ static int nes_post_send(struct ib_qp *ibqp, struct ib_send_wr *ib_wr,
 	struct nes_device *nesdev = nesvnic->nesdev;
 	struct nes_qp *nesqp = to_nesqp(ibqp);
 	struct nes_hw_qp_wqe *wqe;
-	int err;
+	int err = 0;
 	u32 qsize = nesqp->hwqp.sq_size;
 	u32 head;
-	u32 wqe_misc;
-	u32 wqe_count;
+	u32 wqe_misc = 0;
+	u32 wqe_count = 0;
 	u32 counter;
-	u32 total_payload_length;
-
-	err = 0;
-	wqe_misc = 0;
-	wqe_count = 0;
-	total_payload_length = 0;
 
 	if (nesqp->ibqp_state > IB_QPS_RTS) {
 		err = -EINVAL;
@@ -3415,91 +3409,117 @@ static int nes_post_send(struct ib_qp *ibqp, struct ib_send_wr *ib_wr,
 		u64temp = (u64)(ib_wr->wr_id);
 		set_wqe_64bit_value(wqe->wqe_words, NES_IWARP_SQ_WQE_COMP_SCRATCH_LOW_IDX,
 					u64temp);
-			switch (ib_wr->opcode) {
-				case IB_WR_SEND:
-					if (ib_wr->send_flags & IB_SEND_SOLICITED) {
-						wqe_misc = NES_IWARP_SQ_OP_SENDSE;
-					} else {
-						wqe_misc = NES_IWARP_SQ_OP_SEND;
-					}
-					if (ib_wr->num_sge > nesdev->nesadapter->max_sge) {
-						err = -EINVAL;
-						break;
-					}
-					if (ib_wr->send_flags & IB_SEND_FENCE) {
-						wqe_misc |= NES_IWARP_SQ_WQE_LOCAL_FENCE;
-					}
-					if ((ib_wr->send_flags & IB_SEND_INLINE) &&
-							((nes_drv_opt & NES_DRV_OPT_NO_INLINE_DATA) == 0) &&
-							(ib_wr->sg_list[0].length <= 64)) {
-						memcpy(&wqe->wqe_words[NES_IWARP_SQ_WQE_IMM_DATA_START_IDX],
-							       (void *)(unsigned long)ib_wr->sg_list[0].addr, ib_wr->sg_list[0].length);
-						set_wqe_32bit_value(wqe->wqe_words, NES_IWARP_SQ_WQE_TOTAL_PAYLOAD_IDX,
-								ib_wr->sg_list[0].length);
-						wqe_misc |= NES_IWARP_SQ_WQE_IMM_DATA;
-					} else {
-						fill_wqe_sg_send(wqe, ib_wr, 1);
-					}
+		switch (ib_wr->opcode) {
+		case IB_WR_SEND:
+		case IB_WR_SEND_WITH_INV:
+			if (IB_WR_SEND == ib_wr->opcode) {
+				if (ib_wr->send_flags & IB_SEND_SOLICITED)
+					wqe_misc = NES_IWARP_SQ_OP_SENDSE;
+				else
+					wqe_misc = NES_IWARP_SQ_OP_SEND;
+			} else {
+				if (ib_wr->send_flags & IB_SEND_SOLICITED)
+					wqe_misc = NES_IWARP_SQ_OP_SENDSEINV;
+				else
+					wqe_misc = NES_IWARP_SQ_OP_SENDINV;
 
-					break;
-				case IB_WR_RDMA_WRITE:
-					wqe_misc = NES_IWARP_SQ_OP_RDMAW;
-					if (ib_wr->num_sge > nesdev->nesadapter->max_sge) {
-						nes_debug(NES_DBG_IW_TX, "Exceeded max sge, ib_wr=%u, max=%u\n",
-								ib_wr->num_sge,
-								nesdev->nesadapter->max_sge);
-						err = -EINVAL;
-						break;
-					}
-					if (ib_wr->send_flags & IB_SEND_FENCE) {
-						wqe_misc |= NES_IWARP_SQ_WQE_LOCAL_FENCE;
-					}
+				set_wqe_32bit_value(wqe->wqe_words, NES_IWARP_SQ_WQE_INV_STAG_LOW_IDX,
+						    ib_wr->ex.invalidate_rkey);
+			}
 
-					set_wqe_32bit_value(wqe->wqe_words, NES_IWARP_SQ_WQE_RDMA_STAG_IDX,
-							ib_wr->wr.rdma.rkey);
-					set_wqe_64bit_value(wqe->wqe_words, NES_IWARP_SQ_WQE_RDMA_TO_LOW_IDX,
-							ib_wr->wr.rdma.remote_addr);
-
-					if ((ib_wr->send_flags & IB_SEND_INLINE) &&
-							((nes_drv_opt & NES_DRV_OPT_NO_INLINE_DATA) == 0) &&
-							(ib_wr->sg_list[0].length <= 64)) {
-						memcpy(&wqe->wqe_words[NES_IWARP_SQ_WQE_IMM_DATA_START_IDX],
-							       (void *)(unsigned long)ib_wr->sg_list[0].addr, ib_wr->sg_list[0].length);
-						set_wqe_32bit_value(wqe->wqe_words, NES_IWARP_SQ_WQE_TOTAL_PAYLOAD_IDX,
-								ib_wr->sg_list[0].length);
-						wqe_misc |= NES_IWARP_SQ_WQE_IMM_DATA;
-					} else {
-						fill_wqe_sg_send(wqe, ib_wr, 1);
-					}
-					wqe->wqe_words[NES_IWARP_SQ_WQE_RDMA_LENGTH_IDX] =
-							wqe->wqe_words[NES_IWARP_SQ_WQE_TOTAL_PAYLOAD_IDX];
-					break;
-				case IB_WR_RDMA_READ:
-					/* iWARP only supports 1 sge for RDMA reads */
-					if (ib_wr->num_sge > 1) {
-						nes_debug(NES_DBG_IW_TX, "Exceeded max sge, ib_wr=%u, max=1\n",
-								ib_wr->num_sge);
-						err = -EINVAL;
-						break;
-					}
-					wqe_misc = NES_IWARP_SQ_OP_RDMAR;
-					set_wqe_64bit_value(wqe->wqe_words, NES_IWARP_SQ_WQE_RDMA_TO_LOW_IDX,
-							ib_wr->wr.rdma.remote_addr);
-					set_wqe_32bit_value(wqe->wqe_words, NES_IWARP_SQ_WQE_RDMA_STAG_IDX,
-							ib_wr->wr.rdma.rkey);
-					set_wqe_32bit_value(wqe->wqe_words, NES_IWARP_SQ_WQE_RDMA_LENGTH_IDX,
-							ib_wr->sg_list->length);
-					set_wqe_64bit_value(wqe->wqe_words, NES_IWARP_SQ_WQE_FRAG0_LOW_IDX,
-							ib_wr->sg_list->addr);
-					set_wqe_32bit_value(wqe->wqe_words, NES_IWARP_SQ_WQE_STAG0_IDX,
-							ib_wr->sg_list->lkey);
-					break;
-				default:
-					/* error */
-					err = -EINVAL;
-					break;
+			if (ib_wr->num_sge > nesdev->nesadapter->max_sge) {
+				err = -EINVAL;
+				break;
 			}
 
+			if (ib_wr->send_flags & IB_SEND_FENCE)
+				wqe_misc |= NES_IWARP_SQ_WQE_LOCAL_FENCE;
+
+			if ((ib_wr->send_flags & IB_SEND_INLINE) &&
+			    ((nes_drv_opt & NES_DRV_OPT_NO_INLINE_DATA) == 0) &&
+			     (ib_wr->sg_list[0].length <= 64)) {
+				memcpy(&wqe->wqe_words[NES_IWARP_SQ_WQE_IMM_DATA_START_IDX],
+				       (void *)(unsigned long)ib_wr->sg_list[0].addr, ib_wr->sg_list[0].length);
+				set_wqe_32bit_value(wqe->wqe_words, NES_IWARP_SQ_WQE_TOTAL_PAYLOAD_IDX,
+						    ib_wr->sg_list[0].length);
+				wqe_misc |= NES_IWARP_SQ_WQE_IMM_DATA;
+			} else {
+				fill_wqe_sg_send(wqe, ib_wr, 1);
+			}
+
+			break;
+		case IB_WR_RDMA_WRITE:
+			wqe_misc = NES_IWARP_SQ_OP_RDMAW;
+			if (ib_wr->num_sge > nesdev->nesadapter->max_sge) {
+				nes_debug(NES_DBG_IW_TX, "Exceeded max sge, ib_wr=%u, max=%u\n",
+					  ib_wr->num_sge, nesdev->nesadapter->max_sge);
+				err = -EINVAL;
+				break;
+			}
+
+			if (ib_wr->send_flags & IB_SEND_FENCE)
+				wqe_misc |= NES_IWARP_SQ_WQE_LOCAL_FENCE;
+
+			set_wqe_32bit_value(wqe->wqe_words, NES_IWARP_SQ_WQE_RDMA_STAG_IDX,
+					    ib_wr->wr.rdma.rkey);
+			set_wqe_64bit_value(wqe->wqe_words, NES_IWARP_SQ_WQE_RDMA_TO_LOW_IDX,
+					    ib_wr->wr.rdma.remote_addr);
+
+			if ((ib_wr->send_flags & IB_SEND_INLINE) &&
+			    ((nes_drv_opt & NES_DRV_OPT_NO_INLINE_DATA) == 0) &&
+			     (ib_wr->sg_list[0].length <= 64)) {
+				memcpy(&wqe->wqe_words[NES_IWARP_SQ_WQE_IMM_DATA_START_IDX],
+				       (void *)(unsigned long)ib_wr->sg_list[0].addr, ib_wr->sg_list[0].length);
+				set_wqe_32bit_value(wqe->wqe_words, NES_IWARP_SQ_WQE_TOTAL_PAYLOAD_IDX,
+						    ib_wr->sg_list[0].length);
+				wqe_misc |= NES_IWARP_SQ_WQE_IMM_DATA;
+			} else {
+				fill_wqe_sg_send(wqe, ib_wr, 1);
+			}
+
+			wqe->wqe_words[NES_IWARP_SQ_WQE_RDMA_LENGTH_IDX] =
+				wqe->wqe_words[NES_IWARP_SQ_WQE_TOTAL_PAYLOAD_IDX];
+			break;
+		case IB_WR_RDMA_READ:
+		case IB_WR_RDMA_READ_WITH_INV:
+			/* iWARP only supports 1 sge for RDMA reads */
+			if (ib_wr->num_sge > 1) {
+				nes_debug(NES_DBG_IW_TX, "Exceeded max sge, ib_wr=%u, max=1\n",
+					  ib_wr->num_sge);
+				err = -EINVAL;
+				break;
+			}
+			if (ib_wr->opcode == IB_WR_RDMA_READ) {
+				wqe_misc = NES_IWARP_SQ_OP_RDMAR;
+			} else {
+				wqe_misc = NES_IWARP_SQ_OP_RDMAR_LOCINV;
+				set_wqe_32bit_value(wqe->wqe_words, NES_IWARP_SQ_WQE_INV_STAG_LOW_IDX,
+						    ib_wr->ex.invalidate_rkey);
+			}
+
+			set_wqe_64bit_value(wqe->wqe_words, NES_IWARP_SQ_WQE_RDMA_TO_LOW_IDX,
+					    ib_wr->wr.rdma.remote_addr);
+			set_wqe_32bit_value(wqe->wqe_words, NES_IWARP_SQ_WQE_RDMA_STAG_IDX,
+					    ib_wr->wr.rdma.rkey);
+			set_wqe_32bit_value(wqe->wqe_words, NES_IWARP_SQ_WQE_RDMA_LENGTH_IDX,
+					    ib_wr->sg_list->length);
+			set_wqe_64bit_value(wqe->wqe_words, NES_IWARP_SQ_WQE_FRAG0_LOW_IDX,
+					    ib_wr->sg_list->addr);
+			set_wqe_32bit_value(wqe->wqe_words, NES_IWARP_SQ_WQE_STAG0_IDX,
+					    ib_wr->sg_list->lkey);
+			break;
+		case IB_WR_LOCAL_INV:
+			wqe_misc = NES_IWARP_SQ_OP_LOCINV;
+			set_wqe_32bit_value(wqe->wqe_words,
+					    NES_IWARP_SQ_LOCINV_WQE_INV_STAG_IDX,
+					    ib_wr->ex.invalidate_rkey);
+			break;
+		default:
+			/* error */
+			err = -EINVAL;
+			break;
+		}
+
 		if (err)
 			break;
 
@@ -3729,6 +3749,9 @@ static int nes_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *entry)
 						nes_debug(NES_DBG_CQ, "Operation = Send.\n");
 						entry->opcode = IB_WC_SEND;
 						break;
+					case NES_IWARP_SQ_OP_LOCINV:
+						entry->opcode = IB_WR_LOCAL_INV;
+						break;
 				}
 
 				nesqp->hwqp.sq_tail = (wqe_index+1)&(nesqp->hwqp.sq_size - 1);
-- 
1.6.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
