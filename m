From: bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org
Subject: [Bug 119561] New: IPoIB lock inversion complaint
Date: Thu, 02 Jun 2016 20:06:12 +0000
Message-ID: <bug-119561-11804@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=119561

            Bug ID: 119561
           Summary: IPoIB lock inversion complaint
           Product: Drivers
           Version: 2.5
    Kernel Version: 4.7.0-rc1
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Infiniband/RDMA
          Assignee: drivers_infiniband-rdma-ztI5WcYan/vQLgFONoPN62D2FQJk+8+b@public.gmane.org
          Reporter: bvanassche-HInyCGIudOg@public.gmane.org
        Regression: No

The following complaint is reported sometimes when I boot a 4.7.0-rc1 kernel:



=========================================================
[ INFO: possible irq lock inversion dependency detected ]
4.7.0-rc1-dbg+ #1 Not tainted
---------------------------------------------------------
kworker/u64:8/138 just changed the state of lock:
 (_xmit_INFINIBAND){+.+...}, at: [<ffffffffa02d360f>]
ipoib_dev_addr_changed_valid+0x5f/0x1b0 [ib_ipoib]
but this lock was taken by another, SOFTIRQ-safe lock in the past:
 (&(&mc->mca_lock)->rlock){+.-...}

and interrupts could create inverse lock ordering between them.
other info that might help us debug this:

 Possible interrupt unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(_xmit_INFINIBAND);
                               local_irq_disable();
                               lock(&(&mc->mca_lock)->rlock);
                               lock(_xmit_INFINIBAND);
  <Interrupt>
    lock(&(&mc->mca_lock)->rlock);

*** DEADLOCK ***

2 locks held by kworker/u64:8/138:
 #0:  ("%s""ipoib_flush"){.+.+.+}, at: [<ffffffff810736ed>]
process_one_work+0x13d/0x490
 #1:  ((&priv->flush_light)){+.+.+.}, at: [<ffffffff810736ed>]
process_one_work+0x13d/0x490

the shortest dependencies between 2nd lock and 1st lock:
-> (&(&mc->mca_lock)->rlock){+.-...} ops: 91 {
   HARDIRQ-ON-W at:
                     [<ffffffff810a86b6>] __lock_acquire+0x566/0x1480
                     [<ffffffff810a9990>] lock_acquire+0x60/0x80
                     [<ffffffff815b159a>] _raw_spin_lock_bh+0x3a/0x50
                     [<ffffffff815879e5>] igmp6_group_added+0x35/0x190
                     [<ffffffff815885bf>] ipv6_dev_mc_inc+0x33f/0x470
                     [<ffffffff815644e7>] ipv6_add_dev+0x3d7/0x4b0
                     [<ffffffff81b07278>] addrconf_init+0x8e/0x209
                     [<ffffffff81b07075>] inet6_init+0x1aa/0x30d
                     [<ffffffff81000418>] do_one_initcall+0x38/0x150
                     [<ffffffff81ac7076>] kernel_init_freeable+0x1b1/0x239
                     [<ffffffff815a4729>] kernel_init+0x9/0x100
                     [<ffffffff815b20af>] ret_from_fork+0x1f/0x40
   IN-SOFTIRQ-W at:
                     [<ffffffff810a868a>] __lock_acquire+0x53a/0x1480
                     [<ffffffff810a9990>] lock_acquire+0x60/0x80
                     [<ffffffff815b159a>] _raw_spin_lock_bh+0x3a/0x50
                     [<ffffffff81586f18>] mld_ifc_timer_expire+0xe8/0x2b0
                     [<ffffffff810c05a6>] call_timer_fn+0x66/0xe0
                     [<ffffffff810c07cc>] run_timer_softirq+0x1ac/0x250
                     [<ffffffff8105e43f>] __do_softirq+0x10f/0x230
                     [<ffffffff8105e6e8>] irq_exit+0xa8/0xb0
                     [<ffffffff8103aa48>]
smp_trace_apic_timer_interrupt+0x68/0x90
                     [<ffffffff8103aa79>] smp_apic_timer_interrupt+0x9/0x10
                     [<ffffffff815b2aa9>] apic_timer_interrupt+0x89/0x90
                     [<ffffffff8146ba38>] cpuidle_enter_state+0x138/0x210
                     [<ffffffff8146bb32>] cpuidle_enter+0x12/0x20
                     [<ffffffff8109d283>] cpu_startup_entry+0x1c3/0x210
                     [<ffffffff815a4710>] rest_init+0x130/0x140
                     [<ffffffff81ac6eb8>] start_kernel+0x3e9/0x3f6
                     [<ffffffff81ac6294>] x86_64_start_reservations+0x2f/0x31
                     [<ffffffff81ac63c0>] x86_64_start_kernel+0x12a/0x135
   INITIAL USE at:
                    [<ffffffff810a836c>] __lock_acquire+0x21c/0x1480
                    [<ffffffff810a9990>] lock_acquire+0x60/0x80
                    [<ffffffff815b159a>] _raw_spin_lock_bh+0x3a/0x50
                    [<ffffffff815879e5>] igmp6_group_added+0x35/0x190
                    [<ffffffff815885bf>] ipv6_dev_mc_inc+0x33f/0x470
                    [<ffffffff815644e7>] ipv6_add_dev+0x3d7/0x4b0
                    [<ffffffff81b07278>] addrconf_init+0x8e/0x209
                    [<ffffffff81b07075>] inet6_init+0x1aa/0x30d
                    [<ffffffff81000418>] do_one_initcall+0x38/0x150
                    [<ffffffff81ac7076>] kernel_init_freeable+0x1b1/0x239
                    [<ffffffff815a4729>] kernel_init+0x9/0x100
                    [<ffffffff815b20af>] ret_from_fork+0x1f/0x40
 }
 ... key      at: [<ffffffff82940b20>] __key.57090+0x0/0x8
 ... acquired at:
  [<ffffffff810a9990>] lock_acquire+0x60/0x80
  [<ffffffff815b159a>] _raw_spin_lock_bh+0x3a/0x50
  [<ffffffff814b6f07>] __dev_mc_add+0x27/0x80
  [<ffffffff814b6f6b>] dev_mc_add+0xb/0x10
  [<ffffffff81587b01>] igmp6_group_added+0x151/0x190
  [<ffffffff815885bf>] ipv6_dev_mc_inc+0x33f/0x470
  [<ffffffff815644e7>] ipv6_add_dev+0x3d7/0x4b0
  [<ffffffff8156a8be>] addrconf_notify+0x3ae/0xd10
  [<ffffffff8107b198>] notifier_call_chain+0x58/0x80
  [<ffffffff8107b1e1>] raw_notifier_call_chain+0x11/0x20
  [<ffffffff814a6220>] call_netdevice_notifiers_info+0x30/0x60
  [<ffffffff814b1e35>] register_netdevice+0x455/0x510
  [<ffffffff814b1f05>] register_netdev+0x15/0x30
  [<ffffffffa02d3189>] ipoib_add_one+0x259/0x490 [ib_ipoib]
  [<ffffffffa0377485>] ib_register_client+0x65/0xb0 [ib_core]
  [<ffffffffa02e70f2>] srp_rport_set_state+0x42/0x80 [scsi_transport_srp]
  [<ffffffff81000418>] do_one_initcall+0x38/0x150
  [<ffffffff8111acc9>] do_init_module+0x55/0x1cc
  [<ffffffff810db55b>] load_module+0x20ab/0x2660
  [<ffffffff810dbd53>] SYSC_finit_module+0xc3/0xf0
  [<ffffffff810dbd99>] SyS_finit_module+0x9/0x10
  [<ffffffff815b1e69>] entry_SYSCALL_64_fastpath+0x1c/0xac

> (_xmit_INFINIBAND){+.+...} ops: 5 {
  HARDIRQ-ON-W at:
                   [<ffffffff810a86b6>] __lock_acquire+0x566/0x1480
                   [<ffffffff810a9990>] lock_acquire+0x60/0x80
                   [<ffffffff815b159a>] _raw_spin_lock_bh+0x3a/0x50
                   [<ffffffff814b6f07>] __dev_mc_add+0x27/0x80
                   [<ffffffff814b6f6b>] dev_mc_add+0xb/0x10
                   [<ffffffff81587b01>] igmp6_group_added+0x151/0x190
                   [<ffffffff815885bf>] ipv6_dev_mc_inc+0x33f/0x470
                   [<ffffffff815644e7>] ipv6_add_dev+0x3d7/0x4b0
                   [<ffffffff8156a8be>] addrconf_notify+0x3ae/0xd10
                   [<ffffffff8107b198>] notifier_call_chain+0x58/0x80
                   [<ffffffff8107b1e1>] raw_notifier_call_chain+0x11/0x20
                   [<ffffffff814a6220>] call_netdevice_notifiers_info+0x30/0x60
                   [<ffffffff814b1e35>] register_netdevice+0x455/0x510
                   [<ffffffff814b1f05>] register_netdev+0x15/0x30
                   [<ffffffffa02d3189>] ipoib_add_one+0x259/0x490 [ib_ipoib]
                   [<ffffffffa0377485>] ib_register_client+0x65/0xb0 [ib_core]
                   [<ffffffffa02e70f2>] srp_rport_set_state+0x42/0x80
[scsi_transport_srp]
                   [<ffffffff81000418>] do_one_initcall+0x38/0x150
                   [<ffffffff8111acc9>] do_init_module+0x55/0x1cc
                   [<ffffffff810db55b>] load_module+0x20ab/0x2660
                   [<ffffffff810dbd53>] SYSC_finit_module+0xc3/0xf0
                   [<ffffffff810dbd99>] SyS_finit_module+0x9/0x10
                   [<ffffffff815b1e69>] entry_SYSCALL_64_fastpath+0x1c/0xac
  SOFTIRQ-ON-W at:
                   [<ffffffff810a86e8>] __lock_acquire+0x598/0x1480
                   [<ffffffff810a9990>] lock_acquire+0x60/0x80
                   [<ffffffff815b1453>] _raw_spin_lock+0x33/0x50
                   [<ffffffffa02d360f>] ipoib_dev_addr_changed_valid+0x5f/0x1b0
[ib_ipoib]
                   [<ffffffffa02d5875>] __ipoib_ib_dev_flush+0x125/0x440
[ib_ipoib]
                   [<ffffffffa02d5c54>] ipoib_ib_dev_flush_light+0x14/0x20
[ib_ipoib]
                   [<ffffffff8107374d>] process_one_work+0x19d/0x490
                   [<ffffffff81073a89>] worker_thread+0x49/0x490
                   [<ffffffff8107a04a>] kthread+0xea/0x100
                   [<ffffffff815b20af>] ret_from_fork+0x1f/0x40
  INITIAL USE at:
                  [<ffffffff810a836c>] __lock_acquire+0x21c/0x1480
                  [<ffffffff810a9990>] lock_acquire+0x60/0x80
                  [<ffffffff815b159a>] _raw_spin_lock_bh+0x3a/0x50
                  [<ffffffff814b6f07>] __dev_mc_add+0x27/0x80
                  [<ffffffff814b6f6b>] dev_mc_add+0xb/0x10
                  [<ffffffff81587b01>] igmp6_group_added+0x151/0x190
                  [<ffffffff815885bf>] ipv6_dev_mc_inc+0x33f/0x470
                  [<ffffffff815644e7>] ipv6_add_dev+0x3d7/0x4b0
                  [<ffffffff8156a8be>] addrconf_notify+0x3ae/0xd10
                  [<ffffffff8107b198>] notifier_call_chain+0x58/0x80
                  [<ffffffff8107b1e1>] raw_notifier_call_chain+0x11/0x20
                  [<ffffffff814a6220>] call_netdevice_notifiers_info+0x30/0x60
                  [<ffffffff814b1e35>] register_netdevice+0x455/0x510
                  [<ffffffff814b1f05>] register_netdev+0x15/0x30
                  [<ffffffffa02d3189>] ipoib_add_one+0x259/0x490 [ib_ipoib]
                  [<ffffffffa0377485>] ib_register_client+0x65/0xb0 [ib_core]
                  [<ffffffffa02e70f2>] srp_rport_set_state+0x42/0x80
[scsi_transport_srp]
                  [<ffffffff81000418>] do_one_initcall+0x38/0x150
                  [<ffffffff8111acc9>] do_init_module+0x55/0x1cc
                  [<ffffffff810db55b>] load_module+0x20ab/0x2660
                  [<ffffffff810dbd53>] SYSC_finit_module+0xc3/0xf0
                  [<ffffffff810dbd99>] SyS_finit_module+0x9/0x10
                  [<ffffffff815b1e69>] entry_SYSCALL_64_fastpath+0x1c/0xac
}
... key      at: [<ffffffff8292b3d0>] netdev_addr_lock_key+0x70/0x1e0
... acquired at:
  [<ffffffff810a6ba9>] check_usage_backwards+0x129/0x130
  [<ffffffff810a7966>] mark_lock+0x336/0x610
  [<ffffffff810a86e8>] __lock_acquire+0x598/0x1480
  [<ffffffff810a9990>] lock_acquire+0x60/0x80
  [<ffffffff815b1453>] _raw_spin_lock+0x33/0x50
  [<ffffffffa02d360f>] ipoib_dev_addr_changed_valid+0x5f/0x1b0 [ib_ipoib]
  [<ffffffffa02d5875>] __ipoib_ib_dev_flush+0x125/0x440 [ib_ipoib]
  [<ffffffffa02d5c54>] ipoib_ib_dev_flush_light+0x14/0x20 [ib_ipoib]
  [<ffffffff8107374d>] process_one_work+0x19d/0x490
  [<ffffffff81073a89>] worker_thread+0x49/0x490
  [<ffffffff8107a04a>] kthread+0xea/0x100
  [<ffffffff815b20af>] ret_from_fork+0x1f/0x40


stack backtrace:

CPU: 5 PID: 138 Comm: kworker/u64:8 Not tainted 4.7.0-rc1-dbg+ #1
Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 1.0.2 11/17/2014
Workqueue: ipoib_flush ipoib_ib_dev_flush_light [ib_ipoib]
 0000000000000000 ffff88045d53bac0 ffffffff812c71a5 ffffffff826d0720
 ffff88045d53bb20 ffff88045d53bb00 ffffffff8111a93c ffff88045d5aea88
 ffff88045d5aea88 ffff88045d5ae240 ffffffff81797209 0000000000000000
Call Trace:
 [<ffffffff812c71a5>] dump_stack+0x67/0x92
 [<ffffffff8111a93c>] print_irq_inversion_bug.part.36+0x1a4/0x1b0
 [<ffffffff810a6ba9>] check_usage_backwards+0x129/0x130
 [<ffffffff810a7966>] mark_lock+0x336/0x610
 [<ffffffff810a6a80>] ? print_shortest_lock_dependencies+0x1a0/0x1a0
 [<ffffffff810a86e8>] __lock_acquire+0x598/0x1480
 [<ffffffff81178509>] ? kfree+0xa9/0x150
 [<ffffffffa03d5a81>] ? __mlx4_ib_query_gid+0x111/0x1b0 [mlx4_ib]
 [<ffffffff811785a4>] ? kfree+0x144/0x150
 [<ffffffff810a9990>] lock_acquire+0x60/0x80
 [<ffffffffa02d360f>] ? ipoib_dev_addr_changed_valid+0x5f/0x1b0 [ib_ipoib]
 [<ffffffff815b1453>] _raw_spin_lock+0x33/0x50
 [<ffffffffa02d360f>] ? ipoib_dev_addr_changed_valid+0x5f/0x1b0 [ib_ipoib]
 [<ffffffffa02d360f>] ipoib_dev_addr_changed_valid+0x5f/0x1b0 [ib_ipoib]
 [<ffffffffa02d5875>] __ipoib_ib_dev_flush+0x125/0x440 [ib_ipoib]
 [<ffffffffa02d5c54>] ipoib_ib_dev_flush_light+0x14/0x20 [ib_ipoib]
 [<ffffffff8107374d>] process_one_work+0x19d/0x490
 [<ffffffff810736ed>] ? process_one_work+0x13d/0x490
 [<ffffffff81073a89>] worker_thread+0x49/0x490
 [<ffffffff81073a40>] ? process_one_work+0x490/0x490
 [<ffffffff8107a04a>] kthread+0xea/0x100
 [<ffffffff815b20af>] ret_from_fork+0x1f/0x40
 [<ffffffff81079f60>] ? kthread_create_on_node+0x1f0/0x1f0

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
