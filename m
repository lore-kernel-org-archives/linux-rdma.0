Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793002339;
	b=igdeH1i0wQsfK1LlaN74Xt0msNvQwjwKMG+4Gm9LOZkp9ZsidI0RfVsy1OwHmW85Vd3U
	 dglbnUciOgvTCDKwy8kS2AJrJ/oWAMlL4rcntpnWJcmA5yPj4YSh7p8HBNabax8+G3pZS
	 JyiGo5c4fbFMQ4o+bkUGferthlzsSnF8urSA4c9nMGKtHI7wgbOELGX9/dCmK0r2dkNrb
	 sPQOD2ZfenOyevfF/6/Wp+jpIJrIbodVX0be5Vn/JUrMShFliK7TmnsjJxO0bFahJhcUU
	 WrbKKRmz5E1mYhMWNmWcmhXz8e2jgVi0/yQZZ/C2yiwrpDgTG6BrCfqJepNeQrnqDuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793002339;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=FiS8Epo0rObpZyHAu5JfbbeuR5WfAg7bSlhY8G6HyMw=;
	b=jy6UvjjGTUxwIn4JMmexlJV5VJO5pa1FGn+zouFTeq4OfAUfIt4EjLiOvrooKhchFOwk
	 mERoYrflQumDVC2wFKKmkVg2xUC4UPnBT4Crp89yYUigTgF+wdpFJVqY1Sqcwqh6xXVYR
	 4/KewvY8Gv9+Q34phDd+y3tOC1qkG6mMvkdh2XEbIgi6EZiScGj8e2Q5HEG1kgky+vlIN
	 XQQxVqcoAE+Puqk7A024xprAwDrnbcnL9oyy8WwoLj0rsGq8esqlO7gws0Op76hriOk9z
	 jhkvArxhKNusjeGvxh0YI71fUfnBJPBvXKZccY4Bqpcb8CJ7Ty2Nu5uSFHVOKZc7P6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FaOA2+yV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D63F606A31B
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 08:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FaOA2+yV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D2C1F01825;
	Mon, 26 Oct 2026 08:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793002338;
	bh=FiS8Epo0rObpZyHAu5JfbbeuR5WfAg7bSlhY8G6HyMw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FaOA2+yVBeYd563AYpSLFl5oPwr10RiTzX/Sd34ebeolXOkH98kV0J7sU3aBUd4uG
	 WBtkz6270YCBe44wJGNyD9771R4dDqAk9DTHe0V5sfJ3ciwctpO9M1jG+iRVnflrFO
	 EFIjANixr2CnqVhsW83jyccel/sVgyxfsPlLofPGhbac1Yf9rvqYbwU3M/znS9uwhM
	 vnSqC5qrMbCzvugcyNcs3i3RAIRvT0l3GQskBAe+UU7ddcJF003nbSChxp32GBbwqE
	 a0vwwc8BuD9vCZckFd4MV1Pb/umdB+XuOqAbDNHkPHI2A9S8xo0gY3RKDBOzT20guH
	 DwotEGVwj8Xiw==
Message-ID: <sashiko-outbox-184670@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 10/26] dma-buf: Convert all the simple exporters to use
 SGT mapping type
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261026053623.202642-11-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
 <20261026053623.202642-11-apopple@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 08:12:18 +0000
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
> Update the exporters to use a SGT mapping type and the new style mapping
> type API. None of these exporters do anything with attach->peer2peer or
> importer_ops->allow_peer2peer and they all follow the same pattern.
>=20
> Change all the places that need to get the SGT's DMA device for DMA API
> use to use dma_buf_sgt_dma_device().
>=20
> This is all a mechanical change of moving the map_dma_buf/unmap_dma_buf
> into DMA_BUF_SIMPLE_SGT_EXP_MATCH() arguments and switching
> attach->dev to dma_buf_sgt_dma_device(attach).
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> [ added converters for newly added amdxdna, panfrost and panthor exporter=
s - apopple ]
> Signed-off-by: Alistair Popple <apopple@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026053623.2026=
42-1-apopple@nvidia.com?part=3D10

