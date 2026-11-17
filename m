Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794932178;
	b=Vks7gRFx1gj0ixS9OySrlxNGnJ//MG25FmVLvSRyz7y5zmg1UgzJ+HD+yaSXGrxRPQP0
	 FYN5qrqzdOLGgIc6Bv86CMOdKtxBNFrR+Dp7K+cjn6EL9UOhG2cFJCyu/HJfPKDgxtesB
	 KpqiVR/KAlXvHG+NmAo5JME7j1zTfEWZaZArk9dlPrGV4qjgeibIsvV35PlEEH5kKS1e4
	 jOpNfduDwN5qk0ROkl50nLlqifrXqYkdX82VuY3/WUdxD5/4cTTbRT8DRAxZQHQx/ts9C
	 8/fd4aEw9v2289sfsIHDlKA5PWFUyvAkcixeDfGiaDZLgRHd9Z1mhQWhz8smWBwRbvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794932178;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=TkoDYaDWM82iomKI+S7UvJWzRNifdKWleLRH//J8pmM=;
	b=l7mfcM9l+Eq+2ffO6KjzMAcDvWKK7ZbYdF1T+Nfr8VP/7RPqiyOOR0tSkY9WThMdhEkv
	 Mj4YEHWVA9TkpsvAYXg5n0gulMWAPdVhfHZ+aU4bD5w1W7AJ3bYVyVzih2UFMEpphXBcO
	 n20UjTUmwyAsXf2ZNmlTrDBeY3P4UqxactDxVklkce8cg3BxyFFJt9/e6rKpV9NoRnTbn
	 WJlF0yV09IFLc3IBYVOaWmekRW1jxVzCI8CC9EGzAeXdCG+GQwDpf/41OYxD3S2GTOfiG
	 L2TQbw+O0Py0HO3phIqaCgmL9F0iCwrETFCK78M3jgypZOzVzCTw2TA4zx0wuz8kxjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="HU+EXn/5";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0DB606A337
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 16:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HU+EXn/5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A52F1F000C6;
	Tue, 17 Nov 2026 16:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794932178;
	bh=TkoDYaDWM82iomKI+S7UvJWzRNifdKWleLRH//J8pmM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HU+EXn/5TGT/iQxcQEhh3ft09JhibgCwxks3bXrWENXb0oOdHAE2E9wJ6+i0zfDaQ
	 W9uJI8tPrz7KJfDmzB+poTHXUihnrVhZnR4wTV3aL9k0K6TXaDluV/w7oolA8Tqzf9
	 s+PBTitJPORehFS6XxErMBQM21LKe4Wzkz+hEFYtfVTdPe0Mazm0dqnUF7nDRlpKeU
	 kZ1xHhA1DHxZjNaMXMl3k0C7p2v7D3d8+auLVELvJzCRkljvmc0lgAdW5L74vz9olV
	 T3ZO/TatOtPFNI8XSKCjr8zbihrlSOxGnen1Y0VI8WHcuOEdS0O9ILH5yDxmEloqJN
	 fNjZyNfLuHUVA==
Message-ID: <sashiko-outbox-219151@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 4/5] net/mlx4: track whether a TX doorbell
 is pending
Reply-To: sashiko-reviews@lists.linux.dev
To: "Joe Damato" <joe@dama.to>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117155353.2250540-5-joe@dama.to>
References: <20261117155353.2250540-1-joe@dama.to>
 <20261117155353.2250540-5-joe@dama.to>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 16:16:18 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> When the stack sets xmit_more, mlx4_en_xmit() skips the doorbell and
> relies on a later call in the same batch to write it. Nothing records
> that a doorbell is owed, so a path that ends the batch without writing
> the doorbell leaves the WQEs posted before it unannounced to HW.
>=20
> Add ring->doorbell_pending, set when the doorbell is deferred and
> cleared whenever a doorbell or a BlueFlame write is issued, so such a
> path can flush the deferred doorbell.
>=20
> Place the flag in the cache line dirtied by mlx4_en_xmit(), next to
> prod. That line has no room left, so move tx_dropped, which is only
> written when an skb is dropped, to the end of the struct among the
> fields not used in the fast path.
>=20
> Signed-off-by: Joe Damato <joe@dama.to>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117155353.2250=
540-1-joe@dama.to?part=3D4

