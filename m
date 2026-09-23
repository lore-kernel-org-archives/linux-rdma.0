Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3407C449B22
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 12:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790167552; cv=none; b=l+0W9StnnWKWb0SkXUxwHHhC/H/cwWvvJJz3xutamt+NxdiKMt8KLExRclmvzO86yOgvC6Ql0P2cu8BV/AgEsQZK6G9KWx4jg39m/A0zUHWcstIKoSIZwndPZg4g5dGHM7MXzz8mfrnOFNRcMNZj23a1CiU8tf02pdQO+59L9HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790167552; c=relaxed/simple;
	bh=xjaj/c/ldM2AxMHfoufeZyWSKcnJLNt8mHSInxS1bJs=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=caAOTUMZ4WENqG79iJ/Cxf828CUiq5R7ehH5b9pCDql1QMqWG7MkSHHlHnsgj0EzIgo25+flnsBLhL+4NmGtpc2mn8/v/5vEWvnzvoEVSuA4XCI7reBUaL/bETBWY2UK06jTI620zJteWtSOTuH0TB76iSwYSOk433iJb7xHEgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QaLYg+2D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QaLYg+2D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA111F000FF;
	Wed, 23 Sep 2026 12:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790167551;
	bh=GZcThNdlxhOC1CmZImYXtlTbz7q5hdl7W/Ssr9bsq1s=;
	h=Date:From:To:Subject:References:In-Reply-To;
	b=QaLYg+2DhOg5WsyVpDAq58UGtTU2V+5jf/Ww0rQSkm2vXe8NF53Sa0CtovUSIispa
	 yjHR3LQ7HyppgLUiRLrAo70LizUBhrrp63JxO/TZpYx7K0eTxgk6UreafOPolf7VZL
	 g9hYNN2bfiVyUXOEx4yoMbT9wuvOtbm4YYaecevuyQdfPxS90MrS6tshSc39GY0K4T
	 f6Y4p+NMH3u9yvUSCGK/fMPTnuzoHvyoT3SNBGM/2vfOD6zmK1XNGEEfQGOzKk6fYt
	 YgJPlswhvQ5P9of7a5O8rFUKPy9wt9PZWz/GbFcKlQietjx+U5nb+HciWC2wXAUGt4
	 0g7RM9l9vLwgg==
Date: Wed, 23 Sep 2026 15:45:47 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Zhu Yanjun <yanjun.zhu@linux.dev>,
	linux-rdma@vger.kernel.org, lirongqing <lirongqing@baidu.com>
Subject: Re: [PATCH] RDMA/mlx5: Restore flow_attr-first layout in leftovers
 flow rules
Message-ID: <20260923124547.GR563127@unreal>
References: <20260917111722.1723-1-lirongqing@baidu.com>
 <179016730862.3410790.15823629589301922889.b4-ty@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179016730862.3410790.15823629589301922889.b4-ty@kernel.org>

On Wed, Sep 23, 2026 at 08:41:48AM -0400, Leon Romanovsky wrote:
> 
> On Thu, 17 Sep 2026 19:17:22 +0800, lirongqing wrote:
> > Commit e91fb8b9d0ed ("RDMA/mlx5: Avoid flexible array warning") split
> > the leftovers_specs[] array into two separate structs to silence the
> > "array of flexible structures" sparse warning, but in doing so
> > reversed the member order: eth_flow was placed before flow_attr.
> > 
> > _create_flow_rule() locates the flow specs with:
> > 
> > [...]
> 
> Applied, thanks!

I dropped it, as it causes to flex array errors to return.

Thanks

> 
> [1/1] RDMA/mlx5: Restore flow_attr-first layout in leftovers flow rules
>       https://git.kernel.org/rdma/rdma/c/c1212a3c7ccd46
> 
> Best regards,
> -- 
> Leon Romanovsky <leon@kernel.org>
> 
> 
