From: Alex Chiang <achiang-VXdhtT5mjnY@public.gmane.org>
Subject: [PATCH 5/7] IB/uverbs: increase maximum devices supported
Date: Fri, 29 Jan 2010 14:45:23 -0700
Message-ID: <20100129214523.17745.50686.stgit@bob.kio>
References: <20100129214039.17745.38679.stgit@bob.kio>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100129214039.17745.38679.stgit-tBlMHHroXgg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, justin.chen-VXdhtT5mjnY@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Some large systems may support more than IB_UVERBS_MAX_DEVICES
(currently 32).

This change allows us to support more devices in a backwards-compatible
manner. The first IB_UVERBS_MAX_DEVICES keep the same major/minor
device numbers that they've always had.

If there are more than IB_UVERBS_MAX_DEVICES, we then dynamically
request a new major device number (new minors start at 0).

This change increases the maximum number of HCAs to 64 (from 32).

Signed-off-by: Alex Chiang <achiang-VXdhtT5mjnY@public.gmane.org>
---

 drivers/infiniband/core/uverbs_main.c |   56 +++++++++++++++++++++++++++++----
 1 files changed, 50 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index a5d441d..0555460 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -728,6 +728,34 @@ static ssize_t show_abi_version(struct class *class, char *buf)
 }
 static CLASS_ATTR(abi_version, S_IRUGO, show_abi_version, NULL);
 
+static dev_t oflo_maj;
+static DECLARE_BITMAP(oflo_map, IB_UVERBS_MAX_DEVICES);
+
+/*
+ * If we have more than IB_UVERBS_MAX_DEVICES, dynamically overflow by
+ * requesting a new major number and doubling the number of max devices we
+ * support. It's stupid, but simple.
+ */
+static int find_oflo_devnum(void)
+{
+	int ret;
+
+	if (!oflo_maj) {
+		ret = alloc_chrdev_region(&oflo_maj, 0, IB_UVERBS_MAX_DEVICES,
+					  "infiniband_verbs");
+		if (ret) {
+			printk(KERN_ERR "user_verbs: couldn't register dynamic device number\n");
+			return ret;
+		}
+	}
+
+	ret = find_first_zero_bit(oflo_map, IB_UVERBS_MAX_DEVICES);
+	if (ret >= IB_UVERBS_MAX_DEVICES)
+		return -1;
+
+	return ret;
+}
+
 static void ib_uverbs_add_one(struct ib_device *device)
 {
 	int devnum, base;
@@ -747,11 +775,19 @@ static void ib_uverbs_add_one(struct ib_device *device)
 	devnum = find_first_zero_bit(dev_map, IB_UVERBS_MAX_DEVICES);
 	if (devnum >= IB_UVERBS_MAX_DEVICES) {
 		spin_unlock(&map_lock);
-		goto err;
+		devnum = find_oflo_devnum();
+		if (devnum < 0)
+			goto err;
+
+		spin_lock(&map_lock);
+		uverbs_dev->devnum = devnum + IB_UVERBS_MAX_DEVICES;
+		base = devnum + oflo_maj;
+		set_bit(devnum, oflo_map);
+	} else {
+		uverbs_dev->devnum = devnum;
+		base = devnum + IB_UVERBS_BASE_DEV;
+		set_bit(devnum, dev_map);
 	}
-	uverbs_dev->devnum = devnum;
-	base = devnum + IB_UVERBS_BASE_DEV;
-	set_bit(devnum, dev_map);
 	spin_unlock(&map_lock);
 
 	uverbs_dev->ib_dev           = device;
@@ -784,7 +820,10 @@ err_class:
 
 err_cdev:
 	cdev_del(&uverbs_dev->cdev);
-	clear_bit(devnum, dev_map);
+	if (oflo_maj)
+		clear_bit(devnum, oflo_map);
+	else
+		clear_bit(devnum, dev_map);
 
 err:
 	kref_put(&uverbs_dev->ref, ib_uverbs_release_dev);
@@ -804,7 +843,10 @@ static void ib_uverbs_remove_one(struct ib_device *device)
 	device_destroy(uverbs_class, uverbs_dev->cdev.dev);
 	cdev_del(&uverbs_dev->cdev);
 
-	clear_bit(uverbs_dev->devnum, dev_map);
+	if (uverbs_dev->devnum < IB_UVERBS_MAX_DEVICES)
+		clear_bit(uverbs_dev->devnum, dev_map);
+	else
+		clear_bit(uverbs_dev->devnum - IB_UVERBS_MAX_DEVICES, oflo_map);
 
 	kref_put(&uverbs_dev->ref, ib_uverbs_release_dev);
 	wait_for_completion(&uverbs_dev->comp);
@@ -894,6 +936,8 @@ static void __exit ib_uverbs_cleanup(void)
 	unregister_filesystem(&uverbs_event_fs);
 	class_destroy(uverbs_class);
 	unregister_chrdev_region(IB_UVERBS_BASE_DEV, IB_UVERBS_MAX_DEVICES);
+	if (oflo_maj)
+		unregister_chrdev_region(oflo_maj, IB_UVERBS_MAX_DEVICES);
 	idr_destroy(&ib_uverbs_pd_idr);
 	idr_destroy(&ib_uverbs_mr_idr);
 	idr_destroy(&ib_uverbs_mw_idr);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
