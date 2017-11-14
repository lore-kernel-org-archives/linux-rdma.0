From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 13/31] RDMA/cma: Set default GID type as RoCE when resolving RoCE route
Date: Tue, 14 Nov 2017 14:52:00 +0200
Message-ID: <20171114125218.20477-14-leon@kernel.org>
References: <20171114125218.20477-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114125218.20477-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

As the function name suggests cma_resolve_iboe_route() resolves RoCE
route. However, its default GID type is IB_GID_TYPE_IB and not
IB_GID_TYPE_ROCE, even though both are mapped to the same enum value.
Change default GID type to IB_GID_TYPE_ROCE.

cma_iboe_set_mgid() is updated to reflect the RoCEv2 GID check.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 9841e7ca5c06..e63a51b68ed5 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2528,7 +2528,7 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 	struct cma_work *work;
 	int ret;
 	struct net_device *ndev = NULL;
-	enum ib_gid_type gid_type = IB_GID_TYPE_IB;
+	enum ib_gid_type gid_type = IB_GID_TYPE_ROCE;
 	u8 default_roce_tos = id_priv->cma_dev->default_roce_tos[id_priv->id.port_num -
 					rdma_start_port(id_priv->cma_dev->device)];
 	u8 tos = id_priv->tos_set ? id_priv->tos : default_roce_tos;
@@ -4009,8 +4009,10 @@ static void cma_iboe_set_mgid(struct sockaddr *addr, union ib_gid *mgid,
 	} else if (addr->sa_family == AF_INET6) {
 		memcpy(mgid, &sin6->sin6_addr, sizeof *mgid);
 	} else {
-		mgid->raw[0] = (gid_type == IB_GID_TYPE_IB) ? 0xff : 0;
-		mgid->raw[1] = (gid_type == IB_GID_TYPE_IB) ? 0x0e : 0;
+		mgid->raw[0] =
+			(gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP) ? 0 : 0xff;
+		mgid->raw[1] =
+			(gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP) ? 0 : 0x0e;
 		mgid->raw[2] = 0;
 		mgid->raw[3] = 0;
 		mgid->raw[4] = 0;
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
