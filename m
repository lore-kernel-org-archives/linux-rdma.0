From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 04/11] Use cache structure instead of device (gid)
Date: Mon, 7 Nov 2011 14:19:25 +0530
Message-ID: <20111107084921.GA11468@shrek.cartoons>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Changes all ib_xxx_cached_gid funcitons to use device structure instead
of cache structure.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
---
 drivers/infiniband/core/cache.c |   41 +++++++++++++++++++++-----------------
 include/rdma/ib_cache.h         |    4 +-
 include/rdma/ib_verbs.h         |    2 +
 3 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index efe6d00..4797b2b 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -71,44 +71,44 @@ static inline int end_port(struct ib_device *device)
 		0 : device->phys_port_cnt;
 }
 
-int ib_get_cached_gid(struct ib_device *device,
+int ib_get_cached_gid(struct ib_cache *cache,
 		      u8                port_num,
 		      int               index,
 		      union ib_gid     *gid)
 {
-	struct ib_gid_cache *cache;
+	struct ib_gid_cache *gc;
 	unsigned long flags;
 	int ret = 0;
 
-	if (port_num < start_port(device) || port_num > end_port(device))
+	if (port_num < cache->start_port || port_num > cache->end_port)
 		return -EINVAL;
 
-	read_lock_irqsave(&device->cache.lock, flags);
+	read_lock_irqsave(&cache->lock, flags);
 
-	cache = device->cache.gid_cache[port_num - start_port(device)];
+	gc = cache->gid_cache[port_num - cache->start_port];
 
-	if (!test_bit(index, cache->valid_bm)) {
+	if (!test_bit(index, gc->valid_bm)) {
 		ret = -ENOENT;
 		goto out;
 	}
 
-	if (index < 0 || index >= cache->table_len)
+	if (index < 0 || index >= gc->table_len)
 		ret = -EINVAL;
 	else
-		*gid = cache->table[index];
+		*gid = gc->table[index];
 
 out:
-	read_unlock_irqrestore(&device->cache.lock, flags);
+	read_unlock_irqrestore(&cache->lock, flags);
 	return ret;
 }
 EXPORT_SYMBOL(ib_get_cached_gid);
 
-int ib_find_cached_gid(struct ib_device *device,
+int ib_find_cached_gid(struct ib_cache *cache,
 		       union ib_gid	*gid,
 		       u8               *port_num,
 		       u16              *index)
 {
-	struct ib_gid_cache *cache;
+	struct ib_gid_cache *gc;
 	unsigned long flags;
 	int p, i;
 	int ret = -ENOENT;
@@ -117,13 +117,15 @@ int ib_find_cached_gid(struct ib_device *device,
 	if (index)
 		*index = -1;
 
-	read_lock_irqsave(&device->cache.lock, flags);
+	read_lock_irqsave(&cache->lock, flags);
 
-	for (p = 0; p <= end_port(device) - start_port(device); ++p) {
-		cache = device->cache.gid_cache[p];
-		for (i = 0; i < cache->table_len; ++i) {
-			if (!memcmp(gid, &cache->table[i], sizeof *gid)) {
-				*port_num = p + start_port(device);
+	for (p = 0; p <= cache->end_port - cache->start_port; ++p) {
+		gc = cache->gid_cache[p];
+		for (i = 0; i < gc->table_len; ++i) {
+			if (!test_bit(i, gc->valid_bm))
+				continue;
+			if (!memcmp(gid, &gc->table[i], sizeof *gid)) {
+				*port_num = p + cache->start_port;
 				if (index)
 					*index = i;
 				ret = 0;
@@ -132,7 +134,7 @@ int ib_find_cached_gid(struct ib_device *device,
 		}
 	}
 found:
-	read_unlock_irqrestore(&device->cache.lock, flags);
+	read_unlock_irqrestore(&cache->lock, flags);
 
 	return ret;
 }
@@ -320,6 +322,9 @@ static void ib_cache_setup_one(struct ib_device *device)
 {
 	int p;
 
+	device->cache.start_port = start_port(device);
+	device->cache.end_port = end_port(device);
+
 	rwlock_init(&device->cache.lock);
 
 	device->cache.pkey_cache =
diff --git a/include/rdma/ib_cache.h b/include/rdma/ib_cache.h
index e0c360f..c18d2ed 100644
--- a/include/rdma/ib_cache.h
+++ b/include/rdma/ib_cache.h
@@ -47,7 +47,7 @@
  * ib_get_cached_gid() fetches the specified GID table entry stored in
  * the local software cache.
  */
-int ib_get_cached_gid(struct ib_device    *device,
+int ib_get_cached_gid(struct ib_cache     *cache,
 		      u8                   port_num,
 		      int                  index,
 		      union ib_gid        *gid);
@@ -64,7 +64,7 @@ int ib_get_cached_gid(struct ib_device    *device,
  * ib_find_cached_gid() searches for the specified GID value in
  * the local software cache.
  */
-int ib_find_cached_gid(struct ib_device *device,
+int ib_find_cached_gid(struct ib_cache  *cache,
 		       union ib_gid	*gid,
 		       u8               *port_num,
 		       u16              *index);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 630b09f..d047906 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1010,6 +1010,8 @@ enum ib_mad_result {
 struct ib_cache {
 	rwlock_t                lock;
 	struct ib_event_handler event_handler;
+	u8			start_port;
+	u8			end_port;
 	struct ib_pkey_cache  **pkey_cache;
 	struct ib_gid_cache   **gid_cache;
 };
-- 
1.7.6


-- 
Goldwyn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
