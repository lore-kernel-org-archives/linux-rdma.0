From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 18/21] xprtrdma: Schedule reply tasklet once per upcall
Date: Tue, 29 Jul 2014 17:25:46 -0400
Message-ID: <20140729212546.2812.82737.stgit@manet.1015granger.net>
References: <20140729211534.2812.3128.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140729211534.2812.3128.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Minor optimization: grab rpcrdma_tk_lock_g and disable hard IRQs
just once after clearing the receive completion queue.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Tested-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Tested-by: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Tested-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/verbs.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index a27edde..6980149 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -105,17 +105,6 @@ rpcrdma_run_tasklet(unsigned long data)
 
 static DECLARE_TASKLET(rpcrdma_tasklet_g, rpcrdma_run_tasklet, 0UL);
 
-static inline void
-rpcrdma_schedule_tasklet(struct rpcrdma_rep *rep)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&rpcrdma_tk_lock_g, flags);
-	list_add_tail(&rep->rr_list, &rpcrdma_tasklets_g);
-	spin_unlock_irqrestore(&rpcrdma_tk_lock_g, flags);
-	tasklet_schedule(&rpcrdma_tasklet_g);
-}
-
 static void
 rpcrdma_qp_async_error_upcall(struct ib_event *event, void *context)
 {
@@ -214,7 +203,7 @@ rpcrdma_sendcq_upcall(struct ib_cq *cq, void *cq_context)
 }
 
 static void
-rpcrdma_recvcq_process_wc(struct ib_wc *wc)
+rpcrdma_recvcq_process_wc(struct ib_wc *wc, struct list_head *sched_list)
 {
 	struct rpcrdma_rep *rep =
 			(struct rpcrdma_rep *)(unsigned long)wc->wr_id;
@@ -245,28 +234,38 @@ rpcrdma_recvcq_process_wc(struct ib_wc *wc)
 	}
 
 out_schedule:
-	rpcrdma_schedule_tasklet(rep);
+	list_add_tail(&rep->rr_list, sched_list);
 }
 
 static int
 rpcrdma_recvcq_poll(struct ib_cq *cq, struct rpcrdma_ep *ep)
 {
+	struct list_head sched_list;
 	struct ib_wc *wcs;
 	int budget, count, rc;
+	unsigned long flags;
 
+	INIT_LIST_HEAD(&sched_list);
 	budget = RPCRDMA_WC_BUDGET / RPCRDMA_POLLSIZE;
 	do {
 		wcs = ep->rep_recv_wcs;
 
 		rc = ib_poll_cq(cq, RPCRDMA_POLLSIZE, wcs);
 		if (rc <= 0)
-			return rc;
+			goto out_schedule;
 
 		count = rc;
 		while (count-- > 0)
-			rpcrdma_recvcq_process_wc(wcs++);
+			rpcrdma_recvcq_process_wc(wcs++, &sched_list);
 	} while (rc == RPCRDMA_POLLSIZE && --budget);
-	return 0;
+	rc = 0;
+
+out_schedule:
+	spin_lock_irqsave(&rpcrdma_tk_lock_g, flags);
+	list_splice_tail(&sched_list, &rpcrdma_tasklets_g);
+	spin_unlock_irqrestore(&rpcrdma_tk_lock_g, flags);
+	tasklet_schedule(&rpcrdma_tasklet_g);
+	return rc;
 }
 
 /*

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
