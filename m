From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v4 for-next 09/14] IB/core: Support find sgid index using a filter function
Date: Tue, 19 May 2015 17:27:12 +0300
Message-ID: <1432045637-9090-10-git-send-email-matanb@mellanox.com>
References: <1432045637-9090-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432045637-9090-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sometimes a sgid index need to be found based on variable parameters.
For example, when the CM gets a packet from network, it needs to
match a sgid_index that matches the appropriate L2 attributes
of a packet. Extending the cache's API to include Ethernet L2
attribute is problematic, since they may be vastly extended
in the future. As a result, we add a find function that
gets a user filter function and searches the GID table
until a match is found.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cache.c          | 24 +++++++++++++
 drivers/infiniband/core/core_priv.h      |  9 +++++
 drivers/infiniband/core/roce_gid_table.c | 61 ++++++++++++++++++++++++++++++++
 include/rdma/ib_cache.h                  | 27 ++++++++++++++
 4 files changed, 121 insertions(+)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 5af1e6a..020006e 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -280,6 +280,30 @@ int ib_find_cached_gid_by_port(struct ib_device *device,
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
+	if (!ib_cache_use_roce_gid_table(device, port_num))
+		return roce_gid_table_find_gid_by_filter(device, gid,
+							 port_num, filter,
+							 context, index);
+
+	/* Only RoCE GID table supports filter function */
+	if (filter)
+		return -EPROTONOSUPPORT;
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
index 9eebd09..de795ef 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -84,6 +84,15 @@ int roce_gid_table_find_gid_by_port(struct ib_device *ib_dev, union ib_gid *gid,
 				    enum ib_gid_type gid_type, u8 port,
 				    struct net *net, int if_index, u16 *index);
 
+int roce_gid_table_find_gid_by_filter(struct ib_device *ib_dev,
+				      union ib_gid *gid,
+				      u8 port,
+				      bool (*filter)(const union ib_gid *gid,
+						     const struct ib_gid_attr *,
+						     void *),
+				      void *context,
+				      u16 *index);
+
 enum roce_gid_table_default_mode {
 	ROCE_GID_TABLE_DEFAULT_MODE_SET,
 	ROCE_GID_TABLE_DEFAULT_MODE_DELETE
diff --git a/drivers/infiniband/core/roce_gid_table.c b/drivers/infiniband/core/roce_gid_table.c
index ecaaaf4..db6b1df 100644
--- a/drivers/infiniband/core/roce_gid_table.c
+++ b/drivers/infiniband/core/roce_gid_table.c
@@ -450,6 +450,67 @@ int roce_gid_table_find_gid_by_port(struct ib_device *ib_dev, union ib_gid *gid,
 	return -ENOENT;
 }
 
+int roce_gid_table_find_gid_by_filter(struct ib_device *ib_dev,
+				      union ib_gid *gid,
+				      u8 port,
+				      bool (*filter)(const union ib_gid *,
+						     const struct ib_gid_attr *,
+						     void *),
+				      void *context,
+				      u16 *index)
+{
+	struct ib_roce_gid_table **ports_table =
+		READ_ONCE(ib_dev->cache.roce_gid_table);
+	struct ib_roce_gid_table *table;
+	unsigned int i;
+	bool found = false;
+
+	/* make sure we read the ports_table */
+	smp_rmb();
+
+	if (!ports_table)
+		return -EOPNOTSUPP;
+
+	if (port < start_port(ib_dev) ||
+	    port > start_port(ib_dev) + ib_dev->phys_port_cnt ||
+	    rdma_port_get_link_layer(ib_dev, port) !=
+		IB_LINK_LAYER_ETHERNET)
+		return -EPROTONOSUPPORT;
+
+	table = ports_table[port - start_port(ib_dev)];
+
+	if (!table)
+		return -ENOENT;
+
+	for (i = 0; i < table->sz; i++) {
+		struct ib_gid_attr attr;
+		unsigned int orig_seq = read_seqcount_begin(&table->data_vec[i].seq);
+
+		if (memcmp(gid, &table->data_vec[i].gid, sizeof(*gid)))
+			continue;
+
+		memcpy(&attr, &table->data_vec[i].attr, sizeof(attr));
+
+		rcu_read_lock();
+
+		if (!read_seqcount_retry(&table->data_vec[i].seq, orig_seq))
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
 static struct ib_roce_gid_table *alloc_roce_gid_table(int sz)
 {
 	unsigned int i;
diff --git a/include/rdma/ib_cache.h b/include/rdma/ib_cache.h
index 96009ca..347c28b 100644
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
+ *   when RoCE GID table isn't supported on the respective device's port.
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
