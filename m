Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4C04E780A
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 11:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730196; cv=none; b=cWljYizAZUUhetfnJEvqwzGZhrDJLK99nXdAuUsyxhqiSySB6YLfMgd9XCixKOyLcnTtVLm92BzqNxJAUh8qFSLQZQT19Bs3jUeH+f04u1gSxLhbqlgR1aE+r6Y0pfy4Pb7s0W6CxDsIDojFYHFuYzeNpX1OWt4SmG239MvFUTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730196; c=relaxed/simple;
	bh=jXqnkNZSTZgMR2dvqP5lZOHI9oFyIh7oA4P6Fnylk2s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=j7Z+uy9WOM8Ab1sbB4o+DDrYqWYO4mr8Py60Mje9uEsdtmwTHMEzlhvvg5FqcHQRekz5/VAZ2WaKpn+3krkGM1h3ei9sEJazpOUjov5tmzcnXS4l7RUdSCn18/qUdMU3TuSwtTGQQYwC1befShAJPlABYG7JYr59YeXae6maWHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H13tKr4S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H13tKr4S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B8BD1F00893;
	Fri, 18 Sep 2026 11:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789730194;
	bh=GAfXx0kj2d3Yef7H4wRHVaSL6OZVozIzBuJyr6ghVss=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=H13tKr4S2ob621R0osZnIhzmTriW24HZunwiXKlBX8qWkl0I3cfm8Wm/n8bKjklxg
	 Lqf5okmdXlduXEFlbXzP264dRtDLvVjcIpC0FdNa4f51PIGVMdayfhf+3aoWMIzFQP
	 Bik6SD/wsdv02qkaaJvGwbKI2N1UfrqOJUtIWNxvGX7UlIG4MLjVmAHNpdeF3cYoEj
	 uaDqGLJlBLufUVSD34GjiZwwHnfN9opRMsc2tzyN+RALPcGnMmqLrNNTQnrOi/rtS4
	 DHTGxtkyGISPS0trfHaxOWvUH7Q1NwqXrcEL+VjckObuya/v5sVdy+QF8T0vujBtV/
	 nCba6DmKAWVJg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH mlx5-next 10/10] mlx5: Move data direct implementation
 to mlx5_core
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917111422.4054862-11-tariqt@nvidia.com>
References: <20260917111422.4054862-1-tariqt@nvidia.com>
 <20260917111422.4054862-11-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 11:16:33 +0000
Message-Id: <20260918111634.4B8BD1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] mlx5: fatal device probe failure on optional data direct init error
--

commit 99d3c5a833c6ca3bd3a1b016b15bbb8a8b597a79
Author: Dragos Tatulea <dtatulea@nvidia.com>

mlx5: Move data direct implementation to mlx5_core

This commit moves the data direct implementation from mlx5_ib to mlx5_core
so it can be used by netdev devices. The data direct initialization is moved
to mlx5_load() and resource creation is managed by the core driver.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/data_direct.c b/driv=
ers/net/ethernet/mellanox/mlx5/core/data_direct.c
> rename from drivers/infiniband/hw/mlx5/data_direct.c
> rename to drivers/net/ethernet/mellanox/mlx5/core/data_direct.c
> index 3878c4aebb2c6..67717110feab0 100644
> --- a/drivers/infiniband/hw/mlx5/data_direct.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/data_direct.c

[ ... ]

> -	err =3D mlx5_data_direct_query_vuid(ibdev->mdev, reg->vuid);
> +	err =3D mlx5_data_direct_query_vuid(mdev, reg->vuid);
>  	if (err) {
> -		mlx5_ib_warn(ibdev, "Failed to query VUID, disabling data direct, err=
=3D%d\n",
> -			     err);
> +		mlx5_core_warn(mdev,
> +			       "Failed to query VUID, disabling data direct, err=3D%d\n",
> +			       err);
>  		kfree(reg);
> -		return err;
> +		return -EINVAL;
>  	}

[Severity: High]
In mlx5_data_direct_init(), does this code inadvertently cause a fatal probe
failure? The warning claims the optional feature is being disabled, but
returning -EINVAL bubbles up and aborts the entire core driver probe. If the
intent is to gracefully disable the feature when the VUID query fails,
shouldn't it return 0 instead?

[ ... ]

> -int mlx5_data_direct_register(struct mlx5_ib_dev *ibdev,
> +int mlx5_data_direct_register(struct mlx5_core_dev *mdev,
>  			      struct notifier_block *nb)
>  {
>  	struct mlx5_data_direct_registration *reg;
> =20
> -	if (!mlx5_data_direct_supported(ibdev->mdev))
> +	if (!mlx5_data_direct_supported(mdev))
>  		return 0;
> =20
> -	reg =3D container_of(ibdev->data_direct,
> -			    struct mlx5_data_direct_registration, dd);
> +	reg =3D container_of(mdev->data_direct,
> +			   struct mlx5_data_direct_registration, dd);

[Severity: High]
If mlx5_data_direct_init() is modified to return 0 on failure to allow
graceful degradation, will this code in mlx5_data_direct_register() trigger
a NULL pointer dereference?

It appears mlx5_data_direct_supported() only checks hardware capabilities,
blindly assuming mdev->data_direct is allocated. Should
mlx5_data_direct_supported() also check if mdev->data_direct is valid, or
should there be an explicit check here?

[ ... ]

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net=
/ethernet/mellanox/mlx5/core/main.c
> index 643b4aac20336..34f0375b68513 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c

[ ... ]

> @@ -1339,8 +1340,14 @@ static int mlx5_load(struct mlx5_core_dev *dev)
>  	if (err)
>  		goto err_traps_reg;
> =20
> +	err =3D mlx5_data_direct_init(dev);
> +	if (err)
> +		goto err_data_direct;
> +
>  	return 0;

[Severity: High]
Does propagating the error from mlx5_data_direct_init() here in mlx5_load()
unintentionally disable the entire NIC (both Ethernet and IB) when the
optional data direct initialization fails?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917111422.4054=
862-1-tariqt@nvidia.com?part=3D10
