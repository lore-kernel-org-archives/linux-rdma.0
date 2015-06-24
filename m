From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V6 06/10] IB/core: Add RoCE table bonding support
Date: Wed, 24 Jun 2015 15:59:22 +0300
Message-ID: <1435150766-6803-7-git-send-email-matanb@mellanox.com>
References: <1435150766-6803-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1435150766-6803-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Handling bonding and other devices require us to all all GIDs of the
net-devices which are upper-devices of the RoCE port related
net-device.

Active-backup configurations imposes even more challenges as the
default GID should only be set on the active devices (this is
necessary as otherwise the same MAC could be used for several
slaves and thus several slaves will have identical GIDs).

Managing these configurations are done by listening to:
(a) NETDEV_CHANGEUPPER event
	(1) if a related net-device is linked, delete all inactive
	    slaves default GIDs and add the upper device GIDs.
	(2) if a related net-device is unlinked, delete all upper GIDs
	    and add the default GIDs.
(b) NETDEV_BONDING_FAILOVER:
	(1) delete the bond GIDs from inactive slaves
	(2) delete the inactive slave's default GIDs
	(3) Add the bond GIDs to the active slave.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/roce_gid_mgmt.c | 305 +++++++++++++++++++++++++++++---
 1 file changed, 285 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/core/roce_gid_mgmt.c b/drivers/infiniband/core/roce_gid_mgmt.c
index 7bf4798..6eecdfb 100644
--- a/drivers/infiniband/core/roce_gid_mgmt.c
+++ b/drivers/infiniband/core/roce_gid_mgmt.c
@@ -37,6 +37,7 @@
 
 /* For in6_dev_get/in6_dev_put */
 #include <net/addrconf.h>
+#include <net/bonding.h>
 
 #include <rdma/ib_cache.h>
 #include <rdma/ib_addr.h>
@@ -53,16 +54,17 @@ struct update_gid_event_work {
 	enum gid_op_type gid_op;
 };
 
-#define ROCE_NETDEV_CALLBACK_SZ		2
+#define ROCE_NETDEV_CALLBACK_SZ		3
 struct netdev_event_work_cmd {
 	roce_netdev_callback	cb;
 	roce_netdev_filter	filter;
+	struct net_device	*ndev;
+	struct net_device	*filter_ndev;
 };
 
 struct netdev_event_work {
 	struct work_struct		work;
 	struct netdev_event_work_cmd	cmds[ROCE_NETDEV_CALLBACK_SZ];
-	struct net_device		*ndev;
 };
 
 static void update_gid(enum gid_op_type gid_op, struct ib_device *ib_dev,
@@ -79,12 +81,70 @@ static void update_gid(enum gid_op_type gid_op, struct ib_device *ib_dev,
 	}
 }
 
+enum bonding_slave_state {
+	BONDING_SLAVE_STATE_ACTIVE	= 1UL << 0,
+	BONDING_SLAVE_STATE_INACTIVE	= 1UL << 1,
+	/* No primary slave or the device isn't a slave in bonding */
+	BONDING_SLAVE_STATE_NA		= 1UL << 2,
+};
+
+static enum bonding_slave_state is_eth_active_slave_of_bonding_rcu(struct net_device *dev,
+								   struct net_device *upper)
+{
+	if (upper && netif_is_bond_master(upper)) {
+		struct net_device *pdev =
+			bond_option_active_slave_get_rcu(netdev_priv(upper));
+
+		if (pdev)
+			return dev == pdev ? BONDING_SLAVE_STATE_ACTIVE :
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
+	netdev_for_each_all_upper_dev_rcu(dev, _upper, iter)
+		if (_upper == upper)
+			break;
+
+	return _upper == upper;
+}
+
+#define REQUIRED_BOND_STATES		(BONDING_SLAVE_STATE_ACTIVE |	\
+					 BONDING_SLAVE_STATE_NA)
 static int is_eth_port_of_netdev(struct ib_device *ib_dev, u8 port,
 				 struct net_device *rdma_ndev, void *cookie)
 {
+	struct net_device *event_ndev = (struct net_device *)cookie;
 	struct net_device *real_dev;
+	int res;
+
+	if (!rdma_ndev)
+		return 0;
+
+	rcu_read_lock();
+	real_dev = rdma_vlan_dev_real_dev(event_ndev);
+	if (!real_dev)
+		real_dev = event_ndev;
+
+	res = ((is_upper_dev_rcu(rdma_ndev, event_ndev) &&
+	       (is_eth_active_slave_of_bonding_rcu(rdma_ndev, real_dev) &
+		REQUIRED_BOND_STATES)) ||
+	       real_dev == rdma_ndev);
+
+	rcu_read_unlock();
+	return res;
+}
+
+static int is_eth_port_inactive_slave(struct ib_device *ib_dev, u8 port,
+				      struct net_device *rdma_ndev, void *cookie)
+{
 	struct net_device *master_dev;
-	struct net_device *event_ndev = (struct net_device *)cookie;
 	int res;
 
 	if (!rdma_ndev)
@@ -92,9 +152,8 @@ static int is_eth_port_of_netdev(struct ib_device *ib_dev, u8 port,
 
 	rcu_read_lock();
 	master_dev = netdev_master_upper_dev_get_rcu(rdma_ndev);
-	real_dev = rdma_vlan_dev_real_dev(event_ndev);
-	res = (real_dev ? real_dev : event_ndev) ==
-		(master_dev ? master_dev : rdma_ndev);
+	res = is_eth_active_slave_of_bonding_rcu(rdma_ndev, master_dev) ==
+		BONDING_SLAVE_STATE_INACTIVE;
 	rcu_read_unlock();
 
 	return res;
@@ -106,6 +165,25 @@ static int pass_all_filter(struct ib_device *ib_dev, u8 port,
 	return 1;
 }
 
+static int upper_device_filter(struct ib_device *ib_dev, u8 port,
+			       struct net_device *rdma_ndev, void *cookie)
+{
+	struct net_device *event_ndev = (struct net_device *)cookie;
+	int res;
+
+	if (!rdma_ndev)
+		return 0;
+
+	if (rdma_ndev == event_ndev)
+		return 1;
+
+	rcu_read_lock();
+	res = is_upper_dev_rcu(rdma_ndev, event_ndev);
+	rcu_read_unlock();
+
+	return res;
+}
+
 static void update_gid_ip(enum gid_op_type gid_op,
 			  struct ib_device *ib_dev,
 			  u8 port, struct net_device *ndev,
@@ -125,13 +203,49 @@ static void enum_netdev_default_gids(struct ib_device *ib_dev,
 				     u8 port, struct net_device *event_ndev,
 				     struct net_device *rdma_ndev)
 {
-	if (rdma_ndev != event_ndev)
+	rcu_read_lock();
+	if (!rdma_ndev ||
+	    ((rdma_ndev != event_ndev &&
+	      !is_upper_dev_rcu(rdma_ndev, event_ndev)) ||
+	     is_eth_active_slave_of_bonding_rcu(rdma_ndev,
+						netdev_master_upper_dev_get_rcu(rdma_ndev)) ==
+	     BONDING_SLAVE_STATE_INACTIVE)) {
+		rcu_read_unlock();
 		return;
+	}
+	rcu_read_unlock();
 
 	ib_cache_gid_set_default_gid(ib_dev, port, rdma_ndev,
 				     IB_CACHE_GID_DEFAULT_MODE_SET);
 }
 
+static void bond_delete_netdev_default_gids(struct ib_device *ib_dev,
+					    u8 port,
+					    struct net_device *event_ndev,
+					    struct net_device *rdma_ndev)
+{
+	struct net_device *real_dev = rdma_vlan_dev_real_dev(event_ndev);
+
+	if (!rdma_ndev)
+		return;
+
+	if (!real_dev)
+		real_dev = event_ndev;
+
+	rcu_read_lock();
+
+	if (is_upper_dev_rcu(rdma_ndev, event_ndev) &&
+	    is_eth_active_slave_of_bonding_rcu(rdma_ndev, real_dev) ==
+	    BONDING_SLAVE_STATE_INACTIVE) {
+		rcu_read_unlock();
+
+		ib_cache_gid_set_default_gid(ib_dev, port, rdma_ndev,
+					     IB_CACHE_GID_DEFAULT_MODE_DELETE);
+	} else {
+		rcu_read_unlock();
+	}
+}
+
 static void enum_netdev_ipv4_ips(struct ib_device *ib_dev,
 				 u8 port, struct net_device *ndev)
 {
@@ -205,15 +319,21 @@ static void enum_netdev_ipv6_ips(struct ib_device *ib_dev,
 	}
 }
 
+static void _add_netdev_ips(struct ib_device *ib_dev, u8 port,
+			    struct net_device *ndev)
+{
+	enum_netdev_ipv4_ips(ib_dev, port, ndev);
+	if (IS_ENABLED(CONFIG_IPV6))
+		enum_netdev_ipv6_ips(ib_dev, port, ndev);
+}
+
 static void add_netdev_ips(struct ib_device *ib_dev, u8 port,
 			   struct net_device *rdma_ndev, void *cookie)
 {
 	struct net_device *event_ndev = (struct net_device *)cookie;
 
 	enum_netdev_default_gids(ib_dev, port, event_ndev, rdma_ndev);
-	enum_netdev_ipv4_ips(ib_dev, port, event_ndev);
-	if (IS_ENABLED(CONFIG_IPV6))
-		enum_netdev_ipv6_ips(ib_dev, port, event_ndev);
+	_add_netdev_ips(ib_dev, port, event_ndev);
 }
 
 static void del_netdev_ips(struct ib_device *ib_dev, u8 port,
@@ -265,6 +385,94 @@ static void callback_for_addr_gid_device_scan(struct ib_device *device,
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
+				      struct net_device *event_ndev)
+{
+	ib_cache_gid_del_all_netdev_gids(ib_dev, port, event_ndev);
+}
+
+static void del_netdev_upper_ips(struct ib_device *ib_dev, u8 port,
+				 struct net_device *rdma_ndev, void *cookie)
+{
+	handle_netdev_upper(ib_dev, port, cookie, _roce_del_all_netdev_gids);
+}
+
+static void add_netdev_upper_ips(struct ib_device *ib_dev, u8 port,
+				 struct net_device *rdma_ndev, void *cookie)
+{
+	handle_netdev_upper(ib_dev, port, cookie, _add_netdev_ips);
+}
+
+static void del_netdev_default_ips_join(struct ib_device *ib_dev, u8 port,
+					struct net_device *rdma_ndev,
+					void *cookie)
+{
+	struct net_device *master_ndev;
+
+	rcu_read_lock();
+	master_ndev = netdev_master_upper_dev_get_rcu(rdma_ndev);
+	if (master_ndev)
+		dev_hold(master_ndev);
+	rcu_read_unlock();
+
+	if (master_ndev) {
+		bond_delete_netdev_default_gids(ib_dev, port, master_ndev,
+						rdma_ndev);
+		dev_put(master_ndev);
+	}
+}
+
+static void del_netdev_default_ips(struct ib_device *ib_dev, u8 port,
+				   struct net_device *rdma_ndev, void *cookie)
+{
+	struct net_device *event_ndev = (struct net_device *)cookie;
+
+	bond_delete_netdev_default_gids(ib_dev, port, event_ndev, rdma_ndev);
+}
+
 /* The following functions operate on all IB devices. netdevice_event and
  * addr_event execute ib_enum_all_roce_netdevs through a work.
  * ib_enum_all_roce_netdevs iterates through all IB devices.
@@ -276,17 +484,22 @@ static void netdevice_event_work_handler(struct work_struct *_work)
 		container_of(_work, struct netdev_event_work, work);
 	unsigned int i;
 
-	for (i = 0; i < ARRAY_SIZE(work->cmds) && work->cmds[i].cb; i++)
-		ib_enum_all_roce_netdevs(work->cmds[i].filter, work->ndev,
-					 work->cmds[i].cb, work->ndev);
+	for (i = 0; i < ARRAY_SIZE(work->cmds) && work->cmds[i].cb; i++) {
+		ib_enum_all_roce_netdevs(work->cmds[i].filter,
+					 work->cmds[i].filter_ndev,
+					 work->cmds[i].cb,
+					 work->cmds[i].ndev);
+		dev_put(work->cmds[i].ndev);
+		dev_put(work->cmds[i].filter_ndev);
+	}
 
-	dev_put(work->ndev);
 	kfree(work);
 }
 
 static int netdevice_queue_work(struct netdev_event_work_cmd *cmds,
 				struct net_device *ndev)
 {
+	unsigned int i;
 	struct netdev_event_work *ndev_work =
 		kmalloc(sizeof(*ndev_work), GFP_KERNEL);
 
@@ -296,8 +509,14 @@ static int netdevice_queue_work(struct netdev_event_work_cmd *cmds,
 	}
 
 	memcpy(ndev_work->cmds, cmds, sizeof(ndev_work->cmds));
-	ndev_work->ndev = ndev;
-	dev_hold(ndev);
+	for (i = 0; i < ARRAY_SIZE(ndev_work->cmds) && ndev_work->cmds[i].cb; i++) {
+		if (!ndev_work->cmds[i].ndev)
+			ndev_work->cmds[i].ndev = ndev;
+		if (!ndev_work->cmds[i].filter_ndev)
+			ndev_work->cmds[i].filter_ndev = ndev;
+		dev_hold(ndev_work->cmds[i].ndev);
+		dev_hold(ndev_work->cmds[i].filter_ndev);
+	}
 	INIT_WORK(&ndev_work->work, netdevice_event_work_handler);
 
 	queue_work(ib_wq, &ndev_work->work);
@@ -305,13 +524,45 @@ static int netdevice_queue_work(struct netdev_event_work_cmd *cmds,
 	return NOTIFY_DONE;
 }
 
+static const struct netdev_event_work_cmd add_cmd = {
+	.cb = add_netdev_ips, .filter = is_eth_port_of_netdev};
+static const struct netdev_event_work_cmd add_cmd_upper_ips = {
+	.cb = add_netdev_upper_ips, .filter = is_eth_port_of_netdev};
+
+static void netdevice_event_changeupper(struct netdev_changeupper_info *changeupper_info,
+					struct netdev_event_work_cmd *cmds)
+{
+	static const struct netdev_event_work_cmd upper_ips_del_cmd = {
+		.cb = del_netdev_upper_ips, .filter = upper_device_filter};
+	static const struct netdev_event_work_cmd bonding_default_del_cmd = {
+		.cb = del_netdev_default_ips, .filter = is_eth_port_inactive_slave};
+
+	if (changeupper_info->event ==
+	    NETDEV_CHANGEUPPER_UNLINK) {
+		cmds[0] = upper_ips_del_cmd;
+		cmds[0].ndev = changeupper_info->upper;
+		cmds[1] = add_cmd;
+	} else if (changeupper_info->event ==
+		   NETDEV_CHANGEUPPER_LINK) {
+		cmds[0] = bonding_default_del_cmd;
+		cmds[0].ndev = changeupper_info->upper;
+		cmds[1] = add_cmd_upper_ips;
+		cmds[1].ndev = changeupper_info->upper;
+		cmds[1].filter_ndev = changeupper_info->upper;
+	}
+}
+
 static int netdevice_event(struct notifier_block *this, unsigned long event,
 			   void *ptr)
 {
-	static const struct netdev_event_work_cmd add_cmd = {
-		.cb = add_netdev_ips, .filter = is_eth_port_of_netdev};
 	static const struct netdev_event_work_cmd del_cmd = {
 		.cb = del_netdev_ips, .filter = pass_all_filter};
+	static const struct netdev_event_work_cmd bonding_default_del_cmd_join = {
+		.cb = del_netdev_default_ips_join, .filter = is_eth_port_inactive_slave};
+	static const struct netdev_event_work_cmd default_del_cmd = {
+		.cb = del_netdev_default_ips, .filter = pass_all_filter};
+	static const struct netdev_event_work_cmd bonding_event_ips_del_cmd = {
+		.cb = del_netdev_upper_ips, .filter = upper_device_filter};
 	struct net_device *ndev = netdev_notifier_info_to_dev(ptr);
 	struct netdev_event_work_cmd cmds[ROCE_NETDEV_CALLBACK_SZ] = { {NULL} };
 
@@ -321,7 +572,8 @@ static int netdevice_event(struct notifier_block *this, unsigned long event,
 	switch (event) {
 	case NETDEV_REGISTER:
 	case NETDEV_UP:
-		cmds[0] = add_cmd;
+		cmds[0] = bonding_default_del_cmd_join;
+		cmds[1] = add_cmd;
 		break;
 
 	case NETDEV_UNREGISTER:
@@ -332,9 +584,22 @@ static int netdevice_event(struct notifier_block *this, unsigned long event,
 		break;
 
 	case NETDEV_CHANGEADDR:
-		cmds[0] = del_cmd;
+		cmds[0] = default_del_cmd;
 		cmds[1] = add_cmd;
 		break;
+
+	case NETDEV_CHANGEUPPER:
+		netdevice_event_changeupper(
+			container_of(ptr, struct netdev_changeupper_info, info),
+			cmds);
+		break;
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
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
