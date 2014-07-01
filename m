From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: mlx4 lockdep splat
Date: Tue, 1 Jul 2014 18:17:27 -0400
Message-ID: <B2CFBE8B-333B-4EA3-8853-9C91FFCE92D8@oracle.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi-

This happens during boot, and means that lockdep and lock_stat are
completely disabled during any testing I do.

Does this splat have a known fix, or should I file an upstream bugzilla?


Jul  1 15:50:22 manet kernel: =================================
Jul  1 15:50:22 manet kernel: [ INFO: inconsistent lock state ]
Jul  1 15:50:22 manet kernel: 3.16.0-rc2-00024-g2e78883 #17 Tainted: G            E
Jul  1 15:50:22 manet kernel: ---------------------------------
Jul  1 15:50:22 manet kernel: inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
Jul  1 15:50:22 manet kernel: swapper/0/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
Jul  1 15:50:22 manet kernel: (&(&iboe->lock)->rlock){+.?...}, at: [<ffffffffa065f68b>] mlx4_ib_addr_event+0xdb/0x1a0 [mlx4_ib]
Jul  1 15:50:22 manet kernel: {SOFTIRQ-ON-W} state was registered at:
Jul  1 15:50:22 manet kernel:  [<ffffffff810b3110>] mark_irqflags+0x110/0x170
Jul  1 15:50:22 manet kernel:  [<ffffffff810b4806>] __lock_acquire+0x2c6/0x5b0
Jul  1 15:50:22 manet kernel:  [<ffffffff810b4bd9>] lock_acquire+0xe9/0x120
Jul  1 15:50:22 manet kernel:  [<ffffffff815f7f6e>] _raw_spin_lock+0x3e/0x80
Jul  1 15:50:22 manet kernel:  [<ffffffffa0661084>] mlx4_ib_scan_netdevs+0x34/0x260 [mlx4_ib]
Jul  1 15:50:22 manet kernel:  [<ffffffffa06612db>] mlx4_ib_netdev_event+0x2b/0x40 [mlx4_ib]
Jul  1 15:50:22 manet kernel:  [<ffffffff81522219>] register_netdevice_notifier+0x99/0x1e0
Jul  1 15:50:22 manet kernel:  [<ffffffffa06626e3>] mlx4_ib_add+0x743/0xbc0 [mlx4_ib]
Jul  1 15:50:22 manet kernel:  [<ffffffffa05ec168>] mlx4_add_device+0x48/0xa0 [mlx4_core]
Jul  1 15:50:22 manet kernel:  [<ffffffffa05ec2c3>] mlx4_register_interface+0x73/0xb0 [mlx4_core]
Jul  1 15:50:22 manet kernel:  [<ffffffffa05c505e>] cm_req_handler+0x13e/0x460 [ib_cm]
Jul  1 15:50:22 manet kernel:  [<ffffffff810002e2>] do_one_initcall+0x112/0x1c0
Jul  1 15:50:22 manet kernel:  [<ffffffff810e8264>] do_init_module+0x34/0x190
Jul  1 15:50:22 manet kernel:  [<ffffffff810ea62f>] load_module+0x5cf/0x740
Jul  1 15:50:22 manet kernel:  [<ffffffff810ea939>] SyS_init_module+0x99/0xd0
Jul  1 15:50:22 manet kernel:  [<ffffffff815f8fd2>] system_call_fastpath+0x16/0x1b
Jul  1 15:50:22 manet kernel: irq event stamp: 336142
Jul  1 15:50:22 manet kernel: hardirqs last  enabled at (336142): [<ffffffff810612f5>] __local_bh_enable_ip+0xb5/0xc0
Jul  1 15:50:22 manet kernel: hardirqs last disabled at (336141): [<ffffffff81061296>] __local_bh_enable_ip+0x56/0xc0
Jul  1 15:50:22 manet kernel: softirqs last  enabled at (336004): [<ffffffff8106123a>] _local_bh_enable+0x4a/0x50
Jul  1 15:50:22 manet kernel: softirqs last disabled at (336005): [<ffffffff810617a4>] irq_exit+0x44/0xd0
Jul  1 15:50:22 manet kernel: 
Jul  1 15:50:22 manet kernel: other info that might help us debug this:
Jul  1 15:50:22 manet kernel: Possible unsafe locking scenario:
Jul  1 15:50:22 manet kernel: 
Jul  1 15:50:22 manet kernel:       CPU0
Jul  1 15:50:22 manet kernel:       ----
Jul  1 15:50:22 manet kernel:  lock(&(&iboe->lock)->rlock);
Jul  1 15:50:22 manet kernel:  <Interrupt>
Jul  1 15:50:22 manet kernel:    lock(&(&iboe->lock)->rlock);
Jul  1 15:50:22 manet kernel: 
Jul  1 15:50:22 manet kernel: *** DEADLOCK ***
Jul  1 15:50:22 manet kernel: 
Jul  1 15:50:22 manet kernel: 3 locks held by swapper/0/0:
Jul  1 15:50:22 manet kernel: #0:  (rcu_read_lock){......}, at: [<ffffffff81523e33>] __netif_receive_skb_core+0xd3/0x620
Jul  1 15:50:22 manet kernel: #1:  (rcu_read_lock){......}, at: [<ffffffffa036195c>] ip6_input_finish+0x6c/0x5a0 [ipv6]
Jul  1 15:50:22 manet kernel: #2:  (rcu_read_lock){......}, at: [<ffffffff81086630>] __atomic_notifier_call_chain+0x0/0xb0


--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
