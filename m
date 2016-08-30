From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 3/7] IB/uverbs: Add support to extend flow steering specifications
Date: Tue, 30 Aug 2016 16:58:32 +0300
Message-ID: <1472565516-11591-4-git-send-email-leon@kernel.org>
References: <1472565516-11591-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472565516-11591-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Flow steering specifications structures were implemented as in an
extensible way that allows one to add new filters and new fields
to existing filters.
These specifications have never been extended, therefore the
kernel flow specifications size and the user flow specifications size
were must to be equal.

In downstream patch, the IPv4 flow specifications type is extended to
support TOS and TTL fields.

To support an extension we change the flow specifications size
condition test to be as following:

* If the user flow specifications is bigger than the kernel
specifications, we verify that all the bits which not in the kernel
specifications are zeros and the flow is added only with the kernel
specifications fields.

* Otherwise, we add flow rule only with the user specifications fields.

User space filters must be aligned with 32bits.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 98 +++++++++++++++++++++++++++---------
 include/rdma/ib_verbs.h              | 10 ++++
 2 files changed, 83 insertions(+), 25 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index f664731..84c0794 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3078,51 +3078,98 @@ out_put:
 	return ret ? ret : in_len;
 }

+static size_t kern_spec_filter_sz(struct ib_uverbs_flow_spec_hdr *spec)
+{
+	/* Returns user space filter size, includes padding */
+	return (spec->size - sizeof(struct ib_uverbs_flow_spec_hdr)) / 2;
+}
+
+static ssize_t spec_filter_size(void *kern_spec_filter, u16 kern_filter_size,
+				u16 ib_real_filter_sz)
+{
+	/*
+	 * User space filter structures must be 64 bit aligned, otherwise this
+	 * may pass, but we won't handle additional new attributes.
+	 */
+
+	if (kern_filter_size > ib_real_filter_sz) {
+		if (memchr_inv(kern_spec_filter +
+			       ib_real_filter_sz, 0,
+			       kern_filter_size - ib_real_filter_sz))
+			return -EINVAL;
+		return ib_real_filter_sz;
+	}
+	return kern_filter_size;
+}
+
 static int kern_spec_to_ib_spec(struct ib_uverbs_flow_spec *kern_spec,
 				union ib_flow_spec *ib_spec)
 {
+	ssize_t actual_filter_sz;
+	ssize_t kern_filter_sz;
+	ssize_t ib_filter_sz;
+	void *kern_spec_mask;
+	void *kern_spec_val;
+
 	if (kern_spec->reserved)
 		return -EINVAL;

 	ib_spec->type = kern_spec->type;

+	kern_filter_sz = kern_spec_filter_sz(&kern_spec->hdr);
+	/* User flow spec size must be aligned to 4 bytes */
+	if (kern_filter_sz != ALIGN(kern_filter_sz, 4))
+		return -EINVAL;
+
+	kern_spec_val = (void *)kern_spec +
+		sizeof(struct ib_uverbs_flow_spec_hdr);
+	kern_spec_mask = kern_spec_val + kern_filter_sz;
+
 	switch (ib_spec->type) {
 	case IB_FLOW_SPEC_ETH:
-		ib_spec->eth.size = sizeof(struct ib_flow_spec_eth);
-		if (ib_spec->eth.size != kern_spec->eth.size)
+		ib_filter_sz = offsetof(struct ib_flow_eth_filter, real_sz);
+		actual_filter_sz = spec_filter_size(kern_spec_mask,
+						    kern_filter_sz,
+						    ib_filter_sz);
+		if (actual_filter_sz <= 0)
 			return -EINVAL;
-		memcpy(&ib_spec->eth.val, &kern_spec->eth.val,
-		       sizeof(struct ib_flow_eth_filter));
-		memcpy(&ib_spec->eth.mask, &kern_spec->eth.mask,
-		       sizeof(struct ib_flow_eth_filter));
+		ib_spec->size = sizeof(struct ib_flow_spec_eth);
+		memcpy(&ib_spec->eth.val, kern_spec_val, actual_filter_sz);
+		memcpy(&ib_spec->eth.mask, kern_spec_mask, actual_filter_sz);
 		break;
 	case IB_FLOW_SPEC_IPV4:
-		ib_spec->ipv4.size = sizeof(struct ib_flow_spec_ipv4);
-		if (ib_spec->ipv4.size != kern_spec->ipv4.size)
+		ib_filter_sz = offsetof(struct ib_flow_ipv4_filter, real_sz);
+		actual_filter_sz = spec_filter_size(kern_spec_mask,
+						    kern_filter_sz,
+						    ib_filter_sz);
+		if (actual_filter_sz <= 0)
 			return -EINVAL;
-		memcpy(&ib_spec->ipv4.val, &kern_spec->ipv4.val,
-		       sizeof(struct ib_flow_ipv4_filter));
-		memcpy(&ib_spec->ipv4.mask, &kern_spec->ipv4.mask,
-		       sizeof(struct ib_flow_ipv4_filter));
+		ib_spec->size = sizeof(struct ib_flow_spec_ipv4);
+		memcpy(&ib_spec->ipv4.val, kern_spec_val, actual_filter_sz);
+		memcpy(&ib_spec->ipv4.mask, kern_spec_mask, actual_filter_sz);
 		break;
 	case IB_FLOW_SPEC_IPV6:
-		ib_spec->ipv6.size = sizeof(struct ib_flow_spec_ipv6);
-		if (ib_spec->ipv6.size != kern_spec->ipv6.size)
+		ib_filter_sz = offsetof(struct ib_flow_ipv6_filter, real_sz);
+		actual_filter_sz = spec_filter_size(kern_spec_mask,
+						    kern_filter_sz,
+						    ib_filter_sz);
+		if (actual_filter_sz <= 0)
 			return -EINVAL;
-		memcpy(&ib_spec->ipv6.val, &kern_spec->ipv6.val,
-		       sizeof(struct ib_flow_ipv6_filter));
-		memcpy(&ib_spec->ipv6.mask, &kern_spec->ipv6.mask,
-		       sizeof(struct ib_flow_ipv6_filter));
+		ib_spec->size = sizeof(struct ib_flow_spec_ipv6);
+		memcpy(&ib_spec->ipv6.val, kern_spec_val, actual_filter_sz);
+		memcpy(&ib_spec->ipv6.mask, kern_spec_mask, actual_filter_sz);
 		break;
 	case IB_FLOW_SPEC_TCP:
 	case IB_FLOW_SPEC_UDP:
-		ib_spec->tcp_udp.size = sizeof(struct ib_flow_spec_tcp_udp);
-		if (ib_spec->tcp_udp.size != kern_spec->tcp_udp.size)
+		ib_filter_sz = offsetof(struct ib_flow_tcp_udp_filter, real_sz);
+		actual_filter_sz = spec_filter_size(kern_spec_mask,
+						    kern_filter_sz,
+						    ib_filter_sz);
+		if (actual_filter_sz <= 0)
 			return -EINVAL;
-		memcpy(&ib_spec->tcp_udp.val, &kern_spec->tcp_udp.val,
-		       sizeof(struct ib_flow_tcp_udp_filter));
-		memcpy(&ib_spec->tcp_udp.mask, &kern_spec->tcp_udp.mask,
-		       sizeof(struct ib_flow_tcp_udp_filter));
+		ib_spec->size = sizeof(struct ib_flow_spec_tcp_udp);
+		memcpy(&ib_spec->tcp_udp.val, kern_spec_val, actual_filter_sz);
+		memcpy(&ib_spec->tcp_udp.mask, kern_spec_mask, actual_filter_sz);
 		break;
 	default:
 		return -EINVAL;
@@ -3654,7 +3701,8 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 		goto err_uobj;
 	}

-	flow_attr = kmalloc(sizeof(*flow_attr) + cmd.flow_attr.size, GFP_KERNEL);
+	flow_attr = kzalloc(sizeof(*flow_attr) + cmd.flow_attr.num_of_specs *
+			    sizeof(union ib_flow_spec), GFP_KERNEL);
 	if (!flow_attr) {
 		err = -ENOMEM;
 		goto err_put;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 8e90dd2..d4144b2 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1604,6 +1604,8 @@ struct ib_flow_eth_filter {
 	u8	src_mac[6];
 	__be16	ether_type;
 	__be16	vlan_tag;
+	/* Must be last */
+	u8	real_sz[0];
 };

 struct ib_flow_spec_eth {
@@ -1616,6 +1618,8 @@ struct ib_flow_spec_eth {
 struct ib_flow_ib_filter {
 	__be16 dlid;
 	__u8   sl;
+	/* Must be last */
+	u8	real_sz[0];
 };

 struct ib_flow_spec_ib {
@@ -1628,6 +1632,8 @@ struct ib_flow_spec_ib {
 struct ib_flow_ipv4_filter {
 	__be32	src_ip;
 	__be32	dst_ip;
+	/* Must be last */
+	u8	real_sz[0];
 };

 struct ib_flow_spec_ipv4 {
@@ -1640,6 +1646,8 @@ struct ib_flow_spec_ipv4 {
 struct ib_flow_ipv6_filter {
 	u8	src_ip[16];
 	u8	dst_ip[16];
+	/* Must be last */
+	u8	real_sz[0];
 };

 struct ib_flow_spec_ipv6 {
@@ -1652,6 +1660,8 @@ struct ib_flow_spec_ipv6 {
 struct ib_flow_tcp_udp_filter {
 	__be16	dst_port;
 	__be16	src_port;
+	/* Must be last */
+	u8	real_sz[0];
 };

 struct ib_flow_spec_tcp_udp {
--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
