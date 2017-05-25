From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/2] net/mlx5: Define interface bits for fencing UMR wqe
Date: Thu, 25 May 2017 23:13:38 +0300
Message-ID: <1495743219-1085-1-git-send-email-maxg@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org
Cc: shahar.salzman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

HW can implement UMR wqe re-transmission in various ways.
Thus, add HCA cap to distinguish the needed fence for UMR to make
sure that the wqe wouldn't fail on mkey checks.

Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Acked-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/linux/mlx5/mlx5_ifc.h |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 32de072..edafedb 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -766,6 +766,12 @@ enum {
 	MLX5_CAP_PORT_TYPE_ETH = 0x1,
 };
 
+enum {
+	MLX5_CAP_UMR_FENCE_STRONG	= 0x0,
+	MLX5_CAP_UMR_FENCE_SMALL	= 0x1,
+	MLX5_CAP_UMR_FENCE_NONE		= 0x2,
+};
+
 struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         reserved_at_0[0x80];
 
@@ -875,7 +881,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         reserved_at_202[0x1];
 	u8         ipoib_enhanced_offloads[0x1];
 	u8         ipoib_basic_offloads[0x1];
-	u8         reserved_at_205[0xa];
+	u8         reserved_at_205[0x5];
+	u8         umr_fence[0x2];
+	u8         reserved_at_20c[0x3];
 	u8         drain_sigerr[0x1];
 	u8         cmdif_checksum[0x2];
 	u8         sigerr_cqe[0x1];
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
