Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D353A4D955C
	for <linux-rdma@vger.kernel.org>; Fri,  9 Oct 2026 13:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791552668; cv=none; b=IR6OEMi69NvpT4Ek1cGeU0nJ0sgwf5zU3s4WFEKiwKDiift3Rb9ISkhJOv8HQJIp3a9NoqT4gmEXhvLZuWKcvqH0Jf2Dr1jiyhJMKxsRwlr14Ee8xFO1x9Lm6OWBcOKIDGtq/Nn6PPFsbJd6OMjB3RtaR5KTBdUNVRKTiKDsuss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791552668; c=relaxed/simple;
	bh=QPTOXcPoDFVi4LsfwBRCqqVg6hO5kFZEsPm8a0IBcxI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=iZI8Tfi7dnHjbaUa5VdgNDui5ojFr3ahW7Zp0ulLx/yxaCstuFK2/Of4km04w6AgwaohA1VaM/Bz5s6rSWayObZc+3AuYaibzeBOhJ4Nt6xOnthOer0lYBTBdY4/Go/WoMGtjwVxFwTC4eHQTvzpi6UuGnOx4pu0BKqIoHWizuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aPUmkqMt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aPUmkqMt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E29A1F00893;
	Fri,  9 Oct 2026 13:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791552666;
	bh=13ikU8bwfDX8PmTcF7xVyjAtAiggvisfr5Gv791hdH0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aPUmkqMtcRJVd6imjUraOW1bxsFm1qul6oZhECUroit4MXPixaFtIHxTKVRE1NrTq
	 hWbgKkdV/G1yQAIVPqFRXLmEQCObs7NAV4XI1h/3k7PZT3Q2YvsD3Nfh473p686un6
	 /xEtPYZBGuYfp9Y8dOIu/RiUEYS0ApqGChJXae66Iw1eRK+DmF09Hvj3oThttR8zoA
	 XBw0xlaUijZa92t6y2ezuevhUtA+bdw0EZcHOa9zHCPXWmaVozh3LuUV1S3OaUOn0j
	 utOKSQ79nZykdSyPcUVgRZddUgtHAGPrcQTV1lbgniTUvRmkWuirLaFpD3YRkByDBi
	 NZ38KRUB2cGGA==
Message-ID: <sashiko-outbox-165642@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 08/10] net/mlx5e: Recreate netdev channels on
 data direct device unbind
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261008132815.654147-9-tariqt@nvidia.com>
References: <20261008132815.654147-1-tariqt@nvidia.com>
 <20261008132815.654147-9-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 13:31:06 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] net/mlx5e: unhandled mlx5e_safe_switch_params() failure leaves que=
ues using unbound data direct device
- [High] net/mlx5e: missing devmem revoke hook causes IOMMU faults for dmab=
uf bindings on unbind
--

commit e6199c36bc278fa5fdfb415d4fa28dbdfc733a06
Author: Dragos Tatulea <dtatulea@nvidia.com>
Subject: net/mlx5e: Recreate netdev channels on data direct device unbind

This commit handles the unbinding of a data direct device by disabling
the data direct flag and triggering channel recreation for the affected
netdevs. It intends to stop queues from using data direct resources.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en_main.c
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -6144,9 +6144,28 @@ static int mlx5e_data_direct_event(struct notifier=
_block *nb,

[ ... ]

> +	new_params =3D priv->channels.params;
> +	MLX5E_SET_PFLAG(&new_params, MLX5E_PFLAG_DATA_DIRECT, false);
> +	mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, true);

[Severity: High]
Is it safe to ignore the return value of mlx5e_safe_switch_params() here?

If this function fails (for example, due to an allocation failure when sett=
ing
up the new channels), the parameter switch is aborted and the currently act=
ive
channels are left untouched. They will continue to run with the data direct
flag enabled.

Since the driver proceeds with the unbind process while the active queues
still reference the soon-to-be-destroyed data direct resources, could the
hardware access invalid resources and cause use-after-free or crashes?

[Severity: High]
Additionally, since the newly recreated channels inherit existing bindings
via rxq->mp_params, won't they continue to post DMA addresses mapped in
the unbound data direct IOMMU domain to the primary PF?

The commit message notes this will cause IOMMU faults because a devmem
revoke hook is needed to close those bindings before the switch. Does this
leave the automatic unbind path fundamentally broken when dmabuf bindings
are present?

> +	netdev_info(priv->netdev,
> +		    "data_direct device unbound, disabled data_direct\n");
> +
> +out:
> +	mutex_unlock(&priv->state_lock);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008132815.6541=
47-1-tariqt@nvidia.com?part=3D8
