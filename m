From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Crash after commit b13912bbb4a2 "IPoIB: Call skb_dst_drop() once
 skb is enqueued for sending"
Date: Mon, 4 Feb 2013 17:17:53 +0200
Message-ID: <510FD121.9070402@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland.

After commit b13912bbb4a2 "IPoIB: Call skb_dst_drop() once skb is 
enqueued for sending".
Using connected mode and running multi-threaded iperf for long time,
that is iperf -c <IP> -P 16 -t 3600 results with the following crash.

Red Hat Enterprise Linux Server release 6.3 (Santiago)
Kernel 3.7.0 on an x86_64

r-hercules04 login: [  693.383404] BUG: unable to handle kernel NULL 
pointer dereference at 00000000000000e8
[  693.424982] IP: [<ffffffff815138e8>] sock_wfree+0x18/0x70
[  693.452221] PGD 82bc6d067 PUD 82c441067 PMD 0
[  693.475288] Oops: 0000 [#1] SMP
[  693.491589] Modules linked in: netconsole nfsv3 nfs_acl nfs 
ip6table_filter ip6_tables fscache ebtable_nat lockd ebtables 
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_CHECKSUM 
iptable_mangle sunrpc 8021q garp bridge stp llc rdma_ucm ib_ucm rdma_cm 
iw_cm ib_addr ib_ipoib ib_cm ib_uverbs ib_umad iw_nes libcrc32c iw_cxgb3 
cxgb3 mdio mlx4_ib ib_sa ib_mthca ib_mad ib_core binfmt_misc vhost_net 
macvtap macvlan tun uinput iTCO_wdt iTCO_vendor_support coretemp 
kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode serio_raw 
pcspkr hpwdt hpilo sb_edac edac_core lpc_ich mfd_core mlx4_en mlx4_core 
tg3 ptp pps_core ioatdma dca acpi_power_meter hpsa
[  693.790490] CPU 0
[  693.799561] Pid: 2248, comm: avahi-daemon Tainted: G        W 3.7.0 
#3 HP ProLiant DL380p Gen8
[  693.845805] RIP: 0010:[<ffffffff815138e8>] [<ffffffff815138e8>] 
sock_wfree+0x18/0x70
[  693.885685] RSP: 0000:ffff88042fa03d10  EFLAGS: 00010282
[  693.913293] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 
ffff88082bee8e00
[  693.950574] RDX: 0000000000001100 RSI: 00000004105240e4 RDI: 
ffff88042bcacef8
[  693.987599] RBP: ffff88042fa03d20 R08: 0000000000000000 R09: 
0000000000000003
[  694.023758] R10: 0000000000000001 R11: 0000000000000000 R12: 
ffff88042bcacef8
[  694.062076] R13: ffff88041eae4800 R14: ffffc90018147330 R15: 
ffff88041eae5158
[  694.100211] FS:  00007fa892ffe700(0000) GS:ffff88042fa00000(0000) 
knlGS:0000000000000000
[  694.142370] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  694.172468] CR2: 00000000000000e8 CR3: 000000082b5e8000 CR4: 
00000000000407f0
[  694.208474] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  694.245605] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[  694.282249] Process avahi-daemon (pid: 2248, threadinfo 
ffff88082bf56000, task ffff88082ce78000)
[  694.328163] Stack:
[  694.338109]  ffff88042fa03e00 ffff88042bcacef8 ffff88042fa03d40 
ffffffff815775fd
[  694.376164]  ffff88042bcacef8 ffff88042bcacef8 ffff88042fa03d60 
ffffffff81518000
[  694.413834]  ffff88042fa03d70 ffff88042bcacef8 ffff88042fa03d80 
ffffffff81517e66
[  694.451789] Call Trace:
[  694.465091]  <IRQ>
[  694.475075]  [<ffffffff815775fd>] tcp_wfree+0x3d/0xd0
[  694.501753]  [<ffffffff81518000>] skb_release_head_state+0x70/0x120
[  694.534482]  [<ffffffff81517e66>] __kfree_skb+0x16/0xa0
[  694.561060]  [<ffffffff8151855c>] consume_skb+0x2c/0x80
[  694.588186]  [<ffffffff8152271d>] dev_kfree_skb_any+0x3d/0x50
[  694.617646]  [<ffffffffa02ef458>] ipoib_cm_handle_tx_wc+0xa8/0x340 
[ib_ipoib]
[  694.654583]  [<ffffffffa007b3c3>] ? mlx4_eq_int+0xc3/0x9e0 [mlx4_core]
[  694.688519]  [<ffffffffa02e72f4>] ipoib_poll+0x174/0x190 [ib_ipoib]
[  694.721526]  [<ffffffff813b5731>] ? add_interrupt_randomness+0x41/0x190
[  694.755056]  [<ffffffff81527ae3>] net_rx_action+0x103/0x280
[  694.783849]  [<ffffffff81068bf6>] __do_softirq+0xc6/0x240
[  694.812603]  [<ffffffff810eff7d>] ? handle_irq_event+0x4d/0x70
[  694.842805]  [<ffffffff8163109c>] call_softirq+0x1c/0x30
[  694.870480]  [<ffffffff810164a5>] do_softirq+0x65/0xa0
[  694.896157]  [<ffffffff810689dd>] irq_exit+0xcd/0xf0
[  694.922004]  [<ffffffff81631926>] do_IRQ+0x66/0xe0
[  694.947348]  [<ffffffff816279ad>] common_interrupt+0x6d/0x6d
[  694.977302]  <EOI>
[  694.986910]  [<ffffffff8162fd59>] ? system_call_fastpath+0x16/0x1b
[  695.019750] Code: 00 00 e8 0c 87 ff ff eb ca 66 2e 0f 1f 84 00 00 00 
00 00 55 48 89 e5 53 48 83 ec 08 66 66 66 66 90 48 8b 5f 18 8b 97 f0 00 
00 00 <48> 8b 8b e8 00 00 00 89 d0 80 e5 02 74 22 f0 29 83 04 01 00 00
[  695.118690] RIP  [<ffffffff815138e8>] sock_wfree+0x18/0x70
[  695.147669]  RSP <ffff88042fa03d10>
[  695.165503] CR2: 00000000000000e8
[  695.182436] ---[ end trace 71c706b1d9cf8572 ]---
[  695.207779] Kernel panic - not syncing: Fatal exception in interrupt
[  695.242603] ------------[ cut here ]------------
[  695.268868] WARNING: at arch/x86/kernel/smp.c:123 
native_smp_send_reschedule+0x5c/0x60()
[  695.312657] Hardware name: ProLiant DL380p Gen8
[  695.336881] Modules linked in: netconsole nfsv3 nfs_acl nfs 
ip6table_filter ip6_tables fscache ebtable_nat lockd ebtables 
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_CHECKSUM 
iptable_mangle sunrpc 8021q garp bridge stp llc rdma_ucm ib_ucm rdma_cm 
iw_cm ib_addr ib_ipoib ib_cm ib_uverbs ib_umad iw_nes libcrc32c iw_cxgb3 
cxgb3 mdio mlx4_ib ib_sa ib_mthca ib_mad ib_core binfmt_misc vhost_net 
macvtap macvlan tun uinput iTCO_wdt iTCO_vendor_support coretemp 
kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode serio_raw 
pcspkr hpwdt hpilo sb_edac edac_core lpc_ich mfd_core mlx4_en mlx4_core 
tg3 ptp pps_core ioatdma dca acpi_power_meter hpsa
[  695.640007] Pid: 2248, comm: avahi-daemon Tainted: G      D W 3.7.0 #3
[  695.677587] Call Trace:
[  695.690504]  <IRQ>  [<ffffffff8106016f>] warn_slowpath_common+0x7f/0xc0
[  695.725938]  [<ffffffff810601ca>] warn_slowpath_null+0x1a/0x20
[  695.755393]  [<ffffffff81038c9c>] native_smp_send_reschedule+0x5c/0x60
[  695.789711]  [<ffffffff8109ba0a>] trigger_load_balance+0x1aa/0x230
[  695.821367]  [<ffffffff8109346f>] scheduler_tick+0x10f/0x140
[  695.850842]  [<ffffffff8107030e>] update_process_times+0x6e/0x90
[  695.881763]  [<ffffffff810b9ca9>] tick_sched_handle+0x39/0x80
[  695.912138]  [<ffffffff810b9ed4>] tick_sched_timer+0x54/0x90
[  695.941189]  [<ffffffff810882f1>] __run_hrtimer+0x71/0x1d0
[  695.968818]  [<ffffffff810b9e80>] ? tick_nohz_handler+0xc0/0xc0
[  696.001198]  [<ffffffff810886d6>] hrtimer_interrupt+0xf6/0x240
[  696.031610]  [<ffffffff81631a09>] smp_apic_timer_interrupt+0x69/0x99
[  696.064166]  [<ffffffff8163095d>] apic_timer_interrupt+0x6d/0x80
[  696.095812]  [<ffffffff81624582>] ? panic+0x19c/0x1e4
[  696.122152]  [<ffffffff816244df>] ? panic+0xf9/0x1e4
[  696.148977]  [<ffffffff816288ca>] oops_end+0xea/0xf0
[  696.174674]  [<ffffffff81048b2d>] no_context+0x11d/0x2d0
[  696.201968]  [<ffffffff81048e1d>] __bad_area_nosemaphore+0x13d/0x220
[  696.234976]  [<ffffffff81048f13>] bad_area_nosemaphore+0x13/0x20
[  696.266854]  [<ffffffff8162b60a>] __do_page_fault+0x37a/0x4a0
[  696.296904]  [<ffffffff8155abee>] ? ip_local_deliver_finish+0xde/0x290
[  696.331229]  [<ffffffff8155ade7>] ? ip_local_deliver+0x47/0x80
[  696.361302]  [<ffffffff8155a489>] ? ip_rcv_finish+0x119/0x360
[  696.391923]  [<ffffffff8155aa31>] ? ip_rcv+0x221/0x300
[  696.418131]  [<ffffffff8162b73e>] do_page_fault+0xe/0x10
[  696.446177]  [<ffffffff81627c98>] page_fault+0x28/0x30
[  696.471956]  [<ffffffff815138e8>] ? sock_wfree+0x18/0x70
[  696.498716]  [<ffffffff815775fd>] tcp_wfree+0x3d/0xd0
[  696.527393]  [<ffffffff81518000>] skb_release_head_state+0x70/0x120
[  696.558843]  [<ffffffff81517e66>] __kfree_skb+0x16/0xa0
[  696.586331]  [<ffffffff8151855c>] consume_skb+0x2c/0x80
[  696.613061]  [<ffffffff8152271d>] dev_kfree_skb_any+0x3d/0x50
[  696.643584]  [<ffffffffa02ef458>] ipoib_cm_handle_tx_wc+0xa8/0x340 
[ib_ipoib]
[  696.680581]  [<ffffffffa007b3c3>] ? mlx4_eq_int+0xc3/0x9e0 [mlx4_core]
[  696.715184]  [<ffffffffa02e72f4>] ipoib_poll+0x174/0x190 [ib_ipoib]
[  696.747030]  [<ffffffff813b5731>] ? add_interrupt_randomness+0x41/0x190
[  696.782367]  [<ffffffff81527ae3>] net_rx_action+0x103/0x280
[  696.810831]  [<ffffffff81068bf6>] __do_softirq+0xc6/0x240
[  696.839378]  [<ffffffff810eff7d>] ? handle_irq_event+0x4d/0x70
[  696.868711]  [<ffffffff8163109c>] call_softirq+0x1c/0x30
[  696.896905]  [<ffffffff810164a5>] do_softirq+0x65/0xa0
[  696.922869]  [<ffffffff810689dd>] irq_exit+0xcd/0xf0
[  696.948477]  [<ffffffff81631926>] do_IRQ+0x66/0xe0
[  696.973477]  [<ffffffff816279ad>] common_interrupt+0x6d/0x6d
[  697.002119]  <EOI>  [<ffffffff8162fd59>] ? system_call_fastpath+0x16/0x1b
[  697.038451] ---[ end trace 71c706b1d9cf8573 ]---

     Disassembling vmlinux shows that the NULL dereferencing address 
"sock_wfree+0x18" is
     where "skb->sk" is dereferenced.

     /*
      * Write buffer destructor automatically called from kfree_skb.
      */
     void sock_wfree(struct sk_buff *skb)
     {
     ffffffff815138d0:       55                      push   %rbp
     ffffffff815138d1:       48 89 e5                mov    %rsp,%rbp
     ffffffff815138d4:       53                      push   %rbx
     ffffffff815138d5:       48 83 ec 08             sub    $0x8,%rsp
     ffffffff815138d9:       e8 22 c0 11 00          callq 
ffffffff8162f900 <mcount>
             struct sock *sk = skb->sk;
     ffffffff815138de:       48 8b 5f 18             mov 0x18(%rdi),%rbx
             unsigned int len = skb->truesize;
     ffffffff815138e2:       8b 97 f0 00 00 00       mov 0xf0(%rdi),%edx
     ffffffff815138e8:       48 8b 8b e8 00 00 00    mov 0xe8(%rbx),%rcx

Crash analysis.

After the mentioned patch the driver is calling skb_orphan and 
skb_dst_drop after
calling post_send in ipoib_cm.c:: ipoib_cm_send "also in ipoib_ib.c:: 
ipoib_send"

The problem with this is as it is written in a comment in both routines 
is, quote
"it's entirely possible that the completion handler will run before we 
execute
anything after the post_send()."

The rest of the analysis of the crash (below) is as follows.
The call the skbuff.h::skb_orphan is delayed, meanwhile the completion 
starts on another CPU
on NAPI context, and in the routine "skbuff.c::skb_release_head_state" 
the skb->destructor
is still pointing to "tcp_output.c::tcp_wfree". At this point the 
"skbuff.h::skb_orpahn" executes
the destructor too and nullified the "skb->destructor" and the "skb->sk" 
fields.
We can have two destructors running at the same time!
And note that the destructor called from TX complete can dereference the 
nullified "skb->sk",
if it is called before the orphan nullified "skb->destructor" but 
dereference "skb->sk"
right after it was nullified.
This scenario is consistent with the fact that the "skb->destructor" 
namely "tcp_output.c::tcp_wfree"
was called and when it called "sock.c::sock_wfree" the skb->sk" was NULL.

I don't know why this issue didn't manifested itself with UD. Maybe UD 
transmit completes faster.

Proposed solution (patch will follow)

I think the solution is to always perform the skb_orphan and 
skb_dst_drop before the transmission.
In case error occurs than it will be no different than the regular case 
where dev_free_skb_any
in the completion path which is assumed to be after these two routines.

Shlomo Pongratz.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
