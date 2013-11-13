From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V5 8/8] mlx4_en: Avoid setting netdevice dev_id to port number
Date: Thu, 14 Nov 2013 00:29:52 +0200
Message-ID: <1384381792-2023-9-git-send-email-ogerlitz@mellanox.com>
References: <1384381792-2023-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1384381792-2023-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Narendra K <narendra_k-8PEkshWhKlo@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

The port number should not be stored in dev_id.

The netdevice dev_id field was intended to be used to differentiate
between multiple devices which share the same MAC address. Moreover,  this
make the kernel to assign wrong link local IPv6 address to mlx4_en netdevices.

Signed-off-by: Narendra K <narendra_k-8PEkshWhKlo@public.gmane.org>
Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index fa37b7a..b8dbb1a 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2191,7 +2191,6 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 	netif_set_real_num_rx_queues(dev, prof->rx_ring_num);
 
 	SET_NETDEV_DEV(dev, &mdev->dev->pdev->dev);
-	dev->dev_id =  port - 1;
 
 	/*
 	 * Initialize driver private data
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
