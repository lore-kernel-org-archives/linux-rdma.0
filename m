From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 1/2] mlx5: Few small fixes
Date: Tue,  9 May 2017 19:45:21 +0300
Message-ID: <1494348322-4526-2-git-send-email-yishaih@mellanox.com>
References: <1494348322-4526-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1494348322-4526-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

1) Drop redundant line as part of CQE parsing and fix indentation.
2) Under DEBUG mode add a missing 'static' declaration.

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/cq.c | 4 +---
 providers/mlx5/qp.c | 2 +-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/providers/mlx5/cq.c b/providers/mlx5/cq.c
index 2e8b584..288e08f 100644
--- a/providers/mlx5/cq.c
+++ b/providers/mlx5/cq.c
@@ -177,7 +177,7 @@ static inline int handle_responder_lazy(struct mlx5_cq *cq, struct mlx5_cqe64 *c
 		else if (cqe->op_own & MLX5_INLINE_SCATTER_64)
 			err = mlx5_copy_to_recv_wqe(qp, wqe_ctr, cqe - 1,
 						    be32toh(cqe->byte_cnt));
-}
+	}
 
 	return err;
 }
@@ -228,8 +228,6 @@ static inline int handle_responder(struct ibv_wc *wc, struct mlx5_cqe64 *cqe,
 	if (err)
 		return err;
 
-	wc->byte_len = be32toh(cqe->byte_cnt);
-
 	switch (cqe->op_own >> 4) {
 	case MLX5_CQE_RESP_WR_IMM:
 		wc->opcode	= IBV_WC_RECV_RDMA_WITH_IMM;
diff --git a/providers/mlx5/qp.c b/providers/mlx5/qp.c
index 1d5a2f9..5975755 100644
--- a/providers/mlx5/qp.c
+++ b/providers/mlx5/qp.c
@@ -317,7 +317,7 @@ static uint8_t wq_sig(struct mlx5_wqe_ctrl_seg *ctrl)
 }
 
 #ifdef MLX5_DEBUG
-void dump_wqe(FILE *fp, int idx, int size_16, struct mlx5_qp *qp)
+static void dump_wqe(FILE *fp, int idx, int size_16, struct mlx5_qp *qp)
 {
 	uint32_t *uninitialized_var(p);
 	int i, j;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
