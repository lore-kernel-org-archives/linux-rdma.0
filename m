From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 2/5 linux-next] iw_cxgb4: remove unneccessary message level.
Date: Mon, 30 Mar 2015 22:06:05 +0200
Message-ID: <1427745969-12959-2-git-send-email-fabf@skynet.be>
References: <1427745969-12959-1-git-send-email-fabf@skynet.be>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427745969-12959-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Steve Wise <swise@chelsio.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

KERN_ERR is implicitely declared in pr_err()

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/infiniband/hw/cxgb4/device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 8fb295e..59546b6 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -1355,7 +1355,7 @@ static void recover_lost_dbs(struct uld_ctx *ctx, struct qp_list *qp_list)
 					  t4_sq_host_wq_pidx(&qp->wq),
 					  t4_sq_wq_size(&qp->wq));
 		if (ret) {
-			pr_err(KERN_ERR MOD "%s: Fatal error - "
+			pr_err(MOD "%s: Fatal error - "
 			       "DB overflow recovery failed - "
 			       "error syncing SQ qid %u\n",
 			       pci_name(ctx->lldi.pdev), qp->wq.sq.qid);
@@ -1371,7 +1371,7 @@ static void recover_lost_dbs(struct uld_ctx *ctx, struct qp_list *qp_list)
 					  t4_rq_wq_size(&qp->wq));
 
 		if (ret) {
-			pr_err(KERN_ERR MOD "%s: Fatal error - "
+			pr_err(MOD "%s: Fatal error - "
 			       "DB overflow recovery failed - "
 			       "error syncing RQ qid %u\n",
 			       pci_name(ctx->lldi.pdev), qp->wq.rq.qid);
-- 
1.9.1
