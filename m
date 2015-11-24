From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v1 09/10] IB/iser: Increment the rkey when registering and not when invalidating
Date: Tue, 24 Nov 2015 18:23:53 +0200
Message-ID: <1448382234-24806-10-git-send-email-sagig@mellanox.com>
References: <1448382234-24806-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1448382234-24806-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Or Gerlitz <ogerlitz@mellanox.com>, Jenny Derzhavetz <jennyf@mellanox.com>, Steve Wise <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org

With remote invalidate we won't local invalidate
but we still want to increment the rkey.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Jenny Derzhavetz <jennyf@mellanox.com>
---
 drivers/infiniband/ulp/iser/iser_memory.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index a0216da6e8bf..c008fc262aee 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -358,19 +358,14 @@ iser_set_prot_checks(struct scsi_cmnd *sc, u8 *mask)
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
@@ -383,6 +378,7 @@ iser_reg_sig_mr(struct iscsi_iser_task *iser_task,
 	struct iser_tx_desc *tx_desc = &iser_task->desc;
 	struct ib_sig_attrs *sig_attrs = &tx_desc->sig_attrs;
 	struct ib_sig_handover_wr *wr;
+	struct ib_mr *mr = pi_ctx->sig_mr;
 	int ret;
 
 	memset(sig_attrs, 0, sizeof(*sig_attrs));
@@ -393,7 +389,9 @@ iser_reg_sig_mr(struct iscsi_iser_task *iser_task,
 	iser_set_prot_checks(iser_task->sc, &sig_attrs->check_mask);
 
 	if (pi_ctx->sig_mr_valid)
-		iser_inv_rkey(iser_tx_next_wr(tx_desc), pi_ctx->sig_mr);
+		iser_inv_rkey(iser_tx_next_wr(tx_desc), mr);
+
+	ib_update_fast_reg_key(mr, ib_inc_rkey(mr->rkey));
 
 	wr = sig_handover_wr(iser_tx_next_wr(tx_desc));
 	wr->wr.opcode = IB_WR_REG_SIG_MR;
@@ -402,7 +400,7 @@ iser_reg_sig_mr(struct iscsi_iser_task *iser_task,
 	wr->wr.num_sge = 1;
 	wr->wr.send_flags = 0;
 	wr->sig_attrs = sig_attrs;
-	wr->sig_mr = pi_ctx->sig_mr;
+	wr->sig_mr = mr;
 	if (scsi_prot_sg_count(iser_task->sc))
 		wr->prot = &prot_reg->sge;
 	else
@@ -412,8 +410,8 @@ iser_reg_sig_mr(struct iscsi_iser_task *iser_task,
 			   IB_ACCESS_REMOTE_WRITE;
 	pi_ctx->sig_mr_valid = 1;
 
-	sig_reg->sge.lkey = pi_ctx->sig_mr->lkey;
-	sig_reg->rkey = pi_ctx->sig_mr->rkey;
+	sig_reg->sge.lkey = mr->lkey;
+	sig_reg->rkey = mr->rkey;
 	sig_reg->sge.addr = 0;
 	sig_reg->sge.length = scsi_transfer_length(iser_task->sc);
 
@@ -437,6 +435,8 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 	if (rsc->mr_valid)
 		iser_inv_rkey(iser_tx_next_wr(tx_desc), mr);
 
+	ib_update_fast_reg_key(mr, ib_inc_rkey(mr->rkey));
+
 	n = ib_map_mr_sg(mr, mem->sg, mem->size, SIZE_4K);
 	if (unlikely(n != mem->size)) {
 		iser_err("failed to map sg (%d/%d)\n",
-- 
1.8.4.3
