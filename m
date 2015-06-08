From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V5 08/12] IB/core: ib_cache routines should use roce_gid_table when needed
Date: Mon,  8 Jun 2015 17:12:11 +0300
Message-ID: <1433772735-22416-9-git-send-email-matanb@mellanox.com>
References: <1433772735-22416-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433772735-22416-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-xCNTGe7nOvUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When a port uses roce_gid_table, the following function
(a) ib_find_cached_gid
(b) ib_get_cached_gid

should query the gid table accordingly.

In order to query it, roce_gid_table is initialized
when needed.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cache.c  | 210 +++++++++++++++++++++++++++++----------
 drivers/infiniband/core/device.c |  17 +++-
 include/rdma/ib_verbs.h          |  21 +++-
 3 files changed, 193 insertions(+), 55 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 871da83..217e639 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -58,64 +58,133 @@ struct ib_update_work {
 	u8                 port_num;
 };
 
-int ib_get_cached_gid(struct ib_device *device,
-		      u8                port_num,
-		      int               index,
-		      union ib_gid     *gid)
+static int __ib_get_cached_gid(struct ib_device *device,
+			       u8                port_num,
+			       int               index,
+			       union ib_gid     *gid)
 {
 	struct ib_gid_cache *cache;
 	unsigned long flags;
-	int ret = 0;
+	int ret = -ENOENT;
 
 	if (port_num < rdma_start_port(device) || port_num > rdma_end_port(device))
 		return -EINVAL;
+	if (!device->cache.gid_cache)
+		return -ENOENT;
 
 	read_lock_irqsave(&device->cache.lock, flags);
 
 	cache = device->cache.gid_cache[port_num - rdma_start_port(device)];
-
-	if (index < 0 || index >= cache->table_len)
-		ret = -EINVAL;
-	else
+	if (cache && index >= 0 && index < cache->table_len) {
 		*gid = cache->table[index];
+		ret = 0;
+	}
 
 	read_unlock_irqrestore(&device->cache.lock, flags);
-
 	return ret;
 }
+
+int ib_get_cached_gid(struct ib_device *device,
+		      u8                port_num,
+		      int               index,
+		      union ib_gid     *gid)
+{
+	if (port_num < rdma_start_port(device) || port_num > rdma_end_port(device))
+		return -EINVAL;
+
+	if (rdma_cap_roce_gid_table(device, port_num))
+		return roce_gid_table_get_gid(device, port_num, index, gid,
+					      NULL);
+
+	if (rdma_protocol_roce(device, port_num))
+		return -EAGAIN;
+
+	return __ib_get_cached_gid(device, port_num, index, gid);
+}
 EXPORT_SYMBOL(ib_get_cached_gid);
 
-int ib_find_cached_gid(struct ib_device   *device,
-		       const union ib_gid *gid,
-		       u8                 *port_num,
-		       u16                *index)
+static int ___ib_find_cached_gid_by_port(struct ib_device *device,
+					 u8               port_num,
+					 const union ib_gid *gid,
+					 u16              *index)
 {
 	struct ib_gid_cache *cache;
+	u8 p = port_num - rdma_start_port(device);
+	int i;
+
+	if (port_num < rdma_start_port(device) || port_num > rdma_end_port(device))
+		return -EINVAL;
+	if (rdma_cap_roce_gid_table(device, port_num))
+		return -EPROTONOSUPPORT;
+	if (!device->cache.gid_cache)
+		return -ENOENT;
+
+	cache = device->cache.gid_cache[p];
+	if (!cache)
+		return -ENOENT;
+
+	for (i = 0; i < cache->table_len; ++i) {
+		if (!memcmp(gid, &cache->table[i], sizeof(*gid))) {
+			if (index)
+				*index = i;
+			return 0;
+		}
+	}
+
+	return -ENOENT;
+}
+
+static int __ib_find_cached_gid(struct ib_device *device,
+				const union ib_gid *gid,
+				u8               *port_num,
+				u16              *index)
+{
 	unsigned long flags;
-	int p, i;
+	u16 found_index;
+	int p;
 	int ret = -ENOENT;
 
-	*port_num = -1;
+	if (port_num)
+		*port_num = -1;
 	if (index)
 		*index = -1;
 
 	read_lock_irqsave(&device->cache.lock, flags);
 
-	for (p = 0; p <= rdma_end_port(device) - rdma_start_port(device); ++p) {
-		cache = device->cache.gid_cache[p];
-		for (i = 0; i < cache->table_len; ++i) {
-			if (!memcmp(gid, &cache->table[i], sizeof *gid)) {
-				*port_num = p + rdma_start_port(device);
-				if (index)
-					*index = i;
-				ret = 0;
-				goto found;
-			}
+	for (p = rdma_start_port(device); p <= rdma_end_port(device); ++p) {
+		if (!___ib_find_cached_gid_by_port(device, p, gid,
+						   &found_index)) {
+			if (port_num)
+				*port_num = p;
+			ret = 0;
+			break;
 		}
 	}
-found:
+
 	read_unlock_irqrestore(&device->cache.lock, flags);
 
+	if (!ret && index)
+		*index = found_index;
+
+	return ret;
+}
+
+int ib_find_cached_gid(struct ib_device *device,
+		       const union ib_gid *gid,
+		       u8               *port_num,
+		       u16              *index)
+{
+	int ret = -ENOENT;
+
+	/* Look for a RoCE device with the specified GID. */
+	if (device->cache.roce_gid_table)
+		ret = roce_gid_table_find_gid(device, gid, NULL,
+					      port_num, index);
+
+	/* If no RoCE devices with the specified GID, look for IB device. */
+	if (ret)
+		ret =  __ib_find_cached_gid(device, gid, port_num, index);
+
 	return ret;
 }
 EXPORT_SYMBOL(ib_find_cached_gid);
@@ -127,22 +196,23 @@ int ib_get_cached_pkey(struct ib_device *device,
 {
 	struct ib_pkey_cache *cache;
 	unsigned long flags;
-	int ret = 0;
+	int ret = -ENOENT;
 
 	if (port_num < rdma_start_port(device) || port_num > rdma_end_port(device))
 		return -EINVAL;
 
+	if (!device->cache.pkey_cache)
+		return -ENOENT;
+
 	read_lock_irqsave(&device->cache.lock, flags);
 
 	cache = device->cache.pkey_cache[port_num - rdma_start_port(device)];
-
-	if (index < 0 || index >= cache->table_len)
-		ret = -EINVAL;
-	else
+	if (cache && index >= 0 && index < cache->table_len) {
 		*pkey = cache->table[index];
+		ret = 0;
+	}
 
 	read_unlock_irqrestore(&device->cache.lock, flags);
-
 	return ret;
 }
 EXPORT_SYMBOL(ib_get_cached_pkey);
@@ -161,9 +231,14 @@ int ib_find_cached_pkey(struct ib_device *device,
 	if (port_num < rdma_start_port(device) || port_num > rdma_end_port(device))
 		return -EINVAL;
 
+	if (!device->cache.pkey_cache)
+		return -ENOENT;
+
 	read_lock_irqsave(&device->cache.lock, flags);
 
 	cache = device->cache.pkey_cache[port_num - rdma_start_port(device)];
+	if (!cache)
+		goto out;
 
 	*index = -1;
 
@@ -182,8 +257,8 @@ int ib_find_cached_pkey(struct ib_device *device,
 		ret = 0;
 	}
 
+out:
 	read_unlock_irqrestore(&device->cache.lock, flags);
-
 	return ret;
 }
 EXPORT_SYMBOL(ib_find_cached_pkey);
@@ -201,9 +276,14 @@ int ib_find_exact_cached_pkey(struct ib_device *device,
 	if (port_num < rdma_start_port(device) || port_num > rdma_end_port(device))
 		return -EINVAL;
 
+	if (!device->cache.pkey_cache)
+		return -ENOENT;
+
 	read_lock_irqsave(&device->cache.lock, flags);
 
 	cache = device->cache.pkey_cache[port_num - rdma_start_port(device)];
+	if (!cache)
+		goto out;
 
 	*index = -1;
 
@@ -213,9 +293,8 @@ int ib_find_exact_cached_pkey(struct ib_device *device,
 			ret = 0;
 			break;
 		}
-
+out:
 	read_unlock_irqrestore(&device->cache.lock, flags);
-
 	return ret;
 }
 EXPORT_SYMBOL(ib_find_exact_cached_pkey);
@@ -225,13 +304,16 @@ int ib_get_cached_lmc(struct ib_device *device,
 		      u8                *lmc)
 {
 	unsigned long flags;
-	int ret = 0;
+	int ret = -ENOENT;
 
 	if (port_num < rdma_start_port(device) || port_num > rdma_end_port(device))
 		return -EINVAL;
 
 	read_lock_irqsave(&device->cache.lock, flags);
-	*lmc = device->cache.lmc_cache[port_num - rdma_start_port(device)];
+	if (device->cache.lmc_cache) {
+		*lmc = device->cache.lmc_cache[port_num - rdma_start_port(device)];
+		ret = 0;
+	}
 	read_unlock_irqrestore(&device->cache.lock, flags);
 
 	return ret;
@@ -243,9 +325,18 @@ static void ib_cache_update(struct ib_device *device,
 {
 	struct ib_port_attr       *tprops = NULL;
 	struct ib_pkey_cache      *pkey_cache = NULL, *old_pkey_cache;
-	struct ib_gid_cache       *gid_cache = NULL, *old_gid_cache;
+	struct ib_gid_cache       *gid_cache = NULL, *old_gid_cache = NULL;
 	int                        i;
 	int                        ret;
+	bool			   use_roce_gid_table =
+					rdma_cap_roce_gid_table(device, port);
+
+	if (port < rdma_start_port(device) || port > rdma_end_port(device))
+		return;
+
+	if (!(device->cache.pkey_cache && device->cache.gid_cache &&
+	      device->cache.lmc_cache))
+		return;
 
 	tprops = kmalloc(sizeof *tprops, GFP_KERNEL);
 	if (!tprops)
@@ -265,12 +356,14 @@ static void ib_cache_update(struct ib_device *device,
 
 	pkey_cache->table_len = tprops->pkey_tbl_len;
 
-	gid_cache = kmalloc(sizeof *gid_cache + tprops->gid_tbl_len *
-			    sizeof *gid_cache->table, GFP_KERNEL);
-	if (!gid_cache)
-		goto err;
+	if (!use_roce_gid_table) {
+		gid_cache = kmalloc(sizeof(*gid_cache) + tprops->gid_tbl_len *
+			    sizeof(*gid_cache->table), GFP_KERNEL);
+		if (!gid_cache)
+			goto err;
 
-	gid_cache->table_len = tprops->gid_tbl_len;
+		gid_cache->table_len = tprops->gid_tbl_len;
+	}
 
 	for (i = 0; i < pkey_cache->table_len; ++i) {
 		ret = ib_query_pkey(device, port, i, pkey_cache->table + i);
@@ -281,22 +374,28 @@ static void ib_cache_update(struct ib_device *device,
 		}
 	}
 
-	for (i = 0; i < gid_cache->table_len; ++i) {
-		ret = ib_query_gid(device, port, i, gid_cache->table + i);
-		if (ret) {
-			printk(KERN_WARNING "ib_query_gid failed (%d) for %s (index %d)\n",
-			       ret, device->name, i);
-			goto err;
+	if (!use_roce_gid_table) {
+		for (i = 0;  i < gid_cache->table_len; ++i) {
+			ret = ib_query_gid(device, port, i,
+					   gid_cache->table + i);
+			if (ret) {
+				printk(KERN_WARNING "ib_query_gid failed (%d) for %s (index %d)\n",
+				       ret, device->name, i);
+				goto err;
+			}
 		}
 	}
 
 	write_lock_irq(&device->cache.lock);
 
 	old_pkey_cache = device->cache.pkey_cache[port - rdma_start_port(device)];
-	old_gid_cache  = device->cache.gid_cache [port - rdma_start_port(device)];
+	if (!use_roce_gid_table)
+		old_gid_cache  =
+			device->cache.gid_cache[port - rdma_start_port(device)];
 
 	device->cache.pkey_cache[port - rdma_start_port(device)] = pkey_cache;
-	device->cache.gid_cache [port - rdma_start_port(device)] = gid_cache;
+	if (!use_roce_gid_table)
+		device->cache.gid_cache[port - rdma_start_port(device)] = gid_cache;
 
 	device->cache.lmc_cache[port - rdma_start_port(device)] = tprops->lmc;
 
@@ -392,12 +491,19 @@ err:
 	kfree(device->cache.pkey_cache);
 	kfree(device->cache.gid_cache);
 	kfree(device->cache.lmc_cache);
+	device->cache.pkey_cache = NULL;
+	device->cache.gid_cache = NULL;
+	device->cache.lmc_cache = NULL;
 }
 
 static void ib_cache_cleanup_one(struct ib_device *device)
 {
 	int p;
 
+	if (!(device->cache.pkey_cache && device->cache.gid_cache &&
+	      device->cache.lmc_cache))
+		return;
+
 	ib_unregister_event_handler(&device->cache.event_handler);
 	flush_workqueue(ib_wq);
 
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 84edb9a..f9c6935 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -40,6 +40,7 @@
 #include <linux/mutex.h>
 #include <rdma/rdma_netlink.h>
 #include <rdma/ib_addr.h>
+#include <rdma/ib_cache.h>
 
 #include "core_priv.h"
 
@@ -593,6 +594,10 @@ EXPORT_SYMBOL(ib_query_port);
 int ib_query_gid(struct ib_device *device,
 		 u8 port_num, int index, union ib_gid *gid)
 {
+	if (rdma_cap_roce_gid_table(device, port_num))
+		return roce_gid_table_get_gid(device, port_num, index, gid,
+					      NULL);
+
 	return device->query_gid(device, port_num, index, gid);
 }
 EXPORT_SYMBOL(ib_query_gid);
@@ -738,18 +743,26 @@ EXPORT_SYMBOL(ib_modify_port);
  *   a specified GID value occurs.
  * @device: The device to query.
  * @gid: The GID value to search for.
+ * @ndev: In RoCE, the net device of the device. Null means ignore.
  * @port_num: The port number of the device where the GID value was found.
  * @index: The index into the GID table where the GID was found.  This
  *   parameter may be NULL.
  */
 int ib_find_gid(struct ib_device *device, union ib_gid *gid,
-		u8 *port_num, u16 *index)
+		struct net_device *ndev, u8 *port_num, u16 *index)
 {
 	union ib_gid tmp_gid;
 	int ret, port, i;
 
+	if (device->cache.roce_gid_table &&
+	    !roce_gid_table_find_gid(device, gid, ndev, port_num, index))
+		return 0;
+
 	for (port = rdma_start_port(device); port <= rdma_end_port(device); ++port) {
-		for (i = 0; i < device->port_immutable[port].gid_tbl_len; ++i) {
+		if (rdma_cap_roce_gid_table(device, port))
+			continue;
+
+		for (i = 0; i < device->port_immutable[port].pkey_tbl_len; ++i) {
 			ret = ib_query_gid(device, port, i, &tmp_gid);
 			if (ret)
 				return ret;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 1f918b0..4806d8b 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2093,6 +2093,25 @@ static inline bool rdma_cap_read_multi_sge(struct ib_device *device,
 	return !(device->port_immutable[port_num].core_cap_flags & RDMA_CORE_CAP_PROT_IWARP);
 }
 
+/**
+ * rdma_cap_roce_gid_table - Check if the port of device uses roce_gid_table
+ * @device: Device to check
+ * @port_num: Port number to check
+ *
+ * RoCE GID table mechanism manages the various GIDs for a device.
+ *
+ * NOTE: if allocating the port's GID table has failed, this call will still
+ * return true, but any RoCE GID table API will fail.
+ *
+ * Return: true if the port uses RoCE GID table mechanism in order to manage
+ * its GIDs.
+ */
+static inline bool rdma_cap_roce_gid_table(const struct ib_device *device,
+					   u8 port_num)
+{
+	return rdma_protocol_roce(device, port_num) && device->cache.roce_gid_table;
+}
+
 int ib_query_gid(struct ib_device *device,
 		 u8 port_num, int index, union ib_gid *gid);
 
@@ -2108,7 +2127,7 @@ int ib_modify_port(struct ib_device *device,
 		   struct ib_port_modify *port_modify);
 
 int ib_find_gid(struct ib_device *device, union ib_gid *gid,
-		u8 *port_num, u16 *index);
+		struct net_device *ndev, u8 *port_num, u16 *index);
 
 int ib_find_pkey(struct ib_device *device,
 		 u8 port_num, u16 pkey, u16 *index);
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
