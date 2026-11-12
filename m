Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794476412;
	b=wAdgBJnIeRFWZ/PNHbB3ksGMFCd8iAERmsArHtQeWIpiaF8D02nueiEQMKSZ4A4bASQn
	 h4k5tMNSt5PTnOmUwc10y9/f1o/GAVZbyp3bqQ+ckcqY5M00sSgtDWuJemtiskryxYH6s
	 AqwQ+VfcV+eNUnJxvTr6PgM3j7ft1QVwR/Av5kjF9EYeQrCDpd00eh6p7EmvwKj4RztKK
	 ErXWjSK33CpZTEEic7sPt65J3noMj6krlg6TBWE1Qg1rDmZ3YSOrKZZPCS3buJMEAQuCK
	 OJTv7a+Vuf/bRGIbmBfU0JAY4QqekAhL1mArZ8d1ie5YGK05JyKIKRGDS1AoJxHmiEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794476412;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=NyUq0HGbA3xYCUVID2+llNrlZkXulKWcxnwhqdibIlI=;
	b=BbpDg3fZ3TSQRNkduHb0TYmh6erjdTkOYcn02sezTkW38pbql/ccGf8Wznqiyok36NI4
	 fqAXnSpniMDOJ5ZUrg17jF206pBbCbu4wQSdbOX0nxlPuR3N0UtW/6Caf4gtDha3HSWrL
	 Ko7QzLRx+/cjCZ00Z2ygUIxLmHXnRGhBtcektpYG8IjzgmjIGLXb2ZYj6fWx/v7tKOveL
	 CPpEABCNWuq+UgmdpEfWSdHQrAUm/7cTlywMhWM0MLTrhTGK6mv309ilHYyjtlzMpPE6s
	 moss1tuyTy1xJx6Njycpc+Y3Whz1NSE94Tsp4IuTpynW72RsDSc5p1grhTGMzsCU27g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UPZlP6fI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE9E606A31C;
	Thu, 12 Nov 2026 09:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UPZlP6fI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4DB81F00A09;
	Thu, 12 Nov 2026 09:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794476412;
	bh=NyUq0HGbA3xYCUVID2+llNrlZkXulKWcxnwhqdibIlI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=UPZlP6fIyXjZhhA+CNHsPkCgdn5sAUbpb3i3F4cFFKZ6tuCoptu5y5g2XU/TLPBza
	 aiEYyXN9v4JlBVZfZwV3gqObA/OfgDyY4AHiKAaplcrwjfjectqRtGAOUuy1+6pJTO
	 Ne5iumWe4eEcKUl6NEnpW9fS1C0hZEm6jEyDOP0+lEmitTbEklX+qtv0eKfJ7S6Zo2
	 dRWYrqA7IAX6iEk2q3yTBGlX36k5nT/O2EZXdgtha2Y0SFg7JKqCqSsIONuszM3oOn
	 jeOmcJck/qAKKkrANM27gH02V3j7+8eDcBzK5G/peQTc2euLnEvWkFC/CzsInUlI10
	 sVK88RwRZGADg==
Subject: Re: [PATCH net-next V2 09/13] net/mlx5e: Use the correct DMA dev when
 data_direct is enabled
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
Date: Thu, 12 Nov 2026 09:40:10 +0000
Message-ID: <179447641026.2199510.5931919267235772242@kernel.org>
In-Reply-To: <20261110183826.2927274-10-tariqt@nvidia.com>
References: <20261110183826.2927274-10-tariqt@nvidia.com>
X-sashiko-severity: Low
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

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] This patch makes the data-direct PCI device (dd_dev->device) the
  DMA device for the page_pool of data-direct RQs (mlx5e_alloc_rq,…
- [Low] mlx5e_get_dma_dev() (en_main.c:965-976) reads
  mdev->data_direct->dev with READ_ONCE() through…

--

net/mlx5e: Use the correct DMA dev when data_direct is enabled

This commit adds mlx5e_get_dma_dev(). When data_direct is enabled it
returns the data direct device instead of the PF PCI device. The helper
is used for the RQ page_pool DMA device and for .ndo_queue_get_dma_dev,
and the latter now refuses to return a device in data-direct mode when
RX queues are leased.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index 5b99099e4ed0c..ebd41f24330d0 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -962,6 +962,19 @@ static void mlx5e_rq_free_shampo(struct mlx5e_rq *rq)
>  	kvfree(shampo);
>  }
>  
> +static struct device *mlx5e_get_dma_dev(struct mlx5_core_dev *mdev,
> +					bool data_direct)
> +{
> +	struct mlx5_data_direct_dev *dd_dev;
> +
> +	if (!data_direct)
> +		return mlx5_core_dma_dev(mdev);
> +
> +	dd_dev = mlx5_data_direct_get_dev(mdev->data_direct);
> +
> +	return dd_dev ? dd_dev->device : NULL;

[Severity: Low]
Is anything keeping dd_dev alive between the READ_ONCE() in
mlx5_data_direct_get_dev() and the dd_dev->device dereference here?

The unbind side clears the pointer, runs the notifier chain, and then
frees the device:

mlx5_data_direct_remove()
    mlx5_data_direct_dev_unreg(dev)
        ...
        mlx5_data_direct_do_unbind()
            WRITE_ONCE(reg->dd.dev, NULL);
            blocking_notifier_call_chain(&reg->users,
                                         MLX5_DATA_DIRECT_UNBIND, NULL);
    pci_disable_device(pdev);
    kfree(dev->vuid);
    kfree(dev);

At this commit, mlx5e_data_direct_event() only logs on
MLX5_DATA_DIRECT_UNBIND. It takes none of the locks the readers hold,
which is priv->state_lock in mlx5e_queue_get_dma_dev() and in the channel
open path that reaches mlx5e_alloc_rq().

If a reader has already loaded a non-NULL dd_dev, can it dereference it
after kfree(dev)? The returned struct device pointer is also used
without taking a reference.

This does not look reachable at this commit. set_pflag_data_direct()
still returns -EOPNOTSUPP, so data_direct is never true here.

Later in the series, "net/mlx5e: Disable data direct on data direct
device unbind" makes the notifier take rtnl_lock(), netdev_lock() and
priv->state_lock before it returns. That serializes it against these
readers before kfree(dev) runs.

> +}
> +
>  static int mlx5e_alloc_rq(struct mlx5e_params *params,
>  			  struct mlx5e_rq_param *rq_param,
>  			  struct mlx5e_rq_opt_param *rqo,
> @@ -1105,7 +1118,11 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
>  		pp_params.flags     = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV;
>  		pp_params.pool_size = pool_size;
>  		pp_params.nid       = node;
> -		pp_params.dev       = rq->pdev;
> +		pp_params.dev       = mlx5e_get_dma_dev(mdev, data_direct);

[Severity: Low]
With this change, the page_pool of a data direct RQ is created against
dd_dev->device. mlx5e_queue_get_dma_dev() also hands that device to
memory providers (devmem, io_uring zcrx), which map their buffers
against it.

What tears these down when the data direct device is unbound? At this
commit, this is the only mlx5e consumer of MLX5_DATA_DIRECT_UNBIND:

mlx5e_data_direct_event() {
    ...
	if (action == MLX5_DATA_DIRECT_UNBIND)
		mlx5_core_dbg(priv->mdev, "data direct device unbound\n");

	return NOTIFY_OK;
}

It doesn't close the data direct RQs, destroy their page pools, or
unbind the memory provider mappings. mlx5_data_direct_remove() then
runs pci_disable_device() and kfree(dev) right after the notifier
returns.

Could the page_pool and dmabuf mappings outlive the device they were
mapped against?

This also doesn't appear reachable at this commit, since
set_pflag_data_direct() in en_ethtool.c still returns -EOPNOTSUPP.

Later in the series, "net/mlx5e: Disable data direct on data direct
device unbind" rewrites mlx5e_data_direct_event(). The new version calls
netif_close() and netdev_unbind_dma_dev(), then clears
MLX5E_PFLAG_DATA_DIRECT. The flag only becomes settable later, in
"net/mlx5e: Enable the data direct netdev feature".

> +		if (!pp_params.dev) {
> +			err = -ENODEV;
> +			goto err_free_by_rq_type;
> +		}
>  		pp_params.napi      = rq->cq.napi;
>  		pp_params.netdev    = rq->netdev;
>  		pp_params.dma_dir   = rq->buff.map_dir;

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261110183826.2927274-1-tariqt%40nvidia.com
