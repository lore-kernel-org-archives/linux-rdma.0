Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12493B42FE;
	Sun,  6 Sep 2026 19:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788721246; cv=none; b=J75hbHDPfwShMC/S5VNqPRdOhGpJauT343fdWY2hbK1Jfn5xiZVYRH7+130H1ebNQf541ZGLZm7ugh3IL9kBmqClXZkUN4Dpt4NstT/r0x+rrHXvs7bIrRZFFp+SMH8ow1IDItUvrIehqazkCVrKD6IMXekbWU5QbhdaVzM0b4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788721246; c=relaxed/simple;
	bh=eZiV2g18eAGjzO/LLUTPp/72c+BuvitORBjdc3n/u8s=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=U1nQ1lOOC2pK8scGNbEBPCRDBaYlGr/lerdPrux34mvEP8PB2Ou3fPcfu5fcRALXqaHzPxxfx3+DEms35MHdWSn/MllOByjOpMmZFz1nRRM7PMoglekDkoXuSLOzL9cuvDRetWVhKqa2wVI+p3uFjol2Qt12CaAIyhgpdWpVrKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hzdYY/qW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hzdYY/qW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD221F00A3A;
	Sun,  6 Sep 2026 19:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788721244;
	bh=f6QaRcl8KphuJpnun+cYVXPrk2Qep1qZIcNAgvpEG+o=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=hzdYY/qWIbMcnIDFlVUx7d5emVW7AEpvHxITh7+5IccBYGnfSRxWa4VS5GJsfwNel
	 xaKaWNYIiQiOLscm7hNT+a3s7iiuezKpic+jt4om9+SDlAPRaFK94e/niYQ/GdHIVD
	 8Ya7PAqMhXQ7yCHYu+emnB4ZZRn0N0X1w9/hLc3Rq7V1c/1cZ9uD1bKiXjVA9/RGtM
	 Mwv9z3ELk837QJiaXsHtED31peAGWsp/G7hbV/xEx+nWPiWsLsnUhHM8EeEGLeLIsz
	 m0hCKDqXRThL6Etcqv9tR5QmLZkkOXnIusPRxQ+4uAA/OfOtVpW+aWFztnABDUxgjq
	 cuJdMXXAkt6Zg==
Subject: Re: [PATCH net] net/mlx5e: Keep HW timestamp stats monotonic across
 reconfiguration
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 cjubran@nvidia.com, dtatulea@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 rrameshbabu@nvidia.com, richardcochran@gmail.com, saeedm@nvidia.com,
 shshitrit@nvidia.com
Date: Sun, 06 Sep 2026 19:00:42 +0000
Message-ID: <178872124291.219967.5690857105577484083@kernel.org>
In-Reply-To: <20260902193731.3668958-1-tariqt@nvidia.com>
References: <20260902193731.3668958-1-tariqt@nvidia.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 1 (1) · Low: 0

- [Medium] mlx5e_stats_ts_get()
  (drivers/net/ethernet/mellanox/mlx5/core/en_stats.c:1199-1236)…

Pre-existing issues:
- [Medium] The mlx5 PTP CQ -> struct ethtool_ts_stats mapping retained
  (and re-indented) by this patch in mlx5e_stats_ts_get()…

--

net/mlx5e: Keep HW timestamp stats monotonic across reconfiguration

mlx5e_stats_ts_get() no longer picks between DMA and port timestamp
counters based on tx_ptp_opened, and instead always sums the DMA
timestamp counters from the persistent per-channel statistics, adding the
port timestamp counters once the PTP TX queues have been opened. The
state_lock is dropped since only persistent stats are read now.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
> index e7e6db7f6bf1..cd94bb44f6ab 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
> @@ -1199,50 +1199,39 @@ void mlx5e_stats_rmon_get(struct mlx5e_priv *priv,
>  void mlx5e_stats_ts_get(struct mlx5e_priv *priv,
>  			struct ethtool_ts_stats *ts_stats)
>  {
> -	int i, j;
> +	u16 nch = mlx5e_stats_nch_read(priv);
> +	int i, tc;
>  
> -	mutex_lock(&priv->state_lock);
> +	ts_stats->pkts = 0;
>  
> -	if (priv->tx_ptp_opened) {
> -		struct mlx5e_ptp *ptp = priv->channels.ptp;
> +	for (i = 0; i < nch; i++) {
> +		struct mlx5e_channel_stats *channel_stats =
> +			priv->channel_stats[i];
>  
> -		ts_stats->pkts = 0;
> +		for (tc = 0; tc < priv->max_opened_tc; tc++)
> +			ts_stats->pkts += channel_stats->sq[tc].timestamps;
> +	}

[Severity: Medium]
Does this loop miss the HTB/QoS send queue timestamp counters?

The DMA accumulation here only walks priv->channel_stats[i]->sq[tc], but
HTB offload SQs keep their statistics elsewhere, in
mlx5e_open_qos_sq():

drivers/net/ethernet/mellanox/mlx5/core/en/qos.c:mlx5e_open_qos_sq() {
	...
	err = mlx5e_open_txqsq(c, tisn, txq_ix, params, &param_sq, sq, 0, hw_id,
			       priv->htb_qos_sq_stats[node_qid]);
	...
}

Those SQs are opened without a ptpsq (sq->ptpsq is only assigned in
mlx5e_ptp_open_txqsq()), so every hardware timestamped skb completing on
an HTB class queue takes the DMA branch:

drivers/net/ethernet/mellanox/mlx5/core/en_tx.c:mlx5e_consume_skb() {
	...
		} else {
			skb_tstamp_tx(skb, &hwts);
			sq->stats->timestamps++;
		}
	...
}

incrementing priv->htb_qos_sq_stats[qid]->timestamps, which the new code
never reads. With HTB TX offload configured, are those packets then
permanently absent from ETHTOOL_A_TS_STAT_PKTS, even though the driver
still reports the same events privately as qos_txN_timestamps via
MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, timestamps)?

If so, should the new comment claiming DMA timestamp counters are
accumulated also mention this queue class, or should the loop fold in
priv->htb_qos_sq_stats[] as well?

> +
> +	/* Accumulate DMA and port timestamp counters so values stay monotonic
> +	 * across channel teardown and mode switches.
> +	 */
> +	if (priv->tx_ptp_opened) {
> +		/* Err and Lost stats are only relevant for port timestamping,
> +		 * as the DMA layer will always successfully timestamp packets.
> +		 */
>  		ts_stats->err = 0;
>  		ts_stats->lost = 0;
>  
> -		if (!ptp)
> -			goto out;
> -
> -		/* Aggregate stats across all TCs */
> -		for (i = 0; i < ptp->num_tc; i++) {
> +		for (tc = 0; tc < priv->max_opened_tc; tc++) {
>  			struct mlx5e_ptp_cq_stats *stats =
> -				ptp->ptpsq[i].cq_stats;
> +				&priv->ptp_stats.cq[tc];
>  
>  			ts_stats->pkts += stats->cqe;
>  			ts_stats->err += stats->abort + stats->err_cqe +
> -				stats->late_cqe;
> +					stats->late_cqe;
>  			ts_stats->lost += stats->lost_cqe;
>  		}

[Severity: Medium]
This is a pre-existing mapping that this patch only re-indents, so it is
not introduced here, but can the same timestamp request end up counted in
pkts, lost and err at once?

The kernel-doc for struct ethtool_ts_stats in include/linux/ethtool.h
describes err as:

 * @err: Number of arbitrary timestamp generation error events that the
 *	hardware encountered, exclusive of @lost statistics.

In the driver, a request whose port CQE has not arrived within the
undelivered timeout bumps lost_cqe while the skb stays in the metadata
map:

drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c:mlx5e_ptpsq_mark_ts_cqes_undelivered() {
	...
		ptpsq->cq_stats->lost_cqe++;
	...
}

If that CQE arrives later, mlx5e_ptp_handle_ts_cqe() takes the
!nodes[metadata_id].inuse path and bumps late_cqe (mapped to err), and
for a non-error CQE also cqe (mapped to pkts).

Similarly, an aborted timestamp never reaches skb_tstamp_tx():

drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c:mlx5e_skb_cb_hwtstamp_tx() {
	...
		ptpsq->cq_stats->abort++;
		ptpsq->cq_stats->abort_abs_diff_ns += diff;
	...
		return;
}

yet cq_stats->cqe was already incremented for that CQE, so pkts counts a
packet whose timestamp was never delivered to the socket while err counts
it too.

Since this patch turns pkts into a permanent DMA plus port sum, would it
be worth documenting or correcting the overlap so userspace summing
pkts/lost/err does not exceed the number of timestamp requests?

>  	}
> -
> -out:
> -	mutex_unlock(&priv->state_lock);
>  }

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260902193731.3668958-1-tariqt%40nvidia.com
