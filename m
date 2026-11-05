Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793898330;
	b=iFHB5A1PA8UvKjHsIRS92+9zOiINJdNzJvHeZmer0ncQ4xaeW/Qdw5G/7A2dkdXVhVWA
	 ZxXt/bAQ4Nw4HRKNGHtXJtKlQdxYObVV6xbV/rDrm22HP01ylfOc/KP6db9da4EjCmwr+
	 l0wussRYXZiCqaHcyCYTIENf9sYJRKOEWPveK6KAwOwqF1DpRz8EdykFgIZHs0WpL+2x3
	 O9zsZxzUS3edqUiNmGQg22wvFIjAj9gvIYihigM1Z8iJ1teRhxbeBKTohxHy8Hb40+lqc
	 hHFmjFCYVCq74MDQELkyU8ryddNbcDLYRFP+KHc8m1y6Irq38aFMrH1rZAgCZJfspbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793898330;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=dt+bS/VdQDFXRnSUlgwag2EWurUxCShd4OV+Ezmnvzo=;
	b=xKVJ26Xrf9hCirTdK81uWrzOKTYcRBUEVfRnKRcQR6BKlfpl38AzRjcOEtrcpo0dzudq
	 W9MnnBWWs7dYMqTsVRyG/SjJNMCQWYP47Rdsm/XF9NKPNJ1zbMnyPPF+fDj3O6PW85+EI
	 4zv17V55R5JzEbodH2J7+4ebHRcWvpeIJJWqYQfPccZlnOLFfEDheLYaf1YBiQAMtKb2v
	 6xnhMgZnw/e7FDzvYmV1K0EPeV68ax/zj5Z19AN7ay+jecB9LBldoj1CymgC3TfmBoLE4
	 6CDb0l9avIo8+AMXaqFOrqmgYDa1pS5woofR2cEqTO48tiEyMb8HB5zY+LVYM48pKoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WM+qS0yH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6618606A329;
	Thu,  5 Nov 2026 17:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WM+qS0yH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B731F000C1;
	Thu,  5 Nov 2026 17:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793898329;
	bh=dt+bS/VdQDFXRnSUlgwag2EWurUxCShd4OV+Ezmnvzo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=WM+qS0yHv+48Q7hye6rHq3MFiDy2DoTqYvlIiFYvue1b/KpZc/R7As+Zo7TrwNwXG
	 TCbkGZRZrIbe/vH0EwXdI3Jv1835GYgSpKCJjezm8Q3Sa46mENULDc1JdBH5kTLrWg
	 mwcyUCqzHR6UigI9qB3nCV7BGfDmoASd1vMlje+mZB8G5q0zNfDWvTNcpOJlrKhygf
	 8MFZPWbp06utKEUo4ZpmkVQXAT9p5b8CM/lkuOuPpgCGYf+CG8XahwjNF0TXGuBPo/
	 pp5N6yFPvIOak44ud+Mfq1rJGjPtID9yDvko0efo8oJpKZ4YkpdS8zAt28zvq5zGpB
	 HQgPJPrcjKtdQ==
Subject:
 Re: [PATCH net] net/mlx5e: Fix queue stats access to queues without stats
From: netdev-bot+sashiko@kernel.org
To: leitao@debian.org
Cc: saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, joe@dama.to, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com, stable@vger.kernel.org
Date: Thu, 05 Nov 2026 17:05:28 +0000
Message-ID: <179389832803.994134.11688655413292808723@kernel.org>
In-Reply-To: <20261104-mlx5e-qstats-null-v1-1-a6a003245cec@debian.org>
References: <20261104-mlx5e-qstats-null-v1-1-a6a003245cec@debian.org>
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] When HTB leaves are configured and the netdev is brought down,
  the device-wide qstats lose all HTB TX counters.

--

net/mlx5e: Fix queue stats access to queues without stats

This commit fixes NULL pointer dereferences in the mlx5e per-queue
netdev-genl stats callbacks. The core calls them for every queue below
real_num_{rx,tx}_queues, and some of those queues have no stats behind
them. The RX callback now returns early for queues at or above stats_nch,
and the TX callback returns early when txq2sq_stats[i] is NULL.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index c3c2c5720c6f3..72bca10c579df 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c

[ ... ]

> @@ -5521,6 +5521,9 @@ static void mlx5e_get_queue_stats_tx(struct net_device *dev, int i,
>  	 * inactive sqs.
>  	 */
>  	sq_stats = priv->txq2sq_stats[i];
> +	if (!sq_stats)
> +		return;
> +

[Severity: Medium]
With HTB offload leaves configured, do the HTB TX counters drop out of
the device-wide qstats totals while the netdev is down?

The early return depends on the comment above it, which says
get_base_stats "takes care of inactive sqs". For HTB SQs that does not
seem to hold.

On ifdown, mlx5e_deactivate_channel()->mlx5e_qos_deactivate_queues()
clears the entry for every HTB txq:

drivers/net/ethernet/mellanox/mlx5/core/en/qos.c:mlx5e_qos_deactivate_queues() {
    ...
		c->priv->txq2sq[txq_ix] = NULL;
		c->priv->txq2sq_stats[txq_ix] = NULL;
    ...
}

real_num_tx_queues still includes those txqs, because
mlx5e_update_tx_netdev_queues() sets it to nch * ntc +
mlx5e_htb_cur_leaf_nodes(priv->htb) whether or not the channels are
open. So netdev_nl_stats_by_netdev() still calls
mlx5e_get_queue_stats_tx() for those indices, and with this change it
now returns without reporting anything.

mlx5e_get_base_stats() only walks channel_stats[]->sq[tc] and
ptp_stats.sq[tc]:

	for (i = 0; i < nch; i++) {
		struct mlx5e_channel_stats *channel_stats = priv->channel_stats[i];
		...

It never reads priv->htb_qos_sq_stats[], which is where the persistent
HTB counters live. So tx packets, bytes, hw-gso-packets, hw-gso-bytes,
csum-none, stop and wake for HTB queues disappear from the total on
ifdown and come back on ifup.

That looks like it would make device qstats go backwards on ifdown,
which tools/testing/selftests/drivers/net/stats.py check_down() tests
for:

    ksft_ge(qstat2[k], qstat[k], comment=f"{k} went backwards on device down")

The qstats totals would also stop matching the SW/rtnl totals, since
mlx5e_stats_grp_sw_update_stats_qos() still adds every
htb_qos_sq_stats[i].

Should mlx5e_get_base_stats() add priv->htb_qos_sq_stats[] for HTB
queues whose txq2sq_stats entry is NULL? If not, could the comment
above be corrected to document this gap?

>  	stats->packets = sq_stats->packets;
>  	stats->bytes = sq_stats->bytes;
>

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261104-mlx5e-qstats-null-v1-1-a6a003245cec%40debian.org
