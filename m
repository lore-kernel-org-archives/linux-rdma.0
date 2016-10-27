From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 3/6] IB/core: Set routable RoCE gid type for ipv4/ipv6 networks
Date: Thu, 27 Oct 2016 16:36:28 +0300
Message-ID: <1477575391-20134-4-git-send-email-leon@kernel.org>
References: <1477575391-20134-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477575391-20134-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

If the underlying netowrk type is ipv4 or ipv6 and the device supports
routable RoCE, prefer it so the traffic could cross subnets.

Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 36bf50e..9ca0da0 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2436,6 +2436,18 @@ static int iboe_tos_to_sl(struct net_device *ndev, int tos)
 	return 0;
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
 static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 {
 	struct rdma_route *route = &id_priv->id.route;
@@ -2461,6 +2473,8 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 	route->num_paths = 1;
 
 	if (addr->dev_addr.bound_dev_if) {
+		unsigned long supported_gids;
+
 		ndev = dev_get_by_index(&init_net, addr->dev_addr.bound_dev_if);
 		if (!ndev) {
 			ret = -ENODEV;
@@ -2484,7 +2498,12 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 
 		route->path_rec->net = &init_net;
 		route->path_rec->ifindex = ndev->ifindex;
-		route->path_rec->gid_type = id_priv->gid_type;
+		supported_gids = roce_gid_type_mask_support(id_priv->id.device,
+							    id_priv->id.port_num);
+		route->path_rec->gid_type =
+			cma_route_gid_type(addr->dev_addr.network,
+					   supported_gids,
+					   id_priv->gid_type);
 	}
 	if (!ndev) {
 		ret = -ENODEV;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
