From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 07/16] xprtrdma: Remove reply tasklet
Date: Fri, 16 Oct 2015 09:24:58 -0400
Message-ID: <20151016132458.6819.77455.stgit@oracle-122.nfsv4bat.org>
References: <20151016131958.6819.98407.stgit@oracle-122.nfsv4bat.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151016131958.6819.98407.stgit-SEkpj4eus7zuCzdexAEDLOpQh6Td+b7Z@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up: The reply tasklet is no longer used.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Tested-By: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
---
 net/sunrpc/xprtrdma/verbs.c |   43 -------------------------------------------
 1 file changed, 43 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index cf2f5b3..a4102fc 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -68,38 +68,6 @@
  * internal functions
  */
 
-/*
- * handle replies in tasklet context, using a single, global list
- * rdma tasklet function -- just turn around and call the func
- * for all replies on the list
- */
-
-static DEFINE_SPINLOCK(rpcrdma_tk_lock_g);
-static LIST_HEAD(rpcrdma_tasklets_g);
-
-static void
-rpcrdma_run_tasklet(unsigned long data)
-{
-	struct rpcrdma_rep *rep;
-	unsigned long flags;
-
-	data = data;
-	spin_lock_irqsave(&rpcrdma_tk_lock_g, flags);
-	while (!list_empty(&rpcrdma_tasklets_g)) {
-		rep = list_entry(rpcrdma_tasklets_g.next,
-				 struct rpcrdma_rep, rr_list);
-		list_del(&rep->rr_list);
-		spin_unlock_irqrestore(&rpcrdma_tk_lock_g, flags);
-
-		rpcrdma_reply_handler(rep);
-
-		spin_lock_irqsave(&rpcrdma_tk_lock_g, flags);
-	}
-	spin_unlock_irqrestore(&rpcrdma_tk_lock_g, flags);
-}
-
-static DECLARE_TASKLET(rpcrdma_tasklet_g, rpcrdma_run_tasklet, 0UL);
-
 static struct workqueue_struct *rpcrdma_receive_wq;
 
 int
@@ -130,17 +98,6 @@ rpcrdma_destroy_wq(void)
 }
 
 static void
-rpcrdma_schedule_tasklet(struct list_head *sched_list)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&rpcrdma_tk_lock_g, flags);
-	list_splice_tail(sched_list, &rpcrdma_tasklets_g);
-	spin_unlock_irqrestore(&rpcrdma_tk_lock_g, flags);
-	tasklet_schedule(&rpcrdma_tasklet_g);
-}
-
-static void
 rpcrdma_qp_async_error_upcall(struct ib_event *event, void *context)
 {
 	struct rpcrdma_ep *ep = context;

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
