Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E463337C118
	for <linux-rdma@vger.kernel.org>; Mon, 29 Jun 2026 15:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782747162; cv=none; b=ncswIIZbnJ9uYCgVTsc7CVGS2mV+7BvqvQZczhRHScvDSwbai3Ru/6p9nelYqQfQ1J+4BOkKmC6UyvBvDoYgSJ15cJaicvzqm+z0sECNG6stWKARU12WiNUivf7p2MmmVLccvW8PT4nz967BHO5EfeINwjJnXXmoaabtq+xo4Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782747162; c=relaxed/simple;
	bh=8C5wHIw296d72CHheIgkw7j7WAclCODQPS+nZWgd71E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tfZkUp+nXBOInaBl0sh8YDRwy4vXOWX8X8Kkl2scVI0XSfMshnlMikL6S4MN4N4oA0fxtUbVFgoMz52qOICd5yC+/qeWaipCDk465Nm8thJmcxMbgt0CGeu3xKwrYTyHH6Ipyv9x4vOK1UBhGaibOpZdOK/OWlP82X06u3hC+Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KRLeapR9; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KRLeapR9"
Message-ID: <dad01d15-b0a6-43aa-bd72-6eeef51bd9c9@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782747159;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DEDXUEgk116II1lbRLMfpBLcrgR4pBog0BU9j5OYmjk=;
	b=KRLeapR9Zd9sXNsfewPW4ribeGUV2Tm7Hufp0xv08r3WipqfGPQWJx1xNRZU2sP2GkhD+p
	jb8CpTSOJtlTzStJ/Xb6AKdydGrhUgBFozncHZJTB3v935zentEAI/KgAnBs2U69eWQTZT
	xfn/4Gn41zTwIMmtED9iARzlXoqWn84=
Date: Mon, 29 Jun 2026 17:32:26 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3] RDMA/siw: publish QP after initialization
To: Ruoyu Wang <ruoyuw560@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260627144039.3109422-1-ruoyuw560@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Bernard Metzler <bernard.metzler@linux.dev>
In-Reply-To: <20260627144039.3109422-1-ruoyuw560@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 27.06.2026 16:40, Ruoyu Wang wrote:
> siw_create_qp() currently calls siw_qp_add() before the queues, CQ
> pointers, state, completion, and device list entry are ready. A QPN
> lookup can therefore reach a QP that is still being constructed.
> 
> Move siw_qp_add() to the end of siw_create_qp(), after QP
> initialization and before adding the QP to the siw device list.
> 
> Fixes: f29dd55b0236 ("rdma/siw: queue pair methods")
> Suggested-by: Bernard Metzler <bernard.metzler@linux.dev>
> Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
> ---
> Changes in v3:
> - Move siw_qp_add()/xa_alloc() to the end of siw_create_qp().
> - Drop the QPN reservation helper from v2.
> 
>   drivers/infiniband/sw/siw/siw_verbs.c | 45 +++++++++++++++------------
>   1 file changed, 25 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/infiniband/sw/siw/siw_verbs.c b/drivers/infiniband/sw/siw/siw_verbs.c
> index 1e1d262a4ae2..ee3e5529d6f4 100644
> --- a/drivers/infiniband/sw/siw/siw_verbs.c
> +++ b/drivers/infiniband/sw/siw/siw_verbs.c
> @@ -316,6 +316,7 @@ int siw_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
>   	struct siw_ucontext *uctx =
>   		rdma_udata_to_drv_context(udata, struct siw_ucontext,
>   					  base_ucontext);
> +	struct siw_uresp_create_qp uresp = {};
>   	unsigned long flags;
>   	int num_sqe, num_rqe, rv = 0;
>   	size_t length;
> @@ -369,11 +370,6 @@ int siw_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
>   	spin_lock_init(&qp->rq_lock);
>   	spin_lock_init(&qp->orq_lock);
>   
> -	rv = siw_qp_add(sdev, qp);
> -	if (rv)
> -		goto err_atomic;
> -
> -
>   	/* All queue indices are derived from modulo operations
>   	 * on a free running 'get' (consumer) and 'put' (producer)
>   	 * unsigned counter. Having queue sizes at power of two
> @@ -391,14 +387,14 @@ int siw_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
>   
>   	if (qp->sendq == NULL) {
>   		rv = -ENOMEM;
> -		goto err_out_xa;
> +		goto err_out;
>   	}
>   	if (attrs->sq_sig_type != IB_SIGNAL_REQ_WR) {
>   		if (attrs->sq_sig_type == IB_SIGNAL_ALL_WR)
>   			qp->attrs.flags |= SIW_SIGNAL_ALL_WR;
>   		else {
>   			rv = -EINVAL;
> -			goto err_out_xa;
> +			goto err_out;
>   		}
>   	}
>   	qp->pd = pd;
> @@ -424,7 +420,7 @@ int siw_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
>   
>   		if (qp->recvq == NULL) {
>   			rv = -ENOMEM;
> -			goto err_out_xa;
> +			goto err_out;
>   		}
>   		qp->attrs.rq_size = num_rqe;
>   	}
> @@ -439,11 +435,8 @@ int siw_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
>   	qp->attrs.state = SIW_QP_STATE_IDLE;
>   
>   	if (udata) {
> -		struct siw_uresp_create_qp uresp = {};
> -
>   		uresp.num_sqe = num_sqe;
>   		uresp.num_rqe = num_rqe;
> -		uresp.qp_id = qp_id(qp);
>   
>   		if (qp->sendq) {
>   			length = num_sqe * sizeof(struct siw_sqe);
> @@ -452,7 +445,7 @@ int siw_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
>   						      length, &uresp.sq_key);
>   			if (!qp->sq_entry) {
>   				rv = -ENOMEM;
> -				goto err_out_xa;
> +				goto err_out;
>   			}
>   		}
>   
> @@ -464,34 +457,46 @@ int siw_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
>   			if (!qp->rq_entry) {
>   				uresp.sq_key = SIW_INVAL_UOBJ_KEY;
>   				rv = -ENOMEM;
> -				goto err_out_xa;
> +				goto err_out;
>   			}
>   		}
>  

move below check as well into your new 'if (udata) {'
clause below, right before doing the
ib_copy_to_udata() thing. It logically belongs there.
>   		if (udata->outlen < sizeof(uresp)) {
>   			rv = -EINVAL;
> -			goto err_out_xa;
> +			goto err_out;
>   		}
> -		rv = ib_copy_to_udata(udata, &uresp, sizeof(uresp));
> -		if (rv)
> -			goto err_out_xa;
>   	}
>   	qp->tx_cpu = siw_get_tx_cpu(sdev);
>   	if (qp->tx_cpu < 0) {
>   		rv = -EINVAL;
> -		goto err_out_xa;
> +		goto err_out;
>   	}
>   	INIT_LIST_HEAD(&qp->devq);
Put above line close to the list_add_tail() below,
that's where it logically belongs to.


Looks good otherwise!

Thanks,
Bernard.
> +	init_completion(&qp->qp_free);
> +
> +	rv = siw_qp_add(sdev, qp);
> +	if (rv)
> +		goto err_out_tx;
> +
> +	if (udata) {
> +		uresp.qp_id = qp_id(qp);
> +
> +		rv = ib_copy_to_udata(udata, &uresp, sizeof(uresp));
> +		if (rv)
> +			goto err_out_xa;
> +	}
> +
>   	spin_lock_irqsave(&sdev->lock, flags);
>   	list_add_tail(&qp->devq, &sdev->qp_list);
>   	spin_unlock_irqrestore(&sdev->lock, flags);
>   
> -	init_completion(&qp->qp_free);
> -
>   	return 0;
>   
>   err_out_xa:
>   	xa_erase(&sdev->qp_xa, qp_id(qp));
> +err_out_tx:
> +	siw_put_tx_cpu(qp->tx_cpu);
> +err_out:
>   	if (uctx) {
>   		rdma_user_mmap_entry_remove(qp->sq_entry);
>   		rdma_user_mmap_entry_remove(qp->rq_entry);

