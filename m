From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 08/12] Clear status reporting from mthca_mcg
Date: Thu, 7 Jul 2011 12:22:24 -0500
Message-ID: <20110707172223.GI10241@baloo.cartoons>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

---
 drivers/infiniband/hw/mthca/mthca_mcg.c |  101 ++++++++++---------------------
 1 files changed, 33 insertions(+), 68 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_mcg.c b/drivers/infiniband/hw/mthca/mthca_mcg.c
index 515790a..ace9ff4 100644
--- a/drivers/infiniband/hw/mthca/mthca_mcg.c
+++ b/drivers/infiniband/hw/mthca/mthca_mcg.c
@@ -68,7 +68,6 @@ static int find_mgm(struct mthca_dev *dev,
 	struct mthca_mgm *mgm = mgm_mailbox->buf;
 	u8 *mgid;
 	int err;
-	u8 status;
 
 	mailbox = mthca_alloc_mailbox(dev, GFP_KERNEL);
 	if (IS_ERR(mailbox))
@@ -77,12 +76,9 @@ static int find_mgm(struct mthca_dev *dev,
 
 	memcpy(mgid, gid, 16);
 
-	err = mthca_MGID_HASH(dev, mailbox, hash, &status);
-	if (err)
-		goto out;
-	if (status) {
-		mthca_err(dev, "MGID_HASH returned status %02x\n", status);
-		err = -EINVAL;
+	err = mthca_MGID_HASH(dev, mailbox, hash);
+	if (err) {
+		mthca_err(dev, "MGID_HASH failed (%d)\n", err);
 		goto out;
 	}
 
@@ -93,12 +89,9 @@ static int find_mgm(struct mthca_dev *dev,
 	*prev  = -1;
 
 	do {
-		err = mthca_READ_MGM(dev, *index, mgm_mailbox, &status);
-		if (err)
-			goto out;
-		if (status) {
-			mthca_err(dev, "READ_MGM returned status %02x\n", status);
-			err = -EINVAL;
+		err = mthca_READ_MGM(dev, *index, mgm_mailbox);
+		if (err) {
+			mthca_err(dev, "READ_MGM failed (%d)\n", err);
 			goto out;
 		}
 
@@ -134,7 +127,6 @@ int mthca_multicast_attach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 	int link = 0;
 	int i;
 	int err;
-	u8 status;
 
 	mailbox = mthca_alloc_mailbox(dev, GFP_KERNEL);
 	if (IS_ERR(mailbox))
@@ -160,12 +152,9 @@ int mthca_multicast_attach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 			goto out;
 		}
 
-		err = mthca_READ_MGM(dev, index, mailbox, &status);
-		if (err)
-			goto out;
-		if (status) {
-			mthca_err(dev, "READ_MGM returned status %02x\n", status);
-			err = -EINVAL;
+		err = mthca_READ_MGM(dev, index, mailbox);
+		if (err) {
+			mthca_err(dev, "READ_MGM failed (%d)\n", err);
 			goto out;
 		}
 		memset(mgm, 0, sizeof *mgm);
@@ -189,11 +178,9 @@ int mthca_multicast_attach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 		goto out;
 	}
 
-	err = mthca_WRITE_MGM(dev, index, mailbox, &status);
-	if (err)
-		goto out;
-	if (status) {
-		mthca_err(dev, "WRITE_MGM returned status %02x\n", status);
+	err = mthca_WRITE_MGM(dev, index, mailbox);
+	if (err) {
+		mthca_err(dev, "WRITE_MGM failed %d\n", err);
 		err = -EINVAL;
 		goto out;
 	}
@@ -201,24 +188,17 @@ int mthca_multicast_attach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 	if (!link)
 		goto out;
 
-	err = mthca_READ_MGM(dev, prev, mailbox, &status);
-	if (err)
-		goto out;
-	if (status) {
-		mthca_err(dev, "READ_MGM returned status %02x\n", status);
-		err = -EINVAL;
+	err = mthca_READ_MGM(dev, prev, mailbox);
+	if (err) {
+		mthca_err(dev, "READ_MGM failed %d\n", err);
 		goto out;
 	}
 
 	mgm->next_gid_index = cpu_to_be32(index << 6);
 
-	err = mthca_WRITE_MGM(dev, prev, mailbox, &status);
+	err = mthca_WRITE_MGM(dev, prev, mailbox);
 	if (err)
-		goto out;
-	if (status) {
-		mthca_err(dev, "WRITE_MGM returned status %02x\n", status);
-		err = -EINVAL;
-	}
+		mthca_err(dev, "WRITE_MGM returned %d\n", err);
 
  out:
 	if (err && link && index != -1) {
@@ -240,7 +220,6 @@ int mthca_multicast_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 	int prev, index;
 	int i, loc;
 	int err;
-	u8 status;
 
 	mailbox = mthca_alloc_mailbox(dev, GFP_KERNEL);
 	if (IS_ERR(mailbox))
@@ -275,12 +254,9 @@ int mthca_multicast_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 	mgm->qp[loc]   = mgm->qp[i - 1];
 	mgm->qp[i - 1] = 0;
 
-	err = mthca_WRITE_MGM(dev, index, mailbox, &status);
-	if (err)
-		goto out;
-	if (status) {
-		mthca_err(dev, "WRITE_MGM returned status %02x\n", status);
-		err = -EINVAL;
+	err = mthca_WRITE_MGM(dev, index, mailbox);
+	if (err) {
+		mthca_err(dev, "WRITE_MGM returned %d\n", err);
 		goto out;
 	}
 
@@ -292,24 +268,19 @@ int mthca_multicast_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 		int amgm_index_to_free = be32_to_cpu(mgm->next_gid_index) >> 6;
 		if (amgm_index_to_free) {
 			err = mthca_READ_MGM(dev, amgm_index_to_free,
-					     mailbox, &status);
-			if (err)
-				goto out;
-			if (status) {
-				mthca_err(dev, "READ_MGM returned status %02x\n",
-					  status);
+					     mailbox);
+			if (err) {
+				mthca_err(dev, "READ_MGM returned %d\n",
+					  err);
 				err = -EINVAL;
 				goto out;
 			}
 		} else
 			memset(mgm->gid, 0, 16);
 
-		err = mthca_WRITE_MGM(dev, index, mailbox, &status);
-		if (err)
-			goto out;
-		if (status) {
-			mthca_err(dev, "WRITE_MGM returned status %02x\n", status);
-			err = -EINVAL;
+		err = mthca_WRITE_MGM(dev, index, mailbox);
+		if (err) {
+			mthca_err(dev, "WRITE_MGM returned %d\n", err);
 			goto out;
 		}
 		if (amgm_index_to_free) {
@@ -319,23 +290,17 @@ int mthca_multicast_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 	} else {
 		/* Remove entry from AMGM */
 		int curr_next_index = be32_to_cpu(mgm->next_gid_index) >> 6;
-		err = mthca_READ_MGM(dev, prev, mailbox, &status);
-		if (err)
-			goto out;
-		if (status) {
-			mthca_err(dev, "READ_MGM returned status %02x\n", status);
-			err = -EINVAL;
+		err = mthca_READ_MGM(dev, prev, mailbox);
+		if (err) {
+			mthca_err(dev, "READ_MGM returned %d\n", err);
 			goto out;
 		}
 
 		mgm->next_gid_index = cpu_to_be32(curr_next_index << 6);
 
-		err = mthca_WRITE_MGM(dev, prev, mailbox, &status);
-		if (err)
-			goto out;
-		if (status) {
-			mthca_err(dev, "WRITE_MGM returned status %02x\n", status);
-			err = -EINVAL;
+		err = mthca_WRITE_MGM(dev, prev, mailbox);
+		if (err) {
+			mthca_err(dev, "WRITE_MGM returned %d\n", err);
 			goto out;
 		}
 		BUG_ON(index < dev->limits.num_mgms);
-- 
1.7.5.3


-- 
Goldwyn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
