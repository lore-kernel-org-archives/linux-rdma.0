Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=68.232.154.123
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795604952;
	b=4Zk2Jg76bfns0WC9KsEq4iqX+vxLo2Oqfi1Lf+Y3W9kEzM/YHcFmr7s7wCwKLv3+Sr5B
	 zYKIObjNGtyCHxn8uQArO9e0H2Py4zsYexYZ8sPccvApeK+Q+VzK7+RAQjulsl6iQjpdt
	 Xb2yl8Fm6pte36mKPNzAYEATj3yonOeLGpw/EkgGCGLufp1VMuEpdCce7mwGZLLVcd3EK
	 hnXiMOk5Ab5MnIcx9vA2hL+4eCTdxSOw1NXGPzlArd62O8xmjqkAmy5vsl7VCMY98o1LE
	 R2/RxPa5zQVxD1w8BgbShDqmTmFbiLLG62Wq5qbuQrqI0jzQegpsOBntYtMKbxconng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795604952;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-Amp-Result:Received:Received:Received:Date:From:To:CC:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=bez0u8/Y0qn5lvcB023udzihcPUHRj63AD4E4YDCVhs=;
	b=t+vhj2GqwxZ1XmN66eirX3500EInhz43z9YqayfF0bvoDIWxbuWpM1VGkgTiZx/hPsjD
	 zZRRpsBr+jf06Y8QF9zhIjowEzPYDSTyds2Un/u10HZ+JxchPbxrQ7hgV7okuMk1ofWFq
	 HCYENAKguL+GApg9JqB8XzVoaYKj6s6sxgm3R0yz3/wl5DumP2+NO3b+4yqnhClnXCp7w
	 mi9ReKqlxdnBq7WOjp1y5IjOPZg20dbb1OD/xUQCaRHQEOSlqF2hPeOI/GmImFBeMIZcS
	 sPJfolC5lv4311RdDmNM8vg7oR0YKrosGCwMoxS7u5r/WgejAvQP01XMR+yP6y+ODmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=microchip.com;
	spf=pass smtp.mailfrom=microchip.com;
	dkim=pass header.d=microchip.com header.i=@microchip.com header.a=rsa-sha256 header.s=mchp header.b=ec7Lskrh;
	arc=none smtp.remote-ip=68.232.154.123
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E228606A31E;
	Wed, 25 Nov 2026 11:09:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7E228606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=microchip.com header.i=@microchip.com header.a=rsa-sha256 header.s=mchp header.b=ec7Lskrh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1795604951; x=1827140951;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=e+iy8X+LBbHFttGZByeKZw6Kzf6psPn49gSpJQ8bpcs=;
  b=ec7Lskrh2xn0P+US8P3Zz12zLoyDojhK6UUz0dT3mw8TiIadbi1UuM08
   jyjJCjXIsjiZ38r5zPs52lZLMd/JZmrZrvU//haydjFH286ZuITLmB4Nz
   dHyPNoHdu3x3unwvzwL7jKyyNMXGZfPKKamRpUUrgsfcuTh0nNIFRgMNo
   tltkJ7rD5umjzhOXIheq3is+5kHD9aVBUXx++cpCcDs73l/f/AOonXFU0
   UKqq57Ygy03qT2qg/RHN/9HotpHORrJd4ZeVvibECjuesZRpRV2tuGtIc
   Vyj3n5BYMoDXKdhGBNkubcPt92E8kyz5ez+fDSPhwF9APXS2m77nqxNdR
   g==;
X-CSE-ConnectionGUID: rVzxWilIT9ibD/wGZRBL3w==
X-CSE-MsgGUID: tzg176+UQ7KKuh1LfNYYsQ==
X-IronPort-AV: E=Sophos;i="6.27,232,1787036400"; 
   d="scan'208";a="234073923"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Nov 2026 04:09:05 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Wed, 25 Nov 2026 04:09:05 -0700
Received: from DEN-DL-M70577 (10.10.85.11) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.58 via Frontend
 Transport; Wed, 25 Nov 2026 04:09:02 -0700
Date: Wed, 25 Nov 2026 12:09:01 +0100
From: Daniel Machon <daniel.machon@microchip.com>
To: Tariq Toukan <tariqt@nvidia.com>
CC: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Yishai Hadas
	<yishaih@nvidia.com>
Subject: Re: [PATCH net-next 1/2] net/mlx5: Declare no DMA segment boundary
 restriction
Message-ID: <20261125110901.xuokqcxe425fphch@DEN-DL-M70577>
References: <20261120081819.2538191-1-tariqt@nvidia.com>
 <20261120081819.2538191-2-tariqt@nvidia.com>
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
In-Reply-To: <20261120081819.2538191-2-tariqt@nvidia.com>

> From: Yishai Hadas <yishaih@nvidia.com>
> 
> The PCI core initialises every PCI device with a DMA segment boundary
> mask of 0xffffffff in pci_device_add(), which forbids any segment from
> crossing a 4GB-aligned address regardless of its length. mlx5_core
> raises the default maximum segment size to 2GB but never overrides the
> boundary, although the device has no such limitation.
> 
> Consumers such as ib_umem_get() coalesce physically contiguous pages up
> to the maximum segment size without consulting the boundary mask.
> Registering a large MR can therefore produce a segment that crosses a
> 4GB-aligned address, which the DMA API debug checker reports:
> 
>   DMA-API: mlx5_core 0000:08:00.0: mapping sg segment across boundary
>   [start=0x00000002ffe27000] [end=0x000000030020efff]
>   [boundary=0x00000000ffffffff]
> 
> The segment is about 4MB long, well below the 2GB maximum, but it spans
> the 12GB (0x300000000) boundary: the upper halves of start and end are
> 0x2 and 0x3.
> 
> Set the segment boundary mask to ULONG_MAX so the DMA constraints
> declared for the device match what the hardware supports.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
