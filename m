From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/5] IB/core: Create common start/end port functions
Date: Wed, 13 May 2015 20:02:55 -0400
Message-ID: <1431561779-13714-2-git-send-email-ira.weiny@intel.com>
References: <1431561779-13714-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431561779-13714-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Previously start_port and end_port were defined in 2 places, cache.c and
device.c and this prevented their use in other modules.

Make these common functions, change the name to reflect the rdma
name space, and update existing users.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cache.c  | 61 ++++++++++++++++------------------------
 drivers/infiniband/core/device.c | 26 +++++------------
 include/rdma/ib_verbs.h          | 27 ++++++++++++++++++
 3 files changed, 59 insertions(+), 55 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 80f6cf2449fb..08921b34182c 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -58,17 +58,6 @@ struct ib_update_work {
 	u8                 port_num;
 };
 
-static inline int start_port(struct ib_device *device)
-{
-	return (device->node_type == RDMA_NODE_IB_SWITCH) ? 0 : 1;
-}
-
-static inline int end_port(struct ib_device *device)
-{
-	return (device->node_type == RDMA_NODE_IB_SWITCH) ?
-		0 : device->phys_port_cnt;
-}
-
 int ib_get_cached_gid(struct ib_device *device,
 		      u8                port_num,
 		      int               index,
@@ -78,12 +67,12 @@ int ib_get_cached_gid(struct ib_device *device,
 	unsigned long flags;
 	int ret = 0;
 
-	if (port_num < start_port(device) || port_num > end_port(device))
+	if (port_num < rdma_start_port(device) || port_num > rdma_end_port(device))
 		return -EINVAL;
 
 	read_lock_irqsave(&device->cache.lock, flags);
 
-	cache = device->cache.gid_cache[port_num - start_port(device)];
+	cache = device->cache.gid_cache[port_num - rdma_start_port(device)];
 
 	if (index < 0 || index >= cache->table_len)
 		ret = -EINVAL;
@@ -112,11 +101,11 @@ int ib_find_cached_gid(struct ib_device *device,
 
 	read_lock_irqsave(&device->cache.lock, flags);
 
-	for (p = 0; p <= end_port(device) - start_port(device); ++p) {
+	for (p = 0; p <= rdma_end_port(device) - rdma_start_port(device); ++p) {
 		cache = device->cache.gid_cache[p];
 		for (i = 0; i < cache->table_len; ++i) {
 			if (!memcmp(gid, &cache->table[i], sizeof *gid)) {
-				*port_num = p + start_port(device);
+				*port_num = p + rdma_start_port(device);
 				if (index)
 					*index = i;
 				ret = 0;
@@ -140,12 +129,12 @@ int ib_get_cached_pkey(struct ib_device *device,
 	unsigned long flags;
 	int ret = 0;
 
-	if (port_num < start_port(device) || port_num > end_port(device))
+	if (port_num < rdma_start_port(device) || port_num > rdma_end_port(device))
 		return -EINVAL;
 
 	read_lock_irqsave(&device->cache.lock, flags);
 
-	cache = device->cache.pkey_cache[port_num - start_port(device)];
+	cache = device->cache.pkey_cache[port_num - rdma_start_port(device)];
 
 	if (index < 0 || index >= cache->table_len)
 		ret = -EINVAL;
@@ -169,12 +158,12 @@ int ib_find_cached_pkey(struct ib_device *device,
 	int ret = -ENOENT;
 	int partial_ix = -1;
 
-	if (port_num < start_port(device) || port_num > end_port(device))
+	if (port_num < rdma_start_port(device) || port_num > rdma_end_port(device))
 		return -EINVAL;
 
 	read_lock_irqsave(&device->cache.lock, flags);
 
-	cache = device->cache.pkey_cache[port_num - start_port(device)];
+	cache = device->cache.pkey_cache[port_num - rdma_start_port(device)];
 
 	*index = -1;
 
@@ -209,12 +198,12 @@ int ib_find_exact_cached_pkey(struct ib_device *device,
 	int i;
 	int ret = -ENOENT;
 
-	if (port_num < start_port(device) || port_num > end_port(device))
+	if (port_num < rdma_start_port(device) || port_num > rdma_end_port(device))
 		return -EINVAL;
 
 	read_lock_irqsave(&device->cache.lock, flags);
 
-	cache = device->cache.pkey_cache[port_num - start_port(device)];
+	cache = device->cache.pkey_cache[port_num - rdma_start_port(device)];
 
 	*index = -1;
 
@@ -238,11 +227,11 @@ int ib_get_cached_lmc(struct ib_device *device,
 	unsigned long flags;
 	int ret = 0;
 
-	if (port_num < start_port(device) || port_num > end_port(device))
+	if (port_num < rdma_start_port(device) || port_num > rdma_end_port(device))
 		return -EINVAL;
 
 	read_lock_irqsave(&device->cache.lock, flags);
-	*lmc = device->cache.lmc_cache[port_num - start_port(device)];
+	*lmc = device->cache.lmc_cache[port_num - rdma_start_port(device)];
 	read_unlock_irqrestore(&device->cache.lock, flags);
 
 	return ret;
@@ -303,13 +292,13 @@ static void ib_cache_update(struct ib_device *device,
 
 	write_lock_irq(&device->cache.lock);
 
-	old_pkey_cache = device->cache.pkey_cache[port - start_port(device)];
-	old_gid_cache  = device->cache.gid_cache [port - start_port(device)];
+	old_pkey_cache = device->cache.pkey_cache[port - rdma_start_port(device)];
+	old_gid_cache  = device->cache.gid_cache [port - rdma_start_port(device)];
 
-	device->cache.pkey_cache[port - start_port(device)] = pkey_cache;
-	device->cache.gid_cache [port - start_port(device)] = gid_cache;
+	device->cache.pkey_cache[port - rdma_start_port(device)] = pkey_cache;
+	device->cache.gid_cache [port - rdma_start_port(device)] = gid_cache;
 
-	device->cache.lmc_cache[port - start_port(device)] = tprops->lmc;
+	device->cache.lmc_cache[port - rdma_start_port(device)] = tprops->lmc;
 
 	write_unlock_irq(&device->cache.lock);
 
@@ -363,14 +352,14 @@ static void ib_cache_setup_one(struct ib_device *device)
 
 	device->cache.pkey_cache =
 		kmalloc(sizeof *device->cache.pkey_cache *
-			(end_port(device) - start_port(device) + 1), GFP_KERNEL);
+			(rdma_end_port(device) - rdma_start_port(device) + 1), GFP_KERNEL);
 	device->cache.gid_cache =
 		kmalloc(sizeof *device->cache.gid_cache *
-			(end_port(device) - start_port(device) + 1), GFP_KERNEL);
+			(rdma_end_port(device) - rdma_start_port(device) + 1), GFP_KERNEL);
 
 	device->cache.lmc_cache = kmalloc(sizeof *device->cache.lmc_cache *
-					  (end_port(device) -
-					   start_port(device) + 1),
+					  (rdma_end_port(device) -
+					   rdma_start_port(device) + 1),
 					  GFP_KERNEL);
 
 	if (!device->cache.pkey_cache || !device->cache.gid_cache ||
@@ -380,10 +369,10 @@ static void ib_cache_setup_one(struct ib_device *device)
 		goto err;
 	}
 
-	for (p = 0; p <= end_port(device) - start_port(device); ++p) {
+	for (p = 0; p <= rdma_end_port(device) - rdma_start_port(device); ++p) {
 		device->cache.pkey_cache[p] = NULL;
 		device->cache.gid_cache [p] = NULL;
-		ib_cache_update(device, p + start_port(device));
+		ib_cache_update(device, p + rdma_start_port(device));
 	}
 
 	INIT_IB_EVENT_HANDLER(&device->cache.event_handler,
@@ -394,7 +383,7 @@ static void ib_cache_setup_one(struct ib_device *device)
 	return;
 
 err_cache:
-	for (p = 0; p <= end_port(device) - start_port(device); ++p) {
+	for (p = 0; p <= rdma_end_port(device) - rdma_start_port(device); ++p) {
 		kfree(device->cache.pkey_cache[p]);
 		kfree(device->cache.gid_cache[p]);
 	}
@@ -412,7 +401,7 @@ static void ib_cache_cleanup_one(struct ib_device *device)
 	ib_unregister_event_handler(&device->cache.event_handler);
 	flush_workqueue(ib_wq);
 
-	for (p = 0; p <= end_port(device) - start_port(device); ++p) {
+	for (p = 0; p <= rdma_end_port(device) - rdma_start_port(device); ++p) {
 		kfree(device->cache.pkey_cache[p]);
 		kfree(device->cache.gid_cache[p]);
 	}
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index b360350a0b20..0f16dd4d9bb4 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -152,18 +152,6 @@ static int alloc_name(char *name)
 	return 0;
 }
 
-static int start_port(struct ib_device *device)
-{
-	return (device->node_type == RDMA_NODE_IB_SWITCH) ? 0 : 1;
-}
-
-
-static int end_port(struct ib_device *device)
-{
-	return (device->node_type == RDMA_NODE_IB_SWITCH) ?
-		0 : device->phys_port_cnt;
-}
-
 /**
  * ib_alloc_device - allocate an IB device struct
  * @size:size of structure to allocate
@@ -233,7 +221,7 @@ static int read_port_table_lengths(struct ib_device *device)
 	if (!tprops)
 		goto out;
 
-	num_ports = end_port(device) - start_port(device) + 1;
+	num_ports = rdma_end_port(device) - rdma_start_port(device) + 1;
 
 	device->pkey_tbl_len = kmalloc(sizeof *device->pkey_tbl_len * num_ports,
 				       GFP_KERNEL);
@@ -243,7 +231,7 @@ static int read_port_table_lengths(struct ib_device *device)
 		goto err;
 
 	for (port_index = 0; port_index < num_ports; ++port_index) {
-		ret = ib_query_port(device, port_index + start_port(device),
+		ret = ib_query_port(device, port_index + rdma_start_port(device),
 					tprops);
 		if (ret)
 			goto err;
@@ -576,7 +564,7 @@ int ib_query_port(struct ib_device *device,
 		  u8 port_num,
 		  struct ib_port_attr *port_attr)
 {
-	if (port_num < start_port(device) || port_num > end_port(device))
+	if (port_num < rdma_start_port(device) || port_num > rdma_end_port(device))
 		return -EINVAL;
 
 	return device->query_port(device, port_num, port_attr);
@@ -654,7 +642,7 @@ int ib_modify_port(struct ib_device *device,
 	if (!device->modify_port)
 		return -ENOSYS;
 
-	if (port_num < start_port(device) || port_num > end_port(device))
+	if (port_num < rdma_start_port(device) || port_num > rdma_end_port(device))
 		return -EINVAL;
 
 	return device->modify_port(device, port_num, port_modify_mask,
@@ -677,8 +665,8 @@ int ib_find_gid(struct ib_device *device, union ib_gid *gid,
 	union ib_gid tmp_gid;
 	int ret, port, i;
 
-	for (port = start_port(device); port <= end_port(device); ++port) {
-		for (i = 0; i < device->gid_tbl_len[port - start_port(device)]; ++i) {
+	for (port = rdma_start_port(device); port <= rdma_end_port(device); ++port) {
+		for (i = 0; i < device->gid_tbl_len[port - rdma_start_port(device)]; ++i) {
 			ret = ib_query_gid(device, port, i, &tmp_gid);
 			if (ret)
 				return ret;
@@ -710,7 +698,7 @@ int ib_find_pkey(struct ib_device *device,
 	u16 tmp_pkey;
 	int partial_ix = -1;
 
-	for (i = 0; i < device->pkey_tbl_len[port_num - start_port(device)]; ++i) {
+	for (i = 0; i < device->pkey_tbl_len[port_num - rdma_start_port(device)]; ++i) {
 		ret = ib_query_pkey(device, port_num, i, &tmp_pkey);
 		if (ret)
 			return ret;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 8d59479eea4d..2637e7a6674d 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1752,6 +1752,33 @@ int ib_query_port(struct ib_device *device,
 enum rdma_link_layer rdma_port_get_link_layer(struct ib_device *device,
 					       u8 port_num);
 
+/**
+ * rdma_start_port - Return the first valid port number for the device
+ * specified
+ *
+ * @device: Device to be checked
+ *
+ * Return start port number
+ */
+static inline u8 rdma_start_port(const struct ib_device *device)
+{
+	return (device->node_type == RDMA_NODE_IB_SWITCH) ? 0 : 1;
+}
+
+/**
+ * rdma_end_port - Return the last valid port number for the device
+ * specified
+ *
+ * @device: Device to be checked
+ *
+ * Return last port number
+ */
+static inline u8 rdma_end_port(const struct ib_device *device)
+{
+	return (device->node_type == RDMA_NODE_IB_SWITCH) ?
+		0 : device->phys_port_cnt;
+}
+
 static inline bool rdma_protocol_ib(struct ib_device *device, u8 port_num)
 {
 	return device->query_protocol(device, port_num) == RDMA_PROTOCOL_IB;
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
