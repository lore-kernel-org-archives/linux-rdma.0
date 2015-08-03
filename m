From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V1 2/3] IB/core: RoCE GID management separate cleanup and release
Date: Mon,  3 Aug 2015 16:09:01 +0300
Message-ID: <1438607342-11964-3-git-send-email-matanb@mellanox.com>
References: <1438607342-11964-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438607342-11964-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Separate the cleanup and release IB cache functions.
The cleanup function delete all GIDs and unregister the event channel,
while the release function frees all memory. The cleanup function is
called after all clients were removed (in the device un-registration
process).

The release function is called after the device was put.
Although vendor drivers aren't expected to use IB cache in their
removal process, we postpone freeing the cache in order to avoid
possible use-after-free errors.

Squash-into: 'IB/core: Add RoCE GID table management'
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cache.c     | 82 ++++++++++++++++++++++++++++---------
 drivers/infiniband/core/core_priv.h |  1 +
 drivers/infiniband/core/device.c    |  4 ++
 drivers/infiniband/core/sysfs.c     |  2 +-
 4 files changed, 68 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 01b8792..58a44bd 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -464,8 +464,16 @@ err_free_table:
 	return NULL;
 }
 
-static void free_gid_table(struct ib_device *ib_dev, u8 port,
-			   struct ib_gid_table *table)
+static void release_gid_table(struct ib_gid_table *table)
+{
+	if (table) {
+		kfree(table->data_vec);
+		kfree(table);
+	}
+}
+
+static void cleanup_gid_table_port(struct ib_device *ib_dev, u8 port,
+				   struct ib_gid_table *table)
 {
 	int i;
 
@@ -479,8 +487,6 @@ static void free_gid_table(struct ib_device *ib_dev, u8 port,
 				table->data_vec[i].props &
 				GID_ATTR_FIND_MASK_DEFAULT);
 	}
-	kfree(table->data_vec);
-	kfree(table);
 }
 
 void ib_cache_gid_set_default_gid(struct ib_device *ib_dev, u8 port,
@@ -582,15 +588,17 @@ static int _gid_table_setup_one(struct ib_device *ib_dev)
 	return 0;
 
 rollback_table_setup:
-	for (port = 0; port < ib_dev->phys_port_cnt; port++)
-		free_gid_table(ib_dev, port + rdma_start_port(ib_dev),
-			       table[port]);
+	for (port = 0; port < ib_dev->phys_port_cnt; port++) {
+		cleanup_gid_table_port(ib_dev, port + rdma_start_port(ib_dev),
+				       table[port]);
+		release_gid_table(table[port]);
+	}
 
 	kfree(table);
 	return err;
 }
 
-static void gid_table_cleanup_one(struct ib_device *ib_dev)
+static void gid_table_release_one(struct ib_device *ib_dev)
 {
 	struct ib_gid_table **table = ib_dev->cache.gid_cache;
 	u8 port;
@@ -599,10 +607,23 @@ static void gid_table_cleanup_one(struct ib_device *ib_dev)
 		return;
 
 	for (port = 0; port < ib_dev->phys_port_cnt; port++)
-		free_gid_table(ib_dev, port + rdma_start_port(ib_dev),
-			       table[port]);
+		release_gid_table(table[port]);
 
 	kfree(table);
+	ib_dev->cache.gid_cache = NULL;
+}
+
+static void gid_table_cleanup_one(struct ib_device *ib_dev)
+{
+	struct ib_gid_table **table = ib_dev->cache.gid_cache;
+	u8 port;
+
+	if (!table)
+		return;
+
+	for (port = 0; port < ib_dev->phys_port_cnt; port++)
+		cleanup_gid_table_port(ib_dev, port + rdma_start_port(ib_dev),
+				       table[port]);
 }
 
 static int gid_table_setup_one(struct ib_device *ib_dev)
@@ -616,8 +637,10 @@ static int gid_table_setup_one(struct ib_device *ib_dev)
 
 	err = roce_rescan_device(ib_dev);
 
-	if (err)
+	if (err) {
 		gid_table_cleanup_one(ib_dev);
+		gid_table_release_one(ib_dev);
+	}
 
 	return err;
 }
@@ -902,9 +925,7 @@ int ib_cache_setup_one(struct ib_device *device)
 					  (rdma_end_port(device) -
 					   rdma_start_port(device) + 1),
 					  GFP_KERNEL);
-	err = gid_table_setup_one(device);
-
-	if (!device->cache.pkey_cache || !device->cache.gid_cache ||
+	if (!device->cache.pkey_cache ||
 	    !device->cache.lmc_cache) {
 		printk(KERN_WARNING "Couldn't allocate cache "
 		       "for %s\n", device->name);
@@ -912,6 +933,10 @@ int ib_cache_setup_one(struct ib_device *device)
 		goto err;
 	}
 
+	err = gid_table_setup_one(device);
+	if (err)
+		goto err;
+
 	for (p = 0; p <= rdma_end_port(device) - rdma_start_port(device); ++p) {
 		device->cache.pkey_cache[p] = NULL;
 		ib_cache_update(device, p + rdma_start_port(device));
@@ -929,29 +954,46 @@ err_cache:
 	for (p = 0; p <= rdma_end_port(device) - rdma_start_port(device); ++p)
 		kfree(device->cache.pkey_cache[p]);
 
+	gid_table_cleanup_one(device);
+	gid_table_release_one(device);
 err:
 	kfree(device->cache.pkey_cache);
-	gid_table_cleanup_one(device);
 	kfree(device->cache.lmc_cache);
 
 	return err;
 }
 
-void ib_cache_cleanup_one(struct ib_device *device)
+void ib_cache_release_one(struct ib_device *device)
 {
 	int p;
 
-	ib_unregister_event_handler(&device->cache.event_handler);
-	flush_workqueue(ib_wq);
-
+	/* The release function frees all the cache elements.
+	 * This function should be called as part of freeing
+	 * all the device's resources when the cache could no
+	 * longer be accessed.
+	 */
 	for (p = 0; p <= rdma_end_port(device) - rdma_start_port(device); ++p)
 		kfree(device->cache.pkey_cache[p]);
 
+	gid_table_release_one(device);
 	kfree(device->cache.pkey_cache);
-	gid_table_cleanup_one(device);
 	kfree(device->cache.lmc_cache);
 }
 
+void ib_cache_cleanup_one(struct ib_device *device)
+{
+	/* The cleanup function unregisters the event handler,
+	 * waits for all in-progress workqueue elements and cleans
+	 * up the GID cache. This function should be called after
+	 * the device was removed from the devices list and all
+	 * clients were removed, so the cache exists but is
+	 * non-functional and shouldn't be updated anymore.
+	 */
+	ib_unregister_event_handler(&device->cache.event_handler);
+	flush_workqueue(ib_wq);
+	gid_table_cleanup_one(device);
+}
+
 void __init ib_cache_setup(void)
 {
 	roce_gid_mgmt_init();
diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 210ddd2..b78adb5 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -98,5 +98,6 @@ int roce_rescan_device(struct ib_device *ib_dev);
 
 int ib_cache_setup_one(struct ib_device *device);
 void ib_cache_cleanup_one(struct ib_device *device);
+void ib_cache_release_one(struct ib_device *device);
 
 #endif /* _CORE_PRIV_H */
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 14ea709..abd511e 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -366,6 +366,10 @@ void ib_unregister_device(struct ib_device *device)
 
 	mutex_unlock(&device_mutex);
 
+	/* All clients were removed and the device is being removed, no calls
+	 * are expcted to ib_cache by clients/API.
+	 */
+	ib_cache_cleanup_one(device);
 	ib_device_unregister_sysfs(device);
 
 	spin_lock_irqsave(&device->client_data_lock, flags);
diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index c10c6d3..5f45786 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -461,7 +461,7 @@ static void ib_device_release(struct device *device)
 {
 	struct ib_device *dev = container_of(device, struct ib_device, dev);
 
-	ib_cache_cleanup_one(dev);
+	ib_cache_release_one(dev);
 	kfree(dev->port_immutable);
 	kfree(dev);
 }
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
