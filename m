From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: rdma_cm NULL deref in 4.11.0+
Date: Sun, 21 May 2017 16:59:36 +0300
Message-ID: <acc72471-eb22-4474-04f5-db23227faadd@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Just stepped on it,

Simple nvmf connect triggers it, is this known?
Also, rping client segfaults so librdmacm seems to be broken.

--
[   16.809498] BUG: unable to handle kernel NULL pointer dereference at 
0000000000000008
[   16.812570] IP: __radix_tree_lookup+0xe/0xf0
[   16.814172] PGD 0
[   16.814174] P4D 0

[   16.815052] Oops: 0000 [#1] SMP
[   16.815401] Modules linked in: nvme_loop nvme_fabrics nvme_core 
nvmet_rdma nvmet rdma_cm iw_cm null_blk mlx5_ib iscsi_target_mod ib_srpt 
ib_cm ib_core tcm_loop tcm_fc libfc tcm_qla2xxx qla2xxx 
scsi_transport_fc usb_f_tcm tcm_usb_gadget libcomposite udc_core 
vhost_scsi vhost target_core_file target_core_iblock target_core_pscsi 
target_core_mod configfs kvm_intel kvm irqbypass ppdev crct10dif_pclmul 
crc32_pclmul ghash_clmulni_intel pcbc aesni_intel aes_x86_64 crypto_simd 
glue_helper cryptd input_leds joydev serio_raw i2c_piix4 parport_pc 
parport mac_hid sunrpc autofs4 8139too cirrus ttm drm_kms_helper 
mlx5_core syscopyarea ptp sysfillrect psmouse sysimgblt fb_sys_fops 
pps_core drm floppy 8139cp mii pata_acpi
[   16.821972] CPU: 0 PID: 3 Comm: kworker/0:0 Not tainted 4.11.0+ #158
[   16.822656] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
[   16.823630] Workqueue: ib_cm cm_work_handler [ib_cm]
[   16.824144] task: ffff8e013d9810c0 task.stack: ffff9afc801a4000
[   16.824754] RIP: 0010:__radix_tree_lookup+0xe/0xf0
[   16.825248] RSP: 0018:ffff9afc801a7b48 EFLAGS: 00010246
[   16.825791] RAX: ffff8e0135d70f80 RBX: ffff8e0137130a00 RCX: 
0000000000000000
[   16.826497] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 
0000000000000000
[   16.827209] RBP: ffff9afc801a7b50 R08: ffff9afc801a7a48 R09: 
ffff8e0139b35030
[   16.827916] R10: 0000000000000000 R11: 0000000000000040 R12: 
ffff8e0137130a88
[   16.828631] R13: ffff8e0137130a88 R14: ffff8e0135786200 R15: 
ffff8e0137130c00
[   16.829317] FS:  0000000000000000(0000) GS:ffff8e013fc00000(0000) 
knlGS:0000000000000000
[   16.830084] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   16.830629] CR2: 0000000000000008 CR3: 000000000fe09000 CR4: 
00000000003406f0
[   16.831278] Call Trace:
[   16.831511]  radix_tree_lookup+0xd/0x10
[   16.831865]  cma_ps_find+0x59/0x70 [rdma_cm]
[   16.832287]  cma_id_from_event+0xe8/0x5a0 [rdma_cm]
[   16.832734]  cma_req_handler+0x49/0x970 [rdma_cm]
[   16.833166]  ? cma_req_handler+0x49/0x970 [rdma_cm]
[   16.833612]  cm_process_work+0x25/0x120 [ib_cm]
[   16.834026]  ? cm_process_work+0x25/0x120 [ib_cm]
[   16.834455]  ? cm_get_bth_pkey.isra.36+0x3a/0xa0 [ib_cm]
[   16.834938]  cm_req_handler+0xad2/0xd30 [ib_cm]
[   16.835356]  cm_work_handler+0x196/0x16fa [ib_cm]
[   16.835785]  ? cm_work_handler+0x196/0x16fa [ib_cm]
[   16.836263]  process_one_work+0x156/0x3f0
[   16.836631]  worker_thread+0x4b/0x410
[   16.836969]  kthread+0x109/0x140
[   16.837268]  ? process_one_work+0x3f0/0x3f0
[   16.837650]  ? kthread_create_on_node+0x40/0x40
[   16.838070]  ret_from_fork+0x2c/0x40
[   16.838399] Code: ff 45 00 7e 03 e9 64 ff ff ff 4c 89 23 e9 0e ff ff 
ff 90 66 2e 0f 1f 84 00 00 00 00 00 55 49 89 ca 41 bb 40 00 00 00 48 89 
e5 53 <4c> 8b 47 08 4c 89 c0 83 e0 03 48 83 f8 01 0f 85 a9 00 00 00 4c
--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
