Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793947429;
	b=JzjFaCvlk/QeGlcrXaRnP/QrOUcUEtnhAAkKyVAh4v4zJwWA1D/Xp64M1yohl5UUZTIF
	 Jl4MrPS86f49Nx+KpciuFCP7GdztUfnYVlh0nZEVCXoWmoRPJlRZJGMFp6Hv7fdaGgGAi
	 i6XqefiFXxnJXyKUssJaz+a1moDRFdT/0q21wfyid+uTaSMr1rptlxBMa+V6Go5ALYrq7
	 vwZwajUXgSjHOpKOwWIQRBikqYSdvhISEQqVJlUJXiBv6nIq17yMraxQQw0vxEIrT5BDI
	 +/8ao9I5+Cj/qnwA9GGXyCQU8XXGuiE1tqp+LRJhWdfHrLmvnceC+th2eOz7ZqR4G1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793947429;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=vHmVhmo+qvowb1N52K4PXczTVaGsNHqvAx4Yvr54T10=;
	b=wmvyhQym4erAo1iLZHkk5VV2QQbh7SgWQMDIxVpIJTny560xw+lNGqY4BaZ0gAJdHGfY
	 ipkCf+00eqDtiZ4cpJexQmx/DxBwx0lVhGFxLkXcamB/XKXr0ivNwU2Xrfv8Ll8ZHTrxQ
	 8AHeE2uWUe0GqzDIfuhPHt4tpBqLHSxPh+ep7t1+MIhvlYh9gtHveDaEFkpYjHhLBg69Z
	 pk0NaAqFJobECLAk3X6ENEjdyaVMnJoiSKpcKU1EZESGPH1hb7JSKRlUijW9F8qc2gSso
	 CNEAEpGf4v1WKtX9tUUKdeXmgK43eZGvrwjzd8wOPm/Yn/fY5xOttON3YEhY1350p1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Thc3Ixrx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69FED606A326
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 06:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Thc3Ixrx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E599F1F0089F;
	Fri,  6 Nov 2026 06:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793947429;
	bh=vHmVhmo+qvowb1N52K4PXczTVaGsNHqvAx4Yvr54T10=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=Thc3IxrxS+qKjj4cbA1JmZczDS/EFF4a0CPRMDRwJ11ixaHPCbdLnsl3atSHoxPnu
	 Z4/iQW/EIRAWsjoi3OGwfxzH6G5gib6B56r8x5aNnXEhp9D9hKCa1XNZofYVw1TxKg
	 BABHJQF+b8KooAGZm4VwzNgs95mCzljJsLSeFxrqXysuYK3pFo72K6C1gfAqEz8nA7
	 dMJeasWqpdLUJOKMDkzTOWXluRdUNIbKIl3yt962y+5q3Zw8V/aFZwuxKzUss/wfen
	 zZkG/CMw/nK5DBziQQzZYvGwkIiZttu0LpxlB60Ii2muF5mM0hldLEGK5gHbdDv4pA
	 /huh1Gy5g+FkQ==
Message-ID: <sashiko-outbox-200919@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 03/23] dma-buf: Add the SGT DMA mapping type
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-dma_mapping_type_v4-v2-3-78b8dc9ae80a@nvidia.com>
References: <20261105-dma_mapping_type_v4-v2-0-78b8dc9ae80a@nvidia.com>
 <20261105-dma_mapping_type_v4-v2-3-78b8dc9ae80a@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 06:43:48 +0000
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
> Signed-off-by: Alistair Popple <apopple@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-dma_mappin=
g_type_v4-v2-0-78b8dc9ae80a@nvidia.com?part=3D3

