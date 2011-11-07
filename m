From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 10/11] Remove cache finding functions
Date: Mon, 7 Nov 2011 14:20:58 +0530
Message-ID: <20111107085054.GA11494@shrek.cartoons>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Cache finding functions are no longer required since the query
functions take care of the caching.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
---
 drivers/infiniband/core/cache.c |   72 ---------------------------------------
 include/rdma/ib_cache.h         |   34 ------------------
 2 files changed, 0 insertions(+), 106 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 3e410fe..09b0586 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -103,43 +103,6 @@ out:
 }
 EXPORT_SYMBOL(ib_get_cached_gid);
 
-int ib_find_cached_gid(struct ib_cache *cache,
-		       union ib_gid	*gid,
-		       u8               *port_num,
-		       u16              *index)
-{
-	struct ib_gid_cache *gc;
-	unsigned long flags;
-	int p, i;
-	int ret = -ENOENT;
-
-	*port_num = -1;
-	if (index)
-		*index = -1;
-
-	read_lock_irqsave(&cache->lock, flags);
-
-	for (p = 0; p <= cache->end_port - cache->start_port; ++p) {
-		gc = cache->gid_cache[p];
-		for (i = 0; i < gc->table_len; ++i) {
-			if (!test_bit(i, gc->valid_bm))
-				continue;
-			if (!memcmp(gid, &gc->table[i], sizeof *gid)) {
-				*port_num = p + cache->start_port;
-				if (index)
-					*index = i;
-				ret = 0;
-				goto found;
-			}
-		}
-	}
-found:
-	read_unlock_irqrestore(&cache->lock, flags);
-
-	return ret;
-}
-EXPORT_SYMBOL(ib_find_cached_gid);
-
 int ib_get_cached_pkey(struct ib_cache  *cache,
 		       u8                port_num,
 		       int               index,
@@ -171,41 +134,6 @@ out:
 }
 EXPORT_SYMBOL(ib_get_cached_pkey);
 
-int ib_find_cached_pkey(struct ib_cache *cache,
-			u8                port_num,
-			u16               pkey,
-			u16              *index)
-{
-	struct ib_pkey_cache *pc;
-	unsigned long flags;
-	int i;
-	int ret = -ENOENT;
-
-	if (port_num < cache->start_port || port_num > cache->end_port)
-		return -EINVAL;
-
-	read_lock_irqsave(&cache->lock, flags);
-
-	pc = cache->pkey_cache[port_num - cache->start_port];
-
-	*index = -1;
-
-	for (i = 0; i < pc->table_len; ++i) {
-		if (!test_bit(i, pc->valid_bm))
-			continue;
-		if ((pc->table[i] & 0x7fff) == (pkey & 0x7fff)) {
-			*index = i;
-			ret = 0;
-			break;
-		}
-	}
-
-	read_unlock_irqrestore(&cache->lock, flags);
-
-	return ret;
-}
-EXPORT_SYMBOL(ib_find_cached_pkey);
-
 int ib_update_cached_pkey(struct ib_cache *cache,
 	  		  u8 port_num,
 			  int index,
diff --git a/include/rdma/ib_cache.h b/include/rdma/ib_cache.h
index 8a23663..a290070 100644
--- a/include/rdma/ib_cache.h
+++ b/include/rdma/ib_cache.h
@@ -53,23 +53,6 @@ int ib_get_cached_gid(struct ib_cache     *cache,
 		      union ib_gid        *gid);
 
 /**
- * ib_find_cached_gid - Returns the port number and GID table index where
- *   a specified GID value occurs.
- * @device: The device to query.
- * @gid: The GID value to search for.
- * @port_num: The port number of the device where the GID value was found.
- * @index: The index into the cached GID table where the GID was found.  This
- *   parameter may be NULL.
- *
- * ib_find_cached_gid() searches for the specified GID value in
- * the local software cache.
- */
-int ib_find_cached_gid(struct ib_cache  *cache,
-		       union ib_gid	*gid,
-		       u8               *port_num,
-		       u16              *index);
-
-/**
  * ib_get_cached_pkey - Returns a cached PKey table entry
  * @device: The device to query.
  * @port_num: The port number of the device to query.
@@ -85,23 +68,6 @@ int ib_get_cached_pkey(struct ib_cache    *cache,
 		       u16                 *pkey);
 
 /**
- * ib_find_cached_pkey - Returns the PKey table index where a specified
- *   PKey value occurs.
- * @device: The device to query.
- * @port_num: The port number of the device to search for the PKey.
- * @pkey: The PKey value to search for.
- * @index: The index into the cached PKey table where the PKey was found.
- *
- * ib_find_cached_pkey() searches the specified PKey table in
- * the local software cache.
- */
-int ib_find_cached_pkey(struct ib_cache     *cache,
-			u8                   port_num,
-			u16                  pkey,
-			u16                 *index);
-
-
-/**
  * ib_update_cached_pkey - updates the cache with the value specified
  * @cache: The cache to query
  * @port_num: The port number of the device
-- 
1.7.6


-- 
Goldwyn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
