From: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH v3 08/12] ib/core: IB cache enhancements to support Infiniband security
Date: Tue, 19 Apr 2016 22:51:25 +0300
Message-ID: <1461095489-18732-9-git-send-email-danielj@mellanox.com>
References: <1461095489-18732-1-git-send-email-danielj@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461095489-18732-1-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Cache the subnet prefix and add a function to access it. Enforcing
security requires frequent queries of the subnet prefix and the pkeys in
the pkey table.

Also removed an unneded pr_warn about memory allocation failure.

Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
v2: Added to series.

v3:
1. Removed unneccesary pr_warn after mem alloc failure. Leon
---
 drivers/infiniband/core/cache.c     |   35 +++++++++++++++++++++++++++++++++--
 drivers/infiniband/core/core_priv.h |    3 +++
 include/rdma/ib_verbs.h             |    1 +
 3 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index cb00d59..f1d602f 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -925,6 +925,25 @@ int ib_get_cached_pkey(struct ib_device *device,
 }
 EXPORT_SYMBOL(ib_get_cached_pkey);
 
+int ib_get_cached_subnet_prefix(struct ib_device *device,
+				u8                port_num,
+				u64              *sn_pfx)
+{
+	unsigned long flags;
+	int p = port_num - rdma_start_port(device);
+
+	if (port_num < rdma_start_port(device) ||
+	    port_num > rdma_end_port(device))
+		return -EINVAL;
+
+	read_lock_irqsave(&device->cache.lock, flags);
+	*sn_pfx = device->cache.subnet_prefix_cache[p];
+	read_unlock_irqrestore(&device->cache.lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL(ib_get_cached_subnet_prefix);
+
 int ib_find_cached_pkey(struct ib_device *device,
 			u8                port_num,
 			u16               pkey,
@@ -1101,6 +1120,8 @@ static void ib_cache_update(struct ib_device *device,
 
 	device->cache.lmc_cache[port - rdma_start_port(device)] = tprops->lmc;
 
+	device->cache.subnet_prefix_cache[port - rdma_start_port(device)] =
+							tprops->subnet_prefix;
 	write_unlock_irq(&device->cache.lock);
 
 	kfree(gid_cache);
@@ -1159,9 +1180,18 @@ int ib_cache_setup_one(struct ib_device *device)
 					  (rdma_end_port(device) -
 					   rdma_start_port(device) + 1),
 					  GFP_KERNEL);
+
+	device->cache.subnet_prefix_cache = kcalloc((rdma_end_port(device) -
+						     rdma_start_port(device) + 1),
+						    sizeof(*device->cache.subnet_prefix_cache),
+						    GFP_KERNEL);
+
 	if (!device->cache.pkey_cache ||
-	    !device->cache.lmc_cache) {
-		pr_warn("Couldn't allocate cache for %s\n", device->name);
+	    !device->cache.lmc_cache ||
+	    !device->cache.subnet_prefix_cache) {
+		kfree(device->cache.pkey_cache);
+		kfree(device->cache.lmc_cache);
+		kfree(device->cache.subnet_prefix_cache);
 		return -ENOMEM;
 	}
 
@@ -1204,6 +1234,7 @@ void ib_cache_release_one(struct ib_device *device)
 	gid_table_release_one(device);
 	kfree(device->cache.pkey_cache);
 	kfree(device->cache.lmc_cache);
+	kfree(device->cache.subnet_prefix_cache);
 }
 
 void ib_cache_cleanup_one(struct ib_device *device)
diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index eab3221..722b866 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -137,4 +137,7 @@ static inline bool rdma_is_upper_dev_rcu(struct net_device *dev,
 	return _upper == upper;
 }
 
+int ib_get_cached_subnet_prefix(struct ib_device *device,
+				u8                port_num,
+				u64              *sn_pfx);
 #endif /* _CORE_PRIV_H */
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 66d37b8..870c5ac 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1616,6 +1616,7 @@ struct ib_cache {
 	struct ib_pkey_cache  **pkey_cache;
 	struct ib_gid_table   **gid_cache;
 	u8                     *lmc_cache;
+	u64                    *subnet_prefix_cache;
 };
 
 struct ib_dma_mapping_ops {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
