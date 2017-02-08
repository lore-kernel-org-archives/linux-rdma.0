From: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: [PATCH 05/14] RDMA/cxgb4: Return an error code only as a constant in
 ep_open()
Date: Wed, 8 Feb 2017 22:15:17 +0100
Message-ID: <ddc093e4-c3ea-4cbd-a6f2-4bf3f4a63ea2@users.sourceforge.net>
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
Date: Wed, 8 Feb 2017 16:36:31 +0100

* Return an error code without storing it in an intermediate variable.

* Adjust jump targets according to the Linux coding style convention.

* Delete the local variable "ret" which became unnecessary with
  this refactoring.

Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/device.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 46410c4a9afb..51801a7d4fb3 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -679,14 +679,12 @@ static int ep_release(struct inode *inode, struct file *file)
 static int ep_open(struct inode *inode, struct file *file)
 {
 	struct c4iw_debugfs_data *epd;
-	int ret = 0;
 	int count = 1;
 
 	epd = kmalloc(sizeof(*epd), GFP_KERNEL);
-	if (!epd) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!epd)
+		goto failure_indication;
+
 	epd->devp = inode->i_private;
 	epd->pos = 0;
 
@@ -698,10 +696,8 @@ static int ep_open(struct inode *inode, struct file *file)
 
 	epd->bufsize = count * 240;
 	epd->buf = vmalloc(epd->bufsize);
-	if (!epd->buf) {
-		ret = -ENOMEM;
-		goto err1;
-	}
+	if (!epd->buf)
+		goto free_epd;
 
 	spin_lock_irq(&epd->devp->lock);
 	idr_for_each(&epd->devp->hwtid_idr, dump_ep, epd);
@@ -710,11 +706,11 @@ static int ep_open(struct inode *inode, struct file *file)
 	spin_unlock_irq(&epd->devp->lock);
 
 	file->private_data = epd;
-	goto out;
-err1:
+	return 0;
+free_epd:
 	kfree(epd);
-out:
-	return ret;
+failure_indication:
+	return -ENOMEM;
 }
 
 static const struct file_operations ep_debugfs_fops = {
-- 
2.11.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
