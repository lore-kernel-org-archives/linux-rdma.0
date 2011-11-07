From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 05/11] Use cache structure instead of device (pkey)
Date: Mon, 7 Nov 2011 14:19:41 +0530
Message-ID: <20111107084937.GA11472@shrek.cartoons>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Changes all ib_xxx_cached_pkey funcitons to use device structure instead
of cache structure.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
---
 drivers/infiniband/core/cache.c |   37 ++++++++++++++++++++-----------------
 include/rdma/ib_cache.h         |    4 ++--
 2 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 4797b2b..f6d0830 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -140,64 +140,67 @@ found:
 }
 EXPORT_SYMBOL(ib_find_cached_gid);
 
-int ib_get_cached_pkey(struct ib_device *device,
+int ib_get_cached_pkey(struct ib_cache  *cache,
 		       u8                port_num,
 		       int               index,
 		       u16              *pkey)
 {
-	struct ib_pkey_cache *cache;
+	struct ib_pkey_cache *pc;
 	unsigned long flags;
 	int ret = 0;
 
-	if (port_num < start_port(device) || port_num > end_port(device))
+	if (port_num < cache->start_port || port_num > cache->end_port)
 		return -EINVAL;
 
-	read_lock_irqsave(&device->cache.lock, flags);
+	read_lock_irqsave(&cache->lock, flags);
 
-	cache = device->cache.pkey_cache[port_num - start_port(device)];
-	if (!test_bit(index, cache->valid_bm)) {
+	pc = cache->pkey_cache[port_num - cache->start_port];
+	if (!test_bit(index, pc->valid_bm)) {
 		ret = -ENOENT;
 		goto out;
 	}
 
-	if (index < 0 || index >= cache->table_len)
+	if (index < 0 || index >= pc->table_len)
 		ret = -EINVAL;
 	else
-		*pkey = cache->table[index];
+		*pkey = pc->table[index];
 
-	read_unlock_irqrestore(&device->cache.lock, flags);
 out:
+	read_unlock_irqrestore(&cache->lock, flags);
 	return ret;
 }
 EXPORT_SYMBOL(ib_get_cached_pkey);
 
-int ib_find_cached_pkey(struct ib_device *device,
+int ib_find_cached_pkey(struct ib_cache *cache,
 			u8                port_num,
 			u16               pkey,
 			u16              *index)
 {
-	struct ib_pkey_cache *cache;
+	struct ib_pkey_cache *pc;
 	unsigned long flags;
 	int i;
 	int ret = -ENOENT;
 
-	if (port_num < start_port(device) || port_num > end_port(device))
+	if (port_num < cache->start_port || port_num > cache->end_port)
 		return -EINVAL;
 
-	read_lock_irqsave(&device->cache.lock, flags);
+	read_lock_irqsave(&cache->lock, flags);
 
-	cache = device->cache.pkey_cache[port_num - start_port(device)];
+	pc = cache->pkey_cache[port_num - cache->start_port];
 
 	*index = -1;
 
-	for (i = 0; i < cache->table_len; ++i)
-		if ((cache->table[i] & 0x7fff) == (pkey & 0x7fff)) {
+	for (i = 0; i < pc->table_len; ++i) {
+		if (!test_bit(i, pc->valid_bm))
+			continue;
+		if ((pc->table[i] & 0x7fff) == (pkey & 0x7fff)) {
 			*index = i;
 			ret = 0;
 			break;
 		}
+	}
 
-	read_unlock_irqrestore(&device->cache.lock, flags);
+	read_unlock_irqrestore(&cache->lock, flags);
 
 	return ret;
 }
diff --git a/include/rdma/ib_cache.h b/include/rdma/ib_cache.h
index c18d2ed..8af9d07 100644
--- a/include/rdma/ib_cache.h
+++ b/include/rdma/ib_cache.h
@@ -79,7 +79,7 @@ int ib_find_cached_gid(struct ib_cache  *cache,
  * ib_get_cached_pkey() fetches the specified PKey table entry stored in
  * the local software cache.
  */
-int ib_get_cached_pkey(struct ib_device    *device_handle,
+int ib_get_cached_pkey(struct ib_cache    *cache,
 		       u8                   port_num,
 		       int                  index,
 		       u16                 *pkey);
@@ -95,7 +95,7 @@ int ib_get_cached_pkey(struct ib_device    *device_handle,
  * ib_find_cached_pkey() searches the specified PKey table in
  * the local software cache.
  */
-int ib_find_cached_pkey(struct ib_device    *device,
+int ib_find_cached_pkey(struct ib_cache     *cache,
 			u8                   port_num,
 			u16                  pkey,
 			u16                 *index);
-- 
1.7.6


-- 
Goldwyn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
