From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH resend] rxe: fix broken receive queue draining
Date: Tue, 27 Jun 2017 12:19:38 +0300
Message-ID: <1498555178-12106-1-git-send-email-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Vijay Immanuel <vijayi-R1PCaG5FPJG/3pe1ocb+swC/G2K4zDHf@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Vijay Immanuel <vijayi-R1PCaG5FPJG/3pe1ocb+swC/G2K4zDHf@public.gmane.org>

If we modified the qp to ERROR state, and
drained the recieve queue, post_recv must
trigger the responder task to complete
the drain work request.

Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Vijay Immanuel <vijayi-R1PCaG5FPJG/3pe1ocb+swC/G2K4zDHf@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_resp.c  | 3 +++
 drivers/infiniband/sw/rxe/rxe_verbs.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 23039768f541..f66b48c114ac 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -1217,6 +1217,9 @@ void rxe_drain_req_pkts(struct rxe_qp *qp, bool notify)
 		kfree_skb(skb);
 	}
 
+	if (notify)
+		return;
+
 	while (!qp->srq && qp->rq.queue && queue_head(qp->rq.queue))
 		advance_consumer(qp->rq.queue);
 }
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index 83d709e74dfb..94af4d67988b 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -919,6 +919,9 @@ static int rxe_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 
 	spin_unlock_irqrestore(&rq->producer_lock, flags);
 
+	if (qp->resp.state == QP_STATE_ERROR)
+		rxe_run_task(&qp->resp.task, 1);
+
 err1:
 	return err;
 }
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
