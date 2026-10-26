Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792998285;
	b=x2jYd5xO+IdD2KManKDcuu8YoJVO/XhvAmpVqQj1yoKR0unV5GxEGf9uP8QMETbSafNv
	 tMLXZEy0xubSHVdLWaUCZRdvGeSKiXe50uLQAc5uvHsl7XPZyCmBan/z9EdOkdckrzRDr
	 kVNC0I1ldAe/axTY9UGwf10bxZWpmXcK1Wmq5k6j5vQuWg5+neT3GQuu0Omo7iDWY10Zb
	 oU9udgmLnP2pfzA+j9DanNBhVvVCWugGCADer2s4UESIsvqrB4fF1Bt5zGan5y8LO2onZ
	 rl/mS7hZwaGvm4BwLlPzLkHtQdAM4vf0UTl3R3hCrMIh1J4VwIEpYSiR+UdPrzRTnyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792998285;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=cIu56JP7Aj9CxFCfQlheY5xUX22Av+N1RbAZKWhhqy0=;
	b=jenere9ZrEE3qWtB6RuO/0VFzLV74U95elg00gYiI9MGz3EwQCDOXD0voZ0y8c+OcSai
	 jWhTCm7eCijB/oJnDe1tiNyfgysD8y4R5iisYp3Yg7W0ezBoQDTMju/4foA64it3HXan+
	 iVjj3s8h+tF4WTGAZ2ssFm6YQE40sAsHq6u+kmHyQxKd9y4S7EhWKBV7c5DakAw+dcJkw
	 xQd14iVtqA7i9p0GoDvlEMUIL+WRtFdoLLXpBIZLvrqeEUjIXPReZh8hEg0zl5MzzxeJB
	 iAuhF+faxF+m/Gz7emgUXm8UM3ef1jSbSufw4XRHsJJpdzpA04OQlcG6Y+BxK2KiY0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bwNXXWIp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4125E606A31A
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 07:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bwNXXWIp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B801F01825;
	Mon, 26 Oct 2026 07:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792998285;
	bh=cIu56JP7Aj9CxFCfQlheY5xUX22Av+N1RbAZKWhhqy0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bwNXXWIpHpQ+HhKUhbEByw+Zdp5enHMFxzma8McSzFkKH19Ri3RcrtnQ8aTktkPow
	 LWxV+07O5kgFTEGj9sv5lGZXFIwt73Hw7Qf1e/qp+T2IG2E1Bvf5g9+KNjoU3rkWnT
	 VCIELYHh37DnNEmGaOr8IXDQt6RfJVw0Sb7trY/Bjv15ZgTyZS7cMvwtzHgbID74Lr
	 LgAx8SMQRBblRBqQB+ctiWhHH6MLenGQN5lNdYTMQzit1WtQFB4zoaIEATP0a99NDv
	 zdDFSrHl7b1KtTx8ikw27g6FYic48IZHdzUklbyTIxxqbGOj2vEO50y2rxwez9JbeI
	 w9Wj+2QJSWg+w==
Message-ID: <sashiko-outbox-184648@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 02/26] dma-buf: Add the SGT DMA mapping type
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261026053623.202642-3-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
 <20261026053623.202642-3-apopple@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 07:04:44 +0000
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
> The SGT (Scatter Gather Table) DMA mapping type represents the existing
> sg_table/scatterlist based DMA mapping. It provides a sg_table based
> map/unmap interface that exactly matches how things work today.
>=20
> dma_buf_sgt_exp_compat_match will be used in the next patch to
> transparently wrap an unaware exporter with a mapping type.
>=20
> The SGT type handles the allow_peer2peer flag directly through matching
> logic. The importer indicates if it is willing to accept peer2peer and the
> exporter indicates if it requires peer2peer. A required peer2peer exporter
> will not match to an importer that does not accept peer2peer.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026053623.2026=
42-1-apopple@nvidia.com?part=3D2

