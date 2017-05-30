From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 08/17] svcrdma: Don't account for Receive queue
 "starvation"
Date: Tue, 30 May 2017 14:15:06 -0400
Message-ID: <20170530181506.2992.9237.stgit@klimt.1015granger.net>
References: <20170530175808.2992.60365.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170530175808.2992.60365.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>From what I can tell, calling ->recvfrom when there is no work to do
is a normal part of operation. This is the only way svc_recv can
tell when there is no more data ready to receive on the transport.

Neither the TCP nor the UDP transport implementations have a
"starve" metric.

The cost of receive starvation accounting is bumping an atomic, which
results in extra (IMO unnecessary) bus traffic between CPU sockets,
while holding a spin lock.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index b480893..1452bd0 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -844,9 +844,9 @@ int svc_rdma_recvfrom(struct svc_rqst *rqstp)
 	struct svc_xprt *xprt = rqstp->rq_xprt;
 	struct svcxprt_rdma *rdma_xprt =
 		container_of(xprt, struct svcxprt_rdma, sc_xprt);
-	struct svc_rdma_op_ctxt *ctxt = NULL;
+	struct svc_rdma_op_ctxt *ctxt;
 	struct rpcrdma_msg *rmsgp;
-	int ret = 0;
+	int ret;
 
 	dprintk("svcrdma: rqstp=%p\n", rqstp);
 
@@ -863,21 +863,13 @@ int svc_rdma_recvfrom(struct svc_rqst *rqstp)
 					struct svc_rdma_op_ctxt, list);
 		list_del(&ctxt->list);
 	} else {
-		atomic_inc(&rdma_stat_rq_starve);
+		/* No new incoming requests, terminate the loop */
 		clear_bit(XPT_DATA, &xprt->xpt_flags);
-		ctxt = NULL;
+		spin_unlock(&rdma_xprt->sc_rq_dto_lock);
+		return 0;
 	}
 	spin_unlock(&rdma_xprt->sc_rq_dto_lock);
-	if (!ctxt) {
-		/* This is the EAGAIN path. The svc_recv routine will
-		 * return -EAGAIN, the nfsd thread will go to call into
-		 * svc_recv again and we shouldn't be on the active
-		 * transport list
-		 */
-		if (test_bit(XPT_CLOSE, &xprt->xpt_flags))
-			goto defer;
-		goto out;
-	}
+
 	dprintk("svcrdma: processing ctxt=%p on xprt=%p, rqstp=%p\n",
 		ctxt, rdma_xprt, rqstp);
 	atomic_inc(&rdma_stat_recv);
@@ -920,7 +912,6 @@ int svc_rdma_recvfrom(struct svc_rqst *rqstp)
 		+ rqstp->rq_arg.page_len
 		+ rqstp->rq_arg.tail[0].iov_len;
 	svc_rdma_put_context(ctxt, 0);
- out:
 	dprintk("svcrdma: ret=%d, rq_arg.len=%u, "
 		"rq_arg.head[0].iov_base=%p, rq_arg.head[0].iov_len=%zd\n",
 		ret, rqstp->rq_arg.len,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
