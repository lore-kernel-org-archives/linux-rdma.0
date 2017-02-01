From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next] IB/core: Remove pointer casting from void to net_device
Date: Wed,  1 Feb 2017 13:51:26 +0200
Message-ID: <20170201115126.7313-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch avoids unnecessary type casting from void to net_device.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/roce_gid_mgmt.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/roce_gid_mgmt.c b/drivers/infiniband/core/roce_gid_mgmt.c
index 0621f4455732..8c1f99f830d4 100644
--- a/drivers/infiniband/core/roce_gid_mgmt.c
+++ b/drivers/infiniband/core/roce_gid_mgmt.c
@@ -144,7 +144,7 @@ static enum bonding_slave_state is_eth_active_slave_of_bonding_rcu(struct net_de
 static int is_eth_port_of_netdev(struct ib_device *ib_dev, u8 port,
 				 struct net_device *rdma_ndev, void *cookie)
 {
-	struct net_device *event_ndev = (struct net_device *)cookie;
+	struct net_device *event_ndev = cookie;
 	struct net_device *real_dev;
 	int res;

@@ -192,7 +192,7 @@ static int pass_all_filter(struct ib_device *ib_dev, u8 port,
 static int upper_device_filter(struct ib_device *ib_dev, u8 port,
 			       struct net_device *rdma_ndev, void *cookie)
 {
-	struct net_device *event_ndev = (struct net_device *)cookie;
+	struct net_device *event_ndev = cookie;
 	int res;

 	if (!rdma_ndev)
@@ -379,7 +379,7 @@ static void _add_netdev_ips(struct ib_device *ib_dev, u8 port,
 static void add_netdev_ips(struct ib_device *ib_dev, u8 port,
 			   struct net_device *rdma_ndev, void *cookie)
 {
-	struct net_device *event_ndev = (struct net_device *)cookie;
+	struct net_device *event_ndev = cookie;

 	enum_netdev_default_gids(ib_dev, port, event_ndev, rdma_ndev);
 	_add_netdev_ips(ib_dev, port, event_ndev);
@@ -388,7 +388,7 @@ static void add_netdev_ips(struct ib_device *ib_dev, u8 port,
 static void del_netdev_ips(struct ib_device *ib_dev, u8 port,
 			   struct net_device *rdma_ndev, void *cookie)
 {
-	struct net_device *event_ndev = (struct net_device *)cookie;
+	struct net_device *event_ndev = cookie;

 	ib_cache_gid_del_all_netdev_gids(ib_dev, port, event_ndev);
 }
@@ -460,7 +460,7 @@ static void handle_netdev_upper(struct ib_device *ib_dev, u8 port,
 						      u8 port,
 						      struct net_device *ndev))
 {
-	struct net_device *ndev = (struct net_device *)cookie;
+	struct net_device *ndev = cookie;
 	struct upper_list *upper_iter;
 	struct upper_list *upper_temp;
 	LIST_HEAD(upper_list);
@@ -519,7 +519,7 @@ static void del_netdev_default_ips_join(struct ib_device *ib_dev, u8 port,
 static void del_netdev_default_ips(struct ib_device *ib_dev, u8 port,
 				   struct net_device *rdma_ndev, void *cookie)
 {
-	struct net_device *event_ndev = (struct net_device *)cookie;
+	struct net_device *event_ndev = cookie;

 	bond_delete_netdev_default_gids(ib_dev, port, event_ndev, rdma_ndev);
 }
--
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
