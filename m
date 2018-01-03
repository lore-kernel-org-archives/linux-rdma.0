From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: [PATCH] net/mlx5e: hide an unused variable
Date: Wed,  3 Jan 2018 23:40:11 +0100
Message-ID: <20180103224022.3737385-1-arnd@arndb.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Paul Blakey <paulb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The uplink_rpriv variable was added at the start of the function but
only used inside of an #ifdef:

drivers/net/ethernet/mellanox/mlx5/core/en_tc.c: In function 'mlx5e_route_lookup_ipv6':
drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:1549:25: error: unused variable 'uplink_rpriv' [-Werror=unused-variable]

This moves the declaration into that #ifdef as well.

Fixes: 5ed99fb421d4 ("net/mlx5e: Move ethernet representors data into separate struct")
Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 25a8073f15d8..933275fe03b2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1546,11 +1546,11 @@ static int mlx5e_route_lookup_ipv6(struct mlx5e_priv *priv,
 				   struct neighbour **out_n,
 				   int *out_ttl)
 {
-	struct mlx5e_rep_priv *uplink_rpriv;
 	struct neighbour *n = NULL;
 	struct dst_entry *dst;
 
 #if IS_ENABLED(CONFIG_INET) && IS_ENABLED(CONFIG_IPV6)
+	struct mlx5e_rep_priv *uplink_rpriv;
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	int ret;
 
-- 
2.9.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
