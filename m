From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 for-next 1/6] IB/core: RoCE IP based GID addressing
Date: Wed, 19 Jun 2013 10:47:06 +0300
Message-ID: <1371628031-17546-2-git-send-email-ogerlitz@mellanox.com>
References: <1371628031-17546-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1371628031-17546-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

Currently, the IB core assume RoCE (IBoE) gids encode related Ethernet
netdevice interface MAC address and possibly VLAN id.

Change gids to be treated as they encode interface IP address.

Since Ethernet layer 2 address parameters are not longer encoded within gids,
had to extend the Infiniband address structures (e.g. ib_ah_attr) with layer 2
address parameters, namely mac and vlan.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cm.c       |    3 ++
 drivers/infiniband/core/cma.c      |   39 ++++++++++++++++++++++--------
 drivers/infiniband/core/sa_query.c |    5 ++++
 drivers/infiniband/core/ucma.c     |   18 +++-----------
 drivers/infiniband/core/verbs.c    |    7 +++++
 include/rdma/ib_addr.h             |   45 ++++++++++++++++++++----------------
 include/rdma/ib_sa.h               |    3 ++
 include/rdma/ib_verbs.h            |    4 +++
 8 files changed, 79 insertions(+), 45 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 784b97c..7af618f 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1557,6 +1557,9 @@ static int cm_req_handler(struct cm_work *work)
 
 	cm_process_routed_req(req_msg, work->mad_recv_wc->wc);
 	cm_format_paths_from_req(req_msg, &work->path[0], &work->path[1]);
+
+	memcpy(work->path[0].dmac, cm_id_priv->av.ah_attr.dmac, 6);
+	work->path[0].vlan = cm_id_priv->av.ah_attr.vlan;
 	ret = cm_init_av_by_path(&work->path[0], &cm_id_priv->av);
 	if (ret) {
 		ib_get_cached_gid(work->port->cm_dev->ib_device,
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 71c2c71..ba217c9 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -373,7 +373,9 @@ static int cma_acquire_dev(struct rdma_id_private *id_priv)
 		return -EINVAL;
 
 	mutex_lock(&lock);
-	iboe_addr_get_sgid(dev_addr, &iboe_gid);
+	rdma_ip2gid((struct sockaddr *)&id_priv->id.route.addr.src_addr,
+		    &iboe_gid);
+
 	memcpy(&gid, dev_addr->src_dev_addr +
 	       rdma_addr_gid_offset(dev_addr), sizeof gid);
 	list_for_each_entry(cma_dev, &dev_list, list) {
@@ -1803,7 +1805,7 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 	struct sockaddr_in *src_addr = (struct sockaddr_in *)&route->addr.src_addr;
 	struct sockaddr_in *dst_addr = (struct sockaddr_in *)&route->addr.dst_addr;
 	struct net_device *ndev = NULL;
-	u16 vid;
+
 
 	if (src_addr->sin_family != dst_addr->sin_family)
 		return -EINVAL;
@@ -1830,10 +1832,13 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 		goto err2;
 	}
 
-	vid = rdma_vlan_dev_vlan_id(ndev);
+	route->path_rec->vlan = rdma_vlan_dev_vlan_id(ndev);
+	memcpy(route->path_rec->dmac, addr->dev_addr.dst_dev_addr, 6);
 
-	iboe_mac_vlan_to_ll(&route->path_rec->sgid, addr->dev_addr.src_dev_addr, vid);
-	iboe_mac_vlan_to_ll(&route->path_rec->dgid, addr->dev_addr.dst_dev_addr, vid);
+	rdma_ip2gid((struct sockaddr *)&id_priv->id.route.addr.src_addr,
+		    &route->path_rec->sgid);
+	rdma_ip2gid((struct sockaddr *)&id_priv->id.route.addr.dst_addr,
+		    &route->path_rec->dgid);
 
 	route->path_rec->hop_limit = 1;
 	route->path_rec->reversible = 1;
@@ -1970,6 +1975,8 @@ static void addr_handler(int status, struct sockaddr *src_addr,
 			   RDMA_CM_ADDR_RESOLVED))
 		goto out;
 
+	memcpy(&id_priv->id.route.addr.src_addr, src_addr,
+	       ip_addr_size(src_addr));
 	if (!status && !id_priv->cma_dev)
 		status = cma_acquire_dev(id_priv);
 
@@ -1979,11 +1986,8 @@ static void addr_handler(int status, struct sockaddr *src_addr,
 			goto out;
 		event.event = RDMA_CM_EVENT_ADDR_ERROR;
 		event.status = status;
-	} else {
-		memcpy(&id_priv->id.route.addr.src_addr, src_addr,
-		       ip_addr_size(src_addr));
+	} else
 		event.event = RDMA_CM_EVENT_ADDR_RESOLVED;
-	}
 
 	if (id_priv->id.event_handler(&id_priv->id, &event)) {
 		cma_exch(id_priv, RDMA_CM_DESTROYING);
@@ -2381,6 +2385,7 @@ int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
 	if (ret)
 		goto err1;
 
+	memcpy(&id->route.addr.src_addr, addr, ip_addr_size(addr));
 	if (!cma_any_addr(addr)) {
 		ret = rdma_translate_ip(addr, &id->route.addr.dev_addr);
 		if (ret)
@@ -2391,7 +2396,6 @@ int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
 			goto err1;
 	}
 
-	memcpy(&id->route.addr.src_addr, addr, ip_addr_size(addr));
 	if (!(id_priv->options & (1 << CMA_OPTION_AFONLY))) {
 		if (addr->sa_family == AF_INET)
 			id_priv->afonly = 1;
@@ -2951,9 +2955,13 @@ static int cma_ib_mc_handler(int status, struct ib_sa_multicast *multicast)
 	struct rdma_id_private *id_priv;
 	struct cma_multicast *mc = multicast->context;
 	struct rdma_cm_event event;
+	struct rdma_dev_addr *dev_addr;
 	int ret;
+	struct net_device *ndev = NULL;
+	u16 vlan;
 
 	id_priv = mc->id_priv;
+	dev_addr = &id_priv->id.route.addr.dev_addr;
 	if (cma_disable_callback(id_priv, RDMA_CM_ADDR_BOUND) &&
 	    cma_disable_callback(id_priv, RDMA_CM_ADDR_RESOLVED))
 		return 0;
@@ -2967,11 +2975,19 @@ static int cma_ib_mc_handler(int status, struct ib_sa_multicast *multicast)
 	memset(&event, 0, sizeof event);
 	event.status = status;
 	event.param.ud.private_data = mc->context;
+	ndev = dev_get_by_index(&init_net, dev_addr->bound_dev_if);
+	if (!ndev) {
+		status = -ENODEV;
+	} else {
+		vlan = rdma_vlan_dev_vlan_id(ndev);
+		dev_put(ndev);
+	}
 	if (!status) {
 		event.event = RDMA_CM_EVENT_MULTICAST_JOIN;
 		ib_init_ah_from_mcmember(id_priv->id.device,
 					 id_priv->id.port_num, &multicast->rec,
 					 &event.param.ud.ah_attr);
+		event.param.ud.ah_attr.vlan = vlan;
 		event.param.ud.qp_num = 0xFFFFFF;
 		event.param.ud.qkey = be32_to_cpu(multicast->rec.qkey);
 	} else
@@ -3138,7 +3154,8 @@ static int cma_iboe_join_multicast(struct rdma_id_private *id_priv,
 		err = -EINVAL;
 		goto out2;
 	}
-	iboe_addr_get_sgid(dev_addr, &mc->multicast.ib->rec.port_gid);
+	rdma_ip2gid((struct sockaddr *)&id_priv->id.route.addr.src_addr,
+		    &mc->multicast.ib->rec.port_gid);
 	work->id = id_priv;
 	work->mc = mc;
 	INIT_WORK(&work->work, iboe_mcast_work_handler);
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 934f45e..d813075 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -556,6 +556,11 @@ int ib_init_ah_from_path(struct ib_device *device, u8 port_num,
 		ah_attr->grh.hop_limit     = rec->hop_limit;
 		ah_attr->grh.traffic_class = rec->traffic_class;
 	}
+	if (force_grh) {
+		memcpy(ah_attr->dmac, rec->dmac, 6);
+		ah_attr->vlan = rec->vlan;
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL(ib_init_ah_from_path);
diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 5ca44cd..bc2cb5d 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -602,24 +602,14 @@ static void ucma_copy_ib_route(struct rdma_ucm_query_route_resp *resp,
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
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 22192de..936ec87 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -189,8 +189,15 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num, struct ib_wc *wc,
 	u32 flow_class;
 	u16 gid_index;
 	int ret;
+	int is_eth = (rdma_port_get_link_layer(device, port_num) ==
+			IB_LINK_LAYER_ETHERNET);
 
 	memset(ah_attr, 0, sizeof *ah_attr);
+	if (is_eth) {
+		memcpy(ah_attr->dmac, wc->smac, 6);
+		ah_attr->vlan = wc->vlan;
+	}
+
 	ah_attr->dlid = wc->slid;
 	ah_attr->sl = wc->sl;
 	ah_attr->src_path_bits = wc->dlid_path_bits;
diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index 9996539..b38f837 100644
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
 
@@ -130,41 +134,42 @@ static inline int rdma_addr_gid_offset(struct rdma_dev_addr *dev_addr)
 	return dev_addr->dev_type == ARPHRD_INFINIBAND ? 4 : 0;
 }
 
-static inline void iboe_mac_vlan_to_ll(union ib_gid *gid, u8 *mac, u16 vid)
-{
-	memset(gid->raw, 0, 16);
-	*((__be32 *) gid->raw) = cpu_to_be32(0xfe800000);
-	if (vid < 0x1000) {
-		gid->raw[12] = vid & 0xff;
-		gid->raw[11] = vid >> 8;
-	} else {
-		gid->raw[12] = 0xfe;
-		gid->raw[11] = 0xff;
-	}
-	memcpy(gid->raw + 13, mac + 3, 3);
-	memcpy(gid->raw + 8, mac, 3);
-	gid->raw[8] ^= 2;
-}
-
 static inline u16 rdma_vlan_dev_vlan_id(const struct net_device *dev)
 {
 	return dev->priv_flags & IFF_802_1Q_VLAN ?
 		vlan_dev_vlan_id(dev) : 0xffff;
 }
 
+static inline int rdma_ip2gid(struct sockaddr *addr, union ib_gid *gid)
+{
+	switch (addr->sa_family) {
+	case AF_INET:
+		ipv6_addr_set_v4mapped(((struct sockaddr_in *)addr)->sin_addr.s_addr,
+				       (struct in6_addr *)gid);
+		break;
+	case AF_INET6:
+		memcpy(gid->raw, &((struct sockaddr_in6 *)addr)->sin6_addr, 16);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
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
diff --git a/include/rdma/ib_sa.h b/include/rdma/ib_sa.h
index 8275e53..0a9207e 100644
--- a/include/rdma/ib_sa.h
+++ b/include/rdma/ib_sa.h
@@ -154,6 +154,9 @@ struct ib_sa_path_rec {
 	u8           packet_life_time_selector;
 	u8           packet_life_time;
 	u8           preference;
+	u8           smac[6];
+	u8           dmac[6];
+	__be16       vlan;
 };
 
 #define IB_SA_MCMEMBER_REC_MGID				IB_SA_COMP_MASK( 0)
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 98cc4b2..ef1f332 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -469,6 +469,8 @@ struct ib_ah_attr {
 	u8			static_rate;
 	u8			ah_flags;
 	u8			port_num;
+	u8			dmac[6];
+	u16			vlan;
 };
 
 enum ib_wc_status {
@@ -541,6 +543,8 @@ struct ib_wc {
 	u8			sl;
 	u8			dlid_path_bits;
 	u8			port_num;	/* valid only for DR SMPs on switches */
+	u8			smac[6];
+	u16			vlan;
 };
 
 enum ib_cq_notify_flags {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
