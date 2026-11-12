Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=68.232.153.233
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794490912;
	b=2Td6PmMEIoyd/dHK7qFFptOaxAFybcS8cd3GOuk+YHtn0wgjmFpTtdC3e+dYzPO2hyOv
	 mCcPNk4lwnIdi7iba/NtpUWBhD11aHQX26vJTu6sL+78z8quzwpVNvbXPU4CJ0ADGLqLm
	 GWXUsD5tXYhhQFjP1pHaYrFyjyiEINyMurdCr5qV+YPDwQj8eb3N32vGLO3RtHNTG1Mwr
	 ipQ+MApOQVWHYA5JxDcMK9YrtztfahKnaRBvUoI6S+5ozqlD/AxUTjhrd+uzsilqXansW
	 qIKWgmzfObogSKwgCOdgSFH3ClEBpT+l66ON2rdEJI4e9j0NS/vjNRuW9VYa2sXYing==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794490912;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-Amp-Result:Received:Received:Received:Date:From:To:CC:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=kUVVSXqDZHlFTfJjw4IvHkP1vN6P8pdKd5orSbBaOsw=;
	b=qLE1361LWWX7ak/3bV6bTkf92kTiULIupDGeOTPKhOpmbFQ12nV657DjopPfxPn5FJcM
	 Uz1kTQg8vUQcGsM/uIBTgn/C94dVD3PzYig2RT3cWTFn1y3u8K4lQZntBpuuM4Dxe3oWH
	 ZIrgqcLN5j5fH7l0eRiPvpeyXBTc15YG/S+gGmeUFgbjK8jzHZOFOuMtY+odD8TZryl51
	 d++HpZZe5QHkkgPQitPD/c9mD3joFoU/z8VK6x8Xr1dArPgTWTymcOI4hwBzzecTYQu0c
	 W8ybXJphuyWfiiIpLQ5L88R2nQu8NKuYJC0lA47Shi1VbdLeTmO2D0dvOkm2XP6XWsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=microchip.com;
	spf=pass smtp.mailfrom=microchip.com;
	dkim=pass header.d=microchip.com header.i=@microchip.com header.a=rsa-sha256 header.s=mchp header.b=Zl80Miqx;
	arc=none smtp.remote-ip=68.232.153.233
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DAC7606A323;
	Thu, 12 Nov 2026 13:41:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7DAC7606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.a=rsa-sha256 header.s=mchp header.b=Zl80Miqx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1794490920; x=1826026920;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yXyLDCP/Hr++ih8wLBa5qVqlBjtP5RJUxIKEUIQNAY0=;
  b=Zl80MiqxUrzLjd7V7NwTSVBtnxhIT1UCMb5gFgJLLOExxy7qZRikZrvO
   xqugI5ZJ6V3ByPWaDmzkcS95pfiCsyMZa0EWV+Bf4TQQTuCFKwCbkoV+o
   4htkWXu1zb3W5D4tkQZcYhd5gq7SJSBFQdDdyRNBsFavM5ylCBwNFckEM
   GwIyvz1HYT6v+DaZYgul91GvRrr47Qzn+807/HceN4GgbSzlB7mK60jF/
   fESx5LJ2RJGVUCip8le++1gLMRqz7UQwoVE/MV0IdhDtybiinNJHg7CNv
   SO4EesJvs3vp/C5yiNt+tnNuJwcXeUSdKW2U3ibAwd22Ujmw6fdiaNHCf
   A==;
X-CSE-ConnectionGUID: UYpkMP1bT/CL9zC7qZ4Wig==
X-CSE-MsgGUID: le06lXg3QGCc/nqUUZS0vA==
X-IronPort-AV: E=Sophos;i="6.27,209,1787036400"; 
   d="scan'208";a="297833451"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Nov 2026 06:41:59 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Thu, 12 Nov 2026 06:41:50 -0700
Received: from DEN-DL-M70577 (10.10.85.11) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.58 via Frontend
 Transport; Thu, 12 Nov 2026 06:41:48 -0700
Date: Thu, 12 Nov 2026 14:41:48 +0100
From: Daniel Machon <daniel.machon@microchip.com>
To: Joe Damato <joe@dama.to>
CC: <netdev@vger.kernel.org>, Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn
	<andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <edumazet@google.com>, <horms@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next 4/5] net/mlx4: track whether a TX doorbell is
 pending
Message-ID: <20261112134148.h2ex6bly2zb32af6@DEN-DL-M70577>
References: <20261110231304.1859217-1-joe@dama.to>
 <20261110231304.1859217-5-joe@dama.to>
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
In-Reply-To: <20261110231304.1859217-5-joe@dama.to>

> When the stack sets xmit_more, mlx4_en_xmit() skips the doorbell and
> relies on a later call in the same batch to write it. Nothing records
> that a doorbell is owed, so a path that ends the batch without writing
> the doorbell leaves the WQEs posted before it unannounced to HW.
> 
> Add ring->doorbell_pending, set when the doorbell is deferred and
> cleared whenever a doorbell or a BlueFlame write is issued, so such a
> path can flush the deferred doorbell.
> 
> Signed-off-by: Joe Damato <joe@dama.to>

Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
