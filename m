Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336031;
	b=r3N8tpgVO+tPFjMon15D/9Ai3lmyKS54r1Hy12YPXVkf9deOHQm0Wb6CXFKsa3YGKcvn
	 Gq78iw+OZ8oEk0S9kAWnlAgnlqE8uFy7BN/SmdiXSdUn8d7LinjlnXzTSEP48HgbuDqY8
	 z7Y5ulscEPSJ8r7jcmbO12fiKkUXhl+XylCzJ85EzL0DMenUKhf9Pt4mcAYg8pOLRlNUz
	 LB9nsqwh8wNvhHJklso5BsgMe46B16/uGxQTGi/iRtw50G/QpjPZHChaaEw8HH6XcI7HR
	 Kd1IfaX+MF+Lar4/EQqxE49v387zANXcMcNY+N6Yg1E8riqqwABh1dtIUQclxSleDcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336031;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=RR25kOBgikhPx0A4KuDwlGQJCuvC9m4a/w4mHc8smAU=;
	b=I9XFnw4GMo3UF5hxE58FAv39m7unsQiFXjn8/FE5dys/XY6zvxOj078othfJsuL8Dxe3
	 NcyabKC8UT/mGeZzyQtFLsAw858NNVDYcMweWX7cGCWTQ6pUys7mhm2+8Nury3+9QZd9r
	 VwhW2S4pGl9Si8KdkuCt90eKIrJ72dbGLSnjxhov4AbsjMnPm/2hI54zC3ZVga+j1VlEf
	 jXysYWpKf1smTvoM2oi53npiJ1L5pxFrBnTs5fNzbg5WBp6w9/r9YONJ2yBjZiXL0Vp1J
	 7qhWdo1DUvc5nEH/jbPytZK4qd/+fbWmAgHW7ug7BUjBr4jpb6oAdziNcvld4Co9VWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="n/j29Tys";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41407606A320
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 04:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n/j29Tys
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79071F000C1;
	Fri, 30 Oct 2026 04:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336031;
	bh=RR25kOBgikhPx0A4KuDwlGQJCuvC9m4a/w4mHc8smAU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=n/j29Tysq7T3MJE63qNHQTDt1rHb+3QjPFUL+829K5IMm2OVoSiRB8g13hdszpYrx
	 VU5+26iqTNP/zlJrr/fKCTJ5zc/MPZJsJ44TVE78pOGhml6te0Hg37MrWiMuxqiee3
	 SH3VHtlWpmjPoyIdGxlCivvteYM6NAOr6zjQi/+yZdwB8oEv3StXKMBjPEjc12vj0q
	 1xY/z+5IqtQp/f6HilCYpI1Sw48TWodpZfpgVGFgNIcr8ivUa3ehduXanCje3gg25z
	 lOgV/cKi85i4i1ccHOQsU7gQQaWULK/MdmupEa4VpCG13zqgd0Kxiu/4+zy0LY3PkJ
	 r5qs/Zu9Di7MA==
Message-ID: <sashiko-outbox-17858@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 1/5] net/mlx5e: remove channel count limit for
 XOR8 RSS hash
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260511172719.330490-2-tariqt@nvidia.com>
References: <20260511172719.330490-2-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:53:50 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Yael Chemla <ychemla@nvidia.com>
>=20
> mlx5e_ethtool_set_channels() and mlx5e_rxfh_hfunc_check() rejected
> channel counts that would produce an indirection table larger than 256
> entries when the XOR8 hash function was active. This check was
> introduced in commit 49e6c9387051 ("net/mlx5e: RSS, Block XOR hash
> with over 128 channels").
>=20
> XOR8 yields an 8-bit hash, so in practice only up to 256 entries in the
> indirection table can be reached due to limited entropy. However, this
> does not provide a strong justification for prohibiting larger
> indirection tables. Remove the limitation.
>=20
> Signed-off-by: Yael Chemla <ychemla@nvidia.com>
> Reviewed-by: Nimrod Oren <noren@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260511172719.3304=
90-1-tariqt@nvidia.com?part=3D1

