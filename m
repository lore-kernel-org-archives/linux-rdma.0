From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH v2 12/12] rds/ib: Remove ib_get_dma_mr calls
Date: Thu, 30 Jul 2015 17:22:26 -0600
Message-ID: <1438298547-21404-13-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1438298547-21404-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438298547-21404-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Chien Yen <chien.yen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dominique Martinet <dominique.martinet-KCE40YydGKI@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eric Van Hensbergen <ericvh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ido Shamay <idos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Latchesar Ionkov <lucho-OnYtXJJ0/fesTnJN9+BGXg@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ron Minnich <rminnich-4OHPYypu0djtX7QSmKvirg@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Simon Derr <simon.derr-6ktuUTfB/bM@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, v9fs-developer-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The pd now has a local_dma_lkey member which completely replaces
ib_get_dma_mr, use it instead.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 net/rds/ib.c      | 8 --------
 net/rds/ib.h      | 2 --
 net/rds/ib_cm.c   | 4 +---
 net/rds/ib_recv.c | 6 +++---
 net/rds/ib_send.c | 8 ++++----
 5 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/net/rds/ib.c b/net/rds/ib.c
index ba2dffeff608..56c570131667 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -99,8 +99,6 @@ static void rds_ib_dev_free(struct work_struct *work)
 
 	if (rds_ibdev->mr_pool)
 		rds_ib_destroy_mr_pool(rds_ibdev->mr_pool);
-	if (rds_ibdev->mr)
-		ib_dereg_mr(rds_ibdev->mr);
 	if (rds_ibdev->pd)
 		ib_dealloc_pd(rds_ibdev->pd);
 
@@ -164,12 +162,6 @@ static void rds_ib_add_one(struct ib_device *device)
 		goto put_dev;
 	}
 
-	rds_ibdev->mr = ib_get_dma_mr(rds_ibdev->pd, IB_ACCESS_LOCAL_WRITE);
-	if (IS_ERR(rds_ibdev->mr)) {
-		rds_ibdev->mr = NULL;
-		goto put_dev;
-	}
-
 	rds_ibdev->mr_pool = rds_ib_create_mr_pool(rds_ibdev);
 	if (IS_ERR(rds_ibdev->mr_pool)) {
 		rds_ibdev->mr_pool = NULL;
diff --git a/net/rds/ib.h b/net/rds/ib.h
index 86d88ec5d556..36f7d808ffaa 100644
--- a/net/rds/ib.h
+++ b/net/rds/ib.h
@@ -100,7 +100,6 @@ struct rds_ib_connection {
 	/* alphabet soup, IBTA style */
 	struct rdma_cm_id	*i_cm_id;
 	struct ib_pd		*i_pd;
-	struct ib_mr		*i_mr;
 	struct ib_cq		*i_send_cq;
 	struct ib_cq		*i_recv_cq;
 
@@ -173,7 +172,6 @@ struct rds_ib_device {
 	struct list_head	conn_list;
 	struct ib_device	*dev;
 	struct ib_pd		*pd;
-	struct ib_mr		*mr;
 	struct rds_ib_mr_pool	*mr_pool;
 	unsigned int		fmr_max_remaps;
 	unsigned int		max_fmrs;
diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index 0da2a45b33bd..a75e8832bc23 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -269,7 +269,6 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 
 	/* Protection domain and memory range */
 	ic->i_pd = rds_ibdev->pd;
-	ic->i_mr = rds_ibdev->mr;
 
 	cq_attr.cqe = ic->i_send_ring.w_nr + 1;
 	ic->i_send_cq = ib_create_cq(dev, rds_ib_send_cq_comp_handler,
@@ -375,7 +374,7 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 
 	rds_ib_recv_init_ack(ic);
 
-	rdsdebug("conn %p pd %p mr %p cq %p %p\n", conn, ic->i_pd, ic->i_mr,
+	rdsdebug("conn %p pd %p cq %p %p\n", conn, ic->i_pd,
 		 ic->i_send_cq, ic->i_recv_cq);
 
 out:
@@ -678,7 +677,6 @@ void rds_ib_conn_shutdown(struct rds_connection *conn)
 
 		ic->i_cm_id = NULL;
 		ic->i_pd = NULL;
-		ic->i_mr = NULL;
 		ic->i_send_cq = NULL;
 		ic->i_recv_cq = NULL;
 		ic->i_send_hdrs = NULL;
diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index cac5b4506ee3..0ceb4c60d2a3 100644
--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -62,12 +62,12 @@ void rds_ib_recv_init_ring(struct rds_ib_connection *ic)
 		sge = &recv->r_sge[0];
 		sge->addr = ic->i_recv_hdrs_dma + (i * sizeof(struct rds_header));
 		sge->length = sizeof(struct rds_header);
-		sge->lkey = ic->i_mr->lkey;
+		sge->lkey = ic->i_pd->local_dma_lkey;
 
 		sge = &recv->r_sge[1];
 		sge->addr = 0;
 		sge->length = RDS_FRAG_SIZE;
-		sge->lkey = ic->i_mr->lkey;
+		sge->lkey = ic->i_pd->local_dma_lkey;
 	}
 }
 
@@ -520,7 +520,7 @@ void rds_ib_recv_init_ack(struct rds_ib_connection *ic)
 
 	sge->addr = ic->i_ack_dma;
 	sge->length = sizeof(struct rds_header);
-	sge->lkey = ic->i_mr->lkey;
+	sge->lkey = ic->i_pd->local_dma_lkey;
 
 	wr->sg_list = sge;
 	wr->num_sge = 1;
diff --git a/net/rds/ib_send.c b/net/rds/ib_send.c
index 5d0a704fa039..f6c829d43373 100644
--- a/net/rds/ib_send.c
+++ b/net/rds/ib_send.c
@@ -202,9 +202,9 @@ void rds_ib_send_init_ring(struct rds_ib_connection *ic)
 		sge = &send->s_sge[0];
 		sge->addr = ic->i_send_hdrs_dma + (i * sizeof(struct rds_header));
 		sge->length = sizeof(struct rds_header);
-		sge->lkey = ic->i_mr->lkey;
+		sge->lkey = ic->i_pd->local_dma_lkey;
 
-		send->s_sge[1].lkey = ic->i_mr->lkey;
+		send->s_sge[1].lkey = ic->i_pd->local_dma_lkey;
 	}
 }
 
@@ -813,7 +813,7 @@ int rds_ib_xmit_atomic(struct rds_connection *conn, struct rm_atomic_op *op)
 	/* Convert our struct scatterlist to struct ib_sge */
 	send->s_sge[0].addr = ib_sg_dma_address(ic->i_cm_id->device, op->op_sg);
 	send->s_sge[0].length = ib_sg_dma_len(ic->i_cm_id->device, op->op_sg);
-	send->s_sge[0].lkey = ic->i_mr->lkey;
+	send->s_sge[0].lkey = ic->i_pd->local_dma_lkey;
 
 	rdsdebug("rva %Lx rpa %Lx len %u\n", op->op_remote_addr,
 		 send->s_sge[0].addr, send->s_sge[0].length);
@@ -927,7 +927,7 @@ int rds_ib_xmit_rdma(struct rds_connection *conn, struct rm_rdma_op *op)
 			send->s_sge[j].addr =
 				 ib_sg_dma_address(ic->i_cm_id->device, scat);
 			send->s_sge[j].length = len;
-			send->s_sge[j].lkey = ic->i_mr->lkey;
+			send->s_sge[j].lkey = ic->i_pd->local_dma_lkey;
 
 			sent += len;
 			rdsdebug("ic %p sent %d remote_addr %llu\n", ic, sent, remote_addr);
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
