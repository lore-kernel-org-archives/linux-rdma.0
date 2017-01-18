From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 08/11] IB/mlx5: Expose vlan offloads capabilities
Date: Wed, 18 Jan 2017 15:40:01 +0200
Message-ID: <20170118134004.5380-9-leon@kernel.org>
References: <20170118134004.5380-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170118134004.5380-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Check device's capabilities and report which raw packet capabilities
are supported.

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index a191b93..753635b 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -564,8 +564,15 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 		props->device_cap_flags |= IB_DEVICE_BLOCK_MULTICAST_LOOPBACK;
 
 	if (MLX5_CAP_GEN(dev->mdev, eth_net_offloads)) {
-		if (MLX5_CAP_ETH(mdev, csum_cap))
+		if (MLX5_CAP_ETH(mdev, csum_cap)) {
+			/* Legacy bit to support old userspace libraries */
 			props->device_cap_flags |= IB_DEVICE_RAW_IP_CSUM;
+			props->raw_packet_caps |= IB_RAW_PACKET_CAP_IP_CSUM;
+		}
+
+		if (MLX5_CAP_ETH(dev->mdev, vlan_cap))
+			props->raw_packet_caps |=
+				IB_RAW_PACKET_CAP_CVLAN_STRIPPING;
 
 		if (field_avail(typeof(resp), tso_caps, uhw->outlen)) {
 			max_tso = MLX5_CAP_ETH(mdev, max_lso_cap);
@@ -604,8 +611,11 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	}
 
 	if (MLX5_CAP_GEN(dev->mdev, eth_net_offloads) &&
-	    MLX5_CAP_ETH(dev->mdev, scatter_fcs))
+	    MLX5_CAP_ETH(dev->mdev, scatter_fcs)) {
+		/* Legacy bit to support old userspace libraries */
 		props->device_cap_flags |= IB_DEVICE_RAW_SCATTER_FCS;
+		props->raw_packet_caps |= IB_RAW_PACKET_CAP_SCATTER_FCS;
+	}
 
 	if (mlx5_get_flow_namespace(dev->mdev, MLX5_FLOW_NAMESPACE_BYPASS))
 		props->device_cap_flags |= IB_DEVICE_MANAGED_FLOW_STEERING;
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
