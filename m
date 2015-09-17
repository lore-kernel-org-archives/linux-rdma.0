From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH V2] IB/hfi: Properly set permissions for user device files
Date: Thu, 17 Sep 2015 13:47:49 -0400
Message-ID: <1442512069-29793-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Michal Schmidt <mschmidt-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haralanov-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org, "mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <Mitko-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Some of the device files are required to be user accessible for PSM while
most should remain accessible only by root.

Add a parameter to hfi1_cdev_init which controls if the user should have access
to this device which places it in a different class with the appropriate
devnode callback.

In addition set the devnode call back for the existing class to be a bit more
explicit for those permissions.

Finally remove the unnecessary null check before class_destroy

Tested-by: Donald Dutile <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Haralanov, Mitko (mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org)
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---

Changes from V1:
	Fixed typo in error message
	added missing goto on error
	Remove null checks for class
	set user_class to NULL on error

 drivers/staging/rdma/hfi1/device.c   | 54 ++++++++++++++++++++++++++++++++----
 drivers/staging/rdma/hfi1/device.h   |  3 +-
 drivers/staging/rdma/hfi1/diag.c     |  5 ++--
 drivers/staging/rdma/hfi1/file_ops.c |  9 ++++--
 4 files changed, 59 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/device.c b/drivers/staging/rdma/hfi1/device.c
index 07c87a87775f..bc26a5392712 100644
--- a/drivers/staging/rdma/hfi1/device.c
+++ b/drivers/staging/rdma/hfi1/device.c
@@ -57,11 +57,13 @@
 #include "device.h"
 
 static struct class *class;
+static struct class *user_class;
 static dev_t hfi1_dev;
 
 int hfi1_cdev_init(int minor, const char *name,
 		   const struct file_operations *fops,
-		   struct cdev *cdev, struct device **devp)
+		   struct cdev *cdev, struct device **devp,
+		   bool user_accessible)
 {
 	const dev_t dev = MKDEV(MAJOR(hfi1_dev), minor);
 	struct device *device = NULL;
@@ -78,7 +80,11 @@ int hfi1_cdev_init(int minor, const char *name,
 		goto done;
 	}
 
-	device = device_create(class, NULL, dev, NULL, "%s", name);
+	if (user_accessible)
+		device = device_create(user_class, NULL, dev, NULL, "%s", name);
+	else
+		device = device_create(class, NULL, dev, NULL, "%s", name);
+
 	if (!IS_ERR(device))
 		goto done;
 	ret = PTR_ERR(device);
@@ -110,6 +116,26 @@ const char *class_name(void)
 	return hfi1_class_name;
 }
 
+static char *hfi1_devnode(struct device *dev, umode_t *mode)
+{
+	if (mode)
+		*mode = 0600;
+	return kasprintf(GFP_KERNEL, "%s", dev_name(dev));
+}
+
+static const char *hfi1_class_name_user = "hfi1_user";
+const char *class_name_user(void)
+{
+	return hfi1_class_name_user;
+}
+
+static char *hfi1_user_devnode(struct device *dev, umode_t *mode)
+{
+	if (mode)
+		*mode = 0666;
+	return kasprintf(GFP_KERNEL, "%s", dev_name(dev));
+}
+
 int __init dev_init(void)
 {
 	int ret;
@@ -125,7 +151,22 @@ int __init dev_init(void)
 		ret = PTR_ERR(class);
 		pr_err("Could not create device class (err %d)\n", -ret);
 		unregister_chrdev_region(hfi1_dev, HFI1_NMINORS);
+		goto done;
 	}
+	class->devnode = hfi1_devnode;
+
+	user_class = class_create(THIS_MODULE, class_name_user());
+	if (IS_ERR(user_class)) {
+		ret = PTR_ERR(user_class);
+		pr_err("Could not create device class for user accessible files (err %d)\n",
+		       -ret);
+		class_destroy(class);
+		class = NULL;
+		user_class = NULL;
+		unregister_chrdev_region(hfi1_dev, HFI1_NMINORS);
+		goto done;
+	}
+	user_class->devnode = hfi1_user_devnode;
 
 done:
 	return ret;
@@ -133,10 +174,11 @@ done:
 
 void dev_cleanup(void)
 {
-	if (class) {
-		class_destroy(class);
-		class = NULL;
-	}
+	class_destroy(class);
+	class = NULL;
+
+	class_destroy(user_class);
+	user_class = NULL;
 
 	unregister_chrdev_region(hfi1_dev, HFI1_NMINORS);
 }
diff --git a/drivers/staging/rdma/hfi1/device.h b/drivers/staging/rdma/hfi1/device.h
index 98caecd3d807..2850ff739d81 100644
--- a/drivers/staging/rdma/hfi1/device.h
+++ b/drivers/staging/rdma/hfi1/device.h
@@ -52,7 +52,8 @@
 
 int hfi1_cdev_init(int minor, const char *name,
 		   const struct file_operations *fops,
-		   struct cdev *cdev, struct device **devp);
+		   struct cdev *cdev, struct device **devp,
+		   bool user_accessible);
 void hfi1_cdev_cleanup(struct cdev *cdev, struct device **devp);
 const char *class_name(void);
 int __init dev_init(void);
diff --git a/drivers/staging/rdma/hfi1/diag.c b/drivers/staging/rdma/hfi1/diag.c
index 6777d6b659cf..b87e4e942ae6 100644
--- a/drivers/staging/rdma/hfi1/diag.c
+++ b/drivers/staging/rdma/hfi1/diag.c
@@ -292,7 +292,7 @@ int hfi1_diag_add(struct hfi1_devdata *dd)
 	if (atomic_inc_return(&diagpkt_count) == 1) {
 		ret = hfi1_cdev_init(HFI1_DIAGPKT_MINOR, name,
 				     &diagpkt_file_ops, &diagpkt_cdev,
-				     &diagpkt_device);
+				     &diagpkt_device, false);
 	}
 
 	return ret;
@@ -592,7 +592,8 @@ static int hfi1_snoop_add(struct hfi1_devdata *dd, const char *name)
 
 	ret = hfi1_cdev_init(HFI1_SNOOP_CAPTURE_BASE + dd->unit, name,
 			     &snoop_file_ops,
-			     &dd->hfi1_snoop.cdev, &dd->hfi1_snoop.class_dev);
+			     &dd->hfi1_snoop.cdev, &dd->hfi1_snoop.class_dev,
+			     false);
 
 	if (ret) {
 		dd_dev_err(dd, "Couldn't create %s device: %d", name, ret);
diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index 469861750b76..625cca2da65c 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -2089,14 +2089,16 @@ static int user_add(struct hfi1_devdata *dd)
 
 	if (atomic_inc_return(&user_count) == 1) {
 		ret = hfi1_cdev_init(0, class_name(), &hfi1_file_ops,
-				     &wildcard_cdev, &wildcard_device);
+				     &wildcard_cdev, &wildcard_device,
+				     true);
 		if (ret)
 			goto done;
 	}
 
 	snprintf(name, sizeof(name), "%s_%d", class_name(), dd->unit);
 	ret = hfi1_cdev_init(dd->unit + 1, name, &hfi1_file_ops,
-			     &dd->user_cdev, &dd->user_device);
+			     &dd->user_cdev, &dd->user_device,
+			     true);
 	if (ret)
 		goto done;
 
@@ -2104,7 +2106,8 @@ static int user_add(struct hfi1_devdata *dd)
 		snprintf(name, sizeof(name),
 			 "%s_ui%d", class_name(), dd->unit);
 		ret = hfi1_cdev_init(dd->unit + UI_OFFSET, name, &ui_file_ops,
-				     &dd->ui_cdev, &dd->ui_device);
+				     &dd->ui_cdev, &dd->ui_device,
+				     false);
 		if (ret)
 			goto done;
 	}
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
