From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC for accelerated IPoIB 11/26] net/mlx5e: Support netdevice creation for IB link type
Date: Wed,  1 Mar 2017 16:02:19 +0200
Message-ID: <1488376954-8346-12-git-send-email-erezsh@mellanox.com>
References: <1488376954-8346-1-git-send-email-erezsh@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1488376954-8346-1-git-send-email-erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Implement required interface that will able the IB link to be run on top
of the ETH data structures.

Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 99 +++++++++++++++++++++++
 include/linux/mlx5/driver.h                       | 11 +++
 2 files changed, 110 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 88541f99d37b..dd7d1d123d38 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3843,6 +3843,105 @@ static void mlx5e_nic_disable(struct mlx5e_priv *priv)
 	mlx5_lag_remove(mdev);
 }
 
+static void mlx5i_nic_init(struct mlx5_core_dev *mdev,
+			   struct net_device *netdev,
+			   const struct mlx5e_profile *profile,
+			   void *ppriv)
+{
+	int base_size = *(int *)ppriv;
+	struct mlx5e_priv *priv = netdev_priv(netdev) + base_size;
+
+	mlx5n_build_nic_netdev_priv_common(mdev, netdev, priv, profile, ppriv);
+}
+
+static int mlx5i_init_nic_rx(struct mlx5e_priv *priv)
+{
+	struct mlx5_core_dev *mdev = priv->mdev;
+	int err;
+
+	err = mlx5n_init_nic_rx_common(priv);
+	if (err) {
+		mlx5_core_warn(mdev, "failed create nic rx res, %d\n", err);
+		return err;
+	}
+
+	err = mlx5i_create_flow_steering(priv);
+	if (err) {
+		mlx5_core_warn(mdev, "create flow steering failed, %d\n", err);
+		return err;
+	}
+
+	return 0;
+}
+
+static void mlx5i_cleanup_nic_rx(struct mlx5e_priv *priv)
+{
+	mlx5i_destroy_flow_steering(priv);
+	mlx5n_cleanup_nic_rx_common(priv);
+}
+
+static const struct mlx5e_profile mlx5i_nic_profile = {
+	.init		   = mlx5i_nic_init,
+	.cleanup	   = NULL,
+	.init_rx	   = mlx5i_init_nic_rx,
+	.cleanup_rx	   = mlx5i_cleanup_nic_rx,
+	.init_tx	   = mlx5e_init_nic_tx,
+	.cleanup_tx	   = mlx5e_cleanup_nic_tx,
+	.enable		   = NULL,/*mlx5e_nic_enable,*/
+	.disable	   = NULL,
+	.update_stats	   = NULL,/*mlx5e_update_stats,*/
+	.max_nch	   = mlx5e_get_max_num_channels,
+	.max_tc		   = MLX5E_MAX_NUM_TC,
+};
+
+struct net_device *mlx5i_create_netdev(struct mlx5_core_dev *mdev,
+				       const char *name,
+				       void (*setup)(struct net_device *dev),
+				       struct mlx5i_create_ext_param *param)
+{
+	const struct mlx5e_profile *profile = &mlx5i_nic_profile;
+	int nch = profile->max_nch(mdev);
+	struct net_device *netdev;
+	struct mlx5e_priv *priv;
+
+	if (mlx5e_check_required_hca_cap(mdev, MLX5_INTERFACE_PROTOCOL_IB))
+		return NULL;
+
+	netdev = alloc_netdev_mqs(sizeof(struct mlx5e_priv) + param->size_base_priv,
+				  name, NET_NAME_UNKNOWN,
+				  setup,
+				  nch * MLX5E_MAX_NUM_TC,
+				  nch);
+	if (!netdev) {
+		pr_err("alloc_netdev_mqs failed\n");
+		return NULL;
+	}
+
+	if (profile->init)
+		profile->init(mdev, netdev, profile, &param->size_base_priv);
+
+	netif_carrier_off(netdev);
+
+	priv = netdev_priv(netdev) + param->size_base_priv;
+
+	priv->underlay_qpn = param->qpn;
+
+	priv->wq = create_singlethread_workqueue("mlx5i");
+	if (!priv->wq)
+		goto err_cleanup_nic;
+
+	return netdev;
+
+err_cleanup_nic:
+	if (profile->cleanup)
+		profile->cleanup(priv);
+
+	free_netdev(netdev);
+
+	return NULL;
+}
+EXPORT_SYMBOL(mlx5i_create_netdev);
+
 static const struct mlx5e_profile mlx5e_nic_profile = {
 	.init		   = mlx5e_nic_init,
 	.cleanup	   = mlx5e_nic_cleanup,
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 886ff2b00500..0acf099e9d06 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1127,4 +1127,15 @@ enum {
 	MLX5_TRIGGERED_CMD_COMP = (u64)1 << 32,
 };
 
+struct mlx5i_create_ext_param {
+	int	size_base_priv;
+	u32	qpn;
+};
+
+struct net_device *mlx5i_create_netdev(struct mlx5_core_dev *mdev,
+				       const char *name,
+				       void (*setup)(struct net_device *dev),
+				       struct mlx5i_create_ext_param *param);
+int mlx5i_attach(struct mlx5_core_dev *mdev, void *vpriv);
+void mlx5i_detach(struct mlx5_core_dev *mdev, void *vpriv);
 #endif /* MLX5_DRIVER_H */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
