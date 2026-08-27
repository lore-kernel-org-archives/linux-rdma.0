Received: from mta0.migadu.com (out-164.mta0.migadu.com [91.218.175.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D68471CF8
	for <linux-rdma@vger.kernel.org>; Thu, 27 Aug 2026 13:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.164
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787837313; cv=none; b=ZZYnrf/GRp23fMVegV7GRtSVM3O+vhgZCbSY5U8oaN2DgnW6MwelVJhnvH3n0uxtTY0qDrc0mzdWh8DTijWFEIw2YXLM/enWlKhBl1d5WJGSI2Jkvn6sE9sRMzd8n+xGrQUpmp/deLX8jQwwBkBnYhCMFsMEnXTLkp1Md1/lBos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787837313; c=relaxed/simple;
	bh=7MG//eqINo+hIz5NgcWTSS8yKOlrSBnNJ/xgChDZ9sY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PnsfI/mdPej/yL5QvLD9msdgJRJTpYFfO6+ZJa9TSu2l0OyIGJAoK/ClTuAzlr/E1GInBthlv0ltVtLwPmVlts57uHNspt4CUrf4hrT/FdywvhuRr2oYrDkQlmPYVLQeDX4W3TbHDrVCkPl4HfqhbCtLq3dSTVpB+SOK9tnVrgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=I2q30Fkn; arc=none smtp.client-ip=91.218.175.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="I2q30Fkn"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=7MG//eqINo+hIz5NgcWTSS8yKOlrSBnNJ/xgChDZ9sY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787837301; v=1; x=1788442101;
 b=I2q30FknJIYgbNKL4nixdLym7J8wi8rGaaCAxRpXyE/NQ7NAvLPS5SfGd88W82zn54VriuuM
 BZdVU06BCuce3L6Fj9nkusOpFTxaxAmpmvgKsrWIJ6UBpolCTK+T4sd0768tYEo/9+KGxr7XqYT
 yoObLFRc9JzYxtBBxfkkQZtg=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id c0d152b930757516;
	Thu, 27 Aug 2026 13:28:21 +0000
X-Mizu-Trace-ID: c0d152b930757516
X-Migadu-Flow: FLOW_OUT
Message-ID: <b08cb248-e7eb-48ea-9873-02032c0ed0ff@linux.dev>
Date: Thu, 27 Aug 2026 15:28:20 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] RDMA/siw: Clear association under lock if
 siw_qp_modify fails in siw_accept
To: Guoqing Jiang <guoqing.jiang@linux.dev>, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, shuangpeng.kernel@gmail.com
References: <20260827125553.12831-1-guoqing.jiang@linux.dev>
From: Bernard Metzler <bernard.metzler@linux.dev>
In-Reply-To: <20260827125553.12831-1-guoqing.jiang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27.08.2026 14:55, Guoqing Jiang wrote:
> We need to clear cep before release state_lock as siw_qp_llp_close and
> siw_qp_modify->siw_qp_llp_close did.
> 
> Otherwise if siw_qp_modify() fails in siw_accept(), the QP's state_lock
> is released before the error path cleanup. A concurrent ibv_modify_qp()
> transitioning the QP to ERROR can race in this window:
> 
>    siw_accept()                       ibv_modify_qp(ERROR)
>    ----------------------             ----------------------
>    siw_qp_modify() fails
>    up_write(&qp->state_lock)
>                                       down_write(&qp->state_lock)
>                                       nextstate_from_idle():
> 				     if (qp->cep)
>                                         siw_cep_put(qp->cep) <- frees cep
>                                         qp->cep = NULL
>    goto error
>      cep->qp = NULL                   <- UAF
> 
> Clear qp->cep and drop the association reference taken by siw_cep_get(),
> all under the write lock held from the initial down_write(&qp->state_lock).
> Thread B therefore sees qp->cep == NULL, skips its own put, and cannot free
> the cep before siw_accept() is done with it.
> 
> Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
> Link: https://lore.kernel.org/linux-rdma/d6fbe475-a5c2-f975-99b0-a0bd6b6d10e8@linux.dev/T/#m5876c1ff2de8686a9a1173b8f1aa0ff5363a785c
> Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
> ---
> V2: remove redundant code per Bernard's review
> 
>   drivers/infiniband/sw/siw/siw_cm.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
> index 0245b25e7271..ed49818793dd 100644
> --- a/drivers/infiniband/sw/siw/siw_cm.c
> +++ b/drivers/infiniband/sw/siw/siw_cm.c
> @@ -1719,9 +1719,12 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
>   			   SIW_QP_ATTR_STATE | SIW_QP_ATTR_LLP_HANDLE |
>   				   SIW_QP_ATTR_ORD | SIW_QP_ATTR_IRD |
>   				   SIW_QP_ATTR_MPA);
> +	if (rv) {
> +		qp->cep = NULL;
> +		siw_cep_put(cep);
> +		goto error_unlock;
> +	}
>   	up_write(&qp->state_lock);
> -	if (rv)
> -		goto error;
>   
>   	siw_dbg_cep(cep, "[QP %u]: send mpa reply, %d byte pdata\n",
>   		    qp_id(qp), params->private_data_len);

Looks good. Thank you, Guoqing.

Acked-by: Bernard Metzler <bernard.metzler@linux.dev>
