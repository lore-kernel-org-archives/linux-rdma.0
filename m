From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 14/15] net/mlx5: Add support to ext_* fields introduced in Port Type and Speed register
Date: Tue, 12 Feb 2019 22:55:45 -0800
Message-ID: <20190213065546.3013-15-saeedm@mellanox.com>
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

This patch exposes new link modes (including 50Gbps per lane), and ext_*
fields which describes the new link modes in Port Type and Speed
register (PTYS).
Access functions, translation functions (speed <-> HW bits) and
link max speed function were modified.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c             |  3 +-
 .../net/ethernet/mellanox/mlx5/core/en/port.c | 85 ++++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/en/port.h |  8 +-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  9 +-
 include/linux/mlx5/port.h                     | 19 +++++
 5 files changed, 94 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index efd08b41126c..3677c00fa3bb 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -421,7 +421,8 @@ static int mlx5_query_port_roce(struct ib_device *device, u8 port_num,
 				   mdev_port_num);
 	if (err)
 		goto out;
-	eth_prot_oper = MLX5_GET(ptys_reg, out, eth_proto_oper);
+	eth_prot_oper = MLX5_GET_ETH_PROTO(ptys_reg, out, false,
+					   eth_proto_oper);
 
 	props->active_width     = IB_WIDTH_4X;
 	props->active_speed     = IB_SPEED_QDR;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
index 9a1c2b2f87d8..122927f3a600 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
@@ -63,7 +63,31 @@ static const u32 mlx5e_link_speed[MLX5E_LINK_MODES_NUMBER] = {
 	[MLX5E_50GBASE_KR2]       = 50000,
 };
 
-int mlx5_port_query_eth_proto(struct mlx5_core_dev *dev, u8 port,
+static const u32 mlx5e_ext_link_speed[MLX5E_EXT_LINK_MODES_NUMBER] = {
+	[MLX5E_SGMII_100M]			= 100,
+	[MLX5E_1000BASE_X_SGMII]		= 1000,
+	[MLX5E_5GBASE_R]			= 5000,
+	[MLX5E_10GBASE_XFI_XAUI_1]		= 10000,
+	[MLX5E_40GBASE_XLAUI_4_XLPPI_4]		= 40000,
+	[MLX5E_25GAUI_1_25GBASE_CR_KR]		= 25000,
+	[MLX5E_50GAUI_2_LAUI_2_50GBASE_CR2_KR2]	= 50000,
+	[MLX5E_50GAUI_1_LAUI_1_50GBASE_CR_KR]	= 50000,
+	[MLX5E_CAUI_4_100GBASE_CR4_KR4]		= 100000,
+	[MLX5E_200GAUI_4_200GBASE_CR4_KR4]	= 200000,
+	[MLX5E_400GAUI_8]			= 400000,
+};
+
+static void mlx5e_port_get_speed_arr(struct mlx5_core_dev *mdev,
+				     const u32 **arr, u32 *size)
+{
+	bool ext = MLX5_CAP_PCAM_FEATURE(mdev, ptys_extended_ethernet);
+
+	*size = ext ? ARRAY_SIZE(mlx5e_ext_link_speed) :
+		      ARRAY_SIZE(mlx5e_link_speed);
+	*arr  = ext ? mlx5e_ext_link_speed : mlx5e_link_speed;
+}
+
+int mlx5_port_query_eth_proto(struct mlx5_core_dev *dev, u8 port, bool ext,
 			      struct mlx5e_port_eth_proto *eproto)
 {
 	u32 out[MLX5_ST_SZ_DW(ptys_reg)];
@@ -72,13 +96,17 @@ int mlx5_port_query_eth_proto(struct mlx5_core_dev *dev, u8 port,
 	if (!eproto)
 		return -EINVAL;
 
+	if (ext !=  MLX5_CAP_PCAM_FEATURE(dev, ptys_extended_ethernet))
+		return -EOPNOTSUPP;
+
 	err = mlx5_query_port_ptys(dev, out, sizeof(out), MLX5_PTYS_EN, port);
 	if (err)
 		return err;
 
-	eproto->cap   = MLX5_GET(ptys_reg, out, eth_proto_capability);
-	eproto->admin = MLX5_GET(ptys_reg, out, eth_proto_admin);
-	eproto->oper  = MLX5_GET(ptys_reg, out, eth_proto_oper);
+	eproto->cap   = MLX5_GET_ETH_PROTO(ptys_reg, out, ext,
+					   eth_proto_capability);
+	eproto->admin = MLX5_GET_ETH_PROTO(ptys_reg, out, ext, eth_proto_admin);
+	eproto->oper  = MLX5_GET_ETH_PROTO(ptys_reg, out, ext, eth_proto_oper);
 	return 0;
 }
 
@@ -100,7 +128,7 @@ void mlx5_port_query_eth_autoneg(struct mlx5_core_dev *dev, u8 *an_status,
 }
 
 int mlx5_port_set_eth_ptys(struct mlx5_core_dev *dev, bool an_disable,
-			   u32 proto_admin)
+			   u32 proto_admin, bool ext)
 {
 	u32 out[MLX5_ST_SZ_DW(ptys_reg)];
 	u32 in[MLX5_ST_SZ_DW(ptys_reg)];
@@ -118,38 +146,46 @@ int mlx5_port_set_eth_ptys(struct mlx5_core_dev *dev, bool an_disable,
 	MLX5_SET(ptys_reg, in, local_port, 1);
 	MLX5_SET(ptys_reg, in, an_disable_admin, an_disable);
 	MLX5_SET(ptys_reg, in, proto_mask, MLX5_PTYS_EN);
-	MLX5_SET(ptys_reg, in, eth_proto_admin, proto_admin);
+	if (ext)
+		MLX5_SET(ptys_reg, in, ext_eth_proto_admin, proto_admin);
+	else
+		MLX5_SET(ptys_reg, in, eth_proto_admin, proto_admin);
 
 	return mlx5_core_access_reg(dev, in, sizeof(in), out,
 			    sizeof(out), MLX5_REG_PTYS, 0, 1);
 }
 
-u32 mlx5e_port_ptys2speed(u32 eth_proto_oper)
+u32 mlx5e_port_ptys2speed(struct mlx5_core_dev *mdev, u32 eth_proto_oper)
 {
 	unsigned long temp = eth_proto_oper;
+	const u32 *table;
 	u32 speed = 0;
+	u32 max_size;
 	int i;
 
-	i = find_first_bit(&temp, MLX5E_LINK_MODES_NUMBER);
-	if (i < MLX5E_LINK_MODES_NUMBER)
-		speed = mlx5e_link_speed[i];
-
+	mlx5e_port_get_speed_arr(mdev, &table, &max_size);
+	i = find_first_bit(&temp, max_size);
+	if (i < max_size)
+		speed = table[i];
 	return speed;
 }
 
 int mlx5e_port_linkspeed(struct mlx5_core_dev *mdev, u32 *speed)
 {
 	struct mlx5e_port_eth_proto eproto;
+	bool ext;
 	int err;
 
-	err = mlx5_port_query_eth_proto(mdev, 1, &eproto);
+	ext = MLX5_CAP_PCAM_FEATURE(mdev, ptys_extended_ethernet);
+	err = mlx5_port_query_eth_proto(mdev, 1, ext, &eproto);
 	if (err)
-		return err;
+		goto out;
 
-	*speed = mlx5e_port_ptys2speed(eproto.oper);
+	*speed = mlx5e_port_ptys2speed(mdev, eproto.oper);
 	if (!(*speed))
 		err = -EINVAL;
 
+out:
 	return err;
 }
 
@@ -157,31 +193,38 @@ int mlx5e_port_max_linkspeed(struct mlx5_core_dev *mdev, u32 *speed)
 {
 	struct mlx5e_port_eth_proto eproto;
 	u32 max_speed = 0;
+	const u32 *table;
+	u32 max_size;
+	bool ext;
 	int err;
 	int i;
 
-	err = mlx5_port_query_eth_proto(mdev, 1, &eproto);
+	ext = MLX5_CAP_PCAM_FEATURE(mdev, ptys_extended_ethernet);
+	err = mlx5_port_query_eth_proto(mdev, 1, ext, &eproto);
 	if (err)
 		return err;
 
-	for (i = 0; i < MLX5E_LINK_MODES_NUMBER; ++i)
+	mlx5e_port_get_speed_arr(mdev, &table, &max_size);
+	for (i = 0; i < max_size; ++i)
 		if (eproto.cap & MLX5E_PROT_MASK(i))
-			max_speed = max(max_speed, mlx5e_link_speed[i]);
+			max_speed = max(max_speed, table[i]);
 
 	*speed = max_speed;
 	return 0;
 }
 
-u32 mlx5e_port_speed2linkmodes(u32 speed)
+u32 mlx5e_port_speed2linkmodes(struct mlx5_core_dev *mdev, u32 speed)
 {
 	u32 link_modes = 0;
+	const u32 *table;
+	u32 max_size;
 	int i;
 
-	for (i = 0; i < MLX5E_LINK_MODES_NUMBER; ++i) {
-		if (mlx5e_link_speed[i] == speed)
+	mlx5e_port_get_speed_arr(mdev, &table, &max_size);
+	for (i = 0; i < max_size; ++i) {
+		if (table[i] == speed)
 			link_modes |= MLX5E_PROT_MASK(i);
 	}
-
 	return link_modes;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.h b/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
index 4bdab8be10af..70f536ec51c4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
@@ -42,16 +42,16 @@ struct mlx5e_port_eth_proto {
 	u32 oper;
 };
 
-int mlx5_port_query_eth_proto(struct mlx5_core_dev *dev, u8 port,
+int mlx5_port_query_eth_proto(struct mlx5_core_dev *dev, u8 port, bool ext,
 			      struct mlx5e_port_eth_proto *eproto);
 void mlx5_port_query_eth_autoneg(struct mlx5_core_dev *dev, u8 *an_status,
 				 u8 *an_disable_cap, u8 *an_disable_admin);
 int mlx5_port_set_eth_ptys(struct mlx5_core_dev *dev, bool an_disable,
-			   u32 proto_admin);
-u32 mlx5e_port_ptys2speed(u32 eth_proto_oper);
+			   u32 proto_admin, bool ext);
+u32 mlx5e_port_ptys2speed(struct mlx5_core_dev *mdev, u32 eth_proto_oper);
 int mlx5e_port_linkspeed(struct mlx5_core_dev *mdev, u32 *speed);
 int mlx5e_port_max_linkspeed(struct mlx5_core_dev *mdev, u32 *speed);
-u32 mlx5e_port_speed2linkmodes(u32 speed);
+u32 mlx5e_port_speed2linkmodes(struct mlx5_core_dev *mdev, u32 speed);
 
 int mlx5e_port_query_pbmc(struct mlx5_core_dev *mdev, void *out);
 int mlx5e_port_set_pbmc(struct mlx5_core_dev *mdev, void *in);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index c29e141d72fb..8343cf7d292c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -695,13 +695,14 @@ static void get_speed_duplex(struct net_device *netdev,
 			     u32 eth_proto_oper,
 			     struct ethtool_link_ksettings *link_ksettings)
 {
+	struct mlx5e_priv *priv = netdev_priv(netdev);
 	u32 speed = SPEED_UNKNOWN;
 	u8 duplex = DUPLEX_UNKNOWN;
 
 	if (!netif_carrier_ok(netdev))
 		goto out;
 
-	speed = mlx5e_port_ptys2speed(eth_proto_oper);
+	speed = mlx5e_port_ptys2speed(priv->mdev, eth_proto_oper);
 	if (!speed) {
 		speed = SPEED_UNKNOWN;
 		goto out;
@@ -896,9 +897,9 @@ int mlx5e_ethtool_set_link_ksettings(struct mlx5e_priv *priv,
 
 	link_modes = link_ksettings->base.autoneg == AUTONEG_ENABLE ?
 		mlx5e_ethtool2ptys_adver_link(link_ksettings->link_modes.advertising) :
-		mlx5e_port_speed2linkmodes(speed);
+		mlx5e_port_speed2linkmodes(mdev, speed);
 
-	err = mlx5_port_query_eth_proto(mdev, 1, &eproto);
+	err = mlx5_port_query_eth_proto(mdev, 1, false, &eproto);
 	if (err) {
 		netdev_err(priv->netdev, "%s: query port eth proto failed: %d\n",
 			   __func__, err);
@@ -923,7 +924,7 @@ int mlx5e_ethtool_set_link_ksettings(struct mlx5e_priv *priv,
 	if (!an_changes && link_modes == eproto.admin)
 		goto out;
 
-	mlx5_port_set_eth_ptys(mdev, an_disable, link_modes);
+	mlx5_port_set_eth_ptys(mdev, an_disable, link_modes, false);
 	mlx5_toggle_port_link(mdev);
 
 out:
diff --git a/include/linux/mlx5/port.h b/include/linux/mlx5/port.h
index 5be7eefa6d75..814fa194663b 100644
--- a/include/linux/mlx5/port.h
+++ b/include/linux/mlx5/port.h
@@ -92,6 +92,22 @@ enum mlx5e_link_mode {
 	MLX5E_LINK_MODES_NUMBER,
 };
 
+enum mlx5e_ext_link_mode {
+	MLX5E_SGMII_100M			= 0,
+	MLX5E_1000BASE_X_SGMII			= 1,
+	MLX5E_5GBASE_R				= 3,
+	MLX5E_10GBASE_XFI_XAUI_1		= 4,
+	MLX5E_40GBASE_XLAUI_4_XLPPI_4		= 5,
+	MLX5E_25GAUI_1_25GBASE_CR_KR		= 6,
+	MLX5E_50GAUI_2_LAUI_2_50GBASE_CR2_KR2	= 7,
+	MLX5E_50GAUI_1_LAUI_1_50GBASE_CR_KR	= 8,
+	MLX5E_CAUI_4_100GBASE_CR4_KR4		= 9,
+	MLX5E_100GAUI_2_100GBASE_CR2_KR2	= 10,
+	MLX5E_200GAUI_4_200GBASE_CR4_KR4	= 12,
+	MLX5E_400GAUI_8				= 15,
+	MLX5E_EXT_LINK_MODES_NUMBER,
+};
+
 enum mlx5e_connector_type {
 	MLX5E_PORT_UNKNOWN	= 0,
 	MLX5E_PORT_NONE			= 1,
@@ -106,6 +122,9 @@ enum mlx5e_connector_type {
 };
 
 #define MLX5E_PROT_MASK(link_mode) (1 << link_mode)
+#define MLX5_GET_ETH_PROTO(reg, out, ext, field)	\
+	(ext ? MLX5_GET(reg, out, ext_##field) :	\
+	MLX5_GET(reg, out, field))
 
 int mlx5_set_port_caps(struct mlx5_core_dev *dev, u8 port_num, u32 caps);
 int mlx5_query_port_ptys(struct mlx5_core_dev *dev, u32 *ptys,
-- 
2.20.1
