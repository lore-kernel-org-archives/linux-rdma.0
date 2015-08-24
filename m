From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] svcrdma: remove dead code
Date: Mon, 24 Aug 2015 18:58:51 +0300
Message-ID: <1440431931-24738-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

No one is calling svc_rdma_fastreg. remove it.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/linux/sunrpc/svc_rdma.h          |    1 -
 net/sunrpc/xprtrdma/svc_rdma_transport.c |   34 ------------------------------
 2 files changed, 0 insertions(+), 35 deletions(-)

diff --git a/include/linux/sunrpc/svc_rdma.h b/include/linux/sunrpc/svc_rdma.h
index cb94ee4..fa5b5eb 100644
--- a/include/linux/sunrpc/svc_rdma.h
+++ b/include/linux/sunrpc/svc_rdma.h
@@ -225,7 +225,6 @@ extern void svc_rdma_put_context(struct svc_rdma_op_ctxt *, int);
 extern void svc_rdma_unmap_dma(struct svc_rdma_op_ctxt *ctxt);
 extern struct svc_rdma_req_map *svc_rdma_get_req_map(void);
 extern void svc_rdma_put_req_map(struct svc_rdma_req_map *);
-extern int svc_rdma_fastreg(struct svcxprt_rdma *, struct svc_rdma_fastreg_mr *);
 extern struct svc_rdma_fastreg_mr *svc_rdma_get_frmr(struct svcxprt_rdma *);
 extern void svc_rdma_put_frmr(struct svcxprt_rdma *,
 			      struct svc_rdma_fastreg_mr *);
diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index a0aa2d7..0e010fe 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -1201,40 +1201,6 @@ static int svc_rdma_secure_port(struct svc_rqst *rqstp)
 	return 1;
 }
 
-/*
- * Attempt to register the kvec representing the RPC memory with the
- * device.
- *
- * Returns:
- *  NULL : The device does not support fastreg or there were no more
- *         fastreg mr.
- *  frmr : The kvec register request was successfully posted.
- *    <0 : An error was encountered attempting to register the kvec.
- */
-int svc_rdma_fastreg(struct svcxprt_rdma *xprt,
-		     struct svc_rdma_fastreg_mr *frmr)
-{
-	struct ib_fast_reg_wr fastreg_wr;
-	u8 key;
-
-	/* Bump the key */
-	key = (u8)(frmr->mr->lkey & 0x000000FF);
-	ib_update_fast_reg_key(frmr->mr, ++key);
-
-	/* Prepare FASTREG WR */
-	memset(&fastreg_wr, 0, sizeof fastreg_wr);
-	fastreg_wr.wr.opcode = IB_WR_FAST_REG_MR;
-	fastreg_wr.wr.send_flags = IB_SEND_SIGNALED;
-	fastreg_wr.iova_start = (unsigned long)frmr->kva;
-	fastreg_wr.page_list = frmr->page_list;
-	fastreg_wr.page_list_len = frmr->page_list_len;
-	fastreg_wr.page_shift = PAGE_SHIFT;
-	fastreg_wr.length = frmr->map_len;
-	fastreg_wr.access_flags = frmr->access_flags;
-	fastreg_wr.rkey = frmr->mr->lkey;
-	return svc_rdma_send(xprt, &fastreg_wr.wr);
-}
-
 int svc_rdma_send(struct svcxprt_rdma *xprt, struct ib_send_wr *wr)
 {
 	struct ib_send_wr *bad_wr, *n_wr;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
