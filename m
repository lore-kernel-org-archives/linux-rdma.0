From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: 3.6-rc1 IB complaint
Date: Tue, 07 Aug 2012 16:48:01 +0000
Message-ID: <502146C1.80405@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello,

Has anyone else already seen the ugly kernel message below ? This
message is generated during boot and prevents my IB HCA to come up
properly with 3.6-rc1. This did not happen with kernel 3.5.

=================================
[ INFO: inconsistent lock state ]
3.6.0-rc1-debug+ #1 Not tainted
---------------------------------
inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
swapper/1/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
 (&(&ibdev->sm_lock)->rlock){?.+...}, at: [<ffffffffa0328df4>] update_sm_ah+0x94/0xd0 [mlx4_ib]
{HARDIRQ-ON-W} state was registered at:
  [<ffffffff81095e8a>] __lock_acquire+0x66a/0x1ca0
  [<ffffffff81097ac5>] lock_acquire+0x95/0x130
  [<ffffffff8140e815>] _raw_spin_lock+0x45/0x80
  [<ffffffffa0329b6b>] mlx4_ib_process_mad+0x58b/0x7a0 [mlx4_ib]
  [<ffffffffa03178be>] ib_post_send_mad+0x34e/0x6d0 [ib_mad]
  [<ffffffffa033afc5>] ib_umad_write+0x515/0x630 [ib_umad]
  [<ffffffff8114e41e>] vfs_write+0xce/0x170
  [<ffffffff8114e724>] sys_write+0x54/0xa0
  [<ffffffff81417692>] system_call_fastpath+0x16/0x1b
irq event stamp: 306104
hardirqs last  enabled at (306101): [<ffffffff8100ae75>] mwait_idle+0x95/0x180
hardirqs last disabled at (306102): [<ffffffff8140f5e7>] common_interrupt+0x67/0x6c
softirqs last  enabled at (306104): [<ffffffff81045793>] _local_bh_enable+0x13/0x20
softirqs last disabled at (306103): [<ffffffff81046045>] irq_enter+0x75/0x90

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&(&ibdev->sm_lock)->rlock);
  <Interrupt>
    lock(&(&ibdev->sm_lock)->rlock);

 *** DEADLOCK ***

1 lock held by swapper/1/0:
 #0:  (&(&priv->ctx_lock)->rlock){-.....}, at: [<ffffffffa02472c9>] mlx4_dispatch_event+0x39/0x90 [mlx4_core]

stack backtrace:
Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc1-debug+ #1
Call Trace:
 <IRQ>  [<ffffffff81095429>] print_usage_bug+0x219/0x220
 [<ffffffff8109579f>] mark_lock+0x36f/0x3f0
 [<ffffffff8109602a>] __lock_acquire+0x80a/0x1ca0
 [<ffffffff81097ac5>] lock_acquire+0x95/0x130
 [<ffffffffa0328df4>] ? update_sm_ah+0x94/0xd0 [mlx4_ib]
 [<ffffffffa02f492b>] ? rdma_port_get_link_layer+0x1b/0x40 [ib_core]
 [<ffffffff8140e815>] _raw_spin_lock+0x45/0x80
 [<ffffffffa0328df4>] ? update_sm_ah+0x94/0xd0 [mlx4_ib]
 [<ffffffffa02f42aa>] ? ib_create_ah+0x1a/0x40 [ib_core]
 [<ffffffffa0328df4>] update_sm_ah+0x94/0xd0 [mlx4_ib]
 [<ffffffffa032957b>] handle_port_mgmt_change_event+0xeb/0x150 [mlx4_ib]
 [<ffffffffa0329ed0>] mlx4_ib_event+0x120/0x170 [mlx4_ib]
 [<ffffffff8140e9f3>] ? _raw_spin_lock_irqsave+0x83/0xa0
 [<ffffffffa02472c9>] ? mlx4_dispatch_event+0x39/0x90 [mlx4_core]
 [<ffffffffa02472fc>] mlx4_dispatch_event+0x6c/0x90 [mlx4_core]
 [<ffffffffa0241a80>] mlx4_eq_int+0x4d0/0x920 [mlx4_core]
 [<ffffffff8107673f>] ? local_clock+0x4f/0x60
 [<ffffffffa0241ee4>] mlx4_msi_x_interrupt+0x14/0x20 [mlx4_core]
 [<ffffffff810bd215>] handle_irq_event_percpu+0x75/0x230
 [<ffffffff810bd41e>] handle_irq_event+0x4e/0x80
 [<ffffffff810bfd55>] handle_edge_irq+0x85/0x130
 [<ffffffff81004375>] handle_irq+0x25/0x40
 [<ffffffff81418ddd>] do_IRQ+0x5d/0xe0
 [<ffffffff8140f5ec>] common_interrupt+0x6c/0x6c
 <EOI>  [<ffffffff8100ae7e>] ? mwait_idle+0x9e/0x180
 [<ffffffff8100ae75>] ? mwait_idle+0x95/0x180
 [<ffffffff8100b7a6>] cpu_idle+0xa6/0xe0
 [<ffffffff8140777d>] start_secondary+0x204/0x206
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
