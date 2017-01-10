From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 10/15] IB/rxe: Introduce functions for queue draining
Date: Tue, 10 Jan 2017 11:08:17 -0800
Message-ID: <20170110190822.16953-11-bart.vanassche@sandisk.com>
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
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170110190822.16953-10-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This change makes the code easier to read and avoids that code is
duplicated.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_comp.c | 63 +++++++++++++-----------------------
 drivers/infiniband/sw/rxe/rxe_resp.c | 28 ++++++++--------
 2 files changed, 38 insertions(+), 53 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c b/drivers/infiniband/sw/rxe/rxe_comp.c
index e912e5396e8c..6769a075501e 100644
--- a/drivers/infiniband/sw/rxe/rxe_comp.c
+++ b/drivers/infiniband/sw/rxe/rxe_comp.c
@@ -503,57 +503,40 @@ static inline enum comp_state complete_wqe(struct rxe_qp *qp,
 	return COMPST_GET_WQE;
 }
 
-int rxe_completer(void *arg)
+static void rxe_drain_resp_pkts(struct rxe_qp *qp, bool notify)
 {
-	struct rxe_qp *qp = (struct rxe_qp *)arg;
-	struct rxe_send_wqe *wqe = wqe;
-	struct sk_buff *skb = NULL;
-	struct rxe_pkt_info *pkt = NULL;
-	enum comp_state state;
-
-	rxe_add_ref(qp);
-
-	if (!qp->valid) {
-		while ((skb = skb_dequeue(&qp->resp_pkts))) {
-			rxe_drop_ref(qp);
-			kfree_skb(skb);
-		}
-		skb = NULL;
-		pkt = NULL;
-
-		while (queue_head(qp->sq.queue))
-			advance_consumer(qp->sq.queue);
+	struct sk_buff *skb;
+	struct rxe_send_wqe *wqe;
 
-		goto exit;
+	while ((skb = skb_dequeue(&qp->resp_pkts))) {
+		rxe_drop_ref(qp);
+		kfree_skb(skb);
 	}
 
-	if (qp->req.state == QP_STATE_ERROR) {
-		while ((skb = skb_dequeue(&qp->resp_pkts))) {
-			rxe_drop_ref(qp);
-			kfree_skb(skb);
-		}
-		skb = NULL;
-		pkt = NULL;
-
-		while ((wqe = queue_head(qp->sq.queue))) {
+	while ((wqe = queue_head(qp->sq.queue))) {
+		if (notify) {
 			wqe->status = IB_WC_WR_FLUSH_ERR;
 			do_complete(qp, wqe);
+		} else {
+			advance_consumer(qp->sq.queue);
 		}
-
-		goto exit;
 	}
+}
 
-	if (qp->req.state == QP_STATE_RESET) {
-		while ((skb = skb_dequeue(&qp->resp_pkts))) {
-			rxe_drop_ref(qp);
-			kfree_skb(skb);
-		}
-		skb = NULL;
-		pkt = NULL;
+int rxe_completer(void *arg)
+{
+	struct rxe_qp *qp = (struct rxe_qp *)arg;
+	struct rxe_send_wqe *wqe = wqe;
+	struct sk_buff *skb = NULL;
+	struct rxe_pkt_info *pkt = NULL;
+	enum comp_state state;
 
-		while (queue_head(qp->sq.queue))
-			advance_consumer(qp->sq.queue);
+	rxe_add_ref(qp);
 
+	if (!qp->valid || qp->req.state == QP_STATE_ERROR ||
+	    qp->req.state == QP_STATE_RESET) {
+		rxe_drain_resp_pkts(qp, qp->valid &&
+				    qp->req.state == QP_STATE_ERROR);
 		goto exit;
 	}
 
diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 6dbd069689fc..51c134dbc6c8 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -1207,6 +1207,19 @@ static enum resp_states do_class_d1e_error(struct rxe_qp *qp)
 	}
 }
 
+static void rxe_drain_req_pkts(struct rxe_qp *qp)
+{
+	struct sk_buff *skb;
+
+	while ((skb = skb_dequeue(&qp->req_pkts))) {
+		rxe_drop_ref(qp);
+		kfree_skb(skb);
+	}
+
+	while (!qp->srq && qp->rq.queue && queue_head(qp->rq.queue))
+		advance_consumer(qp->rq.queue);
+}
+
 int rxe_responder(void *arg)
 {
 	struct rxe_qp *qp = (struct rxe_qp *)arg;
@@ -1374,21 +1387,10 @@ int rxe_responder(void *arg)
 
 			goto exit;
 
-		case RESPST_RESET: {
-			struct sk_buff *skb;
-
-			while ((skb = skb_dequeue(&qp->req_pkts))) {
-				rxe_drop_ref(qp);
-				kfree_skb(skb);
-			}
-
-			while (!qp->srq && qp->rq.queue &&
-			       queue_head(qp->rq.queue))
-				advance_consumer(qp->rq.queue);
-
+		case RESPST_RESET:
+			rxe_drain_req_pkts(qp);
 			qp->resp.wqe = NULL;
 			goto exit;
-		}
 
 		case RESPST_ERROR:
 			qp->resp.goto_error = 0;
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
