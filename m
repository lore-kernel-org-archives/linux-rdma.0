From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V7 05/10] IB/core: Add RoCE GID table management
Date: Thu, 30 Jul 2015 18:33:26 +0300
Message-ID: <1438270411-17648-6-git-send-email-matanb@mellanox.com>
References: <1438270411-17648-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438270411-17648-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

RoCE GIDs are based on IP addresses configured on Ethernet net-devices
which relate to the RDMA (RoCE) device port.

Currently, each of the low-level drivers that support RoCE (ocrdma,
mlx4) manages its own RoCE port GID table. As there's nothing which is
essentially vendor specific, we generalize that, and enhance the RDMA
core GID cache to do this job.

In order to populate the GID table, we listen for events:

(a) netdev up/down/change_addr events - if a netdev is built onto
    our RoCE device, we need to add/delete its IPs. This involves
    adding all GIDs related to this ndev, add default GIDs, etc.

(b) inet events - add new GIDs (according to the IP addresses)
    to the table.

For programming the port RoCE GID table, providers must implement
the add_gid and del_gid callbacks.

RoCE GID management requires us to state the associated net_device
alongside the GID. This information is necessary in order to manage
the GID table. For example, when a net_device is removed, its
associated GIDs need to be removed as well.

RoCE mandates generating a default GID for each port, based on the
related net-device's IPv6 link local. In contrast to the GID based on
the regular IPv6 link-local (as we generate GID per IP address),
the default GID is also available when the net device is down (in
order to support loopback).

Locking is done as follows:
The patch modify the GID table code both for new RoCE drivers
implementing the add_gid/del_gid callbacks and for current RoCE and
IB drivers that do not. The flows for updating the table are
different, so the locking requirements are too.

While updating RoCE GID table, protection against multiple writers is
achieved via mutex_lock(&table->lock). Since writing to a table
requires us to find an entry (possible a free entry) in the table and
then modify it, this mutex protects both the find_gid and write_gid
ensuring the atomicity of the action.
Each entry in the GID cache is protected by rwlock. In RoCE, writing
(usually results from netdev notifier) involves invoking the vendor's
add_gid and del_gid callbacks, which could sleep.
Therefore, an invalid flag is added for each entry. Updates for RoCE are
done via a workqueue, thus sleeping is permitted.

In IB, updates are done in write_lock_irq(&device->cache.lock), thus
write_gid isn't allowed to sleep and add_gid/del_gid are not called.

When passing net-device into/out-of the GID cache, the device
is always passed held (dev_hold).

The code uses a single work item for updating all RDMA devices,
following a netdev or inet notifier.

The patch moves the cache from being a client (which was incorrect,
as the cache is part of the IB infrastructure) to being explicitly
initialized/freed when a device is registered/removed.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/Makefile        |   3 +-
 drivers/infiniband/core/cache.c         | 703 ++++++++++++++++++++++++++++----
 drivers/infiniband/core/core_priv.h     |  50 ++-
 drivers/infiniband/core/device.c        |  95 ++++-
 drivers/infiniband/core/roce_gid_mgmt.c | 465 +++++++++++++++++++++
 drivers/infiniband/core/sysfs.c         |   1 +
 include/rdma/ib_verbs.h                 |  66 ++-
 7 files changed, 1286 insertions(+), 97 deletions(-)
 create mode 100644 drivers/infiniband/core/roce_gid_mgmt.c

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index acf7367..d43a899 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -9,7 +9,8 @@ obj-$(CONFIG_INFINIBAND_USER_ACCESS) +=	ib_uverbs.o ib_ucm.o \
 					$(user_access-y)
 
 ib_core-y :=			packer.o ud_header.o verbs.o sysfs.o \
-				device.o fmr_pool.o cache.o netlink.o
+				device.o fmr_pool.o cache.o netlink.o \
+				roce_gid_mgmt.o
 ib_core-$(CONFIG_INFINIBAND_USER_MEM) += umem.o
 ib_core-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) += umem_odp.o umem_rbtree.o
 
diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 871da83..9b4f16b 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -37,6 +37,8 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
+#include <linux/netdevice.h>
+#include <net/addrconf.h>
 
 #include <rdma/ib_cache.h>
 
@@ -47,77 +49,596 @@ struct ib_pkey_cache {
 	u16             table[0];
 };
 
-struct ib_gid_cache {
-	int             table_len;
-	union ib_gid    table[0];
-};
-
 struct ib_update_work {
 	struct work_struct work;
 	struct ib_device  *device;
 	u8                 port_num;
 };
 
-int ib_get_cached_gid(struct ib_device *device,
-		      u8                port_num,
-		      int               index,
-		      union ib_gid     *gid)
+static union ib_gid zgid;
+
+static const struct ib_gid_attr zattr;
+
+enum gid_attr_find_mask {
+	GID_ATTR_FIND_MASK_GID          = 1UL << 0,
+	GID_ATTR_FIND_MASK_NETDEV	= 1UL << 1,
+	GID_ATTR_FIND_MASK_DEFAULT	= 1UL << 2,
+};
+
+enum gid_table_entry_props {
+	GID_TABLE_ENTRY_INVALID		= 1UL << 0,
+	GID_TABLE_ENTRY_DEFAULT		= 1UL << 1,
+};
+
+enum gid_table_write_action {
+	GID_TABLE_WRITE_ACTION_ADD,
+	GID_TABLE_WRITE_ACTION_DEL,
+	/* MODIFY only updates the GID table. Currently only used by
+	 * ib_cache_update.
+	 */
+	GID_TABLE_WRITE_ACTION_MODIFY
+};
+
+struct ib_gid_table_entry {
+	/* This lock protects an entry from being
+	 * read and written simultaneously.
+	 */
+	rwlock_t	    lock;
+	unsigned long	    props;
+	union ib_gid        gid;
+	struct ib_gid_attr  attr;
+	void		   *context;
+};
+
+struct ib_gid_table {
+	int                  sz;
+	/* In RoCE, adding a GID to the table requires:
+	 * (a) Find if this GID is already exists.
+	 * (b) Find a free space.
+	 * (c) Write the new GID
+	 *
+	 * Delete requires different set of operations:
+	 * (a) Find the GID
+	 * (b) Delete it.
+	 *
+	 * Add/delete should be carried out atomically.
+	 * This is done by locking this mutex from multiple
+	 * writers. We don't need this lock for IB, as the MAD
+	 * layer replaces all entries. All data_vec entries
+	 * are locked by this lock.
+	 **/
+	struct mutex         lock;
+	struct ib_gid_table_entry *data_vec;
+};
+
+static int write_gid(struct ib_device *ib_dev, u8 port,
+		     struct ib_gid_table *table, int ix,
+		     const union ib_gid *gid,
+		     const struct ib_gid_attr *attr,
+		     enum gid_table_write_action action,
+		     bool  default_gid)
 {
-	struct ib_gid_cache *cache;
-	unsigned long flags;
 	int ret = 0;
+	struct net_device *old_net_dev;
+
+	/* in rdma_cap_roce_gid_table, this funciton should be protected by a
+	 * sleep-able lock.
+	 */
+	write_lock(&table->data_vec[ix].lock);
+
+	if (rdma_cap_roce_gid_table(ib_dev, port)) {
+		table->data_vec[ix].props |= GID_TABLE_ENTRY_INVALID;
+		write_unlock(&table->data_vec[ix].lock);
+		/* GID_TABLE_WRITE_ACTION_MODIFY currently isn't supported by
+		 * RoCE providers and thus only updates the cache.
+		 */
+		if (action == GID_TABLE_WRITE_ACTION_ADD)
+			ret = ib_dev->add_gid(ib_dev, port, ix, gid, attr,
+					      &table->data_vec[ix].context);
+		else if (action == GID_TABLE_WRITE_ACTION_DEL)
+			ret = ib_dev->del_gid(ib_dev, port, ix,
+					      &table->data_vec[ix].context);
+		write_lock(&table->data_vec[ix].lock);
+	}
 
-	if (port_num < rdma_start_port(device) || port_num > rdma_end_port(device))
-		return -EINVAL;
+	old_net_dev = table->data_vec[ix].attr.ndev;
+	if (old_net_dev && old_net_dev != attr->ndev)
+		dev_put(old_net_dev);
+	/* if modify_gid failed, just delete the old gid */
+	if (ret || action == GID_TABLE_WRITE_ACTION_DEL) {
+		gid = &zgid;
+		attr = &zattr;
+		table->data_vec[ix].context = NULL;
+	}
+	if (default_gid)
+		table->data_vec[ix].props |= GID_TABLE_ENTRY_DEFAULT;
+	memcpy(&table->data_vec[ix].gid, gid, sizeof(*gid));
+	memcpy(&table->data_vec[ix].attr, attr, sizeof(*attr));
+	if (table->data_vec[ix].attr.ndev &&
+	    table->data_vec[ix].attr.ndev != old_net_dev)
+		dev_hold(table->data_vec[ix].attr.ndev);
 
-	read_lock_irqsave(&device->cache.lock, flags);
+	table->data_vec[ix].props &= ~GID_TABLE_ENTRY_INVALID;
 
-	cache = device->cache.gid_cache[port_num - rdma_start_port(device)];
+	write_unlock(&table->data_vec[ix].lock);
 
-	if (index < 0 || index >= cache->table_len)
-		ret = -EINVAL;
-	else
-		*gid = cache->table[index];
+	if (!ret && rdma_cap_roce_gid_table(ib_dev, port)) {
+		struct ib_event event;
 
-	read_unlock_irqrestore(&device->cache.lock, flags);
+		event.device		= ib_dev;
+		event.element.port_num	= port;
+		event.event		= IB_EVENT_GID_CHANGE;
 
+		ib_dispatch_event(&event);
+	}
 	return ret;
 }
-EXPORT_SYMBOL(ib_get_cached_gid);
 
-int ib_find_cached_gid(struct ib_device   *device,
-		       const union ib_gid *gid,
-		       u8                 *port_num,
-		       u16                *index)
+static int add_gid(struct ib_device *ib_dev, u8 port,
+		   struct ib_gid_table *table, int ix,
+		   const union ib_gid *gid,
+		   const struct ib_gid_attr *attr,
+		   bool  default_gid) {
+	return write_gid(ib_dev, port, table, ix, gid, attr,
+			 GID_TABLE_WRITE_ACTION_ADD, default_gid);
+}
+
+static int modify_gid(struct ib_device *ib_dev, u8 port,
+		      struct ib_gid_table *table, int ix,
+		      const union ib_gid *gid,
+		      const struct ib_gid_attr *attr,
+		      bool  default_gid) {
+	return write_gid(ib_dev, port, table, ix, gid, attr,
+			 GID_TABLE_WRITE_ACTION_MODIFY, default_gid);
+}
+
+static int del_gid(struct ib_device *ib_dev, u8 port,
+		   struct ib_gid_table *table, int ix,
+		   bool  default_gid) {
+	return write_gid(ib_dev, port, table, ix, &zgid, &zattr,
+			 GID_TABLE_WRITE_ACTION_DEL, default_gid);
+}
+
+static int find_gid(struct ib_gid_table *table, const union ib_gid *gid,
+		    const struct ib_gid_attr *val, bool default_gid,
+		    unsigned long mask)
 {
-	struct ib_gid_cache *cache;
-	unsigned long flags;
-	int p, i;
-	int ret = -ENOENT;
+	int i;
 
-	*port_num = -1;
-	if (index)
-		*index = -1;
+	for (i = 0; i < table->sz; i++) {
+		unsigned long flags;
+		struct ib_gid_attr *attr = &table->data_vec[i].attr;
 
-	read_lock_irqsave(&device->cache.lock, flags);
+		read_lock_irqsave(&table->data_vec[i].lock, flags);
 
-	for (p = 0; p <= rdma_end_port(device) - rdma_start_port(device); ++p) {
-		cache = device->cache.gid_cache[p];
-		for (i = 0; i < cache->table_len; ++i) {
-			if (!memcmp(gid, &cache->table[i], sizeof *gid)) {
-				*port_num = p + rdma_start_port(device);
-				if (index)
-					*index = i;
-				ret = 0;
-				goto found;
+		if (table->data_vec[i].props & GID_TABLE_ENTRY_INVALID)
+			goto next;
+
+		if (mask & GID_ATTR_FIND_MASK_GID &&
+		    memcmp(gid, &table->data_vec[i].gid, sizeof(*gid)))
+			goto next;
+
+		if (mask & GID_ATTR_FIND_MASK_NETDEV &&
+		    attr->ndev != val->ndev)
+			goto next;
+
+		if (mask & GID_ATTR_FIND_MASK_DEFAULT &&
+		    !!(table->data_vec[i].props & GID_TABLE_ENTRY_DEFAULT) !=
+		    default_gid)
+			goto next;
+
+		read_unlock_irqrestore(&table->data_vec[i].lock, flags);
+		return i;
+next:
+		read_unlock_irqrestore(&table->data_vec[i].lock, flags);
+	}
+
+	return -1;
+}
+
+static void make_default_gid(struct  net_device *dev, union ib_gid *gid)
+{
+	gid->global.subnet_prefix = cpu_to_be64(0xfe80000000000000LL);
+	addrconf_ifid_eui48(&gid->raw[8], dev);
+}
+
+int ib_cache_gid_add(struct ib_device *ib_dev, u8 port,
+		     union ib_gid *gid, struct ib_gid_attr *attr)
+{
+	struct ib_gid_table **ports_table = ib_dev->cache.gid_cache;
+	struct ib_gid_table *table;
+	int ix;
+	int ret = 0;
+	struct net_device *idev;
+
+	table = ports_table[port - rdma_start_port(ib_dev)];
+
+	if (!memcmp(gid, &zgid, sizeof(*gid)))
+		return -EINVAL;
+
+	if (ib_dev->get_netdev) {
+		idev = ib_dev->get_netdev(ib_dev, port);
+		if (idev && attr->ndev != idev) {
+			union ib_gid default_gid;
+
+			/* Adding default GIDs in not permitted */
+			make_default_gid(idev, &default_gid);
+			if (!memcmp(gid, &default_gid, sizeof(*gid))) {
+				dev_put(idev);
+				return -EPERM;
 			}
 		}
+		if (idev)
+			dev_put(idev);
 	}
-found:
-	read_unlock_irqrestore(&device->cache.lock, flags);
 
+	mutex_lock(&table->lock);
+
+	ix = find_gid(table, gid, attr, false, GID_ATTR_FIND_MASK_GID |
+		      GID_ATTR_FIND_MASK_NETDEV);
+	if (ix >= 0)
+		goto out_unlock;
+
+	ix = find_gid(table, &zgid, NULL, false, GID_ATTR_FIND_MASK_GID |
+		      GID_ATTR_FIND_MASK_DEFAULT);
+	if (ix < 0) {
+		ret = -ENOSPC;
+		goto out_unlock;
+	}
+
+	add_gid(ib_dev, port, table, ix, gid, attr, false);
+
+out_unlock:
+	mutex_unlock(&table->lock);
 	return ret;
 }
+
+int ib_cache_gid_del(struct ib_device *ib_dev, u8 port,
+		     union ib_gid *gid, struct ib_gid_attr *attr)
+{
+	struct ib_gid_table **ports_table = ib_dev->cache.gid_cache;
+	struct ib_gid_table *table;
+	int ix;
+
+	table = ports_table[port - rdma_start_port(ib_dev)];
+
+	mutex_lock(&table->lock);
+
+	ix = find_gid(table, gid, attr, false,
+		      GID_ATTR_FIND_MASK_GID	  |
+		      GID_ATTR_FIND_MASK_NETDEV	  |
+		      GID_ATTR_FIND_MASK_DEFAULT);
+	if (ix < 0)
+		goto out_unlock;
+
+	del_gid(ib_dev, port, table, ix, false);
+
+out_unlock:
+	mutex_unlock(&table->lock);
+	return 0;
+}
+
+int ib_cache_gid_del_all_netdev_gids(struct ib_device *ib_dev, u8 port,
+				     struct net_device *ndev)
+{
+	struct ib_gid_table **ports_table = ib_dev->cache.gid_cache;
+	struct ib_gid_table *table;
+	int ix;
+
+	table  = ports_table[port - rdma_start_port(ib_dev)];
+
+	mutex_lock(&table->lock);
+
+	for (ix = 0; ix < table->sz; ix++)
+		if (table->data_vec[ix].attr.ndev == ndev)
+			del_gid(ib_dev, port, table, ix, false);
+
+	mutex_unlock(&table->lock);
+	return 0;
+}
+
+static int __ib_cache_gid_get(struct ib_device *ib_dev, u8 port, int index,
+			      union ib_gid *gid, struct ib_gid_attr *attr)
+{
+	struct ib_gid_table **ports_table = ib_dev->cache.gid_cache;
+	struct ib_gid_table *table;
+	unsigned long flags;
+
+	table = ports_table[port - rdma_start_port(ib_dev)];
+
+	if (index < 0 || index >= table->sz)
+		return -EINVAL;
+
+	read_lock_irqsave(&table->data_vec[index].lock, flags);
+	if (table->data_vec[index].props & GID_TABLE_ENTRY_INVALID) {
+		read_unlock_irqrestore(&table->data_vec[index].lock, flags);
+		return -EAGAIN;
+	}
+
+	memcpy(gid, &table->data_vec[index].gid, sizeof(*gid));
+	if (attr) {
+		memcpy(attr, &table->data_vec[index].attr, sizeof(*attr));
+		if (attr->ndev)
+			dev_hold(attr->ndev);
+	}
+
+	read_unlock_irqrestore(&table->data_vec[index].lock, flags);
+	return 0;
+}
+
+static int _ib_cache_gid_table_find(struct ib_device *ib_dev,
+				    const union ib_gid *gid,
+				    const struct ib_gid_attr *val,
+				    unsigned long mask,
+				    u8 *port, u16 *index)
+{
+	struct ib_gid_table **ports_table = ib_dev->cache.gid_cache;
+	struct ib_gid_table *table;
+	u8 p;
+	int local_index;
+
+	for (p = 0; p < ib_dev->phys_port_cnt; p++) {
+		table = ports_table[p];
+		local_index = find_gid(table, gid, val, false, mask);
+		if (local_index >= 0) {
+			if (index)
+				*index = local_index;
+			if (port)
+				*port = p + rdma_start_port(ib_dev);
+			return 0;
+		}
+	}
+
+	return -ENOENT;
+}
+
+static int ib_cache_gid_find(struct ib_device *ib_dev,
+			     const union ib_gid *gid,
+			     struct net_device *ndev, u8 *port,
+			     u16 *index)
+{
+	unsigned long mask = GID_ATTR_FIND_MASK_GID;
+	struct ib_gid_attr gid_attr_val = {.ndev = ndev};
+
+	if (ndev)
+		mask |= GID_ATTR_FIND_MASK_NETDEV;
+
+	return _ib_cache_gid_table_find(ib_dev, gid, &gid_attr_val,
+					mask, port, index);
+}
+
+int ib_cache_gid_find_by_port(struct ib_device *ib_dev,
+			      const union ib_gid *gid,
+			      u8 port, struct net_device *ndev,
+			      u16 *index)
+{
+	int local_index;
+	struct ib_gid_table **ports_table = ib_dev->cache.gid_cache;
+	struct ib_gid_table *table;
+	unsigned long mask = GID_ATTR_FIND_MASK_GID;
+	struct ib_gid_attr val = {.ndev = ndev};
+
+	if (port < rdma_start_port(ib_dev) ||
+	    port > rdma_end_port(ib_dev))
+		return -ENOENT;
+
+	table = ports_table[port - rdma_start_port(ib_dev)];
+
+	if (ndev)
+		mask |= GID_ATTR_FIND_MASK_NETDEV;
+
+	local_index = find_gid(table, gid, &val, false, mask);
+	if (local_index >= 0) {
+		if (index)
+			*index = local_index;
+		return 0;
+	}
+
+	return -ENOENT;
+}
+
+static struct ib_gid_table *alloc_gid_table(int sz)
+{
+	unsigned int i;
+	struct ib_gid_table *table =
+		kzalloc(sizeof(struct ib_gid_table), GFP_KERNEL);
+	if (!table)
+		return NULL;
+
+	table->data_vec = kcalloc(sz, sizeof(*table->data_vec), GFP_KERNEL);
+	if (!table->data_vec)
+		goto err_free_table;
+
+	mutex_init(&table->lock);
+
+	table->sz = sz;
+
+	for (i = 0; i < sz; i++)
+		rwlock_init(&table->data_vec[i].lock);
+
+	return table;
+
+err_free_table:
+	kfree(table);
+	return NULL;
+}
+
+static void free_gid_table(struct ib_device *ib_dev, u8 port,
+			   struct ib_gid_table *table)
+{
+	int i;
+
+	if (!table)
+		return;
+
+	for (i = 0; i < table->sz; ++i) {
+		if (memcmp(&table->data_vec[i].gid, &zgid,
+			   sizeof(table->data_vec[i].gid)))
+			del_gid(ib_dev, port, table, i,
+				table->data_vec[i].props &
+				GID_ATTR_FIND_MASK_DEFAULT);
+	}
+	kfree(table->data_vec);
+	kfree(table);
+}
+
+void ib_cache_gid_set_default_gid(struct ib_device *ib_dev, u8 port,
+				  struct net_device *ndev,
+				  enum ib_cache_gid_default_mode mode)
+{
+	struct ib_gid_table **ports_table = ib_dev->cache.gid_cache;
+	union ib_gid gid;
+	struct ib_gid_attr gid_attr;
+	struct ib_gid_table *table;
+	int ix;
+	union ib_gid current_gid;
+	struct ib_gid_attr current_gid_attr = {};
+
+	table  = ports_table[port - rdma_start_port(ib_dev)];
+
+	make_default_gid(ndev, &gid);
+	memset(&gid_attr, 0, sizeof(gid_attr));
+	gid_attr.ndev = ndev;
+
+	ix = find_gid(table, NULL, NULL, true, GID_ATTR_FIND_MASK_DEFAULT);
+
+	/* Coudn't find default GID location */
+	WARN_ON(ix < 0);
+
+	mutex_lock(&table->lock);
+	if (!__ib_cache_gid_get(ib_dev, port, ix,
+				&current_gid, &current_gid_attr) &&
+	    mode == IB_CACHE_GID_DEFAULT_MODE_SET &&
+	    !memcmp(&gid, &current_gid, sizeof(gid)) &&
+	    !memcmp(&gid_attr, &current_gid_attr, sizeof(gid_attr)))
+		goto unlock;
+
+	if ((memcmp(&current_gid, &zgid, sizeof(current_gid)) ||
+	     memcmp(&current_gid_attr, &zattr,
+		    sizeof(current_gid_attr))) &&
+	    del_gid(ib_dev, port, table, ix, true)) {
+		pr_warn("ib_cache_gid: can't delete index %d for default gid %pI6\n",
+			ix, gid.raw);
+		goto unlock;
+	}
+
+	if (mode == IB_CACHE_GID_DEFAULT_MODE_SET)
+		if (add_gid(ib_dev, port, table, ix, &gid, &gid_attr, true))
+			pr_warn("ib_cache_gid: unable to add default gid %pI6\n",
+				gid.raw);
+
+unlock:
+	if (current_gid_attr.ndev)
+		dev_put(current_gid_attr.ndev);
+	mutex_unlock(&table->lock);
+}
+
+static int gid_table_reserve_default(struct ib_device *ib_dev, u8 port,
+				     struct ib_gid_table *table)
+{
+	if (rdma_protocol_roce(ib_dev, port)) {
+		struct ib_gid_table_entry *entry = &table->data_vec[0];
+
+		entry->props |= GID_TABLE_ENTRY_DEFAULT;
+	}
+
+	return 0;
+}
+
+static int _gid_table_setup_one(struct ib_device *ib_dev)
+{
+	u8 port;
+	struct ib_gid_table **table;
+	int err = 0;
+
+	table = kcalloc(ib_dev->phys_port_cnt, sizeof(*table), GFP_KERNEL);
+
+	if (!table) {
+		pr_warn("failed to allocate ib gid cache for %s\n",
+			ib_dev->name);
+		return -ENOMEM;
+	}
+
+	for (port = 0; port < ib_dev->phys_port_cnt; port++) {
+		u8 rdma_port = port + rdma_start_port(ib_dev);
+
+		table[port] =
+			alloc_gid_table(
+				ib_dev->port_immutable[rdma_port].gid_tbl_len);
+		if (!table[port]) {
+			err = -ENOMEM;
+			goto rollback_table_setup;
+		}
+
+		err = gid_table_reserve_default(ib_dev,
+						port + rdma_start_port(ib_dev),
+						table[port]);
+		if (err)
+			goto rollback_table_setup;
+	}
+
+	ib_dev->cache.gid_cache = table;
+	return 0;
+
+rollback_table_setup:
+	for (port = 1; port <= ib_dev->phys_port_cnt; port++)
+		free_gid_table(ib_dev, port, table[port]);
+
+	kfree(table);
+	return err;
+}
+
+static void gid_table_cleanup_one(struct ib_device *ib_dev)
+{
+	struct ib_gid_table **table = ib_dev->cache.gid_cache;
+	u8 port;
+
+	if (!table)
+		return;
+
+	for (port = 0; port < ib_dev->phys_port_cnt; port++)
+		free_gid_table(ib_dev, port + rdma_start_port(ib_dev),
+			       table[port]);
+
+	kfree(table);
+}
+
+static int gid_table_setup_one(struct ib_device *ib_dev)
+{
+	int err;
+
+	err = _gid_table_setup_one(ib_dev);
+
+	if (err)
+		return err;
+
+	err = roce_rescan_device(ib_dev);
+
+	if (err)
+		gid_table_cleanup_one(ib_dev);
+
+	return err;
+}
+
+int ib_get_cached_gid(struct ib_device *device,
+		      u8                port_num,
+		      int               index,
+		      union ib_gid     *gid)
+{
+	if (port_num < rdma_start_port(device) || port_num > rdma_end_port(device))
+		return -EINVAL;
+
+	return __ib_cache_gid_get(device, port_num, index, gid, NULL);
+}
+EXPORT_SYMBOL(ib_get_cached_gid);
+
+int ib_find_cached_gid(struct ib_device *device,
+		       const union ib_gid *gid,
+		       u8               *port_num,
+		       u16              *index)
+{
+	return ib_cache_gid_find(device, gid, NULL, port_num, index);
+}
 EXPORT_SYMBOL(ib_find_cached_gid);
 
 int ib_get_cached_pkey(struct ib_device *device,
@@ -243,9 +764,21 @@ static void ib_cache_update(struct ib_device *device,
 {
 	struct ib_port_attr       *tprops = NULL;
 	struct ib_pkey_cache      *pkey_cache = NULL, *old_pkey_cache;
-	struct ib_gid_cache       *gid_cache = NULL, *old_gid_cache;
+	struct ib_gid_cache {
+		int             table_len;
+		union ib_gid    table[0];
+	}			  *gid_cache = NULL;
 	int                        i;
 	int                        ret;
+	struct ib_gid_table	  *table;
+	struct ib_gid_table	 **ports_table = device->cache.gid_cache;
+	bool			   use_roce_gid_table =
+					rdma_cap_roce_gid_table(device, port);
+
+	if (port < rdma_start_port(device) || port > rdma_end_port(device))
+		return;
+
+	table = ports_table[port - rdma_start_port(device)];
 
 	tprops = kmalloc(sizeof *tprops, GFP_KERNEL);
 	if (!tprops)
@@ -265,12 +798,14 @@ static void ib_cache_update(struct ib_device *device,
 
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
@@ -281,29 +816,36 @@ static void ib_cache_update(struct ib_device *device,
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
 
 	device->cache.pkey_cache[port - rdma_start_port(device)] = pkey_cache;
-	device->cache.gid_cache [port - rdma_start_port(device)] = gid_cache;
+	if (!use_roce_gid_table) {
+		for (i = 0; i < gid_cache->table_len; i++) {
+			modify_gid(device, port, table, i, gid_cache->table + i,
+				   &zattr, false);
+		}
+	}
 
 	device->cache.lmc_cache[port - rdma_start_port(device)] = tprops->lmc;
 
 	write_unlock_irq(&device->cache.lock);
 
+	kfree(gid_cache);
 	kfree(old_pkey_cache);
-	kfree(old_gid_cache);
 	kfree(tprops);
 	return;
 
@@ -344,85 +886,76 @@ static void ib_cache_event(struct ib_event_handler *handler,
 	}
 }
 
-static void ib_cache_setup_one(struct ib_device *device)
+int ib_cache_setup_one(struct ib_device *device)
 {
 	int p;
+	int err;
 
 	rwlock_init(&device->cache.lock);
 
 	device->cache.pkey_cache =
 		kmalloc(sizeof *device->cache.pkey_cache *
 			(rdma_end_port(device) - rdma_start_port(device) + 1), GFP_KERNEL);
-	device->cache.gid_cache =
-		kmalloc(sizeof *device->cache.gid_cache *
-			(rdma_end_port(device) - rdma_start_port(device) + 1), GFP_KERNEL);
-
 	device->cache.lmc_cache = kmalloc(sizeof *device->cache.lmc_cache *
 					  (rdma_end_port(device) -
 					   rdma_start_port(device) + 1),
 					  GFP_KERNEL);
+	err = gid_table_setup_one(device);
 
 	if (!device->cache.pkey_cache || !device->cache.gid_cache ||
 	    !device->cache.lmc_cache) {
 		printk(KERN_WARNING "Couldn't allocate cache "
 		       "for %s\n", device->name);
+		err = -ENOMEM;
 		goto err;
 	}
 
 	for (p = 0; p <= rdma_end_port(device) - rdma_start_port(device); ++p) {
 		device->cache.pkey_cache[p] = NULL;
-		device->cache.gid_cache [p] = NULL;
 		ib_cache_update(device, p + rdma_start_port(device));
 	}
 
 	INIT_IB_EVENT_HANDLER(&device->cache.event_handler,
 			      device, ib_cache_event);
-	if (ib_register_event_handler(&device->cache.event_handler))
+	err = ib_register_event_handler(&device->cache.event_handler);
+	if (err)
 		goto err_cache;
 
-	return;
+	return 0;
 
 err_cache:
-	for (p = 0; p <= rdma_end_port(device) - rdma_start_port(device); ++p) {
+	for (p = 0; p <= rdma_end_port(device) - rdma_start_port(device); ++p)
 		kfree(device->cache.pkey_cache[p]);
-		kfree(device->cache.gid_cache[p]);
-	}
 
 err:
 	kfree(device->cache.pkey_cache);
-	kfree(device->cache.gid_cache);
+	gid_table_cleanup_one(device);
 	kfree(device->cache.lmc_cache);
+
+	return err;
 }
 
-static void ib_cache_cleanup_one(struct ib_device *device)
+void ib_cache_cleanup_one(struct ib_device *device)
 {
 	int p;
 
 	ib_unregister_event_handler(&device->cache.event_handler);
 	flush_workqueue(ib_wq);
 
-	for (p = 0; p <= rdma_end_port(device) - rdma_start_port(device); ++p) {
+	for (p = 0; p <= rdma_end_port(device) - rdma_start_port(device); ++p)
 		kfree(device->cache.pkey_cache[p]);
-		kfree(device->cache.gid_cache[p]);
-	}
 
 	kfree(device->cache.pkey_cache);
-	kfree(device->cache.gid_cache);
+	gid_table_cleanup_one(device);
 	kfree(device->cache.lmc_cache);
 }
 
-static struct ib_client cache_client = {
-	.name   = "cache",
-	.add    = ib_cache_setup_one,
-	.remove = ib_cache_cleanup_one
-};
-
-int __init ib_cache_setup(void)
+void __init ib_cache_setup(void)
 {
-	return ib_register_client(&cache_client);
+	roce_gid_mgmt_init();
 }
 
 void __exit ib_cache_cleanup(void)
 {
-	ib_unregister_client(&cache_client);
+	roce_gid_mgmt_cleanup();
 }
diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 87d1936..210ddd2 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -46,9 +46,57 @@ void ib_device_unregister_sysfs(struct ib_device *device);
 int  ib_sysfs_setup(void);
 void ib_sysfs_cleanup(void);
 
-int  ib_cache_setup(void);
+void  ib_cache_setup(void);
 void ib_cache_cleanup(void);
 
 int ib_resolve_eth_l2_attrs(struct ib_qp *qp,
 			    struct ib_qp_attr *qp_attr, int *qp_attr_mask);
+
+typedef void (*roce_netdev_callback)(struct ib_device *device, u8 port,
+	      struct net_device *idev, void *cookie);
+
+typedef int (*roce_netdev_filter)(struct ib_device *device, u8 port,
+	     struct net_device *idev, void *cookie);
+
+void ib_enum_roce_netdev(struct ib_device *ib_dev,
+			 roce_netdev_filter filter,
+			 void *filter_cookie,
+			 roce_netdev_callback cb,
+			 void *cookie);
+void ib_enum_all_roce_netdevs(roce_netdev_filter filter,
+			      void *filter_cookie,
+			      roce_netdev_callback cb,
+			      void *cookie);
+
+int ib_cache_gid_find_by_port(struct ib_device *ib_dev,
+			      const union ib_gid *gid,
+			      u8 port, struct net_device *ndev,
+			      u16 *index);
+
+enum ib_cache_gid_default_mode {
+	IB_CACHE_GID_DEFAULT_MODE_SET,
+	IB_CACHE_GID_DEFAULT_MODE_DELETE
+};
+
+void ib_cache_gid_set_default_gid(struct ib_device *ib_dev, u8 port,
+				  struct net_device *ndev,
+				  enum ib_cache_gid_default_mode mode);
+
+int ib_cache_gid_add(struct ib_device *ib_dev, u8 port,
+		     union ib_gid *gid, struct ib_gid_attr *attr);
+
+int ib_cache_gid_del(struct ib_device *ib_dev, u8 port,
+		     union ib_gid *gid, struct ib_gid_attr *attr);
+
+int ib_cache_gid_del_all_netdev_gids(struct ib_device *ib_dev, u8 port,
+				     struct net_device *ndev);
+
+int roce_gid_mgmt_init(void);
+void roce_gid_mgmt_cleanup(void);
+
+int roce_rescan_device(struct ib_device *ib_dev);
+
+int ib_cache_setup_one(struct ib_device *device);
+void ib_cache_cleanup_one(struct ib_device *device);
+
 #endif /* _CORE_PRIV_H */
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index f08d438..14ea709 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -39,6 +39,8 @@
 #include <linux/init.h>
 #include <linux/mutex.h>
 #include <rdma/rdma_netlink.h>
+#include <rdma/ib_addr.h>
+#include <rdma/ib_cache.h>
 
 #include "core_priv.h"
 
@@ -314,6 +316,14 @@ int ib_register_device(struct ib_device *device,
 
 	device->reg_state = IB_DEV_REGISTERED;
 
+	ret = ib_cache_setup_one(device);
+	if (ret) {
+		printk(KERN_WARNING "Couldn't set up InfiniBand P_Key/GID cache\n");
+		ib_device_unregister_sysfs(device);
+		kfree(device->port_immutable);
+		goto out;
+	}
+
 	{
 		struct ib_client *client;
 
@@ -607,11 +617,80 @@ EXPORT_SYMBOL(ib_query_port);
 int ib_query_gid(struct ib_device *device,
 		 u8 port_num, int index, union ib_gid *gid)
 {
+	if (rdma_cap_roce_gid_table(device, port_num))
+		return ib_get_cached_gid(device, port_num, index, gid);
+
 	return device->query_gid(device, port_num, index, gid);
 }
 EXPORT_SYMBOL(ib_query_gid);
 
 /**
+ * ib_enum_roce_netdev - enumerate all RoCE ports
+ * @ib_dev : IB device we want to query
+ * @filter: Should we call the callback?
+ * @filter_cookie: Cookie passed to filter
+ * @cb: Callback to call for each found RoCE ports
+ * @cookie: Cookie passed back to the callback
+ *
+ * Enumerates all of the physical RoCE ports of ib_dev
+ * which are related to netdevice and calls callback() on each
+ * device for which filter() function returns non zero.
+ */
+void ib_enum_roce_netdev(struct ib_device *ib_dev,
+			 roce_netdev_filter filter,
+			 void *filter_cookie,
+			 roce_netdev_callback cb,
+			 void *cookie)
+{
+	u8 port;
+
+	for (port = rdma_start_port(ib_dev); port <= rdma_end_port(ib_dev);
+	     port++)
+		if (rdma_protocol_roce(ib_dev, port)) {
+			struct net_device *idev = NULL;
+
+			if (ib_dev->get_netdev)
+				idev = ib_dev->get_netdev(ib_dev, port);
+
+			if (idev &&
+			    idev->reg_state >= NETREG_UNREGISTERED) {
+				dev_put(idev);
+				idev = NULL;
+			}
+
+			if (filter(ib_dev, port, idev, filter_cookie))
+				cb(ib_dev, port, idev, cookie);
+
+			if (idev)
+				dev_put(idev);
+		}
+}
+
+/**
+ * ib_enum_all_roce_netdevs - enumerate all RoCE devices
+ * @filter: Should we call the callback?
+ * @filter_cookie: Cookie passed to filter
+ * @cb: Callback to call for each found RoCE ports
+ * @cookie: Cookie passed back to the callback
+ *
+ * Enumerates all RoCE devices' physical ports which are related
+ * to netdevices and calls callback() on each device for which
+ * filter() function returns non zero.
+ */
+void ib_enum_all_roce_netdevs(roce_netdev_filter filter,
+			      void *filter_cookie,
+			      roce_netdev_callback cb,
+			      void *cookie)
+{
+	struct ib_device *dev;
+
+	down_read(&lists_rwsem);
+	list_for_each_entry(dev, &device_list, core_list)
+		ib_enum_roce_netdev(dev, filter, filter_cookie, cb, cookie);
+	up_read(&lists_rwsem);
+}
+
+/**
  * ib_query_pkey - Get P_Key table entry
  * @device:Device to query
  * @port_num:Port number to query
@@ -690,6 +769,13 @@ int ib_find_gid(struct ib_device *device, union ib_gid *gid,
 	int ret, port, i;
 
 	for (port = rdma_start_port(device); port <= rdma_end_port(device); ++port) {
+		if (rdma_cap_roce_gid_table(device, port)) {
+			if (!ib_cache_gid_find_by_port(device, gid, port,
+						       NULL, index))
+				*port_num = port;
+				return 0;
+		}
+
 		for (i = 0; i < device->port_immutable[port].gid_tbl_len; ++i) {
 			ret = ib_query_gid(device, port, i, &tmp_gid);
 			if (ret)
@@ -766,17 +852,10 @@ static int __init ib_core_init(void)
 		goto err_sysfs;
 	}
 
-	ret = ib_cache_setup();
-	if (ret) {
-		printk(KERN_WARNING "Couldn't set up InfiniBand P_Key/GID cache\n");
-		goto err_nl;
-	}
+	ib_cache_setup();
 
 	return 0;
 
-err_nl:
-	ibnl_cleanup();
-
 err_sysfs:
 	ib_sysfs_cleanup();
 
diff --git a/drivers/infiniband/core/roce_gid_mgmt.c b/drivers/infiniband/core/roce_gid_mgmt.c
new file mode 100644
index 0000000..7bf4798
--- /dev/null
+++ b/drivers/infiniband/core/roce_gid_mgmt.c
@@ -0,0 +1,465 @@
+/*
+ * Copyright (c) 2015, Mellanox Technologies inc.  All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include "core_priv.h"
+
+#include <linux/in.h>
+#include <linux/in6.h>
+
+/* For in6_dev_get/in6_dev_put */
+#include <net/addrconf.h>
+
+#include <rdma/ib_cache.h>
+#include <rdma/ib_addr.h>
+
+enum gid_op_type {
+	GID_DEL = 0,
+	GID_ADD
+};
+
+struct update_gid_event_work {
+	struct work_struct work;
+	union ib_gid       gid;
+	struct ib_gid_attr gid_attr;
+	enum gid_op_type gid_op;
+};
+
+#define ROCE_NETDEV_CALLBACK_SZ		2
+struct netdev_event_work_cmd {
+	roce_netdev_callback	cb;
+	roce_netdev_filter	filter;
+};
+
+struct netdev_event_work {
+	struct work_struct		work;
+	struct netdev_event_work_cmd	cmds[ROCE_NETDEV_CALLBACK_SZ];
+	struct net_device		*ndev;
+};
+
+static void update_gid(enum gid_op_type gid_op, struct ib_device *ib_dev,
+		       u8 port, union ib_gid *gid,
+		       struct ib_gid_attr *gid_attr)
+{
+	switch (gid_op) {
+	case GID_ADD:
+		ib_cache_gid_add(ib_dev, port, gid, gid_attr);
+		break;
+	case GID_DEL:
+		ib_cache_gid_del(ib_dev, port, gid, gid_attr);
+		break;
+	}
+}
+
+static int is_eth_port_of_netdev(struct ib_device *ib_dev, u8 port,
+				 struct net_device *rdma_ndev, void *cookie)
+{
+	struct net_device *real_dev;
+	struct net_device *master_dev;
+	struct net_device *event_ndev = (struct net_device *)cookie;
+	int res;
+
+	if (!rdma_ndev)
+		return 0;
+
+	rcu_read_lock();
+	master_dev = netdev_master_upper_dev_get_rcu(rdma_ndev);
+	real_dev = rdma_vlan_dev_real_dev(event_ndev);
+	res = (real_dev ? real_dev : event_ndev) ==
+		(master_dev ? master_dev : rdma_ndev);
+	rcu_read_unlock();
+
+	return res;
+}
+
+static int pass_all_filter(struct ib_device *ib_dev, u8 port,
+			   struct net_device *rdma_ndev, void *cookie)
+{
+	return 1;
+}
+
+static void update_gid_ip(enum gid_op_type gid_op,
+			  struct ib_device *ib_dev,
+			  u8 port, struct net_device *ndev,
+			  struct sockaddr *addr)
+{
+	union ib_gid gid;
+	struct ib_gid_attr gid_attr;
+
+	rdma_ip2gid(addr, &gid);
+	memset(&gid_attr, 0, sizeof(gid_attr));
+	gid_attr.ndev = ndev;
+
+	update_gid(gid_op, ib_dev, port, &gid, &gid_attr);
+}
+
+static void enum_netdev_default_gids(struct ib_device *ib_dev,
+				     u8 port, struct net_device *event_ndev,
+				     struct net_device *rdma_ndev)
+{
+	if (rdma_ndev != event_ndev)
+		return;
+
+	ib_cache_gid_set_default_gid(ib_dev, port, rdma_ndev,
+				     IB_CACHE_GID_DEFAULT_MODE_SET);
+}
+
+static void enum_netdev_ipv4_ips(struct ib_device *ib_dev,
+				 u8 port, struct net_device *ndev)
+{
+	struct in_device *in_dev;
+
+	if (ndev->reg_state >= NETREG_UNREGISTERING)
+		return;
+
+	in_dev = in_dev_get(ndev);
+	if (!in_dev)
+		return;
+
+	for_ifa(in_dev) {
+		struct sockaddr_in ip;
+
+		ip.sin_family = AF_INET;
+		ip.sin_addr.s_addr = ifa->ifa_address;
+		update_gid_ip(GID_ADD, ib_dev, port, ndev,
+			      (struct sockaddr *)&ip);
+	}
+	endfor_ifa(in_dev);
+
+	in_dev_put(in_dev);
+}
+
+static void enum_netdev_ipv6_ips(struct ib_device *ib_dev,
+				 u8 port, struct net_device *ndev)
+{
+	struct inet6_ifaddr *ifp;
+	struct inet6_dev *in6_dev;
+	struct sin6_list {
+		struct list_head	list;
+		struct sockaddr_in6	sin6;
+	};
+	struct sin6_list *sin6_iter;
+	struct sin6_list *sin6_temp;
+	struct ib_gid_attr gid_attr = {.ndev = ndev};
+	LIST_HEAD(sin6_list);
+
+	if (ndev->reg_state >= NETREG_UNREGISTERING)
+		return;
+
+	in6_dev = in6_dev_get(ndev);
+	if (!in6_dev)
+		return;
+
+	read_lock_bh(&in6_dev->lock);
+	list_for_each_entry(ifp, &in6_dev->addr_list, if_list) {
+		struct sin6_list *entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
+
+		if (!entry) {
+			pr_warn("roce_gid_mgmt: couldn't allocate entry for IPv6 update\n");
+			continue;
+		}
+
+		entry->sin6.sin6_family = AF_INET6;
+		entry->sin6.sin6_addr = ifp->addr;
+		list_add_tail(&entry->list, &sin6_list);
+	}
+	read_unlock_bh(&in6_dev->lock);
+
+	in6_dev_put(in6_dev);
+
+	list_for_each_entry_safe(sin6_iter, sin6_temp, &sin6_list, list) {
+		union ib_gid	gid;
+
+		rdma_ip2gid((struct sockaddr *)&sin6_iter->sin6, &gid);
+		update_gid(GID_ADD, ib_dev, port, &gid, &gid_attr);
+		list_del(&sin6_iter->list);
+		kfree(sin6_iter);
+	}
+}
+
+static void add_netdev_ips(struct ib_device *ib_dev, u8 port,
+			   struct net_device *rdma_ndev, void *cookie)
+{
+	struct net_device *event_ndev = (struct net_device *)cookie;
+
+	enum_netdev_default_gids(ib_dev, port, event_ndev, rdma_ndev);
+	enum_netdev_ipv4_ips(ib_dev, port, event_ndev);
+	if (IS_ENABLED(CONFIG_IPV6))
+		enum_netdev_ipv6_ips(ib_dev, port, event_ndev);
+}
+
+static void del_netdev_ips(struct ib_device *ib_dev, u8 port,
+			   struct net_device *rdma_ndev, void *cookie)
+{
+	struct net_device *event_ndev = (struct net_device *)cookie;
+
+	ib_cache_gid_del_all_netdev_gids(ib_dev, port, event_ndev);
+}
+
+static void enum_all_gids_of_dev_cb(struct ib_device *ib_dev,
+				    u8 port,
+				    struct net_device *rdma_ndev,
+				    void *cookie)
+{
+	struct net *net;
+	struct net_device *ndev;
+
+	/* Lock the rtnl to make sure the netdevs does not move under
+	 * our feet
+	 */
+	rtnl_lock();
+	for_each_net(net)
+		for_each_netdev(net, ndev)
+			if (is_eth_port_of_netdev(ib_dev, port, rdma_ndev, ndev))
+				add_netdev_ips(ib_dev, port, rdma_ndev, ndev);
+	rtnl_unlock();
+}
+
+/* This function will rescan all of the network devices in the system
+ * and add their gids, as needed, to the relevant RoCE devices. */
+int roce_rescan_device(struct ib_device *ib_dev)
+{
+	ib_enum_roce_netdev(ib_dev, pass_all_filter, NULL,
+			    enum_all_gids_of_dev_cb, NULL);
+
+	return 0;
+}
+
+static void callback_for_addr_gid_device_scan(struct ib_device *device,
+					      u8 port,
+					      struct net_device *rdma_ndev,
+					      void *cookie)
+{
+	struct update_gid_event_work *parsed = cookie;
+
+	return update_gid(parsed->gid_op, device,
+			  port, &parsed->gid,
+			  &parsed->gid_attr);
+}
+
+/* The following functions operate on all IB devices. netdevice_event and
+ * addr_event execute ib_enum_all_roce_netdevs through a work.
+ * ib_enum_all_roce_netdevs iterates through all IB devices.
+ */
+
+static void netdevice_event_work_handler(struct work_struct *_work)
+{
+	struct netdev_event_work *work =
+		container_of(_work, struct netdev_event_work, work);
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(work->cmds) && work->cmds[i].cb; i++)
+		ib_enum_all_roce_netdevs(work->cmds[i].filter, work->ndev,
+					 work->cmds[i].cb, work->ndev);
+
+	dev_put(work->ndev);
+	kfree(work);
+}
+
+static int netdevice_queue_work(struct netdev_event_work_cmd *cmds,
+				struct net_device *ndev)
+{
+	struct netdev_event_work *ndev_work =
+		kmalloc(sizeof(*ndev_work), GFP_KERNEL);
+
+	if (!ndev_work) {
+		pr_warn("roce_gid_mgmt: can't allocate work for netdevice_event\n");
+		return NOTIFY_DONE;
+	}
+
+	memcpy(ndev_work->cmds, cmds, sizeof(ndev_work->cmds));
+	ndev_work->ndev = ndev;
+	dev_hold(ndev);
+	INIT_WORK(&ndev_work->work, netdevice_event_work_handler);
+
+	queue_work(ib_wq, &ndev_work->work);
+
+	return NOTIFY_DONE;
+}
+
+static int netdevice_event(struct notifier_block *this, unsigned long event,
+			   void *ptr)
+{
+	static const struct netdev_event_work_cmd add_cmd = {
+		.cb = add_netdev_ips, .filter = is_eth_port_of_netdev};
+	static const struct netdev_event_work_cmd del_cmd = {
+		.cb = del_netdev_ips, .filter = pass_all_filter};
+	struct net_device *ndev = netdev_notifier_info_to_dev(ptr);
+	struct netdev_event_work_cmd cmds[ROCE_NETDEV_CALLBACK_SZ] = { {NULL} };
+
+	if (ndev->type != ARPHRD_ETHER)
+		return NOTIFY_DONE;
+
+	switch (event) {
+	case NETDEV_REGISTER:
+	case NETDEV_UP:
+		cmds[0] = add_cmd;
+		break;
+
+	case NETDEV_UNREGISTER:
+		if (ndev->reg_state < NETREG_UNREGISTERED)
+			cmds[0] = del_cmd;
+		else
+			return NOTIFY_DONE;
+		break;
+
+	case NETDEV_CHANGEADDR:
+		cmds[0] = del_cmd;
+		cmds[1] = add_cmd;
+		break;
+	default:
+		return NOTIFY_DONE;
+	}
+
+	return netdevice_queue_work(cmds, ndev);
+}
+
+static void update_gid_event_work_handler(struct work_struct *_work)
+{
+	struct update_gid_event_work *work =
+		container_of(_work, struct update_gid_event_work, work);
+
+	ib_enum_all_roce_netdevs(is_eth_port_of_netdev, work->gid_attr.ndev,
+				 callback_for_addr_gid_device_scan, work);
+
+	dev_put(work->gid_attr.ndev);
+	kfree(work);
+}
+
+static int addr_event(struct notifier_block *this, unsigned long event,
+		      struct sockaddr *sa, struct net_device *ndev)
+{
+	struct update_gid_event_work *work;
+	enum gid_op_type gid_op;
+
+	if (ndev->type != ARPHRD_ETHER)
+		return NOTIFY_DONE;
+
+	switch (event) {
+	case NETDEV_UP:
+		gid_op = GID_ADD;
+		break;
+
+	case NETDEV_DOWN:
+		gid_op = GID_DEL;
+		break;
+
+	default:
+		return NOTIFY_DONE;
+	}
+
+	work = kmalloc(sizeof(*work), GFP_ATOMIC);
+	if (!work) {
+		pr_warn("roce_gid_mgmt: Couldn't allocate work for addr_event\n");
+		return NOTIFY_DONE;
+	}
+
+	INIT_WORK(&work->work, update_gid_event_work_handler);
+
+	rdma_ip2gid(sa, &work->gid);
+	work->gid_op = gid_op;
+
+	memset(&work->gid_attr, 0, sizeof(work->gid_attr));
+	dev_hold(ndev);
+	work->gid_attr.ndev   = ndev;
+
+	queue_work(ib_wq, &work->work);
+
+	return NOTIFY_DONE;
+}
+
+static int inetaddr_event(struct notifier_block *this, unsigned long event,
+			  void *ptr)
+{
+	struct sockaddr_in	in;
+	struct net_device	*ndev;
+	struct in_ifaddr	*ifa = ptr;
+
+	in.sin_family = AF_INET;
+	in.sin_addr.s_addr = ifa->ifa_address;
+	ndev = ifa->ifa_dev->dev;
+
+	return addr_event(this, event, (struct sockaddr *)&in, ndev);
+}
+
+static int inet6addr_event(struct notifier_block *this, unsigned long event,
+			   void *ptr)
+{
+	struct sockaddr_in6	in6;
+	struct net_device	*ndev;
+	struct inet6_ifaddr	*ifa6 = ptr;
+
+	in6.sin6_family = AF_INET6;
+	in6.sin6_addr = ifa6->addr;
+	ndev = ifa6->idev->dev;
+
+	return addr_event(this, event, (struct sockaddr *)&in6, ndev);
+}
+
+static struct notifier_block nb_netdevice = {
+	.notifier_call = netdevice_event
+};
+
+static struct notifier_block nb_inetaddr = {
+	.notifier_call = inetaddr_event
+};
+
+static struct notifier_block nb_inet6addr = {
+	.notifier_call = inet6addr_event
+};
+
+int __init roce_gid_mgmt_init(void)
+{
+	register_inetaddr_notifier(&nb_inetaddr);
+	if (IS_ENABLED(CONFIG_IPV6))
+		register_inet6addr_notifier(&nb_inet6addr);
+	/* We relay on the netdevice notifier to enumerate all
+	 * existing devices in the system. Register to this notifier
+	 * last to make sure we will not miss any IP add/del
+	 * callbacks.
+	 */
+	register_netdevice_notifier(&nb_netdevice);
+
+	return 0;
+}
+
+void __exit roce_gid_mgmt_cleanup(void)
+{
+	if (IS_ENABLED(CONFIG_IPV6))
+		unregister_inet6addr_notifier(&nb_inet6addr);
+	unregister_inetaddr_notifier(&nb_inetaddr);
+	unregister_netdevice_notifier(&nb_netdevice);
+	/* Ensure all gid deletion tasks complete before we go down,
+	 * to avoid any reference to free'd memory. By the time
+	 * ib-core is removed, all physical devices have been removed,
+	 * so no issue with remaining hardware contexts.
+	 */
+}
diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 0b84a9c..c10c6d3 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -461,6 +461,7 @@ static void ib_device_release(struct device *device)
 {
 	struct ib_device *dev = container_of(device, struct ib_device, dev);
 
+	ib_cache_cleanup_one(dev);
 	kfree(dev->port_immutable);
 	kfree(dev);
 }
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 080a976..74fc94c 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -64,6 +64,10 @@ union ib_gid {
 	} global;
 };
 
+struct ib_gid_attr {
+	struct net_device	*ndev;
+};
+
 enum rdma_node_type {
 	/* IB values map to NodeInfo:NodeType. */
 	RDMA_NODE_IB_CA 	= 1,
@@ -284,7 +288,7 @@ enum ib_port_cap_flags {
 	IB_PORT_BOOT_MGMT_SUP			= 1 << 23,
 	IB_PORT_LINK_LATENCY_SUP		= 1 << 24,
 	IB_PORT_CLIENT_REG_SUP			= 1 << 25,
-	IB_PORT_IP_BASED_GIDS			= 1 << 26
+	IB_PORT_IP_BASED_GIDS			= 1 << 26,
 };
 
 enum ib_port_width {
@@ -1488,7 +1492,7 @@ struct ib_cache {
 	rwlock_t                lock;
 	struct ib_event_handler event_handler;
 	struct ib_pkey_cache  **pkey_cache;
-	struct ib_gid_cache   **gid_cache;
+	struct ib_gid_table   **gid_cache;
 	u8                     *lmc_cache;
 };
 
@@ -1572,9 +1576,47 @@ struct ib_device {
 						 struct ib_port_attr *port_attr);
 	enum rdma_link_layer	   (*get_link_layer)(struct ib_device *device,
 						     u8 port_num);
+	/* When calling get_netdev, the HW vendor's driver should return the
+	 * net device of device @device at port @port_num or NULL if such
+	 * a net device doesn't exist. The vendor driver should call dev_hold
+	 * on this net device. The HW vendor's device driver must guarantee
+	 * that this function returns NULL before the net device reaches
+	 * NETDEV_UNREGISTER_FINAL state.
+	 */
+	struct net_device	  *(*get_netdev)(struct ib_device *device,
+						 u8 port_num);
 	int		           (*query_gid)(struct ib_device *device,
 						u8 port_num, int index,
 						union ib_gid *gid);
+	/* When calling add_gid, the HW vendor's driver should
+	 * add the gid of device @device at gid index @index of
+	 * port @port_num to be @gid. Meta-info of that gid (for example,
+	 * the network device related to this gid is available
+	 * at @attr. @context allows the HW vendor driver to store extra
+	 * information together with a GID entry. The HW vendor may allocate
+	 * memory to contain this information and store it in @context when a
+	 * new GID entry is written to. Params are consistent until the next
+	 * call of add_gid or delete_gid. The function should return 0 on
+	 * success or error otherwise. The function could be called
+	 * concurrently for different ports. This function is only called
+	 * when roce_gid_table is used.
+	 */
+	int		           (*add_gid)(struct ib_device *device,
+					      u8 port_num,
+					      unsigned int index,
+					      const union ib_gid *gid,
+					      const struct ib_gid_attr *attr,
+					      void **context);
+	/* When calling del_gid, the HW vendor's driver should delete the
+	 * gid of device @device at gid index @index of port @port_num.
+	 * Upon the deletion of a GID entry, the HW vendor must free any
+	 * allocated memory. The caller will clear @context afterwards.
+	 * This function is only called when roce_gid_table is used.
+	 */
+	int		           (*del_gid)(struct ib_device *device,
+					      u8 port_num,
+					      unsigned int index,
+					      void **context);
 	int		           (*query_pkey)(struct ib_device *device,
 						 u8 port_num, u16 index, u16 *pkey);
 	int		           (*modify_device)(struct ib_device *device,
@@ -2088,6 +2130,26 @@ static inline size_t rdma_max_mad_size(const struct ib_device *device, u8 port_n
 	return device->port_immutable[port_num].max_mad_size;
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
+	return rdma_protocol_roce(device, port_num) &&
+		device->add_gid && device->del_gid;
+}
+
 int ib_query_gid(struct ib_device *device,
 		 u8 port_num, int index, union ib_gid *gid);
 
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
