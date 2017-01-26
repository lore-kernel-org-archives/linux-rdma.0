From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 6/7] mlx5: Unify exported and internal CQE format
Date: Thu, 26 Jan 2017 17:56:21 +0200
Message-ID: <1485446182-5109-7-git-send-email-yishaih@mellanox.com>
References: <1485446182-5109-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485446182-5109-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Direct verbs are exporting CQE format, which is mapped
to enum MLX5_INLINE_SCATTER_*.

The proposed change brings in sync the internal code,
exported enum and returned CQE format.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Acked-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/cq.c             | 24 ++++++++++++------------
 providers/mlx5/include/dv-cqe.h |  4 ++--
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/providers/mlx5/cq.c b/providers/mlx5/cq.c
index fe7379c..0ae6a19 100644
--- a/providers/mlx5/cq.c
+++ b/providers/mlx5/cq.c
@@ -151,10 +151,10 @@ static inline int handle_responder_lazy(struct mlx5_cq *cq, struct mlx5_cqe64 *c
 		wqe_ctr = ntohs(cqe->wqe_counter);
 		cq->ibv_cq.wr_id = srq->wrid[wqe_ctr];
 		mlx5_free_srq_wqe(srq, wqe_ctr);
-		if (cqe->op_own & MLX5_INLINE_SCATTER_32)
+		if (mlx5dv_get_cqe_format(cqe) == MLX5_INLINE_SCATTER_32)
 			err = mlx5_copy_to_recv_srq(srq, wqe_ctr, cqe,
 						    ntohl(cqe->byte_cnt));
-		else if (cqe->op_own & MLX5_INLINE_SCATTER_64)
+		else if (mlx5dv_get_cqe_format(cqe) == MLX5_INLINE_SCATTER_64)
 			err = mlx5_copy_to_recv_srq(srq, wqe_ctr, cqe - 1,
 						    ntohl(cqe->byte_cnt));
 	} else {
@@ -169,10 +169,10 @@ static inline int handle_responder_lazy(struct mlx5_cq *cq, struct mlx5_cqe64 *c
 		wqe_ctr = wq->tail & (wq->wqe_cnt - 1);
 		cq->ibv_cq.wr_id = wq->wrid[wqe_ctr];
 		++wq->tail;
-		if (cqe->op_own & MLX5_INLINE_SCATTER_32)
+		if (mlx5dv_get_cqe_format(cqe) == MLX5_INLINE_SCATTER_32)
 			err = mlx5_copy_to_recv_wqe(qp, wqe_ctr, cqe,
 						    ntohl(cqe->byte_cnt));
-		else if (cqe->op_own & MLX5_INLINE_SCATTER_64)
+		else if (mlx5dv_get_cqe_format(cqe) == MLX5_INLINE_SCATTER_64)
 			err = mlx5_copy_to_recv_wqe(qp, wqe_ctr, cqe - 1,
 						    ntohl(cqe->byte_cnt));
 }
@@ -194,10 +194,10 @@ static inline int handle_responder(struct ibv_wc *wc, struct mlx5_cqe64 *cqe,
 		wqe_ctr = ntohs(cqe->wqe_counter);
 		wc->wr_id = srq->wrid[wqe_ctr];
 		mlx5_free_srq_wqe(srq, wqe_ctr);
-		if (cqe->op_own & MLX5_INLINE_SCATTER_32)
+		if (mlx5dv_get_cqe_format(cqe) == MLX5_INLINE_SCATTER_32)
 			err = mlx5_copy_to_recv_srq(srq, wqe_ctr, cqe,
 						    wc->byte_len);
-		else if (cqe->op_own & MLX5_INLINE_SCATTER_64)
+		else if (mlx5dv_get_cqe_format(cqe) == MLX5_INLINE_SCATTER_64)
 			err = mlx5_copy_to_recv_srq(srq, wqe_ctr, cqe - 1,
 						    wc->byte_len);
 	} else {
@@ -216,10 +216,10 @@ static inline int handle_responder(struct ibv_wc *wc, struct mlx5_cqe64 *cqe,
 		wqe_ctr = wq->tail & (wq->wqe_cnt - 1);
 		wc->wr_id = wq->wrid[wqe_ctr];
 		++wq->tail;
-		if (cqe->op_own & MLX5_INLINE_SCATTER_32)
+		if (mlx5dv_get_cqe_format(cqe) == MLX5_INLINE_SCATTER_32)
 			err = mlx5_copy_to_recv_wqe(qp, wqe_ctr, cqe,
 						    wc->byte_len);
-		else if (cqe->op_own & MLX5_INLINE_SCATTER_64)
+		else if (mlx5dv_get_cqe_format(cqe) == MLX5_INLINE_SCATTER_64)
 			err = mlx5_copy_to_recv_wqe(qp, wqe_ctr, cqe - 1,
 						    wc->byte_len);
 	}
@@ -572,10 +572,10 @@ static inline int mlx5_parse_cqe(struct mlx5_cq *cq,
 				wc_byte_len = 8;
 
 			scatter_out:
-				if (cqe64->op_own & MLX5_INLINE_SCATTER_32)
+				if (mlx5dv_get_cqe_format(cqe64) == MLX5_INLINE_SCATTER_32)
 					err = mlx5_copy_to_send_wqe(
 					    mqp, wqe_ctr, cqe, wc_byte_len);
-				else if (cqe64->op_own & MLX5_INLINE_SCATTER_64)
+				else if (mlx5dv_get_cqe_format(cqe64) == MLX5_INLINE_SCATTER_64)
 					err = mlx5_copy_to_send_wqe(
 					    mqp, wqe_ctr, cqe - 1, wc_byte_len);
 				break;
@@ -586,10 +586,10 @@ static inline int mlx5_parse_cqe(struct mlx5_cq *cq,
 		} else {
 			handle_good_req(wc, cqe64, wq, idx);
 
-			if (cqe64->op_own & MLX5_INLINE_SCATTER_32)
+			if (mlx5dv_get_cqe_format(cqe64) == MLX5_INLINE_SCATTER_32)
 				err = mlx5_copy_to_send_wqe(mqp, wqe_ctr, cqe,
 							    wc->byte_len);
-			else if (cqe64->op_own & MLX5_INLINE_SCATTER_64)
+			else if (mlx5dv_get_cqe_format(cqe64) == MLX5_INLINE_SCATTER_64)
 				err = mlx5_copy_to_send_wqe(
 				    mqp, wqe_ctr, cqe - 1, wc->byte_len);
 
diff --git a/providers/mlx5/include/dv-cqe.h b/providers/mlx5/include/dv-cqe.h
index c36b7e0..d7d3dba 100644
--- a/providers/mlx5/include/dv-cqe.h
+++ b/providers/mlx5/include/dv-cqe.h
@@ -37,8 +37,8 @@
 #include <linux/types.h>
 
 enum {
-	MLX5_INLINE_SCATTER_32	= 0x4,
-	MLX5_INLINE_SCATTER_64	= 0x8,
+	MLX5_INLINE_SCATTER_32	= 0x1,
+	MLX5_INLINE_SCATTER_64	= 0x2,
 };
 
 enum {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
