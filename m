From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-4.3 03/15] IB/iser: Convert to ib_alloc_mr
Date: Thu, 30 Jul 2015 10:32:36 +0300
Message-ID: <1438241568-3685-4-git-send-email-sagig@mellanox.com>
References: <1438241568-3685-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438241568-3685-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_verbs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 9bef5a7..0a7ceb9 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -299,8 +299,8 @@ iser_alloc_pi_ctx(struct ib_device *ib_device, struct ib_pd *pd,
 		goto prot_frpl_failure;
 	}
 
-	pi_ctx->prot_mr = ib_alloc_fast_reg_mr(pd,
-					ISCSI_ISER_SG_TABLESIZE + 1);
+	pi_ctx->prot_mr = ib_alloc_mr(pd, IB_MR_TYPE_MEM_REG,
+				      ISCSI_ISER_SG_TABLESIZE + 1);
 	if (IS_ERR(pi_ctx->prot_mr)) {
 		ret = PTR_ERR(pi_ctx->prot_mr);
 		goto prot_mr_failure;
@@ -351,7 +351,8 @@ iser_create_fastreg_desc(struct ib_device *ib_device, struct ib_pd *pd,
 		return PTR_ERR(desc->data_frpl);
 	}
 
-	desc->data_mr = ib_alloc_fast_reg_mr(pd, ISCSI_ISER_SG_TABLESIZE + 1);
+	desc->data_mr = ib_alloc_mr(pd, IB_MR_TYPE_MEM_REG,
+				    ISCSI_ISER_SG_TABLESIZE + 1);
 	if (IS_ERR(desc->data_mr)) {
 		ret = PTR_ERR(desc->data_mr);
 		iser_err("Failed to allocate ib_fast_reg_mr err=%d\n", ret);
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
