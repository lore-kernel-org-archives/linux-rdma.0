Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792799747;
	b=SB1QzM0Cf3ZmpjweiTtYGjReCOJQ0OTDRkunap2zAHpEEKB+17zxb8upehyuouMvD9fS
	 UIc90miQmIhavQ0djQ3ezYmHz3LUSY8QfbERpIG+u9Acwm4CN2jnzHJL5Y/rXlt7XltGK
	 TO250vjRhhxUVFMOkjGMuEO6KVO0P4w8F3ENU7NJ4A65Yc0zgce0JSwre/T4cWPoM3QY+
	 oMGMi4waeKv6fQQ8aiO1DkbBI6iAMlm4QMlDKkFmwbjVjkvzfN+U5eMl2tKxjtvbCVozv
	 enrfEZGBLq0hEHzp6fClUwL06DqFVb3vHSSQWw9fqZkzDwv0zH29378TSL1fimmaFSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792799747;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=sQMOzXlwis47fVrtfGiCkG4l9vLWXRq77JzVAFDOgr8=;
	b=amYHq07aFt24o59mVOMOkHhQJIlyLBFlb3A1ThpYdUgN6u1q3P0kqKfxbF7lZLxhWRNo
	 qF9GkQfrPNkR5ZOpStBqXAPCZcGa5htI7IVtIgWNeU99rEYrUZsvrT4l4VFSHRluF95jx
	 82LkEL9gFAGRWqRsh5/y6hR8+btXBm8q/lpMp1/yTg1ELtB6dT31gX7dl91tDAnVgkK/f
	 gIvSaivIVB/O7oOh0oJykvKI22488EL+W7Pl+r/NjLZaLdrSHXdKEUEQKLQE0t7NGnqgx
	 RrTqHkveqLnC1XZyoBqVeHippZnZN7jfcn4LQCoCAa9yyaE9Llif0gyAXrBlzfoOTHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Jvw/ry4n";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58E4606A320
	for <linux-rdma@vger.kernel.org>; Fri, 23 Oct 2026 23:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jvw/ry4n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F241F031E0;
	Fri, 23 Oct 2026 23:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792799746;
	bh=sQMOzXlwis47fVrtfGiCkG4l9vLWXRq77JzVAFDOgr8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Jvw/ry4n7WXC0dlDCNx9nJwRoP8WscHGqfN4+UCkHTX0L1v/3igJbUPvTOIawHT6t
	 NbVnQJkYeh1uDQ9YkMU14JOA11BbKcYZqN1Ap24oPX0YM4L4YIcHg/zt/xrZYDfM72
	 jZQ1VtHxy23OriNFX6jY8iPsMQucrFmPJrbvV2+QNz5m1Xu5YgaB8DjZzfMQI5qP00
	 MYm9YwliIv3CeGwkeTU6QjT59c4GIeyHb4vQdZwt1ZI8g6MdYxCN+5ZYs557ChB6bK
	 xmRC3b58du+8heURUJ8QiaTez3Nsz6uZx1Cdc5NWJAzEpYBnEXn7gqllZSG+48a32K
	 U2vM6R1xplTTQ==
Message-ID: <sashiko-outbox-183440@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v3 2/4] psp: support ipv6 extension headers in
 psp_dev_rcv() decap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261023234640.1459291-3-toddfreed@meta.com>
References: <20261023234640.1459291-1-toddfreed@meta.com>
 <20261023234640.1459291-3-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 23:55:46 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> psp_dev_rcv() expects the udp header to immediately follow the fixed
> ipv6 header, so packets with ipv6 extension headers are dropped by the
> is_udp check. additionally, on decap it writes the inner nexthdr into
> the fixed header instead of into the last extension header.
>=20
> fix by skipping the extension headers to find the udp header, and on
> decap, setting the inner nexthdr on the last one.
>=20
> fragment and authentication headers (ah) are not supported in psp
> transport mode, so such packets are dropped.
>=20
> Fixes: 0eddb8023cee ("psp: provide decapsulation and receive helper for d=
rivers")
> Signed-off-by: Todd Freed <toddfreed@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023234640.1459=
291-1-toddfreed@meta.com?part=3D2

