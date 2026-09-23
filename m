Received: from mta0.migadu.com (out-86.mta0.migadu.com [91.218.175.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8AE3AEF4C
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 22:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790203825; cv=none; b=CE0mVXDr8KqjO2/+f13aODukWUIjBHVkwfKZQoMBuY+LsP3r9eiJyDuLlAOEGhP8fSXI0V5Qj+e4UWbBb3EMh4rheIjpI6b8GnbhAoYlCAcJSL8cdcxMFOh8IBYydqLucCLeZARB235ce+emFKliQxJ1tokzo04AbhKvYK2JnR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790203825; c=relaxed/simple;
	bh=cAHW9pR8nlR6sk+Upl/hizK55XCqRvMPrhN2PbL0DKc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iDYjj51HZ60bvZ290MHOwITxOH+2Xs6KetI0SglPqIonSgex6Gd+u4siByiwu0XC9qOwf1voBnnIkXo1DqJdEEtLGIlRzfWGUsUMlUd/WOUgf+KXPyYBYR0/Lth0x+hfqXVXOf7Azk9xXqdA39mXbRFe55OBfBe1zopjEFB5BJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Et25QBmL; arc=none smtp.client-ip=91.218.175.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Et25QBmL"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=cAHW9pR8nlR6sk+Upl/hizK55XCqRvMPrhN2PbL0DKc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790203821; v=1; x=1790808621;
 b=Et25QBmLSzqTYSkcLMCSSFS4TkXc1IC11nlXWMkLNUYS9yB3+2J2S7FGkzaSBlq7UGOe2M5R
 uynUrDnCuUchmjmfSGBuU1hFB92gtMijghJZrenS7Eq0h3ug+Fk2+jbec0DR7DAhGWzjz2Xcyhj
 /GKcu5Hthb4mO+K9IDmZePcs=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 81f228547fa01915;
	Wed, 23 Sep 2026 22:50:21 +0000
X-Mizu-Trace-ID: 81f228547fa01915
X-Migadu-Flow: FLOW_OUT
Message-ID: <a126a34f-3d47-48d3-842c-14cb9e4b943a@linux.dev>
Date: Wed, 23 Sep 2026 15:50:14 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] RDMA/rxe: Reject prefetch of a non-ODP MR
To: norbert@doyensec.com, Zhu Yanjun <zyjzyj2000@gmail.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Bob Pearson <rpearsonhpe@gmail.com>, Daisuke Matsuda <dskmtsd@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260923-rxe-advise-mr-v3-v3-0-95e1a4077e4d@doyensec.com>
 <20260923-rxe-advise-mr-v3-v3-2-95e1a4077e4d@doyensec.com>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260923-rxe-advise-mr-v3-v3-2-95e1a4077e4d@doyensec.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2026/9/23 7:40, Norbert Szetei via B4 Relay 写道:
> From: Norbert Szetei <norbert@doyensec.com>
> 
> rxe_ib_advise_mr_prefetch() and rxe_ib_prefetch_sg_list() look up the MR
> by lkey and hand it to rxe_odp_do_pagefault_and_lock() without checking
> that it is an ODP MR. That path runs to_ib_umem_odp() on mr->umem, and
> for a non-ODP MR mr->umem is a plain struct ib_umem from ib_umem_get(),
> so the container_of() in to_ib_umem_odp() lands past the end of the
> object and ib_umem_odp_map_dma_and_lock() reads its ib_umem_odp fields
> out of bounds.
> 
> lookup_mr() validates the lkey, PD, access and state but not the MR
> type, and IB_UVERBS_ADVISE_MR_ADVICE_PREFETCH is accepted for any MR.
> 
>   BUG: KASAN: slab-out-of-bounds in ib_umem_odp_map_dma_and_lock+0x884/0x8a0
>   Read of size 8 at addr ffff88810a3ebcf0 by task advi/921
>    ib_umem_odp_map_dma_and_lock+0x884/0x8a0
>    rxe_ib_advise_mr+0x543/0xad0
>    ib_uverbs_handler_UVERBS_METHOD_ADVISE_MR+0x446/0x530
>    ib_uverbs_cmd_verbs+0x2b3c/0x3b20
>    ib_uverbs_ioctl+0x1e3/0x310
>   Allocated by task 921:
>    __ib_umem_get_va+0x13e/0xae0
>    rxe_mr_init_user+0x2ae/0xb00
>    rxe_reg_user_mr+0x337/0x510
>   The buggy address belongs to the object at ffff88810a3ebc80
>    which belongs to the cache kmalloc-96 of size 96
> 
> Ask lookup_mr() for IB_ACCESS_ON_DEMAND in both the synchronous and
> the asynchronous prefetch arm. mr->access carries that flag only for
> an MR registered as ODP, so the existing
> (access & mr->access) != access test rejects a plain MR and the
> prefetch fails with -EINVAL.
> 
> Fixes: 3576b0df1588 ("RDMA/rxe: Implement synchronous prefetch for ODP MRs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Norbert Szetei <norbert@doyensec.com>

Thanks a lot.
It is fine with me.

Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>

Zhu Yanjun

> ---
>   drivers/infiniband/sw/rxe/rxe_odp.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c b/drivers/infiniband/sw/rxe/rxe_odp.c
> index e870efa7a0a3..f8ffd6a3219a 100644
> --- a/drivers/infiniband/sw/rxe/rxe_odp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_odp.c
> @@ -463,7 +463,7 @@ static int rxe_ib_prefetch_sg_list(struct ib_pd *ibpd,
>   		struct rxe_mr *mr;
>   		struct ib_umem_odp *umem_odp;
>   
> -		mr = lookup_mr(pd, IB_ACCESS_LOCAL_WRITE,
> +		mr = lookup_mr(pd, IB_ACCESS_LOCAL_WRITE | IB_ACCESS_ON_DEMAND,
>   			       sg_list[i].lkey, RXE_LOOKUP_LOCAL);
>   
>   		if (!mr) {
> @@ -529,7 +529,7 @@ static int rxe_ib_advise_mr_prefetch(struct ib_pd *ibpd,
>   
>   	for (i = 0; i < num_sge; ++i) {
>   		/* Takes a reference, which will be released in the queued work */
> -		mr = lookup_mr(pd, IB_ACCESS_LOCAL_WRITE,
> +		mr = lookup_mr(pd, IB_ACCESS_LOCAL_WRITE | IB_ACCESS_ON_DEMAND,
>   			       sg_list[i].lkey, RXE_LOOKUP_LOCAL);
>   		if (!mr) {
>   			mr = ERR_PTR(-EINVAL);
> 

