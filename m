From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 21/30] net/mlx4: Postpone the registration of net_device
Date: Thu, 19 Feb 2015 15:53:47 +0530
Message-ID: <1c42ba0e-ac61-46d6-a15e-75cf1878f857@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The mlx4 network driver was registered in the context of the 'add'
function of the core driver (called when HW should be registered).
This makes the netdev event NETDEV_REGISTER to be sent in a context
where the answer to get_protocol_dev() callback returns NULL. This may
be confusing to listeners of netdev events.
This patch is a preparation to the patch that implements the
get_netdev() callback in the IB/mlx4 driver.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_main.c |   36 +++++++++++++++-----------
 drivers/net/ethernet/mellanox/mlx4/intf.c    |    3 ++
 include/linux/mlx4/driver.h                  |    1 +
 3 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_main.c b/drivers/net/ethernet/mellanox/mlx4/en_main.c
index 2859ac6..64b4f8d 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_main.c
@@ -219,6 +219,26 @@ static void mlx4_en_remove(struct mlx4_dev *dev, void *endev_ptr)
 	kfree(mdev);
 }
 
+static void mlx4_en_activate(struct mlx4_dev *dev, void *ctx)
+{
+	int i;
+	struct mlx4_en_dev *mdev = ctx;
+
+	/* Create a netdev for each port */
+	mlx4_foreach_port(i, dev, MLX4_PORT_TYPE_ETH) {
+		mlx4_info(mdev, "Activating port:%d\n", i);
+		if (mlx4_en_init_netdev(mdev, i, &mdev->profile.prof[i]))
+			mdev->pndev[i] = NULL;
+	}
+
+	/* register notifier */
+	mdev->nb.notifier_call = mlx4_en_netdev_event;
+	if (register_netdevice_notifier(&mdev->nb)) {
+		mdev->nb.notifier_call = NULL;
+		mlx4_err(mdev, "Failed to create notifier\n");
+	}
+}
+
 static void *mlx4_en_add(struct mlx4_dev *dev)
 {
 	struct mlx4_en_dev *mdev;
@@ -292,21 +312,6 @@ static void *mlx4_en_add(struct mlx4_dev *dev)
 	mutex_init(&mdev->state_lock);
 	mdev->device_up = true;
 
-	/* Setup ports */
-
-	/* Create a netdev for each port */
-	mlx4_foreach_port(i, dev, MLX4_PORT_TYPE_ETH) {
-		mlx4_info(mdev, "Activating port:%d\n", i);
-		if (mlx4_en_init_netdev(mdev, i, &mdev->profile.prof[i]))
-			mdev->pndev[i] = NULL;
-	}
-	/* register notifier */
-	mdev->nb.notifier_call = mlx4_en_netdev_event;
-	if (register_netdevice_notifier(&mdev->nb)) {
-		mdev->nb.notifier_call = NULL;
-		mlx4_err(mdev, "Failed to create notifier\n");
-	}
-
 	return mdev;
 
 err_mr:
@@ -330,6 +335,7 @@ static struct mlx4_interface mlx4_en_interface = {
 	.event		= mlx4_en_event,
 	.get_dev	= mlx4_en_get_netdev,
 	.protocol	= MLX4_PROT_ETH,
+	.activate	= mlx4_en_activate,
 };
 
 static void mlx4_en_verify_params(void)
diff --git a/drivers/net/ethernet/mellanox/mlx4/intf.c b/drivers/net/ethernet/mellanox/mlx4/intf.c
index a1a5985..ada70cb 100644
--- a/drivers/net/ethernet/mellanox/mlx4/intf.c
+++ b/drivers/net/ethernet/mellanox/mlx4/intf.c
@@ -65,6 +65,9 @@ static void mlx4_add_device(struct mlx4_interface *intf, struct mlx4_priv *priv)
 		spin_unlock_irq(&priv->ctx_lock);
 	} else
 		kfree(dev_ctx);
+
+	if (intf->activate)
+		intf->activate(&priv->dev, dev_ctx->context);
 }
 
 static void mlx4_remove_device(struct mlx4_interface *intf, struct mlx4_priv *priv)
diff --git a/include/linux/mlx4/driver.h b/include/linux/mlx4/driver.h
index 9553a73..5a06d96 100644
--- a/include/linux/mlx4/driver.h
+++ b/include/linux/mlx4/driver.h
@@ -59,6 +59,7 @@ struct mlx4_interface {
 	void			(*event) (struct mlx4_dev *dev, void *context,
 					  enum mlx4_dev_event event, unsigned long param);
 	void *			(*get_dev)(struct mlx4_dev *dev, void *context, u8 port);
+	void			(*activate)(struct mlx4_dev *dev, void *context);
 	struct list_head	list;
 	enum mlx4_protocol	protocol;
 	int			flags;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
