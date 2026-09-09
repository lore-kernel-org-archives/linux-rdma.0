Received: from mta0.migadu.com (out-158.mta0.migadu.com [91.218.175.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8738576ED7
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 14:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963332; cv=none; b=DJNoiuq5LulE7/PivNVhD8a3Uhtkh6cj9urbqAwhknxkkWSzmjqjM7gvYb41PTogT8VKTVh0JhnKGpY7F3HZ9kvNp2glELgXw3ZSBQPNKn8oLPJvTRzZplzqlHTBid7qQ7Axp17hbA4PrWPnkmK37m0qznDTY8d6Z9ofDOs+Ah4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963332; c=relaxed/simple;
	bh=IJnv0Yz9XvaKbROvvLRFmstX6j7Ft1qm+GcbiMTYjGI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=hItZyVSRvzRLRiRuPE6kjzrBdDrWYtw6NVIDlkqhNCVmO9pqBWlZJAZnM8fnWYbQuGf1dQt0ShkcizYv4KepOx3zl46RKdxXrGvlrVUW4sd6UcGqD37AB4X9jQ2ksS0czATNXBxyMLjw5W7cUUd+ccDfj3g7JtU65UExd60czhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oRMYMwpy; arc=none smtp.client-ip=91.218.175.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oRMYMwpy"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=IJnv0Yz9XvaKbROvvLRFmstX6j7Ft1qm+GcbiMTYjGI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788963326; v=1; x=1789568126;
 b=oRMYMwpyzEJ5mbJKUUiPvV/hOGs7j+B5JVnVgZDSQ+rC5ZUHC9AttVFb+uKUNGI3RjvFwL9Q
 p1+RS8OE18Bam0KHuftleBjtM0AVDhA7I48ysvQvmZT8s03DiEER3rzS8wqxhUSCnUq84YdlZXl
 v24Cmy1d7QTgKigq1yClm9rk=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8afb378187cf97ca;
	Wed, 09 Sep 2026 14:15:25 +0000
X-Mizu-Trace-ID: 8afb378187cf97ca
X-Migadu-Flow: FLOW_OUT
Message-ID: <594ad636-369d-4f0c-8c42-c1b3fba51f5b@linux.dev>
Date: Wed, 9 Sep 2026 07:15:22 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/rxe: Use validated num_sge in local buffer
To: Nicolas Morey <nmorey@suse.com>, Zhu Yanjun <zyjzyj2000@gmail.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Tristan Madani <tristmd@gmail.com>,
 "open list:SOFT-ROCE DRIVER (rxe)" <linux-rdma@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
References: <20260907161550.716670-1-nmorey@suse.com>
 <27376486-9cab-4d42-8ed7-36e13231dd91@linux.dev>
 <681ae665-523a-441b-bbd8-dbae51ee64f1@suse.com>
 <4bb04e58-7e69-46bc-9ecf-283605b18340@linux.dev>
 <a8d64435-2fd8-4e2b-9b48-aea496630e07@suse.com>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <a8d64435-2fd8-4e2b-9b48-aea496630e07@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2026/9/8 0:35, Nicolas Morey 写道:
> On 2026-09-08 05:07, Zhu Yanjun wrote:
>> 在 2026/9/7 14:44, Nicolas Morey 写道:
>>> On 2026-09-07 23:20, Zhu Yanjun wrote:
>>>> 在 2026/9/7 9:15, Nicolas Morey 写道:
>>>>> For both SRQ and non-SRQ receive paths, the WQE is copied into a local
>>>>> buffer to provide a kernel-owned, validated copy. While calculating the
>>>>> memcpy size from the validated num_sge prevents overflow during the
>>>>> copy, memcpy() itself still copies num_sge from shared memory.
>>>>>
>>>>> A concurrent userspace modification before or during memcpy() leaves
>>>>> an unvalidated num_sge in the local buffer, leading to potential
>>>>> out-of-bounds reads in rxe_resp_check_length() and copy_data().
>>>>>
>>>>
>>>> Hi Nicolas,
>>>>
>>>> Thanks for the patch. The logic makes total sense to prevent the TOCTOU race condition after memcpy.
>>>>
>>>> Just out of curiosity, do you happen to have a reproducer or a POC script that demonstrates this race in practice?
>>>>
>>>> It would be great to know if this can be reliably reproduced or integrated into testing setups (like rdma-core tests, or tools/testing/selftests/rdma) to catch similar double-read issues in the future.
>>>>
>>>
>>> No reproducer or PoC sadly. I haven't tried to make one though.
>>> This got caught by one of our AI tools when checking the backport of CVE-2026-74377.
>>
>> Hi, Nicolas
>>
>> Thanks for sharing this. Could you clarify whether your AI tool detected this purely through static analysis (and provided a suggested fix), or if it actually triggered a runtime bug with a backtrace/calltrace?
>>
>> If you have a calltrace, please share it—that would help a lot in understanding the issue. Also, if this was flagged and fixed by a specific AI tool, adding an Assisted-by: tag (or referencing the tool in the commit description) would be appropriate.
>>
>> Thanks,
>>
>> Zhu Yanjun
>>
> 
> Hi Zhu,
> 
> The tool is a LLM static analyser that simply detected that d6ab440240a0 ("RDMA/rxe: Copy WQE to local buffer in non-SRQ receive path") was a valid patch but did not fix the whole issue. It did not suggest any breaker PoC nor any fix.
> All the rest is human (me) made.
> Does that warrant an Assisted-by tag ?
> It seems sashiko picked the same issue for 22b8fbded65b ("RDMA/rxe: Fix TOCTOU heap overflow in get_srq_wqe")
> https://sashiko.dev/#/patchset/20260518215040.1598586-1-tristan%40talencesecurity.com
> 
>> If a concurrent userspace thread modifies wqe->dma.num_sge after the
>> bounds check but before the memcpy completes, doesn't this copy the
>> unvalidated value into the kernel heap?
> 
> By tweaking the reproducer from Tristan, I have been able to reproduce it once out of sheer luck I think:

Thanks a lot. Please add the following call trace into the commit log 
and send out a new commit.

Except the above, I am fine with this commit.

Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>

Zhu Yanjun

> ==================================================================
> BUG: KASAN: slab-out-of-bounds in rxe_receiver+0x8109/0x9ec0 [rdma_rxe]
> Read of size 4 at addr ffff88812c4867f8 by task kworker/u9:6/361
> 
> CPU: 0 UID: 0 PID: 361 Comm: kworker/u9:6 Tainted: G            E       7.3.0-rc2-00006-g28924df2a08f #3 PREEMPT(full)  318a88bba3045f81bad31a7694727561b4bd4965
> Tainted: [E]=UNSIGNED_MODULE
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.3-2-gc13ff2cd-prebuilt.qemu.org 04/01/2014
> Workqueue: rxe_wq do_work [rdma_rxe]
> Call Trace:
>   <TASK>
>   dump_stack_lvl+0x4b/0x70
>   print_report+0x153/0x4b5
>   ? __pfx__raw_spin_lock_irqsave+0x10/0x10
>   ? stack_trace_save+0x93/0xd0
>   kasan_report+0xbc/0xf0
>   ? rxe_receiver+0x8109/0x9ec0 [rdma_rxe b8d153a5fa9911e345612beff278ac3241bac327]
>   ? rxe_receiver+0x8109/0x9ec0 [rdma_rxe b8d153a5fa9911e345612beff278ac3241bac327]
>   rxe_receiver+0x8109/0x9ec0 [rdma_rxe b8d153a5fa9911e345612beff278ac3241bac327]
>   ? pick_task_fair+0x12e/0x1b50
>   ? __pfx_rxe_receiver+0x10/0x10 [rdma_rxe b8d153a5fa9911e345612beff278ac3241bac327]
>   ? __pfx__raw_spin_lock_irqsave+0x10/0x10
>   ? hrtimer_start_range_ns+0xe7/0x320
>   ? ktime_get+0xe3/0x170
>   ? _raw_spin_unlock+0xe/0x30
>   ? _raw_spin_lock_irqsave+0x8a/0xf0
>   ? __pfx__raw_spin_lock_irqsave+0x10/0x10
>   ? __pfx_rxe_receiver+0x10/0x10 [rdma_rxe b8d153a5fa9911e345612beff278ac3241bac327]
>   do_work+0x149/0x610 [rdma_rxe b8d153a5fa9911e345612beff278ac3241bac327]
>   process_one_work+0x726/0x10a0
>   ? __pfx___schedule+0x10/0x10
>   ? __pfx_process_one_work+0x10/0x10
>   ? _raw_spin_lock_irq+0x85/0xe0
>   ? __pfx__raw_spin_lock_irq+0x10/0x10
>   worker_thread+0x500/0xd70
>   ? __kthread_parkme+0x8d/0x170
>   ? __pfx_worker_thread+0x10/0x10
>   ? __pfx_worker_thread+0x10/0x10
>   kthread+0x329/0x410
>   ? recalc_sigpending+0x15c/0x200
>   ? __pfx_kthread+0x10/0x10
>   ret_from_fork+0x4cf/0x760
>   ? __pfx_ret_from_fork+0x10/0x10
>   ? __switch_to+0x575/0x11c0
>   ? __pfx_kthread+0x10/0x10
>   ret_from_fork_asm+0x1a/0x30
>   </TASK>
> 
> Allocated by task 1698:
>   kasan_save_stack+0x20/0x40
>   kasan_save_track+0x14/0x30
>   __kasan_kmalloc+0x9a/0xb0
>   __kmalloc_noprof+0x209/0x560
>   create_qp.part.0+0x760/0x9d0 [ib_core]
>   ib_create_qp_user+0xa2/0x500 [ib_core]
>   ib_uverbs_handler_UVERBS_METHOD_QP_CREATE+0x99b/0x12af [ib_uverbs]
>   ib_uverbs_cmd_verbs+0x214b/0x32d0 [ib_uverbs]
>   ib_uverbs_ioctl+0x131/0x200 [ib_uverbs]
>   __x64_sys_ioctl+0x13c/0x1c0
>   do_syscall_64+0xba/0x530
>   entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> Last potentially related work creation:
>   kasan_save_stack+0x20/0x40
>   kasan_record_aux_stack+0xb0/0xc0
>   __queue_work+0x8c5/0x11f0
>   queue_work_on+0x60/0x70
>   rxe_sched_task+0x1d2/0x250 [rdma_rxe]
>   rxe_rcv+0x847/0x1830 [rdma_rxe]
>   rxe_xmit_packet+0x408/0x950 [rdma_rxe]
>   rxe_requester+0x1878/0x5460 [rdma_rxe]
>   rxe_sender+0x17/0x40 [rdma_rxe]
>   do_work+0x149/0x610 [rdma_rxe]
>   process_one_work+0x726/0x10a0
>   worker_thread+0x500/0xd70
>   kthread+0x329/0x410
>   ret_from_fork+0x4cf/0x760
>   ret_from_fork_asm+0x1a/0x30
> 
> The buggy address belongs to the object at ffff88812c486000
>   which belongs to the cache kmalloc-part-13-2k of size 2048
> The buggy address is located 0 bytes to the right of
>   allocated 2040-byte region [ffff88812c486000, ffff88812c4867f8)
> 
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff88812c480000 pfn:0x12c480
> head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> flags: 0x17ffffc0000240(workingset|head|node=0|zone=2|lastcpupid=0x1fffff)
> page_type: f5(slab)
> raw: 0017ffffc0000240 ffff888100059140 ffffea0004499010 ffffea00049a7a10
> raw: ffff88812c480000 0000000200080007 00000000f5000000 0000000000000000
> head: 0017ffffc0000240 ffff888100059140 ffffea0004499010 ffffea00049a7a10
> head: ffff88812c480000 0000000200080007 00000000f5000000 0000000000000000
> head: 0017ffffc0000003 fffffffffffffe01 00000000ffffffff 00000000ffffffff
> head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
> page dumped because: kasan: bad access detected
> 
> Memory state around the buggy address:
>   ffff88812c486680: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>   ffff88812c486700: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> ffff88812c486780: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 fc
>                                                                  ^
>   ffff88812c486800: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>   ffff88812c486880: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ==================================================================

