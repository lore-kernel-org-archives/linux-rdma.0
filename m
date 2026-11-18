Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022023;
	b=Iu5g590kcHUQojLCYVYy704i/pOT5iAtWPIRxmg0nKKwKQ0xMVn5rYzOGH75v0nNjXkJ
	 fDMSfy4DnT0q0+rKIAlrtbKylA1dioYf3p+GOjdPIhCH5vPwrUnvXDKDdPOIFVgI+E0gB
	 ETV1jHsfpkgi6pmciaI7XTw78kjL0R7pw3Znj0bzIoZsMI8ciG4Yye6gVZwaFrhwXIC4N
	 vXqSFy+7SebXcrNT+bBn6BEsm8wcTjVsNLp8g0QeTAJS9TFmoSAcEzbNba0Ngau8XStDF
	 Fdf0W1EgHWVN9Hr6sEETRuWN4ZPReJ1lSnBUKxppH0tZwzvLfrfErACSHJqZ8aUc8Lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022023;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=v+OCtHfTudxZPIZDU6bQC0ag5FOvXfOuFEu+qHl3+00=;
	b=dPD5dtpLPYpSg6VnZ2t7nb7JemgwRJR/C8K1cYsEUDO4TyOvCEQ3Fq5lm5q6YSGq6rmu
	 hbn0rwx3/ymf0hdeHdmqqCixxWX0M1nwPTqFeD4lwxxBO+RSsLqJKTQ+1XAv8ee4X/0uY
	 cAAaxACiAF19Y2bmu1Q/7w7LBVfo5buY5GrF0zKgMNc9eFVw6C2K2UTrl1/siJ05R4rnP
	 uQTfduzCkSq4zc3wJeHt9tzmhzEUXnqbKiv4adNVMP11GtXuTii0PFq1FI+SfrEEUFL/p
	 MkqKhsb5260vpE8nv/eG4cvef9k7SPZHcMw7LJqkXT9EaDPJhBprZLthFRA2gtZEM5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ap2DEkqO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDFC4606A325
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 17:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ap2DEkqO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74DA71F000C5;
	Wed, 18 Nov 2026 17:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795022023;
	bh=v+OCtHfTudxZPIZDU6bQC0ag5FOvXfOuFEu+qHl3+00=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ap2DEkqOofK5IDNqmNJE9CDTpgCdOF3qj4Eu9KkvmrcX1owrJZYrfAfNtQiM6NC0P
	 1VyFHuDbAmTJvXWiXg4mBq71NDByhhH8SMhT6HVJk3dlLf+x1SpWNeI/vaEbUupv4m
	 h5u2kuua0n6Z9f3Pn4+Kw+/kRGkKdDz3s3YpMR+A5QNJg6ba1IhPedk3r6/O16FfTP
	 2y7+IL4FUjrp8aqDDR2a4HrQEQvyMOsjKaMxKKOEjisSjyjVnhEknhjI7v7bpOpA3g
	 YMCdPA+s2SN5EX/ivxfDZUmAKY2Y3nwPVn8qhP18PnY7q4PKR4stxJGrgQEyqpjwY7
	 b2v6T8USGpc8A==
Message-ID: <sashiko-outbox-221606@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V2 rdma-next 05/21] net/mlx5: Add macros for reading
 log-based caps
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117170914.27410-6-yishaih@nvidia.com>
References: <20261117170914.27410-1-yishaih@nvidia.com>
 <20261117170914.27410-6-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 17:13:42 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Dragos Tatulea <dtatulea@nvidia.com>
>=20
> Add macros that can be used to exponentiate log based capabilities.
>=20
> When a capability can represent more than the used version (u32 , u64),
> value will be clamped to the largest representable power of two.
>=20
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117170914.2741=
0-1-yishaih@nvidia.com?part=3D5

