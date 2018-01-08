From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/6] RDMA/cma: Use the net namespace of the rdma_cm_id
Date: Mon,  8 Jan 2018 17:04:43 +0200
Message-ID: <20180108150448.29069-2-leon@kernel.org>
References: <20180108150448.29069-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180108150448.29069-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The net namespace is set during create_rdma_id(), while
the cma_resolve_iboe_route() used init namespace.

The original code was added in commit fa20105e09e9 ("IB/cma: Add support
for network namespaces"), but this path wasn't in use back then.

This patch updates the code to use right namespace, as a preparation
to the following patches.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 62fc876169dd..282269f88f89 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2567,7 +2567,8 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 		goto err2;
 	}
 
-	ndev = dev_get_by_index(&init_net, addr->dev_addr.bound_dev_if);
+	ndev = dev_get_by_index(addr->dev_addr.net,
+				addr->dev_addr.bound_dev_if);
 	if (!ndev) {
 		ret = -ENODEV;
 		goto err2;
@@ -2583,7 +2584,7 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 		gid_type = ib_network_to_gid_type(addr->dev_addr.network);
 	route->path_rec->rec_type = sa_conv_gid_to_pathrec_type(gid_type);
 
-	sa_path_set_ndev(route->path_rec, &init_net);
+	sa_path_set_ndev(route->path_rec, addr->dev_addr.net);
 	sa_path_set_ifindex(route->path_rec, ndev->ifindex);
 	sa_path_set_dmac(route->path_rec, addr->dev_addr.dst_dev_addr);
 
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
