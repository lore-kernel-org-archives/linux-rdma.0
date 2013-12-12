From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V6 for-next 3/7] IB/mlx4: Use IBoE (RoCE) IP based GIDs in the port GID table
Date: Thu, 12 Dec 2013 18:03:13 +0200
Message-ID: <1386864197-10591-4-git-send-email-ogerlitz@mellanox.com>
References: <1386864197-10591-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1386864197-10591-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Currently, the mlx4 driver set IBoE (RoCE) gids to encode related
Ethernet netdevice interface MAC address and possibly VLAN id.

Change this scheme such that gids encode interface IP addresses
(both IP4 and IPv6).

This requires learning which are the IP addresses which are of use
by a netdevice associated with the HCA port, formatting them to gids
and adding them to the port gid table. Further, events of add and
delete address are caught to maintain the gid table accordingly.

Associated IP addresses may belong to a master of an Ethernet netdevice
on top of that port so this should be considered when building and
maintaining the gid table.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c    |  474 ++++++++++++++++++++++++----------
 drivers/infiniband/hw/mlx4/mlx4_ib.h |    3 +
 2 files changed, 334 insertions(+), 143 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 1958c5c..a776aab 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -39,6 +39,8 @@
 #include <linux/inetdevice.h>
 #include <linux/rtnetlink.h>
 #include <linux/if_vlan.h>
+#include <net/ipv6.h>
+#include <net/addrconf.h>
 
 #include <rdma/ib_smi.h>
 #include <rdma/ib_user_verbs.h>
@@ -787,7 +789,6 @@ static int add_gid_entry(struct ib_qp *ibqp, union ib_gid *gid)
 int mlx4_ib_add_mc(struct mlx4_ib_dev *mdev, struct mlx4_ib_qp *mqp,
 		   union ib_gid *gid)
 {
-	u8 mac[6];
 	struct net_device *ndev;
 	int ret = 0;
 
@@ -801,11 +802,7 @@ int mlx4_ib_add_mc(struct mlx4_ib_dev *mdev, struct mlx4_ib_qp *mqp,
 	spin_unlock(&mdev->iboe.lock);
 
 	if (ndev) {
-		rdma_get_mcast_mac((struct in6_addr *)gid, mac);
-		rtnl_lock();
-		dev_mc_add(mdev->iboe.netdevs[mqp->port - 1], mac);
 		ret = 1;
-		rtnl_unlock();
 		dev_put(ndev);
 	}
 
@@ -1025,6 +1022,8 @@ static int mlx4_ib_mcg_attach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 	struct mlx4_ib_qp *mqp = to_mqp(ibqp);
 	u64 reg_id;
 	struct mlx4_ib_steering *ib_steering = NULL;
+	enum mlx4_protocol prot = (gid->raw[1] == 0x0e) ?
+		MLX4_PROT_IB_IPV4 : MLX4_PROT_IB_IPV6;
 
 	if (mdev->dev->caps.steering_mode ==
 	    MLX4_STEERING_MODE_DEVICE_MANAGED) {
@@ -1036,7 +1035,7 @@ static int mlx4_ib_mcg_attach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 	err = mlx4_multicast_attach(mdev->dev, &mqp->mqp, gid->raw, mqp->port,
 				    !!(mqp->flags &
 				       MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK),
-				    MLX4_PROT_IB_IPV6, &reg_id);
+				    prot, &reg_id);
 	if (err)
 		goto err_malloc;
 
@@ -1055,7 +1054,7 @@ static int mlx4_ib_mcg_attach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 
 err_add:
 	mlx4_multicast_detach(mdev->dev, &mqp->mqp, gid->raw,
-			      MLX4_PROT_IB_IPV6, reg_id);
+			      prot, reg_id);
 err_malloc:
 	kfree(ib_steering);
 
@@ -1083,10 +1082,11 @@ static int mlx4_ib_mcg_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 	int err;
 	struct mlx4_ib_dev *mdev = to_mdev(ibqp->device);
 	struct mlx4_ib_qp *mqp = to_mqp(ibqp);
-	u8 mac[6];
 	struct net_device *ndev;
 	struct mlx4_ib_gid_entry *ge;
 	u64 reg_id = 0;
+	enum mlx4_protocol prot = (gid->raw[1] == 0x0e) ?
+		MLX4_PROT_IB_IPV4 : MLX4_PROT_IB_IPV6;
 
 	if (mdev->dev->caps.steering_mode ==
 	    MLX4_STEERING_MODE_DEVICE_MANAGED) {
@@ -1109,7 +1109,7 @@ static int mlx4_ib_mcg_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 	}
 
 	err = mlx4_multicast_detach(mdev->dev, &mqp->mqp, gid->raw,
-				    MLX4_PROT_IB_IPV6, reg_id);
+				    prot, reg_id);
 	if (err)
 		return err;
 
@@ -1121,13 +1121,8 @@ static int mlx4_ib_mcg_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 		if (ndev)
 			dev_hold(ndev);
 		spin_unlock(&mdev->iboe.lock);
-		rdma_get_mcast_mac((struct in6_addr *)gid, mac);
-		if (ndev) {
-			rtnl_lock();
-			dev_mc_del(mdev->iboe.netdevs[ge->port - 1], mac);
-			rtnl_unlock();
+		if (ndev)
 			dev_put(ndev);
-		}
 		list_del(&ge->list);
 		kfree(ge);
 	} else
@@ -1223,20 +1218,6 @@ static struct device_attribute *mlx4_class_attributes[] = {
 	&dev_attr_board_id
 };
 
-static void mlx4_addrconf_ifid_eui48(u8 *eui, u16 vlan_id, struct net_device *dev)
-{
-	memcpy(eui, dev->dev_addr, 3);
-	memcpy(eui + 5, dev->dev_addr + 3, 3);
-	if (vlan_id < 0x1000) {
-		eui[3] = vlan_id >> 8;
-		eui[4] = vlan_id & 0xff;
-	} else {
-		eui[3] = 0xff;
-		eui[4] = 0xfe;
-	}
-	eui[0] ^= 2;
-}
-
 static void update_gids_task(struct work_struct *work)
 {
 	struct update_gid_work *gw = container_of(work, struct update_gid_work, work);
@@ -1259,161 +1240,318 @@ static void update_gids_task(struct work_struct *work)
 		       MLX4_CMD_WRAPPED);
 	if (err)
 		pr_warn("set port command failed\n");
-	else {
-		memcpy(gw->dev->iboe.gid_table[gw->port - 1], gw->gids, sizeof gw->gids);
+	else
 		mlx4_ib_dispatch_event(gw->dev, gw->port, IB_EVENT_GID_CHANGE);
-	}
 
 	mlx4_free_cmd_mailbox(dev, mailbox);
 	kfree(gw);
 }
 
-static int update_ipv6_gids(struct mlx4_ib_dev *dev, int port, int clear)
+static void reset_gids_task(struct work_struct *work)
 {
-	struct net_device *ndev = dev->iboe.netdevs[port - 1];
-	struct update_gid_work *work;
-	struct net_device *tmp;
+	struct update_gid_work *gw =
+			container_of(work, struct update_gid_work, work);
+	struct mlx4_cmd_mailbox *mailbox;
+	union ib_gid *gids;
+	int err;
 	int i;
-	u8 *hits;
-	int ret;
-	union ib_gid gid;
-	int free;
-	int found;
-	int need_update = 0;
-	u16 vid;
+	struct mlx4_dev	*dev = gw->dev->dev;
 
-	work = kzalloc(sizeof *work, GFP_ATOMIC);
-	if (!work)
-		return -ENOMEM;
+	mailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(mailbox)) {
+		pr_warn("reset gid table failed\n");
+		goto free;
+	}
 
-	hits = kzalloc(128, GFP_ATOMIC);
-	if (!hits) {
-		ret = -ENOMEM;
-		goto out;
+	gids = mailbox->buf;
+	memcpy(gids, gw->gids, sizeof(gw->gids));
+
+	for (i = 1; i < gw->dev->num_ports + 1; i++) {
+		if (mlx4_ib_port_link_layer(&gw->dev->ib_dev, i) ==
+					    IB_LINK_LAYER_ETHERNET) {
+			err = mlx4_cmd(dev, mailbox->dma,
+				       MLX4_SET_PORT_GID_TABLE << 8 | i,
+				       1, MLX4_CMD_SET_PORT,
+				       MLX4_CMD_TIME_CLASS_B,
+				       MLX4_CMD_WRAPPED);
+			if (err)
+				pr_warn(KERN_WARNING
+					"set port %d command failed\n", i);
+		}
 	}
 
-	rcu_read_lock();
-	for_each_netdev_rcu(&init_net, tmp) {
-		if (ndev && (tmp == ndev || rdma_vlan_dev_real_dev(tmp) == ndev)) {
-			gid.global.subnet_prefix = cpu_to_be64(0xfe80000000000000LL);
-			vid = rdma_vlan_dev_vlan_id(tmp);
-			mlx4_addrconf_ifid_eui48(&gid.raw[8], vid, ndev);
-			found = 0;
-			free = -1;
-			for (i = 0; i < 128; ++i) {
-				if (free < 0 &&
-				    !memcmp(&dev->iboe.gid_table[port - 1][i], &zgid, sizeof zgid))
-					free = i;
-				if (!memcmp(&dev->iboe.gid_table[port - 1][i], &gid, sizeof gid)) {
-					hits[i] = 1;
-					found = 1;
-					break;
-				}
-			}
+	mlx4_free_cmd_mailbox(dev, mailbox);
+free:
+	kfree(gw);
+}
 
-			if (!found) {
-				if (tmp == ndev &&
-				    (memcmp(&dev->iboe.gid_table[port - 1][0],
-					    &gid, sizeof gid) ||
-				     !memcmp(&dev->iboe.gid_table[port - 1][0],
-					     &zgid, sizeof gid))) {
-					dev->iboe.gid_table[port - 1][0] = gid;
-					++need_update;
-					hits[0] = 1;
-				} else if (free >= 0) {
-					dev->iboe.gid_table[port - 1][free] = gid;
-					hits[free] = 1;
-					++need_update;
-				}
+static int update_gid_table(struct mlx4_ib_dev *dev, int port,
+			    union ib_gid *gid, int clear)
+{
+	struct update_gid_work *work;
+	int i;
+	int need_update = 0;
+	int free = -1;
+	int found = -1;
+	int max_gids;
+
+	max_gids = dev->dev->caps.gid_table_len[port];
+	for (i = 0; i < max_gids; ++i) {
+		if (!memcmp(&dev->iboe.gid_table[port - 1][i], gid,
+			    sizeof(*gid)))
+			found = i;
+
+		if (clear) {
+			if (found >= 0) {
+				need_update = 1;
+				dev->iboe.gid_table[port - 1][found] = zgid;
+				break;
 			}
+		} else {
+			if (found >= 0)
+				break;
+
+			if (free < 0 &&
+			    !memcmp(&dev->iboe.gid_table[port - 1][i], &zgid,
+				    sizeof(*gid)))
+				free = i;
 		}
 	}
-	rcu_read_unlock();
 
-	for (i = 0; i < 128; ++i)
-		if (!hits[i]) {
-			if (memcmp(&dev->iboe.gid_table[port - 1][i], &zgid, sizeof zgid))
-				++need_update;
-			dev->iboe.gid_table[port - 1][i] = zgid;
-		}
+	if (found == -1 && !clear && free >= 0) {
+		dev->iboe.gid_table[port - 1][free] = *gid;
+		need_update = 1;
+	}
 
-	if (need_update) {
-		memcpy(work->gids, dev->iboe.gid_table[port - 1], sizeof work->gids);
-		INIT_WORK(&work->work, update_gids_task);
-		work->port = port;
-		work->dev = dev;
-		queue_work(wq, &work->work);
-	} else
-		kfree(work);
+	if (!need_update)
+		return 0;
+
+	work = kzalloc(sizeof(*work), GFP_ATOMIC);
+	if (!work)
+		return -ENOMEM;
+
+	memcpy(work->gids, dev->iboe.gid_table[port - 1], sizeof(work->gids));
+	INIT_WORK(&work->work, update_gids_task);
+	work->port = port;
+	work->dev = dev;
+	queue_work(wq, &work->work);
 
-	kfree(hits);
 	return 0;
+}
 
-out:
-	kfree(work);
-	return ret;
+static int reset_gid_table(struct mlx4_ib_dev *dev)
+{
+	struct update_gid_work *work;
+
+
+	work = kzalloc(sizeof(*work), GFP_ATOMIC);
+	if (!work)
+		return -ENOMEM;
+	memset(dev->iboe.gid_table, 0, sizeof(dev->iboe.gid_table));
+	memset(work->gids, 0, sizeof(work->gids));
+	INIT_WORK(&work->work, reset_gids_task);
+	work->dev = dev;
+	queue_work(wq, &work->work);
+	return 0;
 }
 
-static void handle_en_event(struct mlx4_ib_dev *dev, int port, unsigned long event)
+static int mlx4_ib_addr_event(int event, struct net_device *event_netdev,
+			      struct mlx4_ib_dev *ibdev, union ib_gid *gid)
 {
-	switch (event) {
-	case NETDEV_UP:
-	case NETDEV_CHANGEADDR:
-		update_ipv6_gids(dev, port, 0);
-		break;
+	struct mlx4_ib_iboe *iboe;
+	int port = 0;
+	struct net_device *real_dev = rdma_vlan_dev_real_dev(event_netdev) ?
+				rdma_vlan_dev_real_dev(event_netdev) :
+				event_netdev;
+
+	if (event != NETDEV_DOWN && event != NETDEV_UP)
+		return 0;
+
+	if ((real_dev != event_netdev) &&
+	    (event == NETDEV_DOWN) &&
+	    rdma_link_local_addr((struct in6_addr *)gid))
+		return 0;
+
+	iboe = &ibdev->iboe;
+	spin_lock(&iboe->lock);
+
+	for (port = 1; port <= MLX4_MAX_PORTS; ++port)
+		if ((netif_is_bond_master(real_dev) &&
+		     (real_dev == iboe->masters[port - 1])) ||
+		     (!netif_is_bond_master(real_dev) &&
+		     (real_dev == iboe->netdevs[port - 1])))
+			update_gid_table(ibdev, port, gid,
+					 event == NETDEV_DOWN);
+
+	spin_unlock(&iboe->lock);
+	return 0;
 
-	case NETDEV_DOWN:
-		update_ipv6_gids(dev, port, 1);
-		dev->iboe.netdevs[port - 1] = NULL;
-	}
 }
 
-static void netdev_added(struct mlx4_ib_dev *dev, int port)
+static u8 mlx4_ib_get_dev_port(struct net_device *dev,
+			       struct mlx4_ib_dev *ibdev)
 {
-	update_ipv6_gids(dev, port, 0);
+	u8 port = 0;
+	struct mlx4_ib_iboe *iboe;
+	struct net_device *real_dev = rdma_vlan_dev_real_dev(dev) ?
+				rdma_vlan_dev_real_dev(dev) : dev;
+
+	iboe = &ibdev->iboe;
+	spin_lock(&iboe->lock);
+
+	for (port = 1; port <= MLX4_MAX_PORTS; ++port)
+		if ((netif_is_bond_master(real_dev) &&
+		     (real_dev == iboe->masters[port - 1])) ||
+		     (!netif_is_bond_master(real_dev) &&
+		     (real_dev == iboe->netdevs[port - 1])))
+			break;
+
+	spin_unlock(&iboe->lock);
+
+	if ((port == 0) || (port > MLX4_MAX_PORTS))
+		return 0;
+	else
+		return port;
 }
 
-static void netdev_removed(struct mlx4_ib_dev *dev, int port)
+static int mlx4_ib_inet_event(struct notifier_block *this, unsigned long event,
+				void *ptr)
 {
-	update_ipv6_gids(dev, port, 1);
+	struct mlx4_ib_dev *ibdev;
+	struct in_ifaddr *ifa = ptr;
+	union ib_gid gid;
+	struct net_device *event_netdev = ifa->ifa_dev->dev;
+
+	ipv6_addr_set_v4mapped(ifa->ifa_address, (struct in6_addr *)&gid);
+
+	ibdev = container_of(this, struct mlx4_ib_dev, iboe.nb_inet);
+
+	mlx4_ib_addr_event(event, event_netdev, ibdev, &gid);
+	return NOTIFY_DONE;
 }
 
-static int mlx4_ib_netdev_event(struct notifier_block *this, unsigned long event,
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+static int mlx4_ib_inet6_event(struct notifier_block *this, unsigned long event,
 				void *ptr)
 {
-	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	struct mlx4_ib_dev *ibdev;
-	struct net_device *oldnd;
+	struct inet6_ifaddr *ifa = ptr;
+	union  ib_gid *gid = (union ib_gid *)&ifa->addr;
+	struct net_device *event_netdev = ifa->idev->dev;
+
+	ibdev = container_of(this, struct mlx4_ib_dev, iboe.nb_inet6);
+
+	mlx4_ib_addr_event(event, event_netdev, ibdev, gid);
+	return NOTIFY_DONE;
+}
+#endif
+
+static void mlx4_ib_get_dev_addr(struct net_device *dev,
+				 struct mlx4_ib_dev *ibdev, u8 port)
+{
+	struct in_device *in_dev;
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+	struct inet6_dev *in6_dev;
+	union ib_gid  *pgid;
+	struct inet6_ifaddr *ifp;
+#endif
+	union ib_gid gid;
+
+
+	if ((port == 0) || (port > MLX4_MAX_PORTS))
+		return;
+
+	/* IPv4 gids */
+	in_dev = in_dev_get(dev);
+	if (in_dev) {
+		for_ifa(in_dev) {
+			/*ifa->ifa_address;*/
+			ipv6_addr_set_v4mapped(ifa->ifa_address,
+					       (struct in6_addr *)&gid);
+			update_gid_table(ibdev, port, &gid, 0);
+		}
+		endfor_ifa(in_dev);
+		in_dev_put(in_dev);
+	}
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+	/* IPv6 gids */
+	in6_dev = in6_dev_get(dev);
+	if (in6_dev) {
+		read_lock_bh(&in6_dev->lock);
+		list_for_each_entry(ifp, &in6_dev->addr_list, if_list) {
+			pgid = (union ib_gid *)&ifp->addr;
+			update_gid_table(ibdev, port, pgid, 0);
+		}
+		read_unlock_bh(&in6_dev->lock);
+		in6_dev_put(in6_dev);
+	}
+#endif
+}
+
+static int mlx4_ib_init_gid_table(struct mlx4_ib_dev *ibdev)
+{
+	struct	net_device *dev;
+
+	if (reset_gid_table(ibdev))
+		return -1;
+
+	read_lock(&dev_base_lock);
+
+	for_each_netdev(&init_net, dev) {
+		u8 port = mlx4_ib_get_dev_port(dev, ibdev);
+		if (port)
+			mlx4_ib_get_dev_addr(dev, ibdev, port);
+	}
+
+	read_unlock(&dev_base_lock);
+
+	return 0;
+}
+
+static void mlx4_ib_scan_netdevs(struct mlx4_ib_dev *ibdev)
+{
 	struct mlx4_ib_iboe *iboe;
 	int port;
 
-	if (!net_eq(dev_net(dev), &init_net))
-		return NOTIFY_DONE;
-
-	ibdev = container_of(this, struct mlx4_ib_dev, iboe.nb);
 	iboe = &ibdev->iboe;
 
 	spin_lock(&iboe->lock);
 	mlx4_foreach_ib_transport_port(port, ibdev->dev) {
-		oldnd = iboe->netdevs[port - 1];
+		struct net_device *old_master = iboe->masters[port - 1];
+		struct net_device *curr_master;
 		iboe->netdevs[port - 1] =
 			mlx4_get_protocol_dev(ibdev->dev, MLX4_PROT_ETH, port);
-		if (oldnd != iboe->netdevs[port - 1]) {
-			if (iboe->netdevs[port - 1])
-				netdev_added(ibdev, port);
-			else
-				netdev_removed(ibdev, port);
+
+		if (iboe->netdevs[port - 1] &&
+		    netif_is_bond_slave(iboe->netdevs[port - 1])) {
+			rtnl_lock();
+			iboe->masters[port - 1] = netdev_master_upper_dev_get(
+				iboe->netdevs[port - 1]);
+			rtnl_unlock();
 		}
-	}
+		curr_master = iboe->masters[port - 1];
 
-	if (dev == iboe->netdevs[0] ||
-	    (iboe->netdevs[0] && rdma_vlan_dev_real_dev(dev) == iboe->netdevs[0]))
-		handle_en_event(ibdev, 1, event);
-	else if (dev == iboe->netdevs[1]
-		 || (iboe->netdevs[1] && rdma_vlan_dev_real_dev(dev) == iboe->netdevs[1]))
-		handle_en_event(ibdev, 2, event);
+		/* if bonding is used it is possible that we add it to masters
+		    only after IP address is assigned to the net bonding
+		    interface */
+		if (curr_master && (old_master != curr_master))
+			mlx4_ib_get_dev_addr(curr_master, ibdev, port);
+	}
 
 	spin_unlock(&iboe->lock);
+}
+
+static int mlx4_ib_netdev_event(struct notifier_block *this,
+				unsigned long event, void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct mlx4_ib_dev *ibdev;
+
+	if (!net_eq(dev_net(dev), &init_net))
+		return NOTIFY_DONE;
+
+	ibdev = container_of(this, struct mlx4_ib_dev, iboe.nb);
+	mlx4_ib_scan_netdevs(ibdev);
 
 	return NOTIFY_DONE;
 }
@@ -1719,11 +1857,35 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	if (mlx4_ib_init_sriov(ibdev))
 		goto err_mad;
 
-	if (dev->caps.flags & MLX4_DEV_CAP_FLAG_IBOE && !iboe->nb.notifier_call) {
-		iboe->nb.notifier_call = mlx4_ib_netdev_event;
-		err = register_netdevice_notifier(&iboe->nb);
-		if (err)
-			goto err_sriov;
+	if (dev->caps.flags & MLX4_DEV_CAP_FLAG_IBOE) {
+		if (!iboe->nb.notifier_call) {
+			iboe->nb.notifier_call = mlx4_ib_netdev_event;
+			err = register_netdevice_notifier(&iboe->nb);
+			if (err) {
+				iboe->nb.notifier_call = NULL;
+				goto err_notif;
+			}
+		}
+		if (!iboe->nb_inet.notifier_call) {
+			iboe->nb_inet.notifier_call = mlx4_ib_inet_event;
+			err = register_inetaddr_notifier(&iboe->nb_inet);
+			if (err) {
+				iboe->nb_inet.notifier_call = NULL;
+				goto err_notif;
+			}
+		}
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+		if (!iboe->nb_inet6.notifier_call) {
+			iboe->nb_inet6.notifier_call = mlx4_ib_inet6_event;
+			err = register_inet6addr_notifier(&iboe->nb_inet6);
+			if (err) {
+				iboe->nb_inet6.notifier_call = NULL;
+				goto err_notif;
+			}
+		}
+#endif
+		mlx4_ib_scan_netdevs(ibdev);
+		mlx4_ib_init_gid_table(ibdev);
 	}
 
 	for (j = 0; j < ARRAY_SIZE(mlx4_class_attributes); ++j) {
@@ -1749,11 +1911,25 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	return ibdev;
 
 err_notif:
-	if (unregister_netdevice_notifier(&ibdev->iboe.nb))
-		pr_warn("failure unregistering notifier\n");
+	if (ibdev->iboe.nb.notifier_call) {
+		if (unregister_netdevice_notifier(&ibdev->iboe.nb))
+			pr_warn("failure unregistering notifier\n");
+		ibdev->iboe.nb.notifier_call = NULL;
+	}
+	if (ibdev->iboe.nb_inet.notifier_call) {
+		if (unregister_inetaddr_notifier(&ibdev->iboe.nb_inet))
+			pr_warn("failure unregistering notifier\n");
+		ibdev->iboe.nb_inet.notifier_call = NULL;
+	}
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+	if (ibdev->iboe.nb_inet6.notifier_call) {
+		if (unregister_inet6addr_notifier(&ibdev->iboe.nb_inet6))
+			pr_warn("failure unregistering notifier\n");
+		ibdev->iboe.nb_inet6.notifier_call = NULL;
+	}
+#endif
 	flush_workqueue(wq);
 
-err_sriov:
 	mlx4_ib_close_sriov(ibdev);
 
 err_mad:
@@ -1795,6 +1971,18 @@ static void mlx4_ib_remove(struct mlx4_dev *dev, void *ibdev_ptr)
 			pr_warn("failure unregistering notifier\n");
 		ibdev->iboe.nb.notifier_call = NULL;
 	}
+	if (ibdev->iboe.nb_inet.notifier_call) {
+		if (unregister_inetaddr_notifier(&ibdev->iboe.nb_inet))
+			pr_warn("failure unregistering notifier\n");
+		ibdev->iboe.nb_inet.notifier_call = NULL;
+	}
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+	if (ibdev->iboe.nb_inet6.notifier_call) {
+		if (unregister_inet6addr_notifier(&ibdev->iboe.nb_inet6))
+			pr_warn("failure unregistering notifier\n");
+		ibdev->iboe.nb_inet6.notifier_call = NULL;
+	}
+#endif
 	iounmap(ibdev->uar_map);
 	for (p = 0; p < ibdev->num_ports; ++p)
 		if (ibdev->counters[p] != -1)
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 036b663..133f41f 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -428,7 +428,10 @@ struct mlx4_ib_sriov {
 struct mlx4_ib_iboe {
 	spinlock_t		lock;
 	struct net_device      *netdevs[MLX4_MAX_PORTS];
+	struct net_device      *masters[MLX4_MAX_PORTS];
 	struct notifier_block 	nb;
+	struct notifier_block	nb_inet;
+	struct notifier_block	nb_inet6;
 	union ib_gid		gid_table[MLX4_MAX_PORTS][128];
 };
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
