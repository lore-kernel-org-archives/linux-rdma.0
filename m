From: Zhu Yanjun <yanjun.zhu@oracle.com>
Subject: [PATCH 1/1] net: rds: use memset to optimize the recv
Date: Fri, 14 Sep 2018 04:45:38 -0400
Message-ID: <20180914084538.11666-1-yanjun.zhu@oracle.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: santosh.shilimkar@oracle.com, davem@davemloft.net, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
List-Id: linux-rdma@vger.kernel.org

The function rds_inc_init is in recv process. To use memset can optimize
the function rds_inc_init.
The test result:

    Before:
    1) + 24.950 us   |        rds_inc_init [rds]();
    After:
    1) + 10.990 us   |        rds_inc_init [rds]();

Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
---
 net/rds/recv.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/rds/recv.c b/net/rds/recv.c
index 504cd6bcc54c..a9399ddbb7bf 100644
--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -43,8 +43,6 @@
 void rds_inc_init(struct rds_incoming *inc, struct rds_connection *conn,
 		 struct in6_addr *saddr)
 {
-	int i;
-
 	refcount_set(&inc->i_refcount, 1);
 	INIT_LIST_HEAD(&inc->i_item);
 	inc->i_conn = conn;
@@ -53,8 +51,7 @@ void rds_inc_init(struct rds_incoming *inc, struct rds_connection *conn,
 	inc->i_rx_tstamp.tv_sec = 0;
 	inc->i_rx_tstamp.tv_usec = 0;
 
-	for (i = 0; i < RDS_RX_MAX_TRACES; i++)
-		inc->i_rx_lat_trace[i] = 0;
+	memset(inc->i_rx_lat_trace, 0, sizeof(inc->i_rx_lat_trace));
 }
 EXPORT_SYMBOL_GPL(rds_inc_init);
 
-- 
2.17.1
