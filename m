From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RFC rdma-core 5/5] mlx5: Handles QP creation with a given parent domain
Date: Sun, 12 Nov 2017 23:41:43 +0200
Message-ID: <1510522903-6838-6-git-send-email-yishaih@mellanox.com>
References: <1510522903-6838-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510522903-6838-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch comes to demonstrate the expected usage of parent domain
and its internal thread domain as part of QP creation.

In case a parent domain was set, its internal protection domain (i.e.
ibv_pd) will be used for the PD usage and if a thread domain exists its
dedicated UAR will be used by passing its index to the mlx5
kernel driver. In that way application can control the UAR that this QP
will use and share it with other QPs upon their creation by suppling the
same thread domain.

A full patch will be supplied as part the final series post this RFC.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/mlx5-abi.h |  3 ++-
 providers/mlx5/verbs.c    | 41 +++++++++++++++++++++++++++++++++++++----
 2 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/providers/mlx5/mlx5-abi.h b/providers/mlx5/mlx5-abi.h
index d1e8b9d..1c6116c 100644
--- a/providers/mlx5/mlx5-abi.h
+++ b/providers/mlx5/mlx5-abi.h
@@ -43,6 +43,7 @@
 enum {
 	MLX5_QP_FLAG_SIGNATURE		= 1 << 0,
 	MLX5_QP_FLAG_SCATTER_CQE	= 1 << 1,
+	MLX5_QP_FLAG_UAR_INDEX		= 1 << 2,
 };
 
 enum {
@@ -196,7 +197,7 @@ struct mlx5_create_qp {
 	__u32				rq_wqe_shift;
 	__u32				flags;
 	__u32                           uidx;
-	__u32                           reserved;
+	__u32                           uar_user_index;
 	/* SQ buffer address - used for Raw Packet QP */
 	__u64                           sq_buf_addr;
 };
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index 13844b3..85e3841 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -1094,11 +1094,14 @@ static int mlx5_calc_wq_size(struct mlx5_context *ctx,
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
@@ -1309,6 +1312,19 @@ enum {
 					IBV_QP_INIT_ATTR_RX_HASH),
 };
 
+static void mlx5_get_domains(struct ibv_pd *pd, struct ibv_pd **protection_domain,
+				struct ibv_td **td)
+{
+	struct mlx5_pd *mpd = to_mpd(pd);
+	if (mpd->is_parent_domain) {
+		*protection_domain = mpd->protection_domain;
+		*td  = mpd->td;
+	} else {
+		*protection_domain = pd;
+		*td = NULL;
+	}
+}
+
 static struct ibv_qp *create_qp(struct ibv_context *context,
 			 struct ibv_qp_init_attr_ex *attr)
 {
@@ -1322,6 +1338,10 @@ static struct ibv_qp *create_qp(struct ibv_context *context,
 	int32_t				usr_idx = 0;
 	uint32_t			uuar_index;
 	FILE *fp = ctx->dbg_fp;
+	struct ibv_pd *pd;
+	struct ibv_td *td;
+	struct mlx5_td *mtd = NULL;
+	struct ibv_pd *attr_pd = attr->pd;
 
 	if (attr->comp_mask & ~MLX5_CREATE_QP_SUP_COMP_MASK)
 		return NULL;
@@ -1335,6 +1355,13 @@ static struct ibv_qp *create_qp(struct ibv_context *context,
 		mlx5_dbg(fp, MLX5_DBG_QP, "\n");
 		return NULL;
 	}
+
+	mlx5_get_domains(attr->pd, &pd, &td);
+	if (!pd)
+		goto err;
+	attr->pd = pd;
+	if (td)
+		mtd = to_mtd(td);
 	ibqp = (struct ibv_qp *)&qp->verbs_qp;
 	qp->ibv_qp = ibqp;
 
@@ -1440,6 +1467,11 @@ static struct ibv_qp *create_qp(struct ibv_context *context,
 		cmd.uidx = usr_idx;
 	}
 
+	if (mtd) {
+		cmd.uar_user_index = mtd->bf->uuarn;
+		cmd.flags |= MLX5_QP_FLAG_UAR_INDEX;
+	}
+
 	if (attr->comp_mask & MLX5_CREATE_QP_EX2_COMP_MASK)
 		ret = mlx5_cmd_create_qp_ex(context, attr, &cmd, qp, &resp_ex);
 	else
@@ -1465,7 +1497,7 @@ static struct ibv_qp *create_qp(struct ibv_context *context,
 		pthread_mutex_unlock(&ctx->qp_table_mutex);
 	}
 
-	map_uuar(context, qp, uuar_index);
+	map_uuar(context, qp, uuar_index, mtd ? mtd->bf : NULL);
 
 	qp->rq.max_post = qp->rq.wqe_cnt;
 	if (attr->sq_sig_all)
@@ -1481,6 +1513,7 @@ static struct ibv_qp *create_qp(struct ibv_context *context,
 	qp->rsc.rsn = (ctx->cqe_version && !is_xrc_tgt(attr->qp_type)) ?
 		      usr_idx : ibqp->qp_num;
 
+	attr->pd = attr_pd;
 	return ibqp;
 
 err_destroy:
@@ -1500,7 +1533,7 @@ err_free_qp_buf:
 
 err:
 	free(qp);
-
+	attr->pd = attr_pd;
 	return NULL;
 }
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
