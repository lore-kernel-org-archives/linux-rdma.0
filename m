From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 rdma-core 3/4] mlx5: Create DC transport QPs
Date: Sun, 21 Jan 2018 18:16:58 +0200
Message-ID: <1516551419-12829-4-git-send-email-yishaih@mellanox.com>
References: <1516551419-12829-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1516551419-12829-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Make changes in the flow of create_qp() to handle DC transport QPs.
Because DCT QP is a software abstraction to a DC target hardware object
the flow to create a DCT QPs takes almost nothing from the general flow
to create a QP. A DCI QP however, behaves almost like any other QP.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/mlx5-abi.h | 18 +++++++--
 providers/mlx5/mlx5.h     |  1 +
 providers/mlx5/verbs.c    | 95 ++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 109 insertions(+), 5 deletions(-)

diff --git a/providers/mlx5/mlx5-abi.h b/providers/mlx5/mlx5-abi.h
index 7b96429..6d5793f 100644
--- a/providers/mlx5/mlx5-abi.h
+++ b/providers/mlx5/mlx5-abi.h
@@ -45,6 +45,8 @@ enum {
 	MLX5_QP_FLAG_SCATTER_CQE	= 1 << 1,
 	MLX5_QP_FLAG_TUNNEL_OFFLOADS	= 1 << 2,
 	MLX5_QP_FLAG_BFREG_INDEX	= 1 << 3,
+	MLX5_QP_FLAG_TYPE_DCT		= 1 << 4,
+	MLX5_QP_FLAG_TYPE_DCI		= 1 << 5,
 };
 
 enum {
@@ -169,8 +171,12 @@ struct mlx5_create_qp_drv_ex {
 	__u32			flags;
 	__u32			uidx;
 	__u32			reserved;
-	/* SQ buffer address - used for Raw Packet QP */
-	__u64			sq_buf_addr;
+	union {
+		/* SQ buffer address - used for Raw Packet QP */
+		__u64			sq_buf_addr;
+		/* DC access key - used to create a DCT QP */
+		__u64			access_key;
+	};
 };
 
 struct mlx5_create_qp_ex {
@@ -205,8 +211,12 @@ struct mlx5_create_qp {
 	__u32				flags;
 	__u32                           uidx;
 	__u32                           bfreg_index;
-	/* SQ buffer address - used for Raw Packet QP */
-	__u64                           sq_buf_addr;
+	union {
+		/* SQ buffer address - used for Raw Packet QP */
+		__u64			sq_buf_addr;
+		/* DC access key - used to create a DCT QP */
+		__u64			access_key;
+	};
 };
 
 struct mlx5_create_qp_resp {
diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index d8b1858..fc97b12 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -511,6 +511,7 @@ struct mlx5_qp {
 	uint16_t			max_tso_header;
 	int                             rss_qp;
 	uint32_t			flags; /* Use enum mlx5_qp_flags */
+	enum mlx5dv_dc_type		dc_type;
 };
 
 struct mlx5_ah {
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index dafed18..800a5e7 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -1000,6 +1000,12 @@ static int sq_overhead(struct mlx5_qp *qp, enum ibv_qp_type qp_type)
 	    max_t(size_t, sizeof(struct mlx5_wqe_umr_klm_seg), 64);
 
 	switch (qp_type) {
+	case IBV_QPT_DRIVER:
+		if (qp->dc_type != MLX5DV_DCTYPE_DCI)
+			return -EINVAL;
+		size += sizeof(struct mlx5_wqe_datagram_seg);
+		SWITCH_FALLTHROUGH;
+
 	case IBV_QPT_RC:
 		size += sizeof(struct mlx5_wqe_ctrl_seg) +
 			max(sizeof(struct mlx5_wqe_atomic_seg) +
@@ -1483,7 +1489,8 @@ enum {
 };
 
 enum {
-	MLX5_DV_CREATE_QP_SUP_COMP_MASK = MLX5DV_QP_INIT_ATTR_MASK_QP_CREATE_FLAGS
+	MLX5_DV_CREATE_QP_SUP_COMP_MASK = MLX5DV_QP_INIT_ATTR_MASK_QP_CREATE_FLAGS |
+					  MLX5DV_QP_INIT_ATTR_MASK_DC
 };
 
 enum {
@@ -1493,6 +1500,62 @@ enum {
 					IBV_QP_INIT_ATTR_RX_HASH),
 };
 
+static int create_dct(struct ibv_context *context,
+		      struct ibv_qp_init_attr_ex *attr,
+		      struct mlx5dv_qp_init_attr *mlx5_qp_attr,
+		      struct mlx5_qp		       *qp)
+{
+	struct mlx5_create_qp		cmd = {};
+	struct mlx5_create_qp_resp	resp = {};
+	int				ret;
+	struct mlx5_context	       *ctx = to_mctx(context);
+	int32_t				usr_idx = 0xffffff;
+	FILE *fp = ctx->dbg_fp;
+
+	if (!check_comp_mask(attr->comp_mask, IBV_QP_INIT_ATTR_PD)) {
+		mlx5_dbg(fp, MLX5_DBG_QP,
+			 "Unsupported comp_mask for %s\n", __func__);
+		errno = EINVAL;
+		return errno;
+	}
+
+	if (!check_comp_mask(mlx5_qp_attr->comp_mask, MLX5DV_QP_INIT_ATTR_MASK_DC)) {
+		mlx5_dbg(fp, MLX5_DBG_QP,
+			 "Unsupported vendor comp_mask for %s\n", __func__);
+		errno = EINVAL;
+		return errno;
+	}
+
+	cmd.flags = MLX5_QP_FLAG_TYPE_DCT;
+	cmd.access_key = mlx5_qp_attr->dc_init_attr.dct_access_key;
+
+	if (ctx->cqe_version) {
+		usr_idx = mlx5_store_uidx(ctx, qp);
+		if (usr_idx < 0) {
+			mlx5_dbg(fp, MLX5_DBG_QP, "Couldn't find free user index\n");
+			errno = ENOMEM;
+			return errno;
+		}
+	}
+	cmd.uidx = usr_idx;
+
+	ret = ibv_cmd_create_qp_ex(context, &qp->verbs_qp, sizeof(qp->verbs_qp),
+				   attr, &cmd.ibv_cmd, sizeof(cmd),
+				   &resp.ibv_resp, sizeof(resp));
+	if (ret) {
+		mlx5_dbg(fp, MLX5_DBG_QP, "Couldn't create dct, ret %d\n", ret);
+		if (ctx->cqe_version)
+			mlx5_clear_uidx(ctx, cmd.uidx);
+		return ret;
+	}
+
+	qp->dc_type = MLX5DV_DCTYPE_DCT;
+	qp->rsc.type = MLX5_RSC_TYPE_QP;
+	if (ctx->cqe_version)
+		qp->rsc.rsn = usr_idx;
+	return 0;
+}
+
 static struct ibv_qp *create_qp(struct ibv_context *context,
 				struct ibv_qp_init_attr_ex *attr,
 				struct mlx5dv_qp_init_attr *mlx5_qp_attr)
@@ -1551,6 +1614,12 @@ static struct ibv_qp *create_qp(struct ibv_context *context,
 			goto err;
 		}
 
+		if ((mlx5_qp_attr->comp_mask & MLX5DV_QP_INIT_ATTR_MASK_DC) &&
+		    (attr->qp_type != IBV_QPT_DRIVER)) {
+			mlx5_dbg(fp, MLX5_DBG_QP, "DC QP must be of type IBV_QPT_DRIVER\n");
+			errno = EINVAL;
+			goto err;
+		}
 		if (mlx5_qp_attr->comp_mask &
 		    MLX5DV_QP_INIT_ATTR_MASK_QP_CREATE_FLAGS) {
 			if (mlx5_qp_attr->create_flags &
@@ -1563,6 +1632,30 @@ static struct ibv_qp *create_qp(struct ibv_context *context,
 				goto err;
 			}
 		}
+
+		if (attr->qp_type == IBV_QPT_DRIVER) {
+			if (mlx5_qp_attr->comp_mask & MLX5DV_QP_INIT_ATTR_MASK_DC) {
+				if (mlx5_qp_attr->dc_init_attr.dc_type == MLX5DV_DCTYPE_DCT) {
+					ret = create_dct(context, attr, mlx5_qp_attr, qp);
+					if (ret)
+						goto err;
+					return ibqp;
+				} else if (mlx5_qp_attr->dc_init_attr.dc_type == MLX5DV_DCTYPE_DCI) {
+					mlx5_create_flags |= MLX5_QP_FLAG_TYPE_DCI;
+					qp->dc_type = MLX5DV_DCTYPE_DCI;
+				} else {
+					errno = EINVAL;
+					goto err;
+				}
+			} else {
+				errno = EINVAL;
+				goto err;
+			}
+		}
+
+	} else {
+		if (attr->qp_type == IBV_QPT_DRIVER)
+			goto err;
 	}
 
 	if (attr->comp_mask & IBV_QP_INIT_ATTR_RX_HASH) {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
