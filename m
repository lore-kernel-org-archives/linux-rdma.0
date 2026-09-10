Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B98B457E76;
	Thu, 10 Sep 2026 21:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789077279; cv=none; b=KHtRJ9LFfiFqtAIcvCiiGRjRnPSS+t423/f29SwekuAPx5h1/JHZDf6+qzMDzzkFx3qe54whbYK1Hxg0sI64NcklAu/XzjzycI8X2OS0U3ujSVGXdYR3TL2Zbkb+wQceb1DSExgYU1BWABUuMpBYMWVn6PN8jke2ZyZsIZjLwWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789077279; c=relaxed/simple;
	bh=mymvh+C5y57DOwgNGI0tFgJk47ni6jiScNxb7gW7x8U=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bbi3tq0u2ON+QHOwXbFaOjvSTZD9Nqyz9QZajbDy9NRoS0sYTW9nJqpId9Krc4Y9qHsTqJcXG+rcrR2C5DiyhMk0NiABjCiG1RYaSxHtL5CbGCBgbPaQONL4NeBDPyBGLu6gezRzrbD+0vTAeVjyCt02w19Ptwgg6usq8hDImDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ElSisVVz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ElSisVVz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F451F000FF;
	Thu, 10 Sep 2026 21:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789077277;
	bh=bOmbMRVPhEjBQMu73RN2GS0UGFB3o3X1o99OAz2BmCM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ElSisVVz4gpeEhSIF4W2t9bZ3GpFRTiv09FEl29STuDeO7qt5L5pNNkDQqF0xst5J
	 ZvJGdGEOsnanMsvIG0dkieJXMTRzzEFOLptNcCM4iKRQqarI7kCD5gamqAlTne+lU/
	 OajaeiavFQiijmkkHl12Z7nWxWwbTt9yQkVsmt4hXWtPWh+bVRcsR44T5Yu0xWS20h
	 uvXMUd+6SnDA1DW8LWi8BlprXX0Wi+aPXHM9JmKUjqQ2DFD/cIzOA4e8/uzg6sMGyb
	 9lfgjGWSkMpZfqeHQ9yWh8907G6ADC7qBGlvIZQwcLzE1O/0pGVkjadCjWqdR31l3U
	 6O7EBDUjfGRZA==
Subject: Re: [PATCH net-next V4 11/14] net/mlx5e: psp: Dynamically reconfigure
 based on SHAMPO mode
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 sd@queasysnail.net, bobbyeshleman@meta.com, borisp@nvidia.com,
 cjubran@nvidia.com, cratiu@nvidia.com, daniel.zahka@gmail.com, doruk@0sec.ai,
 dtatulea@nvidia.com, gal@nvidia.com, jianbol@nvidia.com, kees@kernel.org,
 leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org,
 mbloch@nvidia.com, petrm@nvidia.com, raeds@nvidia.com, rrameshbabu@nvidia.com,
 saeedm@nvidia.com, shuah@kernel.org, skhan@linuxfoundation.org,
 horms@kernel.org, willemb@google.com, willemdebruijn.kernel@gmail.com
Date: Thu, 10 Sep 2026 21:54:35 +0000
Message-ID: <178907727544.219967.2356323073395306766@kernel.org>
In-Reply-To: <20260908065244.3799142-12-tariqt@nvidia.com>
References: <20260908065244.3799142-12-tariqt@nvidia.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 1 · Low: 0

- [Medium] In mlx5e_update_nic_rx()
  (drivers/net/ethernet/mellanox/mlx5/core/en_main.c:6289-6300) the…

--

net/mlx5e: psp: Dynamically reconfigure based on SHAMPO mode

This adds an mlx5e_update_nic_rx() -> mlx5e_accel_update_rx() ->
mlx5e_psp_update_rx() hook so PSP steering can switch between standard and
decap modes when the SHAMPO mode changes.  It also enables decap at fs
creation time when shampo_enabled() says so.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c
> index 84133cbf8689..c40d2ddf6af2 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c

[ ... ]

> @@ -1355,3 +1363,14 @@ void mlx5e_psp_cleanup(struct mlx5e_priv *priv)
>  	priv->psp = NULL;
>  	kfree(psp);
>  }
> +
> +void mlx5e_psp_update_rx(struct mlx5e_priv *priv)
> +{
> +	struct mlx5e_psp *psp = priv->psp;
> +
> +	netdev_assert_locked(priv->netdev);
> +	if (!psp || !psp->fs->check.ft)
> +		return;
> +
> +	accel_psp_fs_rx_reconfigure(psp->fs, shampo_enabled(priv));
> +}

[ ... ]

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index fc110a7d16e8..b5449d849838 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -6288,7 +6288,15 @@ static void mlx5e_nic_disable(struct mlx5e_priv *priv)
>  
>  static int mlx5e_update_nic_rx(struct mlx5e_priv *priv)
>  {
> -	return mlx5e_refresh_tirs(priv->mdev, false, false);
> +	int err;
> +
> +	err = mlx5e_refresh_tirs(priv->mdev, false, false);
> +	if (err)
> +		return err;
> +
> +	mlx5e_accel_update_rx(priv);
> +
> +	return 0;
>  }

[Severity: Medium]
Should the new PSP hook be gated on the TIR refresh result?  The two
operations look unrelated (TIR self-loopback refresh versus the PSP check
rule destination), so a failing mlx5e_refresh_tirs() now also skips the PSP
steering reconfiguration.

mlx5e_refresh_tirs() does have reachable failure modes on devices where
MLX5_CAP_GEN(mdev, tis_tir_td_order) is 0, since it then calls
mlx5e_modify_tirs_lb() in en_common.c, which returns -ENOMEM when
mlx5e_tir_builder_alloc() fails and otherwise propagates the MODIFY_TIR
firmware error:

drivers/net/ethernet/mellanox/mlx5/core/en_common.c:mlx5e_modify_tirs_lb() {
	builder = mlx5e_tir_builder_alloc(true);
	if (!builder)
		return -ENOMEM;
	...
		err = mlx5e_tir_modify(tir, builder);
		if (err) {
	...
			break;
}

The live reconfiguration caller does not look at the return value either,
and it has already committed the new channel params by then:

drivers/net/ethernet/mellanox/mlx5/core/en_main.c:mlx5e_switch_priv_channels() {
	priv->channels = *new_chs;
	...
	priv->profile->update_rx(priv);
	...
	mlx5e_activate_priv_channels(priv);
}

In that case the datapath runs with the new packet_merge.type while
fs->decap_enabled still reflects the old mode, and nothing re-evaluates it,
because shampo_enabled() is only consulted from mlx5e_psp_update_rx() and
accel_psp_fs_create().  When SHAMPO has just been enabled the PSP check rule
keeps pointing at fs->rx.ft rather than fs->decap.ft, so HW GRO for PSP stays
unavailable, and unlike accel_psp_fs_rx_reconfigure()'s own error path there
is no mlx5_core_warn() to indicate it.

The RX path itself appears to tolerate the mismatch, since
mlx5e_psp_is_decap() keys off the per-CQE flow tag and en_rx.c flushes the
SHAMPO session for non-decap PSP packets, and the state self-heals on the
next channel switch or open.  Would calling mlx5e_accel_update_rx(priv)
unconditionally, or before mlx5e_refresh_tirs(), be preferable here?

This condition is still present at the end of the series
(a9e41034d482a6cbfe0487f9ed8050c5bf5c3ce1), where mlx5e_update_nic_rx() is
unchanged.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260908065244.3799142-1-tariqt%40nvidia.com
