From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 11/30] IB/core: Add rdma_network_type to wc
Date: Fri, 20 Feb 2015 03:32:26 +0530
Message-ID: <b88b89df-fa3f-4da8-adf3-e1560d912261@CMEXHTCAS2.ad.emulex.com>
References: <1424383365-19337-1-git-send-email-somnath.kotur@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424383365-19337-1-git-send-email-somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Providers should tell IB core the wc's network type.
This is used in order to search for the proper GID in the
GID table. When using HCAs that can't provide this info,
IB core tries to deep examine the packet and extract
the GID type by itself.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/verbs.c |  106 +++++++++++++++++++++++++++++++++++++--
 include/rdma/ib_verbs.h         |   30 +++++++++++
 2 files changed, 131 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 2c54d31..0fdac14 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -195,8 +195,84 @@ struct ib_ah *ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr)
 }
 EXPORT_SYMBOL(ib_create_ah);
 
+static int ib_get_grh_header_version(const void *h)
+{
+	const struct iphdr *ip4h = (struct iphdr *)(h + 20);
+	struct iphdr ip4h_checked;
+	const struct ipv6hdr *ip6h = (struct ipv6hdr *)h;
+
+	if (ip6h->version != 6)
+		return (ip4h->version == 4) ? 4 : 0;
+	/* version may be 6 or 4 */
+	if (ip4h->ihl != 5) /* IPv4 header length must be 5 for RR */
+		return 6;
+	/* Verify checksum.
+	   We can't write on scattered buffers so we need to copy to
+	   temp buffer.
+	 */
+	memcpy(&ip4h_checked, ip4h, sizeof(ip4h_checked));
+	ip4h_checked.check = 0;
+	ip4h_checked.check = ip_fast_csum((u8 *)&ip4h_checked, 5);
+	/* if IPv4 header checksum is OK, bellive it */
+	if (ip4h->check == ip4h_checked.check)
+		return 4;
+	return 6;
+}
+
+static int ib_get_dgid_sgid_by_grh(const void *h,
+				   enum rdma_network_type net_type,
+				   union ib_gid *dgid, union ib_gid *sgid)
+{
+	switch (net_type) {
+	case RDMA_NETWORK_IPV4: {
+		const struct iphdr *ip4h = (struct iphdr *)(h + 20);
+
+		ipv6_addr_set_v4mapped(ip4h->daddr, (struct in6_addr *)dgid);
+		ipv6_addr_set_v4mapped(ip4h->saddr, (struct in6_addr *)sgid);
+		return 0;
+	}
+	case RDMA_NETWORK_IPV6: {
+		struct ipv6hdr *ip6h = (struct ipv6hdr *)h;
+
+		memcpy(dgid, &ip6h->daddr, sizeof(*dgid));
+		memcpy(sgid, &ip6h->saddr, sizeof(*sgid));
+		return 0;
+	}
+	case RDMA_NETWORK_IB: {
+		struct ib_grh *grh = (struct ib_grh *)h;
+
+		memcpy(dgid, &grh->dgid, sizeof(*dgid));
+		memcpy(sgid, &grh->sgid, sizeof(*sgid));
+		return 0;
+	}
+	}
+
+	return -EINVAL;
+}
+
+static enum rdma_network_type ib_get_net_type_by_grh(struct ib_device *device,
+						     u8 port_num,
+						     const struct ib_grh *grh)
+{
+	int grh_version;
+
+	if (rdma_port_get_link_layer(device, port_num) == IB_LINK_LAYER_INFINIBAND)
+		return RDMA_NETWORK_IB;
+
+	grh_version = ib_get_grh_header_version(grh);
+
+	if (grh_version == 4)
+		return RDMA_NETWORK_IPV4;
+
+	if (grh->next_hdr == IPPROTO_UDP)
+		return RDMA_NETWORK_IPV6;
+
+	return RDMA_NETWORK_IB;
+}
+
 struct find_gid_index_context {
 	u16 vlan_id;
+	enum ib_gid_type gid_type;
 };
 
 static bool find_gid_index(const union ib_gid *gid,
@@ -206,6 +282,9 @@ static bool find_gid_index(const union ib_gid *gid,
 	struct find_gid_index_context *ctx =
 		(struct find_gid_index_context *)context;
 
+	if (ctx->gid_type != gid_attr->gid_type)
+		return false;
+
 	if ((!!(ctx->vlan_id != 0xffff) == !is_vlan_dev(gid_attr->ndev)) ||
 	    (is_vlan_dev(gid_attr->ndev) &&
 	     vlan_dev_vlan_id(gid_attr->ndev) != ctx->vlan_id))
@@ -216,9 +295,11 @@ static bool find_gid_index(const union ib_gid *gid,
 
 static int get_sgid_index_from_eth(struct ib_device *device, u8 port_num,
 				   u16 vlan_id, union ib_gid *sgid,
+				   enum ib_gid_type gid_type,
 				   u16 *gid_index)
 {
-	struct find_gid_index_context context = {.vlan_id = vlan_id};
+	struct find_gid_index_context context = {.vlan_id = vlan_id,
+						 .gid_type = gid_type};
 
 	return ib_find_gid_by_filter(device, sgid, port_num, find_gid_index,
 				     &context, gid_index);
@@ -232,9 +313,24 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num, struct ib_wc *wc,
 	int ret;
 	int is_eth = (rdma_port_get_link_layer(device, port_num) ==
 			IB_LINK_LAYER_ETHERNET);
+	enum rdma_network_type net_type = RDMA_NETWORK_IB;
+	enum ib_gid_type gid_type = IB_GID_TYPE_IB;
+	union ib_gid dgid;
+	union ib_gid sgid;
 
 	memset(ah_attr, 0, sizeof *ah_attr);
 	if (is_eth) {
+		if (wc->wc_flags & IB_WC_WITH_NETWORK_HDR_TYPE)
+			net_type = wc->network_hdr_type;
+		else
+			net_type = ib_get_net_type_by_grh(device, port_num, grh);
+		gid_type = ib_network_to_gid_type(net_type);
+	}
+	ret = ib_get_dgid_sgid_by_grh(grh, net_type, &dgid, &sgid);
+	if (ret)
+		return ret;
+
+	if (is_eth) {
 		u16 vlan_id = wc->wc_flags & IB_WC_WITH_VLAN ?
 				wc->vlan_id : 0xffff;
 
@@ -243,7 +339,7 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num, struct ib_wc *wc,
 
 		if (!(wc->wc_flags & IB_WC_WITH_SMAC) ||
 		    !(wc->wc_flags & IB_WC_WITH_VLAN)) {
-			ret = rdma_addr_find_dmac_by_grh(&grh->dgid, &grh->sgid,
+			ret = rdma_addr_find_dmac_by_grh(&dgid, &sgid,
 							 ah_attr->dmac,
 							 wc->wc_flags & IB_WC_WITH_VLAN ?
 							 NULL : &vlan_id,
@@ -253,7 +349,7 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num, struct ib_wc *wc,
 		}
 
 		ret = get_sgid_index_from_eth(device, port_num, vlan_id,
-					      &grh->dgid, &gid_index);
+					      &dgid, gid_type, &gid_index);
 		if (ret)
 			return ret;
 
@@ -268,10 +364,10 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num, struct ib_wc *wc,
 
 	if (wc->wc_flags & IB_WC_GRH) {
 		ah_attr->ah_flags = IB_AH_GRH;
-		ah_attr->grh.dgid = grh->sgid;
+		ah_attr->grh.dgid = sgid;
 
 		if (!is_eth) {
-			ret = ib_find_cached_gid_by_port(device, &grh->dgid,
+			ret = ib_find_cached_gid_by_port(device, &dgid,
 							 IB_GID_TYPE_IB,
 							 port_num, NULL, 0,
 							 &gid_index);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 854e705..01eaf32 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -50,6 +50,7 @@
 #include <linux/workqueue.h>
 #include <net/net_namespace.h>
 #include <uapi/linux/if_ether.h>
+#include <net/ipv6.h>
 
 #include <linux/atomic.h>
 #include <linux/mmu_notifier.h>
@@ -117,6 +118,33 @@ enum rdma_transport_type {
 __attribute_const__ enum rdma_transport_type
 rdma_node_get_transport(enum rdma_node_type node_type);
 
+enum rdma_network_type {
+	RDMA_NETWORK_IB,
+	RDMA_NETWORK_IPV4,
+	RDMA_NETWORK_IPV6
+};
+
+static inline enum ib_gid_type ib_network_to_gid_type(enum rdma_network_type network_type)
+{
+	if (network_type == RDMA_NETWORK_IPV4 ||
+	    network_type == RDMA_NETWORK_IPV6)
+		return IB_GID_TYPE_ROCE_V2;
+
+	return IB_GID_TYPE_IB;
+}
+
+static inline enum rdma_network_type ib_gid_to_network_type(enum ib_gid_type gid_type,
+							    union ib_gid *gid)
+{
+	if (gid_type == IB_GID_TYPE_IB)
+		return RDMA_NETWORK_IB;
+
+	if (ipv6_addr_v4mapped((struct in6_addr *)gid))
+		return RDMA_NETWORK_IPV4;
+	else
+		return RDMA_NETWORK_IPV6;
+}
+
 enum rdma_link_layer {
 	IB_LINK_LAYER_UNSPECIFIED,
 	IB_LINK_LAYER_INFINIBAND,
@@ -724,6 +752,7 @@ enum ib_wc_flags {
 	IB_WC_IP_CSUM_OK	= (1<<3),
 	IB_WC_WITH_SMAC		= (1<<4),
 	IB_WC_WITH_VLAN		= (1<<5),
+	IB_WC_WITH_NETWORK_HDR_TYPE	= (1<<6),
 };
 
 struct ib_wc {
@@ -746,6 +775,7 @@ struct ib_wc {
 	u8			port_num;	/* valid only for DR SMPs on switches */
 	u8			smac[ETH_ALEN];
 	u16			vlan_id;
+	u8			network_hdr_type;
 };
 
 enum ib_cq_notify_flags {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
