From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v1 2/4] RDMA/ucma: Use rdma cm API to query GID
Date: Thu, 18 Jan 2018 10:11:17 +0200
Message-ID: <20180118081119.30024-3-leon@kernel.org>
References: <20180118081119.30024-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180118081119.30024-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Make use of rdma_read_gids() API to read SGID and DGID which returns
correct GIDs for RoCE and other transports.

rdma_addr_get_dgid() for RoCE for client side connections returns MAC
address, instead of DGID.
rdma_addr_get_sgid() for RoCE doesn't return correct SGID for IPv6 and
when more than one IP address is assigned to the netdevice.

Therefore use transport agnostic rdma_read_gids() API provided by rdma_cm
module.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/ucma.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 2ec0f89035fb..d67219db99be 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -944,8 +944,8 @@ static ssize_t ucma_query_gid(struct ucma_context *ctx,
 	} else {
 		addr->sib_family = AF_IB;
 		addr->sib_pkey = (__force __be16) resp.pkey;
-		rdma_addr_get_sgid(&ctx->cm_id->route.addr.dev_addr,
-				   (union ib_gid *) &addr->sib_addr);
+		rdma_read_gids(ctx->cm_id, (union ib_gid *)&addr->sib_addr,
+			       NULL);
 		addr->sib_sid = rdma_get_service_id(ctx->cm_id, (struct sockaddr *)
 						    &ctx->cm_id->route.addr.src_addr);
 	}
@@ -957,8 +957,8 @@ static ssize_t ucma_query_gid(struct ucma_context *ctx,
 	} else {
 		addr->sib_family = AF_IB;
 		addr->sib_pkey = (__force __be16) resp.pkey;
-		rdma_addr_get_dgid(&ctx->cm_id->route.addr.dev_addr,
-				   (union ib_gid *) &addr->sib_addr);
+		rdma_read_gids(ctx->cm_id, NULL,
+			       (union ib_gid *)&addr->sib_addr);
 		addr->sib_sid = rdma_get_service_id(ctx->cm_id, (struct sockaddr *)
 						    &ctx->cm_id->route.addr.dst_addr);
 	}
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
