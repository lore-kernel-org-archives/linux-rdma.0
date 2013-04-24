From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 1/9] net/mlx4_core: Move DMFS HW structs to common header file
Date: Wed, 24 Apr 2013 16:58:44 +0300
Message-ID: <1366811932-28199-2-git-send-email-ogerlitz@mellanox.com>
References: <1366811932-28199-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1366811932-28199-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Move flow steering HW structures to be on the public mlx4 include
directory, as a pre-step for the mlx4 IB driver to use them too.

Signed-off-by: Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/mlx4.h |   79 -----------------------------
 include/linux/mlx4/device.h               |   79 +++++++++++++++++++++++++++++
 2 files changed, 79 insertions(+), 79 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4.h b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
index d738454..d5fdb19 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@ -701,85 +701,6 @@ struct mlx4_steer {
 	struct list_head steer_entries[MLX4_NUM_STEERS];
 };
 
-struct mlx4_net_trans_rule_hw_ctrl {
-	__be32 ctrl;
-	u8 rsvd1;
-	u8 funcid;
-	u8 vep;
-	u8 port;
-	__be32 qpn;
-	__be32 rsvd2;
-};
-
-struct mlx4_net_trans_rule_hw_ib {
-	u8 size;
-	u8 rsvd1;
-	__be16 id;
-	u32 rsvd2;
-	__be32 qpn;
-	__be32 qpn_mask;
-	u8 dst_gid[16];
-	u8 dst_gid_msk[16];
-} __packed;
-
-struct mlx4_net_trans_rule_hw_eth {
-	u8	size;
-	u8	rsvd;
-	__be16	id;
-	u8	rsvd1[6];
-	u8	dst_mac[6];
-	u16	rsvd2;
-	u8	dst_mac_msk[6];
-	u16	rsvd3;
-	u8	src_mac[6];
-	u16	rsvd4;
-	u8	src_mac_msk[6];
-	u8      rsvd5;
-	u8      ether_type_enable;
-	__be16  ether_type;
-	__be16  vlan_id_msk;
-	__be16  vlan_id;
-} __packed;
-
-struct mlx4_net_trans_rule_hw_tcp_udp {
-	u8	size;
-	u8	rsvd;
-	__be16	id;
-	__be16	rsvd1[3];
-	__be16	dst_port;
-	__be16	rsvd2;
-	__be16	dst_port_msk;
-	__be16	rsvd3;
-	__be16	src_port;
-	__be16	rsvd4;
-	__be16	src_port_msk;
-} __packed;
-
-struct mlx4_net_trans_rule_hw_ipv4 {
-	u8	size;
-	u8	rsvd;
-	__be16	id;
-	__be32	rsvd1;
-	__be32	dst_ip;
-	__be32	dst_ip_msk;
-	__be32	src_ip;
-	__be32	src_ip_msk;
-} __packed;
-
-struct _rule_hw {
-	union {
-		struct {
-			u8 size;
-			u8 rsvd;
-			__be16 id;
-		};
-		struct mlx4_net_trans_rule_hw_eth eth;
-		struct mlx4_net_trans_rule_hw_ib ib;
-		struct mlx4_net_trans_rule_hw_ipv4 ipv4;
-		struct mlx4_net_trans_rule_hw_tcp_udp tcp_udp;
-	};
-};
-
 enum {
 	MLX4_PCI_DEV_IS_VF		= 1 << 0,
 	MLX4_PCI_DEV_FORCE_SENSE_PORT	= 1 << 1,
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 811f91c..9fbf416 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -962,6 +962,85 @@ struct mlx4_net_trans_rule {
 	u32	qpn;
 };
 
+struct mlx4_net_trans_rule_hw_ctrl {
+	__be32 ctrl;
+	u8 rsvd1;
+	u8 funcid;
+	u8 vep;
+	u8 port;
+	__be32 qpn;
+	__be32 rsvd2;
+};
+
+struct mlx4_net_trans_rule_hw_ib {
+	u8 size;
+	u8 rsvd1;
+	__be16 id;
+	u32 rsvd2;
+	__be32 qpn;
+	__be32 qpn_mask;
+	u8 dst_gid[16];
+	u8 dst_gid_msk[16];
+} __packed;
+
+struct mlx4_net_trans_rule_hw_eth {
+	u8	size;
+	u8	rsvd;
+	__be16	id;
+	u8	rsvd1[6];
+	u8	dst_mac[6];
+	u16	rsvd2;
+	u8	dst_mac_msk[6];
+	u16	rsvd3;
+	u8	src_mac[6];
+	u16	rsvd4;
+	u8	src_mac_msk[6];
+	u8      rsvd5;
+	u8      ether_type_enable;
+	__be16  ether_type;
+	__be16  vlan_id_msk;
+	__be16  vlan_id;
+} __packed;
+
+struct mlx4_net_trans_rule_hw_tcp_udp {
+	u8	size;
+	u8	rsvd;
+	__be16	id;
+	__be16	rsvd1[3];
+	__be16	dst_port;
+	__be16	rsvd2;
+	__be16	dst_port_msk;
+	__be16	rsvd3;
+	__be16	src_port;
+	__be16	rsvd4;
+	__be16	src_port_msk;
+} __packed;
+
+struct mlx4_net_trans_rule_hw_ipv4 {
+	u8	size;
+	u8	rsvd;
+	__be16	id;
+	__be32	rsvd1;
+	__be32	dst_ip;
+	__be32	dst_ip_msk;
+	__be32	src_ip;
+	__be32	src_ip_msk;
+} __packed;
+
+struct _rule_hw {
+	union {
+		struct {
+			u8 size;
+			u8 rsvd;
+			__be16 id;
+		};
+		struct mlx4_net_trans_rule_hw_eth eth;
+		struct mlx4_net_trans_rule_hw_ib ib;
+		struct mlx4_net_trans_rule_hw_ipv4 ipv4;
+		struct mlx4_net_trans_rule_hw_tcp_udp tcp_udp;
+	};
+};
+
 int mlx4_flow_steer_promisc_add(struct mlx4_dev *dev, u8 port, u32 qpn,
 				enum mlx4_net_trans_promisc_mode mode);
 int mlx4_flow_steer_promisc_remove(struct mlx4_dev *dev, u8 port,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
