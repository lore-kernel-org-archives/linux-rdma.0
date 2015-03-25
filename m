From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 for-next 29/33] net/mlx4_core: Add handling of R-RoCE over IPV4 in qp attach flow
Date: Thu, 26 Mar 2015 02:50:18 +0530
Message-ID: <42d52b71-809f-44b1-8676-6f03cb3cdc8b@CMEXHTCAS2.ad.emulex.com>
References: <1427318422-12004-1-git-send-email-somnath.kotur@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427318422-12004-1-git-send-email-somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In that case, the IPv4 bit should be enabled in the IB flow spec.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/mcg.c | 14 ++++++++++++--
 include/linux/mlx4/device.h              |  6 ++++++
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/mcg.c b/drivers/net/ethernet/mellanox/mlx4/mcg.c
index a3867e7..cdf07b9 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mcg.c
+++ b/drivers/net/ethernet/mellanox/mlx4/mcg.c
@@ -858,7 +858,9 @@ static int parse_trans_rule(struct mlx4_dev *dev, struct mlx4_spec_list *spec,
 		break;
 
 	case MLX4_NET_TRANS_RULE_ID_IB:
-		rule_hw->ib.l3_qpn = spec->ib.l3_qpn;
+		rule_hw->ib.l3_qpn = spec->ib.l3_qpn |
+			(spec->ib.roce_type == MLX4_FLOW_SPEC_IB_ROCE_TYPE_IPV4 ?
+			 0x80 : 0);
 		rule_hw->ib.qpn_mask = spec->ib.qpn_msk;
 		memcpy(&rule_hw->ib.dst_gid, &spec->ib.dst_gid, 16);
 		memcpy(&rule_hw->ib.dst_gid_msk, &spec->ib.dst_gid_msk, 16);
@@ -1377,10 +1379,18 @@ int mlx4_trans_to_dmfs_attach(struct mlx4_dev *dev, struct mlx4_qp *qp,
 			memcpy(spec.eth.dst_mac_msk, &mac_mask, ETH_ALEN);
 			break;
 
+		case MLX4_PROT_IB_IPV4:
+			spec.id = MLX4_NET_TRANS_RULE_ID_IB;
+			memcpy(spec.ib.dst_gid + 12, gid + 12, 4);
+			memset(spec.ib.dst_gid_msk + 12, 0xff, 4);
+			spec.ib.roce_type = MLX4_FLOW_SPEC_IB_ROCE_TYPE_IPV4;
+
+			break;
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
index dd1488c..58b0b8c 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -369,6 +369,11 @@ enum mlx4_protocol {
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
@@ -1096,6 +1101,7 @@ struct mlx4_spec_ipv4 {
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
