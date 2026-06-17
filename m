Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F575407CC8
	for <linux-rdma@vger.kernel.org>; Wed, 17 Jun 2026 13:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781703276; cv=none; b=H8D9VGQxj2UzmNCI5bjYJGGpGrzf2wBR0fFPkMTI3FKYdVA0odKTJuJ86krBbdQu8AbKNn69COwa90zDubNGgQ28ZggIfb1IFFIJ6vzgySCskyhd1EThpIlj/xtvwbXmnvBvPv2x4cN/jmd3NfwjjAvckRdPHI/a6DdcJr8RNrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781703276; c=relaxed/simple;
	bh=4ymlhHB/SuWo+Hlll0cXhF2ouOVQETxm+yCrJv9/utc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s0L7OzGfuk8O8LPA0mEmdEWiAoIMz6u5DpIdjWVNayO3sRg4RJkLhC5Q5uJiCepUz/+ARWC8Lg50owO3OL/m8VnI5I/QXcm5ZOeflQ5YoQ0gYwkSW2FMcj7tAJPnm7k7ZSc2XDdCixvhbn05NWWX3Vm363+5gHFfrsbh0Uaqi5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e0CCv8GK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e0CCv8GK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 213171F000E9;
	Wed, 17 Jun 2026 13:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781703274;
	bh=qYXP8Oz5zX1Gw1/QdJizBexO2nNNt3BOfsxcF2+/R0g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=e0CCv8GKpghIhsKDnwpA+sBPnB3CT1E4B6J7pPE6E8ORYoQKHm93X+P8TIxs6Soih
	 /Hs4RouansCxB4WYInGv+H6Pi6OLDDoYZ7zC3bGU7jMbEgQ3DV/sRXpfvOyl0dG4cE
	 MliZxyizTP8yuLmcp8TAzVx6IMeQVhggoHShwLiCJr7JgdAnVkJqct6LAH2Agnc6i3
	 0tWEbbxuGhfuPEab5iG9oLvf6eitZDBLjRi70iXGsriaFXFOaur/AMJ+VeHmGyRQwc
	 fqwYBQ8hYcDEkls5DrFSWGA/5I5D0NxDjCxbHQA9N9Rvy7JVilIeJKHoXEeeEGGMgX
	 YP+afzH4BffYg==
Date: Wed, 17 Jun 2026 16:34:29 +0300
From: Leon Romanovsky <leon@kernel.org>
To: ogerlitz@ddn.com
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Mark Zhang <markzhang@nvidia.com>,
	Patrisious Haddad <phaddad@nvidia.com>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH] RDMA/cma: Fix hardware address comparison length in
 netevent callback
Message-ID: <20260617133429.GA327369@unreal>
References: <20260617-fix-cma-ipoib-v1-1-03f869344304@ddn.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260617-fix-cma-ipoib-v1-1-03f869344304@ddn.com>

On Wed, Jun 17, 2026 at 02:21:05PM +0300, Or Gerlitz via B4 Relay wrote:
> From: Or Gerlitz <ogerlitz@ddn.com>
> 
> The cited commit hardcoded the hardware address comparison len to ETH_ALEN.
> 
> This breaks IPoIB, which uses 20-byte addresses. By truncating the
> memcmp, the CMA may incorrectly assume the target address is
> unchanged and fails to abort the stalled connection.
> 
> Fix this by replacing ETH_ALEN with the dynamic neigh->dev->addr_len
> to correctly evaluate the full address regardless of the link layer.
> 
> Fixes: 925d046e7e52 ("RDMA/core: Add a netevent notifier to cma")
> Signed-off-by: Or Gerlitz <ogerlitz@ddn.com>
> ---
> I caught this while reviewing the RoCE netevent callback, 
> the patch is compile-tested only..
> ---
>  drivers/infiniband/core/cma.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Looks correct to me.

Thanks,
Reviewed-by: Leon Romanovsky <leon@kernel.org>
