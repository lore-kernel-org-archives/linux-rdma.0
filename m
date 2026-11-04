Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793812433;
	b=L4b4J5v3kg0hlDWa9BDRgZCI33RbvTqwgM6FUYA63sjzUh8jSqsYNF8EwfBguibQlBSy
	 7Lp7F/BmNz1LGu2rzRuhXCRr65IdOtSDV+NwgNVmICWz2Ro8DxDUdm0yRHYrzyCD5kV7E
	 A6c1B8uZGBC/b3QGkVgT7H3Dis+rMJ98VqFY5qhLsAHNfXDLbf9S5ZOkIoVfrL/EIq/sW
	 Y3srRvjit7Fib1+BxVSAq0mHcOfducGdPEBXyyegkuf/Rm00s2gQOSbVMiUa6r0oQ/fJV
	 ePZD5gb0TNdrxxiawb6BUWJZPVBy4Unwh7amLmZWTmXPyQr/vb2MRpSswKxhDkHeZZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793812433;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=eaVcmsC6mBAwPwh/4ik5DZ3ikYihldyYHFOk8ce0uFQ=;
	b=0qQQLZfAIvKEDWzarAWzNlVkuVcWkIilYYNFqupHXYSGg7GbuOitOrVwi02YsQJeSbzr
	 7xtLryuuQy7J3g7wMCcHhuNVULEFdOLB9ufyMqvoJqL4GVNUrrq80ZQxVyom+7TVOacoE
	 vpUKeBVvWqr+i+CDyGTkxHDnEMYomhjAbSm6sjTQsIw0f6h0ZIcs6SsPer8ZrFLtH8IfL
	 DTHFGUVyffaLngHoAnXbHfz7SGn8YlgZliD3YTbjvcwhbWuY8ZIqWBxGFzqsmO7qTV93T
	 7n4H8le1LIckpYcLH9lFH/ZPiCq1jbe43A4VlYUPKV6OsoJlVwaTWFiEXrZ5I9ott/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XEstyVbu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91B5606A334
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 17:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XEstyVbu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A174A1F000C1;
	Wed,  4 Nov 2026 17:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793812432;
	bh=eaVcmsC6mBAwPwh/4ik5DZ3ikYihldyYHFOk8ce0uFQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XEstyVbuhIZWZR2/i10WmO35XByVjHE/2KyMOMuP17RJvCXxlIRM0h0EsJjOke3FL
	 yOp4MVQAgfUAfzrjtLQQ7UjKP6hzOem2sMA5Oynr4PzVfQi7N/6U5JPdePbbvpQQ/S
	 e6N9g4qsmHgdjOrCPUP2rjCgRZO4zCETLaApUgfiy1FVifmvspHePzcw9eni13rmtG
	 ZYkVVZO6EjKJRbkYAEsOBo4h7/DEnwb5L6YlQZIttY9VdwwYjVN7GcADl7TjlCvuWQ
	 5vxyVgfxuOuJS3I6bgjRj9gKJmAMPyQlNMeBbkT0a+xZKUeBCfYE0LRkbsGemDyh53
	 2O9U4PTSWDIcA==
Message-ID: <sashiko-outbox-197742@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 15/15] net/mlx5: LAG, enable LAG over functions
 that do not represent a physical port
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103171009.563034-16-tariqt@nvidia.com>
References: <20261103171009.563034-1-tariqt@nvidia.com>
 <20261103171009.563034-16-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 17:13:52 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] net/mlx5: LAG, empty debugfs member list in members_show() for v=
irt_lag
--

commit a1292895cfa07137f4fbbaafed6d7e85d7e486bc
Author: Shay Drory <shayd@nvidia.com>

net/mlx5: LAG, enable LAG over functions that do not represent a physical p=
ort

This commit enables LAG over virtual functions (VFs/SFs) sitting behind a
multi_uplink_eswitch that do not represent a physical port. It skips setting
MLX5_LAG_XA_MARK_PORT on these functions, avoids registering the netdev
notifier or adding netdevs, and reports at least one port in
mlx5_lag_get_num_ports().

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/=
net/ethernet/mellanox/mlx5/core/lag/lag.c
> index 4e15e16ae6e84..5532b2505161c 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c

[ ... ]

> @@ -2399,7 +2402,7 @@ int mlx5_ldev_add_mdev(struct mlx5_lag *ldev,
>  	fn->group_id =3D group_id;
>  	dev->priv.lag =3D ldev;
> =20
> -	if (group_id)
> +	if (group_id || ldev->virt_lag)
>  		return 0;
> =20
>  	xa_set_mark(&ldev->fns, idx, MLX5_LAG_XA_MARK_PORT);

[Severity: Medium]
When a virt_lag device is added in mlx5_lag_add_mdev(), it registers the lag
debugfs entries via mlx5_ldev_add_debugfs(), including the members file bac=
ked
by members_show().

Since mlx5_ldev_add_mdev() returns early when ldev->virt_lag is set before
marking the xarray entry with MLX5_LAG_XA_MARK_PORT, no member in ldev->fns
has the port mark. However, members_show() iterates with mlx5_ldev_for_each=
(),
which uses MLX5_LAG_FILTER_PORTS:

drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c:members_show() {
	ldev =3D mlx5_lag_dev(dev);
	mutex_lock(&ldev->lock);
	mlx5_ldev_for_each(i, 0, ldev)
		seq_printf(file, "%s\n",
			   dev_name(mlx5_lag_fn(ldev, i)->dev->device));
	mutex_unlock(&ldev->lock);
}

Won't reading the lag/members debugfs file on a virt_lag device always
produce empty output?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103171009.5630=
34-1-tariqt@nvidia.com?part=3D15
