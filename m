Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07793B7B93;
	Fri,  9 Oct 2026 17:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791565213; cv=none; b=f+oUVGmOvCieiN15liW46hjwrch1bvuwbZu13eTGsmVs2Izp3Q1fP7LtzyvyExc+Vfo13rZgXxfeTkNRAlCZwgf+Wb4xfvAMien70I9F3jvGXSG9ngTquYxqVUXLLxGlbQcUbA2qhsodTts5+hhrtOuqTnABnnP7eIe1xxlcn5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791565213; c=relaxed/simple;
	bh=f4hqEti0uqNvIlR4oCQlE7kLrMLq2qTdUcn75V2nhl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mFaYgdGAv9vvkkunZXVl4lieMt0umtTnJ7MXbTPsHO5iZwxP1lhe3rMjG0qmZszLAtR2B5vzXTmmf0QuaTuXTlR/2fPhO1Zv+/vJNBRzSubRkuaWlzPKRBLDFsuy5JqDQK5CE9jztsTMSqNlLhGVEHaVfDvQ/cjNeAxGjYiLmAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WhJitxze; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WhJitxze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89BF21F000FF;
	Fri,  9 Oct 2026 17:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791565208;
	bh=PoY3aqr6DG621pLXXsvlPveTjmtP6GG3qEUPuZfhjU4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WhJitxzey9fFvZssGdVh4OkxbcK556oIMxrOSJlkd+cuyE1a1yL+4hn1TD2yKSvMW
	 w81ayDZtb3I1ndEYxELbhe2BRdAPrZHe4UpCpW4ZtbK4bkhPYECiN6oGw+pZhCnXb2
	 r9zooJiczfnv33ZtP2Qu4rhoYFgjBxosZPA9kZijL6ekYf7BQ1r6r0HGPiN7DBrZeb
	 dusOP75IyE5DYdEb3lcVl9It/HS2k0cq50wPqlfKyWPXj4iPRkk1n6L0rIDkXuh1wv
	 qJOoHafPffUVYnApVyFHS3vCD0mo96TboHLsXlXXIO44Z8i6n/EP7z/lr2D41qaWM3
	 m/JtRc9gaRJBw==
Date: Fri, 9 Oct 2026 18:00:02 +0100
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
Subject: Re: [PATCH net-next 3/3] net/mlx5e: use skb_share_check() in the
 loopback selftest hook
Message-ID: <20261009170002.GK83879@horms.kernel.org>
References: <20261007-nb-net-selftest-shared-net-v1-0-458369bfa1ba@tipi-net.de>
 <20261007-nb-net-selftest-shared-net-v1-3-458369bfa1ba@tipi-net.de>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007-nb-net-selftest-shared-net-v1-3-458369bfa1ba@tipi-net.de>

On Wed, Oct 07, 2026 at 08:29:24PM +0200, Nicolai Buchwitz wrote:
> The loopback hook gets a shared skb when another ETH_P_IP handler is
> bound to the device. skb_linearize() on a non-linear frame then hits
> BUG_ON(skb_shared()).
> 
> Call skb_share_check() before linearizing the skb.
> 
> Fixes: 95b9606b15bb ("net/mlx5: Extend Ethtool loopback selftest to support non-linear SKB")
> Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>

Reviewed-by: Simon Horman <horms@kernel.org>

