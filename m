From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 08/11] Functions to drop caches
Date: Mon, 7 Nov 2011 14:20:28 +0530
Message-ID: <20111107085024.GA11485@shrek.cartoons>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

These functions are called in case of port changes or device resets etc.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
---
 drivers/infiniband/core/cache.c |   26 ++++++++++++++++++++++++++
 include/rdma/ib_cache.h         |   15 +++++++++++++++
 2 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 67252ad..532d442 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -397,6 +397,19 @@ static void ib_cache_pkey_free(struct ib_pkey_cache *cache)
 	kfree(cache);
 }
 
+int ib_cache_pkey_drop(struct ib_cache *cache, u8 port_num)
+{
+	struct ib_pkey_cache *pc;
+	unsigned long flags;
+
+	write_lock_irqsave(&cache->lock, flags);
+	pc = cache->pkey_cache[port_num - cache->start_port];
+	memset(pc->valid_bm, 0, BITS_TO_LONGS(pc->table_len));
+	write_unlock_irqrestore(&cache->lock, flags);
+	return 0;
+}
+EXPORT_SYMBOL(ib_cache_pkey_drop);
+
 static struct ib_gid_cache *ib_cache_gid_alloc(int size)
 {
 	struct ib_gid_cache *gc;
@@ -419,6 +432,19 @@ static void ib_cache_gid_free(struct ib_gid_cache *cache)
 	kfree(cache);
 }
 
+int ib_cache_gid_drop(struct ib_cache *cache, u8 port_num)
+{
+	struct ib_gid_cache *gc;
+	unsigned long flags;
+
+	write_lock_irqsave(&cache->lock, flags);
+	gc = cache->gid_cache[port_num - cache->start_port];
+	memset(gc->valid_bm, 0, BITS_TO_LONGS(gc->table_len));
+	write_unlock_irqrestore(&cache->lock, flags);
+	return 0;
+}
+EXPORT_SYMBOL(ib_cache_gid_drop);
+
 int ib_cache_init(struct ib_cache *cache,
 		  struct ib_device *device)
 {
diff --git a/include/rdma/ib_cache.h b/include/rdma/ib_cache.h
index a5d7c7d..8a23663 100644
--- a/include/rdma/ib_cache.h
+++ b/include/rdma/ib_cache.h
@@ -138,4 +138,19 @@ int ib_cache_init(struct ib_cache *cache,
  * @cache: The cache to free
  */
 void ib_cache_free(struct ib_cache *cache);
+
+/**
+ * ib_cache_pkey_drop - drop the pkey cache entry associated with port
+ * @cache: The cache to free
+ * @port_num: port number entry in the cache
+ */
+int ib_cache_pkey_drop(struct ib_cache *cache, u8 port_num);
+
+
+/**
+ * ib_cache_gid_drop - drop the gid cache entry associated with port
+ * @cache: The cache to free
+ * @port_num: port number entry in the cache
+ */
+int ib_cache_gid_drop(struct ib_cache *cache, u8 port_num);
 #endif /* _IB_CACHE_H */
-- 
1.7.6


-- 
Goldwyn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
