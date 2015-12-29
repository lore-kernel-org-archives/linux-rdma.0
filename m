From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 4/7] net/mlx4_core: Add handlning of RoCE v2 over IPV4 in attach_flow
Date: Tue, 29 Dec 2015 15:24:04 +0200
Message-ID: <1451395447-5198-5-git-send-email-matanb@mellanox.com>
References: <1451395447-5198-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1451395447-5198-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When attaching multicast for RoCE v2, we need to be able to steer
packets to the QPs. Hence, we add support for IPV4 over IB steering.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/mcg.c | 14 ++++++++++++--
 include/linux/mlx4/device.h              |  6 ++++++
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/mcg.c b/drivers/net/ethernet/mellanox/mlx4/mcg.c
index 1d4e2e0..834e60e 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mcg.c
+++ b/drivers/net/ethernet/mellanox/mlx4/mcg.c
@@ -858,7 +858,9 @@ static int parse_trans_rule(struct mlx4_dev *dev, struct mlx4_spec_list *spec,
 		break;
 
 	case MLX4_NET_TRANS_RULE_ID_IB:
-		rule_hw->ib.l3_qpn = spec->ib.l3_qpn;
+		rule_hw->ib.l3_qpn = spec->ib.l3_qpn |
+			(spec->ib.roce_type == MLX4_FLOW_SPEC_IB_ROCE_TYPE_IPV4 ?
+			 (__force __be32)0x80 : (__force __be32)0);
 		rule_hw->ib.qpn_mask = spec->ib.qpn_msk;
 		memcpy(&rule_hw->ib.dst_gid, &spec->ib.dst_gid, 16);
 		memcpy(&rule_hw->ib.dst_gid_msk, &spec->ib.dst_gid_msk, 16);
@@ -1384,10 +1386,18 @@ int mlx4_trans_to_dmfs_attach(struct mlx4_dev *dev, struct mlx4_qp *qp,
 			memcpy(spec.eth.dst_mac_msk, &mac_mask, ETH_ALEN);
 			break;
 
+		case MLX4_PROT_IB_IPV4:
+			spec.id = MLX4_NET_TRANS_RULE_ID_IB;
+			memcpy(spec.ib.dst_gid + 12, gid + 12, 4);
+			memset(spec.ib.dst_gid_msk + 12, 0xff, 4);
+			spec.ib.roce_type = MLX4_FLOW_SPEC_IB_ROCE_TYPE_IPV4;
+			break;
+
 		case MLX4_PROT_IB_IPV6:
 			spec.id = MLX4_NET_TRANS_RULE_ID_IB;
 			memcpy(spec.ib.dst_gid, gid, 16);
-			memset(&spec.ib.dst_gid_msk, 0xff, 16);
+			memset(spec.ib.dst_gid_msk, 0xff, 16);
+			spec.ib.roce_type = MLX4_FLOW_SPEC_IB_ROCE_TYPE_IPV6;
 			break;
 		default:
 			return -EINVAL;
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 0d873f1ae..cdc75b2 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -391,6 +391,11 @@ enum mlx4_protocol {
 	MLX4_PROT_FCOE
 };
 
+enum mlx4_flow_roce_type {
+	MLX4_FLOW_SPEC_IB_ROCE_TYPE_IPV6 = 0,
+	MLX4_FLOW_SPEC_IB_ROCE_TYPE_IPV4
+};
+
 enum {
 	MLX4_MTT_FLAG_PRESENT		= 1
 };
@@ -1197,6 +1202,7 @@ struct mlx4_spec_ipv4 {
 struct mlx4_spec_ib {
 	__be32  l3_qpn;
 	__be32	qpn_msk;
+	enum    mlx4_flow_roce_type roce_type;
 	u8	dst_gid[16];
 	u8	dst_gid_msk[16];
 };
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
