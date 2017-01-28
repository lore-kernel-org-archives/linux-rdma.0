From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 09/11] libbnxtre: Add support for atomic operations
Date: Sat, 28 Jan 2017 17:13:40 -0500
Message-ID: <1485641622-30015-10-git-send-email-devesh.sharma@broadcom.com>
References: <1485641622-30015-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485641622-30015-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch adds support for compare-and-swap and fetch-and-add
atomic operations in user library.

Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 providers/bnxtre/abi.h    |  3 ++-
 providers/bnxtre/main.h   |  8 ++++++-
 providers/bnxtre/memory.h |  3 +++
 providers/bnxtre/verbs.c  | 57 ++++++++++++++++++++++++++++++++++++++++-------
 4 files changed, 61 insertions(+), 10 deletions(-)

diff --git a/providers/bnxtre/abi.h b/providers/bnxtre/abi.h
index 447058e..451af08 100644
--- a/providers/bnxtre/abi.h
+++ b/providers/bnxtre/abi.h
@@ -56,7 +56,8 @@ enum bnxt_re_wr_opcode {
 	BNXT_RE_WR_OPCD_ATOMIC_FA	= 0x0B,
 	BNXT_RE_WR_OPCD_LOC_INVAL	= 0x0C,
 	BNXT_RE_WR_OPCD_BIND		= 0x0E,
-	BNXT_RE_WR_OPCD_RECV		= 0x80
+	BNXT_RE_WR_OPCD_RECV		= 0x80,
+	BNXT_RE_WR_OPCD_INVAL		= 0xFF
 };
 
 enum bnxt_re_wr_flags {
diff --git a/providers/bnxtre/main.h b/providers/bnxtre/main.h
index c3689a5..c9b04e1 100644
--- a/providers/bnxtre/main.h
+++ b/providers/bnxtre/main.h
@@ -207,9 +207,15 @@ static inline uint8_t bnxt_re_ibv_to_bnxt_wr_opcd(uint8_t ibv_opcd)
 	case IBV_WR_RDMA_READ:
 		bnxt_opcd = BNXT_RE_WR_OPCD_RDMA_READ;
 		break;
+	case IBV_WR_ATOMIC_CMP_AND_SWP:
+		bnxt_opcd = BNXT_RE_WR_OPCD_ATOMIC_CS;
+		break;
+	case IBV_WR_ATOMIC_FETCH_AND_ADD:
+		bnxt_opcd = BNXT_RE_WR_OPCD_ATOMIC_FA;
+		break;
 		/* TODO: Add other opcodes */
 	default:
-		bnxt_opcd = 0xFF;
+		bnxt_opcd = BNXT_RE_WR_OPCD_INVAL;
 		break;
 	};
 
diff --git a/providers/bnxtre/memory.h b/providers/bnxtre/memory.h
index 4360914..4caa5dc 100644
--- a/providers/bnxtre/memory.h
+++ b/providers/bnxtre/memory.h
@@ -42,6 +42,9 @@
 
 #include <pthread.h>
 
+#define upper_32_bits(n)	((__u32)(((n) >> 16) >> 16))
+#define lower_32_bits(n)	((__u32)((n) & 0xFFFFFFFFUL))
+
 struct bnxt_re_queue {
 	void *va;
 	uint32_t bytes; /* for munmap */
diff --git a/providers/bnxtre/verbs.c b/providers/bnxtre/verbs.c
index 9b92f20..0f5fcde 100644
--- a/providers/bnxtre/verbs.c
+++ b/providers/bnxtre/verbs.c
@@ -1072,6 +1072,9 @@ static int bnxt_re_build_send_sqe(struct bnxt_re_qp *qp, void *wqe,
 
 	/* Fill Header */
 	opcode = bnxt_re_ibv_to_bnxt_wr_opcd(wr->opcode);
+	if (opcode == BNXT_RE_WR_OPCD_INVAL)
+		return -EINVAL;
+
 	hdr->rsv_ws_fl_wt |= (opcode & BNXT_RE_HDR_WT_MASK);
 
 	if (is_inline) {
@@ -1120,6 +1123,44 @@ static int bnxt_re_build_rdma_sqe(struct bnxt_re_qp *qp, void *wqe,
 	return len;
 }
 
+static int bnxt_re_build_cns_sqe(struct bnxt_re_qp *qp, void *wqe,
+				 struct ibv_send_wr *wr)
+{
+	struct bnxt_re_bsqe *hdr = wqe;
+	struct bnxt_re_atomic *sqe = ((void *)wqe +
+				      sizeof(struct bnxt_re_bsqe));
+	uint32_t len;
+
+	len = bnxt_re_build_send_sqe(qp, wqe, wr, false);
+	hdr->key_immd = wr->wr.atomic.rkey;
+	sqe->rva_lo = lower_32_bits(wr->wr.atomic.remote_addr);
+	sqe->rva_hi = upper_32_bits(wr->wr.atomic.remote_addr);
+	sqe->cmp_dt_lo = lower_32_bits(wr->wr.atomic.compare_add);
+	sqe->cmp_dt_hi = upper_32_bits(wr->wr.atomic.compare_add);
+	sqe->swp_dt_lo = lower_32_bits(wr->wr.atomic.swap);
+	sqe->swp_dt_hi = upper_32_bits(wr->wr.atomic.swap);
+
+	return len;
+}
+
+static int bnxt_re_build_fna_sqe(struct bnxt_re_qp *qp, void *wqe,
+				 struct ibv_send_wr *wr)
+{
+	struct bnxt_re_bsqe *hdr = wqe;
+	struct bnxt_re_atomic *sqe = ((void *)wqe +
+				      sizeof(struct bnxt_re_bsqe));
+	uint32_t len;
+
+	len = bnxt_re_build_send_sqe(qp, wqe, wr, false);
+	hdr->key_immd = wr->wr.atomic.rkey;
+	sqe->rva_lo = lower_32_bits(wr->wr.atomic.remote_addr);
+	sqe->rva_hi = upper_32_bits(wr->wr.atomic.remote_addr);
+	sqe->cmp_dt_lo = lower_32_bits(wr->wr.atomic.compare_add);
+	sqe->cmp_dt_hi = upper_32_bits(wr->wr.atomic.compare_add);
+
+	return len;
+}
+
 int bnxt_re_post_send(struct ibv_qp *ibvqp, struct ibv_send_wr *wr,
 		      struct ibv_send_wr **bad)
 {
@@ -1173,27 +1214,27 @@ int bnxt_re_post_send(struct ibv_qp *ibvqp, struct ibv_send_wr *wr,
 			else
 				bytes = bnxt_re_build_send_sqe(qp, sqe, wr,
 							       is_inline);
-			if (bytes < 0)
-				ret = (bytes == -EINVAL) ? EINVAL : ENOMEM;
 			break;
 		case IBV_WR_RDMA_WRITE_WITH_IMM:
 			hdr->key_immd = wr->imm_data;
 		case IBV_WR_RDMA_WRITE:
 			bytes = bnxt_re_build_rdma_sqe(qp, sqe, wr, is_inline);
-			if (bytes < 0)
-				ret = ENOMEM;
 			break;
 		case IBV_WR_RDMA_READ:
 			bytes = bnxt_re_build_rdma_sqe(qp, sqe, wr, false);
-			if (bytes < 0)
-				ret = ENOMEM;
 			break;
+		case IBV_WR_ATOMIC_CMP_AND_SWP:
+			bytes = bnxt_re_build_cns_sqe(qp, sqe, wr);
+			break;
+		case IBV_WR_ATOMIC_FETCH_AND_ADD:
+			bytes = bnxt_re_build_fna_sqe(qp, sqe, wr);
 		default:
-			ret = EINVAL;
+			bytes = -EINVAL;
 			break;
 		}
 
-		if (ret) {
+		if (bytes < 0) {
+			ret = (bytes == -EINVAL) ? EINVAL : ENOMEM;
 			*bad = wr;
 			break;
 		}
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
