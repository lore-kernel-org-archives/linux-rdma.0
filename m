Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A181A2C04;
	Sun,  6 Sep 2026 09:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788687038; cv=none; b=tLsodyt/Ob+zNxCZLvZHGJpZw/YJvZGyhERh7enM3t0+y24v0YmZvOhDAJVu9+t/eyyYRqAAGqOS/u0aJQlnSKv/0+jt0IAu8z6ZakqMHJ3YFVCQLRWVgK08EVqb2S73B3Kw4hYqk80/t/S50m6SlQPo5OPajwrxYAXktqgzoVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788687038; c=relaxed/simple;
	bh=1aH/O/nXGmguu/sbyzKfjo4n+RaPBUSNb01FLutqxDY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jKAtdq3PKVkvQT7MEwuXg9k9ew1trS9c66Gyhk0ZLOAVeu2bjqghMo0AJlYkMFhC/TNKWKtvwtM3n3WtCFVy4FFsPnW3lfhqAx3SQ61pMQW7DHjMc69haCJBFGRIXG8DRQPHyEzKQPLW1Owx25E5VYL4WqVMOeOm++703De/HdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WCYjFxcZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WCYjFxcZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EBC51F00A3A;
	Sun,  6 Sep 2026 09:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788687037;
	bh=Nx2JQF+OxPCsyKg0a0cwCiG38AC7FzKH63fy02rceHk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WCYjFxcZZC8ovxw2hzzEqPqdVHKVt7/yMDVT5q/x3O4BwX59w/9CeVpqQWBX4y4L6
	 rO9BM8FVs6FjesgtnpFYRGz+a/LXFzlXMuZb0ePHijEmqpPrAVjThC6G3eo6J4tOk2
	 FfQO87tlKwXgye1oNhIfEQ9W/mEpFH0XNscMJ19mHogxNkztlJI5SMelpOp1OV4oif
	 E8dbbuIeaA8wMQF0HReFH/xqG06fCiwAE0wsYQAJD0Qjaa5Zrw2UWi3vFO6zb4itgl
	 SoxazbzlxSafW87vru+RvTPn+b8cOcta5uJ4Pt9UDvhi4TWirT727k70eoBGbRoEIA
	 Lg8W8CUJi9rjQ==
Date: Sun, 6 Sep 2026 12:30:30 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Serhat Kumral <serhatkumral1@gmail.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Sagi Grimberg <sagi@grimberg.me>, linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] RDMA/srpt: Clamp the CQ size request to max_cqe
Message-ID: <20260906093030.GD13683@unreal>
References: <20260904200240.48976-1-serhatkumral1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904200240.48976-1-serhatkumral1@gmail.com>

On Fri, Sep 04, 2026 at 11:02:40PM +0300, Serhat Kumral wrote:
> srpt_create_ch_ib() asks ib_cq_pool_get() for ch->rq_size + sq_size
> completion queue entries. rq_size is bounded by max_qp_wr, but sq_size
> comes from the per-port srp_sq_size configfs attribute, which is only
> validated against MAX_SRPT_SRQ_SIZE (65535) and never compared with
> dev->attrs.max_cqe. The largest configuration srpt accepts therefore
> asks for 128 + 65535 = 65663 entries, while rxe caps max_cqe at 32767
> and cxgb4 and ionic are in the same range.
> 
> Such a request cannot be met, and ib_cq_pool_get() does not reject it.
> It clamps every CQ it creates to max_cqe, so no CQ it adds to the pool
> can ever fit the request, and it keeps allocating batches until the
> allocation fails. A single SRP login against such a target exhausts
> memory:
> 
>   Out of memory and no killable processes...
>   Kernel panic - not syncing: System is deadlocked on memory
>   Workqueue: ib_cm cm_work_handler
>   Call Trace:
>    __vmalloc_node_range_noprof
>    vmalloc_user_noprof
>    rxe_queue_init
>    rxe_cq_from_init
>    rxe_create_cq
>    __ib_alloc_cq
>    ib_cq_pool_get
>    srpt_cm_req_recv.cold
> 
> Before commit c804af2c1d31 ("IB/srpt: use new shared CQ mechanism") the
> same request went to ib_alloc_cq_any(), which rejected it with -EINVAL.
> 
> The existing backoff, which halves sq_size when queue pair creation
> fails, only runs after ib_cq_pool_get() has returned, so shrink sq_size
> before asking for the CQ. rq_size never exceeds MAX_SRPT_RQ_SIZE (128),
> far below the max_cqe any device reports in practice, so the
> subtraction does not underflow. With the clamp the same login proceeds
> exactly like a correctly sized target.
> 
> Fixes: c804af2c1d31 ("IB/srpt: use new shared CQ mechanism")
> Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
> ---
> Changes since v1:
> - Move the fix from the RDMA core to ib_srpt, as requested by Leon
>   Romanovsky.
> - Clamp sq_size before the CQ request instead of rejecting oversized
>   requests in ib_cq_pool_get().
> 
> v1: https://lore.kernel.org/linux-rdma/20260831171354.72140-1-serhatkumral1@gmail.com/
> 
>  drivers/infiniband/ulp/srpt/ib_srpt.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index 7197d95f2216..58064a4c606b 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -1867,6 +1867,13 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
>  	if (!qp_init)
>  		goto out;
>  
> +	/* The send and receive queues share a single CQ. */
> +	if (ch->rq_size + sq_size > attrs->max_cqe) {
> +		sq_size = attrs->max_cqe - ch->rq_size;

I don't think that Sashiko concern is real
https://sashiko.dev/#/patchset/20260904200240.48976-1-serhatkumral1@gmail.com
but it is worth to write it in a way to avoid triggering this warning.

For example
/* Catch drivers that incorrectly set ch->rq_size */
WARN_ON_ONCE(attrs->max_cqe < ch->rq_size)

Thanks

> +		pr_debug("reduced sq_size to %u because max_cqe is %u\n",
> +			 sq_size, attrs->max_cqe);
> +	}
> +
>  retry:
>  	ch->cq = ib_cq_pool_get(sdev->device, ch->rq_size + sq_size, -1,
>  				 IB_POLL_WORKQUEUE);
> 
> base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
> -- 
> 2.53.0
> 
