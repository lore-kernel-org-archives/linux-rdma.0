From: =?UTF-8?q?H=C3=A5kon=20Bugge?= <Haakon.Bugge@oracle.com>
Subject: [PATCH] net/rds: Remove unnecessary variable
Date: Mon, 16 Jul 2018 15:06:39 +0200
Message-ID: <20180716130639.1591990-1-Haakon.Bugge@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Santosh Shilimkar <santosh.shilimkar@oracle.com>, "David S . Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
---
 net/rds/ib_recv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index b4e421aa9727..a720583542a1 100644
--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -1025,7 +1025,6 @@ int rds_ib_recv_path(struct rds_conn_path *cp)
 {
 	struct rds_connection *conn = cp->cp_conn;
 	struct rds_ib_connection *ic = conn->c_transport_data;
-	int ret = 0;
 
 	rdsdebug("conn %p\n", conn);
 	if (rds_conn_up(conn)) {
@@ -1034,7 +1033,7 @@ int rds_ib_recv_path(struct rds_conn_path *cp)
 		rds_ib_stats_inc(s_ib_rx_refill_from_thread);
 	}
 
-	return ret;
+	return 0;
 }
 
 int rds_ib_recv_init(void)
-- 
2.14.3
