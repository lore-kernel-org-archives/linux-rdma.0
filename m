From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 03/10] verbs: Split init_device into a match and alloc/bind step
Date: Tue, 19 Sep 2017 15:18:44 -0600
Message-ID: <1505855931-4956-4-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1505855931-4956-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1505855931-4956-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The match step determines if the provider should bind to the sysfs device,
and the allocation step creates the verbs_device and cleanly matches the
uninit_device step which frees it.

This split makes it simpler to factor out all the duplicated code in the
match step.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibverbs/driver.h | 21 ++++++++++++++-
 libibverbs/init.c   | 74 ++++++++++++++++++++++++++++++++++-------------------
 2 files changed, 68 insertions(+), 27 deletions(-)

diff --git a/libibverbs/driver.h b/libibverbs/driver.h
index f9f5cfa2308c2f..397441f49a0e5a 100644
--- a/libibverbs/driver.h
+++ b/libibverbs/driver.h
@@ -40,6 +40,7 @@
 #include <infiniband/kern-abi.h>
 #include <ccan/list.h>
 #include <config.h>
+#include <stdbool.h>
 
 #ifdef __cplusplus
 #  define BEGIN_C_DECLS extern "C" {
@@ -95,10 +96,27 @@ struct verbs_qp {
 	struct verbs_xrcd       *xrcd;
 };
 
+/* A rdma device detected in sysfs */
+struct verbs_sysfs_dev {
+	struct list_node entry;
+	void *provider_data;
+	char sysfs_name[IBV_SYSFS_NAME_MAX];
+	char ibdev_name[IBV_SYSFS_NAME_MAX];
+	char sysfs_path[IBV_SYSFS_PATH_MAX];
+	char ibdev_path[IBV_SYSFS_PATH_MAX];
+	int abi_ver;
+	struct timespec time_created;
+};
+
 /* Must change the PRIVATE IBVERBS_PRIVATE_ symbol if this is changed */
 struct verbs_device_ops {
 	const char *name;
 
+	int match_min_abi_version;
+	int match_max_abi_version;
+
+	bool (*match_device)(struct verbs_sysfs_dev *sysfs_dev);
+
 	/* Old interface, do not use in new code. */
 	struct ibv_context *(*alloc_context)(struct ibv_device *device,
 					     int cmd_fd);
@@ -110,6 +128,7 @@ struct verbs_device_ops {
 	void (*uninit_context)(struct verbs_device *device,
 			       struct ibv_context *ctx);
 
+	struct verbs_device *(*alloc_device)(struct verbs_sysfs_dev *sysfs_dev);
 	struct verbs_device *(*init_device)(const char *uverbs_sys_path,
 					    int abi_version);
 	void (*uninit_device)(struct verbs_device *device);
@@ -123,7 +142,7 @@ struct verbs_device {
 	size_t	size_of_context;
 	atomic_int refcount;
 	struct list_node entry;
-	struct ibv_sysfs_dev *sysfs;
+	struct verbs_sysfs_dev *sysfs;
 };
 
 static inline struct verbs_device *
diff --git a/libibverbs/init.c b/libibverbs/init.c
index 996406e2efa258..2369a1df6e1fbd 100644
--- a/libibverbs/init.c
+++ b/libibverbs/init.c
@@ -47,22 +47,11 @@
 #include <errno.h>
 #include <assert.h>
 
-#include <ccan/list.h>
 #include <util/util.h>
 #include "ibverbs.h"
 
 int abi_ver;
 
-struct ibv_sysfs_dev {
-	struct list_node	entry;
-	char		        sysfs_name[IBV_SYSFS_NAME_MAX];
-	char		        ibdev_name[IBV_SYSFS_NAME_MAX];
-	char		        sysfs_path[IBV_SYSFS_PATH_MAX];
-	char		        ibdev_path[IBV_SYSFS_PATH_MAX];
-	int			abi_ver;
-	struct timespec		time_created;
-};
-
 struct ibv_driver_name {
 	struct list_node	entry;
 	char		       *name;
@@ -81,7 +70,7 @@ static int find_sysfs_devs(struct list_head *tmp_sysfs_dev_list)
 	char class_path[IBV_SYSFS_PATH_MAX];
 	DIR *class_dir;
 	struct dirent *dent;
-	struct ibv_sysfs_dev *sysfs_dev = NULL;
+	struct verbs_sysfs_dev *sysfs_dev = NULL;
 	char value[8];
 	int ret = 0;
 
@@ -100,7 +89,7 @@ static int find_sysfs_devs(struct list_head *tmp_sysfs_dev_list)
 			continue;
 
 		if (!sysfs_dev)
-			sysfs_dev = malloc(sizeof *sysfs_dev);
+			sysfs_dev = calloc(1, sizeof(*sysfs_dev));
 		if (!sysfs_dev) {
 			ret = ENOMEM;
 			goto out;
@@ -148,8 +137,6 @@ static int find_sysfs_devs(struct list_head *tmp_sysfs_dev_list)
 		if (ibv_read_sysfs_file(sysfs_dev->sysfs_path, "abi_version",
 					value, sizeof value) > 0)
 			sysfs_dev->abi_ver = strtol(value, NULL, 10);
-		else
-			sysfs_dev->abi_ver = 0;
 
 		list_add(tmp_sysfs_dev_list, &sysfs_dev->entry);
 		sysfs_dev      = NULL;
@@ -353,16 +340,51 @@ out:
 	closedir(conf_dir);
 }
 
+/* True if the provider matches the selected rdma sysfs device */
+static bool match_device(const struct verbs_device_ops *ops,
+			 struct verbs_sysfs_dev *sysfs_dev)
+{
+	if (!ops->match_device(sysfs_dev))
+		return false;
+
+	if (sysfs_dev->abi_ver < ops->match_min_abi_version ||
+	    sysfs_dev->abi_ver > ops->match_max_abi_version) {
+		fprintf(stderr, PFX
+			"Warning: Driver %s does not support the kernel ABI of %u (supports %u to %u) for device %s\n",
+			ops->name, sysfs_dev->abi_ver,
+			ops->match_min_abi_version,
+			ops->match_max_abi_version,
+			sysfs_dev->ibdev_path);
+		return false;
+	}
+	return true;
+}
+
 static struct verbs_device *try_driver(const struct verbs_device_ops *ops,
-				       struct ibv_sysfs_dev *sysfs_dev)
+				       struct verbs_sysfs_dev *sysfs_dev)
 {
 	struct verbs_device *vdev;
 	struct ibv_device *dev;
 	char value[16];
 
-	vdev = ops->init_device(sysfs_dev->sysfs_path, sysfs_dev->abi_ver);
-	if (!vdev)
-		return NULL;
+	if (ops->alloc_device) {
+		if (!match_device(ops, sysfs_dev))
+			return NULL;
+
+		vdev = ops->alloc_device(sysfs_dev);
+		if (!vdev) {
+			fprintf(stderr, PFX
+				"Fatal: couldn't allocate device for %s\n",
+				sysfs_dev->ibdev_path);
+			return NULL;
+		}
+	} else {
+		vdev =
+		    ops->init_device(sysfs_dev->sysfs_path, sysfs_dev->abi_ver);
+		if (!vdev)
+			return NULL;
+	}
+
 	vdev->ops = ops;
 
 	atomic_init(&vdev->refcount, 1);
@@ -409,7 +431,7 @@ static struct verbs_device *try_driver(const struct verbs_device_ops *ops,
 	return vdev;
 }
 
-static struct verbs_device *try_drivers(struct ibv_sysfs_dev *sysfs_dev)
+static struct verbs_device *try_drivers(struct verbs_sysfs_dev *sysfs_dev)
 {
 	struct ibv_driver *driver;
 	struct verbs_device *dev;
@@ -463,8 +485,8 @@ static void check_memlock_limit(void)
 			rlim.rlim_cur);
 }
 
-static int same_sysfs_dev(struct ibv_sysfs_dev *sysfs1,
-			  struct ibv_sysfs_dev *sysfs2)
+static int same_sysfs_dev(struct verbs_sysfs_dev *sysfs1,
+			  struct verbs_sysfs_dev *sysfs2)
 {
 	if (!strcmp(sysfs1->sysfs_name, sysfs2->sysfs_name) &&
 	    ts_cmp(&sysfs1->time_created,
@@ -481,8 +503,8 @@ static void try_all_drivers(struct list_head *sysfs_list,
 			    struct list_head *device_list,
 			    unsigned int *num_devices)
 {
-	struct ibv_sysfs_dev *sysfs_dev;
-	struct ibv_sysfs_dev *tmp;
+	struct verbs_sysfs_dev *sysfs_dev;
+	struct verbs_sysfs_dev *tmp;
 	struct verbs_device *vdev;
 
 	list_for_each_safe(sysfs_list, sysfs_dev, tmp, entry) {
@@ -499,7 +521,7 @@ static void try_all_drivers(struct list_head *sysfs_list,
 int ibverbs_get_device_list(struct list_head *device_list)
 {
 	LIST_HEAD(sysfs_list);
-	struct ibv_sysfs_dev *sysfs_dev, *next_dev;
+	struct verbs_sysfs_dev *sysfs_dev, *next_dev;
 	struct verbs_device *vdev, *tmp;
 	static int drivers_loaded;
 	unsigned int num_devices = 0;
@@ -515,7 +537,7 @@ int ibverbs_get_device_list(struct list_head *device_list)
 	 * present in the sysfs_list.
 	 */
 	list_for_each_safe(device_list, vdev, tmp, entry) {
-		struct ibv_sysfs_dev *old_sysfs = NULL;
+		struct verbs_sysfs_dev *old_sysfs = NULL;
 
 		list_for_each(&sysfs_list, sysfs_dev, entry) {
 			if (same_sysfs_dev(vdev->sysfs, sysfs_dev)) {
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
