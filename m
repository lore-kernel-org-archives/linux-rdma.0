Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462073C76BB;
	Wed, 23 Sep 2026 08:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153278; cv=none; b=Ys+SLmrU80r5N5XNHxUqcFZ/sQ4v1qscRoTCXXdzcHyItf6b46SUZcq2JCkpE6IqNf4gDRGlQd0If4fvwDh/+BwEHn8ChyoBjddr55EQLFxLQTjON3osolJytRpoNgSRa4lgLZeByAc/4H7pzoyC3iIiGq2lsLsYIdtUKwGR2V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153278; c=relaxed/simple;
	bh=E6ngUR8yaYSFJtkuqufH1CdCHF25jtwtFAw9biubYl0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tioGLcQPgHbl3guMOmCErhztqpHNeeWpdSMpJpEuGEZ2ZhuhvoPc7e3B50GYLTgjVIRkMPNZq31zyLMmhunrngXtXTSr88oAZIMtqd1WouuhH58PcEC76EhqKvJKzfO+rT9aZJ4Z9rQRl2qJgp8d1HdvMlvHsU0n+CzdRfb0O2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m0wn8MfM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m0wn8MfM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06AE41F000FF;
	Wed, 23 Sep 2026 08:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790153275;
	bh=xaui1Yn1pNkB/nXVOEkdR+sUD99wJxLpBFDtsL2MDSg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=m0wn8MfMyFpXasMiG+weY3HX9RwsxY9ICdpZvTSdsAcjVs2yTSmfxwYMNeWxbEEjB
	 7cYc3WomzdwZIl3OU0eL/hg8hVqKVVK3Z2zdNbDUZXBkqSNOzbpsZ00DwS4utasRWY
	 GC+gUjfZT0Q0Z7BJoR+P+QIqOVLdjX45j6bwPo2kIxgFOVJDXEw6aD4jgJeLr9VpoP
	 u4yGgwddNMxEr/YOWEGcUSUnnWlDRoWKJ8YlhVHNy1iA1vTKaAsY1K8v26wja7jmZ/
	 oLWUMVT/iNoG9VbRZEtfTYyzpL1ufsot4XnIV7sIKNdLq7gR6UtFWALrZadRWi3CPX
	 qc1RARsvEhcjg==
Date: Wed, 23 Sep 2026 11:47:52 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: jgg@ziepe.ca, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
	rolandd@cisco.com, stable@vger.kernel.org
Subject: Re: [PATCH] RDMA/core: Fix member use-after-free in
 process_group_error()
Message-ID: <20260923084752.GN563127@unreal>
References: <20260916184555.2093238-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916184555.2093238-1-vulab@iscas.ac.cn>

On Wed, Sep 16, 2026 at 06:45:55PM +0000, Wentao Liang wrote:
> If the callback on the error path returns non-zero after a concurrent
> ib_sa_free_multicast() already dropped the initial member reference,
> dropping our temporary reference completes the waiter, which then frees
> the member before ib_sa_free_multicast() dereferences it again.
> 
> Only free the multicast member when our reference decrement was not
> the last one; otherwise the concurrent free is already in flight.

I'm not sure that last sentence is correct. Can you prove it?
Because we have the following code:
  662 void ib_sa_free_multicast(struct ib_sa_multicast *multicast)
  663 {
  ...
  685
  686         deref_member(member);
  687         wait_for_completion(&member->comp);
  ...
  691 EXPORT_SYMBOL(ib_sa_free_multicast);

Thanks

> 
> Fixes: faec2f7b96b5 ("IB/sa: Track multicast join/leave requests")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  drivers/infiniband/core/multicast.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/core/multicast.c b/drivers/infiniband/core/multicast.c
> index bea7df3dd8f3..aa6fdac5fcde 100644
> --- a/drivers/infiniband/core/multicast.c
> +++ b/drivers/infiniband/core/multicast.c
> @@ -409,8 +409,9 @@ static void process_group_error(struct mcast_group *group)
>  
>  		ret = member->multicast.callback(-ENETRESET,
>  						 &member->multicast);
> -		deref_member(member);
> -		if (ret)
> +		if (refcount_dec_and_test(&member->refcount))
> +			complete(&member->comp);
> +		else if (ret)
>  			ib_sa_free_multicast(&member->multicast);
>  		spin_lock_irq(&group->lock);
>  	}
> -- 
> 2.34.1
> 
