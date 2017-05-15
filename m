From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Kernel panic in cma_ps_find
Date: Mon, 15 May 2017 14:26:50 +0000
Message-ID: <492D39E1-EF12-4F5F-83C7-A273BAD6806D@mellanox.com>
References: <201705141752.v4EHqUVD008443@vnc21.mtl.labs.mlnx>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201705141752.v4EHqUVD008443-w322HNqTTWz8qXErf1F4WZe3/6m9zbFP@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On May 14, 2017, at 8:52 PM, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>=20
> Hi all,
>=20
> I want to report the following kernel panic that our verification team
> revealed recently:
Found the root cause and we will send a fix soon.
>=20
> [   27.074594] BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000008
> [   27.074731] IP: __radix_tree_lookup+0x1d/0xe0
> [   27.074782] PGD 1dadcb067
> [   27.074783] PUD 1dadc3067
> [   27.074821] PMD 0
> [   27.074855]
> [   27.074916] Oops: 0000 [#1] SMP
> [   27.074950] Modules linked in: netconsole nfsv3 nfs fscache rdma_ucm i=
b_ucm
> rdma_cm iw_cm ib_ipoib ib_cm ib_uverbs ib_umad mlx5_ib mlx4_en mlx4_ib ib=
_core
> mlx4_core sg crc32_pclmul crc32c_intel dm_mirror dm_region_hash dm_log dm=
_mod
> acpi_cpufreq ppdev serio_raw parport_pc i2c_piix4 parport virtio_balloon =
pcspkr
> ghash_clmulni_intel nfsd auth_rpcgss nfs_acl lockd grace sunrpc uinput
> binfmt_misc ata_generic pata_acpi cirrus mlx5_core drm_kms_helper syscopy=
area
> sysfillrect sysimgblt fb_sys_fops ttm drm ata_piix libata virtio_blk e100=
0
> virtio_pci ptp virtio_ring pps_core floppy i2c_core virtio [last unloaded=
:
> ipmi_msghandler]
> [   27.075252] CPU: 4 PID: 205 Comm: kworker/4:1 Not tainted 4.11.0-rc6+ =
#71
> [   27.075307] Hardware name: Red Hat KVM, BIOS Bochs 01/01/2011
> [   27.075356] Workqueue: ib_cm cm_work_handler [ib_cm]
> [   27.075401] task: ffff88022e3b8000 task.stack: ffffc90001298000
> [   27.075449] RIP: 0010:__radix_tree_lookup+0x1d/0xe0
> [   27.075495] RSP: 0018:ffffc9000129bb98 EFLAGS: 00010292
> [   27.075546] RAX: ffff88022e990180 RBX: ffffc9000129bc10 RCX: 000000000=
0000000
> [   27.075600] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000000000=
0000000
> [   27.075650] RBP: ffffc9000129bbc8 R08: ffffc9000129bad0 R09: 000000000=
0000002
> [   27.075700] R10: 0000000000000002 R11: 0000000000000000 R12: 000000000=
0000000
> [   27.075770] R13: 0000000000000000 R14: 0000000000000000 R15: 000000000=
0000000
> [   27.075823] FS:  0000000000000000(0000) GS:ffff880237300000(0000)
> knlGS:0000000000000000
> [   27.075879] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   27.075924] CR2: 0000000000000008 CR3: 0000000227bcd000 CR4: 000000000=
01406e0
> [   27.075979] Call Trace:
> [   27.076015]  radix_tree_lookup+0xd/0x10
> [   27.076055]  cma_ps_find+0x59/0x70 [rdma_cm]
> [   27.076097]  cma_id_from_event+0xd2/0x470 [rdma_cm]
> [   27.076144]  ? ib_init_ah_from_path+0x39a/0x590 [ib_core]
> [   27.076193]  cma_req_handler+0x25/0x480 [rdma_cm]
> [   27.076237]  cm_process_work+0x25/0x120 [ib_cm]
> [   27.076280]  ? cm_get_bth_pkey.isra.62+0x3c/0xa0 [ib_cm]
> [   27.076350]  cm_req_handler+0xb03/0xd40 [ib_cm]
> [   27.076430]  ? sched_clock_cpu+0x11/0xb0
> [   27.076478]  cm_work_handler+0x194/0x1588 [ib_cm]
> [   27.076525]  process_one_work+0x160/0x410
> [   27.076565]  worker_thread+0x137/0x4a0
> [   27.076614]  kthread+0x112/0x150
> [   27.076684]  ? max_active_store+0x60/0x60
> [   27.077642]  ? kthread_park+0x90/0x90
> [   27.078530]  ret_from_fork+0x2c/0x40
> [   27.079449] Code: ff ff 0f 0b 0f 0b 0f 1f 84 00 00 00 00 00 55 48 89 e=
5 41 57
> 49 89 d7 41 56 49 89 ce 41 55 49 89 fd 41 54 49 89 f4 53 48 83 ec 08 <49>=
 8b 45
> 08 48 89 c6 48 89 45 d0 83 e6 03 48 83 fe 01 0f 85 9d
> [   27.081351] RIP: __radix_tree_lookup+0x1d/0xe0 RSP: ffffc9000129bb98
> [   27.082280] CR2: 0000000000000008
> [   27.083206] ---[ end trace 883c88edc92746ef ]---
> [   27.084121] Kernel panic - not syncing: Fatal exception
> [   27.085122] Kernel Offset: disabled
> [   27.086057] ---[ end Kernel panic - not syncing: Fatal exception
> [   27.086989] ------------[ cut here ]------------
> [   27.087925] WARNING: CPU: 4 PID: 205 at arch/x86/kernel/smp.c:127
> native_smp_send_reschedule+0x3f/0x50
> [   27.088905] Modules linked in: netconsole nfsv3 nfs fscache rdma_ucm i=
b_ucm
> rdma_cm iw_cm ib_ipoib ib_cm ib_uverbs ib_umad mlx5_ib mlx4_en mlx4_ib ib=
_core
> mlx4_core sg crc32_pclmul crc32c_intel dm_mirror dm_region_hash dm_log dm=
_mod
> acpi_cpufreq ppdev serio_raw parport_pc i2c_piix4 parport virtio_balloon =
pcspkr
> ghash_clmulni_intel nfsd auth_rpcgss nfs_acl lockd grace sunrpc uinput
> binfmt_misc ata_generic pata_acpi cirrus mlx5_core drm_kms_helper syscopy=
area
> sysfillrect sysimgblt fb_sys_fops ttm drm ata_piix libata virtio_blk e100=
0
> virtio_pci ptp virtio_ring pps_core floppy i2c_core virtio [last unloaded=
:
> ipmi_msghandler]                                                         =
    =20
>=20
>=20
> I did some bisecting and found that the issue was introduced in the follo=
wing
> commits:
>=20
> broken
> 9fdca4d IB/SA: Split struct sa_path_rec based on IB and ROCE specific fie=
lds
> dfa834e1 IB/SA: Introduce path record specific types
> c2f8fc4 IB/SA: Rename ib_sa_path_rec to sa_path_rec
>=20
> works
> 82ffc22 IB/CM: Add braces when using sizeof
>=20
>=20
> Thanks
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
