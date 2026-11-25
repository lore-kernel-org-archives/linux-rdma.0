Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=68.232.154.123
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795604968;
	b=jmOg0iGHrwVeWSvRqcwtWIjhPLinBlzNvDrgpNOs08wyeHoZjjyvQZBJ44T8tx43+Uf2
	 bOa7q0XieDJWDso1l/e63OOqls46SQCH9TiZbodX5nGgw4oNemKQrj5Qjl5SqCOBPlwj5
	 lsZhyNYzMXM1sj5rAzRAZGAOwNpcPRNbJ34maHL+qgorEHggjA1wcGVOYFkSv1evTZ5cd
	 P3v9zFwlYQk8Y01y+D2q6YeZtc+Tz3a5B55Pewb0n1dB2UWX103HVMt+rMFsvGBIxNlxt
	 oS4kglVhcCCbUSU7KxFNG6oATaptISLKOhzfQfBxNPE5Y1H+4sahhlYN2ys27eUliOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795604968;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-Amp-Result:Received:Received:Received:Date:From:To:CC:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=oFTO4XrOWf62L9p8l4hiQJfNqLVjR2xhwAOI6YlgejI=;
	b=hxx6BSmJWhRpfii3o+4+mYlvNQwuPyZCXeIEWTGPipv50L3lstMXEWhYL0XBP8GKlVsi
	 fwbtGbKlPYIWX7nzvU5+jy1k5rWpS3PcPxsw0VWiQNHo8g9EfORdYZQkct3a+jq8UwWPn
	 0VK66ycAVtXusLjKztLI1I25msfPnafFNti+Fyebnwnlp8KQMxlKbZPa0I3UWYwrnJMdw
	 Rr6PgB5C7gbNEKyQjgFSBqdxhwKNmzKcB67fIHwfpxNhQoFP7/PRa/+fT7YlFfeNaANrM
	 8WaTd9SRMMP/z9F0uTGIfvCf1tpaAmSXa46BpA61iNNOIFxU/Z02Az5QppX8DYfzZww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=microchip.com;
	spf=pass smtp.mailfrom=microchip.com;
	dkim=pass header.d=microchip.com header.i=@microchip.com header.a=rsa-sha256 header.s=mchp header.b=XbdUukXa;
	arc=none smtp.remote-ip=68.232.154.123
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FF8606A323;
	Wed, 25 Nov 2026 11:09:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A3FF8606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.a=rsa-sha256 header.s=mchp header.b=XbdUukXa
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1795604967; x=1827140967;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IECCZngcWYJPkW98qYT4Ot7lUmJVmz9WUAgkqRODs2s=;
  b=XbdUukXai4A0v0JnDuS+nRwa/GZyB8AOvCo6Po2nt6mypjjsG/O+pPX2
   qvjibi0uqEVXip2sc7272VGTLZ0C4mPjIESTTMu9f6FSioxUU7lwd2ZoU
   hlw11hzV0Eel7wK75YTLwPrTp9nIP2cfOV1I+S/Su5ix6fzbuqHRSaCJj
   aH++TIndS2a6bWWc/V7EglGTQF0IK5tmbA0uP6BMVa6Pc4WXUAgL/c4XI
   Xk/BswLOnLuTY9GROnMj3NiA5ddxlZn6kTPEmnsCEQgDM802tlpDVFMH4
   a66tz8DNtEDxq/6SsUA6iBkyCpF2fH9yt8WenXRL6fQ/Ri7Cwn6uduPA9
   w==;
X-CSE-ConnectionGUID: cyIXGbluT4O6U6DN2S8ROw==
X-CSE-MsgGUID: 15eS+1EZRP2MNEvHd+c5CA==
X-IronPort-AV: E=Sophos;i="6.27,232,1787036400"; 
   d="scan'208";a="67263931"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Nov 2026 04:09:27 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Wed, 25 Nov 2026 04:09:26 -0700
Received: from DEN-DL-M70577 (10.10.85.11) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.58 via Frontend
 Transport; Wed, 25 Nov 2026 04:09:23 -0700
Date: Wed, 25 Nov 2026 12:09:23 +0100
From: Daniel Machon <daniel.machon@microchip.com>
To: Tariq Toukan <tariqt@nvidia.com>
CC: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Yishai Hadas
	<yishaih@nvidia.com>
Subject: Re: [PATCH net-next 2/2] net/mlx5: Declare no DMA segment boundary
 for data direct device
Message-ID: <20261125110923.7ut72ppp33vpybkj@DEN-DL-M70577>
References: <20261120081819.2538191-1-tariqt@nvidia.com>
 <20261120081819.2538191-3-tariqt@nvidia.com>
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
In-Reply-To: <20261120081819.2538191-3-tariqt@nvidia.com>

> From: Yishai Hadas <yishaih@nvidia.com>
> 
> The PCI core initialises every PCI device with a DMA segment boundary
> mask of 0xffffffff in pci_device_add(), which forbids any segment from
> crossing a 4GB-aligned address regardless of its length. The data direct
> device raises the default maximum segment size to 2GB but keeps that
> boundary, although it has no such limitation.
> 
> Declare that explicitly, in line with mlx5_core, to avoid a mismatch
> between the declared constraints and the hardware capabilities.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
