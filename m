From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 2/2] IB/mlx5: Use IP version matching to classify IP traffic
Date: Mon,  3 Apr 2017 13:11:03 +0300
Message-ID: <20170403101103.5141-2-leon@kernel.org>
References: <20170403101103.5141-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170403101103.5141-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This change adds the ability for flow steering to classify IPv4/6
packets with MPLS tag (Ethertype 0x8847 and 0x8848) as standard IP
packets and hit IPv4/6 classifed steering rules.

When user added a flow rule with IP classification, driver was
implicitly adding ethertype matching to the created rule in order
to distinguish between IPv4 and IPv6 protocols.
Since IP packets with MPLS tag header have MPLS ethertype, they missed
the rule and ended up hitting the default filters.
Such behavior prevented from MPLS packets to undergo inbound traffic
load balancing flows (if such were defined by configuring RSS) to
achieve higher throughput - the way that non-MPLS IP packets performed.

Since our device is able to look past the MPLS tag and identify the
next protocol we introduce this solution which replaces Ethertype
matching by the device's capability to perform IP version parsing
and matching in order to distinguish between IPv4 and IPv6.
Therefore, whenever a flow with IP spec is added and device support IP
version matching, driver will implicitly add IP version matching to the
rule (Based on the IP spec type) without Ethertype matching which will
cause relevant MPLS tagged packets to hit this rule as well.
Otherwise (device doesn't support IP version matching), we fall back to
setting Ethertype matching.

If the user's filters specify an L2 ethertype and an IP spec
the rule will then match both the ethertype and the IP version.

The device's support for IP version matching is reported by the
device via dedicated capability bit in query_device_cap and named
outer/inner_ip_version.

Signed-off-by: Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 66 +++++++++++++++++++++++++++++----------
 include/linux/mlx5/mlx5_ifc.h     |  6 ++--
 2 files changed, 52 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 8e9c57cd3039..0f28f608bd4d 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1735,8 +1735,11 @@ static void set_tos(void *outer_c, void *outer_v, u8 mask, u8 val)
 		   offsetof(typeof(filter), field) -\
 		   sizeof(filter.field))
 
-static int parse_flow_attr(u32 *match_c, u32 *match_v,
-			   const union ib_flow_spec *ib_spec, u32 *tag_id)
+#define IPV4_VERSION 4
+#define IPV6_VERSION 6
+static int parse_flow_attr(struct mlx5_core_dev *mdev, u32 *match_c,
+			   u32 *match_v, const union ib_flow_spec *ib_spec,
+			   u32 *tag_id)
 {
 	void *misc_params_c = MLX5_ADDR_OF(fte_match_param, match_c,
 					   misc_parameters);
@@ -1744,17 +1747,22 @@ static int parse_flow_attr(u32 *match_c, u32 *match_v,
 					   misc_parameters);
 	void *headers_c;
 	void *headers_v;
+	int match_ipv;
 
 	if (ib_spec->type & IB_FLOW_SPEC_INNER) {
 		headers_c = MLX5_ADDR_OF(fte_match_param, match_c,
 					 inner_headers);
 		headers_v = MLX5_ADDR_OF(fte_match_param, match_v,
 					 inner_headers);
+		match_ipv = MLX5_CAP_FLOWTABLE_NIC_RX(mdev,
+					ft_field_support.inner_ip_version);
 	} else {
 		headers_c = MLX5_ADDR_OF(fte_match_param, match_c,
 					 outer_headers);
 		headers_v = MLX5_ADDR_OF(fte_match_param, match_v,
 					 outer_headers);
+		match_ipv = MLX5_CAP_FLOWTABLE_NIC_RX(mdev,
+					ft_field_support.outer_ip_version);
 	}
 
 	switch (ib_spec->type & ~IB_FLOW_SPEC_INNER) {
@@ -1810,10 +1818,17 @@ static int parse_flow_attr(u32 *match_c, u32 *match_v,
 		if (FIELDS_NOT_SUPPORTED(ib_spec->ipv4.mask, LAST_IPV4_FIELD))
 			return -EOPNOTSUPP;
 
-		MLX5_SET(fte_match_set_lyr_2_4, headers_c,
-			 ethertype, 0xffff);
-		MLX5_SET(fte_match_set_lyr_2_4, headers_v,
-			 ethertype, ETH_P_IP);
+		if (match_ipv) {
+			MLX5_SET(fte_match_set_lyr_2_4, headers_c,
+				 ip_version, 0xf);
+			MLX5_SET(fte_match_set_lyr_2_4, headers_v,
+				 ip_version, IPV4_VERSION);
+		} else {
+			MLX5_SET(fte_match_set_lyr_2_4, headers_c,
+				 ethertype, 0xffff);
+			MLX5_SET(fte_match_set_lyr_2_4, headers_v,
+				 ethertype, ETH_P_IP);
+		}
 
 		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_c,
 				    src_ipv4_src_ipv6.ipv4_layout.ipv4),
@@ -1842,10 +1857,17 @@ static int parse_flow_attr(u32 *match_c, u32 *match_v,
 		if (FIELDS_NOT_SUPPORTED(ib_spec->ipv6.mask, LAST_IPV6_FIELD))
 			return -EOPNOTSUPP;
 
-		MLX5_SET(fte_match_set_lyr_2_4, headers_c,
-			 ethertype, 0xffff);
-		MLX5_SET(fte_match_set_lyr_2_4, headers_v,
-			 ethertype, ETH_P_IPV6);
+		if (match_ipv) {
+			MLX5_SET(fte_match_set_lyr_2_4, headers_c,
+				 ip_version, 0xf);
+			MLX5_SET(fte_match_set_lyr_2_4, headers_v,
+				 ip_version, IPV6_VERSION);
+		} else {
+			MLX5_SET(fte_match_set_lyr_2_4, headers_c,
+				 ethertype, 0xffff);
+			MLX5_SET(fte_match_set_lyr_2_4, headers_v,
+				 ethertype, ETH_P_IPV6);
+		}
 
 		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_c,
 				    src_ipv4_src_ipv6.ipv6_layout.ipv6),
@@ -1967,10 +1989,16 @@ static bool flow_is_multicast_only(struct ib_flow_attr *ib_attr)
 	       is_multicast_ether_addr(eth_spec->val.dst_mac);
 }
 
-static bool is_valid_ethertype(const struct ib_flow_attr *flow_attr,
+static bool is_valid_ethertype(struct mlx5_core_dev *mdev,
+			       const struct ib_flow_attr *flow_attr,
 			       bool check_inner)
 {
 	union ib_flow_spec *ib_spec = (union ib_flow_spec *)(flow_attr + 1);
+	int match_ipv = check_inner ?
+			MLX5_CAP_FLOWTABLE_NIC_RX(mdev,
+					ft_field_support.inner_ip_version) :
+			MLX5_CAP_FLOWTABLE_NIC_RX(mdev,
+					ft_field_support.outer_ip_version);
 	int inner_bit = check_inner ? IB_FLOW_SPEC_INNER : 0;
 	bool ipv4_spec_valid, ipv6_spec_valid;
 	unsigned int ip_spec_type = 0;
@@ -2001,16 +2029,20 @@ static bool is_valid_ethertype(const struct ib_flow_attr *flow_attr,
 			(ip_spec_type == (IB_FLOW_SPEC_IPV4 | inner_bit));
 		ipv6_spec_valid = (eth_type == ETH_P_IPV6) &&
 			(ip_spec_type == (IB_FLOW_SPEC_IPV6 | inner_bit));
-		type_valid = ipv4_spec_valid || ipv6_spec_valid;
+
+		type_valid = (ipv4_spec_valid) || (ipv6_spec_valid) ||
+			     (((eth_type == ETH_P_MPLS_UC) ||
+			       (eth_type == ETH_P_MPLS_MC)) && match_ipv);
 	}
 
 	return type_valid;
 }
 
-static bool is_valid_attr(const struct ib_flow_attr *flow_attr)
+static bool is_valid_attr(struct mlx5_core_dev *mdev,
+			  const struct ib_flow_attr *flow_attr)
 {
-	return is_valid_ethertype(flow_attr, false) &&
-	       is_valid_ethertype(flow_attr, true);
+	return is_valid_ethertype(mdev, flow_attr, false) &&
+	       is_valid_ethertype(mdev, flow_attr, true);
 }
 
 static void put_flow_table(struct mlx5_ib_dev *dev,
@@ -2147,7 +2179,7 @@ static struct mlx5_ib_flow_handler *create_flow_rule(struct mlx5_ib_dev *dev,
 	u32 flow_tag = MLX5_FS_DEFAULT_FLOW_TAG;
 	int err = 0;
 
-	if (!is_valid_attr(flow_attr))
+	if (!is_valid_attr(dev->mdev, flow_attr))
 		return ERR_PTR(-EINVAL);
 
 	spec = mlx5_vzalloc(sizeof(*spec));
@@ -2160,7 +2192,7 @@ static struct mlx5_ib_flow_handler *create_flow_rule(struct mlx5_ib_dev *dev,
 	INIT_LIST_HEAD(&handler->list);
 
 	for (spec_index = 0; spec_index < flow_attr->num_of_specs; spec_index++) {
-		err = parse_flow_attr(spec->match_criteria,
+		err = parse_flow_attr(dev->mdev, spec->match_criteria,
 				      spec->match_value, ib_flow, &flow_tag);
 		if (err < 0)
 			goto free;
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 838242697541..dbd0e304c9bc 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -234,7 +234,7 @@ struct mlx5_ifc_flow_table_fields_supported_bits {
 	u8         outer_dmac[0x1];
 	u8         outer_smac[0x1];
 	u8         outer_ether_type[0x1];
-	u8         reserved_at_3[0x1];
+	u8         outer_ip_version[0x1];
 	u8         outer_first_prio[0x1];
 	u8         outer_first_cfi[0x1];
 	u8         outer_first_vid[0x1];
@@ -263,7 +263,7 @@ struct mlx5_ifc_flow_table_fields_supported_bits {
 	u8         inner_dmac[0x1];
 	u8         inner_smac[0x1];
 	u8         inner_ether_type[0x1];
-	u8         reserved_at_23[0x1];
+	u8         inner_ip_version[0x1];
 	u8         inner_first_prio[0x1];
 	u8         inner_first_cfi[0x1];
 	u8         inner_first_vid[0x1];
@@ -368,7 +368,7 @@ struct mlx5_ifc_fte_match_set_lyr_2_4_bits {
 	u8         cvlan_tag[0x1];
 	u8         svlan_tag[0x1];
 	u8         frag[0x1];
-	u8         reserved_at_93[0x4];
+	u8         ip_version[0x4];
 	u8         tcp_flags[0x9];
 
 	u8         tcp_sport[0x10];
-- 
2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
