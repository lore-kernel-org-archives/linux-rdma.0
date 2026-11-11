Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794422439;
	b=JOvD2hW5YmwuRq04Inl6ClGbR0Moh73R4jLAt8Hc9xO94Gs2ZjbwyWtZE8hKn2FViWAj
	 G0uXsyiPnzsmBkwP8+S5sgwx8hspbL9B/u/6XkMvXTNPnik857SnREZpa10Jt0ar4K1hU
	 B2NCBQ7iTbXji9dNcnjYSf/PUHbpyiU6gEy9KSDOwMEMZ1mCvcHQt6Y0Ry3AZZEzAZ343
	 I2wM88zDTzfCLyPpSqh1RuhCgcGkFjNuJqj75fGK+5DYD7eqrNfD3JQHVJxaqrfAX2pBC
	 el/3U05y7Q1X4bwRmvz2eLvqAfQzyOKxQedr8T5FXGXeUmGAWYFItmxTzhPDKo+7Yww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794422439;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=k2THJoddXSQrel1e0V/mHItZGbqVhPE5fTVyBe8ca3w=;
	b=z/ROWf8p6N2bEWAfgxN1dVDWPa3+mp+ZsnDsx6aSuD17URP2DxI/eIuq3ubEeqI97MCI
	 JkjZAH7fec8kUH+WR9UlKBq3XMNtRKDBheVbLjl2BtkIC9+NL+y8iu80RLKwRtxV34iOL
	 TQ+eD+h20sAegOaKJ9ayoSp9Iz/HB/T/grYr2KrNTOBxbnn92pFwVBvAmkVPaux9/ywU1
	 viaAxDG4mz5Q8t+Ua6EksyfbydZFLsfMdldWsrAeb1HvWIaG8EzwpIMinlI3Asc6lh2CO
	 V/grF4eUsyADvlH4nTWKRobogwffwIyR0lkTNWVSfBLSziJXzF0JwlIuP4W9dIqke2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lESJe8LJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9327606A32D
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 18:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lESJe8LJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7741F00A07;
	Wed, 11 Nov 2026 18:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794422439;
	bh=k2THJoddXSQrel1e0V/mHItZGbqVhPE5fTVyBe8ca3w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lESJe8LJddODZjTqPsxO88758AlPGxoAqEbI5L9XnVxy134GX9MDaD5ZgQznhIzep
	 RGHY1dGevlV0U6/8iUbryuSxbruZDxWTQEvs34TMCK7Xpb/VNh4NFC3FhQiEtOSaTJ
	 p5YJ+2lRznySnKOjvrmQEmNBMt4Eizi1RehMH1tObfiFFkdzL01OH5bLCWrfsG8yGn
	 sSa+N0Vt0weyFztR93DhNuSjnj/xUFZAt9YQ9Gjzm8iuCM2SefibWSesK1lsfRAFs4
	 h2i/n0ujm3OEUEOrlSQ84ck0zm1REs0R4OwlzEUHR+pOJ0eBh3DGn1jyUu4Gz64hlc
	 lv+0AKHVFpKCA==
Message-ID: <sashiko-outbox-209481@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V2 13/13] net/mlx5e: Enable the data direct
 netdev feature
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110183826.2927274-14-tariqt@nvidia.com>
References: <20261110183826.2927274-1-tariqt@nvidia.com>
 <20261110183826.2927274-14-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 18:40:38 +0000
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
- [Medium] net/mlx5e: stale MLX5E_PFLAG_DATA_DIRECT state after resume
  if dd_dev unbound
--

commit 2963efd7a308324cf29d1ee3e4d43832eae0f949
Author: Dragos Tatulea <dtatulea@nvidia.com>

net/mlx5e: Enable the data direct netdev feature

This commit implements the ethtool set_pflag_data_direct() callback to
validate device state and toggle MLX5E_PFLAG_DATA_DIRECT via
mlx5e_safe_switch_params().

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drive=
rs/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> index 26f76449af351..2204b370f4395 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c

[ ... ]

> @@ -2407,7 +2410,65 @@ static int set_pflag_tx_port_ts(struct net_device =
*netdev, bool enable)
> =20
>  static int set_pflag_data_direct(struct net_device *netdev, bool enable)
>  {
> -	return -EOPNOTSUPP;
> +	struct mlx5e_priv *priv =3D netdev_priv(netdev);
> +	struct mlx5_core_dev *mdev =3D priv->mdev;
> +	struct mlx5e_params new_params;
> +	unsigned int i;
> +
> +	if (enable) {
> +		if (!mlx5_data_direct_supported(mdev) ||
> +		    !MLX5_CAP_GEN(mdev, crossing_vhca_mkey)) {
> +			netdev_err(netdev, "data_direct is not supported by the device\n");
> +			return -EOPNOTSUPP;
> +		}
> +
> +		if (!MLX5_CAP_GEN(mdev, shampo)) {
> +			netdev_err(netdev, "data_direct requires SHAMPO (Header-Data Split) s=
upport\n");
> +			return -EOPNOTSUPP;
> +		}
> +
> +		if (mlx5_get_sd(mdev)) {
> +			netdev_err(netdev, "data_direct is not supported with socket direct\n=
");
> +			return -EOPNOTSUPP;
> +		}
> +
> +		if (mlx5e_is_uplink_rep(priv)) {
> +			netdev_err(netdev, "data_direct is not supported for uplink represent=
ors\n");
> +			return -EOPNOTSUPP;
> +		}
> +
> +		if (!mlx5_data_direct_get_dev(mdev->data_direct)) {
> +			netdev_err(netdev, "data_direct device not bound\n");
> +			return -ENODEV;
> +		}
> +
> +		if (mlx5e_has_leased_rxqs(netdev)) {
> +			netdev_err(netdev, "data_direct is not supported with leased RX queue=
s\n");
> +			return -EBUSY;
> +		}
> +	}
> +
> +	/* Changing the flag reopens the channels with a different DMA device,
> +	 * which would break the memory providers installed on the RX queues
> +	 * (devmem or io_uring zcrx) and the dmabufs bound for TX.
> +	 */
> +	for (i =3D 0; i < netdev->real_num_rx_queues; i++) {
> +		if (netif_rxq_has_unreadable_mp(netdev, i)) {
> +			netdev_err(netdev, "Can't change data_direct while rxq %u has a memor=
y provider\n",
> +				   i);
> +			return -EBUSY;
> +		}
> +	}
> +
> +	if (netdev_has_dmabuf_binding(netdev, NULL)) {
> +		netdev_err(netdev, "Can't change data_direct while dmabufs are bound\n=
");
> +		return -EBUSY;
> +	}
> +
> +	new_params =3D priv->channels.params;
> +	MLX5E_SET_PFLAG(&new_params, MLX5E_PFLAG_DATA_DIRECT, enable);
> +
> +	return mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, true);
>  }

[Severity: Medium]
Can MLX5E_PFLAG_DATA_DIRECT remain set after system resume if the data
direct device was unbound while suspended?

During suspend, mlx5e_nic_disable() calls mlx5e_data_direct_unbind_dev()
and unregisters priv->data_direct_nb without clearing
MLX5E_PFLAG_DATA_DIRECT in priv->channels.params.  If the data direct
PCI device is unbound before mlx5e_nic_enable() re-registers the
notifier on resume, mdev->data_direct->dev is NULL, yet the channels
reopen with MLX5E_PFLAG_DATA_DIRECT still enabled.  Subsequent calls to
mlx5e_queue_get_dma_dev() then return NULL instead of the NIC DMA
device, breaking zero-copy memory provider operations until the flag is
manually disabled.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110183826.2927=
274-1-tariqt@nvidia.com?part=3D13
