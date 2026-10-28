Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=68.232.153.233
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793190112;
	b=NSTlHxMfHjUdLg7LcunMl7TltQBsBa1CU0Ghz0hQkUch9UC7JwOoTjbRR0AmB3CkEbA0
	 Iqu0CQZ/bwDnGGyCITZOT4b+3uRg9/06m3jJHBOs6SCM6b09AFk2xrzy/SfoYdhYU9m4M
	 JSww2Yw4WlMa2J/+gYayK2+CKPlrtLdC7y9aJ9PGycAJJLQBLUT5UsYzKDCrTT0n9PjQn
	 7AkHosocZyMTekMrrKRrGE1l0FbtMT9w4IjuwMJaYcMEqmj/RgssczuW3C5tu0Gf9RWpW
	 Quv8tUQajEOZ08AJdE176LbqQnSG37pXo4MhNhX/DwIyU8t9t5pGo65PpTOiEwV3Frg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793190112;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-Amp-Result:Received:Received:Received:Date:From:To:CC:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=VSsMSfeVFRpy+zU7AnNnWN4w/3WDk8WOTlDao6IXyko=;
	b=yohzjDde84+enKxiKDuB5nrBeKLphbVM5LbObWWhyRYbS/+ZVzi54u3qinG19fYDJejd
	 Nfq68ktLGixaDsiG42yuP0WvOr2THgTyuPiS9IKYl2EwOpGAFwEfP9gU0uOrB8jbzlYy2
	 uKFblj/GmHIqDkQuxGwbrS3oAPF4i6mavkAhiYDWNwVhVTr+nQeoVOmOy6fwM4XfPNFo4
	 iOxapDfViLcv1xuCaEAnSQhlNxVbuuiIzlUNCJDQ1IyBFYYHrWGskDYa7u9FV0LW6d6cz
	 CB3asxBAJl8itmUEA+S8GGPDCqCAel4dO4WUJBrg3NHRCt3OFQ12k8TCtwtMWY/Jd8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=microchip.com;
	spf=pass smtp.mailfrom=microchip.com;
	dkim=pass header.d=microchip.com header.i=@microchip.com header.a=rsa-sha256 header.s=mchp header.b=zITKeO8Z;
	arc=none smtp.remote-ip=68.232.153.233
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD1B606A31C;
	Wed, 28 Oct 2026 12:21:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7BD1B606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=microchip.com header.i=@microchip.com header.a=rsa-sha256 header.s=mchp header.b=zITKeO8Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1793190111; x=1824726111;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zhXwhn/Mb9Oo9aXdIdqqmfpJxHVR7QuDQg6QCjR4Zw0=;
  b=zITKeO8ZbsBk3M0X0nWEiN6n3T8i3usqbwvt3oLmHY4TlREIPpgTzFD9
   A2BLMGRS9Q7rVDilGvMJ1kaapOAL3t9ddSPvdePkI56K74XDu+1vDYjw7
   mi5cXVWczBzBoKM6qjS9Tl3ZyN7oKW5FzRaI2DMcwiYp1/Ebqz4zZSxh0
   Xopn4/mpwANvrQVgTZZDCpBz0N82t7YOYw1MsV968OvAPT9tmKGP6Ie1j
   5XIMiRcSzHG3zZA5ervbJ6L8Ntf6dApOXRnJiWMtUUPkTrCuJ0Zkgkw72
   19hsHjOuEl6HKicmHXjPEOg56keLDs336jhxj33YqaAoNRA9xZn01pG6a
   A==;
X-CSE-ConnectionGUID: d5H901CSTa6MZ04mTUqV0Q==
X-CSE-MsgGUID: 371hSaVvQ3a5vjNhV2/Bxg==
X-IronPort-AV: E=Sophos;i="6.27,182,1787036400"; 
   d="scan'208";a="65668053"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2026 05:21:50 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.87.152) by
 chn-vm-ex2.mchp-main.com (10.10.87.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.56; Wed, 28 Oct 2026 05:21:49 -0700
Received: from DEN-DL-M70577.microsemi.net (10.10.85.11) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.58 via Frontend Transport; Wed, 28 Oct 2026 05:21:46 -0700
Date: Wed, 28 Oct 2026 13:21:45 +0100
From: Daniel Machon <daniel.machon@microchip.com>
To: Tariq Toukan <tariqt@nvidia.com>
CC: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Cosmin Ratiu <cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>, Gal
 Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Simon Horman
	<horms@kernel.org>
Subject: Re: [PATCH net] net/mlx5: Only set num_doorbells on a fully
 initialized SF
Message-ID: <20261028122145.g7ve7z6jvii6euud@DEN-DL-M70577.microsemi.net>
References: <20261026084503.4122732-1-tariqt@nvidia.com>
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
In-Reply-To: <20261026084503.4122732-1-tariqt@nvidia.com>

> From: Cosmin Ratiu <cratiu@nvidia.com>
> 
> The validation for the num_doorbells devlink param rejects values
> greater than num_channels. For lightweight SFs, this ends up accessing
> a NULL priv->eq_table, leading to a crash.
> 
> Fix that by rejecting setting num_doorbells on uninitialized SFs.
> 
> Fixes: 11bbcfb7668c ("net/mlx5e: Use the 'num_doorbells' devlink param")
> Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
