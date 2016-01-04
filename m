From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 for-next 2/2] IB/core: Use hop-limit from IP stack for RoCE
Date: Mon,  4 Jan 2016 10:49:54 +0200
Message-ID: <1451897394-24525-3-git-send-email-matanb@mellanox.com>
References: <1451897394-24525-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1451897394-24525-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Previously, IPV6_DEFAULT_HOPLIMIT was used as the hop limit value for
RoCE. Fixing that by taking ip4_dst_hoplimit and ip6_dst_hoplimit as
hop limit values.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/addr.c           |  9 ++++++++-
 drivers/infiniband/core/cm.c             |  1 +
 drivers/infiniband/core/cma.c            | 12 +++++-------
 drivers/infiniband/core/verbs.c          | 16 +++++++---------
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c |  3 ++-
 include/rdma/ib_addr.h                   |  4 +++-
 6 files changed, 26 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index ce3c68e..f924d90 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -252,6 +252,8 @@ static int addr4_resolve(struct sockaddr_in *src_in,
 	if (rt->rt_uses_gateway)
 		addr->network = RDMA_NETWORK_IPV4;
 
+	addr->hoplimit = ip4_dst_hoplimit(&rt->dst);
+
 	*prt = rt;
 	return 0;
 out:
@@ -295,6 +297,8 @@ static int addr6_resolve(struct sockaddr_in6 *src_in,
 	if (rt->rt6i_flags & RTF_GATEWAY)
 		addr->network = RDMA_NETWORK_IPV6;
 
+	addr->hoplimit = ip6_dst_hoplimit(dst);
+
 	*pdst = dst;
 	return 0;
 put:
@@ -542,7 +546,8 @@ static void resolve_cb(int status, struct sockaddr *src_addr,
 
 int rdma_addr_find_l2_eth_by_grh(const union ib_gid *sgid,
 				 const union ib_gid *dgid,
-				 u8 *dmac, u16 *vlan_id, int *if_index)
+				 u8 *dmac, u16 *vlan_id, int *if_index,
+				 int *hoplimit)
 {
 	int ret = 0;
 	struct rdma_dev_addr dev_addr;
@@ -581,6 +586,8 @@ int rdma_addr_find_l2_eth_by_grh(const union ib_gid *sgid,
 		*if_index = dev_addr.bound_dev_if;
 	if (vlan_id)
 		*vlan_id = rdma_vlan_dev_vlan_id(dev);
+	if (hoplimit)
+		*hoplimit = dev_addr.hoplimit;
 	dev_put(dev);
 	return ret;
 }
diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index e3a95d1..cd3d345 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1641,6 +1641,7 @@ static int cm_req_handler(struct cm_work *work)
 	cm_format_paths_from_req(req_msg, &work->path[0], &work->path[1]);
 
 	memcpy(work->path[0].dmac, cm_id_priv->av.ah_attr.dmac, ETH_ALEN);
+	work->path[0].hop_limit = cm_id_priv->av.ah_attr.grh.hop_limit;
 	ret = ib_get_cached_gid(work->port->cm_dev->ib_device,
 				work->port->port_num,
 				cm_id_priv->av.ah_attr.grh.sgid_index,
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 559ee3d..66983da 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2424,7 +2424,6 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 {
 	struct rdma_route *route = &id_priv->id.route;
 	struct rdma_addr *addr = &route->addr;
-	enum ib_gid_type network_gid_type;
 	struct cma_work *work;
 	int ret;
 	struct net_device *ndev = NULL;
@@ -2478,14 +2477,13 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 		    &route->path_rec->dgid);
 
 	/* Use the hint from IP Stack to select GID Type */
-	network_gid_type = ib_network_to_gid_type(addr->dev_addr.network);
-	if (addr->dev_addr.network != RDMA_NETWORK_IB) {
-		route->path_rec->gid_type = network_gid_type;
+	if (route->path_rec->gid_type < ib_network_to_gid_type(addr->dev_addr.network))
+		route->path_rec->gid_type = ib_network_to_gid_type(addr->dev_addr.network);
+	if (((struct sockaddr *)&id_priv->id.route.addr.dst_addr)->sa_family != AF_IB)
 		/* TODO: get the hoplimit from the inet/inet6 device */
-		route->path_rec->hop_limit = IPV6_DEFAULT_HOPLIMIT;
-	} else {
+		route->path_rec->hop_limit = addr->dev_addr.hoplimit;
+	else
 		route->path_rec->hop_limit = 1;
-	}
 	route->path_rec->reversible = 1;
 	route->path_rec->pkey = cpu_to_be16(0xffff);
 	route->path_rec->mtu_selector = IB_SA_EQ;
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 66eb498..b1998bc 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -434,6 +434,7 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num,
 	int ret;
 	enum rdma_network_type net_type = RDMA_NETWORK_IB;
 	enum ib_gid_type gid_type = IB_GID_TYPE_IB;
+	int hoplimit = 0xff;
 	union ib_gid dgid;
 	union ib_gid sgid;
 
@@ -471,7 +472,7 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num,
 						   ah_attr->dmac,
 						   wc->wc_flags & IB_WC_WITH_VLAN ?
 						   NULL : &vlan_id,
-						   &if_index);
+						   &if_index, &hoplimit);
 		if (ret) {
 			dev_put(idev);
 			return ret;
@@ -520,7 +521,7 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num,
 		ah_attr->grh.sgid_index = (u8) gid_index;
 		flow_class = be32_to_cpu(grh->version_tclass_flow);
 		ah_attr->grh.flow_label = flow_class & 0xFFFFF;
-		ah_attr->grh.hop_limit = 0xFF;
+		ah_attr->grh.hop_limit = hoplimit;
 		ah_attr->grh.traffic_class = (flow_class >> 20) & 0xFF;
 	}
 	return 0;
@@ -1138,6 +1139,7 @@ int ib_resolve_eth_dmac(struct ib_qp *qp,
 			union ib_gid		sgid;
 			struct ib_gid_attr	sgid_attr;
 			int			ifindex;
+			int			hop_limit;
 
 			ret = ib_query_gid(qp->device,
 					   qp_attr->ah_attr.port_num,
@@ -1149,21 +1151,17 @@ int ib_resolve_eth_dmac(struct ib_qp *qp,
 					ret = -ENXIO;
 				goto out;
 			}
-			if (sgid_attr.gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP)
-				/* TODO: get the hoplimit from the inet/inet6
-				 * device
-				 */
-				qp_attr->ah_attr.grh.hop_limit =
-							IPV6_DEFAULT_HOPLIMIT;
 
 			ifindex = sgid_attr.ndev->ifindex;
 
 			ret = rdma_addr_find_l2_eth_by_grh(&sgid,
 							   &qp_attr->ah_attr.grh.dgid,
 							   qp_attr->ah_attr.dmac,
-							   NULL, &ifindex);
+							   NULL, &ifindex, &hop_limit);
 
 			dev_put(sgid_attr.ndev);
+
+			qp_attr->ah_attr.grh.hop_limit = hop_limit;
 		}
 	}
 out:
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
index 850e0d1..3790771 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
@@ -154,7 +154,8 @@ struct ib_ah *ocrdma_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr)
 	    (!rdma_link_local_addr((struct in6_addr *)attr->grh.dgid.raw))) {
 		status = rdma_addr_find_l2_eth_by_grh(&sgid, &attr->grh.dgid,
 						      attr->dmac, &vlan_tag,
-						      &sgid_attr.ndev->ifindex);
+						      &sgid_attr.ndev->ifindex,
+						      NULL);
 		if (status) {
 			pr_err("%s(): Failed to resolve dmac from gid." 
 				"status = %d\n", __func__, status);
diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index 73fd088..c34c900 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -84,6 +84,7 @@ struct rdma_dev_addr {
 	enum rdma_transport_type transport;
 	struct net *net;
 	enum rdma_network_type network;
+	int hoplimit;
 };
 
 /**
@@ -132,7 +133,8 @@ int rdma_addr_size(struct sockaddr *addr);
 int rdma_addr_find_smac_by_sgid(union ib_gid *sgid, u8 *smac, u16 *vlan_id);
 int rdma_addr_find_l2_eth_by_grh(const union ib_gid *sgid,
 				 const union ib_gid *dgid,
-				 u8 *smac, u16 *vlan_id, int *if_index);
+				 u8 *smac, u16 *vlan_id, int *if_index,
+				 int *hoplimit);
 
 static inline u16 ib_addr_get_pkey(struct rdma_dev_addr *dev_addr)
 {
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
