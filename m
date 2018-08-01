From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] rds: remove redundant variable 'rds_ibdev'
Date: Wed, 1 Aug 2018 15:14:07 +0800
Message-ID: <20180801071407.22044-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: davem@davemloft.net, santosh.shilimkar@oracle.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, YueHaibing <yuehaibing@huawei.com>
List-Id: linux-rdma@vger.kernel.org

Variable 'rds_ibdev' is being assigned but never used,
so can be removed.

fix this clang warning:
 net/rds/ib_send.c:762:24: warning: variable ‘rds_ibdev’ set but not used [-Wunused-but-set-variable]

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/rds/ib_send.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/rds/ib_send.c b/net/rds/ib_send.c
index c4cdfe49..c8dd312 100644
--- a/net/rds/ib_send.c
+++ b/net/rds/ib_send.c
@@ -759,14 +759,11 @@ int rds_ib_xmit_atomic(struct rds_connection *conn, struct rm_atomic_op *op)
 	struct rds_ib_connection *ic = conn->c_transport_data;
 	struct rds_ib_send_work *send = NULL;
 	struct ib_send_wr *failed_wr;
-	struct rds_ib_device *rds_ibdev;
 	u32 pos;
 	u32 work_alloc;
 	int ret;
 	int nr_sig = 0;
 
-	rds_ibdev = ib_get_client_data(ic->i_cm_id->device, &rds_ib_client);
-
 	work_alloc = rds_ib_ring_alloc(&ic->i_send_ring, 1, &pos);
 	if (work_alloc != 1) {
 		rds_ib_stats_inc(s_ib_tx_ring_full);
-- 
2.7.0
