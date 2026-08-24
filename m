Received: from mta0.migadu.com (out-112.mta0.migadu.com [91.218.175.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B17402428
	for <linux-rdma@vger.kernel.org>; Mon, 24 Aug 2026 15:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787585068; cv=none; b=J0h2SeYtN5d7696ViKIh3Hi1E0czohibLzi2l4OPcyv70QR+5fzTYwAu3u+88DBpKP+GVbU9o3N3WC7MF98wFEXEh4Q2iAMUitcAKW7mQD9/U1J96T8heoUs1s9WKqO5OTMZY4TxGUyIM14lF6309b3qgYIFECRkkjOEIAueur0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787585068; c=relaxed/simple;
	bh=7lNKlFpG1/Rfo1+XNFejg9HEn8ngWSQXgqnvhDMFNPA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P5dDPljMlUyQgfpJ6zJqMk4tO8edy0Fi3ZwYc7LuWmnUAjmByAigiUJpb/ZCjyd0iqdHJ5vMvLUmMH8q7+HOS+qKVPRcQPVBZc1rU8CdWb5rof7SeUvT3bmsBuDdg3azsFsJaasLJXNbAo6QxGPLH51uAGIrvLW/4m09TYhvwCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rYlBOevX; arc=none smtp.client-ip=91.218.175.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rYlBOevX"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=7lNKlFpG1/Rfo1+XNFejg9HEn8ngWSQXgqnvhDMFNPA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787585064; v=1; x=1788189864;
 b=rYlBOevXfUw+Fnl42gmeQsd6MJ0/Snm0YB0trEBtaGGzT3O+dGrhNtP9cTbznsfzA6oB2yeR
 FBkAKnGSVsDQcJbQJ8rBw2bFnZn7lFfCu/Mbhm/i6l3NbMJNwE4oXt2T4vEJhnLCRNQatCHL9ul
 nwiMEfZv43OtDNs4XX2hEKLg=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: from [IPV6:2a04:ee41:4:15d4:8934:f21b:2683:d2a4] (2a04:ee41:4:15d4:8934:f21b:2683:d2a4)
	by smtp.migadu.com with ESMTPS id ac01b71e8bf4fad9;
	Mon, 24 Aug 2026 15:24:24 +0000
X-Mizu-Trace-ID: ac01b71e8bf4fad9
X-Migadu-Flow: FLOW_OUT
Message-ID: <4aa8833a-ab7d-4034-a299-414c3e11ed1d@linux.dev>
Date: Mon, 24 Aug 2026 17:24:20 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] RDMA/siw: KASAN: slab-use-after-free in siw_accept
To: Guoqing Jiang <guoqing.jiang@linux.dev>,
 Shuangpeng Bai <shuangpeng.kernel@gmail.com>, Jason Gunthorpe
 <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260821194704.835548-1-shuangpeng.kernel@gmail.com>
 <3702388e-3eb9-5f62-f2ae-cac3a01be716@linux.dev>
From: Bernard Metzler <bernard.metzler@linux.dev>
In-Reply-To: <3702388e-3eb9-5f62-f2ae-cac3a01be716@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 24.08.2026 10:58, Guoqing Jiang wrote:
> Hi,
> 
> On 8/22/26 03:46, Shuangpeng Bai wrote:
>> Hi Kernel Maintainers,
>>
>> I hit the following report while testing current upstream kernel:
>>
>> KASAN: slab-use-after-free in siw_accept
>>
>> on commit: bd5f485f3f026225b86573e559af0b7254ef4184 (2026-08-18)
>>
>> To help trigger the bug more reliably, we applied a minimal diagnostic patch
>> that only adds delays and print statements.
>>
>> The reproducer and .config files are here.
>> https://gist.github.com/shuangpengbai/28addfcbf79470a62d5b4cd784e95cd2
>>
>> The reproducer triggers a concurrent userspace QP transition to ERROR while
>> siw_accept() is unwinding after a QP initialization allocation failure. The
>> QP ERROR path drops qp->cep and frees the same struct siw_cep before
>> siw_accept() stores cep->qp = NULL.
>>
>> This report is separate from the withdrawn follow-up patch:
>> https://lore.kernel.org/linux-rdma/20260816061353.4059242-1-shuangpeng.kernel@gmail.com/
>>
>> That patch concerned a concurrent QP-destruction path. This report instead
>> involves a normal userspace ibv_modify_qp() transition to IBV_QPS_ERR on a
>> still-live QP.
>>
>> We also reproduced this issue on a tree containing
>> a93949718259 ("RDMA/siw: Fix use-after-free in siw_accept()"). That commit
>> covers the qp->cep != cep case; this report exercises the distinct
>> qp->cep == cep race during a concurrent userspace ibv_modify_qp(...,
>> IBV_QPS_ERR).
>>
>> The QP initialization failure was induced through the built-in fail_page_alloc
>> fault injector, restricted to the siw_qp_modify() call stack. The failing
>> vcalloc() path is a real -ENOMEM path.
>>
>> The diagnostic patch shifts source line numbers in the decoded trace; in the
>> unmodified tree, the corresponding access is `siw_cm.c:1758` and the freeing
>> put is `siw_qp.c:663`.
>>
>> I'm happy to test debug patches or provide additional information.
>>
>> Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
>>
>> [  409.854273] ==================================================================
>> [  409.856424] BUG: KASAN: slab-use-after-free in siw_accept (drivers/infiniband/sw/siw/siw_cm.c:1766)
>> [  409.858419] Write of size 8 at addr ffff888176620068 by task siw_accept_foll/8801
>>
>> [  409.860281] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
>> [  409.860284] Call Trace:
>> [  409.860288]  <TASK>
>> [  409.860291]  dump_stack_lvl (lib/dump_stack.c:94 lib/dump_stack.c:120)
>> [  409.860298]  print_report (mm/kasan/report.c:378 mm/kasan/report.c:482)
>> [  409.860315]  kasan_report (mm/kasan/report.c:595)
>> [  409.860325]  siw_accept (drivers/infiniband/sw/siw/siw_cm.c:1766)
>> [  409.860382]  iw_cm_accept (drivers/infiniband/core/iwcm.c:670)
>> [  409.860388]  rdma_accept (drivers/infiniband/core/cma.c:4643 drivers/infiniband/core/cma.c:4727)
>> [  409.860484]  ucma_accept (drivers/infiniband/core/ucma.c:1208)
>> [  409.860504]  ucma_write (drivers/infiniband/core/ucma.c:1856)
>> [  409.860528]  vfs_write (fs/read_write.c:685)
>> [  409.860554]  ksys_write (fs/read_write.c:739)
>> [  409.860574]  do_syscall_64 (arch/x86/entry/syscall_64.c:61 arch/x86/entry/syscall_64.c:84)
>> [  409.860579]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
>> [  409.860583] RIP: 0033:0x7f179cdf6fef
>> [  409.860588] Code: 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8 29 fd ff ff 48 8b 54 24 18 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 01 00 00 00 0f 05 <48> 3d 00 
>> f0 ff ff 77 31 44 89 c7 48 89 44 24 08 e8 5c fd ff ff 48
>> All code
>> ========
>>     0:    89 54 24 18              mov    %edx,0x18(%rsp)
>>     4:    48 89 74 24 10           mov    %rsi,0x10(%rsp)
>>     9:    89 7c 24 08              mov    %edi,0x8(%rsp)
>>     d:    e8 29 fd ff ff           call   0xfffffffffffffd3b
>>    12:    48 8b 54 24 18           mov    0x18(%rsp),%rdx
>>    17:    48 8b 74 24 10           mov    0x10(%rsp),%rsi
>>    1c:    41 89 c0                 mov    %eax,%r8d
>>    1f:    8b 7c 24 08              mov    0x8(%rsp),%edi
>>    23:    b8 01 00 00 00           mov    $0x1,%eax
>>    28:    0f 05                    syscall
>>    2a:*    48 3d 00 f0 ff ff        cmp    $0xfffffffffffff000,%rax        <-- trapping instruction
>>    30:    77 31                    ja     0x63
>>    32:    44 89 c7                 mov    %r8d,%edi
>>    35:    48 89 44 24 08           mov    %rax,0x8(%rsp)
>>    3a:    e8 5c fd ff ff           call   0xfffffffffffffd9b
>>    3f:    48                       rex.W
>>
>> Code starting with the faulting instruction
>> ===========================================
>>     0:    48 3d 00 f0 ff ff        cmp    $0xfffffffffffff000,%rax
>>     6:    77 31                    ja     0x39
>>     8:    44 89 c7                 mov    %r8d,%edi
>>     b:    48 89 44 24 08           mov    %rax,0x8(%rsp)
>>    10:    e8 5c fd ff ff           call   0xfffffffffffffd71
>>    15:    48                       rex.W
>> [  409.860592] RSP: 002b:00007ffe992e7720 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
>> [  409.860599] RAX: ffffffffffffffda RBX: 00007ffe992e79c0 RCX: 00007f179cdf6fef
>> [  409.860602] RDX: 0000000000000130 RSI: 00007ffe992e7800 RDI: 0000000000000003
>> [  409.860605] RBP: 000055f0d1977070 R08: 0000000000000000 R09: 00007f179ca7e700
>> [  409.860608] R10: fffffffffffffaa5 R11: 0000000000000293 R12: 0000000000000000
>> [  409.860610] R13: 0000000000000000 R14: 0000000000000001 R15: 00007ffe992e7800
>> [  409.860615]  </TASK>
>>
>> [  409.897413] Allocated by task 8115 on cpu 1 at 408.747286s:
>> [  409.897984]  kasan_save_track (mm/kasan/common.c:57 mm/kasan/common.c:78)
>> [  409.898409]  __kasan_kmalloc (mm/kasan/common.c:398 mm/kasan/common.c:415)
>> [  409.898822]  __kmalloc_cache_noprof (./include/linux/kasan.h:263 mm/slub.c:5489)
>> [  409.899305]  siw_cep_alloc (./include/linux/slab.h:988 ./include/linux/slab.h:1309 drivers/infiniband/sw/siw/siw_cm.c:210)
>> [  409.899712]  siw_cm_work_handler (drivers/infiniband/sw/siw/siw_cm.c:982 drivers/infiniband/sw/siw/siw_cm.c:1077)
>> [  409.900176]  process_scheduled_works (kernel/workqueue.c:3322 kernel/workqueue.c:3405)
>> [  409.900666]  worker_thread (kernel/workqueue.c:3486)
>> [  409.901080]  kthread (kernel/kthread.c:436)
>> [  409.901451]  ret_from_fork (archkernel/process.c:158)
>> [  409.901865]  ret_from_fork_asm (arch/x86/entry/entry_64.S:245)
>>
>> [  409.902511] Freed by task 8817 on cpu 0 at 409.051801s:
>> [  409.903051]  kasan_save_track (mm/kasan/common.c:57 mm/kasan/common.c:78)
>> [  409.903477]  kasan_save_free_info (mm/kasan/generic.c:584)
>> [  409.903930]  __kasan_slab_free (mm/kasan/common.c:253 mm/kasan/common.c:285)
>> [  409.904366]  kfree (./include/linux/kasan.h:235 mm/slub.c:2677 mm/slub.c:6377 mm/slub.c:6692)
>> [  409.904718]  siw_qp_modify (drivers/infiniband/sw/siw/siw_qp.c:669 drivers/infiniband/sw/siw/siw_qp.c:823)
>> [  409.905144]  siw_verbs_modify_qp (drivers/infiniband/sw/siw/siw_verbs.c:600)
>> [  409.905609]  ib_security_modify_qp (drivers/infiniband/core/security.c:625)
>> [  409.906082]  _ib_modify_qp (drivers/infiniband/core/verbs.c:1912)
>> [  409.906502]  modify_qp (drivers/infiniband/core/uverbs_cmd.c:1925)
>> [  409.906890]  ib_uverbs_modify_qp (drivers/infiniband/core/uverbs_cmd.c:1951)
>> [  409.907339]  ib_uverbs_handler_UVERBS_METHOD_INVOKE_WRITE (drivers/infiniband/core/uverbs_std_types_device.c:44)
>> [  409.907989]  ib_uverbs_cmd_verbs (drivers/infiniband/core/uverbs_ioctl.c:387 drivers/infiniband/core/uverbs_ioctl.c:526)
>> [  409.908469]  ib_uverbs_ioctl (drivers/infiniband/core/uverbs_ioctl.c:555)
>> [  409.908898]  __se_sys_ioctl (fs/ioctl.c:51 fs/ioctl.c:597 fs/ioctl.c:583)
>> [  409.909319]  do_syscall_64 (arch/x86/entry/syscall_64.c:61 arch/x86/entry/syscall_64.c:84)
>> [  409.909729]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
>>
>> [  409.910480] The buggy address belongs to the object at ffff888176620000
>> which belongs to the cache kmalloc-256 of size 256
>> [  409.911716] The buggy address is located 104 bytes inside of
>> freed 256-byte region [ffff888176620000, ffff888176620100)
> 
> I suppose it is necessary to clear qp and cep before release state_lock since both siw_qp_llp_close and
> siw_qp_modify->siw_qp_llp_close hold the lock during close cep, something like
> 
> @@ -1719,6 +1719,16 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
>                             SIW_QP_ATTR_STATE | SIW_QP_ATTR_LLP_HANDLE |
>                                     SIW_QP_ATTR_ORD | SIW_QP_ATTR_IRD |
>                                     SIW_QP_ATTR_MPA);
> +       if (rv) {
> +               cep->qp = NULL;
> +               qp->cep = NULL;
> +               siw_cep_put(cep);
> +       }
>          up_write(&qp->state_lock);
> 
Thanks Guoqing, that should fix it. But even better if we
goto error_unlock directly and remove the now obsolete
'if (rv != 0) goto error' below. Can you pls provide
a new patch?

Shuangpeng - could you pls test this with your
test environment?

Thank you both!
Bernard.

> Thanks,
> Guoqing

