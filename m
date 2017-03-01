From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC for accelerated IPoIB 17/26] net/mlx5e: Change cleanup API in order to enable IB link
Date: Wed,  1 Mar 2017 16:02:25 +0200
Message-ID: <1488376954-8346-18-git-send-email-erezsh@mellanox.com>
References: <1488376954-8346-1-git-send-email-erezsh@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1488376954-8346-1-git-send-email-erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


1. Change the mlx5e_detach_netdev api.
2. Let that function to be called after the rtnl_lock is already held,
like done in IB link.

Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 18 +++++++++++-------
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c  |  4 ++--
 3 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 84db4761f09c..a10966df24f6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -921,7 +921,7 @@ struct net_device *mlx5e_create_netdev(struct mlx5_core_dev *mdev,
 				       void *ppriv);
 void mlx5e_destroy_netdev(struct mlx5_core_dev *mdev, struct mlx5e_priv *priv);
 int mlx5e_attach_netdev(struct mlx5_core_dev *mdev, struct mlx5e_priv *priv);
-void mlx5e_detach_netdev(struct mlx5_core_dev *mdev, struct net_device *netdev);
+void mlx5e_detach_netdev(struct mlx5_core_dev *mdev, struct mlx5e_priv *priv);
 u32 mlx5e_choose_lro_timeout(struct mlx5_core_dev *mdev, u32 wanted_timeout);
 void mlx5e_add_vxlan_port(struct net_device *netdev,
 			  struct udp_tunnel_info *ti);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 726d516b7ea8..42ac16daa126 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4022,7 +4022,7 @@ void mlx5i_detach(struct mlx5_core_dev *mdev, void *vpriv)
 	if (!netif_device_present(netdev))
 		return;
 
-	mlx5e_detach_netdev(mdev, netdev);
+	mlx5e_detach_netdev(mdev, priv);
 	mlx5e_destroy_mdev_resources(mdev);
 }
 EXPORT_SYMBOL(mlx5i_detach);
@@ -4127,18 +4127,22 @@ static void mlx5e_register_vport_rep(struct mlx5_core_dev *mdev)
 	}
 }
 
-void mlx5e_detach_netdev(struct mlx5_core_dev *mdev, struct net_device *netdev)
+void mlx5e_detach_netdev(struct mlx5_core_dev *mdev, struct mlx5e_priv *priv)
 {
-	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct net_device *netdev = priv->netdev;
 	const struct mlx5e_profile *profile = priv->profile;
-
+	bool locked = false;
 	set_bit(MLX5E_STATE_DESTROYING, &priv->state);
 
-	rtnl_lock();
+	if (!rtnl_is_locked()) {
+		rtnl_lock();
+		locked = true;
+	}
 	if (netif_running(netdev))
 		mlx5e_close(netdev);
 	netif_device_detach(netdev);
-	rtnl_unlock();
+	if (locked)
+		rtnl_unlock();
 
 	if (profile->disable)
 		profile->disable(priv);
@@ -4184,7 +4188,7 @@ static void mlx5e_detach(struct mlx5_core_dev *mdev, void *vpriv)
 	if (!netif_device_present(netdev))
 		return;
 
-	mlx5e_detach_netdev(mdev, netdev);
+	mlx5e_detach_netdev(mdev, priv);
 	mlx5e_destroy_mdev_resources(mdev);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 0aad28da1638..21d3d8e0bab7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -586,7 +586,7 @@ int mlx5e_vport_rep_load(struct mlx5_eswitch *esw,
 	return 0;
 
 err_detach_netdev:
-	mlx5e_detach_netdev(esw->dev, netdev);
+	mlx5e_detach_netdev(esw->dev, priv);
 
 err_destroy_netdev:
 	mlx5e_destroy_netdev(esw->dev, netdev_priv(netdev));
@@ -601,6 +601,6 @@ void mlx5e_vport_rep_unload(struct mlx5_eswitch *esw,
 	struct net_device *netdev = rep->netdev;
 
 	unregister_netdev(netdev);
-	mlx5e_detach_netdev(esw->dev, netdev);
+	mlx5e_detach_netdev(esw->dev, netdev_priv(netdev));
 	mlx5e_destroy_netdev(esw->dev, netdev_priv(netdev));
 }
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
