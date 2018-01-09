From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 4/6] RDMA/cma: Update RoCE multicast routines to use net namespace
Date: Tue,  9 Jan 2018 15:58:57 +0200
Message-ID: <20180109135859.7676-5-leon@kernel.org>
References: <20180109135859.7676-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180109135859.7676-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

rdma_dev_addr contains the net namespace pointer, while referring
bound_dev_if of the rdma_dev_addr, refer to the net namespace of
rdma_cm_id stored in rdma_dev_addr.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 09bde1b13a64..90dead30de4c 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -3930,7 +3930,7 @@ static int cma_ib_mc_handler(int status, struct ib_sa_multicast *multicast)
 		struct rdma_dev_addr *dev_addr =
 			&id_priv->id.route.addr.dev_addr;
 		struct net_device *ndev =
-			dev_get_by_index(&init_net, dev_addr->bound_dev_if);
+			dev_get_by_index(dev_addr->net, dev_addr->bound_dev_if);
 		enum ib_gid_type gid_type =
 			id_priv->cma_dev->default_gid_type[id_priv->id.port_num -
 			rdma_start_port(id_priv->cma_dev->device)];
@@ -4120,7 +4120,7 @@ static int cma_iboe_join_multicast(struct rdma_id_private *id_priv,
 		mc->multicast.ib->rec.qkey = cpu_to_be32(RDMA_UDP_QKEY);
 
 	if (dev_addr->bound_dev_if)
-		ndev = dev_get_by_index(&init_net, dev_addr->bound_dev_if);
+		ndev = dev_get_by_index(dev_addr->net, dev_addr->bound_dev_if);
 	if (!ndev) {
 		err = -ENODEV;
 		goto out2;
@@ -4238,7 +4238,7 @@ void rdma_leave_multicast(struct rdma_cm_id *id, struct sockaddr *addr)
 					struct net_device *ndev = NULL;
 
 					if (dev_addr->bound_dev_if)
-						ndev = dev_get_by_index(&init_net,
+						ndev = dev_get_by_index(dev_addr->net,
 									dev_addr->bound_dev_if);
 					if (ndev) {
 						cma_igmp_send(ndev,
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
