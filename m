From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH FIXES 0/2] mlx4: SRIOV locking related fixes
Date: Tue, 27 Nov 2012 18:24:28 +0200
Message-ID: <1354033470-12724-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

Pretty late indeed, but here are two SRIOV locking related fixes for issues 
spotted by lockdep. Basically, as we're late in the cycle, I guess there are 
two options here, either push to 3.8 and later to -stable once 3.7 is released,
or push to 3.7 this week. This way or another, would be nice if you can place 
them on a branch at your tree which will cause them to spend the night in linux-next.

Or.


Jack Morgenstein (2):
  IB/mlx4: Fix spinlock order to avoid lockdep warnings
  NET/mlx4_core: Fix potential deadlock in mlx4_eq_int

 drivers/infiniband/hw/mlx4/cm.c          |    4 ++--
 drivers/net/ethernet/mellanox/mlx4/cmd.c |    9 +++++----
 drivers/net/ethernet/mellanox/mlx4/eq.c  |   10 ++++++----
 3 files changed, 13 insertions(+), 10 deletions(-)


These are the lockdep warnings, initially those that relate to patch #1
and later those relating to patch #2. Personally, I don't see the added value
in placing them in the change-log, so they are brought up here for the purpose
of reporting on the problems.

(1) those that relate to patch #1

======================================================
[ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
3.7.0-rc6+ #68 Not tainted
------------------------------------------------------
kworker/u:3/1547 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
 (&(&dev->sriov.id_map_lock)->rlock){+.+...}, at: [<ffffffffa03d5387>] schedule_delayed+0x38/0x77 [mlx4_ib]

and this task is already holding:
 (&(&dev->sriov.going_down_lock)->rlock){-.-...}, at: [<ffffffffa03d537c>] schedule_delayed+0x2d/0x77 [mlx4_ib]
which would create a new lock dependency:
 (&(&dev->sriov.going_down_lock)->rlock){-.-...} -> (&(&dev->sriov.id_map_lock)->rlock){+.+...}

but this new dependency connects a HARDIRQ-irq-safe lock:
 (&(&dev->sriov.going_down_lock)->rlock){-.-...}
... which became HARDIRQ-irq-safe at:
  [<ffffffff81070ea6>] __lock_acquire+0x5e9/0x9ae
  [<ffffffff8107135b>] lock_acquire+0xf0/0x116
  [<ffffffff813845e8>] _raw_spin_lock_irqsave+0x46/0x58
  [<ffffffffa03c8ad9>] mlx4_ib_tunnel_comp_handler+0x22/0x57 [mlx4_ib]
  [<ffffffffa03c63ba>] mlx4_ib_cq_comp+0x12/0x14 [mlx4_ib]
  [<ffffffffa03e9b22>] mlx4_cq_completion+0x5c/0x62 [mlx4_core]
  [<ffffffffa03eb1fb>] mlx4_eq_int+0x89/0x865 [mlx4_core]
  [<ffffffffa03eb9e6>] mlx4_msi_x_interrupt+0xf/0x16 [mlx4_core]
  [<ffffffff8108b0d7>] handle_irq_event_percpu+0x93/0x1d7
  [<ffffffff8108b257>] handle_irq_event+0x3c/0x5c
  [<ffffffff8108ddad>] handle_edge_irq+0xcc/0xf3
  [<ffffffff810032e7>] handle_irq+0x1f/0x28
  [<ffffffff81002a94>] do_IRQ+0x48/0xaf
  [<ffffffff81384fef>] ret_from_intr+0x0/0x13
  [<ffffffff81008aa9>] cpu_idle+0x6e/0xab
  [<ffffffff8137d16a>] start_secondary+0x1af/0x1b3

to a HARDIRQ-irq-unsafe lock:
 (&(&dev->sriov.id_map_lock)->rlock){+.+...}
... which became HARDIRQ-irq-unsafe at:
...  [<ffffffff81070f1f>] __lock_acquire+0x662/0x9ae
  [<ffffffff8107135b>] lock_acquire+0xf0/0x116
  [<ffffffff813844e5>] _raw_spin_lock+0x3b/0x4a
  [<ffffffffa03d55bd>] mlx4_ib_multiplex_cm_handler+0x128/0x2ff [mlx4_ib]
  [<ffffffffa03c900f>] mlx4_ib_multiplex_mad+0x1a4/0x2bd [mlx4_ib]
  [<ffffffffa03c9196>] mlx4_ib_tunnel_comp_worker+0x6e/0x140 [mlx4_ib]
  [<ffffffff8104604c>] process_one_work+0x2e1/0x498
  [<ffffffff8104669d>] worker_thread+0x225/0x35d
  [<ffffffff8104c887>] kthread+0xc2/0xca
  [<ffffffff8138b96c>] ret_from_fork+0x7c/0xb0

other info that might help us debug this:

 Possible interrupt unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&(&dev->sriov.id_map_lock)->rlock);
                               local_irq_disable();
                               lock(&(&dev->sriov.going_down_lock)->rlock);
                               lock(&(&dev->sriov.id_map_lock)->rlock);
  <Interrupt>
    lock(&(&dev->sriov.going_down_lock)->rlock);

 *** DEADLOCK ***

3 locks held by kworker/u:3/1547:
 #0:  ((name)#2){.+.+.+}, at: [<ffffffff81045fa3>] process_one_work+0x238/0x498
 #1:  ((&ctx->work)#2){+.+.+.}, at: [<ffffffff81045fa3>] process_one_work+0x238/0x498
 #2:  (&(&dev->sriov.going_down_lock)->rlock){-.-...}, at: [<ffffffffa03d537c>] schedule_delayed+0x2d/0x77 [mlx4_ib]

the dependencies between HARDIRQ-irq-safe lock and the holding lock:
-> (&(&dev->sriov.going_down_lock)->rlock){-.-...} ops: 1222 {
   IN-HARDIRQ-W at:
                    [<ffffffff81070ea6>] __lock_acquire+0x5e9/0x9ae
                    [<ffffffff8107135b>] lock_acquire+0xf0/0x116
                    [<ffffffff813845e8>] _raw_spin_lock_irqsave+0x46/0x58
                    [<ffffffffa03c8ad9>] mlx4_ib_tunnel_comp_handler+0x22/0x57 [mlx4_ib]
                    [<ffffffffa03c63ba>] mlx4_ib_cq_comp+0x12/0x14 [mlx4_ib]
                    [<ffffffffa03e9b22>] mlx4_cq_completion+0x5c/0x62 [mlx4_core]
                    [<ffffffffa03eb1fb>] mlx4_eq_int+0x89/0x865 [mlx4_core]
                    [<ffffffffa03eb9e6>] mlx4_msi_x_interrupt+0xf/0x16 [mlx4_core]
                    [<ffffffff8108b0d7>] handle_irq_event_percpu+0x93/0x1d7
                    [<ffffffff8108b257>] handle_irq_event+0x3c/0x5c
                    [<ffffffff8108ddad>] handle_edge_irq+0xcc/0xf3
                    [<ffffffff810032e7>] handle_irq+0x1f/0x28
                    [<ffffffff81002a94>] do_IRQ+0x48/0xaf
                    [<ffffffff81384fef>] ret_from_intr+0x0/0x13
                    [<ffffffff81008aa9>] cpu_idle+0x6e/0xab
                    [<ffffffff8137d16a>] start_secondary+0x1af/0x1b3
   IN-SOFTIRQ-W at:
                    [<ffffffff81070ec9>] __lock_acquire+0x60c/0x9ae
                    [<ffffffff8107135b>] lock_acquire+0xf0/0x116
                    [<ffffffff813845e8>] _raw_spin_lock_irqsave+0x46/0x58
                    [<ffffffffa03c8ad9>] mlx4_ib_tunnel_comp_handler+0x22/0x57 [mlx4_ib]
                    [<ffffffffa03c63ba>] mlx4_ib_cq_comp+0x12/0x14 [mlx4_ib]
                    [<ffffffffa03e9b22>] mlx4_cq_completion+0x5c/0x62 [mlx4_core]
                    [<ffffffffa03eb1fb>] mlx4_eq_int+0x89/0x865 [mlx4_core]
                    [<ffffffffa03eb9e6>] mlx4_msi_x_interrupt+0xf/0x16 [mlx4_core]
                    [<ffffffff8108b0d7>] handle_irq_event_percpu+0x93/0x1d7
                    [<ffffffff8108b257>] handle_irq_event+0x3c/0x5c
                    [<ffffffff8108ddad>] handle_edge_irq+0xcc/0xf3
                    [<ffffffff810032e7>] handle_irq+0x1f/0x28
                    [<ffffffff81002a94>] do_IRQ+0x48/0xaf
                    [<ffffffff81384fef>] ret_from_intr+0x0/0x13
                    [<ffffffff812cd807>] flush_unmaps_timeout+0x2c/0x31
                    [<ffffffff8103be30>] call_timer_fn+0xb2/0x178
                    [<ffffffff8103c0ed>] run_timer_softirq+0x1f7/0x24d
                    [<ffffffff81035d86>] __do_softirq+0x10c/0x1fe
                    [<ffffffff8138cbcc>] call_softirq+0x1c/0x30
                    [<ffffffff81003280>] do_softirq+0x38/0x80
                    [<ffffffff81035a3c>] irq_exit+0x4e/0x83
                    [<ffffffff8101e8d7>] smp_apic_timer_interrupt+0x86/0x94
                    [<ffffffff8138c52f>] apic_timer_interrupt+0x6f/0x80
                    [<ffffffff81008aa9>] cpu_idle+0x6e/0xab
                    [<ffffffff8137d16a>] start_secondary+0x1af/0x1b3
   INITIAL USE at:
                   [<ffffffff81070f9a>] __lock_acquire+0x6dd/0x9ae
                   [<ffffffff8107135b>] lock_acquire+0xf0/0x116
                   [<ffffffff813845e8>] _raw_spin_lock_irqsave+0x46/0x58
                   [<ffffffffa03caeb9>] do_slave_init+0x164/0x1be [mlx4_ib]
                   [<ffffffffa03cbd85>] mlx4_ib_add+0x966/0xa43 [mlx4_ib]
                   [<ffffffffa03eefed>] mlx4_add_device+0x47/0x9a [mlx4_core]
                   [<ffffffffa03ef127>] mlx4_register_interface+0x5a/0x93 [mlx4_core]
                   [<ffffffffa03df053>] 0xffffffffa03df053
                   [<ffffffff810001fa>] do_one_initcall+0x7a/0x12e
                   [<ffffffff8107beed>] sys_init_module+0x7a/0x1bd
                   [<ffffffff8138ba12>] system_call_fastpath+0x16/0x1b
 }
 ... key      at: [<ffffffffa03da250>] __key.29772+0x0/0xffffffffffffd7cf [mlx4_ib]
 ... acquired at:
   [<ffffffff8106f0f6>] check_irq_usage+0x5d/0xbe
   [<ffffffff8106fe59>] validate_chain+0x890/0xe5a
   [<ffffffff810711f7>] __lock_acquire+0x93a/0x9ae
   [<ffffffff8107135b>] lock_acquire+0xf0/0x116
   [<ffffffff813844e5>] _raw_spin_lock+0x3b/0x4a
   [<ffffffffa03d5387>] schedule_delayed+0x38/0x77 [mlx4_ib]
   [<ffffffffa03d576f>] mlx4_ib_multiplex_cm_handler+0x2da/0x2ff [mlx4_ib]
   [<ffffffffa03c900f>] mlx4_ib_multiplex_mad+0x1a4/0x2bd [mlx4_ib]
   [<ffffffffa03c9196>] mlx4_ib_tunnel_comp_worker+0x6e/0x140 [mlx4_ib]
   [<ffffffff8104604c>] process_one_work+0x2e1/0x498
   [<ffffffff8104669d>] worker_thread+0x225/0x35d
   [<ffffffff8104c887>] kthread+0xc2/0xca
   [<ffffffff8138b96c>] ret_from_fork+0x7c/0xb0


the dependencies between the lock to be acquired and HARDIRQ-irq-unsafe lock:
-> (&(&dev->sriov.id_map_lock)->rlock){+.+...} ops: 5 {
   HARDIRQ-ON-W at:
                    [<ffffffff81070f1f>] __lock_acquire+0x662/0x9ae
                    [<ffffffff8107135b>] lock_acquire+0xf0/0x116
                    [<ffffffff813844e5>] _raw_spin_lock+0x3b/0x4a
                    [<ffffffffa03d55bd>] mlx4_ib_multiplex_cm_handler+0x128/0x2ff [mlx4_ib]
                    [<ffffffffa03c900f>] mlx4_ib_multiplex_mad+0x1a4/0x2bd [mlx4_ib]
                    [<ffffffffa03c9196>] mlx4_ib_tunnel_comp_worker+0x6e/0x140 [mlx4_ib]
                    [<ffffffff8104604c>] process_one_work+0x2e1/0x498
                    [<ffffffff8104669d>] worker_thread+0x225/0x35d
                    [<ffffffff8104c887>] kthread+0xc2/0xca
                    [<ffffffff8138b96c>] ret_from_fork+0x7c/0xb0
   SOFTIRQ-ON-W at:
                    [<ffffffff81070f42>] __lock_acquire+0x685/0x9ae
                    [<ffffffff8107135b>] lock_acquire+0xf0/0x116
                    [<ffffffff813844e5>] _raw_spin_lock+0x3b/0x4a
                    [<ffffffffa03d55bd>] mlx4_ib_multiplex_cm_handler+0x128/0x2ff [mlx4_ib]
                    [<ffffffffa03c900f>] mlx4_ib_multiplex_mad+0x1a4/0x2bd [mlx4_ib]
                    [<ffffffffa03c9196>] mlx4_ib_tunnel_comp_worker+0x6e/0x140 [mlx4_ib]
                    [<ffffffff8104604c>] process_one_work+0x2e1/0x498
                    [<ffffffff8104669d>] worker_thread+0x225/0x35d
                    [<ffffffff8104c887>] kthread+0xc2/0xca
                    [<ffffffff8138b96c>] ret_from_fork+0x7c/0xb0
   INITIAL USE at:
                   [<ffffffff81070f9a>] __lock_acquire+0x6dd/0x9ae
                   [<ffffffff8107135b>] lock_acquire+0xf0/0x116
                   [<ffffffff813844e5>] _raw_spin_lock+0x3b/0x4a
                   [<ffffffffa03d55bd>] mlx4_ib_multiplex_cm_handler+0x128/0x2ff [mlx4_ib]
                   [<ffffffffa03c900f>] mlx4_ib_multiplex_mad+0x1a4/0x2bd [mlx4_ib]
                   [<ffffffffa03c9196>] mlx4_ib_tunnel_comp_worker+0x6e/0x140 [mlx4_ib]
                   [<ffffffff8104604c>] process_one_work+0x2e1/0x498
                   [<ffffffff8104669d>] worker_thread+0x225/0x35d
                   [<ffffffff8104c887>] kthread+0xc2/0xca
                   [<ffffffff8138b96c>] ret_from_fork+0x7c/0xb0
 }
 ... key      at: [<ffffffffa03da378>] __key.27645+0x0/0xffffffffffffd6a7 [mlx4_ib]
 ... acquired at:
   [<ffffffff8106f0f6>] check_irq_usage+0x5d/0xbe
   [<ffffffff8106fe59>] validate_chain+0x890/0xe5a
   [<ffffffff810711f7>] __lock_acquire+0x93a/0x9ae
   [<ffffffff8107135b>] lock_acquire+0xf0/0x116
   [<ffffffff813844e5>] _raw_spin_lock+0x3b/0x4a
   [<ffffffffa03d5387>] schedule_delayed+0x38/0x77 [mlx4_ib]
   [<ffffffffa03d576f>] mlx4_ib_multiplex_cm_handler+0x2da/0x2ff [mlx4_ib]
   [<ffffffffa03c900f>] mlx4_ib_multiplex_mad+0x1a4/0x2bd [mlx4_ib]
   [<ffffffffa03c9196>] mlx4_ib_tunnel_comp_worker+0x6e/0x140 [mlx4_ib]
   [<ffffffff8104604c>] process_one_work+0x2e1/0x498
   [<ffffffff8104669d>] worker_thread+0x225/0x35d
   [<ffffffff8104c887>] kthread+0xc2/0xca
   [<ffffffff8138b96c>] ret_from_fork+0x7c/0xb0


stack backtrace:
Pid: 1547, comm: kworker/u:3 Not tainted 3.7.0-rc6+ #68
Call Trace:
 [<ffffffff81030325>] ? console_unlock+0x358/0x37e
 [<ffffffff8106f085>] check_usage+0x525/0x539
 [<ffffffff8106f0f6>] check_irq_usage+0x5d/0xbe
 [<ffffffff8106fe59>] validate_chain+0x890/0xe5a
 [<ffffffff8106e463>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff810711f7>] __lock_acquire+0x93a/0x9ae
 [<ffffffff8107135b>] lock_acquire+0xf0/0x116
 [<ffffffffa03d5387>] ? schedule_delayed+0x38/0x77 [mlx4_ib]
 [<ffffffff813844e5>] _raw_spin_lock+0x3b/0x4a
 [<ffffffffa03d5387>] ? schedule_delayed+0x38/0x77 [mlx4_ib]
 [<ffffffffa03d5387>] schedule_delayed+0x38/0x77 [mlx4_ib]
 [<ffffffffa03d576f>] mlx4_ib_multiplex_cm_handler+0x2da/0x2ff [mlx4_ib]
 [<ffffffffa03c900f>] mlx4_ib_multiplex_mad+0x1a4/0x2bd [mlx4_ib]
 [<ffffffff8106e41f>] ? trace_hardirqs_on_caller+0x11e/0x155
 [<ffffffffa03c6c0e>] ? mlx4_ib_poll_cq+0x609/0x62d [mlx4_ib]
 [<ffffffffa03c9196>] mlx4_ib_tunnel_comp_worker+0x6e/0x140 [mlx4_ib]
 [<ffffffff8104604c>] process_one_work+0x2e1/0x498
 [<ffffffff81045fa3>] ? process_one_work+0x238/0x498
 [<ffffffff81384c23>] ? _raw_spin_unlock_irq+0x2b/0x40
 [<ffffffffa03c9128>] ? mlx4_ib_multiplex_mad+0x2bd/0x2bd [mlx4_ib]
 [<ffffffff8104669d>] worker_thread+0x225/0x35d
 [<ffffffff81046478>] ? manage_workers+0x275/0x275
 [<ffffffff8104c887>] kthread+0xc2/0xca
 [<ffffffff8104c7c5>] ? __init_kthread_worker+0x56/0x56
 [<ffffffff8138b96c>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104c7c5>] ? __init_kthread_worker+0x56/0x56
[sched_delayed] sched: RT throttling activated


(2) those that relate to patch #2

inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
swapper/7/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
 (&(&priv->mfunc.master.slave_state_lock)->rlock){?.+...}, at: [<ffffffffa042e786>] mlx4_eq_int+0x5e7/0x84b [mlx4_core]
{HARDIRQ-ON-W} state was registered at:
  [<ffffffff8107143f>] __lock_acquire+0x662/0x9ae
  [<ffffffff8107187b>] lock_acquire+0xf0/0x116
  [<ffffffff813848ad>] _raw_spin_lock+0x3b/0x4a
  [<ffffffffa042c1d4>] mlx4_master_comm_channel+0x3e3/0x4d5 [mlx4_core]
  [<ffffffff81045f9c>] process_one_work+0x2e1/0x498
  [<ffffffff810465ed>] worker_thread+0x225/0x35d
  [<ffffffff8104c7cb>] kthread+0xc2/0xca
  [<ffffffff8138bdec>] ret_from_fork+0x7c/0xb0
irq event stamp: 1140398
hardirqs last  enabled at (1140395): [<ffffffff810086db>] mwait_idle+0x133/0x208
hardirqs last disabled at (1140396): [<ffffffff813853aa>] common_interrupt+0x6a/0x6f
softirqs last  enabled at (1140398): [<ffffffff810359f7>] _local_bh_enable+0xe/0x10
softirqs last disabled at (1140397): [<ffffffff81035bc0>] irq_enter+0x44/0x76

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&(&priv->mfunc.master.slave_state_lock)->rlock);
  <Interrupt>
    lock(&(&priv->mfunc.master.slave_state_lock)->rlock);

 *** DEADLOCK ***

no locks held by swapper/7/0.

stack backtrace:
Pid: 0, comm: swapper/7 Not tainted 3.7.0-rc1+ #2
Call Trace:
 <IRQ>  [<ffffffff8103021a>] ? console_unlock+0x2d5/0x37e
 [<ffffffff8106e086>] print_usage_bug+0x297/0x2a8
 [<ffffffff8100cc92>] ? save_stack_trace+0x2a/0x47
 [<ffffffff8106eee8>] ? print_irq_inversion_bug+0x1d7/0x1d7
 [<ffffffff8106e38a>] mark_lock+0x2f3/0x52b
 [<ffffffff810713c6>] __lock_acquire+0x5e9/0x9ae
 [<ffffffff8107187b>] lock_acquire+0xf0/0x116
 [<ffffffffa042e786>] ? mlx4_eq_int+0x5e7/0x84b [mlx4_core]
 [<ffffffff813848ad>] _raw_spin_lock+0x3b/0x4a
 [<ffffffffa042e786>] ? mlx4_eq_int+0x5e7/0x84b [mlx4_core]
 [<ffffffff8106e925>] ? trace_hardirqs_on_caller+0x104/0x155
 [<ffffffffa042e786>] mlx4_eq_int+0x5e7/0x84b [mlx4_core]
 [<ffffffff8106e983>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffffa042e9f9>] mlx4_msi_x_interrupt+0xf/0x16 [mlx4_core]
 [<ffffffff8108b5f3>] handle_irq_event_percpu+0x93/0x1d7
 [<ffffffff8108b773>] handle_irq_event+0x3c/0x5c
 [<ffffffff8108e2c9>] handle_edge_irq+0xcc/0xf3
 [<ffffffff81003407>] handle_irq+0x1f/0x28
 [<ffffffff81002bb4>] do_IRQ+0x48/0xaf
 [<ffffffff813853af>] common_interrupt+0x6f/0x6f
 <EOI>  [<ffffffff810086e4>] ? mwait_idle+0x13c/0x208
 [<ffffffff810086db>] ? mwait_idle+0x133/0x208
 [<ffffffff81008bc9>] cpu_idle+0x6e/0xab
 [<ffffffff8137d512>] start_secondary+0x1af/0x1b3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
