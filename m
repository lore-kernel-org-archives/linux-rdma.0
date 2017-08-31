From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 3/5] verbs: Use ccan list.h instead of open coding lists
Date: Thu, 31 Aug 2017 14:50:57 -0600
Message-ID: <1504212659-9674-4-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1504212659-9674-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1504212659-9674-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

For ibv_sysfs_dev, ibv_driver_name and ibv_driver internal structs. ccan
lists are easier to understand and use than the open coded versions.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibverbs/init.c | 62 +++++++++++++++++++++++++------------------------------
 1 file changed, 28 insertions(+), 34 deletions(-)

diff --git a/libibverbs/init.c b/libibverbs/init.c
index e0fa4caae6f125..91ce8b4e378458 100644
--- a/libibverbs/init.c
+++ b/libibverbs/init.c
@@ -47,17 +47,18 @@
 #include <errno.h>
 #include <assert.h>
 
+#include <ccan/list.h>
 #include <util/util.h>
 #include "ibverbs.h"
 
 int abi_ver;
 
 struct ibv_sysfs_dev {
+	struct list_node	entry;
 	char		        sysfs_name[IBV_SYSFS_NAME_MAX];
 	char		        ibdev_name[IBV_SYSFS_NAME_MAX];
 	char		        sysfs_path[IBV_SYSFS_PATH_MAX];
 	char		        ibdev_path[IBV_SYSFS_PATH_MAX];
-	struct ibv_sysfs_dev   *next;
 	int			abi_ver;
 	int			have_driver;
 	struct timespec		time_created;
@@ -65,20 +66,20 @@ struct ibv_sysfs_dev {
 };
 
 struct ibv_driver_name {
+	struct list_node	entry;
 	char		       *name;
-	struct ibv_driver_name *next;
 };
 
 struct ibv_driver {
+	struct list_node	entry;
 	const char	       *name;
 	verbs_driver_init_func	verbs_init_func;
-	struct ibv_driver      *next;
 };
 
-static struct ibv_driver_name *driver_name_list;
-static struct ibv_driver *head_driver, *tail_driver;
+static LIST_HEAD(driver_name_list);
+static LIST_HEAD(driver_list);
 
-static int find_sysfs_devs(struct ibv_sysfs_dev **tmp_sysfs_dev_list)
+static int find_sysfs_devs(struct list_head *tmp_sysfs_dev_list)
 {
 	char class_path[IBV_SYSFS_PATH_MAX];
 	DIR *class_dir;
@@ -147,7 +148,6 @@ static int find_sysfs_devs(struct ibv_sysfs_dev **tmp_sysfs_dev_list)
 
 		sysfs_dev->time_created = buf.st_mtim;
 
-		sysfs_dev->next        = *tmp_sysfs_dev_list;
 		sysfs_dev->have_driver = 0;
 		sysfs_dev->used = 0;
 		if (ibv_read_sysfs_file(sysfs_dev->sysfs_path, "abi_version",
@@ -156,7 +156,8 @@ static int find_sysfs_devs(struct ibv_sysfs_dev **tmp_sysfs_dev_list)
 		else
 			sysfs_dev->abi_ver = 0;
 
-		*tmp_sysfs_dev_list = sysfs_dev;
+		list_node_init(&sysfs_dev->entry);
+		list_add(tmp_sysfs_dev_list, &sysfs_dev->entry);
 		sysfs_dev      = NULL;
 	}
 
@@ -181,13 +182,9 @@ void verbs_register_driver(const char *name,
 
 	driver->name            = name;
 	driver->verbs_init_func = verbs_init_func;
-	driver->next            = NULL;
 
-	if (tail_driver)
-		tail_driver->next = driver;
-	else
-		head_driver = driver;
-	tail_driver = driver;
+	list_node_init(&driver->entry);
+	list_add_tail(&driver_list, &driver->entry);
 }
 
 static void load_driver(const char *name)
@@ -261,9 +258,7 @@ static void load_drivers(void)
 		}
 	}
 
-	for (name = driver_name_list, next_name = name ? name->next : NULL;
-	     name;
-	     name = next_name, next_name = name ? name->next : NULL) {
+	list_for_each_safe(&driver_name_list, name, next_name, entry) {
 		load_driver(name->name);
 		free(name->name);
 		free(name);
@@ -314,8 +309,8 @@ static void read_config_file(const char *path)
 				continue;
 			}
 
-			driver_name->next = driver_name_list;
-			driver_name_list  = driver_name;
+			list_node_init(&driver_name->entry);
+			list_add(&driver_name_list, &driver_name->entry);
 		} else
 			fprintf(stderr, PFX "Warning: ignoring bad config directive "
 				"'%s' in file '%s'.\n", field, path);
@@ -427,7 +422,7 @@ static struct verbs_device *try_drivers(struct ibv_sysfs_dev *sysfs_dev)
 	struct ibv_driver *driver;
 	struct verbs_device *dev;
 
-	for (driver = head_driver; driver; driver = driver->next) {
+	list_for_each(&driver_list, driver, entry) {
 		dev = try_driver(driver, sysfs_dev);
 		if (dev)
 			return dev;
@@ -488,7 +483,8 @@ static int same_sysfs_dev(struct ibv_sysfs_dev *sysfs1,
 
 int ibverbs_get_device_list(struct list_head *list)
 {
-	struct ibv_sysfs_dev *tmp_sysfs_dev_list = NULL, *sysfs_dev, *next_dev;
+	LIST_HEAD(tmp_sysfs_dev_list);
+	struct ibv_sysfs_dev *sysfs_dev, *next_dev;
 	struct verbs_device *vdev, *tmp;
 	static int drivers_loaded;
 	int num_devices = 0;
@@ -501,23 +497,25 @@ int ibverbs_get_device_list(struct list_head *list)
 		return -ret;
 
 	list_for_each_safe(list, vdev, tmp, entry) {
-		for (sysfs_dev = tmp_sysfs_dev_list; sysfs_dev; sysfs_dev =
-		     sysfs_dev->next) {
+		struct ibv_sysfs_dev *old_sysfs = NULL;
+
+		list_for_each(&tmp_sysfs_dev_list, sysfs_dev, entry) {
 			if (same_sysfs_dev(vdev->sysfs, sysfs_dev)) {
-				sysfs_dev->have_driver = 1;
-				num_devices++;
+				old_sysfs = sysfs_dev;
 				break;
 			}
 		}
 
-		if (!sysfs_dev) {
+		if (old_sysfs) {
+			sysfs_dev->have_driver = 1;
+			num_devices++;
+		} else {
 			list_del(&vdev->entry);
 			ibverbs_device_put(&vdev->device);
 		}
 	}
 
-	for (sysfs_dev = tmp_sysfs_dev_list; sysfs_dev; sysfs_dev =
-	     sysfs_dev->next) {
+	list_for_each(&tmp_sysfs_dev_list, sysfs_dev, entry) {
 		if (sysfs_dev->have_driver)
 			continue;
 		vdev = try_drivers(sysfs_dev);
@@ -555,8 +553,7 @@ int ibverbs_get_device_list(struct list_head *list)
 	load_drivers();
 	drivers_loaded = 1;
 
-	for (sysfs_dev = tmp_sysfs_dev_list; sysfs_dev; sysfs_dev =
-	     sysfs_dev->next) {
+	list_for_each(&tmp_sysfs_dev_list, sysfs_dev, entry) {
 		if (sysfs_dev->have_driver)
 			continue;
 
@@ -569,10 +566,7 @@ int ibverbs_get_device_list(struct list_head *list)
 	}
 
 out:
-	for (sysfs_dev = tmp_sysfs_dev_list,
-	     next_dev = sysfs_dev ? sysfs_dev->next : NULL;
-	     sysfs_dev;
-	     sysfs_dev = next_dev, next_dev = sysfs_dev ? sysfs_dev->next : NULL) {
+	list_for_each_safe(&tmp_sysfs_dev_list, sysfs_dev, next_dev, entry) {
 		if (!sysfs_dev->have_driver && getenv("IBV_SHOW_WARNINGS")) {
 			fprintf(stderr, PFX "Warning: no userspace device-specific "
 				"driver found for %s\n", sysfs_dev->sysfs_path);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
