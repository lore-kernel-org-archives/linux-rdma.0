From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 14/31] RDMA/cma: Simplify netdev check
Date: Tue, 14 Nov 2017 14:52:01 +0200
Message-ID: <20171114125218.20477-15-leon@kernel.org>
References: <20171114125218.20477-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114125218.20477-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Current code checks for NULL ndev twice where 2nd check is always
invalid given the fact that during route resolving stage, device address
must be bound to netdevice interface.

This patch simplifies such check.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index e63a51b68ed5..168f1230756b 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2527,8 +2527,10 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 	struct rdma_addr *addr = &route->addr;
 	struct cma_work *work;
 	int ret;
-	struct net_device *ndev = NULL;
+	struct net_device *ndev;
 	enum ib_gid_type gid_type = IB_GID_TYPE_ROCE;
+	unsigned long supported_gids;
+
 	u8 default_roce_tos = id_priv->cma_dev->default_roce_tos[id_priv->id.port_num -
 					rdma_start_port(id_priv->cma_dev->device)];
 	u8 tos = id_priv->tos_set ? id_priv->tos : default_roce_tos;
@@ -2549,30 +2551,25 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 
 	route->num_paths = 1;
 
-	if (addr->dev_addr.bound_dev_if) {
-		unsigned long supported_gids;
-
-		ndev = dev_get_by_index(&init_net, addr->dev_addr.bound_dev_if);
-		if (!ndev) {
-			ret = -ENODEV;
-			goto err2;
-		}
-
-		supported_gids = roce_gid_type_mask_support(id_priv->id.device,
-							    id_priv->id.port_num);
-		gid_type = cma_route_gid_type(addr->dev_addr.network,
-					      supported_gids,
-					      id_priv->gid_type);
-		route->path_rec->rec_type =
-			sa_conv_gid_to_pathrec_type(gid_type);
-		sa_path_set_ndev(route->path_rec, &init_net);
-		sa_path_set_ifindex(route->path_rec, ndev->ifindex);
+	if (!addr->dev_addr.bound_dev_if) {
+		ret = -ENODEV;
+		goto err2;
 	}
+
+	ndev = dev_get_by_index(&init_net, addr->dev_addr.bound_dev_if);
 	if (!ndev) {
 		ret = -ENODEV;
 		goto err2;
 	}
 
+	supported_gids = roce_gid_type_mask_support(id_priv->id.device,
+						    id_priv->id.port_num);
+	gid_type = cma_route_gid_type(addr->dev_addr.network,
+				      supported_gids,
+				      id_priv->gid_type);
+	route->path_rec->rec_type = sa_conv_gid_to_pathrec_type(gid_type);
+	sa_path_set_ndev(route->path_rec, &init_net);
+	sa_path_set_ifindex(route->path_rec, ndev->ifindex);
 	sa_path_set_dmac(route->path_rec, addr->dev_addr.dst_dev_addr);
 
 	rdma_ip2gid((struct sockaddr *)&id_priv->id.route.addr.src_addr,
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
