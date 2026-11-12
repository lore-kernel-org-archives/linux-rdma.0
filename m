Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794503174;
	b=w2AYGmm2iLjCVwt0OoXYVzJ26r+7NKmRHbfY91BUSq9dDaLXYf8rDkAo3COTEhPXz4N6
	 gjgqyJEr6c5upCODpayNea5P0VEtw9FJ8V6NHrpzalgnQjuYsFGFLqaTRPEekSipnrL8A
	 ZdeajVy9xU3WJH4mnzjZzP0zINWvpwaDhjokE7WUCSTwr8yjFOLy/usAevbA86MzAhfzh
	 HLUTkedKui6OhIbwejP5XbeHPOocIMMHKuKbsivrqpaXEr8IS2yaQfg7CJzu8DA6ixecC
	 Ko/t+cJmUohZMODoSN/ejm/kxgPWOMtHzZYY/3zaHz6yFLEf2FD3ed6clLpHmObLWgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794503174;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=fv+5uWOGquIkSRNIH8DWcm6l/TCUNnmeTthcpTBWL4Q=;
	b=fq3M8umgR26+c6Fjndg8FfUm5/1TNdUHKGWrshqD+GvF/9RFpIYE4naC9FQITrJfzoXo
	 8ItzyIcglyYbOKkQBFiYxxHIqCXfR5dYxdlcBUEWPXVzTxHYRnh0xRCIeWLgHtfBqQTc5
	 L7PA4fllxns1eM+YCPewqWdrZTcOba1gVKp+wLG3bys1kLBUq8i4x9jA6cKEBp6EtYdCI
	 xk4jlJ1e2Xqv6hFh1XKRdYo2CYoVWW/NVNeF1BKSoNmab4OFmYjSvZzO5+uj+QfHcGtxD
	 d4lwLadAPME2tbCIMG5AqbW2GdSTpnTtP8EKGNPPaKJYSBVxUGz5gV5wW2OQII/7nvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="dN2lrqL/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA0A606A31C
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 17:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dN2lrqL/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E231F000C4;
	Thu, 12 Nov 2026 17:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794503173;
	bh=fv+5uWOGquIkSRNIH8DWcm6l/TCUNnmeTthcpTBWL4Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dN2lrqL/a/906bDS4DDhte3/1Gyt91BkLn/suR9+Svqp7G9S14m2eM/TpOGwV6+1K
	 UvsRT8+2wktB+quwttLAvcM/jvBkttaTnWQljoauHd5exiheAIj/i6APZu+kBgDtph
	 BiGhsYw0M9cSoLtkvm0zrslsWsht9U/aTQW8dYs76XzPgOYzAXlvQ+cepF619vgn/W
	 wqvsYL+dvSVLps0bxZcz6VmUff0amNLVXaQhuSaKgRfuov/EYOFFJ1h5IGwaLTSbON
	 qR0xyqXPsKfI0dqdDBK5TfOyemmDTDfQZushSCOpd9HdslFa0G86OuLRSNlwBhMuCk
	 KCBrnJ8n58ViQ==
Message-ID: <sashiko-outbox-211565@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v4] net/mlx5e: advertise tcp-data-split support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dimitri Daskalakis" <dimitri.daskalakis1@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261111170558.1654691-1-dimitri.daskalakis1@gmail.com>
References: <20261111170558.1654691-1-dimitri.daskalakis1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 17:06:13 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] net/mlx5e: missing HW-GRO cap check in
  mlx5e_ethtool_set_tcp_data_split()
- [Low] net/mlx5e: missing Fixes trailer for commit 46bcce5dfd33
--

commit 10e87fc2f39f7859cabd43f8c342a731e4043353
Author: Dimitri Daskalakis <daskald@meta.com>

> net/mlx5e: advertise tcp-data-split support
>
> Since commit 46bcce5dfd33 ("net/mlx5e: Support ethtool tcp-data-split
> settings"), mlx5 no longer reports tcp-data-split from
> mlx5e_ethtool_get_ringparam() and the reply carries only the stored
> config. With the default config (auto) the attribute is omitted, so the
> device looks like it does not support tcp-data-split, even while HW-GRO
> is on and SHAMPO is splitting headers.
>
> On mlx5, header-data split is performed by SHAMPO, which is used only
> when HW-GRO is enabled. The driver already keeps HW-GRO on while
> tcp-data-split is enabled, but nothing enforces the other direction.
> A user can disable tcp-data-split and then enable rx-gro-hw, leaving
> the device splitting while the config says it is off.
>
> To make the feature handling consistent, report tcp-data-split as on
> when SHAMPO is active and off otherwise. Only allow disabling
> tcp-data-split while HW-GRO is off, and keep HW-GRO off in
> mlx5e_fix_features() when tcp-data-split is already disabled.
>
> Signed-off-by: Dimitri Daskalakis <daskald@meta.com>

[Severity: Low]
As reported by Bj=C3=B6rn T=C3=B6pel on v3 [1], should this include a Fixes=
 tag for
stable backports:

  Fixes: 46bcce5dfd33 ("net/mlx5e: Support ethtool tcp-data-split settings")

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drive=
rs/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> index 1f534051cdfe4..8e7c748caf2d2 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> @@ -388,6 +388,13 @@ static void mlx5e_get_ringparam(struct net_device *d=
ev,
>  	struct mlx5e_priv *priv =3D netdev_priv(dev);
> =20
>  	mlx5e_ethtool_get_ringparam(priv, param, kernel_param);
> +
> +	if (dev->hw_features & NETIF_F_GRO_HW)
> +		kernel_param->tcp_data_split =3D
> +			priv->channels.params.packet_merge.type =3D=3D
> +			MLX5E_PACKET_MERGE_SHAMPO ?
> +			ETHTOOL_TCP_DATA_SPLIT_ENABLED :
> +			ETHTOOL_TCP_DATA_SPLIT_DISABLED;
>  }
> =20
>  static bool mlx5e_ethtool_set_tcp_data_split(struct mlx5e_priv *priv,
> @@ -399,7 +406,14 @@ static bool mlx5e_ethtool_set_tcp_data_split(struct =
mlx5e_priv *priv,
>  	if (tcp_data_split =3D=3D ETHTOOL_TCP_DATA_SPLIT_ENABLED &&
>  	    !(dev->features & NETIF_F_GRO_HW)) {
>  		NL_SET_ERR_MSG_MOD(extack,
> -				   "TCP-data-split is not supported when GRO HW is disabled");
> +				   "TCP-data-split can not be enabled without HW-GRO, set it to 'aut=
o' and enable HW-GRO first");
> +		return false;
> +	}
> +
> +	if (tcp_data_split =3D=3D ETHTOOL_TCP_DATA_SPLIT_DISABLED &&
> +	    dev->features & NETIF_F_GRO_HW) {
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "TCP-data-split can not be disabled while HW-GRO is on, set it to=
 'auto' and disable HW-GRO first");
>  		return false;
>  	}

[Severity: Medium]
Does mlx5e_ethtool_set_tcp_data_split() allow setting
ETHTOOL_TCP_DATA_SPLIT_DISABLED on devices that do not support
NETIF_F_GRO_HW?

On hardware without SHAMPO support, dev->features & NETIF_F_GRO_HW is
always 0, so requesting ETHTOOL_TCP_DATA_SPLIT_DISABLED succeeds and saves
that value in dev->cfg->hds_config.  Because rings_prepare_data() copies
dev->cfg->hds_config into kernel_ringparam.tcp_data_split before calling
mlx5e_get_ringparam(), and mlx5e_get_ringparam() leaves tcp_data_split
untouched when NETIF_F_GRO_HW is not in dev->hw_features, subsequent
ETHTOOL_MSG_RINGS_GET queries will report tcp-data-split as supported and
disabled on unsupported hardware.  Requesting ETHTOOL_TCP_DATA_SPLIT_ENABLED
on such devices also returns an extack telling the user to enable HW-GRO
first when the device cannot support it.

Rejecting non-ETHTOOL_TCP_DATA_SPLIT_UNKNOWN values in
mlx5e_ethtool_set_tcp_data_split() when !(dev->hw_features & NETIF_F_GRO_HW)
would prevent this.

[1] https://lore.kernel.org/r/87a4ons7dd.fsf@all.your.base.are.belong.to.us

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111170558.1654=
691-1-dimitri.daskalakis1@gmail.com?part=3D1
