From: Zhu Yanjun <yanjun.zhu@oracle.com>
Subject: [PATCH 1/1] Revert "rds: ib: add error handle"
Date: Mon, 23 Apr 2018 21:39:01 -0400
Message-ID: <1524533941-4072-1-git-send-email-yanjun.zhu@oracle.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: santosh.shilimkar@oracle.com, davem@davemloft.net, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
List-Id: linux-rdma@vger.kernel.org

This reverts commit 3b12f73a5c2977153f28a224392fd4729b50d1dc.

After long time discussion and investigations, it seems that there
is no mem leak. So this patch is reverted.

Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
---
 net/rds/ib_cm.c | 47 +++++++++++------------------------------------
 1 file changed, 11 insertions(+), 36 deletions(-)

diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index eea1d86..d64bfaf 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -443,7 +443,7 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 		ic->i_send_cq = NULL;
 		ibdev_put_vector(rds_ibdev, ic->i_scq_vector);
 		rdsdebug("ib_create_cq send failed: %d\n", ret);
-		goto rds_ibdev_out;
+		goto out;
 	}
 
 	ic->i_rcq_vector = ibdev_get_unused_vector(rds_ibdev);
@@ -457,19 +457,19 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 		ic->i_recv_cq = NULL;
 		ibdev_put_vector(rds_ibdev, ic->i_rcq_vector);
 		rdsdebug("ib_create_cq recv failed: %d\n", ret);
-		goto send_cq_out;
+		goto out;
 	}
 
 	ret = ib_req_notify_cq(ic->i_send_cq, IB_CQ_NEXT_COMP);
 	if (ret) {
 		rdsdebug("ib_req_notify_cq send failed: %d\n", ret);
-		goto recv_cq_out;
+		goto out;
 	}
 
 	ret = ib_req_notify_cq(ic->i_recv_cq, IB_CQ_SOLICITED);
 	if (ret) {
 		rdsdebug("ib_req_notify_cq recv failed: %d\n", ret);
-		goto recv_cq_out;
+		goto out;
 	}
 
 	/* XXX negotiate max send/recv with remote? */
@@ -495,7 +495,7 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 	ret = rdma_create_qp(ic->i_cm_id, ic->i_pd, &attr);
 	if (ret) {
 		rdsdebug("rdma_create_qp failed: %d\n", ret);
-		goto recv_cq_out;
+		goto out;
 	}
 
 	ic->i_send_hdrs = ib_dma_alloc_coherent(dev,
@@ -505,7 +505,7 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 	if (!ic->i_send_hdrs) {
 		ret = -ENOMEM;
 		rdsdebug("ib_dma_alloc_coherent send failed\n");
-		goto qp_out;
+		goto out;
 	}
 
 	ic->i_recv_hdrs = ib_dma_alloc_coherent(dev,
@@ -515,7 +515,7 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 	if (!ic->i_recv_hdrs) {
 		ret = -ENOMEM;
 		rdsdebug("ib_dma_alloc_coherent recv failed\n");
-		goto send_hdrs_dma_out;
+		goto out;
 	}
 
 	ic->i_ack = ib_dma_alloc_coherent(dev, sizeof(struct rds_header),
@@ -523,7 +523,7 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 	if (!ic->i_ack) {
 		ret = -ENOMEM;
 		rdsdebug("ib_dma_alloc_coherent ack failed\n");
-		goto recv_hdrs_dma_out;
+		goto out;
 	}
 
 	ic->i_sends = vzalloc_node(ic->i_send_ring.w_nr * sizeof(struct rds_ib_send_work),
@@ -531,7 +531,7 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 	if (!ic->i_sends) {
 		ret = -ENOMEM;
 		rdsdebug("send allocation failed\n");
-		goto ack_dma_out;
+		goto out;
 	}
 
 	ic->i_recvs = vzalloc_node(ic->i_recv_ring.w_nr * sizeof(struct rds_ib_recv_work),
@@ -539,7 +539,7 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 	if (!ic->i_recvs) {
 		ret = -ENOMEM;
 		rdsdebug("recv allocation failed\n");
-		goto sends_out;
+		goto out;
 	}
 
 	rds_ib_recv_init_ack(ic);
@@ -547,33 +547,8 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 	rdsdebug("conn %p pd %p cq %p %p\n", conn, ic->i_pd,
 		 ic->i_send_cq, ic->i_recv_cq);
 
-	return ret;
-
-sends_out:
-	vfree(ic->i_sends);
-ack_dma_out:
-	ib_dma_free_coherent(dev, sizeof(struct rds_header),
-			     ic->i_ack, ic->i_ack_dma);
-recv_hdrs_dma_out:
-	ib_dma_free_coherent(dev, ic->i_recv_ring.w_nr *
-					sizeof(struct rds_header),
-					ic->i_recv_hdrs, ic->i_recv_hdrs_dma);
-send_hdrs_dma_out:
-	ib_dma_free_coherent(dev, ic->i_send_ring.w_nr *
-					sizeof(struct rds_header),
-					ic->i_send_hdrs, ic->i_send_hdrs_dma);
-qp_out:
-	rdma_destroy_qp(ic->i_cm_id);
-recv_cq_out:
-	if (!ib_destroy_cq(ic->i_recv_cq))
-		ic->i_recv_cq = NULL;
-send_cq_out:
-	if (!ib_destroy_cq(ic->i_send_cq))
-		ic->i_send_cq = NULL;
-rds_ibdev_out:
-	rds_ib_remove_conn(rds_ibdev, conn);
+out:
 	rds_ib_dev_put(rds_ibdev);
-
 	return ret;
 }
 
-- 
2.7.4
