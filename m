From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v1 3/4] net/rds: Use rdma_read_gids to read connection GIDs
Date: Thu, 18 Jan 2018 10:11:18 +0200
Message-ID: <20180118081119.30024-4-leon@kernel.org>
References: <20180118081119.30024-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180118081119.30024-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Use newly introduced API rdma_read_gids to read the SGID and DGID for
the connection which returns GID correctly for RoCE transport as well.

rdma_addr_get_dgid() for RoCE for client side connections returns MAC
address, instead of DGID.
rdma_addr_get_sgid() for RoCE doesn't return correct SGID for IPv6 and
when more than one IP address is assigned to the netdevice.

Therefore use transport agnostic rdma_read_gids() API provided by rdma_cm
module.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Acked-by: Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 net/rds/ib.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

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
