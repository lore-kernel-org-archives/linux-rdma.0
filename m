From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH v2] IB/core: remove dead code
Date: Mon,  6 Jun 2016 22:15:06 +0100
Message-ID: <1465247706-4418-1-git-send-email-sudipm.mukherjee@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Sudip Mukherjee <sudipm.mukherjee@gmail.com>, leon@kernel.org
List-Id: linux-rdma@vger.kernel.org

prot_sg_cnt has been assigned with the value of ret which we have
already checked to be non-zero so prot_sg_cnt can never be zero at this
point of the code and hence the else part can never execute.
And since we know prot_sg_cnt is non zero there is no use for the
if condition also.

Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
---
 drivers/infiniband/core/rw.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
index 1eb9b12..a829a14 100644
--- a/drivers/infiniband/core/rw.c
+++ b/drivers/infiniband/core/rw.c
@@ -386,21 +386,17 @@ int rdma_rw_ctx_signature_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
 	count += ret;
 	prev_wr = &ctx->sig->data.reg_wr.wr;
 
-	if (prot_sg_cnt) {
-		ret = rdma_rw_init_one_mr(qp, port_num, &ctx->sig->prot,
-				prot_sg, prot_sg_cnt, 0);
-		if (ret < 0)
-			goto out_destroy_data_mr;
-		count += ret;
+	ret = rdma_rw_init_one_mr(qp, port_num, &ctx->sig->prot,
+				  prot_sg, prot_sg_cnt, 0);
+	if (ret < 0)
+		goto out_destroy_data_mr;
+	count += ret;
 
-		if (ctx->sig->prot.inv_wr.next)
-			prev_wr->next = &ctx->sig->prot.inv_wr;
-		else
-			prev_wr->next = &ctx->sig->prot.reg_wr.wr;
-		prev_wr = &ctx->sig->prot.reg_wr.wr;
-	} else {
-		ctx->sig->prot.mr = NULL;
-	}
+	if (ctx->sig->prot.inv_wr.next)
+		prev_wr->next = &ctx->sig->prot.inv_wr;
+	else
+		prev_wr->next = &ctx->sig->prot.reg_wr.wr;
+	prev_wr = &ctx->sig->prot.reg_wr.wr;
 
 	ctx->sig->sig_mr = ib_mr_pool_get(qp, &qp->sig_mrs);
 	if (!ctx->sig->sig_mr) {
-- 
1.9.1
