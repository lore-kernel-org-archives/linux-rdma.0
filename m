Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37D03FC5BE;
	Mon,  7 Sep 2026 06:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788762778; cv=none; b=tZnnUgBbnEIdR1G9aYQH86GqOg0dG/sucVKwi0nmsvNQ+WxU/dZggNgfI/bTTa3B+2hJ4BKhb4QCV0dk+m0qKTzO94E0tN4voHfbTScQ4WKhgx7TWFoA6ecOLAO4yABVtK4XDjOwUs8gMSKlcESibAMTcDz6paiop/TsovgLT3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788762778; c=relaxed/simple;
	bh=Kegs9nl8Sy8Ds1khtctJ0olgavOIAuru544FhE50yLE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YnChypdkJU+SKDOFIk3IkdRXzTLnI4KIMXgJw17NPvr9Zm81g9BAZx0E584YhHKjF1QGsBckN0LC0JzhBgs8h7vFUg9LeCK6PwDihZYMI+2aSQ8pP69HUMjHfFzmnRpLnA55TCGdrd3DZsteyZrVeVzNjceR1dTCqUWMQlFYkEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D3ZnVESu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D3ZnVESu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61E31F00A3E;
	Mon,  7 Sep 2026 06:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788762776;
	bh=9Xf5JQSoZTzzJA4G8NY2Ni7s6Wy1zSsh/0HJWACiKBQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=D3ZnVESunth9IzqpfSMqn8n3S43eYkTDkgiIj2QN0ffDMfUGEJBVlWddL5VjbB+7H
	 DLoVmQb1NQa4voXb+jRGSURwKMDl8rKs7IDBP7Qwc21wU8XzQCq8Bnj3pGNyBOCWpI
	 uQf1mrDtPAxeZuK1FNfEtpP1van3I1QCgs6t0uTwXgbWpDwDwjIgyeXMojEDTP5kuu
	 KNurZHmo99j0zOK71NN6jF5iacr4GY5Y4J2Ju9gTEBOYBRVSHT88KYUwYfcvj1eJlO
	 NSCN8M2pGzDEjudVIRfDNcnPALF+U1nATesyEn5KnmVeveqZXXkrPOOPhamcdDkp5E
	 ebsY6iSVX23LA==
Date: Mon, 7 Sep 2026 09:32:51 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Serhat Kumral <serhatkumral1@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Sagi Grimberg <sagi@grimberg.me>,
	linux-rdma@vger.kernel.org, target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] RDMA/srpt: Clamp the CQ size request to max_cqe
Message-ID: <20260907063251.GE13683@unreal>
References: <20260906161235.8563-1-serhatkumral1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260906161235.8563-1-serhatkumral1@gmail.com>

On Sun, Sep 06, 2026 at 07:12:35PM +0300, Serhat Kumral wrote:
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
> before asking for the CQ. With the clamp the same login proceeds exactly
> like a correctly sized target.
> 
> Fixes: c804af2c1d31 ("IB/srpt: use new shared CQ mechanism")
> Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
> ---
> Changes since v2:
> - Add a WARN_ON_ONCE().
> 
> Changes since v1:
> - Move the fix from the RDMA core to ib_srpt, as requested by Leon
>   Romanovsky.
> - Clamp sq_size before the CQ request instead of rejecting oversized
>   requests in ib_cq_pool_get().
> 
> v1: https://lore.kernel.org/linux-rdma/20260831171354.72140-1-serhatkumral1@gmail.com/
> v2: https://lore.kernel.org/linux-rdma/20260904200240.48976-1-serhatkumral1@gmail.com/
> 
>  drivers/infiniband/ulp/srpt/ib_srpt.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index 7197d95f2216..7ac526e3d2c2 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -1867,6 +1867,15 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
>  	if (!qp_init)
>  		goto out;
>  
> +	/* The send and receive queues share a single CQ. */
> +	if (ch->rq_size + sq_size > attrs->max_cqe) {
> +		/* Catch drivers that incorrectly set ch->rq_size */
> +		WARN_ON_ONCE(ch->rq_size > attrs->max_cqe);
> +		sq_size = attrs->max_cqe - ch->rq_size;
> +		pr_debug("reduced sq_size to %u because max_cqe is %u\n",
> +			 sq_size, attrs->max_cqe);
> +	}

All these Sashiko reports suggest that sq_size is being changed in the wrong
place. Can you check for the correct value in srpt_tpg_attrib_srp_sq_size_store()?

Bart, can we simply decrease MAX_SRPT_SRQ_SIZE by, say, 100?

Thanks

> +
>  retry:
>  	ch->cq = ib_cq_pool_get(sdev->device, ch->rq_size + sq_size, -1,
>  				 IB_POLL_WORKQUEUE);
> 
> base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
> -- 
> 2.53.0
> 
