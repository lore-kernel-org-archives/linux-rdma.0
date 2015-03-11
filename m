From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 for-next 02/32] IB/core: Add kref to IB devices
Date: Wed, 11 Mar 2015 10:25:54 +0530
Message-ID: <35c593d8-0150-49c9-b18a-2e55a685bfb3@CMEXHTCAS2.ad.emulex.com>
References: <1426049785-30364-1-git-send-email-somnath.kotur@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426049785-30364-1-git-send-email-somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Previously. we used device_mutex lock in order to protect
the device's list. That means that in order to guarantee a
device isn't freed while we use it, we had to lock all
devices.

Adding a kref per IB device. Before an IB device
is unregistered, we wait before its not held anymore.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/device.c | 41 ++++++++++++++++++++++++++++++++++++++++
 include/rdma/ib_verbs.h          |  6 ++++++
 2 files changed, 47 insertions(+)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 18c1ece..8616a95 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -261,6 +261,39 @@ out:
 	return ret;
 }
 
+static void ib_device_complete_cb(struct kref *kref)
+{
+	struct ib_device *device = container_of(kref, struct ib_device,
+						refcount);
+
+	if (device->reg_state >= IB_DEV_UNREGISTERING)
+		complete(&device->free);
+}
+
+/**
+ * ib_device_hold - increase the reference count of device
+ * @device: ib device to prevent from being free'd
+ *
+ * Prevent the device from being free'd.
+ */
+void ib_device_hold(struct ib_device *device)
+{
+	kref_get(&device->refcount);
+}
+EXPORT_SYMBOL(ib_device_hold);
+
+/**
+ * ib_device_put - decrease the reference count of device
+ * @device: allows this device to be free'd
+ *
+ * Puts the ib_device and allows it to be free'd.
+ */
+int ib_device_put(struct ib_device *device)
+{
+	return kref_put(&device->refcount, ib_device_complete_cb);
+}
+EXPORT_SYMBOL(ib_device_put);
+
 /**
  * ib_register_device - Register an IB device with IB core
  * @device:Device to register
@@ -312,6 +345,9 @@ int ib_register_device(struct ib_device *device,
 
 	list_add_tail(&device->core_list, &device_list);
 
+	kref_init(&device->refcount);
+	init_completion(&device->free);
+
 	device->reg_state = IB_DEV_REGISTERED;
 
 	{
@@ -342,6 +378,8 @@ void ib_unregister_device(struct ib_device *device)
 
 	mutex_lock(&device_mutex);
 
+	device->reg_state = IB_DEV_UNREGISTERING;
+
 	list_for_each_entry_reverse(client, &client_list, list)
 		if (client->remove)
 			client->remove(device);
@@ -355,6 +393,9 @@ void ib_unregister_device(struct ib_device *device)
 
 	ib_device_unregister_sysfs(device);
 
+	ib_device_put(device);
+	wait_for_completion(&device->free);
+
 	spin_lock_irqsave(&device->client_data_lock, flags);
 	list_for_each_entry_safe(context, tmp, &device->client_data_list, list)
 		kfree(context);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 1866595..a7593b0 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1716,6 +1716,7 @@ struct ib_device {
 	enum {
 		IB_DEV_UNINITIALIZED,
 		IB_DEV_REGISTERED,
+		IB_DEV_UNREGISTERING,
 		IB_DEV_UNREGISTERED
 	}                            reg_state;
 
@@ -1728,6 +1729,8 @@ struct ib_device {
 	u32			     local_dma_lkey;
 	u8                           node_type;
 	u8                           phys_port_cnt;
+	struct kref		     refcount;
+	struct completion	     free;
 };
 
 struct ib_client {
@@ -1741,6 +1744,9 @@ struct ib_client {
 struct ib_device *ib_alloc_device(size_t size);
 void ib_dealloc_device(struct ib_device *device);
 
+void ib_device_hold(struct ib_device *device);
+int ib_device_put(struct ib_device *device);
+
 int ib_register_device(struct ib_device *device,
 		       int (*port_callback)(struct ib_device *,
 					    u8, struct kobject *));
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
