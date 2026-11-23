Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=68.232.153.233
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795424455;
	b=a7sbsJ+XrAvbsUYwlxyEsVU/BaYQXeUFu96kZNAZsSq3DlStp5RHsZisRi8YRH5NYekN
	 cPa1cZQ6X/rIF5UkK4X7NYPyaq7fxfYzJ/JFTnaIQalPLuJ5IyMA3u1et/564C9FVkyqf
	 DMNSAv+8uJ6X7Ghu4v1ywlBvlh7NhIZKTLkC9nHBBxGM7eTcm1gx5sLNOLt/86UVuEIkN
	 mPe229ufaSQ2zxLcwcckutwXJWR0+K+RFWMEn+Q/8/dpje7lJ9+JtK3EXenhAsBWEMJg+
	 pcmJ7k6w0jfAH84CR0e+PdkFOn4DTeF11ohDkBbDqZRNctljlq5dBzpTjgoYAG7b24g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795424455;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-Amp-Result:Received:Received:Received:Date:From:To:CC:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=wK56nV5dj6BN9DnAzwC2it7nIfhccBMyPksEVfxk8L4=;
	b=ayXf4zjqCXW/DCMPw6IxOFwlyB7yQwTSxtStZ5lK+oFTYPUDg4gEXdrWxbZylxat0/5Q
	 FBbqdWyJ2LptLgR4Y6XNt6DBrm1tOSZzPtrEaGYKcfcYD1FkrPQVxyo/GrGVn7BcAmjUs
	 9GKTjiGdwf80Xtzgo9rx7a/FhdG3aYSzIjTxwVgwVTL5U37Mc6BlHez587PCPHkK+udWn
	 BuLr93+B5yy+Xnh5fq2K4ecGOa/BVDBoR9GEhBr4T+OPmr/bSwY2Xt+BRa4awC4JNxgqY
	 Lsuv2Dcmzc521JJys/te9ebc7zA8M5r24c6u+s0grEfSdiQHjiLV2o2LrTiGfs3ADPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=microchip.com;
	spf=pass smtp.mailfrom=microchip.com;
	dkim=pass header.d=microchip.com header.i=@microchip.com header.a=rsa-sha256 header.s=mchp header.b=ThYvsDtQ;
	arc=none smtp.remote-ip=68.232.153.233
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9567B606A31A;
	Mon, 23 Nov 2026 09:00:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9567B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.a=rsa-sha256 header.s=mchp header.b=ThYvsDtQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1795424463; x=1826960463;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vVIT0KjQxjO+p+ys4Bw721gnr410olPHzZc14uULyqU=;
  b=ThYvsDtQwp+r566AhDWYFcHwQE+ofdFWmZRRYroQ4ATDfVHrSFHikScv
   QZgf7sbvuZFs6xcY3VRyIzdG4wWbfXSdWwYDSfck+YK6DkjtE+rzDIyur
   1EfllIzgEyzN3BHClSKd2uWM9makInbzQNqHi1kntMI4CEgkWjjNg8bdZ
   +7Ymdhv7Igz7/72/GbeTKl7etgpEeIdqNaBpQ5XDO3O7HlWFgA18gkVZy
   xQHxwX4bCAVJOdvvc8b80sjFLo4klIlh1yqM53tv1cX4jkdCScC6Gk7Hw
   6MaffLMfbkVgiCseeheVOMWvSfACeiwFy5p57Y6LvYrv2vAsp5wNQHncy
   w==;
X-CSE-ConnectionGUID: fjHc7KbqRG+GFgtrW5tWDg==
X-CSE-MsgGUID: idz3Yb9QRXKumrLi0BSZhQ==
X-IronPort-AV: E=Sophos;i="6.27,227,1787036400"; 
   d="scan'208";a="298321523"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2026 02:01:01 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.87.151) by
 chn-vm-ex1.mchp-main.com (10.10.87.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.57; Mon, 23 Nov 2026 02:00:52 -0700
Received: from DEN-DL-M70577 (10.10.85.11) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.58 via Frontend
 Transport; Mon, 23 Nov 2026 02:00:49 -0700
Date: Mon, 23 Nov 2026 10:00:49 +0100
From: Daniel Machon <daniel.machon@microchip.com>
To: Zhao Li <enderaoelyther@gmail.com>
CC: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Mark
 Bloch <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Andrew Lunn
	<andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Moshe Shemesh <moshe@nvidia.com>, Shay Drory
	<shayd@nvidia.com>, Akiva Goldberger <agoldberger@nvidia.com>,
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net/mlx5e: TC, fix a NULL pointer write in the peer
 flow error path
Message-ID: <20261123090049.hkhclpdiljjfptff@DEN-DL-M70577>
References: <20261118025708.86215-1-enderaoelyther@gmail.com>
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
In-Reply-To: <20261118025708.86215-1-enderaoelyther@gmail.com>

> The peer flow add path hands the duplicated flow over to the origin
> flow before it looks up the peer entry for the peer vhca_id. When
> that entry is missing, the function returns -ENODEV, and the caller
> then deletes the duplicated flow with list_del() on its peer node, a
> list head that was never initialised and never linked. list_del() on
> such a node writes through the NULL page.
> 
> Look the peer entry up before the duplicated flow is created and
> handed over, so that a missing entry is reported without leaving a
> duplicated flow behind. The entry cannot change in between: the peer
> loop in mlx5e_add_fdb_flow() holds the devcom component's read lock,
> and peer_flows entries are only stored and erased by the pair and
> unpair events, under its write lock.
> 
> Found by code review and not reproduced; compile-tested only.
> 
> AI assistance was used.
> 
> Fixes: 9d608a40c2d4 ("net/mlx5e: TC, track peer flows in a vhca_id xarray")
> Signed-off-by: Zhao Li <enderaoelyther@gmail.com>

Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
