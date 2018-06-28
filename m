From: "Calciano, Jess" <jess.calciano@intel.com>
Subject: iscsi_trx oops in 4.18.0-rc2 and potential patch for percpu_ida.c
Date: Thu, 28 Jun 2018 19:53:21 +0000
Message-ID: <E079A211AAA8AD48953B67A89DB71C856E7DBC38@fmsmsx104.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "'linux-rdma@vger.kernel.org'" <linux-rdma@vger.kernel.org>
Cc: "bigeasy@linutronix.de" <bigeasy@linutronix.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hello,

In 4.18.0-rc1 and rc2, we're seeing a kernel oops on the SCSI target host when an initiator issues an "iscsiadm -m discovery" command.
Stack trace is below.

It seems to be the same bug discussed on the target-devel list in this thread: https://www.spinics.net/lists/target-devel/msg16815.html
...and resolved with the patch posted there: [PATCH] lib/percpu_ida.c: don't do alloc from per-CPU list if there is none
We tried the patch, and it works to fix the problem in our testing as well.

So although the problem has already been reported, we're wondering if there are any updates on the status of the fix, or if it will be available in an upcoming mainline build.


Thanks,
Jess



[  278.870830] BUG: unable to handle kernel paging request at ffffc128bfa06b34
[  278.878629] PGD 85e46d067 P4D 85e46d067 PUD 0
[  278.883600] Oops: 0000 [#1] SMP PTI
[  278.887500] CPU: 0 PID: 3331 Comm: iscsi_trx Not tainted 4.18.0-rc2 #1
[  278.894799] Hardware name: Intel Corporation S2600WT2R/S2600WT2R, BIOS SE5C610.86B.01.01.0016.033120161139 03/31/2016
[  278.906669] RIP: 0010:percpu_ida_alloc+0x67/0x90
[  278.911831] Code: 8c 48 89 44 24 18 48 89 44 24 20 65 48 03 1d e8 6e c6 73 48 89 df e8 58 b8 3e 00 8b 4b 04 48 89 c6 48 89 df 8d 51 ff 89 53 04 <8b> 6c 93 08 e8 70 b6 3e 00 48 8b 74 24 28 65 48 33 34 25 28 00 00
[  278.932933] RSP: 0018:ffffa12cc8e87db0 EFLAGS: 00010046
[  278.938775] RAX: 0000000000000286 RBX: ffffc124bfa06b30 RCX: 0000000000000000
[  278.946753] RDX: 00000000ffffffff RSI: 0000000000000286 RDI: ffffc124bfa06b30
[  278.954730] RBP: ffff90a819b92000 R08: 0000000000000000 R09: 0000000000000030
[  278.962707] R10: ffff90a016f080c8 R11: 000000000000000c R12: ffffa12cc8e87e58
[  278.970683] R13: ffff90a01baa8000 R14: ffff90a819b92000 R15: ffff90a8197a62d8
[  278.979145] FS:  0000000000000000(0000) GS:ffff90a01f200000(0000) knlGS:0000000000000000
[  278.988606] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  278.995440] CR2: ffffc128bfa06b34 CR3: 000000064220a001 CR4: 00000000003606f0
[  279.003831] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  279.012233] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  279.020609] Call Trace:
[  279.023746]  ? remove_wait_queue+0x60/0x60
[  279.028741]  iscsit_allocate_cmd+0x28/0x110 [iscsi_target_mod]
[  279.035670]  iscsit_get_rx_pdu+0x4bb/0x880 [iscsi_target_mod]
[  279.042506]  ? pick_next_task_fair+0x291/0x620
[  279.047888]  ? __switch_to+0xa8/0x480
[  279.052405]  iscsi_target_rx_thread+0xb5/0xf0 [iscsi_target_mod]
[  279.059552]  kthread+0xf5/0x130
[  279.063499]  ? iscsi_target_tx_thread+0x1f0/0x1f0 [iscsi_target_mod]
[  279.071042]  ? kthread_bind+0x10/0x10
[  279.075576]  ret_from_fork+0x35/0x40
[  279.080007] Modules linked in: target_core_user uio tcm_fc libfc scsi_transport_fc tcm_loop target_core_pscsi target_core_iblock target_core_file rpcrdma ib_isert iscsi_target_mod sunrpc target_core_mod rdma_ucm ib_uverbs ib_ipoib dm_mirror ib_iser dm_region_hash ib_umad dm_log rdma_cm libiscsi ib_cm dm_mod iw_cm scsi_transport_iscsi intel_rapl sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm hfi1 irqbypass joydev crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc rdmavt iTCO_wdt mei_me aesni_intel mei iTCO_vendor_support sg lpc_ich ib_core i2c_i801 crypto_simd cryptd glue_helper ipmi_si mxm_wmi ipmi_devintf ipmi_msghandler pcspkr ioatdma acpi_pad wmi acpi_power_meter ip_tables ext4 mbcache jbd2 sd_mod mgag200 drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops tt
 m drm igb
[  279.162388]  ahci libahci libata crc32c_intel dca i2c_algo_bit i2c_core
[  279.170337] CR2: ffffc128bfa06b34
[  279.174655] ---[ end trace 3b147417c7ae0be8 ]---
