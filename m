Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245E130CD95;
	Mon, 15 Jun 2026 12:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781526306; cv=none; b=jUH+jvflmVUaMHImE7a+B57bl7kqMSxGvHVDDASewWJnEjQa9Eb9WqhtH9naxI7+sFRWOKwOVi2hzhEOIGxdjzTbrRsdTNAo9gA59iLmCTtZiC/9+CL0HbOC5Rnwrv7dXbNodrra89gKPiUjeQgclqTdjqyRFbAMghnvQRdBmv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781526306; c=relaxed/simple;
	bh=BhZyPrFHfFCI2uYZ/ZfVpNsFdCKYdFUVl/LN8PH88L4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SDy9GwMD7SUvhYJ9hNiecYoM73Byqy8fTqwRdFQTkhymz6u3Gh1lpG7T+zPQVV/x7LkBWN7wHP7rDigAH2VueyiwCioksLqFYDOqPGjLnFZxS3v94nyyC12ku6wURflvN4FjAueA1J/PMfo7iap+MEjDqOs5a8F6egcuLeZFqno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jOQb8l0x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jOQb8l0x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5299F1F000E9;
	Mon, 15 Jun 2026 12:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781526304;
	bh=R6hOtI8UaFHkE4M5u8Uc+3LIthWmoAE3HwYQQathdZ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jOQb8l0xPCSazAlerFYQKsTGaWyXCmPqTBPLJrNrr7ErbkqBVEkFzz+FXglBT+yRf
	 SbHysIbxQjpVXpRloLEhDCCElGra4MPLSvhSg2df2sdH9Y6+1bBvPYFKLHmfOqjjpH
	 TbJ6YS3Z8O+2AzWp6SkaUq52aYF+icvxGNhp78RwKNPuS2sZw7Siee0cOV5HqQQqNl
	 a7Wn9WBD0+2yzObScKCI22YUEmIF+y7Z5fEtzpznIufHET5aDpjBkehqvGlO92Z5sB
	 7KL+SWvbyClwPKclG4llyt9r2KdD1KQFSx9YyYo+67aC7x53+DvbPgzpt1ef6djkqW
	 5oZcdVMtjy5+g==
Date: Mon, 15 Jun 2026 13:25:00 +0100
From: Simon Horman <horms@kernel.org>
To: lirongqing <lirongqing@baidu.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx5: Fix L3 tunnel entropy refcount leak
Message-ID: <20260615122500.GI712698@horms.kernel.org>
References: <20260613153631.1752-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260613153631.1752-1-lirongqing@baidu.com>

On Sat, Jun 13, 2026 at 11:36:31PM +0800, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> mlx5_tun_entropy_refcount_inc() counts both VXLAN and L2-to-L3
> tunnel reformat entries as entropy-enabling users. The matching
> decrement path only handled VXLAN, leaving L2-to-L3 tunnel entries
> counted after release.
> 
> Handle MLX5_REFORMAT_TYPE_L2_TO_L3_TUNNEL in
> mlx5_tun_entropy_refcount_dec() as well so the enabling entry
> refcount remains balanced.
> 
> Fixes: f828ca6a2fb6 ("net/mlx5e: Add support for hw encapsulation of MPLS over UDP")
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Reviewed-by: Simon Horman <horms@kernel.org>

