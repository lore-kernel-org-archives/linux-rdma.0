From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 05/10] svcrdma: Find rmsgp more reliably
Date: Tue, 13 Jan 2015 11:03:11 -0500
Message-ID: <20150113160311.8118.87208.stgit@klimt.1015granger.net>
References: <20150113155904.8118.57718.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150113155904.8118.57718.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

xdr_start() can return the wrong rmsgp address if an assumption
about how the xdr_buf was constructed changes.  When it gets it
wrong, the client receives a reply that has gibberish in the
RPC/RDMA header, preventing it from matching a waiting RPC request.

Instead, make (and document) just one assumption: that the RDMA
header for the client's RPC call is at the start of the first page
in rq_pages.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---

 net/sunrpc/xprtrdma/svc_rdma_sendto.c |   18 ++++--------------
 1 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_sendto.c b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
index 7d79897..7de33d1 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
@@ -483,18 +483,6 @@ void svc_rdma_prep_reply_hdr(struct svc_rqst *rqstp)
 {
 }
 
-/*
- * Return the start of an xdr buffer.
- */
-static void *xdr_start(struct xdr_buf *xdr)
-{
-	return xdr->head[0].iov_base -
-		(xdr->len -
-		 xdr->page_len -
-		 xdr->tail[0].iov_len -
-		 xdr->head[0].iov_len);
-}
-
 int svc_rdma_sendto(struct svc_rqst *rqstp)
 {
 	struct svc_xprt *xprt = rqstp->rq_xprt;
@@ -512,8 +500,10 @@ int svc_rdma_sendto(struct svc_rqst *rqstp)
 
 	dprintk("svcrdma: sending response for rqstp=%p\n", rqstp);
 
-	/* Get the RDMA request header. */
-	rdma_argp = xdr_start(&rqstp->rq_arg);
+	/* Get the RDMA request header. The receive logic always
+	 * places this at the start of page 0.
+	 */
+	rdma_argp = page_address(rqstp->rq_pages[0]);
 
 	/* Build an req vec for the XDR */
 	ctxt = svc_rdma_get_context(rdma);

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
