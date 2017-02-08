From: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: [PATCH 08/14] RDMA/cxgb4: Adjust construction of two error messages
 in recover_lost_dbs()
Date: Wed, 8 Feb 2017 22:18:43 +0100
Message-ID: <ad58d9b8-ce55-3150-e219-1a94f9ca50c9@users.sourceforge.net>
References: <0aff92fa-2891-333a-2e1e-ca309db2ec72@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0aff92fa-2891-333a-2e1e-ca309db2ec72-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Date: Wed, 8 Feb 2017 17:48:04 +0100

The script "checkpatch.pl" pointed information out like the following.

WARNING: quoted string split across lines

Thus adjust the error message constructions in this function.

Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/device.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 7f30bfd71eb2..2931920d7c4c 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -1398,10 +1398,10 @@ static void recover_lost_dbs(struct uld_ctx *ctx, struct qp_list *qp_list)
 					  t4_sq_host_wq_pidx(&qp->wq),
 					  t4_sq_wq_size(&qp->wq));
 		if (ret) {
-			pr_err(MOD "%s: Fatal error - "
-			       "DB overflow recovery failed - "
-			       "error syncing SQ qid %u\n",
-			       pci_name(ctx->lldi.pdev), qp->wq.sq.qid);
+			pr_err(MOD "%s%sSQ qid %u\n",
+			       pci_name(ctx->lldi.pdev),
+			       ": Fatal error - DB overflow recovery failed - error syncing ",
+			       qp->wq.sq.qid);
 			spin_unlock(&qp->lock);
 			spin_unlock_irq(&qp->rhp->lock);
 			return;
@@ -1414,10 +1414,10 @@ static void recover_lost_dbs(struct uld_ctx *ctx, struct qp_list *qp_list)
 					  t4_rq_wq_size(&qp->wq));
 
 		if (ret) {
-			pr_err(MOD "%s: Fatal error - "
-			       "DB overflow recovery failed - "
-			       "error syncing RQ qid %u\n",
-			       pci_name(ctx->lldi.pdev), qp->wq.rq.qid);
+			pr_err(MOD "%s%sRQ qid %u\n",
+			       pci_name(ctx->lldi.pdev),
+			       ": Fatal error - DB overflow recovery failed - error syncing ",
+			       qp->wq.rq.qid);
 			spin_unlock(&qp->lock);
 			spin_unlock_irq(&qp->rhp->lock);
 			return;
-- 
2.11.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
