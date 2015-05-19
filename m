From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v4 for-next 02/14] IB/core: Replace device_mutex with rwsem
Date: Tue, 19 May 2015 17:27:05 +0300
Message-ID: <1432045637-9090-3-git-send-email-matanb@mellanox.com>
References: <1432045637-9090-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432045637-9090-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

device_mutex is replaced rwsem in order to allow
clients' work to run concurrently with register_device,
unregister_device, register_client and unregister_client.

Clients might want to iterate the devices list in work
contexts. Saying that, a client must finish its operations
on a device when client->remove(device) is called. Finishing
the client's operation requires waiting for all works it
created regarding this device. However, a work could
depend on the device_mutex to iterate the devices list
and we would have got a deadlock. Replacing this lock
with rwlock solves this problem.

rwlock isn't enough in this scenario. This is because running
register_client and register_device could result in running
client->add(device) twice (if we protect the list with down_read).
A similar problem arises for unregister_client and unregister_device
concurrently. In order to solve this, we mutually exclude those
operations with a mutex.

This follows Jason Gunthorpe's suggestion in:
http://www.spinics.net/lists/linux-rdma/msg25174.html

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/device.c | 55 ++++++++++++++++++++++++++++++----------
 1 file changed, 41 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 18c1ece..bf19358 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -59,13 +59,27 @@ static LIST_HEAD(device_list);
 static LIST_HEAD(client_list);
 
 /*
- * device_mutex protects access to both device_list and client_list.
- * There's no real point to using multiple locks or something fancier
- * like an rwsem: we always access both lists, and we're always
- * modifying one list or the other list.  In any case this is not a
- * hot path so there's no point in trying to optimize.
+ * modify_mutex protects adding/removing devices and clients.
+ * Adding a client and a device simultaneously might cause calling
+ * client->add twice for the same device. Removing a client could
+ * cause calling client->remove twice. modify_mutex synchronizes
+ * those actions.
  */
-static DEFINE_MUTEX(device_mutex);
+static DEFINE_MUTEX(modify_mutex);
+
+/*
+ * lists_rwsem protects the client and device lists from
+ * read-while-write scenario. Adding/removing a device/client
+ * is protected by modify_mutex. However, other contexts of
+ * clients might want to iterate the device list. Client should
+ * cease all actions after client->remove returns. For that purpose,
+ * clients need to wait for their contexts which might need to
+ * iterate that list. Summing all that up, we have to use RCU/rwsem
+ * as either the iteration over client->remove could deadlock with
+ * the clients' works. We don't expect adding/removing of devices/clients
+ * to be done frequently, thus rwsem is favored here.
+ */
+static DECLARE_RWSEM(lists_rwsem);
 
 static int ib_device_check_mandatory(struct ib_device *device)
 {
@@ -276,7 +290,7 @@ int ib_register_device(struct ib_device *device,
 {
 	int ret;
 
-	mutex_lock(&device_mutex);
+	mutex_lock(&modify_mutex);
 
 	if (strchr(device->name, '%')) {
 		ret = alloc_name(device->name);
@@ -310,20 +324,24 @@ int ib_register_device(struct ib_device *device,
 		goto out;
 	}
 
+	down_write(&lists_rwsem);
 	list_add_tail(&device->core_list, &device_list);
+	up_write(&lists_rwsem);
+
 
 	device->reg_state = IB_DEV_REGISTERED;
 
 	{
 		struct ib_client *client;
 
+		/* down_read(&lists_rwsem) is implied by modify_mutex */
 		list_for_each_entry(client, &client_list, list)
 			if (client->add && !add_client_context(device, client))
 				client->add(device);
 	}
 
  out:
-	mutex_unlock(&device_mutex);
+	mutex_unlock(&modify_mutex);
 	return ret;
 }
 EXPORT_SYMBOL(ib_register_device);
@@ -340,18 +358,21 @@ void ib_unregister_device(struct ib_device *device)
 	struct ib_client_data *context, *tmp;
 	unsigned long flags;
 
-	mutex_lock(&device_mutex);
+	mutex_lock(&modify_mutex);
 
+	/* down_read(&lists_rwsem) is implied by modify_mutex */
 	list_for_each_entry_reverse(client, &client_list, list)
 		if (client->remove)
 			client->remove(device);
 
+	down_write(&lists_rwsem);
 	list_del(&device->core_list);
+	up_write(&lists_rwsem);
 
 	kfree(device->gid_tbl_len);
 	kfree(device->pkey_tbl_len);
 
-	mutex_unlock(&device_mutex);
+	mutex_unlock(&modify_mutex);
 
 	ib_device_unregister_sysfs(device);
 
@@ -381,14 +402,17 @@ int ib_register_client(struct ib_client *client)
 {
 	struct ib_device *device;
 
-	mutex_lock(&device_mutex);
+	mutex_lock(&modify_mutex);
 
+	down_write(&lists_rwsem);
 	list_add_tail(&client->list, &client_list);
+	up_write(&lists_rwsem);
+	/* down_read(&lists_rwsem) is implied by modify_mutex */
 	list_for_each_entry(device, &device_list, core_list)
 		if (client->add && !add_client_context(device, client))
 			client->add(device);
 
-	mutex_unlock(&device_mutex);
+	mutex_unlock(&modify_mutex);
 
 	return 0;
 }
@@ -408,8 +432,9 @@ void ib_unregister_client(struct ib_client *client)
 	struct ib_device *device;
 	unsigned long flags;
 
-	mutex_lock(&device_mutex);
+	mutex_lock(&modify_mutex);
 
+	/* down_read(&lists_rwsem) is implied by modify_mutex */
 	list_for_each_entry(device, &device_list, core_list) {
 		if (client->remove)
 			client->remove(device);
@@ -422,9 +447,11 @@ void ib_unregister_client(struct ib_client *client)
 			}
 		spin_unlock_irqrestore(&device->client_data_lock, flags);
 	}
+	down_write(&lists_rwsem);
 	list_del(&client->list);
+	up_write(&lists_rwsem);
 
-	mutex_unlock(&device_mutex);
+	mutex_unlock(&modify_mutex);
 }
 EXPORT_SYMBOL(ib_unregister_client);
 
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
