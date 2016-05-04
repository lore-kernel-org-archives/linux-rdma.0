From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 6/9] svcrdma: Drain QP before freeing svcrdma_xprt
Date: Wed, 04 May 2016 10:53:30 -0400
Message-ID: <20160504145330.6602.53005.stgit@klimt.1015granger.net>
References: <20160504144730.6602.89073.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160504144730.6602.89073.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If the server has forced a disconnect, the associated QP has not
been moved to the Error state, and thus Receives are still posted.

Ensure Receives (and any other outstanding WRs) are drained to
release resources that can be freed during teardown of the
svcrdma_xprt.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/svc_rdma_transport.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 02a112c..dd94401 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -1180,6 +1180,9 @@ static void __svc_rdma_free(struct work_struct *work)
 
 	dprintk("svcrdma: %s(%p)\n", __func__, rdma);
 
+	if (rdma->sc_qp && !IS_ERR(rdma->sc_qp))
+		ib_drain_qp(rdma->sc_qp);
+
 	/* We should only be called from kref_put */
 	if (atomic_read(&xprt->xpt_ref.refcount) != 0)
 		pr_err("svcrdma: sc_xprt still in use? (%d)\n",

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
