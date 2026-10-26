Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793007317;
	b=EL5aYdjg7k/mYy/GODEOC/Uw61sALZveiGl1AH4CGNO2S0A7fd5TiUt2WFNEnmoDJ3Hn
	 8w2Z7Da4/uV97UHqmKV9qnGJSIYG5dXkQqp+EU3UMVSyAYBbc+VVFmIRFZcTooQAavLGP
	 oSqB4eS55DcaOH2P28Xcwj/zvllXca5DyWej4VEFQbhyn3E6hf+VPqnGNZ1q2ytGSkcK/
	 EBshquuY4jT9SKcjWw9Ue/h4q8OA0dejtbsZKW6AdiNIKQxfOzj0elPuP6B/AkxVOjLDK
	 fSLGvjV1GD7cuuOdMd3SWaRhQSSU/XH9NIO8LNE6PWGS7iSMnr8KEAqtLm1GvYIAHUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793007317;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=yvUFgaaYZUMasW0y4zEkIkl6hYXDAJ/g6jPb0WImI5c=;
	b=KsD9kVgzFYUUAgdc05CkdPnLcEXNpNuD6k7V4eMEjsG4mybs+HWIML8E/D6pXCTHJwqn
	 2hiWr/9JLVgZad7nOlNsXDwrCd+hzQvRF+2BbklRqp9SFB5SZkj/cJ4mIOkxc8shLJDEL
	 NQpvOdrU7MecB83WcPRswX//nQcXSwqmSxbBTJPt7oYoXhlxByHR79m1xB+Ka7dTAxhgu
	 P1uvQ9b0+6P07E4+8SpyR6diDjrLShw3rC+x0ndppun9lVxMxtzPXeLyqzSq7lGNGinNU
	 obpnpm3dcmtQgHObj4oq7R/tkH7oRA0PuYvnJEnkpgs3yyFt+O01wgQdN3ioooMyUkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aNh4ewPw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7563C606A31A
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 09:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aNh4ewPw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 041A21F01825;
	Mon, 26 Oct 2026 09:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793007317;
	bh=yvUFgaaYZUMasW0y4zEkIkl6hYXDAJ/g6jPb0WImI5c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aNh4ewPwRKoECehyHlj+Z3iroTuodQ80kV/am0l215z4R+FjGuBAOaA6p7fCW9wS4
	 tf+/N62kp6VH+Ih31rr8sY5s/2tEC9oQLq3U9QIsQ4CG7zNmMh+PXq4oYJYd2Lk3Yc
	 q9J48AwR43A6JJliTIvvJCKZIupeZxqbzsddSmVQ3VdvF0XySzSlJNyDXrwgQsF60f
	 r9lQVpZ+AMn8Apno+5xcC0jZQ095kf2C/3r06c953KvfZlmlsnceGq4tXNPfI0TjQU
	 U65/+G8Vcv9FGZYTP6hM2cZNOklPiQNQgqpIrxTWY/acX8bE+3Dh+YXhkoslI9wr21
	 m9NygG0XGU4Rg==
Message-ID: <sashiko-outbox-184804@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 19/26] functionfs: convert to use the SGT mapping type
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261026053623.202642-20-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
 <20261026053623.202642-20-apopple@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 09:35:16 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Jason Gunthorpe <jgg@nvidia.com>
>=20
> These importer helper functions should call dma_buf_sgt_dma_device() as
> they are always working with SGTs.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026053623.2026=
42-1-apopple@nvidia.com?part=3D19

