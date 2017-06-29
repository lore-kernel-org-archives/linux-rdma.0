From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 3/5] verbs: Refresh cahced ibv_device list
Date: Thu, 29 Jun 2017 17:00:14 +0300
Message-ID: <1498744816-23354-4-git-send-email-yishaih@mellanox.com>
References: <1498744816-23354-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498744816-23354-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Problem
=======
Currently, libibverbs builds the cached ibv_device list only
in the first time that ibv_get_device_list is called, as a result
the list is never updated, no matter if there were hardware changes
in the system.

Solution
========
Modify the implementation of ibv_get_device_list() so that
consecutive calls will re-scan the sysfs in the same manner as done
today in order to create a fresh ibv_device list each time.
For this purpose, the cached device list is change to be a
real linked list and not a dynamic array.

How we identify new devices
===========================
Identifying same device is done according to timestamp creation of
/sys/class/infiniband_verbs/uverbs%d/ibdev.
We get the file status with stat syscall and use the st_mtime field for
this purpose.

When we rescan the sysfs devices, then we check for each sysfs device
if it was already been in the last scan, if not then we allocate new
ibv_device and add it to the cached device list.
Next patch in this series handles the case that a device is no
longer in use.

Note:
This patch changes the IBVERBS_PRIVATE symbol as required in the note
above verbs_device struct.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 debian/libibverbs1.symbols |   2 +-
 libibverbs/device.c        |  37 ++++++++++-----
 libibverbs/driver.h        |   3 ++
 libibverbs/ibverbs.h       |   3 +-
 libibverbs/init.c          | 109 +++++++++++++++++++++++++++------------------
 libibverbs/libibverbs.map  |   2 +-
 6 files changed, 97 insertions(+), 59 deletions(-)

diff --git a/debian/libibverbs1.symbols b/debian/libibverbs1.symbols
index b96ef46..aaee795 100644
--- a/debian/libibverbs1.symbols
+++ b/debian/libibverbs1.symbols
@@ -1,7 +1,7 @@
 libibverbs.so.1 libibverbs1 #MINVER#
  IBVERBS_1.0@IBVERBS_1.0 1.1.6
  IBVERBS_1.1@IBVERBS_1.1 1.1.6
- (symver)IBVERBS_PRIVATE_14 14
+ (symver)IBVERBS_PRIVATE_15 15
  ibv_ack_async_event@IBVERBS_1.0 1.1.6
  ibv_ack_async_event@IBVERBS_1.1 1.1.6
  ibv_ack_cq_events@IBVERBS_1.0 1.1.6
diff --git a/libibverbs/device.c b/libibverbs/device.c
index ebf4970..b8c1fc1 100644
--- a/libibverbs/device.c
+++ b/libibverbs/device.c
@@ -59,41 +59,54 @@ int __ibv_get_async_event(struct ibv_context *context,
 			  struct ibv_async_event *event);
 void __ibv_ack_async_event(struct ibv_async_event *event);
 
-static pthread_once_t device_list_once = PTHREAD_ONCE_INIT;
-static int num_devices;
-static struct ibv_device **device_list;
+static pthread_once_t init_once = PTHREAD_ONCE_INIT;
+static pthread_mutex_t dev_list_lock = PTHREAD_MUTEX_INITIALIZER;
+static int initialized;
+static struct list_head device_list = LIST_HEAD_INIT(device_list);
 
-static void count_devices(void)
+static void init_resources(void)
 {
-	num_devices = ibverbs_init(&device_list);
+	initialized = ibverbs_init();
 }
 
 struct ibv_device **__ibv_get_device_list(int *num)
 {
 	struct ibv_device **l;
-	int i;
+	struct verbs_device *device;
+	int num_devices;
+	int i = 0;
 
 	if (num)
 		*num = 0;
 
-	pthread_once(&device_list_once, count_devices);
+	pthread_once(&init_once, init_resources);
+	if (initialized < 0) {
+		errno = -initialized;
+		return NULL;
+	}
 
+	pthread_mutex_lock(&dev_list_lock);
+	num_devices = ibverbs_get_device_list(&device_list);
 	if (num_devices < 0) {
 		errno = -num_devices;
-		return NULL;
+		l = NULL;
+		goto out;
 	}
 
 	l = calloc(num_devices + 1, sizeof (struct ibv_device *));
 	if (!l) {
 		errno = ENOMEM;
-		return NULL;
+		goto out;
 	}
 
-	for (i = 0; i < num_devices; ++i)
-		l[i] = device_list[i];
+	list_for_each(&device_list, device, entry) {
+		l[i] = &device->device;
+		i++;
+	}
 	if (num)
 		*num = num_devices;
-
+out:
+	pthread_mutex_unlock(&dev_list_lock);
 	return l;
 }
 default_symver(__ibv_get_device_list, ibv_get_device_list);
diff --git a/libibverbs/driver.h b/libibverbs/driver.h
index ec87afd..2ed846e 100644
--- a/libibverbs/driver.h
+++ b/libibverbs/driver.h
@@ -37,6 +37,7 @@
 
 #include <infiniband/verbs.h>
 #include <infiniband/kern-abi.h>
+#include <ccan/list.h>
 
 #ifdef __cplusplus
 #  define BEGIN_C_DECLS extern "C" {
@@ -119,6 +120,8 @@ struct verbs_device {
 	const struct verbs_device_ops *ops;
 	size_t	sz;
 	size_t	size_of_context;
+	struct list_node entry;
+	struct ibv_sysfs_dev *sysfs;
 };
 
 static inline struct verbs_device *
diff --git a/libibverbs/ibverbs.h b/libibverbs/ibverbs.h
index eb304ba..3e2fe8f 100644
--- a/libibverbs/ibverbs.h
+++ b/libibverbs/ibverbs.h
@@ -59,7 +59,8 @@ struct ibv_abi_compat_v2 {
 
 extern int abi_ver;
 
-int ibverbs_init(struct ibv_device ***list);
+int ibverbs_get_device_list(struct list_head *list);
+int ibverbs_init(void);
 
 struct verbs_ex_private {
 	struct ibv_cq_ex *(*create_cq_ex)(struct ibv_context *context,
diff --git a/libibverbs/init.c b/libibverbs/init.c
index 6e453ea..5ad95ca 100644
--- a/libibverbs/init.c
+++ b/libibverbs/init.c
@@ -62,6 +62,8 @@ struct ibv_sysfs_dev {
 	struct ibv_sysfs_dev   *next;
 	int			abi_ver;
 	int			have_driver;
+	struct timespec		time_created;
+	int			used;
 };
 
 struct ibv_driver_name {
@@ -75,11 +77,10 @@ struct ibv_driver {
 	struct ibv_driver      *next;
 };
 
-static struct ibv_sysfs_dev *sysfs_dev_list;
 static struct ibv_driver_name *driver_name_list;
 static struct ibv_driver *head_driver, *tail_driver;
 
-static int find_sysfs_devs(void)
+static int find_sysfs_devs(struct ibv_sysfs_dev **tmp_sysfs_dev_list)
 {
 	char class_path[IBV_SYSFS_PATH_MAX];
 	DIR *class_dir;
@@ -140,15 +141,24 @@ static int find_sysfs_devs(void)
 			sysfs_dev->ibdev_name))
 			continue;
 
-		sysfs_dev->next        = sysfs_dev_list;
+		if (stat(sysfs_dev->ibdev_path, &buf)) {
+			fprintf(stderr, PFX "Warning: couldn't stat '%s'.\n",
+				sysfs_dev->ibdev_path);
+			continue;
+		}
+
+		sysfs_dev->time_created = buf.st_mtim;
+
+		sysfs_dev->next        = *tmp_sysfs_dev_list;
 		sysfs_dev->have_driver = 0;
+		sysfs_dev->used = 0;
 		if (ibv_read_sysfs_file(sysfs_dev->sysfs_path, "abi_version",
 					value, sizeof value) > 0)
 			sysfs_dev->abi_ver = strtol(value, NULL, 10);
 		else
 			sysfs_dev->abi_ver = 0;
 
-		sysfs_dev_list = sysfs_dev;
+		*tmp_sysfs_dev_list = sysfs_dev;
 		sysfs_dev      = NULL;
 	}
 
@@ -361,8 +371,8 @@ out:
 	closedir(conf_dir);
 }
 
-static struct ibv_device *try_driver(struct ibv_driver *driver,
-				     struct ibv_sysfs_dev *sysfs_dev)
+static struct verbs_device *try_driver(struct ibv_driver *driver,
+				       struct ibv_sysfs_dev *sysfs_dev)
 {
 	struct verbs_device *vdev;
 	struct ibv_device *dev;
@@ -410,14 +420,16 @@ static struct ibv_device *try_driver(struct ibv_driver *driver,
 	strcpy(dev->dev_path,   sysfs_dev->sysfs_path);
 	strcpy(dev->name,       sysfs_dev->ibdev_name);
 	strcpy(dev->ibdev_path, sysfs_dev->ibdev_path);
+	vdev->sysfs = sysfs_dev;
+	sysfs_dev->used = 1;
 
-	return dev;
+	return vdev;
 }
 
-static struct ibv_device *try_drivers(struct ibv_sysfs_dev *sysfs_dev)
+static struct verbs_device *try_drivers(struct ibv_sysfs_dev *sysfs_dev)
 {
 	struct ibv_driver *driver;
-	struct ibv_device *dev;
+	struct verbs_device *dev;
 
 	for (driver = head_driver; driver; driver = driver->next) {
 		dev = try_driver(driver, sysfs_dev);
@@ -468,45 +480,51 @@ static void check_memlock_limit(void)
 			rlim.rlim_cur);
 }
 
-static void add_device(struct ibv_device *dev,
-		       struct ibv_device ***dev_list,
-		       int *num_devices,
-		       int *list_size)
+static int same_sysfs_dev(struct ibv_sysfs_dev *sysfs1,
+			  struct ibv_sysfs_dev *sysfs2)
 {
-	struct ibv_device **new_list;
-
-	if (*list_size <= *num_devices) {
-		*list_size = *list_size ? *list_size * 2 : 1;
-		new_list = realloc(*dev_list, *list_size * sizeof (struct ibv_device *));
-		if (!new_list)
-			return;
-		*dev_list = new_list;
-	}
-
-	(*dev_list)[(*num_devices)++] = dev;
+	if (!strcmp(sysfs1->sysfs_name, sysfs2->sysfs_name) &&
+	    ts_cmp(&sysfs1->time_created,
+		   &sysfs2->time_created, ==))
+		return 1;
+	return 0;
 }
 
-int ibverbs_get_device_list(struct ibv_device ***list)
+int ibverbs_get_device_list(struct list_head *list)
 {
-	struct ibv_sysfs_dev *sysfs_dev, *next_dev;
-	struct ibv_device *device;
+	struct ibv_sysfs_dev *tmp_sysfs_dev_list = NULL, *sysfs_dev, *next_dev;
+	struct verbs_device *vdev, *tmp;
 	int num_devices = 0;
-	int list_size = 0;
 	int statically_linked = 0;
 	int no_driver = 0;
 	int ret;
 
-	*list = NULL;
-
-	ret = find_sysfs_devs();
+	ret = find_sysfs_devs(&tmp_sysfs_dev_list);
 	if (ret)
 		return -ret;
 
-	for (sysfs_dev = sysfs_dev_list; sysfs_dev; sysfs_dev = sysfs_dev->next) {
-		device = try_drivers(sysfs_dev);
-		if (device) {
-			add_device(device, list, &num_devices, &list_size);
+	list_for_each_safe(list, vdev, tmp, entry) {
+		for (sysfs_dev = tmp_sysfs_dev_list; sysfs_dev; sysfs_dev =
+		     sysfs_dev->next) {
+			if (same_sysfs_dev(vdev->sysfs, sysfs_dev)) {
+				sysfs_dev->have_driver = 1;
+				num_devices++;
+				break;
+			}
+		}
+		if (!sysfs_dev)
+			list_del(&vdev->entry);
+	}
+
+	for (sysfs_dev = tmp_sysfs_dev_list; sysfs_dev; sysfs_dev =
+	     sysfs_dev->next) {
+		if (sysfs_dev->have_driver)
+			continue;
+		vdev = try_drivers(sysfs_dev);
+		if (vdev) {
 			sysfs_dev->have_driver = 1;
+			list_add(list, &vdev->entry);
+			num_devices++;
 		} else
 			no_driver = 1;
 	}
@@ -536,20 +554,22 @@ int ibverbs_get_device_list(struct ibv_device ***list)
 
 	load_drivers();
 
-	for (sysfs_dev = sysfs_dev_list; sysfs_dev; sysfs_dev = sysfs_dev->next) {
+	for (sysfs_dev = tmp_sysfs_dev_list; sysfs_dev; sysfs_dev =
+	     sysfs_dev->next) {
 		if (sysfs_dev->have_driver)
 			continue;
 
-		device = try_drivers(sysfs_dev);
-		if (device) {
-			add_device(device, list, &num_devices, &list_size);
+		vdev = try_drivers(sysfs_dev);
+		if (vdev) {
 			sysfs_dev->have_driver = 1;
+			list_add(list, &vdev->entry);
+			num_devices++;
 		}
 	}
 
 out:
-	for (sysfs_dev = sysfs_dev_list,
-		     next_dev = sysfs_dev ? sysfs_dev->next : NULL;
+	for (sysfs_dev = tmp_sysfs_dev_list,
+	     next_dev = sysfs_dev ? sysfs_dev->next : NULL;
 	     sysfs_dev;
 	     sysfs_dev = next_dev, next_dev = sysfs_dev ? sysfs_dev->next : NULL) {
 		if (!sysfs_dev->have_driver && getenv("IBV_SHOW_WARNINGS")) {
@@ -559,13 +579,14 @@ out:
 				fprintf(stderr, "	When linking libibverbs statically, "
 					"driver must be statically linked too.\n");
 		}
-		free(sysfs_dev);
+		if (!sysfs_dev->used)
+			free(sysfs_dev);
 	}
 
 	return num_devices;
 }
 
-int ibverbs_init(struct ibv_device ***list)
+int ibverbs_init(void)
 {
 	const char *sysfs_path;
 	int ret;
@@ -587,5 +608,5 @@ int ibverbs_init(struct ibv_device ***list)
 
 	read_config();
 
-	return ibverbs_get_device_list(list);
+	return 0;
 }
diff --git a/libibverbs/libibverbs.map b/libibverbs/libibverbs.map
index 5401241..56020d0 100644
--- a/libibverbs/libibverbs.map
+++ b/libibverbs/libibverbs.map
@@ -86,7 +86,7 @@ IBVERBS_1.1 {
 
 /* If any symbols in this stanza change ABI then the entire staza gets a new symbol
    version. Also see the private_symver() macro */
-IBVERBS_PRIVATE_14 {
+IBVERBS_PRIVATE_15 {
 	global:
 		/* These historical symbols are now private to libibverbs */
 		ibv_cmd_alloc_mw;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
