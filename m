From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 2/2] mlx5: Update mlx5dv_query_device man page
Date: Sun, 29 Oct 2017 13:07:38 +0200
Message-ID: <1509275258-9808-3-git-send-email-yishaih@mellanox.com>
References: <1509275258-9808-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1509275258-9808-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add details on CQE compression and SW parsing support.

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/man/mlx5dv_query_device.3 | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/providers/mlx5/man/mlx5dv_query_device.3 b/providers/mlx5/man/mlx5dv_query_device.3
index c2fe9a3..7a36717 100644
--- a/providers/mlx5/man/mlx5dv_query_device.3
+++ b/providers/mlx5/man/mlx5dv_query_device.3
@@ -21,11 +21,21 @@ of the internal hardware structures that mlx5dv.h represents. Additions of new f
 structures are handled by comp_mask field.
 .PP
 .nf
+struct mlx5dv_sw_parsing_caps {
+.in +8
+uint32_t sw_parsing_offloads; /* Use enum mlx5dv_sw_parsing_offloads */
+uint32_t supported_qpts;
+.in -8
+};
+.PP
+.nf
 struct mlx5dv_context {
 .in +8
 uint8_t         version;
 uint64_t        flags;
-uint64_t        comp_mask;
+uint64_t        comp_mask; /* Use enum mlx5dv_context_comp_mask */
+struct mlx5dv_cqe_comp_caps     cqe_comp_caps;
+struct mlx5dv_sw_parsing_caps sw_parsing_caps;
 .in -8
 };
 
@@ -40,6 +50,26 @@ enum mlx5dv_context_flags {
  MLX5DV_CONTEXT_FLAGS_ENHANCED_MPW = (1 << 3), /* Enhanced multi packet WQE is supported or not */
 .in -8
 };
+
+.PP
+.nf
+enum mlx5dv_context_comp_mask {
+.in +8
+MLX5DV_CONTEXT_MASK_CQE_COMPRESION      = 1 << 0,
+MLX5DV_CONTEXT_MASK_SWP                 = 1 << 1,
+MLX5DV_CONTEXT_MASK_RESERVED            = 1 << 2,
+.in -8
+};
+
+.PP
+.nf
+enum enum mlx5dv_sw_parsing_offloads {
+.in +8
+MLX5DV_SW_PARSING         = 1 << 0,
+MLX5DV_SW_PARSING_CSUM    = 1 << 1,
+MLX5DV_SW_PARSING_LSO     = 1 << 2,
+.in -8
+};
 .fi
 .SH "RETURN VALUE"
 0 on success or the value of errno on failure (which indicates the failure reason).
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
