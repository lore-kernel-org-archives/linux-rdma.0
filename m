From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] IB/mlx4: fix possible deadlock with sm_lock spinlock
Date: Fri,  3 Aug 2012 11:26:45 +0300
Message-ID: <1343982405-2828-1-git-send-email-jackm@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dotanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The sm_lock spinlock is taken in the process context by mlx4_ib_modify_device,
and in the interrupt context by update_sm_ah.

Need to take that spinlock with irqsave, and release it with irqrestore.

>From a stack trace with LOCKDEP configured in the kernel:
[ INFO: inconsistent lock state ]
3.5.0+ #20 Not tainted
inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
swapper/0/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
(&(&ibdev->sm_lock)->rlock){?.+...}, at: [<ffffffffa028af1d>] update_sm_ah+0xad/0x100 [mlx4_ib]
{HARDIRQ-ON-W} state was registered at:
  [<ffffffff810b84a0>] mark_irqflags+0x120/0x190
  [<ffffffff810b9ce7>] __lock_acquire+0x307/0x4c0
  [<ffffffff810b9f51>] lock_acquire+0xb1/0x150
  [<ffffffff815523b1>] _raw_spin_lock+0x41/0x50
  [<ffffffffa028d563>] mlx4_ib_modify_device+0x63/0x240 [mlx4_ib]
  [<ffffffffa026d1fc>] ib_modify_device+0x1c/0x20 [ib_core]
  [<ffffffffa026c353>] set_node_desc+0x83/0xc0 [ib_core]
  [<ffffffff8136a150>] dev_attr_store+0x20/0x30
  [<ffffffff81201fd6>] sysfs_write_file+0xe6/0x170
  [<ffffffff8118da38>] vfs_write+0xc8/0x190
  [<ffffffff8118dc01>] sys_write+0x51/0x90
  [<ffffffff8155b869>] system_call_fastpath+0x16/0x1b

...
*** DEADLOCK ***

1 lock held by swapper/0/0:

stack backtrace:
Pid: 0, comm: swapper/0 Not tainted 3.5.0+ #20
Call Trace:
<IRQ>  [<ffffffff810b7bea>] print_usage_bug+0x18a/0x190
[<ffffffff810b7370>] ? print_irq_inversion_bug+0x210/0x210
[<ffffffff810b7fb2>] mark_lock_irq+0xf2/0x280
[<ffffffff810b8290>] mark_lock+0x150/0x240
[<ffffffff810b84ef>] mark_irqflags+0x16f/0x190
[<ffffffff810b9ce7>] __lock_acquire+0x307/0x4c0
[<ffffffffa028af1d>] ? update_sm_ah+0xad/0x100 [mlx4_ib]
[<ffffffff810b9f51>] lock_acquire+0xb1/0x150
[<ffffffffa028af1d>] ? update_sm_ah+0xad/0x100 [mlx4_ib]
[<ffffffff815523b1>] _raw_spin_lock+0x41/0x50
[<ffffffffa028af1d>] ? update_sm_ah+0xad/0x100 [mlx4_ib]
[<ffffffffa026b2fa>] ? ib_create_ah+0x1a/0x40 [ib_core]
[<ffffffffa028af1d>] update_sm_ah+0xad/0x100 [mlx4_ib]
[<ffffffff810c27c3>] ? is_module_address+0x23/0x30
[<ffffffffa028b05b>] handle_port_mgmt_change_event+0xeb/0x150 [mlx4_ib]
[<ffffffffa028c177>] mlx4_ib_event+0x117/0x160 [mlx4_ib]
[<ffffffff81552501>] ? _raw_spin_lock_irqsave+0x61/0x70
[<ffffffffa022718c>] mlx4_dispatch_event+0x6c/0x90 [mlx4_core]
[<ffffffffa0221b40>] mlx4_eq_int+0x500/0x950 [mlx4_core]

Reported by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mad.c  |   16 ++++++++++------
 drivers/infiniband/hw/mlx4/main.c |    7 ++++---
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index c27141f..9c2ae7e 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -125,6 +125,7 @@ static void update_sm_ah(struct mlx4_ib_dev *dev, u8 port_num, u16 lid, u8 sl)
 {
 	struct ib_ah *new_ah;
 	struct ib_ah_attr ah_attr;
+	unsigned long flags;
 
 	if (!dev->send_agent[port_num - 1][0])
 		return;
@@ -139,11 +140,11 @@ static void update_sm_ah(struct mlx4_ib_dev *dev, u8 port_num, u16 lid, u8 sl)
 	if (IS_ERR(new_ah))
 		return;
 
-	spin_lock(&dev->sm_lock);
+	spin_lock_irqsave(&dev->sm_lock, flags);
 	if (dev->sm_ah[port_num - 1])
 		ib_destroy_ah(dev->sm_ah[port_num - 1]);
 	dev->sm_ah[port_num - 1] = new_ah;
-	spin_unlock(&dev->sm_lock);
+	spin_unlock_irqrestore(&dev->sm_lock, flags);
 }
 
 /*
@@ -197,13 +198,15 @@ static void smp_snoop(struct ib_device *ibdev, u8 port_num, struct ib_mad *mad,
 static void node_desc_override(struct ib_device *dev,
 			       struct ib_mad *mad)
 {
+	unsigned long flags;
+
 	if ((mad->mad_hdr.mgmt_class == IB_MGMT_CLASS_SUBN_LID_ROUTED ||
 	     mad->mad_hdr.mgmt_class == IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE) &&
 	    mad->mad_hdr.method == IB_MGMT_METHOD_GET_RESP &&
 	    mad->mad_hdr.attr_id == IB_SMP_ATTR_NODE_DESC) {
-		spin_lock(&to_mdev(dev)->sm_lock);
+		spin_lock_irqsave(&to_mdev(dev)->sm_lock, flags);
 		memcpy(((struct ib_smp *) mad)->data, dev->node_desc, 64);
-		spin_unlock(&to_mdev(dev)->sm_lock);
+		spin_unlock_irqrestore(&to_mdev(dev)->sm_lock, flags);
 	}
 }
 
@@ -213,6 +216,7 @@ static void forward_trap(struct mlx4_ib_dev *dev, u8 port_num, struct ib_mad *ma
 	struct ib_mad_send_buf *send_buf;
 	struct ib_mad_agent *agent = dev->send_agent[port_num - 1][qpn];
 	int ret;
+	unsigned long flags;
 
 	if (agent) {
 		send_buf = ib_create_send_mad(agent, qpn, 0, 0, IB_MGMT_MAD_HDR,
@@ -225,13 +229,13 @@ static void forward_trap(struct mlx4_ib_dev *dev, u8 port_num, struct ib_mad *ma
 		 * wrong following the IB spec strictly, but we know
 		 * it's OK for our devices).
 		 */
-		spin_lock(&dev->sm_lock);
+		spin_lock_irqsave(&dev->sm_lock, flags);
 		memcpy(send_buf->mad, mad, sizeof *mad);
 		if ((send_buf->ah = dev->sm_ah[port_num - 1]))
 			ret = ib_post_send_mad(send_buf, NULL);
 		else
 			ret = -EINVAL;
-		spin_unlock(&dev->sm_lock);
+		spin_unlock_irqrestore(&dev->sm_lock, flags);
 
 		if (ret)
 			ib_free_send_mad(send_buf);
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index fe2088c..7573304 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -423,16 +423,17 @@ static int mlx4_ib_modify_device(struct ib_device *ibdev, int mask,
 				 struct ib_device_modify *props)
 {
 	struct mlx4_cmd_mailbox *mailbox;
-
+	unsigned long flags;
+
 	if (mask & ~IB_DEVICE_MODIFY_NODE_DESC)
 		return -EOPNOTSUPP;
 
 	if (!(mask & IB_DEVICE_MODIFY_NODE_DESC))
 		return 0;
 
-	spin_lock(&to_mdev(ibdev)->sm_lock);
+	spin_lock_irqsave(&to_mdev(ibdev)->sm_lock, flags);
 	memcpy(ibdev->node_desc, props->node_desc, 64);
-	spin_unlock(&to_mdev(ibdev)->sm_lock);
+	spin_unlock_irqrestore(&to_mdev(ibdev)->sm_lock, flags);
 
 	/*
 	 * If possible, pass node desc to FW, so it can generate
-- 
1.7.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
