From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH WIP 09/43] iser-target: Convert to ib_alloc_mr
Date: Wed, 22 Jul 2015 09:55:09 +0300
Message-ID: <1437548143-24893-10-git-send-email-sagig@mellanox.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437548143-24893-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index f0b7c9b..94395ce 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -526,7 +526,8 @@ isert_create_pi_ctx(struct fast_reg_descriptor *desc,
 		goto err_pi_ctx;
 	}
 
-	pi_ctx->prot_mr = ib_alloc_fast_reg_mr(pd, ISCSI_ISER_SG_TABLESIZE);
+	pi_ctx->prot_mr = ib_alloc_mr(pd, IB_MR_TYPE_FAST_REG,
+				      ISCSI_ISER_SG_TABLESIZE, 0);
 	if (IS_ERR(pi_ctx->prot_mr)) {
 		isert_err("Failed to allocate prot frmr err=%ld\n",
 			  PTR_ERR(pi_ctx->prot_mr));
@@ -573,7 +574,8 @@ isert_create_fr_desc(struct ib_device *ib_device, struct ib_pd *pd,
 		return PTR_ERR(fr_desc->data_frpl);
 	}
 
-	fr_desc->data_mr = ib_alloc_fast_reg_mr(pd, ISCSI_ISER_SG_TABLESIZE);
+	fr_desc->data_mr = ib_alloc_mr(pd, IB_MR_TYPE_FAST_REG,
+				       ISCSI_ISER_SG_TABLESIZE, 0);
 	if (IS_ERR(fr_desc->data_mr)) {
 		isert_err("Failed to allocate data frmr err=%ld\n",
 			  PTR_ERR(fr_desc->data_mr));
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
