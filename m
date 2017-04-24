From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [rdma-core v5 8/8] libbnxt_re: Add support for atomic operations
Date: Mon, 24 Apr 2017 14:53:15 -0400
Message-ID: <1493059995-636-9-git-send-email-devesh.sharma@broadcom.com>
References: <1493059995-636-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493059995-636-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch adds support for compare-and-swap and fetch-and-add
atomic operations in user library.

v4->v5
 -- Removed definition of upper_32_bits and
    lower_32_bits.

v3->v4
 -- Changed weq init code to match the DMA ABI.
v1->v2
 -- Fixed the missing "break"
 -- Changed macros to inline function

Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 providers/bnxt_re/bnxt_re-abi.h |  3 ++-
 providers/bnxt_re/main.h        |  8 ++++++-
 providers/bnxt_re/verbs.c       | 52 ++++++++++++++++++++++++++++++++++-------
 3 files changed, 53 insertions(+), 10 deletions(-)

diff --git a/providers/bnxt_re/bnxt_re-abi.h b/providers/bnxt_re/bnxt_re-abi.h
index db11322..205d8c4 100644
--- a/providers/bnxt_re/bnxt_re-abi.h
+++ b/providers/bnxt_re/bnxt_re-abi.h
@@ -54,7 +54,8 @@ enum bnxt_re_wr_opcode {
 	BNXT_RE_WR_OPCD_ATOMIC_FA	= 0x0B,
 	BNXT_RE_WR_OPCD_LOC_INVAL	= 0x0C,
 	BNXT_RE_WR_OPCD_BIND		= 0x0E,
-	BNXT_RE_WR_OPCD_RECV		= 0x80
+	BNXT_RE_WR_OPCD_RECV		= 0x80,
+	BNXT_RE_WR_OPCD_INVAL		= 0xFF
 };
 
 enum bnxt_re_wr_flags {
diff --git a/providers/bnxt_re/main.h b/providers/bnxt_re/main.h
index 1a4dc06..4cc8abd 100644
--- a/providers/bnxt_re/main.h
+++ b/providers/bnxt_re/main.h
@@ -236,9 +236,15 @@ static inline uint8_t bnxt_re_ibv_to_bnxt_wr_opcd(uint8_t ibv_opcd)
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
 
diff --git a/providers/bnxt_re/verbs.c b/providers/bnxt_re/verbs.c
index 1f8ff8e..2768a56 100644
--- a/providers/bnxt_re/verbs.c
+++ b/providers/bnxt_re/verbs.c
@@ -1068,6 +1068,8 @@ static int bnxt_re_build_send_sqe(struct bnxt_re_qp *qp, void *wqe,
 
 	/* Fill Header */
 	opcode = bnxt_re_ibv_to_bnxt_wr_opcd(wr->opcode);
+	if (opcode == BNXT_RE_WR_OPCD_INVAL)
+		return -EINVAL;
 	hdrval = (opcode & BNXT_RE_HDR_WT_MASK);
 
 	if (is_inline) {
@@ -1115,6 +1117,39 @@ static int bnxt_re_build_rdma_sqe(struct bnxt_re_qp *qp, void *wqe,
 	return len;
 }
 
+static int bnxt_re_build_cns_sqe(struct bnxt_re_qp *qp, void *wqe,
+				 struct ibv_send_wr *wr)
+{
+	struct bnxt_re_bsqe *hdr = wqe;
+	struct bnxt_re_atomic *sqe = ((void *)wqe +
+				      sizeof(struct bnxt_re_bsqe));
+	int len;
+
+	len = bnxt_re_build_send_sqe(qp, wqe, wr, false);
+	hdr->key_immd = htole32(wr->wr.atomic.rkey);
+	sqe->rva = htole64(wr->wr.atomic.remote_addr);
+	sqe->cmp_dt = htole64(wr->wr.atomic.compare_add);
+	sqe->swp_dt = htole64(wr->wr.atomic.swap);
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
+	int len;
+
+	len = bnxt_re_build_send_sqe(qp, wqe, wr, false);
+	hdr->key_immd = htole32(wr->wr.atomic.rkey);
+	sqe->rva = htole64(wr->wr.atomic.remote_addr);
+	sqe->cmp_dt = htole64(wr->wr.atomic.compare_add);
+
+	return len;
+}
+
 int bnxt_re_post_send(struct ibv_qp *ibvqp, struct ibv_send_wr *wr,
 		      struct ibv_send_wr **bad)
 {
@@ -1168,27 +1203,28 @@ int bnxt_re_post_send(struct ibv_qp *ibvqp, struct ibv_send_wr *wr,
 			else
 				bytes = bnxt_re_build_send_sqe(qp, sqe, wr,
 							       is_inline);
-			if (bytes < 0)
-				ret = (bytes == -EINVAL) ? EINVAL : ENOMEM;
 			break;
 		case IBV_WR_RDMA_WRITE_WITH_IMM:
 			hdr->key_immd = htole32(be32toh(wr->imm_data));
 		case IBV_WR_RDMA_WRITE:
 			bytes = bnxt_re_build_rdma_sqe(qp, sqe, wr, is_inline);
-			if (bytes < 0)
-				ret = ENOMEM;
 			break;
 		case IBV_WR_RDMA_READ:
 			bytes = bnxt_re_build_rdma_sqe(qp, sqe, wr, false);
-			if (bytes < 0)
-				ret = ENOMEM;
+			break;
+		case IBV_WR_ATOMIC_CMP_AND_SWP:
+			bytes = bnxt_re_build_cns_sqe(qp, sqe, wr);
+			break;
+		case IBV_WR_ATOMIC_FETCH_AND_ADD:
+			bytes = bnxt_re_build_fna_sqe(qp, sqe, wr);
 			break;
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
