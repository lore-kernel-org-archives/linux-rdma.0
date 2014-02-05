From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.14 5/5] IB/mlx4: Build the port IBoE GID table properly under bonding
Date: Wed,  5 Feb 2014 15:13:02 +0200
Message-ID: <1391605982-4348-6-git-send-email-ogerlitz@mellanox.com>
References: <1391605982-4348-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391605982-4348-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

When scanning netdevices we need to check few more conditions and cases
to build the IBoE GID table properly. For example, under a bonding use-case
we must make sure that when a port is down, the bond IP address isn't
programmed there as GID, since not doing so will cause failure with IB core
flows that selects ports by GID.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |   41 +++++++++++++++++++++++++++++++++---
 1 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 85fbb41..e81c554 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1507,7 +1507,6 @@ static int reset_gid_table(struct mlx4_ib_dev *dev, u8 port)
 {
 	struct update_gid_work *work;
 
-
 	work = kzalloc(sizeof(*work), GFP_ATOMIC);
 	if (!work)
 		return -ENOMEM;
@@ -1699,25 +1698,57 @@ static void mlx4_ib_scan_netdevs(struct mlx4_ib_dev *ibdev)
 
 	spin_lock(&iboe->lock);
 	mlx4_foreach_ib_transport_port(port, ibdev->dev) {
+		enum ib_port_state	port_state = IB_PORT_NOP;
 		struct net_device *old_master = iboe->masters[port - 1];
+		struct net_device *curr_netdev;
 		struct net_device *curr_master;
+
 		iboe->netdevs[port - 1] =
 			mlx4_get_protocol_dev(ibdev->dev, MLX4_PROT_ETH, port);
 		if (iboe->netdevs[port - 1])
 			mlx4_ib_set_default_gid(ibdev,
 						iboe->netdevs[port - 1], port);
+		curr_netdev = iboe->netdevs[port - 1];
+
 		if (iboe->netdevs[port - 1] &&
 		    netif_is_bond_slave(iboe->netdevs[port - 1])) {
 			iboe->masters[port - 1] = netdev_master_upper_dev_get(
 				iboe->netdevs[port - 1]);
+		} else {
+			iboe->masters[port - 1] = NULL;
 		}
 		curr_master = iboe->masters[port - 1];
 
+		if (curr_netdev) {
+			port_state = (netif_running(curr_netdev) && netif_carrier_ok(curr_netdev)) ?
+						IB_PORT_ACTIVE : IB_PORT_DOWN;
+			mlx4_ib_set_default_gid(ibdev, curr_netdev, port);
+		} else {
+			reset_gid_table(ibdev, port);
+		}
+		/* if using bonding/team and a slave port is down, we don't the bond IP
+		 * based gids in the table since flows that select port by gid may get
+		 * the down port.
+		 */
+		if (curr_master && (port_state == IB_PORT_DOWN)) {
+			reset_gid_table(ibdev, port);
+			mlx4_ib_set_default_gid(ibdev, curr_netdev, port);
+		}
 		/* if bonding is used it is possible that we add it to masters
-		    only after IP address is assigned to the net bonding
-		    interface */
-		if (curr_master && (old_master != curr_master))
+		 * only after IP address is assigned to the net bonding
+		 * interface.
+		*/
+		if (curr_master && (old_master != curr_master)) {
+			reset_gid_table(ibdev, port);
+			mlx4_ib_set_default_gid(ibdev, curr_netdev, port);
 			mlx4_ib_get_dev_addr(curr_master, ibdev, port);
+		}
+
+		if (!curr_master && (old_master != curr_master)) {
+			reset_gid_table(ibdev, port);
+			mlx4_ib_set_default_gid(ibdev, curr_netdev, port);
+			mlx4_ib_get_dev_addr(curr_netdev, ibdev, port);
+		}
 	}
 
 	spin_unlock(&iboe->lock);
@@ -2099,6 +2130,8 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 			}
 		}
 #endif
+		for (i = 1 ; i <= ibdev->num_ports ; ++i)
+			reset_gid_table(ibdev, i);
 		rtnl_lock();
 		mlx4_ib_scan_netdevs(ibdev);
 		rtnl_unlock();
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
