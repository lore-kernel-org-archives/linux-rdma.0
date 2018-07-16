From: =?UTF-8?q?H=C3=A5kon=20Bugge?= <Haakon.Bugge@oracle.com>
Subject: [PATCH] net/rds: void function cannot return -1
Date: Mon, 16 Jul 2018 15:00:09 +0200
Message-ID: <20180716130009.1591379-1-Haakon.Bugge@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Santosh Shilimkar <santosh.shilimkar@oracle.com>, "David S . Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Commit b6fb0df12db6 ("RDS/IB: Make ib_recv_refill return void") did
not change the comment accordingly.

Fixes: b6fb0df12db6 ("RDS/IB: Make ib_recv_refill return void")
Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
---
 net/rds/ib_recv.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index b4e421aa9727..e5ce93419263 100644
--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -376,8 +376,6 @@ static void release_refill(struct rds_connection *conn)
  * This tries to allocate and post unused work requests after making sure that
  * they have all the allocations they need to queue received fragments into
  * sockets.
- *
- * -1 is returned if posting fails due to temporary resource exhaustion.
  */
 void rds_ib_recv_refill(struct rds_connection *conn, int prefill, gfp_t gfp)
 {
-- 
2.14.3
