Received: from mail.tipi-net.de (mail.tipi-net.de [194.13.80.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5B52D7DD8;
	Wed, 14 Oct 2026 21:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.13.80.246
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792011791; cv=none; b=k6T8irF+ZeVWO5RLIa/hELT6fzuC+zNyJRZDNy0VIIIcChSpJ4gccaZOhRvAth+ysT+oVXCXcU6Dt0OZshoAx4YFHRnC+omxrQSkRWt6kBty7fVXI8fCjSQiPWgieNFPhsSXYMP6hjgtNim0asu1PXHkz9IEqnZw1t8betJ9Ado=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792011791; c=relaxed/simple;
	bh=SqjFtcMUiykXxYPVsn6NLogUDEnJnLN8ZRQiWX6Puok=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=KcwNDTAjWR6B/z2ckhSE4rDSLeOXdjSrEa2szqzCAO2N3j/rL/iZd7wmc9cyNBUmbkICX+CkyBWMlg7UZelgMwomtLBkZPAYvAVxO8aSxiD/3HXcoGpxCmeWyw9onpI8+UF2B7VB0WNMtJxyC4NWTuCl08Jtzuvgr8sRoXt1Eck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tipi-net.de; spf=pass smtp.mailfrom=tipi-net.de; dkim=pass (2048-bit key) header.d=tipi-net.de header.i=@tipi-net.de header.b=yIkCqM8V; arc=none smtp.client-ip=194.13.80.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tipi-net.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tipi-net.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tipi-net.de header.i=@tipi-net.de header.b="yIkCqM8V"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id A5F15A158F;
	Wed, 14 Oct 2026 23:02:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tipi-net.de; s=dkim;
	t=1792011778; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=SqjFtcMUiykXxYPVsn6NLogUDEnJnLN8ZRQiWX6Puok=;
	b=yIkCqM8VXYULT4KSbksQvh0J7Tj15J46cr34YtosYI+MjN0Qk5769F9P5w48F1OB0hO8NY
	pNbnddSbAdW7N+NXrJnwhCD1yKwuI+R8VW88csJuiShpMYw7uFaeel2BUQH4vPdQOhYD28
	yvTpcN52JWnyPulsJ+WwN9zZAtkZ4w+5OowTW6E+7A/S8UYV7yxAvT4LXOAh/L6aB8Vzl4
	lbDcYE+Hmrw2M7T2zY3ZPtju8277v6m3C2XptLTMAwxS7uQIctI1WXhjCDTxrY+RhrjIPU
	yXH7MMdMrWrRib0sHpB8eTrNmO9wF+K5NQMpemE2L8DPo7STohPRaJl25S8bOA==
Date: Wed, 14 Oct 2026 23:02:52 +0200
From: Nicolai Buchwitz <nb@tipi-net.de>
To: Jakub Kicinski <kuba@kernel.org>
CC: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Oleksij Rempel <o.rempel@pengutronix.de>,
 Maxime Chevallier <maxime.chevallier@bootlin.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Jose Abreu <Jose.Abreu@synopsys.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Dragos Tatulea <dtatulea@nvidia.com>,
 Alexei Lazar <alazar@nvidia.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-rdma@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_net-next_0/3=5D_net=3A_use_skb=5Fs?=
 =?US-ASCII?Q?hare=5Fcheck=28=29_in_loopback_selftest_hooks?=
User-Agent: Thunderbird for Android
In-Reply-To: <20261014130618.4c50f817@kernel.org>
References: <20261007-nb-net-selftest-shared-net-v1-0-458369bfa1ba@tipi-net.de> <20261014130618.4c50f817@kernel.org>
Message-ID: <BBC0F4F4-AE37-423C-9BC8-4C288D316DA9@tipi-net.de>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Last-TLS-Session-Version: TLSv1.3

Hi Jakub

On October 14, 2026 10:06:18 PM GMT+02:00, Jakub Kicinski <kuba@kernel=2Eo=
rg> wrote:
>On Wed, 07 Oct 2026 20:29:21 +0200 Nicolai Buchwitz wrote:
>> The loopback selftest hooks can get a shared skb when another handler
>> is bound to the device=2E Linearizing a non-linear frame then hits
>> BUG_ON(skb_shared()) in pskb_expand_head()=2E
>>=20
>> Stumbled over this on RPi CM4 (bcmgenet, with jumbo series applied +
>> WIP selftest patches) with a packet socket open at the same time as
>> running ethtool -t=2E
>>=20
>> stmmac and mlx5 seem to have the same pattern, xgbe already handles
>> shared skbs=2E Patches 2 and 3 are compile tested only=2E
>>=20
>> As the impact is pretty limited and doesn't seem to bother anyone in
>> the wild, I've chosen net-next, but kept the Fixes tags=2E That matches
>> what Paolo suggested during the LPC track=2E
>
>Wonder if we should follow up and rename skb_unshare to skb_unclone_full
>or some such? The "share" in the name is quite confusing for people who
>haven't been around for 10+ years=2E=2E

Makes sense=2E _unclone_full still sounds a bit clonky, but I can't think =
of a better name right now=2E I will give it a thought and send a follow up=
 :)

Regards,
Nicolai
