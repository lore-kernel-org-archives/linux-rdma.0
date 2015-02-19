From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 04/30] IB/core: Add default GID for RoCE GID Cache
Date: Fri, 20 Feb 2015 03:32:19 +0530
Message-ID: <a4684f8a-105d-49d8-aa1a-3a97350aca5c@CMEXHTCAS2.ad.emulex.com>
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

When RoCE is used, a default GID address should be generated
for every supported RoCE type. These default GID addresses are
generated based on the IPv6 link-local address, but in contrast
to the GID based on the regular IPv6 link-local (as we generate
GID per IP address), these GIDs are also available if the net
device is down (in order to support loopback).
Moreover, these default GID addresses can't be deleted.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/core_priv.h      |   10 ++++
 drivers/infiniband/core/roce_gid_cache.c |   86 ++++++++++++++++++++++++++++++
 drivers/infiniband/core/roce_gid_mgmt.c  |   43 ++++++++++++---
 include/net/addrconf.h                   |   31 +++++++++++
 net/ipv6/addrconf.c                      |   31 -----------
 5 files changed, 163 insertions(+), 38 deletions(-)

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 12797d9..6ab40a9 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -84,6 +84,16 @@ int roce_gid_cache_find_gid_by_port(struct ib_device *ib_dev, union ib_gid *gid,
 
 int roce_gid_cache_is_active(struct ib_device *ib_dev, u8 port);
 
+enum roce_gid_cache_default_mode {
+	ROCE_GID_CACHE_DEFAULT_MODE_SET,
+	ROCE_GID_CACHE_DEFAULT_MODE_DELETE
+};
+
+void roce_gid_cache_set_default_gid(struct ib_device *ib_dev, u8 port,
+				    struct net_device *ndev,
+				    unsigned long gid_type_mask,
+				    enum roce_gid_cache_default_mode mode);
+
 int roce_gid_cache_setup(void);
 void roce_gid_cache_cleanup(void);
 
diff --git a/drivers/infiniband/core/roce_gid_cache.c b/drivers/infiniband/core/roce_gid_cache.c
index f072533..fc6a4e6 100644
--- a/drivers/infiniband/core/roce_gid_cache.c
+++ b/drivers/infiniband/core/roce_gid_cache.c
@@ -34,6 +34,7 @@
 #include <linux/netdevice.h>
 #include <linux/rtnetlink.h>
 #include <rdma/ib_cache.h>
+#include <net/addrconf.h>
 
 #include "core_priv.h"
 
@@ -176,12 +177,19 @@ static int find_gid(struct ib_roce_gid_cache *cache, union ib_gid *gid,
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
 	struct ib_roce_gid_cache *cache;
 	int ix;
 	int ret = 0;
+	struct net_device *idev;
 
 	if (!ib_dev->cache.roce_gid_cache)
 		return -ENOSYS;
@@ -191,6 +199,22 @@ int roce_add_gid(struct ib_device *ib_dev, u8 port,
 	if (!cache->active)
 		return -ENOSYS;
 
+	if (ib_dev->get_netdev) {
+		rcu_read_lock();
+		idev = ib_dev->get_netdev(ib_dev, port);
+		if (attr->ndev != idev) {
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
 	mutex_lock(&cache->lock);
 
 	ix = find_gid(cache, gid, attr, GID_ATTR_FIND_MASK_GID_TYPE |
@@ -215,6 +239,7 @@ int roce_del_gid(struct ib_device *ib_dev, u8 port,
 		 union ib_gid *gid, struct ib_gid_attr *attr)
 {
 	struct ib_roce_gid_cache *cache;
+	union ib_gid default_gid;
 	int ix;
 
 	if (!ib_dev->cache.roce_gid_cache)
@@ -225,6 +250,13 @@ int roce_del_gid(struct ib_device *ib_dev, u8 port,
 	if (!cache->active)
 		return -ENOSYS;
 
+	if (attr->ndev) {
+		/* Deleting default GIDs in not permitted */
+		make_default_gid(attr->ndev, &default_gid);
+		if (!memcmp(gid, &default_gid, sizeof(*gid)))
+			return -EPERM;
+	}
+
 	mutex_lock(&cache->lock);
 
 	ix = find_gid(cache, gid, attr,
@@ -437,6 +469,60 @@ static void set_roce_gid_cache_active(struct ib_roce_gid_cache *cache,
 	cache->active = active;
 }
 
+void roce_gid_cache_set_default_gid(struct ib_device *ib_dev, u8 port,
+				    struct net_device *ndev,
+				    unsigned long gid_type_mask,
+				    enum roce_gid_cache_default_mode mode)
+{
+	union ib_gid gid;
+	struct ib_gid_attr gid_attr;
+	struct ib_roce_gid_cache *cache;
+	unsigned int gid_type;
+	unsigned int gid_index = 0;
+
+	cache  = ib_dev->cache.roce_gid_cache[port - 1];
+
+	if (!cache)
+		return;
+
+	make_default_gid(ndev, &gid);
+	memset(&gid_attr, 0, sizeof(gid_attr));
+	gid_attr.ndev = ndev;
+	for (gid_type = 0; gid_type < IB_GID_TYPE_SIZE; ++gid_type) {
+		union ib_gid current_gid;
+		struct ib_gid_attr current_gid_attr;
+
+		if (1UL << gid_type & ~gid_type_mask)
+			continue;
+
+		gid_attr.gid_type = gid_type;
+
+		if (!roce_gid_cache_get_gid(ib_dev, port, gid_index,
+					    &current_gid, &current_gid_attr) &&
+		    !memcmp(&gid, &current_gid, sizeof(gid)) &&
+		    !memcmp(&gid_attr, &current_gid_attr, sizeof(gid_attr)) &&
+		    mode == ROCE_GID_CACHE_DEFAULT_MODE_SET)
+			continue;
+
+		mutex_lock(&cache->lock);
+		if (write_gid(ib_dev, port, cache, gid_index, &zgid, &zattr)) {
+			pr_warn("roce_gid_cache: can't delete index %d for default gid %pI6\n",
+				gid_index, gid.raw);
+			mutex_unlock(&cache->lock);
+			++gid_index;
+			continue;
+		}
+
+		if (mode == ROCE_GID_CACHE_DEFAULT_MODE_SET &&
+		    write_gid(ib_dev, port, cache, gid_index, &gid, &gid_attr))
+			pr_warn("roce_gid_cache: unable to add default gid %pI6\n",
+				gid.raw);
+
+		mutex_unlock(&cache->lock);
+		++gid_index;
+	}
+}
+
 static int roce_gid_cache_setup_one(struct ib_device *ib_dev)
 {
 	u8 port;
diff --git a/drivers/infiniband/core/roce_gid_mgmt.c b/drivers/infiniband/core/roce_gid_mgmt.c
index 48f9267..b65eab8 100644
--- a/drivers/infiniband/core/roce_gid_mgmt.c
+++ b/drivers/infiniband/core/roce_gid_mgmt.c
@@ -82,24 +82,37 @@ static const struct {
 
 #define CAP_TO_GID_TABLE_SIZE	ARRAY_SIZE(PORT_CAP_TO_GID_TYPE)
 
-static void update_gid(enum gid_op_type gid_op, struct ib_device *ib_dev,
-		       u8 port, union ib_gid *gid,
-		       struct ib_gid_attr *gid_attr)
+static unsigned long gid_type_mask_support(struct ib_device *ib_dev, u8 port)
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
+	unsigned long gid_type_mask = gid_type_mask_support(ib_dev, port);
+
+	for (i = 0; i < IB_GID_TYPE_SIZE; i++) {
+		if ((1UL << i) & gid_type_mask) {
+			gid_attr->gid_type = i;
 			switch (gid_op) {
 			case GID_ADD:
 				roce_add_gid(ib_dev, port,
@@ -167,6 +180,21 @@ static void update_gid_ip(enum gid_op_type gid_op,
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
+	gid_type_mask = gid_type_mask_support(ib_dev, port);
+
+	roce_gid_cache_set_default_gid(ib_dev, port, idev, gid_type_mask,
+				       ROCE_GID_CACHE_DEFAULT_MODE_SET);
+}
+
 static void enum_netdev_ipv4_ips(struct ib_device *ib_dev,
 				 u8 port, struct net_device *ndev)
 {
@@ -276,6 +304,7 @@ static void add_netdev_ips(struct ib_device *ib_dev, u8 port,
 {
 	struct net_device *ndev = (struct net_device *)cookie;
 
+	enum_netdev_default_gids(ib_dev, port, ndev, idev);
 	enum_netdev_ipv4_ips(ib_dev, port, ndev);
 #if IS_ENABLED(CONFIG_IPV6)
 	enum_netdev_ipv6_ips(ib_dev, port, ndev);
diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index d13573b..378bf82 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -88,6 +88,37 @@ int ipv6_rcv_saddr_equal(const struct sock *sk, const struct sock *sk2);
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
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index f7c8bbe..1ad323d 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1765,37 +1765,6 @@ static void addrconf_leave_anycast(struct inet6_ifaddr *ifp)
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
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
