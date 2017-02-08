From: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: [PATCH 03/14] RDMA/cxgb4: Use kcalloc() in two functions
Date: Wed, 8 Feb 2017 22:13:29 +0100
Message-ID: <3050b601-fb9f-9eed-1b92-75395407a133@users.sourceforge.net>
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
Date: Wed, 8 Feb 2017 15:40:16 +0100

Multiplications for the size determination of memory allocations
indicated that array data structures should be processed.
Thus use the corresponding function "kcalloc".

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 4e4f1a732b01..444c28206dae 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -873,7 +873,7 @@ static int c4iw_rdev_open(struct c4iw_rdev *rdev)
 	rdev->status_page->cq_size = rdev->lldi.vr->cq.size;
 
 	if (c4iw_wr_log) {
-		rdev->wr_log = kzalloc((1 << c4iw_wr_log_size_order) *
+		rdev->wr_log = kcalloc(1 << c4iw_wr_log_size_order,
 				       sizeof(*rdev->wr_log), GFP_KERNEL);
 		if (rdev->wr_log) {
 			rdev->wr_log_size = 1 << c4iw_wr_log_size_order;
@@ -1466,7 +1466,7 @@ static void recover_queues(struct uld_ctx *ctx)
 	ctx->dev->db_state = RECOVERY;
 	idr_for_each(&ctx->dev->qpidr, count_qps, &count);
 
-	qp_list.qps = kzalloc(count * sizeof *qp_list.qps, GFP_ATOMIC);
+	qp_list.qps = kcalloc(count, sizeof(*qp_list.qps), GFP_ATOMIC);
 	if (!qp_list.qps) {
 		spin_unlock_irq(&ctx->dev->lock);
 		return;
-- 
2.11.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
