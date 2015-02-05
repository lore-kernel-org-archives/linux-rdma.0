From: Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>
Subject: [PATCH 1/2] infiniband: cxgb4: Fix some format strings
Date: Fri,  6 Feb 2015 00:32:58 +0100
Message-ID: <1423179179-16847-1-git-send-email-linux@rasmusvillemoes.dk>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

PDBG prepends MOD (which expands to "iw_cxgb4" ":") to the format
string. So the KERN_INFO just ends up in the middle where it just
garbles the output. At the same place, there's obviously no reason to
add MOD explicitly.

The two other are straight-forward fixes of KERN_ERR KERN_ERR, where
the second will end up as garbage in the output.

Signed-off-by: Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/device.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index eb5df4e62703..536356a8c58c 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -979,7 +979,7 @@ static struct c4iw_dev *c4iw_alloc(const struct cxgb4_lld_info *infop)
 		}
 	}
 
-	PDBG(KERN_INFO MOD "ocq memory: "
+	PDBG("ocq memory: "
 	       "hw_start 0x%x size %u mw_pa 0x%lx mw_kva %p\n",
 	       devp->rdev.lldi.vr->ocq.start, devp->rdev.lldi.vr->ocq.size,
 	       devp->rdev.oc_mw_pa, devp->rdev.oc_mw_kva);
@@ -1368,7 +1368,7 @@ static void recover_lost_dbs(struct uld_ctx *ctx, struct qp_list *qp_list)
 					  t4_sq_host_wq_pidx(&qp->wq),
 					  t4_sq_wq_size(&qp->wq));
 		if (ret) {
-			pr_err(KERN_ERR MOD "%s: Fatal error - "
+			pr_err(MOD "%s: Fatal error - "
 			       "DB overflow recovery failed - "
 			       "error syncing SQ qid %u\n",
 			       pci_name(ctx->lldi.pdev), qp->wq.sq.qid);
@@ -1384,7 +1384,7 @@ static void recover_lost_dbs(struct uld_ctx *ctx, struct qp_list *qp_list)
 					  t4_rq_wq_size(&qp->wq));
 
 		if (ret) {
-			pr_err(KERN_ERR MOD "%s: Fatal error - "
+			pr_err(MOD "%s: Fatal error - "
 			       "DB overflow recovery failed - "
 			       "error syncing RQ qid %u\n",
 			       pci_name(ctx->lldi.pdev), qp->wq.rq.qid);
-- 
2.1.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
