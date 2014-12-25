From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/6] IB/Core: Changes to the IB Core infrastructure for RoCEv2 support
Date: Thu, 25 Dec 2014 06:29:11 +0530
Message-ID: <99a3d3b9-842b-450f-916a-87eb197048a3@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Somnath kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Somnath kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

1. Associate gid_index with a Type (as per V2 SPEC) in GID Table
   and GID Cache.
2. Modify GID Cache helper functions to search for gid_index based on
   GID Value and Type.
3. Choose sgid_index from all the matching entries in RDMA-CM based on
   hint from the IP stack.
4. Set hop_limit for the IP Packet based on above hint from IP stack
5. Modify GID table population for all device drivers to add the GID Type
   for each IP address entry. Each GID will appear twice, one for RoCEV1
   and another for RoCEV2.
6. Introduce a new API/ Driver hook to query GID Type.
   Default to GID_TYPE_V1 for all drivers/cards that don't support V2 so
   all drivers for now don't have to mandatorily implement the new hook.
7. Introduce a new Port Capability flag for a HW vendor to indicate
   RoCEV2 Based GIDs support.
8. Introduce a new API to report Port Type (RoCEV2 or V1).

Signed-off-by: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/addr.c      |    8 +++
 drivers/infiniband/core/cache.c     |   14 ++++--
 drivers/infiniband/core/cm.c        |   15 ++++--
 drivers/infiniband/core/cma.c       |   56 +++++++++++++++++++----
 drivers/infiniband/core/device.c    |   23 +++++++++
 drivers/infiniband/core/multicast.c |    3 +-
 drivers/infiniband/core/sa_query.c  |    3 +-
 drivers/infiniband/core/verbs.c     |   68 ++++++++++++++++++++++++----
 include/rdma/ib_addr.h              |    1 +
 include/rdma/ib_cache.h             |    2 +
 include/rdma/ib_sa.h                |    1 +
 include/rdma/ib_verbs.h             |   85 ++++++++++++++++++++++++++++++++++-
 12 files changed, 248 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index f80da50..9a7e38c 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -257,6 +257,9 @@ static int addr4_resolve(struct sockaddr_in *src_in,
 		goto put;
 	}
 
+	if (rt->rt_uses_gateway)
+		addr->network = RDMA_NETWORK_IPv4;
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
+		addr->network = RDMA_NETWORK_IPv6;
+
 	ret = dst_fetch_ha(dst, addr, &fl6.daddr);
 put:
 	dst_release(dst);
diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 80f6cf2..c31c71b 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -48,8 +48,8 @@ struct ib_pkey_cache {
 };
 
 struct ib_gid_cache {
-	int             table_len;
-	union ib_gid    table[0];
+	int			table_len;
+	struct ib_gid_entry	table[0];
 };
 
 struct ib_update_work {
@@ -88,7 +88,7 @@ int ib_get_cached_gid(struct ib_device *device,
 	if (index < 0 || index >= cache->table_len)
 		ret = -EINVAL;
 	else
-		*gid = cache->table[index];
+		*gid = cache->table[index].gid;
 
 	read_unlock_irqrestore(&device->cache.lock, flags);
 
@@ -98,6 +98,7 @@ EXPORT_SYMBOL(ib_get_cached_gid);
 
 int ib_find_cached_gid(struct ib_device *device,
 		       union ib_gid	*gid,
+		       u8		gid_type,
 		       u8               *port_num,
 		       u16              *index)
 {
@@ -115,7 +116,8 @@ int ib_find_cached_gid(struct ib_device *device,
 	for (p = 0; p <= end_port(device) - start_port(device); ++p) {
 		cache = device->cache.gid_cache[p];
 		for (i = 0; i < cache->table_len; ++i) {
-			if (!memcmp(gid, &cache->table[i], sizeof *gid)) {
+			if (!memcmp(gid, &cache->table[i].gid, sizeof(*gid)) &&
+			    gid_type == cache->table[i].gid_type) {
 				*port_num = p + start_port(device);
 				if (index)
 					*index = i;
@@ -293,12 +295,14 @@ static void ib_cache_update(struct ib_device *device,
 	}
 
 	for (i = 0; i < gid_cache->table_len; ++i) {
-		ret = ib_query_gid(device, port, i, gid_cache->table + i);
+		ret = ib_query_gid(device, port, i, &gid_cache->table[i].gid);
 		if (ret) {
 			printk(KERN_WARNING "ib_query_gid failed (%d) for %s (index %d)\n",
 			       ret, device->name, i);
 			goto err;
 		}
+		ret = ib_query_gid_type(device, port, i,
+					&gid_cache->table[i].gid_type);
 	}
 
 	write_lock_irq(&device->cache.lock);
diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index e28a494..7e041df 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -360,7 +360,7 @@ static int cm_init_av_by_path(struct ib_sa_path_rec *path, struct cm_av *av)
 	read_lock_irqsave(&cm.device_lock, flags);
 	list_for_each_entry(cm_dev, &cm.device_list, list) {
 		if (!ib_find_cached_gid(cm_dev->ib_device, &path->sgid,
-					&p, NULL)) {
+					path->gid_type, &p, NULL)) {
 			port = cm_dev->port[p-1];
 			break;
 		}
@@ -1520,9 +1520,10 @@ static void cm_process_routed_req(struct cm_req_msg *req_msg, struct ib_wc *wc)
 
 static int cm_req_handler(struct cm_work *work)
 {
-	struct ib_cm_id *cm_id;
 	struct cm_id_private *cm_id_priv, *listen_cm_id_priv;
 	struct cm_req_msg *req_msg;
+	struct ib_cm_id *cm_id;
+	struct ib_wc *wc;
 	int ret;
 
 	req_msg = (struct cm_req_msg *)work->mad_recv_wc->recv_buf.mad;
@@ -1531,10 +1532,10 @@ static int cm_req_handler(struct cm_work *work)
 	if (IS_ERR(cm_id))
 		return PTR_ERR(cm_id);
 
+	wc = work->mad_recv_wc->wc;
 	cm_id_priv = container_of(cm_id, struct cm_id_private, id);
 	cm_id_priv->id.remote_id = req_msg->local_comm_id;
-	cm_init_av_for_response(work->port, work->mad_recv_wc->wc,
-				work->mad_recv_wc->recv_buf.grh,
+	cm_init_av_for_response(work->port, wc, work->mad_recv_wc->recv_buf.grh,
 				&cm_id_priv->av);
 	cm_id_priv->timewait_info = cm_create_timewait_info(cm_id_priv->
 							    id.local_id);
@@ -1558,11 +1559,15 @@ static int cm_req_handler(struct cm_work *work)
 	cm_id_priv->id.service_id = req_msg->service_id;
 	cm_id_priv->id.service_mask = ~cpu_to_be64(0);
 
-	cm_process_routed_req(req_msg, work->mad_recv_wc->wc);
+	cm_process_routed_req(req_msg, wc);
 	cm_format_paths_from_req(req_msg, &work->path[0], &work->path[1]);
 
 	memcpy(work->path[0].dmac, cm_id_priv->av.ah_attr.dmac, ETH_ALEN);
 	work->path[0].vlan_id = cm_id_priv->av.ah_attr.vlan_id;
+	if (wc->wc_flags & IB_WC_WITH_NETWORK_HDR_TYPE)
+		work->path[0].gid_type = ib_network_to_gid_type(
+						wc->network_hdr_type);
+
 	ret = cm_init_av_by_path(&work->path[0], &cm_id_priv->av);
 	if (ret) {
 		ib_get_cached_gid(work->port->cm_dev->ib_device,
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index d570030..1d75602 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -356,7 +356,7 @@ static int cma_acquire_dev(struct rdma_id_private *id_priv,
 	struct cma_device *cma_dev;
 	union ib_gid gid, iboe_gid;
 	int ret = -ENODEV;
-	u8 port, found_port;
+	u8 port, found_port, port_type;
 	enum rdma_link_layer dev_ll = dev_addr->dev_type == ARPHRD_INFINIBAND ?
 		IB_LINK_LAYER_INFINIBAND : IB_LINK_LAYER_ETHERNET;
 
@@ -375,13 +375,25 @@ static int cma_acquire_dev(struct rdma_id_private *id_priv,
 				     listen_id_priv->id.port_num) == dev_ll) {
 		cma_dev = listen_id_priv->cma_dev;
 		port = listen_id_priv->id.port_num;
-		if (rdma_node_get_transport(cma_dev->device->node_type) == RDMA_TRANSPORT_IB &&
-		    rdma_port_get_link_layer(cma_dev->device, port) == IB_LINK_LAYER_ETHERNET)
+		if (rdma_node_get_transport(cma_dev->device->node_type) ==
+		    RDMA_TRANSPORT_IB &&
+		    rdma_port_get_link_layer(cma_dev->device, port) ==
+		    IB_LINK_LAYER_ETHERNET) {
+			port_type = rdma_port_get_type(cma_dev->device, port);
 			ret = ib_find_cached_gid(cma_dev->device, &iboe_gid,
-						 &found_port, NULL);
+						 GID_TYPE_V1, &found_port,
+						 NULL);
+			if (ret && port_type == IB_PORT_TYPE_RoCEV2) {
+				ret = ib_find_cached_gid(cma_dev->device,
+							 &iboe_gid,
+							 GID_TYPE_RoCE_V2,
+							 &found_port, NULL);
+			}
+		}
 		else
 			ret = ib_find_cached_gid(cma_dev->device, &gid,
-						 &found_port, NULL);
+						 GID_TYPE_V1, &found_port,
+						 NULL);
 
 		if (!ret && (port  == found_port)) {
 			id_priv->id.port_num = found_port;
@@ -396,10 +408,32 @@ static int cma_acquire_dev(struct rdma_id_private *id_priv,
 				continue;
 			if (rdma_port_get_link_layer(cma_dev->device, port) == dev_ll) {
 				if (rdma_node_get_transport(cma_dev->device->node_type) == RDMA_TRANSPORT_IB &&
-				    rdma_port_get_link_layer(cma_dev->device, port) == IB_LINK_LAYER_ETHERNET)
-					ret = ib_find_cached_gid(cma_dev->device, &iboe_gid, &found_port, NULL);
+				    rdma_port_get_link_layer(cma_dev->device, port) == IB_LINK_LAYER_ETHERNET) {
+					port_type =
+						rdma_port_get_type(cma_dev->device,
+								   port);
+					ret = ib_find_cached_gid(
+								cma_dev->device,
+								&iboe_gid,
+								GID_TYPE_V1,
+								&found_port,
+								NULL);
+					if (ret && port_type ==
+					    IB_PORT_TYPE_RoCEV2)
+						ret = ib_find_cached_gid(
+								cma_dev->device,
+								&iboe_gid,
+								GID_TYPE_RoCE_V2,
+								&found_port,
+								NULL);
+				}
 				else
-					ret = ib_find_cached_gid(cma_dev->device, &gid, &found_port, NULL);
+					ret = ib_find_cached_gid(
+								cma_dev->device,
+								&gid,
+								GID_TYPE_V1,
+								&found_port,
+								NULL);
 
 				if (!ret && (port == found_port)) {
 					id_priv->id.port_num = found_port;
@@ -1924,7 +1958,11 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 	rdma_ip2gid((struct sockaddr *)&id_priv->id.route.addr.dst_addr,
 		    &route->path_rec->dgid);
 
-	route->path_rec->hop_limit = 1;
+	route->path_rec->gid_type =
+				ib_network_to_gid_type(addr->dev_addr.network);
+	if (addr->dev_addr.network != RDMA_NETWORK_IB)
+		route->path_rec->hop_limit = IPV6_DEFAULT_HOPLIMIT;
+
 	route->path_rec->reversible = 1;
 	route->path_rec->pkey = cpu_to_be16(0xffff);
 	route->path_rec->mtu_selector = IB_SA_EQ;
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 18c1ece..18f1ee9 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -599,6 +599,29 @@ int ib_query_gid(struct ib_device *device,
 EXPORT_SYMBOL(ib_query_gid);
 
 /**
+ * ib_query_gid_type - Get GID table entry type
+ * @device:Device to query
+ * @port_num:Port number to query
+ * @index:GID table index to query
+ * @gid:Returned GID Type
+ *
+ * ib_query_gid_type() fetches the specified GID table entry type.
+ */
+int ib_query_gid_type(struct ib_device *device,
+		      u8 port_num, int index, u8 *gid_type)
+{
+	/* Initialise all GIDs before RoCE V2 with this type */
+	if (gid_type)
+		*gid_type = GID_TYPE_V1;
+
+	if (device->query_gid_type)
+		return device->query_gid_type(device, port_num, index,
+					      gid_type);
+	return 0;
+}
+EXPORT_SYMBOL(ib_query_gid_type);
+
+/**
  * ib_query_pkey - Get P_Key table entry
  * @device:Device to query
  * @port_num:Port number to query
diff --git a/drivers/infiniband/core/multicast.c b/drivers/infiniband/core/multicast.c
index fa17b55..8d5237a 100644
--- a/drivers/infiniband/core/multicast.c
+++ b/drivers/infiniband/core/multicast.c
@@ -729,7 +729,8 @@ int ib_init_ah_from_mcmember(struct ib_device *device, u8 port_num,
 	u16 gid_index;
 	u8 p;
 
-	ret = ib_find_cached_gid(device, &rec->port_gid, &p, &gid_index);
+	ret = ib_find_cached_gid(device, &rec->port_gid, GID_TYPE_V1, &p,
+				 &gid_index);
 	if (ret)
 		return ret;
 
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index c38f030..2ca92ee 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -546,7 +546,8 @@ int ib_init_ah_from_path(struct ib_device *device, u8 port_num,
 		ah_attr->ah_flags = IB_AH_GRH;
 		ah_attr->grh.dgid = rec->dgid;
 
-		ret = ib_find_cached_gid(device, &rec->sgid, &port_num,
+		ret = ib_find_cached_gid(device, &rec->sgid,
+					 rec->gid_type, &port_num,
 					 &gid_index);
 		if (ret)
 			return ret;
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index f93eb8d..076986d 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -146,6 +146,15 @@ enum rdma_link_layer rdma_port_get_link_layer(struct ib_device *device, u8 port_
 }
 EXPORT_SYMBOL(rdma_port_get_link_layer);
 
+enum ib_port_type rdma_port_get_type(struct ib_device *device, u8 port_num)
+{
+	if (device->get_port_type)
+		return device->get_port_type(device, port_num);
+
+	return IB_PORT_TYPE_V1;
+}
+EXPORT_SYMBOL(rdma_port_get_type);
+
 /* Protection domains */
 
 struct ib_pd *ib_alloc_pd(struct ib_device *device)
@@ -195,13 +204,23 @@ EXPORT_SYMBOL(ib_create_ah);
 int ib_init_ah_from_wc(struct ib_device *device, u8 port_num, struct ib_wc *wc,
 		       struct ib_grh *grh, struct ib_ah_attr *ah_attr)
 {
-	u32 flow_class;
-	u16 gid_index;
 	int ret;
+	u8 sgid_type;
+	u8 hop_limit = 0xFF;
+	u16 gid_index;
+	u32 flow_class;
+	struct sockaddr_in  src_in;
+	struct sockaddr_in  dst_in;
+	__be32 src_saddr, dst_saddr;
+	union rdma_network_hdr *l3grh;
+	union ib_gid *sgid, *dgid, ipv4_sgid, ipv4_dgid;
 	int is_eth = (rdma_port_get_link_layer(device, port_num) ==
 			IB_LINK_LAYER_ETHERNET);
 
 	memset(ah_attr, 0, sizeof *ah_attr);
+
+	sgid = &grh->sgid;
+	dgid = &grh->dgid;
 	if (is_eth) {
 		if (!(wc->wc_flags & IB_WC_GRH))
 			return -EPROTOTYPE;
@@ -211,13 +230,38 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num, struct ib_wc *wc,
 			memcpy(ah_attr->dmac, wc->smac, ETH_ALEN);
 			ah_attr->vlan_id = wc->vlan_id;
 		} else {
-			ret = rdma_addr_find_dmac_by_grh(&grh->dgid, &grh->sgid,
-					ah_attr->dmac, &ah_attr->vlan_id);
+			hop_limit = grh->hop_limit;
+			if (wc->wc_flags & IB_WC_WITH_NETWORK_HDR_TYPE) {
+				if (wc->network_hdr_type == RDMA_NETWORK_IPv4) {
+					l3grh = (union rdma_network_hdr *)
+						((u8 *)grh + 20);
+					memcpy(&src_in.sin_addr.s_addr,
+					       &l3grh->roce4grh.saddr, 4);
+					memcpy(&dst_in.sin_addr.s_addr,
+					       &l3grh->roce4grh.daddr, 4);
+					src_saddr = src_in.sin_addr.s_addr;
+					dst_saddr = dst_in.sin_addr.s_addr;
+					ipv6_addr_set_v4mapped(src_saddr,
+							(struct in6_addr *)
+							&ipv4_sgid);
+					ipv6_addr_set_v4mapped(dst_saddr,
+							(struct in6_addr *)
+							&ipv4_dgid);
+					dgid = &ipv4_dgid;
+					sgid = &ipv4_sgid;
+					hop_limit = l3grh->roce4grh.ttl;
+				}
+				if (wc->network_hdr_type != RDMA_NETWORK_IB)
+					sgid_type = GID_TYPE_RoCE_V2;
+			}
+			ret = rdma_addr_find_dmac_by_grh(dgid, sgid,
+							 ah_attr->dmac,
+							 &ah_attr->vlan_id);
 			if (ret)
 				return ret;
 		}
 	} else {
-		ah_attr->vlan_id = 0xffff;
+			ah_attr->vlan_id = 0xffff;
 	}
 
 	ah_attr->dlid = wc->slid;
@@ -227,18 +271,18 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num, struct ib_wc *wc,
 
 	if (wc->wc_flags & IB_WC_GRH) {
 		ah_attr->ah_flags = IB_AH_GRH;
-		ah_attr->grh.dgid = grh->sgid;
+		ah_attr->grh.dgid = *sgid;
 
-		ret = ib_find_cached_gid(device, &grh->dgid, &port_num,
-					 &gid_index);
+		ret = ib_find_cached_gid(device, dgid, sgid_type,
+					 &port_num, &gid_index);
 		if (ret)
 			return ret;
 
 		ah_attr->grh.sgid_index = (u8) gid_index;
 		flow_class = be32_to_cpu(grh->version_tclass_flow);
 		ah_attr->grh.flow_label = flow_class & 0xFFFFF;
-		ah_attr->grh.hop_limit = 0xFF;
 		ah_attr->grh.traffic_class = (flow_class >> 20) & 0xFF;
+		ah_attr->grh.hop_limit = hop_limit;
 	}
 	return 0;
 }
@@ -869,6 +913,7 @@ int ib_resolve_eth_l2_attrs(struct ib_qp *qp,
 {
 	int           ret = 0;
 	union ib_gid  sgid;
+	u8	sgid_type;
 
 	if ((*qp_attr_mask & IB_QP_AV)  &&
 	    (rdma_port_get_link_layer(qp->device, qp_attr->ah_attr.port_num) == IB_LINK_LAYER_ETHERNET)) {
@@ -876,6 +921,11 @@ int ib_resolve_eth_l2_attrs(struct ib_qp *qp,
 				   qp_attr->ah_attr.grh.sgid_index, &sgid);
 		if (ret)
 			goto out;
+		ret = ib_query_gid_type(qp->device, qp_attr->ah_attr.port_num,
+					qp_attr->ah_attr.grh.sgid_index,
+					&sgid_type);
+		if (sgid_type == GID_TYPE_RoCE_V2)
+			qp_attr->ah_attr.grh.hop_limit = IPV6_DEFAULT_HOPLIMIT;
 		if (rdma_link_local_addr((struct in6_addr *)qp_attr->ah_attr.grh.dgid.raw)) {
 			rdma_get_ll_mac((struct in6_addr *)qp_attr->ah_attr.grh.dgid.raw, qp_attr->ah_attr.dmac);
 			rdma_get_ll_mac((struct in6_addr *)sgid.raw, qp_attr->smac);
diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index ce55906..39d3ceb 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -71,6 +71,7 @@ struct rdma_dev_addr {
 	unsigned short dev_type;
 	int bound_dev_if;
 	enum rdma_transport_type transport;
+	enum rdma_network_type network;
 };
 
 /**
diff --git a/include/rdma/ib_cache.h b/include/rdma/ib_cache.h
index ad9a3c2..d1ca910 100644
--- a/include/rdma/ib_cache.h
+++ b/include/rdma/ib_cache.h
@@ -57,6 +57,7 @@ int ib_get_cached_gid(struct ib_device    *device,
  *   a specified GID value occurs.
  * @device: The device to query.
  * @gid: The GID value to search for.
+ * @gid_type: The GID type to search for.
  * @port_num: The port number of the device where the GID value was found.
  * @index: The index into the cached GID table where the GID was found.  This
  *   parameter may be NULL.
@@ -66,6 +67,7 @@ int ib_get_cached_gid(struct ib_device    *device,
  */
 int ib_find_cached_gid(struct ib_device *device,
 		       union ib_gid	*gid,
+		       u8		gid_type,
 		       u8               *port_num,
 		       u16              *index);
 
diff --git a/include/rdma/ib_sa.h b/include/rdma/ib_sa.h
index 7e071a6..b4f04dc 100644
--- a/include/rdma/ib_sa.h
+++ b/include/rdma/ib_sa.h
@@ -157,6 +157,7 @@ struct ib_sa_path_rec {
 	u8           smac[ETH_ALEN];
 	u8           dmac[ETH_ALEN];
 	u16	     vlan_id;
+	u8	     gid_type;
 };
 
 #define IB_SA_MCMEMBER_REC_MGID				IB_SA_COMP_MASK( 0)
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 0d74f1d..c38990e 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -49,6 +49,10 @@
 #include <linux/scatterlist.h>
 #include <linux/workqueue.h>
 #include <uapi/linux/if_ether.h>
+#include <uapi/linux/ip.h>
+#include <net/ipv6.h>
+#include <net/if_inet6.h>
+#include <net/ip.h>
 
 #include <linux/atomic.h>
 #include <linux/mmu_notifier.h>
@@ -56,6 +60,11 @@
 
 extern struct workqueue_struct *ib_wq;
 
+enum ib_gid_type {
+	GID_TYPE_V1	= 1,	/* All GIDs before RoCE V2 */
+	GID_TYPE_RoCE_V2
+};
+
 union ib_gid {
 	u8	raw[16];
 	struct {
@@ -64,6 +73,11 @@ union ib_gid {
 	} global;
 };
 
+struct ib_gid_entry {
+	union ib_gid	gid;
+	u8		gid_type;
+};
+
 enum rdma_node_type {
 	/* IB values map to NodeInfo:NodeType. */
 	RDMA_NODE_IB_CA 	= 1,
@@ -84,6 +98,51 @@ enum rdma_transport_type {
 __attribute_const__ enum rdma_transport_type
 rdma_node_get_transport(enum rdma_node_type node_type);
 
+enum rdma_network_type {
+	RDMA_NETWORK_IB,
+	RDMA_NETWORK_IPv4,
+	RDMA_NETWORK_IPv6
+};
+
+static inline u8 ib_network_to_gid_type(enum rdma_network_type network_type)
+{
+	if (network_type == RDMA_NETWORK_IPv4 ||
+	    network_type == RDMA_NETWORK_IPv6)
+		return GID_TYPE_RoCE_V2;
+
+	return GID_TYPE_V1;
+}
+
+static inline u8 ib_gid_to_network_type(enum ib_gid_type gid_type,
+					union ib_gid *gid)
+{
+	if (gid_type == GID_TYPE_V1)
+		return RDMA_NETWORK_IB;
+
+	if (ipv6_addr_v4mapped((struct in6_addr *)gid))
+		return RDMA_NETWORK_IPv4;
+	else
+		return RDMA_NETWORK_IPv6;
+}
+
+static inline bool gid_entry_equal(struct ib_gid_entry *gid1,
+				   struct ib_gid_entry *gid2)
+{
+	return (!memcmp(&gid1->gid, &gid2->gid, sizeof(union ib_gid)) &&
+		gid1->gid_type == gid2->gid_type);
+}
+
+static inline bool is_zero_gid_value(union ib_gid *gid)
+{
+	const unsigned long *ul = (const unsigned long *)gid->raw;
+#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG == 64
+
+	return (ul[0] | ul[1]) == 0UL;
+#else
+	return (ul[0] | ul[1] | ul[2] | ul[3]) == 0;
+#endif
+}
+
 enum rdma_link_layer {
 	IB_LINK_LAYER_UNSPECIFIED,
 	IB_LINK_LAYER_INFINIBAND,
@@ -241,6 +300,11 @@ enum ib_port_state {
 	IB_PORT_ACTIVE_DEFER	= 5
 };
 
+enum ib_port_type {
+	IB_PORT_TYPE_V1		= 0,
+	IB_PORT_TYPE_RoCEV2	= 1
+};
+
 enum ib_port_cap_flags {
 	IB_PORT_SM				= 1 <<  1,
 	IB_PORT_NOTICE_SUP			= 1 <<  2,
@@ -265,7 +329,8 @@ enum ib_port_cap_flags {
 	IB_PORT_BOOT_MGMT_SUP			= 1 << 23,
 	IB_PORT_LINK_LATENCY_SUP		= 1 << 24,
 	IB_PORT_CLIENT_REG_SUP			= 1 << 25,
-	IB_PORT_IP_BASED_GIDS			= 1 << 26
+	IB_PORT_IP_BASED_GIDS			= 1 << 26,
+	IB_PORT_RoCEV2_BASED_GIDS		= 1 << 27
 };
 
 enum ib_port_width {
@@ -453,6 +518,11 @@ struct ib_grh {
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
@@ -690,6 +760,7 @@ enum ib_wc_flags {
 	IB_WC_IP_CSUM_OK	= (1<<3),
 	IB_WC_WITH_SMAC		= (1<<4),
 	IB_WC_WITH_VLAN		= (1<<5),
+	IB_WC_WITH_NETWORK_HDR_TYPE	= (1<<6)
 };
 
 struct ib_wc {
@@ -712,6 +783,7 @@ struct ib_wc {
 	u8			port_num;	/* valid only for DR SMPs on switches */
 	u8			smac[ETH_ALEN];
 	u16			vlan_id;
+	u8			network_hdr_type;
 };
 
 enum ib_cq_notify_flags {
@@ -1503,9 +1575,14 @@ struct ib_device {
 						 struct ib_port_attr *port_attr);
 	enum rdma_link_layer	   (*get_link_layer)(struct ib_device *device,
 						     u8 port_num);
+	enum ib_port_type	   (*get_port_type)(struct ib_device *device,
+						    u8 port_num);
 	int		           (*query_gid)(struct ib_device *device,
 						u8 port_num, int index,
 						union ib_gid *gid);
+	int		           (*query_gid_type)(struct ib_device *device,
+						     u8 port_num, int index,
+						     u8 *gid_type);
 	int		           (*query_pkey)(struct ib_device *device,
 						 u8 port_num, u16 index, u16 *pkey);
 	int		           (*modify_device)(struct ib_device *device,
@@ -1746,9 +1823,15 @@ int ib_query_port(struct ib_device *device,
 enum rdma_link_layer rdma_port_get_link_layer(struct ib_device *device,
 					       u8 port_num);
 
+enum ib_port_type rdma_port_get_type(struct ib_device *device,
+				     u8 port_num);
+
 int ib_query_gid(struct ib_device *device,
 		 u8 port_num, int index, union ib_gid *gid);
 
+int ib_query_gid_type(struct ib_device *device,
+		      u8 port_num, int index, u8 *gid_type);
+
 int ib_query_pkey(struct ib_device *device,
 		  u8 port_num, u16 index, u16 *pkey);
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
