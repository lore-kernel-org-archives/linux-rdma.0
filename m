Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794509407;
	b=V4jkB/u6Rr2UMMmRlKIoN7oCu/gZWBwlsgkaHQNwXy11n3MqkOcvhmIfKiR1mJMmrm6e
	 gWI9DgL0ipTHJXFP/zB8aeZm+Bay6zWCUmd6j/wbYAAiEdA3eFJNPoEP/0mAOWKS9vQVn
	 LAG9+DKdWy8Of6d6ckTgQ7+whp5bra6umFAEov0emlvee2cPSteFZ/oDyaaThZSx0t7Eh
	 8RiyXBnHRZYwG6ggHlSZrzKkTidCen/5XCGbuM1BPPnUhuwo+TktSp5RoMBu1rYaAuFxb
	 dMWRWQqJsIuN1EaGvR4xBnuzk+Bjd8EzKeuqRMf6GTqoe9VIj4hdH9x9iondlR/yfWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794509407;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=uPqB6/0clUPwkTK+X5/I5kQkFm8UpzxKuRZOpXIFmTY=;
	b=dCW+AYS6GgZ+nye7GrYHSKvEt4O+sdUrODklOn8kmFWYSa5M7oFIAiwAajqoKXk15c4J
	 n68oLkQn/s/fcPVVTLUFUgbcT+7LAO5lD77kOEMf0QJNVe0FT/glagGA0huzvANOk2LvN
	 xQhdIYFiMgogtst82POAkCv7y+qyjzv4nsNaEALPDwt3ii4SshgA2Yc6NlNgAmtUwcGUB
	 gYTdTJPVsGuupx8+w99904gVKYwNsSu9p0FC1iW0ap2zF/vZeCjzBaWCxxkb6GTLpKUV5
	 ImYL7YAkyhOovRpW03zS+04UsyOwZbuII84KLvvJd2xXSjBwjjpeTrKyqWzCotvOY8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="c2eQP+/O";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD147606A321;
	Thu, 12 Nov 2026 18:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c2eQP+/O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 069D51F000C4;
	Thu, 12 Nov 2026 18:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794509407;
	bh=uPqB6/0clUPwkTK+X5/I5kQkFm8UpzxKuRZOpXIFmTY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=c2eQP+/OmBtccN6lFP3HYFxFG8agGWrDI1ZXY/qzbQbBLl9kz0DtpxOocyCBeQh/1
	 P/GJX5SY2nNJT4ZjDvY7qfUJOKzOnJEtsmCPA0PNiZ8DY/kvJ0WuFEHcet0S5vEkLZ
	 p94CGqnBzPefm6Xkw2QIA2aXbo77Y+eyyqSr/ikhqeI4OdxK30UzH6kC1dynETqKWr
	 cyG1PQpeMpAJ67J2cjI8+TjpsgcIajdVA1myeYV3IdZbbkblQe5LZfore+ergk6LBG
	 Kqfod2wBo2GGDO1uErPTdY4/hDbA/JE4xTiW4TO4JS4C7rWT7Ta+tPR51DCSdkibnC
	 q6m8EjZlYY8LQ==
Subject: Re: [PATCH net-next V2 1/2] net/mlx5e: Batch NAPI RCU grace periods
 on channel close
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, ast@kernel.org,
 bpf@vger.kernel.org, cjubran@nvidia.com, cratiu@nvidia.com,
 daniel@iogearbox.net, dtatulea@nvidia.com, gal@nvidia.com, hawk@kernel.org,
 john.fastabend@gmail.com, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, lirongqing@baidu.com, mbloch@nvidia.com,
 richardcochran@gmail.com, saeedm@nvidia.com, shshitrit@nvidia.com,
 sdf@fomichev.me
Date: Thu, 12 Nov 2026 18:50:05 +0000
Message-ID: <179450940555.2199510.18034823087861989713@kernel.org>
In-Reply-To: <20261110185005.2932568-2-tariqt@nvidia.com>
References: <20261110185005.2932568-2-tariqt@nvidia.com>
X-sashiko-severity: High
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

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 2 · Medium: 0 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] PTP SQ recovery loses the RCU/NAPI grace period that used to
  separate the PTP napi_disable from freeing the PTP CQs, which can…
- [High] net/mlx5e: missing grace period after page_pool_destroy() in
  channel close
- [Low] The patch adds an unmentioned change in XSK teardown state
  tracking and several copies of teardown sequences that will have to be…

--

net/mlx5e: Batch NAPI RCU grace periods on channel close

This patch splits mlx5e channel deactivate and close into pre_sync and
post_sync phases, so one synchronize_net() covers all channels instead
of one per queue. NAPI instances are unlinked with
__netif_napi_del_locked(), and a single grace period runs before the
channels are freed. Single-queue paths keep their per-object
synchronize_net() calls.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index c3c2c5720c6f3..73b504ba8c8c6 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c

[ ... ]

> @@ -2936,35 +2993,62 @@ static void mlx5e_activate_channel(struct mlx5e_channel *c)

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
> +
> +	if (c->xdp)
> +		mlx5e_close_xdpsq_pre_sync(&c->rq_xdpsq);
>  
> +	if (c->xdpsq)
> +		mlx5e_close_xdpsq_pre_sync(c->xdpsq);
> +}
> +
> +static void mlx5e_close_channel_post_sync(struct mlx5e_channel *c)
> +{
> +	if (c->xskrq.xsk_pool)
> +		mlx5e_close_xsk_post_sync(c);
> +	mlx5e_close_queues_post_sync(c);
> +	mlx5e_qos_close_queues_post_sync(c);
> +}

[Severity: Low]
This isn't a functional bug, but the XSK teardown decision here now uses
c->xskrq.xsk_pool instead of MLX5E_CHANNEL_STATE_XSK. That is because
mlx5e_close_channel_pre_sync() clears the state bit before post_sync
runs.

For the new check to work, the error path in mlx5e_open_xsk() in
en/xsk/setup.c now does:

	c->xskrq.xsk_pool = NULL;
	c->xsksq.xsk_pool = NULL;

The commit message mentions neither change. Could it explain that
xsk_pool is now the liveness flag for XSK teardown?

The patch also adds several copies of existing teardown sequences:

  - mlx5e_close_queues_post_sync() is a near line-by-line copy of
    mlx5e_close_queues(). The original is still used by the
    err_close_queues path in mlx5e_open_channel().

  - mlx5e_close_channels_post_sync() open-codes mlx5e_ptp_close() as
    mlx5e_ptp_close_queues() plus kvfree(). mlx5e_ptp_close() is still
    used by the error handling in mlx5e_open_channels() and by the PTP
    recovery in en/reporter_tx.c.

  - mlx5e_close_locked() open-codes the same sequence as
    mlx5e_deactivate_priv_channels() followed by
    mlx5e_close_channels(), with the same two grace periods.

If a resource is later added to only one copy, either the batched close
path or the error/recovery path will skip its cleanup.

Could the single-object variants be written as pre_sync, then
synchronize_net(), then post_sync? And could mlx5e_close_locked() keep
calling the existing wrappers?

[ ... ]

> @@ -3060,32 +3144,67 @@ static int mlx5e_wait_channels_min_rx_wqes(struct mlx5e_channels *chs)
>  	return err ? -ETIMEDOUT : 0;
>  }
>  
> -static void mlx5e_deactivate_channels(struct mlx5e_channels *chs)
> +static void mlx5e_deactivate_channels_pre_sync(struct mlx5e_channels *chs)
>  {
>  	int i;
>  
>  	if (chs->ptp)
> -		mlx5e_ptp_deactivate_channel(chs->ptp);
> +		mlx5e_ptp_deactivate_channel_pre_sync(chs->ptp);
>  
>  	for (i = 0; i < chs->num; i++)
> -		mlx5e_deactivate_channel(chs->c[i]);
> +		mlx5e_deactivate_channel_pre_sync(chs->c[i]);
>  }
>  
> -void mlx5e_close_channels(struct mlx5e_channels *chs)
> +static void mlx5e_deactivate_channels_post_sync(struct mlx5e_channels *chs)
> +{
> +	int i;
> +
> +	if (chs->ptp)
> +		mlx5e_ptp_deactivate_channel_post_sync(chs->ptp);
> +
> +	for (i = 0; i < chs->num; i++)
> +		mlx5e_deactivate_channel_post_sync(chs->c[i]);
> +}

[Severity: High]
Does freeing the channels here need another grace period after the
page pools are destroyed?

mlx5e_alloc_rq() creates rq->page_pool with pp_params.napi set to
rq->cq.napi. That is &c->napi for regular channels and &ptp->napi for
PTP, and both are embedded in the structs freed here.

When an in-flight skb backed by that pool is freed in softirq on
another CPU, page_pool_napi_local() does READ_ONCE(pool->p.napi) and
then reads napi->list_owner without any lock.

pool->p.napi is only cleared in page_pool_disable_direct_recycling().
That runs from page_pool_destroy(), reached from mlx5e_close_rq()
through mlx5e_free_rq().

Before this patch, mlx5e_close_channel() ran mlx5e_close_queues()
first and only then called netif_napi_del_locked(). Its
synchronize_net() covered any softirq that had loaded the old
pool->p.napi before kvfree(c) ran.

In the batched path, the only grace period runs between
mlx5e_close_channels_pre_sync() and mlx5e_close_channels_post_sync().
At that point pool->p.napi still points at the embedded napi.

post_sync then calls mlx5e_ptp_close_queues() and
mlx5e_close_channel_post_sync(), which clear pool->p.napi. It then
immediately calls kvfree() on chs->ptp and chs->c[i].

page_pool_scrub() only calls synchronize_net() when
dma_dev_need_sync() is true. So on DMA-coherent platforms nothing
waits here.

A softirq that read pool->p.napi just before it was cleared can then
read list_owner from freed memory. If the stale value matches the
current CPU, it would also take the direct recycling path into a pool
that is being torn down.

This affects mlx5e_close_locked() and every mlx5e_close_channels()
caller, for example ip link set down or a channel count change. The
single-channel mlx5e_close_channel() still does
netif_napi_del_locked() after post_sync, so it looks unaffected.

Would it work to destroy all the queues in post_sync, issue a second
synchronize_net(), and only then kvfree() the channels and PTP? That
keeps the cost at a fixed number of grace periods. Or is the
page_pool core meant to provide this guarantee, and I am missing it?

[Severity: High]
Is the PTP SQ recovery path still safe after this change?

mlx5e_tx_reporter_ptpsq_unhealthy_recover() in en/reporter_tx.c does:

	mlx5e_deactivate_priv_channels(priv);

	mlx5e_ptp_close(chs->ptp);

Before this patch, mlx5e_deactivate_channels() ran
mlx5e_ptp_deactivate_channel() first, which ends in
napi_disable_locked(). It then ran mlx5e_deactivate_channel() for each
channel. Those calls did several synchronize_net() calls through
mlx5e_deactivate_rq(), mlx5e_deactivate_icosq() and
mlx5e_deactivate_txqsq(). So a grace period always followed the PTP
napi_disable_locked().

Now the single synchronize_net() in mlx5e_deactivate_priv_channels()
runs before post_sync. mlx5e_ptp_deactivate_channel_post_sync() calls
napi_disable_locked(), and nothing waits after it.

mlx5e_ptp_close() then frees the queues before netif_napi_del_locked():

	mlx5e_ptp_close_queues(c);
	netif_napi_del_locked(&c->napi);

	kvfree(c);

The call chain mlx5e_ptp_close_queues()->mlx5e_close_cq()->
mlx5e_free_cq()->mlx5_wq_destroy() frees the CQ buffer, and frees the
doorbell record through mlx5_db_free().

Meanwhile, mlx5e_ptp_napi_poll() keeps running under rcu_read_lock()
after napi_complete_done():

	if (unlikely(!napi_complete_done(napi, work_done)))
		goto out;

	ch_stats->arm++;

	if (test_bit(MLX5E_PTP_STATE_TX, c->state)) {
		for (i = 0; i < c->num_tc; i++) {
			mlx5e_cq_arm(&c->ptpsq[i].txqsq.cq);
			mlx5e_cq_arm(&c->ptpsq[i].ts_cq);

napi_disable_locked() only waits for NAPIF_STATE_SCHED and
NAPIF_STATE_NPSVC to clear. Can it return while the poller is still in
this arm section?

If so, mlx5e_cq_arm() could write through mcq->arm_db into a doorbell
record that has been freed, or that mlx5_db_alloc() has already given
to another queue. It would also ring the UAR for a destroyed CQN.

The other callers of mlx5e_deactivate_priv_channels() look fine:
mlx5e_switch_priv_channels(), the ipoib paths and mlx5e_queue_start()
go on to mlx5e_close_channels() or mlx5e_close_channel(), and both call
synchronize_net() before freeing. So this seems limited to the PTP
recovery path.

The later patch in this series ("net/mlx5e: Batch ICOSQ trigger RCU
synchronization") does not touch this path either.

Would either of these close the window?

  - Add synchronize_net() before mlx5e_ptp_close() in the recovery
    path.

  - Have mlx5e_ptp_close() call __netif_napi_del_locked() and
    synchronize_net() before mlx5e_ptp_close_queues(), as the batched
    close path now does.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261110185005.2932568-1-tariqt%40nvidia.com
