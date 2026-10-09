Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE323ACA79;
	Fri,  9 Oct 2026 16:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791565178; cv=none; b=gRqM8Ier99TMIMQVRPiuWyYCbCyrx12+B2fmxLSTmDDy2BENVt18+mlIgZGZdM1pPeRpZC2g9TQfiouZt164Mf+4XDlKr2jJ62oaS9dK5/7oFL26UyUPWefolYonh/+KRsoGtX7jCQGBYxREH2LJUnKdu4Kws+dU34Z6pHP9wpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791565178; c=relaxed/simple;
	bh=ucvLx/kp/9SVY/uyqj/BETSHW3DUzVkzfDMECsWwU0A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WFrt79FuMGW/3JpKUr4+gXDHTOR2ozDLgkvAPD1XSHYGDsfyK+P2i4h7X5j55G42zyaWyZdrdJIby/DRe+dFdJ2ZdJLFb9Cu0M+zpyPEp/WvGAR3a7biM93p/36vcd28kJv/Cp0XDCbZuYO7qILuMr/mc1VWc3FxCxVBnoIjJv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KvESlhRh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KvESlhRh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73EDA1F000FF;
	Fri,  9 Oct 2026 16:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791565176;
	bh=I2u5RYrLi5Vo1HxinX/08L+8VcsTjPu5sczVSHgh/yQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KvESlhRhXMB5RiySjeMmv2OIoc8Gdi7xij7cwSN+xkUh1YZXYI4t1SSwGRERnhIHK
	 a2w0Y7RWh1XH8pGXI0HX8wGG9I1PEDnrbhhANmRg2VYIfurkM2ecrahSvL5OX0Uu55
	 aahX3lJERxdLwRpZyHBPjSp2QVkbZbW9KY5hV1pQIQklnSqBXQ0ZTUAdGlwxxwZe4O
	 9KQfFPafjPSS4CXVJNsZezhFqZ8IG7YrUvm1zbssjNXD6uv6s4lYBFTORj+nTbEOaM
	 RBoqa46+1lALyGhrBKu5ddwzH/U5yEy5yliXcEeLdPr2CkCzUzRYhg0xtvFRAFCX/b
	 BglZe/PJJa9Kg==
Date: Fri, 9 Oct 2026 17:59:30 +0100
From: Simon Horman <horms@kernel.org>
To: Nicolai Buchwitz <nb@tipi-net.de>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <Jose.Abreu@synopsys.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Alexei Lazar <alazar@nvidia.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] net: selftests: use skb_share_check() in
 the loopback receive hook
Message-ID: <20261009165930.GI83879@horms.kernel.org>
References: <20261007-nb-net-selftest-shared-net-v1-0-458369bfa1ba@tipi-net.de>
 <20261007-nb-net-selftest-shared-net-v1-1-458369bfa1ba@tipi-net.de>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007-nb-net-selftest-shared-net-v1-1-458369bfa1ba@tipi-net.de>

On Wed, Oct 07, 2026 at 08:29:22PM +0200, Nicolai Buchwitz wrote:
> The loopback hook gets a shared skb when another ETH_P_IP handler is
> bound to the device. skb_unshare() does not unshare it, so
> skb_linearize() on a non-linear frame hits BUG_ON(skb_shared()).
> 
> Use skb_share_check() instead.
> 
> Fixes: 3e1e58d64c3d ("net: add generic selftest support")
> Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>

Reviewed-by: Simon Horman <horms@kernel.org>

