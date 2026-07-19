Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFE33101D8
	for <linux-rdma@vger.kernel.org>; Sun, 19 Jul 2026 21:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784495657; cv=none; b=HgvACgnPdwVNlc9KkefhbXRWNB/M7gNINnmW4nulmlX2ku2FV0LxEzl8jfLgY4yZj+a5qTsZ9gdfItixxFBqHeJ+qpHnr9aWZJ/8ZoE566PGb397iYMtHdn2QJ15+jkSBFZUa5tDk2euVQIeyAcZvY1JZOiPZShUnrX84IfZS5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784495657; c=relaxed/simple;
	bh=ig2ilMlxnlrCkrIc5tzYEjNTnjOPEB7SOFzdJ+j6rvk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bQcl9mtPtJid2+i1MvZL8uRGWgVEIEj6SFB5EV1AIVZ5Zrx8Sc12GDNUnRVKtrOnoH+ntgPo1LRnvx22X2mTHf3CYBFr+eNDuMzOUnAv5aIIiCSmBiZ7fYjBRRjohFESdFmQDphSw4mfr0ZO8dAlPRsZ8A6LEMRXqQr2KhGQ7xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=u0b16Rra; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="u0b16Rra"
Message-ID: <19670ac6-ebab-4074-ab4f-3db06e1db291@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784495642;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fYADyvCrN/rcsyvKI6kUGG9dcrx2JUK8YeO02Ed6NsE=;
	b=u0b16RrazZDnJ4LzCsAGYeDvs0btnc/qP3bP6l4aqK0Yww04fS2wPgYvgMKqKsLDvEHEdF
	C6g6/yC0G5Pc3JMgbrJxHpXcILaQCJPzyW7uZcYYipFEtCdf8FnyMv/E4RO0YR/ML2gfsV
	G0G5Urj1letf5XxooI63fAgL+nnws5k=
Date: Sun, 19 Jul 2026 14:13:43 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [RFC PATCH 1/2] RDMA/rxe: drive UDP tunnel socket lifetime from
 the GID table
To: Serhat Kumral <serhatkumral1@gmail.com>, Zhu Yanjun
 <zyjzyj2000@gmail.com>, "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 David Ahern <dsahern@kernel.org>, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzbot+8c9eede336e3a843750e@syzkaller.appspotmail.com
References: <59a73ba7-52f3-44bc-80b9-98ff2a6aa771@linux.dev>
 <20260719175919.196814-1-serhatkumral1@gmail.com>
 <36fcad71-9165-4e87-93c9-edb9a1aa06e9@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <36fcad71-9165-4e87-93c9-edb9a1aa06e9@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 2026/7/19 13:50, Zhu Yanjun 写道:
>
> 在 2026/7/19 10:59, Serhat Kumral 写道:
>>> Could you please run this selftest in your environment to see if you 
>>> can
>>> reproduce the deadlock/hang and capture the stack trace?
>> I could not reproduce this.
>>
>> I ran the exact sequence from rxe_rping_between_netns.sh, including
>> its cleanup order and module unload, on arm64 QEMU with KASAN,
>> lockdep and a 30-second hung-task timeout. rdma_rxe was built as a
>> module and the test used rdma-core's rping.
>>
>> I ran it 15 consecutive times, followed by a variant that unloads
>> the module while the netns and RXE devices are still alive. The
>> rping transfers completed, the unload succeeded, and there were no
>> hangs or splats.
>>
>> The series was based on b21d9bf627dd. Could you share your exact
>> base commit and .config, and confirm whether the same test passes
>> on that tree without this series?
>
> My repository is 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>
> The base commit is
>
> commit f2ec6312bf711369561bdcb22f8a63c0b118c479 (linux/master, 
> linux/HEAD)
> Merge: ba6bd0df9adb e166bafc483e
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Sat Jul 18 12:36:19 2026 -0700
>
>     Merge tag 'scsi-fixes' of 
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi
>
>     Pull SCSI fixes from James Bottomley:
>      "The biggest core change is the reliable wake fix for 
> scsi_schedule_eh
>       which is used by both libata and libsas which could otherwise cause
>       error handler hangs due to rare races.
>
>       All other fixes are in drivers (well except the export symbol 
> removal)
>       the next biggest being the target PR-OUT transportid parsing fix"
>
>     * tag 'scsi-fixes' of 
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi:
>       scsi: hpsa: Fix DMA mapping leak on IOACCEL2 reset path
>       scsi: elx: efct: Fix refcount leak in efct_hw_io_abort()
>       scsi: elx: efct: Fix I/O leak on unsupported additional CDB
>       scsi: core: wake eh reliably when using scsi_schedule_eh
>       scsi: target: core: Fix iSCSI ISID use-after-free in REGISTER 
> AND MOVE
>       scsi: target: Bound PR-OUT TransportID parsing to the received 
> buffer
>       scsi: lpfc: Fix memory leak in lpfc_sli4_driver_resource_setup()
>       scsi: sg: Report request-table problems when any status is set
>       scsi: ufs: core: tracing: Do not dereference pointers in 
> TP_printk()
>       scsi: bfa: Reduce kernel stack usage in 
> bfa_fcs_lport_fdmi_build_portattr_block()
>       scsi: xen: scsiback: Free the command tag on the TMR 
> submit-failure path
>       scsi: xen: scsiback: Free unsubmitted command instead of 
> double-putting it
>       scsi: core: Remove export for scsi_device_from_queue()
>
> The config file is in the attachment.
>
> My KVM is
>
> # cat /etc/redhat-release
> Fedora release 43 (Forty Three)
>
> # uname -a
> Linux fedora 7.2.0-rc3-rxe-l2+ #64.fc43 SMP PREEMPT_DYNAMIC Sat Jul 18 
> 20:33:51 PDT 2026 x86_64 GNU/Linux
>
> And with this patchset, rping can work well.
>
> [root@fedora linux]# rdma link add rxe0 type rxe netdev enp1s0
> [root@fedora linux]# rping -s -a 192.168.122.174 -C 3 &
> [1] 2580
> [root@fedora linux]# rping -c -a 192.168.122.174 -C 3 -d -Vv
> validate data
> verbose
> created cm_id 0x55b32895a4d0
> cma_event type RDMA_CM_EVENT_ADDR_RESOLVED cma_id 0x55b32895a4d0 (parent)
> cma_event type RDMA_CM_EVENT_ROUTE_RESOLVED cma_id 0x55b32895a4d0 
> (parent)
> rdma_resolve_addr - rdma_resolve_route successful
> created pd 0x55b328950ca0
> created channel 0x55b328950ce0
> created cq 0x55b32895c880
> created qp 0x55b32894f650
> rping_setup_buffers called on cb 0x55b32894f830
> allocated & registered buffers...
> cq_thread started.
> cma_event type RDMA_CM_EVENT_ESTABLISHED cma_id 0x55b32895a4d0 (parent)
> ESTABLISHED
> rdma_connect successful
> RDMA addr 55b328950220 rkey 54e len 64
> send completion
> recv completion
> RDMA addr 55b328950270 rkey 45a len 64
> send completion
> recv completion
> ping data: rdma-ping-0: 
> ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqr
> RDMA addr 55b328950220 rkey 54e len 64
> send completion
> recv completion
> RDMA addr 55b328950270 rkey 45a len 64
> send completion
> recv completion
> ping data: rdma-ping-1: 
> BCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrs
> RDMA addr 55b328950220 rkey 54e len 64
> send completion
> recv completion
> RDMA addr 55b328950270 rkey 45a len 64
> send completion
> recv completion
> ping data: rdma-ping-2: 
> CDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrst
> server DISCONNECT EVENT...
> rping_free_buffers called on cb 0x55b32894f830
> wait for RDMA_READ_ADV state 10
> cma_event type RDMA_CM_EVENT_DISCONNECTED cma_id 0x55b32895a4d0 (parent)
> client DISCONNECT EVENT...
> destroy cm_id 0x55b32895a4d0
> [1]+  Done                       rping -s -a 192.168.122.174 -C 3
> [root@fedora linux]# rdma link
> link rxe0/1 state ACTIVE physical_state LINK_UP netdev enp1s0
>
> # rdma sys
> netns shared privileged-qkey off monitor on copy-on-fork on
>
> But when running tools/testing/selftests/rdma/rxe_rping_between_netns.sh,
>
> the hang will occur. It is weird.
>
> The output is as below after removing /dev/null.
>
> "
> # sh tools/testing/selftests/rdma/rxe_rping_between_netns.sh
> Setting up network namespace and veth pair...
> Creating RDMA links...
> Testing connectivity with rping...
> verbose
> count 3
> created cm_id 0x55b1f415fc00
> cma_event type RDMA_CM_EVENT_ADDR_RESOLVED cma_id 0x55b1f415fc00 (parent)
> cma_event type RDMA_CM_EVENT_ROUTE_RESOLVED cma_id 0x55b1f415fc00 
> (parent)
> rdma_resolve_addr - rdma_resolve_route successful
> created pd 0x55b1f4155ca0
> created channel 0x55b1f4155ce0
> created cq 0x55b1f4161fb0
> created qp 0x55b1f4154650
> rping_setup_buffers called on cb 0x55b1f4154830
> allocated & registered buffers...
> cq_thread started.
> [kernel hang here, no any reponse]
> "
>
> I can not run any command from console or ssh since the kernel hang.
>
> If you need any further information, please let me know.

Although my KVM is still slow, finally I enable kdump in my KVM. The 
followings are call trace.

"

[  161.627498] rdma_rxe: loaded
[  162.308868] infiniband rxe0: set active
[  162.308887] infiniband rxe0: added veth-a
[  163.393981] infiniband rxe1: set active
[  163.393989] infiniband rxe1: added veth-b
[  166.456651] Oops: general protection fault, probably for 
non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
[  166.456942] KASAN: null-ptr-deref in range 
[0x0000000000000000-0x0000000000000007]
[  166.457255] CPU: 9 UID: 0 PID: 409 Comm: kworker/u57:1 Kdump: loaded 
Not tainted 7.2.0-rc3-rxe-l2+ #64.fc43 PREEMPT(lazy)
[  166.457578] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 
1.16.3-debian-1.16.3-2 04/01/2014
[  166.457901] Workqueue: rxe_wq do_work [rdma_rxe]
[  166.458269] RIP: 0010:ip_rcv+0xeb/0x570
[  166.458584] Code: 48 8d 7d 10 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 
21 04 00 00 48 b8 00 00 00 00 00 fc ff df 4c 8b 75 10 4c 89 f2 48 c1 ea 
03 <80> 3c 02 00 0f 85 1e 04 00 00 41 8b 06 a9 00 00 20 00 0f 85 95 02
[  166.459260] RSP: 0018:ffff88848b688b30 EFLAGS: 00010246
[  166.459602] RAX: dffffc0000000000 RBX: 1ffff110916d1167 RCX: 
0000000000000001
[  166.459954] RDX: 0000000000000000 RSI: 0000000000000004 RDI: 
ffff888126d83cd0
[  166.460301] RBP: ffff888126d83cc0 R08: ffffffffc0fbc2a9 R09: 
ffffed102817fa60
[  166.460640] R10: ffffed102817fa61 R11: ffff888117a57872 R12: 
ffff888132e3e000
[  166.460996] R13: ffff888139320000 R14: 0000000000000000 R15: 
1ffffffff75f8c74
[  166.461338] FS:  0000000000000000(0000) GS:ffff8884d124a000(0000) 
knlGS:0000000000000000
[  166.461676] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  166.462023] CR2: 00007f252500af38 CR3: 000000012ed02005 CR4: 
0000000000772ef0
[  166.462367] PKRU: 55555554
[  166.462700] Call Trace:
[  166.463041]  <IRQ>
[  166.463365]  ? __pfx_ip_rcv+0x10/0x10
[  166.463690]  ? validate_chain+0x83/0x930
[  166.464022]  ? __lock_acquire+0x580/0xc30
[  166.464346]  ? process_backlog+0x341/0x1110
[  166.464666]  __netif_receive_skb_one_core+0x14f/0x1b0
[  166.465001]  ? lock_acquire.part.0+0xc7/0x260
[  166.465323]  ? __pfx___netif_receive_skb_one_core+0x10/0x10
[  166.465643]  ? __lock_release+0x59/0x160
[  166.465965]  ? process_backlog+0x341/0x1110
[  166.466284]  process_backlog+0x381/0x1110
[  166.466600]  __napi_poll+0x9d/0x500
[  166.466915]  net_rx_action+0x87e/0xe00
[  166.467224]  ? __pfx_net_rx_action+0x10/0x10
[  166.467515]  ? sched_clock_cpu+0x69/0x5a0
[  166.467799]  ? sched_clock_cpu+0x69/0x5a0
[  166.468087]  ? mark_held_locks+0x40/0x70
[  166.468367]  ? mark_held_locks+0x40/0x70
[  166.468644]  handle_softirqs+0x1de/0x860
[  166.468928]  ? __pfx_handle_softirqs+0x10/0x10
[  166.469213]  ? __pfx_handle_softirqs+0x10/0x10
[  166.469487]  ? __dev_queue_xmit+0x927/0x2120
[  166.469760]  do_softirq.part.0+0x5f/0xb0
[  166.470044]  </IRQ>
[  166.470308]  <TASK>
[  166.470569]  __local_bh_enable_ip+0x113/0x150
[  166.470836]  __dev_queue_xmit+0x93c/0x2120
[  166.471116]  ? save_trace+0x63/0x200
[  166.471384]  ? __pfx___dev_queue_xmit+0x10/0x10
[  166.471652]  ? __lock_acquire+0x580/0xc30
[  166.471932]  ? lock_acquire.part.0+0xc7/0x260
[  166.472195]  ? find_held_lock+0x2b/0x80
[  166.472446]  ? mark_held_locks+0x40/0x70
[  166.472687]  ? lockdep_hardirqs_on_prepare.part.0+0x9b/0x140
[  166.472930]  ? seqcount_lockdep_reader_access+0xb5/0xc0
[  166.473170]  ? trace_hardirqs_on+0x19/0x190
[  166.473403]  ? __asan_memcpy+0x3c/0x60
[  166.473624]  ? neigh_hh_output+0x106/0x350
[  166.473834]  ip_finish_output2+0x928/0x1c10
[  166.474056]  ? ip_dst_mtu_maybe_forward+0x2bd/0x6f0
[  166.474263]  ? ip_dst_mtu_maybe_forward+0x2c7/0x6f0
[  166.474464]  ? __pfx_ip_finish_output2+0x10/0x10
[  166.474664]  ip_output+0x1ca/0x600
[  166.474859]  ? mark_held_locks+0x40/0x70
[  166.475061]  ? __pfx_ip_output+0x10/0x10
[  166.475253]  ? __pfx_ip_finish_output+0x10/0x10
[  166.475439]  ? __pfx___rxe_get+0x10/0x10 [rdma_rxe]
[  166.475629]  ? crc32_le+0xfd/0x180
[  166.475809]  rxe_xmit_packet+0x588/0x7b0 [rdma_rxe]
[  166.476005]  rxe_requester+0x59a/0x22c0 [rdma_rxe]
[  166.476199]  ? __lock_acquire+0x580/0xc30
[  166.476385]  ? __pfx_rxe_requester+0x10/0x10 [rdma_rxe]
[  166.476580]  ? mark_held_locks+0x40/0x70
[  166.476777]  ? __pfx_rxe_sender+0x10/0x10 [rdma_rxe]
[  166.477066]  rxe_sender+0x17/0x40 [rdma_rxe]
[  166.477265]  do_task+0x154/0x640 [rdma_rxe]
[  166.477460]  process_one_work+0x8b7/0x15e0
[  166.477648]  ? __pfx_process_one_work+0x10/0x10
[  166.477833]  ? lock_acquire.part.0+0xc7/0x260
[  166.478033]  worker_thread+0x60a/0xff0
[  166.478223]  ? __pfx_worker_thread+0x10/0x10
[  166.478413]  kthread+0x35d/0x460
[  166.478603]  ? _raw_spin_unlock_irq+0x28/0x50
[  166.478795]  ? __pfx_kthread+0x10/0x10
[  166.478995]  ret_from_fork+0x55b/0x850
[  166.479189]  ? __pfx_ret_from_fork+0x10/0x10
[  166.479378]  ? __switch_to+0x474/0xd60
[  166.479570]  ? __pfx_kthread+0x10/0x10
[  166.479761]  ret_from_fork_asm+0x1a/0x30
[  166.479961]  </TASK>
[  166.480153] Modules linked in: rdma_ucm ib_uverbs ib_uverbs_support 
rdma_cm iw_cm ib_cm veth rdma_rxe ib_core qrtr rfkill sunrpc 
intel_rapl_msr intel_rapl_common intel_uncore_frequency_common 
intel_pmc_core pmt_telemetry pmt_discovery pmt_class 
intel_pmc_ssram_telemetry intel_pmc_pwrm_telemetry intel_vsec kvm_intel 
kvm iTCO_wdt irqbypass intel_pmc_bxt rapl i2c_i801 i2c_smbus pcspkr 
lpc_ich virtio_balloon joydev loop zram lz4hc_compress 
vmw_vsock_virtio_transport vmw_vsock_virtio_transport_common vsock 
virtio_net net_failover virtio_gpu failover virtio_dma_buf serio_raw 
i2c_dev qemu_fw_cfg virtiofs fuse
"

Zhu Yanjun

>
> Zhu Yanjun
>
>>
>> The script redirects stdout to /dev/null, so could you also identify
>> the command at which it stops, for example by temporarily removing
>> the redirections and running it with bash -x? If it hangs again,
>> "echo w > /proc/sysrq-trigger" and, if possible,
>> "echo t > /proc/sysrq-trigger" from the console should provide the
>> blocked-task stacks without requiring kdump.
>
-- 
Best Regards,
Yanjun.Zhu

