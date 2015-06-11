From: clsoto-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
Subject: [PATCH] IB/ucm: ib_ucm_release_dev clears wrong bit if devnum is greater than IB_UCM_MAX_DEVICES
Date: Thu, 11 Jun 2015 11:06:41 -0500
Message-ID: <1434038801-6513-1-git-send-email-clsoto@linux.vnet.ibm.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Carol L Soto <clsoto-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Carol L Soto <clsoto-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

ib_ucm_release_dev clears wrong bit if devnum is greater than IB_UCM_MAX_DEVICES.

Signed-off-by: Carol L Soto <clsoto-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/infiniband/core/ucm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index f2f6393..e2fd085 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -1193,6 +1193,7 @@ static int ib_ucm_close(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+static DECLARE_BITMAP(overflow_map, IB_UCM_MAX_DEVICES);
 static void ib_ucm_release_dev(struct device *dev)
 {
 	struct ib_ucm_device *ucm_dev;
@@ -1202,7 +1203,7 @@ static void ib_ucm_release_dev(struct device *dev)
 	if (ucm_dev->devnum < IB_UCM_MAX_DEVICES)
 		clear_bit(ucm_dev->devnum, dev_map);
 	else
-		clear_bit(ucm_dev->devnum - IB_UCM_MAX_DEVICES, dev_map);
+		clear_bit(ucm_dev->devnum - IB_UCM_MAX_DEVICES, overflow_map);
 	kfree(ucm_dev);
 }
 
@@ -1226,7 +1227,6 @@ static ssize_t show_ibdev(struct device *dev, struct device_attribute *attr,
 static DEVICE_ATTR(ibdev, S_IRUGO, show_ibdev, NULL);
 
 static dev_t overflow_maj;
-static DECLARE_BITMAP(overflow_map, IB_UCM_MAX_DEVICES);
 static int find_overflow_devnum(void)
 {
 	int ret;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
