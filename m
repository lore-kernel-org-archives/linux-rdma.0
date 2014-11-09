From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 05/10] xprtrdma: Re-write rpcrdma_flush_cqs()
Date: Sat, 08 Nov 2014 20:14:45 -0500
Message-ID: <20141109011445.8806.70952.stgit@manet.1015granger.net>
References: <20141109010328.8806.5861.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141109010328.8806.5861.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Currently rpcrdma_flush_cqs() attempts to avoid code duplication,
and simply invokes rpcrdma_recvcq_upcall and rpcrdma_sendcq_upcall.

1. rpcrdma_flush_cqs() can run concurrently with provider upcalls.
   Both flush_cqs() and the upcalls were invoking ib_poll_cq() in
   different threads using the same wc buffers (ep->rep_recv_wcs
   and ep->rep_send_wcs), added by commit 1c00dd077654 ("xprtrmda:
   Reduce calls to ib_poll_cq() in completion handlers").

   During transport disconnect processing, this sometimes resulted
   in the same reply getting added to the rpcrdma_tasklets_g list
   more than once, which corrupted the list.

2. The upcall functions drain only a limited number of CQEs,
   thanks to the poll budget added by commit 8301a2c047cc
   ("xprtrdma: Limit work done by completion handler").

Fixes: a7bc211ac926 ("xprtrdma: On disconnect, don't ignore ... ")
BugLink: https://bugzilla.linux-nfs.org/show_bug.cgi?id=276
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/verbs.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 478b2fd..e6ac964 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -317,8 +317,15 @@ rpcrdma_recvcq_upcall(struct ib_cq *cq, void *cq_context)
 static void
 rpcrdma_flush_cqs(struct rpcrdma_ep *ep)
 {
-	rpcrdma_recvcq_upcall(ep->rep_attr.recv_cq, ep);
-	rpcrdma_sendcq_upcall(ep->rep_attr.send_cq, ep);
+	struct ib_wc wc;
+	LIST_HEAD(sched_list);
+
+	while (ib_poll_cq(ep->rep_attr.recv_cq, 1, &wc) > 0)
+		rpcrdma_recvcq_process_wc(&wc, &sched_list);
+	if (!list_empty(&sched_list))
+		rpcrdma_schedule_tasklet(&sched_list);
+	while (ib_poll_cq(ep->rep_attr.send_cq, 1, &wc) > 0)
+		rpcrdma_sendcq_process_wc(&wc);
 }
 
 #ifdef RPC_DEBUG

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
