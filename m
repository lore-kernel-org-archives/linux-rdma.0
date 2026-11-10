Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794311414;
	b=gUxXdT6iu9gIpXxdBlTD8qCNpjyYh9owQ23SZVUrXFksfy0iGhohM1Ctnk16Pzm+Ak5j
	 BlwA0x/M1A7OWupAuMhfNmCbs/DvoOjwMJnmSaF3shtTCOsY/Mr43pi4PA7V7CLFTOtgC
	 7L8rPjkJ/xTpo+OAlhSXRgF4HFcTfDGy7NjKHNBrSdyJ0SvgjTAhXw95zXxx6UwbWsLd4
	 SrYX+z9g6YtV0n9gwIK7LJtodXPNEKdUVKjuRAkbcfhncCln/KkrH9rAWbO0DxPI9bNfz
	 Y7Yp1gwMNeVdg0drQ1U8ubJoq59ng3AqraOQvTrzq4Mlqe4BVbiIztFxKa19NMVWZrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794311414;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=dGFbF9Anuu1/ALvQWjfraC6OLrqS/f8iZ6ssP3p8OFk=;
	b=H+2ipUSxw8So5//CD68ZBUVqZGSPHqfObcktC528Cm16kB+n2JdYTEZ7o1iF/QJepuJw
	 Jvko3vOMO4AZSjoaQBAYyW2iGg+kZ50+3wNIWs4vacklBolsmt6oUnRyZzQsMe9OPuYiC
	 rz/yX5iMzPfg9L5JmnwXtPJMcRJ9DEFECcPOyCjgK+QOOmtLLOhmm46MBkQWiRPKnYTe4
	 yldtSOtVNfv3ayPk6o3aqkG85oLloYwITDzue71Dg6n3ggHGLc0OInOJ3eacNwHm+sBHs
	 gzL2y8da9QVFTXBNsib21EWnvLxOcMzUEG/soIgvLK00dqvRPHaqhfhIwVyS3cLuE+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="JSi/J09O";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A91606B592
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 11:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JSi/J09O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F251F008A1;
	Tue, 10 Nov 2026 11:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794311413;
	bh=dGFbF9Anuu1/ALvQWjfraC6OLrqS/f8iZ6ssP3p8OFk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JSi/J09OGNa1hd2MrlgLM9MPwEUs7Cj7M1eh6fP5Eh5n+3IXccKifvK2PTZ31W3lX
	 SE8SncOE0kCFkOtXfZkMjdzCFJypt8yLdt4llTwoADR7YMzdpix2xRUpGJBrT4AY/7
	 ICfzYYMmOIyo8eVy9GzP3yPfiwd6YyMdwwOrmtSOBUaGy0dGfnB61gLmxcs4iEKIDt
	 k2eh6KgO4xR36kM4B3avDh1ipZhu4PoUrznD1bLkyJ5cyjiC14YLkis1CIAs1EW/HC
	 feaaT46M9cyfE2yrOwbvWjk0TNZX7wq8grFbkVhQCTBVtp3VVX7QBJkOKkmchAK1CU
	 xEJ4qp14H29dQ==
Message-ID: <sashiko-outbox-206956@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC net-next 4/7] net/mlx5e: Drain old TX SQs before
 activating new channels
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261109114734.2087878-5-tariqt@nvidia.com>
References: <20261109114734.2087878-1-tariqt@nvidia.com>
 <20261109114734.2087878-5-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 11:50:12 +0000
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
- [High] net/mlx5e: mlx5e_poll_tx_cqes() queues recover_work on
  deactivated SQs
--

commit fd69ab25361dddbeaf22971fdc4198ef4326e153
Author: Tariq Toukan <tariqt@nvidia.com>

net/mlx5e: Drain old TX SQs before activating new channels

This commit drains pending WQEs from deactivated TX SQs before activating
new channels when tis_tir_td_order is supported, falling back to closing
the old channels first if the drain times out.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_tx.c
> index bee6f0bf1eff5..eb20e3d14d461 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> @@ -780,10 +780,11 @@ void mlx5e_txqsq_wake(struct mlx5e_txqsq *sq)
>  	}
>  }
> =20
> -bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget)
> +/* Returns the number of polled CQEs. */
> +static int mlx5e_poll_tx_cqes(struct mlx5e_txqsq *sq, int napi_budget)
>  {
> +	struct mlx5e_cq *cq =3D &sq->cq;
>  	struct mlx5e_sq_stats *stats;
> -	struct mlx5e_txqsq *sq;
>  	struct mlx5_cqe64 *cqe;
>  	u32 dma_fifo_cc;
>  	u32 nbytes;
> @@ -791,14 +792,9 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_=
budget)
>  	u16 sqcc;
>  	int i;
> =20
> -	sq =3D container_of(cq, struct mlx5e_txqsq, cq);
> -
> -	if (unlikely(!test_bit(MLX5E_SQ_STATE_ENABLED, &sq->state)))
> -		return false;
> -
>  	cqe =3D mlx5_cqwq_get_cqe(&cq->wq);
>  	if (!cqe)
> -		return false;
> +		return 0;
> =20
>  	stats =3D sq->stats;
> =20
> @@ -891,11 +887,40 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi=
_budget)
> =20
>  	netdev_tx_completed_queue(sq->txq, npkts, nbytes);
> =20
> +	return i;
> +}
> +
> +bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget)
> +{
> +	struct mlx5e_txqsq *sq =3D container_of(cq, struct mlx5e_txqsq, cq);
> +	int i;
> +
> +	if (unlikely(!test_bit(MLX5E_SQ_STATE_ENABLED, &sq->state)))
> +		return false;
> +
> +	i =3D mlx5e_poll_tx_cqes(sq, napi_budget);
> +	if (!i)
> +		return false;
> +
>  	mlx5e_txqsq_wake(sq);
> =20
>  	return (i =3D=3D MLX5E_TX_CQ_POLL_BUDGET);
>  }
> =20
> +/* Reap the completions of a deactivated SQ, whose NAPI is disabled, wit=
hout
> + * waking its TX queue. Returns true once all its WQEs have completed.
> + */
> +bool mlx5e_txqsq_drain(struct mlx5e_txqsq *sq)
> +{
> +	int polled;
> +
> +	do {
> +		polled =3D mlx5e_poll_tx_cqes(sq, 0);
> +	} while (polled =3D=3D MLX5E_TX_CQ_POLL_BUDGET);
> +
> +	return sq->cc =3D=3D sq->pc;
> +}

[Severity: High]
Can mlx5e_txqsq_drain() -> mlx5e_poll_tx_cqes() queue sq->recover_work on
a deactivated SQ when it polls an MLX5_CQE_REQ_ERR completion?

Before this patch, mlx5e_poll_tx_cq() returned early when
MLX5E_SQ_STATE_ENABLED was clear.  Now mlx5e_poll_tx_cqes() runs on the
deactivated SQs in old_chs during mlx5e_switch_priv_channels(), after
mlx5e_open_channels() -> mlx5e_health_channels_update() has already reset
priv->tx_reporter->health_state to DEVLINK_HEALTH_REPORTER_STATE_HEALTHY.
If an old SQ completes a WQE or the deactivation NOP with
MLX5_CQE_REQ_ERR, mlx5e_poll_tx_cqes() queues sq->recover_work on
cq->workqueue:

drivers/net/ethernet/mellanox/mlx5/core/en_tx.c:mlx5e_poll_tx_cqes() {
	...
		if (unlikely(err_cqe)) {
			if (!test_and_set_bit(MLX5E_SQ_STATE_RECOVERING,
					      &sq->state)) {
				mlx5e_dump_error_cqe(&sq->cq, sq->sqn,
						     (struct mlx5_err_cqe *)cqe);
				mlx5_wq_cyc_wqe_dump(&sq->wq, ci, wi->num_wqebbs);
				queue_work(cq->workqueue, &sq->recover_work);
			}
			stats->cqe_err++;
		}
	...
}

When mlx5e_safe_reopen_channels() is invoked from devlink health recovery
under devl_lock(devlink), this causes an ABBA deadlock with
cancel_work_sync(&sq->recover_work) when old_chs is closed:

CPU0                              CPU1 (kworker)
----                              --------------
devl_lock(devlink)
  ...
  mlx5e_switch_priv_channels()
    mlx5e_drain_channels_txqsqs()
      mlx5e_poll_tx_cqes()
        queue_work(..., &sq->recover_work)
                                  mlx5e_tx_err_cqe_work()
                                    mlx5e_reporter_tx_err_cqe()
                                      devlink_health_report()
                                        devl_lock(devlink)
    mlx5e_close_channels(old_chs)
      ...
      mlx5e_close_txqsq()
        cancel_work_sync(&sq->recover_work)

 *** DEADLOCK ***

Even when devl_lock(devlink) is not held by the caller (such as during an
ethtool channel change), queuing sq->recover_work for an SQ in old_chs
runs devlink_health_report() after mlx5e_open_channels() marked
tx_reporter healthy, which either leaves tx_reporter in an error state for
an already-closed SQ or starts a recovery graceful period that suppresses
real error recovery on new_chs.

Should mlx5e_poll_tx_cqes() only queue sq->recover_work when
MLX5E_SQ_STATE_ENABLED is set?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109114734.2087=
878-1-tariqt@nvidia.com?part=3D4
