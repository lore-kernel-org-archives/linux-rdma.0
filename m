Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793046730;
	b=2Ie01l9QfWlBj4F60kb5UmbllcYSjLTlTYYEoXHDk8fXWFPunfaK8mXZXck6Vrjv0y9P
	 mFNiqOGRvxN4WqGFrFE6nJaBJLgUdnxXCnhPiTBiaPpt8iJGzQbCCI/PpAQCSdlmYKoxU
	 ZyOnJzO8qa/znak4Vsn9jx+ktPncANUMHlcS1KDR9rPBwspLXQ9CloM2VYgmstqHZvhrN
	 WnDCnDcBYV2sZbfJ/xDlq/b3xfBxDnzQhv+/rOh/a5rFIPcAM7lVYfhLSkU72AQZXU7xX
	 IYcj7BW0322zMibZeD7G4ys7Wkuzmm4o7DHKZCVMSEdM5nKVU4VWiYJSjP5PGUDrmPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793046730;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=iJc4+QyiUpbP5bLPqs8ix+Tf2mWeWDixRtgU+vBWVdo=;
	b=K8apKK9BIWaKD3P4uORhfVZbWC3f0bQlTrmilgPi8+CKhlQyfEPnZGlRn15GhG6Hv+wS
	 cZrbmPMOG+fsoNVjpXjXudMwpqoSxB2XdeOAOpXcNnF13S6y2e70CAsi9d5eEU+hCE72H
	 qctdinjukD9BbgJFDIZZbLhbHvosQ40N/iSSnMclAKz+HjCtr8Z4t+lHIXF7UCNv37eqY
	 rYciGA5ah6V6eTvB+Q6j3y8OtitJ8pP4RYlCjlx3sHB3deL7rmkkNnrksoI2W1jLxGjUl
	 5saldVB+UgX89SRosRdQVH7SThPsYoVLtoHSlmkEL1JgJTgA6juAolJlvbp6IoNTwuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aZ3x7X7l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DC8606A31D;
	Mon, 26 Oct 2026 20:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aZ3x7X7l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C261F01825;
	Mon, 26 Oct 2026 20:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793046729;
	bh=iJc4+QyiUpbP5bLPqs8ix+Tf2mWeWDixRtgU+vBWVdo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=aZ3x7X7lPmzWi+0+la1FI2ySRw6j6DEWKtAMNpk1axiD+80W7IjyJFKABYyKgRTry
	 zBO0XZTNS2hLHBc87nndDQ3scy6/d+hnIL1tck7jK47+NPeoCS7TL1EAuz8aWZ/o00
	 ZLNR0f1fBLjqZ8GI0b0JE3UfbTGBbd5aBNy+FkVyBEtsDtDMmNKPUsTxVGd8iCzRga
	 i4u5FbXnu5tEzlzP8jNC/xcE/h7a79NhZF3piV98Dz0QDTDMuOzhmgkpH9cCMRVHZ8
	 ftcLrhH0m482X/wYy4xcWMNIWzK8ei4OXRC+pw51BhuNoMq6nYQqreRhVnOy7ucR+Y
	 8KQXIaMLvY0ZA==
Subject: Re: [PATCH net V2 1/4] {RDMA,net}/mlx5: cache and use TX-enabled
 aggregate speed for vports
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 bhelgaas@google.com, cjubran@nvidia.com, cratiu@nvidia.com,
 edwards@nvidia.com, gal@nvidia.com, jgg@ziepe.ca, kees@kernel.org,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
 linux-rdma@vger.kernel.org, msanalla@nvidia.com, mbloch@nvidia.com,
 ohartoov@nvidia.com, saeedm@nvidia.com, shayd@nvidia.com
Date: Mon, 26 Oct 2026 20:32:07 +0000
Message-ID: <179304672765.3134.1208806064407803696@kernel.org>
In-Reply-To: <20261022193053.3815866-2-tariqt@nvidia.com>
References: <20261022193053.3815866-2-tariqt@nvidia.com>
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

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 2 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The new ldev->agg_speed_mbps cache is invalidated on only one
  teardown path, and it is filled only after the IB device is exposed.
- [Medium] For regular (non-MPESW) RoCE/SRIOV LAG, the patch replaces the
  bond's ethtool-derived speed (tracker.bond_speed_mbps) with a sum of…
- [Low] In non-MPESW mode, mlx5_lag_get_devices_oper_speed() now reads
  the live ldev->tracker.netdev_state[pf_idx].tx_enabled/link_up for…

--

{RDMA,net}/mlx5: cache and use TX-enabled aggregate speed for vports

This patch caches the aggregate operational speed of the TX-enabled LAG
ports in ldev->agg_speed_mbps. VF/SF vport max_tx_speed is now programmed
from that cache instead of from the bond speed. The exported
mlx5_lag_query_bond_speed() is replaced by
mlx5_lag_query_aggregated_speed(), which the mlx5 IB driver uses for port
speed queries and which returns -ENODATA until a measurement succeeds.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> index 4e173b08cb37a..57755ceab8a75 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c

[ ... ]

> @@ -1452,15 +1453,21 @@ static int mlx5_lag_get_devices_oper_speed(struct mlx5_lag *ldev,
>  		pf_mdev = pf->dev;
>  		if (!pf_mdev)
>  			continue;
> -		ret = mlx5_query_vport_max_tx_speed(pf_mdev, opmod, 0, 0,
> -						    &speed, &state);
> -		if (ret) {
> -			mlx5_core_dbg(pf_mdev, "State query failed (err=%d)\n",
> -				      ret);
> -			return ret;
> -		}
> -		if (state != VPORT_STATE_UP)
> +		if (mpesw) {
> +			ret = mlx5_query_vport_max_tx_speed(pf_mdev, opmod, 0,
> +							    0, &speed, &state);
> +			if (ret) {
> +				mlx5_core_dbg(pf_mdev,
> +					      "State query failed (err=%d)\n",
> +					      ret);
> +				return ret;
> +			}
> +			if (state != VPORT_STATE_UP)
> +				continue;
> +		} else if (!ldev->tracker.netdev_state[pf_idx].tx_enabled ||
> +			   !ldev->tracker.netdev_state[pf_idx].link_up) {
>  			continue;
> +		}

[Severity: Low]

Can these live reads of ldev->tracker race with mlx5_lag_netdev_event()?
The notifier publishes the whole tracker while holding only RTNL:

	ldev->tracker = tracker;

This code runs from mlx5_do_bond_work() under ldev->lock and the devcom
lock, but without RTNL. The lockdep_assert_held(&ldev->lock) in
mlx5_lag_update_agg_speed() therefore does not exclude the writer.

Between the tx_enabled/link_up reads for different ports,
mlx5_port_oper_linkspeed() issues a PTYS command that sleeps. During an
active-backup failover:

bond work                              netdev notifier (RTNL)
port 0: tx_enabled, count it
mlx5_port_oper_linkspeed() sleeps
                                       ldev->tracker = tracker
                                       (port 0 off, port 1 on)
port 1: tx_enabled, count it

Would the aggregate then cover both ports, even though only one of them
was TX-enabled at any given moment? That value goes to RDMA and into the
VF/SF vport max_tx_speed, and it stays there until the requeued bond work
recomputes it.

mlx5_do_bond() already takes a snapshot with tracker = ldev->tracker for
activate/modify. Could the speed calculation use that same snapshot?

>  
>  		ret = mlx5_port_oper_linkspeed(pf_mdev, &speed);

[Severity: Medium]

For non-MPESW RoCE/SRIOV LAG, this replaces tracker.bond_speed_mbps,
which came from the netdevs' ethtool link speed, with a sum of
mlx5_port_oper_linkspeed() results. Does that lose the fallbacks the old
source had?

mlx5_port_oper_linkspeed() picks the PTYS encoding only from
mlx5_ptys_ext_supported(). When no known bit is set, it returns success
with a speed of 0:

	ext = mlx5_ptys_ext_supported(mdev);
	err = mlx5_port_query_eth_proto(mdev, 1, ext, &eproto);
	...
	for (i = 0; i < max_size; ++i)
		if (eproto.oper & MLX5E_PROT_MASK(i))
			oper_speed = max(oper_speed, table[i].speed);

	*speed = oper_speed;
	return 0;

The old source had two fallbacks:

- mlx5e_ethtool_get_link_ksettings() falls back to the legacy
  eth_proto_admin/eth_proto_oper when the extended admin field is zero.
- get_link_properties() falls back to 100 * data_rate_oper when the
  bitmap cannot be decoded.

The legacy admin case looks reachable through
mlx5e_ethtool_set_link_ksettings(). On ext-capable hardware with autoneg
enabled, advertising only legacy modes writes the legacy admin field.

In that configuration, would an up, TX-enabled member contribute 0 Mbps,
with the result cached as a successful measurement? RDMA would then
under-report the port speed. If the whole aggregate is 0, the VF/SF
vports would get the max-capability fallback instead of the operational
speed.

This assumes firmware reports oper only in the legacy field in that
configuration. That assumption comes from the ethtool code's handling,
not from a firmware specification.

>  		if (ret) {

[ ... ]

> @@ -1594,6 +1625,7 @@ void mlx5_lag_reset_vports_speed(struct mlx5_lag *ldev)
>  	int pf_idx;
>  	int ret;
>  
> +	mlx5_lag_reset_agg_speed(ldev);

[Severity: Medium]

Is this the only teardown path that invalidates agg_speed_mbps?
mlx5_lag_reset_vports_speed() is only called from the disable branch of
mlx5_do_bond():

	} else if (mlx5_lag_should_disable_lag(ldev, do_bond)) {
		mlx5_lag_reset_vports_speed(ldev);
		mlx5_disable_lag(ldev);
	}

Other teardown paths do not appear to reset the cache. One example is
mlx5_lag_disable_change(), reached on eswitch disable or mode change:

	if (__mlx5_lag_is_active(ldev)) {
		if (ldev->mode == MLX5_LAG_MODE_MPESW)
			mlx5_lag_disable_mpesw(ldev);
		else
			mlx5_disable_lag(ldev);
	}

The MPESW disable work also calls mlx5_lag_disable_mpesw(), and the
shared FDB path goes through
mlx5_lag_shared_fdb_destroy()->mlx5_deactivate_lag(). Neither path
touches agg_speed_mbps.

On activation, mlx5_do_bond() calls mlx5_activate_lag() and then
mlx5_lag_rescan_dev_locked(ldev, dev0, true) before
mlx5_lag_set_vports_agg_speed() fills the cache.
mlx5_lag_shared_fdb_create() also rescans and reloads the IB reps before
it refreshes the speed.

mlx5_lag_query_aggregated_speed() reads agg_speed_mbps without a lock,
and its IB caller only checks the LAG mode. Could a uverbs
QUERY_PORT_SPEED in that window return the previous LAG instance's
aggregate as valid data? On a first activation, it would get -ENODATA
instead.

This seems to contradict the commit message:

  "Until the aggregate has been measured, or after a failed measurement,
  mlx5_lag_query_aggregated_speed() returns -ENODATA."

It also contradicts the v2 changelog note about resetting the cache to
SPEED_UNKNOWN on teardown.

Later patches in the series do not appear to change this.
mlx5_lag_reset_agg_speed() is still reachable only through the disable
branch of mlx5_do_bond(). In "notify IB uplink on LAG aggregate speed
change", the stale value also feeds the speed != old_speed check.

>  	mlx5_ldev_for_each(pf_idx, 0, ldev) {

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261022193053.3815866-1-tariqt%40nvidia.com
