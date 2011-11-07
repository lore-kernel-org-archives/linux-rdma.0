From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 06/11] Add cache update functions
Date: Mon, 7 Nov 2011 14:19:56 +0530
Message-ID: <20111107084952.GA11476@shrek.cartoons>
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
 drivers/infiniband/core/cache.c |   54 +++++++++++++++++++++++++++++++++++++++
 include/rdma/ib_cache.h         |   25 ++++++++++++++++++
 2 files changed, 79 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index f6d0830..8c99788 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -206,6 +206,60 @@ int ib_find_cached_pkey(struct ib_cache *cache,
 }
 EXPORT_SYMBOL(ib_find_cached_pkey);
 
+int ib_update_cached_pkey(struct ib_cache *cache,
+	  		  u8 port_num,
+			  int index,
+			  u16 pkey)
+{
+	struct ib_pkey_cache *pc;
+	unsigned long flags;
+	int ret = 0;
+
+	if (port_num < cache->start_port || port_num > cache->end_port)
+		return -EINVAL;
+
+	write_lock_irqsave(&cache->lock, flags);
+
+	pc = cache->pkey_cache[port_num - cache->start_port];
+
+	if (index < 0 || index >= pc->table_len)
+		ret = -EINVAL;
+	else
+		pc->table[index] = pkey;
+
+	write_unlock_irqrestore(&cache->lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(ib_update_cached_pkey);
+
+int ib_update_cached_gid(struct ib_cache *cache,
+			 u8 port_num,
+			 int index,
+			 union ib_gid gid)
+{
+	struct ib_gid_cache *gc;
+	unsigned long flags;
+	int ret = 0;
+
+	if (port_num < cache->start_port || port_num > cache->end_port)
+		return -EINVAL;
+
+	write_lock_irqsave(&cache->lock, flags);
+
+	gc = cache->gid_cache[port_num - cache->start_port];
+
+	if (index < 0 || index >= gc->table_len)
+		ret = -EINVAL;
+	else
+		gc->table[index] = gid;
+
+	write_unlock_irqrestore(&cache->lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(ib_update_cached_gid);
+
 static void ib_cache_update(struct ib_device *device,
 			    u8                port)
 {
diff --git a/include/rdma/ib_cache.h b/include/rdma/ib_cache.h
index 8af9d07..4dd91dc 100644
--- a/include/rdma/ib_cache.h
+++ b/include/rdma/ib_cache.h
@@ -100,4 +100,29 @@ int ib_find_cached_pkey(struct ib_cache     *cache,
 			u16                  pkey,
 			u16                 *index);
 
+
+/**
+ * ib_update_cached_pkey - updates the cache with the value specified
+ * @cache: The cache to query
+ * @port_num: The port number of the device
+ * @index: The index into the cached PKey table
+ * @pkey: The PKey value to be set
+ */
+int ib_update_cached_pkey(struct ib_cache *cache,
+	  		  u8 port_num,
+			  int index,
+			  u16 pkey);
+
+/**
+ * ib_update_cached_gid - updates the cache with the gid
+ * @cache: The cache to query
+ * @port_num: The port number of the device
+ * @index: The index into the cached PKey table
+ * @gid: The gid value to be set
+ */
+int ib_update_cached_gid(struct ib_cache *cach,
+			 u8 port_num,
+			 int index,
+			 union ib_gid gid);
+
 #endif /* _IB_CACHE_H */
-- 
1.7.6


-- 
Goldwyn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
