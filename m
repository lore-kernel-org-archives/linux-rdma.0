From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 01/11] Enable bitmaps for valid cache entries
Date: Mon, 7 Nov 2011 14:18:25 +0530
Message-ID: <20111107084821.GA11453@shrek.cartoons>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add a bitmap to check if the entry is valid or not. This keeps a record of
which entries have been updated and which have not.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
---
 drivers/infiniband/core/cache.c |   26 ++++++++++++++++++++++++--
 1 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 9353992..c9c9530 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -44,11 +44,13 @@
 
 struct ib_pkey_cache {
 	int             table_len;
+	unsigned long	*valid_bm;
 	u16             table[0];
 };
 
 struct ib_gid_cache {
 	int             table_len;
+	unsigned long	*valid_bm;
 	union ib_gid    table[0];
 };
 
@@ -85,13 +87,18 @@ int ib_get_cached_gid(struct ib_device *device,
 
 	cache = device->cache.gid_cache[port_num - start_port(device)];
 
+	if (!test_bit(index, cache->valid_bm)) {
+		ret = -ENOENT;
+		goto out;
+	}
+
 	if (index < 0 || index >= cache->table_len)
 		ret = -EINVAL;
 	else
 		*gid = cache->table[index];
 
+out:
 	read_unlock_irqrestore(&device->cache.lock, flags);
-
 	return ret;
 }
 EXPORT_SYMBOL(ib_get_cached_gid);
@@ -146,6 +153,10 @@ int ib_get_cached_pkey(struct ib_device *device,
 	read_lock_irqsave(&device->cache.lock, flags);
 
 	cache = device->cache.pkey_cache[port_num - start_port(device)];
+	if (!test_bit(index, cache->valid_bm)) {
+		ret = -ENOENT;
+		goto out;
+	}
 
 	if (index < 0 || index >= cache->table_len)
 		ret = -EINVAL;
@@ -153,7 +164,7 @@ int ib_get_cached_pkey(struct ib_device *device,
 		*pkey = cache->table[index];
 
 	read_unlock_irqrestore(&device->cache.lock, flags);
-
+out:
 	return ret;
 }
 EXPORT_SYMBOL(ib_get_cached_pkey);
@@ -234,6 +245,11 @@ static void ib_cache_update(struct ib_device *device,
 		goto err;
 
 	pkey_cache->table_len = tprops->pkey_tbl_len;
+	pkey_cache->valid_bm = kzalloc(BITS_TO_LONGS(pkey_cache->table_len),
+		GFP_KERNEL);
+	if (!pkey_cache->valid_bm)
+		goto err;
+
 
 	gid_cache = kmalloc(sizeof *gid_cache + tprops->gid_tbl_len *
 			    sizeof *gid_cache->table, GFP_KERNEL);
@@ -241,6 +257,10 @@ static void ib_cache_update(struct ib_device *device,
 		goto err;
 
 	gid_cache->table_len = tprops->gid_tbl_len;
+	gid_cache->valid_bm = kzalloc(BITS_TO_LONGS(gid_cache->table_len),
+		GFP_KERNEL);
+	if (!gid_cache->valid_bm)
+		goto err;
 
 	for (i = 0; i < pkey_cache->table_len; ++i) {
 		ret = ib_query_pkey(device, port, i, pkey_cache->table + i);
@@ -249,6 +269,7 @@ static void ib_cache_update(struct ib_device *device,
 			       ret, device->name, i);
 			goto err;
 		}
+		set_bit(i, pkey_cache->valid_bm);
 	}
 
 	for (i = 0; i < gid_cache->table_len; ++i) {
@@ -258,6 +279,7 @@ static void ib_cache_update(struct ib_device *device,
 			       ret, device->name, i);
 			goto err;
 		}
+		set_bit(i, gid_cache->valid_bm);
 	}
 
 	write_lock_irq(&device->cache.lock);
-- 
1.7.6


-- 
Goldwyn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
