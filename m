From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 10/10] net/mlx5: Remove the get protocol device interface entry
Date: Sun,  9 Dec 2018 19:04:42 -0800
Message-ID: <20181210030442.7543-11-saeedm@mellanox.com>
References: <20181210030442.7543-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181210030442.7543-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Or Gerlitz <ogerlitz@mellanox.com>

This isn't used anywhere across the mlx5 driver stack,
remove it.

Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c | 22 -------------------
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  8 -------
 include/linux/mlx5/driver.h                   |  2 --
 3 files changed, 32 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index d2ed14bc37c3..ebc046fa97d3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -256,28 +256,6 @@ void mlx5_reload_interface(struct mlx5_core_dev *mdev, int protocol)
 	mutex_unlock(&mlx5_intf_mutex);
 }
 
-void *mlx5_get_protocol_dev(struct mlx5_core_dev *mdev, int protocol)
-{
-	struct mlx5_priv *priv = &mdev->priv;
-	struct mlx5_device_context *dev_ctx;
-	unsigned long flags;
-	void *result = NULL;
-
-	spin_lock_irqsave(&priv->ctx_lock, flags);
-
-	list_for_each_entry(dev_ctx, &mdev->priv.ctx_list, list)
-		if ((dev_ctx->intf->protocol == protocol) &&
-		    dev_ctx->intf->get_dev) {
-			result = dev_ctx->intf->get_dev(dev_ctx->context);
-			break;
-		}
-
-	spin_unlock_irqrestore(&priv->ctx_lock, flags);
-
-	return result;
-}
-EXPORT_SYMBOL(mlx5_get_protocol_dev);
-
 /* Must be called with intf_mutex held */
 void mlx5_add_dev_by_protocol(struct mlx5_core_dev *dev, int protocol)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 56bc41b1c31f..a43092de3cc0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5160,20 +5160,12 @@ static void mlx5e_remove(struct mlx5_core_dev *mdev, void *vpriv)
 	kfree(ppriv);
 }
 
-static void *mlx5e_get_netdev(void *vpriv)
-{
-	struct mlx5e_priv *priv = vpriv;
-
-	return priv->netdev;
-}
-
 static struct mlx5_interface mlx5e_interface = {
 	.add       = mlx5e_add,
 	.remove    = mlx5e_remove,
 	.attach    = mlx5e_attach,
 	.detach    = mlx5e_detach,
 	.protocol  = MLX5_INTERFACE_PROTOCOL_ETH,
-	.get_dev   = mlx5e_get_netdev,
 };
 
 void mlx5e_init(void)
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 584d8a5df7eb..cc29e880c733 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1004,12 +1004,10 @@ struct mlx5_interface {
 	void			(*remove)(struct mlx5_core_dev *dev, void *context);
 	int			(*attach)(struct mlx5_core_dev *dev, void *context);
 	void			(*detach)(struct mlx5_core_dev *dev, void *context);
-	void *                  (*get_dev)(void *context);
 	int			protocol;
 	struct list_head	list;
 };
 
-void *mlx5_get_protocol_dev(struct mlx5_core_dev *mdev, int protocol);
 int mlx5_register_interface(struct mlx5_interface *intf);
 void mlx5_unregister_interface(struct mlx5_interface *intf);
 int mlx5_notifier_register(struct mlx5_core_dev *dev, struct notifier_block *nb);
-- 
2.19.2
