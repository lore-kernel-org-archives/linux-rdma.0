From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [Patch v2 3/3] IB/cache: don't fill the cache with junk
Date: Tue, 24 Sep 2013 17:16:29 -0400
Message-ID: <4c88e00f5211787a98fa980a4d42c5c6374ab868.1380056994.git.dledford@redhat.com>
References: <cover.1380056994.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1380056994.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1380056994.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1380056994.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Drier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We keep a cache of the GIDs and PKeys on an IB device, but when we get
the props for the card, the table length returned is the overall table
size and not related to how many valid entries there are in the table.
As a result, we end up with things like 128 entries for GIDs that are 3
valid GIDs and 125 empty GIDs.  Then when we call find_cache_gid, we
search through all 128 GID cache entries using memcmp.  This is
needlessly expensive.  So when we update the cache, check each item we
get from the card to see if it's valid and only save it into the cache
if it is.  We make sure to preserve the index from the card's table with
each cache item so the correct index in the card's table is returned
on any lookup that requests the index.

I have performance numbers on this change, but they aren't really
conclusive.  I made this change after the previous two patches, and
while conceptually it is obvious that search 3 or 4 GIDs is better than
searching through 128 empty GIDs using memcmp, the fact of the matter is
that we normally find our result quickly and so the benefit of this
change is not seen, at least not by using the cmtime application.  In
addition, the immediately previous patch optimized the connect routine's
selection of device to search first, again hiding the benefit of this
change.  It would require a very complex setup with lots of valid GIDs
and connect attempts that were accessing GIDs late in the table to
demonstrate the benefit of this patch clearly, and the cmtime utilitity
from librdmacm does not do that.

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/cache.c | 132 +++++++++++++++++++++++++++++++---------
 1 file changed, 103 insertions(+), 29 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 80f6cf2..d31972d 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -44,12 +44,18 @@
 
 struct ib_pkey_cache {
 	int             table_len;
-	u16             table[0];
+	struct pkey_cache_table_entry {
+		u16             pkey;
+		unsigned char	index;
+	}		entry[0];
 };
 
 struct ib_gid_cache {
 	int             table_len;
-	union ib_gid    table[0];
+	struct gid_cache_table_entry {
+		union ib_gid    gid;
+		unsigned char	index;
+	}		entry[0];
 };
 
 struct ib_update_work {
@@ -76,7 +82,7 @@ int ib_get_cached_gid(struct ib_device *device,
 {
 	struct ib_gid_cache *cache;
 	unsigned long flags;
-	int ret = 0;
+	int i, ret = 0;
 
 	if (port_num < start_port(device) || port_num > end_port(device))
 		return -EINVAL;
@@ -85,13 +91,26 @@ int ib_get_cached_gid(struct ib_device *device,
 
 	cache = device->cache.gid_cache[port_num - start_port(device)];
 
-	if (index < 0 || index >= cache->table_len)
+	if (index < 0 || index >= cache->table_len) {
 		ret = -EINVAL;
-	else
-		*gid = cache->table[index];
+		goto out_unlock;
+	}
 
-	read_unlock_irqrestore(&device->cache.lock, flags);
+	for (i = 0; i < cache->table_len; ++i)
+		if (cache->entry[i].index == index)
+			break;
+
+	if (i < cache->table_len)
+		*gid = cache->entry[i].gid;
+	else {
+		ret = ib_query_gid(device, port_num, index, gid);
+		if (ret)
+			printk(KERN_WARNING "ib_query_gid failed (%d) for %s (index %d)\n",
+			       ret, device->name, index);
+	}
 
+out_unlock:
+	read_unlock_irqrestore(&device->cache.lock, flags);
 	return ret;
 }
 EXPORT_SYMBOL(ib_get_cached_gid);
@@ -115,18 +134,18 @@ int ib_find_cached_gid(struct ib_device *device,
 	for (p = 0; p <= end_port(device) - start_port(device); ++p) {
 		cache = device->cache.gid_cache[p];
 		for (i = 0; i < cache->table_len; ++i) {
-			if (!memcmp(gid, &cache->table[i], sizeof *gid)) {
+			if (!memcmp(gid, &cache->entry[i].gid, sizeof *gid)) {
 				*port_num = p + start_port(device);
 				if (index)
-					*index = i;
+					*index = cache->entry[i].index;
 				ret = 0;
 				goto found;
 			}
 		}
 	}
+
 found:
 	read_unlock_irqrestore(&device->cache.lock, flags);
-
 	return ret;
 }
 EXPORT_SYMBOL(ib_find_cached_gid);
@@ -138,7 +157,7 @@ int ib_get_cached_pkey(struct ib_device *device,
 {
 	struct ib_pkey_cache *cache;
 	unsigned long flags;
-	int ret = 0;
+	int i, ret = 0;
 
 	if (port_num < start_port(device) || port_num > end_port(device))
 		return -EINVAL;
@@ -147,13 +166,22 @@ int ib_get_cached_pkey(struct ib_device *device,
 
 	cache = device->cache.pkey_cache[port_num - start_port(device)];
 
-	if (index < 0 || index >= cache->table_len)
+	if (index < 0 || index >= cache->table_len) {
 		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	for (i = 0; i < cache->table_len; ++i)
+		if (cache->entry[i].index == index)
+			break;
+
+	if (i < cache->table_len)
+		*pkey = cache->entry[i].pkey;
 	else
-		*pkey = cache->table[index];
+		*pkey = 0x0000;
 
+out_unlock:
 	read_unlock_irqrestore(&device->cache.lock, flags);
-
 	return ret;
 }
 EXPORT_SYMBOL(ib_get_cached_pkey);
@@ -179,13 +207,13 @@ int ib_find_cached_pkey(struct ib_device *device,
 	*index = -1;
 
 	for (i = 0; i < cache->table_len; ++i)
-		if ((cache->table[i] & 0x7fff) == (pkey & 0x7fff)) {
-			if (cache->table[i] & 0x8000) {
-				*index = i;
+		if ((cache->entry[i].pkey & 0x7fff) == (pkey & 0x7fff)) {
+			if (cache->entry[i].pkey & 0x8000) {
+				*index = cache->entry[i].index;
 				ret = 0;
 				break;
 			} else
-				partial_ix = i;
+				partial_ix = cache->entry[i].index;
 		}
 
 	if (ret && partial_ix >= 0) {
@@ -219,8 +247,8 @@ int ib_find_exact_cached_pkey(struct ib_device *device,
 	*index = -1;
 
 	for (i = 0; i < cache->table_len; ++i)
-		if (cache->table[i] == pkey) {
-			*index = i;
+		if (cache->entry[i].pkey == pkey) {
+			*index = cache->entry[i].index;
 			ret = 0;
 			break;
 		}
@@ -255,8 +283,10 @@ static void ib_cache_update(struct ib_device *device,
 	struct ib_port_attr       *tprops = NULL;
 	struct ib_pkey_cache      *pkey_cache = NULL, *old_pkey_cache;
 	struct ib_gid_cache       *gid_cache = NULL, *old_gid_cache;
-	int                        i;
+	int                        i, j;
 	int                        ret;
+	union ib_gid		   gid, empty_gid;
+	u16			   pkey;
 
 	tprops = kmalloc(sizeof *tprops, GFP_KERNEL);
 	if (!tprops)
@@ -270,35 +300,79 @@ static void ib_cache_update(struct ib_device *device,
 	}
 
 	pkey_cache = kmalloc(sizeof *pkey_cache + tprops->pkey_tbl_len *
-			     sizeof *pkey_cache->table, GFP_KERNEL);
+			     sizeof *pkey_cache->entry, GFP_KERNEL);
 	if (!pkey_cache)
 		goto err;
 
-	pkey_cache->table_len = tprops->pkey_tbl_len;
+	pkey_cache->table_len = 0;
 
 	gid_cache = kmalloc(sizeof *gid_cache + tprops->gid_tbl_len *
-			    sizeof *gid_cache->table, GFP_KERNEL);
+			    sizeof *gid_cache->entry, GFP_KERNEL);
 	if (!gid_cache)
 		goto err;
 
-	gid_cache->table_len = tprops->gid_tbl_len;
+	gid_cache->table_len = 0;
 
-	for (i = 0; i < pkey_cache->table_len; ++i) {
-		ret = ib_query_pkey(device, port, i, pkey_cache->table + i);
+	for (i = 0, j = 0; i < tprops->pkey_tbl_len; ++i) {
+		ret = ib_query_pkey(device, port, i, &pkey);
 		if (ret) {
 			printk(KERN_WARNING "ib_query_pkey failed (%d) for %s (index %d)\n",
 			       ret, device->name, i);
 			goto err;
 		}
+		/* pkey 0xffff must be the default pkeyand 0x0000 must be the invalid
+		 * pkey per IBTA spec */
+		if (pkey) {
+			pkey_cache->entry[j].index = i;
+			pkey_cache->entry[j++].pkey = pkey;
+		}
 	}
+	pkey_cache->table_len = j;
 
-	for (i = 0; i < gid_cache->table_len; ++i) {
-		ret = ib_query_gid(device, port, i, gid_cache->table + i);
+	memset(&empty_gid, 0, sizeof empty_gid);
+	for (i = 0, j = 0; i < tprops->gid_tbl_len; ++i) {
+		ret = ib_query_gid(device, port, i, &gid);
 		if (ret) {
 			printk(KERN_WARNING "ib_query_gid failed (%d) for %s (index %d)\n",
 			       ret, device->name, i);
 			goto err;
 		}
+		/* if the lower 8 bytes the device GID entry is all 0,
+		 * our entry is a blank, invalid entry...
+		 * depending on device, the upper 8 bytes might or might
+		 * not be prefilled with a valid subnet prefix, so
+		 * don't rely on them for determining a valid gid
+		 * entry
+		 */
+		if (memcmp(&gid + 8, &empty_gid + 8, sizeof gid - 8)) {
+			gid_cache->entry[j].index = i;
+			gid_cache->entry[j++].gid = gid;
+		}
+	}
+	gid_cache->table_len = j;
+
+	old_pkey_cache = pkey_cache;
+	pkey_cache = kmalloc(sizeof *pkey_cache + old_pkey_cache->table_len *
+			     sizeof *pkey_cache->entry, GFP_KERNEL);
+	if (!pkey_cache)
+		pkey_cache = old_pkey_cache;
+	else {
+		pkey_cache->table_len = old_pkey_cache->table_len;
+		memcpy(&pkey_cache->entry[0], &old_pkey_cache->entry[0],
+		       pkey_cache->table_len * sizeof *pkey_cache->entry);
+		kfree(old_pkey_cache);
+	}
+
+	old_gid_cache = gid_cache;
+	gid_cache = kmalloc(sizeof *gid_cache + old_gid_cache->table_len *
+			    sizeof *gid_cache->entry, GFP_KERNEL);
+	if (!gid_cache)
+		gid_cache = old_gid_cache;
+	else {
+		gid_cache->table_len = old_gid_cache->table_len;
+		memcpy(&gid_cache->entry[0], &old_gid_cache->entry[0],
+		       gid_cache->table_len * sizeof *gid_cache->entry);
+		kfree(old_gid_cache);
 	}
 
 	write_lock_irq(&device->cache.lock);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
