Received: from mta0.migadu.com (out-237.mta0.migadu.com [91.218.175.237])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82858471CF8
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 04:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.237
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791864194; cv=none; b=mvLQfTkq1R8xmjUTjDK0OHd+jIFh6tyT54Wzr2IW1LuLJ7nubiBxil+UmERMEccCOBFiD9+kJrWpyNlV56sD2s3nnEtORwwV339cQI7ZtFKZxjfc1i8LcTVXbgIp56PCVZFUO0sQm8E+TvfZohZezb+OElXZArj/IDDAhb64xow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791864194; c=relaxed/simple;
	bh=pRw3+DNz4FKZkULbMEuGqFvNWp9tZmYd8hyPp4BAQ6c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iKJu1UW+Dyn5JyD72oF6hxEJe54pVXzkNVW0bgn6BbeZx6QBeyZoqRivfHSMELwH7hQgazDxHFh7rlLWfBotUJ1YC1t86nqP8uTmn+a2kuwTRaIeOWZUMGgv99vrioGr45FXatsEmh2jkYpvgW1i7jDy/G+iRMPuCbC6u0xxrbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=B7E24c3O; arc=none smtp.client-ip=91.218.175.237
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="B7E24c3O"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=pRw3+DNz4FKZkULbMEuGqFvNWp9tZmYd8hyPp4BAQ6c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791864188; v=1; x=1792468988;
 b=B7E24c3OEUzIxtl6nemya7PChQAx1Mf1B5UQz6xGa1wORDSJfKLyHGD5CnLHQ7M5RK2qRW14
 KSMSGRSmeSd9iLQvMmk+gtjzFBmAxhrbLuDN3Br3ayI6NKDfU6S7sJMbSfffTQobjHKBNFGexXM
 JGCiCpNuIYO6qtCA52EPW8uA=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 5736003ccde2858d;
	Tue, 13 Oct 2026 04:03:08 +0000
X-Mizu-Trace-ID: 5736003ccde2858d
X-Migadu-Flow: FLOW_OUT
Message-ID: <55731898-1cc7-4d6b-af6c-18f369aff79c@linux.dev>
Date: Mon, 12 Oct 2026 21:03:01 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/rxe: require ODP MR iova to equal the umem user
 address
To: hello messi <Hello_Messi_10@outlook.com>,
 "zyjzyj2000@gmail.com" <zyjzyj2000@gmail.com>,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: "jgg@ziepe.ca" <jgg@ziepe.ca>, "leon@kernel.org" <leon@kernel.org>,
 "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
References: <SY7P300MB0292E9E08F0890A2C31CFD96DE972@SY7P300MB0292.AUSP300.PROD.OUTLOOK.COM>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <SY7P300MB0292E9E08F0890A2C31CFD96DE972@SY7P300MB0292.AUSP300.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2026/10/4 7:07, hello messi 写道:
> Hello,
> I found an out-of-bounds access in the RXE ODP MR path when an ODP 
> memory region is registered with an IOVA that differs from the user 
> virtual address used to create the underlying |ib_umem_odp|.
> The issue was reproduced on Linux v7.2.8 with Soft-RoCE (|rxe0|).
> *Environment*

Please read the files in 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process

Thanks a lot.
Yanjun Zhu

> 
> |Kernel: Linux v7.2.8 RDMA device: Soft-RoCE (rxe0) 
> CONFIG_INFINIBAND_ON_DEMAND_PAGING=y CONFIG_RDMA_RXE=m CONFIG_KASAN=y 
> CONFIG_KASAN_GENERIC=y CONFIG_KASAN_INLINE=y CONFIG_DEBUG_INFO=y 
> CONFIG_DEBUG_INFO_DWARF5=y |
> 
> *Root cause*
> |rxe_odp_mr_init_user()| accepts |start| and |iova| independently:
> 
> |umem_odp = ib_umem_odp_get(&rxe->ib_dev, start, length, access_flags,   
>                          &rxe_mn_ops); ... mr->ibmr.length = length; mr- 
>  >ibmr.iova = iova; |
> 
> The ODP page list is sized according to the UMEM user address range, 
> while RXE calculates the page-list index from the MR IOVA:
> 
> |idx = (iova - ib_umem_start(umem_odp)) >> umem_odp->page_shift; |
> 
> There is no validation that the resulting index is within |umem_odp- 
>  >map.pfn_list|.
> |mr_check_range()| does not prevent this because it validates the IOVA 
> against |mr->ibmr.iova| and |mr->ibmr.length|, rather than against the 
> underlying UMEM user address range.
> *Reproduction*
> A minimal reproducer is attached as |poc.c|.
> The reproducer creates a one-page ODP MR with a deliberately divergent IOVA:
> 
> |user VA      : 0x55b0f4fb2000 ODP IOVA     : 0x55b1f4fb2000 IOVA delta 
>    : 0x100000000 ODP length   : 0x1000 expected idx : 0x100000 |
> 
> The resulting index is |0x100000|, while the one-page ODP |pfn_list| 
> only contains the entry corresponding to the valid UMEM page.
> The reproducer then submits an RC atomic-write operation using the MR 
> rkey and the divergent IOVA, reaching:
> 
> |rxe_odp_do_atomic_write()  -> rxe_odp_iova_to_index()  -> umem_odp- 
>  >map.pfn_list[index]  -> hmm_pfn_to_page()  -> kmap_local_page()  -> 
> smp_store_release() |
> 
> The reproducer can be executed by an unprivileged user.
> *KASAN/Oops*
> The reproducer triggers:
> 
> |Oops: general protection fault, probably for non-canonical address ... 
> KASAN: maybe wild-memory-access ... CPU: 3 UID: 0 PID: 13495 Comm: 
> kworker/u514:1 Workqueue: rxe_wq do_work [rdma_rxe] RIP: 
> 0010:rxe_odp_do_atomic_write+0x1ba/0x3e0 [rdma_rxe] |
> 
> Using |faddr2line|:
> 
> |rxe_odp_do_atomic_write+0x1ba/0x3e0: rxe_odp_do_atomic_write at /home/ 
> kali/linux-7.2.8/drivers/infiniband/sw/rxe/rxe_odp.c:410 |
> 
> Line 410 is:
> 
> |smp_store_release(&va[page_offset >> 3], value); |
> 
> The atomic value supplied by the reproducer was:
> 
> |atomic value=0x4141414142424242 |
> 
> The same value was present in the kernel register state at the time of 
> the fault.
> This demonstrates an out-of-bounds ODP |pfn_list| access in the RXE 
> atomic-write path. I have not assumed arbitrary kernel write or code 
> execution from this crash; the demonstrated impact is a kernel memory- 
> safety violation leading to a kernel fault.
> *Proposed fix*
> The existing ODP index calculation assumes that the MR IOVA and the UMEM 
> user address refer to the same address range. The simplest fix is to 
> reject an ODP MR when these addresses differ:
> 
> |diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c b/drivers/infiniband/ 
> sw/rxe/rxe_odp.c index ... --- a/drivers/infiniband/sw/rxe/rxe_odp.c +++ 
> b/drivers/infiniband/sw/rxe/rxe_odp.c @@ -98,6 +98,9 @@ int 
> rxe_odp_mr_init_user(struct rxe_dev *rxe, u64 start, u64 length,         
>         /* Never reach here, for implicit ODP is not implemented. */| 
> rxe_odp_do_atomic_op()|       } +       if (iova != start) +             
>    return -EINVAL; +        umem_odp = ib_umem_odp_get(&rxe->ib_dev, 
> start, length, access_flags,                                   
> &rxe_mn_ops); |
> 
> This restores the invariant required by the existing ODP index 
> calculation and prevents a divergent IOVA from producing an out-of-range 
> |pfn_list| index.
> Please consider applying an appropriate fix to current mainline and 
> stable kernels as appropriate.
> The reproducer is attached as |poc.c|, and the relevant KASAN/Oops 
> output is attached as |kasan-oops.txt|.
> Thanks,
> hellomessi
> 

