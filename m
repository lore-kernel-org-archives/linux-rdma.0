Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E8850128C;
	Mon, 21 Sep 2026 18:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790016549; cv=none; b=lAap/ZfUkkBMQNSzu8RpyW7rNJ8HLF2J7ZDJ56SFm4n93e92EkjPlRNGKFJLnVUBIfGQ9Skbc0IKAdHvC/fZSKNjg9NGcq0bv/J8iMB2lm6x6Eg6YGo8Hn/MzXsP5FwAyyVUQR9zhSA37fNX89UtdPHGvvKSki70OTTeokBbbew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790016549; c=relaxed/simple;
	bh=9g+raEIjDrdIjdADEBfym8NPZbGRRHaZ7c1Tjl6o9Dc=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gPF/Jzj45X783Ncy/IJXhm7Imm+J0eRBTotwpF5/FB6imJ/kLrMasbnJmW04qDG4/fWKQXnDjFtoFih3G7MeMz0q7BMOzOFMqpbwdhh5QQk6Oss3b8O32wXmje9dvKOzZWLWsEdwtjLbz3uAr2b+fV7dmIwvb2Sxx/5PTOC76y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VrVRe56y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VrVRe56y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8B41F00898;
	Mon, 21 Sep 2026 18:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790016548;
	bh=S0eF2K1L3HtfjB5qnb2HrSxRozRcj0NZGVI63FxDRxw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=VrVRe56y/S4vLCSx0nsAqGFqQEoRfB9sUfUIEMrpfQstygUrVV+zwrrKHxKAbL4eb
	 259INSagX0OrCw5n0lIFcbmSnPgBPYHusplyI5UvNg2bhnYZKvS4fcEtwag9BidcF+
	 sTkfvZr6S1SaEkwbDCqeXDvMYkXF3Y4VUNRttlqgzjZ3RNgBYfs5bjNO79ggEjpoHt
	 e993Cu0kdqyI2m+bNozAMFLy94owTD9lSVJDDWsqnTD5eCXp+DJDVitE2Z8H00UCD0
	 JA5IrgaR9BU/160GE6WaP/1la0E3rKpLeyqoSTeUCwHkhXjbi+y+5Zk/ZyDLCMGgET
	 eZslNPzt/LrFw==
Subject: Re: [PATCH net 3/7] net/mlx5e: tc: Tie esw & accel blocking refs to
 the flow's lifetime
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 sd@queasysnail.net, borisp@nvidia.com, cjubran@nvidia.com, cratiu@nvidia.com,
 daniel.zahka@gmail.com, dtatulea@nvidia.com, ehakim@nvidia.com,
 gal@nvidia.com, jianbol@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, liorna@nvidia.com,
 mbloch@nvidia.com, parav@nvidia.com, raeds@nvidia.com, rrameshbabu@nvidia.com,
 roid@nvidia.com, saeedm@nvidia.com, steffen.klassert@secunet.com
Date: Mon, 21 Sep 2026 18:49:05 +0000
Message-ID: <179001654595.2160803.16115000237972239535@kernel.org>
In-Reply-To: <20260917175433.4090878-4-tariqt@nvidia.com>
References: <20260917175433.4090878-4-tariqt@nvidia.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 (1) · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] `_mlx5e_tc_del_flow()` (en_tc.c:5396-5403, the
  `rhashtable_free_and_destroy()` callback used by…

Pre-existing issues:
- [Medium] The TC/IPsec mutual-exclusion counters `mdev->num_block_tc` /
  `mdev->num_block_ipsec` are plain `u64` fields…

--

net/mlx5e: tc: Tie esw & accel blocking refs to the flow's lifetime

This moves the eswitch user reference and the IPsec-blocking reference
acquisition from mlx5e_configure_flower() into mlx5e_alloc_flow(), and moves
the matching release from mlx5e_delete_flower() into mlx5e_tc_del_flow() so
bulk flow destruction also releases them. A couple of questions below about
the new release site.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index b290beb4369ad..44fc421e7b8c1 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c

[ ... ]

> @@ -2158,13 +2162,16 @@ static void mlx5e_tc_del_fdb_peers_flow(struct mlx5e_tc_flow *flow)
>  static void mlx5e_tc_del_flow(struct mlx5e_priv *priv,
>  			      struct mlx5e_tc_flow *flow)
>  {
> +	struct net_device *filter_dev = flow->attr->parse_attr->filter_dev;
> +	bool peer = flow_flag_test(flow, PEER);
> +
>  	if (mlx5e_is_eswitch_flow(flow)) {
>  		struct mlx5_devcom_comp_dev *devcom = flow->priv->mdev->priv.eswitch->devcom;
>  
> -		if (flow_flag_test(flow, PEER) ||
> +		if (peer ||
>  		    !mlx5_devcom_for_each_peer_begin(devcom)) {
>  			mlx5e_tc_del_fdb_flow(priv, flow);
> -			return;
> +			goto out;
>  		}
>  
>  		mlx5e_tc_del_fdb_peers_flow(flow);
> @@ -2173,6 +2180,11 @@ static void mlx5e_tc_del_fdb_peers_flow(struct mlx5e_tc_flow *flow)
>  	} else {
>  		mlx5e_tc_del_nic_flow(priv, flow);
>  	}
> +out:
> +	if (!peer) {
> +		mlx5e_tc_unblock_ipsec_offload(filter_dev, flow->priv);
> +		mlx5_esw_put(flow->priv->mdev);
> +	}
>  }

[Severity: High]
Can this new release pair run twice for the same flow?

The bulk cleanup callback used by mlx5e_tc_nic_cleanup() and
mlx5e_tc_ht_cleanup() ignores flow->refcnt entirely:

drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:_mlx5e_tc_del_flow() {
	struct mlx5e_tc_flow *flow = ptr;
	struct mlx5e_priv *priv = flow->priv;

	mlx5e_tc_del_flow(priv, flow);
	kfree(flow);
}

If another context is holding a reference taken with mlx5e_flow_get() when
rhashtable_free_and_destroy() runs this callback, its later
mlx5e_flow_put() calls mlx5e_tc_del_flow() a second time on the already
freed flow, so mlx5e_tc_unblock_ipsec_offload() and mlx5_esw_put() execute
twice for one acquisition.

Does that underflow mdev->num_block_ipsec (leaving IPsec packet offload
rejected with -EBUSY until reload), and does the extra mlx5_esw_put()
consume an esw->user_count belonging to a different, still-live flow,
re-opening the mode-change-versus-live-rules window that 7dc84de98bab
closes?

The window looks structurally open during teardown. mlx5e_cleanup_rep_tx()
destroys the flow hash before the reference-holding contexts are quiesced:

drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:mlx5e_cleanup_rep_tx() {
	mlx5e_tc_ht_cleanup(&rpriv->tc_ht);

	if (rpriv->rep->vport == MLX5_VPORT_UPLINK)
		mlx5e_cleanup_uplink_rep_tx(rpriv);

	mlx5e_rep_neigh_cleanup(rpriv);
}

The netevent notifier unregister, flush_workqueue(priv->wq) and
cancel_delayed_work_sync(&rpriv->neigh_update.neigh_stats_work) all happen
inside mlx5e_rep_neigh_cleanup(), i.e. after the hash is gone, and the FIB
notifier is unregistered even later via mlx5e_cleanup_uplink_rep_tx() ->
mlx5e_tc_tun_cleanup(). Both of those workers drop their flow references
outside any lock that the cleanup path takes:

drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:mlx5e_tc_fib_event_work() {
	mutex_unlock(&esw->offloads.encap_tbl_lock);
	rtnl_unlock();

	mlx5e_put_flow_list(priv, &flow_list);
}

mlx5e_tc_update_neigh_used_value() does the same after unlocking
encap_tbl_lock, and mlx5e_rep_neigh_stats_work() is queued on fc_stats->wq
rather than priv->wq, so the earlier flush_workqueue(priv->wq) in
mlx5e_detach_netdev() does not cover it.

Would it be safer for _mlx5e_tc_del_flow() to go through mlx5e_flow_put()
(or for the reservations to be tied to the tc_ht-owned reference), and for
the neigh/FIB work to be quiesced before the flow table is destroyed?

[ ... ]

> @@ -4497,11 +4510,23 @@ mlx5e_alloc_flow(struct mlx5e_priv *priv, int attr_size,
>  	init_completion(&flow->init_done);
>  	init_completion(&flow->del_hw_done);
>  
> +	parse_attr->filter_dev = filter_dev;
> +	attr->parse_attr = parse_attr;
> +	/* Non-peer flows own the reservations until final destruction. */
> +	if (!flow_flag_test(flow, PEER)) {
> +		err = mlx5e_tc_block_ipsec_offload(filter_dev, priv);
> +		if (err)
> +			goto err_free_attr;
> +		mlx5_esw_get(priv->mdev);
> +	}
> +

[Severity: Medium]
This isn't a bug introduced by this patch, but it does widen the set of
unsynchronized contexts, so it seems worth asking: what serializes the
TC/IPsec exclusion counters now?

At this commit num_block_tc and num_block_ipsec are plain u64 fields in
struct mlx5_core_dev, and mlx5e_tc_block_ipsec_offload() does a
check-then-increment with no lock of its own:

	if (mdev->num_block_tc)
		return -EBUSY;

	mdev->num_block_ipsec++;

On this path the only thing held is the eswitch mode_lock read side taken by
mlx5_esw_hold() in mlx5e_configure_flower(), which does not exclude a
concurrent TC add on another netdev of the same mdev. The decrement side is
now reached from mlx5e_tc_del_flow() with no eswitch lock at all, including
from bulk cleanup and from mlx5e_tc_fib_event_work() /
mlx5e_tc_update_neigh_used_value() after they drop rtnl and encap_tbl_lock.

The peer side in mlx5e_ipsec_block_tc_offload() reads num_block_ipsec and
increments num_block_tc under mlx5_esw_lock(), and only when an eswitch
exists.

Can a lost update here leave num_block_ipsec permanently non-zero (IPsec
offload stuck at -EBUSY) or prematurely zero (IPsec offload accepted while
TC rules exist), i.e. break the invariant of c8e350e62fc5 in either
direction? On 32-bit the u64 read-modify-write can also tear.

A later patch in the series, "net/mlx5e: Serialize TC and IPsec offload
exclusion counters", moves both counters into mdev->offload_block and wraps
every check, increment and decrement in a dedicated mutex. Would it make
sense to order that patch before this one, since this one adds new
unlocked decrement contexts?

>  	*__flow = flow;
>  	*__parse_attr = parse_attr;
>  
>  	return 0;
>  
> +err_free_attr:
> +	kfree(attr);
>  err_free:
>  	kfree(flow);
>  	kvfree(parse_attr);

[ ... ]

> @@ -4865,12 +4888,6 @@ int mlx5e_configure_flower(struct net_device *dev, struct mlx5e_priv *priv,
>  	if (!mlx5_esw_hold(priv->mdev))
>  		return -EBUSY;
>  
> -	err = mlx5e_tc_block_ipsec_offload(dev, priv);
> -	if (err)
> -		goto esw_release;
> -
> -	mlx5_esw_get(priv->mdev);
> -
>  	rcu_read_lock();
>  	flow = rhashtable_lookup(tc_ht, &f->cookie, tc_ht_params);
>  	if (flow) {

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260917175433.4090878-1-tariqt%40nvidia.com
