From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 3/3] net/mlx5e: Enable local loopback in loopback selftest
Date: Tue, 30 May 2017 09:42:55 +0300
Message-ID: <20170530064255.3745-4-leon@kernel.org>
References: <20170530064255.3745-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170530064255.3745-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Huy Nguyen <huyn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Huy Nguyen <huyn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Before running the ethtool's loopback selftest, we need
to make sure that the local loopback is enabled.

Signed-off-by: Huy Nguyen <huyn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c b/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
index 5225f2226a67..8a074ad5cf3b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
@@ -189,6 +189,7 @@ struct mlx5e_lbt_priv {
 	struct packet_type pt;
 	struct completion comp;
 	bool loopback_ok;
+	bool local_lb;
 };
 
 static int
@@ -236,6 +237,13 @@ static int mlx5e_test_loopback_setup(struct mlx5e_priv *priv,
 {
 	int err = 0;
 
+	/* Temporarily enable local_lb */
+	if (MLX5_CAP_GEN(priv->mdev, disable_local_lb)) {
+		mlx5_nic_vport_query_local_lb(priv->mdev, &lbtp->local_lb);
+		if (!lbtp->local_lb)
+			mlx5_nic_vport_update_local_lb(priv->mdev, true);
+	}
+
 	err = mlx5e_refresh_tirs(priv, true);
 	if (err)
 		return err;
@@ -254,6 +262,11 @@ static int mlx5e_test_loopback_setup(struct mlx5e_priv *priv,
 static void mlx5e_test_loopback_cleanup(struct mlx5e_priv *priv,
 					struct mlx5e_lbt_priv *lbtp)
 {
+	if (MLX5_CAP_GEN(priv->mdev, disable_local_lb)) {
+		if (!lbtp->local_lb)
+			mlx5_nic_vport_update_local_lb(priv->mdev, false);
+	}
+
 	dev_remove_pack(&lbtp->pt);
 	mlx5e_refresh_tirs(priv, false);
 }
-- 
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
