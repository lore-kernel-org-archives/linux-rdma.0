Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795248152;
	b=XgWN4HfF8mKnBlURvA/JZTcjfb05o85nqfRP1zr2VfjkUUbGdEZd10Xu7crRWTwmQECg
	 lMEFMFeXzDmTOWtsZ37I1W1nkpDhss1cmh+6GDCJT4b/bxbO2v0UT32HA7k9qSuJv8oGb
	 Myhkn0EC+5cMBSvzZ666pHGnoWDyVUk0E9/p7NMHuH3he31hI2ZTyGa/SF5z/VzY/n4vT
	 o9UuR0tqJlVaHGKHHnwawPBgdJmr34PEQVcOTXRkgLoRXLua/XkDYWjJqiGO6017A+K0c
	 lrjDNbJW9/nx2mGsqqjIOWqeHbSz0HSuF3dhfCGmnhP2duHVmLYn1LTwDZxeaanyAEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795248152;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=WMALtIvXPHBEJJnsCIraip+TUoIV7FXK3aXPEPw+PI8=;
	b=avpVZofYn+Os2i6em8rfj884iCACofhFjgzTZs6+Usyh9iHtQLHGJP7IPBnuAE41FVy9
	 QuZwBzBi39hJ95VTjOdAABqGZ93oxS17MEBcvjTIK0wT6zH47uR6nxjAAPmzSKr9bozXY
	 bSd+mx2QdXeSFUvlhV8V1Foiiin8NLsXkdPliZm4BdB3kNYaNzrhv1hNTikA4FH2Hli45
	 3YlvkBHc4N1C34NLqMefO8ULXVGv5lPMw6ThLBe4AKmJ9vatLvS5YGIt2hptrHMjOVHMg
	 qskgeD4M40t+qCPYxO48EXSy+EmNw2sVF7BXnw5hjL2y29/xt/urANOzJpiI5yJiUnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lDlAHLGx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379F4606A336
	for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 08:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lDlAHLGx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC9261F000C4;
	Sat, 21 Nov 2026 08:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795248151;
	bh=WMALtIvXPHBEJJnsCIraip+TUoIV7FXK3aXPEPw+PI8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lDlAHLGxr9wPlZAUgcJ+75gPcPnhdAMjTSwx8Rz58Etw5ALlvBlV6C+jFB8Jo1F7N
	 70XAlV1VqTkITJmpA9vWj/RdWcuapypIHf+2uZphq0gRUnMWsVDfM8FCQjYcu66vN/
	 F/ObOe4j9+FubwzxDg5xUXf9oaeUIYNCVaGLw4Ym93kVjvLVVHcYx2zoZiY7ru34XD
	 nkm+ZgawMRx4LBf0kUZNFY6knVVfjQxWcqCPXWFTW+n5wOFfAaGJ05hkIGPr4fc9E9
	 HN66+PadiXYFZHsZX6NvKwhkJxUHmwNWp8AQ9TBtUvRsQQDFuxH7SzmTMkA1JYo6wy
	 bnQQQJfkinwXA==
Message-ID: <sashiko-outbox-226816@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V2 5/5] net/mlx5: LAG, enable LAG over
 functions that do not represent a physical port
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261120075959.2533702-6-tariqt@nvidia.com>
References: <20261120075959.2533702-1-tariqt@nvidia.com>
 <20261120075959.2533702-6-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 08:02:31 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] net/mlx5: LAG, empty debugfs member list in members_show()
  for virt_lag
--

commit 7460886c7aaf474929cb486d03267be648beb73f
Author: Shay Drory <shayd@nvidia.com>

net/mlx5: LAG, enable LAG over functions that do not represent a physical p=
ort

This commit enables LAG over virtual functions (such as VFs or SFs) that
sit behind a multi-uplink e-switch and do not represent a physical port.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/=
net/ethernet/mellanox/mlx5/core/lag/lag.c
> index 193fbe47fef15..2cd2319f93189 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c

[ ... ]

> @@ -2398,7 +2404,7 @@ int mlx5_ldev_add_mdev(struct mlx5_lag *ldev,
>  	fn->group_id =3D group_id;
>  	dev->priv.lag =3D ldev;
> =20
> -	if (group_id)
> +	if (group_id || ldev->virt_lag)
>  		return 0;
> =20
>  	xa_set_mark(&ldev->fns, idx, MLX5_LAG_XA_MARK_PORT);

[Severity: Medium]
Does skipping MLX5_LAG_XA_MARK_PORT here leave the lag/members debugfs
file empty for virt_lag devices?

mlx5_lag_add_mdev() calls mlx5_ldev_add_debugfs(), which registers the
members file backed by members_show():

drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c:members_show() {
	...
	mutex_lock(&ldev->lock);
	mlx5_ldev_for_each(i, 0, ldev)
		seq_printf(file, "%s\n",
			   dev_name(mlx5_lag_fn(ldev, i)->dev->device));
	mutex_unlock(&ldev->lock);
	...
}

Because mlx5_ldev_for_each() iterates with MLX5_LAG_FILTER_PORTS, which
only visits entries in ldev->fns marked with MLX5_LAG_XA_MARK_PORT,
reading lag/members on a virt_lag device will print nothing.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120075959.2533=
702-1-tariqt@nvidia.com?part=3D5
