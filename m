From: Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>
Subject: [PATCH] RDMA/qedr: Fix some error handling
Date: Sat, 18 Feb 2017 12:28:15 +0100
Message-ID: <20170218112815.9329-1-christophe.jaillet@wanadoo.fr>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, rajesh.borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

'qedr_alloc_pbl_tbl()' can not return NULL.

In qedr_init_user_queue():
 - simplify the test for the return value, no need to test for NULL
 - propagate the error pointer if needed, otherwise 0 (success) is returned.
   This is spurious.

In init_mr_info():
 - test the return value with IS_ERR
 - propagate the error pointer if needed instead of an exlictit -ENOMEM.
   This is a no-op as the only error pointer that we can have here is
   already -ENOMEM

Signed-off-by: Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>
---
 drivers/infiniband/hw/qedr/verbs.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index ef83a3f322d6..0c51657af151 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -771,8 +771,10 @@ static inline int qedr_init_user_queue(struct ib_ucontext *ib_ctx,
 		goto err0;
 
 	q->pbl_tbl = qedr_alloc_pbl_tbl(dev, &q->pbl_info, GFP_KERNEL);
-	if (IS_ERR_OR_NULL(q->pbl_tbl))
+	if (IS_ERR(q->pbl_tbl)) {
+		rc = PTR_ERR(q->pbl_tbl);
 		goto err0;
+	}
 
 	qedr_populate_pbls(dev, q->umem, q->pbl_tbl, &q->pbl_info);
 
@@ -2105,8 +2107,8 @@ static int init_mr_info(struct qedr_dev *dev, struct mr_info *info,
 		goto done;
 
 	info->pbl_table = qedr_alloc_pbl_tbl(dev, &info->pbl_info, GFP_KERNEL);
-	if (!info->pbl_table) {
-		rc = -ENOMEM;
+	if (IS_ERR(info->pbl_table)) {
+		rc = PTR_ERR(info->pbl_table);
 		goto done;
 	}
 
@@ -2117,7 +2119,7 @@ static int init_mr_info(struct qedr_dev *dev, struct mr_info *info,
 	 * list and allocating another one
 	 */
 	tmp = qedr_alloc_pbl_tbl(dev, &info->pbl_info, GFP_KERNEL);
-	if (!tmp) {
+	if (IS_ERR(tmp)) {
 		DP_DEBUG(dev, QEDR_MSG_MR, "Extra PBL is not allocated\n");
 		goto done;
 	}
-- 
2.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
