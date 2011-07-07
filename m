From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 05/12] Clean status reporting from mthca_cq
Date: Thu, 7 Jul 2011 12:21:39 -0500
Message-ID: <20110707172138.GF10241@baloo.cartoons>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

---
 drivers/infiniband/hw/mthca/mthca_cq.c |   15 ++-------------
 1 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_cq.c b/drivers/infiniband/hw/mthca/mthca_cq.c
index 18ee3fa..53157b8 100644
--- a/drivers/infiniband/hw/mthca/mthca_cq.c
+++ b/drivers/infiniband/hw/mthca/mthca_cq.c
@@ -779,7 +779,6 @@ int mthca_init_cq(struct mthca_dev *dev, int nent,
 	struct mthca_mailbox *mailbox;
 	struct mthca_cq_context *cq_context;
 	int err = -ENOMEM;
-	u8 status;
 
 	cq->ibcq.cqe  = nent - 1;
 	cq->is_kernel = !ctx;
@@ -847,19 +846,12 @@ int mthca_init_cq(struct mthca_dev *dev, int nent,
 		cq_context->state_db = cpu_to_be32(cq->arm_db_index);
 	}
 
-	err = mthca_SW2HW_CQ(dev, mailbox, cq->cqn, &status);
+	err = mthca_SW2HW_CQ(dev, mailbox, cq->cqn);
 	if (err) {
 		mthca_warn(dev, "SW2HW_CQ failed (%d)\n", err);
 		goto err_out_free_mr;
 	}
 
-	if (status) {
-		mthca_warn(dev, "SW2HW_CQ returned status 0x%02x\n",
-			   status);
-		err = -EINVAL;
-		goto err_out_free_mr;
-	}
-
 	spin_lock_irq(&dev->cq_table.lock);
 	if (mthca_array_set(&dev->cq_table.cq,
 			    cq->cqn & (dev->limits.num_cqs - 1),
@@ -915,7 +907,6 @@ void mthca_free_cq(struct mthca_dev *dev,
 {
 	struct mthca_mailbox *mailbox;
 	int err;
-	u8 status;
 
 	mailbox = mthca_alloc_mailbox(dev, GFP_KERNEL);
 	if (IS_ERR(mailbox)) {
@@ -923,11 +914,9 @@ void mthca_free_cq(struct mthca_dev *dev,
 		return;
 	}
 
-	err = mthca_HW2SW_CQ(dev, mailbox, cq->cqn, &status);
+	err = mthca_HW2SW_CQ(dev, mailbox, cq->cqn);
 	if (err)
 		mthca_warn(dev, "HW2SW_CQ failed (%d)\n", err);
-	else if (status)
-		mthca_warn(dev, "HW2SW_CQ returned status 0x%02x\n", status);
 
 	if (0) {
 		__be32 *ctx = mailbox->buf;
-- 
1.7.5.3


-- 
Goldwyn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
