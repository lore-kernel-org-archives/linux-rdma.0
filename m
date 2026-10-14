Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAC33EF643;
	Wed, 14 Oct 2026 20:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792008381; cv=none; b=Ec4DRHL05ar3Uo3qavMdw3gEd+WqJX/s97g32GZDz5ylj8ZBc3zjXcnVey+SA4iAyeFPuB8tfZkFSIBbvMNuKc2cegFTo2dkQS1ZIUzbEcRsvPTOHJgemBXOD/tkLxBXnwnXgDvzEwU9bh2geNGKGp+0gk/uh1hiQF0ZoPHGKDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792008381; c=relaxed/simple;
	bh=STt+qlQ21qsLZEFC4WMmETmXxDWpEPitn6cC3OXRWKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JIboj/ImHD4OcIiKeSNfJyU/P8hGMBBJyHVhbBSSY4VNpqus93Ou7b00f2PzZDgxhhF/8Ba24HBHypSVmF0gS2zlKCp2CjlM+sSU97Jdjqq/mTyOvOea2cQvBNQQCefahCIEJW52ZEEiq1tkOGDsComLF2UcmwF5zy6ioxtYqIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UimVmlXi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UimVmlXi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23E51F000C4;
	Wed, 14 Oct 2026 20:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792008380;
	bh=J74yMVdROHOSqDpQt8vzdEHyhc79HiSag/0ZDT/dVDY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=UimVmlXi6yp/94y2kx8+9uB1XS4sKw3as8nM/huU5VvzIfpO6YQj+6B/3woC3x+bo
	 Ia83E6ptRq9nK09Ko/BAX3FEKoa/QyxBRSogLPpNKX4yY8Iipqh/+raj6DPo//etlG
	 nZlFs+4m7TVIRKP9ik9L32WGXvL/2eEPpx5Vsh1vRl5ONRXe7vuWNsVS2BvDA4L9JV
	 xBYyx5X3Y8PBKWfhiJAvBwHNjNsElFDqKrGJnx1tvNrIzlEAFunLD5ackAoLgTholU
	 8dFVU+1xGaRBSeyt+lV4BN1u2oUpiLZ4LnzQaopEz8AORu2Snv5R9sS/CWhwgIXomt
	 CMX1cbJ/FGrHA==
Date: Wed, 14 Oct 2026 13:06:18 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Nicolai Buchwitz <nb@tipi-net.de>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
 <horms@kernel.org>, Oleksij Rempel <o.rempel@pengutronix.de>, Maxime
 Chevallier <maxime.chevallier@bootlin.com>, Andrew Lunn
 <andrew+netdev@lunn.ch>, Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>, Jose Abreu
 <Jose.Abreu@synopsys.com>, Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan
 <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky
 <leon@kernel.org>, Dragos Tatulea <dtatulea@nvidia.com>, Alexei Lazar
 <alazar@nvidia.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] net: use skb_share_check() in loopback
 selftest hooks
Message-ID: <20261014130618.4c50f817@kernel.org>
In-Reply-To: <20261007-nb-net-selftest-shared-net-v1-0-458369bfa1ba@tipi-net.de>
References: <20261007-nb-net-selftest-shared-net-v1-0-458369bfa1ba@tipi-net.de>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 07 Oct 2026 20:29:21 +0200 Nicolai Buchwitz wrote:
> The loopback selftest hooks can get a shared skb when another handler
> is bound to the device. Linearizing a non-linear frame then hits
> BUG_ON(skb_shared()) in pskb_expand_head().
> 
> Stumbled over this on RPi CM4 (bcmgenet, with jumbo series applied +
> WIP selftest patches) with a packet socket open at the same time as
> running ethtool -t.
> 
> stmmac and mlx5 seem to have the same pattern, xgbe already handles
> shared skbs. Patches 2 and 3 are compile tested only.
> 
> As the impact is pretty limited and doesn't seem to bother anyone in
> the wild, I've chosen net-next, but kept the Fixes tags. That matches
> what Paolo suggested during the LPC track.

Wonder if we should follow up and rename skb_unshare to skb_unclone_full
or some such? The "share" in the name is quite confusing for people who
haven't been around for 10+ years..
