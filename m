Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794476420;
	b=fSwgn60jP8yVtcgluOFIEXuKvaHsu9biMibfn9msPxf3TFCmfnxb+naG4PuVlGtlXH88
	 qrLZCNeCbeRwTaV7KMHZIBvMFOcdstRsIa1/UySpu16bAoM/H8vPSXtROKMHyNleh7Nex
	 vnPtEpKZhqHbprmvgqrog9UtmuXJWDExbTIUNlaW41EoIFca7AwOfTZuONIB/nIeiV/ql
	 2GAZ4RRIttxAfO/mbf4xNXyzFc46BPxeAPRr9zSBB7I5EqCe55voPA984MUKVUQAkxnzS
	 ezFIcGPr4IEAj4cq9Lhp34fisLRkI61SEYBiCJozrGqGBjm90MVuMGF4epXlb3DEGnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794476420;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=nfBezKBdxLXSAVbqgVYtBr/75KwOkIqOMORKzm/Op+o=;
	b=NIiwKZ9lBdh636Jpg6Zu/F7/VTH5gYjH3QDeb60u+cj6AOuvkrrk28Rjmx42Nea8h9X6
	 zQof6TMEPnGw22mCbSI+a4co1sQQrrxlUfP6u1pP+A0TUk3nNgVHexKqpFPeB7khDcpvG
	 dr+EWsrusax0RC7KcouZ3RHKdMQ4kMGUqs2mYqwedO5lGO+Z/tDuIc91sMBYuKhwVjBLq
	 iPlpHjxO0aFCl3fZ8KrJJh2W7BSEGHunqy25iVG9QAupSq50nJtbSKcO5nYWA2NOzB7uF
	 7UOK8g8spdMjqT4zXmZem+KA8N5aVwAZLj9tTwjUOw+/MgDHwfpJcJf6FeC9oUi1p5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cFnjPKgB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61E6606A895;
	Thu, 12 Nov 2026 09:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cFnjPKgB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC46F1F00A14;
	Thu, 12 Nov 2026 09:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794476419;
	bh=nfBezKBdxLXSAVbqgVYtBr/75KwOkIqOMORKzm/Op+o=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=cFnjPKgB5YRnaQmJ22jrU+hoVkiEfZiC23vGTlfBDAxi0Vs2O/6y27iXS8U73rCJe
	 +GoaqO8nY/MubvPluRvXjO7MfLoKWUOO0ehAn4OHhwtpQ01B/QCw4/U/lnd1UXmagi
	 wq0F6Ibj/xcTHoLSKuOd0YG2U9x5vkftqDtkSJforRUg2uXLhfW9a+bRiDYPKBhnu8
	 XEPboPV+MmAO1CyxDZjBVyirfCOljLUdbFvqEVkilXUUG23uaeFzq6gLd2U/r2Uhc5
	 RZxAmjktcuLB8sWWSKJQ+eyT0O3onMzAgp0FhEkxv0k4il47bd9D5O8J/JmkJWiYQm
	 gdE/IxD1jShgA==
Subject: Re: [PATCH net-next V2 12/13] net/mlx5e: Disable data direct on data
 direct device unbind
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 bobbyeshleman@meta.com, cjubran@nvidia.com, cratiu@nvidia.com,
 daniel@iogearbox.net, dw@davidwei.uk, dtatulea@nvidia.com, erfansh@meta.com,
 gal@nvidia.com, Jacob.e.keller@intel.com, kaifengw@google.com,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 mbloch@nvidia.com, mfleming@cloudflare.com, almasrymina@google.com,
 razor@blackwall.org, saeedm@nvidia.com, horms@kernel.org, sdf@fomichev.me,
 sdf.kernel@gmail.com, witu@nvidia.com
Date: Thu, 12 Nov 2026 09:40:17 +0000
Message-ID: <179447641740.2199510.285792504757822678@kernel.org>
In-Reply-To: <20261110183826.2927274-13-tariqt@nvidia.com>
References: <20261110183826.2927274-13-tariqt@nvidia.com>
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

Thank you for your contribution! Sashiko AI review found 4 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 2 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The suspend teardown and the notifier teardown leave the
  data_direct private flag in different states.
- [Medium] mlx5e_data_direct_event() can run against a netdev that
  mlx5e_nic_disable() or mlx5e_nic_enable() is in the middle of…
- [Low] Socket-direct gap: both new paths only look at priv->mdev's data-
  direct device, while mlx5e_queue_get_dma_dev() picks the DMA device…
- [Low] Notifier payload contract: mlx5_data_direct_do_unbind() now
  passes reg->dd.dev as the UNBIND payload.

--

net/mlx5e: Disable data direct on data direct device unbind

When the data direct device is unbound, the notifier handler now stops the
netdev, releases the providers bound to that DMA device and clears the
data_direct private flag. The suspend path also releases those providers,
because the notifier is not registered while the device is suspended.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/data_direct.c b/drivers/net/ethernet/mellanox/mlx5/core/data_direct.c
> index 7db94b8a5b79c..246a03f44afd3 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/data_direct.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/data_direct.c
> @@ -198,9 +198,11 @@ static void mlx5_data_direct_bind(struct mlx5_data_direct_registration *reg,
>  static void
>  mlx5_data_direct_do_unbind(struct mlx5_data_direct_registration *reg)
>  {
> +	struct mlx5_data_direct_dev *dev = reg->dd.dev;
> +
>  	WRITE_ONCE(reg->dd.dev, NULL);
>  	blocking_notifier_call_chain(&reg->users, MLX5_DATA_DIRECT_UNBIND,
> -				     NULL);
> +				     dev);
>  }

[Severity: Low]
This isn't a bug, but the UNBIND payload is now an implicit contract. It is
not documented next to enum mlx5_data_direct_event in
include/linux/mlx5/data_direct.h.

reg->dd.dev can be NULL here when mlx5_data_direct_cleanup() calls this for
a registration that was never bound. mlx5e_data_direct_event() dereferences
dd_dev->device without a NULL check.

As far as I can tell, that path can't be hit today.
mlx5_data_direct_cleanup() is only called from mlx5_unload(). By then,
mlx5_detach_device() or mlx5_unregister_device() has already gone through
mlx5e_nic_disable()->mlx5_data_direct_unregister(). The dereference also
sits behind the pflag check, and the pflag can only be set while dd.dev is
non-NULL.

Would it make sense to document the payload type and the fact that it can
be NULL, or to add a NULL check in the handler?

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index ebd41f24330d0..63d91ef0dda80 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -6170,9 +6170,53 @@ static int mlx5e_data_direct_event(struct notifier_block *nb,

[ ... ]

> +	if (action != MLX5_DATA_DIRECT_UNBIND)
> +		return NOTIFY_DONE;
> +
> +	rtnl_lock();
> +	netdev_lock(netdev);
> +
> +	mutex_lock(&priv->state_lock);
> +	enabled = MLX5E_GET_PFLAG(&priv->channels.params,
> +				  MLX5E_PFLAG_DATA_DIRECT);
> +	mutex_unlock(&priv->state_lock);
> +	if (!enabled)
> +		goto out;
> +
> +	reopen = netif_running(netdev);
> +	netif_close(netdev);

[Severity: Medium]
Can this handler run against a netdev that mlx5e_nic_disable() has already
detached? Nothing checks netif_device_present() before netif_close().

On the disable side, mlx5_data_direct_do_unbind() sets dd.dev to NULL. The
handler then blocks in rtnl_lock() while mlx5e_nic_disable() holds rtnl and
runs:

	if (netif_running(priv->netdev))
		mlx5e_close(priv->netdev);
	netif_device_detach(priv->netdev);
	...
	mlx5e_data_direct_unbind_dev(priv);
	netdev_unlock(priv->netdev);
	rtnl_unlock();

	mlx5e_nic_set_rx_mode(priv);

	mlx5_data_direct_unregister(mdev, &priv->data_direct_nb);

mlx5e_data_direct_unbind_dev() finds mlx5_data_direct_get_dev() == NULL and
returns without doing anything. mlx5e_close() is the ndo-level call, so
IFF_UP and __LINK_STATE_START stay set.

Once rtnl is dropped, the handler continues with the pflag still set and
reopen = true. netif_close()->__dev_close_many() clears IFF_UP and
__LINK_STATE_START and sends NETDEV_GOING_DOWN/NETDEV_DOWN. Then
netif_open()->__dev_open() fails with -ENODEV because the device is
detached.

The profile can be enabled again later, on resume or for the uplink rep
profile after an eswitch mode change. At that point mlx5e_nic_enable()
checks:

	if (netif_running(netdev))
		mlx5e_open(netdev);

That check is now false. Does the interface then stay administratively
down?

The enable side has a similar window. mlx5e_nic_enable() registers the
notifier before it takes rtnl and before netif_device_attach(). An unbind
handled in that window would do the same close and failed open on a netdev
that is still detached.

Is a netif_device_present() check needed here, or some other handling for
the detached case?

> +
> +	err = netdev_unbind_dma_dev(netdev, dd_dev->device);
> +	if (WARN_ON_ONCE(err)) {
> +		netdev_err(netdev, "Failed to unbind dma device, won't reopen netdev, err=%d\n",
> +			   err);
> +		goto out;
> +	}
> +
> +	mutex_lock(&priv->state_lock);
> +	new_params = priv->channels.params;
> +	MLX5E_SET_PFLAG(&new_params, MLX5E_PFLAG_DATA_DIRECT, false);
> +	mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, false);
> +	mutex_unlock(&priv->state_lock);
> +
> +	netdev_info(netdev, "data_direct device unbound, disabled data_direct\n");
>  
> -	if (action == MLX5_DATA_DIRECT_UNBIND)
> -		mlx5_core_dbg(priv->mdev, "data direct device unbound\n");
> +	if (reopen) {
> +		err = netif_open(netdev, NULL);
> +		if (err)
> +			netdev_err(netdev, "Failed to reopen after data_direct unbind, err=%d\n",
> +				   err);
> +	}

[ ... ]

> @@ -6407,6 +6451,24 @@ static int mlx5e_nic_enable(struct mlx5e_priv *priv)
>  	return err;
>  }
>  
> +static void mlx5e_data_direct_unbind_dev(struct mlx5e_priv *priv)
> +{
> +	struct mlx5_data_direct_dev *dd_dev;
> +	bool enabled;
> +
> +	dd_dev = mlx5_data_direct_get_dev(priv->mdev->data_direct);

[Severity: Low]
This helper and the notifier only look at priv->mdev's data direct device.
mlx5e_queue_get_dma_dev() picks the DMA device per channel:

	dma_dev = mlx5e_get_dma_dev(ch->mdev, dd);

Here ch->mdev comes from mlx5_sd_ch_ix_get_dev(). With socket direct, would
providers and dmabuf bindings mapped to a secondary PF's data direct device
stay in place?

This appears to be resolved later in the series. The patch "net/mlx5e:
Enable the data direct netdev feature" makes set_pflag_data_direct() return
-EOPNOTSUPP when mlx5_get_sd(mdev) is non-NULL, and at this commit the flag
can't be enabled at all.

> +	if (!dd_dev)
> +		return;
> +
> +	mutex_lock(&priv->state_lock);
> +	enabled = MLX5E_GET_PFLAG(&priv->channels.params,
> +				  MLX5E_PFLAG_DATA_DIRECT);
> +	mutex_unlock(&priv->state_lock);
> +	if (enabled)
> +		WARN_ON_ONCE(netdev_unbind_dma_dev(priv->netdev,
> +						   dd_dev->device));
> +}

[Severity: Medium]
mlx5e_data_direct_event() clears the flag, but this helper only releases the
providers. MLX5E_PFLAG_DATA_DIRECT stays set in priv->channels.params. Can
that leave a stale flag after resume?

On PCI PM suspend the path is:

mlx5_suspend()
  mlx5_unload_one(dev, true)
    mlx5e_suspend()
      mlx5e_detach_netdev()
        mlx5e_nic_disable()
          mlx5e_data_direct_unbind_dev()

While the device is suspended, mlx5_unload()->mlx5_data_direct_cleanup()
frees the registration, and the mlx5e notifier is unregistered.

The data direct PCI function could go away in that window. The commit
message says such an unbind "would go unnoticed". In that case
mlx5_data_direct_init() finds no matching device on resume, and dd.dev
stays NULL.

mlx5e_attach_netdev() and mlx5e_nic_enable() keep the old params.
mlx5e_nic_enable() registers the notifier again without checking the flag
against mlx5_data_direct_get_dev().

That has three effects:

- ethtool reports data_direct as on with no device behind it.
- mlx5e_queue_get_dma_dev()->mlx5e_get_dma_dev() returns NULL for every
  queue. Devmem and io_uring zcrx binds then fail instead of falling back
  to the PF DMA device.
- mlx5e_alloc_txqsq() keeps creating SQs with MLX5E_SQ_STATE_DATA_DIRECT
  and the crossing mkey.

The commit message says "To prevent further use disable the private flag",
but the flag is not cleared on this path. Should the suspend path clear it
too, or should mlx5e_nic_enable() check it again?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261110183826.2927274-1-tariqt%40nvidia.com
