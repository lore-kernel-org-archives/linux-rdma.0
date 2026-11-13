Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794557184;
	b=v6TdMXiac732MHhTrLapKnHJwVlVy0use34H6ZsEg2gKdVckiQ/Nc2FbJnZMOtGIOMWx
	 t5rfI1RPqViTHLjhHSlG5Tm0Fu4ZkF75L8LG69Rzq1XvMcUkHLeQFLlZEs9N97Lfo+YqM
	 xpQwqVpqc3CjM82k3b2Dab1gNEt9fx/yUQkOkx2DXDVA7YaIRjUcOvVUdjx38wIyW07Ca
	 TCgfRERnF0GtalBQpCUyZLoELGcbxYGX81HfLOkIZG/7DxerQbPeVO1lqprBppIvU8nBj
	 sphYJGcZR2NZ3f7WJ00RW1J2E4bUTlGpmcKe2btlMxKMtZXgLug+hLeMF/X6l+TPURQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794557184;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=lb4Edw7yh0QJZr9z5jSn2QIVos+nFDc8neFuLj7Hbhw=;
	b=Zl7Fc0tLxWgkPdNe8zWuZBlN74/tg+HpSeezH1eDRhjh0JpyNFuRuG2ZKC43EOqnYwJu
	 cdYUgCY/kIVay7hHmCyABxRImcgLKXTHGW/Yknhkk/hgZqRbuoxnB7a/d9lPKnmlV8QyD
	 DMlmkEX+0CmY4YTM+8BdjmDZ4uxw21R307HJWuQXN7TLJomEkuSBGD3PPzqTqY2/PCQAZ
	 rX4U+j4hH/+NO+ITQx8V0r82g+4RjU4tQ8vlgK29+z4TG0T2Dd2YrZCTTDKElz7WXUqNP
	 IuTzbTAUk9al4klYcu4UyRU14jDwFBrmpyXwbCObuiM8+bDDbeSyHdZpl/7msNtq2UQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UcHftlkA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1017606A31C;
	Fri, 13 Nov 2026 08:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UcHftlkA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986131F000C4;
	Fri, 13 Nov 2026 08:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794557183;
	bh=lb4Edw7yh0QJZr9z5jSn2QIVos+nFDc8neFuLj7Hbhw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=UcHftlkAxlMUoAHLH8VSPUOsFhelDvPy+o87pyiVN2VT7skEDm66aBi86qvxzVfBn
	 +uURM/9tB/z+AHJ3mp+8euBYcJONXsvOPq5dXhQMYWwU6IFExLNl1yoEh7t2akUVpz
	 1YyAtMwGiN/1Q8+DSlF5iby+eSDqHX19/Toj/sC3B08oXyRwKjnBRnBXKUBvJ4dgxh
	 L3Ib6Ox0l61YU5c3aMXJJKgvhT34NHVy0dZIN90tjfOcGzFlkqIb2SeH5fYaMlEGVq
	 oCrHR2gZNelltU6kLImqLDFuVjjgDJgSYal2qOitulw+Xq/WY+INtSYe2HRMWENZOA
	 yQ4q1kaSDYaRA==
Subject: Re: [PATCH net-next v4] net/mlx5e: advertise tcp-data-split support
From: netdev-bot+sashiko@kernel.org
To: dimitri.daskalakis1@gmail.com
Cc: davem@davemloft.net, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, leon@kernel.org, andrew+netdev@lunn.ch,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, gal@nvidia.com,
 cratiu@nvidia.com, dtatulea@nvidia.com, noren@nvidia.com, cjubran@nvidia.com,
 bjorn@kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Date: Fri, 13 Nov 2026 08:06:22 +0000
Message-ID: <179455718216.2199510.10119051325167179247@kernel.org>
In-Reply-To: <20261111170558.1654691-1-dimitri.daskalakis1@gmail.com>
References: <20261111170558.1654691-1-dimitri.daskalakis1@gmail.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] mlx5e_get_ringparam() now reports tcp-data-split as ENABLED
  whenever SHAMPO is active, even when dev->cfg->hds_config is still…
- [Low] The patch has no Fixes: tag, even though its commit message
  describes regressions caused by commit 46bcce5dfd33 ("net/mlx5e:…

--

net/mlx5e: advertise tcp-data-split support

On devices that support HW-GRO, mlx5e_get_ringparam() now reports
tcp-data-split as enabled when SHAMPO is active and as disabled otherwise.
The patch also rejects disabling tcp-data-split while HW-GRO is on.
mlx5e_fix_features() now keeps HW-GRO off when tcp-data-split is disabled.

> Since commit 46bcce5dfd33 ("net/mlx5e: Support ethtool tcp-data-split
> settings"), mlx5 no longer reports tcp-data-split from
> mlx5e_ethtool_get_ringparam() and the reply carries only the stored
> config. With the default config (auto) the attribute is omitted, so the
> device looks like it does not support tcp-data-split, even while HW-GRO
> is on and SHAMPO is splitting headers.

[Severity: Low]
This isn't a bug, but should this patch carry a Fixes: tag?

The commit message names 46bcce5dfd33 as the cause. That commit removed
the assignment of kernel_param->tcp_data_split from the SHAMPO state in
mlx5e_ethtool_get_ringparam().

Since then, rings_prepare_data() seeds the value from
dev->cfg->hds_config. rings_fill_reply() only emits
ETHTOOL_A_RINGS_TCP_DATA_SPLIT when the value is non-zero, so in auto mode
the attribute is missing.

46bcce5dfd33 also enforced only one direction in mlx5e_fix_features().
This patch restores the reporting and adds the missing direction, so
would this be appropriate:

Fixes: 46bcce5dfd33 ("net/mlx5e: Support ethtool tcp-data-split settings")

Without the tag, stable kernels that contain 46bcce5dfd33 would keep the
missing attribute in auto mode.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> index 1f534051cdfe4..8e7c748caf2d2 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> @@ -388,6 +388,13 @@ static void mlx5e_get_ringparam(struct net_device *dev,
>  	struct mlx5e_priv *priv = netdev_priv(dev);
>  
>  	mlx5e_ethtool_get_ringparam(priv, param, kernel_param);
> +
> +	if (dev->hw_features & NETIF_F_GRO_HW)
> +		kernel_param->tcp_data_split =
> +			priv->channels.params.packet_merge.type ==
> +			MLX5E_PACKET_MERGE_SHAMPO ?
> +			ETHTOOL_TCP_DATA_SPLIT_ENABLED :
> +			ETHTOOL_TCP_DATA_SPLIT_DISABLED;
>  }

[Severity: Medium]
With this change, tcp-data-split is reported as enabled whenever SHAMPO
is active, even while dev->cfg->hds_config is still auto
(ETHTOOL_TCP_DATA_SPLIT_UNKNOWN). Does this break the XDP cases in
tools/testing/selftests/drivers/net/hds.py?

With HW-GRO on, set_xdp() and ioctl_set_xdp() now see 'enabled' and set
tcp-data-split back to 'unknown'. hds_config is already unknown, so
ethnl_set_rings() sees no change and returns without calling the
driver. HW-GRO and SHAMPO stay on.

The core checks in dev_xdp_attach() and netif_xdp_propagate() only
reject single-buffer XDP when hds_config is
ETHTOOL_TCP_DATA_SPLIT_ENABLED. The request therefore reaches the driver,
and mlx5e_xdp_allowed() rejects it:

	if (params->packet_merge.type != MLX5E_PACKET_MERGE_NONE) {
		netdev_warn(netdev, "can't set XDP while HW-GRO/LRO is on, disable them first\n");
		return -EINVAL;

That matches "not ok 9 hds.set_xdp" and "not ok 12 hds.ioctl_set_xdp" in
the posted run. Before this patch, ioctl_set_xdp found the attribute
missing in auto mode and skipped.

In auto mode with HDS reported as on, the ring param also can't be used
to turn HDS off. mlx5e_ethtool_set_tcp_data_split() now rejects
'disabled' while HW-GRO is on.

With HW-GRO off, enabled_set_xdp() and ioctl_enabled_set_xdp() call
rings_set() with tcp-data-split set to 'enabled' and no exception
handling. The driver now returns -EINVAL for that request.

The "SKIP enabling of HDS not supported by the device" lines in the
posted results don't seem to exist anywhere under
tools/testing/selftests/. Did those results come from a locally modified
hds.py?

Because of the _hds_reset() logic in hds.py, some of these cases could
already fail before this patch, depending on test order.

Should hds.py be updated together with this change? If not, could the
commit message mention the expected hds.py failures on mlx5?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261111170558.1654691-1-dimitri.daskalakis1%40gmail.com
