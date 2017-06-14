From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 2/5] IB/ipoib: Limit call to free rdma_netdev for capable devices
Date: Wed, 14 Jun 2017 09:59:06 +0300
Message-ID: <20170614065909.23650-3-leon@kernel.org>
References: <20170614065909.23650-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170614065909.23650-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Limit calls to free_rdma_netdev() for capable devices only.

Fixes: cd565b4b51e5 ('IB/IPoIB: Support acceleration options callbacks')
Signed-off-by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c         | 6 ++++--
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 5 ++++-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 0c79983c8b1a..9ecc089d4529 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3692,8 +3692,10 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	dev->ib_dev.check_mr_status	= mlx5_ib_check_mr_status;
 	dev->ib_dev.get_port_immutable  = mlx5_port_immutable;
 	dev->ib_dev.get_dev_fw_str      = get_dev_fw_str;
-	dev->ib_dev.alloc_rdma_netdev	= mlx5_ib_alloc_rdma_netdev;
-	dev->ib_dev.free_rdma_netdev	= mlx5_ib_free_rdma_netdev;
+	if (MLX5_CAP_GEN(mdev, ipoib_enhanced_offloads)) {
+		dev->ib_dev.alloc_rdma_netdev	= mlx5_ib_alloc_rdma_netdev;
+		dev->ib_dev.free_rdma_netdev	= mlx5_ib_free_rdma_netdev;
+	}
 	if (mlx5_core_is_pf(mdev)) {
 		dev->ib_dev.get_vf_config	= mlx5_ib_get_vf_config;
 		dev->ib_dev.set_vf_link_state	= mlx5_ib_set_vf_link_state;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 0ddd9709e1df..91fae34bdd4f 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -2301,7 +2301,10 @@ static void ipoib_remove_one(struct ib_device *device, void *client_data)
 		flush_workqueue(priv->wq);
 
 		unregister_netdev(priv->dev);
-		free_netdev(priv->dev);
+		if (device->free_rdma_netdev)
+			device->free_rdma_netdev(priv->dev);
+		else
+			free_netdev(priv->dev);
 
 		list_for_each_entry_safe(cpriv, tcpriv, &priv->child_intfs, list)
 			kfree(cpriv);
-- 
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
