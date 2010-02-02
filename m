From: Alex Chiang <achiang-VXdhtT5mjnY@public.gmane.org>
Subject: [PATCH v2 02/18] IB/uverbs: remove dev_table
Date: Tue, 02 Feb 2010 12:07:54 -0700
Message-ID: <20100202190754.28217.48388.stgit@bob.kio>
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

dev_table's raison d'etre was to associate an inode back to a
struct ib_uverbs_device.

However, now that we've converted ib_uverbs_device to contain
an embedded cdev (instead of a *cdev), we can use the container_of()
macro and cast back to the containing device.

There's no longer any need for dev_table, so get rid of it.

Signed-off-by: Alex Chiang <achiang-VXdhtT5mjnY@public.gmane.org>
---

 drivers/infiniband/core/uverbs_main.c |   24 +++++-------------------
 1 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 5da9a73..3f11292 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -74,7 +74,6 @@ DEFINE_IDR(ib_uverbs_qp_idr);
 DEFINE_IDR(ib_uverbs_srq_idr);
 
 static DEFINE_SPINLOCK(map_lock);
-static struct ib_uverbs_device *dev_table[IB_UVERBS_MAX_DEVICES];
 static DECLARE_BITMAP(dev_map, IB_UVERBS_MAX_DEVICES);
 
 static ssize_t (*uverbs_cmd_table[])(struct ib_uverbs_file *file,
@@ -616,14 +615,12 @@ static int ib_uverbs_mmap(struct file *filp, struct vm_area_struct *vma)
 /*
  * ib_uverbs_open() does not need the BKL:
  *
- *  - dev_table[] accesses are protected by map_lock, the
- *    ib_uverbs_device structures are properly reference counted, and
+ *  - the ib_uverbs_device structures are properly reference counted and
  *    everything else is purely local to the file being created, so
  *    races against other open calls are not a problem;
  *  - there is no ioctl method to race against;
- *  - the device is added to dev_table[] as the last part of module
- *    initialization, the open method will either immediately run
- *    -ENXIO, or all required initialization will be done.
+ *  - the open method will either immediately run -ENXIO, or all
+ *    required initialization will be done.
  */
 static int ib_uverbs_open(struct inode *inode, struct file *filp)
 {
@@ -631,13 +628,10 @@ static int ib_uverbs_open(struct inode *inode, struct file *filp)
 	struct ib_uverbs_file *file;
 	int ret;
 
-	spin_lock(&map_lock);
-	dev = dev_table[iminor(inode) - IB_UVERBS_BASE_MINOR];
+	dev = container_of(inode->i_cdev, struct ib_uverbs_device, cdev);
 	if (dev)
 		kref_get(&dev->ref);
-	spin_unlock(&map_lock);
-
-	if (!dev)
+	else
 		return -ENXIO;
 
 	if (!try_module_get(dev->ib_dev->owner)) {
@@ -778,10 +772,6 @@ static void ib_uverbs_add_one(struct ib_device *device)
 	if (device_create_file(uverbs_dev->dev, &dev_attr_abi_version))
 		goto err_class;
 
-	spin_lock(&map_lock);
-	dev_table[uverbs_dev->devnum] = uverbs_dev;
-	spin_unlock(&map_lock);
-
 	ib_set_client_data(device, &uverbs_client, uverbs_dev);
 
 	return;
@@ -811,10 +801,6 @@ static void ib_uverbs_remove_one(struct ib_device *device)
 	device_destroy(uverbs_class, uverbs_dev->cdev.dev);
 	cdev_del(&uverbs_dev->cdev);
 
-	spin_lock(&map_lock);
-	dev_table[uverbs_dev->devnum] = NULL;
-	spin_unlock(&map_lock);
-
 	clear_bit(uverbs_dev->devnum, dev_map);
 
 	kref_put(&uverbs_dev->ref, ib_uverbs_release_dev);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
