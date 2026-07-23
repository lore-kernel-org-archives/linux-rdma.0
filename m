Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A2837DEA1;
	Thu, 23 Jul 2026 08:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784794116; cv=none; b=ltiXrheHehhllKpEWTZDuLrZPn6saNPLETDHMtrOroG12GYDtk6msojhaL7EPArQzf4kCRL5NqMtdIznMCaiBeMpxzUESaxWyXsG7HT9VTEUej3Wh8cm74LBjJLVYn0Am8+GVyEvj2X0sxtR+YKygchYNIFxLMmRgB6siwlUhk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784794116; c=relaxed/simple;
	bh=7ZpjJ0AR8m8jk75wu9pqVc+aMfXRVbAF6HeBmks4bJM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fVihDfgnPlUinPEbYPt6/VnMhF0Crf2FDdR+htWQ65iZt2/qsnmJx6Of4F4rMxhi8w6Rhlrvi6W+crJvvoooSRLtKvhUMkSxYdfK5Z8mHtxhi+0/4fufUvHRghaXjkwJS7ezlsCtUt3lF1uCGW/VV6JCvHblUD/v75YK0FLWaOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=jLg8kQnj; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="jLg8kQnj"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784794110; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=nurY72WLtbiBuXLzZL1ENKlyc5yQo+wcEK0q+X5MDoU=;
	b=jLg8kQnjN8Gnz5VBMr8Uwkr8S9Dcvsz6cD0Nl33xPAAL86HI4BVucBXWkjNXhGVZ0+QKPccA0K0TKjtY5U0fUtvWSniT0EB0mCGJI6qyJOfKZlcvpKBkvNZkRu/qUHbgmF5Ps3CZl3AoREsyWrhnSiuHR6cxRHZ9eO1UddwgelY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X7fc6pf_1784794109;
Received: from 30.221.110.236(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0X7fc6pf_1784794109 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 23 Jul 2026 16:08:29 +0800
Message-ID: <4c1bbac8-b010-ce2d-3d96-25623cbdeec1@linux.alibaba.com>
Date: Thu, 23 Jul 2026 16:08:28 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH rdma-next] RDMA/erdma: complete object teardown when the
 destroy command fails
Content-Language: en-US
To: Leon Romanovsky <leon@kernel.org>, Kai Shen <kaishen@linux.alibaba.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Wei Yongjun <weiyongjun1@huawei.com>,
 Yang Li <yang.lee@linux.alibaba.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260722-b4-qp-and-cq-memory-are-leaked-if-the-d-v1-1-97e223dc1c96@nvidia.com>
From: Cheng Xu <chengyou@linux.alibaba.com>
In-Reply-To: <20260722-b4-qp-and-cq-memory-are-leaked-if-the-d-v1-1-97e223dc1c96@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 7/22/26 9:13 PM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> erdma_destroy_qp(), erdma_destroy_cq(), erdma_dereg_mr(), and
> erdma_destroy_ah() returned early when erdma_post_cmd_wait() failed,
> leaking the queue buffers, MTTs, doorbells and the STAG, QPN, CQN and AHN
> identifiers. A command timeout clears ERDMA_CMDQ_STATE_OK_BIT and
> permanently disables the command queue, so no retry can succeed; the RDMA
> core keeps the object after a failed destructor and forced uverbs cleanup
> then nulls the pointers, making the resources unreachable.
> 
> Warn on failure but release every software-owned resource and return
> success, since during terminal destruction the hardware command result is
> only diagnostic.
> 
> Fixes: 155055771704 ("RDMA/erdma: Add verbs implementation")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/infiniband/hw/erdma/erdma_verbs.c | 21 +++++++++++++++++----
>  1 file changed, 17 insertions(+), 4 deletions(-)
> 

Thanks Leon, this makes sense to me.

Acked-by: Cheng Xu <chengyou@linux.alibaba.com>

Thanks,
Cheng Xu

> diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.c b/drivers/infiniband/hw/erdma/erdma_verbs.c
> index 71e3e8618a61..ab6abbab029e 100644
> --- a/drivers/infiniband/hw/erdma/erdma_verbs.c
> +++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
> @@ -1302,8 +1302,15 @@ int erdma_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
>  
>  	ret = erdma_post_cmd_wait(&dev->cmdq, &req, sizeof(req), NULL, NULL,
>  				  true);
> +	/*
> +	 * A timeout disables the command queue, so retry cannot succeed.  Treat
> +	 * terminal command failures as diagnostic; propagating them can make
> +	 * forced uverbs cleanup discard the last software resource pointers.
> +	 */
>  	if (ret)
> -		return ret;
> +		ibdev_warn_ratelimited(&dev->ibdev,
> +				       "failed to deregister MR 0x%x: %d\n",
> +				       ibmr->lkey, ret);
>  
>  	erdma_free_idx(&dev->res_cb[ERDMA_RES_TYPE_STAG_IDX], ibmr->lkey >> 8);
>  
> @@ -1329,7 +1336,9 @@ int erdma_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
>  	err = erdma_post_cmd_wait(&dev->cmdq, &req, sizeof(req), NULL, NULL,
>  				  true);
>  	if (err)
> -		return err;
> +		ibdev_warn_ratelimited(&dev->ibdev,
> +				       "failed to destroy CQ %u: %d\n",
> +				       cq->cqn, err);
>  
>  	if (rdma_is_kernel_res(&cq->ibcq.res)) {
>  		dma_free_coherent(&dev->pdev->dev, cq->depth << CQE_SHIFT,
> @@ -1377,7 +1386,9 @@ int erdma_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
>  	err = erdma_post_cmd_wait(&dev->cmdq, &req, sizeof(req), NULL, NULL,
>  				  true);
>  	if (err)
> -		return err;
> +		ibdev_warn_ratelimited(&dev->ibdev,
> +				       "failed to destroy QP %u: %d\n",
> +				       QP_ID(qp), err);
>  
>  	erdma_qp_put(qp);
>  	wait_for_completion(&qp->safe_free);
> @@ -2279,7 +2290,9 @@ int erdma_destroy_ah(struct ib_ah *ibah, u32 flags)
>  	ret = erdma_post_cmd_wait(&dev->cmdq, &req, sizeof(req), NULL, NULL,
>  				  flags & RDMA_DESTROY_AH_SLEEPABLE);
>  	if (ret)
> -		return ret;
> +		ibdev_warn_ratelimited(&dev->ibdev,
> +				       "failed to destroy AH %u: %d\n",
> +				       ah->ahn, ret);
>  
>  	erdma_free_idx(&dev->res_cb[ERDMA_RES_TYPE_AH], ah->ahn);
>  
> 
> ---
> base-commit: 0e8e94c15091041ea8910cbfcade5a9c7cfe3f90
> change-id: 20260722-b4-qp-and-cq-memory-are-leaked-if-the-d-760a0f866319
> 
> Best regards,
> --  
> Leon Romanovsky <leonro@nvidia.com>
