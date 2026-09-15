Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5413CEBA7;
	Tue, 15 Sep 2026 01:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789437091; cv=none; b=LfGgG7+H4xO651MIxi5uz/QrUQK8eGUx5ImCBmfP23FIo0YU4ja6WOxEEsAqXhRA4ySE3Yg6D33i+IPfnFkhe1pMJMzpE21b9VpBPnBC3VmaUZS4PNS5c/058W7l70ozv3dMijM0CzHiILWBnX8Gt4xvyMVjhKwNaG5F8CXDDWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789437091; c=relaxed/simple;
	bh=6XCLumPsIXQ/BULMGaecKqPQOW025FYUVFfWnI0Qn+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GvMGj3UTcii168+NOQcbcWeFxW3W8T3/dYkGvisxmfI7bogmPefd+HqFOLyRNJXbWjhSoQlQhY2htkmWGqciPrtIfICiDcOhFeus7WqlFNWLHZrHarje8R4UCDk+ntcaJAAXC+u8K3wuDntn8dS6FqP7wFy1qv5PSLR/n/kVkG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KsTyS5PD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KsTyS5PD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A2301F000FF;
	Tue, 15 Sep 2026 01:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789437088;
	bh=qAr+28TuufFKWB0DyivQh4D5ccnl8xbwK4LXHENZXpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KsTyS5PDnMqxntjK51+xnZbu42i6jAGjcP6J7uw3n/mB+/WDn6A8F+L98jFVEBgvE
	 aKFk8GHJ2UIOnVYsDc6nL6TOroOzYpxpWd/Gw8E4Beiibj2FiwQ3HUgY9gzowR/Ao2
	 ULUw1G5mYxxADGYELSNs8im91EwliAswf2msEA10t7eSKeyiAfPFkYs6ZwZ223IOLV
	 1bGaP6iKxnHMm7p2gyjMeqplpXNd+QYwzVX/qvuxli7Z3+l8BU3/RW+Iela6CmPrXJ
	 fjplnQ8dnIA2GgoB2OSSAFG8y9tKH5s32or+4HwOVvY7NAqA5ThNie5e34nO3AsrNg
	 +LfnuR3Uuff8g==
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
Subject: Re: [PATCH net 5/5] {RDMA,net}/mlx5: notify RoCE LAG speed change via driver event
Date: Mon, 14 Sep 2026 18:51:27 -0700
Message-ID: <20260915015127.875561-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910102432.3845360-6-tariqt@nvidia.com>
References: <20260910102432.3845360-6-tariqt@nvidia.com>
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
{RDMA,net}/mlx5: notify RoCE LAG speed change via driver event

This adds a new MLX5_DRIVER_EVENT_LAG_SPEED_CHANGE driver event that the
LAG layer raises from mlx5_lag_update_agg_speed() when the cached
aggregate speed changes, and the mlx5_ib lag_event() handler turns it
into an IB_EVENT_DEVICE_SPEED_CHANGE for the IB device.  A couple of
questions below about the emit condition and the commit message.

> In RoCE LAG we don't modify any max_tx_speed, so no
> IB_EVENT_DEVICE_SPEED_CHANGE is ever fired.

[Severity: Medium]
Is this description of the existing behaviour accurate?  handle_port_change()
in drivers/infiniband/hw/mlx5/main.c already dispatches this event, and it
does so before the Ethernet link layer early return:

	case MLX5_PORT_CHANGE_SUBTYPE_ACTIVE:
	case MLX5_PORT_CHANGE_SUBTYPE_DOWN:
	case MLX5_PORT_CHANGE_SUBTYPE_INITIALIZED:
		if (ibdev->ib_active) {
			struct ib_event speed_event = {};

			speed_event.device = &ibdev->ib_dev;
			speed_event.event = IB_EVENT_DEVICE_SPEED_CHANGE;
			ib_dispatch_event(&speed_event);
		}

		/* In RoCE, port up/down events are handled in
		 * mlx5_netdev_event().
		 */
		if (mlx5_ib_port_link_layer(&ibdev->ib_dev, port) ==
					    IB_LINK_LAYER_ETHERNET)
			return -EINVAL;

So for the master device of a RoCE LAG whose own physical port changes
state, the event is fired today.

The gap this patch appears to close is narrower: aggregate changes driven by
a port EQE that only lands on a peer mdev whose IB device was removed by
mlx5_lag_remove_devices(), and bonding state changes (tracker tx_enabled,
v2p remap) that update the cache asynchronously from the port EQE, where a
consumer querying on the existing event can still read the old aggregate.

Since the patch carries a Fixes: tag and is a stable candidate, would it be
worth rewording this to describe the case that is actually uncovered instead
of saying no such event is ever fired?

> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index 6ab7f945e712c..bd54af47eda73 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -3693,6 +3693,16 @@ static int lag_event(struct notifier_block *nb, unsigned long event, void *data)
>  			rdma_roce_rescan_port(ibdev, portnum + 1);
>  		}
>  		break;
> +	case MLX5_DRIVER_EVENT_LAG_SPEED_CHANGE: {
> +		struct ib_event speed_event = {};
> +
> +		if (!dev->ib_active)
> +			break;
> +		speed_event.device = ibdev;
> +		speed_event.event = IB_EVENT_DEVICE_SPEED_CHANGE;
> +		ib_dispatch_event(&speed_event);
> +		break;
> +	}
>  	default:
>  		return NOTIFY_DONE;
>  	}

[ ... ]

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> index fd91becd6848f..5e70ca3b09ba9 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> @@ -1503,8 +1503,24 @@ static int mlx5_lag_get_devices_max_speed(struct mlx5_lag *ldev, u32 *max_speed)
>  	return 0;
>  }
>  
> +void mlx5_lag_notify_speed_change(struct mlx5_lag *ldev)
> +{
> +	struct lag_func *pf;
> +	int idx;
> +
> +	idx = mlx5_lag_get_dev_index_by_seq(ldev, MLX5_LAG_P1);
> +	if (idx < 0)
> +		return;
> +	pf = mlx5_lag_pf(ldev, idx);
> +	if (!pf)
> +		return;
> +	blocking_notifier_call_chain(&pf->dev->priv.lag_nh,
> +				     MLX5_DRIVER_EVENT_LAG_SPEED_CHANGE, NULL);
> +}
> +
>  void mlx5_lag_update_agg_speed(struct mlx5_lag *ldev)
>  {
> +	u32 old_speed;
>  	u32 speed;
>  
>  	lockdep_assert_held(&ldev->lock);
> @@ -1516,7 +1532,11 @@ void mlx5_lag_update_agg_speed(struct mlx5_lag *ldev)
>  	if (!speed && mlx5_lag_get_devices_max_speed(ldev, &speed))
>  		return;
>  
> +	old_speed = ldev->agg_speed_mbps;
>  	ldev->agg_speed_mbps = speed;
> +
> +	if (mlx5_lag_is_roce_lag(ldev) && speed != old_speed)
> +		mlx5_lag_notify_speed_change(ldev);
>  }

[Severity: Medium]
Should the emit be gated on mlx5_lag_is_roce_lag() here?  The same cached
value that was just updated is also what the IB layer reports for the
switchdev uplink representor, in mlx5_ib_query_port_speed_rep():

	if (rep->vport == MLX5_VPORT_UPLINK) {
		if (mlx5_lag_is_sriov(mdev))
			return mlx5_ib_query_port_speed_from_bond(dev,
								  port_num,
								  speed);

mlx5_lag_is_roce_lag() is a "no SR-IOV and legacy eswitch" predicate:

	mlx5_ldev_for_each(i, 0, ldev) {
		pf = mlx5_lag_pf(ldev, i);
		roce_lag = roce_lag && !mlx5_sriov_is_enabled(pf->dev);
	}
	...
		roce_lag = roce_lag && is_mdev_legacy_mode(pf->dev);

so in exactly the SR-IOV/shared-FDB LAG configuration where the uplink
representor reader is used, the gate is always false and no
IB_EVENT_DEVICE_SPEED_CHANGE is delivered even though the value exported
through QUERY_PORT_SPEED changed.

The reasoning given in the commit message applies to that reader too, since
mlx5_lag_modify_device_vports_speed() skips the uplink vport:

		if (vport->vport == MLX5_VPORT_UPLINK)
			continue;

The path I have in mind is: both PFs in switchdev mode and bonded, LAG comes
up in MLX5_LAG_MODE_SRIOV, then the peer PF link goes down and the bond work
runs mlx5_modify_lag() -> mlx5_lag_set_vports_agg_speed() ->
mlx5_lag_update_agg_speed(), which stores a different agg_speed_mbps with no
notification, while the peer's physical port EQE never reaches this IB
device's handle_port_change().

Separately, mlx5_lag_notify_speed_change() only calls the MLX5_LAG_P1 device's
priv.lag_nh, but each IB device registers on its own mdev's chain:

	dev->lag_events.notifier_call = lag_event;
	blocking_notifier_chain_register(&dev->mdev->priv.lag_nh,
					 &dev->lag_events);

In SR-IOV LAG the slave IB devices are not removed, so would the second PF's
IB device be reachable at all here even if the gate were relaxed?

[ ... ]
