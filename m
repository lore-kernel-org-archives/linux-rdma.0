Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793168293;
	b=3asc8VuAujZ5GPJ0pXupN0a2j/Ab+jOSD3SXKij0itgTvcfGhsvQUPFFg9ZOVuXXpnDM
	 w4bZIz3wfRg9wTrVsp8KJGjcaZfSliIbNrvlPltRNWkxJQGou51tCjUV8eMqeG+n70ixR
	 6RU3+Q8GBPQHfh7bJJ9TKeNhJG79uuVc0O0Ypghn+YVXmMkurbROx7rKRFVMn/hmk5K4f
	 6mjcDUIchNsqhUa+uOSddCnUdUmPEO5liXZZlzSNICNvF3UqkuUYjJfxqRBBk0ECe3OtG
	 l8jyzi2muvRb7dlxwEgKYD/i9tz4FeoI92ey8LUfqU/EGGpRgjRCfQfOKKx/iursl0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793168293;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=5GXd3EMcaKB98O8hCt/Lf4ADlVh1RNVffDM5bgPGUqU=;
	b=RHT+NRZbR4Cu0u/dcSmldw81ZwsfDLs7qAtV0XBPp6sOPByr6dKCt1USsIGUfQ60/CmS
	 lLSxocBOF1HOtiNs8i6rrLG9+pQB8p1yPMfrbIhE9aXKL6CcVGiYxXtu4zE7k83k7D4uP
	 4xTYxPDc+9rpbXLK0JfN2ScZr0T5XkwalLE10ANS1JEzk6uXpdHX8QQqmAk4rIylCqG8u
	 OGeU/j5N3BU2zwZeuHmo853I9/fJZQk6csK7HUVF68yj3EN29hRKHRGlNcIjYcHyTZ4Mb
	 CI0DoOPJOobGVqBKzoMfGazBs0JqS8LLgy05bveZq40hRfMCZhzy2QBojwREVzqlvwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S+W8JgFB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15782606A31D
	for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2026 06:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S+W8JgFB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831D21F01825;
	Wed, 28 Oct 2026 06:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793168292;
	bh=5GXd3EMcaKB98O8hCt/Lf4ADlVh1RNVffDM5bgPGUqU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=S+W8JgFBC6mgrzd8gzUItWAmmFoQHsE2UPQrp9k704WEmw/XHNaJgQnPF2t67k++i
	 RAltRFaB11Gh6Nkbi9TJu8i+8gHEiCllUPCWZwlwwRykCpgjHA8kzjlKXwciEVQpCa
	 0GmAYGBBCJi6LpJDJ49NqD3TtzYIb4BNpoaOKo60Er2JClrT2o/in88EwayHyJ/o24
	 ljbG3DGmLnQ8kM+OKio3EewjGPaitoYqMtR1g9FDNa5/e/qN8E3Ben5q9PUOfvStc4
	 qNUuuLJbuF5y8YkBETZ2ZObr8RVOetCxAEL4Uf1X5S+DPckm7u8ZYyfV9g5RXO65JA
	 M+QRvSF/9Yx6w==
Message-ID: <sashiko-outbox-187554@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-rc 7/7] RDMA/bnxt_re: Bound FRMR page list by
 max_num_sg
Reply-To: sashiko-reviews@lists.linux.dev
To: "Selvin Xavier" <selvin.xavier@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261028113404.33289-8-selvin.xavier@broadcom.com>
References: <20261028113404.33289-1-selvin.xavier@broadcom.com>
 <20261028113404.33289-8-selvin.xavier@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 06:18:12 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> bnxt_re_set_page() checks against frpl->max_pg_ptrs, which is rounded up
> to a power of two, while mr->pages[] is allocated with max_num_sg
> entries. For a non-power-of-two max_num_sg, ib_sg_to_pages() can write
> past the end of mr->pages[].
>=20
> Track the allocated size in mr->max_pages and bound against it. Also
> reject max_num_sg of 0.
>=20
> Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
> Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028113404.3328=
9-1-selvin.xavier@broadcom.com?part=3D7

