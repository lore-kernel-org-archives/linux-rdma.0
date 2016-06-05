From: Sudip Mukherjee <sudipm.mukherjee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/core: remove dead code
Date: Sun,  5 Jun 2016 21:45:52 +0100
Message-ID: <1465159552-11833-1-git-send-email-sudipm.mukherjee@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sudip Mukherjee <sudipm.mukherjee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

prot_sg_cnt has been assigned with the value of ret which we have
already checked to be non-zero so prot_sg_cnt can never be zero at this
point of the code and hence the else part can never execute.

Signed-off-by: Sudip Mukherjee <sudip.mukherjee-4yDnlxn2s6sWdaTGBSpHTA@public.gmane.org>
---
 drivers/infiniband/core/rw.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
index 1eb9b12..644589b 100644
--- a/drivers/infiniband/core/rw.c
+++ b/drivers/infiniband/core/rw.c
@@ -398,8 +398,6 @@ int rdma_rw_ctx_signature_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
 		else
 			prev_wr->next = &ctx->sig->prot.reg_wr.wr;
 		prev_wr = &ctx->sig->prot.reg_wr.wr;
-	} else {
-		ctx->sig->prot.mr = NULL;
 	}
 
 	ctx->sig->sig_mr = ib_mr_pool_get(qp, &qp->sig_mrs);
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
