From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 rdma-core 2/7] mlx5: Add CQE fields
Date: Tue, 14 Feb 2017 15:48:19 +0200
Message-ID: <1487080104-28991-3-git-send-email-yishaih@mellanox.com>
References: <1487080104-28991-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487080104-28991-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Introduce inline calls to get/set for most
commonly used CQE data path fields.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/mlx5dv.h | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/providers/mlx5/mlx5dv.h b/providers/mlx5/mlx5dv.h
index 34502a8..5709039 100644
--- a/providers/mlx5/mlx5dv.h
+++ b/providers/mlx5/mlx5dv.h
@@ -37,6 +37,13 @@
 #include <linux/types.h>
 #include <arpa/inet.h>
 
+/* Always inline the functions */
+#ifdef __GNUC__
+#define MLX5DV_ALWAYS_INLINE inline __attribute__((always_inline))
+#else
+#define MLX5DV_ALWAYS_INLINE inline
+#endif
+
 enum {
 	MLX5_RCV_DBR	= 0,
 	MLX5_SND_DBR	= 1,
@@ -264,6 +271,37 @@ struct mlx5_cqe64 {
 	uint8_t		op_own;
 };
 
+static MLX5DV_ALWAYS_INLINE
+uint8_t mlx5dv_get_cqe_owner(struct mlx5_cqe64 *cqe)
+{
+	return cqe->op_own & 0x1;
+}
+
+static MLX5DV_ALWAYS_INLINE
+void mlx5dv_set_cqe_owner(struct mlx5_cqe64 *cqe, uint8_t val)
+{
+	cqe->op_own = (val & 0x1) | (cqe->op_own & ~0x1);
+}
+
+/* Solicited event */
+static MLX5DV_ALWAYS_INLINE
+uint8_t mlx5dv_get_cqe_se(struct mlx5_cqe64 *cqe)
+{
+	return (cqe->op_own >> 1) & 0x1;
+}
+
+static MLX5DV_ALWAYS_INLINE
+uint8_t mlx5dv_get_cqe_format(struct mlx5_cqe64 *cqe)
+{
+	return (cqe->op_own >> 2) & 0x3;
+}
+
+static MLX5DV_ALWAYS_INLINE
+uint8_t mlx5dv_get_cqe_opcode(struct mlx5_cqe64 *cqe)
+{
+	return cqe->op_own >> 4;
+}
+
 /*
  * WQE related part
  */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
