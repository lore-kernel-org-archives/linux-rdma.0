From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 07/11] Functions to setup and free cache
Date: Mon, 7 Nov 2011 14:20:14 +0530
Message-ID: <20111107085008.GA11480@shrek.cartoons>
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
 drivers/infiniband/core/cache.c |  104 +++++++++++++++++++++++++++++++++++++++
 include/rdma/ib_cache.h         |   13 +++++
 2 files changed, 117 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 8c99788..67252ad 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -375,6 +375,110 @@ static void ib_cache_event(struct ib_event_handler *handler,
 	}
 }
 
+static struct ib_pkey_cache *ib_cache_pkey_alloc(int size)
+{
+	struct ib_pkey_cache *pc;
+	pc = kmalloc(sizeof(struct ib_pkey_cache) + size *
+			     sizeof(u16), GFP_KERNEL);
+	if (!pc)
+		return ERR_PTR(-ENOMEM);
+	pc->table_len = size;
+	pc->valid_bm = kzalloc(BITS_TO_LONGS(size), GFP_KERNEL);
+	if (!pc->valid_bm) {
+		kfree(pc);
+		return ERR_PTR(-ENOMEM);
+	}
+	return pc;
+}
+
+static void ib_cache_pkey_free(struct ib_pkey_cache *cache)
+{
+	kfree(cache->valid_bm);
+	kfree(cache);
+}
+
+static struct ib_gid_cache *ib_cache_gid_alloc(int size)
+{
+	struct ib_gid_cache *gc;
+	gc = kmalloc(sizeof(struct ib_gid_cache) + size *
+			     sizeof(u16), GFP_KERNEL);
+	if (!gc)
+		return ERR_PTR(-ENOMEM);
+	gc->table_len = size;
+	gc->valid_bm = kzalloc(BITS_TO_LONGS(size), GFP_KERNEL);
+	if (!gc->valid_bm) {
+		kfree(gc);
+		return ERR_PTR(-ENOMEM);
+	}
+	return gc;
+}
+
+static void ib_cache_gid_free(struct ib_gid_cache *cache)
+{
+	kfree(cache->valid_bm);
+	kfree(cache);
+}
+
+int ib_cache_init(struct ib_cache *cache,
+		  struct ib_device *device)
+{
+	int p, len;
+	int ret = -ENOMEM;
+	struct ib_port_attr	attr;
+
+	cache->start_port = start_port(device);
+	cache->end_port = end_port(device);
+	len = cache->end_port - cache->start_port + 1;
+	
+	rwlock_init(&cache->lock);
+	cache->pkey_cache = kzalloc(sizeof(struct ib_pkey_cache) * len,
+				    GFP_KERNEL);
+	if (!cache->pkey_cache) {
+		printk(KERN_WARNING "Could not allocate pkey_cache for %s\n",
+		       device->name);
+		goto err;
+	}
+
+	cache->gid_cache = kzalloc(sizeof(struct ib_gid_cache) * len,
+			           GFP_KERNEL);
+	if (!cache->gid_cache) {
+		printk(KERN_WARNING "Could not allocate gid_cache for %s\n",
+		       device->name);
+		kfree(cache->pkey_cache);
+		goto err;
+	}
+
+	for (p = 0; p < len; ++p) {
+		cache->pkey_cache[p] = NULL;
+		cache->gid_cache [p] = NULL;
+		ret = ib_query_port(device, p + cache->start_port, &attr);
+		if (ret) {
+			printk(KERN_WARNING "ib_query_port failed (%d) "
+			       "for %s\n", ret, device->name);
+			goto err;
+		}
+		cache->pkey_cache[p] = ib_cache_pkey_alloc(attr.pkey_tbl_len);
+		cache->gid_cache[p] = ib_cache_gid_alloc(attr.gid_tbl_len);
+	}
+	ret = 0;
+err:
+	return ret;
+}
+EXPORT_SYMBOL(ib_cache_init);
+
+void ib_cache_free(struct ib_cache *cache)
+{
+	int p;
+	for (p = 0; p <= cache->end_port - cache->start_port; ++p) {
+		ib_cache_pkey_free(cache->pkey_cache[p]);
+		ib_cache_gid_free(cache->gid_cache[p]);
+	}
+
+	kfree(cache->pkey_cache);
+	kfree(cache->gid_cache);
+}
+EXPORT_SYMBOL(ib_cache_free);
+
 static void ib_cache_setup_one(struct ib_device *device)
 {
 	int p;
diff --git a/include/rdma/ib_cache.h b/include/rdma/ib_cache.h
index 4dd91dc..a5d7c7d 100644
--- a/include/rdma/ib_cache.h
+++ b/include/rdma/ib_cache.h
@@ -125,4 +125,17 @@ int ib_update_cached_gid(struct ib_cache *cach,
 			 int index,
 			 union ib_gid gid);
 
+/**
+ * ib_cache_init - initializes the cache data structure
+ * @cache: The cache to setup
+ * @cache: The device for which the cache is setup
+ */
+int ib_cache_init(struct ib_cache *cache,
+			 struct ib_device *device);
+
+/**
+ * ib_cache_free - releases the cache data structure
+ * @cache: The cache to free
+ */
+void ib_cache_free(struct ib_cache *cache);
 #endif /* _IB_CACHE_H */
-- 
1.7.6


-- 
Goldwyn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
