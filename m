Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2FF33CA497
	for <linux-rdma@vger.kernel.org>; Wed,  8 Jul 2026 19:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783539182; cv=none; b=WA0AQbkIOF9sDDNqDRpFpqS9WFNhDeDwnfms5t/BP72FhGlgysKtIVJSvEXbXUP6oVvk1d6p0fQHRlraoVLr4QQOKmyqhSPAg6b3kD1Fa2fZtsTmGX5f1LA/4NAdU8ydrUU6Ja67ye6GXv5pYbldLKPlkrNxdSKZaMkeYBLuLdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783539182; c=relaxed/simple;
	bh=IOS5GN2pONlWzmwhsKZA8OXhk6yaaGtWlzaGSCHwBxk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XZpbEfAPfTzN4rBx6+Dxuki9UOj/0kUcC2e3X87jXgDhPmgxcMKR21ASJhCDEJhbAQHdoYact5tircksxnPeFaQBEsEcHfIiV2zfD1+xih8BAacqDEwJHu+0hi0wXzUTM7/YnXJZOIPU7BIVzKV2KDYpTsDL+8MDTfgKfZEFOuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eMpN2EiY; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eMpN2EiY"
Date: Wed, 8 Jul 2026 19:32:16 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783539177;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ALUaD454sMRQMP0Da2KjIGTgJMad7ivkipowHf/Yitk=;
	b=eMpN2EiYDIOFvvgoXG+7C/O0zYni/j0H+Qt6Qu9dHkFNb0sWGh+6wiBgBeb4mP1Fsk1x0i
	CSLdG9ZWkRhTa4vtz8Pn3TSUEiBRXZRn54KRAgwZ+3ZKYe+g5vlcPu3VanyfwyGz0kLqOJ
	YW6PoKpkeQNGRX+jUWJEs8BA5h2UHxY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, 
	Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>, 
	Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Ben Cressey <ben@cressey.dev>
Subject: Re: [PATCH net-next] net/mlx5e: bound TX CQ poll softirq residency
 with a time budget
Message-ID: <ak6efg89Cb1s_TEd@linux.dev>
References: <20260703-mlx5e-tx-cq-time-budget-v1-1-6da2cfe9c7b1@linux.dev>
 <5557a08f-6d53-4425-8004-b7f0bbcd8a50@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5557a08f-6d53-4425-8004-b7f0bbcd8a50@nvidia.com>
X-Migadu-Flow: FLOW_OUT

Hi Dragos,

Thanks for the review.

On Mon, Jul 06, 2026 at 01:48:41PM +0200, Dragos Tatulea wrote:
> This is interesting. I can think of 2 cases here which can overlap:
>
> 1) Packets are sent with xmit_more which trigger this many WQEs per
>   CQE scenario.
>
> 2) TSO packets can have many fragments so even a single WQE will have
>    more than one DMA unmap. For the default GSO size of 64K each TSO
>    skb will have 2 fragments on your platform. If the GSO is bumped to
>    256K then you usually get ~5 fragments.
>
> Let's first understand if this is a case of 1) (small packets sent
> with xmit_more) or 2) (many TSO packets) or 1+2) (many TSO packets sent
> with xmit_more).

Likely both, mostly 1). The workload is bursty bulk transfers, and
the stalls hit while processing a burst's completions: one CQE covers
a whole xmit_more batch, each TSO skb adds its 2 frag unmaps, so the
CQE budget bounds entries but not the unmap work behind them.

I don't have the tx_xmit_more / tx_tso_packets ratios handy. I'll
collect them across a burst window and report back.

> If xmit_more is used then you can actually tune the BQL to avoid this
> behavior which seems to wreak havoc on your configuration.

We considered that. BQL bounds bytes in flight, but bytes only
translate into poll time at some assumed per-unmap cost, and that
cost is the unstable part here: a few us normally, ~100x worse when
many CPUs contend on the shared SMMU command queue. A BQL setting
small enough for the worst case would hurt throughput the rest of
the time.

> The bounded poll is faster because it is interrupted earlier or is
> it faster because it results in less contention on the IOMMU?

Both, and we tried to separate them. Sweeping the yield cadence
barely moves the numbers, so it is not just doing less per poll. And
in A/B runs with the budget armed, the competing side's per-unmap
cost drops 15-20%, so there is a real contention reduction on top of
the transmit path getting the core back sooner.

> This change is too invasive in the driver for all the other cases. We have to figure
> another way to go about this issue.

Fair enough, and the module parameter should not have been there anyway.
The direction I would rather take: fix the cost instead of capping it,
by converting the mlx5e TX path to the tso_dma_map helpers (as bnxt
did), so a TSO skb maps as one IOVA range where the DMA IOVA API is
available, completing with one sync instead of one per frag.

Once the counters confirm the frag-unmap volume I will prototype that,
unless you or Tariq/Saeed see a problem with the direction. Happy to
test on the affected boxes. We have a repro harness.

Thanks,
Jose
