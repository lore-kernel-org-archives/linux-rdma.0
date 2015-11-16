From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 09/10] IB/iser: Increment the rkey when registering and not when invalidating
Date: Mon, 16 Nov 2015 18:37:40 +0200
Message-ID: <1447691861-3796-10-git-send-email-sagig@mellanox.com>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447691861-3796-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

With remote invalidate we won't local invalidate
but we still want to increment the rkey.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_memory.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index fb676ae25c42..52f64073037b 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -412,19 +412,14 @@ iser_set_prot_checks(struct scsi_cmnd *sc, u8 *mask)
 		*mask |= ISER_CHECK_GUARD;
 }
 
-static void
+static inline void
 iser_inv_rkey(struct ib_send_wr *inv_wr, struct ib_mr *mr)
 {
-	u32 rkey;
-
 	inv_wr->opcode = IB_WR_LOCAL_INV;
 	inv_wr->wr_id = ISER_FASTREG_LI_WRID;
 	inv_wr->ex.invalidate_rkey = mr->rkey;
 	inv_wr->send_flags = 0;
 	inv_wr->num_sge = 0;
-
-	rkey = ib_inc_rkey(mr->rkey);
-	ib_update_fast_reg_key(mr, rkey);
 }
 
 static int
@@ -437,6 +432,7 @@ iser_reg_sig_mr(struct iscsi_iser_task *iser_task,
 	struct iser_tx_desc *tx_desc = &iser_task->desc;
 	struct ib_sig_attrs *sig_attrs = &tx_desc->sig_attrs;
 	struct ib_sig_handover_wr *wr;
+	struct ib_mr *mr = pi_ctx->sig_mr;
 	int ret;
 
 	memset(sig_attrs, 0, sizeof(*sig_attrs));
@@ -447,7 +443,9 @@ iser_reg_sig_mr(struct iscsi_iser_task *iser_task,
 	iser_set_prot_checks(iser_task->sc, &sig_attrs->check_mask);
 
 	if (pi_ctx->sig_mr_valid)
-		iser_inv_rkey(iser_tx_next_wr(tx_desc), pi_ctx->sig_mr);
+		iser_inv_rkey(iser_tx_next_wr(tx_desc), mr);
+
+	ib_update_fast_reg_key(mr, ib_inc_rkey(mr->rkey));
 
 	wr = sig_handover_wr(iser_tx_next_wr(tx_desc));
 	wr->wr.opcode = IB_WR_REG_SIG_MR;
@@ -456,7 +454,7 @@ iser_reg_sig_mr(struct iscsi_iser_task *iser_task,
 	wr->wr.num_sge = 1;
 	wr->wr.send_flags = 0;
 	wr->sig_attrs = sig_attrs;
-	wr->sig_mr = pi_ctx->sig_mr;
+	wr->sig_mr = mr;
 	if (scsi_prot_sg_count(iser_task->sc))
 		wr->prot = &prot_reg->sge;
 	else
@@ -466,8 +464,8 @@ iser_reg_sig_mr(struct iscsi_iser_task *iser_task,
 			   IB_ACCESS_REMOTE_WRITE;
 	pi_ctx->sig_mr_valid = 1;
 
-	sig_reg->sge.lkey = pi_ctx->sig_mr->lkey;
-	sig_reg->rkey = pi_ctx->sig_mr->rkey;
+	sig_reg->sge.lkey = mr->lkey;
+	sig_reg->rkey = mr->rkey;
 	sig_reg->sge.addr = 0;
 	sig_reg->sge.length = scsi_transfer_length(iser_task->sc);
 
@@ -491,6 +489,8 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 	if (rsc->mr_valid)
 		iser_inv_rkey(iser_tx_next_wr(tx_desc), mr);
 
+	ib_update_fast_reg_key(mr, ib_inc_rkey(mr->rkey));
+
 	n = ib_map_mr_sg(mr, mem->sg, mem->size, SIZE_4K);
 	if (unlikely(n != mem->size)) {
 		iser_err("failed to map sg (%d/%d)\n",
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
