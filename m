From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/2] IB/mlx5: Add inner spec and IPv6 validation in user's flow attribute list
Date: Mon,  3 Apr 2017 13:11:02 +0300
Message-ID: <20170403101103.5141-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This change fixes an incomplete validation of the user's
flow attributes list.

Previous implementation validated only matching of IPv4 Ethertype
to IPv4 spec of outer headers (in case both Ethernet with specified
Ethertype and IP specs were present) and lacked the validation of:
1. Matching of IPv6 Ethertype in Ethernet spec (if such exists) to an
   IPv6 protocol spec (if such exists).
2. Validation of Ethertype to IP protocol matching on inner headers specs.
Which could cause some combinations of unmatching Ethernet and IP
protocols to pass validation and apply on the device.

The fix adds validation of IPv6 Ethertype and IP spec as well as
performing the scan on both outer and inner attributes.

Fixes: 038d2ef87572 ("Add flow steering support")
Signed-off-by: Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 44 ++++++++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 4dc0a8785fe0..8e9c57cd3039 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1967,26 +1967,50 @@ static bool flow_is_multicast_only(struct ib_flow_attr *ib_attr)
 	       is_multicast_ether_addr(eth_spec->val.dst_mac);
 }
 
-static bool is_valid_attr(const struct ib_flow_attr *flow_attr)
+static bool is_valid_ethertype(const struct ib_flow_attr *flow_attr,
+			       bool check_inner)
 {
 	union ib_flow_spec *ib_spec = (union ib_flow_spec *)(flow_attr + 1);
-	bool has_ipv4_spec = false;
-	bool eth_type_ipv4 = true;
+	int inner_bit = check_inner ? IB_FLOW_SPEC_INNER : 0;
+	bool ipv4_spec_valid, ipv6_spec_valid;
+	unsigned int ip_spec_type = 0;
+	bool has_ethertype = false;
 	unsigned int spec_index;
+	bool mask_valid = true;
+	u16 eth_type = 0;
+	bool type_valid;
 
 	/* Validate that ethertype is correct */
 	for (spec_index = 0; spec_index < flow_attr->num_of_specs; spec_index++) {
-		if (ib_spec->type == IB_FLOW_SPEC_ETH &&
+		if ((ib_spec->type == (IB_FLOW_SPEC_ETH | inner_bit)) &&
 		    ib_spec->eth.mask.ether_type) {
-			if (!((ib_spec->eth.mask.ether_type == htons(0xffff)) &&
-			      ib_spec->eth.val.ether_type == htons(ETH_P_IP)))
-				eth_type_ipv4 = false;
-		} else if (ib_spec->type == IB_FLOW_SPEC_IPV4) {
-			has_ipv4_spec = true;
+			mask_valid = (ib_spec->eth.mask.ether_type ==
+				      htons(0xffff));
+			has_ethertype = true;
+			eth_type = ntohs(ib_spec->eth.val.ether_type);
+		} else if ((ib_spec->type == (IB_FLOW_SPEC_IPV4 | inner_bit)) ||
+			   (ib_spec->type == (IB_FLOW_SPEC_IPV6 | inner_bit))) {
+			ip_spec_type = ib_spec->type;
 		}
 		ib_spec = (void *)ib_spec + ib_spec->size;
 	}
-	return !has_ipv4_spec || eth_type_ipv4;
+
+	type_valid = (!has_ethertype) || (!ip_spec_type);
+	if (!type_valid && mask_valid) {
+		ipv4_spec_valid = (eth_type == ETH_P_IP) &&
+			(ip_spec_type == (IB_FLOW_SPEC_IPV4 | inner_bit));
+		ipv6_spec_valid = (eth_type == ETH_P_IPV6) &&
+			(ip_spec_type == (IB_FLOW_SPEC_IPV6 | inner_bit));
+		type_valid = ipv4_spec_valid || ipv6_spec_valid;
+	}
+
+	return type_valid;
+}
+
+static bool is_valid_attr(const struct ib_flow_attr *flow_attr)
+{
+	return is_valid_ethertype(flow_attr, false) &&
+	       is_valid_ethertype(flow_attr, true);
 }
 
 static void put_flow_table(struct mlx5_ib_dev *dev,
-- 
2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
