From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/8] infiniband: fix ulp/srpt/ib_srpt.c kernel-doc
 notation
Date: Tue, 09 Jan 2018 15:15:56 -0500
Message-ID: <1515528956.3919.3.camel@redhat.com>
References: <5a5016c0.4c0a620a.ed2b3.60da@mx.google.com>
         <fcc3f226-848d-abc4-2a81-f4fd821761c9@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <fcc3f226-848d-abc4-2a81-f4fd821761c9-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Randy Dunlap <rd.dunlab-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2018-01-05 at 16:36 -0800, Bart Van Assche wrote:
> On 01/05/18 16:22, Randy Dunlap wrote:
> > Use correct parameter names in kernel-doc notation to eliminate
> > warnings from scripts/kernel-doc.
> > 
> > ../drivers/infiniband/ulp/srpt/ib_srpt.c:1146: warning: Excess
> > function parameter 'context' description in 'srpt_abort_cmd'
> > ../drivers/infiniband/ulp/srpt/ib_srpt.c:1482: warning: Excess
> > function parameter 'ioctx' description in 'srpt_handle_new_iu'
> > 
> > Signed-off-by: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> > Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > ---
> >   drivers/infiniband/ulp/srpt/ib_srpt.c |    4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > --- linux-next-20171222.orig/drivers/infiniband/ulp/srpt/ib_srpt.c
> > +++ linux-next-20171222/drivers/infiniband/ulp/srpt/ib_srpt.c
> > @@ -1139,7 +1139,6 @@ static struct srpt_send_ioctx *srpt_get_
> >   /**
> >    * srpt_abort_cmd() - Abort a SCSI command.
> >    * @ioctx:   I/O context associated with the SCSI command.
> > - * @context: Preferred execution context.
> >    */
> >   static int srpt_abort_cmd(struct srpt_send_ioctx *ioctx)
> >   {
> > @@ -1473,7 +1472,8 @@ fail:
> >   /**
> >    * srpt_handle_new_iu() - Process a newly received information
> > unit.
> >    * @ch:    RDMA channel through which the information unit has
> > been received.
> > - * @ioctx: SRPT I/O context associated with the information unit.
> > + * @recv_ioctx: SRPT I/O context associated with the receive
> > information unit.
> > + * @send_ioctx: SRPT I/O context associated with the send
> > information unit.
> >    */
> >   static void srpt_handle_new_iu(struct srpt_rdma_ch *ch,
> >   			       struct srpt_recv_ioctx
> > *recv_ioctx,
> 
> Please drop this patch. It conflicts with a patch series I'm working
> on.
> 
> Thanks,
> 
> Bart.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" 
> in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hello Bart

As agreed, I pulled your tree and checked out block-scsi-for-next
branch 
I built a kernel to test on mlx5 and booted into that kernel and mapped
my SRP devices.

My first test I always run is a reboot after mapping the LUNS, my
server is not yet running your kernel only the client.

Anyway, I panicked on the client due to a list corruption and have the
capture below.

I am thinking you may not have seen this because you don't have mlx5,
only mlx4 in your test bed.

[  202.449161] sd 1:0:0:1: [sdbk] Synchronizing SCSI cache
[  202.478733] sd 1:0:0:2: [sdbj] Synchronizing SCSI cache
[  202.508986] sd 1:0:0:3: [sdbi] Synchronizing SCSI cache
[  202.538082] sd 1:0:0:4: [sdbh] Synchronizing SCSI cache
[  202.568329] sd 1:0:0:5: [sdbg] Synchronizing SCSI cache
[  202.598275] sd 1:0:0:6: [sdbf] Synchronizing SCSI cache
[  202.627607] sd 1:0:0:7: [sdbe] Synchronizing SCSI cache
[  202.657557] sd 1:0:0:8: [sdbd] Synchronizing SCSI cache
[  202.686773] sd 1:0:0:9: [sdbc] Synchronizing SCSI cache
[  202.716227] sd 1:0:0:10: [sdbb] Synchronizing SCSI cache
[  202.746555] sd 1:0:0:11: [sdba] Synchronizing SCSI cache
[  202.777826] sd 1:0:0:12: [sdaz] Synchronizing SCSI cache
[  202.808770] sd 1:0:0:13: [sday] Synchronizing SCSI cache
[  202.839954] sd 1:0:0:14: [sdax] Synchronizing SCSI cache
[  202.870355] sd 1:0:0:15: [sdaw] Synchronizing SCSI cache
[  202.900917] sd 1:0:0:16: [sdav] Synchronizing SCSI cache
[  202.930718] sd 1:0:0:17: [sdau] Synchronizing SCSI cache
[  202.960734] sd 1:0:0:18: [sdat] Synchronizing SCSI cache
[  202.990976] sd 1:0:0:19: [sdas] Synchronizing SCSI cache
[  203.020733] sd 1:0:0:20: [sdar] Synchronizing SCSI cache
[  203.050828] sd 1:0:0:21: [sdaq] Synchronizing SCSI cache
[  203.081566] sd 1:0:0:22: [sdap] Synchronizing SCSI cache
[  203.112472] sd 1:0:0:23: [sdao] Synchronizing SCSI cache
[  203.143305] sd 1:0:0:24: [sdan] Synchronizing SCSI cache
[  203.174065] sd 1:0:0:25: [sdam] Synchronizing SCSI cache
[  203.205173] sd 1:0:0:26: [sdal] Synchronizing SCSI cache
[  203.236178] sd 1:0:0:27: [sdak] Synchronizing SCSI cache
[  203.266446] sd 1:0:0:28: [sdaj] Synchronizing SCSI cache
[  203.297050] sd 1:0:0:29: [sdai] Synchronizing SCSI cache
[  203.327570] sd 1:0:0:0: [sdah] Synchronizing SCSI cache
[  203.357475] sd 2:0:0:1: [sdag] Synchronizing SCSI cache
[  203.387259] sd 2:0:0:2: [sdaf] Synchronizing SCSI cache
[  203.416950] sd 2:0:0:3: [sdae] Synchronizing SCSI cache
[  203.447112] sd 2:0:0:4: [sdad] Synchronizing SCSI cache
[  203.477650] sd 2:0:0:5: [sdac] Synchronizing SCSI cache
[  203.508438] sd 2:0:0:6: [sdab] Synchronizing SCSI cache
[  203.539018] sd 2:0:0:7: [sdaa] Synchronizing SCSI cache
[  203.568806] sd 2:0:0:8: [sdz] Synchronizing SCSI cache
[  203.598575] sd 2:0:0:9: [sdy] Synchronizing SCSI cache
[  203.628063] sd 2:0:0:10: [sdx] Synchronizing SCSI cache
[  203.658096] sd 2:0:0:11: [sdw] Synchronizing SCSI cache
[  203.687453] sd 2:0:0:12: [sdv] Synchronizing SCSI cache
[  203.718127] sd 2:0:0:13: [sdu] Synchronizing SCSI cache
[  203.747953] sd 2:0:0:14: [sdt] Synchronizing SCSI cache
[  203.777593] sd 2:0:0:15: [sds] Synchronizing SCSI cache
[  203.808214] sd 2:0:0:16: [sdr] Synchronizing SCSI cache
[  203.837516] sd 2:0:0:17: [sdq] Synchronizing SCSI cache
[  203.866690] sd 2:0:0:18: [sdp] Synchronizing SCSI cache
[  203.896013] sd 2:0:0:19: [sdo] Synchronizing SCSI cache
[  203.925029] sd 2:0:0:20: [sdn] Synchronizing SCSI cache
[  203.953954] sd 2:0:0:21: [sdm] Synchronizing SCSI cache
[  203.982830] sd 2:0:0:22: [sdl] Synchronizing SCSI cache
[  204.012713] sd 2:0:0:23: [sdk] Synchronizing SCSI cache
[  204.043456] sd 2:0:0:24: [sdj] Synchronizing SCSI cache
[  204.073671] sd 2:0:0:25: [sdi] Synchronizing SCSI cache
[  204.104050] sd 2:0:0:26: [sdh] Synchronizing SCSI cache
[  204.134239] sd 2:0:0:27: [sdg] Synchronizing SCSI cache
[  204.164603] sd 2:0:0:28: [sdf] Synchronizing SCSI cache
[  204.195387] sd 2:0:0:29: [sde] Synchronizing SCSI cache
[  204.225894] sd 2:0:0:0: [sdd] Synchronizing SCSI cache
[  204.256062] mlx5_core 0000:08:00.1: Shutdown was called
[  204.286882] mlx5_core 0000:08:00.1:
mlx5_cmd_force_teardown_hca:245:(pid 15875): teardown with force mode
failed
[  204.296810] mlx5_core 0000:08:00.1: mlx5_cmd_comp_handler:1445:(pid
1028): Command completion arrived after timeout (entry idx = 0).
[  207.477515] mlx5_1:wait_for_async_commands:735:(pid 15875): done
with all pending requests
[  207.529305] sd 1:0:0:0: [sdah] Synchronizing SCSI cache
[  207.563161] scsi 1:0:0:0: alua: Detached
[  207.586589] sd 1:0:0:29: [sdai] Synchronizing SCSI cache
[  207.623036] scsi 1:0:0:29: alua: Detached
[  207.646005] sd 1:0:0:28: [sdaj] Synchronizing SCSI cache
[  207.690180] scsi 1:0:0:28: alua: Detached
[  207.713360] sd 1:0:0:27: [sdak] Synchronizing SCSI cache
[  207.749020] scsi 1:0:0:27: alua: Detached
[  207.771957] sd 1:0:0:26: [sdal] Synchronizing SCSI cache
[  207.808036] scsi 1:0:0:26: alua: Detached
[  207.831913] sd 1:0:0:25: [sdam] Synchronizing SCSI cache
[  207.872192] scsi 1:0:0:25: alua: Detached
[  207.895678] sd 1:0:0:24: [sdan] Synchronizing SCSI cache
[  207.931020] scsi 1:0:0:24: alua: Detached
[  207.954279] sd 1:0:0:23: [sdao] Synchronizing SCSI cache
[  207.990180] scsi 1:0:0:23: alua: Detached
[  208.013315] sd 1:0:0:22: [sdap] Synchronizing SCSI cache
[  208.049012] scsi 1:0:0:22: alua: Detached
[  208.072381] sd 1:0:0:21: [sdaq] Synchronizing SCSI cache
[  208.112041] scsi 1:0:0:21: alua: Detached
[  208.135881] sd 1:0:0:20: [sdar] Synchronizing SCSI cache
[  208.176006] scsi 1:0:0:20: alua: Detached
[  208.199316] sd 1:0:0:19: [sdas] Synchronizing SCSI cache
[  208.235018] scsi 1:0:0:19: alua: Detached
[  208.257835] sd 1:0:0:18: [sdat] Synchronizing SCSI cache
[  208.294019] scsi 1:0:0:18: alua: Detached
[  208.317725] sd 1:0:0:17: [sdau] Synchronizing SCSI cache
[  208.357016] scsi 1:0:0:17: alua: Detached
[  208.380742] sd 1:0:0:16: [sdav] Synchronizing SCSI cache
[  208.417015] scsi 1:0:0:16: alua: Detached
[  208.440017] sd 1:0:0:15: [sdaw] Synchronizing SCSI cache
[  208.479001] scsi 1:0:0:15: alua: Detached
[  208.501658] sd 1:0:0:14: [sdax] Synchronizing SCSI cache
[  208.536039] scsi 1:0:0:14: alua: Detached
[  208.559162] sd 1:0:0:13: [sday] Synchronizing SCSI cache
[  208.595027] scsi 1:0:0:13: alua: Detached
[  208.618418] sd 1:0:0:12: [sdaz] Synchronizing SCSI cache
[  208.662175] scsi 1:0:0:12: alua: Detached
[  208.685158] sd 1:0:0:11: [sdba] Synchronizing SCSI cache
[  208.723993] scsi 1:0:0:11: alua: Detached
[  208.747988] sd 1:0:0:10: [sdbb] Synchronizing SCSI cache
[  208.787003] scsi 1:0:0:10: alua: Detached
[  208.810841] sd 1:0:0:9: [sdbc] Synchronizing SCSI cache
[  208.850000] scsi 1:0:0:9: alua: Detached
[  208.873249] sd 1:0:0:8: [sdbd] Synchronizing SCSI cache
[  208.913186] scsi 1:0:0:8: alua: Detached
[  208.936783] sd 1:0:0:7: [sdbe] Synchronizing SCSI cache
[  208.973192] scsi 1:0:0:7: alua: Detached
[  208.995709] sd 1:0:0:6: [sdbf] Synchronizing SCSI cache
[  209.031179] scsi 1:0:0:6: alua: Detached
[  209.053746] sd 1:0:0:5: [sdbg] Synchronizing SCSI cache
[  209.089022] scsi 1:0:0:5: alua: Detached
[  209.112261] sd 1:0:0:4: [sdbh] Synchronizing SCSI cache
[  209.148024] scsi 1:0:0:4: alua: Detached
[  209.171354] sd 1:0:0:3: [sdbi] Synchronizing SCSI cache
[  209.207014] scsi 1:0:0:3: alua: Detached
[  209.229514] sd 1:0:0:2: [sdbj] Synchronizing SCSI cache
[  209.267005] scsi 1:0:0:2: alua: Detached
[  209.290867] sd 1:0:0:1: [sdbk] Synchronizing SCSI cache
[  209.326303] scsi 1:0:0:1: alua: Detached
[  211.376056] ib0: multicast join failed for
ff12:601b:ffff:0000:0000:0000:0000:0001, status -22
[  211.439940] scsi host1: ib_srp: connection closed
[  211.466771] scsi host1: ib_srp: connection closed
[  211.493623] scsi host1: ib_srp: connection closed
[  213.425511] ib0: multicast join failed for
ff12:601b:ffff:0000:0000:0000:0000:0001, status -22
[  217.521341] ib0: multicast join failed for
ff12:601b:ffff:0000:0000:0000:0000:0001, status -22
[  220.843344] ------------[ cut here ]------------
[  220.869309] list_add corruption. prev->next should be next
(000000002a07d255), but was           (null). (prev=000000000edf5e8c).
[  220.935392] WARNING: CPU: 1 PID: 694 at lib/list_debug.c:28
__list_add_valid+0x6a/0x70
[  220.979462] Modules linked in: xt_CHECKSUM iptable_mangle
ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT
nf_reject_ipv4 tun bridge stp llc ebtable_filter ebtables
ip6table_filter ip6_tables iptable_filter rpcrdma ib_isert
iscsi_target_mod target_core_mod ib_iser libiscsi scsi_transport_iscsi
ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad
rdma_cm ib_cm iw_cm mlx5_ib ib_core intel_powerclamp coretemp kvm_intel
kvm irqbypass crct10dif_pclmul crc32_pclmul ipmi_ssif
ghash_clmulni_intel pcbc aesni_intel joydev ipmi_si crypto_simd
dm_service_time iTCO_wdt hpwdt iTCO_vendor_support glue_helper cryptd
ipmi_devintf sg gpio_ich pcspkr hpilo ipmi_msghandler lpc_ich
acpi_power_meter i7core_edac shpchp
[  221.385270]  pcc_cpufreq nfsd auth_rpcgss nfs_acl lockd grace sunrpc
dm_multipath ip_tables xfs libcrc32c radeon i2c_algo_bit drm_kms_helper
syscopyarea sysfillrect sysimgblt fb_sys_fops ttm mlx5_core mlxfw
sd_mod drm ptp hpsa pps_core crc32c_intel i2c_core serio_raw bnx2
devlink scsi_transport_sas dm_mirror dm_region_hash dm_log dm_mod
[  221.554496] CPU: 1 PID: 694 Comm: kworker/1:1H Tainted:
G          I      4.15.0-rc7+ #1
[  221.606907] Hardware name: HP ProLiant DL380 G7, BIOS P67 08/16/2015
[  221.642980] Workqueue: ib-comp-wq ib_cq_poll_work [ib_core]
[  221.674616] RIP: 0010:__list_add_valid+0x6a/0x70
[  221.700561] RSP: 0018:ffffb2bdc75c7cf0 EFLAGS: 00010086
[  221.730608] RAX: 0000000000000000 RBX: ffff94342d610880 RCX:
ffffffff8ba62928
[  221.771490] RDX: 0000000000000001 RSI: 0000000000000082 RDI:
0000000000000046
[  221.812721] RBP: ffff94342d6108b8 R08: 0000000000000000 R09:
0000000000000722
[  221.853073] R10: 0000000000000000 R11: ffffb2bdc75c7a58 R12:
0000000000000200
[  221.894156] R13: 0000000000000246 R14: ffff943fb7fd5000 R15:
ffff943fb7fd5000
[  221.935233] FS:  0000000000000000(0000) GS:ffff944033200000(0000)
knlGS:0000000000000000
[  221.980521] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  222.013062] CR2: 00007f1bdc0ee910 CR3: 00000017e7e0a002 CR4:
00000000000206e0
[  222.052302] Call Trace:
[  222.065971]  ib_mad_post_receive_mads+0x177/0x310 [ib_core]
[  222.097349]  ib_mad_recv_done+0x471/0x9c0 [ib_core]
[  222.124387]  __ib_process_cq+0x55/0xa0 [ib_core]
[  222.150827]  ib_cq_poll_work+0x1b/0x60 [ib_core]
[  222.177751]  process_one_work+0x141/0x340
[  222.200383]  worker_thread+0x47/0x3e0
[  222.220641]  kthread+0xf5/0x130
[  222.238951]  ? rescuer_thread+0x380/0x380
[  222.262034]  ? kthread_associate_blkcg+0x90/0x90
[  222.288514]  ? do_group_exit+0x39/0xa0
[  222.309492]  ret_from_fork+0x1f/0x30
[  222.330073] Code: fe 31 c0 48 c7 c7 98 36 89 8b e8 02 9c cf ff 0f ff
31 c0 c3 48 89 d1 48 c7 c7 48 36 89 8b 48 89 f2 48 89 c6 31 c0 e8 e6 9b
cf ff <0f> ff 31 c0 c3 90 48 8b 07 48 b9 00 01 00 00 00 00 ad de 48 8b 
[  222.438058] ---[ end trace 5d41544bf17ab73b ]---
[  222.465993] BUG: unable to handle kernel NULL pointer dereference at
0000000000000028
[  222.510316] IP: ib_mad_post_receive_mads+0x3c/0x310 [ib_core]
[  222.543188] PGD 0 P4D 0 
[  222.557625] Oops: 0000 [#1] SMP PTI
[  222.576674] Modules linked in: xt_CHECKSUM iptable_mangle
ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT
nf_reject_ipv4 tun bridge stp llc ebtable_filter ebtables
ip6table_filter ip6_tables iptable_filter rpcrdma ib_isert
iscsi_target_mod target_core_mod ib_iser libiscsi scsi_transport_iscsi
ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad
rdma_cm ib_cm iw_cm mlx5_ib ib_core intel_powerclamp coretemp kvm_intel
kvm irqbypass crct10dif_pclmul crc32_pclmul ipmi_ssif
ghash_clmulni_intel pcbc aesni_intel joydev ipmi_si crypto_simd
dm_service_time iTCO_wdt hpwdt iTCO_vendor_support glue_helper cryptd
ipmi_devintf sg gpio_ich pcspkr hpilo ipmi_msghandler lpc_ich
acpi_power_meter i7core_edac shpchp
[  222.981443]  pcc_cpufreq nfsd auth_rpcgss nfs_acl lockd grace sunrpc
dm_multipath ip_tables xfs libcrc32c radeon i2c_algo_bit drm_kms_helper
syscopyarea sysfillrect sysimgblt fb_sys_fops ttm mlx5_core mlxfw
sd_mod drm ptp hpsa pps_core crc32c_intel i2c_core serio_raw bnx2
devlink scsi_transport_sas dm_mirror dm_region_hash dm_log dm_mod
[  223.152359] CPU: 1 PID: 694 Comm: kworker/1:1H Tainted: G        W
I      4.15.0-rc7+ #1
[  223.198577] Hardware name: HP ProLiant DL380 G7, BIOS P67 08/16/2015
[  223.235101] Workqueue: ib-comp-wq ib_cq_poll_work [ib_core]
[  223.266750] RIP: 0010:ib_mad_post_receive_mads+0x3c/0x310 [ib_core]
[  223.303012] RSP: 0018:ffffb2bdc75c7cf8 EFLAGS: 00010286
[  223.333022] RAX: 0000000000000000 RBX: ffff94342d610908 RCX:
ffff94342d610948
[  223.373307] RDX: 0000000000000001 RSI: ffff94342d6108c0 RDI:
ffff94342d610908
[  223.414451] RBP: ffff94342d610940 R08: ffff94342a8e64c0 R09:
ffff94342a8e64e8
[  223.454789] R10: ffff94342a8e64e8 R11: ffff94342d6109a8 R12:
ffff944029c2e048
[  223.496554] R13: 0000000000000000 R14: ffff94342a8e64c0 R15:
ffff94342d6108c0
[  223.537489] FS:  0000000000000000(0000) GS:ffff944033200000(0000)
knlGS:0000000000000000
[  223.583538] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  223.616545] CR2: 0000000000000028 CR3: 00000017e7e0a002 CR4:
00000000000206e0
[  223.657337] Call Trace:
[  223.671022]  ? find_mad_agent+0x77/0x1b0 [ib_core]
[  223.698581]  ? __kmalloc+0x1be/0x1f0
[  223.719074]  ib_mad_recv_done+0x471/0x9c0 [ib_core]
[  223.747190]  __ib_process_cq+0x55/0xa0 [ib_core]
[  223.774140]  ib_cq_poll_work+0x1b/0x60 [ib_core]
[  223.800719]  process_one_work+0x141/0x340
[  223.824120]  worker_thread+0x47/0x3e0
[  223.845133]  kthread+0xf5/0x130
[  223.863116]  ? rescuer_thread+0x380/0x380
[  223.886173]  ? kthread_associate_blkcg+0x90/0x90
[  223.912207]  ? do_group_exit+0x39/0xa0
[  223.933198]  ret_from_fork+0x1f/0x30
[  223.953218] Code: 55 41 54 55 48 8d 6f 38 53 48 89 fb 48 83 ec 50 65
48 8b 04 25 28 00 00 00 48 89 44 24 48 31 c0 48 8b 07 48 85 f6 48 89 4c
24 08 <48> 8b 50 28 8b 12 48 c7 44 24 28 00 00 00 00 c7 44 24 40 01 00 
[  224.059985] RIP: ib_mad_post_receive_mads+0x3c/0x310 [ib_core] RSP:
ffffb2bdc75c7cf8
[  224.103994] CR2: 0000000000000028


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
