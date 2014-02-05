From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.14 1/5] IB/mlx4: Make sure GID index 0 is always occupied
Date: Wed,  5 Feb 2014 15:12:58 +0200
Message-ID: <1391605982-4348-2-git-send-email-ogerlitz@mellanox.com>
References: <1391605982-4348-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391605982-4348-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

Make sure that for Ethernet ports, the port GID table index 0 is always
occupied with a default GID of the relevant IPv6 link-local adderss.

This provides better user-experience for legacy applications that don't use
the rdma-cm and where working on index 0 prior to the IP addressing change.

Also, as GIDs are generated from IP addresses of the network devices that
are associated with the port, its basically possible that the GID table
will be empty if no IP address was assigned. This doesn't comply to the
IB spec section 4.1.1 "GID usage and properties".

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |   92 +++++++++++++++++++++++++++----------
 1 files changed, 68 insertions(+), 24 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index d7a0619..06978cd 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1357,6 +1357,21 @@ static struct device_attribute *mlx4_class_attributes[] = {
 	&dev_attr_board_id
 };
 
+static void mlx4_addrconf_ifid_eui48(u8 *eui, u16 vlan_id,
+				     struct net_device *dev)
+{
+	memcpy(eui, dev->dev_addr, 3);
+	memcpy(eui + 5, dev->dev_addr + 3, 3);
+	if (vlan_id < 0x1000) {
+		eui[3] = vlan_id >> 8;
+		eui[4] = vlan_id & 0xff;
+	} else {
+		eui[3] = 0xff;
+		eui[4] = 0xfe;
+	}
+	eui[0] ^= 2;
+}
+
 static void update_gids_task(struct work_struct *work)
 {
 	struct update_gid_work *gw = container_of(work, struct update_gid_work, work);
@@ -1425,7 +1440,8 @@ free:
 }
 
 static int update_gid_table(struct mlx4_ib_dev *dev, int port,
-			    union ib_gid *gid, int clear)
+			    union ib_gid *gid, int clear,
+			    int default_gid)
 {
 	struct update_gid_work *work;
 	int i;
@@ -1434,26 +1450,31 @@ static int update_gid_table(struct mlx4_ib_dev *dev, int port,
 	int found = -1;
 	int max_gids;
 
-	max_gids = dev->dev->caps.gid_table_len[port];
-	for (i = 0; i < max_gids; ++i) {
-		if (!memcmp(&dev->iboe.gid_table[port - 1][i], gid,
-			    sizeof(*gid)))
-			found = i;
-
-		if (clear) {
-			if (found >= 0) {
-				need_update = 1;
-				dev->iboe.gid_table[port - 1][found] = zgid;
-				break;
-			}
-		} else {
-			if (found >= 0)
-				break;
-
-			if (free < 0 &&
-			    !memcmp(&dev->iboe.gid_table[port - 1][i], &zgid,
+	if (default_gid) {
+		free = 0;
+	} else {
+		max_gids = dev->dev->caps.gid_table_len[port];
+		for (i = 1; i < max_gids; ++i) {
+			if (!memcmp(&dev->iboe.gid_table[port - 1][i], gid,
 				    sizeof(*gid)))
-				free = i;
+				found = i;
+
+			if (clear) {
+				if (found >= 0) {
+					need_update = 1;
+					dev->iboe.gid_table[port - 1][found] =
+						zgid;
+					break;
+				}
+			} else {
+				if (found >= 0)
+					break;
+
+				if (free < 0 &&
+				    !memcmp(&dev->iboe.gid_table[port - 1][i],
+					    &zgid, sizeof(*gid)))
+					free = i;
+			}
 		}
 	}
 
@@ -1478,6 +1499,13 @@ static int update_gid_table(struct mlx4_ib_dev *dev, int port,
 	return 0;
 }
 
+static void mlx4_make_default_gid(struct  net_device *dev, union ib_gid *gid)
+{
+	gid->global.subnet_prefix = cpu_to_be64(0xfe80000000000000LL);
+	mlx4_addrconf_ifid_eui48(&gid->raw[8], 0xffff, dev);
+}
+
+
 static int reset_gid_table(struct mlx4_ib_dev *dev)
 {
 	struct update_gid_work *work;
@@ -1502,6 +1530,12 @@ static int mlx4_ib_addr_event(int event, struct net_device *event_netdev,
 	struct net_device *real_dev = rdma_vlan_dev_real_dev(event_netdev) ?
 				rdma_vlan_dev_real_dev(event_netdev) :
 				event_netdev;
+	union ib_gid default_gid;
+
+	mlx4_make_default_gid(real_dev, &default_gid);
+
+	if (!memcmp(gid, &default_gid, sizeof(*gid)))
+		return 0;
 
 	if (event != NETDEV_DOWN && event != NETDEV_UP)
 		return 0;
@@ -1520,7 +1554,7 @@ static int mlx4_ib_addr_event(int event, struct net_device *event_netdev,
 		     (!netif_is_bond_master(real_dev) &&
 		     (real_dev == iboe->netdevs[port - 1])))
 			update_gid_table(ibdev, port, gid,
-					 event == NETDEV_DOWN);
+					 event == NETDEV_DOWN, 0);
 
 	spin_unlock(&iboe->lock);
 	return 0;
@@ -1607,7 +1641,7 @@ static void mlx4_ib_get_dev_addr(struct net_device *dev,
 			/*ifa->ifa_address;*/
 			ipv6_addr_set_v4mapped(ifa->ifa_address,
 					       (struct in6_addr *)&gid);
-			update_gid_table(ibdev, port, &gid, 0);
+			update_gid_table(ibdev, port, &gid, 0, 0);
 		}
 		endfor_ifa(in_dev);
 		in_dev_put(in_dev);
@@ -1619,7 +1653,7 @@ static void mlx4_ib_get_dev_addr(struct net_device *dev,
 		read_lock_bh(&in6_dev->lock);
 		list_for_each_entry(ifp, &in6_dev->addr_list, if_list) {
 			pgid = (union ib_gid *)&ifp->addr;
-			update_gid_table(ibdev, port, pgid, 0);
+			update_gid_table(ibdev, port, pgid, 0, 0);
 		}
 		read_unlock_bh(&in6_dev->lock);
 		in6_dev_put(in6_dev);
@@ -1627,6 +1661,14 @@ static void mlx4_ib_get_dev_addr(struct net_device *dev,
 #endif
 }
 
+static void mlx4_ib_set_default_gid(struct mlx4_ib_dev *ibdev,
+				 struct  net_device *dev, u8 port)
+{
+	union ib_gid gid;
+	mlx4_make_default_gid(dev, &gid);
+	update_gid_table(ibdev, port, &gid, 0, 1);
+}
+
 static int mlx4_ib_init_gid_table(struct mlx4_ib_dev *ibdev)
 {
 	struct	net_device *dev;
@@ -1660,7 +1702,9 @@ static void mlx4_ib_scan_netdevs(struct mlx4_ib_dev *ibdev)
 		struct net_device *curr_master;
 		iboe->netdevs[port - 1] =
 			mlx4_get_protocol_dev(ibdev->dev, MLX4_PROT_ETH, port);
-
+		if (iboe->netdevs[port - 1])
+			mlx4_ib_set_default_gid(ibdev,
+						iboe->netdevs[port - 1], port);
 		if (iboe->netdevs[port - 1] &&
 		    netif_is_bond_slave(iboe->netdevs[port - 1])) {
 			rtnl_lock();
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
