Received: from mta0.migadu.com (out-208.mta0.migadu.com [91.218.175.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB1A40EB99
	for <linux-rdma@vger.kernel.org>; Thu, 27 Aug 2026 19:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787857953; cv=none; b=O+25Sil1C4aBNM7uhoAt9/t8VACCSw8BDuCvpqOx8S4vgzp5VqWZI6SnCh2LgYA/xEA9XgXX8CzxMpNx0L5iw8B30I8k8K4yHJ43KaEfB3kOpI/n0TutgooEUv4LTXrSiEa0nMgMqmTXyG6KvcYbmrhwwQT8W/MDMskJlleuxmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787857953; c=relaxed/simple;
	bh=mZhb+1jxU20Yw/v0bX/foaYI7uLOOOFyWkVpOgfmn18=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PKHz6icisWLpzaue6dzo64BgCUoKSxrdR3zBkcvO604nzASEWd3DSQiYVpdsVQy7OcKiBj5A/yr2s2yYSA4DRWCpRoy2hCdjFoohy6SRyctEgGrOiD5P2bIcAk8KWZxniy8wK/JV01DDLlWr8G9Zc9Y/m3mRBp9x1a/e5hCiYQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UyPA1iAY; arc=none smtp.client-ip=91.218.175.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UyPA1iAY"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=mZhb+1jxU20Yw/v0bX/foaYI7uLOOOFyWkVpOgfmn18=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787857948; v=1; x=1788462748;
 b=UyPA1iAYE++KJSbjMJplAciUYLKC1uDNVoN/R0fpuFH4jQfQNtw2cctKxTnsqWPIUn+xklW8
 iGwF8NE+Cyog7GqxGQltuzPoyqXE9m4MyVVDTwxq2YFikiMHZos/aQQJrLPvTEy/LYd3bh5zkpz
 rh6oXlxgKSoenGrb2NbnInCY=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id bdcd1106c4d923b0;
	Thu, 27 Aug 2026 19:12:27 +0000
X-Mizu-Trace-ID: bdcd1106c4d923b0
X-Migadu-Flow: FLOW_OUT
Message-ID: <1cd5be49-6946-4010-8539-e8d015f23201@linux.dev>
Date: Thu, 27 Aug 2026 12:12:22 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/rxe: Reject prefetch of a non-ODP MR
To: Norbert Szetei <norbert@doyensec.com>, linux-rdma@vger.kernel.org,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: Zhu Yanjun <zyjzyj2000@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, linux-kernel@vger.kernel.org
References: <521D5E74-89E3-43C0-81C7-AC0BE52591E7@doyensec.com>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <521D5E74-89E3-43C0-81C7-AC0BE52591E7@doyensec.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2026/8/27 3:51, Norbert Szetei 写道:
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
>    BUG: KASAN: slab-out-of-bounds in ib_umem_odp_map_dma_and_lock+0x884/0x8a0
>    Read of size 8 at addr ffff88810a3ebcf0 by task advi/921
>     ib_umem_odp_map_dma_and_lock+0x884/0x8a0
>     rxe_ib_advise_mr+0x543/0xad0
>     ib_uverbs_handler_UVERBS_METHOD_ADVISE_MR+0x446/0x530
>     ib_uverbs_cmd_verbs+0x2b3c/0x3b20
>     ib_uverbs_ioctl+0x1e3/0x310
>    Allocated by task 921:
>     __ib_umem_get_va+0x13e/0xae0
>     rxe_mr_init_user+0x2ae/0xb00
>     rxe_reg_user_mr+0x337/0x510
>    The buggy address belongs to the object at ffff88810a3ebc80
>     which belongs to the cache kmalloc-96 of size 96
> 
> Reject a non-ODP MR after lookup_mr() in both the synchronous and
> asynchronous prefetch arms.
> 
> Fixes: 3576b0df1588 ("RDMA/rxe: Implement synchronous prefetch for ODP MRs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Norbert Szetei <norbert@doyensec.com>
> ---
>   drivers/infiniband/sw/rxe/rxe_odp.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c b/drivers/infiniband/sw/rxe/rxe_odp.c
> index e870efa7a0a3..5c9dde3501a0 100644
> --- a/drivers/infiniband/sw/rxe/rxe_odp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_odp.c
> @@ -472,6 +472,11 @@ static int rxe_ib_prefetch_sg_list(struct ib_pd *ibpd,
>   			return -EINVAL;
>   		}
>   
> +		if (unlikely(!is_odp_mr(mr))) {

lookup_mr is a function specific to rxe. Renaming it to rxe_lookup_mr 
would make this clearer.

When I first saw this function, I assumed it was a generic RDMA 
function. After looking into the implementation, I realized that it is 
specific to rxe. Therefore, I think rxe_lookup_mr would be a clearer and 
more descriptive name.

Anyway, I think this commit is fine. Thanks a lot.

Reviewed-by: Zhu Yanjun yanjun.zhu@linux.dev

Zhu Yanjun > +			rxe_put(mr);
> +			return -EOPNOTSUPP;
> +		}
> +
>   		if (advice == IB_UVERBS_ADVISE_MR_ADVICE_PREFETCH_WRITE &&
>   		    !mr->umem->writable) {
>   			rxe_dbg_mr(mr, "missing write permission\n");
> @@ -536,6 +541,12 @@ static int rxe_ib_advise_mr_prefetch(struct ib_pd *ibpd,
>   			goto err;
>   		}
>   
> +		if (unlikely(!is_odp_mr(mr))) {
> +			rxe_put(mr);
> +			mr = ERR_PTR(-EOPNOTSUPP);
> +			goto err;
> +		}
> +
>   		work->frags[i].io_virt = sg_list[i].addr;
>   		work->frags[i].length = sg_list[i].length;
>   		work->frags[i].mr = mr;

