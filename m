From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 05/30] IB/core: Add RoCE cache bonding support
Date: Fri, 20 Feb 2015 03:32:20 +0530
Message-ID: <1a54c125-fc73-4812-9aad-600260cbb44c@CMEXHTCAS2.ad.emulex.com>
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

Bonding is a unique behavior since when working in
active-backup mode, only the current selected slave
should occupy the default GIDs and the master's GID.
Listening to bonding events and only adding the
required GIDs to the active slave in the RoCE cache
GID table.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/roce_gid_mgmt.c |  137 ++++++++++++++++++++++++++++++-
 drivers/net/bonding/bond_options.c      |   13 ---
 include/net/bonding.h                   |    7 ++
 3 files changed, 140 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/core/roce_gid_mgmt.c b/drivers/infiniband/core/roce_gid_mgmt.c
index b65eab8..e724295 100644
--- a/drivers/infiniband/core/roce_gid_mgmt.c
+++ b/drivers/infiniband/core/roce_gid_mgmt.c
@@ -37,6 +37,7 @@
 
 /* For in6_dev_get/in6_dev_put */
 #include <net/addrconf.h>
+#include <net/bonding.h>
 
 #include <rdma/ib_cache.h>
 #include <rdma/ib_addr.h>
@@ -127,12 +128,40 @@ static void update_gid(enum gid_op_type gid_op, struct ib_device *ib_dev,
 	}
 }
 
+#define IS_NETDEV_BONDING_MASTER(ndev)	\
+	(((ndev)->priv_flags &		\
+	  (IFF_BONDING | IFF_MASTER)) == (IFF_BONDING | IFF_MASTER))
+
+enum bonding_slave_state {
+	BONDING_SLAVE_STATE_ACTIVE,
+	BONDING_SLAVE_STATE_INACTIVE,
+	BONDING_SLAVE_STATE_NA
+};
+
+static enum bonding_slave_state is_eth_active_slave_of_bonding(struct net_device *idev,
+							       struct net_device *upper)
+{
+	if (upper && IS_NETDEV_BONDING_MASTER(upper)) {
+		struct net_device *pdev;
+
+		rcu_read_lock();
+		pdev = bond_option_active_slave_get_rcu(netdev_priv(upper));
+		rcu_read_unlock();
+		if (pdev)
+			return idev == pdev ? BONDING_SLAVE_STATE_ACTIVE :
+				BONDING_SLAVE_STATE_INACTIVE;
+	}
+
+	return BONDING_SLAVE_STATE_NA;
+}
+
 static int is_eth_port_of_netdev(struct ib_device *ib_dev, u8 port,
 				 struct net_device *idev, void *cookie)
 {
 	struct net_device *rdev;
 	struct net_device *mdev;
 	struct net_device *ndev = (struct net_device *)cookie;
+	int res;
 
 	if (!idev)
 		return 0;
@@ -140,9 +169,16 @@ static int is_eth_port_of_netdev(struct ib_device *ib_dev, u8 port,
 	rcu_read_lock();
 	mdev = netdev_master_upper_dev_get_rcu(idev);
 	rdev = rdma_vlan_dev_real_dev(ndev);
-	rcu_read_unlock();
+	if (!rdev)
+		rdev = ndev;
 
-	return (rdev ? rdev : ndev) == (mdev ? mdev : idev);
+	res = (rdev == idev ||
+	       (rdev == mdev &&
+		is_eth_active_slave_of_bonding(idev, mdev) !=
+		BONDING_SLAVE_STATE_INACTIVE));
+
+	rcu_read_unlock();
+	return res;
 }
 
 static int pass_all_filter(struct ib_device *ib_dev, u8 port,
@@ -151,6 +187,26 @@ static int pass_all_filter(struct ib_device *ib_dev, u8 port,
 	return 1;
 }
 
+static int bonding_slaves_filter(struct ib_device *ib_dev, u8 port,
+				 struct net_device *idev, void *cookie)
+{
+	struct net_device *mdev;
+	struct net_device *rdev;
+	struct net_device *ndev = (struct net_device *)cookie;
+
+	rdev = rdma_vlan_dev_real_dev(ndev);
+
+	ndev = rdev ? rdev : ndev;
+	if (!idev || !IS_NETDEV_BONDING_MASTER(ndev))
+		return 0;
+
+	rcu_read_lock();
+	mdev = netdev_master_upper_dev_get_rcu(idev);
+	rcu_read_unlock();
+
+	return ndev == mdev;
+}
+
 static void netdevice_event_work_handler(struct work_struct *_work)
 {
 	struct netdev_event_work *work =
@@ -186,8 +242,16 @@ static void enum_netdev_default_gids(struct ib_device *ib_dev,
 {
 	unsigned long gid_type_mask;
 
-	if (idev != ndev)
+	rcu_read_lock();
+	if (!idev ||
+	    ((idev != ndev && netdev_master_upper_dev_get_rcu(idev) != ndev) ||
+	     is_eth_active_slave_of_bonding(idev,
+					    netdev_master_upper_dev_get_rcu(idev)) ==
+	     BONDING_SLAVE_STATE_INACTIVE)) {
+		rcu_read_unlock();
 		return;
+	}
+	rcu_read_unlock();
 
 	gid_type_mask = gid_type_mask_support(ib_dev, port);
 
@@ -195,6 +259,35 @@ static void enum_netdev_default_gids(struct ib_device *ib_dev,
 				       ROCE_GID_CACHE_DEFAULT_MODE_SET);
 }
 
+static void bond_delete_netdev_default_gids(struct ib_device *ib_dev,
+					    u8 port, struct net_device *ndev,
+					    struct net_device *idev)
+{
+	struct net_device *upper;
+
+	if (!idev)
+		return;
+
+	rcu_read_lock();
+	upper = netdev_master_upper_dev_get_rcu(idev);
+
+	if ((upper == ndev) &&
+	    is_eth_active_slave_of_bonding(idev, upper) ==
+	    BONDING_SLAVE_STATE_INACTIVE) {
+		unsigned long gid_type_mask;
+
+		rcu_read_unlock();
+
+		gid_type_mask = gid_type_mask_support(ib_dev, port);
+
+		roce_gid_cache_set_default_gid(ib_dev, port, idev,
+					       gid_type_mask,
+					       ROCE_GID_CACHE_DEFAULT_MODE_DELETE);
+	} else {
+		rcu_read_unlock();
+	}
+}
+
 static void enum_netdev_ipv4_ips(struct ib_device *ib_dev,
 				 u8 port, struct net_device *ndev)
 {
@@ -317,6 +410,27 @@ static void del_netdev_ips(struct ib_device *ib_dev, u8 port,
 	struct net_device *ndev = (struct net_device *)cookie;
 
 	roce_del_all_netdev_gids(ib_dev, port, ndev);
+	if (idev) {
+		bool is_upper;
+
+		rcu_read_lock();
+		is_upper = netdev_master_upper_dev_get_rcu(idev) == ndev;
+		rcu_read_unlock();
+
+		if (is_upper)
+			/* Delete default GIDs, vlans should be deleted
+			 * first by user
+			 */
+			roce_del_all_netdev_gids(ib_dev, port, idev);
+	}
+}
+
+static void del_netdev_default_ips(struct ib_device *ib_dev, u8 port,
+				   struct net_device *idev, void *cookie)
+{
+	struct net_device *ndev = (struct net_device *)cookie;
+
+	bond_delete_netdev_default_gids(ib_dev, port, ndev, idev);
 }
 
 static int netdevice_event(struct notifier_block *this, unsigned long event,
@@ -326,6 +440,10 @@ static int netdevice_event(struct notifier_block *this, unsigned long event,
 		.cb = add_netdev_ips, .filter = is_eth_port_of_netdev};
 	static const struct netdev_event_work_cmd del_cmd = {
 		.cb = del_netdev_ips, .filter = pass_all_filter};
+	static const struct netdev_event_work_cmd bonding_default_del_cmd = {
+		.cb = del_netdev_default_ips, .filter = bonding_slaves_filter};
+	static const struct netdev_event_work_cmd bonding_ips_del_cmd = {
+		.cb = del_netdev_ips, .filter = bonding_slaves_filter};
 	struct net_device *ndev = netdev_notifier_info_to_dev(ptr);
 	struct netdev_event_work *ndev_work;
 	struct netdev_event_work_cmd cmds[ROCE_NETDEV_CALLBACK_SZ] = { {NULL} };
@@ -336,7 +454,8 @@ static int netdevice_event(struct notifier_block *this, unsigned long event,
 	switch (event) {
 	case NETDEV_REGISTER:
 	case NETDEV_UP:
-		cmds[0] = add_cmd;
+		cmds[0] = bonding_default_del_cmd;
+		cmds[1] = add_cmd;
 		break;
 
 	case NETDEV_UNREGISTER:
@@ -350,6 +469,16 @@ static int netdevice_event(struct notifier_block *this, unsigned long event,
 		cmds[0] = del_cmd;
 		cmds[1] = add_cmd;
 		break;
+
+	case NETDEV_BONDING_FAILOVER:
+		cmds[0] = bonding_ips_del_cmd;
+		cmds[1] = add_cmd;
+		break;
+	case NETDEV_JOIN:
+		cmds[0] = bonding_default_del_cmd;
+		cmds[1] = add_cmd;
+		break;
+
 	default:
 		return NOTIFY_DONE;
 	}
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 1a61cc9..42e30e5 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -690,19 +690,6 @@ static int bond_option_mode_set(struct bonding *bond,
 	return 0;
 }
 
-static struct net_device *__bond_option_active_slave_get(struct bonding *bond,
-							 struct slave *slave)
-{
-	return bond_uses_primary(bond) && slave ? slave->dev : NULL;
-}
-
-struct net_device *bond_option_active_slave_get_rcu(struct bonding *bond)
-{
-	struct slave *slave = rcu_dereference(bond->curr_active_slave);
-
-	return __bond_option_active_slave_get(bond, slave);
-}
-
 static int bond_option_active_slave_set(struct bonding *bond,
 					const struct bond_opt_value *newval)
 {
diff --git a/include/net/bonding.h b/include/net/bonding.h
index 4c2b0f4..074bcad 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -314,6 +314,13 @@ static inline bool bond_uses_primary(struct bonding *bond)
 	return bond_mode_uses_primary(BOND_MODE(bond));
 }
 
+static inline struct net_device *bond_option_active_slave_get_rcu(struct bonding *bond)
+{
+	struct slave *slave = rcu_dereference(bond->curr_active_slave);
+
+	return bond_uses_primary(bond) && slave ? slave->dev : NULL;
+}
+
 static inline bool bond_slave_is_up(struct slave *slave)
 {
 	return netif_running(slave->dev) && netif_carrier_ok(slave->dev);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
