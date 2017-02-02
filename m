From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1] IB/core: Remove pointer casting from void to net_device
Date: Thu,  2 Feb 2017 07:14:08 +0200
Message-ID: <20170202051408.21839-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch avoids unnecessary type casting from void to net_device.

CC: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
Changelog v0->v1:
 * Removed temporary event_ndev variable as was suggested by Yuval Shaia.
---
 drivers/infiniband/core/roce_gid_mgmt.c | 28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/core/roce_gid_mgmt.c b/drivers/infiniband/core/roce_gid_mgmt.c
index 0621f4455732..db958d3207ef 100644
--- a/drivers/infiniband/core/roce_gid_mgmt.c
+++ b/drivers/infiniband/core/roce_gid_mgmt.c
@@ -144,7 +144,6 @@ static enum bonding_slave_state is_eth_active_slave_of_bonding_rcu(struct net_de
 static int is_eth_port_of_netdev(struct ib_device *ib_dev, u8 port,
 				 struct net_device *rdma_ndev, void *cookie)
 {
-	struct net_device *event_ndev = (struct net_device *)cookie;
 	struct net_device *real_dev;
 	int res;

@@ -152,11 +151,11 @@ static int is_eth_port_of_netdev(struct ib_device *ib_dev, u8 port,
 		return 0;

 	rcu_read_lock();
-	real_dev = rdma_vlan_dev_real_dev(event_ndev);
+	real_dev = rdma_vlan_dev_real_dev(cookie);
 	if (!real_dev)
-		real_dev = event_ndev;
+		real_dev = cookie;

-	res = ((rdma_is_upper_dev_rcu(rdma_ndev, event_ndev) &&
+	res = ((rdma_is_upper_dev_rcu(rdma_ndev, cookie) &&
 	       (is_eth_active_slave_of_bonding_rcu(rdma_ndev, real_dev) &
 		REQUIRED_BOND_STATES)) ||
 	       real_dev == rdma_ndev);
@@ -192,17 +191,16 @@ static int pass_all_filter(struct ib_device *ib_dev, u8 port,
 static int upper_device_filter(struct ib_device *ib_dev, u8 port,
 			       struct net_device *rdma_ndev, void *cookie)
 {
-	struct net_device *event_ndev = (struct net_device *)cookie;
 	int res;

 	if (!rdma_ndev)
 		return 0;

-	if (rdma_ndev == event_ndev)
+	if (rdma_ndev == cookie)
 		return 1;

 	rcu_read_lock();
-	res = rdma_is_upper_dev_rcu(rdma_ndev, event_ndev);
+	res = rdma_is_upper_dev_rcu(rdma_ndev, cookie);
 	rcu_read_unlock();

 	return res;
@@ -379,18 +377,14 @@ static void _add_netdev_ips(struct ib_device *ib_dev, u8 port,
 static void add_netdev_ips(struct ib_device *ib_dev, u8 port,
 			   struct net_device *rdma_ndev, void *cookie)
 {
-	struct net_device *event_ndev = (struct net_device *)cookie;
-
-	enum_netdev_default_gids(ib_dev, port, event_ndev, rdma_ndev);
-	_add_netdev_ips(ib_dev, port, event_ndev);
+	enum_netdev_default_gids(ib_dev, port, cookie, rdma_ndev);
+	_add_netdev_ips(ib_dev, port, cookie);
 }

 static void del_netdev_ips(struct ib_device *ib_dev, u8 port,
 			   struct net_device *rdma_ndev, void *cookie)
 {
-	struct net_device *event_ndev = (struct net_device *)cookie;
-
-	ib_cache_gid_del_all_netdev_gids(ib_dev, port, event_ndev);
+	ib_cache_gid_del_all_netdev_gids(ib_dev, port, cookie);
 }

 static void enum_all_gids_of_dev_cb(struct ib_device *ib_dev,
@@ -460,7 +454,7 @@ static void handle_netdev_upper(struct ib_device *ib_dev, u8 port,
 						      u8 port,
 						      struct net_device *ndev))
 {
-	struct net_device *ndev = (struct net_device *)cookie;
+	struct net_device *ndev = cookie;
 	struct upper_list *upper_iter;
 	struct upper_list *upper_temp;
 	LIST_HEAD(upper_list);
@@ -519,9 +513,7 @@ static void del_netdev_default_ips_join(struct ib_device *ib_dev, u8 port,
 static void del_netdev_default_ips(struct ib_device *ib_dev, u8 port,
 				   struct net_device *rdma_ndev, void *cookie)
 {
-	struct net_device *event_ndev = (struct net_device *)cookie;
-
-	bond_delete_netdev_default_gids(ib_dev, port, event_ndev, rdma_ndev);
+	bond_delete_netdev_default_gids(ib_dev, port, cookie, rdma_ndev);
 }

 /* The following functions operate on all IB devices. netdevice_event and
--
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
