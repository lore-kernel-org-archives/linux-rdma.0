From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 2/4] mlx5: Add interface to create DC transport QPs
Date: Thu,  4 Jan 2018 18:49:19 +0200
Message-ID: <1515084561-11374-3-git-send-email-yishaih@mellanox.com>
References: <1515084561-11374-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1515084561-11374-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Extend mlx5dv_create_qp() function to add attributes that are used to
create DC transport QPs, DCT (target) and DCI (initiator).

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/mlx5dv.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/providers/mlx5/mlx5dv.h b/providers/mlx5/mlx5dv.h
index 0e78c41..1f9bd0a 100644
--- a/providers/mlx5/mlx5dv.h
+++ b/providers/mlx5/mlx5dv.h
@@ -141,11 +141,23 @@ enum mlx5dv_qp_create_flags {
 
 enum mlx5dv_qp_init_attr_mask {
 	MLX5DV_QP_INIT_ATTR_MASK_QP_CREATE_FLAGS	= 1 << 0,
+	MLX5DV_QP_INIT_ATTR_MASK_DC			= 1 << 1,
+};
+
+enum mlx5dv_dc_type {
+	MLX5DV_DCTYPE_DCT     = 1,
+	MLX5DV_DCTYPE_DCI,
+};
+
+struct mlx5dv_dc_init_attr {
+	enum mlx5dv_dc_type	dc_type;
+	uint64_t dct_access_key;
 };
 
 struct mlx5dv_qp_init_attr {
 	uint64_t comp_mask;	/* Use enum mlx5dv_qp_init_attr_mask */
 	uint32_t create_flags;	/* Use enum mlx5dv_qp_create_flags */
+	struct mlx5dv_dc_init_attr  dc_init_attr;
 };
 
 struct ibv_qp *mlx5dv_create_qp(struct ibv_context *context,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
