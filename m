From: Dan Jurgens <danielj@mellanox.com>
Subject: [PATCH v7 1/9] IB/core: IB cache enhancements to support Infiniband security
Date: Fri, 19 May 2017 15:48:51 +0300
Message-ID: <1495198139-69993-2-git-send-email-danielj@mellanox.com>
References: <1495198139-69993-1-git-send-email-danielj@mellanox.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1495198139-69993-1-git-send-email-danielj@mellanox.com>
Sender: owner-linux-security-module@vger.kernel.org
To: chrisw@sous-sol.org, paul@paul-moore.com, sds@tycho.nsa.gov, eparis@parisplace.org, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org, linux-rdma@vger.kernel.org, yevgenyp@mellanox.com, Daniel Jurgens <danielj@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj@mellanox.com>

Cache the subnet prefix and add a function to access it. Enforcing
security requires frequent queries of the subnet prefix and the pkeys in
the pkey table.

Signed-off-by: Daniel Jurgens <danielj@mellanox.com>
Reviewed-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

---
v2:
- In ib_get_cached_subnet_prefix wait to initialize p until after
  validation.  Yuval Shaia

 drivers/infiniband/core/cache.c     | 22 ++++++++++++++++++++++
 drivers/infiniband/core/core_priv.h |  3 +++
 include/rdma/ib_verbs.h             |  1 +
 3 files changed, 26 insertions(+)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index b1371eb..b9c0066 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -911,6 +911,26 @@ int ib_get_cached_pkey(struct ib_device *device,
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
+	*sn_pfx = device->cache.ports[p].subnet_prefix;
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
 	device->cache.ports[port - rdma_start_port(device)].port_state =
 		tprops->state;
 
+	device->cache.ports[port - rdma_start_port(device)].subnet_prefix =
+							tprops->subnet_prefix;
 	write_unlock_irq(&device->cache.lock);
 
 	kfree(gid_cache);
diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index cb7d372..249e3ed 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -176,4 +176,7 @@ int ib_nl_handle_set_timeout(struct sk_buff *skb,
 int ib_nl_handle_ip_res_resp(struct sk_buff *skb,
 			     struct netlink_callback *cb);
 
+int ib_get_cached_subnet_prefix(struct ib_device *device,
+				u8                port_num,
+				u64              *sn_pfx);
 #endif /* _CORE_PRIV_H */
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 99e4423..23486d3 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1841,6 +1841,7 @@ enum ib_mad_result {
 #define IB_DEVICE_NAME_MAX 64
 
 struct ib_port_cache {
+	u64		      subnet_prefix;
 	struct ib_pkey_cache  *pkey;
 	struct ib_gid_table   *gid;
 	u8                     lmc;
-- 
2.7.4

