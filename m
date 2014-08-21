From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.17 1/7] IB/mlx4: Avoid null pointer dereference in mlx4_ib_scan_netdevs()
Date: Thu, 21 Aug 2014 14:28:37 +0300
Message-ID: <1408620523-10616-2-git-send-email-ogerlitz@mellanox.com>
References: <1408620523-10616-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1408620523-10616-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When Ethernet netdev is not present for a port (e.g. when the link
layer type of the port is InfiniBand) it's possible to dereference
a null pointer when we do netdevice scanning.

To fix that, we move a section of code that needs to run only when
netdev is present to a proper if () statement.

Fixes: ad4885d2 ('IB/mlx4: Build the port IBoE GID table properly under bonding')
Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |   49 +++++++++++++++++++-----------------
 1 files changed, 26 insertions(+), 23 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index e1e558a..a6a9e57 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1786,31 +1786,34 @@ static void mlx4_ib_scan_netdevs(struct mlx4_ib_dev *ibdev,
 			port_state = (netif_running(curr_netdev) && netif_carrier_ok(curr_netdev)) ?
 						IB_PORT_ACTIVE : IB_PORT_DOWN;
 			mlx4_ib_set_default_gid(ibdev, curr_netdev, port);
-		} else {
-			reset_gid_table(ibdev, port);
-		}
-		/* if using bonding/team and a slave port is down, we don't the bond IP
-		 * based gids in the table since flows that select port by gid may get
-		 * the down port.
-		 */
-		if (curr_master && (port_state == IB_PORT_DOWN)) {
-			reset_gid_table(ibdev, port);
-			mlx4_ib_set_default_gid(ibdev, curr_netdev, port);
-		}
-		/* if bonding is used it is possible that we add it to masters
-		 * only after IP address is assigned to the net bonding
-		 * interface.
-		*/
-		if (curr_master && (old_master != curr_master)) {
-			reset_gid_table(ibdev, port);
-			mlx4_ib_set_default_gid(ibdev, curr_netdev, port);
-			mlx4_ib_get_dev_addr(curr_master, ibdev, port);
-		}
+			/* if using bonding/team and a slave port is down, we
+			 * don't the bond IP based gids in the table since
+			 * flows that select port by gid may get the down port.
+			 */
+			if (curr_master && (port_state == IB_PORT_DOWN)) {
+				reset_gid_table(ibdev, port);
+				mlx4_ib_set_default_gid(ibdev,
+							curr_netdev, port);
+			}
+			/* if bonding is used it is possible that we add it to
+			 * masters only after IP address is assigned to the
+			 * net bonding interface.
+			*/
+			if (curr_master && (old_master != curr_master)) {
+				reset_gid_table(ibdev, port);
+				mlx4_ib_set_default_gid(ibdev,
+							curr_netdev, port);
+				mlx4_ib_get_dev_addr(curr_master, ibdev, port);
+			}
 
-		if (!curr_master && (old_master != curr_master)) {
+			if (!curr_master && (old_master != curr_master)) {
+				reset_gid_table(ibdev, port);
+				mlx4_ib_set_default_gid(ibdev,
+							curr_netdev, port);
+				mlx4_ib_get_dev_addr(curr_netdev, ibdev, port);
+			}
+		} else {
 			reset_gid_table(ibdev, port);
-			mlx4_ib_set_default_gid(ibdev, curr_netdev, port);
-			mlx4_ib_get_dev_addr(curr_netdev, ibdev, port);
 		}
 	}
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
