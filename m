From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Kernel v4.16 / v4.17 SRP and SRPT patches
Date: Wed, 10 Jan 2018 13:59:10 -0500
Message-ID: <1515610750.10153.1.camel@redhat.com>
References: <5a5016c0.4c0a620a.ed2b3.60da@mx.google.com>
         <fcc3f226-848d-abc4-2a81-f4fd821761c9@wdc.com>
         <1515528956.3919.3.camel@redhat.com> <1515529869.3919.4.camel@redhat.com>
         <1515531079.2721.26.camel@wdc.com> <1515531652.26021.1.camel@redhat.com>
         <1515537614.26021.3.camel@redhat.com> <1515591723.26021.6.camel@redhat.com>
         <20180110182648.GI4518@ziepe.ca> <1515609623.2745.20.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1515609623.2745.20.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "jgg-uk2M96/98Pc@public.gmane.org" <jgg-uk2M96/98Pc@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2018-01-10 at 18:40 +0000, Bart Van Assche wrote:
> On Wed, 2018-01-10 at 11:26 -0700, Jason Gunthorpe wrote:
> > On Wed, Jan 10, 2018 at 08:42:03AM -0500, Laurence Oberman wrote:
> > 
> > > [  946.647514] kernel tried to execute NX-protected page -
> > > exploit
> > > attempt? (uid: 0)
> > > [  946.691954] BUG: unable to handle kernel paging request at
> > > 00000000a2129b93
> > > [  947.889552] Call Trace:
> > > [  947.903724]  ? __ib_process_cq+0x55/0xa0 [ib_core]
> > > [  947.931179]  ? ib_cq_poll_work+0x1b/0x60 [ib_core]
> > > [  947.958153]  ? process_one_work+0x141/0x340
> > > [  947.981362]  ? worker_thread+0x47/0x3e0
> > > [  948.002102]  ? kthread+0xf5/0x130
> > > [  948.020538]  ? rescuer_thread+0x380/0x380
> > > [  948.043180]  ? kthread_associate_blkcg+0x90/0x90
> > > [  948.070184]  ? ret_from_fork+0x1f/0x30
> > 
> > These oops's you have are very suggestive that ib_wc->wr_cqe
> > is garbage..
> > 
> > Did SRP free its wr_cqe data before completion somehow?
> > 
> > Turn on slab poisoning to confirm?
> 
> Hello Jason,
> 
> It's easy to see in drivers/infiniband/core/cq.c that polling is
> stopped
> before a completion queue is destroyed (see also the
> cancel_work_sync(&cq->work)
> and the cq->device->destroy_cq(cq) calls in ib_free_cq()).
> 
> BTW, I run all my tests with SLAB poisoning enabled. My SRP tests
> pass if I run
> the SRP initiator and target drivers on top of the mlx4 and rdma_rxe
> drivers.
> 
> Bart.

Hi Jason

Yep, this seems specific to the mlx5 and IB. 
The problem though is Linus's tree 4.15-rc-7 already has enough of the
part of the RDMA updates to see issues.

With his tree I don't panic but I see this

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

With the latest RDMA tree additions I panic every time on shutdown.
This is built against  4.15.0-rc2 with whatever other patches are in
the RDMA tree.

I was testing Bart's tree when I panicked and we know now we hve an
issue in mlx5/ib

I am waiting to see what Leon and the RDMA folks want to do so I can
avoid another bisect, but if I have to instrument and/or bisect I will
do it.

Regards
Laurence


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
