From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 2/2] iw_cxgb4: block module unload until all ep resources are
 released
Date: Fri, 26 Aug 2016 08:28:01 -0700
Message-ID: <5ab9ec03bb938a988f3684a4a0d056c01ec70084.1472241953.git.swise@opengridcomputing.com>
References: <c1b639ca7d71ee034e334b4400ff0bae3ba58c47.1472241953.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c1b639ca7d71ee034e334b4400ff0bae3ba58c47.1472241953.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Otherwise an endpoint can be still closing down causing a touch
after free crash.

Fixes: ad61a4c7a9b7 ("iw_cxgb4: don't block in destroy_qp awaiting the last deref")
Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c       | 2 ++
 drivers/infiniband/hw/cxgb4/device.c   | 5 +++++
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h | 1 +
 3 files changed, 8 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 434a7fb..80f9889 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -333,6 +333,8 @@ static void remove_ep_tid(struct c4iw_ep *ep)
 
 	spin_lock_irqsave(&ep->com.dev->lock, flags);
 	_remove_handle(ep->com.dev, &ep->com.dev->hwtid_idr, ep->hwtid, 0);
+	if (idr_is_empty(&ep->com.dev->hwtid_idr))
+		wake_up(&ep->com.dev->wait);
 	spin_unlock_irqrestore(&ep->com.dev->lock, flags);
 }
 
diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 071d733..3c4b212 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -872,9 +872,13 @@ static void c4iw_rdev_close(struct c4iw_rdev *rdev)
 static void c4iw_dealloc(struct uld_ctx *ctx)
 {
 	c4iw_rdev_close(&ctx->dev->rdev);
+	WARN_ON_ONCE(!idr_is_empty(&ctx->dev->cqidr));
 	idr_destroy(&ctx->dev->cqidr);
+	WARN_ON_ONCE(!idr_is_empty(&ctx->dev->qpidr));
 	idr_destroy(&ctx->dev->qpidr);
+	WARN_ON_ONCE(!idr_is_empty(&ctx->dev->mmidr));
 	idr_destroy(&ctx->dev->mmidr);
+	wait_event(ctx->dev->wait, idr_is_empty(&ctx->dev->hwtid_idr));
 	idr_destroy(&ctx->dev->hwtid_idr);
 	idr_destroy(&ctx->dev->stid_idr);
 	idr_destroy(&ctx->dev->atid_idr);
@@ -992,6 +996,7 @@ static struct c4iw_dev *c4iw_alloc(const struct cxgb4_lld_info *infop)
 	mutex_init(&devp->rdev.stats.lock);
 	mutex_init(&devp->db_mutex);
 	INIT_LIST_HEAD(&devp->db_fc_list);
+	init_waitqueue_head(&devp->wait);
 	devp->avail_ird = devp->rdev.lldi.max_ird_adapter;
 
 	if (c4iw_debugfs_root) {
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index aa47e0a..4b83b84 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -263,6 +263,7 @@ struct c4iw_dev {
 	struct idr stid_idr;
 	struct list_head db_fc_list;
 	u32 avail_ird;
+	wait_queue_head_t wait;
 };
 
 static inline struct c4iw_dev *to_c4iw_dev(struct ib_device *ibdev)
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
