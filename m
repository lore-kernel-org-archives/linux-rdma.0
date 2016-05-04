From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 5/9] svcrdma: Post Receives only for forward channel
 requests
Date: Wed, 04 May 2016 10:53:22 -0400
Message-ID: <20160504145322.6602.71848.stgit@klimt.1015granger.net>
References: <20160504144730.6602.89073.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160504144730.6602.89073.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Since backward direction support was added, the rq_depth was
increased to accommodate both forward and backward Receives.

But only forward Receives need to be posted after a connection
has been accepted. Receives for backward replies are posted as
needed by svc_rdma_bc_sendto().

This doesn't break anything, but it means some resources are
wasted.

Fixes: 03fe9931536f ('svcrdma: Define maximum number of ...')
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/svc_rdma_transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index d2680b8..02a112c 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -1083,7 +1083,7 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 		newxprt->sc_dev_caps |= SVCRDMA_DEVCAP_READ_W_INV;
 
 	/* Post receive buffers */
-	for (i = 0; i < newxprt->sc_rq_depth; i++) {
+	for (i = 0; i < newxprt->sc_max_requests; i++) {
 		ret = svc_rdma_post_recv(newxprt, GFP_KERNEL);
 		if (ret) {
 			dprintk("svcrdma: failure posting receive buffers\n");

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
