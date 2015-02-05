From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx4 2/2] Implement Send with invalidate
Date: Thu,  5 Feb 2015 14:28:33 +0200
Message-ID: <1423139313-17418-3-git-send-email-majd@mellanox.com>
References: <1423139313-17418-1-git-send-email-majd@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423139313-17418-1-git-send-email-majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Send with invalidate can be used to invalidate a remote memory region or memory
window. The complete details are specified in the InfiniBand Architecture
Specifications, section 9.4.1.1.

According to the specs, the following objects can be invalidated:

1. Memory Window type 2
2. Physical MR
3. Fast register MR

The invalidation is done by posting a send work request, where the opcode is
IBV_WR_SEND_WITH_INV and the immediate data contain's the R_key.

Upon success, the responder's work completion will contain the invalidated R_key
in it's immediate data.

Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/cq.c |    8 ++++++++
 src/qp.c |    4 ++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/src/cq.c b/src/cq.c
index 77eb6c2..c52e6c7 100644
--- a/src/cq.c
+++ b/src/cq.c
@@ -294,6 +294,9 @@ static int mlx4_poll_one(struct mlx4_cq *cq,
 		case MLX4_OPCODE_BIND_MW:
 			wc->opcode    = IBV_WC_BIND_MW;
 			break;
+		case MLX4_OPCODE_SEND_INVAL:
+			wc->opcode    = IBV_WC_SEND;
+			break;
 		default:
 			/* assume it's a send completion */
 			wc->opcode    = IBV_WC_SEND;
@@ -308,6 +311,11 @@ static int mlx4_poll_one(struct mlx4_cq *cq,
 			wc->wc_flags = IBV_WC_WITH_IMM;
 			wc->imm_data = cqe->immed_rss_invalid;
 			break;
+		case MLX4_RECV_OPCODE_SEND_INVAL:
+			wc->opcode   = IBV_WC_RECV;
+			wc->wc_flags |= IBV_WC_WITH_INV;
+			wc->imm_data = ntohl(cqe->immed_rss_invalid);
+			break;
 		case MLX4_RECV_OPCODE_SEND:
 			wc->opcode   = IBV_WC_RECV;
 			wc->wc_flags = 0;
diff --git a/src/qp.c b/src/qp.c
index 80a21da..2612748 100644
--- a/src/qp.c
+++ b/src/qp.c
@@ -56,6 +56,7 @@ static const uint32_t mlx4_ib_opcode[] = {
 	[IBV_WR_ATOMIC_FETCH_AND_ADD]	= MLX4_OPCODE_ATOMIC_FA,
 	[IBV_WR_LOCAL_INV]		= MLX4_OPCODE_LOCAL_INVAL,
 	[IBV_WR_BIND_MW]		= MLX4_OPCODE_BIND_MW,
+	[IBV_WR_SEND_WITH_INV]		= MLX4_OPCODE_SEND_INVAL,
 };
 
 static void *get_recv_wqe(struct mlx4_qp *qp, int n)
@@ -332,6 +333,9 @@ int mlx4_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 				size += sizeof
 					(struct mlx4_wqe_bind_seg) / 16;
 				break;
+			case IBV_WR_SEND_WITH_INV:
+				ctrl->imm = htonl(wr->imm_data);
+				break;
 
 			default:
 				/* No extra segments required for sends */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
