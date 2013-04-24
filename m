From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 3/9] net/mlx4_core: Change few DMFS fields names to match firmare spec
Date: Wed, 24 Apr 2013 16:58:46 +0300
Message-ID: <1366811932-28199-4-git-send-email-ogerlitz@mellanox.com>
References: <1366811932-28199-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1366811932-28199-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Change struct mlx4_net_trans_rule_hw_eth :: vlan_id name to vlan_tag

Change struct mlx4_net_trans_rule_hw_ib :: r_u_qpn name to l3_qpn

The patch doesn't introduce any functional change or API change
towards the firmware.

Signed-off-by: Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/mcg.c |    6 +++---
 include/linux/mlx4/device.h              |    8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/mcg.c b/drivers/net/ethernet/mellanox/mlx4/mcg.c
index d1f01dc..3cfd372 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mcg.c
+++ b/drivers/net/ethernet/mellanox/mlx4/mcg.c
@@ -714,12 +714,12 @@ static int parse_trans_rule(struct mlx4_dev *dev, struct mlx4_spec_list *spec,
 			rule_hw->eth.ether_type_enable = 1;
 			rule_hw->eth.ether_type = spec->eth.ether_type;
 		}
-		rule_hw->eth.vlan_id = spec->eth.vlan_id;
-		rule_hw->eth.vlan_id_msk = spec->eth.vlan_id_msk;
+		rule_hw->eth.vlan_tag = spec->eth.vlan_id;
+		rule_hw->eth.vlan_tag_msk = spec->eth.vlan_id_msk;
 		break;
 
 	case MLX4_NET_TRANS_RULE_ID_IB:
-		rule_hw->ib.qpn = spec->ib.r_qpn;
+		rule_hw->ib.l3_qpn = spec->ib.l3_qpn;
 		rule_hw->ib.qpn_mask = spec->ib.qpn_msk;
 		memcpy(&rule_hw->ib.dst_gid, &spec->ib.dst_gid, 16);
 		memcpy(&rule_hw->ib.dst_gid_msk, &spec->ib.dst_gid_msk, 16);
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index b2fe59d..a69bda7 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -930,7 +930,7 @@ struct mlx4_spec_ipv4 {
 };
 
 struct mlx4_spec_ib {
-	__be32	r_qpn;
+	__be32  l3_qpn;
 	__be32	qpn_msk;
 	u8	dst_gid[16];
 	u8	dst_gid_msk[16];
@@ -978,7 +978,7 @@ struct mlx4_net_trans_rule_hw_ib {
 	u8 rsvd1;
 	__be16 id;
 	u32 rsvd2;
-	__be32 qpn;
+	__be32 l3_qpn;
 	__be32 qpn_mask;
 	u8 dst_gid[16];
 	u8 dst_gid_msk[16];
@@ -999,8 +999,8 @@ struct mlx4_net_trans_rule_hw_eth {
 	u8      rsvd5;
 	u8      ether_type_enable;
 	__be16  ether_type;
-	__be16  vlan_id_msk;
-	__be16  vlan_id;
+	__be16  vlan_tag_msk;
+	__be16  vlan_tag;
 } __packed;
 
 struct mlx4_net_trans_rule_hw_tcp_udp {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
