Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B7518A6DB
	for <linux-rdma@vger.kernel.org>; Fri, 28 Aug 2026 03:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787886462; cv=none; b=BnPJuywERSRHSOAVmwdvnRgikoOYTZaPACbD19PKAIateI6JxQlMw91VoQ/3nsOBuEASaxidTX1+eoEmkB7GhU6nJeOYtwZAv3H2J+QwujYgtedjbeF/7wwYg9nDI7UAwIhQAbuWtJNMgXeEy7rUzGBxumCmpPiYBtF4JgdDPvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787886462; c=relaxed/simple;
	bh=nUrmCH8ATPcfcFzFuqGPWRExyD77m/ZlXR6xhaqZpfI=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=VkfvRrgy2Lld8XDaDFN2w+sPus5BT51QrOLVVff8czE5SrLGQkw75HQkdpf0h2Jmrk337YEayfGLRsnIr2f0S5n+anwWtBKU91RvQjhCQ5goC/Cd11np/4noMgS7mRGfVa2/daYT+oxLAQ4rUqM7wGxRWAXgk4jxJ5q1Jq+Qpb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=lajB9qVt; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="lajB9qVt"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787886458; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=dJV+WJfSpE1eVMULzVP3J7f0VT05TgE+Oa4yjJuDwVY=;
	b=lajB9qVtBrLTd8K9Td3g9VfmnHRMpSTXDRyTP83B1tnGgOse8lmatwZtHN0ZPhJj03DOskmwKI6qa4CzKeDt57hWgPNPJQ2XxcqpEGZZjmVYSW/USO8NZ4fvxHWh3ojCEeUabAPF5NbwBeuyx7gNKwnlurARQxpb3TEpxNi3cLY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X9l9XE1_1787886456;
Received: from 30.221.104.67(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0X9l9XE1_1787886456 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 28 Aug 2026 11:07:37 +0800
Message-ID: <2f5d0de3-6811-fe1e-ce2d-71f7c1fbfeb5@linux.alibaba.com>
Date: Fri, 28 Aug 2026 11:07:36 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH for-rc] RDMA/erdma: Use IRQ-safe XArray helpers for QP and
 CQ tables
Content-Language: en-US
From: Cheng Xu <chengyou@linux.alibaba.com>
To: jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, KaiShen@linux.alibaba.com
References: <20260825121638.75509-1-chengyou@linux.alibaba.com>
In-Reply-To: <20260825121638.75509-1-chengyou@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 8/25/26 8:16 PM, Cheng Xu wrote:
> Locked QP and CQ lookups from EQ interrupts can deadlock with
> create-path XArray updates. If an interrupt arrives while the create
> path holds the plain xa_lock, the lookup spins forever trying to
> acquire the same lock.
> 
> Use IRQ-safe XArray helpers for all QP and CQ create-path updates,
> including the GSI QP store and error paths.
> 
> Fixes: 98df2aee1459 ("RDMA/erdma: Hold CQ references when processing EQ events")
> Fixes: a52eeff32024 ("RDMA/erdma: Hold QP references for AE and CM processing")
> Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
> ---
>  drivers/infiniband/hw/erdma/erdma_verbs.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 

Hi,

Sashiko found an issue in this patch, so I have sent v2.

Thanks,
Cheng Xu

> diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.c b/drivers/infiniband/hw/erdma/erdma_verbs.c
> index 65b1af1e6623..f18b88bba281 100644
> --- a/drivers/infiniband/hw/erdma/erdma_verbs.c
> +++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
> @@ -1021,15 +1021,15 @@ int erdma_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
>  	init_completion(&qp->safe_free);
>  
>  	if (qp->ibqp.qp_type == IB_QPT_GSI) {
> -		old_entry = xa_store(&dev->qp_xa, 1, qp, GFP_KERNEL);
> +		old_entry = xa_store_irq(&dev->qp_xa, 1, qp, GFP_KERNEL);
>  		if (xa_is_err(old_entry))
>  			ret = xa_err(old_entry);
>  		else
>  			qp->ibqp.qp_num = 1;
>  	} else {
> -		ret = xa_alloc_cyclic(&dev->qp_xa, &qp->ibqp.qp_num, qp,
> -				      XA_LIMIT(1, dev->attrs.max_qp - 1),
> -				      &dev->next_alloc_qpn, GFP_KERNEL);
> +		ret = xa_alloc_cyclic_irq(&dev->qp_xa, &qp->ibqp.qp_num, qp,
> +					  XA_LIMIT(1, dev->attrs.max_qp - 1),
> +					  &dev->next_alloc_qpn, GFP_KERNEL);
>  	}
>  
>  	if (ret < 0) {
> @@ -1089,7 +1089,7 @@ int erdma_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
>  	else
>  		free_kernel_qp(qp);
>  err_out_xa:
> -	xa_erase(&dev->qp_xa, QP_ID(qp));
> +	xa_erase_irq(&dev->qp_xa, QP_ID(qp));
>  err_out:
>  	return ret;
>  }
> @@ -1993,9 +1993,9 @@ int erdma_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
>  	refcount_set(&cq->refcount, 1);
>  	init_completion(&cq->free);
>  
> -	ret = xa_alloc_cyclic(&dev->cq_xa, &cq->cqn, cq,
> -			      XA_LIMIT(1, dev->attrs.max_cq - 1),
> -			      &dev->next_alloc_cqn, GFP_KERNEL);
> +	ret = xa_alloc_cyclic_irq(&dev->cq_xa, &cq->cqn, cq,
> +				  XA_LIMIT(1, dev->attrs.max_cq - 1),
> +				  &dev->next_alloc_cqn, GFP_KERNEL);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -2041,7 +2041,7 @@ int erdma_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
>  	}
>  
>  err_out_xa:
> -	xa_erase(&dev->cq_xa, cq->cqn);
> +	xa_erase_irq(&dev->cq_xa, cq->cqn);
>  
>  	return ret;
>  }
