From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 10/16] IB/iser: Centralize memory region invalidation to a function
Date: Sun,  7 Dec 2014 16:10:01 +0200
Message-ID: <1417961407-10139-11-git-send-email-ogerlitz@mellanox.com>
References: <1417961407-10139-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1417961407-10139-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Eliminates code duplication.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_memory.c |   32 ++++++++++++++--------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 5796c95..a70fd9a 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -524,6 +524,20 @@ iser_set_prot_checks(struct scsi_cmnd *sc, u8 *mask)
 	return 0;
 }
 
+static void
+iser_inv_rkey(struct ib_send_wr *inv_wr, struct ib_mr *mr)
+{
+	u32 rkey;
+
+	memset(inv_wr, 0, sizeof(*inv_wr));
+	inv_wr->opcode = IB_WR_LOCAL_INV;
+	inv_wr->wr_id = ISER_FASTREG_LI_WRID;
+	inv_wr->ex.invalidate_rkey = mr->rkey;
+
+	rkey = ib_inc_rkey(mr->rkey);
+	ib_update_fast_reg_key(mr, rkey);
+}
+
 static int
 iser_reg_sig_mr(struct iscsi_iser_task *iser_task,
 		struct fast_reg_descriptor *desc, struct ib_sge *data_sge,
@@ -535,7 +549,6 @@ iser_reg_sig_mr(struct iscsi_iser_task *iser_task,
 	struct ib_send_wr *bad_wr, *wr = NULL;
 	struct ib_sig_attrs sig_attrs;
 	int ret;
-	u32 key;
 
 	memset(&sig_attrs, 0, sizeof(sig_attrs));
 	ret = iser_set_sig_attrs(iser_task->sc, &sig_attrs);
@@ -547,14 +560,8 @@ iser_reg_sig_mr(struct iscsi_iser_task *iser_task,
 		goto err;
 
 	if (!(desc->reg_indicators & ISER_SIG_KEY_VALID)) {
-		memset(&inv_wr, 0, sizeof(inv_wr));
-		inv_wr.opcode = IB_WR_LOCAL_INV;
-		inv_wr.wr_id = ISER_FASTREG_LI_WRID;
-		inv_wr.ex.invalidate_rkey = pi_ctx->sig_mr->rkey;
+		iser_inv_rkey(&inv_wr, pi_ctx->sig_mr);
 		wr = &inv_wr;
-		/* Bump the key */
-		key = (u8)(pi_ctx->sig_mr->rkey & 0x000000FF);
-		ib_update_fast_reg_key(pi_ctx->sig_mr, ++key);
 	}
 
 	memset(&sig_wr, 0, sizeof(sig_wr));
@@ -612,7 +619,6 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 	struct ib_fast_reg_page_list *frpl;
 	struct ib_send_wr fastreg_wr, inv_wr;
 	struct ib_send_wr *bad_wr, *wr = NULL;
-	u8 key;
 	int ret, offset, size, plen;
 
 	/* if there a single dma entry, dma mr suffices */
@@ -644,14 +650,8 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 	}
 
 	if (!(desc->reg_indicators & ind)) {
-		memset(&inv_wr, 0, sizeof(inv_wr));
-		inv_wr.wr_id = ISER_FASTREG_LI_WRID;
-		inv_wr.opcode = IB_WR_LOCAL_INV;
-		inv_wr.ex.invalidate_rkey = mr->rkey;
+		iser_inv_rkey(&inv_wr, mr);
 		wr = &inv_wr;
-		/* Bump the key */
-		key = (u8)(mr->rkey & 0x000000FF);
-		ib_update_fast_reg_key(mr, ++key);
 	}
 
 	/* Prepare FASTREG WR */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
