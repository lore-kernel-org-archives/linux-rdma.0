From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 2/7] mlx4: Add CQE fields
Date: Thu, 29 Jun 2017 14:47:03 +0300
Message-ID: <1498736828-17875-3-git-send-email-yishaih@mellanox.com>
References: <1498736828-17875-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498736828-17875-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Introduce inline calls to get/set for most
commonly used CQE data path fields.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx4/mlx4dv.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/providers/mlx4/mlx4dv.h b/providers/mlx4/mlx4dv.h
index 86b4e13..e677fe1 100644
--- a/providers/mlx4/mlx4dv.h
+++ b/providers/mlx4/mlx4dv.h
@@ -37,6 +37,13 @@
 #include <endian.h>
 #include <infiniband/verbs.h>
 
+/* Always inline the functions */
+#ifdef __GNUC__
+#define MLX4DV_ALWAYS_INLINE inline __attribute__((always_inline))
+#else
+#define MLX4DV_ALWAYS_INLINE inline
+#endif
+
 enum {
 	MLX4_OPCODE_NOP			= 0x00,
 	MLX4_OPCODE_SEND_INVAL		= 0x01,
@@ -219,6 +226,25 @@ enum mlx4dv_obj_type {
  */
 int mlx4dv_init_obj(struct mlx4dv_obj *obj, uint64_t obj_type);
 
+static MLX4DV_ALWAYS_INLINE
+uint8_t mlx4dv_get_cqe_owner(struct mlx4_cqe *cqe)
+{
+	return cqe->owner_sr_opcode & MLX4_CQE_OWNER_MASK;
+}
+
+static MLX4DV_ALWAYS_INLINE
+void mlx4dv_set_cqe_owner(struct mlx4_cqe *cqe, uint8_t val)
+{
+	cqe->owner_sr_opcode = (val & MLX4_CQE_OWNER_MASK) |
+		(cqe->owner_sr_opcode & ~MLX4_CQE_OWNER_MASK);
+}
+
+static MLX4DV_ALWAYS_INLINE
+uint8_t mlx4dv_get_cqe_opcode(struct mlx4_cqe *cqe)
+{
+	return cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK;
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
