Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD3D399340;
	Mon, 17 Aug 2026 10:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786961882; cv=none; b=B/0E4sIXBN304ppxhPC+MiZdWQZ4eGfJ0h2uPXtAnUsxqU5dYN5Nmq4mFy060Y1UGPlWIp2GtaUJmhLpons+5KngmOWl1KPvRQLa6ryDOOEy/COiqI5Mq//r3doUaDUSitP4CV2TnYTi/a8VW+PnPc2Wa5adYifieRBnHzSQmhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786961882; c=relaxed/simple;
	bh=WYFr824Jg2UGcL8s/b+96eo/UlnKUJpf22JY9x9tOZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KPcVQJ+lXsD1l5PdLMoec+08MLpdf7uyCJaRWpwvdqHwwQ6chxO/i3Fm1rKNcFHh9x+C5RbVYddKOXPji6z8WIyvTkhckLbXXtdttXiKKsoha0ttzRjtsaIXtd/FqAIamUBiqZ30R6yFvh35wRdr9NeVodk99WZ44rRuyC5D1Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WnoxnwwN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WnoxnwwN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000DA1F000E9;
	Mon, 17 Aug 2026 10:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786961880;
	bh=TXBQkyiFLvXRPc/vOwn4FFBd5nq323zoO1sSOJOX4cw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WnoxnwwNzxDZ1uTD3Jm53Egy4+C6aqoRoY0GEIURu9TYM82Zq+KqLLAJ/E2+/+UgC
	 M3LKx/OX2d5cuGEO1UZnES5hvb30VCRndCdCmDJLGMHFSiUhJ4tPIkuebjI6x+fVFc
	 54056sAl+BGJK1Lbbl5FuyrHxcXqwZqkNt2PJuLbhjKopgFXps6Xa+ABEO2rh1Lpi8
	 85D0gqTYZKc38c3RkDt/Cgbz3XaSYodY+Dyf0yuy0eQfJ4A6+3RbG6kV0jYw6lQ+fT
	 T9FC3OurG4v08tTv0HWDox4ksMeFINLXpqRB2B8uP2i+pZ/0T8/T5jOE0dTqPDugUo
	 aiXwObD4UGM8A==
Date: Mon, 17 Aug 2026 11:17:52 +0100
From: Simon Horman <horms@kernel.org>
To: Stanislav Fomichev <sdf.kernel@gmail.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, anthony.l.nguyen@intel.com,
	przemyslaw.kitszel@intel.com, andrew+netdev@lunn.ch,
	saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com,
	maxime.chevallier@bootlin.com, mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com, aleksander.lobakin@intel.com,
	magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
	sdf@fomichev.me, ast@kernel.org, daniel@iogearbox.net,
	hawk@kernel.org, john.fastabend@gmail.com, witu@nvidia.com,
	martin.lau@kernel.org, yoong.siang.song@intel.com,
	rohan.g.thomas@intel.com, intel-wired-lan@lists.osuosl.org,
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, bpf@vger.kernel.org,
	leon@kernel.org
Subject: Re: [PATCH net v2 3/3] net: stmmac: skip queueMaxSDU check for AF_XDP
Message-ID: <20260817101752.GY265046@horms.kernel.org>
References: <20260813190800.222527-1-sdf@fomichev.me>
 <20260813190800.222527-4-sdf@fomichev.me>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813190800.222527-4-sdf@fomichev.me>

On Thu, Aug 13, 2026 at 12:08:00PM -0700, Stanislav Fomichev wrote:
> Commit c5c3e1bfc9e0 ("net: stmmac: Offload queueMaxSDU from tc-taprio")
> was inspired by commit 92a0dcb8427d ("igc: offload queue max SDU from
> tc-taprio"), but the igc change does not apply the check to AF_XDP.
> 
> xsk_tx_peek_desc() reserves a completion entry. Continuing without
> queuing or completing the descriptor leaves the AF_XDP rings imbalanced,
> so remove the check from the zero-copy path.
> 
> The assumptions is that AF_XDP zero-copy traffic bypasses the qdisc, so
> taprio's queueMaxSDU check does not apply to this path.
> 
> Fixes: c5c3e1bfc9e0 ("net: stmmac: Offload queueMaxSDU from tc-taprio")
> Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>

Reviewed-by: Simon Horman <horms@kernel.org>

