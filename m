Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795717651;
	b=l5FY5GyE7BeVpPz6+/9wSkqwUBqg7eAbwuTMpE9shA5TxPruURCyrQ0vOQy7lNJwQx5N
	 DRKMrGRkh4TPjtsJNWiHNhTa/pEML+q3OcER77GgOyZuS6ayidzs0m/ZrflB55PccpL+p
	 vVQE0Z1BVetGJOzjnW1/h3/RKkNEZhl8fF1tnzNW+wwIWsVwNGbsepHavw3LTQY5eLlxg
	 RxaiAFAOTNnqSeQQYGSf4CWkwcWAuDPcf8oCaOHtt5DzY1b52uP6W4un/E4tu0taKwH0y
	 ToFi+HxEP9GqfAyXuaueLnHXQ3ekxFGMkld2EXc/I+HR/A/rbXy1nofJnobJZo9eIsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795717651;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=UP+g+jLUJt1VJnbL+dTM9FJbop57Dq2KJ57hkYZxwNA=;
	b=SvH/tyTMOWlaHjG7bN66M/rhGa0TTBV65d5LOVgVAwcspY4QWyTGtOLJHngdGdAN6BZg
	 UcsCChTRpG7JZAoUZKpjpK9WyKAjAin2M1xszVho2M476tlKyPzUM3vVgRzBdiKpt2FGe
	 hHUUFv8s9MF6+vZYwlpxMZFC1SRwUrL+MNjvfILOylJ+I5jE9y/RUm3MNht9qWbiE58ik
	 lcAZ3uzAiLLKsO4GRh1Wtr7B0/12kliAWeR8AhLTNbom9/hmeSNR23gpCSiJJj3FIcE8J
	 hjvGGN1JxIWtBkiDByveMHy62uzYQImrP0am4EGp+ZVzTr5QC8AB13Zbb0EVB7S9r3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aJHbRUc1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B42606A31C;
	Thu, 26 Nov 2026 18:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aJHbRUc1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830871F000C6;
	Thu, 26 Nov 2026 18:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795717651;
	bh=UP+g+jLUJt1VJnbL+dTM9FJbop57Dq2KJ57hkYZxwNA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=aJHbRUc1oFRZ3O/QHV55ga7bEgqjd8xKAbrAnC4eOTpQW3bWZEySr3kd+KURBDG+C
	 aBrQTmJDGvczyIfi9avJ1nje3IpwXIMn7Jsh7PmRrZRoDKg+ilufWb5zTtx/uvdKII
	 PYlDPSYrYgLR/g99EtRLvJQdMz0FKOJKqaCGEiSKwLPY9ayfbqrHgeif9RAhc9EUvG
	 USTL9dVjUdgB/b2DF8MrgMzYVAXRESR0o5sHf0qQP4kdB+xctQAl+WzRu9roHTn+ok
	 WgX0zXKzsD5J7IZCl/Ax42aJDqI6k4rvPCVqb+zK7lZPGCurSj82QdZQiFBKaocTBH
	 HAxVg2oZlEDbQ==
Subject:
 Re: [PATCH net] net/mlx5e: guard child PKEY channel stats lookup in rx path
From: netdev-bot+sashiko@kernel.org
To: eaujames@ddn.com
Cc: tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org, dtatulea@nvidia.com,
 mbloch@nvidia.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 feliu@nvidia.com, davem@davemloft.net, guillaume.courrier@cea.fr,
 kuba@kernel.org
Date: Thu, 26 Nov 2026 18:27:30 +0000
Message-ID: <179571765003.3135.3532444751948893709@kernel.org>
In-Reply-To: <awcn1-LpcFgzRKgq@eaujamesFR0130>
References: <awcn1-LpcFgzRKgq@eaujamesFR0130>
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

- [Medium] When the child PKEY priv has no channel_stats entry for the
  parent RQ index, the new fallback in mlx5i_complete_rx_cqe()…

--

net/mlx5e: guard child PKEY channel stats lookup in rx path

This adds a helper, mlx5e_channel_stats_get(), that checks the channel
index against stats_nch. mlx5i_complete_rx_cqe() now uses it to look up
the child PKEY priv's channel_stats[]. If the child has no entry for the
parent's rq->ix, the stats go to the parent's rq->stats instead.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> index 1586cb2404c01..5f2347672cf33 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c

[ ... ]

> @@ -2552,7 +2553,8 @@ static inline void mlx5i_complete_rx_cqe(struct mlx5e_rq *rq,
>  	}
>  
>  	priv = mlx5i_epriv(netdev);
> -	stats = &priv->channel_stats[rq->ix]->rq;
> +	channel_stats = mlx5e_channel_stats_get(priv, rq->ix);
> +	stats = likely(channel_stats) ? &channel_stats->rq : rq->stats;

[Severity: Medium]

Does this fallback count child PKEY traffic on the parent netdev?

For a parent RQ, rq->stats points into the parent priv:

mlx5e_init_rxq_rq() {
    ...
	rq->stats        = &c->priv->channel_stats[c->ix]->rq;
    ...
}

When the lookup returns NULL, the csum_complete/csum_none updates and the
packets/bytes updates at the end of mlx5i_complete_rx_cqe() all land on
the parent. The skb itself is still delivered to the child:

	skb->dev = netdev;

	stats->packets++;
	stats->bytes += cqe_bcnt;

mlx5i_grp_sw_update_stats() only sums a netdev's own
channel_stats[0..stats_nch). So the parent's rx_packets/rx_bytes would be
too high, and the child's would be missing these packets.

For these indexes, isn't this the same misattribution that b5e23931c45a
("net/mlx5e: IPoIB, Fix child PKEY interface stats on rx path") fixed?

Could this also last beyond the window in mlx5i_pkey_open() between
mlx5_fs_add_rx_underlay_qpn() and mlx5e_open_channels()?

The child's channel count defaults to:

mlx5e_build_nic_params() {
    ...
	params->num_channels = min_t(unsigned int, MLX5E_MAX_NUM_CHANNELS / 2,
				     priv->max_nch);
    ...
}

mlx5i_pkey_ethtool_ops has no set_channels, so the child can't change
this value.

The parent can be raised above 128 channels with ethtool -L as long as no
child exists yet, because mlx5i_set_channels() only refuses when:

	if (ipriv->num_sub_interfaces > 0) {

On hosts where max_nch is above 128, a child could then be created after
the parent was raised. Every child packet that RSS steers to a parent RQ
with rq->ix >= the child's stats_nch would then be counted on the parent
for good, not just during the open race.

The commit message says the fallback "adds no new data race", but it
doesn't mention that the per-netdev RX counters become wrong. Should the
fallback avoid charging the parent's rq->stats? If the current behaviour
is intended, could the commit message describe it?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/awcn1-LpcFgzRKgq%40eaujamesFR0130
