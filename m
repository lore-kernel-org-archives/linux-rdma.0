From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V5 05/12] IB/core: Add default GID for RoCE GID table
Date: Mon,  8 Jun 2015 17:12:08 +0300
Message-ID: <1433772735-22416-6-git-send-email-matanb@mellanox.com>
References: <1433772735-22416-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433772735-22416-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-xCNTGe7nOvUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
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
 drivers/infiniband/core/core_priv.h      |  12 +++
 drivers/infiniband/core/roce_gid_mgmt.c  |  25 ++++-
 drivers/infiniband/core/roce_gid_table.c | 162 ++++++++++++++++++++++++++++---
 include/rdma/ib_verbs.h                  |   1 +
 4 files changed, 185 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index eab4e6c..8da7a86 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -83,6 +83,16 @@ int roce_gid_table_find_gid_by_port(struct ib_device *ib_dev,
 				    u8 port, struct net_device *ndev,
 				    u16 *index);
 
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
 
@@ -99,5 +109,7 @@ int roce_gid_mgmt_init(void);
 void roce_gid_mgmt_cleanup(void);
 
 int roce_rescan_device(struct ib_device *ib_dev);
+unsigned long roce_gid_type_mask_support(struct ib_device *ib_dev, u8 port);
+
 
 #endif /* _CORE_PRIV_H */
diff --git a/drivers/infiniband/core/roce_gid_mgmt.c b/drivers/infiniband/core/roce_gid_mgmt.c
index 70616fc..6dcd1c7 100644
--- a/drivers/infiniband/core/roce_gid_mgmt.c
+++ b/drivers/infiniband/core/roce_gid_mgmt.c
@@ -67,11 +67,18 @@ struct netdev_event_work {
 	struct net_device		*ndev;
 };
 
+unsigned long roce_gid_type_mask_support(struct ib_device *ib_dev, u8 port)
+{
+	return !!rdma_protocol_roce(ib_dev, port);
+}
+
 static void update_gid(enum gid_op_type gid_op, struct ib_device *ib_dev,
 		       u8 port, union ib_gid *gid,
 		       struct ib_gid_attr *gid_attr)
 {
-	if (rdma_protocol_roce(ib_dev, port)) {
+	unsigned long gid_type_mask = roce_gid_type_mask_support(ib_dev, port);
+
+	if (gid_type_mask) {
 		switch (gid_op) {
 		case GID_ADD:
 			roce_add_gid(ib_dev, port,
@@ -124,6 +131,21 @@ static void update_gid_ip(enum gid_op_type gid_op,
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
@@ -204,6 +226,7 @@ static void add_netdev_ips(struct ib_device *ib_dev, u8 port,
 {
 	struct net_device *ndev = (struct net_device *)cookie;
 
+	enum_netdev_default_gids(ib_dev, port, ndev, idev);
 	enum_netdev_ipv4_ips(ib_dev, port, ndev);
 #if IS_ENABLED(CONFIG_IPV6)
 	enum_netdev_ipv6_ips(ib_dev, port, ndev);
diff --git a/drivers/infiniband/core/roce_gid_table.c b/drivers/infiniband/core/roce_gid_table.c
index 5e9e4dc..f0e68dc 100644
--- a/drivers/infiniband/core/roce_gid_table.c
+++ b/drivers/infiniband/core/roce_gid_table.c
@@ -34,6 +34,7 @@
 #include <linux/netdevice.h>
 #include <linux/rtnetlink.h>
 #include <rdma/ib_cache.h>
+#include <net/addrconf.h>
 
 #include "core_priv.h"
 
@@ -45,6 +46,7 @@ static const struct ib_gid_attr zattr;
 enum gid_attr_find_mask {
 	GID_ATTR_FIND_MASK_GID          = 1UL << 0,
 	GID_ATTR_FIND_MASK_NETDEV	= 1UL << 1,
+	GID_ATTR_FIND_MASK_DEFAULT	= 1UL << 2,
 };
 
 struct dev_put_rcu {
@@ -64,7 +66,8 @@ static void put_ndev(struct rcu_head *rcu)
 static int write_gid(struct ib_device *ib_dev, u8 port,
 		     struct ib_roce_gid_table *table, int ix,
 		     const union ib_gid *gid,
-		     const struct ib_gid_attr *attr)
+		     const struct ib_gid_attr *attr,
+		     bool  default_gid)
 {
 	int ret;
 	struct dev_put_rcu	*put_rcu;
@@ -72,6 +75,7 @@ static int write_gid(struct ib_device *ib_dev, u8 port,
 
 	write_seqcount_begin(&table->data_vec[ix].seq);
 
+	table->data_vec[ix].default_gid = default_gid;
 	ret = ib_dev->modify_gid(ib_dev, port, ix, gid, attr,
 				 &table->data_vec[ix].context);
 
@@ -114,7 +118,8 @@ static int write_gid(struct ib_device *ib_dev, u8 port,
 }
 
 static int find_gid(struct ib_roce_gid_table *table, const union ib_gid *gid,
-		    const struct ib_gid_attr *val, unsigned long mask)
+		    const struct ib_gid_attr *val, bool default_gid,
+		    unsigned long mask)
 {
 	int i;
 
@@ -122,13 +127,18 @@ static int find_gid(struct ib_roce_gid_table *table, const union ib_gid *gid,
 		struct ib_gid_attr *attr = &table->data_vec[i].attr;
 		unsigned int orig_seq = read_seqcount_begin(&table->data_vec[i].seq);
 
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
@@ -140,6 +150,12 @@ static int find_gid(struct ib_roce_gid_table *table, const union ib_gid *gid,
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
@@ -148,6 +164,7 @@ int roce_add_gid(struct ib_device *ib_dev, u8 port,
 	struct ib_roce_gid_table *table;
 	int ix;
 	int ret = 0;
+	struct net_device *idev;
 
 	/* make sure we read the ports_table */
 	smp_rmb();
@@ -163,19 +180,37 @@ int roce_add_gid(struct ib_device *ib_dev, u8 port,
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
 
-	ix = find_gid(table, gid, attr, GID_ATTR_FIND_MASK_NETDEV);
+	ix = find_gid(table, gid, attr, false, GID_ATTR_FIND_MASK_GID |
+		      GID_ATTR_FIND_MASK_NETDEV);
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
@@ -188,6 +223,7 @@ int roce_del_gid(struct ib_device *ib_dev, u8 port,
 	struct ib_roce_gid_table **ports_table =
 		READ_ONCE(ib_dev->cache.roce_gid_table);
 	struct ib_roce_gid_table *table;
+	union ib_gid default_gid;
 	int ix;
 
 	/* make sure we read the ports_table */
@@ -201,14 +237,23 @@ int roce_del_gid(struct ib_device *ib_dev, u8 port,
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
-		      GID_ATTR_FIND_MASK_NETDEV);
+	ix = find_gid(table, gid, attr, false,
+		      GID_ATTR_FIND_MASK_GID	  |
+		      GID_ATTR_FIND_MASK_NETDEV	  |
+		      GID_ATTR_FIND_MASK_DEFAULT);
 	if (ix < 0)
 		goto out_unlock;
 
-	write_gid(ib_dev, port, table, ix, &zgid, &zattr);
+	write_gid(ib_dev, port, table, ix, &zgid, &zattr, false);
 
 out_unlock:
 	mutex_unlock(&table->lock);
@@ -238,7 +283,7 @@ int roce_del_all_netdev_gids(struct ib_device *ib_dev, u8 port,
 
 	for (ix = 0; ix < table->sz; ix++)
 		if (table->data_vec[ix].attr.ndev == ndev)
-			write_gid(ib_dev, port, table, ix, &zgid, &zattr);
+			write_gid(ib_dev, port, table, ix, &zgid, &zattr, false);
 
 	mutex_unlock(&table->lock);
 	return 0;
@@ -306,7 +351,7 @@ static int _roce_gid_table_find_gid(struct ib_device *ib_dev,
 		table = ports_table[p];
 		if (!table)
 			continue;
-		local_index = find_gid(table, gid, val, mask);
+		local_index = find_gid(table, gid, val, false, mask);
 		if (local_index >= 0) {
 			if (index)
 				*index = local_index;
@@ -341,7 +386,7 @@ int roce_gid_table_find_gid_by_port(struct ib_device *ib_dev,
 	struct ib_roce_gid_table **ports_table =
 		READ_ONCE(ib_dev->cache.roce_gid_table);
 	struct ib_roce_gid_table *table;
-	unsigned long mask = 0;
+	unsigned long mask = GID_ATTR_FIND_MASK_GID;
 	struct ib_gid_attr val = {.ndev = ndev};
 
 	/* make sure we read the ports_table */
@@ -358,7 +403,7 @@ int roce_gid_table_find_gid_by_port(struct ib_device *ib_dev,
 	if (ndev)
 		mask |= GID_ATTR_FIND_MASK_NETDEV;
 
-	local_index = find_gid(table, gid, &val, mask);
+	local_index = find_gid(table, gid, &val, false, mask);
 	if (local_index >= 0) {
 		if (index)
 			*index = local_index;
@@ -405,12 +450,95 @@ static void free_roce_gid_table(struct ib_device *ib_dev, u8 port,
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
+	struct ib_roce_gid_table *table;
+
+	/* make sure we read the ports_table */
+	smp_rmb();
+
+	if (!ports_table)
+		return;
+
+	table  = ports_table[port - rdma_start_port(ib_dev)];
+
+	if (!table)
+		return;
+
+	make_default_gid(ndev, &gid);
+	memset(&gid_attr, 0, sizeof(gid_attr));
+	gid_attr.ndev = ndev;
+	if (gid_type_mask) {
+		int ix;
+		union ib_gid current_gid;
+		struct ib_gid_attr current_gid_attr;
+
+		ix = find_gid(table, &gid, &gid_attr, true,
+			      GID_ATTR_FIND_MASK_DEFAULT);
+
+		if (ix < 0) {
+			pr_warn("roce_gid_table: couldn't find index for default gid\n");
+			return;
+		}
+
+		mutex_lock(&table->lock);
+		if (!roce_gid_table_get_gid(ib_dev, port, ix,
+					    &current_gid, &current_gid_attr) &&
+		    mode == ROCE_GID_TABLE_DEFAULT_MODE_SET &&
+		    !memcmp(&gid, &current_gid, sizeof(gid)) &&
+		    !memcmp(&gid_attr, &current_gid_attr, sizeof(gid_attr)))
+			goto unlock_mutex;
+
+		if ((memcmp(&current_gid, &zgid, sizeof(current_gid)) ||
+		     memcmp(&current_gid_attr, &zattr,
+			    sizeof(current_gid_attr))) &&
+		    write_gid(ib_dev, port, table, ix, &zgid, &zattr, true)) {
+			pr_warn("roce_gid_table: can't delete index %d for default gid %pI6\n",
+				ix, gid.raw);
+			goto unlock_mutex;
+		}
+
+		if (mode == ROCE_GID_TABLE_DEFAULT_MODE_SET)
+			if (write_gid(ib_dev, port, table, ix, &gid, &gid_attr,
+				      true))
+				pr_warn("roce_gid_table: unable to add default gid %pI6\n",
+					gid.raw);
+	}
+
+unlock_mutex:
+	mutex_unlock(&table->lock);
+}
+
+static int roce_gid_table_reserve_default(struct ib_device *ib_dev, u8 port,
+					  struct ib_roce_gid_table *table)
+{
+	unsigned long roce_gid_type_mask;
+
+	roce_gid_type_mask = roce_gid_type_mask_support(ib_dev, port);
+	if (roce_gid_type_mask) {
+		struct ib_roce_gid_table_entry *entry =
+			&table->data_vec[0];
+
+		entry->default_gid = true;
+	}
+
+	return 0;
+}
+
 static int roce_gid_table_setup_one(struct ib_device *ib_dev)
 {
 	u8 port;
@@ -440,6 +568,12 @@ static int roce_gid_table_setup_one(struct ib_device *ib_dev)
 			err = -ENOMEM;
 			goto rollback_table_setup;
 		}
+
+		err = roce_gid_table_reserve_default(ib_dev,
+						     port + rdma_start_port(ib_dev),
+						     table[port]);
+		if (err)
+			goto rollback_table_setup;
 	}
 
 	ib_dev->cache.roce_gid_table = table;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 05dcfad..1f918b0 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -75,6 +75,7 @@ struct ib_roce_gid_table_entry {
 	union ib_gid        gid;
 	struct ib_gid_attr  attr;
 	void		   *context;
+	bool		    default_gid;
 };
 
 struct ib_roce_gid_table {
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
