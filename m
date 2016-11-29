From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 06/10] svcrdma: Remove svc_rdma_op_ctxt::wc_status
Date: Tue, 29 Nov 2016 11:05:07 -0500
Message-ID: <20161129160507.4477.60847.stgit@klimt.1015granger.net>
References: <20161129155521.4477.53561.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161129155521.4477.53561.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up: Completion status is already reported in the individual
completion handlers. Save a few bytes in struct svc_rdma_op_ctxt.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 include/linux/sunrpc/svc_rdma.h          |    1 -
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c  |    4 ++--
 net/sunrpc/xprtrdma/svc_rdma_transport.c |    1 -
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/linux/sunrpc/svc_rdma.h b/include/linux/sunrpc/svc_rdma.h
index 43d7c70..757fb96 100644
--- a/include/linux/sunrpc/svc_rdma.h
+++ b/include/linux/sunrpc/svc_rdma.h
@@ -79,7 +79,6 @@ struct svc_rdma_op_ctxt {
 	struct ib_cqe reg_cqe;
 	struct ib_cqe inv_cqe;
 	struct list_head dto_q;
-	enum ib_wc_status wc_status;
 	u32 byte_len;
 	u32 position;
 	struct svcxprt_rdma *xprt;
diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index 283246e..428ab4ef 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -640,8 +640,8 @@ int svc_rdma_recvfrom(struct svc_rqst *rqstp)
 			goto defer;
 		goto out;
 	}
-	dprintk("svcrdma: processing ctxt=%p on xprt=%p, rqstp=%p, status=%d\n",
-		ctxt, rdma_xprt, rqstp, ctxt->wc_status);
+	dprintk("svcrdma: processing ctxt=%p on xprt=%p, rqstp=%p\n",
+		ctxt, rdma_xprt, rqstp);
 	atomic_inc(&rdma_stat_recv);
 
 	/* Build up the XDR from the receive buffers. */
diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 61ae392..733d6e03 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -395,7 +395,6 @@ static void svc_rdma_wc_receive(struct ib_cq *cq, struct ib_wc *wc)
 
 	/* WARNING: Only wc->wr_cqe and wc->status are reliable */
 	ctxt = container_of(cqe, struct svc_rdma_op_ctxt, cqe);
-	ctxt->wc_status = wc->status;
 	svc_rdma_unmap_dma(ctxt);
 
 	if (wc->status != IB_WC_SUCCESS)

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
