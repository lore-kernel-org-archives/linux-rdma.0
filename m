From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 8/9] mlx5: Add support for thread domain as part of QP creation
Date: Mon, 25 Dec 2017 15:57:00 +0200
Message-ID: <1514210221-10466-9-git-send-email-yishaih@mellanox.com>
References: <1514210221-10466-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1514210221-10466-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When a TD is supplied as part of QP creation use its internal BF.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/mlx5-abi.h |  3 ++-
 providers/mlx5/verbs.c    | 27 ++++++++++++++++++++++++---
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/providers/mlx5/mlx5-abi.h b/providers/mlx5/mlx5-abi.h
index ebe079b..7b96429 100644
--- a/providers/mlx5/mlx5-abi.h
+++ b/providers/mlx5/mlx5-abi.h
@@ -44,6 +44,7 @@ enum {
 	MLX5_QP_FLAG_SIGNATURE		= 1 << 0,
 	MLX5_QP_FLAG_SCATTER_CQE	= 1 << 1,
 	MLX5_QP_FLAG_TUNNEL_OFFLOADS	= 1 << 2,
+	MLX5_QP_FLAG_BFREG_INDEX	= 1 << 3,
 };
 
 enum {
@@ -203,7 +204,7 @@ struct mlx5_create_qp {
 	__u32				rq_wqe_shift;
 	__u32				flags;
 	__u32                           uidx;
-	__u32                           reserved;
+	__u32                           bfreg_index;
 	/* SQ buffer address - used for Raw Packet QP */
 	__u64                           sq_buf_addr;
 };
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index b8cbbe9..efecd93 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -1266,11 +1266,14 @@ static int mlx5_calc_wq_size(struct mlx5_context *ctx,
 }
 
 static void map_uuar(struct ibv_context *context, struct mlx5_qp *qp,
-		     int uuar_index)
+		     int uuar_index, struct mlx5_bf *dyn_bf)
 {
 	struct mlx5_context *ctx = to_mctx(context);
 
-	qp->bf = &ctx->bfs[uuar_index];
+	if (!dyn_bf)
+		qp->bf = &ctx->bfs[uuar_index];
+	else
+		qp->bf = dyn_bf;
 }
 
 static const char *qptype2key(enum ibv_qp_type type)
@@ -1501,7 +1504,9 @@ static struct ibv_qp *create_qp(struct ibv_context *context,
 	int32_t				usr_idx = 0;
 	uint32_t			uuar_index;
 	uint32_t			mlx5_create_flags = 0;
+	struct mlx5_bf			*bf = NULL;
 	FILE *fp = ctx->dbg_fp;
+	struct mlx5_parent_domain *mparent_domain;
 
 	if (attr->comp_mask & ~MLX5_CREATE_QP_SUP_COMP_MASK)
 		return NULL;
@@ -1515,6 +1520,7 @@ static struct ibv_qp *create_qp(struct ibv_context *context,
 		mlx5_dbg(fp, MLX5_DBG_QP, "\n");
 		return NULL;
 	}
+
 	ibqp = (struct ibv_qp *)&qp->verbs_qp;
 	qp->ibv_qp = ibqp;
 
@@ -1645,6 +1651,15 @@ static struct ibv_qp *create_qp(struct ibv_context *context,
 		cmd.uidx = usr_idx;
 	}
 
+	mparent_domain = to_mparent_domain(attr->pd);
+	if (mparent_domain && mparent_domain->mtd)
+		bf = mparent_domain->mtd->bf;
+
+	if (bf) {
+		cmd.bfreg_index = bf->bfreg_dyn_index;
+		cmd.flags |= MLX5_QP_FLAG_BFREG_INDEX;
+	}
+
 	if (attr->comp_mask & MLX5_CREATE_QP_EX2_COMP_MASK)
 		ret = mlx5_cmd_create_qp_ex(context, attr, &cmd, qp, &resp_ex);
 	else
@@ -1670,7 +1685,7 @@ static struct ibv_qp *create_qp(struct ibv_context *context,
 		pthread_mutex_unlock(&ctx->qp_table_mutex);
 	}
 
-	map_uuar(context, qp, uuar_index);
+	map_uuar(context, qp, uuar_index, bf);
 
 	qp->rq.max_post = qp->rq.wqe_cnt;
 	if (attr->sq_sig_all)
@@ -1686,6 +1701,8 @@ static struct ibv_qp *create_qp(struct ibv_context *context,
 	qp->rsc.rsn = (ctx->cqe_version && !is_xrc_tgt(attr->qp_type)) ?
 		      usr_idx : ibqp->qp_num;
 
+	if (mparent_domain)
+		atomic_fetch_add(&mparent_domain->mpd.refcount, 1);
 	return ibqp;
 
 err_destroy:
@@ -1775,6 +1792,7 @@ int mlx5_destroy_qp(struct ibv_qp *ibqp)
 	struct mlx5_qp *qp = to_mqp(ibqp);
 	struct mlx5_context *ctx = to_mctx(ibqp->context);
 	int ret;
+	struct mlx5_parent_domain *mparent_domain = to_mparent_domain(ibqp->pd);
 
 	if (qp->rss_qp) {
 		ret = ibv_cmd_destroy_qp(ibqp);
@@ -1814,6 +1832,9 @@ int mlx5_destroy_qp(struct ibv_qp *ibqp)
 	mlx5_free_db(ctx, qp->db);
 	mlx5_free_qp_buf(qp);
 free:
+	if (mparent_domain)
+		atomic_fetch_sub(&mparent_domain->mpd.refcount, 1);
+
 	free(qp);
 
 	return 0;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
