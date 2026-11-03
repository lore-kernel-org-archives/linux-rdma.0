Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793745301;
	b=ftUkhZBZHpswAH17gIvYX1KVAIozGV5e5+ByH3asOQ/iN3gEOS+75zIqZ3BXqa8+9QMZ
	 8zao/GaFkJJQVJ5ts0BCYQ2DHQkxJZU998yRT9wT7GdHxM6YlvgCvHd6CnU0775TQeTex
	 jRbZEpkTJbiJBrQuADghG3OMNF8ts9IzrpJZrbWhNofJpUTuf1eUdGKfCXdTXwMMCOJ3X
	 Vw8iGN2QLhOTiGuuVFx5udq4fLaRLvTYX43Em3wJPJnmiLc2VtL50tapf0xHFOgYLlOfB
	 S6XOkapjg4COFr/N+YlcUbRKjYaC6cLhL6QXYkXfEpauk7TxO03SA6JKGMq9C6wL8fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793745301;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=t9rwE2lZT/hC+cdk95HmVX07KkYMFvuLDnfvdrxjt5A=;
	b=JiqYMh1Nh+f/NHU9R2vT8L7/DbIy++obduCGsd/pDq9DIIpGhQ5r9cGK5WRlroxO2gZU
	 dnNx7WAl/EO8KPg8Ao42dVobp+Lee75Uj5nMNb34i8daTPLb1RNRjhvlDdYDFnrFFJB2L
	 J9Tqisftzv/brD9Lhc8gmRB5WpVGXQ1gZa/X0FPZYAWQqf2uhsU1DGo5NiH3SKTuTy8k/
	 xWULiPEjm7lMTA2RTqi3yKdR6jlE7ERZ7ASHlFq2d/ObN/X5zEIk7RNALpGOj48xQ8tDe
	 OxXcZwWPik0slg8cB1xjDS11uEo2VC1NZujNdmIxycIX1k1lMM8ox6WljITB0OtmvWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ku8CLW4j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8047D606A328
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 22:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ku8CLW4j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED75B1F000C1;
	Tue,  3 Nov 2026 22:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793745301;
	bh=t9rwE2lZT/hC+cdk95HmVX07KkYMFvuLDnfvdrxjt5A=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=Ku8CLW4jVm2H8o9LayftkefYBIU5I9DMmMPSBN3GAZxmDbbCZRb2UDWLJ0ZgACcsE
	 lihM0MoaeLzwxt6Zp6ahfvPPRcDPACDyViA/iRd5UdrfjSDltxWO/P/XTU9TljHW/f
	 5wvZSaffXAj5/vqBla6KsaBw/rm9D6G8wpnOOZhfB2KIcKySJTkzbBhm30RaPxu66h
	 3SwHjeE6TwmdlfkscLEef7M/cYK13sKUiQw97r2zKzEPwrrA4v4TG922WsuRiZtwsW
	 xxDFQlVobVEhX38N00cdfyPZVJ05OLwtUC8TLJleodAXgjfKgmZXIvELFYVEZZYlCf
	 qKYPHYVqw1vfA==
Message-ID: <sashiko-outbox-196133@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 08/15] net/mlx5: Enable relaxed ordering on
 resource dump mkey
Reply-To: sashiko-reviews@lists.linux.dev
To: "Michael Gur" <michaelgur@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261102223325.2115128-9-michaelgur@nvidia.com>
References: <20261102223325.2115128-1-michaelgur@nvidia.com>
 <20261102223325.2115128-9-michaelgur@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 22:35:00 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> As resource dump logic reads data only following an event that is
> delivered with strong ordering, there is no need for strong ordering of
> its memory accesses.
> Add relaxed ordering access flag to its registered memory, thus allowing
> better performance and allowing resource dump on HW that restricts
> strong ordering.
>=20
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Michael Gur <michaelgur@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102223325.2115=
128-1-michaelgur@nvidia.com?part=3D8

