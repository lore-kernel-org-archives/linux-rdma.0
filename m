Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC994D09F6
	for <linux-rdma@vger.kernel.org>; Fri,  9 Oct 2026 13:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791552669; cv=none; b=Er8UddJoCwKGN7yEPWyXwFsYkl4BW4u56h1MqGPNdLtLm67YKHc8KYMAOqoxRoJr6YrVjUKt9HJU2WZOkwSb6mJsIcpR1UltruvN2P5d+yZ8EIpxSOiKUuposrdAWXBRb6wEubUP+ifUJrZ67l559wRAy5IJbcM6uTqrCCd/zMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791552669; c=relaxed/simple;
	bh=iP6dVOsnw5rQhp8360xQd5dIqh1JR9dIdKD61MsunNI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=jU+3wukc+bnSPS5727Flt+H71cJWPmmjOoWYSAMc25LrGo5NX38d0j6IBeTNIV/A7344X3zWQeA8B1YkXjuYOW9kOzxJfiqXcRw/alSRxQx4T0Bk8j7aZ1uAVW+4u3kYwICxHhk86dLmr9AdLWIkRtYhs7bswQ8RM40NL8SUpRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VlLB2zRU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VlLB2zRU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0031F000FF;
	Fri,  9 Oct 2026 13:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791552668;
	bh=U1X6fcr6hujX07ip9OhDd0dD9oeWHXeTcaLbddCCHlU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VlLB2zRUw8ZxVriy2iFZnSGTFkFMG2iVEpIh8gzZs8EkNT7XTYgfsOAy1yoM99yzi
	 YBIlbDhqENPpAIWmJgcart0bfv7EkoA1hij9qgJXoXznGz4TZ+a8Wz5uUUaq7x+XyV
	 WC1tUF4STDzfE/CfoopWpC4U3GQ78a0OPGJ8aAOSDHvTrCrRmGuLA6UlCGORVtBwJo
	 R1Hq51bX21pv8lwKG8gkPKrKjEu4pmU46LidJ8q7Ing2Eo4NFnfcMM6E0e8dxZFdan
	 w5e/gzwB1fHbIa2x7VdAZmeR8ZI75RVewlJY6W3ZqnniQove/IBtqewQu1nUl7SC6I
	 BVqnzN5AiAd0w==
Message-ID: <sashiko-outbox-165644@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 10/10] net/mlx5e: Enable the data direct netdev
 feature
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261008132815.654147-11-tariqt@nvidia.com>
References: <20261008132815.654147-1-tariqt@nvidia.com>
 <20261008132815.654147-11-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 13:31:07 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] net/mlx5e: unbind event ignores dmabuf bindings and channel switch=
 failures
--

commit 9f56d4d1fade135dc92a72f9f099f77953de0c1d
Author: Dragos Tatulea <dtatulea@nvidia.com>

net/mlx5e: Enable the data direct netdev feature

This commit implements the data_direct private flag in the mlx5e driver,
enabling the feature. It also adds a check to prevent changing the flag's
state if there are active dmabuf bindings to avoid breaking them during
the resulting DMA device change.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drive=
rs/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> index b3eced1dd43fd..8ab1150ce3f20 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c

[ ... ]

> @@ -2402,7 +2403,40 @@ static int set_pflag_tx_port_ts(struct net_device =
*netdev, bool enable)
> =20
>  static int set_pflag_data_direct(struct net_device *netdev, bool enable)
>  {
> -	return -EOPNOTSUPP;
> +	struct mlx5e_priv *priv =3D netdev_priv(netdev);
> +	struct mlx5_core_dev *mdev =3D priv->mdev;
> +	struct mlx5e_params new_params;
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
> +		if (!mlx5_data_direct_get_dev(mdev->data_direct)) {
> +			netdev_err(netdev, "data_direct device not bound\n");
> +			return -ENODEV;
> +		}
> +	}
> +
> +	/* Changing the flag reopens the channels with a different DMA device,
> +	 * which would break any dmabuf currently bound to this netdev.
> +	 */
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

[Severity: High]
This ethtool callback explicitly acknowledges that reopening channels with a
different DMA device breaks dmabuf bindings. However, does the unbind notif=
ier
in mlx5e_data_direct_event() omit this safety check?

Looking at mlx5e_data_direct_event() in
drivers/net/ethernet/mellanox/mlx5/core/en_main.c:

	new_params =3D priv->channels.params;
	MLX5E_SET_PFLAG(&new_params, MLX5E_PFLAG_DATA_DIRECT, false);

	mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, true);

	netdev_info(priv->netdev,
		    "data_direct device unbound, disabled data_direct\n");

The notifier forcefully reopens the channels without checking for or revoki=
ng
active dmabuf bindings. The channels are reopened using the netdev's primary
DMA device, but the dmabufs remain mapped for the removed data_direct GPU,
which could cause IOMMU faults.

Additionally, what happens if the channel switch in the notifier fails?

The return value of mlx5e_safe_switch_params() is ignored. If it fails
(e.g., due to ENOMEM), the old channels might continue running with the old
parameters, actively issuing DMA requests to the unbound and
soon-to-be-freed data_direct device, potentially leading to a
use-after-free and DMA corruption.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008132815.6541=
47-1-tariqt@nvidia.com?part=3D10
