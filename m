From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 09/11] Remove old cache setup functions
Date: Mon, 7 Nov 2011 14:20:44 +0530
Message-ID: <20111107085040.GA11490@shrek.cartoons>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
---
 drivers/infiniband/core/cache.c  |  193 --------------------------------------
 drivers/infiniband/core/device.c |   10 --
 2 files changed, 0 insertions(+), 203 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 532d442..3e410fe 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -260,121 +260,6 @@ int ib_update_cached_gid(struct ib_cache *cache,
 }
 EXPORT_SYMBOL(ib_update_cached_gid);
 
-static void ib_cache_update(struct ib_device *device,
-			    u8                port)
-{
-	struct ib_port_attr       *tprops = NULL;
-	struct ib_pkey_cache      *pkey_cache = NULL, *old_pkey_cache;
-	struct ib_gid_cache       *gid_cache = NULL, *old_gid_cache;
-	int                        i;
-	int                        ret;
-
-	tprops = kmalloc(sizeof *tprops, GFP_KERNEL);
-	if (!tprops)
-		return;
-
-	ret = ib_query_port(device, port, tprops);
-	if (ret) {
-		printk(KERN_WARNING "ib_query_port failed (%d) for %s\n",
-		       ret, device->name);
-		goto err;
-	}
-
-	pkey_cache = kmalloc(sizeof *pkey_cache + tprops->pkey_tbl_len *
-			     sizeof *pkey_cache->table, GFP_KERNEL);
-	if (!pkey_cache)
-		goto err;
-
-	pkey_cache->table_len = tprops->pkey_tbl_len;
-	pkey_cache->valid_bm = kzalloc(BITS_TO_LONGS(pkey_cache->table_len),
-		GFP_KERNEL);
-	if (!pkey_cache->valid_bm)
-		goto err;
-
-
-	gid_cache = kmalloc(sizeof *gid_cache + tprops->gid_tbl_len *
-			    sizeof *gid_cache->table, GFP_KERNEL);
-	if (!gid_cache)
-		goto err;
-
-	gid_cache->table_len = tprops->gid_tbl_len;
-	gid_cache->valid_bm = kzalloc(BITS_TO_LONGS(gid_cache->table_len),
-		GFP_KERNEL);
-	if (!gid_cache->valid_bm)
-		goto err;
-
-	for (i = 0; i < pkey_cache->table_len; ++i) {
-		ret = ib_query_pkey(device, port, i, pkey_cache->table + i);
-		if (ret) {
-			printk(KERN_WARNING "ib_query_pkey failed (%d) for %s (index %d)\n",
-			       ret, device->name, i);
-			goto err;
-		}
-		set_bit(i, pkey_cache->valid_bm);
-	}
-
-	for (i = 0; i < gid_cache->table_len; ++i) {
-		ret = ib_query_gid(device, port, i, gid_cache->table + i);
-		if (ret) {
-			printk(KERN_WARNING "ib_query_gid failed (%d) for %s (index %d)\n",
-			       ret, device->name, i);
-			goto err;
-		}
-		set_bit(i, gid_cache->valid_bm);
-	}
-
-	write_lock_irq(&device->cache.lock);
-
-	old_pkey_cache = device->cache.pkey_cache[port - start_port(device)];
-	old_gid_cache  = device->cache.gid_cache [port - start_port(device)];
-
-	device->cache.pkey_cache[port - start_port(device)] = pkey_cache;
-	device->cache.gid_cache [port - start_port(device)] = gid_cache;
-
-	write_unlock_irq(&device->cache.lock);
-
-	kfree(old_pkey_cache);
-	kfree(old_gid_cache);
-	kfree(tprops);
-	return;
-
-err:
-	kfree(pkey_cache);
-	kfree(gid_cache);
-	kfree(tprops);
-}
-
-static void ib_cache_task(struct work_struct *_work)
-{
-	struct ib_update_work *work =
-		container_of(_work, struct ib_update_work, work);
-
-	ib_cache_update(work->device, work->port_num);
-	kfree(work);
-}
-
-static void ib_cache_event(struct ib_event_handler *handler,
-			   struct ib_event *event)
-{
-	struct ib_update_work *work;
-
-	if (event->event == IB_EVENT_PORT_ERR    ||
-	    event->event == IB_EVENT_PORT_ACTIVE ||
-	    event->event == IB_EVENT_LID_CHANGE  ||
-	    event->event == IB_EVENT_PKEY_CHANGE ||
-	    event->event == IB_EVENT_SM_CHANGE   ||
-	    event->event == IB_EVENT_CLIENT_REREGISTER ||
-	    event->event == IB_EVENT_GID_CHANGE) {
-		work = kmalloc(sizeof *work, GFP_ATOMIC);
-		if (work) {
-			INIT_WORK(&work->work, ib_cache_task);
-			work->device   = event->device;
-			work->port_num = event->element.port_num;
-			queue_work(ib_wq, &work->work);
-		}
-	}
-}
-
 static struct ib_pkey_cache *ib_cache_pkey_alloc(int size)
 {
 	struct ib_pkey_cache *pc;
@@ -504,81 +389,3 @@ void ib_cache_free(struct ib_cache *cache)
 	kfree(cache->gid_cache);
 }
 EXPORT_SYMBOL(ib_cache_free);
-
-static void ib_cache_setup_one(struct ib_device *device)
-{
-	int p;
-
-	device->cache.start_port = start_port(device);
-	device->cache.end_port = end_port(device);
-
-	rwlock_init(&device->cache.lock);
-
-	device->cache.pkey_cache =
-		kmalloc(sizeof *device->cache.pkey_cache *
-			(end_port(device) - start_port(device) + 1), GFP_KERNEL);
-	device->cache.gid_cache =
-		kmalloc(sizeof *device->cache.gid_cache *
-			(end_port(device) - start_port(device) + 1), GFP_KERNEL);
-
-	if (!device->cache.pkey_cache || !device->cache.gid_cache) {
-		printk(KERN_WARNING "Couldn't allocate cache "
-		       "for %s\n", device->name);
-		goto err;
-	}
-
-	for (p = 0; p <= end_port(device) - start_port(device); ++p) {
-		device->cache.pkey_cache[p] = NULL;
-		device->cache.gid_cache [p] = NULL;
-		ib_cache_update(device, p + start_port(device));
-	}
-
-	INIT_IB_EVENT_HANDLER(&device->cache.event_handler,
-			      device, ib_cache_event);
-	if (ib_register_event_handler(&device->cache.event_handler))
-		goto err_cache;
-
-	return;
-
-err_cache:
-	for (p = 0; p <= end_port(device) - start_port(device); ++p) {
-		kfree(device->cache.pkey_cache[p]);
-		kfree(device->cache.gid_cache[p]);
-	}
-
-err:
-	kfree(device->cache.pkey_cache);
-	kfree(device->cache.gid_cache);
-}
-
-static void ib_cache_cleanup_one(struct ib_device *device)
-{
-	int p;
-
-	ib_unregister_event_handler(&device->cache.event_handler);
-	flush_workqueue(ib_wq);
-
-	for (p = 0; p <= end_port(device) - start_port(device); ++p) {
-		kfree(device->cache.pkey_cache[p]);
-		kfree(device->cache.gid_cache[p]);
-	}
-
-	kfree(device->cache.pkey_cache);
-	kfree(device->cache.gid_cache);
-}
-
-static struct ib_client cache_client = {
-	.name   = "cache",
-	.add    = ib_cache_setup_one,
-	.remove = ib_cache_cleanup_one
-};
-
-int __init ib_cache_setup(void)
-{
-	return ib_register_client(&cache_client);
-}
-
-void __exit ib_cache_cleanup(void)
-{
-	ib_unregister_client(&cache_client);
-}
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 5ea7652..52793ee 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -766,17 +766,8 @@ static int __init ib_core_init(void)
 		goto err_sysfs;
 	}
 
-	ret = ib_cache_setup();
-	if (ret) {
-		printk(KERN_WARNING "Couldn't set up InfiniBand P_Key/GID cache\n");
-		goto err_nl;
-	}
-
 	return 0;
 
-err_nl:
-	ibnl_cleanup();
-
 err_sysfs:
 	ib_sysfs_cleanup();
 
@@ -787,7 +778,6 @@ err:
 
 static void __exit ib_core_cleanup(void)
 {
-	ib_cache_cleanup();
 	ibnl_cleanup();
 	ib_sysfs_cleanup();
 	/* Make sure that any pending umem accounting work is done. */
-- 
1.7.6


-- 
Goldwyn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
