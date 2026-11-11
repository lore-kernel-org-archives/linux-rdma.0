Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794423116;
	b=evuqMpWtHQI/MZn9LUWeFRj2E7V+J6plJDqbZeDJC3+KFjb2HyaTH+k4JBrv95w7PVWO
	 qO30vZUGYV+1lxOF9UcXe8iKSeD1ll4nkrn/ftvuGM8vj1lYWPYjSbBQ70ENylHXOT17u
	 QN5e2dMBM7tWDjUuvyDF3nOwBD+jqzVY7cHzb8evulG8GdKb7a3jQAqOytcGRgV+/o26E
	 iTXtG5O+DOb2LiD5OL7TwNPqJNUFDij3Tsl91neXa2mqIV3ujklO/ndbn2HqI5lkVag3C
	 /y+2M+OLHB95HUdXEvjpH+V5bxYv4PyqCXxf/K5rTCU1TGRS3s1O+IAnO85Bd4pQ2LQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794423116;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=cXy90lB9ier5/0rOFar7kwJ0LRRMvTBhXN8p7YdUqkM=;
	b=jlamaS2VcC8pi+Sv7Vq4Ze+6JC2Mgg/weRuAp64kKSPrJSrYjgRGPISBQm5/O9EWujfp
	 goV61BAmvHRqEJqru1dAgErSx8TNsCp8i3vn7l6VE+1sxve75heyXu0Qu2KiITjerAKxE
	 TJ2cJydYtGCQjLqsLLI1Yq3cl+yw9Ll0g+yVesnNUgB+faIE0nYo7vWgKjEnTBrRsZW5s
	 H911YFMUEjOaoNyWtepXRgeZsHABe7JZolYl7/GiQVSzT0E1hhPr110lRcWi6F5RD7KP7
	 dcwMVops3U4icqNBsUpuQXl93QTQPvLiTJg7gcNRuY96mYTkRoyLuUhFmiN03RmsHtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X3NDFFJe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8748606A31C;
	Wed, 11 Nov 2026 18:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X3NDFFJe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1917E1F00A05;
	Wed, 11 Nov 2026 18:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794423116;
	bh=cXy90lB9ier5/0rOFar7kwJ0LRRMvTBhXN8p7YdUqkM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X3NDFFJeIELCWrEDwGqaUq3LbXCmhJdDkSLWt8DBivn5Bk1u2S/CvFNUCdykxXYdh
	 dhhvMbm8yN/rPsZsTgrkWAj4ZkjVhJiBnpVODLxI2VuWSCZe0INntPP2s/wFXtDmr/
	 YjeiLI4WzJc+pXZsMN5RyNWlAhUmEvdIWD+acvQLq3BZvGKNmsIsvfpKyj2pTiKjvt
	 oogQDuv8W0c40dmuxDhl33stQs/ZjgsCljbRlCDoQDvDLJax3ycxgFXAIMXdbx+NEg
	 u0HWrA4q8kBvFGKEeVgb3mHVCWblAD2+zst2HYwhaU/ldINXi+ODVqhU1rStho6Xzq
	 l9VZvV/SQk/IQ==
Message-ID: <sashiko-outbox-209498@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V2 1/2] net/mlx5e: Batch NAPI RCU grace periods
 on channel close
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: bpf@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261110185005.2932568-2-tariqt@nvidia.com>
References: <20261110185005.2932568-1-tariqt@nvidia.com>
 <20261110185005.2932568-2-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 18:51:55 +0000
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
- [High] net/mlx5e: missing grace period after page_pool_destroy() in
  channel close
- [Low] net/mlx5e: redundant pre/post_sync open-coding and duplicated
  queue teardown
--

commit 2f06177c661abed7fd45e14fc9a588083535c8b2
Author: Carolina Jubran <cjubran@nvidia.com>

net/mlx5e: Batch NAPI RCU grace periods on channel close

This commit splits channel deactivation and teardown into pre_sync and
post_sync phases so that synchronize_net() grace periods are batched
across all channels during channel close.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en_main.c
> index c3c2c5720c6f3..73b504ba8c8c6 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c

[ ... ]

> @@ -2749,6 +2785,27 @@ static void mlx5e_close_queues(struct mlx5e_channe=
l *c)
>  	mlx5e_close_cq(&c->icosq.cq);
>  }
> =20
> +static void mlx5e_close_queues_post_sync(struct mlx5e_channel *c)
> +{
> +	if (c->xdp)
> +		mlx5e_close_xdpsq_post_sync(&c->rq_xdpsq);
> +	/* The same ICOSQ is used for UMRs for both RQ and XSKRQ. */
> +	cancel_work_sync(&c->icosq.recover_work);
> +	mlx5e_close_rq(&c->rq);
> +	mlx5e_close_sqs(c);
> +	mlx5e_close_icosq(&c->icosq);
> +	mutex_destroy(&c->icosq_recovery_lock);
> +	if (c->async_icosq)
> +		mlx5e_close_async_icosq(c->async_icosq);
> +	if (c->xdp)
> +		mlx5e_close_cq(&c->rq_xdpsq.cq);
> +	mlx5e_close_cq(&c->rq.cq);
> +	if (c->xdpsq)
> +		mlx5e_close_xdpredirect_sq_post_sync(c->xdpsq);
> +	mlx5e_close_tx_cqs(c);
> +	mlx5e_close_cq(&c->icosq.cq);
> +}

[ ... ]

> @@ -3060,32 +3144,67 @@ static int mlx5e_wait_channels_min_rx_wqes(struct=
 mlx5e_channels *chs)

[ ... ]

> +static void mlx5e_close_channels_pre_sync(struct mlx5e_channels *chs)
> +{
> +	int i;
> +
> +	if (chs->ptp)
> +		__netif_napi_del_locked(&chs->ptp->napi);
> +
> +	for (i =3D 0; i < chs->num; i++) {
> +		mlx5e_close_channel_pre_sync(chs->c[i]);
> +		__netif_napi_del_locked(&chs->c[i]->napi);
> +	}
> +}
> +
> +static void mlx5e_close_channels_post_sync(struct mlx5e_channels *chs)
> +{
> +	int i;
> +
> +	if (chs->ptp) {
> +		mlx5e_ptp_close_queues(chs->ptp);
> +		kvfree(chs->ptp);
> +		chs->ptp =3D NULL;
> +	}
> +
> +	for (i =3D 0; i < chs->num; i++) {
> +		mlx5e_close_channel_post_sync(chs->c[i]);
> +		kvfree(chs->c[i]);
> +	}
> =20
>  	kfree(chs->c);
>  	chs->num =3D 0;
>  }
> =20
> +void mlx5e_close_channels(struct mlx5e_channels *chs)
> +{
> +	mlx5e_close_channels_pre_sync(chs);
> +	synchronize_net();
> +	mlx5e_close_channels_post_sync(chs);
> +}

[Severity: High]
Can freeing chs->ptp and chs->c[i] in mlx5e_close_channels_post_sync()
cause a use-after-free on &c->napi (or &ptp->napi) in
page_pool_napi_local()?

rq->page_pool is created with pool->p.napi pointing to the NAPI struct
embedded in struct mlx5e_channel or struct mlx5e_ptp.  That pointer is
only cleared when mlx5e_close_rq() -> mlx5e_free_rq() ->
xdp_rxq_info_unreg() calls page_pool_destroy():

net/core/page_pool.c:page_pool_disable_direct_recycling() {
	...
	WRITE_ONCE(pool->p.napi, NULL);
}

Before this patch, mlx5e_close_queues() and mlx5e_ptp_close_queues() ran
before netif_napi_del_locked(), so synchronize_net() waited for any
concurrent softirq running page_pool_napi_local() to finish before
kvfree() freed the channel.  Moving queue teardown into
mlx5e_close_channels_post_sync() places page_pool_destroy() after
synchronize_net(), and page_pool_scrub() skips its own synchronize_net()
when dma_dev_need_sync() is false:

CPU0                                  CPU1 (<softirq>)
mlx5e_close_channels()
  mlx5e_close_channels_pre_sync()
  synchronize_net()
  mlx5e_close_channels_post_sync()
    mlx5e_close_channel_post_sync()
      ...
                                      napi_consume_skb()
                                        ...
                                          page_pool_napi_local()
                                            napi =3D READ_ONCE(pool->p.napi=
);
        page_pool_destroy()
          WRITE_ONCE(pool->p.napi, NULL);
    kvfree(chs->c[i])
                                            READ_ONCE(napi->list_owner)
                                              <-- use-after-free

Closing the queues before synchronize_net() (or waiting for a grace period
after page_pool_destroy() before kvfree()) would avoid freeing the channel
while a softirq still holds the NAPI pointer.

[ ... ]

> @@ -3610,8 +3742,14 @@ int mlx5e_close_locked(struct net_device *netdev)
>  	clear_bit(MLX5E_STATE_OPENED, &priv->state);
> =20
>  	netif_carrier_off(priv->netdev);
> -	mlx5e_deactivate_priv_channels(priv);
> -	mlx5e_close_channels(&priv->channels);
> +
> +	mlx5e_deactivate_priv_channels_pre_sync(priv);
> +	synchronize_net();
> +	mlx5e_deactivate_priv_channels_post_sync(priv);
> +
> +	mlx5e_close_channels_pre_sync(&priv->channels);
> +	synchronize_net();
> +	mlx5e_close_channels_post_sync(&priv->channels);
> =20
>  	return 0;
>  }

[Severity: Low]
This isn't a bug, but mlx5e_close_locked() open-codes the exact bodies of
mlx5e_deactivate_priv_channels() and mlx5e_close_channels() without
combining their synchronize_net() calls, so it could keep calling those
two helpers directly.  Similarly, mlx5e_close_queues_post_sync()
duplicates mlx5e_close_queues(); mlx5e_close_queues() could run the
pre_sync steps, call synchronize_net(), and call
mlx5e_close_queues_post_sync() like mlx5e_close_channel() does.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110185005.2932=
568-1-tariqt@nvidia.com?part=3D1
