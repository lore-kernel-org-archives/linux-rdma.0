Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D7934EF0C
	for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 11:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791804587; cv=none; b=GvwgsOFSnZWgMdpkvhuHRssH1lBcoS5PdzJRF1xEHqVKI2Ge5l7Vcm38pzwzDa2wyRtLjdqMxi2WKX6/ZQaVAOIt9BnLa4z9G6WvRQcapNcDdJDjrOAovf6UqMu5lEpD3MXKcbLxn+iIFHd2UEf3vxLa6QX8b5/L1QRzpGQiM8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791804587; c=relaxed/simple;
	bh=QuK5ddb48HoIZpXskGfWJs3dUeEh1WNT8LlQO7VhuIg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=sdjkmd9kpMPCdb8boRTVFtt5UwJv6G0Kmpu5VhNb0A0+aqMsxK1xu+Zf3qiyFvcinW0il5HH6164+aeSrMpgl02rcE/nX7hgJ6LkdL14JYegdrQ2hlsIvl1vS6/i3jsVB9Bg4bfmD28Cg3oLrh63wO0aZx2yZVrkbB1v3Q/LFBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WldJYyPT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WldJYyPT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783211F0089C;
	Mon, 12 Oct 2026 11:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791804586;
	bh=yTGB2XYUqgSai6WZaxPIwFHeS1PtVx8o3R3QQ8BUQ+c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WldJYyPTrNo2hIXceCwvzyhVrtW4nWDC4aMFMMQEjDpbhLWwRD1EaOcwZEa0iWEbS
	 el2BBth9wkbZnvcYqs1HMCaVfIclKWcsWQBYIPM7KUJ6MTyte8h+B2J1RNKZI/nn4w
	 rDPFDcePCwKS2XuGgRo2tj5NWx5gDvulosXP419WgZC/uMmMD9DhjVjIHB55AG9UMV
	 R3jaZlv9glz5IVifax3ACYzOObDyQVkHev+u+RHx6qK2prY1A7eIwSO/vilG27spHw
	 JjMA/jlWGtGamLFcQtrz+lDtZB4u4DUsh7DF16mclmWOJmpl1PCgkjmj0/haviIeel
	 uyPFSvHOflHxw==
Message-ID: <sashiko-outbox-168017@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 1/2] net/mlx5e: Select DCBX HOST/AUTO from
 capability flags in setdcbx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261011112900.802150-2-tariqt@nvidia.com>
References: <20261011112900.802150-1-tariqt@nvidia.com>
 <20261011112900.802150-2-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 11:29:46 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] net: mlx5e: stale DCBX capabilities reported due to skipped dcbx=
->cap update
--

commit d9bd56bb438776afa3f0fbae89fef22fddf584b9
Author: Alexei Lazar <alazar@nvidia.com>

net/mlx5e: Select DCBX HOST/AUTO from capability flags in setdcbx

This commit switches the firmware HOST/AUTO modes based on the
DCB_CAP_DCBX_HOST bit rather than using mode 0. It also attempts to
simplify the code by folding two different execution paths into one.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers=
/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
> index 741f75b5bfec5..4eef929f5ae9b 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
> @@ -453,32 +434,31 @@ static u8 mlx5e_dcbnl_getdcbx(struct net_device *de=
v)
> =20
>  static u8 mlx5e_dcbnl_setdcbx(struct net_device *dev, u8 mode)
>  {
> +	bool new_is_host =3D mode & DCB_CAP_DCBX_HOST;
>  	struct mlx5e_priv *priv =3D netdev_priv(dev);
>  	struct mlx5e_dcbx *dcbx =3D &priv->dcbx;
> +	enum mlx5_dcbx_oper_mode target_mode;
> =20
>  	if (mode & DCB_CAP_DCBX_LLD_MANAGED)
>  		return 1;
> =20
> -	if ((!mode) && MLX5_CAP_GEN(priv->mdev, dcbx)) {
> [ ... ]
> +	if (!MLX5_CAP_GEN(priv->mdev, dcbx))
> +		return !new_is_host;

[Severity: Medium]
When the hardware lacks DCBX capability and new_is_host is true, this
early return evaluates to 0 (success). Does this inadvertently skip the
dcbx->cap =3D mode assignment at the end of the function?

If a privileged user updates the capabilities, it appears they will be
silently dropped, causing mlx5e_dcbnl_getdcbx() to report stale values.

> =20
> +	target_mode =3D new_is_host ? MLX5E_DCBX_PARAM_VER_OPER_HOST :
> +				    MLX5E_DCBX_PARAM_VER_OPER_AUTO;
> +	if (dcbx->mode =3D=3D target_mode)
> +		return 0;

[Severity: Medium]
If the hardware is already in the target operational mode, this also returns
early and skips the dcbx->cap =3D mode assignment. Could this cause valid
capability bit changes (such as switching between CEE and IEEE) to be lost?

In the previous implementation, these paths fell through and correctly
updated the software capability state.

> =20
> -	if (!(mode & DCB_CAP_DCBX_HOST))
> +	if (mlx5e_dcbnl_set_dcbx_mode(priv, target_mode))
>  		return 1;
> =20
> -	if (mlx5e_dcbnl_switch_to_host_mode(netdev_priv(dev)))
> -		return 1;
> +	if (!new_is_host)
> +		mode =3D DCB_CAP_DCBX_VER_CEE |
> +		       DCB_CAP_DCBX_VER_IEEE |
> +		       DCB_CAP_DCBX_LLD_MANAGED;
> =20
> +	dcbx->mode =3D target_mode;
>  	dcbx->cap =3D mode;
> =20
>  	return 0;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261011112900.8021=
50-1-tariqt@nvidia.com?part=3D1
