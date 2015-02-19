From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 13/30] IB/Core: Changes to the IB Core infrastructure for RoCEv2 support
Date: Thu, 19 Feb 2015 15:51:40 +0530
Message-ID: <8aa48493-7ae0-4480-80ad-072c40878fdd@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

1. Choose sgid_index and type from all the matching entries in RDMA-CM
   based on hint from the IP stack.
2. Set hop_limit for the IP Packet based on above hint from IP stack
3. Define a RDMA_NETWORK enum type.

Signed-off-by: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/addr.c  |    8 ++++
 drivers/infiniband/core/cma.c   |   10 +++++-
 drivers/infiniband/core/verbs.c |   70 +++++++++++++++++++++------------------
 include/rdma/ib_addr.h          |    1 +
 include/rdma/ib_verbs.h         |    6 +++
 5 files changed, 62 insertions(+), 33 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index 43af7f5..da24c0e 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -257,6 +257,9 @@ static int addr4_resolve(struct sockaddr_in *src_in,
 		goto put;
 	}
 
+	if (rt->rt_uses_gateway)
+		addr->network = RDMA_NETWORK_IPV4;
+
 	ret = dst_fetch_ha(&rt->dst, addr, &fl4.daddr);
 put:
 	ip_rt_put(rt);
@@ -271,6 +274,7 @@ static int addr6_resolve(struct sockaddr_in6 *src_in,
 {
 	struct flowi6 fl6;
 	struct dst_entry *dst;
+	struct rt6_info *rt;
 	int ret;
 
 	memset(&fl6, 0, sizeof fl6);
@@ -282,6 +286,7 @@ static int addr6_resolve(struct sockaddr_in6 *src_in,
 	if ((ret = dst->error))
 		goto put;
 
+	rt = (struct rt6_info *)dst;
 	if (ipv6_addr_any(&fl6.saddr)) {
 		ret = ipv6_dev_get_saddr(&init_net, ip6_dst_idev(dst)->dev,
 					 &fl6.daddr, 0, &fl6.saddr);
@@ -305,6 +310,9 @@ static int addr6_resolve(struct sockaddr_in6 *src_in,
 		goto put;
 	}
 
+	if (rt->rt6i_flags & RTF_GATEWAY)
+		addr->network = RDMA_NETWORK_IPV6;
+
 	ret = dst_fetch_ha(dst, addr, &fl6.daddr);
 put:
 	dst_release(dst);
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 237f2dd..50635fe 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1952,6 +1952,7 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 {
 	struct rdma_route *route = &id_priv->id.route;
 	struct rdma_addr *addr = &route->addr;
+	enum ib_gid_type network_gid_type;
 	struct cma_work *work;
 	int ret;
 	struct net_device *ndev = NULL;
@@ -1990,7 +1991,14 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 	rdma_ip2gid((struct sockaddr *)&id_priv->id.route.addr.dst_addr,
 		    &route->path_rec->dgid);
 
-	route->path_rec->hop_limit = 1;
+	/* Use the hint from IP Stack to select GID Type */
+	network_gid_type = ib_network_to_gid_type(addr->dev_addr.network);
+	if (addr->dev_addr.network != RDMA_NETWORK_IB) {
+		route->path_rec->gid_type = network_gid_type;
+		route->path_rec->hop_limit = IPV6_DEFAULT_HOPLIMIT;
+	} else {
+		route->path_rec->hop_limit = 1;
+	}
 	route->path_rec->reversible = 1;
 	route->path_rec->pkey = cpu_to_be16(0xffff);
 	route->path_rec->mtu_selector = IB_SA_EQ;
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 0fdac14..5478c5d 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -219,37 +219,6 @@ static int ib_get_grh_header_version(const void *h)
 	return 6;
 }
 
-static int ib_get_dgid_sgid_by_grh(const void *h,
-				   enum rdma_network_type net_type,
-				   union ib_gid *dgid, union ib_gid *sgid)
-{
-	switch (net_type) {
-	case RDMA_NETWORK_IPV4: {
-		const struct iphdr *ip4h = (struct iphdr *)(h + 20);
-
-		ipv6_addr_set_v4mapped(ip4h->daddr, (struct in6_addr *)dgid);
-		ipv6_addr_set_v4mapped(ip4h->saddr, (struct in6_addr *)sgid);
-		return 0;
-	}
-	case RDMA_NETWORK_IPV6: {
-		struct ipv6hdr *ip6h = (struct ipv6hdr *)h;
-
-		memcpy(dgid, &ip6h->daddr, sizeof(*dgid));
-		memcpy(sgid, &ip6h->saddr, sizeof(*sgid));
-		return 0;
-	}
-	case RDMA_NETWORK_IB: {
-		struct ib_grh *grh = (struct ib_grh *)h;
-
-		memcpy(dgid, &grh->dgid, sizeof(*dgid));
-		memcpy(sgid, &grh->sgid, sizeof(*sgid));
-		return 0;
-	}
-	}
-
-	return -EINVAL;
-}
-
 static enum rdma_network_type ib_get_net_type_by_grh(struct ib_device *device,
 						     u8 port_num,
 						     const struct ib_grh *grh)
@@ -305,6 +274,40 @@ static int get_sgid_index_from_eth(struct ib_device *device, u8 port_num,
 				     &context, gid_index);
 }
 
+static int get_gids_from_grh(struct ib_grh *grh, enum rdma_network_type net_type,
+			     union ib_gid *sgid, union ib_gid *dgid)
+{
+	union rdma_network_hdr *l3grh;
+	struct sockaddr_in  src_in;
+	struct sockaddr_in  dst_in;
+	__be32 src_saddr, dst_saddr;
+
+	if (!sgid || !dgid)
+		return -EINVAL;
+
+	if (net_type == RDMA_NETWORK_IPV4) {
+		l3grh = (union rdma_network_hdr *)
+			((u8 *)grh + 20);
+		memcpy(&src_in.sin_addr.s_addr,
+		       &l3grh->roce4grh.saddr, 4);
+		memcpy(&dst_in.sin_addr.s_addr,
+		       &l3grh->roce4grh.daddr, 4);
+		src_saddr = src_in.sin_addr.s_addr;
+		dst_saddr = dst_in.sin_addr.s_addr;
+		ipv6_addr_set_v4mapped(src_saddr,
+				       (struct in6_addr *)sgid);
+		ipv6_addr_set_v4mapped(dst_saddr,
+				       (struct in6_addr *)dgid);
+		return 0;
+	} else if (net_type == RDMA_NETWORK_IPV6 ||
+		   net_type == RDMA_NETWORK_IB) {
+		*dgid = grh->dgid;
+		*sgid = grh->sgid;
+		return 0;
+	} else
+		return -EINVAL;
+}
+
 int ib_init_ah_from_wc(struct ib_device *device, u8 port_num, struct ib_wc *wc,
 		       struct ib_grh *grh, struct ib_ah_attr *ah_attr)
 {
@@ -326,7 +329,7 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num, struct ib_wc *wc,
 			net_type = ib_get_net_type_by_grh(device, port_num, grh);
 		gid_type = ib_network_to_gid_type(net_type);
 	}
-	ret = ib_get_dgid_sgid_by_grh(grh, net_type, &dgid, &sgid);
+	ret = get_gids_from_grh(grh, net_type, &sgid, &dgid);
 	if (ret)
 		return ret;
 
@@ -1004,6 +1007,9 @@ int ib_resolve_eth_dmac(struct ib_qp *qp,
 				rcu_read_unlock();
 				goto out;
 			}
+			if (sgid_attr.gid_type == IB_GID_TYPE_ROCE_V2)
+				qp_attr->ah_attr.grh.hop_limit =
+							IPV6_DEFAULT_HOPLIMIT;
 
 			dev_hold(sgid_attr.ndev);
 			ifindex = sgid_attr.ndev->ifindex;
diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index 0dfaaa7..80afbf7 100644
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
index 01eaf32..fa541b9 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -51,6 +51,7 @@
 #include <net/net_namespace.h>
 #include <uapi/linux/if_ether.h>
 #include <net/ipv6.h>
+#include <net/ip.h>
 
 #include <linux/atomic.h>
 #include <linux/mmu_notifier.h>
@@ -516,6 +517,11 @@ struct ib_grh {
 	union ib_gid	dgid;
 };
 
+union rdma_network_hdr {
+	struct ib_grh ibgrh;
+	struct iphdr roce4grh;
+};
+
 enum {
 	IB_MULTICAST_QPN = 0xffffff
 };
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
