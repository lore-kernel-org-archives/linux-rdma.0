Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794948580;
	b=hqz5X32Z4RRPVktKokYVObgMLj5237xCa3IUUrIbt+BW/q/TaF9dKK96MVwxeCLDBjGz
	 vphIlTvsjIVR6iZjWN0dotNF5zFSgeOZC2VfS0MYuVYBBe4VOeWR6EUpjbp+AqDy9DdaX
	 teFTkH3gL9FFcxLYxX/EF3Zr/H5cCaiRrPe9bR9jQgnx265wkJnCK1Ico1eUyvZ5BBezz
	 jrXGo04CZNwAKoutIR0rHoRT2X9xkVqyp8A895oSP2M5N8xnl+YSb5+/dPBj7thECMSlj
	 IHPbDOpkAeDA9dzTHtL2NlwG3K0S4G7PHSXaVXDANks5M7XDWVrHuga8M7fInh1ZIdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794948580;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=4w/7hbbpJHjY8ogZuR/rVb0ilrFC2OI0G1RZ+LkC2dU=;
	b=og5IBNNA7bnrth5VWuny01BcK4n+x3ltSNiJfkx2JqwGqSy4HzHHOVGNTU6O2rj2IGcY
	 srWrwBp3ounHUpV9RXuxfht9WlEkHYdpcbOVu6magsSJeQZnqxnL6hWYupcAagAdzyIcc
	 YLSnbgXZd3LvvkGVRqqz+pzZ6XX7N2otS44chWx8f4rjCillxJt8uk5ZhAfM3ZEraXFSF
	 vN9yWD8hIrET7rbMnp3+BxHVlPWnaemscAWsQIlvCZMbTMrU1SMIXY89YnyuAAl8ajsSs
	 VnwpDRL3iuZ5HR2G2cThbhyypYEaPXWl2jHfpH+V/6X7ZFAi+poDw+K7OKZ8IPMaDIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kDxk5ycq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E893E606A330
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 20:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kDxk5ycq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF3A1F000C5;
	Tue, 17 Nov 2026 20:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794948579;
	bh=4w/7hbbpJHjY8ogZuR/rVb0ilrFC2OI0G1RZ+LkC2dU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kDxk5ycqR1Ha3q+SxC7c43/fCpOzy01lx9Tt4xKi7iihGvHFg1ptgX2ym2r8QU2a1
	 pSSUkv9HAE5OkVa0y8jWEgNxONBH4aLAf7rIMSoyttXEshN2zExPPXMT7eCPtJpK+T
	 BLiwSzLFk0C/4aD8qMfknlhrbFVqt2PV0gv2qrW1AkrYQdAp2MB6VOTTD63SgnN2QX
	 rVAqGBVuf5FTfxwH8yqFneTHr0PqFSzKTMECsxvgpAbluMF5++OZRIPfLKg9Ce/jPF
	 YnmzV7tguiEInIzT81/HLckD6pPsw1587P3+I58BBoOWSf3FTad++bpOcTn41wdXqp
	 HdZ6YSvOjCrZw==
Message-ID: <sashiko-outbox-219651@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v6 4/8] ipv4: icmp: don't quote decrypted payload in
 icmp errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117203137.804424-5-toddfreed@meta.com>
References: <20261117203137.804424-1-toddfreed@meta.com>
 <20261117203137.804424-5-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 20:49:39 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> an icmp error quotes as much of the invoking packet as fits in 576
> bytes. if the device had decrypted the packet (as indicated by
> skb->decrypted) then the icmp error is sending part of it back out onto
> the network in cleartext.
>=20
> the two offloads encrypt different parts of the packet:
>=20
> - ktls encrypts the tcp payload. the tcp header is in the clear on the
>   wire, so a quote of the ip header and the tcp header, without the
>   payload, would be fine.
>=20
> - psp encryption also covers the tcp header. the quote could include
>   just the ip header, but then that's not really useful. linux receivers
>   want to look at the l4 layer on the quoted packet to look up the
>   related flow, so such a truncated icmp error packet is just dropped
> [ ... ]
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Suggested-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>
> Fixes: 784abe24c903 ("net: Add decrypted field to skb")
> Cc: stable@vger.kernel.org
> Signed-off-by: Todd Freed <toddfreed@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117203137.8044=
24-1-toddfreed@meta.com?part=3D4

