From: Maxim Levitsky <maximlevitsky-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Mellanox Technologies MT23108 causes #MC exceptions under heavy load
Date: Fri, 6 Mar 2015 05:35:40 +0200
Message-ID: <CACAwPwaEw2nVnCYp=3eAc378DOEEDK+06avLThzYc=2UhjBQLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We are running CPU and network heavy test on marmot.pdl.cmu.edu cluster.
It has Mellanox Technologies MT23108 InfiniHost controller.

When we start using it for network communications, after just few
minutes some of the nodes of the cluster die
with the following machine check exception.
I repeated this test with Ethernet few times and had not an single
failure so far (I thought to had one but it turned to be another
unrelated issue)

It happened already on most nodes of this 128 node cluster, thus I
expect this to be kernel bug.
Do you have any pointers what we could try?

I compiled and tested current HEAD  of the vanilla kernel
(99aedde0869ce194539166ac5a4d2e1a20995348)
4.0.0-rc2
but this happens even on 2.6.38 (which was in one of
their stock kernel images).

Best regards,
          Maxim Levitsky

The kernel log of failure captured via serial console:

[  297.575167] ib0: can't use GFP_NOIO for QPs on device mthca0, using
GFP_KERNEL
[  564.704428] ib0: can't use GFP_NOIO for QPs on device mthca0, using
GFP_KERNEL
[  951.619320] ib0: can't use GFP_NOIO for QPs on device mthca0, using
GFP_KERNEL
[  956.790789] ib0: can't use GFP_NOIO for QPs on device mthca0, using
GFP_KERNEL
[  957.301036] ib0: can't use GFP_NOIO for QPs on device mthca0, using
GFP_KERNEL
[  957.333938] ib0: can't use GFP_NOIO for QPs on device mthca0, using
GFP_KERNEL
[  957.924656] ib0: can't use GFP_NOIO for QPs on device mthca0, using
GFP_KERNEL
[  958.125879] ib0: can't use GFP_NOIO for QPs on device mthca0, using
GFP_KERNEL
[  958.147588] ib0: can't use GFP_NOIO for QPs on device mthca0, using
GFP_KERNEL
[  958.485607] ib0: can't use GFP_NOIO for QPs on device mthca0, using
GFP_KERNEL
[  959.050155] ib0: can't use GFP_NOIO for QPs on device mthca0, using
GFP_KERNEL
[  959.120109] ib0: can't use GFP_NOIO for QPs on device mthca0, using
GFP_KERNEL
[  960.048666] ib0: can't use GFP_NOIO for QPs on device mthca0, using
GFP_KERNEL
[  960.110928] ib0: can't use GFP_NOIO for QPs on device mthca0, using
GFP_KERNEL
[  960.754363] ib0: can't use GFP_NOIO for QPs on device mthca0, using
GFP_KERNEL
[  961.390093] ib0: can't use GFP_NOIO for QPs on device mthca0, using
GFP_KERNEL
[  972.199782] ib0: can't use GFP_NOIO for QPs on device mthca0, using
GFP_KERNEL
[  972.496511] ib0: can't use GFP_NOIO for QPs on device mthca0, using
GFP_KERNEL
[  983.078444] ib0: can't use GFP_NOIO for QPs on device mthca0, using
GFP_KERNEL
[  983.618178] ib0: can't use GFP_NOIO for QPs on device mthca0, using
GFP_KERNEL
[  991.365565] ib0: can't use GFP_NOIO for QPs on device mthca0, using
GFP_KERNEL
[ 1003.344498] ib0: can't use GFP_NOIO for QPs on device mthca0, using
GFP_KERNEL
[ 1013.748036] Disabling lock debugging due to kernel taint
[ 1013.747903] [Hardware Error]: System Fatal error.
[ 1013.747903] [Hardware Error]: CPU:0 (f:5:1)
MC4_STATUS[-|UE|-|PCC|-]: 0xb200000000070f0f
[ 1013.747903] [Hardware Error]: MC4 Error (node 0): Watchdog timeout
due to lack of progress.
[ 1013.747903] [Hardware Error]: cache level: L3/GEN, mem/io: GEN,
mem-tx: GEN, part-proc: GEN (timed out)
[ 1013.747903] mce: [Hardware Error]: CPU 0: Machine Check Exception:
4 Bank 4: b200000000070f0f
[ 1013.747903] mce: [Hardware Error]: TSC 1a2dcecb6b8
[ 1013.747903] mce: [Hardware Error]: PROCESSOR 2:f51 TIME 1425610753
SOCKET 0 APIC 0 microcode 0
[ 1013.747903] [Hardware Error]: System Fatal error.
[ 1013.747903] [Hardware Error]: CPU:0 (f:5:1)
MC4_STATUS[-|UE|-|PCC|-]: 0xb200000000070f0f
[ 1013.747903] [Hardware Error]: MC4 Error (node 0): Watchdog timeout
due to lack of progress.
[ 1013.747903] [Hardware Error]: cache level: L3/GEN, mem/io: GEN,
mem-tx: GEN, part-proc: GEN (timed out)
[ 1013.747903] mce: [Hardware Error]: Machine check: Processor context corrupt
[ 1013.747903] Kernel panic - not syncing: Fatal machine check on current CPU
[ 1013.748036] [Hardware Error]: System Fatal error.
[ 1013.748036] [Hardware Error]: CPU:1 (f:5:1)
MC4_STATUS[-|UE|-|PCC|-]: 0xb200000000070f0f
[ 1013.748036] [Hardware Error]: MC4 Error (node 1): Watchdog timeout
due to lack of progress.
[ 1013.748036] [Hardware Error]: cache level: L3/GEN, mem/io: GEN,
mem-tx: GEN, part-proc: GEN (timed out)
[ 1013.747903] Kernel Offset: disabled
[ 1013.747903] ---[ end Kernel panic - not syncing: Fatal machine
check on current CPU
[ 1019.239423] ------------[ cut here ]------------
[ 1019.244144] WARNING: CPU: 0 PID: 13875 at arch/x86/kernel/smp.c:124
native_smp_send_reschedule+0x5f/0x70()
[ 1019.249416] Modules linked in: ib_ipoib ib_cm ib_sa nfsv2 nfs lockd
sunrpc grace i2c_piix4 ib_mthca ib_mad ib_core ib_addr shpchp
amd64_edac_mod i2c_amd756 k8temp amd_rng edac_core edac_mce_amd tg3
ptp pps_core sata_promise pata_amd
[ 1019.249416] CPU: 0 PID: 13875 Comm: java Tainted: G   M
4.0.0-rc2+ #1
[ 1019.249416] Hardware name: RIOWORKS HDAMA/HDAMA, BIOS V2.17 03/20/2006
[ 1019.249416]  000000000000007c ffff8801f8409a80 ffffffff815f33ff
000000000000007c
[ 1019.249416]  0000000000000000 ffff8801f8409ac0 ffffffff81055c97
ffff8801f8413d28
[ 1019.249416]  ffff8803ffc13cc0 0000000000000001 ffff8801f8413cc0
0000000000000000
[ 1019.249416] Call Trace:
[ 1019.249416]  <#MC>  [<ffffffff815f33ff>] dump_stack+0x48/0x61
[ 1019.249416]  [<ffffffff81055c97>] warn_slowpath_common+0x97/0xe0
[ 1019.249416]  [<ffffffff81055cfa>] warn_slowpath_null+0x1a/0x20
[ 1019.249416]  [<ffffffff81032aef>] native_smp_send_reschedule+0x5f/0x70
[ 1019.249416]  [<ffffffff8108a24a>] trigger_load_balance+0x15a/0x200
[ 1019.249416]  [<ffffffff8107e038>] scheduler_tick+0x88/0xa0
[ 1019.249416]  [<ffffffff810ac3d1>] update_process_times+0x51/0x70
[ 1019.249416]  [<ffffffff810bb7f0>] tick_sched_handle.clone.11+0x30/0x70
[ 1019.249416]  [<ffffffff810bb92f>] tick_sched_timer+0x4f/0x90
[ 1019.249416]  [<ffffffff810acbdc>] __run_hrtimer+0x6c/0x1b0
[ 1019.249416]  [<ffffffff810bb8e0>] ? tick_nohz_handler+0xb0/0xb0
[ 1019.249416]  [<ffffffff810ad393>] hrtimer_interrupt+0xe3/0x200
[ 1019.249416]  [<ffffffff81035179>] local_apic_timer_interrupt+0x39/0x60
[ 1019.249416]  [<ffffffff815fa355>] smp_apic_timer_interrupt+0x45/0x60
[ 1019.249416]  [<ffffffff815f892a>] apic_timer_interrupt+0x6a/0x70
[ 1019.249416]  [<ffffffff815f3170>] ? panic+0x1b9/0x1fb
[ 1019.249416]  [<ffffffff815f316c>] ? panic+0x1b5/0x1fb
[ 1019.249416]  [<ffffffff815f31f8>] ? printk+0x46/0x48
[ 1019.249416]  [<ffffffff810295cf>] mce_panic+0x24f/0x270
[ 1019.249416]  [<ffffffff8102a687>] do_machine_check+0x767/0xa60
[ 1019.249416]  [<ffffffff815f95d6>] machine_check+0x26/0x50
[ 1019.249416]  [<ffffffffa000b2c5>] ? pdc_interrupt+0x2d5/0x430 [sata_promise]
[ 1019.249416]  <<EOE>>  <IRQ>  [<ffffffff8109d1a4>]
handle_irq_event_percpu+0x54/0x1a0
[ 1019.249416]  [<ffffffff8109d332>] handle_irq_event+0x42/0x70
[ 1019.249416]  [<ffffffff8109fcd9>] handle_fasteoi_irq+0x79/0x130
[ 1019.249416]  [<ffffffff81006222>] handle_irq+0x22/0x40
[ 1019.249416]  [<ffffffff815fa25c>] do_IRQ+0x5c/0x110
[ 1019.249416]  [<ffffffff815f85ea>] common_interrupt+0x6a/0x6a
[ 1019.249416]  <EOI>  [<ffffffff811d3f57>] ? fsnotify+0xc7/0x340
[ 1019.249416]  [<ffffffff811d40e4>] ? fsnotify+0x254/0x340
[ 1019.249416]  [<ffffffff811968cf>] vfs_write+0x12f/0x1d0
[ 1019.249416]  [<ffffffff81196c16>] SyS_write+0x56/0xd0
[ 1019.249416]  [<ffffffff811da81e>] ? SyS_epoll_wait+0xbe/0xe0
[ 1019.249416]  [<ffffffff815f7b32>] system_call_fastpath+0x12/0x17
[ 1019.249416] ---[ end trace 3ba0c941409cb2fb ]---
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
