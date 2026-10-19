Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5752D4A4828;
	Mon, 19 Oct 2026 09:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792400434; cv=none; b=jVn4YnG4qx52MybJVQ4eCUFX7UOFfqOaHxhcu095jX2spcf1z3fSUpGvQLpDPcN7XQQKxyr89ozAiKYfJOL8uet7a/10GMSMvzXWR4C/yTdIn8yyBP3iopbolnbAAOXMXH1r8BjgyqC3mZMAZchq3vonMn81ZGC18MBl4ItVDRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792400434; c=relaxed/simple;
	bh=BAwzcRi7vSkEAOcUWAZNU6P64l/jjXjj5WuPW4v82Mw=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IZibU26ApsyCgkfIwGRl73nYw+/FCcGmKGJCUia5yQ2QtruT1so5tH5BaD7Qx6Bh2alnNwL2SV8BCf76ZAF4QJcCDiq46N4RAPa8Pzk3FxIJsd0QUpkMSgG4l6yAwUgqdh3T6zTqrFcCvA8rdcOmQFbyLjWhLYOmblmZj5L8+oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XbF2sNAd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XbF2sNAd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190DE1F000C4;
	Mon, 19 Oct 2026 09:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792400432;
	bh=3hSYYZxfXUj4tub1+H+H+fSNPGf3qpxBoVbL6tLJEdA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=XbF2sNAdqr+c1OO5LrHqGA/JGS94z54W5+wyvYxuEfitleJKGbEzhIXg7w3cHW9yJ
	 8+vBXnwzz2OBn8h0Cl69pJ0PkMHfU7miZ6TkZP+1UzP/8+71jA4mEFafwFSdnQE+/0
	 3kTIekOGem/vZ9GsmwmQeS3yCY6fbEnGK7bsvq8znJnP0MYgD2nmxvrQ2C9t51PWDk
	 PJcJh9A5sIg+1okdfxjdnCD38va0sbny13hzT3dgmdI5BMOsMUDwTkUYjBjyRs6ZmG
	 M7izDwiyFpuC5Z9c0bDkhlfAPzdKf18nZgBJnursvCDCXqbzww1pP9D79rxJiMF+0v
	 Dwfc2EL7jsnaQ==
Subject: Re: [PATCH net] net/mlx5e: rep, Fix races between devcom PAIR event
 and uplink close
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, gal@nvidia.com,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 mbloch@nvidia.com, moshe@nvidia.com, roid@nvidia.com, saeedm@nvidia.com,
 shayd@nvidia.com
Date: Mon, 19 Oct 2026 09:00:31 +0000
Message-ID: <179240043161.3135.7551017781405209816@kernel.org>
In-Reply-To: <20261015085744.1109107-1-tariqt@nvidia.com>
References: <20261015085744.1109107-1-tariqt@nvidia.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 2 · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The fix is incomplete.
- [High] The patch adds a lockless load and dereference of esw->devcom to
  every rep channel deactivation.

--

net/mlx5e: rep, Fix races between devcom PAIR event and uplink close

This commit wraps mlx5e_sqs2vport_stop() in mlx5e_remove_sqs_fwd_rules()
with mlx5_devcom_for_each_peer_begin()/end(). The goal is to serialize
rep_sq and sq_peer teardown against the devcom ESW_OFFLOADS PAIR/UNPAIR
event handler, which follows the pattern already used on the add side.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> index 88a170e40bd9..7211faaffd8d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> @@ -629,8 +629,12 @@ mlx5e_remove_sqs_fwd_rules(struct mlx5e_priv *priv)
>  	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
>  	struct mlx5e_rep_priv *rpriv = priv->ppriv;
>  	struct mlx5_eswitch_rep *rep = rpriv->rep;
> +	bool devcom_locked;
>  
> +	devcom_locked = mlx5_devcom_for_each_peer_begin(esw->devcom);

[Severity: High]
Before this patch, the stop path never touched esw->devcom. Now every rep
channel deactivation loads and dereferences it with no lock held, and does
so before the esw->mode check in mlx5e_sqs2vport_stop(). Can esw->devcom
be freed while this runs?

esw_offloads_disable() cleans up devcom before it unloads the reps:

	mlx5_esw_offloads_devcom_cleanup(esw);
	mlx5_eswitch_disable_pf_vf_vports(esw);
	mlx5_esw_offloads_rep_unload(esw, MLX5_VPORT_UPLINK);

mlx5_esw_offloads_devcom_cleanup() frees the devcom before it clears the
pointer:

	mlx5_devcom_unregister_component(esw->devcom);
	xa_destroy(&esw->paired);
	xa_destroy(&esw->fdb_table.offloads.peer_miss_rules);
	esw->devcom = NULL;

The free happens in mlx5_devcom_unregister_component()->
devcom_free_comp_dev(), which does kfree(devcom) and then
kref_put(&comp->ref, mlx5_devcom_comp_release). That also frees comp if
this was the last member.

One possible interleaving:

CPU0 (ip link set <rep> down)
mlx5e_rep_deactivate_channels()->mlx5e_remove_sqs_fwd_rules()
  mlx5_devcom_for_each_peer_begin(esw->devcom)   /* loads P */

CPU1 (devlink eswitch mode set legacy)
mlx5_devlink_eswitch_mode_set()->mlx5_eswitch_disable_locked()
  ->esw_offloads_disable()->mlx5_esw_offloads_devcom_cleanup()
    kfree(P), possibly frees P->comp as well

CPU0
  comp = devcom->comp;
  down_read(&comp->sem);

The ndo_stop path holds rtnl, the netdev lock and priv->state_lock. The
devlink mode set path holds the devlink lock and reps_lock. Nothing
appears to serialize the two.

Could this become a use-after-free on the comp_dev and on comp->sem? The
start path already has a similar unsynchronized use of esw->devcom, but
this patch adds a new one on the close path.

>  	mlx5e_sqs2vport_stop(esw, rep);
> +	if (devcom_locked)
> +		mlx5_devcom_for_each_peer_end(esw->devcom);
>  }

[Severity: High]
Does this fully close the race with the PAIR event?
mlx5_devcom_for_each_peer_begin() drops the semaphore and returns false
when the component is not ready:

lib/devcom.c:mlx5_devcom_for_each_peer_begin() {
	...
	down_read(&comp->sem);
	if (!READ_ONCE(comp->ready)) {
		up_read(&comp->sem);
		return false;
	}
	...
}

In that case mlx5e_sqs2vport_stop() still runs, with no devcom exclusion.
It calls list_del() and kfree() on each rep_sq, kfree() on each sq_peer,
and xa_destroy(&rep_sq->sq_peer).

The PAIR handler, though, does all of its rep work while ready is still
false. mlx5_esw_offloads_devcom_event() sets ready only at the end:

	err = mlx5_esw_offloads_pair(esw, peer_esw);
	...
	err = mlx5_esw_offloads_pair(peer_esw, esw);
	...
	mlx5_devcom_comp_set_ready(esw->devcom, true);

UNPAIR sets ready back to false once the last peer is gone. With two
ports, every first PAIR and every re-pair therefore runs with ready set
to false.

One possible interleaving:

CPU0 (ip link set <rep> down on eswitch A)
mlx5e_rep_close()->mlx5e_close_locked()->mlx5e_deactivate_priv_channels()
  ->mlx5e_rep_deactivate_channels()->mlx5e_remove_sqs_fwd_rules()
    mlx5_devcom_for_each_peer_begin() returns false
    mlx5e_sqs2vport_stop()
      list_del(&rep_sq->list);
      kfree(rep_sq);

CPU1 (peer eswitch B entering switchdev)
mlx5_devcom_send_event(PAIR), which takes comp->sem for write
  ->mlx5_esw_offloads_devcom_event()->mlx5_esw_offloads_pair()
    ->mlx5e_vport_rep_event_pair()
      list_for_each_entry(rep_sq, &rpriv->vport_sqs_list, list) {
          sq_peer = xa_load(&rep_sq->sq_peer, i);
          ...
          err = xa_insert(&rep_sq->sq_peer, i, sq_peer, GFP_KERNEL);

Can CPU1 then walk a freed rep_sq, or call xa_insert() on an xarray that
has already been destroyed?

If the insert lands between the xa_for_each() and the xa_destroy() in
mlx5e_sqs2vport_stop(), the sq_peer and its peer FDB send-to-vport rule
look like they would be leaked.

The commit message says:

  "The add side (mlx5e_sqs2vport_start) already guards the peer-rule work
  with mlx5_devcom_for_each_peer_begin(), i.e. the devcom read semaphore,
  which excludes the write-side event."

mlx5e_sqs2vport_start() uses the same ready-gated check:

	if (mlx5_devcom_comp_is_ready(esw->devcom) &&
	    mlx5_devcom_for_each_peer_begin(esw->devcom))
		devcom_locked = true;

As a result, its list_add() into rpriv->vport_sqs_list can also run while
a first-time PAIR is walking the list.

Would both the start and stop paths need exclusion that does not depend
on comp->ready? One option is to hold comp->sem for read whenever
esw->devcom is non-NULL, which would need a new devcom helper. Another is
a lock that the event handler also takes.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261015085744.1109107-1-tariqt%40nvidia.com
