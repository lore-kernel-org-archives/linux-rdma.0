From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next V2 03/22] IB/core: Add ib_find_exact_cached_pkey() to search for 16-bit pkey match
Date: Fri,  3 Aug 2012 11:40:39 +0300
Message-ID: <1343983258-6268-4-git-send-email-jackm@dev.mellanox.co.il>
References: <1343983258-6268-1-git-send-email-jackm@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343983258-6268-1-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When port pkey table potentially contains both full and partial
membership copies for the same pkey, we need a function to find
the exact (16-bit) pkey index.

This is particularly necessary when the master forwards QP1 MADS
sent by guests.  If the guest has sent the MAD with a limited
membership pkey, we wish to forward the MAD using the same limited
membership pkey.  Since master may have both the limited and
the full member pkeys in its table, we must make sure to retrieve
the limited membership pkey in this case.

This requires the 16-bit pkey lookup function (which includes the
membership bit).

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cache.c |   32 ++++++++++++++++++++++++++++++++
 include/rdma/ib_cache.h         |   16 ++++++++++++++++
 2 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 0f2f2b7..d8a8c83 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -198,6 +198,38 @@ int ib_find_cached_pkey(struct ib_device *device,
 }
 EXPORT_SYMBOL(ib_find_cached_pkey);
 
+int ib_find_exact_cached_pkey(struct ib_device *device,
+			      u8                port_num,
+			      u16               pkey,
+			      u16              *index)
+{
+	struct ib_pkey_cache *cache;
+	unsigned long flags;
+	int i;
+	int ret = -ENOENT;
+
+	if (port_num < start_port(device) || port_num > end_port(device))
+		return -EINVAL;
+
+	read_lock_irqsave(&device->cache.lock, flags);
+
+	cache = device->cache.pkey_cache[port_num - start_port(device)];
+
+	*index = -1;
+
+	for (i = 0; i < cache->table_len; ++i)
+		if (cache->table[i] == pkey) {
+			*index = i;
+			ret = 0;
+			break;
+		}
+
+	read_unlock_irqrestore(&device->cache.lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(ib_find_exact_cached_pkey);
+
 int ib_get_cached_lmc(struct ib_device *device,
 		      u8                port_num,
 		      u8                *lmc)
diff --git a/include/rdma/ib_cache.h b/include/rdma/ib_cache.h
index 00a2b8e..ad9a3c2 100644
--- a/include/rdma/ib_cache.h
+++ b/include/rdma/ib_cache.h
@@ -101,6 +101,22 @@ int ib_find_cached_pkey(struct ib_device    *device,
 			u16                 *index);
 
 /**
+ * ib_find_exact_cached_pkey - Returns the PKey table index where a specified
+ *   PKey value occurs. Comparison uses the FULL 16 bits (incl membership bit)
+ * @device: The device to query.
+ * @port_num: The port number of the device to search for the PKey.
+ * @pkey: The PKey value to search for.
+ * @index: The index into the cached PKey table where the PKey was found.
+ *
+ * ib_find_exact_cached_pkey() searches the specified PKey table in
+ * the local software cache.
+ */
+int ib_find_exact_cached_pkey(struct ib_device    *device,
+			      u8                   port_num,
+			      u16                  pkey,
+			      u16                 *index);
+
+/**
  * ib_get_cached_lmc - Returns a cached lmc table entry
  * @device: The device to query.
  * @port_num: The port number of the device to query.
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
