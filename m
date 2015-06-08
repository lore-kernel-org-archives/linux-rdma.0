From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V5 01/12] IB/core: Add RoCE GID table
Date: Mon,  8 Jun 2015 17:12:04 +0300
Message-ID: <1433772735-22416-2-git-send-email-matanb@mellanox.com>
References: <1433772735-22416-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433772735-22416-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-xCNTGe7nOvUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Refactoring the GID management code requires us to have GIDs
alongside its meta information (the associated net_device).
This information is necessary in order to manage the GID
table successfully. For example, when a net_device is removed,
its associated GIDs need to be removed as well.

Adding a GID table that supports a lockless find, add and
delete gids. The lockless nature comes from using a unique
sequence number per table entry and detecting that while reading/
writing this sequence wasn't changed.

By using this RoCE GID table, providers must implement a
modify_gid callback. The table is managed exclusively by
this roce_gid_table and the provider just need to write
the data to the hardware.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/Makefile         |   3 +-
 drivers/infiniband/core/core_priv.h      |  23 ++
 drivers/infiniband/core/roce_gid_table.c | 470 +++++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx4/main.c        |   2 -
 include/rdma/ib_verbs.h                  |  46 ++-
 5 files changed, 540 insertions(+), 4 deletions(-)
 create mode 100644 drivers/infiniband/core/roce_gid_table.c

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index acf7367..fbeb72a 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -9,7 +9,8 @@ obj-$(CONFIG_INFINIBAND_USER_ACCESS) +=	ib_uverbs.o ib_ucm.o \
 					$(user_access-y)
 
 ib_core-y :=			packer.o ud_header.o verbs.o sysfs.o \
-				device.o fmr_pool.o cache.o netlink.o
+				device.o fmr_pool.o cache.o netlink.o \
+				roce_gid_table.o
 ib_core-$(CONFIG_INFINIBAND_USER_MEM) += umem.o
 ib_core-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) += umem_odp.o umem_rbtree.o
 
diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 87d1936..a9e58418 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -35,6 +35,7 @@
 
 #include <linux/list.h>
 #include <linux/spinlock.h>
+#include <net/net_namespace.h>
 
 #include <rdma/ib_verbs.h>
 
@@ -51,4 +52,26 @@ void ib_cache_cleanup(void);
 
 int ib_resolve_eth_l2_attrs(struct ib_qp *qp,
 			    struct ib_qp_attr *qp_attr, int *qp_attr_mask);
+
+int roce_gid_table_get_gid(struct ib_device *ib_dev, u8 port, int index,
+			   union ib_gid *gid, struct ib_gid_attr *attr);
+
+int roce_gid_table_find_gid(struct ib_device *ib_dev, const union ib_gid *gid,
+			    struct net_device *ndev, u8 *port,
+			    u16 *index);
+
+int roce_gid_table_find_gid_by_port(struct ib_device *ib_dev,
+				    const union ib_gid *gid,
+				    u8 port, struct net_device *ndev,
+				    u16 *index);
+
+int roce_add_gid(struct ib_device *ib_dev, u8 port,
+		 union ib_gid *gid, struct ib_gid_attr *attr);
+
+int roce_del_gid(struct ib_device *ib_dev, u8 port,
+		 union ib_gid *gid, struct ib_gid_attr *attr);
+
+int roce_del_all_netdev_gids(struct ib_device *ib_dev, u8 port,
+			     struct net_device *ndev);
+
 #endif /* _CORE_PRIV_H */
diff --git a/drivers/infiniband/core/roce_gid_table.c b/drivers/infiniband/core/roce_gid_table.c
new file mode 100644
index 0000000..f492cf1
--- /dev/null
+++ b/drivers/infiniband/core/roce_gid_table.c
@@ -0,0 +1,470 @@
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
+#include <linux/slab.h>
+#include <linux/netdevice.h>
+#include <linux/rtnetlink.h>
+#include <rdma/ib_cache.h>
+
+#include "core_priv.h"
+
+union ib_gid zgid;
+EXPORT_SYMBOL_GPL(zgid);
+
+static const struct ib_gid_attr zattr;
+
+enum gid_attr_find_mask {
+	GID_ATTR_FIND_MASK_GID          = 1UL << 0,
+	GID_ATTR_FIND_MASK_NETDEV	= 1UL << 1,
+};
+
+struct dev_put_rcu {
+	struct rcu_head		rcu;
+	struct net_device	*ndev;
+};
+
+static void put_ndev(struct rcu_head *rcu)
+{
+	struct dev_put_rcu *put_rcu =
+		container_of(rcu, struct dev_put_rcu, rcu);
+
+	dev_put(put_rcu->ndev);
+	kfree(put_rcu);
+}
+
+static int write_gid(struct ib_device *ib_dev, u8 port,
+		     struct ib_roce_gid_table *table, int ix,
+		     const union ib_gid *gid,
+		     const struct ib_gid_attr *attr)
+{
+	int ret;
+	struct dev_put_rcu	*put_rcu;
+	struct net_device *old_net_dev;
+
+	write_seqcount_begin(&table->data_vec[ix].seq);
+
+	ret = ib_dev->modify_gid(ib_dev, port, ix, gid, attr,
+				 &table->data_vec[ix].context);
+
+	old_net_dev = table->data_vec[ix].attr.ndev;
+	if (old_net_dev && old_net_dev != attr->ndev) {
+		put_rcu = kmalloc(sizeof(*put_rcu), GFP_KERNEL);
+		if (put_rcu) {
+			put_rcu->ndev = old_net_dev;
+			call_rcu(&put_rcu->rcu, put_ndev);
+		} else {
+			pr_warn("roce_gid_table: can't allocate rcu context, using synchronize\n");
+			synchronize_rcu();
+			dev_put(old_net_dev);
+		}
+	}
+	/* if modify_gid failed, just delete the old gid */
+	if (ret || !memcmp(gid, &zgid, sizeof(*gid))) {
+		gid = &zgid;
+		attr = &zattr;
+		table->data_vec[ix].context = NULL;
+	}
+	memcpy(&table->data_vec[ix].gid, gid, sizeof(*gid));
+	memcpy(&table->data_vec[ix].attr, attr, sizeof(*attr));
+	if (table->data_vec[ix].attr.ndev &&
+	    table->data_vec[ix].attr.ndev != old_net_dev)
+		dev_hold(table->data_vec[ix].attr.ndev);
+
+	write_seqcount_end(&table->data_vec[ix].seq);
+
+	if (!ret) {
+		struct ib_event event;
+
+		event.device		= ib_dev;
+		event.element.port_num	= port;
+		event.event		= IB_EVENT_GID_CHANGE;
+
+		ib_dispatch_event(&event);
+	}
+	return ret;
+}
+
+static int find_gid(struct ib_roce_gid_table *table, const union ib_gid *gid,
+		    const struct ib_gid_attr *val, unsigned long mask)
+{
+	int i;
+
+	for (i = 0; i < table->sz; i++) {
+		struct ib_gid_attr *attr = &table->data_vec[i].attr;
+		unsigned int orig_seq = read_seqcount_begin(&table->data_vec[i].seq);
+
+		if (memcmp(gid, &table->data_vec[i].gid, sizeof(*gid)))
+			continue;
+
+		if (mask & GID_ATTR_FIND_MASK_NETDEV &&
+		    attr->ndev != val->ndev)
+			continue;
+
+		if (!read_seqcount_retry(&table->data_vec[i].seq, orig_seq))
+			return i;
+		/* The sequence number changed under our feet,
+		 * the GID entry is invalid. Continue to the
+		 * next entry.
+		 */
+	}
+
+	return -1;
+}
+
+int roce_add_gid(struct ib_device *ib_dev, u8 port,
+		 union ib_gid *gid, struct ib_gid_attr *attr)
+{
+	struct ib_roce_gid_table **ports_table =
+		READ_ONCE(ib_dev->cache.roce_gid_table);
+	struct ib_roce_gid_table *table;
+	int ix;
+	int ret = 0;
+
+	/* make sure we read the ports_table */
+	smp_rmb();
+
+	if (!ports_table)
+		return -EOPNOTSUPP;
+
+	table = ports_table[port - rdma_start_port(ib_dev)];
+
+	if (!table)
+		return -EPROTONOSUPPORT;
+
+	if (!memcmp(gid, &zgid, sizeof(*gid)))
+		return -EINVAL;
+
+	mutex_lock(&table->lock);
+
+	ix = find_gid(table, gid, attr, GID_ATTR_FIND_MASK_NETDEV);
+	if (ix >= 0)
+		goto out_unlock;
+
+	ix = find_gid(table, &zgid, NULL, 0);
+	if (ix < 0) {
+		ret = -ENOSPC;
+		goto out_unlock;
+	}
+
+	write_gid(ib_dev, port, table, ix, gid, attr);
+
+out_unlock:
+	mutex_unlock(&table->lock);
+	return ret;
+}
+
+int roce_del_gid(struct ib_device *ib_dev, u8 port,
+		 union ib_gid *gid, struct ib_gid_attr *attr)
+{
+	struct ib_roce_gid_table **ports_table =
+		READ_ONCE(ib_dev->cache.roce_gid_table);
+	struct ib_roce_gid_table *table;
+	int ix;
+
+	/* make sure we read the ports_table */
+	smp_rmb();
+
+	if (!ports_table)
+		return 0;
+
+	table  = ports_table[port - rdma_start_port(ib_dev)];
+
+	if (!table)
+		return -EPROTONOSUPPORT;
+
+	mutex_lock(&table->lock);
+
+	ix = find_gid(table, gid, attr,
+		      GID_ATTR_FIND_MASK_NETDEV);
+	if (ix < 0)
+		goto out_unlock;
+
+	write_gid(ib_dev, port, table, ix, &zgid, &zattr);
+
+out_unlock:
+	mutex_unlock(&table->lock);
+	return 0;
+}
+
+int roce_del_all_netdev_gids(struct ib_device *ib_dev, u8 port,
+			     struct net_device *ndev)
+{
+	struct ib_roce_gid_table **ports_table =
+		READ_ONCE(ib_dev->cache.roce_gid_table);
+	struct ib_roce_gid_table *table;
+	int ix;
+
+	/* make sure we read the ports_table */
+	smp_rmb();
+
+	if (!ports_table)
+		return 0;
+
+	table  = ports_table[port - rdma_start_port(ib_dev)];
+
+	if (!table)
+		return -EPROTONOSUPPORT;
+
+	mutex_lock(&table->lock);
+
+	for (ix = 0; ix < table->sz; ix++)
+		if (table->data_vec[ix].attr.ndev == ndev)
+			write_gid(ib_dev, port, table, ix, &zgid, &zattr);
+
+	mutex_unlock(&table->lock);
+	return 0;
+}
+
+int roce_gid_table_get_gid(struct ib_device *ib_dev, u8 port, int index,
+			   union ib_gid *gid, struct ib_gid_attr *attr)
+{
+	struct ib_roce_gid_table **ports_table =
+		READ_ONCE(ib_dev->cache.roce_gid_table);
+	struct ib_roce_gid_table *table;
+	union ib_gid local_gid;
+	struct ib_gid_attr local_attr;
+	unsigned int orig_seq;
+
+	/* make sure we read the ports_table */
+	smp_rmb();
+
+	if (!ports_table)
+		return -EOPNOTSUPP;
+
+	table = ports_table[port - rdma_start_port(ib_dev)];
+
+	if (!table)
+		return -EPROTONOSUPPORT;
+
+	if (index < 0 || index >= table->sz)
+		return -EINVAL;
+
+	orig_seq = read_seqcount_begin(&table->data_vec[index].seq);
+
+	memcpy(&local_gid, &table->data_vec[index].gid, sizeof(local_gid));
+	memcpy(&local_attr, &table->data_vec[index].attr, sizeof(local_attr));
+
+	if (read_seqcount_retry(&table->data_vec[index].seq, orig_seq))
+		return -EAGAIN;
+
+	memcpy(gid, &local_gid, sizeof(*gid));
+	if (attr)
+		memcpy(attr, &local_attr, sizeof(*attr));
+	return 0;
+}
+
+static int _roce_gid_table_find_gid(struct ib_device *ib_dev,
+				    const union ib_gid *gid,
+				    const struct ib_gid_attr *val,
+				    unsigned long mask,
+				    u8 *port, u16 *index)
+{
+	struct ib_roce_gid_table **ports_table =
+		READ_ONCE(ib_dev->cache.roce_gid_table);
+	struct ib_roce_gid_table *table;
+	u8 p;
+	int local_index;
+
+	/* make sure we read the ports_table */
+	smp_rmb();
+
+	if (!ports_table)
+		return -ENOENT;
+
+	for (p = 0; p < ib_dev->phys_port_cnt; p++) {
+		if (!rdma_protocol_roce(ib_dev, p + rdma_start_port(ib_dev)))
+			continue;
+		table = ports_table[p];
+		if (!table)
+			continue;
+		local_index = find_gid(table, gid, val, mask);
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
+int roce_gid_table_find_gid(struct ib_device *ib_dev, const union ib_gid *gid,
+			    struct net_device *ndev, u8 *port, u16 *index)
+{
+	unsigned long mask = GID_ATTR_FIND_MASK_GID;
+	struct ib_gid_attr gid_attr_val = {.ndev = ndev};
+
+	if (ndev)
+		mask |= GID_ATTR_FIND_MASK_NETDEV;
+
+	return _roce_gid_table_find_gid(ib_dev, gid, &gid_attr_val,
+					mask, port, index);
+}
+
+int roce_gid_table_find_gid_by_port(struct ib_device *ib_dev,
+				    const union ib_gid *gid,
+				    u8 port, struct net_device *ndev,
+				    u16 *index)
+{
+	int local_index;
+	struct ib_roce_gid_table **ports_table =
+		READ_ONCE(ib_dev->cache.roce_gid_table);
+	struct ib_roce_gid_table *table;
+	unsigned long mask = 0;
+	struct ib_gid_attr val = {.ndev = ndev};
+
+	/* make sure we read the ports_table */
+	smp_rmb();
+
+	if (!ports_table || port < rdma_start_port(ib_dev) ||
+	    port > rdma_end_port(ib_dev))
+		return -ENOENT;
+
+	table = ports_table[port - rdma_start_port(ib_dev)];
+	if (!table)
+		return -ENOENT;
+
+	if (ndev)
+		mask |= GID_ATTR_FIND_MASK_NETDEV;
+
+	local_index = find_gid(table, gid, &val, mask);
+	if (local_index >= 0) {
+		if (index)
+			*index = local_index;
+		return 0;
+	}
+
+	return -ENOENT;
+}
+
+static struct ib_roce_gid_table *alloc_roce_gid_table(int sz)
+{
+	unsigned int i;
+	struct ib_roce_gid_table *table =
+		kzalloc(sizeof(struct ib_roce_gid_table), GFP_KERNEL);
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
+		seqcount_init(&table->data_vec[i].seq);
+
+	return table;
+
+err_free_table:
+	kfree(table);
+	return NULL;
+}
+
+static void free_roce_gid_table(struct ib_device *ib_dev, u8 port,
+				struct ib_roce_gid_table *table)
+{
+	int i;
+
+	if (!table)
+		return;
+
+	for (i = 0; i < table->sz; ++i) {
+		if (memcmp(&table->data_vec[i].gid, &zgid,
+			   sizeof(table->data_vec[i].gid)))
+			write_gid(ib_dev, port, table, i, &zgid, &zattr);
+	}
+	kfree(table->data_vec);
+	kfree(table);
+}
+
+static int roce_gid_table_setup_one(struct ib_device *ib_dev)
+{
+	u8 port;
+	struct ib_roce_gid_table **table;
+	int err = 0;
+
+	if (!ib_dev->modify_gid)
+		return -EOPNOTSUPP;
+
+	table = kcalloc(ib_dev->phys_port_cnt, sizeof(*table), GFP_KERNEL);
+
+	if (!table) {
+		pr_warn("failed to allocate roce addr table for %s\n",
+			ib_dev->name);
+		return -ENOMEM;
+	}
+
+	for (port = 0; port < ib_dev->phys_port_cnt; port++) {
+		uint8_t rdma_port = port + rdma_start_port(ib_dev);
+
+		if (!rdma_protocol_roce(ib_dev, rdma_port))
+			continue;
+		table[port] =
+			alloc_roce_gid_table(
+				ib_dev->port_immutable[rdma_port].gid_tbl_len);
+		if (!table[port]) {
+			err = -ENOMEM;
+			goto rollback_table_setup;
+		}
+	}
+
+	ib_dev->cache.roce_gid_table = table;
+	return 0;
+
+rollback_table_setup:
+	for (port = 1; port <= ib_dev->phys_port_cnt; port++)
+		free_roce_gid_table(ib_dev, port, table[port]);
+
+	kfree(table);
+	return err;
+}
+
+static void roce_gid_table_cleanup_one(struct ib_device *ib_dev,
+				       struct ib_roce_gid_table **table)
+{
+	u8 port;
+
+	if (!table)
+		return;
+
+	for (port = 0; port < ib_dev->phys_port_cnt; port++)
+		free_roce_gid_table(ib_dev, port + rdma_start_port(ib_dev),
+				    table[port]);
+
+	kfree(table);
+}
+
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 86c0c27..69ae464 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -93,8 +93,6 @@ static void init_query_mad(struct ib_smp *mad)
 	mad->method	   = IB_MGMT_METHOD_GET;
 }
 
-static union ib_gid zgid;
-
 static int check_flow_steering_support(struct mlx4_dev *dev)
 {
 	int eth_num_ports = 0;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 7d78794..72b62cd 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -64,6 +64,27 @@ union ib_gid {
 	} global;
 };
 
+extern union ib_gid zgid;
+
+struct ib_gid_attr {
+	struct net_device	*ndev;
+};
+
+struct ib_roce_gid_table_entry {
+	seqcount_t	    seq;
+	union ib_gid        gid;
+	struct ib_gid_attr  attr;
+	void		   *context;
+};
+
+struct ib_roce_gid_table {
+	int		     active;
+	int                  sz;
+	/* locking against multiple writes in data_vec */
+	struct mutex         lock;
+	struct ib_roce_gid_table_entry *data_vec;
+};
+
 enum rdma_node_type {
 	/* IB values map to NodeInfo:NodeType. */
 	RDMA_NODE_IB_CA 	= 1,
@@ -272,7 +293,8 @@ enum ib_port_cap_flags {
 	IB_PORT_BOOT_MGMT_SUP			= 1 << 23,
 	IB_PORT_LINK_LATENCY_SUP		= 1 << 24,
 	IB_PORT_CLIENT_REG_SUP			= 1 << 25,
-	IB_PORT_IP_BASED_GIDS			= 1 << 26
+	IB_PORT_IP_BASED_GIDS			= 1 << 26,
+	IB_PORT_ROCE				= 1 << 27,
 };
 
 enum ib_port_width {
@@ -1476,6 +1498,7 @@ struct ib_cache {
 	struct ib_pkey_cache  **pkey_cache;
 	struct ib_gid_cache   **gid_cache;
 	u8                     *lmc_cache;
+	struct ib_roce_gid_table **roce_gid_table;
 };
 
 struct ib_dma_mapping_ops {
@@ -1559,6 +1582,27 @@ struct ib_device {
 	int		           (*query_gid)(struct ib_device *device,
 						u8 port_num, int index,
 						union ib_gid *gid);
+	/* When calling modify_gid, the HW vendor's driver should
+	 * modify the gid of device @device at gid index @index of
+	 * port @port to be @gid. Meta-info of that gid (for example,
+	 * the network device related to this gid is available
+	 * at @attr. @context allows the HW vendor driver to store extra
+	 * information together with a GID entry. The HW vendor may allocate
+	 * memory to contain this information and store it in @context when a
+	 * new GID entry is written to. Upon the deletion of a GID entry,
+	 * the HW vendor must free any allocated memory. The caller will clear
+	 * @context afterwards.GID deletion is done by passing the zero gid.
+	 * Params are consistent until the next call of modify_gid.
+	 * The function should return 0 on success or error otherwise.
+	 * The function could be called concurrently for different ports.
+	 * This function is only called when roce_gid_table is used.
+	 */
+	int		           (*modify_gid)(struct ib_device *device,
+						 u8 port_num,
+						 unsigned int index,
+						 const union ib_gid *gid,
+						 const struct ib_gid_attr *attr,
+						 void **context);
 	int		           (*query_pkey)(struct ib_device *device,
 						 u8 port_num, u16 index, u16 *pkey);
 	int		           (*modify_device)(struct ib_device *device,
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
