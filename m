From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 2.6.35 2/3] RDMA/cxgb4: Support variable sized work requests.
Date: Thu, 10 Jun 2010 14:03:00 -0500
Message-ID: <20100610190300.18331.39028.stgit@build.ogc.int>
References: <20100610190255.18331.20027.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100610190255.18331.20027.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

T4 EQ entries are in multiples of 64B.  Currently the RDMA SQ and RQ
use fixed sized entries composed of 4 EQ entries for the SQ and 2 EQ
entries for the RQ.  For optimial latency with small IO, we need to
change this so the HW only needs to DMA the EQ entries actually used by
a given work request.

Implementation:

- add wq_pidx counter to track where we are in the EQ.  cidx/pidx are
used for the sw sq/rq tracking and flow control.

- the variable part of work requests is the SGL.  Add new functions to
build the SGL and/or immediate data directly in the EQ memory wrapping
when needed.

- adjust the min burst size for the EQ contexts to 64B.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/qp.c |  220 ++++++++++++++++++++------------------
 drivers/infiniband/hw/cxgb4/t4.h |   32 +++---
 2 files changed, 130 insertions(+), 122 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 0c28ed1..7d87fe5 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -162,7 +162,7 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 	res->u.sqrq.dcaen_to_eqsize = cpu_to_be32(
 		V_FW_RI_RES_WR_DCAEN(0) |
 		V_FW_RI_RES_WR_DCACPU(0) |
-		V_FW_RI_RES_WR_FBMIN(3) |
+		V_FW_RI_RES_WR_FBMIN(2) |
 		V_FW_RI_RES_WR_FBMAX(3) |
 		V_FW_RI_RES_WR_CIDXFTHRESHO(0) |
 		V_FW_RI_RES_WR_CIDXFTHRESH(0) |
@@ -185,7 +185,7 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 	res->u.sqrq.dcaen_to_eqsize = cpu_to_be32(
 		V_FW_RI_RES_WR_DCAEN(0) |
 		V_FW_RI_RES_WR_DCACPU(0) |
-		V_FW_RI_RES_WR_FBMIN(3) |
+		V_FW_RI_RES_WR_FBMIN(2) |
 		V_FW_RI_RES_WR_FBMAX(3) |
 		V_FW_RI_RES_WR_CIDXFTHRESHO(0) |
 		V_FW_RI_RES_WR_CIDXFTHRESH(0) |
@@ -235,12 +235,78 @@ err1:
 	return -ENOMEM;
 }
 
-static int build_rdma_send(union t4_wr *wqe, struct ib_send_wr *wr, u8 *len16)
+static int build_immd(struct t4_sq *sq, struct fw_ri_immd *immdp,
+		      struct ib_send_wr *wr, int max, u32 *plenp)
 {
+	u8 *dstp, *srcp;
+	u32 plen = 0;
 	int i;
+	int rem, len;
+
+	dstp = (u8 *)immdp->data;
+	for (i = 0; i < wr->num_sge; i++) {
+		if ((plen + wr->sg_list[i].length) > max)
+			return -EMSGSIZE;
+		srcp = (u8 *)(unsigned long)wr->sg_list[i].addr;
+		plen += wr->sg_list[i].length;
+		rem = wr->sg_list[i].length;
+		while (rem) {
+			if (dstp == (u8 *)&sq->queue[sq->size])
+				dstp = (u8 *)sq->queue;
+			if (rem <= (u8 *)&sq->queue[sq->size] - dstp)
+				len = rem;
+			else
+				len = (u8 *)&sq->queue[sq->size] - dstp;
+			memcpy(dstp, srcp, len);
+			dstp += len;
+			srcp += len;
+			rem -= len;
+		}
+	}
+	immdp->op = FW_RI_DATA_IMMD;
+	immdp->r1 = 0;
+	immdp->r2 = 0;
+	immdp->immdlen = cpu_to_be32(plen);
+	*plenp = plen;
+	return 0;
+}
+
+static int build_isgl(__be64 *queue_start, __be64 *queue_end,
+		      struct fw_ri_isgl *isglp, struct ib_sge *sg_list,
+		      int num_sge, u32 *plenp)
+
+{
+	int i;
+	u32 plen = 0;
+	__be64 *flitp = (__be64 *)isglp->sge;
+
+	for (i = 0; i < num_sge; i++) {
+		if ((plen + sg_list[i].length) < plen)
+			return -EMSGSIZE;
+		plen += sg_list[i].length;
+		*flitp = cpu_to_be64(((u64)sg_list[i].lkey << 32) |
+				     sg_list[i].length);
+		if (++flitp == queue_end)
+			flitp = queue_start;
+		*flitp = cpu_to_be64(sg_list[i].addr);
+		if (++flitp == queue_end)
+			flitp = queue_start;
+	}
+	isglp->op = FW_RI_DATA_ISGL;
+	isglp->r1 = 0;
+	isglp->nsge = cpu_to_be16(num_sge);
+	isglp->r2 = 0;
+	if (plenp)
+		*plenp = plen;
+	return 0;
+}
+
+static int build_rdma_send(struct t4_sq *sq, union t4_wr *wqe,
+			   struct ib_send_wr *wr, u8 *len16)
+{
 	u32 plen;
 	int size;
-	u8 *datap;
+	int ret;
 
 	if (wr->num_sge > T4_MAX_SEND_SGE)
 		return -EINVAL;
@@ -267,43 +333,23 @@ static int build_rdma_send(union t4_wr *wqe, struct ib_send_wr *wr, u8 *len16)
 	default:
 		return -EINVAL;
 	}
+
 	plen = 0;
 	if (wr->num_sge) {
 		if (wr->send_flags & IB_SEND_INLINE) {
-			datap = (u8 *)wqe->send.u.immd_src[0].data;
-			for (i = 0; i < wr->num_sge; i++) {
-				if ((plen + wr->sg_list[i].length) >
-				    T4_MAX_SEND_INLINE) {
-					return -EMSGSIZE;
-				}
-				plen += wr->sg_list[i].length;
-				memcpy(datap,
-				     (void *)(unsigned long)wr->sg_list[i].addr,
-				     wr->sg_list[i].length);
-				datap += wr->sg_list[i].length;
-			}
-			wqe->send.u.immd_src[0].op = FW_RI_DATA_IMMD;
-			wqe->send.u.immd_src[0].r1 = 0;
-			wqe->send.u.immd_src[0].r2 = 0;
-			wqe->send.u.immd_src[0].immdlen = cpu_to_be32(plen);
+			ret = build_immd(sq, wqe->send.u.immd_src, wr,
+					 T4_MAX_SEND_INLINE, &plen);
+			if (ret)
+				return ret;
 			size = sizeof wqe->send + sizeof(struct fw_ri_immd) +
 			       plen;
 		} else {
-			for (i = 0; i < wr->num_sge; i++) {
-				if ((plen + wr->sg_list[i].length) < plen)
-					return -EMSGSIZE;
-				plen += wr->sg_list[i].length;
-				wqe->send.u.isgl_src[0].sge[i].stag =
-					cpu_to_be32(wr->sg_list[i].lkey);
-				wqe->send.u.isgl_src[0].sge[i].len =
-					cpu_to_be32(wr->sg_list[i].length);
-				wqe->send.u.isgl_src[0].sge[i].to =
-					cpu_to_be64(wr->sg_list[i].addr);
-			}
-			wqe->send.u.isgl_src[0].op = FW_RI_DATA_ISGL;
-			wqe->send.u.isgl_src[0].r1 = 0;
-			wqe->send.u.isgl_src[0].nsge = cpu_to_be16(wr->num_sge);
-			wqe->send.u.isgl_src[0].r2 = 0;
+			ret = build_isgl((__be64 *)sq->queue,
+					 (__be64 *)&sq->queue[sq->size],
+					 wqe->send.u.isgl_src,
+					 wr->sg_list, wr->num_sge, &plen);
+			if (ret)
+				return ret;
 			size = sizeof wqe->send + sizeof(struct fw_ri_isgl) +
 			       wr->num_sge * sizeof(struct fw_ri_sge);
 		}
@@ -313,62 +359,40 @@ static int build_rdma_send(union t4_wr *wqe, struct ib_send_wr *wr, u8 *len16)
 		wqe->send.u.immd_src[0].r2 = 0;
 		wqe->send.u.immd_src[0].immdlen = 0;
 		size = sizeof wqe->send + sizeof(struct fw_ri_immd);
+		plen = 0;
 	}
 	*len16 = DIV_ROUND_UP(size, 16);
 	wqe->send.plen = cpu_to_be32(plen);
 	return 0;
 }
 
-static int build_rdma_write(union t4_wr *wqe, struct ib_send_wr *wr, u8 *len16)
+static int build_rdma_write(struct t4_sq *sq, union t4_wr *wqe,
+			    struct ib_send_wr *wr, u8 *len16)
 {
-	int i;
 	u32 plen;
 	int size;
-	u8 *datap;
+	int ret;
 
-	if (wr->num_sge > T4_MAX_WRITE_SGE)
+	if (wr->num_sge > T4_MAX_SEND_SGE)
 		return -EINVAL;
 	wqe->write.r2 = 0;
 	wqe->write.stag_sink = cpu_to_be32(wr->wr.rdma.rkey);
 	wqe->write.to_sink = cpu_to_be64(wr->wr.rdma.remote_addr);
-	plen = 0;
 	if (wr->num_sge) {
 		if (wr->send_flags & IB_SEND_INLINE) {
-			datap = (u8 *)wqe->write.u.immd_src[0].data;
-			for (i = 0; i < wr->num_sge; i++) {
-				if ((plen + wr->sg_list[i].length) >
-				    T4_MAX_WRITE_INLINE) {
-					return -EMSGSIZE;
-				}
-				plen += wr->sg_list[i].length;
-				memcpy(datap,
-				     (void *)(unsigned long)wr->sg_list[i].addr,
-				     wr->sg_list[i].length);
-				datap += wr->sg_list[i].length;
-			}
-			wqe->write.u.immd_src[0].op = FW_RI_DATA_IMMD;
-			wqe->write.u.immd_src[0].r1 = 0;
-			wqe->write.u.immd_src[0].r2 = 0;
-			wqe->write.u.immd_src[0].immdlen = cpu_to_be32(plen);
+			ret = build_immd(sq, wqe->write.u.immd_src, wr,
+					 T4_MAX_WRITE_INLINE, &plen);
+			if (ret)
+				return ret;
 			size = sizeof wqe->write + sizeof(struct fw_ri_immd) +
 			       plen;
 		} else {
-			for (i = 0; i < wr->num_sge; i++) {
-				if ((plen + wr->sg_list[i].length) < plen)
-					return -EMSGSIZE;
-				plen += wr->sg_list[i].length;
-				wqe->write.u.isgl_src[0].sge[i].stag =
-					cpu_to_be32(wr->sg_list[i].lkey);
-				wqe->write.u.isgl_src[0].sge[i].len =
-					cpu_to_be32(wr->sg_list[i].length);
-				wqe->write.u.isgl_src[0].sge[i].to =
-					cpu_to_be64(wr->sg_list[i].addr);
-			}
-			wqe->write.u.isgl_src[0].op = FW_RI_DATA_ISGL;
-			wqe->write.u.isgl_src[0].r1 = 0;
-			wqe->write.u.isgl_src[0].nsge =
-						       cpu_to_be16(wr->num_sge);
-			wqe->write.u.isgl_src[0].r2 = 0;
+			ret = build_isgl((__be64 *)sq->queue,
+					 (__be64 *)&sq->queue[sq->size],
+					 wqe->write.u.isgl_src,
+					 wr->sg_list, wr->num_sge, &plen);
+			if (ret)
+				return ret;
 			size = sizeof wqe->write + sizeof(struct fw_ri_isgl) +
 			       wr->num_sge * sizeof(struct fw_ri_sge);
 		}
@@ -378,6 +402,7 @@ static int build_rdma_write(union t4_wr *wqe, struct ib_send_wr *wr, u8 *len16)
 		wqe->write.u.immd_src[0].r2 = 0;
 		wqe->write.u.immd_src[0].immdlen = 0;
 		size = sizeof wqe->write + sizeof(struct fw_ri_immd);
+		plen = 0;
 	}
 	*len16 = DIV_ROUND_UP(size, 16);
 	wqe->write.plen = cpu_to_be32(plen);
@@ -416,29 +441,13 @@ static int build_rdma_read(union t4_wr *wqe, struct ib_send_wr *wr, u8 *len16)
 static int build_rdma_recv(struct c4iw_qp *qhp, union t4_recv_wr *wqe,
 			   struct ib_recv_wr *wr, u8 *len16)
 {
-	int i;
-	int plen = 0;
+	int ret;
 
-	for (i = 0; i < wr->num_sge; i++) {
-		if ((plen + wr->sg_list[i].length) < plen)
-			return -EMSGSIZE;
-		plen += wr->sg_list[i].length;
-		wqe->recv.isgl.sge[i].stag =
-			cpu_to_be32(wr->sg_list[i].lkey);
-		wqe->recv.isgl.sge[i].len =
-			cpu_to_be32(wr->sg_list[i].length);
-		wqe->recv.isgl.sge[i].to =
-			cpu_to_be64(wr->sg_list[i].addr);
-	}
-	for (; i < T4_MAX_RECV_SGE; i++) {
-		wqe->recv.isgl.sge[i].stag = 0;
-		wqe->recv.isgl.sge[i].len = 0;
-		wqe->recv.isgl.sge[i].to = 0;
-	}
-	wqe->recv.isgl.op = FW_RI_DATA_ISGL;
-	wqe->recv.isgl.r1 = 0;
-	wqe->recv.isgl.nsge = cpu_to_be16(wr->num_sge);
-	wqe->recv.isgl.r2 = 0;
+	ret = build_isgl((__be64 *)qhp->wq.rq.queue,
+			 (__be64 *)&qhp->wq.rq.queue[qhp->wq.rq.size],
+			 &wqe->recv.isgl, wr->sg_list, wr->num_sge, NULL);
+	if (ret)
+		return ret;
 	*len16 = DIV_ROUND_UP(sizeof wqe->recv +
 			      wr->num_sge * sizeof(struct fw_ri_sge), 16);
 	return 0;
@@ -547,7 +556,9 @@ int c4iw_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			*bad_wr = wr;
 			break;
 		}
-		wqe = &qhp->wq.sq.queue[qhp->wq.sq.pidx];
+		wqe = (union t4_wr *)((u8 *)qhp->wq.sq.queue +
+		      qhp->wq.sq.wq_pidx * T4_EQ_ENTRY_SIZE);
+
 		fw_flags = 0;
 		if (wr->send_flags & IB_SEND_SOLICITED)
 			fw_flags |= FW_RI_SOLICITED_EVENT_FLAG;
@@ -564,12 +575,12 @@ int c4iw_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 				swsqe->opcode = FW_RI_SEND;
 			else
 				swsqe->opcode = FW_RI_SEND_WITH_INV;
-			err = build_rdma_send(wqe, wr, &len16);
+			err = build_rdma_send(&qhp->wq.sq, wqe, wr, &len16);
 			break;
 		case IB_WR_RDMA_WRITE:
 			fw_opcode = FW_RI_RDMA_WRITE_WR;
 			swsqe->opcode = FW_RI_RDMA_WRITE;
-			err = build_rdma_write(wqe, wr, &len16);
+			err = build_rdma_write(&qhp->wq.sq, wqe, wr, &len16);
 			break;
 		case IB_WR_RDMA_READ:
 		case IB_WR_RDMA_READ_WITH_INV:
@@ -619,8 +630,8 @@ int c4iw_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		     swsqe->opcode, swsqe->read_len);
 		wr = wr->next;
 		num_wrs--;
-		t4_sq_produce(&qhp->wq);
-		idx++;
+		t4_sq_produce(&qhp->wq, len16);
+		idx += DIV_ROUND_UP(len16*16, T4_EQ_ENTRY_SIZE);
 	}
 	if (t4_wq_db_enabled(&qhp->wq))
 		t4_ring_sq_db(&qhp->wq, idx);
@@ -656,7 +667,9 @@ int c4iw_post_receive(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 			*bad_wr = wr;
 			break;
 		}
-		wqe = &qhp->wq.rq.queue[qhp->wq.rq.pidx];
+		wqe = (union t4_recv_wr *)((u8 *)qhp->wq.rq.queue +
+					   qhp->wq.rq.wq_pidx *
+					   T4_EQ_ENTRY_SIZE);
 		if (num_wrs)
 			err = build_rdma_recv(qhp, wqe, wr, &len16);
 		else
@@ -675,15 +688,12 @@ int c4iw_post_receive(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 		wqe->recv.r2[1] = 0;
 		wqe->recv.r2[2] = 0;
 		wqe->recv.len16 = len16;
-		if (len16 < 5)
-			wqe->flits[8] = 0;
-
 		PDBG("%s cookie 0x%llx pidx %u\n", __func__,
 		     (unsigned long long) wr->wr_id, qhp->wq.rq.pidx);
-		t4_rq_produce(&qhp->wq);
+		t4_rq_produce(&qhp->wq, len16);
+		idx += DIV_ROUND_UP(len16*16, T4_EQ_ENTRY_SIZE);
 		wr = wr->next;
 		num_wrs--;
-		idx++;
 	}
 	if (t4_wq_db_enabled(&qhp->wq))
 		t4_ring_rq_db(&qhp->wq, idx);
diff --git a/drivers/infiniband/hw/cxgb4/t4.h b/drivers/infiniband/hw/cxgb4/t4.h
index 1057cb9..97798d4 100644
--- a/drivers/infiniband/hw/cxgb4/t4.h
+++ b/drivers/infiniband/hw/cxgb4/t4.h
@@ -65,10 +65,10 @@ struct t4_status_page {
 	u8 db_off;
 };
 
-#define T4_EQ_SIZE 64
+#define T4_EQ_ENTRY_SIZE 64
 
 #define T4_SQ_NUM_SLOTS 4
-#define T4_SQ_NUM_BYTES (T4_EQ_SIZE * T4_SQ_NUM_SLOTS)
+#define T4_SQ_NUM_BYTES (T4_EQ_ENTRY_SIZE * T4_SQ_NUM_SLOTS)
 #define T4_MAX_SEND_SGE ((T4_SQ_NUM_BYTES - sizeof(struct fw_ri_send_wr) - \
 			sizeof(struct fw_ri_isgl)) / sizeof(struct fw_ri_sge))
 #define T4_MAX_SEND_INLINE ((T4_SQ_NUM_BYTES - sizeof(struct fw_ri_send_wr) - \
@@ -84,7 +84,7 @@ struct t4_status_page {
 #define T4_MAX_FR_DEPTH (T4_MAX_FR_IMMD / sizeof(u64))
 
 #define T4_RQ_NUM_SLOTS 2
-#define T4_RQ_NUM_BYTES (T4_EQ_SIZE * T4_RQ_NUM_SLOTS)
+#define T4_RQ_NUM_BYTES (T4_EQ_ENTRY_SIZE * T4_RQ_NUM_SLOTS)
 #define T4_MAX_RECV_SGE 4
 
 union t4_wr {
@@ -97,20 +97,18 @@ union t4_wr {
 	struct fw_ri_fr_nsmr_wr fr;
 	struct fw_ri_inv_lstag_wr inv;
 	struct t4_status_page status;
-	__be64 flits[T4_EQ_SIZE / sizeof(__be64) * T4_SQ_NUM_SLOTS];
+	__be64 flits[T4_EQ_ENTRY_SIZE / sizeof(__be64) * T4_SQ_NUM_SLOTS];
 };
 
 union t4_recv_wr {
 	struct fw_ri_recv_wr recv;
 	struct t4_status_page status;
-	__be64 flits[T4_EQ_SIZE / sizeof(__be64) * T4_RQ_NUM_SLOTS];
+	__be64 flits[T4_EQ_ENTRY_SIZE / sizeof(__be64) * T4_RQ_NUM_SLOTS];
 };
 
 static inline void init_wr_hdr(union t4_wr *wqe, u16 wrid,
 			       enum fw_wr_opcodes opcode, u8 flags, u8 len16)
 {
-	int slots_used;
-
 	wqe->send.opcode = (u8)opcode;
 	wqe->send.flags = flags;
 	wqe->send.wrid = wrid;
@@ -118,12 +116,6 @@ static inline void init_wr_hdr(union t4_wr *wqe, u16 wrid,
 	wqe->send.r1[1] = 0;
 	wqe->send.r1[2] = 0;
 	wqe->send.len16 = len16;
-
-	slots_used = DIV_ROUND_UP(len16*16, T4_EQ_SIZE);
-	while (slots_used < T4_SQ_NUM_SLOTS) {
-		wqe->flits[slots_used * T4_EQ_SIZE / sizeof(__be64)] = 0;
-		slots_used++;
-	}
 }
 
 /* CQE/AE status codes */
@@ -289,6 +281,7 @@ struct t4_sq {
 	u16 size;
 	u16 cidx;
 	u16 pidx;
+	u16 wq_pidx;
 };
 
 struct t4_swrqe {
@@ -310,6 +303,7 @@ struct t4_rq {
 	u16 size;
 	u16 cidx;
 	u16 pidx;
+	u16 wq_pidx;
 };
 
 struct t4_wq {
@@ -340,11 +334,14 @@ static inline u32 t4_rq_avail(struct t4_wq *wq)
 	return wq->rq.size - 1 - wq->rq.in_use;
 }
 
-static inline void t4_rq_produce(struct t4_wq *wq)
+static inline void t4_rq_produce(struct t4_wq *wq, u8 len16)
 {
 	wq->rq.in_use++;
 	if (++wq->rq.pidx == wq->rq.size)
 		wq->rq.pidx = 0;
+	wq->rq.wq_pidx += DIV_ROUND_UP(len16*16, T4_EQ_ENTRY_SIZE);
+	if (wq->rq.wq_pidx >= wq->rq.size * T4_RQ_NUM_SLOTS)
+		wq->rq.wq_pidx %= wq->rq.size * T4_RQ_NUM_SLOTS;
 }
 
 static inline void t4_rq_consume(struct t4_wq *wq)
@@ -370,11 +367,14 @@ static inline u32 t4_sq_avail(struct t4_wq *wq)
 	return wq->sq.size - 1 - wq->sq.in_use;
 }
 
-static inline void t4_sq_produce(struct t4_wq *wq)
+static inline void t4_sq_produce(struct t4_wq *wq, u8 len16)
 {
 	wq->sq.in_use++;
 	if (++wq->sq.pidx == wq->sq.size)
 		wq->sq.pidx = 0;
+	wq->sq.wq_pidx += DIV_ROUND_UP(len16*16, T4_EQ_ENTRY_SIZE);
+	if (wq->sq.wq_pidx >= wq->sq.size * T4_SQ_NUM_SLOTS)
+		wq->sq.wq_pidx %= wq->sq.size * T4_SQ_NUM_SLOTS;
 }
 
 static inline void t4_sq_consume(struct t4_wq *wq)
@@ -386,14 +386,12 @@ static inline void t4_sq_consume(struct t4_wq *wq)
 
 static inline void t4_ring_sq_db(struct t4_wq *wq, u16 inc)
 {
-	inc *= T4_SQ_NUM_SLOTS;
 	wmb();
 	writel(QID(wq->sq.qid) | PIDX(inc), wq->db);
 }
 
 static inline void t4_ring_rq_db(struct t4_wq *wq, u16 inc)
 {
-	inc *= T4_RQ_NUM_SLOTS;
 	wmb();
 	writel(QID(wq->rq.qid) | PIDX(inc), wq->db);
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
