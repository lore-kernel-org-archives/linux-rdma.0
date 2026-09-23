Received: from mta0.migadu.com (out-76.mta0.migadu.com [91.218.175.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2BD427F91
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 22:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790203764; cv=none; b=IA1ReG15Idg9gPCMoNc43ZYGAbjKEPWaevQVtkrPkLoSfahSAHZzjmTwasnyqzAge/88n6FE+z3fU/quysA3xPBuCz1rXTHoDTCZKi8h4l4oYpnNWTXOzRsJHTgegGgcRlz4rYl87nqLHxrl4uE7ZV0xoNqmwncleMbplgqh0gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790203764; c=relaxed/simple;
	bh=N6DEIJwXs89OYvuIP58cOGr26F4IcXTzYNn+vfOg1xc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jIbKR/6yT1M1RsGoYlsXlPsmUkAzGYHHmjOOuQGfVdbgPBThUz6fBQ5YaTRdGVicWQBoavaRgP/b+7baMDf96b8ztMROuEwMt3JZjqZ1xj9F0b6jaq8Q9glIQOoDlePHlqn4I1fIrgV5A7cxB3lDn0s+W8IbF2upKJMvt/MC+bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=C/lmrSDW; arc=none smtp.client-ip=91.218.175.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="C/lmrSDW"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=N6DEIJwXs89OYvuIP58cOGr26F4IcXTzYNn+vfOg1xc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790203759; v=1; x=1790808559;
 b=C/lmrSDWYZnosGT3v6xXmQ5eOc+DwhsAPKuqw2s3hmA4IDF4A9altCq74VkGf/t4FEyzWC5X
 zGukvWBisfj9A8svbBW/vU0QLH2s9qsanucI7LTixNjKCrbaYLtmKZuhBe1y9Bz8YcXDseFDvmW
 mfaYga+tycHG0YdgCK5hxPqI=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ee3f85351b71f6f8;
	Wed, 23 Sep 2026 22:49:09 +0000
X-Mizu-Trace-ID: ee3f85351b71f6f8
X-Migadu-Flow: FLOW_OUT
Message-ID: <7aef51f0-b28f-4d8a-b938-aea8b3dcfd87@linux.dev>
Date: Wed, 23 Sep 2026 15:49:03 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] RDMA/rxe: Reject IB_ACCESS_ON_DEMAND changes after
 MR creation
To: norbert@doyensec.com, Zhu Yanjun <zyjzyj2000@gmail.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Bob Pearson <rpearsonhpe@gmail.com>, Daisuke Matsuda <dskmtsd@gmail.com>,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260923-rxe-advise-mr-v3-v3-0-95e1a4077e4d@doyensec.com>
 <20260923-rxe-advise-mr-v3-v3-1-95e1a4077e4d@doyensec.com>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260923-rxe-advise-mr-v3-v3-1-95e1a4077e4d@doyensec.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2026/9/23 7:40, Norbert Szetei via B4 Relay 写道:
> From: Norbert Szetei <norbert@doyensec.com>
> 
> Whether an MR is an ODP MR is decided once, at registration time:
> rxe_reg_user_mr() picks rxe_odp_mr_init_user() over rxe_mr_init_user()
> based on IB_ACCESS_ON_DEMAND, and only the former builds an ib_umem_odp
> via ib_umem_odp_get(). The umem cannot change type afterwards, and
> is_odp_mr() reads mr->umem->is_odp.
> 
> Two paths assign mr->access after that point and can leave it
> describing an MR type the umem does not have:
> 
> rxe_rereg_user_mr() with IB_MR_REREG_ACCESS overwrites mr->access with
> the caller's value, and IB_ACCESS_ON_DEMAND is part of
> RXE_ACCESS_SUPPORTED_MR, so userspace can set the flag on a plain MR or
> clear it on an ODP MR while the umem stays what it was.
> 
> rxe_reg_fast_mr() takes mr->access from the REG_MR work request
> unmasked and moves the MR to RXE_MR_STATE_VALID, on an MR that
> rxe_mr_init_fast() left with a NULL umem.
> 
> Reject IB_ACCESS_ON_DEMAND in both, so mr->access carries the flag only
> for an MR that has an ODP umem and the flag can be used to identify one.
> 
> Fixes: 544c7f62cf32 ("RDMA/rxe: Implement rereg_user_mr")
> Cc: stable@vger.kernel.org
> Signed-off-by: Norbert Szetei <norbert@doyensec.com>

I have already reviewed this commit. I am fine with this commit.
So
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>

Zhu Yanjun

> ---
>   drivers/infiniband/sw/rxe/rxe_mr.c    | 6 ++++++
>   drivers/infiniband/sw/rxe/rxe_verbs.c | 6 ++++++
>   2 files changed, 12 insertions(+)
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
> index 875eceb55fdf..2afda5154dfb 100644
> --- a/drivers/infiniband/sw/rxe/rxe_mr.c
> +++ b/drivers/infiniband/sw/rxe/rxe_mr.c
> @@ -795,6 +795,12 @@ int rxe_reg_fast_mr(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
>   		return -EINVAL;
>   	}
>   
> +	/* an MR with no umem is never an ODP MR */
> +	if (unlikely(access & IB_ACCESS_ON_DEMAND)) {
> +		rxe_dbg_mr(mr, "access = 0x%x requests ODP\n", access);
> +		return -EINVAL;
> +	}
> +
>   	mr->access = access;
>   	mr->lkey = key;
>   	mr->rkey = key;
> diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
> index 96c7716057fe..21855274f63a 100644
> --- a/drivers/infiniband/sw/rxe/rxe_verbs.c
> +++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
> @@ -1331,6 +1331,12 @@ static struct ib_mr *rxe_rereg_user_mr(struct ib_mr *ibmr, int flags,
>   	if (err)
>   		return ERR_PTR(err);
>   
> +	if ((flags & IB_MR_REREG_ACCESS) &&
> +	    ((access ^ mr->access) & IB_ACCESS_ON_DEMAND)) {
> +		rxe_err_mr(mr, "cannot change IB_ACCESS_ON_DEMAND\n");
> +		return ERR_PTR(-EOPNOTSUPP);
> +	}
> +
>   	if (flags & IB_MR_REREG_PD) {
>   		rxe_put(old_pd);
>   		rxe_get(pd);
> 

