From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v4 01/14] IB/core: Add rwsem to allow reading device list or client list
Date: Thu, 30 Jul 2015 17:50:13 +0300
Message-ID: <1438267826-32155-2-git-send-email-haggaie@mellanox.com>
References: <1438267826-32155-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438267826-32155-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Currently the RDMA subsystem's device list and client list are protected by
a single mutex. This prevents adding user-facing APIs that iterate these
lists, since using them may cause a deadlock. The patch attempts to solve
this problem by adding a read-write semaphore to protect the lists. Readers
now don't need the mutex, and are safe just by read-locking the semaphore.

The ib_register_device, ib_register_client, ib_unregister_device, and
ib_unregister_client functions are modified to lock the semaphore for write
during their respective list modification. Also, in order to make sure
client callbacks are called only between add() and remove() calls, the code
is changed to only add items to the lists after the add() calls and remove
from the lists before the remove() calls.

This patch attempts to solve a similar need [1] that was seen in the RoCE
v2 patch series.

[1] http://www.spinics.net/lists/linux-rdma/msg24733.html

Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/device.c | 39 ++++++++++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 9567756ca4f9..f08d438205ed 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -55,17 +55,24 @@ struct ib_client_data {
 struct workqueue_struct *ib_wq;
 EXPORT_SYMBOL_GPL(ib_wq);
 
+/* The device_list and client_list contain devices and clients after their
+ * registration has completed, and the devices and clients are removed
+ * during unregistration. */
 static LIST_HEAD(device_list);
 static LIST_HEAD(client_list);
 
 /*
- * device_mutex protects access to both device_list and client_list.
- * There's no real point to using multiple locks or something fancier
- * like an rwsem: we always access both lists, and we're always
- * modifying one list or the other list.  In any case this is not a
- * hot path so there's no point in trying to optimize.
+ * device_mutex and lists_rwsem protect access to both device_list and
+ * client_list.  device_mutex protects writer access by device and client
+ * registration / de-registration.  lists_rwsem protects reader access to
+ * these lists.  Iterators of these lists must lock it for read, while updates
+ * to the lists must be done with a write lock. A special case is when the
+ * device_mutex is locked. In this case locking the lists for read access is
+ * not necessary as the device_mutex implies it.
  */
 static DEFINE_MUTEX(device_mutex);
+static DECLARE_RWSEM(lists_rwsem);
+
 
 static int ib_device_check_mandatory(struct ib_device *device)
 {
@@ -305,8 +312,6 @@ int ib_register_device(struct ib_device *device,
 		goto out;
 	}
 
-	list_add_tail(&device->core_list, &device_list);
-
 	device->reg_state = IB_DEV_REGISTERED;
 
 	{
@@ -317,6 +322,10 @@ int ib_register_device(struct ib_device *device,
 				client->add(device);
 	}
 
+	down_write(&lists_rwsem);
+	list_add_tail(&device->core_list, &device_list);
+	up_write(&lists_rwsem);
+
  out:
 	mutex_unlock(&device_mutex);
 	return ret;
@@ -337,12 +346,14 @@ void ib_unregister_device(struct ib_device *device)
 
 	mutex_lock(&device_mutex);
 
+	down_write(&lists_rwsem);
+	list_del(&device->core_list);
+	up_write(&lists_rwsem);
+
 	list_for_each_entry_reverse(client, &client_list, list)
 		if (client->remove)
 			client->remove(device);
 
-	list_del(&device->core_list);
-
 	mutex_unlock(&device_mutex);
 
 	ib_device_unregister_sysfs(device);
@@ -375,11 +386,14 @@ int ib_register_client(struct ib_client *client)
 
 	mutex_lock(&device_mutex);
 
-	list_add_tail(&client->list, &client_list);
 	list_for_each_entry(device, &device_list, core_list)
 		if (client->add && !add_client_context(device, client))
 			client->add(device);
 
+	down_write(&lists_rwsem);
+	list_add_tail(&client->list, &client_list);
+	up_write(&lists_rwsem);
+
 	mutex_unlock(&device_mutex);
 
 	return 0;
@@ -402,6 +416,10 @@ void ib_unregister_client(struct ib_client *client)
 
 	mutex_lock(&device_mutex);
 
+	down_write(&lists_rwsem);
+	list_del(&client->list);
+	up_write(&lists_rwsem);
+
 	list_for_each_entry(device, &device_list, core_list) {
 		if (client->remove)
 			client->remove(device);
@@ -414,7 +432,6 @@ void ib_unregister_client(struct ib_client *client)
 			}
 		spin_unlock_irqrestore(&device->client_data_lock, flags);
 	}
-	list_del(&client->list);
 
 	mutex_unlock(&device_mutex);
 }
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
