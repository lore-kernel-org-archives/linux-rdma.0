From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/Core: Changes to the IB Core infrastructure for RoCEv2 support
Date: Thu, 27 Nov 2014 06:26:45 +0530
Message-ID: <de700fb7-a033-44e6-afee-46da3bf6d42d@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Padmanabh Ratnakar <padmanabh.ratnakar-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 Changes include
 > Introduced a new 'RDMA_NETWORK_TYPE' in the IB Core
 > Adding a new 'network_hdr_type' in data structures like 'global_route',
 'work_completion' and 'path_record' structs
 > Determining if IPvX Address is routeable and set hop_limit in IP HDR accordingly
 > Repurpose rdma_addr_find_dmac_by_grh to get network hdr type

Signed-off-by: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Padmanabh Ratnakar <padmanabh.ratnakar-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
PS: Not yet added UDP hdr addition to this. This sets the basic foundation for the
IP routeability. UDP source port /hdr filling should be relatively trivial and
will follow this patch based on how this design finally shapes up post review.

 drivers/infiniband/core/addr.c     |   13 +++++++++-
 drivers/infiniband/core/cm.c       |   15 +++++++----
 drivers/infiniband/core/cma.c      |    4 ++-
 drivers/infiniband/core/sa_query.c |    1 +
 drivers/infiniband/core/verbs.c    |   47 ++++++++++++++++++++++++++++++-----
 include/rdma/ib_addr.h             |    3 +-
 include/rdma/ib_sa.h               |    1 +
 include/rdma/ib_verbs.h            |   15 +++++++++++
 8 files changed, 83 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index 8172d37..77262e6 100644
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
@@ -458,7 +466,7 @@ static void resolve_cb(int status, struct sockaddr *src_addr,
 }
 
 int rdma_addr_find_dmac_by_grh(union ib_gid *sgid, union ib_gid *dgid, u8 *dmac,
-			       u16 *vlan_id)
+			       u16 *vlan_id, u8 *network_hdr_type)
 {
 	int ret = 0;
 	struct rdma_dev_addr dev_addr;
@@ -497,6 +505,9 @@ int rdma_addr_find_dmac_by_grh(union ib_gid *sgid, union ib_gid *dgid, u8 *dmac,
 		return -ENODEV;
 	if (vlan_id)
 		*vlan_id = rdma_vlan_dev_vlan_id(dev);
+	if (network_hdr_type)
+		*network_hdr_type = dev_addr.network;
+
 	dev_put(dev);
 	return ret;
 }
diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index e28a494..01986e8 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1233,8 +1233,8 @@ static inline int cm_is_active_peer(__be64 local_ca_guid, __be64 remote_ca_guid,
 }
 
 static void cm_format_paths_from_req(struct cm_req_msg *req_msg,
-					    struct ib_sa_path_rec *primary_path,
-					    struct ib_sa_path_rec *alt_path)
+				     struct ib_sa_path_rec *primary_path,
+				     struct ib_sa_path_rec *alt_path)
 {
 	memset(primary_path, 0, sizeof *primary_path);
 	primary_path->dgid = req_msg->primary_local_gid;
@@ -1520,9 +1520,10 @@ static void cm_process_routed_req(struct cm_req_msg *req_msg, struct ib_wc *wc)
 
 static int cm_req_handler(struct cm_work *work)
 {
-	struct ib_cm_id *cm_id;
 	struct cm_id_private *cm_id_priv, *listen_cm_id_priv;
 	struct cm_req_msg *req_msg;
+	struct ib_wc *wc;
+	struct ib_cm_id *cm_id;
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
@@ -1558,11 +1559,13 @@ static int cm_req_handler(struct cm_work *work)
 	cm_id_priv->id.service_id = req_msg->service_id;
 	cm_id_priv->id.service_mask = ~cpu_to_be64(0);
 
-	cm_process_routed_req(req_msg, work->mad_recv_wc->wc);
+	cm_process_routed_req(req_msg, wc);
 	cm_format_paths_from_req(req_msg, &work->path[0], &work->path[1]);
 
 	memcpy(work->path[0].dmac, cm_id_priv->av.ah_attr.dmac, ETH_ALEN);
 	work->path[0].vlan_id = cm_id_priv->av.ah_attr.vlan_id;
+	work->path[0].network_hdr_type = wc->network_hdr_type;
+
 	ret = cm_init_av_by_path(&work->path[0], &cm_id_priv->av);
 	if (ret) {
 		ib_get_cached_gid(work->port->cm_dev->ib_device,
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index d570030..285794a 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1924,7 +1924,9 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 	rdma_ip2gid((struct sockaddr *)&id_priv->id.route.addr.dst_addr,
 		    &route->path_rec->dgid);
 
-	route->path_rec->hop_limit = 1;
+	route->path_rec->network_hdr_type = addr->dev_addr.network;
+	if (route->path_rec->network_hdr_type != RDMA_NETWORK_IB)
+		route->path_rec->hop_limit = IPV6_DEFAULT_HOPLIMIT;
 	route->path_rec->reversible = 1;
 	route->path_rec->pkey = cpu_to_be16(0xffff);
 	route->path_rec->mtu_selector = IB_SA_EQ;
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index c38f030..2377577 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -555,6 +555,7 @@ int ib_init_ah_from_path(struct ib_device *device, u8 port_num,
 		ah_attr->grh.flow_label    = be32_to_cpu(rec->flow_label);
 		ah_attr->grh.hop_limit     = rec->hop_limit;
 		ah_attr->grh.traffic_class = rec->traffic_class;
+		ah_attr->grh.network_hdr_type = rec->network_hdr_type;
 	}
 	if (force_grh) {
 		memcpy(ah_attr->dmac, rec->dmac, ETH_ALEN);
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index c2b89cc..68d7d23 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -195,9 +195,14 @@ EXPORT_SYMBOL(ib_create_ah);
 int ib_init_ah_from_wc(struct ib_device *device, u8 port_num, struct ib_wc *wc,
 		       struct ib_grh *grh, struct ib_ah_attr *ah_attr)
 {
-	u32 flow_class;
-	u16 gid_index;
 	int ret;
+	u16 gid_index;
+	u32 flow_class;
+	u8 *network_hdr_type;
+	struct sockaddr_in  src_in;
+	struct sockaddr_in  dst_in;
+	union rdma_network_hdr *l3grh;
+	union ib_gid *sgid, *dgid, ipv4_sgid, ipv4_dgid;
 	int is_eth = (rdma_port_get_link_layer(device, port_num) ==
 			IB_LINK_LAYER_ETHERNET);
 
@@ -206,18 +211,42 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num, struct ib_wc *wc,
 		if (!(wc->wc_flags & IB_WC_GRH))
 			return -EPROTOTYPE;
 
+		sgid = &grh->sgid;
+		dgid = &grh->dgid;
+
 		if (wc->wc_flags & IB_WC_WITH_SMAC &&
 		    wc->wc_flags & IB_WC_WITH_VLAN) {
 			memcpy(ah_attr->dmac, wc->smac, ETH_ALEN);
 			ah_attr->vlan_id = wc->vlan_id;
 		} else {
-			ret = rdma_addr_find_dmac_by_grh(&grh->dgid, &grh->sgid,
-					ah_attr->dmac, &ah_attr->vlan_id);
+			ah_attr->grh.hop_limit = grh->hop_limit;
+			if (wc->wc_flags & IB_WC_WITH_L3_TYPE &&
+			    wc->network_hdr_type == RDMA_NETWORK_IPv4) {
+				l3grh = (union rdma_network_hdr *)grh;
+				memcpy(&src_in.sin_addr.s_addr,
+				       &l3grh->roce4grh.saddr, 4);
+				memcpy(&dst_in.sin_addr.s_addr,
+				       &l3grh->roce4grh.daddr, 4);
+				ipv6_addr_set_v4mapped(src_in.sin_addr.s_addr,
+						       (struct in6_addr *)
+						       &ipv4_sgid);
+				ipv6_addr_set_v4mapped(dst_in.sin_addr.s_addr,
+						       (struct in6_addr *)
+						       &ipv4_dgid);
+				dgid = &ipv4_dgid;
+				sgid = &ipv4_sgid;
+				ah_attr->grh.hop_limit = l3grh->roce4grh.ttl;
+			}
+			network_hdr_type = &ah_attr->grh.network_hdr_type;
+			ret = rdma_addr_find_dmac_by_grh(dgid, sgid,
+							 ah_attr->dmac,
+							 &ah_attr->vlan_id,
+							 network_hdr_type);
 			if (ret)
 				return ret;
 		}
 	} else {
-		ah_attr->vlan_id = 0xffff;
+			ah_attr->vlan_id = 0xffff;
 	}
 
 	ah_attr->dlid = wc->slid;
@@ -237,7 +266,6 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num, struct ib_wc *wc,
 		ah_attr->grh.sgid_index = (u8) gid_index;
 		flow_class = be32_to_cpu(grh->version_tclass_flow);
 		ah_attr->grh.flow_label = flow_class & 0xFFFFF;
-		ah_attr->grh.hop_limit = 0xFF;
 		ah_attr->grh.traffic_class = (flow_class >> 20) & 0xFF;
 	}
 	return 0;
@@ -869,6 +897,7 @@ int ib_resolve_eth_l2_attrs(struct ib_qp *qp,
 {
 	int           ret = 0;
 	union ib_gid  sgid;
+	u8 *network_hdr_type;
 
 	if ((*qp_attr_mask & IB_QP_AV)  &&
 	    (rdma_port_get_link_layer(qp->device, qp_attr->ah_attr.port_num) == IB_LINK_LAYER_ETHERNET)) {
@@ -881,8 +910,12 @@ int ib_resolve_eth_l2_attrs(struct ib_qp *qp,
 			rdma_get_ll_mac((struct in6_addr *)sgid.raw, qp_attr->smac);
 			qp_attr->vlan_id = rdma_get_vlan_id(&sgid);
 		} else {
+			network_hdr_type =
+					&qp_attr->ah_attr.grh.network_hdr_type;
 			ret = rdma_addr_find_dmac_by_grh(&sgid, &qp_attr->ah_attr.grh.dgid,
-					qp_attr->ah_attr.dmac, &qp_attr->vlan_id);
+							 qp_attr->ah_attr.dmac,
+							 &qp_attr->vlan_id,
+							 network_hdr_type);
 			if (ret)
 				goto out;
 			ret = rdma_addr_find_smac_by_sgid(&sgid, qp_attr->smac, NULL);
diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index ce55906..242c0a9 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -71,6 +71,7 @@ struct rdma_dev_addr {
 	unsigned short dev_type;
 	int bound_dev_if;
 	enum rdma_transport_type transport;
+	enum rdma_network_type network;
 };
 
 /**
@@ -112,7 +113,7 @@ int rdma_addr_size(struct sockaddr *addr);
 
 int rdma_addr_find_smac_by_sgid(union ib_gid *sgid, u8 *smac, u16 *vlan_id);
 int rdma_addr_find_dmac_by_grh(union ib_gid *sgid, union ib_gid *dgid, u8 *smac,
-			       u16 *vlan_id);
+			       u16 *vlan_id, u8 *network_hdr_type);
 
 static inline u16 ib_addr_get_pkey(struct rdma_dev_addr *dev_addr)
 {
diff --git a/include/rdma/ib_sa.h b/include/rdma/ib_sa.h
index 7e071a6..3946a67 100644
--- a/include/rdma/ib_sa.h
+++ b/include/rdma/ib_sa.h
@@ -157,6 +157,7 @@ struct ib_sa_path_rec {
 	u8           smac[ETH_ALEN];
 	u8           dmac[ETH_ALEN];
 	u16	     vlan_id;
+	u8	     network_hdr_type;
 };
 
 #define IB_SA_MCMEMBER_REC_MGID				IB_SA_COMP_MASK( 0)
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 470a011..3f5dc91 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -49,6 +49,7 @@
 #include <linux/scatterlist.h>
 #include <linux/workqueue.h>
 #include <uapi/linux/if_ether.h>
+#include <uapi/linux/ip.h>
 
 #include <linux/atomic.h>
 #include <asm/uaccess.h>
@@ -83,6 +84,12 @@ enum rdma_transport_type {
 __attribute_const__ enum rdma_transport_type
 rdma_node_get_transport(enum rdma_node_type node_type);
 
+enum rdma_network_type {
+	RDMA_NETWORK_IB,
+	RDMA_NETWORK_IPv4,
+	RDMA_NETWORK_IPv6
+};
+
 enum rdma_link_layer {
 	IB_LINK_LAYER_UNSPECIFIED,
 	IB_LINK_LAYER_INFINIBAND,
@@ -418,6 +425,7 @@ struct ib_global_route {
 	u8		sgid_index;
 	u8		hop_limit;
 	u8		traffic_class;
+	u8		network_hdr_type;
 };
 
 struct ib_grh {
@@ -429,6 +437,11 @@ struct ib_grh {
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
@@ -666,6 +679,7 @@ enum ib_wc_flags {
 	IB_WC_IP_CSUM_OK	= (1<<3),
 	IB_WC_WITH_SMAC		= (1<<4),
 	IB_WC_WITH_VLAN		= (1<<5),
+	IB_WC_WITH_L3_TYPE	= (1<<6)
 };
 
 struct ib_wc {
@@ -688,6 +702,7 @@ struct ib_wc {
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
