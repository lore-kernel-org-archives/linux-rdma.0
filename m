From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 11/15] IB/rxe: Generate a completion for all failed work requests
Date: Tue, 10 Jan 2017 11:08:18 -0800
Message-ID: <20170110190822.16953-12-bart.vanassche@sandisk.com>
References: <20170110190822.16953-1-bart.vanassche@sandisk.com>
 <20170110190822.16953-2-bart.vanassche@sandisk.com>
 <20170110190822.16953-3-bart.vanassche@sandisk.com>
 <20170110190822.16953-4-bart.vanassche@sandisk.com>
 <20170110190822.16953-5-bart.vanassche@sandisk.com>
 <20170110190822.16953-6-bart.vanassche@sandisk.com>
 <20170110190822.16953-7-bart.vanassche@sandisk.com>
 <20170110190822.16953-8-bart.vanassche@sandisk.com>
 <20170110190822.16953-9-bart.vanassche@sandisk.com>
 <20170110190822.16953-10-bart.vanassche@sandisk.com>
 <20170110190822.16953-11-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170110190822.16953-11-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Change do_complete() such that an error completion is not only
generated if a QP is in the error state but also if a work request
failed.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_comp.c | 11 ++++++++++-
 drivers/infiniband/sw/rxe/rxe_loc.h  |  1 +
 drivers/infiniband/sw/rxe/rxe_req.c  | 18 +++++++-----------
 drivers/infiniband/sw/rxe/rxe_resp.c |  4 ++--
 4 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c b/drivers/infiniband/sw/rxe/rxe_comp.c
index 6769a075501e..91317c159b9a 100644
--- a/drivers/infiniband/sw/rxe/rxe_comp.c
+++ b/drivers/infiniband/sw/rxe/rxe_comp.c
@@ -412,13 +412,21 @@ static void make_send_cqe(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
 	}
 }
 
+/*
+ * IBA Spec. Section 10.7.3.1 SIGNALED COMPLETIONS
+ * ---------8<---------8<-------------
+ * ...Note that if a completion error occurs, a Work Completion
+ * will always be generated, even if the signaling
+ * indicator requests an Unsignaled Completion.
+ * ---------8<---------8<-------------
+ */
 static void do_complete(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
 {
 	struct rxe_cqe cqe;
 
 	if ((qp->sq_sig_type == IB_SIGNAL_ALL_WR) ||
 	    (wqe->wr.send_flags & IB_SEND_SIGNALED) ||
-	    (qp->req.state == QP_STATE_ERROR)) {
+	    wqe->status != IB_WC_SUCCESS) {
 		make_send_cqe(qp, wqe, &cqe);
 		advance_consumer(qp->sq.queue);
 		rxe_cq_post(qp->scq, &cqe, 0);
@@ -709,6 +717,7 @@ int rxe_completer(void *arg)
 			break;
 
 		case COMPST_ERROR:
+			WARN_ON_ONCE(wqe->status == IB_WC_SUCCESS);
 			do_complete(qp, wqe);
 			rxe_qp_error(qp);
 
diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index da191d7acb6f..bdec460f1fce 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -225,6 +225,7 @@ extern struct ib_dma_mapping_ops rxe_dma_mapping_ops;
 
 void rxe_release(struct kref *kref);
 
+void rxe_drain_req_pkts(struct rxe_qp *qp, bool notify);
 int rxe_completer(void *arg);
 int rxe_requester(void *arg);
 int rxe_responder(void *arg);
diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index 310cd3350578..d62be4828899 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -594,9 +594,14 @@ int rxe_requester(void *arg)
 	rxe_add_ref(qp);
 
 next_wqe:
-	if (unlikely(!qp->valid || qp->req.state == QP_STATE_ERROR))
+	if (unlikely(!qp->valid))
 		goto exit;
 
+	if (unlikely(qp->req.state == QP_STATE_ERROR)) {
+		rxe_drain_req_pkts(qp, true);
+		goto exit;
+	}
+
 	if (unlikely(qp->req.state == QP_STATE_RESET)) {
 		qp->req.wqe_index = consumer_index(qp->sq.queue);
 		qp->req.opcode = -1;
@@ -743,17 +748,8 @@ int rxe_requester(void *arg)
 	kfree_skb(skb);
 	wqe->status = IB_WC_LOC_PROT_ERR;
 	wqe->state = wqe_state_error;
-
-	/*
-	 * IBA Spec. Section 10.7.3.1 SIGNALED COMPLETIONS
-	 * ---------8<---------8<-------------
-	 * ...Note that if a completion error occurs, a Work Completion
-	 * will always be generated, even if the signaling
-	 * indicator requests an Unsignaled Completion.
-	 * ---------8<---------8<-------------
-	 */
-	wqe->wr.send_flags |= IB_SEND_SIGNALED;
 	__rxe_do_task(&qp->comp.task);
+
 exit:
 	rxe_drop_ref(qp);
 	return -EAGAIN;
diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 51c134dbc6c8..33defaddc000 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -1207,7 +1207,7 @@ static enum resp_states do_class_d1e_error(struct rxe_qp *qp)
 	}
 }
 
-static void rxe_drain_req_pkts(struct rxe_qp *qp)
+void rxe_drain_req_pkts(struct rxe_qp *qp, bool notify)
 {
 	struct sk_buff *skb;
 
@@ -1388,7 +1388,7 @@ int rxe_responder(void *arg)
 			goto exit;
 
 		case RESPST_RESET:
-			rxe_drain_req_pkts(qp);
+			rxe_drain_req_pkts(qp, false);
 			qp->resp.wqe = NULL;
 			goto exit;
 
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
