Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794422431;
	b=afx/2FPcYgeGmgfPETgaRzNKqdj6GfUivs6U544UvA1lIZsBRXCpzwkJLkq2fMcR5Dds
	 ZJJfFlZwQpHDp934LU+Lx8Im1uwvsy+hZC0NtCQIuuMxRVRnrf7jlunVXrsYJU4PLD/g+
	 MSe9XBCIrBsVMImhD84sDTuLj0TqDHUUIUKboIoL30OD/it8+9RNscnccL04fIZmiJzY5
	 xrpQNP9vUtSTUUnDLtokJrtsSkcuylQuHpO1CUTKkTjAl/Vsv47jP8NQKo0ZYrM679Sot
	 si70d8DHuTjD3kLXXeBgxQx0dl+oENHqCiDviyCudf2NAl9OewBrSG63uhWCG/FqneQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794422431;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=XvHvQh9BI5ME6id9h1vB4In0L+d8d2e2BDnZ9Wxio1I=;
	b=op2prdnMGmPgSFv1krcbTEgta33PI+QzVpmEgN56CX0f+wYIpvNGiiHPWw/DJTtE8sw6
	 +5NWIH1FWjPcq4fCBJ+IhVHQA8Y/d7iuFH7/GmAfieRQgCRP5haNc3m8q2eUgJfwuFVy7
	 mHzNnBeiqJdCIT5UC8q/KrD3Tjwjh0GM5dfSVvvbdKbsk4tlMk8HMSOh8aTWSVerKi1v+
	 SsEIVIRASWoYFZEETZ3zSGMzhuukzvoxu9gekWbJPUPI4gnWNiY0gQ0wJ71itS/EYOXJq
	 /JfOC3igG0IHWqI5wvJKtMV+JKOxx9U4NSuq6W4cjIUo3LrlJEAm1gxlrL1/TXKbQxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JDUn8lm4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D5E606A321
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 18:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JDUn8lm4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47CEF1F00A06;
	Wed, 11 Nov 2026 18:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794422431;
	bh=XvHvQh9BI5ME6id9h1vB4In0L+d8d2e2BDnZ9Wxio1I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JDUn8lm42FVKgz4rf4BfxJw5UQpyiCEIrqBj967Si07Apk51mywvAHmcOQuWPP4rT
	 Cp7rvm0jZxWoZlOVMSfmKixYkPyKDH336Ks94WYnguiyY3O6QF0EB1pKvyZhfl5pqT
	 S5ogft2xsrLtASjQePBvdEyb8AEKCSjZkPBEdiuT7ZhfAMPYwHqWfoHFAC7L553ACu
	 w30naXOvkzuni145yrUSS4R/p17TbZoDIWKcKL7WsBr2ym5+Rr07loHBUv48QbpY5E
	 HPElDrZ/qQGeVKyaukVY8mljUvbKJVtaTftLNzjkgsJ5ehuZV7NM1dLI5Ss7vFezpJ
	 UvW1kEYjJio5g==
Message-ID: <sashiko-outbox-209470@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V2 02/13] net/mlx5: Detach auxiliary devices on
 attach failure during load
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110183826.2927274-3-tariqt@nvidia.com>
References: <20261110183826.2927274-1-tariqt@nvidia.com>
 <20261110183826.2927274-3-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 18:40:30 +0000
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
- [High] net/mlx5: pass suspend=3Dfalse to mlx5_detach_device() on
  err_attach path
--

commit c641732ab192276884adbc4d8e49ff0e43bff599
Author: Dragos Tatulea <dtatulea@nvidia.com>

net/mlx5: Detach auxiliary devices on attach failure during load

This commit calls mlx5_detach_device() on the error path in
mlx5_load_one_devl_locked() when mlx5_attach_device() fails.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net=
/ethernet/mellanox/mlx5/core/main.c
> index 1a45474ce03db..7e762f72b19ef 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> @@ -1547,6 +1547,7 @@ int mlx5_load_one_devl_locked(struct mlx5_core_dev =
*dev, bool recovery)
>  	return 0;
> =20
>  err_attach:
> +	mlx5_detach_device(dev, true);
>  	clear_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state);
>  	mlx5_unload(dev);
>  err_load:

[Severity: High]
Should this pass suspend =3D false instead of true to mlx5_detach_device()?

When suspend is true, mlx5_detach_device() invokes adrv->suspend() and
skips del_adev() for auxiliary drivers that implement .suspend (eth and
dpll), leaving those auxiliary devices registered while mlx5_unload() and
mlx5_function_teardown() tear down the core device:

drivers/net/ethernet/mellanox/mlx5/core/dev.c:mlx5_detach_device() {
    ...
		if (adrv->suspend && suspend) {
			adrv->suspend(adev, pm);
			continue;
		}

skip_suspend:
		del_adev(&priv->adev[i]->adev);
		priv->adev[i] =3D NULL;
    ...
}

For dpll, mlx5_dpll_suspend() is a no-op, so its periodic delayed work
mdpll->work remains active and continues issuing firmware commands against
the torn-down core device.  For eth, suspending instead of deleting leaves
the netdev registered with MLX5E_STATE_DESTROYING set after destroying
mdev_resources, which causes a later _mlx5e_remove() -> _mlx5e_suspend()
to destroy mdev_resources a second time, and on a Socket-Direct secondary
mlx5e_suspend() clears mdev->sd so a subsequent mlx5e_remove()
dereferences NULL drvdata on the secondary adev.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110183826.2927=
274-1-tariqt@nvidia.com?part=3D2
