From: bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Subject: [PATCH] IB/mlx5: report tx/rx checksum cap when query device
Date: Fri, 18 Dec 2015 13:53:20 +0200
Message-ID: <1450439601-49989-1-git-send-email-bodong@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch will report the tx/rx checksum cap for raw qp

Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 38aa490..101c17a 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -499,6 +499,10 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	if (MLX5_CAP_GEN(mdev, block_lb_mc))
 		props->device_cap_flags |= IB_DEVICE_BLOCK_MULTICAST_LOOPBACK;
 
+	if (MLX5_CAP_GEN(dev->mdev, eth_net_offloads) &&
+	    (MLX5_CAP_ETH(dev->mdev, csum_cap)))
+			props->device_cap_flags |= IB_DEVICE_RAW_IP_CSUM;
+
 	props->vendor_part_id	   = mdev->pdev->device;
 	props->hw_ver		   = mdev->pdev->revision;
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
