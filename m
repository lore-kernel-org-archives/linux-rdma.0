From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next 1/2] IB/rxe: Add fast memory registraion and remote invalidation support
Date: Tue,  5 Jul 2016 19:05:49 +0300
Message-ID: <1467734750-20298-2-git-send-email-monis@mellanox.com>
References: <1467734750-20298-1-git-send-email-monis@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467734750-20298-1-git-send-email-monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Sagi Grimberg <sagig-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>

1. Implement ib_map_mr_sg() and populate the private
   rxe memory region with the page addresses.

2. Implement the registration (MR state) in the requester
   routine.

3. Have the responder support remote invalidation.

Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/rxe/rxe_mr.c     |  3 ++
 drivers/infiniband/hw/rxe/rxe_opcode.c |  4 +--
 drivers/infiniband/hw/rxe/rxe_opcode.h |  1 +
 drivers/infiniband/hw/rxe/rxe_param.h  |  3 +-
 drivers/infiniband/hw/rxe/rxe_req.c    | 36 +++++++++++++++++++++++
 drivers/infiniband/hw/rxe/rxe_resp.c   | 16 +++++++++++
 drivers/infiniband/hw/rxe/rxe_verbs.c  | 52 ++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/rxe/rxe_verbs.h  |  1 +
 include/uapi/rdma/ib_user_rxe.h        |  5 ++++
 9 files changed, 118 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/rxe/rxe_mr.c b/drivers/infiniband/hw/rxe/rxe_mr.c
index e533249..6f9bf13 100644
--- a/drivers/infiniband/hw/rxe/rxe_mr.c
+++ b/drivers/infiniband/hw/rxe/rxe_mr.c
@@ -246,6 +246,9 @@ int rxe_mem_init_fast(struct rxe_dev *rxe, struct rxe_pd *pd,
 
 	rxe_mem_init(0, mem);
 
+	/* In fastreg, we also set the rkey */
+	mem->ibmr.rkey = mem->ibmr.lkey;
+
 	err = rxe_mem_alloc(rxe, mem, max_pages);
 	if (err)
 		goto err1;
diff --git a/drivers/infiniband/hw/rxe/rxe_opcode.c b/drivers/infiniband/hw/rxe/rxe_opcode.c
index 4293768..61927c1 100644
--- a/drivers/infiniband/hw/rxe/rxe_opcode.c
+++ b/drivers/infiniband/hw/rxe/rxe_opcode.c
@@ -114,13 +114,13 @@ struct rxe_wr_opcode_info rxe_wr_opcode_info[] = {
 	[IB_WR_LOCAL_INV]				= {
 		.name	= "IB_WR_LOCAL_INV",
 		.mask	= {
-			/* not supported */
+			[IB_QPT_RC]	= WR_REG_MASK,
 		},
 	},
 	[IB_WR_REG_MR]					= {
 		.name	= "IB_WR_REG_MR",
 		.mask	= {
-			/* not supported */
+			[IB_QPT_RC]	= WR_REG_MASK,
 		},
 	},
 };
diff --git a/drivers/infiniband/hw/rxe/rxe_opcode.h b/drivers/infiniband/hw/rxe/rxe_opcode.h
index 0c5f979..307604e 100644
--- a/drivers/infiniband/hw/rxe/rxe_opcode.h
+++ b/drivers/infiniband/hw/rxe/rxe_opcode.h
@@ -47,6 +47,7 @@ enum rxe_wr_mask {
 	WR_READ_MASK			= BIT(3),
 	WR_WRITE_MASK			= BIT(4),
 	WR_LOCAL_MASK			= BIT(5),
+	WR_REG_MASK			= BIT(6),
 
 	WR_READ_OR_WRITE_MASK		= WR_READ_MASK | WR_WRITE_MASK,
 	WR_READ_WRITE_OR_SEND_MASK	= WR_READ_OR_WRITE_MASK | WR_SEND_MASK,
diff --git a/drivers/infiniband/hw/rxe/rxe_param.h b/drivers/infiniband/hw/rxe/rxe_param.h
index 656a1a1..27ac76c 100644
--- a/drivers/infiniband/hw/rxe/rxe_param.h
+++ b/drivers/infiniband/hw/rxe/rxe_param.h
@@ -77,7 +77,8 @@ enum rxe_device_param {
 					| IB_DEVICE_PORT_ACTIVE_EVENT
 					| IB_DEVICE_SYS_IMAGE_GUID
 					| IB_DEVICE_RC_RNR_NAK_GEN
-					| IB_DEVICE_SRQ_RESIZE,
+					| IB_DEVICE_SRQ_RESIZE
+					| IB_DEVICE_MEM_MGT_EXTENSIONS,
 	RXE_MAX_SGE			= 32,
 	RXE_MAX_SGE_RD			= 32,
 	RXE_MAX_CQ			= 16384,
diff --git a/drivers/infiniband/hw/rxe/rxe_req.c b/drivers/infiniband/hw/rxe/rxe_req.c
index f78efa6..33b2d9d 100644
--- a/drivers/infiniband/hw/rxe/rxe_req.c
+++ b/drivers/infiniband/hw/rxe/rxe_req.c
@@ -251,6 +251,9 @@ static int next_opcode_rc(struct rxe_qp *qp, unsigned opcode, int fits)
 		else
 			return fits ? IB_OPCODE_RC_SEND_ONLY_WITH_INVALIDATE :
 				IB_OPCODE_RC_SEND_FIRST;
+	case IB_WR_REG_MR:
+	case IB_WR_LOCAL_INV:
+		return opcode;
 	}
 
 	return -EINVAL;
@@ -592,6 +595,39 @@ next_wqe:
 	if (unlikely(!wqe))
 		goto exit;
 
+	if (wqe->mask & WR_REG_MASK) {
+		if (wqe->wr.opcode == IB_WR_LOCAL_INV) {
+			struct rxe_dev *rxe = to_rdev(qp->ibqp.device);
+			struct rxe_mem *rmr;
+
+			rmr = rxe_pool_get_index(&rxe->mr_pool,
+						 wqe->wr.ex.invalidate_rkey >> 8);
+			if (!rmr) {
+				pr_err("No mr for key %#x\n", wqe->wr.ex.invalidate_rkey);
+				wqe->state = wqe_state_error;
+				wqe->status = IB_WC_MW_BIND_ERR;
+				goto exit;
+			}
+			rmr->state = RXE_MEM_STATE_FREE;
+			wqe->state = wqe_state_done;
+			wqe->status = IB_WC_SUCCESS;
+		} else if (wqe->wr.opcode == IB_WR_REG_MR) {
+			struct rxe_mem *rmr = to_rmr(wqe->wr.wr.reg.mr);
+
+			rmr->state = RXE_MEM_STATE_VALID;
+			rmr->access = wqe->wr.wr.reg.access;
+			rmr->lkey = wqe->wr.wr.reg.key;
+			rmr->rkey = wqe->wr.wr.reg.key;
+			wqe->state = wqe_state_done;
+			wqe->status = IB_WC_SUCCESS;
+		} else {
+			goto exit;
+		}
+		qp->req.wqe_index = next_index(qp->sq.queue,
+						qp->req.wqe_index);
+		goto next_wqe;
+	}
+
 	if (unlikely(qp_type(qp) == IB_QPT_RC &&
 		     qp->req.psn > (qp->comp.psn + RXE_MAX_UNACKED_PSNS))) {
 		qp->req.wait_psn = 1;
diff --git a/drivers/infiniband/hw/rxe/rxe_resp.c b/drivers/infiniband/hw/rxe/rxe_resp.c
index a00a743..ebb03b4 100644
--- a/drivers/infiniband/hw/rxe/rxe_resp.c
+++ b/drivers/infiniband/hw/rxe/rxe_resp.c
@@ -455,6 +455,11 @@ static enum resp_states check_rkey(struct rxe_qp *qp,
 		goto err1;
 	}
 
+	if (unlikely(mem->state == RXE_MEM_STATE_FREE)) {
+		state = RESPST_ERR_RKEY_VIOLATION;
+		goto err1;
+	}
+
 	if (mem_check_range(mem, va, resid)) {
 		state = RESPST_ERR_RKEY_VIOLATION;
 		goto err2;
@@ -867,8 +872,19 @@ static enum resp_states do_complete(struct rxe_qp *qp,
 			}
 
 			if (pkt->mask & RXE_IETH_MASK) {
+				struct rxe_dev *rxe = to_rdev(qp->ibqp.device);
+				struct rxe_mem *rmr;
+
 				wc->wc_flags |= IB_WC_WITH_INVALIDATE;
 				wc->ex.invalidate_rkey = ieth_rkey(pkt);
+
+				rmr = rxe_pool_get_index(&rxe->mr_pool,
+							 wc->ex.invalidate_rkey >> 8);
+				if (unlikely(!rmr)) {
+					pr_err("Bad rkey %#x invalidation\n", wc->ex.invalidate_rkey);
+					return RESPST_ERROR;
+				}
+				rmr->state = RXE_MEM_STATE_FREE;
 			}
 
 			wc->qp			= &qp->ibqp;
diff --git a/drivers/infiniband/hw/rxe/rxe_verbs.c b/drivers/infiniband/hw/rxe/rxe_verbs.c
index 898b3bb..c5d48c4 100644
--- a/drivers/infiniband/hw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/hw/rxe/rxe_verbs.c
@@ -692,6 +692,14 @@ static void init_send_wr(struct rxe_qp *qp, struct rxe_send_wr *wr,
 			wr->wr.atomic.swap = atomic_wr(ibwr)->swap;
 			wr->wr.atomic.rkey = atomic_wr(ibwr)->rkey;
 			break;
+		case IB_WR_LOCAL_INV:
+			wr->ex.invalidate_rkey = ibwr->ex.invalidate_rkey;
+		break;
+		case IB_WR_REG_MR:
+			wr->wr.reg.mr = reg_wr(ibwr)->mr;
+			wr->wr.reg.key = reg_wr(ibwr)->key;
+			wr->wr.reg.access = reg_wr(ibwr)->access;
+		break;
 		default:
 			break;
 		}
@@ -729,6 +737,10 @@ static int init_send_wqe(struct rxe_qp *qp, struct ib_send_wr *ibwr,
 
 			p += sge->length;
 		}
+	} else if (mask & WR_REG_MASK) {
+		wqe->mask = mask;
+		wqe->state = wqe_state_posted;
+		return 0;
 	} else
 		memcpy(wqe->dma.sge, ibwr->sg_list,
 		       num_sge * sizeof(struct ib_sge));
@@ -1102,6 +1114,45 @@ err1:
 	return ERR_PTR(err);
 }
 
+static int rxe_set_page(struct ib_mr *ibmr, u64 addr)
+{
+	struct rxe_mem *mr = to_rmr(ibmr);
+	struct rxe_map *map;
+	struct rxe_phys_buf *buf;
+
+	if (unlikely(mr->nbuf == mr->num_buf))
+		return -ENOMEM;
+
+	map = mr->map[mr->nbuf / RXE_BUF_PER_MAP];
+	buf = &map->buf[mr->nbuf % RXE_BUF_PER_MAP];
+
+	buf->addr = addr;
+	buf->size = ibmr->page_size;
+	mr->nbuf++;
+
+	return 0;
+}
+
+static int rxe_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
+			 unsigned int *sg_offset)
+{
+	struct rxe_mem *mr = to_rmr(ibmr);
+	int n;
+
+	mr->nbuf = 0;
+
+	n = ib_sg_to_pages(ibmr, sg, sg_nents, sg_offset, rxe_set_page);
+
+	mr->va = ibmr->iova;
+	mr->iova = ibmr->iova;
+	mr->length = ibmr->length;
+	mr->page_shift = ilog2(ibmr->page_size);
+	mr->page_mask = ibmr->page_size - 1;
+	mr->offset = mr->iova & mr->page_mask;
+
+	return n;
+}
+
 static struct ib_fmr *rxe_alloc_fmr(struct ib_pd *ibpd,
 				    int access, struct ib_fmr_attr *attr)
 {
@@ -1308,6 +1359,7 @@ int rxe_register_device(struct rxe_dev *rxe)
 	dev->reg_user_mr = rxe_reg_user_mr;
 	dev->dereg_mr = rxe_dereg_mr;
 	dev->alloc_mr = rxe_alloc_mr;
+	dev->map_mr_sg = rxe_map_mr_sg;
 	dev->alloc_fmr = rxe_alloc_fmr;
 	dev->map_phys_fmr = rxe_map_phys_fmr;
 	dev->unmap_fmr = rxe_unmap_fmr;
diff --git a/drivers/infiniband/hw/rxe/rxe_verbs.h b/drivers/infiniband/hw/rxe/rxe_verbs.h
index ef73edb..d34c056 100644
--- a/drivers/infiniband/hw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/hw/rxe/rxe_verbs.h
@@ -334,6 +334,7 @@ struct rxe_mem {
 	int			map_mask;
 
 	u32			num_buf;
+	u32			nbuf;
 
 	u32			max_buf;
 	u32			num_map;
diff --git a/include/uapi/rdma/ib_user_rxe.h b/include/uapi/rdma/ib_user_rxe.h
index ee17d49..19f9615 100644
--- a/include/uapi/rdma/ib_user_rxe.h
+++ b/include/uapi/rdma/ib_user_rxe.h
@@ -87,6 +87,11 @@ struct rxe_send_wr {
 			__u32	remote_qkey;
 			__u16	pkey_index;
 		} ud;
+		struct {
+			struct ib_mr *mr;
+			__u32        key;
+			int          access;
+		} reg;
 	} wr;
 };
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
