From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net-next v2 04/12] net/mlx5e: Implement ndo_get_port_parent_id()
Date: Tue,  5 Feb 2019 14:13:03 -0800
Message-ID: <20190205221311.18476-5-f.fainelli@gmail.com>
References: <20190205221311.18476-1-f.fainelli@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190205221311.18476-1-f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: netdev@vger.kernel.org
Cc: Florian Fainelli <f.fainelli@gmail.com>, "David S. Miller" <davem@davemloft.net>, Ido Schimmel <idosch@mellanox.com>, open list <linux-kernel@vger.kernel.org>, "open list:MELLANOX MLX5 core VPI driver" <linux-rdma@vger.kernel.org>, "open list:NETRONOME ETHERNET DRIVERS" <oss-drivers@netronome.com>, "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>, "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>
List-Id: linux-rdma@vger.kernel.org

mlx5e only supports SWITCHDEV_ATTR_ID_PORT_PARENT_ID, which makes it a
great candidate to be converted to use the ndo_get_port_parent_id() NDO
instead of implementing switchdev_port_attr_get().

Since mlx5e makes use of switchdev_port_parent_id() convert it to use
netdev_port_same_parent_id().

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_tun.c   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 31 +++++++------------
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  5 ++-
 3 files changed, 14 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index 046948ead152..19dc4a963b90 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -25,7 +25,7 @@ static int get_route_and_out_devs(struct mlx5e_priv *priv,
 	/* if the egress device isn't on the same HW e-switch or
 	 * it's a LAG device, use the uplink
 	 */
-	if (!switchdev_port_same_parent_id(priv->netdev, dev) ||
+	if (!netdev_port_same_parent_id(priv->netdev, dev) ||
 	    dst_is_lag_dev) {
 		*route_dev = uplink_dev;
 		*out_dev = *route_dev;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 5d2e0c2f6624..0b1988b330f3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -381,7 +381,8 @@ static const struct ethtool_ops mlx5e_uplink_rep_ethtool_ops = {
 	.set_pauseparam    = mlx5e_uplink_rep_set_pauseparam,
 };
 
-static int mlx5e_attr_get(struct net_device *dev, struct switchdev_attr *attr)
+static int mlx5e_rep_get_port_parent_id(struct net_device *dev,
+					struct netdev_phys_item_id *ppid)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
@@ -398,20 +399,14 @@ static int mlx5e_attr_get(struct net_device *dev, struct switchdev_attr *attr)
 		uplink_priv = netdev_priv(uplink_dev);
 	}
 
-	switch (attr->id) {
-	case SWITCHDEV_ATTR_ID_PORT_PARENT_ID:
-		attr->u.ppid.id_len = ETH_ALEN;
-		if (uplink_upper && mlx5_lag_is_sriov(uplink_priv->mdev)) {
-			ether_addr_copy(attr->u.ppid.id, uplink_upper->dev_addr);
-		} else {
-			struct mlx5e_rep_priv *rpriv = priv->ppriv;
-			struct mlx5_eswitch_rep *rep = rpriv->rep;
+	ppid->id_len = ETH_ALEN;
+	if (uplink_upper && mlx5_lag_is_sriov(uplink_priv->mdev)) {
+		ether_addr_copy(ppid->id, uplink_upper->dev_addr);
+	} else {
+		struct mlx5e_rep_priv *rpriv = priv->ppriv;
+		struct mlx5_eswitch_rep *rep = rpriv->rep;
 
-			ether_addr_copy(attr->u.ppid.id, rep->hw_id);
-		}
-		break;
-	default:
-		return -EOPNOTSUPP;
+		ether_addr_copy(ppid->id, rep->hw_id);
 	}
 
 	return 0;
@@ -1284,10 +1279,6 @@ static int mlx5e_uplink_rep_set_vf_vlan(struct net_device *dev, int vf, u16 vlan
 	return 0;
 }
 
-static const struct switchdev_ops mlx5e_rep_switchdev_ops = {
-	.switchdev_port_attr_get	= mlx5e_attr_get,
-};
-
 static const struct net_device_ops mlx5e_netdev_ops_vf_rep = {
 	.ndo_open                = mlx5e_vf_rep_open,
 	.ndo_stop                = mlx5e_vf_rep_close,
@@ -1298,6 +1289,7 @@ static const struct net_device_ops mlx5e_netdev_ops_vf_rep = {
 	.ndo_has_offload_stats	 = mlx5e_rep_has_offload_stats,
 	.ndo_get_offload_stats	 = mlx5e_rep_get_offload_stats,
 	.ndo_change_mtu          = mlx5e_vf_rep_change_mtu,
+	.ndo_get_port_parent_id	 = mlx5e_rep_get_port_parent_id,
 };
 
 static const struct net_device_ops mlx5e_netdev_ops_uplink_rep = {
@@ -1319,6 +1311,7 @@ static const struct net_device_ops mlx5e_netdev_ops_uplink_rep = {
 	.ndo_get_vf_config       = mlx5e_get_vf_config,
 	.ndo_get_vf_stats        = mlx5e_get_vf_stats,
 	.ndo_set_vf_vlan         = mlx5e_uplink_rep_set_vf_vlan,
+	.ndo_get_port_parent_id	 = mlx5e_rep_get_port_parent_id,
 };
 
 bool mlx5e_eswitch_rep(struct net_device *netdev)
@@ -1393,8 +1386,6 @@ static void mlx5e_build_rep_netdev(struct net_device *netdev)
 	netdev->watchdog_timeo    = 15 * HZ;
 
 
-	netdev->switchdev_ops = &mlx5e_rep_switchdev_ops;
-
 	netdev->features	 |= NETIF_F_HW_TC | NETIF_F_NETNS_LOCAL;
 	netdev->hw_features      |= NETIF_F_HW_TC;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 74159d39dd66..098b28feba0c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -38,7 +38,6 @@
 #include <linux/mlx5/fs.h>
 #include <linux/mlx5/device.h>
 #include <linux/rhashtable.h>
-#include <net/switchdev.h>
 #include <net/tc_act/tc_mirred.h>
 #include <net/tc_act/tc_vlan.h>
 #include <net/tc_act/tc_tunnel_key.h>
@@ -2569,8 +2568,8 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv, struct tcf_exts *exts,
 
 			action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
 				  MLX5_FLOW_CONTEXT_ACTION_COUNT;
-			if (switchdev_port_same_parent_id(priv->netdev,
-							  out_dev) ||
+			if (netdev_port_same_parent_id(priv->netdev,
+						       out_dev) ||
 			    is_merged_eswitch_dev(priv, out_dev)) {
 				struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 				struct net_device *uplink_dev = mlx5_eswitch_uplink_get_proto_dev(esw, REP_ETH);
-- 
2.17.1
