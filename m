From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc V1 3/4] IB/rxe: Fix race condition between requester and completer
Date: Wed,  7 Sep 2016 14:04:06 +0300
Message-ID: <1473246247-16536-4-git-send-email-leon@kernel.org>
References: <1473246247-16536-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473246247-16536-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

rxe_requester() is sending a pkt with rxe_xmit_packet() and
then calls rxe_update() to update the wqe and qp's psn values.
But sometimes the response is received before the requester
had time to update the wqe in which case the completer
acts on errornous wqe values.
This fix updates the wqe and qp before actually sending
the request and rolls back when xmit fails.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_req.c | 57 ++++++++++++++++++++++++++++---------
 1 file changed, 44 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index 33b2d9d..13a848a 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -511,24 +511,21 @@ static int fill_packet(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
 }

 static void update_wqe_state(struct rxe_qp *qp,
-			     struct rxe_send_wqe *wqe,
-			     struct rxe_pkt_info *pkt,
-			     enum wqe_state *prev_state)
+		struct rxe_send_wqe *wqe,
+		struct rxe_pkt_info *pkt)
 {
-	enum wqe_state prev_state_ = wqe->state;
-
 	if (pkt->mask & RXE_END_MASK) {
 		if (qp_type(qp) == IB_QPT_RC)
 			wqe->state = wqe_state_pending;
 	} else {
 		wqe->state = wqe_state_processing;
 	}
-
-	*prev_state = prev_state_;
 }

-static void update_state(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
-			 struct rxe_pkt_info *pkt, int payload)
+static void update_wqe_psn(struct rxe_qp *qp,
+			   struct rxe_send_wqe *wqe,
+			   struct rxe_pkt_info *pkt,
+			   int payload)
 {
 	/* number of packets left to send including current one */
 	int num_pkt = (wqe->dma.resid + payload + qp->mtu - 1) / qp->mtu;
@@ -546,9 +543,34 @@ static void update_state(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
 		qp->req.psn = (wqe->first_psn + num_pkt) & BTH_PSN_MASK;
 	else
 		qp->req.psn = (qp->req.psn + 1) & BTH_PSN_MASK;
+}

-	qp->req.opcode = pkt->opcode;
+static void save_state(struct rxe_send_wqe *wqe,
+		       struct rxe_qp *qp,
+		       struct rxe_send_wqe *rollback_wqe,
+		       struct rxe_qp *rollback_qp)
+{
+	rollback_wqe->state     = wqe->state;
+	rollback_wqe->first_psn = wqe->first_psn;
+	rollback_wqe->last_psn  = wqe->last_psn;
+	rollback_qp->req.psn    = qp->req.psn;
+}

+static void rollback_state(struct rxe_send_wqe *wqe,
+			   struct rxe_qp *qp,
+			   struct rxe_send_wqe *rollback_wqe,
+			   struct rxe_qp *rollback_qp)
+{
+	wqe->state     = rollback_wqe->state;
+	wqe->first_psn = rollback_wqe->first_psn;
+	wqe->last_psn  = rollback_wqe->last_psn;
+	qp->req.psn    = rollback_qp->req.psn;
+}
+
+static void update_state(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
+			 struct rxe_pkt_info *pkt, int payload)
+{
+	qp->req.opcode = pkt->opcode;

 	if (pkt->mask & RXE_END_MASK)
 		qp->req.wqe_index = next_index(qp->sq.queue, qp->req.wqe_index);
@@ -571,7 +593,8 @@ int rxe_requester(void *arg)
 	int mtu;
 	int opcode;
 	int ret;
-	enum wqe_state prev_state;
+	struct rxe_qp rollback_qp;
+	struct rxe_send_wqe rollback_wqe;

 next_wqe:
 	if (unlikely(!qp->valid || qp->req.state == QP_STATE_ERROR))
@@ -688,13 +711,21 @@ next_wqe:
 		goto err;
 	}

-	update_wqe_state(qp, wqe, &pkt, &prev_state);
+	/*
+	 * To prevent a race on wqe access between requester and completer,
+	 * wqe members state and psn need to be set before calling
+	 * rxe_xmit_packet().
+	 * Otherwise, completer might initiate an unjustified retry flow.
+	 */
+	save_state(wqe, qp, &rollback_wqe, &rollback_qp);
+	update_wqe_state(qp, wqe, &pkt);
+	update_wqe_psn(qp, wqe, &pkt, payload);
 	ret = rxe_xmit_packet(to_rdev(qp->ibqp.device), qp, &pkt, skb);
 	if (ret) {
 		qp->need_req_skb = 1;
 		kfree_skb(skb);

-		wqe->state = prev_state;
+		rollback_state(wqe, qp, &rollback_wqe, &rollback_qp);

 		if (ret == -EAGAIN) {
 			rxe_run_task(&qp->req.task, 1);
--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
