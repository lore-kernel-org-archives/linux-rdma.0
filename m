Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736201F09AD
	for <linux-rdma@vger.kernel.org>; Fri, 26 Jun 2026 02:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782439656; cv=none; b=lJEqE8LeDphSCEg41TFDNeqSpsDkYsd/uI7PLhqguURwedqwP3SQDDRAoy3p9BDjgNRNskgPCK6vhqRTDg+ekZFmu3L5z4y+jHfe+UizPFPZMKBNAEJyB8h2TR85LNGz63nr1dd0NLLqfZxI6Kd/EAEbu6CYcPBoJW+v5v/Qj8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782439656; c=relaxed/simple;
	bh=1ihNJoT8/ZXc62I41MiabtaWrBjIF6/3qgFIsqKehL0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VWvhM/1GDWatcD8e87cKvFiAD6CPzr+WRZTVZgipwGyAbfhIS00hcTiWDm7+7a+54NLOpZJ+eUj5D6/kb31yXOqrEB2r1i1IoaKXhjbCNcpXQL4ZARmY+pK28DI/V70unudLaY0ehH73S/s+RVnK3ArdgcB4UD7Aiudj60zW0V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FbgJLkDK; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FbgJLkDK"
Message-ID: <c94264a5-3078-4152-b38b-e20156c54068@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782439653;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sbUtshgjGrpyDeVrPrLHX9g+whVL51wvLopZCYzLVVE=;
	b=FbgJLkDKmKdvo0opxclS+GcrnTAl07QSduRbE+NpRM0px1DEh+03Jyq9XLyXrywZOM0elb
	geWTBLr4cEyf5SCfTxpk7tOc1xXVgbQsd1KZG2M7Mi+NOuUhdzeaONMIijMFa09cpLiZkr
	aWXlM4rEzttwX51Nxx2p0dGkoLpSXzQ=
Date: Thu, 25 Jun 2026 19:07:29 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2] RDMA/rxe: Check PDs for memory window binds
To: Zhiwei Zhang <202275009@qq.com>, Zhu Yanjun <zyjzyj2000@gmail.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <tencent_FD4FB25AA4FFA845E63F5AC36CF4A46CDC0A@qq.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <tencent_FD4FB25AA4FFA845E63F5AC36CF4A46CDC0A@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 2026/6/25 18:59, Zhiwei Zhang 写道:
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
> Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
> Signed-off-by: Zhiwei Zhang <202275009@qq.com>


Thanks a lot. I am fine with this. Let us wait for the comments from 
Leon and Jason.

Zhu Yanjun


> ---
>   drivers/infiniband/sw/rxe/rxe_mw.c | 20 ++++++++++++--------
>   1 file changed, 12 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/infiniband/sw/rxe/rxe_mw.c b/drivers/infiniband/sw/rxe/rxe_mw.c
> index 379e65bfcd49..bddb7a257831 100644
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
> +		rxe_dbg_mw(mw, "attempt to bind MW/QP to MR with different PD\n");
> +		return -EINVAL;
> +	}
> +
>   	if (unlikely(mr->access & IB_ZERO_BASED)) {
>   		rxe_dbg_mw(mw, "attempt to bind MW to zero based MR\n");
>   		return -EINVAL;

-- 
Best Regards,
Yanjun.Zhu

