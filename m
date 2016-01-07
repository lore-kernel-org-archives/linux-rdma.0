From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 02/10] svcrdma: Clean up process_context()
Date: Thu, 07 Jan 2016 14:49:03 -0500
Message-ID: <20160107194903.2662.66447.stgit@klimt.1015granger.net>
References: <20160107194251.2662.88158.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160107194251.2662.88158.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Be sure the completed ctxt is put in every path.

The xprt enqueue can take a while, so put the completed ctxt back
in circulation _before_ enqueuing the xprt.

Remove/disable debugging.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Acked-by: Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
---
 net/sunrpc/xprtrdma/svc_rdma_transport.c |   44 ++++++++++++++----------------
 1 file changed, 21 insertions(+), 23 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 45d1824..a100d56 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -386,46 +386,44 @@ static void rq_cq_reap(struct svcxprt_rdma *xprt)
 static void process_context(struct svcxprt_rdma *xprt,
 			    struct svc_rdma_op_ctxt *ctxt)
 {
+	struct svc_rdma_op_ctxt *read_hdr;
+	int free_pages = 0;
+
 	svc_rdma_unmap_dma(ctxt);
 
 	switch (ctxt->wr_op) {
 	case IB_WR_SEND:
-		if (ctxt->frmr)
-			pr_err("svcrdma: SEND: ctxt->frmr != NULL\n");
-		svc_rdma_put_context(ctxt, 1);
+		free_pages = 1;
 		break;
 
 	case IB_WR_RDMA_WRITE:
-		if (ctxt->frmr)
-			pr_err("svcrdma: WRITE: ctxt->frmr != NULL\n");
-		svc_rdma_put_context(ctxt, 0);
 		break;
 
 	case IB_WR_RDMA_READ:
 	case IB_WR_RDMA_READ_WITH_INV:
 		svc_rdma_put_frmr(xprt, ctxt->frmr);
-		if (test_bit(RDMACTXT_F_LAST_CTXT, &ctxt->flags)) {
-			struct svc_rdma_op_ctxt *read_hdr = ctxt->read_hdr;
-			if (read_hdr) {
-				spin_lock_bh(&xprt->sc_rq_dto_lock);
-				set_bit(XPT_DATA, &xprt->sc_xprt.xpt_flags);
-				list_add_tail(&read_hdr->dto_q,
-					      &xprt->sc_read_complete_q);
-				spin_unlock_bh(&xprt->sc_rq_dto_lock);
-			} else {
-				pr_err("svcrdma: ctxt->read_hdr == NULL\n");
-			}
-			svc_xprt_enqueue(&xprt->sc_xprt);
-		}
+
+		if (!test_bit(RDMACTXT_F_LAST_CTXT, &ctxt->flags))
+			break;
+
+		read_hdr = ctxt->read_hdr;
 		svc_rdma_put_context(ctxt, 0);
-		break;
+
+		spin_lock_bh(&xprt->sc_rq_dto_lock);
+		set_bit(XPT_DATA, &xprt->sc_xprt.xpt_flags);
+		list_add_tail(&read_hdr->dto_q,
+			      &xprt->sc_read_complete_q);
+		spin_unlock_bh(&xprt->sc_rq_dto_lock);
+		svc_xprt_enqueue(&xprt->sc_xprt);
+		return;
 
 	default:
-		printk(KERN_ERR "svcrdma: unexpected completion type, "
-		       "opcode=%d\n",
-		       ctxt->wr_op);
+		dprintk("svcrdma: unexpected completion opcode=%d\n",
+			ctxt->wr_op);
 		break;
 	}
+
+	svc_rdma_put_context(ctxt, free_pages);
 }
 
 /*

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
