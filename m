Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794311412;
	b=f997JQhwEceufhtaGLkvxhnRJC6o32LpaVTrUrrUH7Eg2TR32CdtUJ+/+NlOaiXxa5LZ
	 nYxe9k6yE8C4JYN7qvaR9EbQeQIvG0DocYhOqrcAZ/PciBgEaVNzqvVzc3gm/xILDLlpj
	 5Ko83PbGjzNy1tmR/aFBeGTslUNV+5eezEGjmZBf21xPsd4He2y8gF+6jUG5OTVB1Xdq6
	 azLto1XkBKC7MObAkmWwvgAX/mhgHnovulg3gqcAWnuXLflfdc91qx4gJxKjpEPKUw46P
	 WL2/fkLqvnvWkq2GdvNATzfj9MzIlqdV8Lrav52iAV8oY7uQx9DqwFTUDpDBcHzxhRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794311412;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Tk/gO6WIVfp+pl3hSlTPnMGz7CTr8yGUyUVSlWHQYyY=;
	b=cB+Yh1KK3rSdMb8rBqHqUX0gWWuYoxT/XpPHvNWbS5Y348Dj2q3t+4GDeEevxmDtGePG
	 02CRUAkUrcLs+Q0HqBrw3Loty8ApdgDQ6IBBvUND5UPfEUGgMruXe2Dz3a46LLEw1XTpU
	 ewnW36n2Hv5EiWA5ZQ7kGXD3f3p1/S2eH28FbsfYmGX9Q0loGeQdnbM4cxai78ycdN4j/
	 7tMXWdrcbut5n3hxXAQPji5fR08BECz2V5QjWeoFnJOTcshwIMlbF/jDfgll/B0S0Czvr
	 zUaDmpPLlW4rjnIaw7z/XXQuj30Vle6ePk5ffaXbQq83NRE4CsjY0wKSus0WFIA/mYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="QwuDJx/8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7125B606A9AC
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 11:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QwuDJx/8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12601F008A2;
	Tue, 10 Nov 2026 11:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794311412;
	bh=Tk/gO6WIVfp+pl3hSlTPnMGz7CTr8yGUyUVSlWHQYyY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QwuDJx/8UAiNjr/HZYl1Tr8XCBe87pk4s2k4lNUtp9GbiwjvnYzSQ5rLdXTSdPny5
	 rvCllc9eV2FqBrLYXp+VHB/wsgmfNJjulxZkfuXJSUmTsZpMWo4wa08ncPxdfMk6zC
	 tlm7DJyix5eXEflUFgpOV96MuM1f7oltClzSRadoLoiwolz4lBPnb2tzbdPPXft63A
	 CoopVeXxNJ19IuXXU7dY+A0qsAPMRN947YazryM+Iyv9PyInt+rHIlJ3G2keY5OvSl
	 o6H/UkYXGKaP81natKKd7kt3Y/K0S4ppe7HjGP4a8Ji/IiultLkEZLCU7qsL7NQ8pS
	 lTA34MjInKkcQ==
Message-ID: <sashiko-outbox-206955@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC net-next 3/7] net/mlx5e: kTLS, Post TX context params only
 for skbs that use them
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261109114734.2087878-4-tariqt@nvidia.com>
References: <20261109114734.2087878-1-tariqt@nvidia.com>
 <20261109114734.2087878-4-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 11:50:11 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> A new kTLS TX context is installed by static and progress params that
> the driver posts for the connection's first skb:
> mlx5e_ktls_handle_tx_skb() posts them before it checks the skb's
> sequence. That skb may not use the context though: a pass-through skb,
> which ends before the offload start marker (SKIP_NO_DATA), e.g. TCP data
> that was queued before the socket was offloaded.
>=20
> A pass-through skb carries no data for the device to encrypt, and is not
> tied to the TX queue of the connection's data. For example, when netem
> on its TX queue delays it, skb_orphan_partial() releases its
> sk_wmem_alloc charge, which lets the socket move to another TX queue
> meanwhile. The params are then posted on one SQ and the connection's
> data on another, with no ordering between them, and the data can be
> encrypted before the TIS is installed, e.g. with the key of the previous
> connection that used a TIS from the pool.
> [ ... ]
>=20
> Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
> Reported-by: Rishikesh Jethwani <rjethwani@everpuredata.com>
> Closes: https://lore.kernel.org/netdev/CAKaoeS1hj9XuM7ojLBCjGA=3DEXc2M-b+=
eRjC2Sk=3D8L_8XYeJ18w@mail.gmail.com/
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109114734.2087=
878-1-tariqt@nvidia.com?part=3D3

