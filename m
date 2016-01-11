From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-4.5 2/2] iw_cxgb4: fix the GW-Basic labels to meaningful error names
Date: Mon, 11 Jan 2016 15:51:00 +0530
Message-ID: <1452507660-27441-3-git-send-email-hariprasad@chelsio.com>
References: <1452507660-27441-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452507660-27441-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/device.c | 45 ++++++++++++++----------------------
 1 file changed, 17 insertions(+), 28 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 2b67743..b89a579 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -315,14 +315,12 @@ static int qp_release(struct inode *inode, struct file *file)
 static int qp_open(struct inode *inode, struct file *file)
 {
 	struct c4iw_debugfs_data *qpd;
-	int ret = 0;
 	int count = 1;
 
 	qpd = kmalloc(sizeof *qpd, GFP_KERNEL);
-	if (!qpd) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!qpd)
+		return -ENOMEM;
+
 	qpd->devp = inode->i_private;
 	qpd->pos = 0;
 
@@ -333,8 +331,8 @@ static int qp_open(struct inode *inode, struct file *file)
 	qpd->bufsize = count * 128;
 	qpd->buf = vmalloc(qpd->bufsize);
 	if (!qpd->buf) {
-		ret = -ENOMEM;
-		goto err1;
+		kfree(qpd);
+		return -ENOMEM;
 	}
 
 	spin_lock_irq(&qpd->devp->lock);
@@ -343,11 +341,7 @@ static int qp_open(struct inode *inode, struct file *file)
 
 	qpd->buf[qpd->pos++] = 0;
 	file->private_data = qpd;
-	goto out;
-err1:
-	kfree(qpd);
-out:
-	return ret;
+	return 0;
 }
 
 static const struct file_operations qp_debugfs_fops = {
@@ -781,8 +775,7 @@ static int c4iw_rdev_open(struct c4iw_rdev *rdev)
 		pr_err(MOD "%s: unsupported udb/ucq densities %u/%u\n",
 		       pci_name(rdev->lldi.pdev), rdev->lldi.udb_density,
 		       rdev->lldi.ucq_density);
-		err = -EINVAL;
-		goto err1;
+		return -EINVAL;
 	}
 	if (rdev->lldi.vr->qp.start != rdev->lldi.vr->cq.start ||
 	    rdev->lldi.vr->qp.size != rdev->lldi.vr->cq.size) {
@@ -791,8 +784,7 @@ static int c4iw_rdev_open(struct c4iw_rdev *rdev)
 		       pci_name(rdev->lldi.pdev), rdev->lldi.vr->qp.start,
 		       rdev->lldi.vr->qp.size, rdev->lldi.vr->cq.size,
 		       rdev->lldi.vr->cq.size);
-		err = -EINVAL;
-		goto err1;
+		return -EINVAL;
 	}
 
 	rdev->qpmask = rdev->lldi.udb_density - 1;
@@ -816,10 +808,8 @@ static int c4iw_rdev_open(struct c4iw_rdev *rdev)
 	     rdev->lldi.db_reg, rdev->lldi.gts_reg,
 	     rdev->qpmask, rdev->cqmask);
 
-	if (c4iw_num_stags(rdev) == 0) {
-		err = -EINVAL;
-		goto err1;
-	}
+	if (c4iw_num_stags(rdev) == 0)
+		return -EINVAL;
 
 	rdev->stats.pd.total = T4_MAX_NUM_PD;
 	rdev->stats.stag.total = rdev->lldi.vr->stag.size;
@@ -831,22 +821,22 @@ static int c4iw_rdev_open(struct c4iw_rdev *rdev)
 	err = c4iw_init_resource(rdev, c4iw_num_stags(rdev), T4_MAX_NUM_PD);
 	if (err) {
 		printk(KERN_ERR MOD "error %d initializing resources\n", err);
-		goto err1;
+		return err;
 	}
 	err = c4iw_pblpool_create(rdev);
 	if (err) {
 		printk(KERN_ERR MOD "error %d initializing pbl pool\n", err);
-		goto err2;
+		goto destroy_resource;
 	}
 	err = c4iw_rqtpool_create(rdev);
 	if (err) {
 		printk(KERN_ERR MOD "error %d initializing rqt pool\n", err);
-		goto err3;
+		goto destroy_pblpool;
 	}
 	err = c4iw_ocqp_pool_create(rdev);
 	if (err) {
 		printk(KERN_ERR MOD "error %d initializing ocqp pool\n", err);
-		goto err4;
+		goto destroy_rqtpool;
 	}
 	rdev->status_page = (struct t4_dev_status_page *)
 			    __get_free_page(GFP_KERNEL);
@@ -875,13 +865,12 @@ static int c4iw_rdev_open(struct c4iw_rdev *rdev)
 	return 0;
 destroy_ocqp_pool:
 	c4iw_ocqp_pool_destroy(rdev);
-err4:
+destroy_rqtpool:
 	c4iw_rqtpool_destroy(rdev);
-err3:
+destroy_pblpool:
 	c4iw_pblpool_destroy(rdev);
-err2:
+destroy_resource:
 	c4iw_destroy_resource(&rdev->resource);
-err1:
 	return err;
 }
 
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
