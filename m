Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16EF3B7B7B;
	Fri,  9 Oct 2026 16:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791565193; cv=none; b=cxpgySlJm1Ifi+sVDtnBrU7yXN5J5jk5e2l3U1AUw7gypUS8OU8GS6XzCf7cqxtLTWz/SWVAIUBaXFVCXsXRHXAo2T8V2w5grp9POn/YSP4soZtCBxW4jsD1GlbCzhyhTXtRrCnWS4ZLu7RHsQw8wH+P9KsaKUQTK7ou26ZCJ1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791565193; c=relaxed/simple;
	bh=mx5HLX7NQip7DTHJlffeAg4KNsmsdr7n2PNVP74wSUk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ssW+6cudWWZ/hA2DGBS34u/rqh4N5wVy1Nr4ZjD/AKTT5RCmcJqygu5auqWcy8le9v8YHHD7F1qaMLVXEHDCT71lwMirPlYljOAz6KMp6xl00ffpUXMBKaqkuHhrwquzIFZYH8GSEo+TsTgVGx8KfS2TLx2tB6KKB60zI/Sb2aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=chtnWsYi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="chtnWsYi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8941F000FF;
	Fri,  9 Oct 2026 16:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791565191;
	bh=+BbB+5V1DDE74DWo4AdI8hldCRXKuou9E7wAUg4Z9Ls=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=chtnWsYin7j3tISjqYSPw9WzoFctpPMc/kleUrQaf9M1veFXAXBd1SBaJlTK8Fk3e
	 X0j7ZFmZnT6P1WURoFLqgvayj80vQVshPh4n3lKJLE/Y6znMWuZAA98linXTtJgkou
	 PtARy39gJebp4DVGvpQxKqbHSEX3xjlkBX3dR98HtywE6G63s2tM9N3RYEYdg3zBPv
	 Pxy2QGfT/1Xr/oSg3mxw0KZws7zpCPPjHiGTJhciqW5JteyhzSbimddJbg3FSEyK5q
	 /zj2a6yK/rftr/SrNBTVKUpbCz8Ncj0ZdKAaDO4q2qidbdHfRrfRsSk4uROEAE9x9C
	 NdwH/vB9UW2uw==
Date: Fri, 9 Oct 2026 17:59:45 +0100
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
Subject: Re: [PATCH net-next 2/3] net: stmmac: selftests: use
 skb_share_check() in the loopback receive hook
Message-ID: <20261009165945.GJ83879@horms.kernel.org>
References: <20261007-nb-net-selftest-shared-net-v1-0-458369bfa1ba@tipi-net.de>
 <20261007-nb-net-selftest-shared-net-v1-2-458369bfa1ba@tipi-net.de>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007-nb-net-selftest-shared-net-v1-2-458369bfa1ba@tipi-net.de>

On Wed, Oct 07, 2026 at 08:29:23PM +0200, Nicolai Buchwitz wrote:
> The loopback hook gets a shared skb when another ETH_P_IP handler is
> bound to the device. skb_unshare() does not unshare it, so
> skb_linearize() on a non-linear frame hits BUG_ON(skb_shared()).
> 
> Use skb_share_check() instead.
> 
> Fixes: 091810dbded9 ("net: stmmac: Introduce selftests support")
> Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>

Reviewed-by: Simon Horman <horms@kernel.org>

