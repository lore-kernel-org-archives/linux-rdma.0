Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622A7192B75
	for <linux-rdma@vger.kernel.org>; Thu, 25 Jun 2026 15:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782402464; cv=none; b=QUPGcNQviSEhuwFXuBPqiMBPX7/SQQJTQ7aahClACWvk788a0Z/fr5G6I3S8p0MOB/M6D883g3N13rfGPvauDcA7P5nKKpZ3L3RibagTruMZV5n3SDz46oxGC+KapHNPrtxgpzH13PC0s9dyDd39v82LdoeSRuzZwK2u0t9BbiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782402464; c=relaxed/simple;
	bh=4dfb0H9aYM7Ikzfhq72r90WUDFnRyvqFDcV2upgd+Kg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jeu9vy3IhEtT+/4UkiaD3/uMDvmzo7RrJtqL1z725BurWt7H92/7039KqADtbMaSXr2RSZp+yBa0nWSQmnkd5Z4rJxgr5qgveKKWPvJkbdQNw/XHGxEEo8iEdjmXUVFU2hOVi56L4D5iUs8jx37Yy5fQKDDSYI5J8lbXQ883fPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iZMz6q6U; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iZMz6q6U"
Message-ID: <0060137c-acb5-4965-bdea-a5601cc4df61@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782402451;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S+D52fC4BDBRKqnk4I5sV3yu2/ACyckCpzkGYD8v7HE=;
	b=iZMz6q6UShfFM3g5YT5ps2nTry2AGb5bbp+/YgkPHKdYwaZDNuWdvMbiDb4A0yVXjAyyza
	k+FRyoqkQSkhj8jvHERWOQVu5x9HbAI3SDOIb+j0cxRCZj89EboopKr2blYsmAFWWEUNEW
	y5DUc8jR/5RDSwFFV9unk8lbPzepTUw=
Date: Thu, 25 Jun 2026 08:47:27 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] RDMA/rxe: Check PDs for memory window binds
To: Zhiwei Zhang <202275009@qq.com>, Zhu Yanjun <zyjzyj2000@gmail.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <tencent_88CB6CA0A60CDD53B24EA5E3A865E6FF5A0A@qq.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <tencent_88CB6CA0A60CDD53B24EA5E3A865E6FF5A0A@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

在 2026/6/24 23:16, Zhiwei Zhang 写道:
> The IBTA Software Transport Verbs specification requires the QP,
> Memory Window and Memory Region for a Bind Memory Window operation
> to belong to the same HCA and protection domain.
> 
> rxe only checked the QP and MW protection domain for type 2 MWs.
> Move the QP/MW PD check to the common bind path and also reject
> binding an MW to an MR from a different PD.
> 
> Invalid bind requests continue to fail with IB_WC_MW_BIND_ERR.
> 
> Signed-off-by: Zhiwei Zhang <202275009@qq.com>
> ---
>   drivers/infiniband/sw/rxe/rxe_mw.c | 20 ++++++++++++--------
>   1 file changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe_mw.c b/drivers/infiniband/sw/rxe/rxe_mw.c
> index 379e65bfcd49..aa9371e4ccd5 100644
> --- a/drivers/infiniband/sw/rxe/rxe_mw.c
> +++ b/drivers/infiniband/sw/rxe/rxe_mw.c
> @@ -72,13 +72,6 @@ static int rxe_check_bind_mw(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
>   			return -EINVAL;
>   		}
>   
> -		/* C10-72 */
> -		if (unlikely(qp->pd != to_rpd(mw->ibmw.pd))) {
> -			rxe_dbg_mw(mw,
> -				"attempt to bind type 2 MW with qp with different PD\n");
> -			return -EINVAL;
> -		}
> -
>   		/* o10-37.2.40 */
>   		if (unlikely(!mr || wqe->wr.wr.mw.length == 0)) {
>   			rxe_dbg_mw(mw,
> @@ -87,10 +80,21 @@ static int rxe_check_bind_mw(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
>   		}
>   	}
>   
> -	/* remaining checks only apply to a nonzero MR */
> +	/* C10-72 */
> +	if (unlikely(qp->pd != rxe_mw_pd(mw))) {
> +		rxe_dbg_mw(mw, "attempt to bind MW with qp with different PD\n");
> +		return -EINVAL;
> +	}
> +
>   	if (!mr)
>   		return 0;
>   
> +	/* remaining checks only apply to a nonzero MR */
> +	if (unlikely(qp->pd != mr_pd(mr))) {
> +		rxe_dbg_mw(mw, "attempt to bind MW to MR with different PD\n");
> +		return -EINVAL;
> +	}

Since the previous check has already explicitly confirmed that qp->pd == 
rxe_mw_pd(mw), this second check implicitly means mw->pd != mr_pd(mr). 
However, for the sake of absolute precision in the kernel logs—and to 
help anyone debugging immediately identify which of the three entities 
is mismatched—it would be better to make the log message more explicit.
"attempt to bind MW/QP to MR with different PD\n"

Except this log, I am fine with this patch.
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>

Zhu Yanjun

> +
>   	if (unlikely(mr->access & IB_ZERO_BASED)) {
>   		rxe_dbg_mw(mw, "attempt to bind MW to zero based MR\n");
>   		return -EINVAL;

