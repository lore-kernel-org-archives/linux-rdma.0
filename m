From: Alex Chiang <achiang-VXdhtT5mjnY@public.gmane.org>
Subject: [PATCH v2 14/18] IB/ucm: use stack variable 'devnum' in ib_ucm_add_one
Date: Tue, 02 Feb 2010 12:08:55 -0700
Message-ID: <20100202190855.28217.68785.stgit@bob.kio>
References: <20100202185235.28217.64521.stgit@bob.kio>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100202185235.28217.64521.stgit-tBlMHHroXgg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, justin.chen-VXdhtT5mjnY@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This change is not useful by itself, but sets us up for a future
change that allows us to dynamically allocate device numbers in case
we have more than IB_UCM_MAX_DEVICES in the system.

Signed-off-by: Alex Chiang <achiang-VXdhtT5mjnY@public.gmane.org>
---

 drivers/infiniband/core/ucm.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index f504c9b..7ff3300 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -1239,6 +1239,7 @@ static DEVICE_ATTR(ibdev, S_IRUGO, show_ibdev, NULL);
 
 static void ib_ucm_add_one(struct ib_device *device)
 {
+	int devnum;
 	struct ib_ucm_device *ucm_dev;
 
 	if (!device->alloc_ucontext ||
@@ -1251,16 +1252,17 @@ static void ib_ucm_add_one(struct ib_device *device)
 
 	ucm_dev->ib_dev = device;
 
-	ucm_dev->devnum = find_first_zero_bit(dev_map, IB_UCM_MAX_DEVICES);
-	if (ucm_dev->devnum >= IB_UCM_MAX_DEVICES)
+	devnum = find_first_zero_bit(dev_map, IB_UCM_MAX_DEVICES);
+	if (devnum >= IB_UCM_MAX_DEVICES)
 		goto err;
 
-	set_bit(ucm_dev->devnum, dev_map);
+	ucm_dev->devnum = devnum;
+	set_bit(devnum, dev_map);
 
 	cdev_init(&ucm_dev->cdev, &ucm_fops);
 	ucm_dev->cdev.owner = THIS_MODULE;
 	kobject_set_name(&ucm_dev->cdev.kobj, "ucm%d", ucm_dev->devnum);
-	if (cdev_add(&ucm_dev->cdev, IB_UCM_BASE_DEV + ucm_dev->devnum, 1))
+	if (cdev_add(&ucm_dev->cdev, IB_UCM_BASE_DEV + devnum, 1))
 		goto err;
 
 	ucm_dev->dev.class = &cm_class;
@@ -1281,7 +1283,7 @@ err_dev:
 	device_unregister(&ucm_dev->dev);
 err_cdev:
 	cdev_del(&ucm_dev->cdev);
-	clear_bit(ucm_dev->devnum, dev_map);
+	clear_bit(devnum, dev_map);
 err:
 	kfree(ucm_dev);
 	return;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
