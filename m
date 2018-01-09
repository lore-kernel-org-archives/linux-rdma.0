From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Kernel v4.16 / v4.17 SRP and SRPT patches
Date: Tue, 09 Jan 2018 16:00:52 -0500
Message-ID: <1515531652.26021.1.camel@redhat.com>
References: <5a5016c0.4c0a620a.ed2b3.60da@mx.google.com>
         <fcc3f226-848d-abc4-2a81-f4fd821761c9@wdc.com>
         <1515528956.3919.3.camel@redhat.com> <1515529869.3919.4.camel@redhat.com>
         <1515531079.2721.26.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1515531079.2721.26.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2018-01-09 at 20:51 +0000, Bart Van Assche wrote:
> On Tue, 2018-01-09 at 15:31 -0500, Laurence Oberman wrote:
> > On Tue, 2018-01-09 at 15:15 -0500, Laurence Oberman wrote:
> > > [  220.843344] ------------[ cut here ]------------
> > > [  220.869309] list_add corruption. prev->next should be next
> > > (000000002a07d255), but was           (null).
> > > (prev=000000000edf5e8c).
> > > [  220.935392] WARNING: CPU: 1 PID: 694 at lib/list_debug.c:28
> > > __list_add_valid+0x6a/0x70
> > > [  220.979462] Modules linked in: xt_CHECKSUM iptable_mangle
> > > ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4
> > > nf_nat
> > > nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack
> > > ipt_REJECT
> > > nf_reject_ipv4 tun bridge stp llc ebtable_filter ebtables
> > > ip6table_filter ip6_tables iptable_filter rpcrdma ib_isert
> > > iscsi_target_mod target_core_mod ib_iser libiscsi
> > > scsi_transport_iscsi
> > > ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs
> > > ib_umad
> > > rdma_cm ib_cm iw_cm mlx5_ib ib_core intel_powerclamp coretemp
> > > kvm_intel
> > > kvm irqbypass crct10dif_pclmul crc32_pclmul ipmi_ssif
> > > ghash_clmulni_intel pcbc aesni_intel joydev ipmi_si crypto_simd
> > > dm_service_time iTCO_wdt hpwdt iTCO_vendor_support glue_helper
> > > cryptd
> > > ipmi_devintf sg gpio_ich pcspkr hpilo ipmi_msghandler lpc_ich
> > > acpi_power_meter i7core_edac shpchp
> > > [  221.385270]  pcc_cpufreq nfsd auth_rpcgss nfs_acl lockd grace
> > > sunrpc
> > > dm_multipath ip_tables xfs libcrc32c radeon i2c_algo_bit
> > > drm_kms_helper
> > > syscopyarea sysfillrect sysimgblt fb_sys_fops ttm mlx5_core mlxfw
> > > sd_mod drm ptp hpsa pps_core crc32c_intel i2c_core serio_raw bnx2
> > > devlink scsi_transport_sas dm_mirror dm_region_hash dm_log dm_mod
> > > [  221.554496] CPU: 1 PID: 694 Comm: kworker/1:1H Tainted:
> > > G          I      4.15.0-rc7+ #1
> > > [  221.606907] Hardware name: HP ProLiant DL380 G7, BIOS P67
> > > 08/16/2015
> > > [  221.642980] Workqueue: ib-comp-wq ib_cq_poll_work [ib_core]
> > > [  221.674616] RIP: 0010:__list_add_valid+0x6a/0x70
> > > [  221.700561] RSP: 0018:ffffb2bdc75c7cf0 EFLAGS: 00010086
> > > [  221.730608] RAX: 0000000000000000 RBX: ffff94342d610880 RCX:
> > > ffffffff8ba62928
> > > [  221.771490] RDX: 0000000000000001 RSI: 0000000000000082 RDI:
> > > 0000000000000046
> > > [  221.812721] RBP: ffff94342d6108b8 R08: 0000000000000000 R09:
> > > 0000000000000722
> > > [  221.853073] R10: 0000000000000000 R11: ffffb2bdc75c7a58 R12:
> > > 0000000000000200
> > > [  221.894156] R13: 0000000000000246 R14: ffff943fb7fd5000 R15:
> > > ffff943fb7fd5000
> > > [  221.935233] FS:  0000000000000000(0000)
> > > GS:ffff944033200000(0000)
> > > knlGS:0000000000000000
> > > [  221.980521] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [  222.013062] CR2: 00007f1bdc0ee910 CR3: 00000017e7e0a002 CR4:
> > > 00000000000206e0
> > > [  222.052302] Call Trace:
> > > [  222.065971]  ib_mad_post_receive_mads+0x177/0x310 [ib_core]
> > > [  222.097349]  ib_mad_recv_done+0x471/0x9c0 [ib_core]
> > > [  222.124387]  __ib_process_cq+0x55/0xa0 [ib_core]
> > > [  222.150827]  ib_cq_poll_work+0x1b/0x60 [ib_core]
> > > [  222.177751]  process_one_work+0x141/0x340
> > > [  222.200383]  worker_thread+0x47/0x3e0
> > > [  222.220641]  kthread+0xf5/0x130
> > > [  222.238951]  ? rescuer_thread+0x380/0x380
> > > [  222.262034]  ? kthread_associate_blkcg+0x90/0x90
> > > [  222.288514]  ? do_group_exit+0x39/0xa0
> > > [  222.309492]  ret_from_fork+0x1f/0x30
> > > [  222.330073] Code: fe 31 c0 48 c7 c7 98 36 89 8b e8 02 9c cf ff
> > > 0f
> > > ff
> > > 31 c0 c3 48 89 d1 48 c7 c7 48 36 89 8b 48 89 f2 48 89 c6 31 c0 e8
> > > e6
> > > 9b
> > > cf ff <0f> ff 31 c0 c3 90 48 8b 07 48 b9 00 01 00 00 00 00 ad de
> > > 48
> > > 8b 
> > > [  222.438058] ---[ end trace 5d41544bf17ab73b ]---
> > > [  222.465993] BUG: unable to handle kernel NULL pointer
> > > dereference
> > > at
> > > 0000000000000028
> > > [  222.510316] IP: ib_mad_post_receive_mads+0x3c/0x310 [ib_core]
> > > [  222.543188] PGD 0 P4D 0 
> > > [  222.557625] Oops: 0000 [#1] SMP PTI
> > > [  222.576674] Modules linked in: xt_CHECKSUM iptable_mangle
> > > ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4
> > > nf_nat
> > > nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack
> > > ipt_REJECT
> > > nf_reject_ipv4 tun bridge stp llc ebtable_filter ebtables
> > > ip6table_filter ip6_tables iptable_filter rpcrdma ib_isert
> > > iscsi_target_mod target_core_mod ib_iser libiscsi
> > > scsi_transport_iscsi
> > > ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs
> > > ib_umad
> > > rdma_cm ib_cm iw_cm mlx5_ib ib_core intel_powerclamp coretemp
> > > kvm_intel
> > > kvm irqbypass crct10dif_pclmul crc32_pclmul ipmi_ssif
> > > ghash_clmulni_intel pcbc aesni_intel joydev ipmi_si crypto_simd
> > > dm_service_time iTCO_wdt hpwdt iTCO_vendor_support glue_helper
> > > cryptd
> > > ipmi_devintf sg gpio_ich pcspkr hpilo ipmi_msghandler lpc_ich
> > > acpi_power_meter i7core_edac shpchp
> > > [  222.981443]  pcc_cpufreq nfsd auth_rpcgss nfs_acl lockd grace
> > > sunrpc
> > > dm_multipath ip_tables xfs libcrc32c radeon i2c_algo_bit
> > > drm_kms_helper
> > > syscopyarea sysfillrect sysimgblt fb_sys_fops ttm mlx5_core mlxfw
> > > sd_mod drm ptp hpsa pps_core crc32c_intel i2c_core serio_raw bnx2
> > > devlink scsi_transport_sas dm_mirror dm_region_hash dm_log dm_mod
> > > [  223.152359] CPU: 1 PID: 694 Comm: kworker/1:1H Tainted:
> > > G        W
> > > I      4.15.0-rc7+ #1
> > > [  223.198577] Hardware name: HP ProLiant DL380 G7, BIOS P67
> > > 08/16/2015
> > > [  223.235101] Workqueue: ib-comp-wq ib_cq_poll_work [ib_core]
> > > [  223.266750] RIP: 0010:ib_mad_post_receive_mads+0x3c/0x310
> > > [ib_core]
> > > [  223.303012] RSP: 0018:ffffb2bdc75c7cf8 EFLAGS: 00010286
> > > [  223.333022] RAX: 0000000000000000 RBX: ffff94342d610908 RCX:
> > > ffff94342d610948
> > > [  223.373307] RDX: 0000000000000001 RSI: ffff94342d6108c0 RDI:
> > > ffff94342d610908
> > > [  223.414451] RBP: ffff94342d610940 R08: ffff94342a8e64c0 R09:
> > > ffff94342a8e64e8
> > > [  223.454789] R10: ffff94342a8e64e8 R11: ffff94342d6109a8 R12:
> > > ffff944029c2e048
> > > [  223.496554] R13: 0000000000000000 R14: ffff94342a8e64c0 R15:
> > > ffff94342d6108c0
> > > [  223.537489] FS:  0000000000000000(0000)
> > > GS:ffff944033200000(0000)
> > > knlGS:0000000000000000
> > > [  223.583538] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [  223.616545] CR2: 0000000000000028 CR3: 00000017e7e0a002 CR4:
> > > 00000000000206e0
> > > [  223.657337] Call Trace:
> > > [  223.671022]  ? find_mad_agent+0x77/0x1b0 [ib_core]
> > > [  223.698581]  ? __kmalloc+0x1be/0x1f0
> > > [  223.719074]  ib_mad_recv_done+0x471/0x9c0 [ib_core]
> > > [  223.747190]  __ib_process_cq+0x55/0xa0 [ib_core]
> > > [  223.774140]  ib_cq_poll_work+0x1b/0x60 [ib_core]
> > > [  223.800719]  process_one_work+0x141/0x340
> > > [  223.824120]  worker_thread+0x47/0x3e0
> > > [  223.845133]  kthread+0xf5/0x130
> > > [  223.863116]  ? rescuer_thread+0x380/0x380
> > > [  223.886173]  ? kthread_associate_blkcg+0x90/0x90
> > > [  223.912207]  ? do_group_exit+0x39/0xa0
> > > [  223.933198]  ret_from_fork+0x1f/0x30
> > > [  223.953218] Code: 55 41 54 55 48 8d 6f 38 53 48 89 fb 48 83 ec
> > > 50
> > > 65
> > > 48 8b 04 25 28 00 00 00 48 89 44 24 48 31 c0 48 8b 07 48 85 f6 48
> > > 89
> > > 4c
> > > 24 08 <48> 8b 50 28 8b 12 48 c7 44 24 28 00 00 00 00 c7 44 24 40
> > > 01
> > > 00 
> > > [  224.059985] RIP: ib_mad_post_receive_mads+0x3c/0x310 [ib_core]
> > > RSP:
> > > ffffb2bdc75c7cf8
> > > [  224.103994] CR2: 0000000000000028
> > 
> > Just wanted to add that the panic is consistent, rebooted into only
> > a
> > single path to my SRP LUNS and on reboot had the same panic.
> 
> Hello Laurence,
> kernsl
> Can you repeat your test with the following two kernels:
> * v4.15-rc7 (Linus' latest).
> * The for-next branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git.
> 
> I'm asking this because the crash occurred in a code path that is not
> modified by
> any of my patches.
> 
> Thanks,
> 
> Bart.NrybXǧv^)޺{.n+{ٚ{ay
ʇڙ,jfhz
w
j:+vwjmzZ+ݢj"!

Bart, Yep, I saw it was not in code you touched specific to your
patches.

Doing that now, although I had already tested 4.15.0-rc4 from Mike
Snitzers tree that only had NVME changes in it and did not see it.
So maybe it crept in in the kernels you mentioned.

Its clearly in the ib_mad_xxxx code.

I will baseline again on the ones you asked me to test with
v4.15-rc7 (Linus' latest).
The for-next branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git

Back later
Regards
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
