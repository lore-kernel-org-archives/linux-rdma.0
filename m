From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 04/14] RDMA/cxgb4: Use common error handling code in
 recover_queues()
Date: Wed, 8 Feb 2017 22:14:20 +0100
Message-ID: <e8abf0d7-1f4d-d218-194c-4c831dbf72d5@users.sourceforge.net>
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
Date: Wed, 8 Feb 2017 15:51:58 +0100

Add a jump target so that a bit of exception handling can be better reused
at the end of this function.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/cxgb4/device.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 444c28206dae..46410c4a9afb 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -1467,10 +1467,9 @@ static void recover_queues(struct uld_ctx *ctx)
 	idr_for_each(&ctx->dev->qpidr, count_qps, &count);
 
 	qp_list.qps = kcalloc(count, sizeof(*qp_list.qps), GFP_ATOMIC);
-	if (!qp_list.qps) {
-		spin_unlock_irq(&ctx->dev->lock);
-		return;
-	}
+	if (!qp_list.qps)
+		goto unlock;
+
 	qp_list.idx = 0;
 
 	/* add and ref each qp so it doesn't get freed */
@@ -1488,6 +1487,7 @@ static void recover_queues(struct uld_ctx *ctx)
 	spin_lock_irq(&ctx->dev->lock);
 	WARN_ON(ctx->dev->db_state != RECOVERY);
 	ctx->dev->db_state = STOPPED;
+unlock:
 	spin_unlock_irq(&ctx->dev->lock);
 }
 
-- 
2.11.1
