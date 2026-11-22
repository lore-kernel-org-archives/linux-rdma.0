Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.106
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795376554;
	b=LoLvg237xtdTW9ODFXrPRNkxAfohjBkL+sDdU0YKCvFPtOHdVj0FxFc59goHqitYIJgt
	 KK1dBlMkNaTJuvq5ehTL2gRBM7sK0ppATmd5PC42cigUgnDbx3XD7pbRD+sDUfGU5uVHG
	 oInmkY5UwGNsndZmZWKsOqFFnvJTRsX9q+2cww5UmGsvrS9GXce1PPSf//O8XFrgo+TyN
	 9vfdSJ2DXwPUiH9X7TPIp5wbo0xiQrQonWThAi/V4SE7YON1/5+0SKeKogeE3QpZBzx5B
	 405E6LpxOAMM5wCMMowVPYaoWHbbBdQ5K40sNuRTb2DrOisdHWfJGANubw6yE4lWXmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795376554;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=u7aJQPEkk1MXoO+1vj7a5E+2bixK8uiORNo00q/fjE8=;
	b=Tp3WJEHntiQd0H+WEIYnxDELy/5LXJ9jyKLB94UMh99cVJS8Ds5qq9lBMDmV+pO2qj+g
	 44IkR68Yf9eiIg9FRNxDMP4/pHmvOR5yaq+Vne7YitsBGPG6/BnxiG9KHDR9nhRVDKvP7
	 Z9tbpH7FZEk8ZDHz+dVDAMamxDXvwiyLPkyGmcmXI4BbW5J1uEv5O+O/kbyNx0pU6Pue9
	 go4iAm1+d7QzfOti1yW/6MAcBGXwE0wx33W29oLnn2yp2Wzu89MwNUI1/B+X+FCyQLiBp
	 dSI6mjb2QMk5fdsbqWOjHoEfKx5EL15m8/wDBFfuKN6R4QBwWZKuMHGkGS5DZrjWFxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=s5i4YqAv;
	arc=none smtp.remote-ip=91.218.175.106
Received: from mta0.migadu.com (out-106.mta0.migadu.com [91.218.175.106])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07851606A31D
	for <linux-rdma@vger.kernel.org>; Sun, 22 Nov 2026 19:42:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07851606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=s5i4YqAv
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=A+Nq3QPurMldwnh5piZQ+zljAbZ0+xg1hBlzTGvD0cc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795376550; v=1; x=1795981350;
 b=s5i4YqAv+lTxDUZNfVxCbqnF/eQx3G/yOrnJ5YL0kFxhoR6V23uE34ShE656JWio5v4dTAvQ
 6mPN+PlhUELsdZ0y+oa976QS8gylaVKscmBzd244wFkbtKhhGzLvvbfyd9EndYYNPaCPRvUXoHf
 +m12sDC/l+wN80L0dQWbdViQ=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id bc5ce082725462f8;
	Sun, 22 Nov 2026 19:42:30 +0000
X-Mizu-Trace-ID: bc5ce082725462f8
X-Migadu-Flow: FLOW_OUT
Message-ID: <59e93766-fb4f-43de-a721-4ad544264730@linux.dev>
Date: Sun, 22 Nov 2026 11:42:27 -0800
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rdma-next v2] RDMA/rxe: Require a responder resource for
 FLUSH
To: Andrew Stellman <astellman@stellman-greene.com>,
 Zhu Yanjun <zyjzyj2000@gmail.com>,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261122170551.19582-1-astellman@stellman-greene.com>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20261122170551.19582-1-astellman@stellman-greene.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2026/11/22 9:05, Andrew Stellman 写道:
> process_flush() keeps its state in a responder resource from
> rxe_prepare_res(), as READ and ATOMIC requests do. check_resource()
> refuses those requests when max_dest_rd_atomic is 0, but it does not
> check FLUSH. With max_dest_rd_atomic 0, qp->resp.resources is
> ZERO_SIZE_PTR, and rxe_prepare_res() writes through it in
> free_rd_atomic_resource().
> 
> A FLUSH sent to an RC QP with max_dest_rd_atomic 0 oopses the
> responder:
> 
>    Oops: general protection fault, probably for non-canonical address 0xdffffc0000000002: 0000 [#1] SMP KASAN NOPTI
>    KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
>    CPU: 0 UID: 0 PID: 13 Comm: kworker/u8:0 Not tainted 7.4.0-rc3-gaebb72744764 #1 PREEMPT(lazy)
>    Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
>    Workqueue: rxe_wq do_work
>    RIP: 0010:free_rd_atomic_resource+0x15/0x50
>    Code: 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 40 d6 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 04 3c 03 7e 0b c7 07 00 00 00 00 c3 cc cc cc
>    RSP: 0018:ff110000013479f8 EFLAGS: 00000202
>    RAX: dffffc0000000000 RBX: 0000000000000010 RCX: ff110000059f9760
>    RDX: 0000000000000002 RSI: 0000000000000000 RDI: 0000000000000010
>    RBP: 0000000000000001 R08: ff110000024a2180 R09: ffe21c0000268f2c
>    R10: 0000000000000003 R11: ff110000059f9298 R12: ff1100000592dc00
>    R13: 0000000000000040 R14: ff110000059f9000 R15: ff110000024a2168
>    FS:  0000000000000000(0000) GS:ff110000e18da000(0000) knlGS:0000000000000000
>    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>    CR2: dffffc0000000002 CR3: 00000000052ca000 CR4: 0000000000751ef0
>    PKRU: 55555554
>    Call Trace:
>     <TASK>
>     rxe_receiver+0x5f6e/0x9a20
>     ? flush_workqueue_prep_pwqs+0x1a4/0xe80
>     ? kthread+0x2b0/0x3b0
>     ? __pfx_rxe_receiver+0x10/0x10
>     ? update_cfs_rq_load_avg+0x5a/0x560
>     ? pick_task_fair+0x468/0x1a60
>     ? __pfx_rxe_receiver+0x10/0x10
>     ? _raw_spin_lock_irqsave+0x86/0xe0
>     ? __pfx_rxe_receiver+0x10/0x10
>     do_work+0x144/0x470
>     process_one_work+0x6fc/0x1180
>     ? __pfx___schedule+0x10/0x10
>     ? __pfx_process_one_work+0x10/0x10
>     ? _raw_spin_lock_irq+0x81/0xe0
>     ? __pfx_do_work+0x10/0x10
>     ? assign_work+0x11d/0x410
>     worker_thread+0x45b/0xd10
>     ? __pfx_worker_thread+0x10/0x10
>     kthread+0x2c8/0x3b0
>     ? recalc_sigpending+0x15c/0x1e0
>     ? __pfx_kthread+0x10/0x10
>     ret_from_fork+0x36e/0x5a0
>     ? __pfx_ret_from_fork+0x10/0x10
>     ? __switch_to+0x572/0xdc0
>     ? __switch_to_asm+0x33/0x70
>     ? __pfx_kthread+0x10/0x10
>     ret_from_fork_asm+0x1a/0x30
>     </TASK>
>    Modules linked in:
>    ---[ end trace 0000000000000000 ]---
>    RIP: 0010:free_rd_atomic_resource+0x15/0x50
>    Code: 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 40 d6 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 04 3c 03 7e 0b c7 07 00 00 00 00 c3 cc cc cc
>    RSP: 0018:ff110000013479f8 EFLAGS: 00000202
>    RAX: dffffc0000000000 RBX: 0000000000000010 RCX: ff110000059f9760
>    RDX: 0000000000000002 RSI: 0000000000000000 RDI: 0000000000000010
>    RBP: 0000000000000001 R08: ff110000024a2180 R09: ffe21c0000268f2c
>    R10: 0000000000000003 R11: ff110000059f9298 R12: ff1100000592dc00
>    R13: 0000000000000040 R14: ff110000059f9000 R15: ff110000024a2168
>    FS:  0000000000000000(0000) GS:ff110000e18da000(0000) knlGS:0000000000000000
>    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>    CR2: dffffc0000000002 CR3: 00000000052ca000 CR4: 0000000000751ef0
>    PKRU: 55555554
> 
>    ------------[ cut here ]------------
>    WARNING: drivers/infiniband/sw/rxe/rxe_pool.c:212 at __rxe_cleanup+0x21b/0x290, CPU#0: t028/87
>    Modules linked in:
>    CPU: 0 UID: 0 PID: 87 Comm: t028 Tainted: G      D             7.4.0-rc3-gaebb72744764 #1 PREEMPT(lazy)
>    Tainted: [D]=DIE
>    Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
>    RIP: 0010:__rxe_cleanup+0x21b/0x290
>    Code: f7 fe ff ff 4c 89 e7 e8 43 99 ad fd 84 c0 0f 85 6f ff ff ff be 50 c3 00 00 4c 89 e7 e8 9e 22 f3 00 85 c0 0f 85 5a ff ff ff 90 <0f> 0b 90 eb 04 90 0f 0b 90 bd 92 ff ff ff e9 48 ff ff ff 90 0f 0b
>    RSP: 0018:ff110000053f78f8 EFLAGS: 00000246
>    RAX: 0000000000000000 RBX: ff110000059f9160 RCX: ffe21c0000a7ef08
>    RDX: 0000000000000000 RSI: ff110000053f7860 RDI: ff110000059f9190
>    RBP: 0000000000000001 R08: 0000000000000001 R09: ffe21c0000a7eef5
>    R10: 0000000000000003 R11: ffffffff89c14700 R12: ff110000059f9188
>    R13: ff110000059f9170 R14: ff11000004794ea0 R15: 1fe2200000a7ef1f
>    FS:  0000000000000000(0000) GS:ff110000e18da000(0000) knlGS:0000000000000000
>    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>    CR2: dffffc0000000002 CR3: 000000001b872000 CR4: 0000000000751ef0
>    PKRU: 55555554
>    Call Trace:
>     <TASK>
>     ? __pfx___rxe_cleanup+0x10/0x10
>     ? rxe_qp_chk_destroy+0x61/0xc0
>     rxe_destroy_qp+0x2f/0x180
>     ib_destroy_qp_user+0x30f/0x4f0
>     ? __pfx_ib_destroy_qp_user+0x10/0x10
>     ? stack_trace_save+0x8e/0xc0
>     uverbs_free_qp+0x7c/0x150
>     ? put_files_struct+0x181/0x310
>     destroy_hw_idr_uobject+0x7e/0x130
>     ? entry_SYSCALL_64_after_hwframe+0x77/0x7f
>     uverbs_destroy_uobject+0xdf/0x770
>     __uverbs_cleanup_ufile+0x18b/0x390
>     ? __pfx___uverbs_cleanup_ufile+0x10/0x10
>     ? __pfx_down_write+0x10/0x10
>     uverbs_destroy_ufile_hw+0x6d/0x260
>     ib_uverbs_close+0x46/0x270
>     __fput+0x2f8/0x9e0
>     fput_close_sync+0xe2/0x190
>     ? __pfx_fput_close_sync+0x10/0x10
>     filp_close_sync+0x18/0x30
>     put_files_struct+0x181/0x310
>     do_exit+0x6ab/0x25f0
>     ? __pfx_do_exit+0x10/0x10
>     ? zap_other_threads+0xb9/0x300
>     ? __pfx_zap_other_threads+0x10/0x10
>     ? handle_mm_fault+0x13d/0x420
>     do_group_exit+0xab/0x220
>     __x64_sys_exit_group+0x39/0x40
>     x64_sys_call+0x1962/0x1970
>     do_syscall_64+0xdf/0x4c0
>     entry_SYSCALL_64_after_hwframe+0x77/0x7f
>    RIP: 0033:0x7f34f928a21d
>    Code: Unable to access opcode bytes at 0x7f34f928a1f3.
>    RSP: 002b:00007ffeed584088 EFLAGS: 00000202 ORIG_RAX: 00000000000000e7
>    RAX: ffffffffffffffda RBX: 00007f34f93a0fa8 RCX: 00007f34f928a21d
>    RDX: 00000000000000e7 RSI: ffffffffffffff88 RDI: 0000000000000000
>    RBP: 00007ffeed5840e0 R08: 00007ffeed584030 R09: 0000000000000000
>    R10: 000055d8b71c93e0 R11: 0000000000000202 R12: 0000000000000001
>    R13: 0000000000000000 R14: 0000000000000000 R15: 00007f34f93a0fc0
>     </TASK>
>    ---[ end trace 0000000000000000 ]---
> 
> The responder task dies, and when the test exits, destroying the QP
> warns on a timeout in __rxe_cleanup() (the WARNING above) and then
> hangs.
> 
> Add RXE_FLUSH_MASK to the check, so a FLUSH gets the same Invalid
> Request NAK a READ would, and the requester sees IB_WC_REM_INV_REQ_ERR.
> 
> The issue was found by Claude Opus 5.5 running Quality Playbook, an
> LLM-driven code review tool:
> https://github.com/andrewstellman/quality-playbook
> The fix and this changelog were drafted with Claude Opus 5.5 and
> reviewed by me.
> 
> Fixes: ea1bb00ee9a5 ("RDMA/rxe: Implement flush execution in responder side")
> Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>
> ---
> 
> v2: the full kernel log of the oops and the later WARNING, as Leon
> asked (timestamps removed). The code change is the same as v1.
> v1: https://lore.kernel.org/r/20261119151332.95466-1-astellman@stellman-greene.com
> 
> Tested in QEMU with KASAN on v7.4-rc3, and on v7.4-rc3 with the RDMA
> code from rdma for-next (7404c82cbf12). The reproducer is a short
> libibverbs program; I can send it off-list.
> 
>   drivers/infiniband/sw/rxe/rxe_resp.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
> index 1b7f31737225..38b5b0c2abe3 100644
> --- a/drivers/infiniband/sw/rxe/rxe_resp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_resp.c
> @@ -340,7 +340,8 @@ static enum resp_states check_resource(struct rxe_qp *qp,
>   {
>   	struct rxe_srq *srq = qp->srq;
>   
> -	if (pkt->mask & (RXE_READ_OR_ATOMIC_MASK | RXE_ATOMIC_WRITE_MASK)) {
> +	if (pkt->mask & (RXE_READ_OR_ATOMIC_MASK | RXE_ATOMIC_WRITE_MASK |
> +			 RXE_FLUSH_MASK)) {

This looks sensible to me—adding RXE_FLUSH_MASK here avoids 
rxe_prepare_res() / free_rd_atomic_resource() touching ZERO_SIZE_PTR 
when max_dest_rd_atomic == 0 and returns the expected Invalid Request NAK.

Just worth confirming:
(1) RXE_FLUSH_MASK takes the same error/NAK path here without later 
responder states assuming a valid qp->resp.res or non-ZERO_SIZE_PTR 
qp->resp.resources, and

(2) no other RXE_READ_OR_ATOMIC_MASK / RXE_ATOMIC_WRITE_MASK checks in 
rxe_resp.c for max_dest_rd_atomic or responder resources missed 
RXE_FLUSH_MASK.

Thanks a lot.

Zhu Yanjun

>   		/* it is the requesters job to not send
>   		 * too many read/atomic ops, we just
>   		 * recycle the responder resource queue
> 
> base-commit: 7404c82cbf1246e0e84e2ec21834d23c26f9a8ed

