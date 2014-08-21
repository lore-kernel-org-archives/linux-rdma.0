From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.17 5/7] IB/mlx4: Fix lockdep splat for the iboe lock
Date: Thu, 21 Aug 2014 14:28:41 +0300
Message-ID: <1408620523-10616-6-git-send-email-ogerlitz@mellanox.com>
References: <1408620523-10616-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1408620523-10616-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Chuck Lever reported the following stack trace:

 =================================
 [ INFO: inconsistent lock state ]
 3.16.0-rc2-00024-g2e78883 #17 Tainted: G            E
 ---------------------------------
 inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
 swapper/0/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
 (&(&iboe->lock)->rlock){+.?...}, at: [<ffffffffa065f68b>] mlx4_ib_addr_event+0xdb/0x1a0 [mlx4_ib]
 {SOFTIRQ-ON-W} state was registered at:
  [<ffffffff810b3110>] mark_irqflags+0x110/0x170
  [<ffffffff810b4806>] __lock_acquire+0x2c6/0x5b0
  [<ffffffff810b4bd9>] lock_acquire+0xe9/0x120
  [<ffffffff815f7f6e>] _raw_spin_lock+0x3e/0x80
  [<ffffffffa0661084>] mlx4_ib_scan_netdevs+0x34/0x260 [mlx4_ib]
  [<ffffffffa06612db>] mlx4_ib_netdev_event+0x2b/0x40 [mlx4_ib]
  [<ffffffff81522219>] register_netdevice_notifier+0x99/0x1e0
  [<ffffffffa06626e3>] mlx4_ib_add+0x743/0xbc0 [mlx4_ib]
  [<ffffffffa05ec168>] mlx4_add_device+0x48/0xa0 [mlx4_core]
  [<ffffffffa05ec2c3>] mlx4_register_interface+0x73/0xb0 [mlx4_core]
  [<ffffffffa05c505e>] cm_req_handler+0x13e/0x460 [ib_cm]
  [<ffffffff810002e2>] do_one_initcall+0x112/0x1c0
  [<ffffffff810e8264>] do_init_module+0x34/0x190
  [<ffffffff810ea62f>] load_module+0x5cf/0x740
  [<ffffffff810ea939>] SyS_init_module+0x99/0xd0
  [<ffffffff815f8fd2>] system_call_fastpath+0x16/0x1b
 irq event stamp: 336142
 hardirqs last  enabled at (336142): [<ffffffff810612f5>] __local_bh_enable_ip+0xb5/0xc0
 hardirqs last disabled at (336141): [<ffffffff81061296>] __local_bh_enable_ip+0x56/0xc0
 softirqs last  enabled at (336004): [<ffffffff8106123a>] _local_bh_enable+0x4a/0x50
 softirqs last disabled at (336005): [<ffffffff810617a4>] irq_exit+0x44/0xd0

 other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&(&iboe->lock)->rlock);
  <Interrupt>
    lock(&(&iboe->lock)->rlock);

 *** DEADLOCK ***

The above problem was caused by the spin lock being taken both in the process
context and in a soft-irq context (in a netdev notifier handler).

The required fix is to use spin_lock/unlock_bh() instead of spin_lock/unlock
on the iboe lock.

Reported-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index dc0dac0..5179504 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -357,7 +357,7 @@ static int eth_link_query_port(struct ib_device *ibdev, u8 port,
 	props->state		= IB_PORT_DOWN;
 	props->phys_state	= state_to_phys_state(props->state);
 	props->active_mtu	= IB_MTU_256;
-	spin_lock(&iboe->lock);
+	spin_lock_bh(&iboe->lock);
 	ndev = iboe->netdevs[port - 1];
 	if (!ndev)
 		goto out_unlock;
@@ -369,7 +369,7 @@ static int eth_link_query_port(struct ib_device *ibdev, u8 port,
 					IB_PORT_ACTIVE : IB_PORT_DOWN;
 	props->phys_state	= state_to_phys_state(props->state);
 out_unlock:
-	spin_unlock(&iboe->lock);
+	spin_unlock_bh(&iboe->lock);
 out:
 	mlx4_free_cmd_mailbox(mdev->dev, mailbox);
 	return err;
@@ -811,11 +811,11 @@ int mlx4_ib_add_mc(struct mlx4_ib_dev *mdev, struct mlx4_ib_qp *mqp,
 	if (!mqp->port)
 		return 0;
 
-	spin_lock(&mdev->iboe.lock);
+	spin_lock_bh(&mdev->iboe.lock);
 	ndev = mdev->iboe.netdevs[mqp->port - 1];
 	if (ndev)
 		dev_hold(ndev);
-	spin_unlock(&mdev->iboe.lock);
+	spin_unlock_bh(&mdev->iboe.lock);
 
 	if (ndev) {
 		ret = 1;
@@ -1262,11 +1262,11 @@ static int mlx4_ib_mcg_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 	mutex_lock(&mqp->mutex);
 	ge = find_gid_entry(mqp, gid->raw);
 	if (ge) {
-		spin_lock(&mdev->iboe.lock);
+		spin_lock_bh(&mdev->iboe.lock);
 		ndev = ge->added ? mdev->iboe.netdevs[ge->port - 1] : NULL;
 		if (ndev)
 			dev_hold(ndev);
-		spin_unlock(&mdev->iboe.lock);
+		spin_unlock_bh(&mdev->iboe.lock);
 		if (ndev)
 			dev_put(ndev);
 		list_del(&ge->list);
@@ -1551,7 +1551,7 @@ static int mlx4_ib_addr_event(int event, struct net_device *event_netdev,
 		return 0;
 
 	iboe = &ibdev->iboe;
-	spin_lock(&iboe->lock);
+	spin_lock_bh(&iboe->lock);
 
 	for (port = 1; port <= ibdev->dev->caps.num_ports; ++port)
 		if ((netif_is_bond_master(real_dev) &&
@@ -1561,7 +1561,7 @@ static int mlx4_ib_addr_event(int event, struct net_device *event_netdev,
 			update_gid_table(ibdev, port, gid,
 					 event == NETDEV_DOWN, 0);
 
-	spin_unlock(&iboe->lock);
+	spin_unlock_bh(&iboe->lock);
 	return 0;
 
 }
@@ -1739,7 +1739,7 @@ static int mlx4_ib_init_gid_table(struct mlx4_ib_dev *ibdev)
 	}
 
 	read_lock(&dev_base_lock);
-	spin_lock(&iboe->lock);
+	spin_lock_bh(&iboe->lock);
 
 	for_each_netdev(&init_net, dev) {
 		u8 port = mlx4_ib_get_dev_port(dev, ibdev);
@@ -1750,7 +1750,7 @@ static int mlx4_ib_init_gid_table(struct mlx4_ib_dev *ibdev)
 		}
 	}
 
-	spin_unlock(&iboe->lock);
+	spin_unlock_bh(&iboe->lock);
 	read_unlock(&dev_base_lock);
 out:
 	return err;
@@ -1767,7 +1767,7 @@ static void mlx4_ib_scan_netdevs(struct mlx4_ib_dev *ibdev,
 
 	iboe = &ibdev->iboe;
 
-	spin_lock(&iboe->lock);
+	spin_lock_bh(&iboe->lock);
 	mlx4_foreach_ib_transport_port(port, ibdev->dev) {
 		enum ib_port_state	port_state = IB_PORT_NOP;
 		struct net_device *old_master = iboe->masters[port - 1];
@@ -1839,7 +1839,7 @@ static void mlx4_ib_scan_netdevs(struct mlx4_ib_dev *ibdev,
 		}
 	}
 
-	spin_unlock(&iboe->lock);
+	spin_unlock_bh(&iboe->lock);
 
 	if (update_qps_port > 0)
 		mlx4_ib_update_qps(ibdev, dev, update_qps_port);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
