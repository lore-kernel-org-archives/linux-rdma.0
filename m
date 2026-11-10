Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794325282;
	b=extrC2m8p3M8MYEehclNXkwGntM/B6BGz0fTQ/lpDzVjnhiC1mTvy5CRMq9LUKGc0VMB
	 9uBvyJZZhD4V74Xmq4MbwVkqs1epLsMx5ZyAo07ac9YZkZNj3/Rzw00cTDVYBY3Kre1sc
	 5ZdeuNk/RCcw0MDPTxJPCcdBkk24cJBHcbZR3tBn+UoxjMoktHpy8x5ca68QKnqwHNMVg
	 4xAYOUKyo6jzXIyZfJE/tSizg7YU+XlCm1g6iUiTmOnwpJio+PH9VKPZ5NEWmYKKHy4fY
	 Kb/cxe6JbI6mIAknczbq8WbgJaM01fKdu8U6OOMrSTYWm2mPckOZ9cZe/6Uz0k6VPzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794325282;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=PaNjR2X5LBK29oUedCwq5xzx24wNQ4vRCBM+QoGI0VI=;
	b=rODNbsx7lvEjMvF/FsBhbhk0E2kkr3SRJRidnh2s+6zRYis8/nnu3FKSe2Abo6yUyAt7
	 LoPGLaxL//4e+5BWqZ0zNGvr2oT/a44V9G0eFP3CFsD9dDo36I+FlkAr1r61+7En5uGPD
	 Ql1bEKgxssHscRlygb5d82HU8q4L90VdNi1+2T5kw6f8GR+8+gM2WsKYF2cx0M/o31D+R
	 X/bnebj2sLKki4tFHCLLNllfIP0y9bewNzSRh7zh9CEOV42mopdnER2tZQDvsOi56DqLS
	 wL7utkjRNqBukXijTRCUwDYuzqq0Kny/QHdXZzrIqp0kXlU9SBhcBd/jQFLDOfOUUbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HrUnTUuB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8868860A2629;
	Tue, 10 Nov 2026 15:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HrUnTUuB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C69F1F008A5;
	Tue, 10 Nov 2026 15:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794325282;
	bh=PaNjR2X5LBK29oUedCwq5xzx24wNQ4vRCBM+QoGI0VI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HrUnTUuBZcqBST7b9i2NNmFC/hxFzPrgiTPAshf5kN0TTq23f1M50mL+0Qb5yDmLI
	 /4tdq8fVVNvaI58gAmgnBoS0PJmHfpJYyO44VZedpnrvfGOA+K+FpGDjcMARZgQc+t
	 LghId7ERfwbp9bSAy4GrcQnaM35/YfskxY0vepPQtHrfGlvfF48BFfmLF740vUIEi8
	 oPQ1/XPD1hXEjFdyUkNBWxTSwyYQXTaTVxto98x7gK9//9i+z48fizZ9MVAuVEZA/9
	 8hVijN6bwlSMadfCYBtrID6mQxoe852ats102UavQZ+0/ANNdeQUsgvxSYcTr4sCuW
	 GZ/jENp8xRFGQ==
Date: Tue, 10 Nov 2026 17:41:17 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Konstantin Taranov <kotaranov@linux.microsoft.com>
Cc: kotaranov@microsoft.com, snsanghvi@microsoft.com, longli@microsoft.com,
	jgg@ziepe.ca, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH rdma-next v9 2/9] RDMA/mana: Create and destroy kernel RC
 QPs
Message-ID: <20261110154117.GN8635@unreal>
References: <20261105175928.1326682-1-kotaranov@linux.microsoft.com>
 <20261105175928.1326682-3-kotaranov@linux.microsoft.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105175928.1326682-3-kotaranov@linux.microsoft.com>

On Thu, Nov 05, 2026 at 09:59:21AM -0800, Konstantin Taranov wrote:
> From: Konstantin Taranov <kotaranov@microsoft.com>
> 
> Implement kernel RC QP creation and destruction. This feature requires
> extended-WQE and power-of-two-SQ support from the HW.
> 
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
> ---
> v5:
> - Validate kernel QP queue sizes before allocating queues.
> - Bound SGE counts and enforce the TX/RX WQE size limits.
> v4:
> - Reject RNIC firmware send-SGE counts below 2.
> - Subtract the reserved SGE for extra-large OOB only for RNIC mana_ib.
> 
>  drivers/infiniband/hw/mana/main.c    |  10 +-
>  drivers/infiniband/hw/mana/mana_ib.h |   6 +
>  drivers/infiniband/hw/mana/qp.c      | 206 +++++++++++++++++++++++++--
>  3 files changed, 211 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
> index ceb4ec58023a..f54905764f59 100644
> --- a/drivers/infiniband/hw/mana/main.c
> +++ b/drivers/infiniband/hw/mana/main.c
> @@ -733,6 +733,13 @@ int mana_ib_gd_query_adapter_caps(struct mana_ib_dev *dev)
>  	if (err)
>  		return err;
>  
> +	/* Hardware supports at least one data SGE plus one reserved for extra-large OOB. */
> +	if (resp.max_send_sge_count < 2) {
> +		ibdev_err(&dev->ib_dev, "Invalid max_send_sge_count %u, expected at least 2\n",
> +			  resp.max_send_sge_count);
> +		return -EINVAL;
> +	}

This check does not make sense here. If this firmware is present, continue to
support it; do not fail just because the kernel has been upgraded. If it is
not present, why check for it?

> +
>  	caps->max_sq_id = resp.max_sq_id;
>  	caps->max_rq_id = resp.max_rq_id;
>  	caps->max_cq_id = resp.max_cq_id;
> @@ -748,7 +755,8 @@ int mana_ib_gd_query_adapter_caps(struct mana_ib_dev *dev)
>  				resp.max_requester_sq_size / GDMA_MAX_SQE_SIZE,
>  				resp.max_requester_rq_size / GDMA_MAX_RQE_SIZE);
>  	caps->max_inline_data_size = resp.max_inline_data_size;
> -	caps->max_send_sge_count = resp.max_send_sge_count;
> +	/* Account for the SGE reserved for extra-large OOB. */
> +	caps->max_send_sge_count = resp.max_send_sge_count - 1;
>  	caps->max_recv_sge_count = resp.max_recv_sge_count;
>  	caps->feature_flags = resp.feature_flags;
>  
> diff --git a/drivers/infiniband/hw/mana/mana_ib.h b/drivers/infiniband/hw/mana/mana_ib.h
> index 5ca6e2acf974..6f5df64e838a 100644
> --- a/drivers/infiniband/hw/mana/mana_ib.h
> +++ b/drivers/infiniband/hw/mana/mana_ib.h
> @@ -267,6 +267,10 @@ struct mana_ib_qp {
>  	u32 sq_psn;
>  	bool sq_sig_all;
>  
> +	/* Serializes receive WR posting. */
> +	spinlock_t rq_lock;
> +	/* Serializes send and memory-management WR posting. */
> +	spinlock_t sq_lock;
>  	/* Serializes QP modification and error-list transitions. */
>  	struct mutex modify_lock;
>  
> @@ -274,6 +278,7 @@ struct mana_ib_qp {
>  	struct list_head recv_err_node;
>  	struct shadow_queue shadow_rq;
>  	struct shadow_queue shadow_sq;
> +	struct shadow_queue shadow_mmq;
>  
>  	refcount_t		refcount;
>  	struct completion	free;
> @@ -315,6 +320,7 @@ enum mana_ib_adapter_features {
>  	MANA_IB_FEATURE_DEV_COUNTERS_SUPPORT = BIT(5),
>  	MANA_IB_FEATURE_MULTI_PORTS_SUPPORT = BIT(6),
>  	MANA_IB_FEATURE_MSN_IN_WQE_SUPPORT = BIT(7),
> +	MANA_IB_FEATURE_EXTENDED_WQE_FORMAT = BIT(9),
>  	MANA_IB_FEATURE_RC_QP_SQ_POW2_SUPPORT = BIT(14),
>  	MANA_IB_FEATURE_MULTI_PORT_GSI_SUPPORT = BIT(15),
>  };
> diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana/qp.c
> index ae2ebbcc759a..387586c45aa0 100644
> --- a/drivers/infiniband/hw/mana/qp.c
> +++ b/drivers/infiniband/hw/mana/qp.c
> @@ -427,27 +427,88 @@ static u32 mana_ib_fixed_wqe_size(u32 sge, u32 oob_size)
>  	return roundup_pow_of_two(mana_ib_wqe_size(sge, oob_size));
>  }
>  
> -static u32 mana_ib_queue_size(struct ib_qp_init_attr *attr, u32 queue_type)
> +static u32 mana_ib_queue_size(struct mana_ib_dev *mdev, struct ib_qp_init_attr *attr,
> +			      u32 queue_type)
>  {
> -	u32 queue_size;
> +	u32 send_wr = max(attr->cap.max_send_wr, 1U);
> +	u32 recv_wr = max(attr->cap.max_recv_wr, 1U);
> +	u32 max_wqe_size = MAX_TX_WQE_SIZE;
> +	u32 wr, wqe_size, read_sge;
> +	u64 queue_size;
> +
> +	if (attr->cap.max_send_sge > MAX_TX_WQE_SIZE / sizeof(struct gdma_sge) ||
> +	    attr->cap.max_recv_sge > MAX_RX_WQE_SIZE / sizeof(struct gdma_sge))
> +		return 0;
>  
>  	switch (attr->qp_type) {
>  	case IB_QPT_UD:
>  	case IB_QPT_GSI:
> -		if (queue_type == MANA_UD_SEND_QUEUE)
> -			queue_size = attr->cap.max_send_wr *
> -				mana_ib_wqe_size(attr->cap.max_send_sge, INLINE_OOB_LARGE_SIZE);
> -		else
> -			queue_size = attr->cap.max_recv_wr *
> -				mana_ib_wqe_size(attr->cap.max_recv_sge, INLINE_OOB_SMALL_SIZE);
> +		if (queue_type == MANA_UD_SEND_QUEUE) {
> +			wr = send_wr;
> +			wqe_size = mana_ib_wqe_size(attr->cap.max_send_sge, INLINE_OOB_LARGE_SIZE);
> +		} else {
> +			wr = recv_wr;
> +			max_wqe_size = MAX_RX_WQE_SIZE;
> +			wqe_size = mana_ib_wqe_size(attr->cap.max_recv_sge, INLINE_OOB_SMALL_SIZE);
> +		}
> +		break;
> +	case IB_QPT_RC:
> +		switch (queue_type) {
> +		case MANA_RC_SEND_QUEUE_REQUESTER:
> +			wr = send_wr;
> +			wqe_size = mana_ib_fixed_wqe_size(attr->cap.max_send_sge,
> +							  INLINE_OOB_EXTRA_LARGE_SIZE);
> +			break;
> +		case MANA_RC_SEND_QUEUE_MMQ:
> +			wr = send_wr;
> +			wqe_size = mana_ib_wqe_size(1U, INLINE_OOB_EXTRA_LARGE_SIZE);
> +			break;
> +		case MANA_RC_SEND_QUEUE_RESPONDER:
> +			return MANA_PAGE_SIZE;
> +		case MANA_RC_RECV_QUEUE_REQUESTER:
> +			wr = send_wr;
> +			max_wqe_size = MAX_RX_WQE_SIZE;
> +			read_sge = min(attr->cap.max_send_sge, mdev->ib_dev.attrs.max_sge_rd);
> +			wqe_size = mana_ib_wqe_size(read_sge, INLINE_OOB_SMALL_SIZE);
> +			break;
> +		case MANA_RC_RECV_QUEUE_RESPONDER:
> +			wr = recv_wr;
> +			max_wqe_size = MAX_RX_WQE_SIZE;
> +			wqe_size = mana_ib_wqe_size(attr->cap.max_recv_sge, INLINE_OOB_SMALL_SIZE);
> +			break;
> +		default:
> +			return 0;
> +		}
>  		break;
>  	default:
>  		return 0;
>  	}
>  
> +	if (!wqe_size || wqe_size > max_wqe_size)
> +		return 0;
> +
> +	queue_size = (u64)wr * wqe_size;
> +	if (queue_size > U32_MAX / 2 + 1)
> +		return 0;
> +
>  	return MANA_PAGE_ALIGN(roundup_pow_of_two(queue_size));
>  }
>  
> +static int mana_ib_check_kernel_qp_sizes(struct mana_ib_dev *mdev,
> +					 struct ib_qp_init_attr *attr, u32 num_queues)
> +{
> +	u32 i;
> +
> +	for (i = 0; i < num_queues; i++) {
> +		if (!mana_ib_queue_size(mdev, attr, i)) {
> +			ibdev_dbg(&mdev->ib_dev, "Invalid kernel QP queue %u size\n", i);

If your code needs to validate in-kernel users, something is fundamentally wrong
with your design. We trust them.

Thanks
