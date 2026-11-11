Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794422439;
	b=pnkGRxgFIvaH1CuSOJtdPoomZkPhYUBGlmkYTjWezl07F/5pWF6EiSY6Q7hZvNPqlR5g
	 0V0SBaGziauEPFmiVkARJitFSZqVPVv6SvcM74TikeH2bI4Q8GFk3ELGD/YDmA9idsFw+
	 j2Rqs7JLyGhkKF+Yg+nnFUn9fu/TNNsYBYtSmrMPCj2ociZAXBMPpyrdwM7Y//MY8rz1W
	 z55+tlpdGoPM88Q0DnL/vvkxhPplLuUJI9ULKwyrwIWDJMVUfazwT8BRnXbojUqBTfcAj
	 0KPu7Kip7ME4xWt864lpTl+kiSbfjVN9+KuOaLDNYtD0gCaH1qLNLtbE6+cVgaAgn5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794422439;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=l+BJO3E5hYPKADi2PoWancDJ0meg1j9MSScjJRQtwUk=;
	b=E3D2uITC8CzKw6tKf/DoNbkudUiJszjsKoGdDV63QLG4omFBDrt61N0a/ZTEyarr41JC
	 XiTK+92Zbd1Oyzj7JwwO2hCDrSs16EsVzfYM8qRNIENcJjgS5C5T/2NfvUEt62VgoMrkh
	 zTeB6qIO+Tp8jj2GosJp74lkzsXtuTupa3mISStGhNHHEmHrI24t0NqH4Eju3iv2cojrC
	 u3ih+fgYpPfX9YflhAXntLWTtvQuo8cQVekGg8Ah31tPtSYo85fXEKGjTDtczhvIPoWhD
	 gvC2sszGRLsBWHX0GB2uU+Q3R10c1sQN2GjvunKBvyyLE1NJQmGp/s0mcZ+U0t4rdZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OFPkRrRe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03200606A882
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 18:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OFPkRrRe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5D11F00A05;
	Wed, 11 Nov 2026 18:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794422438;
	bh=l+BJO3E5hYPKADi2PoWancDJ0meg1j9MSScjJRQtwUk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OFPkRrReIZshC9oib5qbelu2hWTIIlgum74dlM3aOKM1+3Nqy/f4YvLEeIvFRYCVM
	 /wwikJ6PqbBSoSXXvwrjAs0yMN3G3mQyWr0WyDsBjnNVzrhNyTbFa5D2zfY3Y8Eeaz
	 4qRmiARXE1hSL6Nscmi5/WhHAN7p1m5vV+oQtDZP3NjBFSAMiOFWhRD33fuBSaULIN
	 56Vh3DI8dqLwrUpi6ezmtVahG82V+xhdOKZAzs+uHM2wyapOH71Gj+ah/97nPkGGiV
	 3V/c7R0mVR9UbM+dxiWhAK5qWm8iiXoyTTVcyquD/v4v5cxrgBzRtbHIBZzz9VgEZM
	 ufS/pMyaXeW0Q==
Message-ID: <sashiko-outbox-209480@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V2 12/13] net/mlx5e: Disable data direct on
 data direct device unbind
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110183826.2927274-13-tariqt@nvidia.com>
References: <20261110183826.2927274-1-tariqt@nvidia.com>
 <20261110183826.2927274-13-tariqt@nvidia.com>
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

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] net/mlx5e: stale MLX5E_PFLAG_DATA_DIRECT after unbind during
  suspend
- [Medium] net/mlx5e: mlx5e_data_direct_event() closes detached netdev
  on race
--

commit 25c3357461eb765e71d4e416eff4cb0e4cfec6a7
Author: Dragos Tatulea <dtatulea@nvidia.com>

net/mlx5e: Disable data direct on data direct device unbind

This commit stops the netdev, unbinds the data direct DMA device, and
disables the data_direct private flag when the data direct device is
unbound, and also unbinds the DMA device during mlx5e_nic_disable().

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en_main.c
> index ebd41f24330d0..63d91ef0dda80 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -6170,9 +6170,53 @@ static int mlx5e_data_direct_event(struct notifier=
_block *nb,
>  {
>  	struct mlx5e_priv *priv =3D container_of(nb, struct mlx5e_priv,
>  					       data_direct_nb);
> +	struct mlx5_data_direct_dev *dd_dev =3D data;
> +	struct net_device *netdev =3D priv->netdev;
> +	struct mlx5e_params new_params;
> +	bool enabled, reopen;
> +	int err;
> +
> +	if (action !=3D MLX5_DATA_DIRECT_UNBIND)
> +		return NOTIFY_DONE;
> +
> +	rtnl_lock();
> +	netdev_lock(netdev);
> +
> +	mutex_lock(&priv->state_lock);
> +	enabled =3D MLX5E_GET_PFLAG(&priv->channels.params,
> +				  MLX5E_PFLAG_DATA_DIRECT);
> +	mutex_unlock(&priv->state_lock);
> +	if (!enabled)
> +		goto out;
> +
> +	reopen =3D netif_running(netdev);
> +	netif_close(netdev);
> +
> +	err =3D netdev_unbind_dma_dev(netdev, dd_dev->device);
> +	if (WARN_ON_ONCE(err)) {
> +		netdev_err(netdev, "Failed to unbind dma device, won't reopen netdev, =
err=3D%d\n",
> +			   err);
> +		goto out;
> +	}
> +
> +	mutex_lock(&priv->state_lock);
> +	new_params =3D priv->channels.params;
> +	MLX5E_SET_PFLAG(&new_params, MLX5E_PFLAG_DATA_DIRECT, false);
> +	mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, false);
> +	mutex_unlock(&priv->state_lock);
> +
> +	netdev_info(netdev, "data_direct device unbound, disabled data_direct\n=
");
> =20
> -	if (action =3D=3D MLX5_DATA_DIRECT_UNBIND)
> -		mlx5_core_dbg(priv->mdev, "data direct device unbound\n");
> +	if (reopen) {
> +		err =3D netif_open(netdev, NULL);
> +		if (err)
> +			netdev_err(netdev, "Failed to reopen after data_direct unbind, err=3D=
%d\n",
> +				   err);
> +	}

[Severity: Medium]
Can mlx5e_data_direct_event() clear IFF_UP and leave netdev down if a data
direct unbind races with mlx5e_nic_disable() or mlx5e_nic_enable()?

CPU0                                  CPU1
mlx5e_nic_disable()
  rtnl_lock()
  netdev_lock(netdev)
  mlx5e_close(netdev)
  netif_device_detach(netdev)
                                      mlx5_data_direct_do_unbind()
                                        WRITE_ONCE(reg->dd.dev, NULL)
                                        blocking_notifier_call_chain()
                                          mlx5e_data_direct_event()
                                            rtnl_lock()  [blocks]
  mlx5e_data_direct_unbind_dev()
    dd_dev =3D NULL -> returns
  netdev_unlock(netdev)
  rtnl_unlock()
                                            netdev_lock(netdev)
                                            reopen =3D netif_running(netdev)
                                            netif_close(netdev)
                                            ...
                                            netif_open(netdev, NULL)
                                              __dev_open() -> -ENODEV
  mlx5_data_direct_unregister()

mlx5e_nic_disable() detaches the netdev while keeping __LINK_STATE_START
(netif_running(netdev)) and IFF_UP set so that mlx5e_nic_enable() can
reopen it on resume.  The same window exists in mlx5e_nic_enable() between
mlx5_data_direct_register() and netif_device_attach().  When
mlx5e_data_direct_event() runs while !netif_device_present(netdev),
netif_close(netdev) clears IFF_UP and __LINK_STATE_START, and
netif_open(netdev, NULL) then fails with -ENODEV, leaving the interface
down after resume.

> @@ -6407,6 +6451,24 @@ static int mlx5e_nic_enable(struct mlx5e_priv *pri=
v)
>  	return err;
>  }
> =20
> +static void mlx5e_data_direct_unbind_dev(struct mlx5e_priv *priv)
> +{
> +	struct mlx5_data_direct_dev *dd_dev;
> +	bool enabled;
> +
> +	dd_dev =3D mlx5_data_direct_get_dev(priv->mdev->data_direct);
> +	if (!dd_dev)
> +		return;
> +
> +	mutex_lock(&priv->state_lock);
> +	enabled =3D MLX5E_GET_PFLAG(&priv->channels.params,
> +				  MLX5E_PFLAG_DATA_DIRECT);
> +	mutex_unlock(&priv->state_lock);
> +	if (enabled)
> +		WARN_ON_ONCE(netdev_unbind_dma_dev(priv->netdev,
> +						   dd_dev->device));
> +}

[Severity: Medium]
Does MLX5E_PFLAG_DATA_DIRECT stay set after resume if the data direct
device is unbound while the NIC is suspended?

During suspend, mlx5e_nic_disable() calls mlx5e_data_direct_unbind_dev()
to unbind the DMA device, then unregisters priv->data_direct_nb.  If the
data direct device is unbound before mlx5e_nic_enable() re-registers the
notifier on resume, mlx5e_data_direct_event() never runs and
mdev->data_direct->dev remains NULL, but MLX5E_PFLAG_DATA_DIRECT is still
set in priv->channels.params.

When mlx5e_nic_enable() reopens the netdev, TX queues are allocated with
MLX5E_SQ_STATE_DATA_DIRECT set without a bound data direct device, and
mlx5e_queue_get_dma_dev() passes dd =3D true to mlx5e_get_dma_dev(),
returning NULL for every queue instead of the PF DMA device and breaking
subsequent memory provider and dmabuf bindings.  Should mlx5e_nic_enable()
clear MLX5E_PFLAG_DATA_DIRECT if mlx5_data_direct_get_dev() is NULL after
registering the notifier?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110183826.2927=
274-1-tariqt@nvidia.com?part=3D12
