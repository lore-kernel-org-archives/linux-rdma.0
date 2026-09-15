Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710DC3CBE80;
	Tue, 15 Sep 2026 01:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789437083; cv=none; b=EqaBuX2js0VrgnWOk+wc3CvGpF5FkHDjx4qL9Qkehcrhm1KK08QEvb7TjwwztjcbBM3EmThkKeepFUCmmAGQ3TQ/D7UloKQ2Pfp/SHuRNqxiPgnVOVupVp3ybb40oWNucu9JVdHIfWDMSleTHQ+OY/ac22ZwsjacdtPtsgU2RxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789437083; c=relaxed/simple;
	bh=sjgmOK6w17/KH2kxPH6JVtbA1azIzFqmqAhb8R5v7Gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M2OGPcNlbypkC7ZalzKDwR0UC2dSMRVGWx8UYKOGUZdhcNSykJKZ7BmznzR4yjYq3X6BLKBUSowj+x1W/w48OAbRAxu2Es4bKsHD0TbYlUJCZgeSS6rLJ7GTp5+dYiWVAwDoy4rqrwBhIKj04Dj7TDdIMo76gSSxEh24PUSzfgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UqjpvN1e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UqjpvN1e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C371F000FF;
	Tue, 15 Sep 2026 01:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789437082;
	bh=KTBWFawVxhrtvnBe2V2/Z5N9fz3d3cZrNyTFc5D8ydY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UqjpvN1eDzn+gZn6u1NT4OdN8hnLSQiyrojQilZtzVbwM6cfKU/0d0D3J6KN+5HwG
	 YtfpHCmo3hHrSD3AizJOefNwT8JzLK056+yjo5oHb2kgObpej+338y+/ZPMlBHasYq
	 2KJZEFTyCl5mUoVOubOYhcZDPKCQ/VfIgtp0VB0dZdfnGW0VhM///iHu5rC0XQNpP+
	 kkUHCWThDyrR4r4cl35ScME/6zNBvVqjT7fSYQtg5pZUxIIxGuCw8ircajjID/QR5e
	 2A+EfklBqZ54Sm9WKAYzdvL0cpTcYDtmCQqFZy1+3BAWPSsCIMHESHKwHzcz7Tq0ro
	 /4q8Q92bTF0Kw==
From: Jakub Kicinski <kuba@kernel.org>
To: tariqt@nvidia.com
Cc: Jakub Kicinski <kuba@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	edwards@nvidia.com,
	gal@nvidia.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	msanalla@nvidia.com,
	mbloch@nvidia.com,
	ohartoov@nvidia.com,
	saeedm@nvidia.com,
	shayd@nvidia.com
Subject: Re: [PATCH net 1/5] net/mlx5: Lag, split aggregate speed into oper and max helpers
Date: Mon, 14 Sep 2026 18:51:18 -0700
Message-ID: <20260915015118.875210-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910102432.3845360-2-tariqt@nvidia.com>
References: <20260910102432.3845360-2-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
---
net/mlx5: Lag, split aggregate speed into oper and max helpers

This splits the single mlx5_lag_sum_devices_speed() helper into
mlx5_lag_get_devices_oper_speed() and mlx5_lag_get_devices_max_speed().
The oper helper skips ports that are not forwarding traffic, while the max
helper takes the best single port for active-backup and sums the ports for
XOR, LACP and MPESW.

A few questions on the new helpers below.

> net/mlx5: Lag, split aggregate speed into oper and max helpers
>
> The oper function skips a port for two reasons:
> - the bonding driver set tx_enabled=false - LACP converging or
>   active-backup standby slave, where carrier may still be up but the
>   port is intentionally not forwarding traffic.
> - the link is down.

[Severity: Low]
The changelog lists two skip reasons, but the new oper helper also adds a
third, MPESW-only gate that queries the vNIC vport state per PF:

	if (mpesw) {
		if (mlx5_query_vport_state(pf_mdev, opmod, 0) !=
		    VPORT_STATE_UP)
			continue;
	}

Since the value returned by this helper ends up in every vport's
max_tx_speed, would it be worth spelling out the MPESW gate and its effect
on the programmed speed in the changelog too?

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> index c655f6e32e9b0..5aa9d5c98fe16 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> @@ -1412,16 +1412,20 @@ static bool mlx5_lag_should_disable_lag(struct mlx5_lag *ldev, bool do_bond)
>  }
>  
>  #ifdef CONFIG_MLX5_ESWITCH
> -static int
> -mlx5_lag_sum_devices_speed(struct mlx5_lag *ldev, u32 *sum_speed,
> -			   int (*get_speed)(struct mlx5_core_dev *, u32 *))
> +static int mlx5_lag_get_devices_oper_speed(struct mlx5_lag *ldev,
> +					   u32 *sum_speed)
>  {
>  	struct mlx5_core_dev *pf_mdev;
>  	struct lag_func *pf;
>  	int pf_idx;
> +	bool mpesw;
>  	u32 speed;
> +	u8 opmod;
>  	int ret;
>  
> +	mpesw = ldev->mode == MLX5_LAG_MODE_MPESW;
> +	opmod = MLX5_VPORT_STATE_OP_MOD_VNIC_VPORT;
> +
>  	*sum_speed = 0;
>  	mlx5_ldev_for_each(pf_idx, 0, ldev) {
>  		pf = mlx5_lag_pf(ldev, pf_idx);
> @@ -1430,13 +1434,20 @@ mlx5_lag_sum_devices_speed(struct mlx5_lag *ldev, u32 *sum_speed,
>  		pf_mdev = pf->dev;
>  		if (!pf_mdev)
>  			continue;
> +		if (mpesw) {
> +			if (mlx5_query_vport_state(pf_mdev, opmod, 0) !=
> +			    VPORT_STATE_UP)
> +				continue;
> +		}

[Severity: Medium]
Can a failed firmware query be mistaken for a down vport here?
mlx5_query_vport_state() in core/vport.c returns 0 on command failure:

	err = mlx5_cmd_exec_inout(mdev, query_vport_state, in, out);
	if (err)
		return 0;

	return MLX5_GET(query_vport_state_out, out, state);

and include/linux/mlx5/device.h has VPORT_STATE_DOWN = 0x0, so a timeout,
-EIO on a device in error state, or -EBUSY is indistinguishable from a real
"vport down" reply.

The PF is then silently dropped from the sum and the helper still returns 0,
unlike the mlx5_port_oper_linkspeed() failure a few lines below which aborts
the whole computation.

The under-computed value reaches the hardware through
mlx5_lag_set_vports_agg_speed() -> mlx5_lag_modify_device_vports_speed(),
which stores it in vport->agg_max_tx_speed and calls
mlx5_modify_vport_max_tx_speed() for every enabled vport, so with one
failing PF in a two-PF MPESW LAG the rate limit is roughly halved until the
next port change event. If every query fails the sum stays 0 and the
capability-max fallback below is used instead.

This path is reachable from ordinary events via
mlx5_lag_mpesw_port_change_event() -> mlx5_mpesw_speed_update_work() ->
mlx5_lag_set_vports_agg_speed(). Should the query failure be distinguished
from VPORT_STATE_DOWN and propagated like the linkspeed error?

> +		} else if (!ldev->tracker.netdev_state[pf_idx].tx_enabled ||
> +			   !ldev->tracker.netdev_state[pf_idx].link_up) {
> +			continue;
> +		}

[Severity: Low]
Is this else-if arm reachable at this point of the series? The only caller
in this commit is mlx5_lag_set_vports_agg_speed(), which calls the helper
exclusively under:

	if (ldev->mode == MLX5_LAG_MODE_MPESW) {
		if (mlx5_lag_get_devices_oper_speed(ldev, &speed))
			return;

so mpesw is always true inside the helper and the tx_enabled/link_up skip
described in the changelog has no effect yet. The later patch
"{RDMA,net}/mlx5: cache and use TX-enabled aggregate speed for vports"
introduces mlx5_lag_update_agg_speed(), which calls the oper helper for all
LAG modes and makes this branch live, so this is only an intra-series
ordering observation.

[Severity: Low]
This is a pre-existing issue, not introduced by this patch, but these reads
of ldev->tracker.netdev_state[pf_idx].tx_enabled/.link_up (and the
tracker.tx_type read in mlx5_lag_get_devices_max_speed() below) take only
ldev->lock, while the writers use different conventions:

mlx5_lag_netdev_event() republishes the whole struct from RTNL context with
neither ldev->lock nor lag_lock held:

	ldev->tracker = tracker;

	if (changed)
		mlx5_queue_bond_work(ldev, 0);

and mlx5_ldev_add_netdev()/mlx5_ldev_remove_netdev() write the same fields
under lag_lock. The same pattern already exists in the baseline, where
mlx5_do_bond() snapshots ldev->tracker under ldev->lock and
mlx5_infer_tx_enabled() consumes these fields to program the port mapping.

Any mixed snapshot here looks self-correcting because the event path requeues
the bond work, which recomputes the aggregate speed. Is it worth settling on
one lock for the tracker fields while this code is being reworked?

>  
> -		ret = get_speed(pf_mdev, &speed);
> +		ret = mlx5_port_oper_linkspeed(pf_mdev, &speed);
>  		if (ret) {
>  			mlx5_core_dbg(pf_mdev,
> -				      "Failed to get device speed using %ps. Device %s speed is not available (err=%d)\n",
> -				      get_speed, dev_name(pf_mdev->device),
> -				      ret);
> +				      "Failed to get device %s oper speed (err=%d)\n",
> +				      dev_name(pf_mdev->device), ret);
>  			return ret;
>  		}
>  
> @@ -1446,17 +1457,41 @@ mlx5_lag_sum_devices_speed(struct mlx5_lag *ldev, u32 *sum_speed,
>  	return 0;
>  }
>  
> -static int mlx5_lag_sum_devices_max_speed(struct mlx5_lag *ldev, u32 *max_speed)
> +static int mlx5_lag_get_devices_max_speed(struct mlx5_lag *ldev, u32 *max_speed)
>  {
> -	return mlx5_lag_sum_devices_speed(ldev, max_speed,
> -					  mlx5_port_max_linkspeed);
> -}
> +	struct mlx5_core_dev *pf_mdev;
> +	struct lag_func *pf;
> +	bool take_max;
> +	int pf_idx;
> +	u32 speed;
> +	int ret;

[ ... ]

> +		ret = mlx5_port_max_linkspeed(pf_mdev, &speed);
> +		if (ret) {
> +			mlx5_core_dbg(pf_mdev,
> +				      "Failed to get device %s max speed (err=%d)\n",
> +				      dev_name(pf_mdev->device), ret);
> +			return ret;
> +		}
> +
> +		*max_speed = take_max ?
> +			max(*max_speed, speed) : *max_speed + speed;
> +	}

[Severity: Low]
Both new helpers sum per-port Ethernet link speeds from
mlx5_port_max_linkspeed()/mlx5_port_oper_linkspeed(), which derive their
value purely from the PTYS protocol capabilities, with no bound from the
device's PCIe link bandwidth. The changelog says the max helper "represents
the maximum achievable speed", yet the summed value can exceed what the host
DMA path can sustain, and that value is programmed as the vport rate limit.

The follow-up patch "net/mlx5: Lag, limit aggregated TX speed by PCIe
bandwidth" adds the missing clamp in both helpers:

	pci_bw = mlx5_pcie_bandwidth(pf_mdev);
	if (pci_bw)
		speed = min(speed, pci_bw);

so this is closed inside the series; was there a reason for keeping the
clamp in a separate patch rather than adding it here?

>  
>  static void mlx5_lag_modify_device_vports_speed(struct mlx5_core_dev *mdev,
> @@ -1505,7 +1540,7 @@ void mlx5_lag_set_vports_agg_speed(struct mlx5_lag *ldev)
>  	int pf_idx;
>  
>  	if (ldev->mode == MLX5_LAG_MODE_MPESW) {
> -		if (mlx5_lag_sum_devices_oper_speed(ldev, &speed))
> +		if (mlx5_lag_get_devices_oper_speed(ldev, &speed))
>  			return;
>  	} else {
>  		speed = ldev->tracker.bond_speed_mbps;
> @@ -1514,7 +1549,7 @@ void mlx5_lag_set_vports_agg_speed(struct mlx5_lag *ldev)
>  	}
>  
>  	/* If speed is not set, use the sum of max speeds of all PFs */
> -	if (!speed && mlx5_lag_sum_devices_max_speed(ldev, &speed))
> +	if (!speed && mlx5_lag_get_devices_max_speed(ldev, &speed))
>  		return;

[Severity: Low]
Should this comment be updated? mlx5_lag_get_devices_max_speed() no longer
always sums, since:

	take_max = ldev->tracker.tx_type == NETDEV_LAG_TX_TYPE_ACTIVEBACKUP;
	...
	*max_speed = take_max ?
		max(*max_speed, speed) : *max_speed + speed;

For an active-backup bond in a non-MPESW mode the fallback returns the best
single port speed, not "the sum of max speeds of all PFs", and that is the
value programmed into vport max_tx_speed.

The comment also survives unchanged in the follow-up patch that moves this
code into mlx5_lag_update_agg_speed(), so nothing later in the series
corrects it.

>  
>  	speed = speed / MLX5_MAX_TX_SPEED_UNIT;
