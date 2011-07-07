From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 12/12] Clear status from mthca_srq
Date: Thu, 7 Jul 2011 12:23:29 -0500
Message-ID: <20110707172329.GM10241@baloo.cartoons>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

---
 drivers/infiniband/hw/mthca/mthca_srq.c |   33 ++++++------------------------
 1 files changed, 7 insertions(+), 26 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_srq.c b/drivers/infiniband/hw/mthca/mthca_srq.c
index 4fabe62..d22f970 100644
--- a/drivers/infiniband/hw/mthca/mthca_srq.c
+++ b/drivers/infiniband/hw/mthca/mthca_srq.c
@@ -200,7 +200,6 @@ int mthca_alloc_srq(struct mthca_dev *dev, struct mthca_pd *pd,
 		    struct ib_srq_attr *attr, struct mthca_srq *srq)
 {
 	struct mthca_mailbox *mailbox;
-	u8 status;
 	int ds;
 	int err;
 
@@ -266,18 +265,12 @@ int mthca_alloc_srq(struct mthca_dev *dev, struct mthca_pd *pd,
 	else
 		mthca_tavor_init_srq_context(dev, pd, srq, mailbox->buf);
 
-	err = mthca_SW2HW_SRQ(dev, mailbox, srq->srqn, &status);
+	err = mthca_SW2HW_SRQ(dev, mailbox, srq->srqn);
 
 	if (err) {
 		mthca_warn(dev, "SW2HW_SRQ failed (%d)\n", err);
 		goto err_out_free_buf;
 	}
-	if (status) {
-		mthca_warn(dev, "SW2HW_SRQ returned status 0x%02x\n",
-			   status);
-		err = -EINVAL;
-		goto err_out_free_buf;
-	}
 
 	spin_lock_irq(&dev->srq_table.lock);
 	if (mthca_array_set(&dev->srq_table.srq,
@@ -299,11 +292,9 @@ int mthca_alloc_srq(struct mthca_dev *dev, struct mthca_pd *pd,
 	return 0;
 
 err_out_free_srq:
-	err = mthca_HW2SW_SRQ(dev, mailbox, srq->srqn, &status);
+	err = mthca_HW2SW_SRQ(dev, mailbox, srq->srqn);
 	if (err)
 		mthca_warn(dev, "HW2SW_SRQ failed (%d)\n", err);
-	else if (status)
-		mthca_warn(dev, "HW2SW_SRQ returned status 0x%02x\n", status);
 
 err_out_free_buf:
 	if (!pd->ibpd.uobject)
@@ -340,7 +331,6 @@ void mthca_free_srq(struct mthca_dev *dev, struct mthca_srq *srq)
 {
 	struct mthca_mailbox *mailbox;
 	int err;
-	u8 status;
 
 	mailbox = mthca_alloc_mailbox(dev, GFP_KERNEL);
 	if (IS_ERR(mailbox)) {
@@ -348,11 +338,9 @@ void mthca_free_srq(struct mthca_dev *dev, struct mthca_srq *srq)
 		return;
 	}
 
-	err = mthca_HW2SW_SRQ(dev, mailbox, srq->srqn, &status);
+	err = mthca_HW2SW_SRQ(dev, mailbox, srq->srqn);
 	if (err)
 		mthca_warn(dev, "HW2SW_SRQ failed (%d)\n", err);
-	else if (status)
-		mthca_warn(dev, "HW2SW_SRQ returned status 0x%02x\n", status);
 
 	spin_lock_irq(&dev->srq_table.lock);
 	mthca_array_clear(&dev->srq_table.srq,
@@ -378,8 +366,7 @@ int mthca_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 {
 	struct mthca_dev *dev = to_mdev(ibsrq->device);
 	struct mthca_srq *srq = to_msrq(ibsrq);
-	int ret;
-	u8 status;
+	int ret = 0;
 
 	/* We don't support resizing SRQs (yet?) */
 	if (attr_mask & IB_SRQ_MAX_WR)
@@ -391,16 +378,11 @@ int mthca_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 			return -EINVAL;
 
 		mutex_lock(&srq->mutex);
-		ret = mthca_ARM_SRQ(dev, srq->srqn, attr->srq_limit, &status);
+		ret = mthca_ARM_SRQ(dev, srq->srqn, attr->srq_limit);
 		mutex_unlock(&srq->mutex);
-
-		if (ret)
-			return ret;
-		if (status)
-			return -EINVAL;
 	}
 
-	return 0;
+	return ret;
 }
 
 int mthca_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *srq_attr)
@@ -410,14 +392,13 @@ int mthca_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *srq_attr)
 	struct mthca_mailbox *mailbox;
 	struct mthca_arbel_srq_context *arbel_ctx;
 	struct mthca_tavor_srq_context *tavor_ctx;
-	u8 status;
 	int err;
 
 	mailbox = mthca_alloc_mailbox(dev, GFP_KERNEL);
 	if (IS_ERR(mailbox))
 		return PTR_ERR(mailbox);
 
-	err = mthca_QUERY_SRQ(dev, srq->srqn, mailbox, &status);
+	err = mthca_QUERY_SRQ(dev, srq->srqn, mailbox);
 	if (err)
 		goto out;
 
-- 
1.7.5.3


-- 
Goldwyn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
