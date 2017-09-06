From: =?UTF-8?q?H=C3=A5kon=20Bugge?= <Haakon.Bugge@oracle.com>
Subject: [PATCH net] rds: Fix incorrect statistics counting
Date: Wed,  6 Sep 2017 17:29:50 +0200
Message-ID: <20170906152950.17766-1-Haakon.Bugge@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Santosh Shilimkar <santosh.shilimkar@oracle.com>, "David S . Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org, knut.omang@oracle.com
List-Id: linux-rdma@vger.kernel.org

In rds_send_xmit() there is logic to batch the sends. However, if
another thread has acquired the lock, it is considered a race and we
yield. The code incrementing the s_send_lock_queue_raced statistics
counter did not count this event correctly.

This commit removes a small race in determining the race and
increments the statistics counter correctly.

Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
Reviewed-by: Knut Omang <knut.omang@oracle.com>
---
 net/rds/send.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/net/rds/send.c b/net/rds/send.c
index 058a407..ecfe0b5 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -101,6 +101,11 @@ void rds_send_path_reset(struct rds_conn_path *cp)
 }
 EXPORT_SYMBOL_GPL(rds_send_path_reset);
 
+static bool someone_in_xmit(struct rds_conn_path *cp)
+{
+	return test_bit(RDS_IN_XMIT, &cp->cp_flags);
+}
+
 static int acquire_in_xmit(struct rds_conn_path *cp)
 {
 	return test_and_set_bit(RDS_IN_XMIT, &cp->cp_flags) == 0;
@@ -428,14 +433,19 @@ int rds_send_xmit(struct rds_conn_path *cp)
 	 * some work and we will skip our goto
 	 */
 	if (ret == 0) {
+		bool raced;
+
 		smp_mb();
+		raced = someone_in_xmit(cp) ||
+			send_gen != READ_ONCE(cp->cp_send_gen);
+
 		if ((test_bit(0, &conn->c_map_queued) ||
-		     !list_empty(&cp->cp_send_queue)) &&
-			send_gen == READ_ONCE(cp->cp_send_gen)) {
-			rds_stats_inc(s_send_lock_queue_raced);
+				!list_empty(&cp->cp_send_queue)) && !raced) {
 			if (batch_count < send_batch_count)
 				goto restart;
 			queue_delayed_work(rds_wq, &cp->cp_send_w, 1);
+		} else if (raced) {
+			rds_stats_inc(s_send_lock_queue_raced);
 		}
 	}
 out:
-- 
2.9.3
