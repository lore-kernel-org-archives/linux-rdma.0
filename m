From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 05/21] xprtrdma: On disconnect, don't ignore pending CQEs
Date: Tue, 29 Jul 2014 17:23:52 -0400
Message-ID: <20140729212352.2812.99981.stgit@manet.1015granger.net>
References: <20140729211534.2812.3128.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140729211534.2812.3128.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

xprtrdma is currently throwing away queued completions during
a reconnect. RPC replies posted just before connection loss, or
successful completions that change the state of an FRMR, can be
missed.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Tested-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Tested-by: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Tested-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/verbs.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 0d5187d..7fd457e 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -310,6 +310,13 @@ rpcrdma_recvcq_upcall(struct ib_cq *cq, void *cq_context)
 	rpcrdma_recvcq_poll(cq, ep);
 }
 
+static void
+rpcrdma_flush_cqs(struct rpcrdma_ep *ep)
+{
+	rpcrdma_recvcq_upcall(ep->rep_attr.recv_cq, ep);
+	rpcrdma_sendcq_upcall(ep->rep_attr.send_cq, ep);
+}
+
 #ifdef RPC_DEBUG
 static const char * const conn[] = {
 	"address resolved",
@@ -872,9 +879,7 @@ retry:
 		if (rc && rc != -ENOTCONN)
 			dprintk("RPC:       %s: rpcrdma_ep_disconnect"
 				" status %i\n", __func__, rc);
-
-		rpcrdma_clean_cq(ep->rep_attr.recv_cq);
-		rpcrdma_clean_cq(ep->rep_attr.send_cq);
+		rpcrdma_flush_cqs(ep);
 
 		xprt = container_of(ia, struct rpcrdma_xprt, rx_ia);
 		id = rpcrdma_create_id(xprt, ia,
@@ -985,8 +990,7 @@ rpcrdma_ep_disconnect(struct rpcrdma_ep *ep, struct rpcrdma_ia *ia)
 {
 	int rc;
 
-	rpcrdma_clean_cq(ep->rep_attr.recv_cq);
-	rpcrdma_clean_cq(ep->rep_attr.send_cq);
+	rpcrdma_flush_cqs(ep);
 	rc = rdma_disconnect(ia->ri_id);
 	if (!rc) {
 		/* returns without wait if not connected */

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
