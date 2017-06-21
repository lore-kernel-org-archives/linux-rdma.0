From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: NULL pointer dereference in isert_login_recv_done in 4.9.32
Date: Wed, 21 Jun 2017 10:33:45 -0600
Message-ID: <CAANLjFoQcmfkjq9N1fehTC9Zi6aOC7ArOEPXz-he3EnOvWeEDw@mail.gmail.com>
References: <CAANLjFoaZ8ueEQet3Yu6LygmxXBbQ0cHUEYsb2xEON0o3N9=+w@mail.gmail.com>
 <CAANLjFp6Y8wvLvmWrk1ECjm-OoyEppxD1svNYKpg+HDEZevJig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFp6Y8wvLvmWrk1ECjm-OoyEppxD1svNYKpg+HDEZevJig-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 21, 2017 at 9:17 AM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
> On Tue, Jun 20, 2017 at 12:54 PM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
>> We have hit this four times today. Any ideas?
>>
>> [  169.382113] BUG: unable to handle kernel NULL pointer dereference
>> at           (null)
>> [  169.382152] IP: [<ffffffffa051e968>]
>> isert_login_recv_done+0x28/0x170 [ib_isert]
>> [  169.382182] PGD 0
>>
>> [  169.382201] Oops: 0000 [#1] SMP
>> [  169.382214] Modules linked in: ip_vs nf_conntrack macvlan bonding
>> target_core_user uio target_core_pscsi target_core_file
>> target_core_iblock iptable_filter rpcrdma ib_isert ib_iser ib_srpt
>> ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad
>> ipmi_devintf sb_edac iTCO_wdt edac_core iTCO_vendor_support
>> x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass
>> zfs(PO) raid10 zunicode(PO) zavl(PO) zcommon(PO) znvpair(PO) spl(O)
>> joydev pcspkr i2c_i801 i2c_smbus sg lpc_ich mfd_core mei_me mei
>> ioatdma shpchp ipmi_si ipmi_msghandler acpi_power_meter acpi_pad
>> ip_tables xfs libcrc32c mlx4_en mlx4_ib rdma_cm iw_cm ib_cm raid1
>> mlx5_ib ib_core sd_mod 8021q garp mrp crct10dif_pclmul crc32_pclmul
>> ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper
>> cryptd ast mlx5_core
>> [  169.382550]  drm_kms_helper syscopyarea sysfillrect sysimgblt
>> fb_sys_fops ttm mlx4_core ahci drm igb libahci dca ptp libata pps_core
>> i2c_algo_bit wmi sunrpc dm_mirror dm_region_hash dm_log dm_mod
>> [  169.382648] CPU: 29 PID: 27710 Comm: kworker/u69:1 Tainted: P
>>     O    4.9.32-2.el7.centos.x86_64 #1
>> [  169.382699] Hardware name: Supermicro SYS-6028TP-HTFR/X10DRT-PIBF,
>> BIOS 1.1 08/03/2015
>> [  169.382741] Workqueue: ib-comp-wq ib_cq_poll_work [ib_core]
>> [  169.382761] task: ffff887ebd3c0000 task.stack: ffffc900c2258000
>> [  169.382780] RIP: 0010:[<ffffffffa051e968>]  [<ffffffffa051e968>]
>> isert_login_recv_done+0x28/0x170 [ib_isert]
>> [  169.382812] RSP: 0018:ffffc900c225bd90  EFLAGS: 00010206
>> [  169.382829] RAX: 0000000000000000 RBX: ffff887ec700a000 RCX: 00000000000000f0
>> [  169.382852] RDX: ffff887ee0a9d080 RSI: ffff887ed46ca000 RDI: 0000000000000005
>> [  169.382873] RBP: ffffc900c225bda8 R08: 0000000000000fff R09: ffff887f655a8c00
>> [  169.382895] R10: 0000000000000101 R11: ffff887ed46cadd8 R12: 0000000000000040
>> [  169.382917] R13: ffff887ed46ca000 R14: 0000000000000000 R15: ffff887ed46cac00
>> [  169.383857] FS:  0000000000000000(0000) GS:ffff887f7f540000(0000)
>> knlGS:0000000000000000
>> [  169.384728] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  169.385554] CR2: 0000000000000000 CR3: 0000000001c07000 CR4: 00000000001406e0
>> [  169.386380] Stack:
>> [  169.387223]  0000000000000000 0000000000000040 0000000000000001
>> ffffc900c225bde8
>> [  169.388100]  ffffffffa01a9d90 00010000aec95982 ffff887ed46cac40
>> ffff887ed46cac00
>> [  169.388966]  ffff887f655a8c00 ffff887f5ddbf500 00000000000008a0
>> ffffc900c225be08
>> [  169.389865] Call Trace:
>> [  169.390762]  [<ffffffffa01a9d90>] __ib_process_cq+0x50/0xd0 [ib_core]
>> [  169.391624]  [<ffffffffa01a9e80>] ib_cq_poll_work+0x20/0x60 [ib_core]
>> [  169.392527]  [<ffffffff8109d0b2>] process_one_work+0x152/0x400
>> [  169.393378]  [<ffffffff8109d9a5>] worker_thread+0x125/0x4b0
>> [  169.394224]  [<ffffffff8109d880>] ? rescuer_thread+0x380/0x380
>> [  169.395063]  [<ffffffff8109d880>] ? rescuer_thread+0x380/0x380
>> [  169.395951]  [<ffffffff810a36b6>] kthread+0xe6/0x100
>> [  169.396847]  [<ffffffff810a35d0>] ? kthread_park+0x60/0x60
>> [  169.397733]  [<ffffffff8177ba55>] ret_from_fork+0x25/0x30
>> [  169.398533] Code: 00 00 00 0f 1f 44 00 00 55 48 89 e5 41 55 49 89
>> f5 41 54 53 48 8b 46 18 8b 7e 08 48 8b 98 98 00 00 00 85 ff 48 8b 83
>> 48 11 00 00 <4c> 8b 20 0f 85 1f 01 00 00 49 8b 84 24 18 03 00 00 48 8b
>> 73 20
>> [  169.400367] RIP  [<ffffffffa051e968>]
>> isert_login_recv_done+0x28/0x170 [ib_isert]
>> [  169.401224]  RSP <ffffc900c225bd90>
>> [  169.402033] CR2: 0000000000000000
>> [  169.402853] ---[ end trace 1034240ecf8f1811 ]---
>> [  169.406112] BUG: unable to handle kernel paging request at ffffffffffffffd8
>> [  169.407583] IP: [<ffffffff810a43c0>] kthread_data+0x10/0x20
>> [  169.408401] PGD 1c0a067
>> [  169.408409] PUD 1c0c067
>> [  169.409154] PMD 0
>>
>> [  169.409929] Oops: 0000 [#2] SMP
>> [  169.410709] Modules linked in: ip_vs nf_conntrack macvlan bonding
>> target_core_user uio target_core_pscsi target_core_file
>> target_core_iblock iptable_filter rpcrdma ib_isert ib_iser ib_srpt
>> ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad
>> ipmi_devintf sb_edac iTCO_wdt edac_core iTCO_vendor_support
>> x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass
>> zfs(PO) raid10 zunicode(PO) zavl(PO) zcommon(PO) znvpair(PO) spl(O)
>> joydev pcspkr i2c_i801 i2c_smbus sg lpc_ich mfd_core mei_me mei
>> ioatdma shpchp ipmi_si ipmi_msghandler acpi_power_meter acpi_pad
>> ip_tables xfs libcrc32c mlx4_en mlx4_ib rdma_cm iw_cm ib_cm raid1
>> mlx5_ib ib_core sd_mod 8021q garp mrp crct10dif_pclmul crc32_pclmul
>> ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper
>> cryptd ast mlx5_core
>> [  169.415588]  drm_kms_helper syscopyarea sysfillrect sysimgblt
>> fb_sys_fops ttm mlx4_core ahci drm igb libahci dca ptp libata pps_core
>> i2c_algo_bit wmi sunrpc dm_mirror dm_region_hash dm_log dm_mod
>> [  169.417156] CPU: 29 PID: 27710 Comm: kworker/u69:1 Tainted: P
>> D    O    4.9.32-2.el7.centos.x86_64 #1
>> [  169.417887] Hardware name: Supermicro SYS-6028TP-HTFR/X10DRT-PIBF,
>> BIOS 1.1 08/03/2015
>> [  169.418626] task: ffff887ebd3c0000 task.stack: ffffc900c2258000
>> [  169.419353] RIP: 0010:[<ffffffff810a43c0>]  [<ffffffff810a43c0>]
>> kthread_data+0x10/0x20
>> [  169.420088] RSP: 0018:ffffc900c225be68  EFLAGS: 00010002
>> [  169.420808] RAX: 0000000000000000 RBX: ffff887f7f559000 RCX: 000000000000001d
>> [  169.421527] RDX: ffff883f7f410000 RSI: ffff887ebd3c0000 RDI: ffff887ebd3c0000
>> [  169.422244] RBP: ffffc900c225be68 R08: ffff887ebd3c00a8 R09: 00000000001450d7
>> [  169.422964] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000019000
>> [  169.423680] R13: ffff887ebd3c0000 R14: ffff887ebd3c09c0 R15: 0000000000000000
>> [  169.424398] FS:  0000000000000000(0000) GS:ffff887f7f540000(0000)
>> knlGS:0000000000000000
>> [  169.425122] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  169.425838] CR2: 0000000000000028 CR3: 0000000001c07000 CR4: 00000000001406e0
>> [  169.426553] Stack:
>> [  169.427267]  ffffc900c225be78 ffffffff8109e28e ffffc900c225bec8
>> ffffffff81776aa6
>> [  169.427990]  0000000000000000 ffff887ee6435f34 ffff887ee9ba7b88
>> ffff887ebd3c0000
>> [  169.428713]  ffff887ebd3c0000 ffff887ebd3c0000 ffffc900c225b638
>> ffff883f66b00000
>> [  169.429427] Call Trace:
>> [  169.430129]  [<ffffffff8109e28e>] wq_worker_sleeping+0xe/0x90
>> [  169.430857]  [<ffffffff81776aa6>] __schedule+0x426/0x6a0
>> [  169.431566]  [<ffffffff810b14c8>] do_task_dead+0x38/0x40
>> [  169.432278]  [<ffffffff81087f12>] do_exit+0x632/0xac0
>> [  169.433064]  [<ffffffff8177d0c7>] rewind_stack_do_exit+0x17/0x20
>> [  169.433743] Code: 55 be 01 00 00 00 48 89 e5 e8 dd fe ff ff 5d c3
>> 90 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 8b 87 48 09 00
>> 00 48 89 e5 <48> 8b 40 d8 5d c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44
>> 00 00
>> [  169.435285] RIP  [<ffffffff810a43c0>] kthread_data+0x10/0x20
>> [  169.436008]  RSP <ffffc900c225be68>
>> [  169.436727] CR2: ffffffffffffffd8
>> [  169.437448] ---[ end trace 1034240ecf8f1812 ]---
>> [  169.440151] Fixing recursive fault but reboot is needed!
>> ----------------
>> Robert LeBlanc
>> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>
> I'm kind of wondering if we are hitting a race condition in the
> discovery/login process. We have scripts that contact the target,
> exports the LUN, then does a discovery, a login, then a rescan of the
> scsi bus each time, even if it has already discovered and logged in
> before. This script can be called in parallel and handle hundreds of
> LUNs on multiple targets. Here are the commands that our script runs:
>
> do_cmd('/sbin/iscsiadm -m discovery -t st -p %s:3264 -o new -I iser' % san_ip)
> do_cmd('/sbin/iscsiadm -m node --login -I iser -T %s:iser-%s -p
> %s:3264' % (prefix, san, san_ip))
> os.system("for i in /sys/class/scsi_host/host*/scan; do echo '- - -' >
> $i; done")
>
> My co-worker reports the following:
>
> """
> Digging into the source code and the disassembled ib_isert.ko it seems
> that the problem is a NULL pointer dereference in
> isert_create_send_desc(), this function is trying to access
> device->pd->local_dma_lkey, and device->pd is NULL.
>
>     if (tx_desc->tx_sg[0].lkey != device->pd->local_dma_lkey) {
>         tx_desc->tx_sg[0].lkey = device->pd->local_dma_lkey;
>          isert_dbg("tx_desc %p lkey mismatch, fixing\n", tx_desc);
>     }
> """
>
> It makes me think that something in the discovery/login process isn't
> protected in the case there is another discovery/login process going
> on at the same time.
>
> Thank you,
>
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1

There is certainly something unsafe it the discovery/login code path
for iSER. If I run the following three commands on the same initiator
at the same time (one command each in their own window with
clusterSSH) with iSER, things blow up pretty bad.

SAN=2604:3140:40:300:0:580:12:0; iscsiadm -m discovery -t st-p $SAN -o
new -I iser; iscsiadm -m node --login -I iser -T iqn.2017-06.com.test
-p $SAN; for i in /sys/class/scsi_host/host*/scan; do echo '- - -' >
$i; done
SAN=2604:3140:40:300:1:580:13:0; iscsiadm -m discovery -t st-p $SAN -o
new -I iser; iscsiadm -m node --login -I iser -T iqn.2017-06.com.test
-p $SAN; for i in /sys/class/scsi_host/host*/scan; do echo '- - -' >
$i; done
SAN=2604:3140:40:300:2:580:14:0; iscsiadm -m discovery -t st-p $SAN -o
new -I iser; iscsiadm -m node --login -I iser -T iqn.2017-06.com.test
-p $SAN; for i in /sys/class/scsi_host/host*/scan; do echo '- - -' >
$i; done

If I take the same commands run in clusterSSH, but with TCP and not
iSER, there isn't any problems and I can run it over and over, no
messages in dmesg, no errors from iscsiadm. Not all session may get
logged in, but it handles the concurrent commands without blowing up.

Here is an error from iscsiadm:
iscsiadm: Received iferror -12: Cannot allocate memory.
iscsiadm: Could not bind conn 6:0 to session 6, (err 0)
iscsiadm: Received iferror -22: Invalid argument.
iscsiadm: connection 6:0 transport disconnect failed for ep 2 with error -22.
iscsiadm: Received iferror -22: Invalid argument.
iscsiadm: Could not safely destroy connection 6:0
iscsiadm: Received iferror -22: Invalid argument.
iscsiadm: Could not safely destroy session 6
iscsiadm: Connection to discovery portal 2604:3140:40:300:1:580:13:0
failed: internal error
iscsiadm: Received iferror -12: Cannot allocate memory.
iscsiadm: can't set operational parameter 18 for connection 9:0, retcode -12 (0)
iscsiadm: Could not set iscsi params for conn 9:0 (err 1)
iscsiadm: Received iferror -22: Invalid argument.
iscsiadm: connection 9:0 transport disconnect failed for ep 1 with error -22.
iscsiadm: Received iferror -22: Invalid argument.
iscsiadm: Could not safely destroy session 9 (err -22)
iscsiadm: Could not perform SendTargets discovery: internal error
iscsiadm: No records found

And dmesg shows:
[Wed Jun 21 10:16:49 2017] ------------[ cut here ]------------
[Wed Jun 21 10:16:49 2017] WARNING: CPU: 15 PID: 3920 at
fs/sysfs/dir.c:31 sysfs_warn_dup+0x64/0x80
[Wed Jun 21 10:16:49 2017] sysfs: cannot create duplicate filename
'/devices/pci0000:80/0000:80:02.0/0000:81:00.0/host16/session14/connection14:0'
[Wed Jun 21 10:16:49 2017] Modules linked in: ib_iser rdma_ucm ib_ucm
ib_uverbs ib_umad rdma_cm ib_cm iw_cm ipmi_devintf sb_edac edac_core
x86_pkg_temp_thermal iTCO_wdt intel_powerclamp iTCO_vendor_support
coretemp kvm_intel kvm i2c_i801 mei_me mei shpchp joydev irqbypas
s lpc_ich pcspkr sg ioatdma mfd_core i2c_smbus ipmi_si ipmi_msghandler
acpi_power_meter acpi_pad ipt_REJECT nf_reject_ipv4 nf_conntrack_ipv4
nf_defrag_ipv4 xt_conntrack nf_conntrack iptable_filter nfsd
auth_rpcgss nfs_acl lockd grace ip_tables xfs libcrc32c mlx4_en mlx4_
ib raid1 dm_service_time sd_mod mlx5_ib 8021q garp mrp be2iscsi bnx2i
cnic uio cxgb4i iw_cxgb4 cxgb4 cxgb3i iw_cxgb3 ib_core cxgb3 mdio
libcxgbi libcxgb qla4xxx iscsi_boot_sysfs crct10dif_pclmul
crc32_pclmul ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper
ablk_h
elper cryptd
[Wed Jun 21 10:16:49 2017]  ast mlx5_core drm_kms_helper syscopyarea
sysfillrect sysimgblt fb_sys_fops ttm drm ahci mlx4_core libahci igb
dca libata ptp pps_core i2c_algo_bit wmi dm_multipath sunrpc dm_mirror
dm_region_hash dm_log dm_mod
[Wed Jun 21 10:16:49 2017] CPU: 15 PID: 3920 Comm: iscsiadm Tainted: G
       W       4.9.32-2.el7.centos.x86_64 #1
[Wed Jun 21 10:16:49 2017] Hardware name: Supermicro
SYS-6028TP-HTFR/X10DRT-PIBF, BIOS 1.1 08/03/2015
[Wed Jun 21 10:16:49 2017]  ffffc90035cc38c0 ffffffff8134fbdc
ffffc90035cc3910 0000000000000000
[Wed Jun 21 10:16:49 2017]  ffffc90035cc3900 ffffffff81083501
0000001f00001000 ffff883f604fa000
[Wed Jun 21 10:16:49 2017]  ffff883f604d9c10 ffff887f5fa2dac8
ffff887f51316950 0000000000000000
[Wed Jun 21 10:16:49 2017] Call Trace:
[Wed Jun 21 10:16:49 2017]  [<ffffffff8134fbdc>] dump_stack+0x63/0x87
[Wed Jun 21 10:16:49 2017]  [<ffffffff81083501>] __warn+0xd1/0xf0
[Wed Jun 21 10:16:49 2017]  [<ffffffff8108357f>] warn_slowpath_fmt+0x5f/0x80
[Wed Jun 21 10:16:49 2017]  [<ffffffff812958b0>] ?
kernfs_path_from_node+0x50/0x60
[Wed Jun 21 10:16:49 2017]  [<ffffffff812990b4>] sysfs_warn_dup+0x64/0x80
[Wed Jun 21 10:16:49 2017]  [<ffffffff8129919e>] sysfs_create_dir_ns+0x7e/0x90
[Wed Jun 21 10:16:49 2017]  [<ffffffff81352b82>] kobject_add_internal+0xa2/0x320
[Wed Jun 21 10:16:49 2017]  [<ffffffff81353035>] kobject_add+0x75/0xd0
[Wed Jun 21 10:16:49 2017]  [<ffffffff8149cf69>] device_add+0x119/0x610
[Wed Jun 21 10:16:49 2017]  [<ffffffff8149d47a>] device_register+0x1a/0x20
[Wed Jun 21 10:16:49 2017]  [<ffffffff814ee88c>] iscsi_create_conn+0xbc/0x190
[Wed Jun 21 10:16:49 2017]  [<ffffffff814f401b>] iscsi_conn_setup+0x2b/0x1f0
[Wed Jun 21 10:16:49 2017]  [<ffffffffa06f2c92>]
iscsi_iser_conn_create+0x12/0x30 [ib_iser]
[Wed Jun 21 10:16:49 2017]  [<ffffffff814ed32e>] iscsi_if_recv_msg+0x9ce/0x1390
[Wed Jun 21 10:16:49 2017]  [<ffffffff811ef00b>] ? __slab_free+0x9b/0x280
[Wed Jun 21 10:16:49 2017]  [<ffffffff81631bc1>] ? skb_free_head+0x21/0x40
[Wed Jun 21 10:16:49 2017]  [<ffffffff811f1aa4>] ?
__kmalloc_node_track_caller+0x214/0x280
[Wed Jun 21 10:16:49 2017]  [<ffffffff814edd7e>] iscsi_if_rx+0x8e/0x1f0
[Wed Jun 21 10:16:49 2017]  [<ffffffff81680cb1>] netlink_unicast+0x181/0x240
[Wed Jun 21 10:16:49 2017]  [<ffffffff816810a1>] netlink_sendmsg+0x331/0x3b0
[Wed Jun 21 10:16:49 2017]  [<ffffffff8162aaa8>] sock_sendmsg+0x38/0x50
[Wed Jun 21 10:16:49 2017]  [<ffffffff8162b3f9>] ___sys_sendmsg+0x279/0x290
[Wed Jun 21 10:16:49 2017]  [<ffffffff8107fb21>] ? __mmdrop+0x91/0xf0
[Wed Jun 21 10:16:49 2017]  [<ffffffff810aca6d>] ?
finish_task_switch+0x19d/0x240
[Wed Jun 21 10:16:49 2017]  [<ffffffff817768a4>] ? __schedule+0x224/0x6a0
[Wed Jun 21 10:16:49 2017]  [<ffffffff810f6b29>] ?
hrtimer_try_to_cancel+0x29/0x130
[Wed Jun 21 10:16:49 2017]  [<ffffffff8177a257>] ? do_nanosleep+0x97/0xf0
[Wed Jun 21 10:16:49 2017]  [<ffffffff8162be04>] __sys_sendmsg+0x54/0x90
[Wed Jun 21 10:16:49 2017]  [<ffffffff8162be52>] SyS_sendmsg+0x12/0x20
[Wed Jun 21 10:16:49 2017]  [<ffffffff8177b7f7>]
entry_SYSCALL_64_fastpath+0x1a/0xa9
[Wed Jun 21 10:16:49 2017] ---[ end trace 3903258af3dafcd0 ]---
[Wed Jun 21 10:16:49 2017] ------------[ cut here ]------------
[Wed Jun 21 10:16:49 2017] ------------[ cut here ]------------
[Wed Jun 21 10:16:49 2017] WARNING: CPU: 15 PID: 3920 at
lib/kobject.c:240 kobject_add_internal+0x2b5/0x320
[Wed Jun 21 10:16:49 2017] kobject_add_internal failed for
connection14:0 with -EEXIST, don't try to register things with the
same name in the same directory.
[Wed Jun 21 10:16:49 2017] Modules linked in: ib_iser rdma_ucm ib_ucm
ib_uverbs ib_umad rdma_cm ib_cm iw_cm ipmi_devintf sb_edac edac_core
x86_pkg_temp_thermal iTCO_wdt intel_powerclamp iTCO_vendor_support
coretemp kvm_intel kvm i2c_i801 mei_me mei shpchp joydev irqbypas
s lpc_ich pcspkr sg ioatdma mfd_core i2c_smbus ipmi_si ipmi_msghandler
acpi_power_meter acpi_pad ipt_REJECT nf_reject_ipv4 nf_conntrack_ipv4
nf_defrag_ipv4 xt_conntrack nf_conntrack iptable_filter nfsd
auth_rpcgss nfs_acl lockd grace ip_tables xfs libcrc32c mlx4_en mlx4_
ib raid1 dm_service_time sd_mod mlx5_ib 8021q garp mrp be2iscsi bnx2i
cnic uio cxgb4i iw_cxgb4 cxgb4 cxgb3i iw_cxgb3 ib_core cxgb3 mdio
libcxgbi libcxgb qla4xxx iscsi_boot_sysfs crct10dif_pclmul
crc32_pclmul ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper
ablk_h
elper cryptd
[Wed Jun 21 10:16:49 2017]  ast mlx5_core drm_kms_helper syscopyarea
sysfillrect sysimgblt fb_sys_fops ttm drm ahci mlx4_core libahci igb
dca libata ptp pps_core i2c_algo_bit wmi dm_multipath sunrpc dm_mirror
dm_region_hash dm_log dm_mod
[Wed Jun 21 10:16:49 2017] CPU: 15 PID: 3920 Comm: iscsiadm Tainted: G
       W       4.9.32-2.el7.centos.x86_64 #1
[Wed Jun 21 10:16:49 2017] Hardware name: Supermicro
SYS-6028TP-HTFR/X10DRT-PIBF, BIOS 1.1 08/03/2015
[Wed Jun 21 10:16:49 2017]  ffffc90035cc3910 ffffffff8134fbdc
ffffc90035cc3960 0000000000000000
[Wed Jun 21 10:16:49 2017]  ffffc90035cc3950 ffffffff81083501
000000f035cc3978 ffff887f54639868
[Wed Jun 21 10:16:49 2017]  ffff887f51316950 00000000ffffffef
ffff887f51316950 0000000000000000
[Wed Jun 21 10:16:49 2017] Call Trace:
[Wed Jun 21 10:16:49 2017]  [<ffffffff8134fbdc>] dump_stack+0x63/0x87
[Wed Jun 21 10:16:49 2017]  [<ffffffff81083501>] __warn+0xd1/0xf0
[Wed Jun 21 10:16:49 2017]  [<ffffffff8108357f>] warn_slowpath_fmt+0x5f/0x80
[Wed Jun 21 10:16:49 2017]  [<ffffffff812990bc>] ? sysfs_warn_dup+0x6c/0x80
[Wed Jun 21 10:16:49 2017]  [<ffffffff81352d95>]
kobject_add_internal+0x2b5/0x320
[Wed Jun 21 10:16:49 2017]  [<ffffffff81353035>] kobject_add+0x75/0xd0
[Wed Jun 21 10:16:49 2017]  [<ffffffff8149cf69>] device_add+0x119/0x610
[Wed Jun 21 10:16:49 2017]  [<ffffffff8149d47a>] device_register+0x1a/0x20
[Wed Jun 21 10:16:49 2017]  [<ffffffff814ee88c>] iscsi_create_conn+0xbc/0x190
[Wed Jun 21 10:16:49 2017]  [<ffffffff814f401b>] iscsi_conn_setup+0x2b/0x1f0
[Wed Jun 21 10:16:49 2017]  [<ffffffffa06f2c92>]
iscsi_iser_conn_create+0x12/0x30 [ib_iser]
[Wed Jun 21 10:16:49 2017]  [<ffffffff814ed32e>] iscsi_if_recv_msg+0x9ce/0x1390
[Wed Jun 21 10:16:49 2017]  [<ffffffff811ef00b>] ? __slab_free+0x9b/0x280
[Wed Jun 21 10:16:49 2017]  [<ffffffff81631bc1>] ? skb_free_head+0x21/0x40
[Wed Jun 21 10:16:49 2017]  [<ffffffff811f1aa4>] ?
__kmalloc_node_track_caller+0x214/0x280
[Wed Jun 21 10:16:49 2017]  [<ffffffff814edd7e>] iscsi_if_rx+0x8e/0x1f0
[Wed Jun 21 10:16:49 2017]  [<ffffffff81680cb1>] netlink_unicast+0x181/0x240
[Wed Jun 21 10:16:49 2017]  [<ffffffff816810a1>] netlink_sendmsg+0x331/0x3b0
[Wed Jun 21 10:16:49 2017]  [<ffffffff8162aaa8>] sock_sendmsg+0x38/0x50
[Wed Jun 21 10:16:49 2017]  [<ffffffff8162b3f9>] ___sys_sendmsg+0x279/0x290
[Wed Jun 21 10:16:49 2017]  [<ffffffff8107fb21>] ? __mmdrop+0x91/0xf0
[Wed Jun 21 10:16:49 2017]  [<ffffffff810aca6d>] ?
finish_task_switch+0x19d/0x240
[Wed Jun 21 10:16:49 2017]  [<ffffffff817768a4>] ? __schedule+0x224/0x6a0
[Wed Jun 21 10:16:49 2017]  [<ffffffff810f6b29>] ?
hrtimer_try_to_cancel+0x29/0x130
[Wed Jun 21 10:16:49 2017]  [<ffffffff8177a257>] ? do_nanosleep+0x97/0xf0
[Wed Jun 21 10:16:49 2017]  [<ffffffff8162be04>] __sys_sendmsg+0x54/0x90
[Wed Jun 21 10:16:49 2017]  [<ffffffff8162be52>] SyS_sendmsg+0x12/0x20
[Wed Jun 21 10:16:49 2017]  [<ffffffff8177b7f7>]
entry_SYSCALL_64_fastpath+0x1a/0xa9
[Wed Jun 21 10:16:49 2017] ---[ end trace 3903258af3dafcd1 ]---
[Wed Jun 21 10:16:49 2017]  session14: could not register connection's dev
[Wed Jun 21 10:16:49 2017]  session14: couldn't create a new connection.
[Wed Jun 21 10:16:49 2017]  connection14:0: Login/Text in progress.
Cannot start new task.

[Wed Jun 21 10:19:21 2017] INFO: task kworker/10:2:1341 blocked for
more than 120 seconds.
[Wed Jun 21 10:19:21 2017]       Tainted: G        W
4.9.32-2.el7.centos.x86_64 #1
[Wed Jun 21 10:19:21 2017] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Wed Jun 21 10:19:21 2017] kworker/10:2    D    0  1341      2 0x00000000
[Wed Jun 21 10:19:21 2017] Workqueue: release workqueue
iser_release_work [ib_iser]
[Wed Jun 21 10:19:21 2017]  ffff887f5f941f00 0000000000000000
ffff887f4245cb80 ffff887f666225c0
[Wed Jun 21 10:19:21 2017]  ffff887f7f299000 ffffc90032edfcc0
ffffffff8177689c ffffffff810c33ee
[Wed Jun 21 10:19:21 2017]  ffffc90032edfdb4 ffff887f65a1fa08
ffff887f4245cb80 7fffffffffffffff
[Wed Jun 21 10:19:21 2017] Call Trace:
[Wed Jun 21 10:19:21 2017]  [<ffffffff8177689c>] ? __schedule+0x21c/0x6a0
[Wed Jun 21 10:19:21 2017]  [<ffffffff810c33ee>] ? load_balance+0x19e/0x9c0
[Wed Jun 21 10:19:21 2017]  [<ffffffff81776d56>] schedule+0x36/0x80
[Wed Jun 21 10:19:21 2017]  [<ffffffff81779f7c>] schedule_timeout+0x21c/0x3a0
[Wed Jun 21 10:19:21 2017]  [<ffffffff81037b19>] ? sched_clock+0x9/0x10
[Wed Jun 21 10:19:21 2017]  [<ffffffff81777842>] wait_for_completion+0xf2/0x130
[Wed Jun 21 10:19:21 2017]  [<ffffffff810b0150>] ? wake_up_q+0x80/0x80
[Wed Jun 21 10:19:21 2017]  [<ffffffffa06eee05>]
iser_release_work+0x25/0x60 [ib_iser]
[Wed Jun 21 10:19:21 2017]  [<ffffffff8109d0b2>] process_one_work+0x152/0x400
[Wed Jun 21 10:19:21 2017]  [<ffffffff8109d9a5>] worker_thread+0x125/0x4b0
[Wed Jun 21 10:19:21 2017]  [<ffffffff8109d880>] ? rescuer_thread+0x380/0x380
[Wed Jun 21 10:19:21 2017]  [<ffffffff8109d880>] ? rescuer_thread+0x380/0x380
[Wed Jun 21 10:19:21 2017]  [<ffffffff810a36b6>] kthread+0xe6/0x100
[Wed Jun 21 10:19:21 2017]  [<ffffffff810a35d0>] ? kthread_park+0x60/0x60
[Wed Jun 21 10:19:21 2017]  [<ffffffff8177ba55>] ret_from_fork+0x25/0x30

With trying a few times, iscsiadm -m session has lots of erronious
entries that don't show up with TCP:
# iscsiadm -m session
tcp: [1] 10.88.0.11:3260,1 iqn.2004-12.com.betterservers:10.88.0.11 (non-flash)
iscsiadm: could not read session targetname: 5
iscsiadm: could not find session info for session10
iser: [12] [2604:3140:40:300:2:580:14:0]:3260,1 iqn.2017-06.com.test (non-flash)
iscsiadm: could not read session targetname: 5
iscsiadm: could not find session info for session15
iscsiadm: could not read session targetname: 5
iscsiadm: could not find session info for session16
iscsiadm: could not read session targetname: 5
iscsiadm: could not find session info for session17
iscsiadm: could not read session targetname: 5
iscsiadm: could not find session info for session18
tcp: [2] 10.88.0.12:3260,1 iqn.2004-12.com.betterservers:10.88.0.12 (non-flash)
iser: [20] [2604:3140:40:300:0:580:12:0]:3260,1 iqn.2017-06.com.test (non-flash)
iscsiadm: could not read session targetname: 5
iscsiadm: could not find session info for session21
iscsiadm: could not read session targetname: 5
iscsiadm: could not find session info for session23
iscsiadm: could not read session targetname: 5
iscsiadm: could not find session info for session24
iscsiadm: could not read session targetname: 5
iscsiadm: could not find session info for session25
iscsiadm: could not read session targetname: 5
iscsiadm: could not find session info for session26
iscsiadm: could not read session targetname: 5
iscsiadm: could not find session info for session27
iscsiadm: could not read session targetname: 5
iscsiadm: could not find session info for session7
iscsiadm: could not read session targetname: 5
iscsiadm: could not find session info for session8


Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
