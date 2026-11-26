Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=68.232.153.233
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795700293;
	b=D4M2VGnV1Wn0iAV70MHQI27Tue1RXqMEOecoUOu/mcoHw01F45eWnj3OmQUbfVhkQ9nh
	 v3HsZuZzABp80g4+gQvGeIywpvr3S5y8ZHcQszg/U8Qqxg9jWJPnu2HxnjHErU3CZ/cIH
	 oKUYpx3NLrBlGid/DLjLcVPQTjVG+CrgxdZS/jn3OWnCnKjZ37yJA52Fqpt6aHesaLGbB
	 jas6WthhiiAygLu++0lfVD6poRGmZwILU6xiqQXW5O4RljqHb77gSl2MpbjFJByiHsIX0
	 wNQGMfzbJ2n1ZSoTYtJYWWcJ1I5ejkZgTiAwPYJkaCNPhPJAg/mtAtmJc+dV5VWg0Yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795700293;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-Amp-Result:Received:Received:Received:Date:From:To:CC:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=UB4R9+g+/1K+GpovN9vjde8xK9vvArzBeCX49NLeBVM=;
	b=wed2wzGzAHfe7J/8F7RaEunQ50u16Jxz3vjb39RjgX+/8vwlea3huofxitF27GKK9fbh
	 tJzWOKptosZIXo84VgJMYXjhUcgPohR0DwHFBNGXqWMWs9VgUnSTzSGB2acsqQbc688wr
	 enyPn+GiX6bN+jaKKIODFyHcyjgeIXnDw1p8TRKJ4QC1HYcvDdaJ2lb8qtE9eqG6LENg6
	 oJ0DwNADNHLUl3jsAdBMBp0KvTX5JcgLAC+dBTkVL/dLLvAXiWQ/6QD19AVlM5GerVQsX
	 +qHWYDZtbyfpYYLrqoiAnpFUcjac4sjG6MdmX8qh8zeo/c80EaXZiHVHxZUBbOqpBaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=microchip.com;
	spf=pass smtp.mailfrom=microchip.com;
	dkim=pass header.d=microchip.com header.i=@microchip.com header.a=rsa-sha256 header.s=mchp header.b=j599wb4N;
	arc=none smtp.remote-ip=68.232.153.233
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFA0606A31C;
	Thu, 26 Nov 2026 13:38:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1AFA0606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=microchip.com header.i=@microchip.com header.a=rsa-sha256 header.s=mchp header.b=j599wb4N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1795700301; x=1827236301;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=G4zsWeUju+IWgiWPQzRUVrkAwzZVYkalz/qY46Q3Yh0=;
  b=j599wb4NtXMxfaGWrAn0WnQ4MdDszOMt3DTeWkBs8QT85cHFeE2iSJPO
   grTBBP7pgCWz7JC7thg3ae3DgV/xuw1/N4X7B0fpbCNhqNC/BjNShbPx3
   cXNaRaPmB5IC6hZCtrpKsB4XqpZp5ebWO+z+ogj8Ce21NjPc8pGKcIqMY
   N3ZahKIESA0VhFKkIZtlqJbzYAJuL2VMMhR0rntsGkHKpLrsuHWgbpQc7
   9XwOQaoMjn7wM/u70ciB0EZqF4xYlG3kwzKwPTcxpUGVo4w1rO1dWrTWK
   L7tiUpY62tK1AIXkpwADvv3/QDi5bPr/+94bjatgxrANMcEU0H5HXR8et
   Q==;
X-CSE-ConnectionGUID: eKHu6kANRpC25hSdYnGHwA==
X-CSE-MsgGUID: GSlVHfESQC61gBgrgTfi3Q==
X-IronPort-AV: E=Sophos;i="6.27,235,1787036400"; 
   d="scan'208";a="298499061"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Nov 2026 06:38:14 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Thu, 26 Nov 2026 06:38:05 -0700
Received: from DEN-DL-M70577.microsemi.net (10.10.85.11) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.58 via Frontend Transport; Thu, 26 Nov 2026 06:38:01 -0700
Date: Thu, 26 Nov 2026 14:38:01 +0100
From: Daniel Machon <daniel.machon@microchip.com>
To: Tariq Toukan <tariqt@nvidia.com>
CC: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>, Ariel Levkovich <lariel@mellanox.com>,
	Cosmin Ratiu <cratiu@nvidia.com>, Gal Pressman <gal@nvidia.com>, Leon
 Romanovsky <leon@kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Muhammad Zuhayr al-Tayyar <mzuhayr@earthlink.iq>, Roi
 Dayan <roid@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Saeed
 Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net] net/mlx5: E-Switch, Fix offloaded nf flowtable rules
 never being hit
Message-ID: <20261126133801.mvor2d6hxa4icwrq@DEN-DL-M70577.microsemi.net>
References: <20261125115815.87909-1-tariqt@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261125115815.87909-1-tariqt@nvidia.com>

> In switchdev mode, nf flowtable entries offloaded to the FDB are
> installed but never hit, and the traffic keeps going through the slow
> path.
> 
> esw_chains_create() opens the nf flowtable chain, then the root table
> (chain 0, prio 1), and only then sets the nf flowtable table as the end
> table of the chains. mlx5_chains_create_prio() takes the miss
> destination of a new prio from the end table when the prio is created,
> which for the root is still the default table, i.e. the slow path. So
> the root misses to the slow path, and the nf flowtable chain is never
> reached.
> 
> Another chain 0 prio, e.g. of a tc rule, hides the issue: the root's
> miss is rewired to it, and its own miss goes to the nf flowtable chain.
> This stays so after that prio is destroyed, until the eswitch is set up
> again. Setups that always have such a prio, like OVS, don't hit it.
> 
> Set the end table before opening the root, as it was before the
> offending commit.
> 
> Tested on ConnectX-6 Dx in switchdev mode, with two VFs routed through
> their representors and an nftables flowtable with offload on them.
> Without this patch, the connections are HW_OFFLOAD but 99% of their
> packets go through the representors until a chain 0 prio 2 tc rule is
> added; with it, they are forwarded by the eswitch from the start, in
> both SMFS and DMFS.
> 
> Fixes: ae430332557a ("net/mlx5: Refactor multi chains and prios support")
> Reported-by: Muhammad Zuhayr al-Tayyar <mzuhayr@earthlink.iq>
> Closes: https://lore.kernel.org/netdev/AM0PR02MB4307F6D53A2B0AD628D91C81C6682@AM0PR02MB4307.eurprd02.prod.outlook.com/
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>

Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
