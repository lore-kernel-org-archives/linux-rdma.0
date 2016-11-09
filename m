From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 1/7] svcrdma: Clear xpt_bc_xps in xprt_setup_rdma_bc()
 error exit arm
Date: Wed, 09 Nov 2016 12:33:46 -0500
Message-ID: <20161109173346.15735.31869.stgit@klimt.1015granger.net>
References: <20161109165814.15735.47815.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161109165814.15735.47815.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Logic copied from xs_setup_bc_tcp().

Fixes: 39a9beab5acb ('rpc: share one xps between all backchannels')
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_backchannel.c b/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
index 20027f8..6035c5a 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
@@ -359,6 +359,7 @@ static int svc_rdma_bc_sendto(struct svcxprt_rdma *rdma,
 out_fail:
 	xprt_rdma_free_addresses(xprt);
 	args->bc_xprt->xpt_bc_xprt = NULL;
+	args->bc_xprt->xpt_bc_xps = NULL;
 	xprt_put(xprt);
 	xprt_free(xprt);
 	return ERR_PTR(-EINVAL);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
