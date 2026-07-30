Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C2A2FE057
	for <linux-rdma@vger.kernel.org>; Thu, 30 Jul 2026 18:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785434881; cv=none; b=kVOZ4jmLQvYwhYoGwRynrYEKd8filCOa4b0nyqslqcESVxtypZImbKZjv5tm4DXl1KtWrI6nbnKXI7FpKp5V3rV5LX0v+Vvmrerb1Z4Fo1+nwlS6IbQu+5JiJ88StaeO06W8IzQx2XUJ5TkvXZzMsicq9EkWuPsAJYLp14keFYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785434881; c=relaxed/simple;
	bh=aqA4mi7u45VCC/hshFFb0gFXi7iE/CY3fIk6T3r0L5M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k46EcZlx7p4Va2i/Em/Q2vsgRR/UnPas21CbpwCxjR+mwrexh+Qywx0xlIybZzrsfZWx6wuHXrj/xHyeF8omFpWBhqGt71sbwi0XSOMPjYIVswpykIlEAxoQTZFNYKz4NmKW3Lkf7NoYYQumn8F202Sy3cwhc+S3BvSGkb42uDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dh5t+ivN; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dh5t+ivN"
Message-ID: <a35ece69-60af-4a82-a0cd-da1aeb9c60dc@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785434875;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+f8mH+MJAdlyY/RllX1ACKR7VJnel0w9p1IJkxrLK+A=;
	b=dh5t+ivN6r8Nvc6J68jFqpG4Bms20l1TQPTGzD2glIRfwT9GnAdqNFDmyTMtcy8y81GDiu
	sS9/1w9YIz+saLP3NX5ZzZ0egPxiJmeNdYtune+lPg+H6LpwSfIriqZfgT0PrXWRCfyinp
	4cuqJ76RrkZiXd38HcUZ91psF7d7gJQ=
Date: Thu, 30 Jul 2026 11:07:33 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [BUG] RDMA/rxe: memory leak in rxe_qp_from_attr
To: Peiyang He <peiyang_he@smail.nju.edu.cn>, jgg@ziepe.ca, leon@kernel.org,
 Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>,
 linux-rdma@vger.kernel.org,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <357830C4A3236804+c7b5ccba-01ba-468f-97c8-cb6053a8b771@smail.nju.edu.cn>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "yanjun.zhu" <yanjun.zhu@linux.dev>
In-Reply-To: <357830C4A3236804+c7b5ccba-01ba-468f-97c8-cb6053a8b771@smail.nju.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 7/30/26 1:40 AM, Peiyang He wrote:
> Hello Linux kernel developers and maintainers,
> 
> We hit a memory leak in rxe_qp_from_attr when fuzzing RDMA/RXE with Syzkaller.
> 
> The leak is caused by two concurrent MODIFY_QP commands which both modify
> IB_QP_MAX_DEST_RD_ATOMIC on the same RXE QP. They are not serialized by a
> QP-wide lock. The uverbs layer only holds shared UVERBS_LOOKUP_READ access
> to the QP, so two threads may enter rxe_modify_qp() and then rxe_qp_from_attr()
> for the same object at the same time.
> It can leak a whole qp->resp.resources array each time triggered.
> 
> The version of the kernel under test is commit 8cd9520d35a6c38db6567e97dd93b1f11f185dc6 (tag v7.1).
> We believe this OOB bug is still possible in the latest kernel.
> 
> The relevant kernel config is:
> 
> CONFIG_NET=y
> CONFIG_INET=y
> CONFIG_INFINIBAND=y
> CONFIG_INFINIBAND_USER_ACCESS=y
> CONFIG_INFINIBAND_ADDR_TRANS=y
> CONFIG_RDMA_RXE=y
> CONFIG_DEBUG_FS=y
> CONFIG_DEBUG_KERNEL=y
> CONFIG_DEBUG_KMEMLEAK=y
> CONFIG_DEBUG_KMEMLEAK_AUTO_SCAN=y
> 
> =========================
> Original Syzkaller report
> =========================
> 
> BUG: memory leak
> unreferenced object 0xffff8880120ef800 (size 1024):
>    comm "syz.0.1478", pid 15130, jiffies 4295203468
>    hex dump (first 32 bytes):
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>    backtrace (crc 0):
>      kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
>      slab_post_alloc_hook mm/slub.c:4575 [inline]
>      slab_alloc_node mm/slub.c:4899 [inline]
>      __do_kmalloc_node mm/slub.c:5295 [inline]
>      __kmalloc_noprof+0x552/0x850 mm/slub.c:5308
>      kmalloc_noprof include/linux/slab.h:954 [inline]
>      kzalloc_noprof include/linux/slab.h:1188 [inline]
>      alloc_rd_atomic_resources drivers/infiniband/sw/rxe/rxe_qp.c:155 [inline]
>      rxe_qp_from_attr+0x3f8/0x2150 drivers/infiniband/sw/rxe/rxe_qp.c:714
>      rxe_modify_qp+0x1e2/0x530 drivers/infiniband/sw/rxe/rxe_verbs.c:623
>      ib_security_modify_qp+0x223/0xfa0 drivers/infiniband/core/security.c:625
>      _ib_modify_qp+0x333/0xec0 drivers/infiniband/core/verbs.c:1915
>      modify_qp+0x13ca/0x1940 drivers/infiniband/core/uverbs_cmd.c:1932
>      ib_uverbs_modify_qp+0xcb/0x120 drivers/infiniband/core/uverbs_cmd.c:1958
>      ib_uverbs_write+0xb86/0x1030 drivers/infiniband/core/uverbs_main.c:680
>      vfs_write+0x2aa/0x1070 fs/read_write.c:686
>      ksys_write+0x1f8/0x250 fs/read_write.c:740
>      do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>      do_syscall_64+0x116/0x800 arch/x86/entry/syscall_64.c:94
>      entry_SYSCALL_64_after_hwframe+0x77/0x7f

Thanks for the detailed analysis.

 From the RDMA usage perspective, concurrent MODIFY_QP operations on the 
same QP are not normally expected in real workloads. Typically, after a 
QP is created and transitioned to the required state, applications use 
it for communication. If a QP attribute or resource needs to be 
modified, it is usually done by the owner thread/process in a serialized 
manner rather than by multiple threads concurrently modifying the same QP.

However, since the kernel interface does allow such a scenario, 
especially under malicious input or fuzzing environments, the driver 
should still handle this case safely.

For the fix, I agree that the resource replacement path needs proper 
serialization. My preference would be to reuse an existing QP lock if 
there is one suitable for protecting QP attribute modifications, rather 
than introducing a new `rd_atomic_mutex` specifically for this field. 
Adding a new lock may increase locking complexity and could introduce 
additional lock ordering concerns.

It may also be worth checking whether other QP attribute modification 
paths have similar concurrency assumptions. If the QP modify path is 
generally expected to be serialized, protecting the broader QP 
modification operation with an existing lock might provide a more 
consistent solution.

Zhu Yanjun

> 
> ==========
> Root cause
> ==========
> 
> modify_qp() obtains the QP through uobj_get_obj_read() and retains the
> UVERBS_LOOKUP_READ access. This is a shared lookup, since UVERBS_LOOKUP_READ
> increments a positive use count and only rejects an object whose count is -1,
> whereas UVERBS_LOOKUP_WRITE is exclusive. Therefore, the two MODIFY_QP commands
> may execute rxe_modify_qp() concurrently. rxe_modify_qp() directly calls
> rxe_qp_from_attr() without a QP-wide lock.
> 
> For IB_QP_MAX_DEST_RD_ATOMIC, rxe_qp_from_attr() updates qp->attr.max_dest_rd_atomic,
> frees the current qp->resp.resources pointer and calls alloc_rd_atomic_resources().
> The allocator initializes the responder indices and assigns the result of kzalloc_objs()
> to qp->resp.resources. Neither the resource replacement sequence nor the pointer assignment
> is serialized.
> 
> The relevant QP starts with qp->resp.resources == NULL. Let P0 and P1 be the
> two resp_res arrays allocated by the concurrent commands. The following
> race interleaving leaks P1:
> 
> CPU0                                           CPU1
> ====                                           ====
> 
> MODIFY_QP()
> -> rxe_qp_from_attr()
>     -> alloc_rd_atomic_resources()
>        -> P0 = kzalloc_objs()
>        /* preempted after kzalloc_objs() returns P0,
>           before the assignment to qp->resp.resources */
> 
>                                                 MODIFY_QP()
>                                                 -> rxe_qp_from_attr()
>                                                  -> alloc_rd_atomic_resources()
>                                                     -> P1 = kzalloc_objs()
>                                                     -> qp->resp.resources = P1
> 
>        -> qp->resp.resources = P0
>        /* overwrites the only reference to P1 */
> 
> When the QP is later cleaned up, rxe_qp_do_cleanup() calls free_rd_atomic_resources()
> and can only free the pointer currently stored in qp->resp.resources, namely P0.
> P1 has no remaining reference to it and is reported by kmemleak.
> 
> =============
> Suggested fix
> =============
> 
> First of all, I wonder is concurrent modify_qp() on the same QP supposed
> to be supported by design? If yes, then the rd_atomic resource replacement
> path needs explicit serialization. We could add a rd_atomic_mutex in
> struct rxe_qp, init it in rxe_qp_init_misc(). Then, the IB_QP_MAX_DEST_RD_ATOMIC
> branch in rxe_qp_from_attr() and rxe_qp_reset() should be protected by this lock.
> 
> I am happy to send a patch if this fix is needed and reasonable.
> 
> Thanks,
> Peiyang
> 

