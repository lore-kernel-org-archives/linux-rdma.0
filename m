Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793745297;
	b=ilkuzOvO0fWCP057IumDYeG2IEdQI+SspsEmWcRUdWYefGuNgbvqndoe5t4Mf66TDAzG
	 K9Qr8drWud5DCybI3HWLnL2+1je8KWk9WKLkagtSAstf9Gq9NJm48SIFG5vQR3LZS7Mgi
	 FcfY/TWIZb3vonvloVbbwywmqQBuRexXBHA9SCsM4ci/2ulU9db4gjy2UgMKwELGFl+KZ
	 aaJTX8gEjWBvBRSourmxGup4E6uvDkxkTLbLSJeVYBBZA8gDYKkrqD0xkpphLCUpe4Ga9
	 SYqAY1Vdg7Zo91imhyAuwckk7JnQ/+0dMfIkcth5nVVf887RYu0WxgGZPLQY/nfrXbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793745297;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=/KmlW4DJiEx/Mj+CD6XDZQD0O9XMckdRnzeDHR7l7Q8=;
	b=KaluPzqU8+des1B7rqeoZmK2qjIOLX9Kmfw1J/uBIpJwldFLQs9h3v3Q11VQvq97BHoE
	 d1Q7W4ESKJj4iolv0UU1Xp9EqLQbkPyhfFrC589bxD3W73EiZPJ3EADgwoUJO+m92LkDA
	 QExBXP5mG/s6EdsoXoHmlK1EPdqNiqTocmFBWeC59nrJ5oYP+0JKSHUt8rNjcX1hqv68Z
	 9kDSQsdSpupSzi1ZEjb6VzhMsjQZHg5XNKKtu2xbv6sAndVuWSBY6AhV60OFy3oaDe5g/
	 aK0HWsQE9QVuZHhZj3QT2+Q7eqbHz4UPLxuV2hL4NM0W/khpUrZKFcIEH+cRuO+G8tQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Da5kz+dZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B498606A329
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 22:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Da5kz+dZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8F71F00919;
	Tue,  3 Nov 2026 22:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793745297;
	bh=/KmlW4DJiEx/Mj+CD6XDZQD0O9XMckdRnzeDHR7l7Q8=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=Da5kz+dZ7VVsFEV7yJSH144VPwy7Yrf/m8ut8/Hh5hdBMOCQyyBwJ4vlbEjWc39LR
	 FoFKAeYxmmxWA44hLiGrHR/JMilyHglLg2Yr+4jAiOGhY+bOqhZWKJG4o8cfOC252U
	 K86F9Ep+XNusgFkQi682ZH9XGRD3mu8oUIW/lC8qWeEs8KPrW7BYQEurBqf6JnOoXB
	 ZZxCUjk++5yLLMog1y/QB4cH2SZziysIs9AgSP6B0OoDwSFuC9mVkDAVjw1Obe/idZ
	 OOtpsijLo9Y50kfczSceyuf1n+YqDnz3BLzFDq4orh32QMSJd73tIRCQKq//YNrSrk
	 bVowJ7BOvWLlw==
Message-ID: <sashiko-outbox-196127@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 02/15] RDMA/mlx5: Allow optional access
 flags in DEVX UMEM registration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Michael Gur" <michaelgur@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261102223325.2115128-3-michaelgur@nvidia.com>
References: <20261102223325.2115128-1-michaelgur@nvidia.com>
 <20261102223325.2115128-3-michaelgur@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 22:34:56 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> The uverbs ABI reserves the optional access flags range as best-effort:
> drivers should accept any flag in this range and treat the actual support
> as opportunistic, never failing registration when an optional flag is
> requested.
>=20
> Add the optional access flag to the allow-list of DEVX UMEM registration.
> Uverbs users can now request any optional access flag on these
> registrations and mlx5 will apply the flag's effect on a best-effort
> basis when supported.
>=20
> Fixes: 72b2f7608a59 ("RDMA/mlx5: Enable ATS support for MRs and umems")
> Cc: stable@vger.kernel.org
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Michael Gur <michaelgur@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102223325.2115=
128-1-michaelgur@nvidia.com?part=3D2

