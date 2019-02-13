From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 15/15] IB/mlx5: Add support for 50Gbps per lane link modes
Date: Tue, 12 Feb 2019 22:55:46 -0800
Message-ID: <20190213065546.3013-16-saeedm@mellanox.com>
References: <20190213065546.3013-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190213065546.3013-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Aya Levin <ayal@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Driver now supports new link modes: 50Gbps per lane support for
50G/100G/200G. This patch reads the correct field (legacy vs. extended)
based on a FW indication bit, and adds a translation function (link
modes to IB width and speed) to the new link modes.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 66 ++++++++++++++++++++++++++++---
 1 file changed, 61 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 3677c00fa3bb..581ae11e2fc9 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -331,8 +331,8 @@ void mlx5_ib_put_native_port_mdev(struct mlx5_ib_dev *ibdev, u8 port_num)
 	spin_unlock(&port->mp.mpi_lock);
 }
 
-static int translate_eth_proto_oper(u32 eth_proto_oper, u8 *active_speed,
-				    u8 *active_width)
+static int translate_eth_legacy_proto_oper(u32 eth_proto_oper, u8 *active_speed,
+					   u8 *active_width)
 {
 	switch (eth_proto_oper) {
 	case MLX5E_PROT_MASK(MLX5E_1000BASE_CX_SGMII):
@@ -389,6 +389,61 @@ static int translate_eth_proto_oper(u32 eth_proto_oper, u8 *active_speed,
 	return 0;
 }
 
+static int translate_eth_ext_proto_oper(u32 eth_proto_oper, u8 *active_speed,
+					u8 *active_width)
+{
+	switch (eth_proto_oper) {
+	case MLX5E_PROT_MASK(MLX5E_SGMII_100M):
+	case MLX5E_PROT_MASK(MLX5E_1000BASE_X_SGMII):
+		*active_width = IB_WIDTH_1X;
+		*active_speed = IB_SPEED_SDR;
+		break;
+	case MLX5E_PROT_MASK(MLX5E_5GBASE_R):
+		*active_width = IB_WIDTH_1X;
+		*active_speed = IB_SPEED_DDR;
+		break;
+	case MLX5E_PROT_MASK(MLX5E_10GBASE_XFI_XAUI_1):
+		*active_width = IB_WIDTH_1X;
+		*active_speed = IB_SPEED_QDR;
+		break;
+	case MLX5E_PROT_MASK(MLX5E_40GBASE_XLAUI_4_XLPPI_4):
+		*active_width = IB_WIDTH_4X;
+		*active_speed = IB_SPEED_QDR;
+		break;
+	case MLX5E_PROT_MASK(MLX5E_25GAUI_1_25GBASE_CR_KR):
+		*active_width = IB_WIDTH_1X;
+		*active_speed = IB_SPEED_EDR;
+		break;
+	case MLX5E_PROT_MASK(MLX5E_50GAUI_2_LAUI_2_50GBASE_CR2_KR2):
+	case MLX5E_PROT_MASK(MLX5E_50GAUI_1_LAUI_1_50GBASE_CR_KR):
+		*active_width = IB_WIDTH_1X;
+		*active_speed = IB_SPEED_HDR;
+		break;
+	case MLX5E_PROT_MASK(MLX5E_100GAUI_2_100GBASE_CR2_KR2):
+		*active_width = IB_WIDTH_2X;
+		*active_speed = IB_SPEED_HDR;
+		break;
+	case MLX5E_PROT_MASK(MLX5E_200GAUI_4_200GBASE_CR4_KR4):
+		*active_width = IB_WIDTH_4X;
+		*active_speed = IB_SPEED_HDR;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int translate_eth_proto_oper(u32 eth_proto_oper, u8 *active_speed,
+				    u8 *active_width, bool ext)
+{
+	return ext ?
+		translate_eth_ext_proto_oper(eth_proto_oper, active_speed,
+					     active_width) :
+		translate_eth_legacy_proto_oper(eth_proto_oper, active_speed,
+						active_width);
+}
+
 static int mlx5_query_port_roce(struct ib_device *device, u8 port_num,
 				struct ib_port_attr *props)
 {
@@ -401,6 +456,7 @@ static int mlx5_query_port_roce(struct ib_device *device, u8 port_num,
 	u16 qkey_viol_cntr;
 	u32 eth_prot_oper;
 	u8 mdev_port_num;
+	bool ext;
 	int err;
 
 	mdev = mlx5_ib_get_native_port_mdev(dev, port_num, &mdev_port_num);
@@ -421,14 +477,14 @@ static int mlx5_query_port_roce(struct ib_device *device, u8 port_num,
 				   mdev_port_num);
 	if (err)
 		goto out;
-	eth_prot_oper = MLX5_GET_ETH_PROTO(ptys_reg, out, false,
-					   eth_proto_oper);
+	ext = MLX5_CAP_PCAM_FEATURE(dev->mdev, ptys_extended_ethernet);
+	eth_prot_oper = MLX5_GET_ETH_PROTO(ptys_reg, out, ext, eth_proto_oper);
 
 	props->active_width     = IB_WIDTH_4X;
 	props->active_speed     = IB_SPEED_QDR;
 
 	translate_eth_proto_oper(eth_prot_oper, &props->active_speed,
-				 &props->active_width);
+				 &props->active_width, ext);
 
 	props->port_cap_flags |= IB_PORT_CM_SUP;
 	props->ip_gids = true;
-- 
2.20.1
