Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D80E1E511
	for <linux-rdma@vger.kernel.org>; Sun, 26 Jul 2026 00:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785024536; cv=none; b=tx5rBYiNal6OKL9xy23/vOj9N7itnRYM4tWyGPbBn+6xtp3qrXbJxkAW5yYorFTyKlUv8nT+ZgEbEILp/dBZkhn2lsAf0/hhkESCCZY/CISKv2M+C2FdrMZZ2s0MQXvNxfN/xgSkx0Nwn4DVhr0/UXvDt9t+63vkbOk/Ty/pYOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785024536; c=relaxed/simple;
	bh=B7MBl2s5nKkDB4+FgISTBui63xSrrm4mUMxrdPZKLQY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WhYqbvepuexSOxKsD3yITZaw8CxfgT6na7rLdAs09j5eR6hxSdQ2p+c175BhwAPJNEFcmMf8WZ6npOWaIwJRsP83ZtF9qDp1BIcA5Mo9dcuBb7zn1rbOVfYeCq50eUrXmZ6Msrtx9KzNyk6jEAHoJF2ThmuN0gi/a0swtTkve2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=twy+jpV3; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="twy+jpV3"
Message-ID: <1b99ae23-a5b0-4e3b-80b5-1538d0e0a7fe@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785024531;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FgZSsHXxkEfaeuyKCDHxFRRqwxJ4jL34a4fzFsZqoDk=;
	b=twy+jpV3CmCFMEb413rvbS8HGeY0T51fXs4VHYSndOKhuSxNivOck13taPoRLpInai02dB
	USBtaQQiwZNGpEocr+YvbhTq1FFxNVuATiy0xlp6J9KDzH8b151B6yumInhpjUtBvWuJ+x
	8k+pxk7b21kIX1W9z9sia3DjGixdcGo=
Date: Sat, 25 Jul 2026 17:08:29 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] RDMA/rxe: Restore HMM_PFN_WRITE check in ODP write paths
To: Weiming Shi <bestswngs@gmail.com>, security@kernel.org
Cc: Jason Gunthorpe <jgg@nvidia.com>, Zhu Yanjun <zyjzyj2000@gmail.com>,
 Qiang Hong <wanbafv@gmail.com>, Xinyu Ma <mmmxny@gmail.com>,
 Shaomin Chen <eeesssooo020@gmail.com>, Rui Ding <threonine42@gmail.com>,
 Miao Zhao <muel@nova.gal>, RDMA mailing list <linux-rdma@vger.kernel.org>
References: <20260725094805.916278-1-bestswngs@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260725094805.916278-1-bestswngs@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 2026/7/25 2:48, Weiming Shi 写道:
> Commit 0b261d7c1cd3 ("RDMA/rxe: Break endless pagefault loop for RO
> pages") dropped the access permission test from rxe_check_pagefault()
> and left only HMM_PFN_VALID. A page faulted in read-only, for example
> a page-cache folio behind a PROT_READ file mapping, then satisfies the
> check and ODP write operations (RDMA WRITE, RDMA READ response, SEND
> payload, atomics) modify it through kmap without ever breaking CoW.
>
> An unprivileged user can register an ODP MR over such a mapping and
> have incoming RDMA traffic overwrite the page cache of a file it only
> holds O_RDONLY, including /etc/passwd or setuid binaries. This is the
> same primitive class as Dirty COW and CVE-2022-2590.
>
> mlx5 has the missing invariant: its ODP path sets the device write bit
> only for pfns that carry HMM_PFN_WRITE. Restore it in rxe by requiring
> HMM_PFN_WRITE in rxe_check_pagefault() for every operation except
> RXE_PAGEFAULT_RDONLY. A write to a non-writable VMA now fails the one
> fault attempt with -EPERM from hmm_vma_fault() instead of re-faulting
> forever. For a writable VMA the fault breaks CoW and the write lands
> in the private page.
>
> Keep pmem flushes on the read-only check. arch_wb_cache_pmem() never
> modifies memory, and the FLUSH access bits do not make the umem
> writable, so classifying flushes as writes would make every flush
> against a flush-only MR fail.
>
> Fixes: 0b261d7c1cd3 ("RDMA/rxe: Break endless pagefault loop for RO pages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> Reported-by: Shaomin Chen <eeesssooo020@gmail.com>
> Reported-by: Rui Ding <threonine42@gmail.com>
> Reported-by: Miao Zhao <muel@nova.gal>
> Tested-by: Qiang Hong <wanbafv@gmail.com>
> Tested-by: Xinyu Ma <mmmxny@gmail.com>
> ---
>   drivers/infiniband/sw/rxe/rxe_odp.c | 16 +++++++++++-----
>   1 file changed, 11 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c b/drivers/infiniband/sw/rxe/rxe_odp.c
> index ff904d5e54a73..174bb2efc3c6a 100644
> --- a/drivers/infiniband/sw/rxe/rxe_odp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_odp.c
> @@ -124,19 +124,23 @@ int rxe_odp_mr_init_user(struct rxe_dev *rxe, u64 start, u64 length,
>   }
>   
>   static inline bool rxe_check_pagefault(struct ib_umem_odp *umem_odp, u64 iova,
> -				       int length)
> +				       int length, bool write)
>   {
>   	bool need_fault = false;
> +	u64 access = HMM_PFN_VALID;
>   	u64 addr;
>   	int idx;
>   
> +	if (write)
> +		access |= HMM_PFN_WRITE;
> +
>   	addr = iova & (~(BIT(umem_odp->page_shift) - 1));
>   
>   	/* Skim through all pages that are to be accessed. */
>   	while (addr < iova + length) {
>   		idx = (addr - ib_umem_start(umem_odp)) >> umem_odp->page_shift;
>   
> -		if (!(umem_odp->map.pfn_list[idx] & HMM_PFN_VALID)) {
> +		if ((umem_odp->map.pfn_list[idx] & access) != access) {
>   			need_fault = true;
>   			break;
>   		}
> @@ -159,6 +163,7 @@ static unsigned long rxe_odp_iova_to_page_offset(struct ib_umem_odp *umem_odp, u
>   static int rxe_odp_map_range_and_lock(struct rxe_mr *mr, u64 iova, int length, u32 flags)
>   {
>   	struct ib_umem_odp *umem_odp = to_ib_umem_odp(mr->umem);
> +	bool write = !(flags & RXE_PAGEFAULT_RDONLY);
>   	bool need_fault;
>   	int err;
>   
> @@ -167,7 +172,7 @@ static int rxe_odp_map_range_and_lock(struct rxe_mr *mr, u64 iova, int length, u
>   
>   	mutex_lock(&umem_odp->umem_mutex);
>   
> -	need_fault = rxe_check_pagefault(umem_odp, iova, length);
> +	need_fault = rxe_check_pagefault(umem_odp, iova, length, write);
>   	if (need_fault) {
>   		mutex_unlock(&umem_odp->umem_mutex);
>   
> @@ -177,7 +182,7 @@ static int rxe_odp_map_range_and_lock(struct rxe_mr *mr, u64 iova, int length, u
>   		if (err < 0)
>   			return err;
>   
> -		need_fault = rxe_check_pagefault(umem_odp, iova, length);
> +		need_fault = rxe_check_pagefault(umem_odp, iova, length, write);
>   		if (need_fault) {
>   			mutex_unlock(&umem_odp->umem_mutex);
>   			return -EFAULT;
> @@ -339,8 +344,9 @@ int rxe_odp_flush_pmem_iova(struct rxe_mr *mr, u64 iova,
>   	int err;
>   	u8 *va;
>   
> +	/* A flush never modifies memory; read-only access suffices. */
>   	err = rxe_odp_map_range_and_lock(mr, iova, length,
> -					 RXE_PAGEFAULT_DEFAULT);
> +					 RXE_PAGEFAULT_RDONLY);
>   	if (err)
>   		return err;
>   

-- 
Best Regards,
Yanjun.Zhu

