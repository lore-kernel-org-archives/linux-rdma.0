From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 4/5] verbs: Avoid ibv_device memory leak
Date: Thu, 29 Jun 2017 17:00:15 +0300
Message-ID: <1498744816-23354-5-git-send-email-yishaih@mellanox.com>
References: <1498744816-23354-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498744816-23354-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Now, ibv_device list is refreshed each time that
ibv_get_device_list is called, therefore we need to free devices
from previous scan which aren't bound anymore, otherwise it could lead
to memory leak of ibv_device structures. We can free the memory of
ibv_device only if it isn't used anymore by the user.

How we identify if device is still used
========================================
We add a reference count to the verbs device struct.
This reference count is increased when:
  a. Set to one for having the device in the list until it should be
     deleted.
  b. User call to ibv_get_device_list.
  c. User call to ibv_open_device.

The reference count is decreased when:
  a. User call to ibv_free_device_list.
  b. User call to ibv_close_device.
  c. Device is no longer exists in the sysfs.

Device will be freed when the refcount is decreased to zero.

For free the ibv_device struct, we add uninit_device callback function
to verbs_device_ops.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/device.c  |  9 +++++++++
 libibverbs/driver.h  |  3 +++
 libibverbs/ibverbs.h |  2 ++
 libibverbs/init.c    | 24 +++++++++++++++++++++++-
 4 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/libibverbs/device.c b/libibverbs/device.c
index b8c1fc1..b05e6a1 100644
--- a/libibverbs/device.c
+++ b/libibverbs/device.c
@@ -101,6 +101,7 @@ struct ibv_device **__ibv_get_device_list(int *num)
 
 	list_for_each(&device_list, device, entry) {
 		l[i] = &device->device;
+		ibverbs_device_hold(l[i]);
 		i++;
 	}
 	if (num)
@@ -113,6 +114,10 @@ default_symver(__ibv_get_device_list, ibv_get_device_list);
 
 void __ibv_free_device_list(struct ibv_device **list)
 {
+	int i;
+
+	for (i = 0; list[i]; i++)
+		ibverbs_device_put(list[i]);
 	free(list);
 }
 default_symver(__ibv_free_device_list, ibv_free_device_list);
@@ -262,6 +267,8 @@ struct ibv_context *__ibv_open_device(struct ibv_device *device)
 	context->cmd_fd = cmd_fd;
 	pthread_mutex_init(&context->mutex, NULL);
 
+	ibverbs_device_hold(device);
+
 	return context;
 
 verbs_err:
@@ -280,6 +287,7 @@ int __ibv_close_device(struct ibv_context *context)
 	int cq_fd    = -1;
 	struct verbs_context *context_ex;
 	struct verbs_device *verbs_device = verbs_get_device(context->device);
+	struct ibv_device *device = context->device;
 
 	context_ex = verbs_get_ctx(context);
 	if (context_ex) {
@@ -294,6 +302,7 @@ int __ibv_close_device(struct ibv_context *context)
 	close(cmd_fd);
 	if (abi_ver <= 2)
 		close(cq_fd);
+	ibverbs_device_put(device);
 
 	return 0;
 }
diff --git a/libibverbs/driver.h b/libibverbs/driver.h
index 2ed846e..298bd35 100644
--- a/libibverbs/driver.h
+++ b/libibverbs/driver.h
@@ -35,6 +35,7 @@
 #ifndef INFINIBAND_DRIVER_H
 #define INFINIBAND_DRIVER_H
 
+#include <stdatomic.h>
 #include <infiniband/verbs.h>
 #include <infiniband/kern-abi.h>
 #include <ccan/list.h>
@@ -112,6 +113,7 @@ struct verbs_device_ops {
 			    struct ibv_context *ctx, int cmd_fd);
 	void (*uninit_context)(struct verbs_device *device,
 			       struct ibv_context *ctx);
+	void (*uninit_device)(struct verbs_device *device);
 };
 
 /* Must change the PRIVATE IBVERBS_PRIVATE_ symbol if this is changed */
@@ -120,6 +122,7 @@ struct verbs_device {
 	const struct verbs_device_ops *ops;
 	size_t	sz;
 	size_t	size_of_context;
+	atomic_int refcount;
 	struct list_node entry;
 	struct ibv_sysfs_dev *sysfs;
 };
diff --git a/libibverbs/ibverbs.h b/libibverbs/ibverbs.h
index 3e2fe8f..05fd2c8 100644
--- a/libibverbs/ibverbs.h
+++ b/libibverbs/ibverbs.h
@@ -61,6 +61,8 @@ extern int abi_ver;
 
 int ibverbs_get_device_list(struct list_head *list);
 int ibverbs_init(void);
+void ibverbs_device_put(struct ibv_device *dev);
+void ibverbs_device_hold(struct ibv_device *dev);
 
 struct verbs_ex_private {
 	struct ibv_cq_ex *(*create_cq_ex)(struct ibv_context *context,
diff --git a/libibverbs/init.c b/libibverbs/init.c
index 5ad95ca..b3046b3 100644
--- a/libibverbs/init.c
+++ b/libibverbs/init.c
@@ -382,6 +382,7 @@ static struct verbs_device *try_driver(struct ibv_driver *driver,
 	if (!vdev)
 		return NULL;
 
+	atomic_init(&vdev->refcount, 1);
 	dev = &vdev->device;
 	assert(dev->_ops._dummy1 == NULL);
 	assert(dev->_ops._dummy2 == NULL);
@@ -512,8 +513,11 @@ int ibverbs_get_device_list(struct list_head *list)
 				break;
 			}
 		}
-		if (!sysfs_dev)
+
+		if (!sysfs_dev) {
 			list_del(&vdev->entry);
+			ibverbs_device_put(&vdev->device);
+		}
 	}
 
 	for (sysfs_dev = tmp_sysfs_dev_list; sysfs_dev; sysfs_dev =
@@ -610,3 +614,21 @@ int ibverbs_init(void)
 
 	return 0;
 }
+
+void ibverbs_device_hold(struct ibv_device *dev)
+{
+	struct verbs_device *verbs_device = verbs_get_device(dev);
+
+	atomic_fetch_add(&verbs_device->refcount, 1);
+}
+
+void ibverbs_device_put(struct ibv_device *dev)
+{
+	struct verbs_device *verbs_device = verbs_get_device(dev);
+
+	if (atomic_fetch_sub(&verbs_device->refcount, 1) == 1) {
+		free(verbs_device->sysfs);
+		if (verbs_device->ops->uninit_device)
+			verbs_device->ops->uninit_device(verbs_device);
+	}
+}
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
