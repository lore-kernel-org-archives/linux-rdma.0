From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/6] IB/mlx5: Add 128B CQE compression and padding HW bits
Date: Thu, 19 Oct 2017 08:25:51 +0300
Message-ID: <20171019052556.8514-2-leon@kernel.org>
References: <20171019052556.8514-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171019052556.8514-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Adding new bits in mlx5_ifc_cmd_hca_cap to get the hardware capabilities
for:
 - compression_128: Support 128B CQE compression
 - cqe_128_always: Support 128B CQE padding

Signed-off-by: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/linux/mlx5/mlx5_ifc.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index db655db45b77..d49928c314ed 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1047,7 +1047,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8	   num_of_uars_per_page[0x20];
 	u8         reserved_at_540[0x40];
 
-	u8         reserved_at_580[0x3f];
+	u8         reserved_at_580[0x3d];
+	u8         cqe_128_always[0x1];
+	u8         cqe_compression_128[0x1];
 	u8         cqe_compression[0x1];
 
 	u8         cqe_compression_timeout[0x10];
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
