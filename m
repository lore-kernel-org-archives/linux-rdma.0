From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 06/12] Clear status reporting from mthca_mr
Date: Thu, 7 Jul 2011 12:21:49 -0500
Message-ID: <20110707172149.GG10241@baloo.cartoons>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

---
 drivers/infiniband/hw/mthca/mthca_mr.c |   35 +++----------------------------
 1 files changed, 4 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_mr.c b/drivers/infiniband/hw/mthca/mthca_mr.c
index 44045c8..ab876f9 100644
--- a/drivers/infiniband/hw/mthca/mthca_mr.c
+++ b/drivers/infiniband/hw/mthca/mthca_mr.c
@@ -257,7 +257,6 @@ static int __mthca_write_mtt(struct mthca_dev *dev, struct mthca_mtt *mtt,
 	struct mthca_mailbox *mailbox;
 	__be64 *mtt_entry;
 	int err = 0;
-	u8 status;
 	int i;
 
 	mailbox = mthca_alloc_mailbox(dev, GFP_KERNEL);
@@ -281,17 +280,11 @@ static int __mthca_write_mtt(struct mthca_dev *dev, struct mthca_mtt *mtt,
 		if (i & 1)
 			mtt_entry[i + 2] = 0;
 
-		err = mthca_WRITE_MTT(dev, mailbox, (i + 1) & ~1, &status);
+		err = mthca_WRITE_MTT(dev, mailbox, (i + 1) & ~1);
 		if (err) {
 			mthca_warn(dev, "WRITE_MTT failed (%d)\n", err);
 			goto out;
 		}
-		if (status) {
-			mthca_warn(dev, "WRITE_MTT returned status 0x%02x\n",
-				   status);
-			err = -EINVAL;
-			goto out;
-		}
 
 		list_len    -= i;
 		start_index += i;
@@ -441,7 +434,6 @@ int mthca_mr_alloc(struct mthca_dev *dev, u32 pd, int buffer_size_shift,
 	u32 key;
 	int i;
 	int err;
-	u8 status;
 
 	WARN_ON(buffer_size_shift >= 32);
 
@@ -497,16 +489,10 @@ int mthca_mr_alloc(struct mthca_dev *dev, u32 pd, int buffer_size_shift,
 	}
 
 	err = mthca_SW2HW_MPT(dev, mailbox,
-			      key & (dev->limits.num_mpts - 1),
-			      &status);
+			      key & (dev->limits.num_mpts - 1));
 	if (err) {
 		mthca_warn(dev, "SW2HW_MPT failed (%d)\n", err);
 		goto err_out_mailbox;
-	} else if (status) {
-		mthca_warn(dev, "SW2HW_MPT returned status 0x%02x\n",
-			   status);
-		err = -EINVAL;
-		goto err_out_mailbox;
 	}
 
 	mthca_free_mailbox(dev, mailbox);
@@ -567,17 +553,12 @@ static void mthca_free_region(struct mthca_dev *dev, u32 lkey)
 void mthca_free_mr(struct mthca_dev *dev, struct mthca_mr *mr)
 {
 	int err;
-	u8 status;
 
 	err = mthca_HW2SW_MPT(dev, NULL,
 			      key_to_hw_index(dev, mr->ibmr.lkey) &
-			      (dev->limits.num_mpts - 1),
-			      &status);
+			      (dev->limits.num_mpts - 1));
 	if (err)
 		mthca_warn(dev, "HW2SW_MPT failed (%d)\n", err);
-	else if (status)
-		mthca_warn(dev, "HW2SW_MPT returned status 0x%02x\n",
-			   status);
 
 	mthca_free_region(dev, mr->ibmr.lkey);
 	mthca_free_mtt(dev, mr->mtt);
@@ -590,7 +571,6 @@ int mthca_fmr_alloc(struct mthca_dev *dev, u32 pd,
 	struct mthca_mailbox *mailbox;
 	u64 mtt_seg;
 	u32 key, idx;
-	u8 status;
 	int list_len = mr->attr.max_pages;
 	int err = -ENOMEM;
 	int i;
@@ -672,18 +652,11 @@ int mthca_fmr_alloc(struct mthca_dev *dev, u32 pd,
 	}
 
 	err = mthca_SW2HW_MPT(dev, mailbox,
-			      key & (dev->limits.num_mpts - 1),
-			      &status);
+			      key & (dev->limits.num_mpts - 1));
 	if (err) {
 		mthca_warn(dev, "SW2HW_MPT failed (%d)\n", err);
 		goto err_out_mailbox_free;
 	}
-	if (status) {
-		mthca_warn(dev, "SW2HW_MPT returned status 0x%02x\n",
-			   status);
-		err = -EINVAL;
-		goto err_out_mailbox_free;
-	}
 
 	mthca_free_mailbox(dev, mailbox);
 	return 0;
-- 
1.7.5.3


-- 
Goldwyn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
