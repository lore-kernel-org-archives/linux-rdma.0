From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V4 for-next 04/14] RDMA/bnxt_re: Dereg MR in FW before freeing the fast_reg_page_list
Date: Mon, 22 May 2017 03:15:34 -0700
Message-ID: <1495448144-18966-5-git-send-email-selvin.xavier@broadcom.com>
References: <1495448144-18966-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1495448144-18966-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If the host buffers are freed before destroying MR in HW,
HW could try accessing these buffers. This could cause a host
crash. Fixing the code to avoid this condition.

Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index a89f095..e91bd68 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -3035,6 +3035,12 @@ int bnxt_re_dereg_mr(struct ib_mr *ib_mr)
 	struct bnxt_re_dev *rdev = mr->rdev;
 	int rc = 0;
 
+	rc = bnxt_qplib_free_mrw(&rdev->qplib_res, &mr->qplib_mr);
+	if (rc) {
+		dev_err(rdev_to_dev(rdev), "Dereg MR failed: %#x\n", rc);
+		return rc;
+	}
+
 	if (mr->npages && mr->pages) {
 		rc = bnxt_qplib_free_fast_reg_page_list(&rdev->qplib_res,
 							&mr->qplib_frpl);
@@ -3042,8 +3048,6 @@ int bnxt_re_dereg_mr(struct ib_mr *ib_mr)
 		mr->npages = 0;
 		mr->pages = NULL;
 	}
-	rc = bnxt_qplib_free_mrw(&rdev->qplib_res, &mr->qplib_mr);
-
 	if (!IS_ERR(mr->ib_umem) && mr->ib_umem)
 		ib_umem_release(mr->ib_umem);
 
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
