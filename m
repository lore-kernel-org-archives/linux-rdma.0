From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH v4 4/4] IB/iser: Use ib_drain_sq()
Date: Wed, 17 Feb 2016 08:17:12 -0800
Message-ID: <269ab4c6de9c30bb6beba249302d5f1d1db9b924.1455741337.git.swise@chelsio.com>
References: <cover.1455741336.git.swise@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1455741336.git.swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h     |  7 -------
 drivers/infiniband/ulp/iser/iser_initiator.c |  7 -------
 drivers/infiniband/ulp/iser/iser_verbs.c     | 15 ++-------------
 3 files changed, 2 insertions(+), 27 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 95f0a64..0351059 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -458,9 +458,6 @@ struct iser_fr_pool {
  * @comp:                iser completion context
  * @fr_pool:             connection fast registration poool
  * @pi_support:          Indicate device T10-PI support
- * @last:                last send wr to signal all flush errors were drained
- * @last_cqe:            cqe handler for last wr
- * @last_comp:           completes when all connection completions consumed
  */
 struct ib_conn {
 	struct rdma_cm_id           *cma_id;
@@ -472,10 +469,7 @@ struct ib_conn {
 	struct iser_comp	    *comp;
 	struct iser_fr_pool          fr_pool;
 	bool			     pi_support;
-	struct ib_send_wr	     last;
-	struct ib_cqe		     last_cqe;
 	struct ib_cqe		     reg_cqe;
-	struct completion	     last_comp;
 };
 
 /**
@@ -617,7 +611,6 @@ void iser_cmd_comp(struct ib_cq *cq, struct ib_wc *wc);
 void iser_ctrl_comp(struct ib_cq *cq, struct ib_wc *wc);
 void iser_dataout_comp(struct ib_cq *cq, struct ib_wc *wc);
 void iser_reg_comp(struct ib_cq *cq, struct ib_wc *wc);
-void iser_last_comp(struct ib_cq *cq, struct ib_wc *wc);
 
 void iser_task_rdma_init(struct iscsi_iser_task *task);
 
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index ed54b38..81ae2e3 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -729,13 +729,6 @@ void iser_dataout_comp(struct ib_cq *cq, struct ib_wc *wc)
 	kmem_cache_free(ig.desc_cache, desc);
 }
 
-void iser_last_comp(struct ib_cq *cq, struct ib_wc *wc)
-{
-	struct ib_conn *ib_conn = wc->qp->qp_context;
-
-	complete(&ib_conn->last_comp);
-}
-
 void iser_task_rdma_init(struct iscsi_iser_task *iser_task)
 
 {
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 40c0f49..47e1159 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -663,7 +663,6 @@ void iser_conn_release(struct iser_conn *iser_conn)
 int iser_conn_terminate(struct iser_conn *iser_conn)
 {
 	struct ib_conn *ib_conn = &iser_conn->ib_conn;
-	struct ib_send_wr *bad_wr;
 	int err = 0;
 
 	/* terminate the iser conn only if the conn state is UP */
@@ -688,14 +687,8 @@ int iser_conn_terminate(struct iser_conn *iser_conn)
 			iser_err("Failed to disconnect, conn: 0x%p err %d\n",
 				 iser_conn, err);
 
-		/* post an indication that all flush errors were consumed */
-		err = ib_post_send(ib_conn->qp, &ib_conn->last, &bad_wr);
-		if (err) {
-			iser_err("conn %p failed to post last wr", ib_conn);
-			return 1;
-		}
-
-		wait_for_completion(&ib_conn->last_comp);
+		/* block until all flush errors are consumed */
+		ib_drain_sq(ib_conn->qp);
 	}
 
 	return 1;
@@ -954,10 +947,6 @@ void iser_conn_init(struct iser_conn *iser_conn)
 
 	ib_conn->post_recv_buf_count = 0;
 	ib_conn->reg_cqe.done = iser_reg_comp;
-	ib_conn->last_cqe.done = iser_last_comp;
-	ib_conn->last.wr_cqe = &ib_conn->last_cqe;
-	ib_conn->last.opcode = IB_WR_SEND;
-	init_completion(&ib_conn->last_comp);
 }
 
  /**
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
