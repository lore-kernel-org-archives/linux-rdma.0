From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC for accelerated IPoIB 12/26] net/mlx5e: Refactor attach_netdev API
Date: Wed,  1 Mar 2017 16:02:20 +0200
Message-ID: <1488376954-8346-13-git-send-email-erezsh@mellanox.com>
References: <1488376954-8346-1-git-send-email-erezsh@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1488376954-8346-1-git-send-email-erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Use priv object instead of netdev object, will give tha ability to use
it for IB link.

Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 8 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c  | 4 +++-
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index f3337ec4457f..e5c8badc38c7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -918,7 +918,7 @@ struct net_device *mlx5e_create_netdev(struct mlx5_core_dev *mdev,
 				       const struct mlx5e_profile *profile,
 				       void *ppriv);
 void mlx5e_destroy_netdev(struct mlx5_core_dev *mdev, struct mlx5e_priv *priv);
-int mlx5e_attach_netdev(struct mlx5_core_dev *mdev, struct net_device *netdev);
+int mlx5e_attach_netdev(struct mlx5_core_dev *mdev, struct mlx5e_priv *priv);
 void mlx5e_detach_netdev(struct mlx5_core_dev *mdev, struct net_device *netdev);
 u32 mlx5e_choose_lro_timeout(struct mlx5_core_dev *mdev, u32 wanted_timeout);
 void mlx5e_add_vxlan_port(struct net_device *netdev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index dd7d1d123d38..4e9a11b94025 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3994,14 +3994,14 @@ struct net_device *mlx5e_create_netdev(struct mlx5_core_dev *mdev,
 	return NULL;
 }
 
-int mlx5e_attach_netdev(struct mlx5_core_dev *mdev, struct net_device *netdev)
+int mlx5e_attach_netdev(struct mlx5_core_dev *mdev, struct mlx5e_priv *priv)
 {
 	const struct mlx5e_profile *profile;
-	struct mlx5e_priv *priv;
+	struct net_device *netdev;
 	u16 max_mtu;
 	int err;
 
-	priv = netdev_priv(netdev);
+	netdev = priv->netdev;
 	profile = priv->profile;
 	clear_bit(MLX5E_STATE_DESTROYING, &priv->state);
 
@@ -4114,7 +4114,7 @@ static int mlx5e_attach(struct mlx5_core_dev *mdev, void *vpriv)
 	if (err)
 		return err;
 
-	err = mlx5e_attach_netdev(mdev, netdev);
+	err = mlx5e_attach_netdev(mdev, priv);
 	if (err) {
 		mlx5e_destroy_mdev_resources(mdev);
 		return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 850378893b25..0aad28da1638 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -556,6 +556,7 @@ int mlx5e_vport_rep_load(struct mlx5_eswitch *esw,
 			 struct mlx5_eswitch_rep *rep)
 {
 	struct net_device *netdev;
+	struct mlx5e_priv *priv;
 	int err;
 
 	netdev = mlx5e_create_netdev(esw->dev, &mlx5e_rep_profile, rep);
@@ -567,7 +568,8 @@ int mlx5e_vport_rep_load(struct mlx5_eswitch *esw,
 
 	rep->netdev = netdev;
 
-	err = mlx5e_attach_netdev(esw->dev, netdev);
+	priv = netdev_priv(netdev);
+	err = mlx5e_attach_netdev(esw->dev, priv);
 	if (err) {
 		pr_warn("Failed to attach representor netdev for vport %d\n",
 			rep->vport);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
