From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 12/15] net/mlx5: Refactor queries to speed fields in Port Type and Speed register
Date: Tue, 12 Feb 2019 22:55:43 -0800
Message-ID: <20190213065546.3013-13-saeedm@mellanox.com>
References: <20190213065546.3013-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190213065546.3013-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Aya Levin <ayal@mellanox.com>, Eran Ben Elisha <eranbe@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

This patch fascicles queries to speed related fields in Port Type and
Speed register (PTYS) into a single API. I addition, this patch
refactors functions which serves only Ethernet driver: remove the
protocol type as an input parameter, move code from 'core' directory
into 'en' directory and add 'eth' prefix to the function's name. The
patch also encapsulates functions that are not used outside the Ethernet
driver removes redundant include files.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c             |   6 +-
 .../net/ethernet/mellanox/mlx5/core/en/port.c |  75 +++++++++++--
 .../net/ethernet/mellanox/mlx5/core/en/port.h |  12 ++
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  23 ++--
 .../net/ethernet/mellanox/mlx5/core/port.c    | 106 ------------------
 include/linux/mlx5/port.h                     |  11 --
 6 files changed, 91 insertions(+), 142 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 87ce62e44898..efd08b41126c 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -393,6 +393,7 @@ static int mlx5_query_port_roce(struct ib_device *device, u8 port_num,
 				struct ib_port_attr *props)
 {
 	struct mlx5_ib_dev *dev = to_mdev(device);
+	u32 out[MLX5_ST_SZ_DW(ptys_reg)] = {0};
 	struct mlx5_core_dev *mdev;
 	struct net_device *ndev, *upper;
 	enum ib_mtu ndev_ib_mtu;
@@ -416,10 +417,11 @@ static int mlx5_query_port_roce(struct ib_device *device, u8 port_num,
 	/* Possible bad flows are checked before filling out props so in case
 	 * of an error it will still be zeroed out.
 	 */
-	err = mlx5_query_port_eth_proto_oper(mdev, &eth_prot_oper,
-					     mdev_port_num);
+	err = mlx5_query_port_ptys(mdev, out, sizeof(out), MLX5_PTYS_EN,
+				   mdev_port_num);
 	if (err)
 		goto out;
+	eth_prot_oper = MLX5_GET(ptys_reg, out, eth_proto_oper);
 
 	props->active_width     = IB_WIDTH_4X;
 	props->active_speed     = IB_SPEED_QDR;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
index 4a37713023be..9a1c2b2f87d8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
@@ -63,6 +63,67 @@ static const u32 mlx5e_link_speed[MLX5E_LINK_MODES_NUMBER] = {
 	[MLX5E_50GBASE_KR2]       = 50000,
 };
 
+int mlx5_port_query_eth_proto(struct mlx5_core_dev *dev, u8 port,
+			      struct mlx5e_port_eth_proto *eproto)
+{
+	u32 out[MLX5_ST_SZ_DW(ptys_reg)];
+	int err;
+
+	if (!eproto)
+		return -EINVAL;
+
+	err = mlx5_query_port_ptys(dev, out, sizeof(out), MLX5_PTYS_EN, port);
+	if (err)
+		return err;
+
+	eproto->cap   = MLX5_GET(ptys_reg, out, eth_proto_capability);
+	eproto->admin = MLX5_GET(ptys_reg, out, eth_proto_admin);
+	eproto->oper  = MLX5_GET(ptys_reg, out, eth_proto_oper);
+	return 0;
+}
+
+void mlx5_port_query_eth_autoneg(struct mlx5_core_dev *dev, u8 *an_status,
+				 u8 *an_disable_cap, u8 *an_disable_admin)
+{
+	u32 out[MLX5_ST_SZ_DW(ptys_reg)];
+
+	*an_status = 0;
+	*an_disable_cap = 0;
+	*an_disable_admin = 0;
+
+	if (mlx5_query_port_ptys(dev, out, sizeof(out), MLX5_PTYS_EN, 1))
+		return;
+
+	*an_status = MLX5_GET(ptys_reg, out, an_status);
+	*an_disable_cap = MLX5_GET(ptys_reg, out, an_disable_cap);
+	*an_disable_admin = MLX5_GET(ptys_reg, out, an_disable_admin);
+}
+
+int mlx5_port_set_eth_ptys(struct mlx5_core_dev *dev, bool an_disable,
+			   u32 proto_admin)
+{
+	u32 out[MLX5_ST_SZ_DW(ptys_reg)];
+	u32 in[MLX5_ST_SZ_DW(ptys_reg)];
+	u8 an_disable_admin;
+	u8 an_disable_cap;
+	u8 an_status;
+
+	mlx5_port_query_eth_autoneg(dev, &an_status, &an_disable_cap,
+				    &an_disable_admin);
+	if (!an_disable_cap && an_disable)
+		return -EPERM;
+
+	memset(in, 0, sizeof(in));
+
+	MLX5_SET(ptys_reg, in, local_port, 1);
+	MLX5_SET(ptys_reg, in, an_disable_admin, an_disable);
+	MLX5_SET(ptys_reg, in, proto_mask, MLX5_PTYS_EN);
+	MLX5_SET(ptys_reg, in, eth_proto_admin, proto_admin);
+
+	return mlx5_core_access_reg(dev, in, sizeof(in), out,
+			    sizeof(out), MLX5_REG_PTYS, 0, 1);
+}
+
 u32 mlx5e_port_ptys2speed(u32 eth_proto_oper)
 {
 	unsigned long temp = eth_proto_oper;
@@ -78,16 +139,14 @@ u32 mlx5e_port_ptys2speed(u32 eth_proto_oper)
 
 int mlx5e_port_linkspeed(struct mlx5_core_dev *mdev, u32 *speed)
 {
-	u32 out[MLX5_ST_SZ_DW(ptys_reg)] = {};
-	u32 eth_proto_oper;
+	struct mlx5e_port_eth_proto eproto;
 	int err;
 
-	err = mlx5_query_port_ptys(mdev, out, sizeof(out), MLX5_PTYS_EN, 1);
+	err = mlx5_port_query_eth_proto(mdev, 1, &eproto);
 	if (err)
 		return err;
 
-	eth_proto_oper = MLX5_GET(ptys_reg, out, eth_proto_oper);
-	*speed = mlx5e_port_ptys2speed(eth_proto_oper);
+	*speed = mlx5e_port_ptys2speed(eproto.oper);
 	if (!(*speed))
 		err = -EINVAL;
 
@@ -96,17 +155,17 @@ int mlx5e_port_linkspeed(struct mlx5_core_dev *mdev, u32 *speed)
 
 int mlx5e_port_max_linkspeed(struct mlx5_core_dev *mdev, u32 *speed)
 {
+	struct mlx5e_port_eth_proto eproto;
 	u32 max_speed = 0;
-	u32 proto_cap;
 	int err;
 	int i;
 
-	err = mlx5_query_port_proto_cap(mdev, &proto_cap, MLX5_PTYS_EN);
+	err = mlx5_port_query_eth_proto(mdev, 1, &eproto);
 	if (err)
 		return err;
 
 	for (i = 0; i < MLX5E_LINK_MODES_NUMBER; ++i)
-		if (proto_cap & MLX5E_PROT_MASK(i))
+		if (eproto.cap & MLX5E_PROT_MASK(i))
 			max_speed = max(max_speed, mlx5e_link_speed[i]);
 
 	*speed = max_speed;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.h b/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
index cd2160b8c9bf..4bdab8be10af 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
@@ -36,6 +36,18 @@
 #include <linux/mlx5/driver.h>
 #include "en.h"
 
+struct mlx5e_port_eth_proto {
+	u32 cap;
+	u32 admin;
+	u32 oper;
+};
+
+int mlx5_port_query_eth_proto(struct mlx5_core_dev *dev, u8 port,
+			      struct mlx5e_port_eth_proto *eproto);
+void mlx5_port_query_eth_autoneg(struct mlx5_core_dev *dev, u8 *an_status,
+				 u8 *an_disable_cap, u8 *an_disable_admin);
+int mlx5_port_set_eth_ptys(struct mlx5_core_dev *dev, bool an_disable,
+			   u32 proto_admin);
 u32 mlx5e_port_ptys2speed(u32 eth_proto_oper);
 int mlx5e_port_linkspeed(struct mlx5_core_dev *mdev, u32 *speed);
 int mlx5e_port_max_linkspeed(struct mlx5_core_dev *mdev, u32 *speed);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index c9df08133718..c29e141d72fb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -882,7 +882,7 @@ int mlx5e_ethtool_set_link_ksettings(struct mlx5e_priv *priv,
 				     const struct ethtool_link_ksettings *link_ksettings)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
-	u32 eth_proto_cap, eth_proto_admin;
+	struct mlx5e_port_eth_proto eproto;
 	bool an_changes = false;
 	u8 an_disable_admin;
 	u8 an_disable_cap;
@@ -898,14 +898,14 @@ int mlx5e_ethtool_set_link_ksettings(struct mlx5e_priv *priv,
 		mlx5e_ethtool2ptys_adver_link(link_ksettings->link_modes.advertising) :
 		mlx5e_port_speed2linkmodes(speed);
 
-	err = mlx5_query_port_proto_cap(mdev, &eth_proto_cap, MLX5_PTYS_EN);
+	err = mlx5_port_query_eth_proto(mdev, 1, &eproto);
 	if (err) {
-		netdev_err(priv->netdev, "%s: query port eth proto cap failed: %d\n",
+		netdev_err(priv->netdev, "%s: query port eth proto failed: %d\n",
 			   __func__, err);
 		goto out;
 	}
 
-	link_modes = link_modes & eth_proto_cap;
+	link_modes = link_modes & eproto.cap;
 	if (!link_modes) {
 		netdev_err(priv->netdev, "%s: Not supported link mode(s) requested",
 			   __func__);
@@ -913,24 +913,17 @@ int mlx5e_ethtool_set_link_ksettings(struct mlx5e_priv *priv,
 		goto out;
 	}
 
-	err = mlx5_query_port_proto_admin(mdev, &eth_proto_admin, MLX5_PTYS_EN);
-	if (err) {
-		netdev_err(priv->netdev, "%s: query port eth proto admin failed: %d\n",
-			   __func__, err);
-		goto out;
-	}
-
-	mlx5_query_port_autoneg(mdev, MLX5_PTYS_EN, &an_status,
-				&an_disable_cap, &an_disable_admin);
+	mlx5_port_query_eth_autoneg(mdev, &an_status, &an_disable_cap,
+				    &an_disable_admin);
 
 	an_disable = link_ksettings->base.autoneg == AUTONEG_DISABLE;
 	an_changes = ((!an_disable && an_disable_admin) ||
 		      (an_disable && !an_disable_admin));
 
-	if (!an_changes && link_modes == eth_proto_admin)
+	if (!an_changes && link_modes == eproto.admin)
 		goto out;
 
-	mlx5_set_port_ptys(mdev, an_disable, link_modes, MLX5_PTYS_EN);
+	mlx5_port_set_eth_ptys(mdev, an_disable, link_modes);
 	mlx5_toggle_port_link(mdev);
 
 out:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/port.c b/drivers/net/ethernet/mellanox/mlx5/core/port.c
index 2b82f35f4c35..b81542820528 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -30,10 +30,7 @@
  * SOFTWARE.
  */
 
-#include <linux/module.h>
-#include <linux/mlx5/driver.h>
 #include <linux/mlx5/port.h>
-#include <linux/mlx5/cmd.h>
 #include "mlx5_core.h"
 
 int mlx5_core_access_reg(struct mlx5_core_dev *dev, void *data_in,
@@ -157,44 +154,6 @@ int mlx5_set_port_beacon(struct mlx5_core_dev *dev, u16 beacon_duration)
 				    sizeof(out), MLX5_REG_MLCR, 0, 1);
 }
 
-int mlx5_query_port_proto_cap(struct mlx5_core_dev *dev,
-			      u32 *proto_cap, int proto_mask)
-{
-	u32 out[MLX5_ST_SZ_DW(ptys_reg)];
-	int err;
-
-	err = mlx5_query_port_ptys(dev, out, sizeof(out), proto_mask, 1);
-	if (err)
-		return err;
-
-	if (proto_mask == MLX5_PTYS_EN)
-		*proto_cap = MLX5_GET(ptys_reg, out, eth_proto_capability);
-	else
-		*proto_cap = MLX5_GET(ptys_reg, out, ib_proto_capability);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(mlx5_query_port_proto_cap);
-
-int mlx5_query_port_proto_admin(struct mlx5_core_dev *dev,
-				u32 *proto_admin, int proto_mask)
-{
-	u32 out[MLX5_ST_SZ_DW(ptys_reg)];
-	int err;
-
-	err = mlx5_query_port_ptys(dev, out, sizeof(out), proto_mask, 1);
-	if (err)
-		return err;
-
-	if (proto_mask == MLX5_PTYS_EN)
-		*proto_admin = MLX5_GET(ptys_reg, out, eth_proto_admin);
-	else
-		*proto_admin = MLX5_GET(ptys_reg, out, ib_proto_admin);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(mlx5_query_port_proto_admin);
-
 int mlx5_query_port_link_width_oper(struct mlx5_core_dev *dev,
 				    u8 *link_width_oper, u8 local_port)
 {
@@ -211,23 +170,6 @@ int mlx5_query_port_link_width_oper(struct mlx5_core_dev *dev,
 }
 EXPORT_SYMBOL_GPL(mlx5_query_port_link_width_oper);
 
-int mlx5_query_port_eth_proto_oper(struct mlx5_core_dev *dev,
-				   u32 *proto_oper, u8 local_port)
-{
-	u32 out[MLX5_ST_SZ_DW(ptys_reg)];
-	int err;
-
-	err = mlx5_query_port_ptys(dev, out, sizeof(out), MLX5_PTYS_EN,
-				   local_port);
-	if (err)
-		return err;
-
-	*proto_oper = MLX5_GET(ptys_reg, out, eth_proto_oper);
-
-	return 0;
-}
-EXPORT_SYMBOL(mlx5_query_port_eth_proto_oper);
-
 int mlx5_query_port_ib_proto_oper(struct mlx5_core_dev *dev,
 				  u8 *proto_oper, u8 local_port)
 {
@@ -245,35 +187,6 @@ int mlx5_query_port_ib_proto_oper(struct mlx5_core_dev *dev,
 }
 EXPORT_SYMBOL(mlx5_query_port_ib_proto_oper);
 
-int mlx5_set_port_ptys(struct mlx5_core_dev *dev, bool an_disable,
-		       u32 proto_admin, int proto_mask)
-{
-	u32 out[MLX5_ST_SZ_DW(ptys_reg)];
-	u32 in[MLX5_ST_SZ_DW(ptys_reg)];
-	u8 an_disable_admin;
-	u8 an_disable_cap;
-	u8 an_status;
-
-	mlx5_query_port_autoneg(dev, proto_mask, &an_status,
-				&an_disable_cap, &an_disable_admin);
-	if (!an_disable_cap && an_disable)
-		return -EPERM;
-
-	memset(in, 0, sizeof(in));
-
-	MLX5_SET(ptys_reg, in, local_port, 1);
-	MLX5_SET(ptys_reg, in, an_disable_admin, an_disable);
-	MLX5_SET(ptys_reg, in, proto_mask, proto_mask);
-	if (proto_mask == MLX5_PTYS_EN)
-		MLX5_SET(ptys_reg, in, eth_proto_admin, proto_admin);
-	else
-		MLX5_SET(ptys_reg, in, ib_proto_admin, proto_admin);
-
-	return mlx5_core_access_reg(dev, in, sizeof(in), out,
-				    sizeof(out), MLX5_REG_PTYS, 0, 1);
-}
-EXPORT_SYMBOL_GPL(mlx5_set_port_ptys);
-
 /* This function should be used after setting a port register only */
 void mlx5_toggle_port_link(struct mlx5_core_dev *dev)
 {
@@ -606,25 +519,6 @@ int mlx5_query_port_pfc(struct mlx5_core_dev *dev, u8 *pfc_en_tx, u8 *pfc_en_rx)
 }
 EXPORT_SYMBOL_GPL(mlx5_query_port_pfc);
 
-void mlx5_query_port_autoneg(struct mlx5_core_dev *dev, int proto_mask,
-			     u8 *an_status,
-			     u8 *an_disable_cap, u8 *an_disable_admin)
-{
-	u32 out[MLX5_ST_SZ_DW(ptys_reg)];
-
-	*an_status = 0;
-	*an_disable_cap = 0;
-	*an_disable_admin = 0;
-
-	if (mlx5_query_port_ptys(dev, out, sizeof(out), proto_mask, 1))
-		return;
-
-	*an_status = MLX5_GET(ptys_reg, out, an_status);
-	*an_disable_cap = MLX5_GET(ptys_reg, out, an_disable_cap);
-	*an_disable_admin = MLX5_GET(ptys_reg, out, an_disable_admin);
-}
-EXPORT_SYMBOL_GPL(mlx5_query_port_autoneg);
-
 int mlx5_max_tc(struct mlx5_core_dev *mdev)
 {
 	u8 num_tc = MLX5_CAP_GEN(mdev, max_tc) ? : 8;
diff --git a/include/linux/mlx5/port.h b/include/linux/mlx5/port.h
index bf4bc01ffb0c..5be7eefa6d75 100644
--- a/include/linux/mlx5/port.h
+++ b/include/linux/mlx5/port.h
@@ -110,27 +110,16 @@ enum mlx5e_connector_type {
 int mlx5_set_port_caps(struct mlx5_core_dev *dev, u8 port_num, u32 caps);
 int mlx5_query_port_ptys(struct mlx5_core_dev *dev, u32 *ptys,
 			 int ptys_size, int proto_mask, u8 local_port);
-int mlx5_query_port_proto_cap(struct mlx5_core_dev *dev,
-			      u32 *proto_cap, int proto_mask);
-int mlx5_query_port_proto_admin(struct mlx5_core_dev *dev,
-				u32 *proto_admin, int proto_mask);
 int mlx5_query_port_link_width_oper(struct mlx5_core_dev *dev,
 				    u8 *link_width_oper, u8 local_port);
 int mlx5_query_port_ib_proto_oper(struct mlx5_core_dev *dev,
 				  u8 *proto_oper, u8 local_port);
-int mlx5_query_port_eth_proto_oper(struct mlx5_core_dev *dev,
-				   u32 *proto_oper, u8 local_port);
-int mlx5_set_port_ptys(struct mlx5_core_dev *dev, bool an_disable,
-		       u32 proto_admin, int proto_mask);
 void mlx5_toggle_port_link(struct mlx5_core_dev *dev);
 int mlx5_set_port_admin_status(struct mlx5_core_dev *dev,
 			       enum mlx5_port_status status);
 int mlx5_query_port_admin_status(struct mlx5_core_dev *dev,
 				 enum mlx5_port_status *status);
 int mlx5_set_port_beacon(struct mlx5_core_dev *dev, u16 beacon_duration);
-void mlx5_query_port_autoneg(struct mlx5_core_dev *dev, int proto_mask,
-			     u8 *an_status,
-			     u8 *an_disable_cap, u8 *an_disable_admin);
 
 int mlx5_set_port_mtu(struct mlx5_core_dev *dev, u16 mtu, u8 port);
 void mlx5_query_port_max_mtu(struct mlx5_core_dev *dev, u16 *max_mtu, u8 port);
-- 
2.20.1
