Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8DCB3B19BC;
	Mon, 12 Oct 2026 14:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791814651; cv=none; b=esz7yj2A+CZ855LhvbRkrDXsHUxypzSRnS1uCRZzY8n88B8K2ygqYzJcXtVtIYkK2LF9XDQMVzbQS9SyBa88dNqg7hpRdomHpw/mNiy2TXhgCdKJI6DRkkNIA1HTohXM6QbTLQNESj/46HndE+nv86AELS3kNosJxIgx9GkuaRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791814651; c=relaxed/simple;
	bh=7m5n5S0R1yZ76Y6AazBL7Sa3dat7H1ozsiIUrKKWor8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SP3Rsb4j8ca7mErSe2glLd2mLYkdRbsGqxfNra4zMgjGzL7IYxnubl9yAB+5c7ar+XEVrHbFur5W9/EVelsmwERUPlMI+IcIYXfWbU6bV9um4Pln+sXBsFV28QNnl+FzgqadDJjHOEj1qe4/ISplmLYznThaqjfnon0XAzQqXX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LtCgyRv7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LtCgyRv7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96421F0089B;
	Mon, 12 Oct 2026 14:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791814650;
	bh=HAiZUBdrrUscwhb3gzthwXDybrlX1wtePnwMjEx7wY0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LtCgyRv7kNjP5BO129ZDG+yn8i4/73npyD6f62yM9EU5h3/NtEsaH65Fg/wB2R+Kg
	 t/rPma6fgfaALnX07qm7+qDb34HBXLz+RmvK+saIvCw2ev2pBeDksKCEPCYyX5xuJK
	 +LiByY/7hjALz8Z5wYXz4RlcVeOkXAKPFGjwPB+FxaruMHeVh1N9Ynx68O73mlFmoq
	 zLp60kIsZTxXnt9Vvrcya+1tBL5q62mQ31BzfT5XCQ6J/k5fTn+Fp2E9ZDfYh4mEaD
	 voVIEx/NrXsHxzGE/xIFG5NHK2zxgluENpNNktS3CtQa/SEwe2IMqoPx6LQHEtgHnV
	 nWf2YNrfNtNUg==
Date: Mon, 12 Oct 2026 17:17:25 +0300
From: Leon Romanovsky <leon@kernel.org>
To: David Hu <dhu@x6u.co>
Cc: Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, jmoroni@google.com,
	eagleshaw@google.com, David Hu <xuehaohu@google.com>
Subject: Re: [PATCH rdma-next 4/5] RDMA/irdma: Support UMEM attribute for CQ
 creation
Message-ID: <20261012141725.GG219304@unreal>
References: <20261011011022.1445352-1-dhu@x6u.co>
 <20261011011022.1445352-5-dhu@x6u.co>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261011011022.1445352-5-dhu@x6u.co>

On Sun, Oct 11, 2026 at 01:10:21AM +0000, David Hu wrote:
> From: David Hu <xuehaohu@google.com>
> 
> Support the standard 1-step queue buffer creation
> model for CQ by `UVERBS_ATTR_CREATE_CQ_BUF_UMEM`,
> `IRDMA_IB_ATTR_CREATE_CQ_SHADOW_BUF_UMEM` via
> `ib_umem_get_attr()`.
> 
> Set up hardware pble directly from the pinned CQ and
> shadow umems via `irdma_setup_q_pbl_from_umem()`.
> 
> Proper umem and pble cleanup are added into existing
> `irdma_cq_free_rsrc()` upon CQ destruction.
> 
> We maintain backward compatibility for
> legacy 2-step registration if UMEM attributes are
> not provided.
> 
> Signed-off-by: David Hu <xuehaohu@google.com>
> ---
>  drivers/infiniband/hw/irdma/verbs.c | 110 +++++++++++++++++++++++-----
>  1 file changed, 93 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
> index ab25445f3828..e4a02a6b2a11 100644
> --- a/drivers/infiniband/hw/irdma/verbs.c
> +++ b/drivers/infiniband/hw/irdma/verbs.c
> @@ -2028,13 +2028,24 @@ static void irdma_cq_free_rsrc(struct irdma_pci_f *rf, struct irdma_cq *iwcq)
>  		if (iwcq->iwpbl) {
>  			iwmr = iwcq->iwpbl->iwmr;
>  
> -			refcount_dec(&iwmr->user_ring_refs);
> +			if (iwmr && refcount_dec_and_test(&iwmr->user_ring_refs)) {
> +				ib_umem_release(iwmr->region);
> +				if (iwcq->iwpbl->pbl_allocated)
> +					irdma_free_pble(rf->pble_rsrc, &iwcq->iwpbl->pble_alloc);
> +				kfree(iwmr);
> +			}
>  		}
>  
>  		if (iwcq->iwpbl_shadow) {
>  			iwmr = iwcq->iwpbl_shadow->iwmr;
>  
> -			refcount_dec(&iwmr->user_ring_refs);
> +			if (iwmr && refcount_dec_and_test(&iwmr->user_ring_refs)) {
> +				ib_umem_release(iwmr->region);
> +				if (iwcq->iwpbl_shadow->pbl_allocated)
> +					irdma_free_pble(rf->pble_rsrc,
> +							&iwcq->iwpbl_shadow->pble_alloc);
> +				kfree(iwmr);
> +			}
>  		}
>  	}
>  
> @@ -2708,29 +2719,94 @@ static int irdma_create_cq(struct ib_cq *ibcq,
>  		if (err_code)
>  			goto cq_free_rsrc;
>  
> -		spin_lock_irqsave(&ucontext->cq_reg_mem_list_lock, flags);
> -		iwcq->iwpbl = irdma_get_pbl((unsigned long)req.user_cq_buf,
> -					    &ucontext->cq_reg_mem_list);
> -		spin_unlock_irqrestore(&ucontext->cq_reg_mem_list_lock, flags);
> -		if (!iwcq->iwpbl) {
> -			err_code = -EPROTO;
> -			goto cq_free_rsrc;
> -		}
> +		if (attrs && uverbs_attr_is_valid(attrs, UVERBS_ATTR_CREATE_CQ_BUF_UMEM)) {

While making this change, it’s a good opportunity to split
irdma_create_cq() into kernel and user paths.

Also, please keep commit-message lines around 75–80 characters. There’s no
need to wrap them at 50 characters.

Thanks
