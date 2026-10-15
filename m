Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9BC51C065
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 12:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792068513; cv=none; b=bCdIXNob0lAIFCAPd0x9xQ0KkYkBk0LG2+7175WR35avf8DLijnFbvZi1Qtui/ckSJEsbEMj9UCAgFqlFZuekGNarSPpPGx61fPhEBV2ah4fPpteYfeL/8fr2+eH5Uv0m0eovKCbOSC0+1qn+4PNISuZSjG1yACqx1T+av8ZOFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792068513; c=relaxed/simple;
	bh=xK2tQ/RwKoTM4IDBnCZ52HPGj9aGQq0SknD9nZ0HGkQ=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=vA7ygLWWkcXpiPDUL1mwKNVQHTQFYlcMFyG+TYB4Ia+zG95b6YD7lVvubVWGVkxkI72Mn7WeDrd9QWpOLcaVDPrNnPSOdlh/OtQkniqnXuedmuddSxCrrIfwzZN1jmoe55dGxK2bPxzm7Hb2++Fu9BFfJ11YrTerzj7T0m7jT0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OTqxnNsA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OTqxnNsA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C9081F000C5;
	Thu, 15 Oct 2026 12:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792068511;
	bh=UKC5NxTgKnhBxk+hIZxlxhh5DDqydZdYdQ/6cL76KsE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OTqxnNsAAwHz86JtCiauosDKSjUQnlgxy59yNSfLkubB/N9SRq1uMzoiGDdweNJ7s
	 mNIU9MPPSZSdatn8lRWSN2U3AaqC/en1FCGxG/YFq89A+Jb25gXkRVEK1AszPLgK29
	 wR1+Ja98Idqt1ClozfQcau/FqULCcz0WSg7PRXsOsj1Oo3T67wfnH3nKLeGjbxlFxl
	 2ULgwF2MQSQ+BHqKvjnoRKotRaRA+gsXuJhXqoo0+p1uEEDDLlta9T5A7iG+VKHK8B
	 RUae2Ik8/1e0aQOcDVvy37Do+YaVZl9XFTluUSIMS9FLKaG5XrH6pHX2AfRj6j0zbE
	 8gqffbAm3hivA==
Message-ID: <sashiko-outbox-172865@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net 2/3] net/mlx5e: Sync CQE moderation params with
 pflags in set_pflag_cqe_based_moder
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261014124704.1017782-3-tariqt@nvidia.com>
References: <20261014124704.1017782-1-tariqt@nvidia.com>
 <20261014124704.1017782-3-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 12:48:30 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] net/mlx5e: stale hardware CQ moderation when toggling via priv-f=
lag
- [Medium] net/mlx5e: unhandled toggle_dim failure leaves DIM disabled and =
channels partially configured
--

commit 7d36de6d06985b57ee8f31a9e94e4235c92121ae
Author: Yael Chemla <ychemla@nvidia.com>
Subject: net/mlx5e: Sync CQE moderation params with pflags in set_pflag_cqe=
_based_moder

This commit synchronizes the CQE-based moderation parameters with priv-flag=
s=20
when they are toggled via set_pflag_cqe_based_moder(). It updates the chann=
el=20
parameters so that tools like ethtool -c report the correct state, and rese=
ts=20
the moderation usecs to the defaults for the new mode.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drive=
rs/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> index 3ed59ced0407a..c2bee69c26af7 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> @@ -2193,12 +2193,20 @@ static int set_pflag_cqe_based_moder(struct net_d=
evice *netdev, bool enable,
>  		mlx5e_channels_rx_toggle_dim(&priv->channels);

[Severity: Medium]
The return value of mlx5e_channels_rx_toggle_dim() is unconditionally ignor=
ed
here.

If re-enabling DIM fails (for instance, if mlx5e_dim_rx_change() fails due
to memory allocation errors in mlx5e_dim_enable()), does this leave the
current channel's DIM completely disabled while skipping the remaining
channels? This could result in a broken state where the priv-flags appear
successfully updated but DIM is silently disabled on some channels.

>  		MLX5E_SET_PFLAG(&new_params, MLX5E_PFLAG_RX_CQE_BASED_MODER,
>  				cq_period_mode);
> +		new_params.rx_moder_use_cqe_mode =3D enable;
> +		mlx5e_reset_rx_moderation(&new_params.rx_cq_moderation,
> +					  cq_period_mode,
> +					  new_params.rx_dim_enabled);

[Severity: Medium]
Does updating the software state cache here fail to push the updates to the
hardware when DIM is disabled?

When DIM is disabled (e.g., adaptive RX off), mlx5e_channels_rx_toggle_dim()
skips the channels:

mlx5e_channels_rx_toggle_dim() {
    ...
    if (chs->c[i]->rq.dim) {
        ...
    }
}

Since the channels are skipped, no asynchronous hardware update is scheduled
by the DIM work thread. Later, mlx5e_safe_switch_params() is called with
reset=3Dfalse:

mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, false);

Passing reset=3Dfalse skips reopening the channels. Because no hardware
modify command is issued, could this leave the actual hardware operating
with stale CQE moderation parameters while the software ethtool -c
configuration reports the new state?

>  	} else {
>  		mlx5e_reset_tx_channels_moderation(&priv->channels, cq_period_mode,
>  						   false, true);
>  		mlx5e_channels_tx_toggle_dim(&priv->channels);

[Severity: Medium]
The return value of mlx5e_channels_tx_toggle_dim() is unconditionally
ignored here as well.

Similar to the RX side, if this fails, could it leave DIM disabled on some
channels and skip applying the new moderation mode to subsequent channels
without reporting an error?

>  		MLX5E_SET_PFLAG(&new_params, MLX5E_PFLAG_TX_CQE_BASED_MODER,
>  				cq_period_mode);
> +		new_params.tx_moder_use_cqe_mode =3D enable;
> +		mlx5e_reset_tx_moderation(&new_params.tx_cq_moderation,
> +					  cq_period_mode,
> +					  new_params.tx_dim_enabled);
>  	}
> =20
>  	/* Update pflags of existing channels without resetting them */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014124704.1017=
782-1-tariqt@nvidia.com?part=3D2
