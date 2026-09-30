Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7DB4C77B4
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 11:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790769365; cv=none; b=bSqnn2pQTvCRCo/4cOmZ2UFqU50hTJ2R5ib52pwMDSDpJrbarA7ixuoUWPTCL6+Dme7Bl0MXZtFysukI+e2/P1u44LvU0m0KswUh6AA0lgetcETM9lPbLYw5OvMR+J+cO0QNWL2yNDgE2ieoKUQ9zc3hManjiGQ2isVPXE0SvAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790769365; c=relaxed/simple;
	bh=OyFfPUquyK3AScZ19XlekRYLlBNLmZ/2qqwYh6vSEEc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gbCZJXTVqEfv1bnWGjWQUw5XiGW5w90xo5AAzhxJ+a+hFUsHAyddIzVnKOcDAcGr23BqzkT48NsIrHNqYa137ZNL7loePpEYb2vfLpaZo0r10ttigLzV55tzGZn9jwTELbzr/1j7Yp8Px+X1MNAOebx0tK/UB6j4axsSmOXsIXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hQjs7oBv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hQjs7oBv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846FF1F00899;
	Wed, 30 Sep 2026 11:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790769364;
	bh=OyFfPUquyK3AScZ19XlekRYLlBNLmZ/2qqwYh6vSEEc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hQjs7oBv/EsMYk5FrRAlC9PHD5cqKgjGYVchzq9ywNTKlfZGzEXJ4Ih5Yk+Rp3FgN
	 WBzyA7BVkGZyalkX/9nLnYoHzQeaEUKyGwtKrm+Bo+jO0Xe6j3c1DJWZk658m/O551
	 NekylOASQlMoZJMBn2c+8oeQ0erCvcDe314m/VWONJXtAUfuWjAPV9ck4ZD5ynVdwl
	 iE68aVp7OfhZ1YX7l9pKfwrGScrc9yKOwnf/r7Tnxbi1c6sr0OyxxlQOxr4fpMTHHF
	 MquD4z7rxaG0oqEaisVsXsGDKJgirkMGa0YMkfWnSjYXJ+EhLlis3oY04U3yOVxvz4
	 9c3gK8MhZqGZg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH mlx5-next V2 06/10] RDMA/mlx5: Add new registration
 stage for data direct users
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260930114227.139274-7-tariqt@nvidia.com>
References: <20260930114227.139274-1-tariqt@nvidia.com>
 <20260930114227.139274-7-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 11:56:04 +0000
Message-Id: <20260930115604.846FF1F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Dragos Tatulea <dtatulea@nvidia.com>
>=20
> For the upcoming move of data direct to mlx5_core driver,
> the API needs to be split into init and register stages.
> That's because only the core will do the init phase but
> both IB and netdev devices will need to register.
>=20
> While data direct still lives in mlx5_ib, do all steps in
> mlx5_ib_data_direct_init().
>=20
> While at it, make mlx5_data_direct_query_vuid() private
> as it is no longer needed.
>=20
> This patch has no functional changes. It is a preparation
> for moving data direct infrastructure to mlx5_core. For
> this reason the new functions are added to the new header.
>=20
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930114227.1392=
74-1-tariqt@nvidia.com?part=3D6

