Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC3A280331;
	Thu, 24 Sep 2026 13:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790258072; cv=none; b=M4RdkfiPTnmMjvDEoA+tH7Gjn3UEhRjtVhuKZUiK7g5H9UxT/0NjJEDby7BGjpq9MEzavwyT5heIyFBWJL0Hdz2TwW7SEsXGHQ13JVXA8tFdZsWOKXOBoVi7AdDcBPFlrS3kH7ZiMic4Bp9oF4tNPvuJ7+IiLa0lrzQT97H+7/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790258072; c=relaxed/simple;
	bh=L+PpSiG84VaGXlSktp4v2Ha1dfreFC5SkjQ3fY0sM38=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DHCjWOrmz920n4jFuAoeC0xtR3BVPTgq8h8+7hJnQ7rmLSPRfuzQvIpMw45KlywrD7lWm7ZCNd5mxlmgVWl4k17kRoqxYthhfbQSymdQp34CbXIKYKK+V7LhQNL1UzrqS9n6RJSvLtJI/nAVaFyP6dQC2gyDZkHw9mFkqgvEwLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=niHnA08W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="niHnA08W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 151BD1F000FF;
	Thu, 24 Sep 2026 13:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790258070;
	bh=SM0mirBFNqZyzhYwhqOqLEyAVViA4n4Gk8C6G8Jb/dM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=niHnA08WwEkVe6sHPWH5k+sL96KCpVol1HieFXze+sNw9jV5DWckH+z+QY6K3ZMsZ
	 igCkTACaccBXEu1pLtr/NuGWXaqIOZFB079Asdv5chF175fgBoF6pKB6wn92hH9dSA
	 jJxjVo3yeB9Xm++ks74Xe8tWyTV3H1t555tObSf587JnjXr8cx1h+Q1JBr7TqSwMCR
	 MNoCmXw5LxPzSBBys6VSGHw4tqiRRTDxR7R5cAnWklZ6NfJnZTgy12FwY+5N99isZP
	 GZuI1s17ilWita+kY7MfPJUmhlHl6v5BnG/vfXdCoX21YcZd/tg2LtpR5NB4zLVpfW
	 yPekO3HLncBqA==
Subject: Re: [PATCH net] net/mlx5: Fix slab-out-of-bounds when handling team
 device events
From: netdev-bot+sashiko@kernel.org
To: avirdi@redhat.com
Cc: netdev@vger.kernel.org, saeedm@nvidia.com, leon@kernel.org,
 tariqt@nvidia.com, mbloch@nvidia.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 shayd@nvidia.com, ohartoov@nvidia.com, maorg@nvidia.com,
 linux-rdma@vger.kernel.org
Date: Thu, 24 Sep 2026 13:54:29 +0000
Message-ID: <179025806955.2160803.14946061126391357248@kernel.org>
In-Reply-To: <20260922135123.46205-1-avirdi@redhat.com>
References: <20260922135123.46205-1-avirdi@redhat.com>
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

Critical: 0 · High: 1 (1) · Medium: 0 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] Over-broad guard: replacing netif_is_lag_master() with
  netif_is_bond_master() at the very top of…
- [Low] Commit message inaccuracy: the message states that
  mlx5_handle_changeinfodata_event() suffers the same team_port-…

Pre-existing issues:
- [High] The identical bug class the patch claims to eliminate remains
  reachable in the mlx5e TC mirred offload path: get_fdb_out_dev()…

--

net/mlx5: Fix slab-out-of-bounds when handling team device events

This changes the two LAG notifier helpers in mlx5's lag.c to gate on
netif_is_bond_master() instead of netif_is_lag_master(), so that a team
master no longer reaches bond_slave_get_rcu()/bond_is_slave_inactive().
The reported symptom is a KASAN out-of-bounds read when a team_port is
interpreted as a struct slave.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> index dd14cdc378de0..2714d39ae7c24 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> @@ -1922,7 +1922,7 @@ static int mlx5_handle_changeupper_event(struct mlx5_lag *ldev,
>  	int changed = 0;
>  	int i, idx = -1;
>  
> -	if (!netif_is_lag_master(upper))
> +	if (!netif_is_bond_master(upper))
>  		return 0;

[Severity: High]
Does this early return do more than avoid the bonding-only calls?  The
only team-unsafe statements in mlx5_handle_changeupper_event() are further
down in the for_each_netdev_in_bond_rcu() loop:

	slave = bond_slave_get_rcu(ndev_tmp);
	if (slave)
		has_inactive |= bond_is_slave_inactive(slave);

Returning 0 at the top of the function also skips the computation of
tracker->tx_type, tracker->hash_type and tracker->is_bonded for any team
master.

Since mlx5_lag_netdev_event() only writes the tracker back and queues the
work when a handler returns non-zero:

	if (changed)
		mlx5_lag_update_tracker_speed(&tracker, ndev);

	ldev->tracker = tracker;

	if (changed)
		mlx5_queue_bond_work(ldev, 0);

and mlx5_do_bond() gates activation on the tracker:

	do_bond = tracker.is_bonded && mlx5_lag_check_prereq(ldev);

can is_bonded ever become true again for mlx5 ports aggregated by a team
master?  Team does advertise the TX types mlx5 accepts —
team_upper_dev_link() sets lag_upper_info.tx_type = team->mode->lag_tx_type,
with NETDEV_LAG_TX_TYPE_ACTIVEBACKUP in team_mode_activebackup and
NETDEV_LAG_TX_TYPE_HASH in team_mode_loadbalance — which are exactly the
two values the mode_supported test in this function allows.

Would gating only the bond_slave_get_rcu()/bond_is_slave_inactive() block
on netif_is_bond_master() remove the out-of-bounds read while keeping
team-based LAG tracking?

Related to this, does the driver's notifier state machine become
asymmetric?  mlx5_handle_changelowerstate_event() still admits team ports:

	if (!netif_is_lag_port(ndev))
		return 0;

and returns 1, so team NETDEV_CHANGELOWERSTATE events keep updating
tracker->netdev_state[] and queueing bond work while is_bonded can never be
set.  mlx5_lag_update_tracker_speed() also still resolves a team master as
the bond device:

	if (netif_is_lag_master(ndev))
		bond_dev = ndev;

and publishes its speed through mlx5_lag_query_bond_speed().

One more question on the changelog: with a Fixes: tag aimed at stable,
should the loss of hardware LAG offload for team-aggregated ports be
mentioned, since there is no extack or dmesg indication when the handler
bails out early?

>  
>  	if (info->linking)
> @@ -2029,7 +2029,7 @@ static int mlx5_handle_changeinfodata_event(struct mlx5_lag *ldev,
>  	bool has_inactive = 0;
>  	int idx;
>  
> -	if (!netif_is_lag_master(ndev))
> +	if (!netif_is_bond_master(ndev))
>  		return 0;

[Severity: Low]
The commit message says:

    The mlx5_handle_changeupper_event() and mlx5_handle_changeinfodata_event()
    functions assume the upper device is a bonding device and call bonding-
    specific
    APIs like bond_slave_get_rcu() and bond_is_slave_inactive().

Can mlx5_handle_changeinfodata_event() actually be entered with a team
master?  NETDEV_CHANGEINFODATA has a single emitter in the tree, in
bond_option_active_slave_set():

	call_netdevice_notifiers(NETDEV_CHANGEINFODATA, bond->dev);

drivers/net/team/ never emits it, so this hunk looks like hardening of an
unreachable path rather than a second fix.  Could the changelog be narrowed
to the mlx5_handle_changeupper_event() path, so stable backporters see the
real scope?

Also, the sentence above is wrapped mid-word ("bonding-\nspecific") in the
changelog.

>  
>  	rcu_read_lock();

[Severity: High]
This isn't a bug introduced by this patch, but the same pattern is still
present in the mlx5e TC mirred offload path, and it may be worth fixing in
the same series.  get_fdb_out_dev() in
drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c still uses the
generic check before a bonding-only accessor:

	} else if (netif_is_lag_master(out_dev)) {
		fdb_out_dev = bond_option_active_slave_get_rcu(netdev_priv(out_dev));

For a team master, netdev_priv() is a struct team, and
bond_option_active_slave_get_rcu() reads it as struct bonding:

include/net/bonding.h:bond_option_active_slave_get_rcu() {
	const struct slave *slave = rcu_dereference_rtnl(bond->curr_active_slave);

	return bond_uses_primary(bond) && slave ? slave->dev : NULL;
}

bond_uses_primary() reads BOND_MODE(bond) out of unrelated bytes of the team
private area, and bond->curr_active_slave aliases team->header_ops_cache
(struct team starts with pcpu_stats, it has no leading dev member).  If the
garbage mode value happens to be one of the primary modes, does this
dereference header_ops_cache as struct slave * and return slave->dev as a
bogus struct net_device *, which mlx5e_eswitch_rep() then dereferences?

The reachable caller is parse_mirred():

	out_dev = get_fdb_out_dev(uplink_dev, out_dev);
	if (!out_dev)
		return -ENODEV;

reached from tc_act_parse_mirred() when
netdev_port_same_parent_id(priv->netdev, out_dev) holds, which a team master
over mlx5 representors satisfies.  Should this site use
netif_is_bond_master() too, the way mpesw.c already does?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260922135123.46205-1-avirdi%40redhat.com
