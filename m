Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795676397;
	b=pX8VWNFjkR0x4DvG7daWP73zLxHQJPbfeJP2WrUjH2EzZ9j43O/pxBVXpYwltFhaRiML
	 6oDkiD0FNwapqpJn0sY/Yoec62AU9peEJsWS7aZJiDh5Vfv1M/obbfmBqH8j+caUKn3dh
	 89xN9G7U5KFqPDp/ajQr3ou14xinu0jSLZHmahIXlRDiG1flw0KyVOP8zSgqDE4jORHmV
	 jGoC5xbNvyLF92DkrWYKxkLOh2DZzHjYbG/mrkbhmtu7IpDeJnfs/pk0QTjpTGZdHEFA/
	 8BFJYFFnGSeSSAeAs/bEpa2ZuTJaEW3yGBT19aNANJqJCwI1vi45vWrGZhNEcx6bOCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795676397;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=3aFMoAWcUYdXEggHBJ6yxEgsXT7Dt1rVA6UwaU//2oU=;
	b=Eialq3GEU6Dn1h1U1qEaaY/HWrwimrHUXbaU/w+Us3R5ZPeD0w07MiKU5KJaAcSu3pl2
	 2ZVLpUVDguL6OLtszR65Qzb2Q6/HqOOD0ba0vT4CyJvlgtWiCvrn9mgf0D+ZRwhmlDERE
	 ZVAomPgXLaREd7ctf6wG9yTiaTUw9IOAvoh9pSCNpEpkSWroigjgwfo5pVVSKrUfzVFYJ
	 18JZKHIB3HHKH/VNujgHfcnW/mRNdNBcgcazS/J0cFkHp7lgA+TFqTfZ4EVFfyG28XV4z
	 wOZIDX27J4utcKGmmdaL5M7RnkJU/ZHfWSD0R71aaeMioccOSvCgS46FAhwKS/fdjRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KBF7CkNL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A9E606A31C
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 06:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KBF7CkNL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5140D1F000C4;
	Thu, 26 Nov 2026 06:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795676397;
	bh=3aFMoAWcUYdXEggHBJ6yxEgsXT7Dt1rVA6UwaU//2oU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KBF7CkNLLzpnbCxN3sTnQorXCZSHqoc9HZt205I24tj6YeofAyysTA6+rmzgWlgQS
	 X//gSWIrzHX9hDRmExLQwAT/K3yAoEjXIBYOP0cyazO81cXiaSmnLuiO3J9fGX3mSo
	 w5OEBOJHTZM9Qfl7J3k2n3R8Ug7IoN0/PlHp0+3TRj4zxigz+BXRGLub66UnnEhI70
	 6HvnqNVFAy9haGGpPwPwfnAT4lStQEqFYPmrb85jWBNidqFMrFzulJsL85yCG4o+ti
	 DTEaVr202CCm3BVnoPjOJ6v3IvdqLkNwJxb2n6OuEh4ktuJLoZbnXPfKXC7xb/2RXr
	 La50M9Dzg44ow==
Message-ID: <sashiko-outbox-234921@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] IB/ipoib: re-lookup mcast and pin ah across lock drop
 in ipoib_mcast_send()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QmluIEx1byAoVW5pdmVyc2l0eSBvZiBFbGVjdHJvbmljIFNjaWVuY2Ug?=
 =?utf-8?b?YW5kIFRlY2hub2xvZ3kgb2YgQ2hpbmEp?= <luob87709@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261126065125.1082-1-luob87709@gmail.com>
References: <20261126065125.1082-1-luob87709@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 06:59:56 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> In ipoib_mcast_send(), priv->lock is dropped around ipoib_neigh_get()
> and reacquired without re-validating mcast. During that window,
> ipoib_mcast_dev_flush() can unlink mcast from priv->multicast_list and
> priv->multicast_tree, and ipoib_mcast_free() can run
> ipoib_del_neighs_by_gid() and ipoib_put_ah(mcast->ah) before blocking
> on netif_tx_lock_bh().
>=20
> When ipoib_mcast_send() reacquires priv->lock, it can attach a newly
> allocated neigh onto the dying mcast->neigh_list (leaving a dangling
> list pointer once ipoib_mcast_free() calls kfree(mcast)) and access
> mcast->ah after its reference was dropped. Furthermore, mcast->ah is
> dereferenced after priv->lock is released without holding a dedicated
> reference when neigh allocation fails.
>=20
> Re-lookup mcast with __ipoib_mcast_find() after reacquiring priv->lock,
> drop the skb if mcast or mcast->ah is gone, and take a reference on ah
> under priv->lock across rn->send().
>=20
> Fixes: b63b70d87741 ("IPoIB: Use a private hash table for path lookup in =
xmit path")
> Signed-off-by: Bin Luo (University of Electronic Science and Technology o=
f China) <luob87709@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126065125.1082=
-1-luob87709@gmail.com?part=3D1
