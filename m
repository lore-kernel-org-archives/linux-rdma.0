From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.17 4/7] IB/mlx4: Get upper dev addresses as RoCE GIDs when port comes up
Date: Thu, 21 Aug 2014 14:28:40 +0300
Message-ID: <1408620523-10616-5-git-send-email-ogerlitz@mellanox.com>
References: <1408620523-10616-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1408620523-10616-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When RoCE port becomes active and netdev of the port has upper
device (e.g bond/team), gids derived from the upper dev should
appear in the port's RoCE gid table.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index d95b5fe..dc0dac0 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1799,14 +1799,23 @@ static void mlx4_ib_scan_netdevs(struct mlx4_ib_dev *ibdev,
 			port_state = (netif_running(curr_netdev) && netif_carrier_ok(curr_netdev)) ?
 						IB_PORT_ACTIVE : IB_PORT_DOWN;
 			mlx4_ib_set_default_gid(ibdev, curr_netdev, port);
-			/* if using bonding/team and a slave port is down, we
-			 * don't the bond IP based gids in the table since
-			 * flows that select port by gid may get the down port.
-			 */
-			if (curr_master && (port_state == IB_PORT_DOWN)) {
-				reset_gid_table(ibdev, port);
-				mlx4_ib_set_default_gid(ibdev,
-							curr_netdev, port);
+			if (curr_master) {
+				/* if using bonding/team and a slave port is down, we
+				 * don't want the bond IP based gids in the table since
+				 * flows that select port by gid may get the down port.
+				*/
+				if (port_state == IB_PORT_DOWN) {
+					reset_gid_table(ibdev, port);
+					mlx4_ib_set_default_gid(ibdev,
+								curr_netdev,
+								port);
+				} else {
+					/* gids from the upper dev (bond/team)
+					 * should appear in port's gid table
+					*/
+					mlx4_ib_get_dev_addr(curr_master,
+							     ibdev, port);
+				}
 			}
 			/* if bonding is used it is possible that we add it to
 			 * masters only after IP address is assigned to the
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
