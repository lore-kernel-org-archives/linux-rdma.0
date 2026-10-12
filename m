Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71429381AEC;
	Mon, 12 Oct 2026 13:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791812910; cv=none; b=KhKj6y07bJq5K8/AZO2gu7flpJxgQu6cEGOFZ7E//K5uALpzK5l4aVpvYBQBEMOfQG9b32y2jQN5YBTSQFwFo1kWIGNt/iqVZMByLVOGfFTWX1HNRwkGs1/hwPzMPvGW8D/Z9rs9N397TlXFEj9UO7PlX09auNCvVB2jkXipaGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791812910; c=relaxed/simple;
	bh=LPF0coI4H5tCLe99BOy3JgnEs2TNO18R95uk/L4Jay8=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lxh5IOX5GgEuoXEP+Q+810NHePLAKQf6uvcE5Hozanj3aY1dg9mdstOSSYrPMR86684dvi7u3PMkTKsbTcghnj4ZFnMq6pZ3D3/gse9TV9NpB3xZUpSk0kNpuCYciuB0wEcs6KJr1ZCfOnRDEbGpQO2TbMcRqcZZMDzy1VDElTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WTY8oW9P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WTY8oW9P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C721F0089B;
	Mon, 12 Oct 2026 13:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791812909;
	bh=KKbqmwIe3j/zqOZorSSMeoSz3GMtxlQ5ZgnAqnhBq54=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=WTY8oW9PjBeVdgiuXuZ+VadhAeS64JjgvJTD77lq8j1k1R/eBL/XEvmDDusfSGEVh
	 GLoKbyk2za2mKy8q74aULCyB4qnKWcbcG0Qj9T2nnNxr5tfIPRndLy8xNqrUqjCQ26
	 oacqEotsTuVcvuekSaFhaMfTaCzAAMjuhUjqwYolF5msFHfbyXNjBc4ixCLfVGtb32
	 zohtnPnuUTqgLCaw7vCr7cgtVPZnmAX4aAdd5SUjA39VjPZzKGfSRwMb00++ZQB+Yk
	 75EtlzMPK1le2PklkHlisjongj0fho/5faJ36qootAWpW3WGVcMmOLNqq/ZvBP2+Mo
	 oW7Z5L+4CTbmg==
Subject: Re: [PATCH net-next 1/2] net/mlx5e: Batch NAPI RCU grace periods on
 channel close
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, ast@kernel.org,
 bpf@vger.kernel.org, cjubran@nvidia.com, cratiu@nvidia.com,
 daniel@iogearbox.net, dtatulea@nvidia.com, gal@nvidia.com, hawk@kernel.org,
 john.fastabend@gmail.com, kees@kernel.org, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 lirongqing@baidu.com, mbloch@nvidia.com, richardcochran@gmail.com,
 saeedm@nvidia.com, shshitrit@nvidia.com, sdf@fomichev.me, toke@redhat.com,
 toke@kernel.org, amorenoz@redhat.com, mschmidt@redhat.com
Date: Mon, 12 Oct 2026 13:48:26 +0000
Message-ID: <179181290697.434549.8876520561458529007@kernel.org>
In-Reply-To: <20261011133212.807979-2-tariqt@nvidia.com>
References: <20261011133212.807979-2-tariqt@nvidia.com>
X-sashiko-severity: Critical
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 4 potential
issue(s) to consider.

Critical: 1 · High: 0 · Medium: 1 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Critical] Use-after-free in mlx5e_close_locked() (the ndo_stop path),
  introduced by this patch.
- [Medium] The commit message does not match the close-phase code, and
  the close path's safety now rests on an undocumented, unenforced…
- [Low] mlx5e_close_locked() now calls mlx5e_close_channels_pre_sync()
  and mlx5e_close_channels_post_sync() directly instead of…
- [Low] The patch changes how mlx5e_close_channel_post_sync()
  (en_main.c:3032) decides whether to tear down a channel's XSK queues,…

--

net/mlx5e: Batch NAPI RCU grace periods on channel close

This splits mlx5e channel deactivate and close into pre_sync and post_sync
phases, so one synchronize_net() covers all channels instead of one per
queue. NAPI instances are unlinked with __netif_napi_del_locked(), and a
single grace period is taken before the channels are freed. Single-queue
paths are meant to keep their own synchronize_net() calls.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index f90b5a34e097..fe4e5d0b2e9a 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c

[ ... ]

> @@ -2141,18 +2160,28 @@ int mlx5e_open_xdpsq(struct mlx5e_channel *c, struct mlx5e_params *params,
>  	return err;
>  }
>  
> -void mlx5e_close_xdpsq(struct mlx5e_xdpsq *sq)
> +static void mlx5e_destroy_xdpsq(struct mlx5e_xdpsq *sq)
>  {
>  	struct mlx5e_channel *c = sq->channel;
>  
> -	clear_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
> -	synchronize_net(); /* Sync with NAPI. */
> -
>  	mlx5e_destroy_sq(c->mdev, sq->sqn);
>  	mlx5e_free_xdpsq_descs(sq);
>  	mlx5e_free_xdpsq(sq);
>  }
>  
> +void mlx5e_close_xdpsq_post_sync(struct mlx5e_xdpsq *sq)
> +{
> +	clear_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
> +	mlx5e_destroy_xdpsq(sq);
> +}
> +
> +void mlx5e_close_xdpsq(struct mlx5e_xdpsq *sq)
> +{
> +	clear_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
> +	synchronize_net(); /* Sync with NAPI. */
> +	mlx5e_destroy_xdpsq(sq);
> +}
> +

[Severity: Medium]
The commit message says:

  First clear the ENABLED state on all queues, then wait for a single
  grace period before continuing with the teardown.

and:

  Keep the existing per object synchronize_net() calls for single queue
  paths.

Does that match the close phase?

mlx5e_close_xdpsq_post_sync() clears MLX5E_SQ_STATE_ENABLED after the
shared grace period and then destroys the SQ right away. So there is no
pre_sync clear for rq_xdpsq, the XDP_REDIRECT xdpsq or xsksq, and nothing
waits after this clear_bit(). mlx5e_close_channel_pre_sync() only clears
MLX5E_CHANNEL_STATE_XSK.

The other close-phase waits follow the same pattern:

- mlx5e_qos_close_queues_post_sync() removes the synchronize_rcu()
  between unpublishing and freeing the array instead of batching it.

- The single-queue path mlx5e_close_xsk() goes from two synchronize_net()
  calls to one. That particular reduction looks safe on its own, because
  NAPI only touches xsksq under the xsk_open snapshot taken in the same
  RCU section.

So these waits look removed rather than batched, on the assumption that
NAPI is already disabled. That precondition only appears in a comment in
mlx5e_qos_close_queues_post_sync():

	/* Caller guarantees that NAPI is stopped or was never enabled. */

mlx5e_close_xdpsq_post_sync() is exported in en.h and also called from
xsk/setup.c, but nothing documents or enforces that requirement.

Could the commit message describe this? Could the precondition also be
documented on the exported post_sync helpers? As noted below for
mlx5e_close_locked(), NAPI being disabled may not be enough on its own.

[ ... ]

> @@ -2936,35 +2993,56 @@ static void mlx5e_activate_channel(struct mlx5e_channel *c)

[ ... ]

> -static void mlx5e_close_channel(struct mlx5e_channel *c)
> +static void mlx5e_close_channel_pre_sync(struct mlx5e_channel *c)
>  {
>  	if (test_bit(MLX5E_CHANNEL_STATE_XSK, c->state))
> -		mlx5e_close_xsk(c);
> -	mlx5e_close_queues(c);
> -	mlx5e_qos_close_queues(c);
> -	netif_napi_del_locked(&c->napi);
> +		mlx5e_close_xsk_pre_sync(c);
> +}
> +
> +static void mlx5e_close_channel_post_sync(struct mlx5e_channel *c)
> +{
> +	if (c->xskrq.xsk_pool)
> +		mlx5e_close_xsk_post_sync(c);

[Severity: Low]
This isn't a bug, but the test for tearing down the XSK queues changes
here from test_bit(MLX5E_CHANNEL_STATE_XSK, c->state) to
c->xskrq.xsk_pool. It is only correct because of the new error-path reset
in mlx5e_open_xsk() in xsk/setup.c:

err_close_rx_cq:
	mlx5e_close_cq(&c->xskrq.cq);

	c->xskrq.xsk_pool = NULL;
	c->xsksq.xsk_pool = NULL;

Without that reset, a failed mlx5e_xsk_enable_locked() on a live channel
would leave the pool pointer set. Close would then tear down xskrq and
xsksq a second time.

The two hunks depend on each other, but the commit message mentions
neither. Could this be noted in the commit message, so a partial backport
or a later edit to the error path doesn't bring back a double teardown?

> +	mlx5e_close_queues_post_sync(c);
> +	mlx5e_qos_close_queues_post_sync(c);
> +}

[ ... ]

> @@ -3060,33 +3138,72 @@ static int mlx5e_wait_channels_min_rx_wqes(struct mlx5e_channels *chs)

[ ... ]

> +static void mlx5e_close_channels_post_sync(struct mlx5e_channels *chs)
>  {
>  	int i;
>  
> -	ASSERT_RTNL();
>  	if (chs->ptp) {
> -		mlx5e_ptp_close(chs->ptp);
> +		mlx5e_ptp_close_queues(chs->ptp);
> +		__netif_napi_del_locked(&chs->ptp->napi);
> +	}
> +
> +	for (i = 0; i < chs->num; i++) {
> +		mlx5e_close_channel_post_sync(chs->c[i]);
> +		__netif_napi_del_locked(&chs->c[i]->napi);
> +	}
> +
> +	synchronize_net();
> +
> +	if (chs->ptp) {
> +		kvfree(chs->ptp);
>  		chs->ptp = NULL;
>  	}
> +
>  	for (i = 0; i < chs->num; i++)
> -		mlx5e_close_channel(chs->c[i]);
> +		kvfree(chs->c[i]);
>  
>  	kfree(chs->c);
>  	chs->num = 0;
>  }
>  
> +void mlx5e_close_channels(struct mlx5e_channels *chs)
> +{
> +	ASSERT_RTNL();
> +	mlx5e_close_channels_pre_sync(chs);
> +	synchronize_net();
> +	mlx5e_close_channels_post_sync(chs);
> +}

[Severity: Low]
mlx5e_close_locked() now calls mlx5e_close_channels_pre_sync() and
mlx5e_close_channels_post_sync() directly. That means the ASSERT_RTNL(),
which now lives only in this wrapper, no longer runs on the ndo_stop path.

This isn't a functional bug, since mlx5e_close() and mlx5e_rep_close()
both run under RTNL. Would it be worth keeping the assertion in
mlx5e_close_locked() or in the split helpers?

[ ... ]

> @@ -3611,8 +3741,14 @@ int mlx5e_close_locked(struct net_device *netdev)
>  	clear_bit(MLX5E_STATE_OPENED, &priv->state);
>  
>  	netif_carrier_off(priv->netdev);
> -	mlx5e_deactivate_priv_channels(priv);
> -	mlx5e_close_channels(&priv->channels);
> +
> +	mlx5e_deactivate_priv_channels_pre_sync(priv);
> +	mlx5e_close_channels_pre_sync(&priv->channels);
> +
> +	synchronize_net();
> +
> +	mlx5e_deactivate_priv_channels_post_sync(priv);
> +	mlx5e_close_channels_post_sync(&priv->channels);

[Severity: Critical]
In mlx5e_close_locked(), the only grace period now runs before
napi_disable_locked(). What waits for a NAPI poll that is still running
between napi_disable_locked() and the frees in
mlx5e_close_channels_post_sync()?

The sequence becomes:

mlx5e_close_locked()
    synchronize_net()
    mlx5e_deactivate_priv_channels_post_sync()
        mlx5e_deactivate_channel_post_sync()
            napi_disable_locked(&c->napi)
    mlx5e_close_channels_post_sync()
        mlx5e_close_channel_post_sync()
            mlx5e_close_queues_post_sync()
                frees sq->dim, rq->dim, c->async_icosq, c->xdpsq
            mlx5e_qos_close_queues_post_sync()
                kfree(sq), kvfree(qos_sqs), no grace period
        synchronize_net()
        kvfree(chs->c[i])

napi_disable_locked() only waits for NAPIF_STATE_SCHED to be released.
Documentation/networking/napi.rst notes that napi_disable() does not wait
for the poll method to exit.

mlx5e_napi_poll() keeps using queue memory after napi_complete_done(),
inside rcu_read_lock():

mlx5e_napi_poll() {
    ...
	qos_sqs = rcu_dereference(c->qos_sqs);
    ...
	if (unlikely(!napi_complete_done(napi, work_done)))
		goto out;
    ...
	for (i = 0; i < c->num_tc; i++) {
		mlx5e_handle_tx_dim(&c->sq[i]);
		mlx5e_cq_arm(&c->sq[i].cq);
    ...
			if (sq) {
				mlx5e_handle_tx_dim(sq);
				mlx5e_cq_arm(&sq->cq);
    ...
	mlx5e_handle_rx_dim(rq);
    ...
}

The NAPI CPU could be delayed after napi_complete_done(), for example a
preempted threaded NAPI on PREEMPT_RT, or vCPU preemption. In that case,
can this tail touch the QoS SQs, the qos_sqs array, the DIM structs,
async_icosq and xdpsq after they have been freed? net_dim() could also
schedule dim->work on freed memory after cancel_work_sync() has already
run.

Before this patch, mlx5e_qos_close_queues() did synchronize_rcu() between
rcu_replace_pointer() and the frees. The per-object synchronize_net()
calls also gave a grace period after each earlier channel's
napi_disable_locked().

The synchronize_net() in mlx5e_close_channels_post_sync() runs after the
queues are already freed, so it only covers the mlx5e_channel and
mlx5e_ptp structs.

The other paths call mlx5e_deactivate_priv_channels() and then
mlx5e_close_channels(), so they still get one grace period after
napi_disable_locked(). Is merging the two into a single wait safe for
mlx5e_close_locked()?

>  
>  	return 0;
>  }

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261011133212.807979-1-tariqt%40nvidia.com
