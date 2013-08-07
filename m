From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V3 for-next 2/9] IB/CMA: RoCE IP based GID addressing
Date: Wed,  7 Aug 2013 18:34:55 +0300
Message-ID: <1375889702-14818-3-git-send-email-ogerlitz@mellanox.com>
References: <1375889702-14818-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375889702-14818-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Currently, the IB core and specifically the RDMA-CM assumes that
RoCE (IBoE) gids encode related Ethernet netdevice interface
MAC address and possibly VLAN id.

Change gids to be treated as they encode interface IP address.

Since Ethernet layer 2 address parameters are not longer encoded
within gids, had to extend the Infiniband address structures (e.g.
ib_ah_attr) with layer 2 address parameters, namely mac and vlan.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cma.c  |   40 +++++++++++++++++--------
 drivers/infiniband/core/ucma.c |   18 ++---------
 include/rdma/ib_addr.h         |   61 +++++++++++++++++++++++++++------------
 3 files changed, 73 insertions(+), 46 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 4b82e27..e25d5da 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -386,7 +386,9 @@ static int cma_acquire_dev(struct rdma_id_private *id_priv)
 		return -EINVAL;
 
 	mutex_lock(&lock);
-	iboe_addr_get_sgid(dev_addr, &iboe_gid);
+	rdma_ip2gid((struct sockaddr *)&id_priv->id.route.addr.src_addr,
+		    &iboe_gid);
+
 	memcpy(&gid, dev_addr->src_dev_addr +
 	       rdma_addr_gid_offset(dev_addr), sizeof gid);
 	list_for_each_entry(cma_dev, &dev_list, list) {
@@ -600,11 +602,23 @@ EXPORT_SYMBOL(rdma_destroy_qp);
 static int cma_find_smac_by_sgid(union ib_gid *sgid, u8 *smac)
 {
 	int ret = 0;
-	struct in6_addr in6;
+	struct rdma_dev_addr dev_addr;
+	union {
+		struct sockaddr     _sockaddr;
+		struct sockaddr_in  _sockaddr_in;
+		struct sockaddr_in6 _sockaddr_in6;
+	} gid_addr;
+
+	ret = rdma_gid2ip(&gid_addr._sockaddr, sgid);
 
-	memcpy(&in6, sgid, sizeof(in6));
-	rdma_get_ll_mac(&in6, smac);
+	if (ret)
+		return ret;
+	memset(&dev_addr, 0, sizeof(dev_addr));
+	ret = rdma_translate_ip(&gid_addr._sockaddr, &dev_addr);
+	if (ret)
+		return ret;
 
+	memcpy(smac, dev_addr.src_dev_addr, ETH_ALEN);
 	return ret;
 }
 
@@ -1941,10 +1955,10 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 	memcpy(route->path_rec->dmac, addr->dev_addr.dst_dev_addr, ETH_ALEN);
 	memcpy(route->path_rec->smac, ndev->dev_addr, ndev->addr_len);
 
-	iboe_mac_vlan_to_ll(&route->path_rec->sgid, addr->dev_addr.src_dev_addr,
-			    be16_to_cpu(route->path_rec->vlan_id));
-	iboe_mac_vlan_to_ll(&route->path_rec->dgid, addr->dev_addr.dst_dev_addr,
-			    be16_to_cpu(route->path_rec->vlan_id));
+	rdma_ip2gid((struct sockaddr *)&id_priv->id.route.addr.src_addr,
+		    &route->path_rec->sgid);
+	rdma_ip2gid((struct sockaddr *)&id_priv->id.route.addr.dst_addr,
+		    &route->path_rec->dgid);
 
 	route->path_rec->hop_limit = 1;
 	route->path_rec->reversible = 1;
@@ -2111,6 +2125,7 @@ static void addr_handler(int status, struct sockaddr *src_addr,
 			   RDMA_CM_ADDR_RESOLVED))
 		goto out;
 
+	memcpy(cma_src_addr(id_priv), src_addr, rdma_addr_size(src_addr));
 	if (!status && !id_priv->cma_dev)
 		status = cma_acquire_dev(id_priv);
 
@@ -2120,10 +2135,8 @@ static void addr_handler(int status, struct sockaddr *src_addr,
 			goto out;
 		event.event = RDMA_CM_EVENT_ADDR_ERROR;
 		event.status = status;
-	} else {
-		memcpy(cma_src_addr(id_priv), src_addr, rdma_addr_size(src_addr));
+	} else
 		event.event = RDMA_CM_EVENT_ADDR_RESOLVED;
-	}
 
 	if (id_priv->id.event_handler(&id_priv->id, &event)) {
 		cma_exch(id_priv, RDMA_CM_DESTROYING);
@@ -2604,6 +2617,7 @@ int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
 	if (ret)
 		goto err1;
 
+	memcpy(cma_src_addr(id_priv), addr, rdma_addr_size(addr));
 	if (!cma_any_addr(addr)) {
 		ret = cma_translate_addr(addr, &id->route.addr.dev_addr);
 		if (ret)
@@ -2614,7 +2628,6 @@ int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
 			goto err1;
 	}
 
-	memcpy(cma_src_addr(id_priv), addr, rdma_addr_size(addr));
 	if (!(id_priv->options & (1 << CMA_OPTION_AFONLY))) {
 		if (addr->sa_family == AF_INET)
 			id_priv->afonly = 1;
@@ -3345,7 +3358,8 @@ static int cma_iboe_join_multicast(struct rdma_id_private *id_priv,
 		err = -EINVAL;
 		goto out2;
 	}
-	iboe_addr_get_sgid(dev_addr, &mc->multicast.ib->rec.port_gid);
+	rdma_ip2gid((struct sockaddr *)&id_priv->id.route.addr.src_addr,
+		    &mc->multicast.ib->rec.port_gid);
 	work->id = id_priv;
 	work->mc = mc;
 	INIT_WORK(&work->work, iboe_mcast_work_handler);
diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index b0f189b..7e7da86 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -655,24 +655,14 @@ static void ucma_copy_ib_route(struct rdma_ucm_query_route_resp *resp,
 static void ucma_copy_iboe_route(struct rdma_ucm_query_route_resp *resp,
 				 struct rdma_route *route)
 {
-	struct rdma_dev_addr *dev_addr;
-	struct net_device *dev;
-	u16 vid = 0;
 
 	resp->num_paths = route->num_paths;
 	switch (route->num_paths) {
 	case 0:
-		dev_addr = &route->addr.dev_addr;
-		dev = dev_get_by_index(&init_net, dev_addr->bound_dev_if);
-			if (dev) {
-				vid = rdma_vlan_dev_vlan_id(dev);
-				dev_put(dev);
-			}
-
-		iboe_mac_vlan_to_ll((union ib_gid *) &resp->ib_route[0].dgid,
-				    dev_addr->dst_dev_addr, vid);
-		iboe_addr_get_sgid(dev_addr,
-				   (union ib_gid *) &resp->ib_route[0].sgid);
+		rdma_ip2gid((struct sockaddr *)&route->addr.dst_addr,
+			    (union ib_gid *)&resp->ib_route[0].dgid);
+		rdma_ip2gid((struct sockaddr *)&route->addr.src_addr,
+			    (union ib_gid *)&resp->ib_route[0].sgid);
 		resp->ib_route[0].pkey = cpu_to_be16(0xffff);
 		break;
 	case 2:
diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index f3ac0f2..f3d91cc 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -38,8 +38,12 @@
 #include <linux/in6.h>
 #include <linux/if_arp.h>
 #include <linux/netdevice.h>
+#include <linux/inetdevice.h>
 #include <linux/socket.h>
 #include <linux/if_vlan.h>
+#include <net/ipv6.h>
+#include <net/if_inet6.h>
+#include <net/ip.h>
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_pack.h>
 
@@ -126,41 +130,60 @@ static inline int rdma_addr_gid_offset(struct rdma_dev_addr *dev_addr)
 	return dev_addr->dev_type == ARPHRD_INFINIBAND ? 4 : 0;
 }
 
-static inline void iboe_mac_vlan_to_ll(union ib_gid *gid, u8 *mac, u16 vid)
+static inline u16 rdma_vlan_dev_vlan_id(const struct net_device *dev)
 {
-	memset(gid->raw, 0, 16);
-	*((__be32 *) gid->raw) = cpu_to_be32(0xfe800000);
-	if (vid < 0x1000) {
-		gid->raw[12] = vid & 0xff;
-		gid->raw[11] = vid >> 8;
-	} else {
-		gid->raw[12] = 0xfe;
-		gid->raw[11] = 0xff;
+	return dev->priv_flags & IFF_802_1Q_VLAN ?
+		vlan_dev_vlan_id(dev) : 0xffff;
+}
+
+static inline int rdma_ip2gid(struct sockaddr *addr, union ib_gid *gid)
+{
+	switch (addr->sa_family) {
+	case AF_INET:
+		ipv6_addr_set_v4mapped(((struct sockaddr_in *)
+					addr)->sin_addr.s_addr,
+				       (struct in6_addr *)gid);
+		break;
+	case AF_INET6:
+		memcpy(gid->raw, &((struct sockaddr_in6 *)addr)->sin6_addr, 16);
+		break;
+	default:
+		return -EINVAL;
 	}
-	memcpy(gid->raw + 13, mac + 3, 3);
-	memcpy(gid->raw + 8, mac, 3);
-	gid->raw[8] ^= 2;
+	return 0;
 }
 
-static inline u16 rdma_vlan_dev_vlan_id(const struct net_device *dev)
+/* Important - sockaddr should be a union of sockaddr_in and sockaddr_in6 */
+static inline int rdma_gid2ip(struct sockaddr *out, union ib_gid *gid)
 {
-	return dev->priv_flags & IFF_802_1Q_VLAN ?
-		vlan_dev_vlan_id(dev) : 0xffff;
+	if (ipv6_addr_v4mapped((struct in6_addr *)gid)) {
+		struct sockaddr_in *out_in = (struct sockaddr_in *)out;
+		memset(out_in, 0, sizeof(*out_in));
+		out_in->sin_family = AF_INET;
+		memcpy(&out_in->sin_addr.s_addr, gid->raw + 12, 4);
+	} else {
+		struct sockaddr_in6 *out_in = (struct sockaddr_in6 *)out;
+		memset(out_in, 0, sizeof(*out_in));
+		out_in->sin6_family = AF_INET6;
+		memcpy(&out_in->sin6_addr.s6_addr, gid->raw, 16);
+	}
+	return 0;
 }
 
 static inline void iboe_addr_get_sgid(struct rdma_dev_addr *dev_addr,
 				      union ib_gid *gid)
 {
 	struct net_device *dev;
-	u16 vid = 0xffff;
+	struct in_device *ip4;
 
 	dev = dev_get_by_index(&init_net, dev_addr->bound_dev_if);
 	if (dev) {
-		vid = rdma_vlan_dev_vlan_id(dev);
+		ip4 = (struct in_device *)dev->ip_ptr;
+		if (ip4 && ip4->ifa_list && ip4->ifa_list->ifa_address)
+			ipv6_addr_set_v4mapped(ip4->ifa_list->ifa_address,
+					       (struct in6_addr *)gid);
 		dev_put(dev);
 	}
-
-	iboe_mac_vlan_to_ll(gid, dev_addr->src_dev_addr, vid);
 }
 
 static inline void rdma_addr_get_sgid(struct rdma_dev_addr *dev_addr, union ib_gid *gid)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
