Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820E75221D1
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 12:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792068513; cv=none; b=OUy4euYJX1lYR03dsQwC99J/DcmtRj1ZzK3BfScJKA/5vTYUPi9adG46uNTqr92ggN5oYRUyIy701kpXOz0Ljaf3XQiJtFubMAmt8ymTGuaCWQhsZzr14qhC5mjLSLfAqlayYvBmNdCh0VQ45x3/cJN+I4k780cBpsuh4E/93Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792068513; c=relaxed/simple;
	bh=XtzF1750cgjj+gCSUm3R9F/JVymSczq2qSCeAr/iYUc=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=j6OXDV8BbQwoxo/CLZkX2yx5zsPWEHe9ZHYnjXG64l5jwAQ4D4JDnf88pvXJqnVrUlXHB3PD1FJcOr0QeC8eHQCwUn2A+GYdJUN7Fd0dfRpDJMYWPaopmNpGgAl29juR3p93DoGQofX/xYFzeIJJxQG0C5RrrTodGt10sHC4sww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XshQh556; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XshQh556"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 089EF1F000C6;
	Thu, 15 Oct 2026 12:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792068512;
	bh=DX6QZoDW9UQcAb8m9i8N/AIDg9Ff9Kf+QmEGO8UiPts=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XshQh5561pPzY4s0odFWpWTFdSSg48PsX3MTkECbVlFs0iTqwAfceMXePuV/h5cHh
	 /W+c0pH1/L5ffnEfEgoPy0SmESAdmiKRrxyO+rIGJZ9WP5gHU7DnNID8Lv5nH6IENv
	 /+npXOR4paDnvUgLLDYR+cYRQMEUDToh+TBj2BvfZpGRwPkkdwWJYPmVy7rHK8+Odb
	 CLaA8Pzepb8xEH/fV3swK/ac4Q3H0HIlsSyhJyjVixVgUiQYs5gu8udWvDd0zsaAXV
	 Y0m3DJEpkm+8FAPsCe1fFkbveJdLseqfbuJfVpg/cOn0OjcO+JNgMboFQvcVjxi9L1
	 3lIt8nHig9Ikg==
Message-ID: <sashiko-outbox-172866@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net 1/3] net/mlx5e: Sync CQE moderation pflags with
 coalesce params
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261014124704.1017782-2-tariqt@nvidia.com>
References: <20261014124704.1017782-1-tariqt@nvidia.com>
 <20261014124704.1017782-2-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 12:48:31 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Yael Chemla <ychemla@nvidia.com>
>=20
> mlx5e_params keeps two representations of CQE moderation: the private
> flags (MLX5E_PFLAG_RX_CQE_BASED_MODER, MLX5E_PFLAG_TX_CQE_BASED_MODER)
> and the fields rx_moder_use_cqe_mode / tx_moder_use_cqe_mode, which are
> used by ethtool get/set coalesce. Both are used by the driver (ethtool
> get/set coalesce, channel open, moderation apply). When they disagree,
> CQE moderation reported value is wrong.
>=20
> Such an issue can be seen on channel attach or reopen:
> mlx5e_build_nic_params() runs and sets rx_moder_use_cqe_mode and
> tx_moder_use_cqe_mode from device capability but did not set the
> corresponding pflags. So after attach/reopen, pflags could remain zero
> while the fields reflected hardware configuration.
>=20
> Fix by syncing pflags in build_nic_params from the capability-derived
> fields.
>=20
> Reproducer:
>=20
>     ethtool --show-priv-flags eth2 | grep rx_cqe_moder
>       rx_cqe_moder       : off
>     ethtool --coalesce eth2 adaptive-tx off
>     ethtool --show-priv-flags eth2 | grep rx_cqe_moder
>       rx_cqe_moder       : on
>=20
> Fixes: 445a25f6e1a2 ("net/mlx5e: Support updating coalescing configuratio=
n without resetting channels")
> Signed-off-by: Yael Chemla <ychemla@nvidia.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014124704.1017=
782-1-tariqt@nvidia.com?part=3D1

