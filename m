From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 09/14] RDMA/cxgb4: Use common error handling code in
 recover_lost_dbs()
Date: Wed, 8 Feb 2017 22:19:41 +0100
Message-ID: <3da7cff6-9f94-2ae8-a173-7ad6efdb524b@users.sourceforge.net>
References: <0aff92fa-2891-333a-2e1e-ca309db2ec72@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0aff92fa-2891-333a-2e1e-ca309db2ec72@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Steve Wise <swise@chelsio.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 8 Feb 2017 18:08:08 +0100

Add a jump target so that a bit of exception handling can be better reused
from an in branch in this function.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/cxgb4/device.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 2931920d7c4c..86cf7026619f 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -1402,9 +1402,7 @@ static void recover_lost_dbs(struct uld_ctx *ctx, struct qp_list *qp_list)
 			       pci_name(ctx->lldi.pdev),
 			       ": Fatal error - DB overflow recovery failed - error syncing ",
 			       qp->wq.sq.qid);
-			spin_unlock(&qp->lock);
-			spin_unlock_irq(&qp->rhp->lock);
-			return;
+			goto unlock;
 		}
 		qp->wq.sq.wq_pidx_inc = 0;
 
@@ -1418,6 +1416,7 @@ static void recover_lost_dbs(struct uld_ctx *ctx, struct qp_list *qp_list)
 			       pci_name(ctx->lldi.pdev),
 			       ": Fatal error - DB overflow recovery failed - error syncing ",
 			       qp->wq.rq.qid);
+unlock:
 			spin_unlock(&qp->lock);
 			spin_unlock_irq(&qp->rhp->lock);
 			return;
-- 
2.11.1
