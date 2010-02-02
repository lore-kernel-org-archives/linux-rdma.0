From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v2 05/18] IB/uverbs: increase maximum devices supported
Date: Tue, 02 Feb 2010 12:08:09 -0700
Message-ID: <20100202190809.28217.50581.stgit@bob.kio>
References: <20100202185235.28217.64521.stgit@bob.kio>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100202185235.28217.64521.stgit@bob.kio>
Sender: linux-kernel-owner@vger.kernel.org
To: rdreier@cisco.com
Cc: linux-rdma@vger.kernel.org, justin.chen@hp.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Some large systems may support more than IB_UVERBS_MAX_DEVICES
(currently 32).

This change allows us to support more devices in a backwards-compatible
manner. The first IB_UVERBS_MAX_DEVICES keep the same major/minor
device numbers that they've always had.

If there are more than IB_UVERBS_MAX_DEVICES, we then dynamically
request a new major device number (new minors start at 0).

This change increases the maximum number of HCAs to 64 (from 32).

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/infiniband/core/uverbs_main.c |   56 +++++++++++++++++++++++++++++----
 1 files changed, 50 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 8c594cd..38b9085 100644
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
 	int devnum;
@@ -748,11 +776,19 @@ static void ib_uverbs_add_one(struct ib_device *device)
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
@@ -785,7 +821,10 @@ err_class:
 
 err_cdev:
 	cdev_del(&uverbs_dev->cdev);
-	clear_bit(devnum, dev_map);
+	if (uverbs_dev->devnum < IB_UVERBS_MAX_DEVICES)
+		clear_bit(devnum, dev_map);
+	else
+		clear_bit(devnum, oflo_map);
 
 err:
 	kref_put(&uverbs_dev->ref, ib_uverbs_release_dev);
@@ -805,7 +844,10 @@ static void ib_uverbs_remove_one(struct ib_device *device)
 	device_destroy(uverbs_class, uverbs_dev->cdev.dev);
 	cdev_del(&uverbs_dev->cdev);
 
-	clear_bit(uverbs_dev->devnum, dev_map);
+	if (uverbs_dev->devnum < IB_UVERBS_MAX_DEVICES)
+		clear_bit(uverbs_dev->devnum, dev_map);
+	else
+		clear_bit(uverbs_dev->devnum - IB_UVERBS_MAX_DEVICES, oflo_map);
 
 	kref_put(&uverbs_dev->ref, ib_uverbs_release_dev);
 	wait_for_completion(&uverbs_dev->comp);
@@ -895,6 +937,8 @@ static void __exit ib_uverbs_cleanup(void)
 	unregister_filesystem(&uverbs_event_fs);
 	class_destroy(uverbs_class);
 	unregister_chrdev_region(IB_UVERBS_BASE_DEV, IB_UVERBS_MAX_DEVICES);
+	if (oflo_maj)
+		unregister_chrdev_region(oflo_maj, IB_UVERBS_MAX_DEVICES);
 	idr_destroy(&ib_uverbs_pd_idr);
 	idr_destroy(&ib_uverbs_mr_idr);
 	idr_destroy(&ib_uverbs_mw_idr);
