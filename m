From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 07/10] svcrdma: Eliminate code duplication in
 svc_rdma_recvfrom()
Date: Thu, 28 Apr 2016 11:15:26 -0400
Message-ID: <20160428151526.13068.26423.stgit@klimt.1015granger.net>
References: <20160428150915.13068.94602.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160428150915.13068.94602.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c |   26 +++++---------------------
 1 file changed, 5 insertions(+), 21 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index 12e7899..1b72f35 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -508,11 +508,10 @@ static int rdma_read_chunks(struct svcxprt_rdma *xprt,
 	return ret;
 }
 
-static int rdma_read_complete(struct svc_rqst *rqstp,
-			      struct svc_rdma_op_ctxt *head)
+static void rdma_read_complete(struct svc_rqst *rqstp,
+			       struct svc_rdma_op_ctxt *head)
 {
 	int page_no;
-	int ret;
 
 	/* Copy RPC pages */
 	for (page_no = 0; page_no < head->count; page_no++) {
@@ -548,23 +547,6 @@ static int rdma_read_complete(struct svc_rqst *rqstp,
 	rqstp->rq_arg.tail[0] = head->arg.tail[0];
 	rqstp->rq_arg.len = head->arg.len;
 	rqstp->rq_arg.buflen = head->arg.buflen;
-
-	/* Free the context */
-	svc_rdma_put_context(head, 0);
-
-	/* XXX: What should this be? */
-	rqstp->rq_prot = IPPROTO_MAX;
-	svc_xprt_copy_addrs(rqstp, rqstp->rq_xprt);
-
-	ret = rqstp->rq_arg.head[0].iov_len
-		+ rqstp->rq_arg.page_len
-		+ rqstp->rq_arg.tail[0].iov_len;
-	dprintk("svcrdma: deferred read ret=%d, rq_arg.len=%u, "
-		"rq_arg.head[0].iov_base=%p, rq_arg.head[0].iov_len=%zu\n",
-		ret, rqstp->rq_arg.len,	rqstp->rq_arg.head[0].iov_base,
-		rqstp->rq_arg.head[0].iov_len);
-
-	return ret;
 }
 
 /* By convention, backchannel calls arrive via rdma_msg type
@@ -622,7 +604,8 @@ int svc_rdma_recvfrom(struct svc_rqst *rqstp)
 				  dto_q);
 		list_del_init(&ctxt->dto_q);
 		spin_unlock_bh(&rdma_xprt->sc_rq_dto_lock);
-		return rdma_read_complete(rqstp, ctxt);
+		rdma_read_complete(rqstp, ctxt);
+		goto complete;
 	} else if (!list_empty(&rdma_xprt->sc_rq_dto_q)) {
 		ctxt = list_entry(rdma_xprt->sc_rq_dto_q.next,
 				  struct svc_rdma_op_ctxt,
@@ -680,6 +663,7 @@ int svc_rdma_recvfrom(struct svc_rqst *rqstp)
 		return 0;
 	}
 
+complete:
 	ret = rqstp->rq_arg.head[0].iov_len
 		+ rqstp->rq_arg.page_len
 		+ rqstp->rq_arg.tail[0].iov_len;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
