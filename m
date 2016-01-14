From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 05/12] net/mlx4_core: Add support for configuring RoCE v2 UDP port
Date: Thu, 14 Jan 2016 17:50:36 +0200
Message-ID: <2fe759370cd686820ab46e3f03fbeee4d581d625.1452780850.git.monis@mellanox.com>
References: <cover.1452780849.git.monis@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1452780849.git.monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
In-Reply-To: <cover.1452780849.git.monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
References: <cover.1452780849.git.monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In order to support RoCE v2, the hardware needs to be configured
to classify certain UDP packets as RoCE v2 packets and pass it
through its RoCE pipeline. This patch enables configuring this
UDP port.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/fw.c | 16 +++++++++++++++-
 include/linux/mlx4/device.h             |  1 +
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
index 3d05855..d66c690 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -2262,7 +2262,8 @@ struct mlx4_config_dev {
 	__be32	rsvd1[3];
 	__be16	vxlan_udp_dport;
 	__be16	rsvd2;
-	__be32	rsvd3;
+	__be16  roce_v2_entropy;
+	__be16  roce_v2_udp_dport;
 	__be32	roce_flags;
 	__be32	rsvd4[25];
 	__be16	rsvd5;
@@ -2271,6 +2272,7 @@ struct mlx4_config_dev {
 };
 
 #define MLX4_VXLAN_UDP_DPORT (1 << 0)
+#define MLX4_ROCE_V2_UDP_DPORT BIT(3)
 #define MLX4_DISABLE_RX_PORT BIT(18)
 
 static int mlx4_CONFIG_DEV_set(struct mlx4_dev *dev, struct mlx4_config_dev *config_dev)
@@ -2388,6 +2390,18 @@ int mlx4_disable_rx_port_check(struct mlx4_dev *dev, bool dis)
 	return mlx4_CONFIG_DEV_set(dev, &config_dev);
 }
 
+int mlx4_config_roce_v2_port(struct mlx4_dev *dev, u16 udp_port)
+{
+	struct mlx4_config_dev config_dev;
+
+	memset(&config_dev, 0, sizeof(config_dev));
+	config_dev.update_flags    = cpu_to_be32(MLX4_ROCE_V2_UDP_DPORT);
+	config_dev.roce_v2_udp_dport = cpu_to_be16(udp_port);
+
+	return mlx4_CONFIG_DEV_set(dev, &config_dev);
+}
+EXPORT_SYMBOL_GPL(mlx4_config_roce_v2_port);
+
 int mlx4_virt2phy_port_map(struct mlx4_dev *dev, u32 port1, u32 port2)
 {
 	struct mlx4_cmd_mailbox *mailbox;
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 2a7a0e2..358444c 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -1460,6 +1460,7 @@ int mlx4_get_base_gid_ix(struct mlx4_dev *dev, int slave, int port);
 
 int mlx4_config_vxlan_port(struct mlx4_dev *dev, __be16 udp_port);
 int mlx4_disable_rx_port_check(struct mlx4_dev *dev, bool dis);
+int mlx4_config_roce_v2_port(struct mlx4_dev *dev, u16 udp_port);
 int mlx4_virt2phy_port_map(struct mlx4_dev *dev, u32 port1, u32 port2);
 int mlx4_vf_smi_enabled(struct mlx4_dev *dev, int slave, int port);
 int mlx4_vf_get_enable_smi_admin(struct mlx4_dev *dev, int slave, int port);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
