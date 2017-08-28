From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Bug Report: possible circular locking issue
Date: Mon, 28 Aug 2017 15:12:09 -0400
Message-ID: <1503947529.78641.108.camel@redhat.com>
References: <1503938316.78641.98.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1503938316.78641.98.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Wise, Steve" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-08-28 at 12:38 -0400, Doug Ledford wrote:
> Resend from my work email address:
> 
> 
> I ran across this while testing a 4.13-rc7 kernel + the rdma next
> code.

This reproduces on a stock 4.13-rc7 kernel.  But, across all the stuff
I've booted it on so far, it only shows up on cxgb4 devices, so I think
this is a cxgb4 specific issue.  Steve, can you look into this? 

My basic config is a stock Fedora rawhide box and I took the Fedora
kernel config and copied it into my git repo checkout of v4.13-rc7 and
compiled using that config.  If you need any more info, I can try to
get it to you.

The machine environment that produces this includes:

base Ethernet device + 2 vlan devices
srp target mode is in use (kernel LIO support), the iwarp device isn't
specifically configured for use, but srpt tries to set it up anyway
iser target mode is in use (kernel LIO support again, single tpg with
wildcard address so the iwarp devices are in use)
nfsordma in use and exporting several mount points, again with wildcard
address so all RDMA devices are candidates

With this environment, I get the trackback on bootup every time.  It
then proceeds to run.  I haven't tested it under load to see how it
does, but it's up anyway.

>  I don't have the time to track this down before going on PTO, so I'm
> putting it out here for others to look at.
> 
> This machine holds multiple connections in it:
> 
> ib0/ib1 -> dual port qib
> roce -> ocrdma
> iwarp -> cxgb4
> 
> During bootup I got this:
> 
> [   37.244753] iw_cxgb4: 0000:83:00.4: Up
> [   37.250168] iw_cxgb4: 0000:83:00.4: On-Chip Queues not supported
> on
> this deve
> 
> [   37.263207] ======================================================
> [   37.270656] WARNING: possible circular locking dependency detected
> [   37.278101] 4.13.0-rc7+ #130 Not tainted
> [   37.283019] ------------------------------------------------------
> [   37.290470] NetworkManager/2196 is trying to acquire lock:
> [   37.297143]  (device_mutex){+.+.+.}, at: [<ffffffffc08d2465>]
> ib_register_de]
> [   37.308026] 
>                but task is already holding lock:
> [   37.315694]  (uld_mutex){+.+.+.}, at: [<ffffffffc0574fd4>]
> notify_ulds.isra.]
> [   37.326108] 
>                which lock already depends on the new lock.
> 
> [   37.337689] 
>                the existing dependency chain (in reverse order) is:
> [   37.347301] 
>                -> #2 (uld_mutex){+.+.+.}:
> [   37.354048]        lock_acquire+0xbd/0x200
> [   37.359083]        __mutex_lock+0x88/0x950
> [   37.364122]        mutex_lock_nested+0x1b/0x20
> [   37.369690]        cxgb_up+0x27/0x840 [cxgb4]
> [   37.375623]        cxgb_open+0x34/0x90 [cxgb4]
> [   37.381168]        __dev_open+0xc9/0x140
> [   37.386039]        __dev_change_flags+0x9d/0x160
> [   37.391686]        dev_change_flags+0x29/0x60
> [   37.397069]        do_setlink+0x4bf/0xc80
> [   37.402024]        rtnl_newlink+0x512/0x8a0
> [   37.407177]        rtnetlink_rcv_msg+0xac/0x240
> [   37.412702]        netlink_rcv_skb+0xed/0x120
> [   37.418023]        rtnetlink_rcv+0x2a/0x40
> [   37.423060]        netlink_unicast+0x182/0x220
> [   37.428482]        netlink_sendmsg+0x2e9/0x3e0
> [   37.433868]        sock_sendmsg+0x38/0x50
> [   37.438766]        ___sys_sendmsg+0x2b2/0x2d0
> [   37.444052]        __sys_sendmsg+0x54/0x90
> [   37.449047]        SyS_sendmsg+0x12/0x20
> [   37.453848]        entry_SYSCALL_64_fastpath+0x1f/0xbe
> [   37.460007] 
>                -> #1 (rtnl_mutex){+.+.+.}:
> [   37.466764]        lock_acquire+0xbd/0x200
> [   37.471745]        __mutex_lock+0x88/0x950
> [   37.476853]        mutex_lock_nested+0x1b/0x20
> [   37.482336]        rtnl_lock+0x17/0x20
> [   37.487038]        enum_all_gids_of_dev_cb+0x25/0xd0 [ib_core]
> [   37.494509]        ib_enum_roce_netdev+0xe7/0x100 [ib_core]
> [   37.501256]        roce_rescan_device+0x21/0x30 [ib_core]
> [   37.507680]        ib_cache_setup_one+0x1f1/0x350 [ib_core]
> [   37.514297]        ib_register_device+0x444/0x720 [ib_core]
> [   37.520900]        ocrdma_add+0x46f/0x820 [ocrdma]
> [   37.526622]        _be_roce_dev_add+0x17d/0x1e0 [be2net]
> [   37.532929]        be_roce_register_driver+0x4a/0x90 [be2net]
> [   37.539716]        ib_umad_poll+0x15/0x50 [ib_umad]
> [   37.545527]        do_one_initcall+0x51/0x1a9
> [   37.550881]        do_init_module+0x60/0x1ff
> [   37.556129]        load_module+0x257e/0x2b10
> [   37.561375]        SYSC_finit_module+0xa9/0x100
> [   37.566880]        SyS_finit_module+0xe/0x10
> [   37.572099]        do_syscall_64+0x6c/0x1d0
> [   37.577178]        return_from_SYSCALL_64+0x0/0x7a
> [   37.583232] 
>                -> #0 (device_mutex){+.+.+.}:
> [   37.590704]        __lock_acquire+0x153c/0x1550
> [   37.596442]        lock_acquire+0xbd/0x200
> [   37.601399]        __mutex_lock+0x88/0x950
> [   37.606346]        mutex_lock_nested+0x1b/0x20
> [   37.611669]        ib_register_device+0xb5/0x720 [ib_core]
> [   37.618170]        c4iw_register_device+0x3a0/0x460 [iw_cxgb4]
> [   37.625061]        c4iw_uld_state_change+0x7a4/0xcd0 [iw_cxgb4]
> [   37.632108]        notify_ulds.isra.28+0x3f/0x60 [cxgb4]
> [   37.638410]        cxgb_up+0x70b/0x840 [cxgb4]
> [   37.643946]        cxgb_open+0x34/0x90 [cxgb4]
> [   37.649265]        __dev_open+0xc9/0x140
> [   37.653977]        __dev_change_flags+0x9d/0x160
> [   37.659613]        dev_change_flags+0x29/0x60
> [   37.665046]        do_setlink+0x4bf/0xc80
> [   37.669851]        rtnl_newlink+0x512/0x8a0
> [   37.675090]        rtnetlink_rcv_msg+0xac/0x240
> [   37.680717]        netlink_rcv_skb+0xed/0x120
> [   37.685937]        rtnetlink_rcv+0x2a/0x40
> [   37.691081]        netlink_unicast+0x182/0x220
> [   37.696607]        netlink_sendmsg+0x2e9/0x3e0
> [   37.702136]        sock_sendmsg+0x38/0x50
> [   37.707180]        ___sys_sendmsg+0x2b2/0x2d0
> [   37.712639]        __sys_sendmsg+0x54/0x90
> [   37.717542]        SyS_sendmsg+0x12/0x20
> [   37.722249]        entry_SYSCALL_64_fastpath+0x1f/0xbe
> [   37.728326] 
>                other info that might help us debug this:
> 
> [   37.738479] Chain exists of:
>                  device_mutex --> rtnl_mutex --> uld_mutex
> 
> [   37.750153]  Possible unsafe locking scenario:
> 
> [   37.757412]        CPU0                    CPU1
> [   37.762894]        ----                    ----
> [   37.768381]   lock(uld_mutex);
> [   37.772149]                                lock(rtnl_mutex);
> [   37.778830]                                lock(uld_mutex);
> [   37.785413]   lock(device_mutex);
> [   37.789462] 
>                 *** DEADLOCK ***
> 
> [   37.797070] 2 locks held by NetworkManager/2196:
> [   37.802557]  #0:  (rtnl_mutex){+.+.+.}, at: [<ffffffff9e83457b>]
> rtnetlink_r0
> [   37.812213]  #1:  (uld_mutex){+.+.+.}, at: [<ffffffffc0574fd4>]
> notify_ulds.]
> [   37.822846] 
>                stack backtrace:
> [   37.828894] CPU: 17 PID: 2196 Comm: NetworkManager Not tainted
> 4.13.0-rc7+ #0
> [   37.837655] Hardware name: Dell Inc. PowerEdge R730xd/0599V5, BIOS
> 2.0.2 03/6
> [   37.846551] Call Trace:
> [   37.849630]  dump_stack+0x85/0xcc
> [   37.853679]  print_circular_bug+0x200/0x20e
> [   37.858806]  __lock_acquire+0x153c/0x1550
> [   37.863738]  lock_acquire+0xbd/0x200
> [   37.868138]  ? ib_register_device+0xb5/0x720 [ib_core]
> [   37.874275]  ? ib_register_device+0xb5/0x720 [ib_core]
> [   37.880403]  __mutex_lock+0x88/0x950
> [   37.884782]  ? ib_register_device+0xb5/0x720 [ib_core]
> [   37.890914]  ? ib_register_device+0xb5/0x720 [ib_core]
> [   37.897108]  ? find_held_lock+0x40/0xb0
> [   37.901838]  mutex_lock_nested+0x1b/0x20
> [   37.906669]  ib_register_device+0xb5/0x720 [ib_core]
> [   37.912669]  ? c4iw_register_device+0x2f6/0x460 [iw_cxgb4]
> [   37.919261]  ? rcu_read_lock_sched_held+0x98/0xa0
> [   37.924973]  ? kmem_cache_alloc_trace+0x278/0x2e0
> [   37.930691]  ? c4iw_register_device+0x2f6/0x460 [iw_cxgb4]
> [   37.937293]  c4iw_register_device+0x3a0/0x460 [iw_cxgb4]
> [   37.943702]  c4iw_uld_state_change+0x7a4/0xcd0 [iw_cxgb4]
> [   37.950213]  ? notify_ulds.isra.28+0x24/0x60 [cxgb4]
> [   37.956244]  notify_ulds.isra.28+0x3f/0x60 [cxgb4]
> [   37.962083]  cxgb_up+0x70b/0x840 [cxgb4]
> [   37.966951]  ? cxgb4_ofld_send+0x20/0x20 [cxgb4]
> [   37.972594]  cxgb_open+0x34/0x90 [cxgb4]
> [   37.977462]  __dev_open+0xc9/0x140
> [   37.981741]  __dev_change_flags+0x9d/0x160
> [   37.986794]  dev_change_flags+0x29/0x60
> [   37.991557]  do_setlink+0x4bf/0xc80
> [   37.995931]  rtnl_newlink+0x512/0x8a0
> [   38.000500]  ? rtnl_newlink+0x104/0x8a0
> [   38.005263]  ? check_usage+0xb5/0x490
> [   38.009826]  ? ns_capable_common+0x7a/0x90
> [   38.014876]  ? ns_capable+0x13/0x20
> [   38.019253]  rtnetlink_rcv_msg+0xac/0x240
> [   38.024215]  ? rtnetlink_rcv+0x1b/0x40
> [   38.028879]  ? netlink_deliver_tap+0x7a/0x2c0
> [   38.034232]  ? rtnl_newlink+0x8a0/0x8a0
> [   38.038995]  netlink_rcv_skb+0xed/0x120
> [   38.043760]  rtnetlink_rcv+0x2a/0x40
> [   38.048244]  netlink_unicast+0x182/0x220
> [   38.053119]  netlink_sendmsg+0x2e9/0x3e0
> [   38.057985]  sock_sendmsg+0x38/0x50
> [   38.062243]  ___sys_sendmsg+0x2b2/0x2d0
> [   38.066877]  ? find_held_lock+0x40/0xb0
> [   38.071499]  ? __fget+0x102/0x210
> [   38.075647]  ? __fget+0x121/0x210
> [   38.079780]  ? __fget+0x5/0x210
> [   38.083706]  ? __fget_light+0x25/0x70
> [   38.088208]  __sys_sendmsg+0x54/0x90
> [   38.092606]  SyS_sendmsg+0x12/0x20
> [   38.096810]  entry_SYSCALL_64_fastpath+0x1f/0xbe
> [   38.102379] RIP: 0033:0x7f146e486974
> [   38.106778] RSP: 002b:00007ffd0cd3ee00 EFLAGS: 00000293 ORIG_RAX:
> 0000000000e
> [   38.115654] RAX: ffffffffffffffda RBX: 000055698f9641f9 RCX:
> 00007f146e486974
> [   38.124058] RDX: 0000000000000000 RSI: 00007ffd0cd3ee50 RDI:
> 0000000000000007
> [   38.132474] RBP: 00007ffd0cd3f2e0 R08: 0000000000000000 R09:
> 000055699118c300
> [   38.140884] R10: 0000000000000001 R11: 0000000000000293 R12:
> 0000000000000001
> [   38.149306] R13: 0000000000000001 R14: 00007ffd0cd3f010 R15:
> 000055698fbda5c0
> [   38.160359] ib_srpt srpt_add_one(cxgb4_0) failed.
> 
-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
