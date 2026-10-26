Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793004388;
	b=0/RaiSY1A/fUYV5JsC16ahkIFTc73drEWSVJzJ9Rf6UGyTW3W+x2y7aBem9UNbGWQeqJ
	 RCkTV5P/EePLgxQuk7PwdszdY/VrqKNf55hTHQWnF1MlBxAhcwWmeZCt+VJRSLjd9v0vt
	 o0U9Ik+DAO3CqyHg4mUleTTPKyXW92iF2VB7OEISwdiDX39Wg7GkxoxTZQIcBU3EO0LHK
	 ORx+DkL2M31IF2xlHLdzWlenMM0qBc8IWNI6aDOyXhDAe4xDHur68ihD4HNBCtelI7D4A
	 +XN56w13M73Gxl9CzX3SVV/ABr72PlbBJdyRCkiKEHSIoL1giyI48VnXsDkf48s2eng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793004388;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=iBXGF2W2rRljuU1rKWZguK0MZtnpH8ez+jXy6Sq2EME=;
	b=expPkA2q1AgvCIc3M2gTfFFzDcouYDeTONipcy4AlOCXXzTAUxGvblyZh1UXO62IY4FV
	 efQ9qrADAVvAfdd6uhkHGSHCcz3IA+8+TJKlD0Z28E1gJNAhA4f4VPYeztod67MsbO+MX
	 CE2PSxfeeoCXtENyXYl06PV6qLiU7or2YPg+UU8EIeiQynpAbaBjmR5HnvymYCKVGeX+V
	 iVtSayDrZ+ks2fc5dSMYvi1ydoxrsXMecjJJeECrtKBa/p1y179Bqljuft19ofXaRsdkF
	 g6tiDlVe6OIf/wMoynqxNLhpikW6PtwZSpL9vkSJmYjqy+kJZqUvKmtN9qUFbgJhtVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FvG0bLyA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA9E606A31F
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 08:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FvG0bLyA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D168C1F031E2;
	Mon, 26 Oct 2026 08:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793004388;
	bh=iBXGF2W2rRljuU1rKWZguK0MZtnpH8ez+jXy6Sq2EME=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FvG0bLyA3AW90F3HxN4ABbRWYf8WnHs8ZVzLwGSURPrLFHRMRehnTjkPcZD7JZ9Oe
	 vhUcBrB7V4EwuuaPz9b83CJigQHXpwQaSKahjEdy0i0H1oCcGBGnEph8EfyZVD4ei8
	 PiyxcSXiC2xZENx3sv++KIA0juU6CiOo7uovGEr4xuQQJMfAc8cLAhBCfsTpJegx8M
	 aROCr1MCWapi8s/HptlLJAcDmaIouNNUtC7Fo/vpBVJihTzGb1jberm0F5ZYvZB//C
	 4fMeL9CZ+qNjniAemuDRS6a6D/likx7l/IO/e+4vY6/UGHwIFwq3Xr4OPPiPpj1WM4
	 BrQfn9QlgpRbg==
Message-ID: <sashiko-outbox-184689@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 14/26] drm/amdgpu: Use the SGT mapping type
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261026053623.202642-15-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
 <20261026053623.202642-15-apopple@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 08:46:27 +0000
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
> Similar to xe, amdgpu wants to check pci_p2pdma_distance(), and
> only needs that if peer2peer can be supported by the GPU. It can migrate =
to
> system memory and support non-p2p DMA as well.
>=20
> Further it supports a private non-PCI XGMI path. For now hack this on top
> of a SGT type, but eventually this is likely better off as its own mapping
> type.
>=20
> Add two exporter SGT mapping types, one that matches P2P and one that
> matches all of the non-p2p. The pin and map code will force migrate if
> the non-p2p one is matched.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> [ the match set is recorded in attach->matches and the type
>   selected from it at pin or map, so the pin walk, detach and the attach
>   error path ask dma_buf_attach_accepts_sgt_p2p() whether an attachment
>   could take P2P at all, and the XGMI override rewrites the recorded match
>   set entry rather than only attach->map_type. The map path keeps using
>   dma_buf_sgt_p2p_allowed() for the attachment being mapped, which has ju=
st
>   been selected. The runtime PM reference follows the same question: held
>   while P2P is in the match set, dropped in detach. - apopple ]
> Signed-off-by: Alistair Popple <apopple@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026053623.2026=
42-1-apopple@nvidia.com?part=3D14

