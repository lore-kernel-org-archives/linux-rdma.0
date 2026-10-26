Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793007351;
	b=bY4/wO2+CFV/u6SAGy+gg1RjdZiyN+zTRcEUAvZRks3xrYRaSgA2YDoXaX/tTzO6rG93
	 agr65nuP+6IIVuovXmHAugAFfL97Ag/3zOSjXVFlMTsHRt8P1FVKiqwQmLFYKi+a0hoUQ
	 uLFsJg/woDPTrnZKN5l1+4oGDBStzembpyCPLPvYQTZKXOUV9gnQOM6bez9tBMcLkModn
	 xT7iVknNgmAQs7MBfmBfTTK4/MdV+Sqg6KPs82MDY4vlbUnomQCHi/cHfUxbGfc/D3BH7
	 2iJqoIK7S8qonsug19S0YZvZ6VFXe4TQmPFLzl9vFQK80UOdh9UFWA3FVid+YkNabbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793007351;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=n8SzVfkREQIBCh+50C7aHDfKwK771cYmLP2f3a3XTG0=;
	b=1QcECOuGwP/y+oZIJeAmS+oOX+16x8QDwqo/GJcInfYkRslsjq3ERqGYlhQU2VDgNj4Q
	 t6i7qpqGq784j36U1UcxNgl5u7JlvF3mIrGpdtTbe3f17G7qJxI+16ehprfnDvrRYGldN
	 EOaPyR65Aqj0A1ujyNhasL/fYZNPOqmGFPNTv6R6uaLNRFdoo7s/57bVF+raruJ/dY/yZ
	 Q1ArhERPzIjJe3heG+IeHeRnw980Sr9bnC8elgyTeYHByrHWonXyIyMV/ZxJ/Wtqy+ZY5
	 owkk4rhHhU/pI4B/LDA+PxxyHm+lKqX/JhlgasXImTbDFuJw52qZ7UsH+KdeK6+l8qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XhjFoh87;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21F9606A335
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 09:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XhjFoh87
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795411F01829;
	Mon, 26 Oct 2026 09:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793007350;
	bh=n8SzVfkREQIBCh+50C7aHDfKwK771cYmLP2f3a3XTG0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XhjFoh87Kgjpn6RfbGC2THbgT7UP1Umm1rdMqJJYmkv4eCmFinnMbkyisvvXESPDS
	 3Hw9bCoHv0PJEdqzkgHOrI+GGraZjUFdgrId25KgbOpOmtn6YI6ApFBIb9nq5VJRhS
	 Brx9qOH5wvZlowJAeWQ5m0qUGjc+fxPL4BioX9Ym4bgvNLcYMRse8PkdAJrcrWVBzQ
	 hP3bQVLM23nur4FTR3wnf1qk0HQfsAiu2X1i3KXSRsOIvN1TLMnBPb85rBCE6Vw1jC
	 L4QkjPEDvertdqgolcHX1QWkfOoc1geDrXL0dtPyIn/Dqt1EWpNaJWND1WoPgcH07P
	 Is5eME0nc/Mrg==
Message-ID: <sashiko-outbox-184808@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5: Only set num_doorbells on a fully
 initialized SF
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261026084503.4122732-1-tariqt@nvidia.com>
References: <20261026084503.4122732-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 09:35:50 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Cosmin Ratiu <cratiu@nvidia.com>
>=20
> The validation for the num_doorbells devlink param rejects values
> greater than num_channels. For lightweight SFs, this ends up accessing
> a NULL priv->eq_table, leading to a crash.
>=20
> Fix that by rejecting setting num_doorbells on uninitialized SFs.
>=20
> Fixes: 11bbcfb7668c ("net/mlx5e: Use the 'num_doorbells' devlink param")
> Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026084503.4122=
732-1-tariqt@nvidia.com?part=3D1

