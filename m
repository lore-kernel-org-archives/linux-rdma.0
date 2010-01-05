From: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCHv7 4/9] ib_core: RoCEE CMA device binding
Date: Tue, 5 Jan 2010 12:32:57 +0200
Message-ID: <20100105103257.GF31480@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add support for RoCEE device binding and IP --> GID resolution. Path resolving
and multicast joining are implemented within cma.c by filling the responses and
pushing the callbacks to the cma work queue. IP->GID resolution always yields
IPv6 link local addresses - remote GIDs are derived from the destination MAC
address of the remote port. Multicast GIDs are always mapped to multicast MACs
as is done in IPv6. Some helper functions are added to ib_addr.h.  IPv4
multicast is enabled by translating IPv4 multicast addresses to IPv6 multicast
as described in
http://www.mail-archive.com/ipng-Va8kgSFw1KyzQ7sTrsxvMkEOCMrvLtNR@public.gmane.org/msg02134.html.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/core/cma.c  |  261 ++++++++++++++++++++++++++++++++++++++--
 drivers/infiniband/core/ucma.c |   45 ++++++-
 include/rdma/ib_addr.h         |   98 +++++++++++++++-
 3 files changed, 385 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index fbdd731..e8e28ae 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -58,6 +58,7 @@ MODULE_LICENSE("Dual BSD/GPL");
 #define CMA_CM_RESPONSE_TIMEOUT 20
 #define CMA_MAX_CM_RETRIES 15
 #define CMA_CM_MRA_SETTING (IB_CM_MRA_FLAG_DELAY | 24)
+#define ROCEE_PACKET_LIFETIME 18
 
 static void cma_add_one(struct ib_device *device);
 static void cma_remove_one(struct ib_device *device);
@@ -157,6 +158,7 @@ struct cma_multicast {
 	struct list_head	list;
 	void			*context;
 	struct sockaddr_storage	addr;
+	struct kref		mcref;
 };
 
 struct cma_work {
@@ -173,6 +175,12 @@ struct cma_ndev_work {
 	struct rdma_cm_event	event;
 };
 
+struct rocee_mcast_work {
+	struct work_struct	 work;
+	struct rdma_id_private	*id;
+	struct cma_multicast	*mc;
+};
+
 union cma_ip_addr {
 	struct in6_addr ip6;
 	struct {
@@ -281,6 +289,8 @@ static void cma_attach_to_dev(struct rdma_id_private *id_priv,
 	atomic_inc(&cma_dev->refcount);
 	id_priv->cma_dev = cma_dev;
 	id_priv->id.device = cma_dev->device;
+	id_priv->id.route.addr.dev_addr.transport =
+		rdma_node_get_transport(cma_dev->device->node_type);
 	list_add_tail(&id_priv->list, &cma_dev->id_list);
 }
 
@@ -290,6 +300,14 @@ static inline void cma_deref_dev(struct cma_device *cma_dev)
 		complete(&cma_dev->comp);
 }
 
+static inline void release_mc(struct kref *kref)
+{
+	struct cma_multicast *mc = container_of(kref, struct cma_multicast, mcref);
+
+	kfree(mc->multicast.ib);
+	kfree(mc);
+}
+
 static void cma_detach_from_dev(struct rdma_id_private *id_priv)
 {
 	list_del(&id_priv->list);
@@ -556,10 +574,16 @@ static int cma_ib_init_qp_attr(struct rdma_id_private *id_priv,
 {
 	struct rdma_dev_addr *dev_addr = &id_priv->id.route.addr.dev_addr;
 	int ret;
+	u16 pkey;
+
+	if (rdma_port_link_layer(id_priv->id.device, id_priv->id.port_num) ==
+	    IB_LINK_LAYER_INFINIBAND)
+		pkey = ib_addr_get_pkey(dev_addr);
+	else
+		pkey = 0xffff;
 
 	ret = ib_find_cached_pkey(id_priv->id.device, id_priv->id.port_num,
-				  ib_addr_get_pkey(dev_addr),
-				  &qp_attr->pkey_index);
+				  pkey, &qp_attr->pkey_index);
 	if (ret)
 		return ret;
 
@@ -737,8 +761,8 @@ static inline int cma_user_data_offset(enum rdma_port_space ps)
 
 static void cma_cancel_route(struct rdma_id_private *id_priv)
 {
-	switch (rdma_node_get_transport(id_priv->id.device->node_type)) {
-	case RDMA_TRANSPORT_IB:
+	switch (rdma_port_link_layer(id_priv->id.device, id_priv->id.port_num)) {
+	case IB_LINK_LAYER_INFINIBAND:
 		if (id_priv->query)
 			ib_sa_cancel_query(id_priv->query_id, id_priv->query);
 		break;
@@ -816,8 +840,17 @@ static void cma_leave_mc_groups(struct rdma_id_private *id_priv)
 		mc = container_of(id_priv->mc_list.next,
 				  struct cma_multicast, list);
 		list_del(&mc->list);
-		ib_sa_free_multicast(mc->multicast.ib);
-		kfree(mc);
+		switch (rdma_port_link_layer(id_priv->cma_dev->device, id_priv->id.port_num)) {
+		case IB_LINK_LAYER_INFINIBAND:
+			ib_sa_free_multicast(mc->multicast.ib);
+			kfree(mc);
+			break;
+		case IB_LINK_LAYER_ETHERNET:
+			kref_put(&mc->mcref, release_mc);
+			break;
+		default:
+			break;
+		}
 	}
 }
 
@@ -833,7 +866,7 @@ void rdma_destroy_id(struct rdma_cm_id *id)
 	mutex_lock(&lock);
 	if (id_priv->cma_dev) {
 		mutex_unlock(&lock);
-		switch (rdma_node_get_transport(id->device->node_type)) {
+		switch (rdma_node_get_transport(id_priv->id.device->node_type)) {
 		case RDMA_TRANSPORT_IB:
 			if (id_priv->cm_id.ib && !IS_ERR(id_priv->cm_id.ib))
 				ib_destroy_cm_id(id_priv->cm_id.ib);
@@ -1707,6 +1740,78 @@ static int cma_resolve_iw_route(struct rdma_id_private *id_priv, int timeout_ms)
 	return 0;
 }
 
+static int cma_resolve_rocee_route(struct rdma_id_private *id_priv)
+{
+	struct rdma_route *route = &id_priv->id.route;
+	struct rdma_addr *addr = &route->addr;
+	struct cma_work *work;
+	int ret;
+	struct sockaddr_in *src_addr = (struct sockaddr_in *)&route->addr.src_addr;
+	struct sockaddr_in *dst_addr = (struct sockaddr_in *)&route->addr.dst_addr;
+	struct net_device *ndev = NULL;
+
+	if (src_addr->sin_family != dst_addr->sin_family)
+		return -EINVAL;
+
+	work = kzalloc(sizeof *work, GFP_KERNEL);
+	if (!work)
+		return -ENOMEM;
+
+	work->id = id_priv;
+	INIT_WORK(&work->work, cma_work_handler);
+
+	route->path_rec = kzalloc(sizeof *route->path_rec, GFP_KERNEL);
+	if (!route->path_rec) {
+		ret = -ENOMEM;
+		goto err1;
+	}
+
+	route->num_paths = 1;
+
+	rocee_mac_to_ll(&route->path_rec->sgid, addr->dev_addr.src_dev_addr);
+	rocee_mac_to_ll(&route->path_rec->dgid, addr->dev_addr.dst_dev_addr);
+
+	route->path_rec->hop_limit = 2;
+	route->path_rec->reversible = 1;
+	route->path_rec->pkey = cpu_to_be16(0xffff);
+	route->path_rec->mtu_selector = 2;
+
+	if (addr->dev_addr.bound_dev_if) {
+		ndev = dev_get_by_index(&init_net, addr->dev_addr.bound_dev_if);
+		if (!ndev)
+			return -ENODEV;
+	}
+
+	if (ndev)
+		route->path_rec->mtu = rocee_get_mtu(ndev->mtu);
+	route->path_rec->rate_selector = 2;
+	if (ndev)
+		route->path_rec->rate = rocee_get_rate(ndev);
+	dev_put(ndev);
+	route->path_rec->packet_life_time_selector = 2;
+	route->path_rec->packet_life_time = ROCEE_PACKET_LIFETIME;
+	if (!route->path_rec->mtu) {
+		ret = -EINVAL;
+		goto err2;
+	}
+
+	work->old_state = CMA_ROUTE_QUERY;
+	work->new_state = CMA_ROUTE_RESOLVED;
+	work->event.event = RDMA_CM_EVENT_ROUTE_RESOLVED;
+	work->event.status = 0;
+
+	queue_work(cma_wq, &work->work);
+
+	return 0;
+
+err2:
+	kfree(route->path_rec);
+	route->path_rec = NULL;
+err1:
+	kfree(work);
+	return ret;
+}
+
 int rdma_resolve_route(struct rdma_cm_id *id, int timeout_ms)
 {
 	struct rdma_id_private *id_priv;
@@ -1719,7 +1824,16 @@ int rdma_resolve_route(struct rdma_cm_id *id, int timeout_ms)
 	atomic_inc(&id_priv->refcount);
 	switch (rdma_node_get_transport(id->device->node_type)) {
 	case RDMA_TRANSPORT_IB:
-		ret = cma_resolve_ib_route(id_priv, timeout_ms);
+		switch (rdma_port_link_layer(id->device, id->port_num)) {
+		case IB_LINK_LAYER_INFINIBAND:
+			ret = cma_resolve_ib_route(id_priv, timeout_ms);
+			break;
+		case IB_LINK_LAYER_ETHERNET:
+			ret = cma_resolve_rocee_route(id_priv);
+			break;
+		default:
+			ret = -ENOSYS;
+		}
 		break;
 	case RDMA_TRANSPORT_IWARP:
 		ret = cma_resolve_iw_route(id_priv, timeout_ms);
@@ -1772,7 +1886,7 @@ port_found:
 		goto out;
 
 	id_priv->id.route.addr.dev_addr.dev_type =
-		(rdma_node_get_transport(cma_dev->device->node_type) == RDMA_TRANSPORT_IB) ?
+		(rdma_port_link_layer(cma_dev->device, p) == IB_LINK_LAYER_INFINIBAND) ?
 		ARPHRD_INFINIBAND : ARPHRD_ETHER;
 
 	rdma_addr_set_sgid(&id_priv->id.route.addr.dev_addr, &gid);
@@ -2773,6 +2887,107 @@ static int cma_join_ib_multicast(struct rdma_id_private *id_priv,
 	return 0;
 }
 
+
+static void rocee_mcast_work_handler(struct work_struct *work)
+{
+	struct rocee_mcast_work *mw = container_of(work, struct rocee_mcast_work, work);
+	struct cma_multicast *mc = mw->mc;
+	struct ib_sa_multicast *m = mc->multicast.ib;
+
+	mc->multicast.ib->context = mc;
+	cma_ib_mc_handler(0, m);
+	kref_put(&mc->mcref, release_mc);
+	kfree(mw);
+}
+
+static void cma_rocee_set_mgid(struct sockaddr *addr, union ib_gid *mgid)
+{
+	struct sockaddr_in *sin = (struct sockaddr_in *)addr;
+	struct sockaddr_in6 *sin6 = (struct sockaddr_in6 *)addr;
+
+	if (cma_any_addr(addr)) {
+		memset(mgid, 0, sizeof *mgid);
+	} else if (addr->sa_family == AF_INET6)
+		memcpy(mgid, &sin6->sin6_addr, sizeof *mgid);
+	else {
+		mgid->raw[0] = 0xff;
+		mgid->raw[1] = 0x0e;
+		mgid->raw[2] = 0;
+		mgid->raw[3] = 0;
+		mgid->raw[4] = 0;
+		mgid->raw[5] = 0;
+		mgid->raw[6] = 0;
+		mgid->raw[7] = 0;
+		mgid->raw[8] = 0;
+		mgid->raw[9] = 0;
+		mgid->raw[10] = 0xff;
+		mgid->raw[11] = 0xff;
+		*(__be32 *)(&mgid->raw[12]) = sin->sin_addr.s_addr;
+	}
+}
+
+static int cma_rocee_join_multicast(struct rdma_id_private *id_priv,
+				     struct cma_multicast *mc)
+{
+	struct rocee_mcast_work *work;
+	struct rdma_dev_addr *dev_addr = &id_priv->id.route.addr.dev_addr;
+	int err;
+	struct sockaddr *addr = (struct sockaddr *)&mc->addr;
+	struct net_device *ndev = NULL;
+
+	if (cma_zero_addr((struct sockaddr *)&mc->addr))
+		return -EINVAL;
+
+	work = kzalloc(sizeof *work, GFP_KERNEL);
+	if (!work)
+		return -ENOMEM;
+
+	mc->multicast.ib = kzalloc(sizeof(struct ib_sa_multicast), GFP_KERNEL);
+	if (!mc->multicast.ib) {
+		err = -ENOMEM;
+		goto out1;
+	}
+
+	cma_rocee_set_mgid(addr, &mc->multicast.ib->rec.mgid);
+
+	mc->multicast.ib->rec.pkey = cpu_to_be16(0xffff);
+	if (id_priv->id.ps == RDMA_PS_UDP)
+		mc->multicast.ib->rec.qkey = cpu_to_be32(RDMA_UDP_QKEY);
+
+	if (dev_addr->bound_dev_if) {
+		ndev = dev_get_by_index(&init_net, dev_addr->bound_dev_if);
+		if (!ndev) {
+			err = -ENODEV;
+			goto out2;
+		}
+	}
+	if (ndev)
+		mc->multicast.ib->rec.rate = rocee_get_rate(ndev);
+	mc->multicast.ib->rec.hop_limit = 1;
+	if (ndev)
+		mc->multicast.ib->rec.mtu = rocee_get_mtu(ndev->mtu);
+	if (ndev)
+		dev_put(ndev);
+	if (!mc->multicast.ib->rec.mtu) {
+		err = -EINVAL;
+		goto out2;
+	}
+	rocee_addr_get_sgid(dev_addr, &mc->multicast.ib->rec.port_gid);
+	work->id = id_priv;
+	work->mc = mc;
+	INIT_WORK(&work->work, rocee_mcast_work_handler);
+	kref_get(&mc->mcref);
+	queue_work(cma_wq, &work->work);
+
+	return 0;
+
+out2:
+	kfree(mc->multicast.ib);
+out1:
+	kfree(work);
+	return err;
+}
+
 int rdma_join_multicast(struct rdma_cm_id *id, struct sockaddr *addr,
 			void *context)
 {
@@ -2799,7 +3014,17 @@ int rdma_join_multicast(struct rdma_cm_id *id, struct sockaddr *addr,
 
 	switch (rdma_node_get_transport(id->device->node_type)) {
 	case RDMA_TRANSPORT_IB:
-		ret = cma_join_ib_multicast(id_priv, mc);
+		switch (rdma_port_link_layer(id->device, id->port_num)) {
+		case IB_LINK_LAYER_INFINIBAND:
+			ret = cma_join_ib_multicast(id_priv, mc);
+			break;
+		case IB_LINK_LAYER_ETHERNET:
+			kref_init(&mc->mcref);
+			ret = cma_rocee_join_multicast(id_priv, mc);
+			break;
+		default:
+			ret = -EINVAL;
+		}
 		break;
 	default:
 		ret = -ENOSYS;
@@ -2812,6 +3037,7 @@ int rdma_join_multicast(struct rdma_cm_id *id, struct sockaddr *addr,
 		spin_unlock_irq(&id_priv->lock);
 		kfree(mc);
 	}
+
 	return ret;
 }
 EXPORT_SYMBOL(rdma_join_multicast);
@@ -2832,8 +3058,19 @@ void rdma_leave_multicast(struct rdma_cm_id *id, struct sockaddr *addr)
 				ib_detach_mcast(id->qp,
 						&mc->multicast.ib->rec.mgid,
 						mc->multicast.ib->rec.mlid);
-			ib_sa_free_multicast(mc->multicast.ib);
-			kfree(mc);
+			if (rdma_node_get_transport(id_priv->cma_dev->device->node_type) == RDMA_TRANSPORT_IB) {
+				switch (rdma_port_link_layer(id->device, id->port_num)) {
+				case IB_LINK_LAYER_INFINIBAND:
+					ib_sa_free_multicast(mc->multicast.ib);
+					kfree(mc);
+					break;
+				case IB_LINK_LAYER_ETHERNET:
+					kref_put(&mc->mcref, release_mc);
+					break;
+				default:
+					break;
+				}
+			}
 			return;
 		}
 	}
diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index b2e16c3..c17678b 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -582,6 +582,34 @@ static void ucma_copy_ib_route(struct rdma_ucm_query_route_resp *resp,
 	}
 }
 
+static void ucma_copy_rocee_route(struct rdma_ucm_query_route_resp *resp,
+				   struct rdma_route *route)
+{
+	struct rdma_dev_addr *dev_addr;
+
+	resp->num_paths = route->num_paths;
+	switch (route->num_paths) {
+	case 0:
+		dev_addr = &route->addr.dev_addr;
+		rocee_mac_to_ll((union ib_gid *) &resp->ib_route[0].dgid,
+				 dev_addr->dst_dev_addr);
+		rocee_addr_get_sgid(dev_addr,
+				 (union ib_gid *) &resp->ib_route[0].sgid);
+		resp->ib_route[0].pkey = cpu_to_be16(0xffff);
+		break;
+	case 2:
+		ib_copy_path_rec_to_user(&resp->ib_route[1],
+					 &route->path_rec[1]);
+		/* fall through */
+	case 1:
+		ib_copy_path_rec_to_user(&resp->ib_route[0],
+					 &route->path_rec[0]);
+		break;
+	default:
+		break;
+	}
+}
+
 static ssize_t ucma_query_route(struct ucma_file *file,
 				const char __user *inbuf,
 				int in_len, int out_len)
@@ -616,12 +644,17 @@ static ssize_t ucma_query_route(struct ucma_file *file,
 
 	resp.node_guid = (__force __u64) ctx->cm_id->device->node_guid;
 	resp.port_num = ctx->cm_id->port_num;
-	switch (rdma_node_get_transport(ctx->cm_id->device->node_type)) {
-	case RDMA_TRANSPORT_IB:
-		ucma_copy_ib_route(&resp, &ctx->cm_id->route);
-		break;
-	default:
-		break;
+	if (rdma_node_get_transport(ctx->cm_id->device->node_type) == RDMA_TRANSPORT_IB) {
+		switch (rdma_port_link_layer(ctx->cm_id->device, ctx->cm_id->port_num)) {
+		case IB_LINK_LAYER_INFINIBAND:
+			ucma_copy_ib_route(&resp, &ctx->cm_id->route);
+			break;
+		case IB_LINK_LAYER_ETHERNET:
+			ucma_copy_rocee_route(&resp, &ctx->cm_id->route);
+			break;
+		default:
+			break;
+		}
 	}
 
 out:
diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index fa0d52b..b3cdaad 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -40,6 +40,7 @@
 #include <linux/netdevice.h>
 #include <linux/socket.h>
 #include <rdma/ib_verbs.h>
+#include <rdma/ib_pack.h>
 
 struct rdma_addr_client {
 	atomic_t refcount;
@@ -63,6 +64,7 @@ struct rdma_dev_addr {
 	unsigned char broadcast[MAX_ADDR_LEN];
 	unsigned short dev_type;
 	int bound_dev_if;
+	enum rdma_transport_type transport;
 };
 
 /**
@@ -127,9 +129,31 @@ static inline int rdma_addr_gid_offset(struct rdma_dev_addr *dev_addr)
 	return dev_addr->dev_type == ARPHRD_INFINIBAND ? 4 : 0;
 }
 
+static inline void rocee_mac_to_ll(union ib_gid *gid, u8 *mac)
+{
+	memset(gid->raw, 0, 16);
+	*((u32 *)gid->raw) = cpu_to_be32(0xfe800000);
+	gid->raw[12] = 0xfe;
+	gid->raw[11] = 0xff;
+	memcpy(gid->raw + 13, mac + 3, 3);
+	memcpy(gid->raw + 8, mac, 3);
+	gid->raw[8] ^= 2;
+}
+
+static inline void rocee_addr_get_sgid(struct rdma_dev_addr *dev_addr,
+					union ib_gid *gid)
+{
+	rocee_mac_to_ll(gid, dev_addr->src_dev_addr);
+}
+
 static inline void rdma_addr_get_sgid(struct rdma_dev_addr *dev_addr, union ib_gid *gid)
 {
-	memcpy(gid, dev_addr->src_dev_addr + rdma_addr_gid_offset(dev_addr), sizeof *gid);
+	if (dev_addr->transport == RDMA_TRANSPORT_IB &&
+	    dev_addr->dev_type != ARPHRD_INFINIBAND)
+		rocee_addr_get_sgid(dev_addr, gid);
+	else
+		memcpy(gid, dev_addr->src_dev_addr +
+		       rdma_addr_gid_offset(dev_addr), sizeof *gid);
 }
 
 static inline void rdma_addr_set_sgid(struct rdma_dev_addr *dev_addr, union ib_gid *gid)
@@ -147,4 +171,76 @@ static inline void rdma_addr_set_dgid(struct rdma_dev_addr *dev_addr, union ib_g
 	memcpy(dev_addr->dst_dev_addr + rdma_addr_gid_offset(dev_addr), gid, sizeof *gid);
 }
 
+static inline enum ib_mtu rocee_get_mtu(int mtu)
+{
+	/*
+	 * reduce IB headers from effective RoCEE MTU. 28 stands for
+	 * atomic header which is the biggest possible header after BTH
+	 */
+	mtu = mtu - IB_GRH_BYTES - IB_BTH_BYTES - 28;
+
+	if (mtu >= ib_mtu_enum_to_int(IB_MTU_4096))
+		return IB_MTU_4096;
+	else if (mtu >= ib_mtu_enum_to_int(IB_MTU_2048))
+		return IB_MTU_2048;
+	else if (mtu >= ib_mtu_enum_to_int(IB_MTU_1024))
+		return IB_MTU_1024;
+	else if (mtu >= ib_mtu_enum_to_int(IB_MTU_512))
+		return IB_MTU_512;
+	else if (mtu >= ib_mtu_enum_to_int(IB_MTU_256))
+		return IB_MTU_256;
+	else
+		return 0;
+}
+
+static inline int rocee_get_rate(struct net_device *dev)
+{
+	struct ethtool_cmd cmd;
+
+	if (!dev->ethtool_ops || !dev->ethtool_ops->get_settings ||
+	    dev->ethtool_ops->get_settings(dev, &cmd))
+		return IB_RATE_PORT_CURRENT;
+
+	if (cmd.speed >= 40000)
+		return IB_RATE_40_GBPS;
+	else if (cmd.speed >= 30000)
+		return IB_RATE_30_GBPS;
+	else if (cmd.speed >= 20000)
+		return IB_RATE_20_GBPS;
+	else if (cmd.speed >= 10000)
+		return IB_RATE_10_GBPS;
+	else
+		return IB_RATE_PORT_CURRENT;
+}
+
+static inline int rdma_link_local_addr(struct in6_addr *addr)
+{
+	if (addr->s6_addr32[0] == cpu_to_be32(0xfe800000) &&
+	    addr->s6_addr32[1] == 0)
+		return 1;
+
+	return 0;
+}
+
+static inline void rdma_get_ll_mac(struct in6_addr *addr, u8 *mac)
+{
+	memcpy(mac, &addr->s6_addr[8], 3);
+	memcpy(mac + 3, &addr->s6_addr[13], 3);
+	mac[0] ^= 2;
+}
+
+static inline int rdma_is_multicast_addr(struct in6_addr *addr)
+{
+	return addr->s6_addr[0] == 0xff ? 1 : 0;
+}
+
+static inline void rdma_get_mcast_mac(struct in6_addr *addr, u8 *mac)
+{
+	int i;
+
+	mac[0] = 0x33;
+	mac[1] = 0x33;
+	for (i = 2; i < 6; ++i)
+		mac[i] = addr->s6_addr[i + 10];
+}
 #endif /* IB_ADDR_H */
-- 
1.6.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
