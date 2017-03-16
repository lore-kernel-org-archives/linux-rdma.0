From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 11/14] svcrdma: Remove old RDMA Write completion handlers
Date: Thu, 16 Mar 2017 11:53:55 -0400
Message-ID: <20170316155355.4482.35026.stgit@klimt.1015granger.net>
References: <20170316154132.4482.56769.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170316154132.4482.56769.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up. RDMA Write completions are now handled by the rdma_rw API.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 include/linux/sunrpc/svc_rdma.h          |    1 -
 net/sunrpc/xprtrdma/svc_rdma_transport.c |   18 ------------------
 2 files changed, 19 deletions(-)

diff --git a/include/linux/sunrpc/svc_rdma.h b/include/linux/sunrpc/svc_rdma.h
index 6b60f2e..e526c55 100644
--- a/include/linux/sunrpc/svc_rdma.h
+++ b/include/linux/sunrpc/svc_rdma.h
@@ -258,7 +258,6 @@ extern void svc_rdma_build_send_wr(struct svc_rdma_op_ctxt *ctxt,
 
 /* svc_rdma_transport.c */
 extern void svc_rdma_wc_send(struct ib_cq *, struct ib_wc *);
-extern void svc_rdma_wc_write(struct ib_cq *, struct ib_wc *);
 extern void svc_rdma_wc_reg(struct ib_cq *, struct ib_wc *);
 extern void svc_rdma_wc_read(struct ib_cq *, struct ib_wc *);
 extern void svc_rdma_wc_inv(struct ib_cq *, struct ib_wc *);
diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index fecf220..8ce68bf 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -473,24 +473,6 @@ void svc_rdma_wc_send(struct ib_cq *cq, struct ib_wc *wc)
 }
 
 /**
- * svc_rdma_wc_write - Invoked by RDMA provider for each polled Write WC
- * @cq:        completion queue
- * @wc:        completed WR
- *
- */
-void svc_rdma_wc_write(struct ib_cq *cq, struct ib_wc *wc)
-{
-	struct ib_cqe *cqe = wc->wr_cqe;
-	struct svc_rdma_op_ctxt *ctxt;
-
-	svc_rdma_send_wc_common_put(cq, wc, "write");
-
-	ctxt = container_of(cqe, struct svc_rdma_op_ctxt, cqe);
-	svc_rdma_unmap_dma(ctxt);
-	svc_rdma_put_context(ctxt, 0);
-}
-
-/**
  * svc_rdma_wc_reg - Invoked by RDMA provider for each polled FASTREG WC
  * @cq:        completion queue
  * @wc:        completed WR

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
