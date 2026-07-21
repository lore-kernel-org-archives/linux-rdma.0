Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE4237CD59
	for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 11:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784632237; cv=none; b=o1OoabaMQ/OSLYPXxbDuRkyn0UtUihh9IGCyxfE4fT3W5mTxIXDNtkt9KC2IlWNVOgbnVIow4WvsvB1FldxQv3wYwNMMFpW1ND1fw2mH8spjA3AQiYcW/7iWMLmv0nbWmw4j6UIHmoe5DgHacCyLXeaYef42mUOIsT5q/sWxz/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784632237; c=relaxed/simple;
	bh=O+Ugy5zBF/WkSNp/Y70jb8NVlvnOSmIJryvVg1bezYY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fvuASebcHFO2pgSZh57grIyi9F+R7XsGuxdmIJmnAPg+E1jloW9moehD6ydICtuu9YbGvpoy7osmf67xCdcMSmVk6OgBzaJ32PrsWcD18gZfC7Xl/o8Xf39BYxuzuXE4PAJ/VB+9I9kVWL68HyDbhS8ClV+wgFm4v3tBFYBtEhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZyV5wklW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZyV5wklW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4AA1F000E9;
	Tue, 21 Jul 2026 11:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784632236;
	bh=oNFn2Umb8ZbmsnNitf/zc0jSl7qaEDy0swY4ergiYH0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZyV5wklWFKYx2gdvHZnkvZG795f5Svpw1tOCWKhUnYHK0ihjKaTPZ77E81w3lj4Jz
	 7o1qIf6C46jTQBHiJ5HNpwz7pltUyZUh2HIg65SI4bv5+791/3mbp8I1/PZJgolJYn
	 bVZoLu/jzfnF2lX2rkJpWDnVryrEZMrG7AyByt7s4thv549t1h3EH/+1H4C+40Q1Su
	 hU9uXS5eo4x7LlLCqNzzR/whoqTySqhlCAdjgTaXheD8GM8QSP1Zi6Ct8j8uxXybUd
	 en336GwAFp54xPledL3ueFxc01zIfQPb2CbVGFTFNkKGxs3mpJMnoOUCbDPRdaaU8d
	 A/AHOXGkIO9gw==
Date: Tue, 21 Jul 2026 14:10:30 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Timothy Day <timday@thelustrecollective.com>
Cc: Michael Margolin <mrgolin@amazon.com>, Jason Gunthorpe <jgg@nvidia.com>,
	linux-rdma@vger.kernel.org, Gal Pressman <gal.pressman@linux.dev>,
	Yossi Leybovich <sleybo@amazon.com>, Marco Elver <elver@google.com>
Subject: Re: [PATCH v1 0/5] Support Clang context analysis for RDMA/efa
Message-ID: <20260721111030.GH110966@unreal>
References: <20260717031658.477397-1-timday@thelustrecollective.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717031658.477397-1-timday@thelustrecollective.com>

On Thu, Jul 16, 2026 at 11:16:53PM -0400, Timothy Day wrote:
> Hi,
> 
> This series adds annotations for Clang's context analysis to the
> RDMA/efa driver.
> 
> Clang context analysis was recently added in a series by Marco
> Elver [1]. This allows the compiler to validate different
> locking patterns at compile time. This series enables context
> analysis and adds new annotations.
> 
> The series was built with Clang 23 (since the minimum Clang
> version for this feature was recently bumped to 23 in 7.2+ [2])
> with CONFIG_WARN_CONTEXT_ANALYSIS enabled. I based this series
> on rdma/for-next.
> 
> I'd appreciate reviews and suggestions. I'm especially interested
> in suggestions on how we can make this easier to enable in other
> parts of the rdma subsystem.

Yes, this is precisely why I'm not rushing to apply it. It would
be far more compelling to first apply this context analysis to
drivers/infiniband/core, so we can evaluate both its benefits and
drawbacks.

On the other hand, converting drivers incrementally is the safer
approach.

Thanks

> 
> Thanks!
> 
> [1] https://lore.kernel.org/lkml/20251219154418.3592607-1-elver@google.com/
> [2] https://lore.kernel.org/all/20260515124426.2227783-1-elver@google.com/
> 
> Timothy Day (5):
>   RDMA/efa: mark mmio_read seq_num as guarded by mmio_read lock
>   RDMA/efa: mark comp_ctx_pool* as guarded by comp_ctx_lock
>   RDMA/efa: mark admin CQ consumer state as guarded by the ACQ lock
>   RDMA/efa: mark admin SQ producer state as guarded by the ASQ lock
>   RDMA/efa: enable context analysis support for efa driver
> 
>  drivers/infiniband/hw/efa/Makefile  |  2 ++
>  drivers/infiniband/hw/efa/efa_com.c | 33 +++++++++++++++++------------
>  drivers/infiniband/hw/efa/efa_com.h | 14 ++++++------
>  3 files changed, 29 insertions(+), 20 deletions(-)
> 
> -- 
> 2.39.5
> 
