From: Dan Jurgens <danielj@mellanox.com>
Subject: [PATCH v3 1/9] IB/core: IB cache enhancements to support Infiniband security
Date: Fri, 29 Jul 2016 16:53:28 +0300
Message-ID: <1469800416-125043-2-git-send-email-danielj@mellanox.com>
References: <1469800416-125043-1-git-send-email-danielj@mellanox.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1469800416-125043-1-git-send-email-danielj@mellanox.com>
Sender: owner-linux-security-module@vger.kernel.org
To: chrisw@sous-sol.org, paul@paul-moore.com, sds@tycho.nsa.gov, eparis@parisplace.org, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org, linux-rdma@vger.kernel.org, yevgenyp@mellanox.com, Daniel Jurgens <danielj@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj@mellanox.com>

Cache the subnet prefix and add a function to access it. Enforcing
security requires frequent queries of the subnet prefix and the pkeys in
the pkey table.

Also removed an unneded pr_warn about memory allocation failure.

Signed-off-by: Daniel Jurgens <danielj@mellanox.com>
Reviewed-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

---
v2:
- In ib_get_cached_subnet_prefix wait to initialize p until after
  validation.  Yuval Shaia

 drivers/infiniband/core/cache.c     | 36 ++++++++++++++++++++++++++++++++++--
 drivers/infiniband/core/core_priv.h |  3 +++
 include/rdma/ib_verbs.h             |  1 +
 3 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 0409667..8a44894 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -932,6 +932,26 @@ int ib_get_cached_pkey(struct ib_device *device,
 }
 EXPORT_SYMBOL(ib_get_cached_pkey);
 
+int ib_get_cached_subnet_prefix(struct ib_device *device,
+				u8                port_num,
+				u64              *sn_pfx)
+{
+	unsigned long flags;
+	int p;
+
+	if (port_num < rdma_start_port(device) ||
+	    port_num > rdma_end_port(device))
+		return -EINVAL;
+
+	p = port_num - rdma_start_port(device);
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
@@ -1108,6 +1128,8 @@ static void ib_cache_update(struct ib_device *device,
 
 	device->cache.lmc_cache[port - rdma_start_port(device)] = tprops->lmc;
 
+	device->cache.subnet_prefix_cache[port - rdma_start_port(device)] =
+							tprops->subnet_prefix;
 	write_unlock_irq(&device->cache.lock);
 
 	kfree(gid_cache);
@@ -1166,9 +1188,18 @@ int ib_cache_setup_one(struct ib_device *device)
 					  (rdma_end_port(device) -
 					   rdma_start_port(device) + 1),
 					  GFP_KERNEL);
+
+	device->cache.subnet_prefix_cache =
+		kcalloc((rdma_end_port(device) - rdma_start_port(device) + 1),
+			sizeof(*device->cache.subnet_prefix_cache),
+			GFP_KERNEL);
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
 
@@ -1211,6 +1242,7 @@ void ib_cache_release_one(struct ib_device *device)
 	gid_table_release_one(device);
 	kfree(device->cache.pkey_cache);
 	kfree(device->cache.lmc_cache);
+	kfree(device->cache.subnet_prefix_cache);
 }
 
 void ib_cache_cleanup_one(struct ib_device *device)
diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 19d499d..ce826e4 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -153,4 +153,7 @@ int ib_nl_handle_set_timeout(struct sk_buff *skb,
 int ib_nl_handle_ip_res_resp(struct sk_buff *skb,
 			     struct netlink_callback *cb);
 
+int ib_get_cached_subnet_prefix(struct ib_device *device,
+				u8                port_num,
+				u64              *sn_pfx);
 #endif /* _CORE_PRIV_H */
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 156673a..205ea09 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1709,6 +1709,7 @@ struct ib_cache {
 	struct ib_pkey_cache  **pkey_cache;
 	struct ib_gid_table   **gid_cache;
 	u8                     *lmc_cache;
+	u64                    *subnet_prefix_cache;
 };
 
 struct ib_dma_mapping_ops {
-- 
1.8.3.1

