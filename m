Received: from mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D313D093A
	for <linux-rdma@vger.kernel.org>; Thu, 27 Aug 2026 22:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787869591; cv=none; b=g5EPPYCYKeytSbYffaiTf4RZO9sT7yl1mTjFL3QJC+s3ou+1TBk6KrZDUMOZcPO62CAbtqLDWMR2kgKhhMOxzDQpxJY7J+UL8IbSuEZogOx/8ZcwKdOr8b+BGaeVHj3f2AYiPIB2/kmXBDari/UHOt51i2I14A8PIQ7daPQNsZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787869591; c=relaxed/simple;
	bh=VA5zxrFbY3PQTnPkLynSmZ3ClflLa+1PI3VDeQbSbE8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lL6Wh/is4B6t3InY4dXp7UytJiAcLDfyHM/KB8COdLuFgUGgj1w7kz9hdxvNxepjFoc32JNuzOxZ0PU19t06iDDwfsrbMNka0Ac+tZDFyuKnwP/754li/bJF8emGKwgvV/8aP1k9Ss2gwaLogx1pTGb9f2HeWMYsp8TnzMxxYZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dXj94TTs; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dXj94TTs"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=VA5zxrFbY3PQTnPkLynSmZ3ClflLa+1PI3VDeQbSbE8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787869579; v=1; x=1788474379;
 b=dXj94TTso6hS9NS7fUzJhJFz9IAuXM/mcfjoSuaE1b5LHM2OPoONfi2Ulh6cxJuxaMca3PL8
 N66rj6RsX1IP8Tdpl5GgjagIs/vc0WaxV7dFMEeLy8H2STvr8ras0NS7+3uljYyHAp/0O6euI8F
 4lgQ4p8QNkm9OZ6yaiE5T4SE=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 0e2bdeecd9b4d29a;
	Thu, 27 Aug 2026 22:26:09 +0000
X-Mizu-Trace-ID: 0e2bdeecd9b4d29a
X-Migadu-Flow: FLOW_OUT
Message-ID: <dc993a28-cc91-4674-a52f-511e8bb54876@linux.dev>
Date: Thu, 27 Aug 2026 15:26:07 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/rxe: validate access flags before swapping the MR's
 PD
To: Norbert Szetei <norbert@doyensec.com>, linux-rdma@vger.kernel.org,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: Zhu Yanjun <zyjzyj2000@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, linux-kernel@vger.kernel.org
References: <46E1D5C0-24BE-4D01-BDB3-634FE09B22C5@doyensec.com>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <46E1D5C0-24BE-4D01-BDB3-634FE09B22C5@doyensec.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2026/8/27 10:18, Norbert Szetei 写道:
> rxe_rereg_user_mr() reassigns mr->ibmr.pd first and only then
> validates the IB_MR_REREG_ACCESS argument:
> 
> 	if (flags & IB_MR_REREG_PD) {
> 		rxe_put(old_pd);
> 		rxe_get(pd);
> 		mr->ibmr.pd = ibpd;
> 	}
> 
> 	if (flags & IB_MR_REREG_ACCESS) {
> 		if (access & ~RXE_ACCESS_SUPPORTED_MR)
> 			return ERR_PTR(-EOPNOTSUPP);
> 		mr->access = access;
> 	}
> 
> Both flags pass the entry check because RXE_MR_REREG_SUPPORTED is
> IB_MR_REREG_PD | IB_MR_REREG_ACCESS, so a caller can reach the access
> check with mr->ibmr.pd already reassigned.
> 
> mr->ibmr.pd is owned by the core, which adjusts pd->usecnt only on the
> success path: ib_uverbs_rereg_mr() jumps to put_new_uobj on a driver error
> without undoing the reassignment, so mr->pd == new_pd while the usecnts
> still charge the MR to orig_pd. ib_dereg_mr_user() then decrements
> new_pd, whose count can reach zero while a memory window still references
> it; uverbs_free_pd() frees the PD on that count alone and rxe_mw_cleanup()
> writes to freed memory:
> 
>    BUG: KASAN: slab-use-after-free in __rxe_put+0x31/0xa0
>    Write of size 4 at addr ffff8881301dd690 by task rxe_poc/591
>     __rxe_put+0x31/0xa0
>     rxe_mw_cleanup+0x42/0x200
>     __rxe_cleanup+0x115/0x370
>     rxe_dealloc_mw+0x4c/0x80
>    Allocated by task 591:
>     ib_uverbs_alloc_pd+0x258/0x540
>    Freed by task 591:
>     ib_dealloc_pd_user+0x174/0x210
>     uverbs_free_pd+0x8d/0xc0
>     ib_uverbs_dealloc_pd+0x18e/0x1d0
> 
> Validate the access flags before mutating any state so the callback either
> applies every requested change or none.
> 
> Fixes: 544c7f62cf32 ("RDMA/rxe: Implement rereg_user_mr")> Cc: stable@vger.kernel.org
> Signed-off-by: Norbert Szetei <norbert@doyensec.com>

Thanks a lot. I am fine with this commit.

Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>

Zhu Yanjun

> ---
>   drivers/infiniband/sw/rxe/rxe_verbs.c | 13 +++++++------
>   1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
> index 96c7716057fe..3864284522eb 100644
> --- a/drivers/infiniband/sw/rxe/rxe_verbs.c
> +++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
> @@ -1331,19 +1331,20 @@ static struct ib_mr *rxe_rereg_user_mr(struct ib_mr *ibmr, int flags,
>   	if (err)
>   		return ERR_PTR(err);
>   
> +	if ((flags & IB_MR_REREG_ACCESS) &&
> +	    (access & ~RXE_ACCESS_SUPPORTED_MR)) {
> +		rxe_err_mr(mr, "access = %#x not supported\n", access);
> +		return ERR_PTR(-EOPNOTSUPP);
> +	}
> +
>   	if (flags & IB_MR_REREG_PD) {
>   		rxe_put(old_pd);
>   		rxe_get(pd);
>   		mr->ibmr.pd = ibpd;
>   	}
>   
> -	if (flags & IB_MR_REREG_ACCESS) {
> -		if (access & ~RXE_ACCESS_SUPPORTED_MR) {
> -			rxe_err_mr(mr, "access = %#x not supported\n", access);
> -			return ERR_PTR(-EOPNOTSUPP);
> -		}
> +	if (flags & IB_MR_REREG_ACCESS)
>   		mr->access = access;
> -	}
>   
>   	return NULL;
>   }

