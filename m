From: Vladimir Neyelov <vladimirn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] ISER race condition fix
Date: Thu, 18 May 2017 16:16:20 +0300
Message-ID: <1495113381-15564-1-git-send-email-vladimirn@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: root <vladimirn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: root <vladimirn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Heavy iser target(scst) start/stop stress during login/logout on iser initiator side.
I get   Oops : unable to handle kernel paging request

BUG: unable to handle kernel paging request at 0000000000001018
[13403.931396] IP: [<ffffffffc0426f7e>] iscsi_iser_slave_alloc+0x1e/0x50 [ib_iser]
[13403.931599] PGD 0
[13403.931780] Oops: 0000 [#1] SMP
[13403.931958] Modules linked in: dm_round_robin iscsi_tcp libiscsi_tcp ib_iser(OE) libiscsi rdma_ucm(OE) ib_ucm(OE) rdma_cm(OE) iw_cm(OE) ib_ipoib(OE) ib_cm(OE) ib_uverbs(OE) ib_umad(OE) mlx5_ib(OE) mlx5_core(OE) mlx4_ib(OE) ib_core(OE) mlx4_en(OE) ptp pps_core mlx4_core(OE) devlink mlx_compat(OE) knem(OE) nfsv3 nfs fscache ipmi_msghandler ppdev crct10dif_pclmul crc32_pclmul ghash_clmulni_intel 8021q garp mrp stp llc aesni_intel aes_x86_64 snd_hda_codec_generic lrw snd_hda_intel glue_helper ablk_helper cryptd snd_hda_codec snd_hda_core snd_hwdep snd_pcm snd_timer snd joydev input_leds serio_raw soundcore i2c_piix4 parport_pc pvpanic parport mac_hid nfsd auth_rpcgss nfs_acl lockd grace sunrpc dm_multipath configfs scsi_transport_iscsi ip_tables x_tables autofs4 qxl ttm drm_kms_helper sysco
 pyarea psmouse
[13403.933322]  e1000 sysfillrect sysimgblt fb_sys_fops drm pata_acpi floppy [last unloaded: libiscsi]
[13403.933744] CPU: 0 PID: 1810 Comm: iscsid Tainted: G           OE   4.8.0-27-generic #29-Ubuntu
[13403.933971] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[13403.934193] task: ffff9fb83c035580 task.stack: ffff9fb818500000
[13403.934422] RIP: 0010:[<ffffffffc0426f7e>]  [<ffffffffc0426f7e>] iscsi_iser_slave_alloc+0x1e/0x50 [ib_iser]
[13403.934662] RSP: 0018:ffff9fb818503b60  EFLAGS: 00010286
[13403.934891] RAX: 0000000000000000 RBX: ffff9fb81876e000 RCX: ffff9fb81a6bd010
[13403.935124] RDX: ffff9fb81876e000 RSI: 0000000000000202 RDI: ffff9fb81a6bd000
[13403.935390] RBP: ffff9fb818503b90 R08: ffff9fb83fc1c460 R09: 0000000000000000
[13403.935621] R10: ffff9fb838a1a4f8 R11: ffff9fb838a1a4ff R12: ffff9fb804cfd000
[13403.935855] R13: 0000000000000000 R14: ffff9fb804cfd028 R15: ffff9fb81a6bd000
[13403.936088] FS:  00007f85bf22f700(0000) GS:ffff9fb83fc00000(0000) knlGS:0000000000000000
[13403.936330] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[13403.936561] CR2: 0000000000001018 CR3: 0000000018539000 CR4: 00000000000406f0
[13403.936801] Stack:
[13403.937025]  ffffffffb5a0a132 0000000000000002 0000000000000000 ffff9fb81876e208
[13403.937266]  0000000000000000 0000000000000000 ffff9fb818503c90 ffffffffb5a0aca1
[13403.937517]  ffffffffb55c4691 ffff9fb818503bd0 ffffffffb5832196 0000000000000000
[13403.937761] Call Trace:
[13403.937994]  [<ffffffffb5a0a132>] ? scsi_alloc_sdev+0x242/0x300
[13403.938236]  [<ffffffffb5a0aca1>] scsi_probe_and_add_lun+0x9e1/0xea0
[13403.938485]  [<ffffffffb55c4691>] ? kfree_const+0x21/0x30
[13403.938722]  [<ffffffffb5832196>] ? kobject_set_name_vargs+0x76/0x90
[13403.938962]  [<ffffffffb59a945b>] ? __pm_runtime_resume+0x5b/0x70
[13403.939197]  [<ffffffffb5a0bc66>] __scsi_scan_target+0xf6/0x250
[13403.939436]  [<ffffffffb5a0beaa>] scsi_scan_target+0xea/0x100
[13403.939675]  [<ffffffffc0400ce1>] iscsi_user_scan_session.part.13+0x101/0x130 [scsi_transport_iscsi]
[13403.939918]  [<ffffffffc0400d10>] ? iscsi_user_scan_session.part.13+0x130/0x130 [scsi_transport_iscsi]
[13403.940163]  [<ffffffffc0400d2e>] iscsi_user_scan_session+0x1e/0x30 [scsi_transport_iscsi]
[13403.940410]  [<ffffffffb5998670>] device_for_each_child+0x50/0x90
[13403.940650]  [<ffffffffc03fee04>] iscsi_user_scan+0x44/0x60 [scsi_transport_iscsi]
[13403.940892]  [<ffffffffb5a0de28>] store_scan+0xa8/0x100
[13403.941133]  [<ffffffffb57bf16d>] ? common_file_perm+0x5d/0x1c0
[13403.941379]  [<ffffffffb5997e68>] dev_attr_store+0x18/0x30
[13403.941617]  [<ffffffffb56b9a67>] sysfs_kf_write+0x37/0x40
[13403.941851]  [<ffffffffb56b8dac>] kernfs_fop_write+0x12c/0x1c0
[13403.942083]  [<ffffffffb5632598>] __vfs_write+0x18/0x40
[13403.942319]  [<ffffffffb5632cd5>] vfs_write+0xb5/0x1a0
[13403.942546]  [<ffffffffb5634125>] SyS_write+0x55/0xc0
[13403.942773]  [<ffffffffb5c9f076>] entry_SYSCALL_64_fastpath+0x1e/0xa8
[13403.943000] Code: f7 d0 66 25 24 01 5d c3 0f 1f 44 00 00 66 66 66 66 90 48 8b 87 90 01 00 00 48 8b 00 48 8b 40 f8 48 8b 80 10 01 00 00 48 8b 40 08 <48> 8b 80 18 10 00 00 48 8b 00 f6 80 3c 07 00 00 01 74 03 31 c0
[13403.943541] RIP  [<ffffffffc0426f7e>] iscsi_iser_slave_alloc+0x1e/0x50 [ib_iser]
[13403.943779]  RSP <ffff9fb818503b60>
[13403.944000] CR2: 0000000000001018
[13403.947786] ---[ end trace b9fbddb6071bda98 ]---

After investigation I found race condition between two functions iscsi_iser_slave_alloc and  iscsi_iser_conn_stop.
Sometimes iscsi_iser_conn_stop called before iscsi_iser_slave_alloc and executed these lines:
iser_conn->iscsi_conn = NULL;
conn->dd_data = NULL; 
When called iscsi_iser_slave_alloc it try use iser_conn pointer but it already initialized to NULL. 
I added new mutex to synchronize this race. After this patch all tests run successfully.

Thanks,
Vladimir

drivers/infiniband/ulp/iser/iscsi_iser.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
