From: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 7/8] bnxt_re: Fix memory leak in FRMR path
Date: Thu, 31 Aug 2017 09:27:34 +0530
Message-ID: <20170831035735.19595-8-somnath.kotur@broadcom.com>
References: <20170831035735.19595-1-somnath.kotur@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170831035735.19595-1-somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

This patch fixes a memory leak issue when alloc_mr is used.
mr->pages and mr->npages are used only in alloc_mr path. mr->pages
is allocated when alloc_mr is called or in the case of FRMR, while
creating the MR. mr->npages is updated only when the MR created
is used i.e. after invoking map_mr_sg verb, before data transfer.
In the dereg_mr path, if mr->npages is 0, driver ends up not freeing
the memory created.
Removing the npages check from the dereg_mr path for kernel consumers.

Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index cf0440c..94ab9e1 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -3063,7 +3063,7 @@ int bnxt_re_dereg_mr(struct ib_mr *ib_mr)
 		return rc;
 	}
 
-	if (mr->npages && mr->pages) {
+	if (mr->pages) {
 		rc = bnxt_qplib_free_fast_reg_page_list(&rdev->qplib_res,
 							&mr->qplib_frpl);
 		kfree(mr->pages);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
