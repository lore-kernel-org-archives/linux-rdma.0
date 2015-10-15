From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V1 5/9] IB/core: Add rdma_network_type to wc
Date: Thu, 15 Oct 2015 19:07:08 +0300
Message-ID: <1444925232-13598-6-git-send-email-matanb@mellanox.com>
References: <1444925232-13598-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444925232-13598-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>

Providers should tell IB core the wc's network type.
This is used in order to search for the proper GID in the
GID table. When using HCAs that can't provide this info,
IB core tries to deep examine the packet and extract
the GID type by itself.

We choose sgid_index and type from all the matching entries in
RDMA-CM based on hint from the IP stack and we set hop_limit for
the IP packet based on above hint from IP stack.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>
---
 drivers/infiniband/core/addr.c  |  14 +++++
 drivers/infiniband/core/cma.c   |  11 +++-
 drivers/infiniband/core/verbs.c | 123 ++++++++++++++++++++++++++++++++++++++--
 include/rdma/ib_addr.h          |   1 +
 include/rdma/ib_verbs.h         |  44 ++++++++++++++
 5 files changed, 187 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index d3c42b3..3e1f93c 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -257,6 +257,12 @@ static int addr4_resolve(struct sockaddr_in *src_in,
 		goto put;
 	}
 
+	/* If there's a gateway, we're definitely in RoCE v2 (as RoCE v1 isn't
+	 * routable) and we could set the network type accordingly.
+	 */
+	if (rt->rt_uses_gateway)
+		addr->network = RDMA_NETWORK_IPV4;
+
 	ret = dst_fetch_ha(&rt->dst, addr, &fl4.daddr);
 put:
 	ip_rt_put(rt);
@@ -271,6 +277,7 @@ static int addr6_resolve(struct sockaddr_in6 *src_in,
 {
 	struct flowi6 fl6;
 	struct dst_entry *dst;
+	struct rt6_info *rt;
 	int ret;
 
 	memset(&fl6, 0, sizeof fl6);
@@ -282,6 +289,7 @@ static int addr6_resolve(struct sockaddr_in6 *src_in,
 	if ((ret = dst->error))
 		goto put;
 
+	rt = (struct rt6_info *)dst;
 	if (ipv6_addr_any(&fl6.saddr)) {
 		ret = ipv6_dev_get_saddr(&init_net, ip6_dst_idev(dst)->dev,
 					 &fl6.daddr, 0, &fl6.saddr);
@@ -305,6 +313,12 @@ static int addr6_resolve(struct sockaddr_in6 *src_in,
 		goto put;
 	}
 
+	/* If there's a gateway, we're definitely in RoCE v2 (as RoCE v1 isn't
+	 * routable) and we could set the network type accordingly.
+	 */
+	if (rt->rt6i_flags & RTF_GATEWAY)
+		addr->network = RDMA_NETWORK_IPV6;
+
 	ret = dst_fetch_ha(dst, addr, &fl6.daddr);
 put:
 	dst_release(dst);
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 2e592e6..c5d1685 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2253,6 +2253,7 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 {
 	struct rdma_route *route = &id_priv->id.route;
 	struct rdma_addr *addr = &route->addr;
+	enum ib_gid_type network_gid_type;
 	struct cma_work *work;
 	int ret;
 	struct net_device *ndev = NULL;
@@ -2291,7 +2292,15 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 	rdma_ip2gid((struct sockaddr *)&id_priv->id.route.addr.dst_addr,
 		    &route->path_rec->dgid);
 
-	route->path_rec->hop_limit = 1;
+	/* Use the hint from IP Stack to select GID Type */
+	network_gid_type = ib_network_to_gid_type(addr->dev_addr.network);
+	if (addr->dev_addr.network != RDMA_NETWORK_IB) {
+		route->path_rec->gid_type = network_gid_type;
+		/* TODO: get the hoplimit from the inet/inet6 device */
+		route->path_rec->hop_limit = IPV6_DEFAULT_HOPLIMIT;
+	} else {
+		route->path_rec->hop_limit = 1;
+	}
 	route->path_rec->reversible = 1;
 	route->path_rec->pkey = cpu_to_be16(0xffff);
 	route->path_rec->mtu_selector = IB_SA_EQ;
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 8b4ade6..2f568ad 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -311,8 +311,61 @@ struct ib_ah *ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr)
 }
 EXPORT_SYMBOL(ib_create_ah);
 
+static int ib_get_header_version(const union rdma_network_hdr *hdr)
+{
+	const struct iphdr *ip4h = (struct iphdr *)&hdr->roce4grh;
+	struct iphdr ip4h_checked;
+	const struct ipv6hdr *ip6h = (struct ipv6hdr *)&hdr->ibgrh;
+
+	/* If it's IPv6, the version must be 6, otherwise, the first
+	 * 20 bytes (before the IPv4 header) are garbled.
+	 */
+	if (ip6h->version != 6)
+		return (ip4h->version == 4) ? 4 : 0;
+	/* version may be 6 or 4 because the first 20 bytes could be garbled */
+
+	/* RoCE v2 requires no options, thus header length
+	   must be 5 words
+	*/
+	if (ip4h->ihl != 5)
+		return 6;
+
+	/* Verify checksum.
+	   We can't write on scattered buffers so we need to copy to
+	   temp buffer.
+	 */
+	memcpy(&ip4h_checked, ip4h, sizeof(ip4h_checked));
+	ip4h_checked.check = 0;
+	ip4h_checked.check = ip_fast_csum((u8 *)&ip4h_checked, 5);
+	/* if IPv4 header checksum is OK, believe it */
+	if (ip4h->check == ip4h_checked.check)
+		return 4;
+	return 6;
+}
+
+static enum rdma_network_type ib_get_net_type_by_grh(struct ib_device *device,
+						     u8 port_num,
+						     const struct ib_grh *grh)
+{
+	int grh_version;
+
+	if (rdma_protocol_ib(device, port_num))
+		return RDMA_NETWORK_IB;
+
+	grh_version = ib_get_header_version((union rdma_network_hdr *)grh);
+
+	if (grh_version == 4)
+		return RDMA_NETWORK_IPV4;
+
+	if (grh->next_hdr == IPPROTO_UDP)
+		return RDMA_NETWORK_IPV6;
+
+	return RDMA_NETWORK_ROCE_V1;
+}
+
 struct find_gid_index_context {
 	u16 vlan_id;
+	enum ib_gid_type gid_type;
 };
 
 static bool find_gid_index(const union ib_gid *gid,
@@ -322,6 +375,9 @@ static bool find_gid_index(const union ib_gid *gid,
 	struct find_gid_index_context *ctx =
 		(struct find_gid_index_context *)context;
 
+	if (ctx->gid_type != gid_attr->gid_type)
+		return false;
+
 	if ((!!(ctx->vlan_id != 0xffff) == !is_vlan_dev(gid_attr->ndev)) ||
 	    (is_vlan_dev(gid_attr->ndev) &&
 	     vlan_dev_vlan_id(gid_attr->ndev) != ctx->vlan_id))
@@ -332,14 +388,49 @@ static bool find_gid_index(const union ib_gid *gid,
 
 static int get_sgid_index_from_eth(struct ib_device *device, u8 port_num,
 				   u16 vlan_id, const union ib_gid *sgid,
+				   enum ib_gid_type gid_type,
 				   u16 *gid_index)
 {
-	struct find_gid_index_context context = {.vlan_id = vlan_id};
+	struct find_gid_index_context context = {.vlan_id = vlan_id,
+						 .gid_type = gid_type};
 
 	return ib_find_gid_by_filter(device, sgid, port_num, find_gid_index,
 				     &context, gid_index);
 }
 
+static int get_gids_from_rdma_hdr(union rdma_network_hdr *hdr,
+				  enum rdma_network_type net_type,
+				  union ib_gid *sgid, union ib_gid *dgid)
+{
+	struct sockaddr_in  src_in;
+	struct sockaddr_in  dst_in;
+	__be32 src_saddr, dst_saddr;
+
+	if (!sgid || !dgid)
+		return -EINVAL;
+
+	if (net_type == RDMA_NETWORK_IPV4) {
+		memcpy(&src_in.sin_addr.s_addr,
+		       &hdr->roce4grh.saddr, 4);
+		memcpy(&dst_in.sin_addr.s_addr,
+		       &hdr->roce4grh.daddr, 4);
+		src_saddr = src_in.sin_addr.s_addr;
+		dst_saddr = dst_in.sin_addr.s_addr;
+		ipv6_addr_set_v4mapped(src_saddr,
+				       (struct in6_addr *)sgid);
+		ipv6_addr_set_v4mapped(dst_saddr,
+				       (struct in6_addr *)dgid);
+		return 0;
+	} else if (net_type == RDMA_NETWORK_IPV6 ||
+		   net_type == RDMA_NETWORK_IB) {
+		*dgid = hdr->ibgrh.dgid;
+		*sgid = hdr->ibgrh.sgid;
+		return 0;
+	} else {
+		return -EINVAL;
+	}
+}
+
 int ib_init_ah_from_wc(struct ib_device *device, u8 port_num,
 		       const struct ib_wc *wc, const struct ib_grh *grh,
 		       struct ib_ah_attr *ah_attr)
@@ -347,9 +438,25 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num,
 	u32 flow_class;
 	u16 gid_index;
 	int ret;
+	enum rdma_network_type net_type = RDMA_NETWORK_IB;
+	enum ib_gid_type gid_type = IB_GID_TYPE_IB;
+	union ib_gid dgid;
+	union ib_gid sgid;
 
 	memset(ah_attr, 0, sizeof *ah_attr);
 	if (rdma_cap_eth_ah(device, port_num)) {
+		if (wc->wc_flags & IB_WC_WITH_NETWORK_HDR_TYPE)
+			net_type = wc->network_hdr_type;
+		else
+			net_type = ib_get_net_type_by_grh(device, port_num, grh);
+		gid_type = ib_network_to_gid_type(net_type);
+	}
+	ret = get_gids_from_rdma_hdr((union rdma_network_hdr *)grh, net_type,
+				     &sgid, &dgid);
+	if (ret)
+		return ret;
+
+	if (rdma_protocol_roce(device, port_num)) {
 		u16 vlan_id = wc->wc_flags & IB_WC_WITH_VLAN ?
 				wc->vlan_id : 0xffff;
 
@@ -358,7 +465,7 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num,
 
 		if (!(wc->wc_flags & IB_WC_WITH_SMAC) ||
 		    !(wc->wc_flags & IB_WC_WITH_VLAN)) {
-			ret = rdma_addr_find_dmac_by_grh(&grh->dgid, &grh->sgid,
+			ret = rdma_addr_find_dmac_by_grh(&dgid, &sgid,
 							 ah_attr->dmac,
 							 wc->wc_flags & IB_WC_WITH_VLAN ?
 							 NULL : &vlan_id,
@@ -368,7 +475,7 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num,
 		}
 
 		ret = get_sgid_index_from_eth(device, port_num, vlan_id,
-					      &grh->dgid, &gid_index);
+					      &dgid, gid_type, &gid_index);
 		if (ret)
 			return ret;
 
@@ -383,10 +490,10 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num,
 
 	if (wc->wc_flags & IB_WC_GRH) {
 		ah_attr->ah_flags = IB_AH_GRH;
-		ah_attr->grh.dgid = grh->sgid;
+		ah_attr->grh.dgid = sgid;
 
 		if (!rdma_cap_eth_ah(device, port_num)) {
-			ret = ib_find_cached_gid_by_port(device, &grh->dgid,
+			ret = ib_find_cached_gid_by_port(device, &dgid,
 							 IB_GID_TYPE_IB,
 							 port_num, NULL,
 							 &gid_index);
@@ -1026,6 +1133,12 @@ int ib_resolve_eth_dmac(struct ib_qp *qp,
 					ret = -ENXIO;
 				goto out;
 			}
+			if (sgid_attr.gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP)
+				/* TODO: get the hoplimit from the inet/inet6
+				 * device
+				 */
+				qp_attr->ah_attr.grh.hop_limit =
+							IPV6_DEFAULT_HOPLIMIT;
 
 			ifindex = sgid_attr.ndev->ifindex;
 
diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index 17e4a8b..81e19d9 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -71,6 +71,7 @@ struct rdma_dev_addr {
 	unsigned short dev_type;
 	int bound_dev_if;
 	enum rdma_transport_type transport;
+	enum rdma_network_type network;
 };
 
 /**
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 77906fe..dd1d901 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -50,6 +50,8 @@
 #include <linux/workqueue.h>
 #include <linux/socket.h>
 #include <uapi/linux/if_ether.h>
+#include <net/ipv6.h>
+#include <net/ip.h>
 
 #include <linux/atomic.h>
 #include <linux/mmu_notifier.h>
@@ -107,6 +109,35 @@ enum rdma_protocol_type {
 __attribute_const__ enum rdma_transport_type
 rdma_node_get_transport(enum rdma_node_type node_type);
 
+enum rdma_network_type {
+	RDMA_NETWORK_IB,
+	RDMA_NETWORK_ROCE_V1 = RDMA_NETWORK_IB,
+	RDMA_NETWORK_IPV4,
+	RDMA_NETWORK_IPV6
+};
+
+static inline enum ib_gid_type ib_network_to_gid_type(enum rdma_network_type network_type)
+{
+	if (network_type == RDMA_NETWORK_IPV4 ||
+	    network_type == RDMA_NETWORK_IPV6)
+		return IB_GID_TYPE_ROCE_UDP_ENCAP;
+
+	/* IB_GID_TYPE_IB same as RDMA_NETWORK_ROCE_V1 */
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
@@ -533,6 +564,17 @@ struct ib_grh {
 	union ib_gid	dgid;
 };
 
+union rdma_network_hdr {
+	struct ib_grh ibgrh;
+	struct {
+		/* The IB spec states that if it's IPv4, the header
+		 * is located in the last 20 bytes of the header.
+		 */
+		u8		reserved[20];
+		struct iphdr	roce4grh;
+	};
+};
+
 enum {
 	IB_MULTICAST_QPN = 0xffffff
 };
@@ -769,6 +811,7 @@ enum ib_wc_flags {
 	IB_WC_IP_CSUM_OK	= (1<<3),
 	IB_WC_WITH_SMAC		= (1<<4),
 	IB_WC_WITH_VLAN		= (1<<5),
+	IB_WC_WITH_NETWORK_HDR_TYPE	= (1<<6),
 };
 
 struct ib_wc {
@@ -791,6 +834,7 @@ struct ib_wc {
 	u8			port_num;	/* valid only for DR SMPs on switches */
 	u8			smac[ETH_ALEN];
 	u16			vlan_id;
+	u8			network_hdr_type;
 };
 
 enum ib_cq_notify_flags {
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
