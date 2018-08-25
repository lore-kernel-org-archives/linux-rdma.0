From: Zhu Yanjun <yanjun.zhu@oracle.com>
Subject: [PATCH 1/1] net/rds: Use rdma_read_gids to get connection SGID/DGID in IPv6
Date: Sat, 25 Aug 2018 15:19:05 +0800
Message-ID: <20180825071905.2749-1-yanjun.zhu@oracle.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: santosh.shilimkar@oracle.com, davem@davemloft.net, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc: Zhu Yanjun <yanjun.zhu@oracle.com>
List-Id: linux-rdma@vger.kernel.org

In IPv4, the newly introduced rdma_read_gids is used to read the SGID/DGID
for the connection which returns GID correctly for RoCE transport as well.

In IPv6, rdma_read_gids is also used. The following are why rdma_read_gids
is introduced.

rdma_addr_get_dgid() for RoCE for client side connections returns MAC
address, instead of DGID.
rdma_addr_get_sgid() for RoCE doesn't return correct SGID for IPv6 and
when more than one IP address is assigned to the netdevice.

So the transport agnostic rdma_read_gids() API is provided by rdma_cm
module.

Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
---
 net/rds/ib.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/net/rds/ib.c b/net/rds/ib.c
index c1d97640c0be..eba75c1ba359 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -341,15 +341,10 @@ static int rds6_ib_conn_info_visitor(struct rds_connection *conn,
 
 	if (rds_conn_state(conn) == RDS_CONN_UP) {
 		struct rds_ib_device *rds_ibdev;
-		struct rdma_dev_addr *dev_addr;
 
 		ic = conn->c_transport_data;
-		dev_addr = &ic->i_cm_id->route.addr.dev_addr;
-		rdma_addr_get_sgid(dev_addr,
-				   (union ib_gid *)&iinfo6->src_gid);
-		rdma_addr_get_dgid(dev_addr,
-				   (union ib_gid *)&iinfo6->dst_gid);
-
+		rdma_read_gids(ic->i_cm_id, (union ib_gid *)&iinfo6->src_gid,
+			       (union ib_gid *)&iinfo6->dst_gid);
 		rds_ibdev = ic->rds_ibdev;
 		iinfo6->max_send_wr = ic->i_send_ring.w_nr;
 		iinfo6->max_recv_wr = ic->i_recv_ring.w_nr;
-- 
2.17.1
