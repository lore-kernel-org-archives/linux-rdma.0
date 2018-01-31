From: "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: NULL ptr dereference in rpcrdma_regbuf_is_mapped
Date: Wed, 31 Jan 2018 14:05:25 +0000
Message-ID: <CY1PR0701MB2012E2513C601C42F1B1966288FB0@CY1PR0701MB2012.namprd07.prod.outlook.com>
References: <CY1PR0701MB2012AAA5AC6B70B3E2EA5B7E88E40@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <0AEFFE48-ECD8-40A4-87EB-D78B1D1686B0@oracle.com>
 <CY1PR0701MB2012F1220026A59D21107E5B88E40@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <97A827DD-D776-458F-88B5-6E3FAB6F5501@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <97A827DD-D776-458F-88B5-6E3FAB6F5501-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Chuck Lever [mailto:chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org]
> Sent: Tuesday, January 30, 2018 7:28 PM
> To: Kalderon, Michal <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: NULL ptr dereference in rpcrdma_regbuf_is_mapped
>=20
>=20
>=20
> > On Jan 30, 2018, at 11:53 AM, Kalderon, Michal
> <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org> wrote:
> >
> >> From: Chuck Lever [mailto:chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org]
> >> Sent: Tuesday, January 30, 2018 6:47 PM
> >> To: Kalderon, Michal <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> >> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> Subject: Re: NULL ptr dereference in rpcrdma_regbuf_is_mapped
> >>
> >>
> >>
> >>> On Jan 30, 2018, at 11:43 AM, Kalderon, Michal
> >> <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org> wrote:
> >>>
> >>> Hi Chuck,
> >>>
> >>> Different issue, so started different thread.
> >>> If I unload our driver while there is an open NFS connection I get a
> >>> null pointer dereference in rpcrdma_regbuf_is_mapped the pointer to
> >>> buf
> >> received in this function is NULL.
> >>
> >> Hi Michal, let's see the backtrace.
> > Sure
>=20
> OK, I wonder if this is really the same problem as you reported before. I=
s this
> rb coming from a possibly corrupted sendctx?
>=20
> So, I have a fix for the earlier bug, and I'm testing it. I'll post it la=
ter today or
> tomorrow, and let's see if this one goes away too when you try out that f=
ix.

We're still seeing this issue with the new fixed patch.=20

>=20
>=20
> > [root@GAD17990 ~]# [  169.085616] ib_srpt srpt_remove_one(qedr0):
> nothing to do.
> > [  169.112490] rpcrdma: removing device qedr0 for
> > 192.168.110.146:20049 [  169.143909] BUG: unable to handle kernel NULL
> > pointer dereference at 0000000000000010 [  169.181837] IP:
> > rpcrdma_dma_unmap_regbuf+0xa/0x60 [rpcrdma] [  169.209157] PGD 0
> P4D 0
> > [  169.221720] Oops: 0000 [#1] SMP [  169.237123] Modules linked in:
> > nfsv3 rpcsec_gss_krb5 nfsv4 dns_resolver nfs fscache rpcrdma ib_isert
> > iscsi_target_mod ib_iser libiscsi scsi_transport_iscsi ib_srpt
> > target_core_mod ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm
> > ib_uverbs ib_umad rdma_cm ib_cm iw_cm 8021q garp mrp qedr(-) ib_core
> > xt_CHECKSUM iptable_mangle ipt_MASQUERADE
> nf_nat_masquerade_ipv4
> > iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4
> > xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 tun bridge stp llc
> > fuse ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter
> > dm_mirror dm_region_hash dm_log dm_mod dax vfat fat intel_rapl
> > x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm
> irqbypass
> > crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc aesni_intel sg
> > iTCO_wdt hpilo crypto_simd iTCO_vendor_support [  169.590977]
> > i2c_i801 glue_helper hpwdt cryptd ioatdma pcspkr lpc_ich ipmi_si
> > shpchp i2c_core wmi dca pcc_cpufreq acpi_power_meter ipmi_devintf
> > mfd_core ipmi_msghandler nfsd auth_rpcgss nfs_acl lockd grace sunrpc
> > ip_tables xfs libcrc32c qede sd_mod qed tg3 ptp crc32c_intel hpsa
> > pps_core scsi_transport_sas [  169.725580] CPU: 30 PID: 2798 Comm:
> kworker/30:1H Not tainted 4.14.0-rc8+ #1 [  169.759488] Hardware name: HP
> ProLiant DL380 Gen9/ProLiant DL380 Gen9, BIOS P89 02/17/2017 [
> 169.800084] Workqueue: xprtiod xprt_autoclose [sunrpc] [  169.824940] tas=
k:
> ffff9f4b6966c380 task.stack: ffffbae6041c4000 [  169.854591] RIP:
> 0010:rpcrdma_dma_unmap_regbuf+0xa/0x60 [rpcrdma] [  169.884029] RSP:
> 0018:ffffbae6041c7dd0 EFLAGS: 00010287 [  169.910009] RAX:
> ffff9f476aa18220 RBX: ffff9f476aa18000 RCX: 0000000000000001 [  169.94504=
2]
> RDX: 0000000000000184 RSI: 000000046c1ba100 RDI: 0000000000000000 [
> 169.980932] RBP: ffffbae6041c7dd8 R08: 0000000000000000 R09:
> 000000018020001e [  170.016169] R10: 000000006b2c6601 R11:
> ffff9f476b2c6400 R12: ffff9f4768295550 [  170.051560] R13: ffff9f47682958=
78
> R14: ffff9f47682958e0 R15: ffff9f47682953d0 [  170.086745] FS:
> 0000000000000000(0000) GS:ffff9f4b7f980000(0000) knlGS:0000000000000000
> [  170.126491] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 [
> 170.154565] CR2: 0000000000000010 CR3: 00000005cec09005 CR4:
> 00000000001606e0 [  170.189497] Call Trace:
> > [  170.201856]  rpcrdma_ia_remove+0xca/0x110 [rpcrdma] [  170.225375]
> > xprt_rdma_close+0x70/0x90 [rpcrdma] [  170.248093]
> > xprt_autoclose+0x38/0x70 [sunrpc] [  170.269801]
> > process_one_work+0x149/0x360 [  170.290135]
> worker_thread+0x4d/0x3e0
> > [  170.308004]  kthread+0x109/0x140 [  170.323668]  ?
> > rescuer_thread+0x380/0x380 [  170.343204]  ? kthread_park+0x60/0x60 [
> > 170.360671]  ret_from_fork+0x25/0x30 [  170.378242] Code: 48 c7 c6 c0
> > e4 89 c0 48 c7 c7 70 fa 89 c0 31 c0 e8 9f 36 85 d6 e9 e5 fe ff ff 0f
> > 1f 80 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 53 <48> 8b 47 10 48 89 fb
> > 48 85 c0 74 38 8b 4f 18 8b 57 08 48 8b 37 [  170.469580] RIP:
> > rpcrdma_dma_unmap_regbuf+0xa/0x60 [rpcrdma] RSP: ffffbae6041c7dd0
> [
> > 170.505477] CR2: 0000000000000010 [  170.522257] ---[ end trace
> > 0f69dc0bd121b690 ]--- [  170.546716] Kernel panic - not syncing: Fatal
> > exception [  170.572952] Kernel Offset: 0x16000000 from
> > 0xffffffff81000000 (relocation range:
> > 0xffffffff80000000-0xffffffffbfffffff)
> > [  170.628837] ---[ end Kernel panic - not syncing: Fatal exception [
> > 170.657647] ------------[ cut here ]------------ [  170.679659]
> > WARNING: CPU: 30 PID: 2798 at kernel/sched/core.c:1179
> > set_task_cpu+0x191/0x1a0 [  170.719367] Modules linked in: nfsv3
> > rpcsec_gss_krb5 nfsv4 dns_resolver nfs fscache rpcrdma ib_isert
> iscsi_target_mod ib_iser libiscsi scsi_transport_iscsi ib_srpt target_cor=
e_mod
> ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad
> rdma_cm ib_cm iw_cm 8021q garp mrp qedr(-) ib_core xt_CHECKSUM
> iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat
> nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack
> nf_conntrack ipt_REJECT nf_reject_ipv4 tun bridge stp llc fuse ebtable_fi=
lter
> ebtables ip6table_filter ip6_tables iptable_filter dm_mirror dm_region_ha=
sh
> dm_log dm_mod dax vfat fat intel_rapl x86_pkg_temp_thermal
> intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul
> crc32_pclmul ghash_clmulni_intel pcbc aesni_intel sg iTCO_wdt hpilo
> crypto_simd iTCO_vendor_support [  171.072372]  i2c_i801 glue_helper
> hpwdt cryptd ioatdma pcspkr lpc_ich ipmi_si shpchp i2c_core wmi dca
> pcc_cpufreq acpi_power_meter ipmi_devintf mfd_core ipmi_msghandler
> nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c qede
> sd_mod qed tg3 ptp crc32c_intel hpsa pps_core scsi_transport_sas
> > [  171.204786] CPU: 30 PID: 2798 Comm: kworker/30:1H Tainted: G      D
> 4.14.0-rc8+ #1
> > [  171.245766] Hardware name: HP ProLiant DL380 Gen9/ProLiant DL380
> > Gen9, BIOS P89 02/17/2017 [  171.286989] Workqueue: xprtiod
> > xprt_autoclose [sunrpc] [  171.311991] task: ffff9f4b6966c380
> > task.stack: ffffbae6041c4000 [  171.340762] RIP:
> > 0010:set_task_cpu+0x191/0x1a0 [  171.362691] RSP:
> > 0018:ffff9f4b7f983c38 EFLAGS: 00010046 [  171.388519] RAX:
> > 0000000000000200 RBX: ffff9f4b66652d00 RCX: 0000000000000008 [
> > 171.423127] RDX: 0000000000000001 RSI: 0000000000000008 RDI:
> > ffff9f4b66652d00 [  171.457854] RBP: ffff9f4b7f983c58 R08:
> > 00000000ff00ff00 R09: 0000000000000000 [  171.493635] R10:
> > 0000000000000005 R11: 0000000000000c6c R12: ffff9f4b666537ec [
> > 171.528287] R13: 0000000000000008 R14: 0000000000000008 R15:
> > 000000000001bb80 [  171.562311] FS:  0000000000000000(0000)
> > GS:ffff9f4b7f980000(0000) knlGS:0000000000000000 [  171.602138] CS:  00=
10
> DS: 0000 ES: 0000 CR0: 0000000080050033 [  171.630792] CR2:
> 0000000000000010 CR3: 00000005cec09005 CR4: 00000000001606e0 [
> 171.666624] Call Trace:
> > [  171.678579]  <IRQ>
> > [  171.688847]  try_to_wake_up+0x15d/0x440 [  171.707708]
> > default_wake_function+0x12/0x20 [  171.728711]
> > __wake_up_common+0x8a/0x160 [  171.747913]
> __wake_up_locked+0x16/0x20
> > [  171.766944]  ep_poll_callback+0xd0/0x300 [  171.786061]  ?
> > find_next_bit+0xb/0x10 [  171.804356]  __wake_up_common+0x8a/0x160
> [
> > 171.823705]  __wake_up_common_lock+0x7e/0xc0 [  171.844238]
> > __wake_up+0x13/0x20 [  171.860037]
> wake_up_klogd_work_func+0x40/0x60
> > [  171.881812]  irq_work_run_list+0x4d/0x70 [  171.900977]  ?
> > tick_sched_do_timer+0x70/0x70 [  171.921688]  irq_work_tick+0x40/0x50
> > [  171.939208]  update_process_times+0x42/0x60 [  171.959871]
> > tick_sched_handle+0x2d/0x60 [  171.979125]  tick_sched_timer+0x39/0x70
> > [  171.998012]  __hrtimer_run_queues+0xe5/0x230 [  172.019188]
> > hrtimer_interrupt+0xa8/0x1a0 [  172.038449]
> > smp_apic_timer_interrupt+0x5f/0x130
> > [  172.061660]  apic_timer_interrupt+0x9d/0xb0 [  172.082865]  </IRQ>
> > [  172.092655] RIP: 0010:panic+0x1fd/0x245 [  172.111274] RSP:
> > 0018:ffffbae6041c7b10 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff10 [
> > 172.148505] RAX: 0000000000000034 RBX: 0000000000000000 RCX:
> > 0000000000000006 [  172.183145] RDX: 0000000000000000 RSI:
> > 0000000000000092 RDI: ffff9f4b7f98e030 [  172.218508] RBP:
> > ffffbae6041c7b80 R08: 00000000fffffffe R09: 0000000000000c6d [
> > 172.253436] R10: 0000000000000005 R11: 0000000000000c6c R12:
> > ffffffff97a304c0 [  172.288829] R13: 0000000000000000 R14:
> > 0000000000000000 R15: 0000000000000046 [  172.323876]
> > oops_end+0xb8/0xd0 [  172.339074]  no_context+0x1a8/0x400 [
> > 172.355962]  __bad_area_nosemaphore+0xee/0x1d0 [  172.377507]
> > bad_area_nosemaphore+0x14/0x20 [  172.397830]
> > __do_page_fault+0x9a/0x4f0 [  172.416720]  ? __slab_free+0x9b/0x2c0 [
> > 172.434427]  do_page_fault+0x38/0x130 [  172.452423]
> > page_fault+0x22/0x30 [  172.468930] RIP:
> > 0010:rpcrdma_dma_unmap_regbuf+0xa/0x60 [rpcrdma] [  172.499075]
> RSP:
> > 0018:ffffbae6041c7dd0 EFLAGS: 00010287 [  172.524585] RAX:
> > ffff9f476aa18220 RBX: ffff9f476aa18000 RCX: 0000000000000001 [
> > 172.559900] RDX: 0000000000000184 RSI: 000000046c1ba100 RDI:
> > 0000000000000000 [  172.594323] RBP: ffffbae6041c7dd8 R08:
> > 0000000000000000 R09: 000000018020001e [  172.628972] R10:
> > 000000006b2c6601 R11: ffff9f476b2c6400 R12: ffff9f4768295550 [
> > 172.664614] R13: ffff9f4768295878 R14: ffff9f47682958e0 R15:
> > ffff9f47682953d0 [  172.699424]  rpcrdma_ia_remove+0xca/0x110
> > [rpcrdma] [  172.723165]  xprt_rdma_close+0x70/0x90 [rpcrdma] [
> > 172.745492]  xprt_autoclose+0x38/0x70 [sunrpc] [  172.766956]
> > process_one_work+0x149/0x360 [  172.786682]
> worker_thread+0x4d/0x3e0
> > [  172.804538]  kthread+0x109/0x140 [  172.820117]  ?
> > rescuer_thread+0x380/0x380 [  172.839845]  ? kthread_park+0x60/0x60 [
> > 172.857255]  ret_from_fork+0x25/0x30 [  172.874616] Code: ff 80 8b ec
> > 07 00 00 04 e9 23 ff ff ff 0f ff e9 bf fe ff ff f7 83 84 00 00 00 fd
> > ff ff ff 0f 84 c9 fe ff ff 0f ff e9 c2 fe ff ff <0f> ff e9 d1 fe ff ff
> > 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 [  172.964520] ---[ end trace
> 0f69dc0bd121b691 ]--- [  172.986715] sched: Unexpected reschedule of
> offline CPU#8!
> > [  173.013434] ------------[ cut here ]------------ [  173.036387]
> > WARNING: CPU: 30 PID: 2798 at arch/x86/kernel/smp.c:128
> > native_smp_send_reschedule+0x3c/0x40
> > [  173.084056] Modules linked in: nfsv3 rpcsec_gss_krb5 nfsv4
> > dns_resolver nfs fscache rpcrdma ib_isert iscsi_target_mod ib_iser libi=
scsi
> scsi_transport_iscsi ib_srpt target_core_mod ib_srp scsi_transport_srp
> ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm 8021q
> garp mrp qedr(-) ib_core xt_CHECKSUM iptable_mangle ipt_MASQUERADE
> nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4
> nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 tun
> bridge stp llc fuse ebtable_filter ebtables ip6table_filter ip6_tables
> iptable_filter dm_mirror dm_region_hash dm_log dm_mod dax vfat fat
> intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel
> kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc
> aesni_intel sg iTCO_wdt hpilo crypto_simd iTCO_vendor_support [
> 173.436980]  i2c_i801 glue_helper hpwdt cryptd ioatdma pcspkr lpc_ich
> ipmi_si shpchp i2c_core wmi dca pcc_cpufreq acpi_power_meter
> ipmi_devintf mfd_core ipmi_msghandler nfsd auth_rpcgss nfs_acl lockd
> grace sunrpc ip_tables xfs libcrc32c qede sd_mod qed tg3 ptp crc32c_intel
> hpsa pps_core scsi_transport_sas
> > [  173.571732] CPU: 30 PID: 2798 Comm: kworker/30:1H Tainted: G      D =
W
> 4.14.0-rc8+ #1
> > [  173.612509] Hardware name: HP ProLiant DL380 Gen9/ProLiant DL380
> > Gen9, BIOS P89 02/17/2017 [  173.652963] Workqueue: xprtiod
> > xprt_autoclose [sunrpc] [  173.676765] task: ffff9f4b6966c380
> > task.stack: ffffbae6041c4000 [  173.705121] RIP:
> > 0010:native_smp_send_reschedule+0x3c/0x40
> > [  173.732678] RSP: 0018:ffff9f4b7f983bc0 EFLAGS: 00010046 [
> > 173.758761] RAX: 000000000000002e RBX: 0000000000000008 RCX:
> > 0000000000000006 [  173.793600] RDX: 0000000000000000 RSI:
> > 0000000000000096 RDI: ffff9f4b7f98e030 [  173.828260] RBP:
> > ffff9f4b7f983bc0 R08: 00000000fffffffe R09: 0000000000000cb8 [
> > 173.863983] R10: 0000000000000005 R11: 0000000000000cb7 R12:
> > ffff9f4b7f61bb80 [  173.898845] R13: ffff9f4b66652d00 R14:
> > ffff9f4b7f983c78 R15: ffff9f4b7f61bb80 [  173.933362] FS:
> > 0000000000000000(0000) GS:ffff9f4b7f980000(0000)
> > knlGS:0000000000000000 [  173.973149] CS:  0010 DS: 0000 ES: 0000 CR0:
> 0000000080050033 [  174.001483] CR2: 0000000000000010 CR3:
> 00000005cec09005 CR4: 00000000001606e0 [  174.036495] Call Trace:
> > [  174.048417]  <IRQ>
> > [  174.058474]  resched_curr+0xa1/0xc0 [  174.075648]
> > check_preempt_curr+0x79/0x90 [  174.095247]
> ttwu_do_wakeup+0x1e/0x160
> > [  174.113663]  ttwu_do_activate+0x7a/0x90 [  174.132487]
> > try_to_wake_up+0x1d4/0x440 [  174.151326]
> > default_wake_function+0x12/0x20 [  174.172536]
> > __wake_up_common+0x8a/0x160 [  174.191867]
> __wake_up_locked+0x16/0x20
> > [  174.210537]  ep_poll_callback+0xd0/0x300 [  174.230062]  ?
> > find_next_bit+0xb/0x10 [  174.248307]  __wake_up_common+0x8a/0x160
> [
> > 174.267633]  __wake_up_common_lock+0x7e/0xc0 [  174.288376]
> > __wake_up+0x13/0x20 [  174.305441]
> wake_up_klogd_work_func+0x40/0x60
> > [  174.327468]  irq_work_run_list+0x4d/0x70 [  174.346526]  ?
> > tick_sched_do_timer+0x70/0x70 [  174.366836]  irq_work_tick+0x40/0x50
> > [  174.384200]  update_process_times+0x42/0x60 [  174.404774]
> > tick_sched_handle+0x2d/0x60 [  174.424463]  tick_sched_timer+0x39/0x70
> > [  174.443012]  __hrtimer_run_queues+0xe5/0x230 [  174.464378]
> > hrtimer_interrupt+0xa8/0x1a0 [  174.484072]
> > smp_apic_timer_interrupt+0x5f/0x130
> > [  174.506656]  apic_timer_interrupt+0x9d/0xb0 [  174.527140]  </IRQ>
> > [  174.537197] RIP: 0010:panic+0x1fd/0x245 [  174.556508] RSP:
> > 0018:ffffbae6041c7b10 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff10 [
> > 174.594707] RAX: 0000000000000034 RBX: 0000000000000000 RCX:
> > 0000000000000006 [  174.629573] RDX: 0000000000000000 RSI:
> > 0000000000000092 RDI: ffff9f4b7f98e030 [  174.664900] RBP:
> > ffffbae6041c7b80 R08: 00000000fffffffe R09: 0000000000000c6d [
> > 174.699889] R10: 0000000000000005 R11: 0000000000000c6c R12:
> > ffffffff97a304c0 [  174.734379] R13: 0000000000000000 R14:
> > 0000000000000000 R15: 0000000000000046 [  174.768961]
> > oops_end+0xb8/0xd0 [  174.784712]  no_context+0x1a8/0x400 [
> > 174.802290]  __bad_area_nosemaphore+0xee/0x1d0 [  174.823836]
> > bad_area_nosemaphore+0x14/0x20 [  174.844449]
> > __do_page_fault+0x9a/0x4f0 [  174.863790]  ? __slab_free+0x9b/0x2c0 [
> > 174.881658]  do_page_fault+0x38/0x130 [  174.899896]
> > page_fault+0x22/0x30 [  174.916071] RIP:
> > 0010:rpcrdma_dma_unmap_regbuf+0xa/0x60 [rpcrdma] [  174.945525]
> RSP:
> > 0018:ffffbae6041c7dd0 EFLAGS: 00010287 [  174.971363] RAX:
> > ffff9f476aa18220 RBX: ffff9f476aa18000 RCX: 0000000000000001 [
> > 175.006604] RDX: 0000000000000184 RSI: 000000046c1ba100 RDI:
> > 0000000000000000 [  175.041286] RBP: ffffbae6041c7dd8 R08:
> > 0000000000000000 R09: 000000018020001e [  175.075703] R10:
> > 000000006b2c6601 R11: ffff9f476b2c6400 R12: ffff9f4768295550 [
> > 175.109678] R13: ffff9f4768295878 R14: ffff9f47682958e0 R15:
> > ffff9f47682953d0 [  175.143959]  rpcrdma_ia_remove+0xca/0x110
> > [rpcrdma] [  175.167172]  xprt_rdma_close+0x70/0x90 [rpcrdma] [
> > 175.188870]  xprt_autoclose+0x38/0x70 [sunrpc] [  175.209659]
> > process_one_work+0x149/0x360 [  175.229048]
> worker_thread+0x4d/0x3e0
> > [  175.246899]  kthread+0x109/0x140 [  175.262894]  ?
> > rescuer_thread+0x380/0x380 [  175.282497]  ? kthread_park+0x60/0x60 [
> > 175.301315]  ret_from_fork+0x25/0x30 [  175.318548] Code: db 00 0f 92
> > c0 84 c0 74 14 48 8b 05 cf bf a9 00 be fd 00 00 00 ff 90 a0 00 00 00
> > 5d c3 89 fe 48 c7 c7 d0 74 a3 97 e8 57 7f 09 00 <0f> ff 5d c3 0f 1f 44
> > 00 00 55 48 89 e5 48 83 ec 20 65 48 8b 04 [  175.411188] ---[ end
> > trace 0f69dc0bd121b692 ]--- [  175.434569] unchecked MSR access error:
> WRMSR to 0x83f (tried to write 0x00000000000000f6) at rIP:
> 0xffffffff97064044 (native_write_msr+0x4/0x30) [  175.497555] Call Trace:
> > [  175.509756]  <IRQ>
> > [  175.519920]  ? native_apic_msr_write+0x30/0x40 [  175.541602]
> > x2apic_send_IPI_self+0x1d/0x20 [  175.562384]
> > arch_irq_work_raise+0x28/0x40 [  175.582084]
> irq_work_queue+0x6e/0x80
> > [  175.600412]  dbs_update_util_handler+0x8a/0xb0 [  175.621994]
> > task_tick_fair+0x6cb/0x7f0 [  175.640991]  scheduler_tick+0x62/0xe0 [
> > 175.659042]  ? tick_sched_do_timer+0x70/0x70 [  175.679307]
> > update_process_times+0x47/0x60 [  175.699836]
> > tick_sched_handle+0x2d/0x60 [  175.718917]  tick_sched_timer+0x39/0x70
> > [  175.737191]  __hrtimer_run_queues+0xe5/0x230 [  175.757635]
> > hrtimer_interrupt+0xa8/0x1a0 [  175.777022]
> > smp_apic_timer_interrupt+0x5f/0x130
> > [  175.799455]  apic_timer_interrupt+0x9d/0xb0 [  175.819696]  </IRQ>
> > [  175.830023] RIP: 0010:panic+0x1fd/0x245 [  175.849324] RSP:
> > 0018:ffffbae6041c7b10 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff10 [
> > 175.886349] RAX: 0000000000000034 RBX: 0000000000000000 RCX:
> > 0000000000000006 [  175.921984] RDX: 0000000000000000 RSI:
> > 0000000000000092 RDI: ffff9f4b7f98e030 [  175.957360] RBP:
> > ffffbae6041c7b80 R08: 00000000fffffffe R09: 0000000000000c6d [
> > 175.992424] R10: 0000000000000005 R11: 0000000000000c6c R12:
> > ffffffff97a304c0 [  176.027292] R13: 0000000000000000 R14:
> > 0000000000000000 R15: 0000000000000046 [  176.062516]
> > oops_end+0xb8/0xd0 [  176.078137]  no_context+0x1a8/0x400 [
> > 176.095725]  __bad_area_nosemaphore+0xee/0x1d0 [  176.117534]
> > bad_area_nosemaphore+0x14/0x20 [  176.137970]
> > __do_page_fault+0x9a/0x4f0 [  176.156564]  ? __slab_free+0x9b/0x2c0 [
> > 176.174433]  do_page_fault+0x38/0x130 [  176.192638]
> > page_fault+0x22/0x30 [  176.209165] RIP:
> > 0010:rpcrdma_dma_unmap_regbuf+0xa/0x60 [rpcrdma] [  176.239509]
> RSP:
> > 0018:ffffbae6041c7dd0 EFLAGS: 00010287 [  176.266224] RAX:
> > ffff9f476aa18220 RBX: ffff9f476aa18000 RCX: 0000000000000001 [
> > 176.302139] RDX: 0000000000000184 RSI: 000000046c1ba100 RDI:
> > 0000000000000000 [  176.339413] RBP: ffffbae6041c7dd8 R08:
> > 0000000000000000 R09: 000000018020001e [  176.375049] R10:
> > 000000006b2c6601 R11: ffff9f476b2c6400 R12: ffff9f4768295550 [
> > 176.410088] R13: ffff9f4768295878 R14: ffff9f47682958e0 R15:
> > ffff9f47682953d0 [  176.446853]  rpcrdma_ia_remove+0xca/0x110
> > [rpcrdma] [  176.471509]  xprt_rdma_close+0x70/0x90 [rpcrdma] [
> > 176.494036]  xprt_autoclose+0x38/0x70 [sunrpc] [  176.515339]
> > process_one_work+0x149/0x360 [  176.534945]
> worker_thread+0x4d/0x3e0
> > [  176.553011]  kthread+0x109/0x140 [  176.568810]  ?
> > rescuer_thread+0x380/0x380 [  176.588222]  ? kthread_park+0x60/0x60 [
> > 176.606412]  ret_from_fork+0x25/0x30 [  176.624241] sched: Unexpected
> > reschedule of offline CPU#0!
> > [  176.651713] ------------[ cut here ]------------ [  176.675084]
> > WARNING: CPU: 30 PID: 2798 at arch/x86/kernel/smp.c:128
> > native_smp_send_reschedule+0x3c/0x40
> > [  176.721703] Modules linked in: nfsv3 rpcsec_gss_krb5 nfsv4
> > dns_resolver nfs fscache rpcrdma ib_isert iscsi_target_mod ib_iser libi=
scsi
> scsi_transport_iscsi ib_srpt target_core_mod ib_srp scsi_transport_srp
> ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm 8021q
> garp mrp qedr(-) ib_core xt_CHECKSUM iptable_mangle ipt_MASQUERADE
> nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4
> nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 tun
> bridge stp llc fuse ebtable_filter ebtables ip6table_filter ip6_tables
> iptable_filter dm_mirror dm_region_hash dm_log dm_mod dax vfat fat
> intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel
> kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc
> aesni_intel sg iTCO_wdt hpilo crypto_simd iTCO_vendor_support [
> 177.076380]  i2c_i801 glue_helper hpwdt cryptd ioatdma pcspkr lpc_ich
> ipmi_si shpchp i2c_core wmi dca pcc_cpufreq acpi_power_meter
> ipmi_devintf mfd_core ipmi_msghandler nfsd auth_rpcgss nfs_acl lockd
> grace sunrpc ip_tables xfs libcrc32c qede sd_mod qed tg3 ptp crc32c_intel
> hpsa pps_core scsi_transport_sas
> > [  177.209069] CPU: 30 PID: 2798 Comm: kworker/30:1H Tainted: G      D =
W
> 4.14.0-rc8+ #1
> > [  177.250754] Hardware name: HP ProLiant DL380 Gen9/ProLiant DL380
> > Gen9, BIOS P89 02/17/2017 [  177.290959] Workqueue: xprtiod
> > xprt_autoclose [sunrpc] [  177.315723] task: ffff9f4b6966c380
> > task.stack: ffffbae6041c4000 [  177.345409] RIP:
> > 0010:native_smp_send_reschedule+0x3c/0x40
> > [  177.372066] RSP: 0018:ffff9f4b7f983e60 EFLAGS: 00010046 [
> > 177.396735] RAX: 000000000000002e RBX: 0000000000000000 RCX:
> > 0000000000000000 [  177.430540] RDX: 0000000000000000 RSI:
> > ffff9f4b7f98e038 RDI: ffff9f4b7f98e038 [  177.464537] RBP:
> > ffff9f4b7f983e60 R08: 00000000fffffffe R09: 0000000000000d39 [
> > 177.499327] R10: 0000000000000005 R11: 0000000000000d38 R12:
> > 000000000000001e [  177.534782] R13: 00000000fffe07b2 R14:
> > ffff9f4b6966c380 R15: ffff9f4b7f994768 [  177.569257] FS:
> > 0000000000000000(0000) GS:ffff9f4b7f980000(0000)
> > knlGS:0000000000000000 [  177.609059] CS:  0010 DS: 0000 ES: 0000 CR0:
> 0000000080050033 [  177.637131] CR2: 0000000000000010 CR3:
> 00000005cec09005 CR4: 00000000001606e0 [  177.672422] Call Trace:
> > [  177.684361]  <IRQ>
> > [  177.693996]  trigger_load_balance+0x105/0x1f0 [  177.715180]
> > scheduler_tick+0xab/0xe0 [  177.733058]  ?
> > tick_sched_do_timer+0x70/0x70 [  177.754008]
> > update_process_times+0x47/0x60 [  177.774941]
> > tick_sched_handle+0x2d/0x60 [  177.793687]  tick_sched_timer+0x39/0x70
> > [  177.812071]  __hrtimer_run_queues+0xe5/0x230 [  177.832929]
> > hrtimer_interrupt+0xa8/0x1a0 [  177.852686]
> > smp_apic_timer_interrupt+0x5f/0x130
> > [  177.875204]  apic_timer_interrupt+0x9d/0xb0 [  177.895378]  </IRQ>
> > [  177.905441] RIP: 0010:panic+0x1fd/0x245 [  177.923668] RSP:
> > 0018:ffffbae6041c7b10 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff10 [
> > 177.960074] RAX: 0000000000000034 RBX: 0000000000000000 RCX:
> > 0000000000000006 [  177.995687] RDX: 0000000000000000 RSI:
> > 0000000000000092 RDI: ffff9f4b7f98e030 [  178.031336] RBP:
> > ffffbae6041c7b80 R08: 00000000fffffffe R09: 0000000000000c6d [
> > 178.066983] R10: 0000000000000005 R11: 0000000000000c6c R12:
> > ffffffff97a304c0 [  178.102127] R13: 0000000000000000 R14:
> > 0000000000000000 R15: 0000000000000046 [  178.136976]
> > oops_end+0xb8/0xd0 [  178.152223]  no_context+0x1a8/0x400 [
> > 178.169104]  __bad_area_nosemaphore+0xee/0x1d0 [  178.191361]
> > bad_area_nosemaphore+0x14/0x20 [  178.211956]
> > __do_page_fault+0x9a/0x4f0 [  178.231161]  ? __slab_free+0x9b/0x2c0 [
> > 178.248982]  do_page_fault+0x38/0x130 [  178.267162]
> > page_fault+0x22/0x30 [  178.283360] RIP:
> > 0010:rpcrdma_dma_unmap_regbuf+0xa/0x60 [rpcrdma] [  178.313151]
> RSP:
> > 0018:ffffbae6041c7dd0 EFLAGS: 00010287 [  178.339653] RAX:
> > ffff9f476aa18220 RBX: ffff9f476aa18000 RCX: 0000000000000001 [
> > 178.373929] RDX: 0000000000000184 RSI: 000000046c1ba100 RDI:
> > 0000000000000000 [  178.408422] RBP: ffffbae6041c7dd8 R08:
> > 0000000000000000 R09: 000000018020001e [  178.443865] R10:
> > 000000006b2c6601 R11: ffff9f476b2c6400 R12: ffff9f4768295550 [
> > 178.478532] R13: ffff9f4768295878 R14: ffff9f47682958e0 R15:
> > ffff9f47682953d0 [  178.514716]  rpcrdma_ia_remove+0xca/0x110
> > [rpcrdma] [  178.539078]  xprt_rdma_close+0x70/0x90 [rpcrdma] [
> > 178.561619]  xprt_autoclose+0x38/0x70 [sunrpc] [  178.583680]
> > process_one_work+0x149/0x360 [  178.603772]
> worker_thread+0x4d/0x3e0
> > [  178.621660]  kthread+0x109/0x140 [  178.637765]  ?
> > rescuer_thread+0x380/0x380 [  178.657000]  ? kthread_park+0x60/0x60 [
> > 178.674977]  ret_from_fork+0x25/0x30 [  178.692351] Code: db 00 0f 92
> > c0 84 c0 74 14 48 8b 05 cf bf a9 00 be fd 00 00 00 ff 90 a0 00 00 00
> > 5d c3 89 fe 48 c7 c7 d0 74 a3 97 e8 57 7f 09 00 <0f> ff 5d c3 0f 1f 44
> > 00 00 55 48 89 e5 48 83 ec 20 65 48 8b 04 [  178.784645] ---[ end
> > trace 0f69dc0bd121b693 ]---
> >
> >>
> >>> If I check buf for NULL and return false I am able to unload the
> >>> driver,
> >> though I'm not sure this is sufficient.
> >>>
> >>> diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h
> >>> b/net/sunrpc/xprtrdma/xprt_rdma.h index 1342f743..73066a6 100644
> >>> --- a/net/sunrpc/xprtrdma/xprt_rdma.h
> >>> +++ b/net/sunrpc/xprtrdma/xprt_rdma.h
> >>> @@ -588,7 +588,7 @@ struct rpcrdma_regbuf
> >>> *rpcrdma_alloc_regbuf(size_t, enum dma_data_direction, static inline
> >>> bool rpcrdma_regbuf_is_mapped(struct rpcrdma_regbuf *rb) {
> >>> -       return rb->rg_device !=3D NULL;
> >>> +       return rb && (rb->rg_device !=3D NULL);
> >>> :
> >>>
> >>>
> >>> Will be great if you could take a look Thanks, Michal
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> >>> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More
> >> majordomo
> >>> info at  http://vger.kernel.org/majordomo-info.html
> >>
> >> --
> >> Chuck Lever
> >>
> >>
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> > in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More
> majordomo
> > info at  http://vger.kernel.org/majordomo-info.html
>=20
> --
> Chuck Lever
>=20
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
