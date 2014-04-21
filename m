From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V2 16/17] xprtrdma: Limit work done by completion handler
Date: Mon, 21 Apr 2014 18:03:08 -0400
Message-ID: <20140421220308.12569.43779.stgit@manet.1015granger.net>
References: <20140421214442.12569.8950.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140421214442.12569.8950.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> points out that a steady
stream of CQ events could starve other work because of the boundless
loop pooling in rpcrdma_{send,recv}_poll().

Instead of a (potentially infinite) while loop, return after
collecting a budgeted number of completions.

Note that the total number of WCs that can be handled during one
upcall is RPCRDMA_WC_BUDGET * 2, since the handler polls once before
and once after re-enabling completion notifications.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---

 net/sunrpc/xprtrdma/verbs.c     |   10 ++++++----
 net/sunrpc/xprtrdma/xprt_rdma.h |    1 +
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index abb8d8d..d46bdee 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -165,8 +165,9 @@ static int
 rpcrdma_sendcq_poll(struct ib_cq *cq, struct rpcrdma_ep *ep)
 {
 	struct ib_wc *wcs;
-	int count, rc;
+	int budget, count, rc;
 
+	budget = RPCRDMA_WC_BUDGET / RPCRDMA_POLLSIZE;
 	do {
 		wcs = ep->rep_send_wcs;
 
@@ -177,7 +178,7 @@ rpcrdma_sendcq_poll(struct ib_cq *cq, struct rpcrdma_ep *ep)
 		count = rc;
 		while (count-- > 0)
 			rpcrdma_sendcq_process_wc(wcs++);
-	} while (rc == RPCRDMA_POLLSIZE);
+	} while (rc == RPCRDMA_POLLSIZE && --budget);
 	return 0;
 }
 
@@ -254,8 +255,9 @@ static int
 rpcrdma_recvcq_poll(struct ib_cq *cq, struct rpcrdma_ep *ep)
 {
 	struct ib_wc *wcs;
-	int count, rc;
+	int budget, count, rc;
 
+	budget = RPCRDMA_WC_BUDGET / RPCRDMA_POLLSIZE;
 	do {
 		wcs = ep->rep_recv_wcs;
 
@@ -266,7 +268,7 @@ rpcrdma_recvcq_poll(struct ib_cq *cq, struct rpcrdma_ep *ep)
 		count = rc;
 		while (count-- > 0)
 			rpcrdma_recvcq_process_wc(wcs++);
-	} while (rc == RPCRDMA_POLLSIZE);
+	} while (rc == RPCRDMA_POLLSIZE && --budget);
 	return 0;
 }
 
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index cb4c882..0c3b88e 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -74,6 +74,7 @@ struct rpcrdma_ia {
  * RDMA Endpoint -- one per transport instance
  */
 
+#define RPCRDMA_WC_BUDGET	(128)
 #define RPCRDMA_POLLSIZE	(16)
 
 struct rpcrdma_ep {

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
