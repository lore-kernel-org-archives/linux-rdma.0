From: Dag Moxnes <dag.moxnes@oracle.com>
Subject: [PATCH] rds: ib: Fix missing call to rds_ib_dev_put in rds_ib_setup_qp
Date: Wed, 25 Apr 2018 13:22:01 +0200
Message-ID: <1524655321-8379-1-git-send-email-dag.moxnes@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Santosh Shilimkar <santosh.shilimkar@oracle.com>, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The function rds_ib_setup_qp is calling rds_ib_get_client_data and
should correspondingly call rds_ib_dev_put. This call was lost in
the non-error path with the introduction of error handling done in
commit 3b12f73a5c29 ("rds: ib: add error handle")

Signed-off-by: Dag Moxnes <dag.moxnes@oracle.com>
---
 net/rds/ib_cm.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index eea1d86..13b38ad 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -547,7 +547,7 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 	rdsdebug("conn %p pd %p cq %p %p\n", conn, ic->i_pd,
 		 ic->i_send_cq, ic->i_recv_cq);
 
-	return ret;
+	goto out;
 
 sends_out:
 	vfree(ic->i_sends);
@@ -572,6 +572,7 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 		ic->i_send_cq = NULL;
 rds_ibdev_out:
 	rds_ib_remove_conn(rds_ibdev, conn);
+out:
 	rds_ib_dev_put(rds_ibdev);
 
 	return ret;
-- 
1.7.1
