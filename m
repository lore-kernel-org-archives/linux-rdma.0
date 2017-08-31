From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 4/5] verbs: Tidy up ibverbs_get_device_list
Date: Thu, 31 Aug 2017 14:50:58 -0600
Message-ID: <1504212659-9674-5-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1504212659-9674-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1504212659-9674-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Now that we have ccan lists the logic here can be simplified greatly.
Eliminate the confusing used and have_driver values, instead just
delete items from the sysfs list as we run down the process. This
directly guarantees discovered sysfs items are handled only once,
and makes the lifetime of the sysfs pointers much clearer.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibverbs/init.c | 93 +++++++++++++++++++++++++++++--------------------------
 1 file changed, 49 insertions(+), 44 deletions(-)

diff --git a/libibverbs/init.c b/libibverbs/init.c
index 91ce8b4e378458..04583bb5137c96 100644
--- a/libibverbs/init.c
+++ b/libibverbs/init.c
@@ -60,9 +60,7 @@ struct ibv_sysfs_dev {
 	char		        sysfs_path[IBV_SYSFS_PATH_MAX];
 	char		        ibdev_path[IBV_SYSFS_PATH_MAX];
 	int			abi_ver;
-	int			have_driver;
 	struct timespec		time_created;
-	int			used;
 };
 
 struct ibv_driver_name {
@@ -148,8 +146,6 @@ static int find_sysfs_devs(struct list_head *tmp_sysfs_dev_list)
 
 		sysfs_dev->time_created = buf.st_mtim;
 
-		sysfs_dev->have_driver = 0;
-		sysfs_dev->used = 0;
 		if (ibv_read_sysfs_file(sysfs_dev->sysfs_path, "abi_version",
 					value, sizeof value) > 0)
 			sysfs_dev->abi_ver = strtol(value, NULL, 10);
@@ -412,7 +408,6 @@ static struct verbs_device *try_driver(struct ibv_driver *driver,
 	strcpy(dev->name,       sysfs_dev->ibdev_name);
 	strcpy(dev->ibdev_path, sysfs_dev->ibdev_path);
 	vdev->sysfs = sysfs_dev;
-	sysfs_dev->used = 1;
 
 	return vdev;
 }
@@ -481,25 +476,51 @@ static int same_sysfs_dev(struct ibv_sysfs_dev *sysfs1,
 	return 0;
 }
 
-int ibverbs_get_device_list(struct list_head *list)
+/* Match every ibv_sysfs_dev in the sysfs_list to a driver and add a new entry
+ * to device_list. Once matched to a driver the entry in sysfs_list is
+ * removed.
+ */
+static void try_all_drivers(struct list_head *sysfs_list,
+			    struct list_head *device_list,
+			    unsigned int *num_devices)
+{
+	struct ibv_sysfs_dev *sysfs_dev;
+	struct ibv_sysfs_dev *tmp;
+	struct verbs_device *vdev;
+
+	list_for_each_safe(sysfs_list, sysfs_dev, tmp, entry) {
+		vdev = try_drivers(sysfs_dev);
+		if (vdev) {
+			list_del(&sysfs_dev->entry);
+			// Ownership of sysfs_dev moves into vdev->sysfs
+			list_add(device_list, &vdev->entry);
+			(*num_devices)++;
+		}
+	}
+}
+
+int ibverbs_get_device_list(struct list_head *device_list)
 {
-	LIST_HEAD(tmp_sysfs_dev_list);
+	LIST_HEAD(sysfs_list);
 	struct ibv_sysfs_dev *sysfs_dev, *next_dev;
 	struct verbs_device *vdev, *tmp;
 	static int drivers_loaded;
-	int num_devices = 0;
+	unsigned int num_devices = 0;
 	int statically_linked = 0;
-	int no_driver = 0;
 	int ret;
 
-	ret = find_sysfs_devs(&tmp_sysfs_dev_list);
+	ret = find_sysfs_devs(&sysfs_list);
 	if (ret)
 		return -ret;
 
-	list_for_each_safe(list, vdev, tmp, entry) {
+	/* Remove entries from the sysfs_list that are already preset in the
+	 * device_list, and remove entries from the device_list that are not
+	 * present in the sysfs_list.
+	 */
+	list_for_each_safe(device_list, vdev, tmp, entry) {
 		struct ibv_sysfs_dev *old_sysfs = NULL;
 
-		list_for_each(&tmp_sysfs_dev_list, sysfs_dev, entry) {
+		list_for_each(&sysfs_list, sysfs_dev, entry) {
 			if (same_sysfs_dev(vdev->sysfs, sysfs_dev)) {
 				old_sysfs = sysfs_dev;
 				break;
@@ -507,7 +528,8 @@ int ibverbs_get_device_list(struct list_head *list)
 		}
 
 		if (old_sysfs) {
-			sysfs_dev->have_driver = 1;
+			list_del(&old_sysfs->entry);
+			free(old_sysfs);
 			num_devices++;
 		} else {
 			list_del(&vdev->entry);
@@ -515,19 +537,9 @@ int ibverbs_get_device_list(struct list_head *list)
 		}
 	}
 
-	list_for_each(&tmp_sysfs_dev_list, sysfs_dev, entry) {
-		if (sysfs_dev->have_driver)
-			continue;
-		vdev = try_drivers(sysfs_dev);
-		if (vdev) {
-			sysfs_dev->have_driver = 1;
-			list_add(list, &vdev->entry);
-			num_devices++;
-		} else
-			no_driver = 1;
-	}
+	try_all_drivers(&sysfs_list, device_list, &num_devices);
 
-	if (!no_driver || drivers_loaded)
+	if (list_empty(&sysfs_list) || drivers_loaded)
 		goto out;
 
 	/*
@@ -553,29 +565,22 @@ int ibverbs_get_device_list(struct list_head *list)
 	load_drivers();
 	drivers_loaded = 1;
 
-	list_for_each(&tmp_sysfs_dev_list, sysfs_dev, entry) {
-		if (sysfs_dev->have_driver)
-			continue;
-
-		vdev = try_drivers(sysfs_dev);
-		if (vdev) {
-			sysfs_dev->have_driver = 1;
-			list_add(list, &vdev->entry);
-			num_devices++;
-		}
-	}
+	try_all_drivers(&sysfs_list, device_list, &num_devices);
 
 out:
-	list_for_each_safe(&tmp_sysfs_dev_list, sysfs_dev, next_dev, entry) {
-		if (!sysfs_dev->have_driver && getenv("IBV_SHOW_WARNINGS")) {
-			fprintf(stderr, PFX "Warning: no userspace device-specific "
-				"driver found for %s\n", sysfs_dev->sysfs_path);
+	/* Anything left in sysfs_list was not assoicated with a
+	 * driver.
+	 */
+	list_for_each_safe(&sysfs_list, sysfs_dev, next_dev, entry) {
+		if (getenv("IBV_SHOW_WARNINGS")) {
+			fprintf(stderr, PFX
+				"Warning: no userspace device-specific driver found for %s\n",
+				sysfs_dev->sysfs_path);
 			if (statically_linked)
-				fprintf(stderr, "	When linking libibverbs statically, "
-					"driver must be statically linked too.\n");
+				fprintf(stderr,
+					"	When linking libibverbs statically, driver must be statically linked too.\n");
 		}
-		if (!sysfs_dev->used)
-			free(sysfs_dev);
+		free(sysfs_dev);
 	}
 
 	return num_devices;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
