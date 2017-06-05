From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 5/6] net/mlx5: Report enhanced capabilities for IPoIB
Date: Mon,  5 Jun 2017 08:00:20 +0300
Message-ID: <20170605050021.12236-6-leon@kernel.org>
References: <20170605050021.12236-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170605050021.12236-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Report 'ipoib_enhanced_offloads' capabilities from
the core layer, it will be used in the next patch from this series.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw.c | 6 ++++++
 include/linux/mlx5/device.h                  | 6 +++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
index 1bc14d0fded8..cf468be1479c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -119,6 +119,12 @@ int mlx5_query_hca_caps(struct mlx5_core_dev *dev)
 			return err;
 	}

+	if (MLX5_CAP_GEN(dev, ipoib_enhanced_offloads)) {
+		err = mlx5_core_get_caps(dev, MLX5_CAP_IPOIB_ENHANCED_OFFLOADS);
+		if (err)
+			return err;
+	}
+
 	if (MLX5_CAP_GEN(dev, pg)) {
 		err = mlx5_core_get_caps(dev, MLX5_CAP_ODP);
 		if (err)
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index a940ec6a046c..72a5ef0ad40e 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -966,7 +966,7 @@ enum mlx5_cap_type {
 	MLX5_CAP_ATOMIC,
 	MLX5_CAP_ROCE,
 	MLX5_CAP_IPOIB_OFFLOADS,
-	MLX5_CAP_EOIB_OFFLOADS,
+	MLX5_CAP_IPOIB_ENHANCED_OFFLOADS,
 	MLX5_CAP_FLOW_TABLE,
 	MLX5_CAP_ESWITCH_FLOW_TABLE,
 	MLX5_CAP_ESWITCH,
@@ -1008,6 +1008,10 @@ enum mlx5_mcam_feature_groups {
 	MLX5_GET(per_protocol_networking_offload_caps,\
 		 mdev->caps.hca_max[MLX5_CAP_ETHERNET_OFFLOADS], cap)

+#define MLX5_CAP_IPOIB_ENHANCED(mdev, cap) \
+	MLX5_GET(per_protocol_networking_offload_caps,\
+		 mdev->caps.hca_cur[MLX5_CAP_IPOIB_ENHANCED_OFFLOADS], cap)
+
 #define MLX5_CAP_ROCE(mdev, cap) \
 	MLX5_GET(roce_cap, mdev->caps.hca_cur[MLX5_CAP_ROCE], cap)

--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
