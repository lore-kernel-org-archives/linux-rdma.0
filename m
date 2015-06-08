From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V5 03/12] IB/core: Add RoCE GID population
Date: Mon,  8 Jun 2015 17:12:06 +0300
Message-ID: <1433772735-22416-4-git-send-email-matanb@mellanox.com>
References: <1433772735-22416-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433772735-22416-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-xCNTGe7nOvUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In order to populate the GID table, we need to listen for
events:
(a) IB device has been added or removed - used in order
    to allocate/deallocate the table and populate
    the GID table internally.
(b) inet events - add new GIDs (according to the IP addresses)
    to the table.
(c) netdev up/down/change_addr - if a netdev is built onto our
    RoCE device, we need to add/delete its IPs.

When an event is received, multiple entries (each with
different GID type) are added.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/Makefile         |   2 +-
 drivers/infiniband/core/core_priv.h      |  26 ++
 drivers/infiniband/core/device.c         |  77 +++++
 drivers/infiniband/core/roce_gid_mgmt.c  | 471 +++++++++++++++++++++++++++++++
 drivers/infiniband/core/roce_gid_table.c |  52 ++++
 include/rdma/ib_addr.h                   |   2 +-
 include/rdma/ib_verbs.h                  |   8 +
 7 files changed, 636 insertions(+), 2 deletions(-)
 create mode 100644 drivers/infiniband/core/roce_gid_mgmt.c

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index fbeb72a..3ceb3f8 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -10,7 +10,7 @@ obj-$(CONFIG_INFINIBAND_USER_ACCESS) +=	ib_uverbs.o ib_ucm.o \
 
 ib_core-y :=			packer.o ud_header.o verbs.o sysfs.o \
 				device.o fmr_pool.o cache.o netlink.o \
-				roce_gid_table.o
+				roce_gid_table.o roce_gid_mgmt.o
 ib_core-$(CONFIG_INFINIBAND_USER_MEM) += umem.o
 ib_core-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) += umem_odp.o umem_rbtree.o
 
diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index a9e58418..eab4e6c 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -39,6 +39,8 @@
 
 #include <rdma/ib_verbs.h>
 
+extern struct workqueue_struct *roce_gid_mgmt_wq;
+
 int  ib_device_register_sysfs(struct ib_device *device,
 			      int (*port_callback)(struct ib_device *,
 						   u8, struct kobject *));
@@ -53,6 +55,22 @@ void ib_cache_cleanup(void);
 int ib_resolve_eth_l2_attrs(struct ib_qp *qp,
 			    struct ib_qp_attr *qp_attr, int *qp_attr_mask);
 
+typedef void (*roce_netdev_callback)(struct ib_device *device, u8 port,
+	      struct net_device *idev, void *cookie);
+
+typedef int (*roce_netdev_filter)(struct ib_device *device, u8 port,
+	     struct net_device *idev, void *cookie);
+
+void ib_dev_roce_ports_of_netdev(struct ib_device *ib_dev,
+				 roce_netdev_filter filter,
+				 void *filter_cookie,
+				 roce_netdev_callback cb,
+				 void *cookie);
+void ib_enum_roce_ports_of_netdev(roce_netdev_filter filter,
+				  void *filter_cookie,
+				  roce_netdev_callback cb,
+				  void *cookie);
+
 int roce_gid_table_get_gid(struct ib_device *ib_dev, u8 port, int index,
 			   union ib_gid *gid, struct ib_gid_attr *attr);
 
@@ -65,6 +83,9 @@ int roce_gid_table_find_gid_by_port(struct ib_device *ib_dev,
 				    u8 port, struct net_device *ndev,
 				    u16 *index);
 
+int roce_gid_table_setup(void);
+void roce_gid_table_cleanup(void);
+
 int roce_add_gid(struct ib_device *ib_dev, u8 port,
 		 union ib_gid *gid, struct ib_gid_attr *attr);
 
@@ -74,4 +95,9 @@ int roce_del_gid(struct ib_device *ib_dev, u8 port,
 int roce_del_all_netdev_gids(struct ib_device *ib_dev, u8 port,
 			     struct net_device *ndev);
 
+int roce_gid_mgmt_init(void);
+void roce_gid_mgmt_cleanup(void);
+
+int roce_rescan_device(struct ib_device *ib_dev);
+
 #endif /* _CORE_PRIV_H */
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 7e83f0d..84edb9a 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -39,6 +39,7 @@
 #include <linux/init.h>
 #include <linux/mutex.h>
 #include <rdma/rdma_netlink.h>
+#include <rdma/ib_addr.h>
 
 #include "core_priv.h"
 
@@ -597,6 +598,79 @@ int ib_query_gid(struct ib_device *device,
 EXPORT_SYMBOL(ib_query_gid);
 
 /**
+ * ib_dev_roce_ports_of_netdev - enumerate RoCE ports of ibdev in
+ *				 respect of netdev
+ * @ib_dev : IB device we want to query
+ * @filter: Should we call the callback?
+ * @filter_cookie: Cookie passed to filter
+ * @cb: Callback to call for each found RoCE ports
+ * @cookie: Cookie passed back to the callback
+ *
+ * Enumerates all of the physical RoCE ports of ib_dev RoCE ports
+ * which are relaying Ethernet packets to a specific
+ * (possibly virtual) netdevice according to filter.
+ */
+void ib_dev_roce_ports_of_netdev(struct ib_device *ib_dev,
+				 roce_netdev_filter filter,
+				 void *filter_cookie,
+				 roce_netdev_callback cb,
+				 void *cookie)
+{
+	u8 port;
+
+	if (ib_dev->modify_gid)
+		for (port = rdma_start_port(ib_dev); port <= rdma_end_port(ib_dev);
+		     port++)
+			if (rdma_protocol_roce(ib_dev, port)) {
+				struct net_device *idev = NULL;
+
+				rcu_read_lock();
+				if (ib_dev->get_netdev)
+					idev = ib_dev->get_netdev(ib_dev, port);
+
+				if (idev &&
+				    idev->reg_state >= NETREG_UNREGISTERED)
+					idev = NULL;
+
+				if (idev)
+					dev_hold(idev);
+
+				rcu_read_unlock();
+
+				if (filter(ib_dev, port, idev, filter_cookie))
+					cb(ib_dev, port, idev, cookie);
+
+				if (idev)
+					dev_put(idev);
+			}
+}
+
+/**
+ * ib_enum_roce_ports_of_netdev - enumerate RoCE ports of a netdev
+ * @filter: Should we call the callback?
+ * @filter_cookie: Cookie passed to filter
+ * @cb: Callback to call for each found RoCE ports
+ * @cookie: Cookie passed back to the callback
+ *
+ * Enumerates all of the physical RoCE ports which are relaying
+ * Ethernet packets to a specific (possibly virtual) netdevice
+ * according to filter.
+ */
+void ib_enum_roce_ports_of_netdev(roce_netdev_filter filter,
+				  void *filter_cookie,
+				  roce_netdev_callback cb,
+				  void *cookie)
+{
+	struct ib_device *dev;
+
+	down_read(&lists_rwsem);
+	list_for_each_entry_rcu(dev, &device_list, core_list)
+		ib_dev_roce_ports_of_netdev(dev, filter, filter_cookie, cb,
+					    cookie);
+	up_read(&lists_rwsem);
+}
+
+/**
  * ib_query_pkey - Get P_Key table entry
  * @device:Device to query
  * @port_num:Port number to query
@@ -751,6 +825,8 @@ static int __init ib_core_init(void)
 		goto err_sysfs;
 	}
 
+	roce_gid_table_setup();
+
 	ret = ib_cache_setup();
 	if (ret) {
 		printk(KERN_WARNING "Couldn't set up InfiniBand P_Key/GID cache\n");
@@ -772,6 +848,7 @@ err:
 
 static void __exit ib_core_cleanup(void)
 {
+	roce_gid_table_cleanup();
 	ib_cache_cleanup();
 	ibnl_cleanup();
 	ib_sysfs_cleanup();
diff --git a/drivers/infiniband/core/roce_gid_mgmt.c b/drivers/infiniband/core/roce_gid_mgmt.c
new file mode 100644
index 0000000..70616fc
--- /dev/null
+++ b/drivers/infiniband/core/roce_gid_mgmt.c
@@ -0,0 +1,471 @@
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
+struct workqueue_struct *roce_gid_mgmt_wq;
+
+enum gid_op_type {
+	GID_DEL = 0,
+	GID_ADD
+};
+
+struct  update_gid_event_work {
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
+	if (rdma_protocol_roce(ib_dev, port)) {
+		switch (gid_op) {
+		case GID_ADD:
+			roce_add_gid(ib_dev, port,
+				     gid, gid_attr);
+			break;
+		case GID_DEL:
+			roce_del_gid(ib_dev, port,
+				     gid, gid_attr);
+			break;
+		}
+	}
+}
+
+static int is_eth_port_of_netdev(struct ib_device *ib_dev, u8 port,
+				 struct net_device *idev, void *cookie)
+{
+	struct net_device *rdev;
+	struct net_device *mdev;
+	struct net_device *ndev = (struct net_device *)cookie;
+
+	if (!idev)
+		return 0;
+
+	rcu_read_lock();
+	mdev = netdev_master_upper_dev_get_rcu(idev);
+	rdev = rdma_vlan_dev_real_dev(ndev);
+	rcu_read_unlock();
+
+	return (rdev ? rdev : ndev) == (mdev ? mdev : idev);
+}
+
+static int pass_all_filter(struct ib_device *ib_dev, u8 port,
+			   struct net_device *idev, void *cookie)
+{
+	return 1;
+}
+
+static void update_gid_ip(enum gid_op_type gid_op,
+			  struct ib_device *ib_dev,
+			  u8 port, struct net_device *ndev,
+			  const struct sockaddr *addr)
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
+#if IS_ENABLED(CONFIG_IPV6)
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
+		rdma_ip2gid((const struct sockaddr *)&sin6_iter->sin6, &gid);
+		update_gid(GID_ADD, ib_dev, port, &gid, &gid_attr);
+		list_del(&sin6_iter->list);
+		kfree(sin6_iter);
+	}
+}
+#endif
+
+static void add_netdev_ips(struct ib_device *ib_dev, u8 port,
+			   struct net_device *idev, void *cookie)
+{
+	struct net_device *ndev = (struct net_device *)cookie;
+
+	enum_netdev_ipv4_ips(ib_dev, port, ndev);
+#if IS_ENABLED(CONFIG_IPV6)
+	enum_netdev_ipv6_ips(ib_dev, port, ndev);
+#endif
+}
+
+static void del_netdev_ips(struct ib_device *ib_dev, u8 port,
+			   struct net_device *idev, void *cookie)
+{
+	struct net_device *ndev = (struct net_device *)cookie;
+
+	roce_del_all_netdev_gids(ib_dev, port, ndev);
+}
+
+static void enum_all_gids_of_dev_cb(struct ib_device *ib_dev,
+				    u8 port,
+				    struct net_device *idev,
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
+			if (is_eth_port_of_netdev(ib_dev, port, idev, ndev))
+				add_netdev_ips(ib_dev, port, idev, ndev);
+	rtnl_unlock();
+}
+
+/* This function will rescan all of the network devices in the system
+ * and add their gids, as needed, to the relevant RoCE devices. Will
+ * take rtnl and the IB device list mutexes. Must not be called from
+ * ib_wq or deadlock will happen. */
+int roce_rescan_device(struct ib_device *ib_dev)
+{
+	ib_dev_roce_ports_of_netdev(ib_dev, pass_all_filter, NULL,
+				    enum_all_gids_of_dev_cb, NULL);
+
+	return 0;
+}
+
+static void callback_for_addr_gid_device_scan(struct ib_device *device,
+					      u8 port,
+					      struct net_device *idev,
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
+ * addr_event execute ib_enum_roce_ports_of_netdev through a work.
+ * ib_enum_roce_ports_of_netdev iterates through all IB devices, thus proper
+ * usage of SRCU is required
+ */
+
+static void netdevice_event_work_handler(struct work_struct *_work)
+{
+	struct netdev_event_work *work =
+		container_of(_work, struct netdev_event_work, work);
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(work->cmds) && work->cmds[i].cb; i++)
+		ib_enum_roce_ports_of_netdev(work->cmds[i].filter, work->ndev,
+					     work->cmds[i].cb, work->ndev);
+
+	dev_put(work->ndev);
+	kfree(work);
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
+	struct netdev_event_work *ndev_work;
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
+	ndev_work = kmalloc(sizeof(*ndev_work), GFP_KERNEL);
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
+	queue_work(roce_gid_mgmt_wq, &ndev_work->work);
+
+	return NOTIFY_DONE;
+}
+
+static void update_gid_event_work_handler(struct work_struct *_work)
+{
+	struct update_gid_event_work *work =
+		container_of(_work, struct update_gid_event_work, work);
+
+	ib_enum_roce_ports_of_netdev(is_eth_port_of_netdev, work->gid_attr.ndev,
+				     callback_for_addr_gid_device_scan, work);
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
+	queue_work(roce_gid_mgmt_wq, &work->work);
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
+#if IS_ENABLED(CONFIG_IPV6)
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
+#endif
+
+static struct notifier_block nb_netdevice = {
+	.notifier_call = netdevice_event
+};
+
+static struct notifier_block nb_inetaddr = {
+	.notifier_call = inetaddr_event
+};
+
+#if IS_ENABLED(CONFIG_IPV6)
+static struct notifier_block nb_inet6addr = {
+	.notifier_call = inet6addr_event
+};
+#endif
+
+int __init roce_gid_mgmt_init(void)
+{
+	roce_gid_mgmt_wq = alloc_ordered_workqueue("roce_gid_mgmt_wq", 0);
+
+	if (!roce_gid_mgmt_wq) {
+		pr_warn("roce_gid_mgmt: can't allocate work queue\n");
+		return -ENOMEM;
+	}
+
+	register_inetaddr_notifier(&nb_inetaddr);
+#if IS_ENABLED(CONFIG_IPV6)
+	register_inet6addr_notifier(&nb_inet6addr);
+#endif
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
+#if IS_ENABLED(CONFIG_IPV6)
+	unregister_inet6addr_notifier(&nb_inet6addr);
+#endif
+	unregister_inetaddr_notifier(&nb_inetaddr);
+	unregister_netdevice_notifier(&nb_netdevice);
+	/* Ensure all gid deletion tasks complete before we go down,
+	 * to avoid any reference to free'd memory. By the time
+	 * ib-core is removed, all physical devices have been removed,
+	 * so no issue with remaining hardware contexts.
+	 */
+	synchronize_rcu();
+	drain_workqueue(roce_gid_mgmt_wq);
+	destroy_workqueue(roce_gid_mgmt_wq);
+}
diff --git a/drivers/infiniband/core/roce_gid_table.c b/drivers/infiniband/core/roce_gid_table.c
index f492cf1..5e9e4dc 100644
--- a/drivers/infiniband/core/roce_gid_table.c
+++ b/drivers/infiniband/core/roce_gid_table.c
@@ -468,3 +468,55 @@ static void roce_gid_table_cleanup_one(struct ib_device *ib_dev,
 	kfree(table);
 }
 
+static void roce_gid_table_client_cleanup_one(struct ib_device *ib_dev)
+{
+	struct ib_roce_gid_table **table = ib_dev->cache.roce_gid_table;
+
+	if (!table)
+		return;
+
+	ib_dev->cache.roce_gid_table = NULL;
+	/* smp_wmb is mandatory in order to make sure all executing works
+	 * realize we're freeing this roce_gid_table. Every function which
+	 * could be executed in a work, fetches ib_dev->cache.roce_gid_table
+	 * once (READ_ONCE + smp_rmb) into a local variable.
+	 * If it fetched a value != NULL, we wait for this work to finish by
+	 * calling flush_workqueue. If it fetches NULL, it'll return immediately.
+	 */
+	smp_wmb();
+	/* Make sure no gid update task is still referencing this device */
+	flush_workqueue(roce_gid_mgmt_wq);
+
+	roce_gid_table_cleanup_one(ib_dev, table);
+}
+
+static void roce_gid_table_client_setup_one(struct ib_device *ib_dev)
+{
+	if (!roce_gid_table_setup_one(ib_dev))
+		if (roce_rescan_device(ib_dev))
+			roce_gid_table_client_cleanup_one(ib_dev);
+}
+
+static struct ib_client table_client = {
+	.name   = "roce_gid_table",
+	.add    = roce_gid_table_client_setup_one,
+	.remove = roce_gid_table_client_cleanup_one
+};
+
+int __init roce_gid_table_setup(void)
+{
+	roce_gid_mgmt_init();
+
+	return ib_register_client(&table_client);
+}
+
+void __exit roce_gid_table_cleanup(void)
+{
+	ib_unregister_client(&table_client);
+
+	roce_gid_mgmt_cleanup();
+
+	flush_workqueue(system_wq);
+
+	rcu_barrier();
+}
diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index fde33ac..850eec6 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -142,7 +142,7 @@ static inline u16 rdma_vlan_dev_vlan_id(const struct net_device *dev)
 		vlan_dev_vlan_id(dev) : 0xffff;
 }
 
-static inline int rdma_ip2gid(struct sockaddr *addr, union ib_gid *gid)
+static inline int rdma_ip2gid(const struct sockaddr *addr, union ib_gid *gid)
 {
 	switch (addr->sa_family) {
 	case AF_INET:
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 72b62cd..05dcfad 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1579,6 +1579,14 @@ struct ib_device {
 						 struct ib_port_attr *port_attr);
 	enum rdma_link_layer	   (*get_link_layer)(struct ib_device *device,
 						     u8 port_num);
+	/* When calling get_netdev, the HW vendor's driver should return the
+	 * net device of device @device at port @port_num. The function
+	 * is called in rtnl_lock. The HW vendor's device driver must guarantee
+	 * to return NULL before the net device has reached
+	 * NETDEV_UNREGISTER_FINAL state.
+	 */
+	struct net_device	  *(*get_netdev)(struct ib_device *device,
+						 u8 port_num);
 	int		           (*query_gid)(struct ib_device *device,
 						u8 port_num, int index,
 						union ib_gid *gid);
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
