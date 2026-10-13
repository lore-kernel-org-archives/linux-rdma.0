Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3BE3A544D
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 08:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879733; cv=none; b=BaVCd00L6LqPxlJf4o6xKfZXaFSHnXQbZ/8MUXJWtbfhbaNRo+vM6Xbb+Y1HV20kZnyR43I7zSQGLNos7NAYYLGBpqrJY2ufnkzhqzScQ0wnRlzXv9kDyXTLEfR5IptkYal60pVLiHDh7ucVy4NFzyHctgCzWw7AoeocX2MTKKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879733; c=relaxed/simple;
	bh=ZOpOb+MSR8jPjOLorTNPG0z10bhnWdIhWtXADF3We/w=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=I+iExFTYH64Zb0ln1mSfosfEjWBR9o0pgiDNiR9WwOFpgVJiEAA8ue6smfuKro5lakT0FAF/+oo0sUH7C00NAlvmMGgLZqlfmEj2PyStPzvyrJIYg2nCgPjMjpZS2d26upCPWMkudnxnZxHhqAI0T+4vg5sDy2mo5xyNiJ48tZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h56EHdOi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h56EHdOi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A701F000FF;
	Tue, 13 Oct 2026 08:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791879732;
	bh=ZOpOb+MSR8jPjOLorTNPG0z10bhnWdIhWtXADF3We/w=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=h56EHdOiCF3dxooVlBw8fn5WDi4gBN8mTKd86/FVh05pi2BYCCm6HyZfPGAy+CfnU
	 F/Sv/Z8IMHupL6xHM/PeBufL4oE2GtjSmO6Ae7hoK+FK32WcjNmuYI9Sqka56I0gBu
	 RIy1cFUmtREzQygXxGRAZu9fFijO+91QpZgC2R4ugv/FtQyzJWsph0PSEtew9PXTKL
	 LsqRhpUaM+xMNQtS/P4J36r3FL22OIeXUXwztYnR11nTSHsyNEamrHKr1ZZKlHhtNX
	 DW71oGiuwM5iZBGxTvoGXNN5m1uuLNyZdWPa1vxxrGbhuXbLiOl6+2SC2vlzTrhvLq
	 GUg2A7o5d2tMw==
Message-ID: <sashiko-outbox-169236@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 5/6] net: skbuff: use skb_frag_ref() in
 skb_try_coalesce()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mina Almasry" <almasrymina@google.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261012082148.1698596-6-almasrymina@google.com>
References: <20261012082148.1698596-1-almasrymina@google.com>
 <20261012082148.1698596-6-almasrymina@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 08:22:11 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> skb_pp_frag_ref() was introduced solely to work around skb_frag_ref()
> ignoring skb->pp_recycle and incrementing the non-pp backing refcount.
> Now that skb_frag_ref() handles both pp_recycle=3D1 and pp_recycle=3D0
> symmetrically, call skb_frag_ref() directly in skb_try_coalesce() and
> remove skb_pp_frag_ref().
>=20
> Assisted-by: LLM
> Signed-off-by: Mina Almasry <almasrymina@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012082148.1698=
596-1-almasrymina@google.com?part=3D5

