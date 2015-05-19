From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v4 for-next 14/14] IB/mlx4: Replace mechanism for RoCE GID management
Date: Tue, 19 May 2015 17:27:17 +0300
Message-ID: <1432045637-9090-15-git-send-email-matanb@mellanox.com>
References: <1432045637-9090-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432045637-9090-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Manage RoCE gid table with logic in IB/core, which is common to all
vendors, and remove the mechanism from the mlx4 IB driver.
Since management of the GID cache may lead to index mismatch with the
hardware GID table, a translation between indexes is required when
modifying a QP or creating an address handle.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/ah.c      |   2 +-
 drivers/infiniband/hw/mlx4/main.c    | 510 ++---------------------------------
 drivers/infiniband/hw/mlx4/mlx4_ib.h |   4 -
 drivers/infiniband/hw/mlx4/qp.c      |  10 +-
 4 files changed, 30 insertions(+), 496 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/ah.c b/drivers/infiniband/hw/mlx4/ah.c
index aaeeb60..82f5387 100644
--- a/drivers/infiniband/hw/mlx4/ah.c
+++ b/drivers/infiniband/hw/mlx4/ah.c
@@ -100,7 +100,7 @@ static struct ib_ah *create_iboe_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr
 	if (vlan_tag < 0x1000)
 		vlan_tag |= (ah_attr->sl & 7) << 13;
 	ah->av.eth.port_pd = cpu_to_be32(to_mpd(pd)->pdn | (ah_attr->port_num << 24));
-	ah->av.eth.gid_index = ah_attr->grh.sgid_index;
+	ah->av.eth.gid_index = mlx4_ib_gid_index_to_real_index(ibdev, ah_attr->port_num, ah_attr->grh.sgid_index);
 	ah->av.eth.vlan = cpu_to_be16(vlan_tag);
 	if (ah_attr->static_rate) {
 		ah->av.eth.stat_rate = ah_attr->static_rate + MLX4_STAT_RATE_OFFSET;
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 08ec498..4c47cc9 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -77,13 +77,6 @@ static const char mlx4_ib_version[] =
 	DRV_NAME ": Mellanox ConnectX InfiniBand driver v"
 	DRV_VERSION " (" DRV_RELDATE ")\n";
 
-struct update_gid_work {
-	struct work_struct	work;
-	union ib_gid		gids[128];
-	struct mlx4_ib_dev     *dev;
-	int			port;
-};
-
 static void do_slave_init(struct mlx4_ib_dev *ibdev, int slave, int do_init);
 
 static struct workqueue_struct *wq;
@@ -563,7 +556,8 @@ static int eth_link_query_port(struct ib_device *ibdev, u8 port,
 	props->active_width	=  (((u8 *)mailbox->buf)[5] == 0x40) ?
 						IB_WIDTH_4X : IB_WIDTH_1X;
 	props->active_speed	= IB_SPEED_QDR;
-	props->port_cap_flags	= IB_PORT_CM_SUP | IB_PORT_IP_BASED_GIDS;
+	props->port_cap_flags	= IB_PORT_CM_SUP | IB_PORT_IP_BASED_GIDS |
+				  IB_PORT_ROCE;
 	props->gid_tbl_len	= mdev->dev->caps.gid_table_len[port];
 	props->max_msg_sz	= mdev->dev->caps.max_msg_sz;
 	props->pkey_tbl_len	= 1;
@@ -572,12 +566,13 @@ static int eth_link_query_port(struct ib_device *ibdev, u8 port,
 	props->state		= IB_PORT_DOWN;
 	props->phys_state	= state_to_phys_state(props->state);
 	props->active_mtu	= IB_MTU_256;
-	if (is_bonded)
-		rtnl_lock(); /* required to get upper dev */
 	spin_lock_bh(&iboe->lock);
 	ndev = iboe->netdevs[port - 1];
-	if (ndev && is_bonded)
-		ndev = netdev_master_upper_dev_get(ndev);
+	if (ndev && is_bonded) {
+		rcu_read_lock(); /* required to get upper dev */
+		ndev = netdev_master_upper_dev_get_rcu(ndev);
+		rcu_read_unlock();
+	}
 	if (!ndev)
 		goto out_unlock;
 
@@ -589,8 +584,6 @@ static int eth_link_query_port(struct ib_device *ibdev, u8 port,
 	props->phys_state	= state_to_phys_state(props->state);
 out_unlock:
 	spin_unlock_bh(&iboe->lock);
-	if (is_bonded)
-		rtnl_unlock();
 out:
 	mlx4_free_cmd_mailbox(mdev->dev, mailbox);
 	return err;
@@ -673,23 +666,21 @@ out:
 	return err;
 }
 
-static int iboe_query_gid(struct ib_device *ibdev, u8 port, int index,
-			  union ib_gid *gid)
-{
-	struct mlx4_ib_dev *dev = to_mdev(ibdev);
-
-	*gid = dev->iboe.gid_table[port - 1][index];
-
-	return 0;
-}
-
 static int mlx4_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
 			     union ib_gid *gid)
 {
-	if (rdma_port_get_link_layer(ibdev, port) == IB_LINK_LAYER_INFINIBAND)
+	int ret;
+
+	if (ib_cache_use_roce_gid_table(ibdev, port))
 		return __mlx4_ib_query_gid(ibdev, port, index, gid, 0);
-	else
-		return iboe_query_gid(ibdev, port, index, gid);
+
+	ret = ib_get_cached_gid(ibdev, port, index, gid, NULL);
+	if (ret == -EAGAIN) {
+		memcpy(gid, &zgid, sizeof(*gid));
+		return 0;
+	}
+
+	return ret;
 }
 
 int __mlx4_ib_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
@@ -1686,273 +1677,6 @@ static struct device_attribute *mlx4_class_attributes[] = {
 	&dev_attr_board_id
 };
 
-static void mlx4_addrconf_ifid_eui48(u8 *eui, u16 vlan_id,
-				     struct net_device *dev)
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
-static void update_gids_task(struct work_struct *work)
-{
-	struct update_gid_work *gw = container_of(work, struct update_gid_work, work);
-	struct mlx4_cmd_mailbox *mailbox;
-	union ib_gid *gids;
-	int err;
-	struct mlx4_dev	*dev = gw->dev->dev;
-	int is_bonded = mlx4_is_bonded(dev);
-
-	if (!gw->dev->ib_active)
-		return;
-
-	mailbox = mlx4_alloc_cmd_mailbox(dev);
-	if (IS_ERR(mailbox)) {
-		pr_warn("update gid table failed %ld\n", PTR_ERR(mailbox));
-		return;
-	}
-
-	gids = mailbox->buf;
-	memcpy(gids, gw->gids, sizeof gw->gids);
-
-	err = mlx4_cmd(dev, mailbox->dma, MLX4_SET_PORT_GID_TABLE << 8 | gw->port,
-		       MLX4_SET_PORT_ETH_OPCODE, MLX4_CMD_SET_PORT,
-		       MLX4_CMD_TIME_CLASS_B, MLX4_CMD_WRAPPED);
-	if (err)
-		pr_warn("set port command failed\n");
-	else
-		if ((gw->port == 1) || !is_bonded)
-			mlx4_ib_dispatch_event(gw->dev,
-					       is_bonded ? 1 : gw->port,
-					       IB_EVENT_GID_CHANGE);
-
-	mlx4_free_cmd_mailbox(dev, mailbox);
-	kfree(gw);
-}
-
-static void reset_gids_task(struct work_struct *work)
-{
-	struct update_gid_work *gw =
-			container_of(work, struct update_gid_work, work);
-	struct mlx4_cmd_mailbox *mailbox;
-	union ib_gid *gids;
-	int err;
-	struct mlx4_dev	*dev = gw->dev->dev;
-
-	if (!gw->dev->ib_active)
-		return;
-
-	mailbox = mlx4_alloc_cmd_mailbox(dev);
-	if (IS_ERR(mailbox)) {
-		pr_warn("reset gid table failed\n");
-		goto free;
-	}
-
-	gids = mailbox->buf;
-	memcpy(gids, gw->gids, sizeof(gw->gids));
-
-	if (mlx4_ib_port_link_layer(&gw->dev->ib_dev, gw->port) ==
-				    IB_LINK_LAYER_ETHERNET) {
-		err = mlx4_cmd(dev, mailbox->dma,
-			       MLX4_SET_PORT_GID_TABLE << 8 | gw->port,
-			       MLX4_SET_PORT_ETH_OPCODE, MLX4_CMD_SET_PORT,
-			       MLX4_CMD_TIME_CLASS_B,
-			       MLX4_CMD_WRAPPED);
-		if (err)
-			pr_warn(KERN_WARNING
-				"set port %d command failed\n", gw->port);
-	}
-
-	mlx4_free_cmd_mailbox(dev, mailbox);
-free:
-	kfree(gw);
-}
-
-static int update_gid_table(struct mlx4_ib_dev *dev, int port,
-			    union ib_gid *gid, int clear,
-			    int default_gid)
-{
-	struct update_gid_work *work;
-	int i;
-	int need_update = 0;
-	int free = -1;
-	int found = -1;
-	int max_gids;
-
-	if (default_gid) {
-		free = 0;
-	} else {
-		max_gids = dev->dev->caps.gid_table_len[port];
-		for (i = 1; i < max_gids; ++i) {
-			if (!memcmp(&dev->iboe.gid_table[port - 1][i], gid,
-				    sizeof(*gid)))
-				found = i;
-
-			if (clear) {
-				if (found >= 0) {
-					need_update = 1;
-					dev->iboe.gid_table[port - 1][found] =
-						zgid;
-					break;
-				}
-			} else {
-				if (found >= 0)
-					break;
-
-				if (free < 0 &&
-				    !memcmp(&dev->iboe.gid_table[port - 1][i],
-					    &zgid, sizeof(*gid)))
-					free = i;
-			}
-		}
-	}
-
-	if (found == -1 && !clear && free >= 0) {
-		dev->iboe.gid_table[port - 1][free] = *gid;
-		need_update = 1;
-	}
-
-	if (!need_update)
-		return 0;
-
-	work = kzalloc(sizeof(*work), GFP_ATOMIC);
-	if (!work)
-		return -ENOMEM;
-
-	memcpy(work->gids, dev->iboe.gid_table[port - 1], sizeof(work->gids));
-	INIT_WORK(&work->work, update_gids_task);
-	work->port = port;
-	work->dev = dev;
-	queue_work(wq, &work->work);
-
-	return 0;
-}
-
-static void mlx4_make_default_gid(struct  net_device *dev, union ib_gid *gid)
-{
-	gid->global.subnet_prefix = cpu_to_be64(0xfe80000000000000LL);
-	mlx4_addrconf_ifid_eui48(&gid->raw[8], 0xffff, dev);
-}
-
-
-static int reset_gid_table(struct mlx4_ib_dev *dev, u8 port)
-{
-	struct update_gid_work *work;
-
-	work = kzalloc(sizeof(*work), GFP_ATOMIC);
-	if (!work)
-		return -ENOMEM;
-
-	memset(dev->iboe.gid_table[port - 1], 0, sizeof(work->gids));
-	memset(work->gids, 0, sizeof(work->gids));
-	INIT_WORK(&work->work, reset_gids_task);
-	work->dev = dev;
-	work->port = port;
-	queue_work(wq, &work->work);
-	return 0;
-}
-
-static int mlx4_ib_addr_event(int event, struct net_device *event_netdev,
-			      struct mlx4_ib_dev *ibdev, union ib_gid *gid)
-{
-	struct mlx4_ib_iboe *iboe;
-	int port = 0;
-	struct net_device *real_dev = rdma_vlan_dev_real_dev(event_netdev) ?
-				rdma_vlan_dev_real_dev(event_netdev) :
-				event_netdev;
-	union ib_gid default_gid;
-
-	mlx4_make_default_gid(real_dev, &default_gid);
-
-	if (!memcmp(gid, &default_gid, sizeof(*gid)))
-		return 0;
-
-	if (event != NETDEV_DOWN && event != NETDEV_UP)
-		return 0;
-
-	if ((real_dev != event_netdev) &&
-	    (event == NETDEV_DOWN) &&
-	    rdma_link_local_addr((struct in6_addr *)gid))
-		return 0;
-
-	iboe = &ibdev->iboe;
-	spin_lock_bh(&iboe->lock);
-
-	for (port = 1; port <= ibdev->dev->caps.num_ports; ++port)
-		if ((netif_is_bond_master(real_dev) &&
-		     (real_dev == iboe->masters[port - 1])) ||
-		     (!netif_is_bond_master(real_dev) &&
-		     (real_dev == iboe->netdevs[port - 1])))
-			update_gid_table(ibdev, port, gid,
-					 event == NETDEV_DOWN, 0);
-
-	spin_unlock_bh(&iboe->lock);
-	return 0;
-
-}
-
-static u8 mlx4_ib_get_dev_port(struct net_device *dev,
-			       struct mlx4_ib_dev *ibdev)
-{
-	u8 port = 0;
-	struct mlx4_ib_iboe *iboe;
-	struct net_device *real_dev = rdma_vlan_dev_real_dev(dev) ?
-				rdma_vlan_dev_real_dev(dev) : dev;
-
-	iboe = &ibdev->iboe;
-
-	for (port = 1; port <= ibdev->dev->caps.num_ports; ++port)
-		if ((netif_is_bond_master(real_dev) &&
-		     (real_dev == iboe->masters[port - 1])) ||
-		     (!netif_is_bond_master(real_dev) &&
-		     (real_dev == iboe->netdevs[port - 1])))
-			break;
-
-	if ((port == 0) || (port > ibdev->dev->caps.num_ports))
-		return 0;
-	else
-		return port;
-}
-
-static int mlx4_ib_inet_event(struct notifier_block *this, unsigned long event,
-				void *ptr)
-{
-	struct mlx4_ib_dev *ibdev;
-	struct in_ifaddr *ifa = ptr;
-	union ib_gid gid;
-	struct net_device *event_netdev = ifa->ifa_dev->dev;
-
-	ipv6_addr_set_v4mapped(ifa->ifa_address, (struct in6_addr *)&gid);
-
-	ibdev = container_of(this, struct mlx4_ib_dev, iboe.nb_inet);
-
-	mlx4_ib_addr_event(event, event_netdev, ibdev, &gid);
-	return NOTIFY_DONE;
-}
-
-#if IS_ENABLED(CONFIG_IPV6)
-static int mlx4_ib_inet6_event(struct notifier_block *this, unsigned long event,
-				void *ptr)
-{
-	struct mlx4_ib_dev *ibdev;
-	struct inet6_ifaddr *ifa = ptr;
-	union  ib_gid *gid = (union ib_gid *)&ifa->addr;
-	struct net_device *event_netdev = ifa->idev->dev;
-
-	ibdev = container_of(this, struct mlx4_ib_dev, iboe.nb_inet6);
-
-	mlx4_ib_addr_event(event, event_netdev, ibdev, gid);
-	return NOTIFY_DONE;
-}
-#endif
-
 #define MLX4_IB_INVALID_MAC	((u64)-1)
 static void mlx4_ib_update_qps(struct mlx4_ib_dev *ibdev,
 			       struct net_device *dev,
@@ -2011,94 +1735,6 @@ unlock:
 	mutex_unlock(&ibdev->qp1_proxy_lock[port - 1]);
 }
 
-static void mlx4_ib_get_dev_addr(struct net_device *dev,
-				 struct mlx4_ib_dev *ibdev, u8 port)
-{
-	struct in_device *in_dev;
-#if IS_ENABLED(CONFIG_IPV6)
-	struct inet6_dev *in6_dev;
-	union ib_gid  *pgid;
-	struct inet6_ifaddr *ifp;
-	union ib_gid default_gid;
-#endif
-	union ib_gid gid;
-
-
-	if ((port == 0) || (port > ibdev->dev->caps.num_ports))
-		return;
-
-	/* IPv4 gids */
-	in_dev = in_dev_get(dev);
-	if (in_dev) {
-		for_ifa(in_dev) {
-			/*ifa->ifa_address;*/
-			ipv6_addr_set_v4mapped(ifa->ifa_address,
-					       (struct in6_addr *)&gid);
-			update_gid_table(ibdev, port, &gid, 0, 0);
-		}
-		endfor_ifa(in_dev);
-		in_dev_put(in_dev);
-	}
-#if IS_ENABLED(CONFIG_IPV6)
-	mlx4_make_default_gid(dev, &default_gid);
-	/* IPv6 gids */
-	in6_dev = in6_dev_get(dev);
-	if (in6_dev) {
-		read_lock_bh(&in6_dev->lock);
-		list_for_each_entry(ifp, &in6_dev->addr_list, if_list) {
-			pgid = (union ib_gid *)&ifp->addr;
-			if (!memcmp(pgid, &default_gid, sizeof(*pgid)))
-				continue;
-			update_gid_table(ibdev, port, pgid, 0, 0);
-		}
-		read_unlock_bh(&in6_dev->lock);
-		in6_dev_put(in6_dev);
-	}
-#endif
-}
-
-static void mlx4_ib_set_default_gid(struct mlx4_ib_dev *ibdev,
-				 struct  net_device *dev, u8 port)
-{
-	union ib_gid gid;
-	mlx4_make_default_gid(dev, &gid);
-	update_gid_table(ibdev, port, &gid, 0, 1);
-}
-
-static int mlx4_ib_init_gid_table(struct mlx4_ib_dev *ibdev)
-{
-	struct	net_device *dev;
-	struct mlx4_ib_iboe *iboe = &ibdev->iboe;
-	int i;
-	int err = 0;
-
-	for (i = 1; i <= ibdev->num_ports; ++i) {
-		if (rdma_port_get_link_layer(&ibdev->ib_dev, i) ==
-		    IB_LINK_LAYER_ETHERNET) {
-			err = reset_gid_table(ibdev, i);
-			if (err)
-				goto out;
-		}
-	}
-
-	read_lock(&dev_base_lock);
-	spin_lock_bh(&iboe->lock);
-
-	for_each_netdev(&init_net, dev) {
-		u8 port = mlx4_ib_get_dev_port(dev, ibdev);
-		/* port will be non-zero only for ETH ports */
-		if (port) {
-			mlx4_ib_set_default_gid(ibdev, dev, port);
-			mlx4_ib_get_dev_addr(dev, ibdev, port);
-		}
-	}
-
-	spin_unlock_bh(&iboe->lock);
-	read_unlock(&dev_base_lock);
-out:
-	return err;
-}
-
 static void mlx4_ib_scan_netdevs(struct mlx4_ib_dev *ibdev,
 				 struct net_device *dev,
 				 unsigned long event)
@@ -2108,81 +1744,22 @@ static void mlx4_ib_scan_netdevs(struct mlx4_ib_dev *ibdev,
 	int update_qps_port = -1;
 	int port;
 
+	ASSERT_RTNL();
+
 	iboe = &ibdev->iboe;
 
 	spin_lock_bh(&iboe->lock);
 	mlx4_foreach_ib_transport_port(port, ibdev->dev) {
-		enum ib_port_state	port_state = IB_PORT_NOP;
-		struct net_device *old_master = iboe->masters[port - 1];
-		struct net_device *curr_netdev;
-		struct net_device *curr_master;
 
 		iboe->netdevs[port - 1] =
 			mlx4_get_protocol_dev(ibdev->dev, MLX4_PROT_ETH, port);
-		if (iboe->netdevs[port - 1])
-			mlx4_ib_set_default_gid(ibdev,
-						iboe->netdevs[port - 1], port);
-		curr_netdev = iboe->netdevs[port - 1];
-
-		if (iboe->netdevs[port - 1] &&
-		    netif_is_bond_slave(iboe->netdevs[port - 1])) {
-			iboe->masters[port - 1] = netdev_master_upper_dev_get(
-				iboe->netdevs[port - 1]);
-		} else {
-			iboe->masters[port - 1] = NULL;
-		}
-		curr_master = iboe->masters[port - 1];
 
 		if (dev == iboe->netdevs[port - 1] &&
 		    (event == NETDEV_CHANGEADDR || event == NETDEV_REGISTER ||
 		     event == NETDEV_UP || event == NETDEV_CHANGE))
 			update_qps_port = port;
 
-		if (curr_netdev) {
-			port_state = (netif_running(curr_netdev) && netif_carrier_ok(curr_netdev)) ?
-						IB_PORT_ACTIVE : IB_PORT_DOWN;
-			mlx4_ib_set_default_gid(ibdev, curr_netdev, port);
-			if (curr_master) {
-				/* if using bonding/team and a slave port is down, we
-				 * don't want the bond IP based gids in the table since
-				 * flows that select port by gid may get the down port.
-				*/
-				if (port_state == IB_PORT_DOWN &&
-				    !mlx4_is_bonded(ibdev->dev)) {
-					reset_gid_table(ibdev, port);
-					mlx4_ib_set_default_gid(ibdev,
-								curr_netdev,
-								port);
-				} else {
-					/* gids from the upper dev (bond/team)
-					 * should appear in port's gid table
-					*/
-					mlx4_ib_get_dev_addr(curr_master,
-							     ibdev, port);
-				}
-			}
-			/* if bonding is used it is possible that we add it to
-			 * masters only after IP address is assigned to the
-			 * net bonding interface.
-			*/
-			if (curr_master && (old_master != curr_master)) {
-				reset_gid_table(ibdev, port);
-				mlx4_ib_set_default_gid(ibdev,
-							curr_netdev, port);
-				mlx4_ib_get_dev_addr(curr_master, ibdev, port);
-			}
-
-			if (!curr_master && (old_master != curr_master)) {
-				reset_gid_table(ibdev, port);
-				mlx4_ib_set_default_gid(ibdev,
-							curr_netdev, port);
-				mlx4_ib_get_dev_addr(curr_netdev, ibdev, port);
-			}
-		} else {
-			reset_gid_table(ibdev, port);
-		}
 	}
-
 	spin_unlock_bh(&iboe->lock);
 
 	if (update_qps_port > 0)
@@ -2365,6 +1942,8 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 						1 : ibdev->num_ports;
 	ibdev->ib_dev.num_comp_vectors	= dev->caps.num_comp_vectors;
 	ibdev->ib_dev.dma_device	= &dev->persist->pdev->dev;
+	ibdev->ib_dev.get_netdev	= mlx4_ib_get_netdev;
+	ibdev->ib_dev.modify_gid	= mlx4_ib_modify_gid;
 
 	if (dev->caps.userspace_caps)
 		ibdev->ib_dev.uverbs_abi_ver = MLX4_IB_UVERBS_ABI_VERSION;
@@ -2558,26 +2137,6 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 				goto err_notif;
 			}
 		}
-		if (!iboe->nb_inet.notifier_call) {
-			iboe->nb_inet.notifier_call = mlx4_ib_inet_event;
-			err = register_inetaddr_notifier(&iboe->nb_inet);
-			if (err) {
-				iboe->nb_inet.notifier_call = NULL;
-				goto err_notif;
-			}
-		}
-#if IS_ENABLED(CONFIG_IPV6)
-		if (!iboe->nb_inet6.notifier_call) {
-			iboe->nb_inet6.notifier_call = mlx4_ib_inet6_event;
-			err = register_inet6addr_notifier(&iboe->nb_inet6);
-			if (err) {
-				iboe->nb_inet6.notifier_call = NULL;
-				goto err_notif;
-			}
-		}
-#endif
-		if (mlx4_ib_init_gid_table(ibdev))
-			goto err_notif;
 	}
 
 	for (j = 0; j < ARRAY_SIZE(mlx4_class_attributes); ++j) {
@@ -2608,18 +2167,6 @@ err_notif:
 			pr_warn("failure unregistering notifier\n");
 		ibdev->iboe.nb.notifier_call = NULL;
 	}
-	if (ibdev->iboe.nb_inet.notifier_call) {
-		if (unregister_inetaddr_notifier(&ibdev->iboe.nb_inet))
-			pr_warn("failure unregistering notifier\n");
-		ibdev->iboe.nb_inet.notifier_call = NULL;
-	}
-#if IS_ENABLED(CONFIG_IPV6)
-	if (ibdev->iboe.nb_inet6.notifier_call) {
-		if (unregister_inet6addr_notifier(&ibdev->iboe.nb_inet6))
-			pr_warn("failure unregistering notifier\n");
-		ibdev->iboe.nb_inet6.notifier_call = NULL;
-	}
-#endif
 	flush_workqueue(wq);
 
 	mlx4_ib_close_sriov(ibdev);
@@ -2743,19 +2290,6 @@ static void mlx4_ib_remove(struct mlx4_dev *dev, void *ibdev_ptr)
 		kfree(ibdev->ib_uc_qpns_bitmap);
 	}
 
-	if (ibdev->iboe.nb_inet.notifier_call) {
-		if (unregister_inetaddr_notifier(&ibdev->iboe.nb_inet))
-			pr_warn("failure unregistering notifier\n");
-		ibdev->iboe.nb_inet.notifier_call = NULL;
-	}
-#if IS_ENABLED(CONFIG_IPV6)
-	if (ibdev->iboe.nb_inet6.notifier_call) {
-		if (unregister_inet6addr_notifier(&ibdev->iboe.nb_inet6))
-			pr_warn("failure unregistering notifier\n");
-		ibdev->iboe.nb_inet6.notifier_call = NULL;
-	}
-#endif
-
 	iounmap(ibdev->uar_map);
 	for (p = 0; p < ibdev->num_ports; ++p)
 		if (ibdev->counters[p] != -1)
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 0a32552..d6ce6a1 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -474,12 +474,8 @@ struct mlx4_port_gid_table {
 struct mlx4_ib_iboe {
 	spinlock_t		lock;
 	struct net_device      *netdevs[MLX4_MAX_PORTS];
-	struct net_device      *masters[MLX4_MAX_PORTS];
 	atomic64_t		mac[MLX4_MAX_PORTS];
 	struct notifier_block 	nb;
-	struct notifier_block	nb_inet;
-	struct notifier_block	nb_inet6;
-	union ib_gid		gid_table[MLX4_MAX_PORTS][128];
 	struct mlx4_port_gid_table gids[MLX4_MAX_PORTS];
 };
 
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 37305f5..a6f44ba 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1292,14 +1292,18 @@ static int _mlx4_set_path(struct mlx4_ib_dev *dev, const struct ib_ah_attr *ah,
 		path->static_rate = 0;
 
 	if (ah->ah_flags & IB_AH_GRH) {
-		if (ah->grh.sgid_index >= dev->dev->caps.gid_table_len[port]) {
+		int real_sgid_index = mlx4_ib_gid_index_to_real_index(dev,
+								      port,
+								      ah->grh.sgid_index);
+
+		if (real_sgid_index >= dev->dev->caps.gid_table_len[port]) {
 			pr_err("sgid_index (%u) too large. max is %d\n",
-			       ah->grh.sgid_index, dev->dev->caps.gid_table_len[port] - 1);
+			       real_sgid_index, dev->dev->caps.gid_table_len[port] - 1);
 			return -1;
 		}
 
 		path->grh_mylmc |= 1 << 7;
-		path->mgid_index = ah->grh.sgid_index;
+		path->mgid_index = real_sgid_index;
 		path->hop_limit  = ah->grh.hop_limit;
 		path->tclass_flowlabel =
 			cpu_to_be32((ah->grh.traffic_class << 20) |
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
