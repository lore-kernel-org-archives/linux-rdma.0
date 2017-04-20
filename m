From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 3/3] IB/mlx5: Add support for active_width and active_speed in RoCE
Date: Thu, 20 Apr 2017 20:53:33 +0300
Message-ID: <20170420175333.7082-4-leon@kernel.org>
References: <20170420175333.7082-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170420175333.7082-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add missing calculation and translation of active_width and
active_speed for RoCE.

Fixes: 3f89a643eb295 ('IB/mlx5: Extend query_device/port to ...')
Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 73 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 68 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 6ba8bbc5c74a..0eaf769a34f5 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -165,21 +165,87 @@ static struct net_device *mlx5_ib_get_netdev(struct ib_device *device,
 	return ndev;
 }
 
+static int translate_eth_proto_oper(u32 eth_proto_oper, u8 *active_speed,
+				    u8 *active_width)
+{
+	switch (eth_proto_oper) {
+	case MLX5E_PROT_MASK(MLX5E_1000BASE_CX_SGMII):
+	case MLX5E_PROT_MASK(MLX5E_1000BASE_KX):
+	case MLX5E_PROT_MASK(MLX5E_100BASE_TX):
+	case MLX5E_PROT_MASK(MLX5E_1000BASE_T):
+		*active_width = IB_WIDTH_1X;
+		*active_speed = IB_SPEED_SDR;
+		break;
+	case MLX5E_PROT_MASK(MLX5E_10GBASE_T):
+	case MLX5E_PROT_MASK(MLX5E_10GBASE_CX4):
+	case MLX5E_PROT_MASK(MLX5E_10GBASE_KX4):
+	case MLX5E_PROT_MASK(MLX5E_10GBASE_KR):
+	case MLX5E_PROT_MASK(MLX5E_10GBASE_CR):
+	case MLX5E_PROT_MASK(MLX5E_10GBASE_SR):
+	case MLX5E_PROT_MASK(MLX5E_10GBASE_ER):
+		*active_width = IB_WIDTH_1X;
+		*active_speed = IB_SPEED_QDR;
+		break;
+	case MLX5E_PROT_MASK(MLX5E_25GBASE_CR):
+	case MLX5E_PROT_MASK(MLX5E_25GBASE_KR):
+	case MLX5E_PROT_MASK(MLX5E_25GBASE_SR):
+		*active_width = IB_WIDTH_1X;
+		*active_speed = IB_SPEED_EDR;
+		break;
+	case MLX5E_PROT_MASK(MLX5E_40GBASE_CR4):
+	case MLX5E_PROT_MASK(MLX5E_40GBASE_KR4):
+	case MLX5E_PROT_MASK(MLX5E_40GBASE_SR4):
+	case MLX5E_PROT_MASK(MLX5E_40GBASE_LR4):
+		*active_width = IB_WIDTH_4X;
+		*active_speed = IB_SPEED_QDR;
+		break;
+	case MLX5E_PROT_MASK(MLX5E_50GBASE_CR2):
+	case MLX5E_PROT_MASK(MLX5E_50GBASE_KR2):
+	case MLX5E_PROT_MASK(MLX5E_50GBASE_SR2):
+		*active_width = IB_WIDTH_1X;
+		*active_speed = IB_SPEED_HDR;
+		break;
+	case MLX5E_PROT_MASK(MLX5E_56GBASE_R4):
+		*active_width = IB_WIDTH_4X;
+		*active_speed = IB_SPEED_FDR;
+		break;
+	case MLX5E_PROT_MASK(MLX5E_100GBASE_CR4):
+	case MLX5E_PROT_MASK(MLX5E_100GBASE_SR4):
+	case MLX5E_PROT_MASK(MLX5E_100GBASE_KR4):
+	case MLX5E_PROT_MASK(MLX5E_100GBASE_LR4):
+		*active_width = IB_WIDTH_4X;
+		*active_speed = IB_SPEED_EDR;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static void mlx5_query_port_roce(struct ib_device *device, u8 port_num,
 				 struct ib_port_attr *props)
 {
 	struct mlx5_ib_dev *dev = to_mdev(device);
+	struct mlx5_core_dev *mdev = dev->mdev;
 	struct net_device *ndev, *upper;
 	enum ib_mtu ndev_ib_mtu;
 	u16 qkey_viol_cntr;
+	u32 eth_prot_oper;
 
-	/* Getting netdev before filling out props so in case of an error it
-	 * will still be zeroed out.
+	/* Possible bad flows are checked before filling out props so in case
+	 * of an error it will still be zeroed out.
 	 */
 	ndev = mlx5_ib_get_netdev(device, port_num);
 	if (!ndev)
 		return;
 
+	if (mlx5_query_port_eth_proto_oper(mdev, &eth_prot_oper, port_num))
+		return;
+
+	translate_eth_proto_oper(eth_prot_oper, &props->active_speed,
+				 &props->active_width);
+
 	props->port_cap_flags  |= IB_PORT_CM_SUP;
 	props->port_cap_flags  |= IB_PORT_IP_BASED_GIDS;
 
@@ -215,9 +281,6 @@ static void mlx5_query_port_roce(struct ib_device *device, u8 port_num,
 	dev_put(ndev);
 
 	props->active_mtu	= min(props->max_mtu, ndev_ib_mtu);
-
-	props->active_width	= IB_WIDTH_4X;  /* TODO */
-	props->active_speed	= IB_SPEED_QDR; /* TODO */
 }
 
 static void ib_gid_to_mlx5_roce_addr(const union ib_gid *gid,
-- 
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
