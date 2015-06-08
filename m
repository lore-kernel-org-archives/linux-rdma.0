From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V5 07/12] IB/core: Add RoCE table bonding support
Date: Mon,  8 Jun 2015 17:12:10 +0300
Message-ID: <1433772735-22416-8-git-send-email-matanb@mellanox.com>
References: <1433772735-22416-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433772735-22416-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-xCNTGe7nOvUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Bonding is a unique behavior since when working in
active-backup mode, only the current selected slave
should occupy the default GIDs and the master's GID.
Listening to bonding events and only adding the
required GIDs to the active slave in the RoCE table
GID table.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/roce_gid_mgmt.c | 327 ++++++++++++++++++++++++++++++--
 drivers/net/bonding/bond_options.c      |  13 --
 include/net/bonding.h                   |   7 +
 3 files changed, 314 insertions(+), 33 deletions(-)

diff --git a/drivers/infiniband/core/roce_gid_mgmt.c b/drivers/infiniband/core/roce_gid_mgmt.c
index 6dcd1c7..b019d4e 100644
--- a/drivers/infiniband/core/roce_gid_mgmt.c
+++ b/drivers/infiniband/core/roce_gid_mgmt.c
@@ -37,6 +37,7 @@
 
 /* For in6_dev_get/in6_dev_put */
 #include <net/addrconf.h>
+#include <net/bonding.h>
 
 #include <rdma/ib_cache.h>
 #include <rdma/ib_addr.h>
@@ -55,16 +56,17 @@ struct  update_gid_event_work {
 	enum gid_op_type gid_op;
 };
 
-#define ROCE_NETDEV_CALLBACK_SZ		2
+#define ROCE_NETDEV_CALLBACK_SZ		3
 struct netdev_event_work_cmd {
 	roce_netdev_callback	cb;
 	roce_netdev_filter	filter;
+	struct net_device	*ndev;
+	struct net_device	*f_ndev;
 };
 
 struct netdev_event_work {
 	struct work_struct		work;
 	struct netdev_event_work_cmd	cmds[ROCE_NETDEV_CALLBACK_SZ];
-	struct net_device		*ndev;
 };
 
 unsigned long roce_gid_type_mask_support(struct ib_device *ib_dev, u8 port)
@@ -92,22 +94,96 @@ static void update_gid(enum gid_op_type gid_op, struct ib_device *ib_dev,
 	}
 }
 
+#define IS_NETDEV_BONDING_MASTER(ndev)	\
+	(((ndev)->priv_flags & IFF_BONDING) && \
+	 ((ndev)->flags & IFF_MASTER))
+
+enum bonding_slave_state {
+	BONDING_SLAVE_STATE_ACTIVE	= 1UL << 0,
+	BONDING_SLAVE_STATE_INACTIVE	= 1UL << 1,
+	BONDING_SLAVE_STATE_NA		= 1UL << 2,
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
+static bool is_upper_dev_rcu(struct net_device *dev, struct net_device *upper)
+{
+	struct net_device *_upper = NULL;
+	struct list_head *iter;
+
+	rcu_read_lock();
+	netdev_for_each_all_upper_dev_rcu(dev, _upper, iter) {
+		if (_upper == upper)
+			break;
+	}
+
+	rcu_read_unlock();
+	return _upper == upper;
+}
+
+static int _is_eth_port_of_netdev(struct ib_device *ib_dev, u8 port,
+				  struct net_device *idev, void *cookie,
+				  unsigned long bond_state)
+{
+	struct net_device *ndev = (struct net_device *)cookie;
+	struct net_device *rdev;
+	int res;
+
+	if (!idev)
+		return 0;
+
+	rcu_read_lock();
+	rdev = rdma_vlan_dev_real_dev(ndev);
+	if (!rdev)
+		rdev = ndev;
+
+	res = ((is_upper_dev_rcu(idev, ndev) &&
+	       (is_eth_active_slave_of_bonding(idev, rdev) &
+		bond_state)) ||
+	       rdev == idev);
+
+	rcu_read_unlock();
+	return res;
+}
+
 static int is_eth_port_of_netdev(struct ib_device *ib_dev, u8 port,
 				 struct net_device *idev, void *cookie)
 {
-	struct net_device *rdev;
-	struct net_device *mdev;
-	struct net_device *ndev = (struct net_device *)cookie;
+	return _is_eth_port_of_netdev(ib_dev, port, idev, cookie,
+				      BONDING_SLAVE_STATE_ACTIVE |
+				      BONDING_SLAVE_STATE_NA);
+}
 
+static int is_eth_port_inactive_slave(struct ib_device *ib_dev, u8 port,
+				      struct net_device *idev, void *cookie)
+{
+	struct net_device *mdev;
+	int res;
 	if (!idev)
 		return 0;
 
 	rcu_read_lock();
 	mdev = netdev_master_upper_dev_get_rcu(idev);
-	rdev = rdma_vlan_dev_real_dev(ndev);
+	res = is_eth_active_slave_of_bonding(idev, mdev) ==
+		BONDING_SLAVE_STATE_INACTIVE;
 	rcu_read_unlock();
 
-	return (rdev ? rdev : ndev) == (mdev ? mdev : idev);
+	return res;
 }
 
 static int pass_all_filter(struct ib_device *ib_dev, u8 port,
@@ -116,6 +192,34 @@ static int pass_all_filter(struct ib_device *ib_dev, u8 port,
 	return 1;
 }
 
+static int upper_device_filter(struct ib_device *ib_dev, u8 port,
+			       struct net_device *idev, void *cookie)
+{
+	struct net_device *ndev = (struct net_device *)cookie;
+
+	return idev == ndev || is_upper_dev_rcu(idev, ndev);
+}
+
+static int bonding_slaves_filter(struct ib_device *ib_dev, u8 port,
+				 struct net_device *idev, void *cookie)
+{
+	struct net_device *rdev;
+	struct net_device *ndev = (struct net_device *)cookie;
+	int res;
+
+	rdev = rdma_vlan_dev_real_dev(ndev);
+
+	ndev = rdev ? rdev : ndev;
+	if (!idev || !IS_NETDEV_BONDING_MASTER(ndev))
+		return 0;
+
+	rcu_read_lock();
+	res = is_upper_dev_rcu(idev, ndev);
+	rcu_read_unlock();
+
+	return res;
+}
+
 static void update_gid_ip(enum gid_op_type gid_op,
 			  struct ib_device *ib_dev,
 			  u8 port, struct net_device *ndev,
@@ -137,8 +241,16 @@ static void enum_netdev_default_gids(struct ib_device *ib_dev,
 {
 	unsigned long gid_type_mask;
 
-	if (idev != ndev)
+	rcu_read_lock();
+	if (!idev ||
+	    ((idev != ndev && !is_upper_dev_rcu(idev, ndev)) ||
+	     is_eth_active_slave_of_bonding(idev,
+					    netdev_master_upper_dev_get_rcu(idev)) ==
+	     BONDING_SLAVE_STATE_INACTIVE)) {
+		rcu_read_unlock();
 		return;
+	}
+	rcu_read_unlock();
 
 	gid_type_mask = roce_gid_type_mask_support(ib_dev, port);
 
@@ -146,6 +258,37 @@ static void enum_netdev_default_gids(struct ib_device *ib_dev,
 				       ROCE_GID_TABLE_DEFAULT_MODE_SET);
 }
 
+static void bond_delete_netdev_default_gids(struct ib_device *ib_dev,
+					    u8 port, struct net_device *ndev,
+					    struct net_device *idev)
+{
+	struct net_device *rdev = rdma_vlan_dev_real_dev(ndev);
+
+	if (!idev)
+		return;
+
+	if (!rdev)
+		rdev = ndev;
+
+	rcu_read_lock();
+
+	if (is_upper_dev_rcu(idev, ndev) &&
+	    is_eth_active_slave_of_bonding(idev, rdev) ==
+	    BONDING_SLAVE_STATE_INACTIVE) {
+		unsigned long gid_type_mask;
+
+		rcu_read_unlock();
+
+		gid_type_mask = roce_gid_type_mask_support(ib_dev, port);
+
+		roce_gid_table_set_default_gid(ib_dev, port, idev,
+					       gid_type_mask,
+					       ROCE_GID_TABLE_DEFAULT_MODE_DELETE);
+	} else {
+		rcu_read_unlock();
+	}
+}
+
 static void enum_netdev_ipv4_ips(struct ib_device *ib_dev,
 				 u8 port, struct net_device *ndev)
 {
@@ -221,16 +364,22 @@ static void enum_netdev_ipv6_ips(struct ib_device *ib_dev,
 }
 #endif
 
+static void _add_netdev_ips(struct ib_device *ib_dev, u8 port,
+			    struct net_device *ndev)
+{
+	enum_netdev_ipv4_ips(ib_dev, port, ndev);
+#if IS_ENABLED(CONFIG_IPV6)
+	enum_netdev_ipv6_ips(ib_dev, port, ndev);
+#endif
+}
+
 static void add_netdev_ips(struct ib_device *ib_dev, u8 port,
 			   struct net_device *idev, void *cookie)
 {
 	struct net_device *ndev = (struct net_device *)cookie;
 
 	enum_netdev_default_gids(ib_dev, port, ndev, idev);
-	enum_netdev_ipv4_ips(ib_dev, port, ndev);
-#if IS_ENABLED(CONFIG_IPV6)
-	enum_netdev_ipv6_ips(ib_dev, port, ndev);
-#endif
+	_add_netdev_ips(ib_dev, port, ndev);
 }
 
 static void del_netdev_ips(struct ib_device *ib_dev, u8 port,
@@ -284,6 +433,92 @@ static void callback_for_addr_gid_device_scan(struct ib_device *device,
 			  &parsed->gid_attr);
 }
 
+static void handle_netdev_upper(struct ib_device *ib_dev, u8 port,
+				void *cookie,
+				void (*handle_netdev)(struct ib_device *ib_dev,
+						      u8 port,
+						      struct net_device *ndev))
+{
+	struct net_device *ndev = (struct net_device *)cookie;
+	struct upper_list {
+		struct list_head list;
+		struct net_device *upper;
+	};
+	struct net_device *upper;
+	struct list_head *iter;
+	struct upper_list *upper_iter;
+	struct upper_list *upper_temp;
+	LIST_HEAD(upper_list);
+
+	rcu_read_lock();
+	netdev_for_each_all_upper_dev_rcu(ndev, upper, iter) {
+		struct upper_list *entry = kmalloc(sizeof(*entry),
+						   GFP_ATOMIC);
+
+		if (!entry) {
+			pr_info("roce_gid_mgmt: couldn't allocate entry to delete ndev\n");
+			continue;
+		}
+
+		list_add_tail(&entry->list, &upper_list);
+		dev_hold(upper);
+		entry->upper = upper;
+	}
+	rcu_read_unlock();
+
+	handle_netdev(ib_dev, port, ndev);
+	list_for_each_entry_safe(upper_iter, upper_temp, &upper_list,
+				 list) {
+		handle_netdev(ib_dev, port, upper_iter->upper);
+		dev_put(upper_iter->upper);
+		list_del(&upper_iter->list);
+		kfree(upper_iter);
+	}
+}
+
+static void _roce_del_all_netdev_gids(struct ib_device *ib_dev, u8 port,
+				      struct net_device *ndev)
+{
+	roce_del_all_netdev_gids(ib_dev, port, ndev);
+}
+
+static void del_netdev_upper_ips(struct ib_device *ib_dev, u8 port,
+				 struct net_device *idev, void *cookie)
+{
+	handle_netdev_upper(ib_dev, port, cookie, _roce_del_all_netdev_gids);
+}
+
+static void add_netdev_upper_ips(struct ib_device *ib_dev, u8 port,
+				 struct net_device *idev, void *cookie)
+{
+	handle_netdev_upper(ib_dev, port, cookie, _add_netdev_ips);
+}
+
+static void del_netdev_default_ips_join(struct ib_device *ib_dev, u8 port,
+					struct net_device *idev, void *cookie)
+{
+	struct net_device *mdev;
+
+	rcu_read_lock();
+	mdev = netdev_master_upper_dev_get_rcu(idev);
+	if (mdev)
+		dev_hold(mdev);
+	rcu_read_unlock();
+
+	if (mdev) {
+		bond_delete_netdev_default_gids(ib_dev, port, mdev, idev);
+		dev_put(mdev);
+	}
+}
+
+static void del_netdev_default_ips(struct ib_device *ib_dev, u8 port,
+				   struct net_device *idev, void *cookie)
+{
+	struct net_device *ndev = (struct net_device *)cookie;
+
+	bond_delete_netdev_default_gids(ib_dev, port, ndev, idev);
+}
+
 /* The following functions operate on all IB devices. netdevice_event and
  * addr_event execute ib_enum_roce_ports_of_netdev through a work.
  * ib_enum_roce_ports_of_netdev iterates through all IB devices, thus proper
@@ -296,11 +531,15 @@ static void netdevice_event_work_handler(struct work_struct *_work)
 		container_of(_work, struct netdev_event_work, work);
 	unsigned int i;
 
-	for (i = 0; i < ARRAY_SIZE(work->cmds) && work->cmds[i].cb; i++)
-		ib_enum_roce_ports_of_netdev(work->cmds[i].filter, work->ndev,
-					     work->cmds[i].cb, work->ndev);
+	for (i = 0; i < ARRAY_SIZE(work->cmds) && work->cmds[i].cb; i++) {
+		ib_enum_roce_ports_of_netdev(work->cmds[i].filter,
+					     work->cmds[i].f_ndev,
+					     work->cmds[i].cb,
+					     work->cmds[i].ndev);
+		dev_put(work->cmds[i].ndev);
+		dev_put(work->cmds[i].f_ndev);
+	}
 
-	dev_put(work->ndev);
 	kfree(work);
 }
 
@@ -309,11 +548,24 @@ static int netdevice_event(struct notifier_block *this, unsigned long event,
 {
 	static const struct netdev_event_work_cmd add_cmd = {
 		.cb = add_netdev_ips, .filter = is_eth_port_of_netdev};
+	static const struct netdev_event_work_cmd add_cmd_upper_ips = {
+		.cb = add_netdev_upper_ips, .filter = is_eth_port_of_netdev};
 	static const struct netdev_event_work_cmd del_cmd = {
 		.cb = del_netdev_ips, .filter = pass_all_filter};
+	static const struct netdev_event_work_cmd bonding_default_del_cmd_join = {
+		.cb = del_netdev_default_ips_join, .filter = is_eth_port_inactive_slave};
+	static const struct netdev_event_work_cmd bonding_default_del_cmd = {
+		.cb = del_netdev_default_ips, .filter = is_eth_port_inactive_slave};
+	static const struct netdev_event_work_cmd default_del_cmd = {
+		.cb = del_netdev_default_ips, .filter = pass_all_filter};
+	static const struct netdev_event_work_cmd bonding_event_ips_del_cmd = {
+		.cb = del_netdev_upper_ips, .filter = bonding_slaves_filter};
+	static const struct netdev_event_work_cmd upper_ips_del_cmd = {
+		.cb = del_netdev_upper_ips, .filter = upper_device_filter};
 	struct net_device *ndev = netdev_notifier_info_to_dev(ptr);
 	struct netdev_event_work *ndev_work;
 	struct netdev_event_work_cmd cmds[ROCE_NETDEV_CALLBACK_SZ] = { {NULL} };
+	unsigned int i;
 
 	if (ndev->type != ARPHRD_ETHER)
 		return NOTIFY_DONE;
@@ -321,7 +573,8 @@ static int netdevice_event(struct notifier_block *this, unsigned long event,
 	switch (event) {
 	case NETDEV_REGISTER:
 	case NETDEV_UP:
-		cmds[0] = add_cmd;
+		cmds[0] = bonding_default_del_cmd_join;
+		cmds[1] = add_cmd;
 		break;
 
 	case NETDEV_UNREGISTER:
@@ -332,9 +585,37 @@ static int netdevice_event(struct notifier_block *this, unsigned long event,
 		break;
 
 	case NETDEV_CHANGEADDR:
-		cmds[0] = del_cmd;
+		cmds[0] = default_del_cmd;
 		cmds[1] = add_cmd;
 		break;
+
+	case NETDEV_CHANGEUPPER:
+		{
+			struct netdev_changeupper_info *changeupper_info =
+				container_of(ptr, struct netdev_changeupper_info, info);
+
+			if (changeupper_info->event ==
+			    NETDEV_CHANGEUPPER_UNLINK) {
+				cmds[0] = upper_ips_del_cmd;
+				cmds[0].ndev = changeupper_info->upper;
+				cmds[1] = add_cmd;
+			} else if (changeupper_info->event ==
+				   NETDEV_CHANGEUPPER_LINK) {
+				cmds[0] = bonding_default_del_cmd;
+				cmds[0].ndev = changeupper_info->upper;
+				cmds[1] = add_cmd_upper_ips;
+				cmds[1].ndev = changeupper_info->upper;
+				cmds[1].f_ndev = changeupper_info->upper;
+			}
+		}
+	break;
+
+	case NETDEV_BONDING_FAILOVER:
+		cmds[0] = bonding_event_ips_del_cmd;
+		cmds[1] = bonding_default_del_cmd_join;
+		cmds[2] = add_cmd_upper_ips;
+		break;
+
 	default:
 		return NOTIFY_DONE;
 	}
@@ -346,8 +627,14 @@ static int netdevice_event(struct notifier_block *this, unsigned long event,
 	}
 
 	memcpy(ndev_work->cmds, cmds, sizeof(ndev_work->cmds));
-	ndev_work->ndev = ndev;
-	dev_hold(ndev);
+	for (i = 0; i < ARRAY_SIZE(ndev_work->cmds) && ndev_work->cmds[i].cb; i++) {
+		if (!ndev_work->cmds[i].ndev)
+			ndev_work->cmds[i].ndev = ndev;
+		if (!ndev_work->cmds[i].f_ndev)
+			ndev_work->cmds[i].f_ndev = ndev;
+		dev_hold(ndev_work->cmds[i].ndev);
+		dev_hold(ndev_work->cmds[i].f_ndev);
+	}
 	INIT_WORK(&ndev_work->work, netdevice_event_work_handler);
 
 	queue_work(roce_gid_mgmt_wq, &ndev_work->work);
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 4df2894..c4fe29a8 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -689,19 +689,6 @@ static int bond_option_mode_set(struct bonding *bond,
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
index 78ed135..81a94ed 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -307,6 +307,13 @@ static inline bool bond_uses_primary(struct bonding *bond)
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
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
