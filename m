Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDED54E01FC;
	Wed,  7 Oct 2026 18:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.153.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791398420; cv=none; b=GRqptsNpgmvLjj2PG9L/hbYdKaJZUgNm0GsJmKVDy116KKFgw1hv/alrDtQOVKOhyot4bUKQq6yCczyeuseSJkC2UPipjYxuLrNO+I9Ea7YyY9+tFMcBOCgghxEfG5LGCFTVW6NpTSN6ZsT88m0acXF/TyiTqlLMAM/BZnTNns8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791398420; c=relaxed/simple;
	bh=HHlCqGav/n7NtJLQSHN2S4LltChege0BzhxasuthA0k=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ewpZxx2hc0KacHKSGkFBQm0map5FkdiIDzloA2GpMCBBea+CinWRIaPqt6aTqqQIZAkNNNBBgClYaMJMQAm8tDQJWv/dkWT9ZIszpw2fZqetgm3XQ+aTN62XbpbX6wK9bD1v3TNYslUwWXVCiZsJr48G/2+IpJfsiDHzju97PC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=jLA3lC8s; arc=none smtp.client-ip=68.232.153.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="jLA3lC8s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1791398418; x=1822934418;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HHlCqGav/n7NtJLQSHN2S4LltChege0BzhxasuthA0k=;
  b=jLA3lC8sNOZHi1VInAyfo2Gb0ekSWMryW3Z65n5nXQQKpDhpVNOOWPut
   haDK/5kO1NS4Dt6EVtWP5uuEb2d3TyH1agJKQxyJJUBj30YoOxAPyyMLJ
   vxuO+vVlNdbzCHOshnJpcaDWjc9IUmwN2bv15POLWzVso6+FYwyJROlSl
   xgD2qO+CcIQ0c+LR+SKhYriR86Pdjz4TLqCqfVd1sLrftStcgsx0bg1Ea
   /zWGEilJZ5+b2/XQ3a27Wnp+1RFD3H7qMzSkj0n9KYnaQpn3Ly2kXQA7q
   B9PtqzB7EgCSBrmGO7ABqF9awH/fCzQpg3aTurdTk/Sf37ScBALw+ibx3
   A==;
X-CSE-ConnectionGUID: DC8nyTfxQSSDRldCkE/feQ==
X-CSE-MsgGUID: WArMQrM9TDiPxD9S8CSOvg==
X-IronPort-AV: E=Sophos;i="6.27,144,1787036400"; 
   d="scan'208";a="64715694"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2026 11:40:17 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex3.mchp-main.com (10.10.87.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.49; Wed, 7 Oct 2026 11:40:16 -0700
Received: from DEN-DL-M70577 (10.10.85.11) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.58 via Frontend
 Transport; Wed, 7 Oct 2026 11:40:13 -0700
Date: Wed, 7 Oct 2026 20:40:12 +0200
From: Daniel Machon <daniel.machon@microchip.com>
To: Tariq Toukan <tariqt@nvidia.com>
CC: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>, Leon
 Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Li RongQing <lirongqing@baidu.com>, Mark Bloch
	<mbloch@nvidia.com>, Saeed Mahameed <saeedm@mellanox.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [PATCH net V2] net/mlx5e: Order ICOSQ cc update after CQ doorbell
Message-ID: <20261007184012.x7qmcjh4xuks3jbw@DEN-DL-M70577>
References: <20261006105820.257208-1-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261006105820.257208-1-tariqt@nvidia.com>

> From: Li RongQing <lirongqing@baidu.com>
> 
> mlx5e_poll_ico_cq() requires sq->cc to be updated only after
> mlx5_cqwq_update_db_record(), otherwise a CQ overrun may occur.
> 
> The current implementation updates sq->cc before the CQ doorbell
> record, violating this ordering requirement.
> 
> Update the CQ doorbell record first and use dma_wmb() before updating
> sq->cc. This ensures that the CQ space is released to the device
> before the corresponding ICOSQ consumer index is updated by software.
> 

Reviewed-by: Daniel Machon <daniel.machon@microchip.com>

