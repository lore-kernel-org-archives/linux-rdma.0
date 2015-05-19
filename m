From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v4 for-next 04/14] IB/core: Add default GID for RoCE GID table
Date: Tue, 19 May 2015 17:27:07 +0300
Message-ID: <1432045637-9090-5-git-send-email-matanb@mellanox.com>
References: <1432045637-9090-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432045637-9090-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When RoCE is used, a default GID address should be generated
for every supported RoCE type. These default GID addresses are
generated based on the IPv6 link-local address, but in contrast
to the GID based on the regular IPv6 link-local (as we generate
GID per IP address), these GIDs are also available if the net
device is down (in order to support loopback).
Moreover, these default GID addresses can't be deleted.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/core_priv.h      |  12 ++
 drivers/infiniband/core/roce_gid_mgmt.c  |  43 ++++++--
 drivers/infiniband/core/roce_gid_table.c | 182 ++++++++++++++++++++++++++++---
 include/net/addrconf.h                   |  31 ++++++
 include/rdma/ib_verbs.h                  |   1 +
 net/ipv6/addrconf.c                      |  31 ------
 6 files changed, 248 insertions(+), 52 deletions(-)

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index eb094f6..0383643 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -82,6 +82,16 @@ int roce_gid_table_find_gid_by_port(struct ib_device *ib_dev, union ib_gid *gid,
 				    enum ib_gid_type gid_type, u8 port,
 				    struct net *net, int if_index, u16 *index);
 
+enum roce_gid_table_default_mode {
+	ROCE_GID_TABLE_DEFAULT_MODE_SET,
+	ROCE_GID_TABLE_DEFAULT_MODE_DELETE
+};
+
+void roce_gid_table_set_default_gid(struct ib_device *ib_dev, u8 port,
+				    struct net_device *ndev,
+				    unsigned long gid_type_mask,
+				    enum roce_gid_table_default_mode mode);
+
 int roce_gid_table_setup(void);
 void roce_gid_table_cleanup(void);
 
@@ -98,5 +108,7 @@ int roce_gid_mgmt_init(void);
 void roce_gid_mgmt_cleanup(void);
 
 int roce_rescan_device(struct ib_device *ib_dev);
+unsigned long roce_gid_type_mask_support(struct ib_device *ib_dev, u8 port);
+
 
 #endif /* _CORE_PRIV_H */
diff --git a/drivers/infiniband/core/roce_gid_mgmt.c b/drivers/infiniband/core/roce_gid_mgmt.c
index 9aff044..0912934 100644
--- a/drivers/infiniband/core/roce_gid_mgmt.c
+++ b/drivers/infiniband/core/roce_gid_mgmt.c
@@ -76,24 +76,37 @@ static const struct {
 
 #define CAP_TO_GID_TABLE_SIZE	ARRAY_SIZE(PORT_CAP_TO_GID_TYPE)
 
-static void update_gid(enum gid_op_type gid_op, struct ib_device *ib_dev,
-		       u8 port, union ib_gid *gid,
-		       struct ib_gid_attr *gid_attr)
+unsigned long roce_gid_type_mask_support(struct ib_device *ib_dev, u8 port)
 {
 	struct ib_port_attr pattr;
 	int i;
 	int err;
+	unsigned int ret_flags = 0;
 
 	err = ib_query_port(ib_dev, port, &pattr);
 	if (err) {
 		pr_warn("update_gid: ib_query_port() failed for %s, %d\n",
 			ib_dev->name, err);
+		return 0;
 	}
 
-	for (i = 0; i < CAP_TO_GID_TABLE_SIZE; i++) {
-		if (pattr.port_cap_flags & PORT_CAP_TO_GID_TYPE[i].flag_mask) {
-			gid_attr->gid_type =
-				PORT_CAP_TO_GID_TYPE[i].gid_type;
+	for (i = 0; i < CAP_TO_GID_TABLE_SIZE; i++)
+		if (pattr.port_cap_flags & PORT_CAP_TO_GID_TYPE[i].flag_mask)
+			ret_flags |= 1UL << PORT_CAP_TO_GID_TYPE[i].gid_type;
+
+	return ret_flags;
+}
+
+static void update_gid(enum gid_op_type gid_op, struct ib_device *ib_dev,
+		       u8 port, union ib_gid *gid,
+		       struct ib_gid_attr *gid_attr)
+{
+	int i;
+	unsigned long gid_type_mask = roce_gid_type_mask_support(ib_dev, port);
+
+	for (i = 0; i < IB_GID_TYPE_SIZE; i++) {
+		if ((1UL << i) & gid_type_mask) {
+			gid_attr->gid_type = i;
 			switch (gid_op) {
 			case GID_ADD:
 				roce_add_gid(ib_dev, port,
@@ -147,6 +160,21 @@ static void update_gid_ip(enum gid_op_type gid_op,
 	update_gid(gid_op, ib_dev, port, &gid, &gid_attr);
 }
 
+static void enum_netdev_default_gids(struct ib_device *ib_dev,
+				     u8 port, struct net_device *ndev,
+				     struct net_device *idev)
+{
+	unsigned long gid_type_mask;
+
+	if (idev != ndev)
+		return;
+
+	gid_type_mask = roce_gid_type_mask_support(ib_dev, port);
+
+	roce_gid_table_set_default_gid(ib_dev, port, idev, gid_type_mask,
+				       ROCE_GID_TABLE_DEFAULT_MODE_SET);
+}
+
 static void enum_netdev_ipv4_ips(struct ib_device *ib_dev,
 				 u8 port, struct net_device *ndev)
 {
@@ -227,6 +255,7 @@ static void add_netdev_ips(struct ib_device *ib_dev, u8 port,
 {
 	struct net_device *ndev = (struct net_device *)cookie;
 
+	enum_netdev_default_gids(ib_dev, port, ndev, idev);
 	enum_netdev_ipv4_ips(ib_dev, port, ndev);
 #if IS_ENABLED(CONFIG_IPV6)
 	enum_netdev_ipv6_ips(ib_dev, port, ndev);
diff --git a/drivers/infiniband/core/roce_gid_table.c b/drivers/infiniband/core/roce_gid_table.c
index d5d3ca6..5692bb8 100644
--- a/drivers/infiniband/core/roce_gid_table.c
+++ b/drivers/infiniband/core/roce_gid_table.c
@@ -34,6 +34,7 @@
 #include <linux/netdevice.h>
 #include <linux/rtnetlink.h>
 #include <rdma/ib_cache.h>
+#include <net/addrconf.h>
 
 #include "core_priv.h"
 
@@ -46,6 +47,7 @@ enum gid_attr_find_mask {
 	GID_ATTR_FIND_MASK_GID          = 1UL << 0,
 	GID_ATTR_FIND_MASK_GID_TYPE	= 1UL << 1,
 	GID_ATTR_FIND_MASK_NETDEV	= 1UL << 2,
+	GID_ATTR_FIND_MASK_DEFAULT	= 1UL << 3,
 };
 
 static inline int start_port(struct ib_device *ib_dev)
@@ -70,7 +72,8 @@ static void put_ndev(struct rcu_head *rcu)
 static int write_gid(struct ib_device *ib_dev, u8 port,
 		     struct ib_roce_gid_table *table, int ix,
 		     const union ib_gid *gid,
-		     const struct ib_gid_attr *attr)
+		     const struct ib_gid_attr *attr,
+		     bool  default_gid)
 {
 	int ret;
 	struct dev_put_rcu	*put_rcu;
@@ -78,6 +81,7 @@ static int write_gid(struct ib_device *ib_dev, u8 port,
 
 	write_seqcount_begin(&table->data_vec[ix].seq);
 
+	table->data_vec[ix].default_gid = default_gid;
 	ret = ib_dev->modify_gid(ib_dev, port, ix, gid, attr,
 				 &table->data_vec[ix].context);
 
@@ -120,7 +124,8 @@ static int write_gid(struct ib_device *ib_dev, u8 port,
 }
 
 static int find_gid(struct ib_roce_gid_table *table, union ib_gid *gid,
-		    const struct ib_gid_attr *val, unsigned long mask)
+		    const struct ib_gid_attr *val, bool default_gid,
+		    unsigned long mask)
 {
 	int i;
 
@@ -132,13 +137,18 @@ static int find_gid(struct ib_roce_gid_table *table, union ib_gid *gid,
 		    attr->gid_type != val->gid_type)
 			continue;
 
-		if (memcmp(gid, &table->data_vec[i].gid, sizeof(*gid)))
+		if (mask & GID_ATTR_FIND_MASK_GID &&
+		    memcmp(gid, &table->data_vec[i].gid, sizeof(*gid)))
 			continue;
 
 		if (mask & GID_ATTR_FIND_MASK_NETDEV &&
 		    attr->ndev != val->ndev)
 			continue;
 
+		if (mask & GID_ATTR_FIND_MASK_DEFAULT &&
+		    table->data_vec[i].default_gid != default_gid)
+			continue;
+
 		if (!read_seqcount_retry(&table->data_vec[i].seq, orig_seq))
 			return i;
 		/* The sequence number changed under our feet,
@@ -150,6 +160,12 @@ static int find_gid(struct ib_roce_gid_table *table, union ib_gid *gid,
 	return -1;
 }
 
+static void make_default_gid(struct  net_device *dev, union ib_gid *gid)
+{
+	gid->global.subnet_prefix = cpu_to_be64(0xfe80000000000000LL);
+	addrconf_ifid_eui48(&gid->raw[8], dev);
+}
+
 int roce_add_gid(struct ib_device *ib_dev, u8 port,
 		 union ib_gid *gid, struct ib_gid_attr *attr)
 {
@@ -158,6 +174,7 @@ int roce_add_gid(struct ib_device *ib_dev, u8 port,
 	struct ib_roce_gid_table *table;
 	int ix;
 	int ret = 0;
+	struct net_device *idev;
 
 	/* make sure we read the ports_table */
 	smp_rmb();
@@ -173,20 +190,38 @@ int roce_add_gid(struct ib_device *ib_dev, u8 port,
 	if (!memcmp(gid, &zgid, sizeof(*gid)))
 		return -EINVAL;
 
+	if (ib_dev->get_netdev) {
+		rcu_read_lock();
+		idev = ib_dev->get_netdev(ib_dev, port);
+		if (idev && attr->ndev != idev) {
+			union ib_gid default_gid;
+
+			/* Adding default GIDs in not permitted */
+			make_default_gid(idev, &default_gid);
+			if (!memcmp(gid, &default_gid, sizeof(*gid))) {
+				rcu_read_unlock();
+				return -EPERM;
+			}
+		}
+		rcu_read_unlock();
+	}
+
 	mutex_lock(&table->lock);
 
-	ix = find_gid(table, gid, attr, GID_ATTR_FIND_MASK_GID_TYPE |
+	ix = find_gid(table, gid, attr, false, GID_ATTR_FIND_MASK_GID |
+		      GID_ATTR_FIND_MASK_GID_TYPE |
 		      GID_ATTR_FIND_MASK_NETDEV);
 	if (ix >= 0)
 		goto out_unlock;
 
-	ix = find_gid(table, &zgid, NULL, 0);
+	ix = find_gid(table, &zgid, NULL, false, GID_ATTR_FIND_MASK_GID |
+		      GID_ATTR_FIND_MASK_DEFAULT);
 	if (ix < 0) {
 		ret = -ENOSPC;
 		goto out_unlock;
 	}
 
-	write_gid(ib_dev, port, table, ix, gid, attr);
+	write_gid(ib_dev, port, table, ix, gid, attr, false);
 
 out_unlock:
 	mutex_unlock(&table->lock);
@@ -199,6 +234,7 @@ int roce_del_gid(struct ib_device *ib_dev, u8 port,
 	struct ib_roce_gid_table **ports_table =
 		READ_ONCE(ib_dev->cache.roce_gid_table);
 	struct ib_roce_gid_table *table;
+	union ib_gid default_gid;
 	int ix;
 
 	/* make sure we read the ports_table */
@@ -212,15 +248,24 @@ int roce_del_gid(struct ib_device *ib_dev, u8 port,
 	if (!table)
 		return -EPROTONOSUPPORT;
 
+	if (attr->ndev) {
+		/* Deleting default GIDs in not permitted */
+		make_default_gid(attr->ndev, &default_gid);
+		if (!memcmp(gid, &default_gid, sizeof(*gid)))
+			return -EPERM;
+	}
+
 	mutex_lock(&table->lock);
 
-	ix = find_gid(table, gid, attr,
+	ix = find_gid(table, gid, attr, false,
+		      GID_ATTR_FIND_MASK_GID	  |
 		      GID_ATTR_FIND_MASK_GID_TYPE |
-		      GID_ATTR_FIND_MASK_NETDEV);
+		      GID_ATTR_FIND_MASK_NETDEV	  |
+		      GID_ATTR_FIND_MASK_DEFAULT);
 	if (ix < 0)
 		goto out_unlock;
 
-	write_gid(ib_dev, port, table, ix, &zgid, &zattr);
+	write_gid(ib_dev, port, table, ix, &zgid, &zattr, false);
 
 out_unlock:
 	mutex_unlock(&table->lock);
@@ -250,7 +295,7 @@ int roce_del_all_netdev_gids(struct ib_device *ib_dev, u8 port,
 
 	for (ix = 0; ix < table->sz; ix++)
 		if (table->data_vec[ix].attr.ndev == ndev)
-			write_gid(ib_dev, port, table, ix, &zgid, &zattr);
+			write_gid(ib_dev, port, table, ix, &zgid, &zattr, false);
 
 	mutex_unlock(&table->lock);
 	return 0;
@@ -318,7 +363,7 @@ static int _roce_gid_table_find_gid(struct ib_device *ib_dev, union ib_gid *gid,
 		table = ports_table[p];
 		if (!table)
 			continue;
-		local_index = find_gid(table, gid, val, mask);
+		local_index = find_gid(table, gid, val, false, mask);
 		if (local_index >= 0) {
 			if (index)
 				*index = local_index;
@@ -366,7 +411,8 @@ int roce_gid_table_find_gid_by_port(struct ib_device *ib_dev, union ib_gid *gid,
 	struct ib_roce_gid_table **ports_table =
 		READ_ONCE(ib_dev->cache.roce_gid_table);
 	struct ib_roce_gid_table *table;
-	unsigned long mask = GID_ATTR_FIND_MASK_GID_TYPE;
+	unsigned long mask = GID_ATTR_FIND_MASK_GID |
+			     GID_ATTR_FIND_MASK_GID_TYPE;
 	struct ib_gid_attr val = {.gid_type = gid_type};
 
 	/* make sure we read the ports_table */
@@ -382,7 +428,7 @@ int roce_gid_table_find_gid_by_port(struct ib_device *ib_dev, union ib_gid *gid,
 
 	mask |= get_netdev_from_ifindex(net, if_index, &val);
 
-	local_index = find_gid(table, gid, &val, mask);
+	local_index = find_gid(table, gid, &val, false, mask);
 	if (local_index >= 0) {
 		if (index)
 			*index = local_index;
@@ -429,12 +475,114 @@ static void free_roce_gid_table(struct ib_device *ib_dev, u8 port,
 	for (i = 0; i < table->sz; ++i) {
 		if (memcmp(&table->data_vec[i].gid, &zgid,
 			   sizeof(table->data_vec[i].gid)))
-			write_gid(ib_dev, port, table, i, &zgid, &zattr);
+			write_gid(ib_dev, port, table, i, &zgid, &zattr,
+				  table->data_vec[i].default_gid);
 	}
 	kfree(table->data_vec);
 	kfree(table);
 }
 
+void roce_gid_table_set_default_gid(struct ib_device *ib_dev, u8 port,
+				    struct net_device *ndev,
+				    unsigned long gid_type_mask,
+				    enum roce_gid_table_default_mode mode)
+{
+	struct ib_roce_gid_table **ports_table =
+		READ_ONCE(ib_dev->cache.roce_gid_table);
+	union ib_gid gid;
+	struct ib_gid_attr gid_attr;
+	struct ib_gid_attr zattr_type = zattr;
+	struct ib_roce_gid_table *table;
+	unsigned int gid_type;
+
+	/* make sure we read the ports_table */
+	smp_rmb();
+
+	if (!ports_table)
+		return;
+
+	table  = ports_table[port - start_port(ib_dev)];
+
+	if (!table)
+		return;
+
+	make_default_gid(ndev, &gid);
+	memset(&gid_attr, 0, sizeof(gid_attr));
+	gid_attr.ndev = ndev;
+	for (gid_type = 0; gid_type < IB_GID_TYPE_SIZE; ++gid_type) {
+		int ix;
+		union ib_gid current_gid;
+		struct ib_gid_attr current_gid_attr;
+
+		if (1UL << gid_type & ~gid_type_mask)
+			continue;
+
+		gid_attr.gid_type = gid_type;
+
+		ix = find_gid(table, &gid, &gid_attr, true,
+			      GID_ATTR_FIND_MASK_GID_TYPE |
+			      GID_ATTR_FIND_MASK_DEFAULT);
+
+		if (ix < 0) {
+			pr_warn("roce_gid_table: couldn't find index for default gid type %u\n",
+				gid_type);
+			continue;
+		}
+
+		zattr_type.gid_type = gid_type;
+
+		mutex_lock(&table->lock);
+		if (!roce_gid_table_get_gid(ib_dev, port, ix,
+					    &current_gid, &current_gid_attr) &&
+		    mode == ROCE_GID_TABLE_DEFAULT_MODE_SET &&
+		    !memcmp(&gid, &current_gid, sizeof(gid)) &&
+		    !memcmp(&gid_attr, &current_gid_attr, sizeof(gid_attr))) {
+			mutex_unlock(&table->lock);
+			continue;
+		}
+
+		if ((memcmp(&current_gid, &zgid, sizeof(current_gid)) ||
+		     memcmp(&current_gid_attr, &zattr_type,
+			    sizeof(current_gid_attr))) &&
+		    write_gid(ib_dev, port, table, ix, &zgid, &zattr, true)) {
+			pr_warn("roce_gid_table: can't delete index %d for default gid %pI6\n",
+				ix, gid.raw);
+			mutex_unlock(&table->lock);
+			continue;
+		}
+
+		if (mode == ROCE_GID_TABLE_DEFAULT_MODE_SET)
+			if (write_gid(ib_dev, port, table, ix, &gid, &gid_attr,
+				      true))
+				pr_warn("roce_gid_table: unable to add default gid %pI6\n",
+					gid.raw);
+
+		mutex_unlock(&table->lock);
+	}
+}
+
+static int roce_gid_table_reserve_default(struct ib_device *ib_dev, u8 port,
+					  struct ib_roce_gid_table *table)
+{
+	unsigned int i;
+	unsigned long roce_gid_type_mask;
+	unsigned int num_default_gids;
+
+	roce_gid_type_mask = roce_gid_type_mask_support(ib_dev, port);
+	num_default_gids = hweight_long(roce_gid_type_mask);
+	for (i = 0; i < num_default_gids && i < table->sz; i++) {
+		struct ib_roce_gid_table_entry *entry =
+			&table->data_vec[i];
+
+		entry->default_gid = true;
+		entry->attr.gid_type = find_next_bit(&roce_gid_type_mask,
+						     BITS_PER_LONG,
+						     i);
+	}
+
+	return 0;
+}
+
 static int roce_gid_table_setup_one(struct ib_device *ib_dev)
 {
 	u8 port;
@@ -462,6 +610,12 @@ static int roce_gid_table_setup_one(struct ib_device *ib_dev)
 			err = -ENOMEM;
 			goto rollback_table_setup;
 		}
+
+		err = roce_gid_table_reserve_default(ib_dev,
+						     port + start_port(ib_dev),
+						     table[port]);
+		if (err)
+			goto rollback_table_setup;
 	}
 
 	ib_dev->cache.roce_gid_table = table;
diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index 80456f7..89890e7 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -91,6 +91,37 @@ int ipv6_rcv_saddr_equal(const struct sock *sk, const struct sock *sk2);
 void addrconf_join_solict(struct net_device *dev, const struct in6_addr *addr);
 void addrconf_leave_solict(struct inet6_dev *idev, const struct in6_addr *addr);
 
+static inline int addrconf_ifid_eui48(u8 *eui, struct net_device *dev)
+{
+	if (dev->addr_len != ETH_ALEN)
+		return -1;
+	memcpy(eui, dev->dev_addr, 3);
+	memcpy(eui + 5, dev->dev_addr + 3, 3);
+
+	/*
+	 * The zSeries OSA network cards can be shared among various
+	 * OS instances, but the OSA cards have only one MAC address.
+	 * This leads to duplicate address conflicts in conjunction
+	 * with IPv6 if more than one instance uses the same card.
+	 *
+	 * The driver for these cards can deliver a unique 16-bit
+	 * identifier for each instance sharing the same card.  It is
+	 * placed instead of 0xFFFE in the interface identifier.  The
+	 * "u" bit of the interface identifier is not inverted in this
+	 * case.  Hence the resulting interface identifier has local
+	 * scope according to RFC2373.
+	 */
+	if (dev->dev_id) {
+		eui[3] = (dev->dev_id >> 8) & 0xFF;
+		eui[4] = dev->dev_id & 0xFF;
+	} else {
+		eui[3] = 0xFF;
+		eui[4] = 0xFE;
+		eui[0] ^= 2;
+	}
+	return 0;
+}
+
 static inline unsigned long addrconf_timeout_fixup(u32 timeout,
 						   unsigned int unit)
 {
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 3554e32..f9afa91 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -83,6 +83,7 @@ struct ib_roce_gid_table_entry {
 	union ib_gid        gid;
 	struct ib_gid_attr  attr;
 	void		   *context;
+	bool		    default_gid;
 };
 
 struct ib_roce_gid_table {
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 37b70e8..7170c7b 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1845,37 +1845,6 @@ static void addrconf_leave_anycast(struct inet6_ifaddr *ifp)
 	__ipv6_dev_ac_dec(ifp->idev, &addr);
 }
 
-static int addrconf_ifid_eui48(u8 *eui, struct net_device *dev)
-{
-	if (dev->addr_len != ETH_ALEN)
-		return -1;
-	memcpy(eui, dev->dev_addr, 3);
-	memcpy(eui + 5, dev->dev_addr + 3, 3);
-
-	/*
-	 * The zSeries OSA network cards can be shared among various
-	 * OS instances, but the OSA cards have only one MAC address.
-	 * This leads to duplicate address conflicts in conjunction
-	 * with IPv6 if more than one instance uses the same card.
-	 *
-	 * The driver for these cards can deliver a unique 16-bit
-	 * identifier for each instance sharing the same card.  It is
-	 * placed instead of 0xFFFE in the interface identifier.  The
-	 * "u" bit of the interface identifier is not inverted in this
-	 * case.  Hence the resulting interface identifier has local
-	 * scope according to RFC2373.
-	 */
-	if (dev->dev_id) {
-		eui[3] = (dev->dev_id >> 8) & 0xFF;
-		eui[4] = dev->dev_id & 0xFF;
-	} else {
-		eui[3] = 0xFF;
-		eui[4] = 0xFE;
-		eui[0] ^= 2;
-	}
-	return 0;
-}
-
 static int addrconf_ifid_eui64(u8 *eui, struct net_device *dev)
 {
 	if (dev->addr_len != IEEE802154_ADDR_LEN)
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
