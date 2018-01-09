From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 3/3] RDMA: Use rdma_cm API to query GID
Date: Tue,  9 Jan 2018 13:10:58 +0200
Message-ID: <20180109111058.29534-4-leon@kernel.org>
References: <20180109111058.29534-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180109111058.29534-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Make use of rdma_read_gids() function to read SGID and DGID which
returns correct GIDs for all transports.

Cc: Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/ucma.c | 8 ++++----
 net/rds/ib.c                   | 6 ++----
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 29a81e6cfc96..8699b3a1d464 100644
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
diff --git a/net/rds/ib.c b/net/rds/ib.c
index 36dd2099048a..b2a5067b4afe 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -301,13 +301,11 @@ static int rds_ib_conn_info_visitor(struct rds_connection *conn,
 	memset(&iinfo->dst_gid, 0, sizeof(iinfo->dst_gid));
 	if (rds_conn_state(conn) == RDS_CONN_UP) {
 		struct rds_ib_device *rds_ibdev;
-		struct rdma_dev_addr *dev_addr;
 
 		ic = conn->c_transport_data;
-		dev_addr = &ic->i_cm_id->route.addr.dev_addr;
 
-		rdma_addr_get_sgid(dev_addr, (union ib_gid *) &iinfo->src_gid);
-		rdma_addr_get_dgid(dev_addr, (union ib_gid *) &iinfo->dst_gid);
+		rdma_read_gids(ic->i_cm_id, (union ib_gid *)&iinfo->src_gid,
+			       (union ib_gid *)&iinfo->dst_gid);
 
 		rds_ibdev = ic->rds_ibdev;
 		iinfo->max_send_wr = ic->i_send_ring.w_nr;
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
