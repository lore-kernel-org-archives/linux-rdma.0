From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 2/6] RDMA/cma: Provide function to set RoCE path record L2 parameters
Date: Mon,  8 Jan 2018 17:04:44 +0200
Message-ID: <20180108150448.29069-3-leon@kernel.org>
References: <20180108150448.29069-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180108150448.29069-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Introduce helper function to set path record L2 fields for RoCE.
This includes setting GID type, destination mac address and netdev
ifindex.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 88 ++++++++++++++++++++++++++-----------------
 1 file changed, 53 insertions(+), 35 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 282269f88f89..f1321baf12d8 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2466,6 +2466,58 @@ static int cma_resolve_ib_route(struct rdma_id_private *id_priv, int timeout_ms)
 	return ret;
 }
 
+static enum ib_gid_type cma_route_gid_type(enum rdma_network_type network_type,
+					   unsigned long supported_gids,
+					   enum ib_gid_type default_gid)
+{
+	if ((network_type == RDMA_NETWORK_IPV4 ||
+	     network_type == RDMA_NETWORK_IPV6) &&
+	    test_bit(IB_GID_TYPE_ROCE_UDP_ENCAP, &supported_gids))
+		return IB_GID_TYPE_ROCE_UDP_ENCAP;
+
+	return default_gid;
+}
+
+/*
+ * cma_iboe_set_path_rec_l2_fields() is helper function which sets
+ * path record type based on GID type.
+ * It also sets up other L2 fields which includes destination mac address
+ * netdev ifindex, of the path record.
+ * It returns the netdev of the bound interface for this path record entry.
+ */
+static struct net_device *
+cma_iboe_set_path_rec_l2_fields(struct rdma_id_private *id_priv)
+{
+	struct rdma_route *route = &id_priv->id.route;
+	enum ib_gid_type gid_type = IB_GID_TYPE_ROCE;
+	struct rdma_addr *addr = &route->addr;
+	unsigned long supported_gids;
+	struct net_device *ndev;
+
+	if (!addr->dev_addr.bound_dev_if)
+		return NULL;
+
+	ndev = dev_get_by_index(addr->dev_addr.net,
+				addr->dev_addr.bound_dev_if);
+	if (!ndev)
+		return NULL;
+
+	supported_gids = roce_gid_type_mask_support(id_priv->id.device,
+						    id_priv->id.port_num);
+	gid_type = cma_route_gid_type(addr->dev_addr.network,
+				      supported_gids,
+				      id_priv->gid_type);
+	/* Use the hint from IP Stack to select GID Type */
+	if (gid_type < ib_network_to_gid_type(addr->dev_addr.network))
+		gid_type = ib_network_to_gid_type(addr->dev_addr.network);
+	route->path_rec->rec_type = sa_conv_gid_to_pathrec_type(gid_type);
+
+	sa_path_set_ndev(route->path_rec, addr->dev_addr.net);
+	sa_path_set_ifindex(route->path_rec, ndev->ifindex);
+	sa_path_set_dmac(route->path_rec, addr->dev_addr.dst_dev_addr);
+	return ndev;
+}
+
 int rdma_set_ib_paths(struct rdma_cm_id *id,
 		      struct sa_path_rec *path_rec, int num_paths)
 {
@@ -2523,18 +2575,6 @@ static int iboe_tos_to_sl(struct net_device *ndev, int tos)
 	return 0;
 }
 
-static enum ib_gid_type cma_route_gid_type(enum rdma_network_type network_type,
-					   unsigned long supported_gids,
-					   enum ib_gid_type default_gid)
-{
-	if ((network_type == RDMA_NETWORK_IPV4 ||
-	     network_type == RDMA_NETWORK_IPV6) &&
-	    test_bit(IB_GID_TYPE_ROCE_UDP_ENCAP, &supported_gids))
-		return IB_GID_TYPE_ROCE_UDP_ENCAP;
-
-	return default_gid;
-}
-
 static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 {
 	struct rdma_route *route = &id_priv->id.route;
@@ -2542,8 +2582,6 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 	struct cma_work *work;
 	int ret;
 	struct net_device *ndev;
-	enum ib_gid_type gid_type = IB_GID_TYPE_ROCE;
-	unsigned long supported_gids;
 
 	u8 default_roce_tos = id_priv->cma_dev->default_roce_tos[id_priv->id.port_num -
 					rdma_start_port(id_priv->cma_dev->device)];
@@ -2562,32 +2600,12 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 
 	route->num_paths = 1;
 
-	if (!addr->dev_addr.bound_dev_if) {
-		ret = -ENODEV;
-		goto err2;
-	}
-
-	ndev = dev_get_by_index(addr->dev_addr.net,
-				addr->dev_addr.bound_dev_if);
+	ndev = cma_iboe_set_path_rec_l2_fields(id_priv);
 	if (!ndev) {
 		ret = -ENODEV;
 		goto err2;
 	}
 
-	supported_gids = roce_gid_type_mask_support(id_priv->id.device,
-						    id_priv->id.port_num);
-	gid_type = cma_route_gid_type(addr->dev_addr.network,
-				      supported_gids,
-				      id_priv->gid_type);
-	/* Use the hint from IP Stack to select GID Type */
-	if (gid_type < ib_network_to_gid_type(addr->dev_addr.network))
-		gid_type = ib_network_to_gid_type(addr->dev_addr.network);
-	route->path_rec->rec_type = sa_conv_gid_to_pathrec_type(gid_type);
-
-	sa_path_set_ndev(route->path_rec, addr->dev_addr.net);
-	sa_path_set_ifindex(route->path_rec, ndev->ifindex);
-	sa_path_set_dmac(route->path_rec, addr->dev_addr.dst_dev_addr);
-
 	rdma_ip2gid((struct sockaddr *)&id_priv->id.route.addr.src_addr,
 		    &route->path_rec->sgid);
 	rdma_ip2gid((struct sockaddr *)&id_priv->id.route.addr.dst_addr,
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
