From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core] mlx5: Return pointer to CQ doorbell
Date: Thu, 17 Aug 2017 16:36:38 +0300
Message-ID: <1502976998-20906-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The returned UAR pointer is actually void ** and points to whole
UAR database.

Because user is not supposed to access it and expected to use
the CQ doorbell, we will return uar[0] (CQ doorbell) directly
and eliminate the following logic in the applications:

uint64_t cq_db_reg = (uint64_t *)(((uint64_t)(uint64_t *)rxq->cq_uar) +
                     MLX5_CQ_DOORBELL;

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

Pull request was sent:
https://github.com/linux-rdma/rdma-core/pull/184

 providers/mlx5/mlx5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index ede91cb..c7a6efb 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -678,7 +678,7 @@ static int mlx5dv_get_cq(struct ibv_cq *cq_in,
 	cq_out->cqe_size  = mcq->cqe_sz;
 	cq_out->buf       = mcq->active_buf->buf;
 	cq_out->dbrec     = mcq->dbrec;
-	cq_out->uar	  = mctx->uar;
+	cq_out->uar	  = mctx->uar[0];
 
 	mcq->flags	 |= MLX5_CQ_FLAGS_DV_OWNED;
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
