From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: NULL pointer dereference in isert_login_recv_done in 4.9.32
Date: Wed, 21 Jun 2017 09:17:50 -0600
Message-ID: <CAANLjFp6Y8wvLvmWrk1ECjm-OoyEppxD1svNYKpg+HDEZevJig@mail.gmail.com>
References: <CAANLjFoaZ8ueEQet3Yu6LygmxXBbQ0cHUEYsb2xEON0o3N9=+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFoaZ8ueEQet3Yu6LygmxXBbQ0cHUEYsb2xEON0o3N9=+w@mail.gmail.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 20, 2017 at 12:54 PM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
> We have hit this four times today. Any ideas?
>
> [  169.382113] BUG: unable to handle kernel NULL pointer dereference
> at           (null)
> [  169.382152] IP: [<ffffffffa051e968>]
> isert_login_recv_done+0x28/0x170 [ib_isert]
> [  169.382182] PGD 0
>
> [  169.382201] Oops: 0000 [#1] SMP
> [  169.382214] Modules linked in: ip_vs nf_conntrack macvlan bonding
> target_core_user uio target_core_pscsi target_core_file
> target_core_iblock iptable_filter rpcrdma ib_isert ib_iser ib_srpt
> ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad
> ipmi_devintf sb_edac iTCO_wdt edac_core iTCO_vendor_support
> x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass
> zfs(PO) raid10 zunicode(PO) zavl(PO) zcommon(PO) znvpair(PO) spl(O)
> joydev pcspkr i2c_i801 i2c_smbus sg lpc_ich mfd_core mei_me mei
> ioatdma shpchp ipmi_si ipmi_msghandler acpi_power_meter acpi_pad
> ip_tables xfs libcrc32c mlx4_en mlx4_ib rdma_cm iw_cm ib_cm raid1
> mlx5_ib ib_core sd_mod 8021q garp mrp crct10dif_pclmul crc32_pclmul
> ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper
> cryptd ast mlx5_core
> [  169.382550]  drm_kms_helper syscopyarea sysfillrect sysimgblt
> fb_sys_fops ttm mlx4_core ahci drm igb libahci dca ptp libata pps_core
> i2c_algo_bit wmi sunrpc dm_mirror dm_region_hash dm_log dm_mod
> [  169.382648] CPU: 29 PID: 27710 Comm: kworker/u69:1 Tainted: P
>     O    4.9.32-2.el7.centos.x86_64 #1
> [  169.382699] Hardware name: Supermicro SYS-6028TP-HTFR/X10DRT-PIBF,
> BIOS 1.1 08/03/2015
> [  169.382741] Workqueue: ib-comp-wq ib_cq_poll_work [ib_core]
> [  169.382761] task: ffff887ebd3c0000 task.stack: ffffc900c2258000
> [  169.382780] RIP: 0010:[<ffffffffa051e968>]  [<ffffffffa051e968>]
> isert_login_recv_done+0x28/0x170 [ib_isert]
> [  169.382812] RSP: 0018:ffffc900c225bd90  EFLAGS: 00010206
> [  169.382829] RAX: 0000000000000000 RBX: ffff887ec700a000 RCX: 00000000000000f0
> [  169.382852] RDX: ffff887ee0a9d080 RSI: ffff887ed46ca000 RDI: 0000000000000005
> [  169.382873] RBP: ffffc900c225bda8 R08: 0000000000000fff R09: ffff887f655a8c00
> [  169.382895] R10: 0000000000000101 R11: ffff887ed46cadd8 R12: 0000000000000040
> [  169.382917] R13: ffff887ed46ca000 R14: 0000000000000000 R15: ffff887ed46cac00
> [  169.383857] FS:  0000000000000000(0000) GS:ffff887f7f540000(0000)
> knlGS:0000000000000000
> [  169.384728] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  169.385554] CR2: 0000000000000000 CR3: 0000000001c07000 CR4: 00000000001406e0
> [  169.386380] Stack:
> [  169.387223]  0000000000000000 0000000000000040 0000000000000001
> ffffc900c225bde8
> [  169.388100]  ffffffffa01a9d90 00010000aec95982 ffff887ed46cac40
> ffff887ed46cac00
> [  169.388966]  ffff887f655a8c00 ffff887f5ddbf500 00000000000008a0
> ffffc900c225be08
> [  169.389865] Call Trace:
> [  169.390762]  [<ffffffffa01a9d90>] __ib_process_cq+0x50/0xd0 [ib_core]
> [  169.391624]  [<ffffffffa01a9e80>] ib_cq_poll_work+0x20/0x60 [ib_core]
> [  169.392527]  [<ffffffff8109d0b2>] process_one_work+0x152/0x400
> [  169.393378]  [<ffffffff8109d9a5>] worker_thread+0x125/0x4b0
> [  169.394224]  [<ffffffff8109d880>] ? rescuer_thread+0x380/0x380
> [  169.395063]  [<ffffffff8109d880>] ? rescuer_thread+0x380/0x380
> [  169.395951]  [<ffffffff810a36b6>] kthread+0xe6/0x100
> [  169.396847]  [<ffffffff810a35d0>] ? kthread_park+0x60/0x60
> [  169.397733]  [<ffffffff8177ba55>] ret_from_fork+0x25/0x30
> [  169.398533] Code: 00 00 00 0f 1f 44 00 00 55 48 89 e5 41 55 49 89
> f5 41 54 53 48 8b 46 18 8b 7e 08 48 8b 98 98 00 00 00 85 ff 48 8b 83
> 48 11 00 00 <4c> 8b 20 0f 85 1f 01 00 00 49 8b 84 24 18 03 00 00 48 8b
> 73 20
> [  169.400367] RIP  [<ffffffffa051e968>]
> isert_login_recv_done+0x28/0x170 [ib_isert]
> [  169.401224]  RSP <ffffc900c225bd90>
> [  169.402033] CR2: 0000000000000000
> [  169.402853] ---[ end trace 1034240ecf8f1811 ]---
> [  169.406112] BUG: unable to handle kernel paging request at ffffffffffffffd8
> [  169.407583] IP: [<ffffffff810a43c0>] kthread_data+0x10/0x20
> [  169.408401] PGD 1c0a067
> [  169.408409] PUD 1c0c067
> [  169.409154] PMD 0
>
> [  169.409929] Oops: 0000 [#2] SMP
> [  169.410709] Modules linked in: ip_vs nf_conntrack macvlan bonding
> target_core_user uio target_core_pscsi target_core_file
> target_core_iblock iptable_filter rpcrdma ib_isert ib_iser ib_srpt
> ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad
> ipmi_devintf sb_edac iTCO_wdt edac_core iTCO_vendor_support
> x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass
> zfs(PO) raid10 zunicode(PO) zavl(PO) zcommon(PO) znvpair(PO) spl(O)
> joydev pcspkr i2c_i801 i2c_smbus sg lpc_ich mfd_core mei_me mei
> ioatdma shpchp ipmi_si ipmi_msghandler acpi_power_meter acpi_pad
> ip_tables xfs libcrc32c mlx4_en mlx4_ib rdma_cm iw_cm ib_cm raid1
> mlx5_ib ib_core sd_mod 8021q garp mrp crct10dif_pclmul crc32_pclmul
> ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper
> cryptd ast mlx5_core
> [  169.415588]  drm_kms_helper syscopyarea sysfillrect sysimgblt
> fb_sys_fops ttm mlx4_core ahci drm igb libahci dca ptp libata pps_core
> i2c_algo_bit wmi sunrpc dm_mirror dm_region_hash dm_log dm_mod
> [  169.417156] CPU: 29 PID: 27710 Comm: kworker/u69:1 Tainted: P
> D    O    4.9.32-2.el7.centos.x86_64 #1
> [  169.417887] Hardware name: Supermicro SYS-6028TP-HTFR/X10DRT-PIBF,
> BIOS 1.1 08/03/2015
> [  169.418626] task: ffff887ebd3c0000 task.stack: ffffc900c2258000
> [  169.419353] RIP: 0010:[<ffffffff810a43c0>]  [<ffffffff810a43c0>]
> kthread_data+0x10/0x20
> [  169.420088] RSP: 0018:ffffc900c225be68  EFLAGS: 00010002
> [  169.420808] RAX: 0000000000000000 RBX: ffff887f7f559000 RCX: 000000000000001d
> [  169.421527] RDX: ffff883f7f410000 RSI: ffff887ebd3c0000 RDI: ffff887ebd3c0000
> [  169.422244] RBP: ffffc900c225be68 R08: ffff887ebd3c00a8 R09: 00000000001450d7
> [  169.422964] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000019000
> [  169.423680] R13: ffff887ebd3c0000 R14: ffff887ebd3c09c0 R15: 0000000000000000
> [  169.424398] FS:  0000000000000000(0000) GS:ffff887f7f540000(0000)
> knlGS:0000000000000000
> [  169.425122] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  169.425838] CR2: 0000000000000028 CR3: 0000000001c07000 CR4: 00000000001406e0
> [  169.426553] Stack:
> [  169.427267]  ffffc900c225be78 ffffffff8109e28e ffffc900c225bec8
> ffffffff81776aa6
> [  169.427990]  0000000000000000 ffff887ee6435f34 ffff887ee9ba7b88
> ffff887ebd3c0000
> [  169.428713]  ffff887ebd3c0000 ffff887ebd3c0000 ffffc900c225b638
> ffff883f66b00000
> [  169.429427] Call Trace:
> [  169.430129]  [<ffffffff8109e28e>] wq_worker_sleeping+0xe/0x90
> [  169.430857]  [<ffffffff81776aa6>] __schedule+0x426/0x6a0
> [  169.431566]  [<ffffffff810b14c8>] do_task_dead+0x38/0x40
> [  169.432278]  [<ffffffff81087f12>] do_exit+0x632/0xac0
> [  169.433064]  [<ffffffff8177d0c7>] rewind_stack_do_exit+0x17/0x20
> [  169.433743] Code: 55 be 01 00 00 00 48 89 e5 e8 dd fe ff ff 5d c3
> 90 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 8b 87 48 09 00
> 00 48 89 e5 <48> 8b 40 d8 5d c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44
> 00 00
> [  169.435285] RIP  [<ffffffff810a43c0>] kthread_data+0x10/0x20
> [  169.436008]  RSP <ffffc900c225be68>
> [  169.436727] CR2: ffffffffffffffd8
> [  169.437448] ---[ end trace 1034240ecf8f1812 ]---
> [  169.440151] Fixing recursive fault but reboot is needed!
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1

I'm kind of wondering if we are hitting a race condition in the
discovery/login process. We have scripts that contact the target,
exports the LUN, then does a discovery, a login, then a rescan of the
scsi bus each time, even if it has already discovered and logged in
before. This script can be called in parallel and handle hundreds of
LUNs on multiple targets. Here are the commands that our script runs:

do_cmd('/sbin/iscsiadm -m discovery -t st -p %s:3264 -o new -I iser' % san_ip)
do_cmd('/sbin/iscsiadm -m node --login -I iser -T %s:iser-%s -p
%s:3264' % (prefix, san, san_ip))
os.system("for i in /sys/class/scsi_host/host*/scan; do echo '- - -' >
$i; done")

My co-worker reports the following:

"""
Digging into the source code and the disassembled ib_isert.ko it seems
that the problem is a NULL pointer dereference in
isert_create_send_desc(), this function is trying to access
device->pd->local_dma_lkey, and device->pd is NULL.

    if (tx_desc->tx_sg[0].lkey != device->pd->local_dma_lkey) {
        tx_desc->tx_sg[0].lkey = device->pd->local_dma_lkey;
         isert_dbg("tx_desc %p lkey mismatch, fixing\n", tx_desc);
    }
"""

It makes me think that something in the discovery/login process isn't
protected in the case there is another discovery/login process going
on at the same time.

Thank you,

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
