Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=68.232.154.123
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792754568;
	b=OaIbpgd9q2xE+Y8QOIPDuaFCP2s43G7STm2rDaZTJRSVmE5X8vxi7ZxUgMyMIQPpRuAW
	 szNV6jcmMk/2UCQwONF23YAwjsLEI5Tdd4rEtK/54b9OWbqJ2dddhDnunm6oAkHb/cwGS
	 rCwVip4Xok270YaHzbIDCtJzKteI4KX6/1GGc3XHIT4K8BleMOtxBNMBqshVOOJee2O/O
	 GOrijyTZpsEwYWAes2KSaxMhOCm3TTdw7P/pkr+9ZCmW9VU74mVX61WuAiLzFM8rVQOx4
	 7Z5akPFF0vpx5kSPdWt7j40yAJgw110eLTaizIRto2BjseT2/A/RRAZWc+LcgZvUXnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792754568;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-Amp-Result:Received:Received:Received:Date:From:To:CC:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=G5CSIxobeZsdLounHb4GkpO0AIF+/+Z89dEuK4yoslo=;
	b=lJvb2G5eJFo9ryiwq/mAtpiiT5djExx63ASdOA6yy5VWHjT1N2HWMTmzlxUXIBAOW36m
	 xakR3S0HLy9QGG/7gOZbBoTfR+uiss9/DrDrzG4vj2PoqRM3yj6fxRIxM7KETOJx6Fi3A
	 4UCKevyV7ZmB32lBXVovPlI+njKabPoNmV4KWHFdYGn9GD0gPrMOO/vo7lAiOtNbGfPk3
	 tdv+xSp2yqW8Lu16Ad6qixU8JCwGZwym8OHRhCtULkeoYGpUPT1f6KIKpaA/Tgex8p2gt
	 fR1MdDquoIbbYfMJknwLBWmje+8fsTsye9c6kt9rOXDh2IrTqkhDPP20gJposSccTxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=microchip.com;
	spf=pass smtp.mailfrom=microchip.com;
	dkim=pass header.d=microchip.com header.i=@microchip.com header.a=rsa-sha256 header.s=mchp header.b=rqZvcWTE;
	arc=none smtp.remote-ip=68.232.154.123
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2430606A31E;
	Fri, 23 Oct 2026 11:22:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B2430606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=microchip.com header.i=@microchip.com header.a=rsa-sha256 header.s=mchp header.b=rqZvcWTE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1792754574; x=1824290574;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+qda/jg1Jhs1LNJh2oS73NxCLupuDNJ0kTc0oDSTNUM=;
  b=rqZvcWTE9iD6ePSB+KCrAa4xNdvaoEuVKbxyijq3eSWj2rd/iWlfTY3o
   H8le9KkGUHoRcMUR3KjjmOEyn83qO81GfUqiGyKTPrzHTbQVuaFceRTC1
   ICt9paGzdO2SAM8qFZ9o5iW7bRXpzD2dJcQeMwb6MRZxTCD0hhKfun/F4
   wIJyaaQzAXOtyrVTrdtDcN7pJwLrR+36xpEIGur5w0u+djx5JCpHXa5PU
   q0vh5meBBYzlmGLRV2fdSWqt/sHGP33NkUCJ2tqpO5mkjv50kOaBGTQh+
   cWzTAKfkTPa3OkdUEoaSJwRO5JNU9bp4o9FmjQ9NfFa3q19ynNtILXi13
   w==;
X-CSE-ConnectionGUID: a4/kPmM6QOinwLLFglvc3Q==
X-CSE-MsgGUID: R9hzWZuySOOj5jixmaLaOQ==
X-IronPort-AV: E=Sophos;i="6.27,174,1787036400"; 
   d="scan'208";a="65727433"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Oct 2026 04:22:53 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Fri, 23 Oct 2026 04:22:46 -0700
Received: from DEN-DL-M70577 (10.10.85.11) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.58 via Frontend
 Transport; Fri, 23 Oct 2026 04:22:44 -0700
Date: Fri, 23 Oct 2026 13:22:43 +0200
From: Daniel Machon <daniel.machon@microchip.com>
To: Peter Morrow <pdmorrow@gmail.com>
CC: Tariq Toukan <tariqt@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Petr
 Pavlu <petr.pavlu@suse.com>, Yishai Hadas <yishaih@nvidia.com>, Jakub
 Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Eric Dumazet
	<edumazet@google.com>, Andrew Lunn <andrew+netdev@lunn.ch>, "David S .
 Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, <regressions@lists.linux.dev>
Subject: Re: [PATCH net] net/mlx4: always create the eth and ib auxiliary
 devices
Message-ID: <20261023112243.bpowvi6tdcguoie3@DEN-DL-M70577>
References: <20261020164239.3808903-1-pdmorrow@gmail.com>
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
In-Reply-To: <20261020164239.3808903-1-pdmorrow@gmail.com>

> Since commit 7d22b1cb9d84 ("mlx4: Connect the infiniband part to the
> auxiliary bus"), mlx4_core creates the "ib" auxiliary device only for
> an IB port or a device that advertises IBoE. Before it, each mlx4
> interface was offered every device and decided in its own add callback.
> mlx4_ib_add() accepted Ethernet ports without IBoE and registered them
> for raw packet QPs only.
> 
> ConnectX-3 VFs on Azure have an Ethernet port and no IBoE, so since
> v6.6 they get no RDMA device. DPDK's mlx4 PMD, which needs only raw
> packet QPs, then cannot open them:
> 
>   net_mlx4: cannot access device, is mlx4_ib loaded?
> 
> Restore the old behaviour by creating both auxiliary devices for every
> device and letting mlx4_en and mlx4_ib decide in probe, as their add
> callbacks did. mlx4_ib_probe() returns -ENODEV when there are no usable
> ports, and mlx4_en_probe() binds a device without Ethernet ports but
> creates no netdevs, as mlx4_en_add() did.
> 
> Tested on 6.12.111 on an Azure VM with two ConnectX-3 VFs: each gets an
> eth and an ib auxiliary device, and DPDK attaches both VFs and passes
> traffic through them.
> 
> Fixes: 7d22b1cb9d84 ("mlx4: Connect the infiniband part to the auxiliary bus")
> Closes: https://lore.kernel.org/r/20261014133951.3219055-1-pdmorrow@gmail.com
> Suggested-by: Leon Romanovsky <leon@kernel.org>
> Assisted-by: LLM
> Signed-off-by: Peter Morrow <pdmorrow@gmail.com>

Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
