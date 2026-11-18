Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794994191;
	b=IYzCcymsgocJ7atBCOMOa41H4yj0hN3DCGFcqpDARUe/3eD/JJuqfvXVLj3TrPCVHvZo
	 SKdmbsCeevioJT67mQnYkJFU2g26KvjdkDDbkuEV2qshLTeAx1eNaPWhRagHYh5WYwSjN
	 Ism45KHA2fsICT+rHgW6AntSo5qU21bKVfQVxbxhMngth2C0gZaGOb0YQrkOUffT8YihK
	 dm9zTSWhkAaj/OcZvZNY8v/GusjrBT3wlKJjf84oh2Ba5mwn4dtYU8+KtOx1qBlzqkM9h
	 GL1PBgdFlS1j7UmaAoFqZW1f17fNh6nGyV9Pvv3KTNsCfbBurCq7OQsmGA7ZXUgjIsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794994191;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=45+D3ZH9qGXMbdSYFPFhw8ngsNP46/II3RJXcHhb7+s=;
	b=RV5b8+Z+SFWO5UnlIPVvypZxU39lS3QhArj7ILXL7Nv8Vv6aW5zdmCWpBiQewS3q4GKH
	 5VtCeEdZ2xQx4/iWjFa9rL/uxPgZtWVw4x7O3gFzEtbQqsRXcSPtPhb4IgYAkZQ9X6QH3
	 OIj+y7rsL7a+r1GISMJAJ+P74isxPNd6f2URkDFhAkWMmC90lGhang05P/ZHzrA+uG8pN
	 2jJWb0cNaDshjPADjdIBmc+rQ9EDxV2kh27CAMT9CdH9SYAdNbOEQIxz/Ipw2+GiGRckb
	 vRvYAFhPa/q1g870LXgo3VJ8AtnYNd8ghYbGsAq6OPfYQEX/GtPoDsJwJV1aHvx+VQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AJVqjpSL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B9D606A31C
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 09:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AJVqjpSL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F72D1F000C9;
	Wed, 18 Nov 2026 09:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794994190;
	bh=45+D3ZH9qGXMbdSYFPFhw8ngsNP46/II3RJXcHhb7+s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AJVqjpSLpdwVAo9EGzhLNBNaajQEzrkiSkTTX/0Z0xdYFG6pM37F6IVQwK3OIxecI
	 S9AvKpFt7G5bBzNDnLKil0qTVWtTwJ3IJNtEejHGBfRIglEqbLrfBLrMlmfFlI8+EH
	 S4hyqFuA9ZfYZPYxmntIbU2Ri5qTKG4ljD145LpeP+XGK5CPbzIhxzlaQEKaPGHptN
	 7wjSr9EyKZ9OV6GVin319ahnIMXiMfgGO6T0SuvkTdNkC6WXtrncejZ92CLA/q/jjF
	 AQYUiSlCG9vmjOjz3bVbAF+gpVaiIEh6pm1APJoXihucH9VXMWvNRSj8ptT9nPNAFV
	 qUv3Ga+WsjCkw==
Message-ID: <sashiko-outbox-220563@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 02/10] cxgb4: flower: refuse a tunnel key
 wider than the VNI
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandre Cassen" <acassen@corp.free.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117092915.255194-3-acassen@corp.free.fr>
References: <20261117092915.255194-1-acassen@corp.free.fr>
 <20261117092915.255194-3-acassen@corp.free.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 09:29:50 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> cxgb4 holds a 24 bit VNI and truncates the key and the mask of enc_key_id.
> An exact key above bit 23 already selects the wrong VNI. Flower is about
> to accept partial masks. A mask that only covers bits above 23 would then
> clear the VNI mask and encap_vld. The rule would match any traffic its
> other keys allow. Refuse a key that no VNI can match and a mask that
> leaves no VNI bit.
>=20
> Found by an AI code review agent while auditing the users of enc_key_id.
> Confirmed by code inspection. The wrong match was not triggered. Build
> tested only.
>=20
> Fixes: 98f3697f8d41 ("cxgb4: add tc flower match support for tunnel VNI")
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117092915.2551=
94-1-acassen@corp.free.fr?part=3D2

