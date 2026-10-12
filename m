Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D0529BD8C
	for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 11:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791804587; cv=none; b=CHhmPGwFRoNURKJb0g2vu/phWB2pF1n/V+07cBhacU/zcRIos0F0/rpGV3lSk+83T94fDQMOamMUXsZfM6nYbUTlUQ4JcD9MFtwX49qAvNOr9CJGGP8qZm+v7q2Z08CxyWLoLVvWo2tg5+f1DUmN4kwlaPXgsN9Snnn6ewZ3hPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791804587; c=relaxed/simple;
	bh=J6Jn1vaIa2biS/yjTA9If5soaex98HYclnXcMe6/eK4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=tE2SNC9Pu/CGJdnQ5YSUZfAD++qe1G+EL6O52GSgmjyR9nFxJcuOHe4AYtSiOn1fch7UpIiqlG3yitveKU/bSct4zgTYK3gQTnDvyGQ1E/pNc6+2aRgWQAdprUO7U/R/V5xp6V3iKEzbZgxUmQ7exXl1EsPSxcjEWatNiI9ViIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XOMXVdb3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XOMXVdb3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C46791F0089B;
	Mon, 12 Oct 2026 11:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791804586;
	bh=0WXFous1SUPBvIMen+c3VXxqNjJmEfu/40IqetB3Jh8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XOMXVdb3/Nf+BQU0RZ8jPtXcJu9Sp2V1rnbbzKhQbpXgOHoqHLX6qAfP7XmCoFOLJ
	 tf247nyM5CJkvl82KRmVlfMjGm8Ruu37fWBWivnrOzOROvu6XyJxqeSggJtg/R/FBs
	 5Rle+1lNXv+a7y78MfLM1N2scCkpg/kjLqbpk0A4Rgx+lRDT7WzNg3qieSOvLpFkB7
	 iAfdiRrwr2YKol8f4NFGeH3qvOJxpVqisrtBkcGWGTRWL7U5HVFQukaL2Ntuig4TJI
	 ow504TF9Mre2xRjcGezv+2b20yPj0OuoNI8O3UWECBP4Rrttyo4P0827aCL9Uvv10W
	 2KbnpuJwjNSjw==
Message-ID: <sashiko-outbox-168016@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 2/2] net/mlx5e: Add DCB_CAP_DCBX_LLD_MANAGED
 support in setdcbx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261011112900.802150-3-tariqt@nvidia.com>
References: <20261011112900.802150-1-tariqt@nvidia.com>
 <20261011112900.802150-3-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 11:29:45 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] net/mlx5e: DCBX capabilities update silently ignored and LLD_MAN=
AGED missing on boot
--

commit 64b98b95142563c858de976f308b2006891e9c00
Author: Alexei Lazar <alazar@nvidia.com>

net/mlx5e: Add DCB_CAP_DCBX_LLD_MANAGED support in setdcbx

Add support for DCB_CAP_DCBX_LLD_MANAGED, which indicates that DCBX
negotiation is performed by the firmware/LLD agent rather than the host.
When DCB_CAP_DCBX_LLD_MANAGED is requested, switch to
firmware-controlled DCBX mode.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers=
/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
> index 4eef929f5ae9b..68deedb6f82ec 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
> @@ -439,9 +439,6 @@ static u8 mlx5e_dcbnl_setdcbx(struct net_device *dev,=
 u8 mode)
>  	struct mlx5e_dcbx *dcbx =3D &priv->dcbx;
>  	enum mlx5_dcbx_oper_mode target_mode;
> =20
> -	if (mode & DCB_CAP_DCBX_LLD_MANAGED)
> -		return 1;
> -

[Severity: Medium]
If a user issues a setdcbx request to modify capabilities (like CEE/IEEE)
but keeps the same DCB_CAP_DCBX_HOST bit, target_mode won't change.  Will
this cause the function to return 0 early and skip the dcbx->cap update?

drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c:mlx5e_dcbnl_setdcbx() {
	target_mode =3D new_is_host ? MLX5E_DCBX_PARAM_VER_OPER_HOST :
				    MLX5E_DCBX_PARAM_VER_OPER_AUTO;
	if (dcbx->mode =3D=3D target_mode)
		return 0;
	...
	dcbx->cap =3D mode;
}

This appears to be a functional regression introduced when the switch-to-ho=
st
and switch-to-auto logic was folded into one path.

Additionally, since DCB_CAP_DCBX_LLD_MANAGED is now supported, does the
initialization logic need to be updated to report it in AUTO mode on boot?

drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c:mlx5e_dcbnl_initialize()=
 {
	priv->dcbx.cap =3D DCB_CAP_DCBX_VER_CEE |
			 DCB_CAP_DCBX_VER_IEEE;
	if (priv->dcbx.mode =3D=3D MLX5E_DCBX_PARAM_VER_OPER_HOST)
		priv->dcbx.cap |=3D DCB_CAP_DCBX_HOST;
	...
}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261011112900.8021=
50-1-tariqt@nvidia.com?part=3D2
