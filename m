From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 01/30] IB/core: Add RoCE GID cache
Date: Fri, 20 Feb 2015 03:32:16 +0530
Message-ID: <eceb8ec5-7485-4c79-936d-26fb54f13ef9@CMEXHTCAS2.ad.emulex.com>
References: <1424383365-19337-1-git-send-email-somnath.kotur@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424383365-19337-1-git-send-email-somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In order to manage multiple types, vlans and MACs per GID, we
need to store them along the GID itself. We store the net device
as well, as sometimes GIDs should be handled according to the
net device they came from. Since populating the GID table should
be identical for every RoCE provider, the GIDs table should be
handled in ib_core.

Adding a GID cache table that supports a lockless find, add and
delete gids. The lockless nature comes from using a unique
sequence number per table entry and detecting that while reading/
writing this sequence wasn't changed.

By using this RoCE GID cache table, providers must implement a
modify_gid callback. The table is managed exclusively by
this roce_gid_cache and the provider just need to write
the data to the hardware.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/Makefile         |    3 +-
 drivers/infiniband/core/core_priv.h      |   24 ++
 drivers/infiniband/core/roce_gid_cache.c |  511 ++++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx4/main.c        |    2 -
 include/rdma/ib_verbs.h                  |   55 ++++-
 5 files changed, 591 insertions(+), 4 deletions(-)
 create mode 100644 drivers/infiniband/core/roce_gid_cache.c

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index acf7367..9b63bdf 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -9,7 +9,8 @@ obj-$(CONFIG_INFINIBAND_USER_ACCESS) +=	ib_uverbs.o ib_ucm.o \
 					$(user_access-y)
 
 ib_core-y :=			packer.o ud_header.o verbs.o sysfs.o \
-				device.o fmr_pool.o cache.o netlink.o
+				device.o fmr_pool.o cache.o netlink.o \
+				roce_gid_cache.o
 ib_core-$(CONFIG_INFINIBAND_USER_MEM) += umem.o
 ib_core-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) += umem_odp.o umem_rbtree.o
 
diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 87d1936..a502daa 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -35,6 +35,7 @@
 
 #include <linux/list.h>
 #include <linux/spinlock.h>
+#include <net/net_namespace.h>
 
 #include <rdma/ib_verbs.h>
 
@@ -51,4 +52,27 @@ void ib_cache_cleanup(void);
 
 int ib_resolve_eth_l2_attrs(struct ib_qp *qp,
 			    struct ib_qp_attr *qp_attr, int *qp_attr_mask);
+
+int roce_gid_cache_get_gid(struct ib_device *ib_dev, u8 port, int index,
+			   union ib_gid *gid, struct ib_gid_attr *attr);
+
+int roce_gid_cache_find_gid(struct ib_device *ib_dev, union ib_gid *gid,
+			    enum ib_gid_type gid_type, struct net *net,
+			    int if_index, u8 *port, u16 *index);
+
+int roce_gid_cache_find_gid_by_port(struct ib_device *ib_dev, union ib_gid *gid,
+				    enum ib_gid_type gid_type, u8 port,
+				    struct net *net, int if_index, u16 *index);
+
+int roce_gid_cache_is_active(struct ib_device *ib_dev, u8 port);
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
diff --git a/drivers/infiniband/core/roce_gid_cache.c b/drivers/infiniband/core/roce_gid_cache.c
new file mode 100644
index 0000000..8f6af4a
--- /dev/null
+++ b/drivers/infiniband/core/roce_gid_cache.c
@@ -0,0 +1,511 @@
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
+	GID_ATTR_FIND_MASK_GID_TYPE	= 1UL << 0,
+	GID_ATTR_FIND_MASK_NETDEV	= 1UL << 1,
+};
+
+static inline int start_port(struct ib_device *ib_dev)
+{
+	return (ib_dev->node_type == RDMA_NODE_IB_SWITCH) ? 0 : 1;
+}
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
+		     struct ib_roce_gid_cache *cache, int ix,
+		     const union ib_gid *gid,
+		     const struct ib_gid_attr *attr)
+{
+	unsigned int orig_seq;
+	int ret;
+	struct dev_put_rcu	*put_rcu;
+	struct net_device *old_net_dev;
+
+	orig_seq = cache->data_vec[ix].seq;
+	cache->data_vec[ix].seq = -1;
+	/* Ensure that all readers will see invalid sequence
+	 * identifier before starting the actual GID update.
+	 */
+	smp_wmb();
+
+	ret = ib_dev->modify_gid(ib_dev, port, ix, gid, attr,
+				 &cache->data_vec[ix].context);
+
+	old_net_dev = cache->data_vec[ix].attr.ndev;
+	if (old_net_dev && old_net_dev != attr->ndev) {
+		put_rcu = kmalloc(sizeof(*put_rcu), GFP_KERNEL);
+		if (put_rcu) {
+			put_rcu->ndev = old_net_dev;
+			call_rcu(&put_rcu->rcu, put_ndev);
+		} else {
+			pr_warn("roce_gid_cache: can't allocate rcu context, using synchronize\n");
+			synchronize_rcu();
+			dev_put(old_net_dev);
+		}
+	}
+	/* if modify_gid failed, just delete the old gid */
+	if (ret) {
+		gid = &zgid;
+		attr = &zattr;
+		cache->data_vec[ix].context = NULL;
+	}
+	memcpy(&cache->data_vec[ix].gid, gid, sizeof(*gid));
+	memcpy(&cache->data_vec[ix].attr, attr, sizeof(*attr));
+	if (cache->data_vec[ix].attr.ndev &&
+	    cache->data_vec[ix].attr.ndev != old_net_dev)
+		dev_hold(cache->data_vec[ix].attr.ndev);
+
+	/* Ensure that all cached gid data updating is finished before
+	 * marking the entry as available.
+	 */
+	smp_wmb();
+
+	if (++orig_seq == (unsigned int)-1)
+		orig_seq = 0;
+	ACCESS_ONCE(cache->data_vec[ix].seq) = orig_seq;
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
+static int find_gid(struct ib_roce_gid_cache *cache, union ib_gid *gid,
+		    const struct ib_gid_attr *val, unsigned long mask)
+{
+	int i;
+	unsigned int orig_seq;
+
+	for (i = 0; i < cache->sz; i++) {
+		struct ib_gid_attr *attr = &cache->data_vec[i].attr;
+
+		orig_seq = cache->data_vec[i].seq;
+		if (orig_seq == -1)
+			continue;
+		/* Make sure the sequence number we remeber was read
+		 * before the gid cache entry content is read.
+		 */
+		smp_rmb();
+
+		if (mask & GID_ATTR_FIND_MASK_GID_TYPE &&
+		    attr->gid_type != val->gid_type)
+			continue;
+
+		if (memcmp(gid, &cache->data_vec[i].gid, sizeof(*gid)))
+			continue;
+
+		if (mask & GID_ATTR_FIND_MASK_NETDEV &&
+		    attr->ndev != val->ndev)
+			continue;
+
+		/* We have a match, verify that the data we
+		 * compared is valid. Make sure that the
+		 * sequence number we read is the last to be
+		 * read.
+		 */
+		smp_rmb();
+		if (orig_seq == ACCESS_ONCE(cache->data_vec[i].seq))
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
+	struct ib_roce_gid_cache *cache;
+	int ix;
+	int ret = 0;
+
+	if (!ib_dev->cache.roce_gid_cache)
+		return -ENOSYS;
+
+	cache = ib_dev->cache.roce_gid_cache[port - start_port(ib_dev)];
+
+	if (!cache->active)
+		return -ENOSYS;
+
+	mutex_lock(&cache->lock);
+
+	ix = find_gid(cache, gid, attr, GID_ATTR_FIND_MASK_GID_TYPE |
+		      GID_ATTR_FIND_MASK_NETDEV);
+	if (ix >= 0)
+		goto out_unlock;
+
+	ix = find_gid(cache, &zgid, NULL, 0);
+	if (ix < 0) {
+		ret = -ENOSPC;
+		goto out_unlock;
+	}
+
+	write_gid(ib_dev, port, cache, ix, gid, attr);
+
+out_unlock:
+	mutex_unlock(&cache->lock);
+	return ret;
+}
+
+int roce_del_gid(struct ib_device *ib_dev, u8 port,
+		 union ib_gid *gid, struct ib_gid_attr *attr)
+{
+	struct ib_roce_gid_cache *cache;
+	int ix;
+
+	if (!ib_dev->cache.roce_gid_cache)
+		return 0;
+
+	cache  = ib_dev->cache.roce_gid_cache[port - start_port(ib_dev)];
+
+	if (!cache->active)
+		return -ENOSYS;
+
+	mutex_lock(&cache->lock);
+
+	ix = find_gid(cache, gid, attr,
+		      GID_ATTR_FIND_MASK_GID_TYPE |
+		      GID_ATTR_FIND_MASK_NETDEV);
+	if (ix < 0)
+		goto out_unlock;
+
+	write_gid(ib_dev, port, cache, ix, &zgid, &zattr);
+
+out_unlock:
+	mutex_unlock(&cache->lock);
+	return 0;
+}
+
+int roce_del_all_netdev_gids(struct ib_device *ib_dev, u8 port,
+			     struct net_device *ndev)
+{
+	struct ib_roce_gid_cache *cache;
+	int ix;
+
+	if (!ib_dev->cache.roce_gid_cache)
+		return 0;
+
+	cache  = ib_dev->cache.roce_gid_cache[port - start_port(ib_dev)];
+
+	if (!cache->active)
+		return -ENOSYS;
+
+	mutex_lock(&cache->lock);
+
+	for (ix = 0; ix < cache->sz; ix++)
+		if (cache->data_vec[ix].attr.ndev == ndev)
+			write_gid(ib_dev, port, cache, ix, &zgid, &zattr);
+
+	mutex_unlock(&cache->lock);
+	return 0;
+}
+
+int roce_gid_cache_get_gid(struct ib_device *ib_dev, u8 port, int index,
+			   union ib_gid *gid, struct ib_gid_attr *attr)
+{
+	struct ib_roce_gid_cache *cache;
+	union ib_gid local_gid;
+	struct ib_gid_attr local_attr;
+	unsigned int orig_seq;
+
+	if (!ib_dev->cache.roce_gid_cache)
+		return -EINVAL;
+
+	cache = ib_dev->cache.roce_gid_cache[port - start_port(ib_dev)];
+
+	if (!cache->active)
+		return -ENOSYS;
+
+	if (index < 0 || index >= cache->sz)
+		return -EINVAL;
+
+	orig_seq = ACCESS_ONCE(cache->data_vec[index].seq);
+	/* Make sure we read the sequence number before copying the
+	 * gid to local storage. */
+	smp_rmb();
+
+	memcpy(&local_gid, &cache->data_vec[index].gid, sizeof(local_gid));
+	memcpy(&local_attr, &cache->data_vec[index].attr, sizeof(local_attr));
+	/* Ensure the local copy completed reading before verifying
+	 * the new sequence number. */
+	smp_rmb();
+
+	if (orig_seq == -1 ||
+	    orig_seq != ACCESS_ONCE(cache->data_vec[index].seq))
+		return -EAGAIN;
+
+	memcpy(gid, &local_gid, sizeof(*gid));
+	if (attr)
+		memcpy(attr, &local_attr, sizeof(*attr));
+	return 0;
+}
+
+static int _roce_gid_cache_find_gid(struct ib_device *ib_dev, union ib_gid *gid,
+				    const struct ib_gid_attr *val,
+				    unsigned long mask,
+				    u8 *port, u16 *index)
+{
+	struct ib_roce_gid_cache *cache;
+	u8 p;
+	int local_index;
+
+	if (!ib_dev->cache.roce_gid_cache)
+		return -ENOENT;
+
+	for (p = 0; p < ib_dev->phys_port_cnt; p++) {
+		if (rdma_port_get_link_layer(ib_dev, p + start_port(ib_dev)) !=
+		    IB_LINK_LAYER_ETHERNET)
+			continue;
+		cache = ib_dev->cache.roce_gid_cache[p];
+		if (!cache->active)
+			continue;
+		local_index = find_gid(cache, gid, val, mask);
+		if (local_index >= 0) {
+			if (index)
+				*index = local_index;
+			if (port)
+				*port = p + start_port(ib_dev);
+			return 0;
+		}
+	}
+
+	return -ENOENT;
+}
+
+static int get_netdev_from_ifindex(struct net *net, int if_index,
+				   struct ib_gid_attr *gid_attr_val)
+{
+	if (if_index && net) {
+		rcu_read_lock();
+		gid_attr_val->ndev = dev_get_by_index_rcu(net, if_index);
+		rcu_read_unlock();
+		if (gid_attr_val->ndev)
+			return GID_ATTR_FIND_MASK_NETDEV;
+	}
+	return 0;
+}
+
+int roce_gid_cache_find_gid(struct ib_device *ib_dev, union ib_gid *gid,
+			    enum ib_gid_type gid_type, struct net *net,
+			    int if_index, u8 *port, u16 *index)
+{
+	unsigned long mask = GID_ATTR_FIND_MASK_GID_TYPE;
+	struct ib_gid_attr gid_attr_val = {.gid_type = gid_type};
+
+	mask |= get_netdev_from_ifindex(net, if_index, &gid_attr_val);
+
+	return _roce_gid_cache_find_gid(ib_dev, gid, &gid_attr_val,
+					mask, port, index);
+}
+
+int roce_gid_cache_find_gid_by_port(struct ib_device *ib_dev, union ib_gid *gid,
+				    enum ib_gid_type gid_type, u8 port,
+				    struct net *net, int if_index, u16 *index)
+{
+	int local_index;
+	struct ib_roce_gid_cache *cache;
+	unsigned long mask = GID_ATTR_FIND_MASK_GID_TYPE;
+	struct ib_gid_attr val = {.gid_type = gid_type};
+
+	if (!ib_dev->cache.roce_gid_cache || port < start_port(ib_dev) ||
+	    port >= (start_port(ib_dev) + ib_dev->phys_port_cnt))
+		return -ENOENT;
+
+	cache = ib_dev->cache.roce_gid_cache[port - start_port(ib_dev)];
+	if (!cache->active)
+		return -ENOENT;
+
+	mask |= get_netdev_from_ifindex(net, if_index, &val);
+
+	local_index = find_gid(cache, gid, &val, mask);
+	if (local_index >= 0) {
+		if (index)
+			*index = local_index;
+		return 0;
+	}
+
+	return -ENOENT;
+}
+
+static struct ib_roce_gid_cache *alloc_roce_gid_cache(int sz)
+{
+	struct ib_roce_gid_cache *cache =
+		kzalloc(sizeof(struct ib_roce_gid_cache), GFP_KERNEL);
+	if (!cache)
+		return NULL;
+
+	cache->data_vec = kcalloc(sz, sizeof(*cache->data_vec), GFP_KERNEL);
+	if (!cache->data_vec)
+		goto err_free_cache;
+
+	mutex_init(&cache->lock);
+
+	cache->sz = sz;
+
+	return cache;
+
+err_free_cache:
+	kfree(cache);
+	return NULL;
+}
+
+static void free_roce_gid_cache(struct ib_roce_gid_cache *cache)
+{
+	int i;
+
+	if (!cache)
+		return;
+
+	for (i = 0; i < cache->sz; ++i) {
+		if (cache->data_vec[i].attr.ndev)
+			dev_put(cache->data_vec[i].attr.ndev);
+	}
+	kfree(cache->data_vec);
+	kfree(cache);
+}
+
+static void set_roce_gid_cache_active(struct ib_roce_gid_cache *cache,
+				      int active)
+{
+	if (!cache)
+		return;
+
+	cache->active = active;
+}
+
+static int roce_gid_cache_setup_one(struct ib_device *ib_dev)
+{
+	u8 port;
+	int err = 0;
+
+	if (!ib_dev->modify_gid)
+		return -ENOSYS;
+
+	ib_dev->cache.roce_gid_cache =
+		kcalloc(ib_dev->phys_port_cnt,
+			sizeof(*ib_dev->cache.roce_gid_cache), GFP_KERNEL);
+
+	if (!ib_dev->cache.roce_gid_cache) {
+		pr_warn("failed to allocate roce addr cache for %s\n",
+			ib_dev->name);
+		return -ENOMEM;
+	}
+
+	for (port = 0; port < ib_dev->phys_port_cnt; port++) {
+		if (rdma_port_get_link_layer(ib_dev, port + start_port(ib_dev))
+		    != IB_LINK_LAYER_ETHERNET)
+			continue;
+		ib_dev->cache.roce_gid_cache[port] =
+			alloc_roce_gid_cache(ib_dev->gid_tbl_len[port]);
+		if (!ib_dev->cache.roce_gid_cache[port]) {
+			err = -ENOMEM;
+			goto rollback_cache_setup;
+		}
+	}
+	return 0;
+
+rollback_cache_setup:
+	for (port = 0; port < ib_dev->phys_port_cnt; port++)
+		free_roce_gid_cache(ib_dev->cache.roce_gid_cache[port]);
+
+	kfree(ib_dev->cache.roce_gid_cache);
+	ib_dev->cache.roce_gid_cache = NULL;
+	return err;
+}
+
+static void roce_gid_cache_cleanup_one(struct ib_device *ib_dev)
+{
+	u8 port;
+
+	if (!ib_dev->cache.roce_gid_cache)
+		return;
+
+	for (port = 0; port < ib_dev->phys_port_cnt; port++)
+		free_roce_gid_cache(ib_dev->cache.roce_gid_cache[port]);
+
+	kfree(ib_dev->cache.roce_gid_cache);
+	ib_dev->cache.roce_gid_cache = NULL;
+}
+
+static void roce_gid_cache_set_active_state(struct ib_device *ib_dev,
+					    int active)
+{
+	u8 port;
+
+	if (!ib_dev->cache.roce_gid_cache)
+		return;
+
+	for (port = 0; port < ib_dev->phys_port_cnt; port++)
+		set_roce_gid_cache_active(ib_dev->cache.roce_gid_cache[port],
+					  active);
+}
+
+int roce_gid_cache_is_active(struct ib_device *ib_dev, u8 port)
+{
+	return ib_dev->cache.roce_gid_cache &&
+		ib_dev->cache.roce_gid_cache[port - start_port(ib_dev)]->active;
+}
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 5261665..6fa5e49 100644
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
index 65994a1..1866595 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -64,6 +64,36 @@ union ib_gid {
 	} global;
 };
 
+extern union ib_gid zgid;
+
+enum ib_gid_type {
+	/* If link layer is Ethernet, this is RoCE V1 */
+	IB_GID_TYPE_IB        = 0,
+	IB_GID_TYPE_ROCE_V2   = 1,
+	IB_GID_TYPE_SIZE
+};
+
+struct ib_gid_attr {
+	enum ib_gid_type	gid_type;
+	struct net_device	*ndev;
+};
+
+struct ib_roce_gid_cache_entry {
+	/* seq number of 0 indicates entry being changed. */
+	unsigned int        seq;
+	union ib_gid        gid;
+	struct ib_gid_attr  attr;
+	void		   *context;
+};
+
+struct ib_roce_gid_cache {
+	int		     active;
+	int                  sz;
+	/* locking against multiple writes in data_vec */
+	struct mutex         lock;
+	struct ib_roce_gid_cache_entry *data_vec;
+};
+
 enum rdma_node_type {
 	/* IB values map to NodeInfo:NodeType. */
 	RDMA_NODE_IB_CA 	= 1,
@@ -265,7 +295,9 @@ enum ib_port_cap_flags {
 	IB_PORT_BOOT_MGMT_SUP			= 1 << 23,
 	IB_PORT_LINK_LATENCY_SUP		= 1 << 24,
 	IB_PORT_CLIENT_REG_SUP			= 1 << 25,
-	IB_PORT_IP_BASED_GIDS			= 1 << 26
+	IB_PORT_IP_BASED_GIDS			= 1 << 26,
+	IB_PORT_ROCE				= 1 << 27,
+	IB_PORT_ROCE_V2				= 1 << 28,
 };
 
 enum ib_port_width {
@@ -1431,6 +1463,7 @@ struct ib_cache {
 	struct ib_pkey_cache  **pkey_cache;
 	struct ib_gid_cache   **gid_cache;
 	u8                     *lmc_cache;
+	struct ib_roce_gid_cache **roce_gid_cache;
 };
 
 struct ib_dma_mapping_ops {
@@ -1506,6 +1539,26 @@ struct ib_device {
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
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
