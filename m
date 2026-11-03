Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793745298;
	b=FtNiJYmDaXUFe4lFXaKwA0OiTNuJaOPMAOPNDrqvlVuaPDd/cAsSUfjEoP37hSeWiz4z
	 zSXphXD8PyPR4DAcQJfSIyFv0vXcjg0E9LC9NKfFxJ3OVMLd8/kxonlPtfIa+1wExXX7B
	 7BbKHowv3yYraLPqQ6O9/1+xatu6lHwu2gv92AudZ6mDbN69L/Fb9s9JBYcRYyDIecHbx
	 Uu2f8DQtChJ/cninN8Hlw6nO1HBcFTJez1ECY/OMwLyuK6A0HVIUDkDoMfLRiy/KttrQR
	 zoULGezUjVEBCg5VDb+RcxxKoe8c2oYJma1HyC8NhQWlxqO8bbIB1s/jL3UqxO5irQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793745298;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1itHUEJ8pOmIrFb1dzkxeMswTA43yNK8aih0D9h+A/U=;
	b=e1chaJwHAnpp+jje0X74fBvOLHee/siMzAbBe3qo+H0o4yNjuq11eegaEpVH31rixc/S
	 HpRkhAbm4zvozlI/VUxBW8J2Yk7JdwRMA7viKUSsAAN0FHgtKvEQ8it3BJiQsPX/bZJGY
	 1IgrZ88jWfdACT5yZbRvEXfrHQxFgZOQ0Oo6XpwdBkNpX9NpQVovm5iyZW1MO4lVcZ2y+
	 kepb9SIX8raQvsba1t6UN6IGqffUgnq0B+65tpPjETcE7WvJLoKYwgABTNxg5mdbL5Vc1
	 7G7br44YTCJ3Z7mauHin0zQtC6lNTgvGFGy23u8cOB0RMDBp3RIEmrNaN/nbC5iq7VA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ke+4QIOv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2FE606A324
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 22:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ke+4QIOv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362211F00919;
	Tue,  3 Nov 2026 22:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793745298;
	bh=1itHUEJ8pOmIrFb1dzkxeMswTA43yNK8aih0D9h+A/U=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=ke+4QIOvLh3BZYKXaZxRJHXRM3M5ydCqxvyJII9POCvEI5lxbPEk1hxPx3Yt7Yt0B
	 pH/qXB/0bLzXVQxA0VjulKifZLKFkQPJJb1JIGYeHIfyZixj56ZI0uzxqh0mCk6Tpp
	 qfzdEXQEUGLyYR6q1rFw/Hgp2i7/tJmrSpXXRoXS5gXJD4RrUWUIWELCp59f7/sGgu
	 admivCBeLkMLuYIT9zc7k+jNjOEW2nSlOQaTgq2wDem9ulah/1cgp+V47Okclq3tPf
	 UNW3Ph0mtq+pkyMWGUsgITLI/6Dbm++GvUd9Fo2bkuI/MPac2zCY0khpJy4+4NSsWP
	 NbufwVVi1oWjg==
Message-ID: <sashiko-outbox-196129@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 04/15] RDMA/core: Allow optional access
 flags in reg mr ioctl
Reply-To: sashiko-reviews@lists.linux.dev
To: "Michael Gur" <michaelgur@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261102223325.2115128-5-michaelgur@nvidia.com>
References: <20261102223325.2115128-1-michaelgur@nvidia.com>
 <20261102223325.2115128-5-michaelgur@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 22:34:57 +0000
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
> Add the optional access flag to the allow-list of dmabuf registration
> through the reg_mr ioctl. Uverbs users can now request any optional access
> flag on dmabuf registrations and mlx5 will apply the flag's effect on a
> best-effort basis when supported.
>=20
> Fixes: 5b2e45049dc0 ("IB/core: Add UVERBS_METHOD_REG_MR on the MR object")
> Cc: stable@vger.kernel.org
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Michael Gur <michaelgur@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102223325.2115=
128-1-michaelgur@nvidia.com?part=3D4

