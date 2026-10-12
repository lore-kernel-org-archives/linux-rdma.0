Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9634078D5;
	Mon, 12 Oct 2026 12:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791807021; cv=none; b=CHeiFhQ6ydWVlsxbbfzbJdCQZ6ZzjfCnN/zcDQd6vwnwA5VwrERjXzf3ezSEwYOdxGRmNOcBaRb4MeoUiC4r7qzZgCDbZvi1W2wl9PYGwjHxY1cqd13kQ8vbFRtoEcN8Bpft7JR6hPz6SPdTejcvvFybzOndwAym0oH+8uUlzS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791807021; c=relaxed/simple;
	bh=vxLZ0oip0RIsBZ3MyUKRvdS5w0mR+vgj5jMxJWA+0Q0=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=d4IBywOC8QNk7PD8MMjlm0so3BIShzu6iskRrZ41ESAjQDmFTQJ73DnyonQ5SvKnXLKNz6lxF8sXNltznL1xZRei0ynv4wfpA7dvdoXd83tmg5SsFdcHKdhVw1csB17iq+XcI6kz1Ioj/IyJw8rzc9Y1dctmj6zKBTOX/tMlcRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aNQxh/Wz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aNQxh/Wz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9891F0089C;
	Mon, 12 Oct 2026 12:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791807020;
	bh=Fb8bIoSOEH/M7ZSTus3O5Um9HCWjENggLSemxOw5j0w=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=aNQxh/WzXQcdT7EELSwdqE0oh14YAjJLcrNd232EoBk5E35UJa0JBPCbYeRYjfVrD
	 TKfYhr71BcqZWGBamEr7a01C9fHPUJlUSaMs7gl6uGY6B/uZ7d67LFLrY1t9Tz/obK
	 juB177RZv0eCgVzixmYevjX4mZFrlaEOfoo8Japw8NoMz9PW4kRd2aH7yc+vp+H6Ok
	 0PJQVSD8ADEkZwAFtix91v24RMgYrOfbvrxnKjuM+TUpHMGKc/acXOzdCcNSorAwrI
	 D6EKseNQlwfYfzktVpuzyX7sslUbGd+NnrkHjWkBLtjuIXL7XqGdHsfD6xvY9rNGbq
	 2Xv5W2iHVXxbw==
Subject: Re: [PATCH net-next 2/2] net/mlx5e: Add DCB_CAP_DCBX_LLD_MANAGED
 support in setdcbx
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, alazar@nvidia.com,
 cjubran@nvidia.com, dtatulea@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 saeedm@nvidia.com
Date: Mon, 12 Oct 2026 12:10:19 +0000
Message-ID: <179180701909.434549.143908281257445247@kernel.org>
In-Reply-To: <20261011112900.802150-3-tariqt@nvidia.com>
References: <20261011112900.802150-3-tariqt@nvidia.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 2 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] mlx5e_dcbnl_setdcbx() in
  drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c now returns success…
- [Medium] With the `if (mode & DCB_CAP_DCBX_LLD_MANAGED) return 1;`
  guard removed, mlx5e_dcbnl_setdcbx() looks only at the HOST bit…

--

net/mlx5e: Add DCB_CAP_DCBX_LLD_MANAGED support in setdcbx

This patch removes the early rejection of DCB_CAP_DCBX_LLD_MANAGED in
mlx5e_dcbnl_setdcbx(). An LLD_MANAGED request now switches the device to
firmware-controlled DCBX mode instead of failing.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
> index 4eef929f5ae9..68deedb6f82e 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
> @@ -439,9 +439,6 @@ static u8 mlx5e_dcbnl_setdcbx(struct net_device *dev, u8 mode)
>  	struct mlx5e_dcbx *dcbx = &priv->dcbx;
>  	enum mlx5_dcbx_oper_mode target_mode;
>  
> -	if (mode & DCB_CAP_DCBX_LLD_MANAGED)
> -		return 1;
> -

[Severity: Medium]
An LLD_MANAGED request now returns success. If the firmware was already in
AUTO mode at probe, will LLD_MANAGED ever be reported back?

In the firmware-managed case, mlx5e_dcbnl_initialize() sets the cap
without LLD_MANAGED:

	priv->dcbx.cap = DCB_CAP_DCBX_VER_CEE |
			 DCB_CAP_DCBX_VER_IEEE;
	if (priv->dcbx.mode == MLX5E_DCBX_PARAM_VER_OPER_HOST)
		priv->dcbx.cap |= DCB_CAP_DCBX_HOST;

A later DCB_CMD_SDCBX with LLD_MANAGED gives new_is_host == false and
target_mode == MLX5E_DCBX_PARAM_VER_OPER_AUTO. That matches dcbx->mode,
so mlx5e_dcbnl_setdcbx() returns early and never reaches
dcbx->cap = mode:

	if (dcbx->mode == target_mode)
		return 0;

After that, mlx5e_dcbnl_getdcbx() still returns CEE|IEEE.
mlx5e_dcbnl_getcap(DCB_CAP_ATTR_DCBX) also leaves out LLD_MANAGED.

But after a HOST->AUTO switch through setdcbx, the same firmware state
reads back as CEE|IEEE|LLD_MANAGED:

	if (!new_is_host)
		mode = DCB_CAP_DCBX_VER_CEE |
		       DCB_CAP_DCBX_VER_IEEE |
		       DCB_CAP_DCBX_LLD_MANAGED;

Should mlx5e_dcbnl_initialize() also set DCB_CAP_DCBX_LLD_MANAGED when the
mode is AUTO? Then both paths would report the same state.

>  	if (!MLX5_CAP_GEN(priv->mdev, dcbx))
>  		return !new_is_host;
>  

[Severity: Medium]
What happens when a request sets both HOST and LLD_MANAGED?

dcbnl_setdcbx() in net/dcb/dcbnl.c passes the u8 from userspace straight
to the driver without checking it. The uAPI header in
include/uapi/linux/dcbnl.h defines HOST and LLD_MANAGED as opposite owners
of DCBX negotiation.

Only the HOST bit picks the target mode:

	bool new_is_host = mode & DCB_CAP_DCBX_HOST;

So a request like HOST|LLD_MANAGED|IEEE now selects
MLX5E_DCBX_PARAM_VER_OPER_HOST and switches the firmware to host mode.
That is the opposite of what LLD_MANAGED asks for.

The !new_is_host normalisation is skipped, so dcbx->cap = mode stores
HOST|LLD_MANAGED|IEEE. mlx5e_dcbnl_getdcbx() then reports that both the
host and the LLD own DCBX.

On devices without MLX5_CAP_GEN(priv->mdev, dcbx), the same request now
returns !new_is_host, which is 0 (success), and changes nothing. Before
this patch it returned 1.

Other drivers such as ixgbe, mlx4, i40e, ice and hns3 reject LLD_MANAGED
combinations they can't honour. Should this reject LLD_MANAGED when HOST is
also set, or else define what that combination means?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261011112900.802150-1-tariqt%40nvidia.com
