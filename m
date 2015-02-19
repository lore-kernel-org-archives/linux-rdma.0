From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 20/30] IB/mlx4: Lock with RCU instead of RTNL
Date: Fri, 20 Feb 2015 03:32:35 +0530
Message-ID: <ecdac3ce-232f-48bd-b89f-9447030c398e@CMEXHTCAS2.ad.emulex.com>
References: <1424383365-19337-1-git-send-email-somnath.kotur@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424383365-19337-1-git-send-email-somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The function eth_link_query_port() used to take the RTNL lock when
call to netdev_master_upper_dev_get() was necessary. This makes it
impossible to call this function with RTNL lock is held. Calling
netdev_master_upper_dev_get_rcu() and locking with RCU instead solve
this problem.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index d8b227e..32cd009 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -367,14 +367,15 @@ static int eth_link_query_port(struct ib_device *ibdev, u8 port,
 	props->state		= IB_PORT_DOWN;
 	props->phys_state	= state_to_phys_state(props->state);
 	props->active_mtu	= IB_MTU_256;
-	if (is_bonded)
-		rtnl_lock(); /* required to get upper dev */
 	down_read(&iboe->sem);
 	ndev = iboe->netdevs[port - 1];
-	if (ndev && is_bonded)
-		ndev = netdev_master_upper_dev_get(ndev);
+	if (ndev && is_bonded) {
+		rcu_read_lock(); /* required to get upper dev */
+		ndev = netdev_master_upper_dev_get_rcu(ndev);
+		rcu_read_unlock();
+	}
 	if (!ndev)
-		goto out_unlock;
+		goto unlock;
 
 	tmp = iboe_get_mtu(ndev->mtu);
 	props->active_mtu = tmp ? min(props->max_mtu, tmp) : IB_MTU_256;
@@ -382,10 +383,8 @@ static int eth_link_query_port(struct ib_device *ibdev, u8 port,
 	props->state		= (netif_running(ndev) && netif_carrier_ok(ndev)) ?
 					IB_PORT_ACTIVE : IB_PORT_DOWN;
 	props->phys_state	= state_to_phys_state(props->state);
-out_unlock:
+unlock:
 	up_read(&iboe->sem);
-	if (is_bonded)
-		rtnl_unlock();
 out:
 	mlx4_free_cmd_mailbox(mdev->dev, mailbox);
 	return err;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
