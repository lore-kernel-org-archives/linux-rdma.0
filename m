From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: CRASH 3.18-rc2, 3.17.1, isert_connect_request
Date: Mon, 03 Nov 2014 13:27:18 +0200
Message-ID: <54576696.4000203@dev.mellanox.co.il>
References: <545758C8.4050300@tiktalik.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <545758C8.4050300@tiktalik.com>
Sender: target-devel-owner@vger.kernel.org
To: Adam Mazur <adam.mazur@tiktalik.com>, linux-rdma@vger.kernel.org, target-devel <target-devel@vger.kernel.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Oren Duer <oren@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On 11/3/2014 12:28 PM, Adam Mazur wrote:
> Can someone help us with these crashes? We are not able to recreate it
> on demand, but it takes 30 minutes to a few hours to appear the crash.
> We've seen it on kernel 3.17.1 and 3.18-rc2.
>

Hay Adam,

CC'ing target-devel mailing list (where iser target is maintained).

So I stepped on this issue as well, and I actually have a fix for it
in the pipe. I'm planning to test it with a few other fixes for a little
while longer before I submit the code.

In general, This crash occurs due to a race between tpg shutdown (or
np disable) and RDMA_CM connect requests happening in parallel. iser
target tries to reference a tpg attribute while the np->tpg_np is
actually NULL.

How many targets/initiators/portals did you use? HCA?

Would it be possible to send you some patches to test as well?

Thanks for the report!

Sagi.

> On 3.18-rc2 it leaves such tracebacks:
>
>
>   BUG: unable to handle kernel NULL pointer dereference at 0000000000000720
>   IP: [<ffffffffc05dc7fd>] isert_connect_request.isra.48+0x2fd/0x7d0
> [ib_isert]
>   PGD 0
>   Oops: 0000 [#1] SMP
>   Modules linked in: target_core_user uio target_core_pscsi
> target_core_file target_core_iblock dm_thin_pool(OE) dm_persistent_data
> dm_bio_prison dm_bufio libcrc32c gpio_ich intel_powerclamp core
> temp kvm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel dcdbas ast
> aesni_intel ttm drm_kms_helper aes_x86_64 lrw gf128mul glue_helper
> ablk_helper cryptd drm syscopyarea sysfillrect sysimgblt
> joydev serio_raw i7core_edac ib_mthca ib_isert lpc_ich edac_core
> iscsi_target_mod ipmi_si 8250_fintek mac_hid ib_iser ipmi_msghandler
> libiscsi scsi_transport_iscsi rdma_ucm ib_uverbs rdma_cm iw_
> cm ib_ipoib ib_srpt ib_cm ib_sa target_core_mod configfs ib_umad ib_mad
> ib_core ib_addr lp parport bcache raid10 raid456 async_raid6_recov
> async_memcpy async_pq async_xor async_tx xor hid_generi
> c usbhid hid raid6_pq igb raid1 ahci i2c_algo_bit raid0 dca libahci ptp
> megaraid_sas pps_core multipath linear
>   CPU: 3 PID: 23400 Comm: kworker/3:2 Tainted: G           OE
> 3.18.0-031800rc2-generic #201410281737
>   Hardware name: Dell                   FS12-TY               /      ,
> BIOS C99Q3B23 08/16/2012
>   Workqueue: ib_cm cm_work_handler [ib_cm]
>   task: ffff8803ca928000 ti: ffff8803ca8b8000 task.ti: ffff8803ca8b8000
>   RIP: 0010:[<ffffffffc05dc7fd>]  [<ffffffffc05dc7fd>]
> isert_connect_request.isra.48+0x2fd/0x7d0 [ib_isert]
>   RSP: 0018:ffff8803ca8bbbf8  EFLAGS: 00010283
>   RAX: 0000000000000000 RBX: ffff8803e53b0800 RCX: 0000000000009484
>   RDX: ffff880424b08000 RSI: ffff8803e8638d80 RDI: ffff88042ec03d00
>   RBP: ffff8803ca8bbc48 R08: 00000000000173e0 R09: ffffea000fa18e00
>   R10: ffffffffc060ab31 R11: 0000000000000000 R12: ffff880424b08000
>   R13: ffff88041a2a7400 R14: ffff88041215f800 R15: 0000000000000000
>   FS:  0000000000000000(0000) GS:ffff88042f260000(0000)
> knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>   CR2: 0000000000000720 CR3: 0000000001c16000 CR4: 00000000000007e0
>   Stack:
>    ffff8803e53b0c58 ffff8803ca8bbc9a ffff880412a2a680 ffff8800b7a16000
>    c9750c0000ad0500 ffff88041a2a7400 ffff8803ca8bbc88 ffff880411ca3800
>    0000000000000000 ffff88042750e400 ffff8803ca8bbc68 ffffffffc05dcded
>   Call Trace:
>    [<ffffffffc05dcded>] isert_cma_handler+0x11d/0x170 [ib_isert]
>    [<ffffffffc0512cd6>] cma_req_handler+0x196/0x430 [rdma_cm]
>    [<ffffffffc04bdff0>] cm_process_work+0x30/0x140 [ib_cm]
>    [<ffffffffc04bfe84>] cm_req_handler+0x274/0x3a0 [ib_cm]
>    [<ffffffffc04c02f5>] cm_work_handler+0xb5/0x1d4 [ib_cm]
>    [<ffffffff8108d4be>] process_one_work+0x14e/0x460
>    [<ffffffff8108de3b>] worker_thread+0x11b/0x3f0
>    [<ffffffff8108dd20>] ? create_worker+0x1e0/0x1e0
>    [<ffffffff810939b9>] kthread+0xc9/0xe0
>    [<ffffffff810938f0>] ? flush_kthread_worker+0x90/0x90
>    [<ffffffff817b227c>] ret_from_fork+0x7c/0xb0
>    [<ffffffff810938f0>] ? flush_kthread_worker+0x90/0x90
>   Code: be 01 00 00 00 48 89 c7 e8 c1 af e4 ff 48 3d 00 f0 ff ff 48 89
> 83 90 05 00 00 0f 87 80 04 00 00 49 8b 86 78 01 00 00 48 8b 40 08 <0f>
> b6 90 20 07 00 00 84 d2 74 0e 48 8b 45 c8 80 78 04 00 0f 84
>   RIP  [<ffffffffc05dc7fd>] isert_connect_request.isra.48+0x2fd/0x7d0
> [ib_isert]
>    RSP <ffff8803ca8bbbf8>
>   CR2: 0000000000000720
>   ---[ end trace b8718ad554264a63 ]---
>
> followed by:
>
>   BUG: unable to handle kernel paging request at ffffffffffffffd8
>   IP: [<ffffffff81093d50>] kthread_data+0x10/0x20
>   PGD 1c19067 PUD 1c1b067 PMD 0
>   Oops: 0000 [#2] SMP
>   Modules linked in: target_core_user uio target_core_pscsi
> target_core_file target_core_iblock dm_thin_pool(OE) dm_persistent_data
> dm_bio_prison dm_bufio libcrc32c gpio_ich intel_powerclamp coretemp kvm
> crct10dif_pclmul crc32_pclmul ghash_clmulni_intel dcdbas ast aesni_intel
> ttm drm_kms_helper aes_x86_64 lrw gf128mul glue_helper ablk_helper
> cryptd drm syscopyarea sysfillrect sysimgblt joydev serio_raw
> i7core_edac ib_mthca ib_isert lpc_ich edac_core iscsi_target_mod ipmi_si
> 8250_fintek mac_hid ib_iser ipmi_msghandler libiscsi
> scsi_transport_iscsi rdma_ucm ib_uverbs rdma_cm iw_cm ib_ipoib ib_srpt
> ib_cm ib_sa target_core_mod configfs ib_umad ib_mad ib_core ib_addr lp
> parport bcache raid10 raid456 async_raid6_recov async_memcpy async_pq
> async_xor async_tx xor hid_generic usbhid hid raid6_pq igb raid1 ahci
> i2c_algo_bit raid0 dca libahci ptp megaraid_sas pps_core multipath linear
>   CPU: 3 PID: 23400 Comm: kworker/3:2 Tainted: G      D    OE
> 3.18.0-031800rc2-generic #201410281737
>   Hardware name: Dell                   FS12-TY               /      ,
> BIOS C99Q3B23 08/16/2012
>   task: ffff8803ca928000 ti: ffff8803ca8b8000 task.ti: ffff8803ca8b8000
>   RIP: 0010:[<ffffffff81093d50>]  [<ffffffff81093d50>]
> kthread_data+0x10/0x20
>   RSP: 0018:ffff8803ca8bb808  EFLAGS: 00010096
>   RAX: 0000000000000000 RBX: 0000000000000003 RCX: ffffffff81ec8e40
>   RDX: 0000000000000000 RSI: 0000000000000003 RDI: ffff8803ca928000
>   RBP: ffff8803ca8bb808 R08: 0000000000000000 R09: 0000000000000000
>   R10: 0000000000000000 R11: 000000000000e5b0 R12: 0000000000000003
>   R13: ffff8803ca928538 R14: 0000000000000001 R15: 0000000000000046
>   FS:  0000000000000000(0000) GS:ffff88042f260000(0000)
> knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>   CR2: 0000000000000028 CR3: 0000000001c16000 CR4: 00000000000007e0
>   Stack:
>    ffff8803ca8bb828 ffffffff8108ed85 ffff8803ca8bb828 ffff88042f274600
>    ffff8803ca8bb8a8 ffffffff817ade93 ffff8803ca8bb848 ffff8804250612d8
>    ffff8803ca8bbfd8 0000000000014600 ffff8803ca8bb888 0000000000014600
>   Call Trace:
>    [<ffffffff8108ed85>] wq_worker_sleeping+0x15/0xb0
>    [<ffffffff817ade93>] __schedule+0x5f3/0x780
>    [<ffffffff817ae0f9>] schedule+0x29/0x70
>    [<ffffffff81077915>] do_exit+0x2a5/0x470
>    [<ffffffff81017dc8>] oops_end+0xb8/0x160
>    [<ffffffff81796707>] no_context+0x1b5/0x1c4
>    [<ffffffff817968e9>] __bad_area_nosemaphore+0x1d3/0x1f2
>    [<ffffffff8179691b>] bad_area_nosemaphore+0x13/0x15
>    [<ffffffff81062372>] __do_page_fault+0x3b2/0x550
>    [<ffffffffc060a3a9>] ? mthca_cmd_wait+0x149/0x1e0 [ib_mthca]
>    [<ffffffff8106269e>] do_page_fault+0x3e/0x80
>    [<ffffffff817b4388>] page_fault+0x28/0x30
>
>
>
> Traceback from kernel 3.17.1 (hope this will help too):
>
>   BUG: unable to handle kernel paging request at 0000100000000718
>   IP: [<ffffffffc064c7fd>] isert_connect_request.isra.47+0x2fd/0x7d0
> [ib_isert]
>   PGD 0
>   Oops: 0000 [#1] SMP
>   Modules linked in: target_core_pscsi target_core_file
> target_core_iblock dm_thin_pool(OE) dm_persistent_data dm_bio_prison
> dm_bufio libcrc32c intel_powerclamp coretemp ast gpio_ich ttm kvm crct
> 10dif_pclmul crc32_pclmul dcdbas ghash_clmulni_intel drm_kms_helper
> aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd drm
> serio_raw syscopyarea sysfillrect sysimgblt joydev lpc_
> ich ib_mthca ib_isert i7core_edac iscsi_target_mod edac_core ipmi_si
> ipmi_msghandler ib_iser mac_hid libiscsi scsi_transport_iscsi rdma_ucm
> ib_uverbs rdma_cm iw_cm ib_ipoib ib_srpt ib_cm ib_sa target_core_mod
> configfs ib_umad ib_mad ib_core ib_addr lp parport bcache ses enclosure
> raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor
> async_tx xor hid_generic usbhid hid raid6_pq igb ahci libahci raid1
> i2c_algo_bit dca raid0 ptp pps_core megaraid_sas multipath linear
>   CPU: 2 PID: 18880 Comm: kworker/2:0 Tainted: G           OE
> 3.17.1-031701-generic #201410150735
>   Hardware name: Dell                   FS12-TY               /      ,
> BIOS C99Q3B23 08/16/2012
>   Workqueue: ib_cm cm_work_handler [ib_cm]
>   task: ffff8803ea031e00 ti: ffff880378d84000 task.ti: ffff880378d84000
>   RIP: 0010:[<ffffffffc064c7fd>]  [<ffffffffc064c7fd>]
> isert_connect_request.isra.47+0x2fd/0x7d0 [ib_isert]
>   RSP: 0018:ffff880378d87bf8  EFLAGS: 00010287
>   RAX: 0000100000000000 RBX: ffff880362f81000 RCX: 000000000009bda8
>   RDX: ffff880426361000 RSI: ffff88035e872d30 RDI: ffff88042ec03d00
>   RBP: ffff880378d87c48 R08: 0000000000017320 R09: ffffea000d7a1c80
>   R10: ffffffffc065fb31 R11: 0000000000000000 R12: ffff880426361000
>   R13: ffff880357e05000 R14: ffff880426b6f400 R15: 0000000000000000
>   FS:  0000000000000000(0000) GS:ffff88042f240000(0000)
> knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>   CR2: 0000100000000718 CR3: 0000000001c16000 CR4: 00000000000007e0
>   Stack:
>    ffff880362f81458 ffff880378d87c9a ffff8804100e6d80 ffff88040db00800
>    c9750c0000ad0500 ffff880357e05000 ffff880378d87c88 ffff88040f41cc00
>    0000000000000000 ffff8803abc70800 ffff880378d87c68 ffffffffc064cded
>   Call Trace:
>    [<ffffffffc064cded>] isert_cma_handler+0x11d/0x170 [ib_isert]
>    [<ffffffffc056dcc6>] cma_req_handler+0x196/0x430 [rdma_cm]
>    [<ffffffffc051eff0>] cm_process_work+0x30/0x140 [ib_cm]
>    [<ffffffffc0520e84>] cm_req_handler+0x274/0x3a0 [ib_cm]
>    [<ffffffffc05212f5>] cm_work_handler+0xb5/0x1d4 [ib_cm]
>    [<ffffffff8108ce2e>] process_one_work+0x14e/0x460
>    [<ffffffff8108d7ab>] worker_thread+0x11b/0x3f0
>    [<ffffffff8108d690>] ? create_worker+0x1e0/0x1e0
>    [<ffffffff810932b9>] kthread+0xc9/0xe0
>    [<ffffffff810931f0>] ? flush_kthread_worker+0x90/0x90
>    [<ffffffff817a46fc>] ret_from_fork+0x7c/0xb0
>    [<ffffffff810931f0>] ? flush_kthread_worker+0x90/0x90
>   Code: be 01 00 00 00 48 89 c7 e8 c1 ff d7 ff 48 3d 00 f0 ff ff 48 89
> 83 90 05 00 00 0f 87 80 04 00 00 49 8b 86 78 01 00 00 48 8b 40 08 <0f>
> b6 90 18 07 00 00 84 d2 74 0e 48 8b 45 c8 80 78 04 00 0f 84
>   RIP  [<ffffffffc064c7fd>] isert_connect_request.isra.47+0x2fd/0x7d0
> [ib_isert]
>    RSP <ffff880378d87bf8>
>   CR2: 0000100000000718
>
>
> Best regards,
> Adam Mazur
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
