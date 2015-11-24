From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 04/10] IB/iser: set intuitive values for mr_valid
Date: Tue, 24 Nov 2015 18:23:48 +0200
Message-ID: <1448382234-24806-5-git-send-email-sagig@mellanox.com>
References: <1448382234-24806-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1448382234-24806-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This parameter is described as "is mr valid indicator".
In other words, it indicates whether memory registration
is valid or not. So intuitive values would be:
mr_valid=True, when memory registration is valid and
mr_valid=False otherwise.

Signed-off-by: Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_memory.c | 8 ++++----
 drivers/infiniband/ulp/iser/iser_verbs.c  | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 62d0578388d3..a0216da6e8bf 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -392,7 +392,7 @@ iser_reg_sig_mr(struct iscsi_iser_task *iser_task,
 
 	iser_set_prot_checks(iser_task->sc, &sig_attrs->check_mask);
 
-	if (!pi_ctx->sig_mr_valid)
+	if (pi_ctx->sig_mr_valid)
 		iser_inv_rkey(iser_tx_next_wr(tx_desc), pi_ctx->sig_mr);
 
 	wr = sig_handover_wr(iser_tx_next_wr(tx_desc));
@@ -410,7 +410,7 @@ iser_reg_sig_mr(struct iscsi_iser_task *iser_task,
 	wr->access_flags = IB_ACCESS_LOCAL_WRITE |
 			   IB_ACCESS_REMOTE_READ |
 			   IB_ACCESS_REMOTE_WRITE;
-	pi_ctx->sig_mr_valid = 0;
+	pi_ctx->sig_mr_valid = 1;
 
 	sig_reg->sge.lkey = pi_ctx->sig_mr->lkey;
 	sig_reg->rkey = pi_ctx->sig_mr->rkey;
@@ -434,7 +434,7 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 	struct ib_reg_wr *wr;
 	int n;
 
-	if (!rsc->mr_valid)
+	if (rsc->mr_valid)
 		iser_inv_rkey(iser_tx_next_wr(tx_desc), mr);
 
 	n = ib_map_mr_sg(mr, mem->sg, mem->size, SIZE_4K);
@@ -455,7 +455,7 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 		     IB_ACCESS_REMOTE_WRITE |
 		     IB_ACCESS_REMOTE_READ;
 
-	rsc->mr_valid = 0;
+	rsc->mr_valid = 1;
 
 	reg->sge.lkey = mr->lkey;
 	reg->rkey = mr->rkey;
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index a93070210109..415a06e69bc5 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -299,7 +299,7 @@ iser_alloc_reg_res(struct ib_device *ib_device,
 		iser_err("Failed to allocate ib_fast_reg_mr err=%d\n", ret);
 		return ret;
 	}
-	res->mr_valid = 1;
+	res->mr_valid = 0;
 
 	return 0;
 }
@@ -336,7 +336,7 @@ iser_alloc_pi_ctx(struct ib_device *ib_device,
 		ret = PTR_ERR(pi_ctx->sig_mr);
 		goto sig_mr_failure;
 	}
-	pi_ctx->sig_mr_valid = 1;
+	pi_ctx->sig_mr_valid = 0;
 	desc->pi_ctx->sig_protected = 0;
 
 	return 0;
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
