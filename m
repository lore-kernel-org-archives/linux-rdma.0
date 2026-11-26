Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795683434;
	b=HHYX5BZxHr00Th0tGK2ebNrFQTfl/eBX0V9x+Pg5egGpxWolEQyAAVEjpotgjfJigust
	 ZWKDFOLOr7EEkRyEDDZQtW62KIsVHGCOQ7h/2Xrhgh3Mzj/uaypbOLLB4TwVsXSUqzaAq
	 i4ljsiNpkXeFezdap5zxOB2Z4UcMtLMgGoEJUJ/Gu4HNmDEPumv3+2oT0WdlvMjHKQFOS
	 AxGFmxiJdAAJO3cnhQ8lrMN4fQSvuNE7oh8Ga31lagYRECaF+t4a41xuAT4B6tgvY5w2D
	 r6k3ukZ121vEaJFjEjUJx9FB+sx8jwHJDp6yDkGTUcbCBM2LEjlQHrS1FfdEkbxxQoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795683434;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=PhsSdl7Kb9n2mqFWNfO7EXvlqkds1OqSTWtPiMXfyc8=;
	b=qQwuj4BnCRFB/mN/deyu7k7Zt72pBMei5QrEpU9cairPdhClCpW+tQdmuPaYbnADukwu
	 Y9Kfg4bI9u80ofyN5IbQuX5QejH1yfDHjb4gILeeWPo2bwiC4Iu8gbVa5lHegDhneqcAm
	 PHI91Q7KlPlamWH2rrOVKbUQ8e7rxXzsMrixN77o/v0ln7pUUHPFdmGJx0PS12tLB/cZ7
	 ujF5R/11Y7qd6E1Rp3mrfvEJz83UitTYNVSfMXp0bvnU7BtknGlCvpflR0xm7mr1QJx7a
	 +au9kl6mGvnB8uvvbqrtD9EfMpTSX8jUehvjxWsxV6gmKEjiFV71HMbPYUrLS9MOAng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O3x+ooRw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD13606A31E;
	Thu, 26 Nov 2026 08:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O3x+ooRw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B9E81F000CF;
	Thu, 26 Nov 2026 08:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795683433;
	bh=PhsSdl7Kb9n2mqFWNfO7EXvlqkds1OqSTWtPiMXfyc8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=O3x+ooRw9lwvf/xTlp8toDofQjtqO5ylDXBmZQZxHhk1n2lpFxrPg7ntoB4kmxzl4
	 3FyA0hSUkONYT4cXHHcxk3TGYX5HJnQRcpiQf85+ymqmJ2GdlEmeThLrEi01LHrOdg
	 j5rcUtLTgDI+08v1b15teltdMWFF3amll76nd6J01XXKaRyAf/wrfytWKBKaQmML3X
	 w/bJsK43GPsq6aGGWY+FojyjqaPb8viAwqPU02JDkUjr4a9a0463M3/PzW0VbSDgrA
	 OJJVafGvXVAdV5TPpBuSvmSQSPGUv7s/g4P0uZQR+oMkEv64A3dC4UoohzmMTiL23F
	 ZovUOnEoj1haw==
From: Leon Romanovsky <leon@kernel.org>
To: Bernard Metzler <bernard.metzler@linux.dev>, 
 Andrew Stellman <astellman@stellman-greene.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261122191128.65369-1-astellman@stellman-greene.com>
References: <20261122191128.65369-1-astellman@stellman-greene.com>
Subject: Re: [PATCH rdma-rc] RDMA/siw: Honor the sg_offset in
 siw_map_mr_sg()
Message-Id: <179568343071.1250831.8794138039315136264.b4-ty@kernel.org>
Date: Thu, 26 Nov 2026 03:57:10 -0500
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Sun, 22 Nov 2026 14:11:28 -0500, Andrew Stellman wrote:
> siw_map_mr_sg() builds the first PBL entry from sg_dma_address() and
> sg_dma_len() of the first scatterlist entry and ignores *sg_off.
> ib_sg_to_pages() includes *sg_off in mr->iova, which siw stores as
> mem->va, so siw_pbl_get_buffer() resolves an address in the MR to a
> location *sg_off bytes before it. rdma_rw_ctx_init() passes its
> sg_offset to ib_map_mr_sg(), and isert can pass a nonzero offset.
> 
> [...]

Applied, thanks!

[1/1] RDMA/siw: Honor the sg_offset in siw_map_mr_sg()
      https://git.kernel.org/rdma/rdma/c/1b295d105a9bca

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

