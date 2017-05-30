From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 6/6] IB/mlx5: Report RX checksum capabilities for IPoIB
Date: Tue, 30 May 2017 10:16:02 +0300
Message-ID: <20170530071602.8139-7-leon@kernel.org>
References: <20170530071602.8139-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170530071602.8139-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Report RX checksum capabilities when 'ipoib_enhanced_offloads'
capabilities are set and support checksum.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index d3f1c33a29fb..d6ccc00a306b 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -693,6 +693,10 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 		props->device_cap_flags |= IB_DEVICE_UD_TSO;
 	}

+	if (MLX5_CAP_GEN(mdev, ipoib_enhanced_offloads) &&
+	    MLX5_CAP_IPOIB_ENHANCED(mdev, csum_cap))
+		props->device_cap_flags |= IB_DEVICE_UD_IP_CSUM;
+
 	if (MLX5_CAP_GEN(dev->mdev, eth_net_offloads) &&
 	    MLX5_CAP_ETH(dev->mdev, scatter_fcs)) {
 		/* Legacy bit to support old userspace libraries */
--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
