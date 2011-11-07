From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 03/11] Remove lmc from cache
Date: Mon, 7 Nov 2011 14:19:10 +0530
Message-ID: <20111107084906.GA11464@shrek.cartoons>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The lmc cache is removed because it cannot be used in this structure.
Since, there is no call for querying lmc specifically, we cannot use
it in the device driver.

TODO: Find a better place for lmc cache, perhaps the ib_device
structure?

Signed-off-by: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
---
 drivers/infiniband/core/cache.c |   30 +-----------------------------
 include/rdma/ib_cache.h         |   13 -------------
 include/rdma/ib_verbs.h         |    1 -
 3 files changed, 1 insertions(+), 43 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index c9c9530..efe6d00 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -201,24 +201,6 @@ int ib_find_cached_pkey(struct ib_device *device,
 }
 EXPORT_SYMBOL(ib_find_cached_pkey);
 
-int ib_get_cached_lmc(struct ib_device *device,
-		      u8                port_num,
-		      u8                *lmc)
-{
-	unsigned long flags;
-	int ret = 0;
-
-	if (port_num < start_port(device) || port_num > end_port(device))
-		return -EINVAL;
-
-	read_lock_irqsave(&device->cache.lock, flags);
-	*lmc = device->cache.lmc_cache[port_num - start_port(device)];
-	read_unlock_irqrestore(&device->cache.lock, flags);
-
-	return ret;
-}
-EXPORT_SYMBOL(ib_get_cached_lmc);
-
 static void ib_cache_update(struct ib_device *device,
 			    u8                port)
 {
@@ -290,8 +272,6 @@ static void ib_cache_update(struct ib_device *device,
 	device->cache.pkey_cache[port - start_port(device)] = pkey_cache;
 	device->cache.gid_cache [port - start_port(device)] = gid_cache;
 
-	device->cache.lmc_cache[port - start_port(device)] = tprops->lmc;
-
 	write_unlock_irq(&device->cache.lock);
 
 	kfree(old_pkey_cache);
@@ -349,13 +329,7 @@ static void ib_cache_setup_one(struct ib_device *device)
 		kmalloc(sizeof *device->cache.gid_cache *
 			(end_port(device) - start_port(device) + 1), GFP_KERNEL);
 
-	device->cache.lmc_cache = kmalloc(sizeof *device->cache.lmc_cache *
-					  (end_port(device) -
-					   start_port(device) + 1),
-					  GFP_KERNEL);
-
-	if (!device->cache.pkey_cache || !device->cache.gid_cache ||
-	    !device->cache.lmc_cache) {
+	if (!device->cache.pkey_cache || !device->cache.gid_cache) {
 		printk(KERN_WARNING "Couldn't allocate cache "
 		       "for %s\n", device->name);
 		goto err;
@@ -383,7 +357,6 @@ err_cache:
 err:
 	kfree(device->cache.pkey_cache);
 	kfree(device->cache.gid_cache);
-	kfree(device->cache.lmc_cache);
 }
 
 static void ib_cache_cleanup_one(struct ib_device *device)
@@ -400,7 +373,6 @@ static void ib_cache_cleanup_one(struct ib_device *device)
 
 	kfree(device->cache.pkey_cache);
 	kfree(device->cache.gid_cache);
-	kfree(device->cache.lmc_cache);
 }
 
 static struct ib_client cache_client = {
diff --git a/include/rdma/ib_cache.h b/include/rdma/ib_cache.h
index 00a2b8e..e0c360f 100644
--- a/include/rdma/ib_cache.h
+++ b/include/rdma/ib_cache.h
@@ -100,17 +100,4 @@ int ib_find_cached_pkey(struct ib_device    *device,
 			u16                  pkey,
 			u16                 *index);
 
-/**
- * ib_get_cached_lmc - Returns a cached lmc table entry
- * @device: The device to query.
- * @port_num: The port number of the device to query.
- * @lmc: The lmc value for the specified port for that device.
- *
- * ib_get_cached_lmc() fetches the specified lmc table entry stored in
- * the local software cache.
- */
-int ib_get_cached_lmc(struct ib_device *device,
-		      u8                port_num,
-		      u8                *lmc);
-
 #endif /* _IB_CACHE_H */
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index a6cf9f4..630b09f 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1012,7 +1012,6 @@ struct ib_cache {
 	struct ib_event_handler event_handler;
 	struct ib_pkey_cache  **pkey_cache;
 	struct ib_gid_cache   **gid_cache;
-	u8                     *lmc_cache;
 };
 
 struct ib_dma_mapping_ops {
-- 
1.7.6


-- 
Goldwyn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
