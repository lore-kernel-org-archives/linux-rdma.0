Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793002435;
	b=O/mti31XVm7eIjITKGz+B7vx30GfHRgML1jYwBH+J5X2GCvnNgRBT20ANLICmhqR9F4y
	 pNq2rK4mYqwIucW9qIwZiX3vRxYEu6w39yLDwN5VOYCQfpyJdnjVqJDgLmFMPeFFkBeFS
	 orx5TpKwI+++j9xj3OP6mGhBIzr4TCDGOODNpPXLSe4J+b6BtZUBUCZjU5EaTBCEfGNdW
	 902lF604XLF8S1nXW0nG++v6lcIbxsYwv99hCiMTNIvCtJLyIkGUSPUl0BjaHI5wj+UUS
	 SGGVVTOyj2kjZoWbzpPtEs4miznO7jz92DDHEdjeDcwy5GLlEfhecGhMDByEMOzq8JA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793002435;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=6qY3Qgk7my0g4iH715Nd0mYjh5xVH50JbhboZ/6rvAU=;
	b=AhqxI4v6GnJ9bGxF2XTR49Y80dHDia6QNp0Au3fdZ3pmWp7sND8PgumqVx4z07f/P0V3
	 wKd/RjrXYiStwbGC7QqwLI2DvyY3DWKaaBxooAy1tcZkUmMlhW0EsedFphQZeihH9rmvE
	 l6Kk9KSxvWhPfgLeMBOAIkAxGgs7VJMcjElUea7fYcraCne8KA0YjpbzZrR8s3jg3ASxb
	 nNjsjAUrL0IX4McbVm/6mNK2eVuNR4QJJkV3hQOH5saNH6wQz8RjnpYDhNzl43hEwOvBI
	 MUgL1wqj6fovS5pekI3ixkaVLmS9URYFjF0AsgvuTmiimlkfsSnsFaefYVRAJNhS6/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hBFlGCVO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A468D606A320
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 08:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hBFlGCVO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 228CC1F01825;
	Mon, 26 Oct 2026 08:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793002435;
	bh=6qY3Qgk7my0g4iH715Nd0mYjh5xVH50JbhboZ/6rvAU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hBFlGCVOK2bQvmEH0pGltygGEcQ+N2PVZUvCf6ctW6S6Um6UDlTy3wXGt1h9jznHc
	 IuvP3V5zLloPJOSDpyrgjTo+dSoKV40SP570jfnGIG+OE1j0XWDP/TjBECrCyMB+H5
	 3AvxcIptCNYIcOysw4L86cH1WMngTNzJQvlm0T+jr/bZZB9+Psexhx+h2vHQLV1pp6
	 izMT/TsDa4sIbQzOrrBuoHgpNcePuGCuTCnCmJObsysUsWMSel2+OMp10DLrrNEx4G
	 LIyef6Ntdo5C8TY79sRBopFJhM9hqt5LvL5rCzDNlDvUuBMq5B/Mkgdwf70RcbS485
	 uUjpUFfLqEA2A==
Message-ID: <sashiko-outbox-184671@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 11/26] drm/vmwgfx: Use match_mapping instead of dummy
 calls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261026053623.202642-12-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
 <20261026053623.202642-12-apopple@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 08:13:54 +0000
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
> vmwgfx is creating a DMA-buf that cannot be attached by providing
> always fail functions for dma_buf_ops.
>=20
> The attach/detach callbacks are already optional inside DMA-buf, but
> dma_buf_export() is checking for non-null map/unmap callbacks.
>=20
> Instead use the mapping type interface and provide an always fail
> match_mapping(). Remove the unused SGT and attach/detach functions, they
> can never be called if match_mapping() fails.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026053623.2026=
42-1-apopple@nvidia.com?part=3D11

