From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 1/9] IB/core: Add gid_type to gid attribute
Date: Thu, 13 Aug 2015 19:03:06 +0300
Message-ID: <1439481794-27998-2-git-send-email-matanb@mellanox.com>
References: <1439481794-27998-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1439481794-27998-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In order to support multiple GID types, we need to store the gid_type
with each GID. This is also aligned with the RoCE v2 annex "RoCEv2 PORT
GID table entries shall have a "GID type" attribute that denotes the L3
Address type". The currently supported GID is IB_GID_TYPE_IB which is
also RoCE v1 GID type.

This implies that gid_type should be added to roce_gid_table meta-data.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cache.c           | 127 +++++++++++++++++++++---------
 drivers/infiniband/core/cm.c              |   2 +-
 drivers/infiniband/core/cma.c             |   3 +-
 drivers/infiniband/core/core_priv.h       |   4 +
 drivers/infiniband/core/device.c          |   9 ++-
 drivers/infiniband/core/multicast.c       |   2 +-
 drivers/infiniband/core/roce_gid_mgmt.c   |  60 ++++++++++++--
 drivers/infiniband/core/sa_query.c        |   5 +-
 drivers/infiniband/core/uverbs_marshall.c |   1 +
 drivers/infiniband/core/verbs.c           |   1 +
 include/rdma/ib_cache.h                   |   4 +
 include/rdma/ib_sa.h                      |   1 +
 include/rdma/ib_verbs.h                   |  11 ++-
 13 files changed, 177 insertions(+), 53 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index e62b63c..513a1ef 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -64,6 +64,7 @@ enum gid_attr_find_mask {
 	GID_ATTR_FIND_MASK_GID          = 1UL << 0,
 	GID_ATTR_FIND_MASK_NETDEV	= 1UL << 1,
 	GID_ATTR_FIND_MASK_DEFAULT	= 1UL << 2,
+	GID_ATTR_FIND_MASK_GID_TYPE	= 1UL << 3,
 };
 
 enum gid_table_entry_props {
@@ -112,6 +113,19 @@ struct ib_gid_table {
 	struct ib_gid_table_entry *data_vec;
 };
 
+static const char * const gid_type_str[] = {
+	[IB_GID_TYPE_IB]	= "IB/RoCE v1",
+};
+
+const char *ib_cache_gid_type_str(enum ib_gid_type gid_type)
+{
+	if (gid_type < ARRAY_SIZE(gid_type_str) && gid_type_str[gid_type])
+		return gid_type_str[gid_type];
+
+	return "Invalid GID type";
+}
+EXPORT_SYMBOL(ib_cache_gid_type_str);
+
 static int write_gid(struct ib_device *ib_dev, u8 port,
 		     struct ib_gid_table *table, int ix,
 		     const union ib_gid *gid,
@@ -216,6 +230,10 @@ static int find_gid(struct ib_gid_table *table, const union ib_gid *gid,
 		if (table->data_vec[i].props & GID_TABLE_ENTRY_INVALID)
 			goto next;
 
+		if (mask & GID_ATTR_FIND_MASK_GID_TYPE &&
+		    attr->gid_type != val->gid_type)
+			goto next;
+
 		if (mask & GID_ATTR_FIND_MASK_GID &&
 		    memcmp(gid, &table->data_vec[i].gid, sizeof(*gid)))
 			goto next;
@@ -277,6 +295,7 @@ int ib_cache_gid_add(struct ib_device *ib_dev, u8 port,
 	mutex_lock(&table->lock);
 
 	ix = find_gid(table, gid, attr, false, GID_ATTR_FIND_MASK_GID |
+		      GID_ATTR_FIND_MASK_GID_TYPE |
 		      GID_ATTR_FIND_MASK_NETDEV);
 	if (ix >= 0)
 		goto out_unlock;
@@ -308,6 +327,7 @@ int ib_cache_gid_del(struct ib_device *ib_dev, u8 port,
 
 	ix = find_gid(table, gid, attr, false,
 		      GID_ATTR_FIND_MASK_GID	  |
+		      GID_ATTR_FIND_MASK_GID_TYPE |
 		      GID_ATTR_FIND_MASK_NETDEV	  |
 		      GID_ATTR_FIND_MASK_DEFAULT);
 	if (ix < 0)
@@ -396,11 +416,13 @@ static int _ib_cache_gid_table_find(struct ib_device *ib_dev,
 
 static int ib_cache_gid_find(struct ib_device *ib_dev,
 			     const union ib_gid *gid,
+			     enum ib_gid_type gid_type,
 			     struct net_device *ndev, u8 *port,
 			     u16 *index)
 {
-	unsigned long mask = GID_ATTR_FIND_MASK_GID;
-	struct ib_gid_attr gid_attr_val = {.ndev = ndev};
+	unsigned long mask = GID_ATTR_FIND_MASK_GID |
+			     GID_ATTR_FIND_MASK_GID_TYPE;
+	struct ib_gid_attr gid_attr_val = {.ndev = ndev, .gid_type = gid_type};
 
 	if (ndev)
 		mask |= GID_ATTR_FIND_MASK_NETDEV;
@@ -411,14 +433,16 @@ static int ib_cache_gid_find(struct ib_device *ib_dev,
 
 int ib_find_cached_gid_by_port(struct ib_device *ib_dev,
 			       const union ib_gid *gid,
+			       enum ib_gid_type gid_type,
 			       u8 port, struct net_device *ndev,
 			       u16 *index)
 {
 	int local_index;
 	struct ib_gid_table **ports_table = ib_dev->cache.gid_cache;
 	struct ib_gid_table *table;
-	unsigned long mask = GID_ATTR_FIND_MASK_GID;
-	struct ib_gid_attr val = {.ndev = ndev};
+	unsigned long mask = GID_ATTR_FIND_MASK_GID |
+			     GID_ATTR_FIND_MASK_GID_TYPE;
+	struct ib_gid_attr val = {.ndev = ndev, .gid_type = gid_type};
 
 	if (port < rdma_start_port(ib_dev) ||
 	    port > rdma_end_port(ib_dev))
@@ -568,15 +592,15 @@ static void cleanup_gid_table_port(struct ib_device *ib_dev, u8 port,
 
 void ib_cache_gid_set_default_gid(struct ib_device *ib_dev, u8 port,
 				  struct net_device *ndev,
+				  unsigned long gid_type_mask,
 				  enum ib_cache_gid_default_mode mode)
 {
 	struct ib_gid_table **ports_table = ib_dev->cache.gid_cache;
 	union ib_gid gid;
 	struct ib_gid_attr gid_attr;
+	struct ib_gid_attr zattr_type = zattr;
 	struct ib_gid_table *table;
-	int ix;
-	union ib_gid current_gid;
-	struct ib_gid_attr current_gid_attr = {};
+	unsigned int gid_type;
 
 	table  = ports_table[port - rdma_start_port(ib_dev)];
 
@@ -584,46 +608,74 @@ void ib_cache_gid_set_default_gid(struct ib_device *ib_dev, u8 port,
 	memset(&gid_attr, 0, sizeof(gid_attr));
 	gid_attr.ndev = ndev;
 
-	ix = find_gid(table, NULL, NULL, true, GID_ATTR_FIND_MASK_DEFAULT);
+	for (gid_type = 0; gid_type < IB_GID_TYPE_SIZE; ++gid_type) {
+		int ix;
+		union ib_gid current_gid;
+		struct ib_gid_attr current_gid_attr = {};
 
-	/* Coudn't find default GID location */
-	WARN_ON(ix < 0);
+		if (1UL << gid_type & ~gid_type_mask)
+			continue;
 
-	mutex_lock(&table->lock);
-	if (!__ib_cache_gid_get(ib_dev, port, ix,
-				&current_gid, &current_gid_attr) &&
-	    mode == IB_CACHE_GID_DEFAULT_MODE_SET &&
-	    !memcmp(&gid, &current_gid, sizeof(gid)) &&
-	    !memcmp(&gid_attr, &current_gid_attr, sizeof(gid_attr)))
-		goto unlock;
-
-	if ((memcmp(&current_gid, &zgid, sizeof(current_gid)) ||
-	     memcmp(&current_gid_attr, &zattr,
-		    sizeof(current_gid_attr))) &&
-	    del_gid(ib_dev, port, table, ix, true)) {
-		pr_warn("ib_cache_gid: can't delete index %d for default gid %pI6\n",
-			ix, gid.raw);
-		goto unlock;
-	}
+		gid_attr.gid_type = gid_type;
 
-	if (mode == IB_CACHE_GID_DEFAULT_MODE_SET)
-		if (add_gid(ib_dev, port, table, ix, &gid, &gid_attr, true))
-			pr_warn("ib_cache_gid: unable to add default gid %pI6\n",
-				gid.raw);
+		ix = find_gid(table, &gid, &gid_attr, true,
+			      GID_ATTR_FIND_MASK_GID_TYPE |
+			      GID_ATTR_FIND_MASK_DEFAULT);
 
-unlock:
-	if (current_gid_attr.ndev)
-		dev_put(current_gid_attr.ndev);
-	mutex_unlock(&table->lock);
+		/* Coudn't find default GID location */
+		WARN_ON(ix < 0);
+
+		zattr_type.gid_type = gid_type;
+
+		mutex_lock(&table->lock);
+		if (!__ib_cache_gid_get(ib_dev, port, ix,
+					&current_gid, &current_gid_attr) &&
+		    mode == IB_CACHE_GID_DEFAULT_MODE_SET &&
+		    !memcmp(&gid, &current_gid, sizeof(gid)) &&
+		    !memcmp(&gid_attr, &current_gid_attr, sizeof(gid_attr)))
+			goto release;
+
+		if ((memcmp(&current_gid, &zgid, sizeof(current_gid)) ||
+		     memcmp(&current_gid_attr, &zattr_type,
+			    sizeof(current_gid_attr))) &&
+		    del_gid(ib_dev, port, table, ix, true)) {
+			pr_warn("roce_gid_table: can't delete index %d for default gid %pI6\n",
+				ix, gid.raw);
+			goto release;
+		}
+
+		if (mode == IB_CACHE_GID_DEFAULT_MODE_SET)
+			if (add_gid(ib_dev, port, table, ix, &gid, &gid_attr,
+				    true))
+				pr_warn("roce_gid_table: unable to add default gid %pI6\n",
+					gid.raw);
+
+release:
+		if (current_gid_attr.ndev)
+			dev_put(current_gid_attr.ndev);
+		mutex_unlock(&table->lock);
+	}
 }
 
 static int gid_table_reserve_default(struct ib_device *ib_dev, u8 port,
 				     struct ib_gid_table *table)
 {
-	if (rdma_protocol_roce(ib_dev, port)) {
-		struct ib_gid_table_entry *entry = &table->data_vec[0];
+	unsigned int i;
+	unsigned long roce_gid_type_mask;
+	unsigned int num_default_gids;
+	unsigned int current_gid = 0;
+
+	roce_gid_type_mask = roce_gid_type_mask_support(ib_dev, port);
+	num_default_gids = hweight_long(roce_gid_type_mask);
+	for (i = 0; i < num_default_gids && i < table->sz; i++) {
+		struct ib_gid_table_entry *entry =
+			&table->data_vec[i];
 
 		entry->props |= GID_TABLE_ENTRY_DEFAULT;
+		current_gid = find_next_bit(&roce_gid_type_mask,
+					    BITS_PER_LONG,
+					    current_gid);
+		entry->attr.gid_type = current_gid++;
 	}
 
 	return 0;
@@ -735,11 +787,12 @@ EXPORT_SYMBOL(ib_get_cached_gid);
 
 int ib_find_cached_gid(struct ib_device *device,
 		       const union ib_gid *gid,
+		       enum ib_gid_type gid_type,
 		       struct net_device *ndev,
 		       u8               *port_num,
 		       u16              *index)
 {
-	return ib_cache_gid_find(device, gid, ndev, port_num, index);
+	return ib_cache_gid_find(device, gid, gid_type, ndev, port_num, index);
 }
 EXPORT_SYMBOL(ib_find_cached_gid);
 
diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 9948ad0..0c15488 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -362,7 +362,7 @@ static int cm_init_av_by_path(struct ib_sa_path_rec *path, struct cm_av *av)
 	read_lock_irqsave(&cm.device_lock, flags);
 	list_for_each_entry(cm_dev, &cm.device_list, list) {
 		if (!ib_find_cached_gid(cm_dev->ib_device, &path->sgid,
-					ndev, &p, NULL)) {
+					IB_GID_TYPE_IB, ndev, &p, NULL)) {
 			port = cm_dev->port[p-1];
 			break;
 		}
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index e53276f..dfb92bf 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -393,7 +393,8 @@ static inline int cma_validate_port(struct ib_device *device, u8 port,
 	if (dev_type == ARPHRD_ETHER)
 		ndev = dev_get_by_index(&init_net, bound_if_index);
 
-	ret = ib_find_cached_gid_by_port(device, gid, port, ndev, NULL);
+	ret = ib_find_cached_gid_by_port(device, gid, IB_GID_TYPE_IB, port,
+					 ndev, NULL);
 
 	if (ndev)
 		dev_put(ndev);
diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 06df0f8..f2c5cc9 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -70,8 +70,11 @@ enum ib_cache_gid_default_mode {
 	IB_CACHE_GID_DEFAULT_MODE_DELETE
 };
 
+const char *ib_cache_gid_type_str(enum ib_gid_type gid_type);
+
 void ib_cache_gid_set_default_gid(struct ib_device *ib_dev, u8 port,
 				  struct net_device *ndev,
+				  unsigned long gid_type_mask,
 				  enum ib_cache_gid_default_mode mode);
 
 int ib_cache_gid_add(struct ib_device *ib_dev, u8 port,
@@ -87,6 +90,7 @@ int roce_gid_mgmt_init(void);
 void roce_gid_mgmt_cleanup(void);
 
 int roce_rescan_device(struct ib_device *ib_dev);
+unsigned long roce_gid_type_mask_support(struct ib_device *ib_dev, u8 port);
 
 int ib_cache_setup_one(struct ib_device *device);
 void ib_cache_cleanup_one(struct ib_device *device);
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 491068c..c8dc2c6 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -793,25 +793,30 @@ EXPORT_SYMBOL(ib_modify_port);
  *   a specified GID value occurs.
  * @device: The device to query.
  * @gid: The GID value to search for.
+ * @gid_type: Type of GID.
  * @ndev: The ndev related to the GID to search for.
  * @port_num: The port number of the device where the GID value was found.
  * @index: The index into the GID table where the GID was found.  This
  *   parameter may be NULL.
  */
 int ib_find_gid(struct ib_device *device, union ib_gid *gid,
-		struct net_device *ndev, u8 *port_num, u16 *index)
+		enum ib_gid_type gid_type, struct net_device *ndev,
+		u8 *port_num, u16 *index)
 {
 	union ib_gid tmp_gid;
 	int ret, port, i;
 
 	for (port = rdma_start_port(device); port <= rdma_end_port(device); ++port) {
 		if (rdma_cap_roce_gid_table(device, port)) {
-			if (!ib_find_cached_gid_by_port(device, gid, port,
+			if (!ib_find_cached_gid_by_port(device, gid, gid_type, port,
 							ndev, index))
 				*port_num = port;
 				return 0;
 		}
 
+		if (gid_type != IB_GID_TYPE_IB)
+			continue;
+
 		for (i = 0; i < device->port_immutable[port].gid_tbl_len; ++i) {
 			ret = ib_query_gid(device, port, i, &tmp_gid, NULL);
 			if (ret)
diff --git a/drivers/infiniband/core/multicast.c b/drivers/infiniband/core/multicast.c
index dc611fe..6c3cad9 100644
--- a/drivers/infiniband/core/multicast.c
+++ b/drivers/infiniband/core/multicast.c
@@ -729,7 +729,7 @@ int ib_init_ah_from_mcmember(struct ib_device *device, u8 port_num,
 	u16 gid_index;
 	u8 p;
 
-	ret = ib_find_cached_gid(device, &rec->port_gid,
+	ret = ib_find_cached_gid(device, &rec->port_gid, IB_GID_TYPE_IB,
 				 NULL, &p, &gid_index);
 	if (ret)
 		return ret;
diff --git a/drivers/infiniband/core/roce_gid_mgmt.c b/drivers/infiniband/core/roce_gid_mgmt.c
index 6eecdfb..7dec6f2 100644
--- a/drivers/infiniband/core/roce_gid_mgmt.c
+++ b/drivers/infiniband/core/roce_gid_mgmt.c
@@ -67,17 +67,52 @@ struct netdev_event_work {
 	struct netdev_event_work_cmd	cmds[ROCE_NETDEV_CALLBACK_SZ];
 };
 
+static const struct {
+	bool (*is_supported)(const struct ib_device *device, u8 port_num);
+	enum ib_gid_type gid_type;
+} PORT_CAP_TO_GID_TYPE[] = {
+	{rdma_protocol_roce,   IB_GID_TYPE_ROCE},
+};
+
+#define CAP_TO_GID_TABLE_SIZE	ARRAY_SIZE(PORT_CAP_TO_GID_TYPE)
+
+unsigned long roce_gid_type_mask_support(struct ib_device *ib_dev, u8 port)
+{
+	int i;
+	unsigned int ret_flags = 0;
+
+	if (!rdma_protocol_roce(ib_dev, port))
+		return 1UL << IB_GID_TYPE_IB;
+
+	for (i = 0; i < CAP_TO_GID_TABLE_SIZE; i++)
+		if (PORT_CAP_TO_GID_TYPE[i].is_supported(ib_dev, port))
+			ret_flags |= 1UL << PORT_CAP_TO_GID_TYPE[i].gid_type;
+
+	return ret_flags;
+}
+EXPORT_SYMBOL(roce_gid_type_mask_support);
+
 static void update_gid(enum gid_op_type gid_op, struct ib_device *ib_dev,
 		       u8 port, union ib_gid *gid,
 		       struct ib_gid_attr *gid_attr)
 {
-	switch (gid_op) {
-	case GID_ADD:
-		ib_cache_gid_add(ib_dev, port, gid, gid_attr);
-		break;
-	case GID_DEL:
-		ib_cache_gid_del(ib_dev, port, gid, gid_attr);
-		break;
+	int i;
+	unsigned long gid_type_mask = roce_gid_type_mask_support(ib_dev, port);
+
+	for (i = 0; i < IB_GID_TYPE_SIZE; i++) {
+		if ((1UL << i) & gid_type_mask) {
+			gid_attr->gid_type = i;
+			switch (gid_op) {
+			case GID_ADD:
+				ib_cache_gid_add(ib_dev, port,
+						 gid, gid_attr);
+				break;
+			case GID_DEL:
+				ib_cache_gid_del(ib_dev, port,
+						 gid, gid_attr);
+				break;
+			}
+		}
 	}
 }
 
@@ -203,6 +238,8 @@ static void enum_netdev_default_gids(struct ib_device *ib_dev,
 				     u8 port, struct net_device *event_ndev,
 				     struct net_device *rdma_ndev)
 {
+	unsigned long gid_type_mask;
+
 	rcu_read_lock();
 	if (!rdma_ndev ||
 	    ((rdma_ndev != event_ndev &&
@@ -215,7 +252,9 @@ static void enum_netdev_default_gids(struct ib_device *ib_dev,
 	}
 	rcu_read_unlock();
 
-	ib_cache_gid_set_default_gid(ib_dev, port, rdma_ndev,
+	gid_type_mask = roce_gid_type_mask_support(ib_dev, port);
+
+	ib_cache_gid_set_default_gid(ib_dev, port, rdma_ndev, gid_type_mask,
 				     IB_CACHE_GID_DEFAULT_MODE_SET);
 }
 
@@ -237,9 +276,14 @@ static void bond_delete_netdev_default_gids(struct ib_device *ib_dev,
 	if (is_upper_dev_rcu(rdma_ndev, event_ndev) &&
 	    is_eth_active_slave_of_bonding_rcu(rdma_ndev, real_dev) ==
 	    BONDING_SLAVE_STATE_INACTIVE) {
+		unsigned long gid_type_mask;
+
 		rcu_read_unlock();
 
+		gid_type_mask = roce_gid_type_mask_support(ib_dev, port);
+
 		ib_cache_gid_set_default_gid(ib_dev, port, rdma_ndev,
+					     gid_type_mask,
 					     IB_CACHE_GID_DEFAULT_MODE_DELETE);
 	} else {
 		rcu_read_unlock();
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 509e8cc..e26ba9a 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -976,8 +976,8 @@ int ib_init_ah_from_path(struct ib_device *device, u8 port_num,
 		ah_attr->ah_flags = IB_AH_GRH;
 		ah_attr->grh.dgid = rec->dgid;
 
-		ret = ib_find_cached_gid(device, &rec->sgid, ndev, &port_num,
-					 &gid_index);
+		ret = ib_find_cached_gid(device, &rec->sgid, rec->gid_type, ndev,
+					 &port_num, &gid_index);
 		if (ret) {
 			if (ndev)
 				dev_put(ndev);
@@ -1119,6 +1119,7 @@ static void ib_sa_path_rec_callback(struct ib_sa_query *sa_query,
 			  mad->data, &rec);
 		rec.net = NULL;
 		rec.ifindex = 0;
+		rec.gid_type = IB_GID_TYPE_IB;
 		memset(rec.dmac, 0, ETH_ALEN);
 		query->callback(status, &rec, query->context);
 	} else
diff --git a/drivers/infiniband/core/uverbs_marshall.c b/drivers/infiniband/core/uverbs_marshall.c
index 7d2f14c..af020f8 100644
--- a/drivers/infiniband/core/uverbs_marshall.c
+++ b/drivers/infiniband/core/uverbs_marshall.c
@@ -144,5 +144,6 @@ void ib_copy_path_rec_from_user(struct ib_sa_path_rec *dst,
 	memset(dst->dmac, 0, sizeof(dst->dmac));
 	dst->net = NULL;
 	dst->ifindex = 0;
+	dst->gid_type = IB_GID_TYPE_IB;
 }
 EXPORT_SYMBOL(ib_copy_path_rec_from_user);
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 7194189..62a3d01 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -336,6 +336,7 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num,
 
 		if (!rdma_cap_eth_ah(device, port_num)) {
 			ret = ib_find_cached_gid_by_port(device, &grh->dgid,
+							 IB_GID_TYPE_IB,
 							 port_num, NULL,
 							 &gid_index);
 			if (ret)
diff --git a/include/rdma/ib_cache.h b/include/rdma/ib_cache.h
index 269a27cf..e30f19b 100644
--- a/include/rdma/ib_cache.h
+++ b/include/rdma/ib_cache.h
@@ -60,6 +60,7 @@ int ib_get_cached_gid(struct ib_device    *device,
  *   a specified GID value occurs.
  * @device: The device to query.
  * @gid: The GID value to search for.
+ * @gid_type: The GID type to search for.
  * @ndev: In RoCE, the net device of the device. NULL means ignore.
  * @port_num: The port number of the device where the GID value was found.
  * @index: The index into the cached GID table where the GID was found.  This
@@ -70,6 +71,7 @@ int ib_get_cached_gid(struct ib_device    *device,
  */
 int ib_find_cached_gid(struct ib_device *device,
 		       const union ib_gid *gid,
+		       enum ib_gid_type gid_type,
 		       struct net_device *ndev,
 		       u8               *port_num,
 		       u16              *index);
@@ -79,6 +81,7 @@ int ib_find_cached_gid(struct ib_device *device,
  * GID value occurs
  * @device: The device to query.
  * @gid: The GID value to search for.
+ * @gid_type: The GID type to search for.
  * @port_num: The port number of the device where the GID value sould be
  *   searched.
  * @ndev: In RoCE, the net device of the device. Null means ignore.
@@ -90,6 +93,7 @@ int ib_find_cached_gid(struct ib_device *device,
  */
 int ib_find_cached_gid_by_port(struct ib_device *device,
 			       const union ib_gid *gid,
+			       enum ib_gid_type gid_type,
 			       u8               port_num,
 			       struct net_device *ndev,
 			       u16              *index);
diff --git a/include/rdma/ib_sa.h b/include/rdma/ib_sa.h
index 3019695..0a40ed2 100644
--- a/include/rdma/ib_sa.h
+++ b/include/rdma/ib_sa.h
@@ -160,6 +160,7 @@ struct ib_sa_path_rec {
 	int	     ifindex;
 	/* ignored in IB */
 	struct net  *net;
+	enum ib_gid_type gid_type;
 };
 
 static inline struct net_device *ib_get_ndev_from_path(struct ib_sa_path_rec *rec)
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index a795836..a85926d 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -66,7 +66,15 @@ union ib_gid {
 
 extern union ib_gid zgid;
 
+enum ib_gid_type {
+	/* If link layer is Ethernet, this is RoCE V1 */
+	IB_GID_TYPE_IB        = 0,
+	IB_GID_TYPE_ROCE      = 0,
+	IB_GID_TYPE_SIZE
+};
+
 struct ib_gid_attr {
+	enum ib_gid_type	gid_type;
 	struct net_device	*ndev;
 };
 
@@ -2163,7 +2171,8 @@ int ib_modify_port(struct ib_device *device,
 		   struct ib_port_modify *port_modify);
 
 int ib_find_gid(struct ib_device *device, union ib_gid *gid,
-		struct net_device *ndev, u8 *port_num, u16 *index);
+		enum ib_gid_type gid_type, struct net_device *ndev,
+		u8 *port_num, u16 *index);
 
 int ib_find_pkey(struct ib_device *device,
 		 u8 port_num, u16 pkey, u16 *index);
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
