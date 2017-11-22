From: Honggang LI <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [Regression bug] Can't control IPoIB VLAN interfaces if selinux
 enabled
Date: Wed, 22 Nov 2017 20:03:36 +0800
Message-ID: <20171122120336.GA11241@dhcp-13-42.nay.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ReaqsoxgOBHFXBhH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi, Daniel

409dcf31538a selinux: Add a cache for quicker retreival of PKey SIDs
ab861dfca165 selinux: Add IB Port SMP access vector
cfc4d882d417 selinux: Implement Infiniband PKey "Access" access vector
3a976fa6767f selinux: Allocate and free infiniband security hooks
a806f7a1616f selinux: Create policydb version for Infiniband support
47a2b338fe63 IB/core: Enforce security on management datagrams
8f408ab64be6 selinux lsm IB/core: Implement LSM notification system
d291f1a65232 IB/core: Enforce PKey security on QPs
883c71feaf2e IB/core: IB cache enhancements to support Infiniband security

I think your patchset introduces a regression bug. If we created
multiple IPoIB VLAN interfaces, the TCP/IP network will be impacted.

1) Upstream kernel-4.12.0-rc2.409dcf31538a, can't control IPoIB VLAN
interface over ifdown/ifup. ifup/ifdown over bare IPoIB interface works.
System Ethernet card can get DHCP IP address and up as expected.

2) Upstream kernel-4.14.0.0c86a6bd85ff, the TCP/IP network does not
work at all, as all IP interfaces, which include Ethernet interface and
IPoIB/VLAN interfaces, will failed to be initialized.

Issue can be reproduced with mlx4/mlx5/qib hardware. IPoIB works
when selinux disabled.

Please see attachment for details.

thanks


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="4.12.0-rc2.409dcf31538a.txt"

[root@rdma-qe-09 ~]$ dmesg -c
[root@rdma-qe-09 ~]$ ip addr show | grep -w inet
    inet 127.0.0.1/8 scope host lo
    inet 10.16.41.238/21 brd 10.16.47.255 scope global noprefixroute dynamic lom_1
    inet 172.31.0.9/24 brd 172.31.0.255 scope global noprefixroute qib_ib0
    inet 172.31.1.9/24 brd 172.31.1.255 scope global noprefixroute qib_ib1
    inet 172.31.6.9/24 brd 172.31.6.255 scope global noprefixroute qib_ib0.8006
    inet 172.31.4.9/24 brd 172.31.4.255 scope global noprefixroute qib_ib0.8004
    inet 172.31.2.9/24 brd 172.31.2.255 scope global noprefixroute qib_ib0.8002
    inet 172.31.3.9/24 brd 172.31.3.255 scope global noprefixroute qib_ib1.8003
    inet 172.31.5.9/24 brd 172.31.5.255 scope global noprefixroute qib_ib1.8005
    inet 172.31.7.9/24 brd 172.31.7.255 scope global noprefixroute qib_ib1.8007
[root@rdma-qe-09 ~]$ 
[root@rdma-qe-09 ~]$ ifdown qib_ib0
Device 'qib_ib0' successfully disconnected.
[root@rdma-qe-09 ~]$ 
[root@rdma-qe-09 ~]$ ip addr show | grep -w inet
    inet 127.0.0.1/8 scope host lo
    inet 10.16.41.238/21 brd 10.16.47.255 scope global noprefixroute dynamic lom_1
    inet 172.31.1.9/24 brd 172.31.1.255 scope global noprefixroute qib_ib1
    inet 172.31.6.9/24 brd 172.31.6.255 scope global noprefixroute qib_ib0.8006
    inet 172.31.4.9/24 brd 172.31.4.255 scope global noprefixroute qib_ib0.8004
    inet 172.31.2.9/24 brd 172.31.2.255 scope global noprefixroute qib_ib0.8002
    inet 172.31.3.9/24 brd 172.31.3.255 scope global noprefixroute qib_ib1.8003
    inet 172.31.5.9/24 brd 172.31.5.255 scope global noprefixroute qib_ib1.8005
    inet 172.31.7.9/24 brd 172.31.7.255 scope global noprefixroute qib_ib1.8007
[root@rdma-qe-09 ~]$ ifup qib_ib0
Connection successfully activated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/10)
[root@rdma-qe-09 ~]$ 
[root@rdma-qe-09 ~]$ ip addr show | grep -w inet
    inet 127.0.0.1/8 scope host lo
    inet 10.16.41.238/21 brd 10.16.47.255 scope global noprefixroute dynamic lom_1
    inet 172.31.0.9/24 brd 172.31.0.255 scope global noprefixroute qib_ib0
    inet 172.31.1.9/24 brd 172.31.1.255 scope global noprefixroute qib_ib1
    inet 172.31.6.9/24 brd 172.31.6.255 scope global noprefixroute qib_ib0.8006
    inet 172.31.4.9/24 brd 172.31.4.255 scope global noprefixroute qib_ib0.8004
    inet 172.31.2.9/24 brd 172.31.2.255 scope global noprefixroute qib_ib0.8002
    inet 172.31.3.9/24 brd 172.31.3.255 scope global noprefixroute qib_ib1.8003
    inet 172.31.5.9/24 brd 172.31.5.255 scope global noprefixroute qib_ib1.8005
    inet 172.31.7.9/24 brd 172.31.7.255 scope global noprefixroute qib_ib1.8007
[root@rdma-qe-09 ~]$ 
[root@rdma-qe-09 ~]$ 
[root@rdma-qe-09 ~]$ ifdown qib_ib0.8002
Device 'qib_ib0.8002' successfully disconnected.
[root@rdma-qe-09 ~]$ 
[root@rdma-qe-09 ~]$ 
[root@rdma-qe-09 ~]$ ip addr show | grep -w inet
    inet 127.0.0.1/8 scope host lo
    inet 10.16.41.238/21 brd 10.16.47.255 scope global noprefixroute dynamic lom_1
    inet 172.31.0.9/24 brd 172.31.0.255 scope global noprefixroute qib_ib0
    inet 172.31.1.9/24 brd 172.31.1.255 scope global noprefixroute qib_ib1
    inet 172.31.6.9/24 brd 172.31.6.255 scope global noprefixroute qib_ib0.8006
    inet 172.31.4.9/24 brd 172.31.4.255 scope global noprefixroute qib_ib0.8004
    inet 172.31.3.9/24 brd 172.31.3.255 scope global noprefixroute qib_ib1.8003
    inet 172.31.5.9/24 brd 172.31.5.255 scope global noprefixroute qib_ib1.8005
    inet 172.31.7.9/24 brd 172.31.7.255 scope global noprefixroute qib_ib1.8007
[root@rdma-qe-09 ~]$ 
[root@rdma-qe-09 ~]$ 
[root@rdma-qe-09 ~]$ ifup qib_ib0.8002
Error: Connection activation failed: The device could not be readied for configuration
[root@rdma-qe-09 ~]$ 
[root@rdma-qe-09 ~]$ 
[root@rdma-qe-09 ~]$ dmesg -c
[  120.046113] qib_ib0.8006: Failed to modify QP to ERROR state
[  120.076029] qib_ib0.8004: Failed to modify QP to ERROR state
[  120.104711] qib_ib0.8002: Failed to modify QP to ERROR state
[  120.133117] qib_ib0.8006: failed to modify QP to init, ret = -13
[  120.160515] qib_ib0.8006: ipoib_init_qp returned -13
[  120.183154] qib_ib0.8006: Failed to open dev
[  120.202630] qib_ib0.8006: Failed to modify QP to ERROR state
[  120.229387] qib_ib0.8004: failed to modify QP to init, ret = -13
[  120.256439] qib_ib0.8004: ipoib_init_qp returned -13
[  120.279163] qib_ib0.8004: Failed to open dev
[  120.298720] qib_ib0.8004: Failed to modify QP to ERROR state
[  120.324469] qib_ib0.8002: failed to modify QP to init, ret = -13
[  120.352467] qib_ib0.8002: ipoib_init_qp returned -13
[  120.375207] qib_ib0.8002: Failed to open dev
[  120.394731] qib_ib0.8002: Failed to modify QP to ERROR state
[  120.420627] IPv6: ADDRCONF(NETDEV_UP): qib_ib0: link is not ready
[  120.450979] IPv6: ADDRCONF(NETDEV_UP): qib_ib0: link is not ready
[  120.485108] IPv6: ADDRCONF(NETDEV_CHANGE): qib_ib0: link becomes ready
[  135.550742] IPv6: ADDRCONF(NETDEV_UP): qib_ib0.8002: link is not ready
[  150.212302] qib_ib0.8002: enabling connected mode will cause multicast packet drops
[  150.249809] qib_ib0.8002: mtu > 4092 will cause multicast packet drops.
[  150.283008] qib_ib0.8002: failed to modify QP to init, ret = -13
[  150.314293] qib_ib0.8002: ipoib_init_qp returned -13
[  150.336951] qib_ib0.8002: Failed to open dev
[  150.356507] qib_ib0.8002: Failed to modify QP to ERROR state
[  150.383410] qib_ib0.8002: failed to modify QP to init, ret = -13
[  150.410823] qib_ib0.8002: ipoib_init_qp returned -13
[  150.434050] qib_ib0.8002: Failed to open dev
[  150.453570] qib_ib0.8002: Failed to modify QP to ERROR state
[  150.480359] IPv6: ADDRCONF(NETDEV_UP): qib_ib0.8002: link is not ready
[root@rdma-qe-09 ~]$ 
[root@rdma-qe-09 ~]$ 
[root@rdma-qe-09 ~]$  
[root@rdma-qe-09 ~]$ uname -r
4.12.0-rc2.409dcf31538a


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="4.14.0.0c86a6bd85ff.txt"

] Started Update is Completed.  
[   27.449680] IPv6: ADDRCONF(NETDEV_UP): lom_1: link is not ready 
[   27.631512] IPv6: ADDRCONF(NETDEV_UP): lom_1: link is not ready 
[   27.664541] IPv6: ADDRCONF(NETDEV_UP): lom_2: link is not ready 
[   27.848538] IPv6: ADDRCONF(NETDEV_UP): lom_2: link is not ready 
[   27.881879] IPv6: ADDRCONF(NETDEV_UP): mlx5_ib0: link is not ready 
[   27.914131] IPv6: ADDRCONF(NETDEV_UP): mlx5_ib0: link is not ready 
[   27.993179] IPv6: ADDRCONF(NETDEV_UP): mlx5_ib1: link is not ready 
[   28.023180] IPv6: ADDRCONF(NETDEV_CHANGE): mlx5_ib0: link becomes ready 
[   28.054841] IPv6: ADDRCONF(NETDEV_UP): mlx5_ib1: link is not ready 
[   28.109191] IPv6: ADDRCONF(NETDEV_CHANGE): mlx5_ib1: link becomes ready 
[   28.140838] IPv6: ADDRCONF(NETDEV_UP): mlx5_ib0.8002: link is not ready 
[   28.175130] mlx5_ib0.8002: failed to modify QP to init, ret = -13 
[   28.175131] mlx5_ib0.8002: ipoib_init_qp returned -13 
[   28.175132] mlx5_ib0.8002: Failed to open dev 
[   31.188121] tg3 0000:03:00.0 lom_1: Link is up at 1000 Mbps, full duplex 
[   31.218676] tg3 0000:03:00.0 lom_1: Flow control is off for TX and off for RX 
[   31.251212] tg3 0000:03:00.0 lom_1: EEE is disabled 
  
Red Hat Enterprise Linux Server 7.5 Beta (Maipo) 
Kernel 4.14.0.0c86a6bd85ff on an x86_64 
 
localhost login: [  246.751019] INFO: task kworker/4:2:363 blocked for more than 120 seconds. 
[  246.785085]       Not tainted 4.14.0.0c86a6bd85ff #1 
[  246.809832] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
[  246.845726] kworker/4:2     D    0   363      2 0x80000000 
[  246.872758] Workqueue: events linkwatch_event 
[  246.892463] Call Trace: 
[  246.903423]  ? __schedule+0x28d/0x870 
[  246.919827]  schedule+0x32/0x80 
[  246.933930]  schedule_preempt_disabled+0xa/0x10 
[  246.954271]  __mutex_lock.isra.5+0x269/0x500 
[  246.973495]  linkwatch_event+0xa/0x30 
[  246.990944]  process_one_work+0x141/0x340 
[  247.009917]  worker_thread+0x47/0x3e0 
[  247.027374]  kthread+0xf5/0x130 
[  247.042361]  ? rescuer_thread+0x380/0x380 
[  247.061484]  ? kthread_associate_blkcg+0x90/0x90 
[  247.083441]  ? do_group_exit+0x39/0xa0 
[  247.101252]  ret_from_fork+0x1f/0x30 
[  247.118247] INFO: task kworker/u128:6:416 blocked for more than 120 seconds. 
[  247.151925]       Not tainted 4.14.0.0c86a6bd85ff #1 
[  247.175783] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
[  247.215162] kworker/u128:6  D    0   416      2 0x80000000 
[  247.239844] Workqueue: netns cleanup_net 
[  247.257431] Call Trace: 
[  247.268375]  ? __schedule+0x28d/0x870 
[  247.285579]  schedule+0x32/0x80 
[  247.301239]  schedule_preempt_disabled+0xa/0x10 
[  247.323893]  __mutex_lock.isra.5+0x269/0x500 
[  247.344861]  cleanup_net+0x9e/0x2f0 
[  247.360653]  process_one_work+0x141/0x340 
[  247.378802]  worker_thread+0x47/0x3e0 
[  247.395226]  kthread+0xf5/0x130 
[  247.409347]  ? rescuer_thread+0x380/0x380 
[  247.427350]  ? kthread_associate_blkcg+0x90/0x90 
[  247.448021]  ret_from_fork+0x1f/0x30 
[  247.464745] INFO: task postfix:1102 blocked for more than 120 seconds. 
[  247.494120]       Not tainted 4.14.0.0c86a6bd85ff #1 
[  247.516436] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
[  247.551724] postfix         D    0  1102      1 0x00000084 
[  247.576398] Call Trace: 
[  247.588348]  ? __schedule+0x28d/0x870 
[  247.604884]  schedule+0x32/0x80 
[  247.619047]  schedule_preempt_disabled+0xa/0x10 
[  247.639392]  __mutex_lock.isra.5+0x269/0x500 
[  247.659003]  __netlink_dump_start+0x4a/0x210 
[  247.679034]  ? rtnl_bridge_notify+0xe0/0xe0 
[  247.699077]  rtnetlink_rcv_msg+0x1a2/0x280 
[  247.719148]  ? rtnl_bridge_notify+0xe0/0xe0 
[  247.739458]  ? rtnl_calcit.isra.27+0x100/0x100 
[  247.759838]  netlink_rcv_skb+0xe2/0x110 
[  247.777436]  netlink_unicast+0x17e/0x250 
[  247.796411]  netlink_sendmsg+0x2cd/0x3c0 
[  247.816274]  sock_sendmsg+0x30/0x40 
[  247.833703]  SYSC_sendto+0xd7/0x160 
[  247.851482]  ? SYSC_getsockname+0xb4/0xc0 
[  247.870886]  ? __audit_syscall_entry+0xaf/0x100 
[  247.891743]  ? syscall_trace_enter+0x1cc/0x2b0 
[  247.912089]  ? __audit_syscall_exit+0x1ff/0x280 
[  247.932832]  do_syscall_64+0x61/0x1a0 
[  247.949637]  entry_SYSCALL64_slow_path+0x25/0x25 
[  247.971242] RIP: 0033:0x7fe12b6f5a93 
[  247.987474] RSP: 002b:00007ffe434c29f8 EFLAGS: 00000246 ORIG_RAX: 000000000000002c 
[  248.021917] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007fe12b6f5a93 
[  248.054415] RDX: 0000000000000014 RSI: 00007ffe434c3a50 RDI: 0000000000000004 
[  248.086854] RBP: 00007ffe434c3ae0 R08: 00007ffe434c3a30 R09: 000000000000000c 
[  248.120336] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe434c3a50 
[  248.152857] R13: 000000000000044e R14: 00007ffe434c3a30 R15: 00007ffe434c2a00 
[-- MARK -- Wed Nov 22 05:40:00 2017] 
[  369.631006] INFO: task kworker/4:1:71 blocked for more than 120 seconds. 
[  369.665200]       Not tainted 4.14.0.0c86a6bd85ff #1 
[  369.690047] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
[  369.725738] kworker/4:1     D    0    71      2 0x80000000 
[  369.751088] Workqueue: ipv6_addrconf addrconf_verify_work 
[  369.776374] Call Trace: 
[  369.787721]  ? __schedule+0x28d/0x870 
[  369.804530]  schedule+0x32/0x80 
[  369.818979]  schedule_preempt_disabled+0xa/0x10 
[  369.839795]  __mutex_lock.isra.5+0x269/0x500 
[  369.859390]  ? put_prev_entity+0x2f/0xd0 
[  369.878454]  addrconf_verify_work+0xa/0x20 
[  369.898344]  process_one_work+0x141/0x340 
[  369.917971]  worker_thread+0x47/0x3e0 
[  369.935920]  kthread+0xf5/0x130 
[  369.951390]  ? rescuer_thread+0x380/0x380 
[  369.970941]  ? kthread_associate_blkcg+0x90/0x90 
[  369.993296]  ret_from_fork+0x1f/0x30 
[  370.010681] INFO: task kworker/4:2:363 blocked for more than 120 seconds. 
[  370.043438]       Not tainted 4.14.0.0c86a6bd85ff #1 
[  370.067449] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
[  370.105971] kworker/4:2     D    0   363      2 0x80000000 
[  370.133116] Workqueue: events linkwatch_event 
[  370.154279] Call Trace: 
[  370.166991]  ? __schedule+0x28d/0x870 
[  370.185721]  schedule+0x32/0x80 
[  370.201759]  schedule_preempt_disabled+0xa/0x10 
[  370.223608]  __mutex_lock.isra.5+0x269/0x500 
[  370.243793]  linkwatch_event+0xa/0x30 
[  370.260697]  process_one_work+0x141/0x340 
[  370.279114]  worker_thread+0x47/0x3e0 
[  370.295984]  kthread+0xf5/0x130 
[  370.310478]  ? rescuer_thread+0x380/0x380 
[  370.328861]  ? kthread_associate_blkcg+0x90/0x90 
[  370.350312]  ? do_group_exit+0x39/0xa0 
[  370.368242]  ret_from_fork+0x1f/0x30 
[  370.384747] INFO: task kworker/u128:6:416 blocked for more than 120 seconds. 
[  370.416811]       Not tainted 4.14.0.0c86a6bd85ff #1 
[  370.439587] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
[  370.475337] kworker/u128:6  D    0   416      2 0x80000000 
[  370.500875] Workqueue: netns cleanup_net 
[  370.519023] Call Trace: 
[  370.530489]  ? __schedule+0x28d/0x870 
[  370.547556]  schedule+0x32/0x80 
[  370.561695]  schedule_preempt_disabled+0xa/0x10 
[  370.582425]  __mutex_lock.isra.5+0x269/0x500 
[  370.602117]  cleanup_net+0x9e/0x2f0 
[  370.618294]  process_one_work+0x141/0x340 
[  370.637645]  worker_thread+0x47/0x3e0 
[  370.654592]  kthread+0xf5/0x130 
[  370.670293]  ? rescuer_thread+0x380/0x380 
[  370.690115]  ? kthread_associate_blkcg+0x90/0x90 
[  370.713360]  ret_from_fork+0x1f/0x30 
[  370.730941] INFO: task postfix:1102 blocked for more than 120 seconds. 
[  370.760696]       Not tainted 4.14.0.0c86a6bd85ff #1 
[  370.783387] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
[  370.818536] postfix         D    0  1102      1 0x00000084 
[  370.843626] Call Trace: 
[  370.854993]  ? __schedule+0x28d/0x870 
[  370.871831]  schedule+0x32/0x80 
[  370.886316]  schedule_preempt_disabled+0xa/0x10 
[  370.907045]  __mutex_lock.isra.5+0x269/0x500 
[  370.926650]  __netlink_dump_start+0x4a/0x210 
[  370.946228]  ? rtnl_bridge_notify+0xe0/0xe0 
[  370.965376]  rtnetlink_rcv_msg+0x1a2/0x280 
[  370.983763]  ? rtnl_bridge_notify+0xe0/0xe0 
[  371.002925]  ? rtnl_calcit.isra.27+0x100/0x100 
[  371.023320]  netlink_rcv_skb+0xe2/0x110 
[  371.040972]  netlink_unicast+0x17e/0x250 
[  371.058966]  netlink_sendmsg+0x2cd/0x3c0 
[  371.076572]  sock_sendmsg+0x30/0x40 
[  371.092780]  SYSC_sendto+0xd7/0x160 
[  371.109845]  ? SYSC_getsockname+0xb4/0xc0 
[  371.129429]  ? __audit_syscall_entry+0xaf/0x100 
[  371.151461]  ? syscall_trace_enter+0x1cc/0x2b0 
[  371.173129]  ? __audit_syscall_exit+0x1ff/0x280 
[  371.195218]  do_syscall_64+0x61/0x1a0 
[  371.213078]  entry_SYSCALL64_slow_path+0x25/0x25 
[  371.235663] RIP: 0033:0x7fe12b6f5a93 
[  371.253056] RSP: 002b:00007ffe434c29f8 EFLAGS: 00000246 ORIG_RAX: 000000000000002c 
[  371.289461] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007fe12b6f5a93 
[  371.324360] RDX: 0000000000000014 RSI: 00007ffe434c3a50 RDI: 0000000000000004 
[  371.359528] RBP: 00007ffe434c3ae0 R08: 00007ffe434c3a30 R09: 000000000000000c 
[  371.394796] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe434c3a50 
[  371.430479] R13: 000000000000044e R14: 00007ffe434c3a30 R15: 00007ffe434c2a00 
[  492.511020] INFO: task kworker/4:1:71 blocked for more than 120 seconds. 
[  492.544986]       Not tainted 4.14.0.0c86a6bd85ff #1 
[  492.569989] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
[  492.606782] kworker/4:1     D    0    71      2 0x80000000 
[  492.631839] Workqueue: ipv6_addrconf addrconf_verify_work 
[  492.657267] Call Trace: 
[  492.668656]  ? __schedule+0x28d/0x870 
[  492.685507]  schedule+0x32/0x80 
[  492.699970]  schedule_preempt_disabled+0xa/0x10 
[  492.720299]  __mutex_lock.isra.5+0x269/0x500 
[  492.739862]  ? put_prev_entity+0x2f/0xd0 
[  492.757882]  addrconf_verify_work+0xa/0x20 
[  492.777802]  process_one_work+0x141/0x340 
[  492.796944]  worker_thread+0x47/0x3e0 
[  492.814930]  kthread+0xf5/0x130 
[  492.830398]  ? rescuer_thread+0x380/0x380 
[  492.850075]  ? kthread_associate_blkcg+0x90/0x90 
[  492.872581]  ret_from_fork+0x1f/0x30 
[  492.890082] INFO: task kworker/4:2:363 blocked for more than 120 seconds. 
[  492.922975]       Not tainted 4.14.0.0c86a6bd85ff #1 
[  492.947100] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
[  492.985181] kworker/4:2     D    0   363      2 0x80000000 
[  493.012625] Workqueue: events linkwatch_event 
[  493.033772] Call Trace: 
[  493.046062]  ? __schedule+0x28d/0x870 
[  493.064083]  schedule+0x32/0x80 
[  493.080057]  schedule_preempt_disabled+0xa/0x10 
[  493.103035]  __mutex_lock.isra.5+0x269/0x500 
[  493.124037]  linkwatch_event+0xa/0x30 
[  493.141351]  process_one_work+0x141/0x340 
[  493.159730]  worker_thread+0x47/0x3e0 
[  493.176620]  kthread+0xf5/0x130 
[  493.191086]  ? rescuer_thread+0x380/0x380 
[  493.209475]  ? kthread_associate_blkcg+0x90/0x90 
[  493.230739]  ? do_group_exit+0x39/0xa0 
[  493.248197]  ret_from_fork+0x1f/0x30 
[  493.265649] INFO: task kworker/u128:6:416 blocked for more than 120 seconds. 
[  493.297736]       Not tainted 4.14.0.0c86a6bd85ff #1 
[  493.320529] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
[  493.356129] kworker/u128:6  D    0   416      2 0x80000000 
[  493.381757] Workqueue: netns cleanup_net 
[  493.399820] Call Trace: 
[  493.411186]  ? __schedule+0x28d/0x870 
[  493.428204]  schedule+0x32/0x80 
[  493.442692]  schedule_preempt_disabled+0xa/0x10 
[  493.463557]  __mutex_lock.isra.5+0x269/0x500 
[  493.483184]  cleanup_net+0x9e/0x2f0 
[  493.499700]  process_one_work+0x141/0x340 
[  493.519530]  worker_thread+0x47/0x3e0 
[  493.537294]  kthread+0xf5/0x130 
[  493.551796]  ? rescuer_595081]  ret_from_fork+0x1f/0x30 

--ReaqsoxgOBHFXBhH--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
