From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 15/31] RDMA/cma: Avoid setting path record type twice
Date: Tue, 14 Nov 2017 14:52:02 +0200
Message-ID: <20171114125218.20477-16-leon@kernel.org>
References: <20171114125218.20477-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114125218.20477-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Avoid setting path record type twice for RoCE.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 168f1230756b..f986597201fa 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2567,7 +2567,11 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 	gid_type = cma_route_gid_type(addr->dev_addr.network,
 				      supported_gids,
 				      id_priv->gid_type);
+	/* Use the hint from IP Stack to select GID Type */
+	if (gid_type < ib_network_to_gid_type(addr->dev_addr.network))
+		gid_type = ib_network_to_gid_type(addr->dev_addr.network);
 	route->path_rec->rec_type = sa_conv_gid_to_pathrec_type(gid_type);
+
 	sa_path_set_ndev(route->path_rec, &init_net);
 	sa_path_set_ifindex(route->path_rec, ndev->ifindex);
 	sa_path_set_dmac(route->path_rec, addr->dev_addr.dst_dev_addr);
@@ -2577,11 +2581,6 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 	rdma_ip2gid((struct sockaddr *)&id_priv->id.route.addr.dst_addr,
 		    &route->path_rec->dgid);
 
-	/* Use the hint from IP Stack to select GID Type */
-	if (gid_type < ib_network_to_gid_type(addr->dev_addr.network))
-		gid_type = ib_network_to_gid_type(addr->dev_addr.network);
-	route->path_rec->rec_type = sa_conv_gid_to_pathrec_type(gid_type);
-
 	if (((struct sockaddr *)&id_priv->id.route.addr.dst_addr)->sa_family != AF_IB)
 		/* TODO: get the hoplimit from the inet/inet6 device */
 		route->path_rec->hop_limit = addr->dev_addr.hoplimit;
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
