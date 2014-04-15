From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Prove locking correctness
Date: Tue, 15 Apr 2014 17:37:15 -0400
Message-ID: <4824BDCB-897F-458A-B9C1-379A5DD49DBA@oracle.com>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi-

I=92ve had CONFIG_PROVE_LOCKING set in my recent kernel builds (3.13,=20
3.14). With 3.14, it started spitting out the below warning at boot=20
time.

But this week, after 3.14, my system deadlocks on boot. I bisected
it today. It appears to start with either commit 6f008e72 or 462bf234.

Disabling CONFIG_PROVE_LOCKING allows me to boot 3.15-rc1.

[ cut here ]

Apr 15 14:44:59 manet kernel: =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Apr 15 14:44:59 manet kernel: [ INFO: inconsistent lock state ]
Apr 15 14:44:59 manet kernel: 3.14.0-rc3-00053-ge086481 #1 Tainted: GF =
         =20
Apr 15 14:44:59 manet kernel: ---------------------------------
Apr 15 14:44:59 manet kernel: inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIR=
Q-W} usage.
Apr 15 14:44:59 manet kernel: swapper/0/0 [HC0[0]:SC1[1]:HE1:SE0] takes=
:
Apr 15 14:44:59 manet kernel: (&(&iboe->lock)->rlock){+.?...}, at: [<ff=
ffffffa0649ece>] mlx4_ib_addr_event+0xde/0x180 [mlx4_ib]
Apr 15 14:44:59 manet kernel: {SOFTIRQ-ON-W} state was registered at:
Apr 15 14:44:59 manet kernel:  [<ffffffff810b7430>] mark_irqflags+0x110=
/0x170
Apr 15 14:44:59 manet kernel:  [<ffffffff810b8afc>] __lock_acquire+0x29=
c/0x570
Apr 15 14:44:59 manet kernel:  [<ffffffff810b8f01>] lock_acquire+0x131/=
0x160
Apr 15 14:44:59 manet kernel:  [<ffffffff8161bb19>] _raw_spin_lock+0x39=
/0x50
Apr 15 14:44:59 manet kernel:  [<ffffffffa064bc2c>] mlx4_ib_scan_netdev=
s+0x2c/0x210 [mlx4_ib]
Apr 15 14:44:59 manet kernel:  [<ffffffffa064be35>] mlx4_ib_netdev_even=
t+0x25/0x30 [mlx4_ib]
Apr 15 14:44:59 manet kernel:  [<ffffffff81530839>] register_netdevice_=
notifier+0x99/0x1e0
Apr 15 14:44:59 manet kernel:  [<ffffffffa064d21c>] mlx4_ib_add+0x76c/0=
xbf0 [mlx4_ib]
Apr 15 14:44:59 manet kernel:  [<ffffffffa05de228>] mlx4_add_device+0x4=
8/0xa0 [mlx4_core]
Apr 15 14:44:59 manet kernel:  [<ffffffffa05de383>] mlx4_register_inter=
face+0x73/0xb0 [mlx4_core]
Apr 15 14:44:59 manet kernel:  [<ffffffffa05b305a>] 0xffffffffa05b305a
Apr 15 14:44:59 manet kernel:  [<ffffffff8100028a>] do_one_initcall+0xb=
a/0x170
Apr 15 14:44:59 manet kernel:  [<ffffffff810eaa94>] do_init_module+0x84=
/0x1e0
Apr 15 14:44:59 manet kernel:  [<ffffffff810ee886>] load_module+0x5d6/0=
x750
Apr 15 14:44:59 manet kernel:  [<ffffffff810eeb99>] SyS_init_module+0x9=
9/0xd0
Apr 15 14:44:59 manet kernel:  [<ffffffff81626192>] system_call_fastpat=
h+0x16/0x1b
Apr 15 14:44:59 manet kernel: irq event stamp: 237158
Apr 15 14:44:59 manet kernel: hardirqs last  enabled at (237158): [<fff=
fffff8105f0c5>] __local_bh_enable_ip+0xb5/0xc0
Apr 15 14:44:59 manet kernel: hardirqs last disabled at (237157): [<fff=
fffff8105f066>] __local_bh_enable_ip+0x56/0xc0
Apr 15 14:44:59 manet kernel: softirqs last  enabled at (237022): [<fff=
fffff8105f00a>] _local_bh_enable+0x4a/0x50
Apr 15 14:44:59 manet kernel: softirqs last disabled at (237023): [<fff=
fffff8105fd44>] irq_exit+0x44/0xd0
Apr 15 14:44:59 manet kernel:=20
Apr 15 14:44:59 manet kernel: other info that might help us debug this:
Apr 15 14:44:59 manet kernel: Possible unsafe locking scenario:
Apr 15 14:44:59 manet kernel:=20
Apr 15 14:44:59 manet kernel:       CPU0
Apr 15 14:44:59 manet kernel:       ----
Apr 15 14:44:59 manet kernel:  lock(&(&iboe->lock)->rlock);
Apr 15 14:44:59 manet kernel:  <Interrupt>
Apr 15 14:44:59 manet kernel:    lock(&(&iboe->lock)->rlock);
Apr 15 14:44:59 manet kernel:=20
Apr 15 14:44:59 manet kernel: *** DEADLOCK ***
Apr 15 14:44:59 manet kernel:=20
Apr 15 14:44:59 manet kernel: 3 locks held by swapper/0/0:
Apr 15 14:44:59 manet kernel: #0:  (rcu_read_lock){.+.+..}, at: [<fffff=
fff81533f00>] __netif_receive_skb_core+0x240/0x960
Apr 15 14:44:59 manet kernel: #1:  (rcu_read_lock){.+.+..}, at: [<fffff=
fffa037054c>] ip6_input_finish+0x7c/0x710 [ipv6]
Apr 15 14:44:59 manet kernel: #2:  (rcu_read_lock){.+.+..}, at: [<fffff=
fff81620960>] __atomic_notifier_call_chain+0x0/0x130
Apr 15 14:44:59 manet kernel:=20
Apr 15 14:44:59 manet kernel: stack backtrace:
Apr 15 14:44:59 manet kernel: CPU: 0 PID: 0 Comm: swapper/0 Tainted: GF=
            3.14.0-rc3-00053-ge086481 #1
Apr 15 14:44:59 manet kernel: Hardware name: Shuttle SZ77/FZ77, BIOS 1.=
10 07/10/2012
Apr 15 14:44:59 manet kernel: ffffffff81c11118 ffff88022f2035b8 fffffff=
f816165e3 0000000000000002
Apr 15 14:44:59 manet kernel: ffffffff81c104c0 ffff88022f203608 fffffff=
f810b636a 0000000000000001
Apr 15 14:44:59 manet kernel: 0000000000000001 0000000b00000000 fffffff=
f82281948 0000000000000006
Apr 15 14:44:59 manet kernel: Call Trace:
Apr 15 14:44:59 manet kernel: <IRQ>  [<ffffffff816165e3>] dump_stack+0x=
51/0x6e
Apr 15 14:44:59 manet kernel: [<ffffffff810b636a>] print_usage_bug+0x17=
a/0x1a0
Apr 15 14:44:59 manet kernel: [<ffffffff810b6980>] ? print_circular_bug=
+0x120/0x120
Apr 15 14:44:59 manet kernel: [<ffffffff810b6f91>] mark_lock_irq+0xe1/0=
x2b0
Apr 15 14:44:59 manet kernel: [<ffffffff810b7279>] mark_lock+0x119/0x1c=
0
Apr 15 14:44:59 manet kernel: [<ffffffff810b73b5>] mark_irqflags+0x95/0=
x170
Apr 15 14:44:59 manet kernel: [<ffffffff810b8afc>] __lock_acquire+0x29c=
/0x570
Apr 15 14:44:59 manet kernel: [<ffffffff810b6a4c>] ? check_usage_forwar=
ds+0xcc/0x120
Apr 15 14:44:59 manet kernel: [<ffffffff810b8f01>] lock_acquire+0x131/0=
x160
Apr 15 14:44:59 manet kernel: [<ffffffffa0649ece>] ? mlx4_ib_addr_event=
+0xde/0x180 [mlx4_ib]
Apr 15 14:44:59 manet kernel: [<ffffffff8161bb19>] _raw_spin_lock+0x39/=
0x50
Apr 15 14:44:59 manet kernel: [<ffffffffa0649ece>] ? mlx4_ib_addr_event=
+0xde/0x180 [mlx4_ib]
Apr 15 14:44:59 manet kernel: [<ffffffffa0649ece>] mlx4_ib_addr_event+0=
xde/0x180 [mlx4_ib]
Apr 15 14:44:59 manet kernel: [<ffffffffa0649f97>] mlx4_ib_inet6_event+=
0x27/0x30 [mlx4_ib]
Apr 15 14:44:59 manet kernel: [<ffffffff81620934>] notifier_call_chain+=
0xc4/0xf0
Apr 15 14:44:59 manet kernel: [<ffffffff81620a15>] __atomic_notifier_ca=
ll_chain+0xb5/0x130
Apr 15 14:44:59 manet kernel: [<ffffffff81620960>] ? notifier_call_chai=
n+0xf0/0xf0
Apr 15 14:44:59 manet kernel: [<ffffffff81620aa6>] atomic_notifier_call=
_chain+0x16/0x20
Apr 15 14:44:59 manet kernel: [<ffffffff815f4ddb>] inet6addr_notifier_c=
all_chain+0x1b/0x20
Apr 15 14:44:59 manet kernel: [<ffffffffa0377f5d>] ipv6_add_addr+0x48d/=
0x510 [ipv6]
Apr 15 14:44:59 manet kernel: [<ffffffffa0377b31>] ? ipv6_add_addr+0x61=
/0x510 [ipv6]
Apr 15 14:44:59 manet kernel: [<ffffffffa0379ae2>] ? addrconf_prefix_rc=
v+0x522/0x6f0 [ipv6]
Apr 15 14:44:59 manet kernel: [<ffffffffa0379b1a>] addrconf_prefix_rcv+=
0x55a/0x6f0 [ipv6]
Apr 15 14:44:59 manet kernel: [<ffffffffa0389180>] ndisc_router_discove=
ry+0x7b0/0x970 [ipv6]
Apr 15 14:44:59 manet kernel: [<ffffffffa038aa5a>] ndisc_rcv+0x18a/0x1c=
0 [ipv6]
Apr 15 14:44:59 manet kernel: [<ffffffffa0392b30>] icmpv6_rcv+0x490/0x5=
80 [ipv6]
Apr 15 14:44:59 manet kernel: [<ffffffffa0396180>] ? mld_ifc_timer_expi=
re+0x60/0x60 [ipv6]
Apr 15 14:44:59 manet kernel: [<ffffffffa0370978>] ip6_input_finish+0x4=
a8/0x710 [ipv6]
Apr 15 14:44:59 manet kernel: [<ffffffffa037054c>] ? ip6_input_finish+0=
x7c/0x710 [ipv6]
Apr 15 14:44:59 manet kernel: [<ffffffffa036ffd8>] ip6_input+0x58/0x60 =
[ipv6]
Apr 15 14:44:59 manet kernel: [<ffffffffa037028d>] ip6_mc_input+0x2ad/0=
x2e0 [ipv6]
Apr 15 14:44:59 manet kernel: [<ffffffffa03704c6>] ip6_rcv_finish+0x206=
/0x210 [ipv6]
Apr 15 14:44:59 manet kernel: [<ffffffffa03711d8>] ipv6_rcv+0x5f8/0x6a0=
 [ipv6]
Apr 15 14:44:59 manet kernel: [<ffffffffa0370c28>] ? ipv6_rcv+0x48/0x6a=
0 [ipv6]
Apr 15 14:44:59 manet kernel: [<ffffffff81534591>] __netif_receive_skb_=
core+0x8d1/0x960
Apr 15 14:44:59 manet kernel: [<ffffffff81533f00>] ? __netif_receive_sk=
b_core+0x240/0x960
Apr 15 14:44:59 manet kernel: [<ffffffff8152c060>] ? rcu_read_unlock+0x=
40/0x70
Apr 15 14:44:59 manet kernel: [<ffffffff81534687>] __netif_receive_skb+=
0x67/0x80
Apr 15 14:44:59 manet kernel: [<ffffffff81534a08>] netif_receive_skb_in=
ternal+0x1b8/0x1d0
Apr 15 14:44:59 manet kernel: [<ffffffff81537248>] napi_gro_receive+0xc=
8/0x120
Apr 15 14:44:59 manet kernel: [<ffffffffa043bb97>] rtl_rx+0x357/0x3c0 [=
r8169]
Apr 15 14:44:59 manet kernel: [<ffffffffa043bc71>] rtl8169_poll+0x71/0x=
200 [r8169]
Apr 15 14:44:59 manet kernel: [<ffffffff81536797>] net_rx_action+0xc7/0=
x2f0
Apr 15 14:44:59 manet kernel: [<ffffffff8105f941>] ? __do_softirq+0xc1/=
0x420
Apr 15 14:44:59 manet kernel: [<ffffffff8105fa52>] __do_softirq+0x1d2/0=
x420
Apr 15 14:44:59 manet kernel: [<ffffffff8105fd44>] irq_exit+0x44/0xd0
Apr 15 14:44:59 manet kernel: [<ffffffff816281b5>] do_IRQ+0xd5/0x100
Apr 15 14:44:59 manet kernel: [<ffffffff8161c92f>] common_interrupt+0x6=
f/0x6f
Apr 15 14:44:59 manet kernel: <EOI>  [<ffffffff814d828b>] ? cpuidle_ent=
er_state+0x5b/0xd0
Apr 15 14:44:59 manet kernel: [<ffffffff814d8287>] ? cpuidle_enter_stat=
e+0x57/0xd0
Apr 15 14:44:59 manet kernel: [<ffffffff814d8522>] cpuidle_idle_call+0x=
112/0x170
Apr 15 14:44:59 manet kernel: [<ffffffff8100d2de>] arch_cpu_idle+0xe/0x=
30
Apr 15 14:44:59 manet kernel: [<ffffffff810c9f38>] cpu_idle_loop+0x2a8/=
0x360
Apr 15 14:44:59 manet kernel: [<ffffffff810ca013>] cpu_startup_entry+0x=
23/0x30
Apr 15 14:44:59 manet kernel: [<ffffffff8160e989>] rest_init+0x149/0x15=
0
Apr 15 14:44:59 manet kernel: [<ffffffff8160e840>] ? csum_partial_copy_=
generic+0x170/0x170
Apr 15 14:44:59 manet kernel: [<ffffffff81d822af>] start_kernel+0x3ad/0=
x3b4
Apr 15 14:44:59 manet kernel: [<ffffffff81d81d20>] ? repair_env_string+=
0x5b/0x5b
Apr 15 14:44:59 manet kernel: [<ffffffff81614c8e>] ? memblock_reserve+0=
x49/0x4e
Apr 15 14:44:59 manet kernel: [<ffffffff81d815a3>] x86_64_start_reserva=
tions+0x2a/0x2c
Apr 15 14:44:59 manet kernel: [<ffffffff81d816e6>] x86_64_start_kernel+=
0x141/0x148



--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
