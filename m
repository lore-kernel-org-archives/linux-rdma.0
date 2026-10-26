Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793000522;
	b=ReJuF6lzShCE7XOEZGtvE1o1QOtR4eQjctnT39yCniG+f1K155oHAE0952xFvtTU8RCS
	 rYF3Mr91HOZn+Z4bGlWtxpx8MW7I0CIFTly0p+g/qSt6D4xgbnVWCE0Rz8xEZMNfsD1ep
	 ppXboF7+ePK+2Mhyia4RQcnrlkqidzYsTcUUl8Gw+RbiUudHoMGsaKYDk6KXRuC6mIxBs
	 mu6ALaDvCIvb3W/kQzQaml7W1mKS8VuXICMmnpNumNUY4ga92F7mc31TI7sr4HUn0rgLg
	 efIXA7emNUubctvnZQcvGqtP+bdnfRrvOr0z3o7cHBBauu94OB+yvkNdeW1p0YY4H5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793000522;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=DwHEPlaFLI4U6lMLwpj2K1CcGZDUnXTksFeCjhvwHrk=;
	b=5J9PfHjs2ONJWpHhJ2uUPf59Y9UMm8ER/g2TWoqG0tx/NGHaNjm37TZ6kgJ5vv+I9N47
	 PQfNJtNCnqxfxjr3luT7VD/5eLECG0qHOv6o3yVuza3RKSBwW1uLsCHq/p5tFyFoNly4h
	 7A7X6BKQ67pGYEM3EwNbKoaWWryKrWUlcnnlTLOd37CiEYgFwwBxFvin1CgOUCMMaepRn
	 iNV7DlwwlDqyDq9zgwpYAiXMrz9tbubZA2hPzwmoui2xICPB4/u0CdoNW7eS7xw/p5xpw
	 SXVo/nD/Z852fxDgFymA9oIAinOdKIpQKRFANnZ/A/le7bKPMAeEhEywEMUVyRnSxNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hrUHUnyb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE401606A31B
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 07:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hrUHUnyb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535031F01825;
	Mon, 26 Oct 2026 07:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793000521;
	bh=DwHEPlaFLI4U6lMLwpj2K1CcGZDUnXTksFeCjhvwHrk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hrUHUnybiGyLVlbKvq5SiryDvClG7mdl0u0KE1ztQuAfJy3A5JSgbETYp0e6Exk5R
	 lSkhE0r5K1dyfhzmz7bxdvY4JiTPImIeO+P0ZD2aXNrLfYrvwVDl6VCV21M9KJ1FP8
	 xWnRXgYUu9ruuVyKLUBYLEu5OiXZh9zGX0PAoCeqA/kzQrJ2im8S8Ba9QOAE0wvFng
	 EGZpo+3YHXVNbJJpteO/3pp+sx2JeswQH1fgbAPhiVsxAi+JNOMQJn5joCtJVw0gLq
	 jrJcRAz1Bj+/nyoS3up6NPNcKDhSPjQipvpbaxhiI9OO5jHc4Oib0ShjjuXLHhsVAc
	 8yC64pSEaR4yw==
Message-ID: <sashiko-outbox-184663@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 06/26] dma-buf: Add match set queries for exporter
 placement decisions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261026053623.202642-7-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
 <20261026053623.202642-7-apopple@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 07:42:00 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Exporters deciding placement in their pin path walk every attachment
> to determine whether it can take P2P. With selection deferred to pin or
> map an unmapped attachment only holds the exporter's default. Therefore
> determining what is possible requires walking attachments.
>=20
> Add dma_buf_attach_accepts() and dma_buf_attach_accepts_sgt_p2p() to
> walk the match set and determine if an attachment is possible with P2P.
> A future series will convert P2P into a distinct match type.
>=20
> Assisted-by: LLM
> Signed-off-by: Alistair Popple <apopple@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026053623.2026=
42-1-apopple@nvidia.com?part=3D6

