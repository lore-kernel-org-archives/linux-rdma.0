From: Zhu Yanjun <yanjun.zhu@oracle.com>
Subject: [PATCH 1/1] net: rds: exchange of 8K and 1M pool
Date: Wed, 24 Apr 2019 02:56:42 -0400
Message-ID: <20190424065642.28630-1-yanjun.zhu@oracle.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: santosh.shilimkar@oracle.com, davem@davemloft.net, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Before the commit 490ea5967b0d ("RDS: IB: move FMR code to its own file"),
when the dirty_count is greater than 9/10 of max_items of 8K pool,
1M pool is used, Vice versa. After the commit 490ea5967b0d ("RDS: IB: move
FMR code to its own file"), the above is removed. When we make the
following tests.

Server:
  rds-stress -r 1.1.1.16 -D 1M

Client:
  rds-stress -r 1.1.1.14 -s 1.1.1.16 -D 1M

The following will appear.
"
connecting to 1.1.1.16:4000
negotiated options, tasks will start in 2 seconds
Starting up..header from 1.1.1.166:4001 to id 4001 bogus
..
tsks  tx/s  rx/s tx+rx K/s  mbi K/s  mbo K/s tx us/c  rtt us
cpu %
   1    0    0     0.00     0.00     0.00    0.00 0.00 -1.00
   1    0    0     0.00     0.00     0.00    0.00 0.00 -1.00
   1    0    0     0.00     0.00     0.00    0.00 0.00 -1.00
   1    0    0     0.00     0.00     0.00    0.00 0.00 -1.00
   1    0    0     0.00     0.00     0.00    0.00 0.00 -1.00
... 
"
So this exchange between 8K and 1M pool is added back.

Fixes: commit 490ea5967b0d ("RDS: IB: move FMR code to its own file")
Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
---
 net/rds/ib_fmr.c  | 11 +++++++++++
 net/rds/ib_rdma.c |  3 ---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/net/rds/ib_fmr.c b/net/rds/ib_fmr.c
index 4fe8f4f..6fc5e2c 100644
--- a/net/rds/ib_fmr.c
+++ b/net/rds/ib_fmr.c
@@ -44,6 +44,17 @@ struct rds_ib_mr *rds_ib_alloc_fmr(struct rds_ib_device *rds_ibdev, int npages)
 	else
 		pool = rds_ibdev->mr_1m_pool;
 
+	if (atomic_read(&pool->dirty_count) >= pool->max_items / 10)
+		queue_delayed_work(rds_ib_mr_wq, &pool->flush_worker, 10);
+
+	/* Switch pools if one of the pool is reaching upper limit */
+	if (atomic_read(&pool->dirty_count) >=  pool->max_items * 9 / 10) {
+		if (pool->pool_type == RDS_IB_MR_8K_POOL)
+			pool = rds_ibdev->mr_1m_pool;
+		else
+			pool = rds_ibdev->mr_8k_pool;
+	}
+
 	ibmr = rds_ib_try_reuse_ibmr(pool);
 	if (ibmr)
 		return ibmr;
diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
index f7164ac..eb0b1cd 100644
--- a/net/rds/ib_rdma.c
+++ b/net/rds/ib_rdma.c
@@ -441,9 +441,6 @@ struct rds_ib_mr *rds_ib_try_reuse_ibmr(struct rds_ib_mr_pool *pool)
 	struct rds_ib_mr *ibmr = NULL;
 	int iter = 0;
 
-	if (atomic_read(&pool->dirty_count) >= pool->max_items_soft / 10)
-		queue_delayed_work(rds_ib_mr_wq, &pool->flush_worker, 10);
-
 	while (1) {
 		ibmr = rds_ib_reuse_mr(pool);
 		if (ibmr)
-- 
2.7.4
