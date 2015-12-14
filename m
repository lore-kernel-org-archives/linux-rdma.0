From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 08/11] svcrdma: Remove last two __GFP_NOFAIL call sites
Date: Mon, 14 Dec 2015 16:31:06 -0500
Message-ID: <20151214213106.12932.53222.stgit@klimt.1015granger.net>
References: <20151214211951.12932.99017.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151214211951.12932.99017.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up.

These functions can otherwise fail, so check for page allocation
failures too.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/svc_rdma_sendto.c    |    5 ++++-
 net/sunrpc/xprtrdma/svc_rdma_transport.c |    4 +++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_sendto.c b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
index 2d3d7a4..9221086 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
@@ -605,7 +605,10 @@ int svc_rdma_sendto(struct svc_rqst *rqstp)
 	inline_bytes = rqstp->rq_res.len;
 
 	/* Create the RDMA response header */
-	res_page = alloc_page(GFP_KERNEL | __GFP_NOFAIL);
+	ret = -ENOMEM;
+	res_page = alloc_page(GFP_KERNEL);
+	if (!res_page)
+		goto err0;
 	rdma_resp = page_address(res_page);
 	reply_ary = svc_rdma_get_reply_array(rdma_argp);
 	if (reply_ary)
diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 14b692d..694ade4 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -1445,7 +1445,9 @@ void svc_rdma_send_error(struct svcxprt_rdma *xprt, struct rpcrdma_msg *rmsgp,
 	int length;
 	int ret;
 
-	p = alloc_page(GFP_KERNEL | __GFP_NOFAIL);
+	p = alloc_page(GFP_KERNEL);
+	if (!p)
+		return;
 	va = page_address(p);
 
 	/* XDR encode error */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
