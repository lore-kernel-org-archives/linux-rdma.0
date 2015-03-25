From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 for-next 10/33] IB/core: Support find sgid index using a filter function
Date: Thu, 26 Mar 2015 02:49:59 +0530
Message-ID: <11e5b149-4065-48c0-99c0-1ca40c494adc@CMEXHTCAS2.ad.emulex.com>
References: <1427318422-12004-1-git-send-email-somnath.kotur@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427318422-12004-1-git-send-email-somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Sometimes a sgid index need to be found based on variable parameters.
For example, when the CM gets a packet from network, it needs to
match a sgid_index that matches the appropriate L2 attributes
of a packet. Extending the cache's API to include Ethernet L2
attribute is problematic, since they may be vastly extended
in the future. As a result, we add a find function that
gets a user filter function and searches the GID table
until a match is found.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/cache.c          | 24 ++++++++++++
 drivers/infiniband/core/core_priv.h      |  9 +++++
 drivers/infiniband/core/roce_gid_cache.c | 66 ++++++++++++++++++++++++++++++++
 include/rdma/ib_cache.h                  | 27 +++++++++++++
 4 files changed, 126 insertions(+)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 882d491..ae86fe8 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -273,6 +273,30 @@ int ib_find_cached_gid_by_port(struct ib_device *device,
 }
 EXPORT_SYMBOL(ib_find_cached_gid_by_port);
 
+int ib_find_gid_by_filter(struct ib_device *device,
+			  union ib_gid *gid,
+			  u8 port_num,
+			  bool (*filter)(const union ib_gid *gid,
+					 const struct ib_gid_attr *,
+					 void *),
+			  void *context, u16 *index)
+{
+	/* Look for a RoCE device with the specified GID. */
+	if (!ib_cache_use_roce_gid_cache(device, port_num))
+		return roce_gid_cache_find_gid_by_filter(device, gid,
+							 port_num, filter,
+							 context, index);
+
+	/* Only RoCE GID cache supports filter function */
+	if (filter)
+		return -ENOSYS;
+
+	/* If no RoCE devices with the specified GID, look for IB device. */
+	return __ib_find_cached_gid_by_port(device, port_num,
+					    gid, index);
+}
+EXPORT_SYMBOL(ib_find_gid_by_filter);
+
 int ib_get_cached_pkey(struct ib_device *device,
 		       u8                port_num,
 		       int               index,
diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index b5bbbdf..949844c 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -84,6 +84,15 @@ int roce_gid_cache_find_gid_by_port(struct ib_device *ib_dev, union ib_gid *gid,
 				    enum ib_gid_type gid_type, u8 port,
 				    struct net *net, int if_index, u16 *index);
 
+int roce_gid_cache_find_gid_by_filter(struct ib_device *ib_dev,
+				      union ib_gid *gid,
+				      u8 port,
+				      bool (*filter)(const union ib_gid *gid,
+						     const struct ib_gid_attr *,
+						     void *),
+				      void *context,
+				      u16 *index);
+
 int roce_gid_cache_is_active(struct ib_device *ib_dev, u8 port);
 
 enum roce_gid_cache_default_mode {
diff --git a/drivers/infiniband/core/roce_gid_cache.c b/drivers/infiniband/core/roce_gid_cache.c
index b6180eb..bd51d97 100644
--- a/drivers/infiniband/core/roce_gid_cache.c
+++ b/drivers/infiniband/core/roce_gid_cache.c
@@ -455,6 +455,72 @@ int roce_gid_cache_find_gid_by_port(struct ib_device *ib_dev, union ib_gid *gid,
 	return -ENOENT;
 }
 
+int roce_gid_cache_find_gid_by_filter(struct ib_device *ib_dev,
+				      union ib_gid *gid,
+				      u8 port,
+				      bool (*filter)(const union ib_gid *,
+						     const struct ib_gid_attr *,
+						     void *),
+				      void *context,
+				      u16 *index)
+{
+	struct ib_roce_gid_cache *cache;
+	unsigned int i;
+	bool found = false;
+
+	if (!ib_dev->cache.roce_gid_cache)
+		return -ENOSYS;
+
+	if (port < start_port(ib_dev) ||
+	    port > start_port(ib_dev) + ib_dev->phys_port_cnt ||
+	    rdma_port_get_link_layer(ib_dev, port) !=
+		IB_LINK_LAYER_ETHERNET)
+		return -ENOSYS;
+
+	cache = ib_dev->cache.roce_gid_cache[port - start_port(ib_dev)];
+
+	if (!cache || !cache->active)
+		return -ENOENT;
+
+	for (i = 0; i < cache->sz; i++) {
+		unsigned int orig_seq;
+		struct ib_gid_attr attr;
+
+		orig_seq = cache->data_vec[i].seq;
+		if (orig_seq == -1)
+			continue;
+		/* Make sure the sequence number we remeber was read
+		 * before the gid cache entry content is read.
+		 */
+		smp_rmb();
+
+		if (memcmp(gid, &cache->data_vec[i].gid, sizeof(*gid)))
+			continue;
+
+		memcpy(&attr, &cache->data_vec[i].attr, sizeof(attr));
+
+		rcu_read_lock();
+
+		/* Make sure we finished reading the attribute */
+		smp_rmb();
+		if (orig_seq == ACCESS_ONCE(cache->data_vec[i].seq))
+			if (!filter || filter(gid, &attr, context))
+				found = true;
+
+		rcu_read_unlock();
+
+		if (found)
+			break;
+	}
+
+	if (!found)
+		return -ENOENT;
+
+	if (index)
+		*index = i;
+	return 0;
+}
+
 static struct ib_roce_gid_cache *alloc_roce_gid_cache(int sz)
 {
 	struct ib_roce_gid_cache *cache =
diff --git a/include/rdma/ib_cache.h b/include/rdma/ib_cache.h
index 36b72bf..5ed728c 100644
--- a/include/rdma/ib_cache.h
+++ b/include/rdma/ib_cache.h
@@ -111,6 +111,33 @@ int ib_find_cached_gid_by_port(struct ib_device *device,
 			       struct net	*net,
 			       int		if_index,
 			       u16              *index);
+
+/**
+ * ib_find_gid_by_filter - Returns the GID table index where a specified
+ * GID value occurs
+ * @device: The device to query.
+ * @gid: The GID value to search for.
+ * @port_num: The port number of the device where the GID value could be
+ *   searched.
+ * @filter: The filter function is executed on any matching GID in the table.
+ *   If the filter function returns true, the corresponding index is returned,
+ *   otherwise, we continue searching the GID table. It's guaranteed that
+ *   while filter is executed, ndev field is valid and the structure won't
+ *   change. filter is executed in an atomic context. filter must be NULL
+ *   when RoCE GID cache isn't supported on the respective device's port.
+ * @index: The index into the cached GID table where the GID was found.  This
+ *   parameter may be NULL.
+ *
+ * ib_find_gid_by_filter() searches for the specified GID value in
+ * the local software cache.
+ */
+int ib_find_gid_by_filter(struct ib_device *device,
+			  union ib_gid *gid,
+			  u8 port_num,
+			  bool (*filter)(const union ib_gid *gid,
+					 const struct ib_gid_attr *,
+					 void *),
+			  void *context, u16 *index);
 /**
  * ib_get_cached_pkey - Returns a cached PKey table entry
  * @device: The device to query.
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
