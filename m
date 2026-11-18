Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022034;
	b=FvKHfY/IxJXhlKm2KDvctHc0FxbLs++YNG2mRYshSVeWhPHR2ClIG6PVtYik8vQy+XkO
	 ZkQeHOavGDuaZeD59OhNJr1Qn8cqYfrNbzKblV6N07d8M9Tm1vrBtgWobSu/D2A966vpq
	 cHFUTRZD9gYuGGVsYcXeop15uGcb4jSv/3lTyRHhnhUeHWZhKGfhKc5SDZnnEgJ+uw9Yg
	 1+6a1iAFMbA4Q4MafltWyI5az4dw0uDa8AAIA7OOF8tAAw0Rd270LbgONYzsM+qN8CO7Z
	 iZCMBnnv7XwGLJf8iVHgK0aHBy4SQYbmh1VyxCxmPjKXpC1pE997KoO5pzsHsnSoG8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022034;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ddLuKQ27ahQx7oRBBDAeBTPPOswmXfJHzvjiKueAhJI=;
	b=AoSTeFKgpotbHcqlHFl8XkEI2bKf+H0KOEQa6h7mwipa2nKDYu9WtUibSveyQfhIDNlr
	 ASrzwRJKAefpeX9c/ecVxmESJ3rCPxHxdYkEBkpVtLiJG3oyKwLum4x9NoYiX4VnslSC9
	 jLrM+Er5CR0AFpbJ9FDMPNXbFJm1NiTb5nExMI3JT2+16sljIFxXfW/hRsidHX3hbjKuy
	 9Vo9eQxKT2Lcm4nCGY1x6ZKTmrUOgzv7zQZhzsM5QholRU9d5zlzoIzU+C37kmScW63L1
	 Fv9OGHg8Db+XpFmWhr82JHvbzf3Pl4Q8RJQrHi6taWIcTwHxBRpJX3gbxNqblr0oFrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Qcd/8mck";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F34F60A2617
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 17:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qcd/8mck
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA9B31F000CB;
	Wed, 18 Nov 2026 17:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795022033;
	bh=ddLuKQ27ahQx7oRBBDAeBTPPOswmXfJHzvjiKueAhJI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Qcd/8mcktulYapsmg2omWmWnu6/ZwfWFRkgfK5kBAwAMN71Wc8ePfejR5CHNFRk4f
	 90S6DAntTiFq8QSWvdtFnCjajrekYxBvYy3RmXVXIruovr4zrgqrxOXJitCjhkjNn1
	 fXOdtbqdvZXNvAp5QJ224fPnEZ7VzynH4NSM+IxuyD5pgjpvPMA9bzIuHLyuglDZnT
	 63zov8fkgNwbbcE+4TgvVIXEIRXJTv+7XmBwDe+IJw/uZswFUVwarpSFcqvxZ0O9S0
	 mTlM4ZXfUMPNWlieBT0LjdMdO14s4iDRmv5pCu+15TcB2U9gxRT6qk+F2if5e/iNx0
	 rsW3syONS2TeQ==
Message-ID: <sashiko-outbox-221621@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V2 rdma-next 20/21] RDMA/mlx5: Clamp log_max_* shifts in
 query_device and ucontext paths
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117170914.27410-21-yishaih@nvidia.com>
References: <20261117170914.27410-1-yishaih@nvidia.com>
 <20261117170914.27410-21-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 17:13:53 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> The device, port and ucontext attributes and the SRQ size limit are
> computed as 1 << cap from log_max_* FW capabilities. An untrusted NIC
> can report 31 or more, which makes the shift undefined. The same
> applies to 1ull << log_pg_sz with a value of 64 or more, and to the
> max_tso computed as 1 << max_lso_cap, which can be 31.
>=20
> Use MLX5_CAP_GEN_LOGSZ_U32() and MLX5_CAP_GEN_LOGSZ_U64() for these
> values, and BIT() for max_tso. As the limits can now reach 2^31,
> compute max_qp_wr in 64 bits and saturate the max_res_rd_atom and
> max_total_mcast_qp_attach products at U32_MAX. Cap max_cqe at 2^30 - 1,
> the largest CQ size the create path accepts.
>=20
> The SRQ size limit then lets the rounded up SRQ size reach 2^31, which
> doesn't fit the int srq->msrq.max, so make it a u32. The SRQ buffer size
> can also exceed the int passed to create_srq_user() and
> create_srq_kernel(). Reject it above INT_MAX, computing it with
> check_mul_overflow().
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117170914.2741=
0-1-yishaih@nvidia.com?part=3D20

