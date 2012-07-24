From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: circular lockdep problem
Date: Tue, 24 Jul 2012 11:39:41 -0500
Message-ID: <500ECFCD.1040403@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Can anyone help me understand how I can resolve this? Its saying there 
is some circular dependency problem with the cxgb4 uld_mutex, the 
networking rtnl_mutex, and ib_core's device_mutex. I can't decipher the 
stuff below though. It only seems to happen when there is a cxgb4 and 
ipoib device present.

[ 3234.542038] ======================================================
[ 3234.542066] [ INFO: possible circular locking dependency detected ] [
3234.542095] 3.4.0+ #133 Not tainted [ 3234.542111]
-------------------------------------------------------
[ 3234.542139] modprobe/2291 is trying to acquire lock:
[ 3234.542162]  (device_mutex){+.+.+.}, at: [<ffffffffa009ec82>]
ib_register_device+0x42/0x4f0 [ib_core] [ 3234.542221] [ 3234.542222] but task
is already holding lock:
[ 3234.542249]  (uld_mutex){+.+.+.}, at: [<ffffffffa0050e4e>]
cxgb4_register_uld+0x3e/0xe0 [cxgb4] [ 3234.542305] [ 3234.542305] which lock
already depends on the new lock.
[ 3234.542306]
[ 3234.542342]
[ 3234.542343] the existing dependency chain (in reverse order) is:
[ 3234.542376]
[ 3234.542377] -> #2 (uld_mutex){+.+.+.}:
[ 3234.542413]        [<ffffffff810b4061>] lock_acquire+0xb1/0x1a0
[ 3234.542446]        [<ffffffff81630e7d>] __mutex_lock_common+0x5d/0x430
[ 3234.542480]        [<ffffffff81631385>] mutex_lock_nested+0x45/0x50
[ 3234.542510]        [<ffffffffa004f11a>] notify_ulds+0x2a/0x70 [cxgb4]
[ 3234.542543]        [<ffffffffa005220e>] cxgb_up+0x5ae/0xae0 [cxgb4]
[ 3234.542576]        [<ffffffffa005293b>] cxgb_open+0x2b/0x80 [cxgb4]
[ 3234.542608]        [<ffffffff814fe4e7>] __dev_open+0xb7/0x100
[ 3234.542639]        [<ffffffff814fcea1>] __dev_change_flags+0xa1/0x180
[ 3234.542669]        [<ffffffff814fe3e8>] dev_change_flags+0x28/0x70
[ 3234.542699]        [<ffffffff81512252>] do_setlink+0x1c2/0x9f0
[ 3234.542729]        [<ffffffff81514558>] rtnl_newlink+0x3d8/0x600
[ 3234.542758]        [<ffffffff81511e67>] rtnetlink_rcv_msg+0x2d7/0x340
[ 3234.542789]        [<ffffffff8152e289>] netlink_rcv_skb+0xa9/0xd0
[ 3234.542820]        [<ffffffff81511b75>] rtnetlink_rcv+0x25/0x40
[ 3234.542849]        [<ffffffff8152dfa9>] netlink_unicast+0x1a9/0x1f0
[ 3234.542879]        [<ffffffff8152ed4c>] netlink_sendmsg+0x20c/0x310
[ 3234.542909]        [<ffffffff814e7368>] sock_sendmsg+0xf8/0x130
[ 3234.542939]        [<ffffffff814e8c6a>] __sys_sendmsg+0x41a/0x440
[ 3234.542968]        [<ffffffff814e8e99>] sys_sendmsg+0x49/0x80
[ 3234.542996]        [<ffffffff8163d7a9>] system_call_fastpath+0x16/0x1b
[ 3234.543029]
[ 3234.543029] -> #1 (rtnl_mutex){+.+.+.}:
[ 3234.543066]        [<ffffffff810b4061>] lock_acquire+0xb1/0x1a0
[ 3234.543094]        [<ffffffff81630e7d>] __mutex_lock_common+0x5d/0x430
[ 3234.543125]        [<ffffffff81631385>] mutex_lock_nested+0x45/0x50
[ 3234.543155]        [<ffffffff81511b47>] rtnl_lock+0x17/0x20
[ 3234.543183]        [<ffffffff814ff396>] register_netdev+0x16/0x30
[ 3234.543212]        [<ffffffffa01c00cb>] ipoib_add_one+0x2fb/0x460 [ib_ipoib]
[ 3234.544075]        [<ffffffffa009eaa5>] ib_register_client+0x95/0xc0
[ib_core]
[ 3234.544942]        [<ffffffffa00450f3>] stp_proto_register+0x33/0xc0 [stp]
[ 3234.545810]        [<ffffffff81002042>] do_one_initcall+0x42/0x180
[ 3234.546685]        [<ffffffff810c2c20>] sys_init_module+0x90/0x1f0
[ 3234.547562]        [<ffffffff8163d7a9>] system_call_fastpath+0x16/0x1b
[ 3234.548435]
[ 3234.548435] -> #0 (device_mutex){+.+.+.}:
[ 3234.550141]        [<ffffffff810b3b7c>] __lock_acquire+0x12cc/0x1700
[ 3234.551004]        [<ffffffff810b4061>] lock_acquire+0xb1/0x1a0
[ 3234.551848]        [<ffffffff81630e7d>] __mutex_lock_common+0x5d/0x430
[ 3234.552680]        [<ffffffff81631385>] mutex_lock_nested+0x45/0x50
[ 3234.553508]        [<ffffffffa009ec82>] ib_register_device+0x42/0x4f0
[ib_core]
[ 3234.554332]        [<ffffffffa016fe5d>] c4iw_register_device+0x36d/0x410
[iw_cxgb4]
[ 3234.555152]        [<ffffffffa0168ad4>] c4iw_uld_state_change+0x2f4/0x890
[iw_cxgb4]
[ 3234.555965]        [<ffffffffa0050d8a>] uld_attach+0x15a/0x1e0 [cxgb4]
[ 3234.556770]        [<ffffffffa0050ed2>] cxgb4_register_uld+0xc2/0xe0 [cxgb4]
[ 3234.557590]        [<ffffffffa01b3048>] c4iw_init_module+0x48/0x4e
[iw_cxgb4]
[ 3234.558399]        [<ffffffff81002042>] do_one_initcall+0x42/0x180
[ 3234.559198]        [<ffffffff810c2c20>] sys_init_module+0x90/0x1f0
[ 3234.560008]        [<ffffffff8163d7a9>] system_call_fastpath+0x16/0x1b
[ 3234.560813]
[ 3234.560813] other info that might help us debug this:
[ 3234.560814]
[ 3234.563195] Chain exists of:
[ 3234.563196]   device_mutex --> rtnl_mutex --> uld_mutex
[ 3234.564034]
[ 3234.565637]  Possible unsafe locking scenario:
[ 3234.565638]
[ 3234.567278]        CPU0                    CPU1
[ 3234.568099]        ----                    ----
[ 3234.568916]   lock(uld_mutex);
[ 3234.569734]                                lock(rtnl_mutex);
[ 3234.570562]                                lock(uld_mutex);
[ 3234.571381]   lock(device_mutex);
[ 3234.572190]
[ 3234.572190]  *** DEADLOCK ***
[ 3234.572191]
[ 3234.574562] 1 lock held by modprobe/2291:
[ 3234.575360]  #0:  (uld_mutex){+.+.+.}, at: [<ffffffffa0050e4e>]
cxgb4_register_uld+0x3e/0xe0 [cxgb4] [ 3234.576210] [ 3234.576211] stack
backtrace:
[ 3234.577846] Pid: 2291, comm: modprobe Not tainted 3.4.0+ #133 [ 3234.578677]
Call Trace:
[ 3234.579507]  [<ffffffff810b0d02>] print_circular_bug+0x212/0x2f0 [
3234.580356]  [<ffffffff810b3b7c>] __lock_acquire+0x12cc/0x1700 [ 3234.581206]
[<ffffffff8101e343>] ? native_sched_clock+0x13/0x80 [ 3234.582058]
[<ffffffff810b4061>] lock_acquire+0xb1/0x1a0 [ 3234.582910]
[<ffffffffa009ec82>] ? ib_register_device+0x42/0x4f0 [ib_core] [ 3234.583763]
[<ffffffff810b2c28>] ? __lock_acquire+0x378/0x1700 [ 3234.584619]
[<ffffffff81630e7d>] __mutex_lock_common+0x5d/0x430 [ 3234.585474]
[<ffffffffa009ec82>] ? ib_register_device+0x42/0x4f0 [ib_core] [ 3234.586324]
[<ffffffff8101e343>] ? native_sched_clock+0x13/0x80 [ 3234.587179]
[<ffffffff8101d8c9>] ? sched_clock+0x9/0x10 [ 3234.588031]
[<ffffffffa009ec82>] ? ib_register_device+0x42/0x4f0 [ib_core] [ 3234.588895]
[<ffffffff81631385>] mutex_lock_nested+0x45/0x50 [ 3234.589753]
[<ffffffffa009ec82>] ib_register_device+0x42/0x4f0 [ib_core] [ 3234.590618]
[<ffffffff81128a29>] ? __probe_kernel_read+0x49/0x80 [ 3234.591485]
[<ffffffff81174e03>] ? kmem_cache_alloc_trace+0x113/0x1f0
[ 3234.592361]  [<ffffffffa016fdcb>] ? c4iw_register_device+0x2db/0x410
[iw_cxgb4] [ 3234.593242]  [<ffffffffa016fe5d>]
c4iw_register_device+0x36d/0x410 [iw_cxgb4] [ 3234.594122]
[<ffffffffa0168ad4>] c4iw_uld_state_change+0x2f4/0x890 [iw_cxgb4] [
3234.595003]  [<ffffffff81634970>] ? _raw_spin_unlock_irqrestore+0x40/0x80
[ 3234.595880]  [<ffffffff810b25bd>] ? trace_hardirqs_on+0xd/0x10 [
3234.596755]  [<ffffffffa0050d8a>] uld_attach+0x15a/0x1e0 [cxgb4] [
3234.597634]  [<ffffffffa01b3000>] ? 0xffffffffa01b2fff [ 3234.598504]
[<ffffffffa0050ed2>] cxgb4_register_uld+0xc2/0xe0 [cxgb4] [ 3234.599368]
[<ffffffffa01b3048>] c4iw_init_module+0x48/0x4e [iw_cxgb4] [ 3234.600234]
[<ffffffff81002042>] do_one_initcall+0x42/0x180 [ 3234.601104]
[<ffffffff810c2c20>] sys_init_module+0x90/0x1f0 [ 3234.601970]
[<ffffffff8163d7a9>] system_call_fastpath+0x16/0x1b

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
