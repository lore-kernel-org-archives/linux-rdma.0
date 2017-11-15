From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 3/3] mlx5: Support padded CQE by mlx5dv_create_cq
Date: Wed, 15 Nov 2017 16:23:42 +0200
Message-ID: <1510755822-15945-4-git-send-email-yishaih@mellanox.com>
References: <1510755822-15945-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510755822-15945-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch enables creating a padded 128B CQE using the direct verb
mlx5dv_create_cq.

Signed-off-by: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/mlx5-abi.h |  6 +++++-
 providers/mlx5/mlx5dv.h   |  9 ++++++++-
 providers/mlx5/verbs.c    | 23 +++++++++++++++++++++++
 3 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/providers/mlx5/mlx5-abi.h b/providers/mlx5/mlx5-abi.h
index 574688a..e1f5114 100644
--- a/providers/mlx5/mlx5-abi.h
+++ b/providers/mlx5/mlx5-abi.h
@@ -114,6 +114,10 @@ struct mlx5_alloc_pd_resp {
 	__u32				pdn;
 };
 
+enum mlx5_create_cq_flags {
+	MLX5_CREATE_CQ_FLAGS_CQE_128B_PAD	= 1 << 0,
+};
+
 struct mlx5_create_cq {
 	struct ibv_create_cq		ibv_cmd;
 	__u64				buf_addr;
@@ -121,7 +125,7 @@ struct mlx5_create_cq {
 	__u32				cqe_size;
 	__u8                            cqe_comp_en;
 	__u8                            cqe_comp_res_format;
-	__u16                           reserved;
+	__u16                           flags; /* Use enum mlx5_create_cq_flags */
 };
 
 struct mlx5_create_cq_resp {
diff --git a/providers/mlx5/mlx5dv.h b/providers/mlx5/mlx5dv.h
index 0073b9c..935ff54 100644
--- a/providers/mlx5/mlx5dv.h
+++ b/providers/mlx5/mlx5dv.h
@@ -98,12 +98,19 @@ enum mlx5dv_context_flags {
 
 enum mlx5dv_cq_init_attr_mask {
 	MLX5DV_CQ_INIT_ATTR_MASK_COMPRESSED_CQE	= 1 << 0,
-	MLX5DV_CQ_INIT_ATTR_MASK_RESERVED	= 1 << 1,
+	MLX5DV_CQ_INIT_ATTR_MASK_FLAGS		= 1 << 1,
+	MLX5DV_CQ_INIT_ATTR_MASK_RESERVED	= 1 << 2,
+};
+
+enum mlx5dv_cq_init_attr_flags {
+	MLX5DV_CQ_INIT_ATTR_FLAGS_CQE_PAD	= 1 << 0,
+	MLX5DV_CQ_INIT_ATTR_FLAGS_RESERVED	= 1 << 1,
 };
 
 struct mlx5dv_cq_init_attr {
 	uint64_t comp_mask; /* Use enum mlx5dv_cq_init_attr_mask */
 	uint8_t cqe_comp_res_format; /* Use enum mlx5dv_cqe_comp_res_format */
+	uint32_t flags; /* Use enum mlx5dv_cq_init_attr_flags */
 };
 
 struct ibv_cq_ex *mlx5dv_create_cq(struct ibv_context *context,
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index 7350697..19fc947 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -453,6 +453,29 @@ static struct ibv_cq_ex *create_cq(struct ibv_context *context,
 				goto err_db;
 			}
 		}
+
+		if (mlx5cq_attr->comp_mask & MLX5DV_CQ_INIT_ATTR_MASK_FLAGS) {
+			if (mlx5cq_attr->flags & ~(MLX5DV_CQ_INIT_ATTR_FLAGS_RESERVED - 1)) {
+				mlx5_dbg(fp, MLX5_DBG_CQ,
+					 "Unsupported vendor flags for create_cq\n");
+				errno = EINVAL;
+				goto err_db;
+			}
+
+			if (mlx5cq_attr->flags & MLX5DV_CQ_INIT_ATTR_FLAGS_CQE_PAD) {
+				if (!(mctx->vendor_cap_flags &
+				      MLX5_VENDOR_CAP_FLAGS_CQE_128B_PAD) ||
+				    (cqe_sz != 128)) {
+					mlx5_dbg(fp, MLX5_DBG_CQ,
+						 "%dB CQE paddind is not supported\n",
+						 cqe_sz);
+					errno = EINVAL;
+					goto err_db;
+				}
+
+				cmd.flags |= MLX5_CREATE_CQ_FLAGS_CQE_128B_PAD;
+			}
+		}
 	}
 
 	ret = ibv_cmd_create_cq(context, ncqe - 1, cq_attr->channel,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
