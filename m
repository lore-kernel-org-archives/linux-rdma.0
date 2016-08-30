From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 1/7] IB/mlx4: Add validation to flow specifications parsing
Date: Tue, 30 Aug 2016 16:58:30 +0300
Message-ID: <1472565516-11591-2-git-send-email-leon@kernel.org>
References: <1472565516-11591-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472565516-11591-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add validation check that all set fields in flow specification
are supported by vendor.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 2af44c2..624a531 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1361,6 +1361,19 @@ struct mlx4_ib_steering {
 	union ib_gid gid;
 };
 
+#define LAST_ETH_FIELD vlan_tag
+#define LAST_IB_FIELD sl
+#define LAST_IPV4_FIELD dst_ip
+#define LAST_TCP_UDP_FIELD src_port
+
+/* Field is the last supported field */
+#define FIELDS_NOT_SUPPORTED(filter, field)\
+	memchr_inv((void *)&filter.field  +\
+		   sizeof(filter.field), 0,\
+		   sizeof(filter) -\
+		   offsetof(typeof(filter), field) -\
+		   sizeof(filter.field))
+
 static int parse_flow_attr(struct mlx4_dev *dev,
 			   u32 qp_num,
 			   union ib_flow_spec *ib_spec,
@@ -1370,6 +1383,9 @@ static int parse_flow_attr(struct mlx4_dev *dev,
 
 	switch (ib_spec->type) {
 	case IB_FLOW_SPEC_ETH:
+		if (FIELDS_NOT_SUPPORTED(ib_spec->eth.mask, LAST_ETH_FIELD))
+			return -ENOTSUPP;
+
 		type = MLX4_NET_TRANS_RULE_ID_ETH;
 		memcpy(mlx4_spec->eth.dst_mac, ib_spec->eth.val.dst_mac,
 		       ETH_ALEN);
@@ -1379,6 +1395,9 @@ static int parse_flow_attr(struct mlx4_dev *dev,
 		mlx4_spec->eth.vlan_tag_msk = ib_spec->eth.mask.vlan_tag;
 		break;
 	case IB_FLOW_SPEC_IB:
+		if (FIELDS_NOT_SUPPORTED(ib_spec->ib.mask, LAST_IB_FIELD))
+			return -ENOTSUPP;
+
 		type = MLX4_NET_TRANS_RULE_ID_IB;
 		mlx4_spec->ib.l3_qpn =
 			cpu_to_be32(qp_num);
@@ -1388,6 +1407,9 @@ static int parse_flow_attr(struct mlx4_dev *dev,
 
 
 	case IB_FLOW_SPEC_IPV4:
+		if (FIELDS_NOT_SUPPORTED(ib_spec->ipv4.mask, LAST_IPV4_FIELD))
+			return -ENOTSUPP;
+
 		type = MLX4_NET_TRANS_RULE_ID_IPV4;
 		mlx4_spec->ipv4.src_ip = ib_spec->ipv4.val.src_ip;
 		mlx4_spec->ipv4.src_ip_msk = ib_spec->ipv4.mask.src_ip;
@@ -1397,6 +1419,9 @@ static int parse_flow_attr(struct mlx4_dev *dev,
 
 	case IB_FLOW_SPEC_TCP:
 	case IB_FLOW_SPEC_UDP:
+		if (FIELDS_NOT_SUPPORTED(ib_spec->tcp_udp.mask, LAST_TCP_UDP_FIELD))
+			return -ENOTSUPP;
+
 		type = ib_spec->type == IB_FLOW_SPEC_TCP ?
 					MLX4_NET_TRANS_RULE_ID_TCP :
 					MLX4_NET_TRANS_RULE_ID_UDP;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
