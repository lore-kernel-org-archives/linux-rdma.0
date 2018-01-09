From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Kernel v4.16 / v4.17 SRP and SRPT patches
Date: Tue, 09 Jan 2018 17:40:14 -0500
Message-ID: <1515537614.26021.3.camel@redhat.com>
References: <5a5016c0.4c0a620a.ed2b3.60da@mx.google.com>
         <fcc3f226-848d-abc4-2a81-f4fd821761c9@wdc.com>
         <1515528956.3919.3.camel@redhat.com> <1515529869.3919.4.camel@redhat.com>
         <1515531079.2721.26.camel@wdc.com> <1515531652.26021.1.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1515531652.26021.1.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2018-01-09 at 16:00 -0500, Laurence Oberman wrote:
> On Tue, 2018-01-09 at 20:51 +0000, Bart Van Assche wrote:
> > On Tue, 2018-01-09 at 15:31 -0500, Laurence Oberman wrote:
> > > On Tue, 2018-01-09 at 15:15 -0500, Laurence Oberman wrote:
> > > > [  220.843344] ------------[ cut here ]------------
> > > > [  220.869309] list_add corruption. prev->next should be next
> > > > (000000002a07d255), but was           (null).
> > > > (prev=000000000edf5e8c).
> > > > [  220.935392] WARNING: CPU: 1 PID: 694 at lib/list_debug.c:28
> > > > __list_add_valid+0x6a/0x70
> > > > [  220.979462] Modules linked in: xt_CHECKSUM iptable_mangle
> > > > ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4
> > > > nf_nat
> > > > nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack
> > > > ipt_REJECT
> > > > nf_reject_ipv4 tun bridge stp llc ebtable_filter ebtables
> > > > ip6table_filter ip6_tables iptable_filter rpcrdma ib_isert
> > > > iscsi_target_mod target_core_mod ib_iser libiscsi
> > > > scsi_transport_iscsi
> > > > ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs
> > > > ib_umad
> > > > rdma_cm ib_cm iw_cm mlx5_ib ib_core intel_powerclamp coretemp
> > > > kvm_intel
> > > > kvm irqbypass crct10dif_pclmul crc32_pclmul ipmi_ssif
> > > > ghash_clmulni_intel pcbc aesni_intel joydev ipmi_si crypto_simd
> > > > dm_service_time iTCO_wdt hpwdt iTCO_vendor_support glue_helper
> > > > cryptd
> > > > ipmi_devintf sg gpio_ich pcspkr hpilo ipmi_msghandler lpc_ich
> > > > acpi_power_meter i7core_edac shpchp
> > > > [  221.385270]  pcc_cpufreq nfsd auth_rpcgss nfs_acl lockd
> > > > grace
> > > > sunrpc
> > > > dm_multipath ip_tables xfs libcrc32c radeon i2c_algo_bit
> > > > drm_kms_helper
> > > > syscopyarea sysfillrect sysimgblt fb_sys_fops ttm mlx5_core
> > > > mlxfw
> > > > sd_mod drm ptp hpsa pps_core crc32c_intel i2c_core serio_raw
> > > > bnx2
> > > > devlink scsi_transport_sas dm_mirror dm_region_hash dm_log
> > > > dm_mod
> > > > [  221.554496] CPU: 1 PID: 694 Comm: kworker/1:1H Tainted:
> > > > G          I      4.15.0-rc7+ #1
> > > > [  221.606907] Hardware name: HP ProLiant DL380 G7, BIOS P67
> > > > 08/16/2015
> > > > [  221.642980] Workqueue: ib-comp-wq ib_cq_poll_work [ib_core]
> > > > [  221.674616] RIP: 0010:__list_add_valid+0x6a/0x70
> > > > [  221.700561] RSP: 0018:ffffb2bdc75c7cf0 EFLAGS: 00010086
> > > > [  221.730608] RAX: 0000000000000000 RBX: ffff94342d610880 RCX:
> > > > ffffffff8ba62928
> > > > [  221.771490] RDX: 0000000000000001 RSI: 0000000000000082 RDI:
> > > > 0000000000000046
> > > > [  221.812721] RBP: ffff94342d6108b8 R08: 0000000000000000 R09:
> > > > 0000000000000722
> > > > [  221.853073] R10: 0000000000000000 R11: ffffb2bdc75c7a58 R12:
> > > > 0000000000000200
> > > > [  221.894156] R13: 0000000000000246 R14: ffff943fb7fd5000 R15:
> > > > ffff943fb7fd5000
> > > > [  221.935233] FS:  0000000000000000(0000)
> > > > GS:ffff944033200000(0000)
> > > > knlGS:0000000000000000
> > > > [  221.980521] CS:  0010 DS: 0000 ES: 0000 CR0:
> > > > 0000000080050033
> > > > [  222.013062] CR2: 00007f1bdc0ee910 CR3: 00000017e7e0a002 CR4:
> > > > 00000000000206e0
> > > > [  222.052302] Call Trace:
> > > > [  222.065971]  ib_mad_post_receive_mads+0x177/0x310 [ib_core]
> > > > [  222.097349]  ib_mad_recv_done+0x471/0x9c0 [ib_core]
> > > > [  222.124387]  __ib_process_cq+0x55/0xa0 [ib_core]
> > > > [  222.150827]  ib_cq_poll_work+0x1b/0x60 [ib_core]
> > > > [  222.177751]  process_one_work+0x141/0x340
> > > > [  222.200383]  worker_thread+0x47/0x3e0
> > > > [  222.220641]  kthread+0xf5/0x130
> > > > [  222.238951]  ? rescuer_thread+0x380/0x380
> > > > [  222.262034]  ? kthread_associate_blkcg+0x90/0x90
> > > > [  222.288514]  ? do_group_exit+0x39/0xa0
> > > > [  222.309492]  ret_from_fork+0x1f/0x30
> > > > [  222.330073] Code: fe 31 c0 48 c7 c7 98 36 89 8b e8 02 9c cf
> > > > ff
> > > > 0f
> > > > ff
> > > > 31 c0 c3 48 89 d1 48 c7 c7 48 36 89 8b 48 89 f2 48 89 c6 31 c0
> > > > e8
> > > > e6
> > > > 9b
> > > > cf ff <0f> ff 31 c0 c3 90 48 8b 07 48 b9 00 01 00 00 00 00 ad
> > > > de
> > > > 48
> > > > 8b 
> > > > [  222.438058] ---[ end trace 5d41544bf17ab73b ]---
> > > > [  222.465993] BUG: unable to handle kernel NULL pointer
> > > > dereference
> > > > at
> > > > 0000000000000028
> > > > [  222.510316] IP: ib_mad_post_receive_mads+0x3c/0x310
> > > > [ib_core]
> > > > [  222.543188] PGD 0 P4D 0 
> > > > [  222.557625] Oops: 0000 [#1] SMP PTI
> > > > [  222.576674] Modules linked in: xt_CHECKSUM iptable_mangle
> > > > ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4
> > > > nf_nat
> > > > nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack
> > > > ipt_REJECT
> > > > nf_reject_ipv4 tun bridge stp llc ebtable_filter ebtables
> > > > ip6table_filter ip6_tables iptable_filter rpcrdma ib_isert
> > > > iscsi_target_mod target_core_mod ib_iser libiscsi
> > > > scsi_transport_iscsi
> > > > ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs
> > > > ib_umad
> > > > rdma_cm ib_cm iw_cm mlx5_ib ib_core intel_powerclamp coretemp
> > > > kvm_intel
> > > > kvm irqbypass crct10dif_pclmul crc32_pclmul ipmi_ssif
> > > > ghash_clmulni_intel pcbc aesni_intel joydev ipmi_si crypto_simd
> > > > dm_service_time iTCO_wdt hpwdt iTCO_vendor_support glue_helper
> > > > cryptd
> > > > ipmi_devintf sg gpio_ich pcspkr hpilo ipmi_msghandler lpc_ich
> > > > acpi_power_meter i7core_edac shpchp
> > > > [  222.981443]  pcc_cpufreq nfsd auth_rpcgss nfs_acl lockd
> > > > grace
> > > > sunrpc
> > > > dm_multipath ip_tables xfs libcrc32c radeon i2c_algo_bit
> > > > drm_kms_helper
> > > > syscopyarea sysfillrect sysimgblt fb_sys_fops ttm mlx5_core
> > > > mlxfw
> > > > sd_mod drm ptp hpsa pps_core crc32c_intel i2c_core serio_raw
> > > > bnx2
> > > > devlink scsi_transport_sas dm_mirror dm_region_hash dm_log
> > > > dm_mod
> > > > [  223.152359] CPU: 1 PID: 694 Comm: kworker/1:1H Tainted:
> > > > G        W
> > > > I      4.15.0-rc7+ #1
> > > > [  223.198577] Hardware name: HP ProLiant DL380 G7, BIOS P67
> > > > 08/16/2015
> > > > [  223.235101] Workqueue: ib-comp-wq ib_cq_poll_work [ib_core]
> > > > [  223.266750] RIP: 0010:ib_mad_post_receive_mads+0x3c/0x310
> > > > [ib_core]
> > > > [  223.303012] RSP: 0018:ffffb2bdc75c7cf8 EFLAGS: 00010286
> > > > [  223.333022] RAX: 0000000000000000 RBX: ffff94342d610908 RCX:
> > > > ffff94342d610948
> > > > [  223.373307] RDX: 0000000000000001 RSI: ffff94342d6108c0 RDI:
> > > > ffff94342d610908
> > > > [  223.414451] RBP: ffff94342d610940 R08: ffff94342a8e64c0 R09:
> > > > ffff94342a8e64e8
> > > > [  223.454789] R10: ffff94342a8e64e8 R11: ffff94342d6109a8 R12:
> > > > ffff944029c2e048
> > > > [  223.496554] R13: 0000000000000000 R14: ffff94342a8e64c0 R15:
> > > > ffff94342d6108c0
> > > > [  223.537489] FS:  0000000000000000(0000)
> > > > GS:ffff944033200000(0000)
> > > > knlGS:0000000000000000
> > > > [  223.583538] CS:  0010 DS: 0000 ES: 0000 CR0:
> > > > 0000000080050033
> > > > [  223.616545] CR2: 0000000000000028 CR3: 00000017e7e0a002 CR4:
> > > > 00000000000206e0
> > > > [  223.657337] Call Trace:
> > > > [  223.671022]  ? find_mad_agent+0x77/0x1b0 [ib_core]
> > > > [  223.698581]  ? __kmalloc+0x1be/0x1f0
> > > > [  223.719074]  ib_mad_recv_done+0x471/0x9c0 [ib_core]
> > > > [  223.747190]  __ib_process_cq+0x55/0xa0 [ib_core]
> > > > [  223.774140]  ib_cq_poll_work+0x1b/0x60 [ib_core]
> > > > [  223.800719]  process_one_work+0x141/0x340
> > > > [  223.824120]  worker_thread+0x47/0x3e0
> > > > [  223.845133]  kthread+0xf5/0x130
> > > > [  223.863116]  ? rescuer_thread+0x380/0x380
> > > > [  223.886173]  ? kthread_associate_blkcg+0x90/0x90
> > > > [  223.912207]  ? do_group_exit+0x39/0xa0
> > > > [  223.933198]  ret_from_fork+0x1f/0x30
> > > > [  223.953218] Code: 55 41 54 55 48 8d 6f 38 53 48 89 fb 48 83
> > > > ec
> > > > 50
> > > > 65
> > > > 48 8b 04 25 28 00 00 00 48 89 44 24 48 31 c0 48 8b 07 48 85 f6
> > > > 48
> > > > 89
> > > > 4c
> > > > 24 08 <48> 8b 50 28 8b 12 48 c7 44 24 28 00 00 00 00 c7 44 24
> > > > 40
> > > > 01
> > > > 00 
> > > > [  224.059985] RIP: ib_mad_post_receive_mads+0x3c/0x310
> > > > [ib_core]
> > > > RSP:
> > > > ffffb2bdc75c7cf8
> > > > [  224.103994] CR2: 0000000000000028
> > > 
> > > Just wanted to add that the panic is consistent, rebooted into
> > > only
> > > a
> > > single path to my SRP LUNS and on reboot had the same panic.
> > 
> > Hello Laurence,
> > kernsl
> > Can you repeat your test with the following two kernels:
> > * v4.15-rc7 (Linus' latest).
> > * The for-next branch of
> > git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git.
> > 
> > I'm asking this because the crash occurred in a code path that is
> > not
> > modified by
> > any of my patches.
> > 
> > Thanks,
> > 
> > Bart.NrybXǧv^)޺{.n+{ٚ{ay
ʇڙ,jfhz
w
j:+vwjmzZ+ݢj"!
> 
> Bart, Yep, I saw it was not in code you touched specific to your
> patches.
> 
> Doing that now, although I had already tested 4.15.0-rc4 from Mike
> Snitzers tree that only had NVME changes in it and did not see it.
> So maybe it crept in in the kernels you mentioned.
> 
> Its clearly in the ib_mad_xxxx code.
> 
> I will baseline again on the ones you asked me to test with
> v4.15-rc7 (Linus' latest).
> The for-next branch of
> > git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git
> 
> Back later
> Regards
> Laurence

Interesting

On Linus's kernel we don't panic, but we see this below
I will reboot one more time, validate same behavior and then try the
rdma tree
I am pretty sure there are changes in that RDMA tree that piggy back on
the below scenario to trigger the panic.
And I know Bart you have the RDMA stuff pulled in to yours.

If needed I can capture a vmcore to fully triage the panic.

Rebooting.
[ 1358.714127] sd 1:0:0:1: [sdbk] Synchronizing SCSI cache
[ 1358.744171] sd 1:0:0:2: [sdbj] Synchronizing SCSI cache
[ 1358.773412] sd 1:0:0:3: [sdbi] Synchronizing SCSI cache
[ 1358.803791] sd 1:0:0:4: [sdbh] Synchronizing SCSI cache
[ 1358.833925] sd 1:0:0:5: [sdbg] Synchronizing SCSI cache
[ 1358.864175] sd 1:0:0:6: [sdbf] Synchronizing SCSI cache
[ 1358.893766] sd 1:0:0:7: [sdbe] Synchronizing SCSI cache
[ 1358.924356] sd 1:0:0:8: [sdbd] Synchronizing SCSI cache
[ 1358.954940] sd 1:0:0:9: [sdbc] Synchronizing SCSI cache
[ 1358.985734] sd 1:0:0:10: [sdbb] Synchronizing SCSI cache
[ 1359.015816] sd 1:0:0:11: [sdba] Synchronizing SCSI cache
[ 1359.046156] sd 1:0:0:12: [sdaz] Synchronizing SCSI cache
[ 1359.076851] sd 1:0:0:13: [sday] Synchronizing SCSI cache
[ 1359.106872] sd 1:0:0:14: [sdax] Synchronizing SCSI cache
[ 1359.137053] sd 1:0:0:15: [sdaw] Synchronizing SCSI cache
[ 1359.167544] sd 1:0:0:16: [sdav] Synchronizing SCSI cache
[ 1359.197517] sd 1:0:0:17: [sdau] Synchronizing SCSI cache
[ 1359.229360] sd 1:0:0:18: [sdat] Synchronizing SCSI cache
[ 1359.258470] sd 1:0:0:19: [sdas] Synchronizing SCSI cache
[ 1359.286950] sd 1:0:0:20: [sdar] Synchronizing SCSI cache
[ 1359.317636] sd 1:0:0:21: [sdaq] Synchronizing SCSI cache
[ 1359.348601] sd 1:0:0:22: [sdap] Synchronizing SCSI cache
[ 1359.379196] sd 1:0:0:23: [sdao] Synchronizing SCSI cache
[ 1359.409689] sd 1:0:0:24: [sdan] Synchronizing SCSI cache
[ 1359.440632] sd 1:0:0:25: [sdam] Synchronizing SCSI cache
[ 1359.470780] sd 1:0:0:26: [sdal] Synchronizing SCSI cache
[ 1359.501198] sd 1:0:0:27: [sdak] Synchronizing SCSI cache
[ 1359.531820] sd 1:0:0:28: [sdaj] Synchronizing SCSI cache
[ 1359.561622] sd 1:0:0:29: [sdai] Synchronizing SCSI cache
[ 1359.591658] sd 1:0:0:0: [sdah] Synchronizing SCSI cache
[ 1359.621801] sd 2:0:0:1: [sdag] Synchronizing SCSI cache
[ 1359.651696] sd 2:0:0:2: [sdaf] Synchronizing SCSI cache
[ 1359.681975] sd 2:0:0:3: [sdae] Synchronizing SCSI cache
[ 1359.712012] sd 2:0:0:4: [sdad] Synchronizing SCSI cache
[ 1359.741984] sd 2:0:0:5: [sdac] Synchronizing SCSI cache
[ 1359.771704] sd 2:0:0:6: [sdab] Synchronizing SCSI cache
[ 1359.801829] sd 2:0:0:7: [sdaa] Synchronizing SCSI cache
[ 1359.832076] sd 2:0:0:8: [sdz] Synchronizing SCSI cache
[ 1359.861697] sd 2:0:0:9: [sdy] Synchronizing SCSI cache
[ 1359.890470] sd 2:0:0:10: [sdx] Synchronizing SCSI cache
[ 1359.920747] sd 2:0:0:11: [sdw] Synchronizing SCSI cache
[ 1359.950125] sd 2:0:0:12: [sdv] Synchronizing SCSI cache
[ 1359.978736] sd 2:0:0:13: [sdu] Synchronizing SCSI cache
[ 1360.008490] sd 2:0:0:14: [sdt] Synchronizing SCSI cache
[ 1360.037894] sd 2:0:0:15: [sds] Synchronizing SCSI cache
[ 1360.067282] sd 2:0:0:16: [sdr] Synchronizing SCSI cache
[ 1360.095579] sd 2:0:0:17: [sdq] Synchronizing SCSI cache
[ 1360.125297] sd 2:0:0:18: [sdp] Synchronizing SCSI cache
[ 1360.154539] sd 2:0:0:19: [sdo] Synchronizing SCSI cache
[ 1360.184087] sd 2:0:0:20: [sdn] Synchronizing SCSI cache
[ 1360.213859] sd 2:0:0:21: [sdm] Synchronizing SCSI cache
[ 1360.243405] sd 2:0:0:22: [sdl] Synchronizing SCSI cache
[ 1360.272676] sd 2:0:0:23: [sdk] Synchronizing SCSI cache
[ 1360.303088] sd 2:0:0:24: [sdj] Synchronizing SCSI cache
[ 1360.332838] sd 2:0:0:25: [sdi] Synchronizing SCSI cache
[ 1360.362778] sd 2:0:0:26: [sdh] Synchronizing SCSI cache
[ 1360.392887] sd 2:0:0:27: [sdg] Synchronizing SCSI cache
[ 1360.422989] sd 2:0:0:28: [sdf] Synchronizing SCSI cache
[ 1360.452909] sd 2:0:0:29: [sde] Synchronizing SCSI cache
[ 1360.482103] sd 2:0:0:0: [sdd] Synchronizing SCSI cache
[ 1360.511682] mlx5_core 0000:08:00.1: Shutdown was called
[ 1360.550531] mlx5_core 0000:08:00.1: mlx5_enter_error_state:121:(pid
15149): start
[ 1360.593520] ------------[ cut here ]------------
[ 1360.619930] got unsolicited completion for CQ 0x0000000068694acd
[ 1360.654434] WARNING: CPU: 15 PID: 15149 at
drivers/infiniband/core/cq.c:80 ib_cq_completion_direct+0x28/0x30
[ib_core]
[ 1360.716099] Modules linked in: xt_CHECKSUM iptable_mangle
ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT
nf_reject_ipv4 tun bridge stp llc ebtable_filter ebtables
ip6table_filter ip6_tables iptable_filter rpcrdma ib_isert
iscsi_target_mod target_core_mod ib_iser libiscsi scsi_transport_iscsi
ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad
rdma_cm ib_cm iw_cm mlx5_ib ib_core intel_powerclamp coretemp kvm_intel
kvm irqbypass crct10dif_pclmul crc32_pclmul ipmi_ssif
ghash_clmulni_intel pcbc joydev aesni_intel dm_service_time ipmi_si
crypto_simd glue_helper sg hpilo cryptd hpwdt ipmi_devintf iTCO_wdt
gpio_ich acpi_power_meter iTCO_vendor_support ipmi_msghandler shpchp
pcspkr i7core_edac lpc_ich
[ 1361.120851]  pcc_cpufreq nfsd auth_rpcgss nfs_acl lockd grace
dm_multipath sunrpc ip_tables xfs libcrc32c radeon i2c_algo_bit
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm sd_mod
drm mlx5_core mlxfw ptp serio_raw crc32c_intel i2c_core hpsa pps_core
bnx2 devlink scsi_transport_sas dm_mirror dm_region_hash dm_log dm_mod
[ 1361.288913] CPU: 15 PID: 15149 Comm: reboot Tainted:
G          I      4.15.0-rc7 #1
[ 1361.333577] Hardware name: HP ProLiant DL380 G7, BIOS P67 08/16/2015
[ 1361.369976] RIP: 0010:ib_cq_completion_direct+0x28/0x30 [ib_core]
[ 1361.404971] RSP: 0018:ffffa08c8747fc60 EFLAGS: 00010086
[ 1361.435007] RAX: 0000000000000000 RBX: ffff8d37a6f8b468 RCX:
ffffffffae662928
[ 1361.474397] RDX: 0000000000000001 RSI: 0000000000000082 RDI:
0000000000000046
[ 1361.515097] RBP: ffff8d2bb07e0000 R08: 0000000000000000 R09:
0000000000000717
[ 1361.555054] R10: 0000000000000000 R11: ffffa08c8747f9c8 R12:
ffff8d2ed1edc264
[ 1361.595593] R13: ffff8d37a6f8b400 R14: ffffa08c8747fca8 R15:
0000000000000083
[ 1361.635133] FS:  00007fc09956a880(0000) GS:ffff8d37b33c0000(0000)
knlGS:0000000000000000
[ 1361.681800] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1361.714217] CR2: 0000000001034f80 CR3: 0000000ba0f9e005 CR4:
00000000000206e0
[ 1361.754794] Call Trace:
[ 1361.768980]  mlx5_ib_event+0x335/0x410 [mlx5_ib]
[ 1361.795303]  mlx5_core_event+0x7b/0x1a0 [mlx5_core]
[ 1361.823438]  ? synchronize_irq+0x35/0xa0
[ 1361.845962]  mlx5_enter_error_state+0xe4/0x1c0 [mlx5_core]
[ 1361.877382]  shutdown+0x127/0x170 [mlx5_core]
[ 1361.902688]  pci_device_shutdown+0x31/0x60
[ 1361.925924]  device_shutdown+0x101/0x1d0
[ 1361.948642]  kernel_restart+0xe/0x60
[ 1361.968517]  SYSC_reboot+0x1e8/0x210
[ 1361.988062]  ? __audit_syscall_entry+0xaf/0x100
[ 1362.013500]  ? syscall_trace_enter+0x1cc/0x2b0
[ 1362.038483]  ? __audit_syscall_exit+0x1ff/0x280
[ 1362.064598]  do_syscall_64+0x61/0x1a0
[ 1362.084635]  entry_SYSCALL64_slow_path+0x25/0x25
[ 1362.111113] RIP: 0033:0x7fc098377a56
[ 1362.131668] RSP: 002b:00007ffd4b3377e8 EFLAGS: 00000206 ORIG_RAX:
00000000000000a9
[ 1362.174578] RAX: ffffffffffffffda RBX: 0000000000000004 RCX:
00007fc098377a56
[ 1362.213620] RDX: 0000000001234567 RSI: 0000000028121969 RDI:
fffffffffee1dead
[ 1362.255259] RBP: 0000000000000000 R08: 000056141a7642a0 R09:
00007ffd4b336eb0
[ 1362.296293] R10: 0000000000000024 R11: 0000000000000206 R12:
0000000000000000
[ 1362.338341] R13: 00007ffd4b337ab0 R14: 0000000000000000 R15:
0000000000000000
[ 1362.378518] Code: 00 00 00 66 66 66 66 90 80 3d 65 e1 02 00 00 74 02
f3 c3 48 89 fe 31 c0 48 c7 c7 68 58 92 c0 c6 05 4e e1 02 00 01 e8 a8 23
d8 ec <0f> ff c3 0f 1f 44 00 00 66 66 66 66 90 41 55 45 89 c5 41 54 49 
[ 1362.483962] ---[ end trace 528ee06930a5763f ]---
[ 1362.509435] mlx5_1:mlx5_ib_event:2992:(pid 15149): warning: event on
port 0
[ 1362.548716] scsi host2: ib_srp: failed RECV status WR flushed (5)
for CQE 0000000023e53497
[ 1362.595980] mlx5_core 0000:08:00.1: mlx5_enter_error_state:128:(pid
15149): end
[ 1362.637630] mlx5_core 0000:08:00.0: Shutdown was called
[ 1362.677523] mlx5_core 0000:08:00.0: mlx5_enter_error_state:121:(pid
15149): start
[ 1362.720734] mlx5_0:mlx5_ib_event:2992:(pid 15149): warning: event on
port 0
[ 1362.760795] scsi host1: ib_srp: failed RECV status WR flushed (5)
for CQE 000000009ad07e27
[ 1362.806977] mlx5_core 0000:08:00.0: mlx5_enter_error_state:128:(pid
15149): end
[ 1363.331808] reboot: Restarting system
[ 1363.349889] reboot: machine restart
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
