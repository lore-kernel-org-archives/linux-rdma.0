From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 08/17] IB/cxgb4: Remove debug prints after allocation failure
Date: Thu,  3 Nov 2016 07:02:24 +0200
Message-ID: <1478149353-12125-9-git-send-email-leon@kernel.org>
References: <1478149353-12125-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478149353-12125-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The prints after [k|v][m|z|c]alloc() functions are not needed,
because in case of failure, allocator will print their internal
error prints anyway.

Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/device.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 93e3d27..11a25ec 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -841,8 +841,6 @@ static int c4iw_rdev_open(struct c4iw_rdev *rdev)
 		if (rdev->wr_log) {
 			rdev->wr_log_size = 1 << c4iw_wr_log_size_order;
 			atomic_set(&rdev->wr_log_idx, 0);
-		} else {
-			pr_err(MOD "error allocating wr_log. Logging disabled\n");
 		}
 	}
 
@@ -1424,8 +1422,6 @@ static void recover_queues(struct uld_ctx *ctx)
 
 	qp_list.qps = kzalloc(count * sizeof *qp_list.qps, GFP_ATOMIC);
 	if (!qp_list.qps) {
-		printk(KERN_ERR MOD "%s: Fatal error - DB overflow recovery failed\n",
-		       pci_name(ctx->lldi.pdev));
 		spin_unlock_irq(&ctx->dev->lock);
 		return;
 	}
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
