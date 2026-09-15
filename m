Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30B13CF1E6;
	Tue, 15 Sep 2026 01:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789437087; cv=none; b=KH5FvDgz5j1WEjEy4tIhgKDamXmbWrEyFuqzQ+37pj9qVlivlBkdCd/nm1hmwI2SAOd1crZDmgRfuWoUGWnWYJBfQ33aVaauZy95bPYBbQnCxmVxq7z9ACHoBpBzimVpwBBkFBy4hbkcrG4EJBgC9zt9nPUVqI38vgKqRu2PHEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789437087; c=relaxed/simple;
	bh=jLEB+IYMyROss1LZkbnulhcdIBqowGQCEgVzrF0vVm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJOgSfFk/12zsLvVCETHfrTubrGlx3DTxtLe0sh0fgA1h5YXetYG3eOZJ/kUMjzqWAZNSCIXKVnPOF1podhbAszw2dQMozicfdSQLXl43P6tbo491pL2Bkx+9aG/uMzFiqH4D8wOUHHRMv2ZsDt+thIJOa2114bGTfmUy/tDYdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IjqLP4Nx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IjqLP4Nx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09891F000FF;
	Tue, 15 Sep 2026 01:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789437085;
	bh=F3mLRlCCYPKQXsFLJub7PNpRhEFFDNgBX/DoTLuQ+QY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IjqLP4NxTI7E0IQq4mENJYoPFaVrTmlRxcGsr+XvAJLIO9buw+BZh8Vd6Nlr/pUPB
	 ifwa6ui5B5QiVYiD8IbdMA5VbUqSwMJ9JluxK0P7P0TpquQfa9RO8ry3NZXc7j0ViJ
	 NNhOZGc6Nn+0EkDMv+dE+pXssWzBxlZYShkK/JT3gfcUXhMfU3tcnH/OJFpUk/HKJh
	 bCsnp+w/9DeEvHSLq4YS/MT57irdQzs2OiLdL2QLlpY9DMjCoabfnMoL9xBteZV5k/
	 UaIowUyeYkM/ag5GkqKiUVP4EVpz2uJX8VgazNTrMyrKRs+/3aT6bcpb5mTVQl9wkH
	 X/YhJrtobGnQQ==
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
Subject: Re: [PATCH net 3/5] {RDMA,net}/mlx5: cache and use TX-enabled aggregate speed for vports
Date: Mon, 14 Sep 2026 18:51:23 -0700
Message-ID: <20260915015123.875427-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910102432.3845360-4-tariqt@nvidia.com>
References: <20260910102432.3845360-4-tariqt@nvidia.com>
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
{RDMA,net}/mlx5: cache and use TX-enabled aggregate speed for vports

The patch adds a new ldev->agg_speed_mbps cache in struct mlx5_lag,
populated by the new mlx5_lag_update_agg_speed() and cleared by
mlx5_lag_reset_agg_speed(). mlx5_lag_set_vports_agg_speed() now programs
vports from that cache, and mlx5_ib switches from mlx5_lag_query_bond_speed()
to the new exported mlx5_lag_query_aggregated_speed().

A few questions below.

> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index 373ee1f42d4ad..6ab7f945e712c 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -1654,7 +1654,7 @@ static int mlx5_ib_query_port_speed_from_bond(struct mlx5_ib_dev *dev,
>  	u32 bond_speed;
>  	int err;
>  
> -	err = mlx5_lag_query_bond_speed(mdev, &bond_speed);
> +	err = mlx5_lag_query_aggregated_speed(mdev, &bond_speed);
>  	if (err)
>  		return err;

[Severity: Low]
Should the other in-tree consumer of the LAG aggregate speed be converted
too?  After this patch mlx5_ib_query_port_speed_from_bond() uses the new
cached aggregate, but mlx5_esw_qos_max_link_speed_get() in
drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c still uses the bond speed
this commit message describes as unsuitable:

	if (!mlx5_lag_is_active(mdev) ||
	    mlx5_lag_query_bond_speed(mdev, link_speed_max) < 0 ||
	    *link_speed_max == 0)
		goto skip_lag;

That value feeds mlx5_esw_qos_link_speed_verify(), so a devlink rate
request can be accepted against the PTYS-derived bond speed while
mlx5_lag_set_vports_agg_speed() programs the vport with the (possibly
smaller, PCIe-clamped) cached aggregate, and while ib_query_port reports
the cached aggregate for the same LAG.

Two related observations: mlx5_lag_query_bond_speed() stays
EXPORT_SYMBOL_GPL (and declared in include/linux/mlx5/driver.h next to the
new getter) although no caller outside mlx5_core is left after this
conversion, and the two getters use different sentinels for "unknown" -
mlx5_lag_query_bond_speed() returns success with *speed == 0 and errors on
SPEED_UNKNOWN, while mlx5_lag_query_aggregated_speed() errors on 0.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> index c2f21eb4ea7cf..76b574fa0d7a6 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c

[ ... ]

> @@ -1496,6 +1495,30 @@ static int mlx5_lag_get_devices_max_speed(struct mlx5_lag *ldev, u32 *max_speed)
>  	return 0;
>  }
>  
> +void mlx5_lag_update_agg_speed(struct mlx5_lag *ldev)
> +{
> +	u32 speed;
> +
> +	lockdep_assert_held(&ldev->lock);
> +
> +	if (mlx5_lag_get_devices_oper_speed(ldev, &speed))
> +		return;
> +
> +	/* If speed is not set, use the sum of max speeds of all PFs */

[Severity: Low]
This isn't a bug, but is the comment still accurate for active-backup?
mlx5_lag_get_devices_max_speed() does not sum in that case:

	take_max = ldev->tracker.tx_type == NETDEV_LAG_TX_TYPE_ACTIVEBACKUP;
	if (ldev->mode == MLX5_LAG_MODE_MPESW)
		take_max = false;
	...
		*max_speed = take_max ?
			max(*max_speed, speed) : *max_speed + speed;

The comment was correct before the series, where
mlx5_lag_sum_devices_max_speed() unconditionally did *sum_speed += speed;
the take_max behaviour came in with "net/mlx5: Lag, split aggregate speed
into oper and max helpers" and this patch copies the older comment into the
new helper.

> +	if (!speed && mlx5_lag_get_devices_max_speed(ldev, &speed))
> +		return;
> +
> +	ldev->agg_speed_mbps = speed;
> +}

[Severity: Medium]
On the two early returns above, ldev->agg_speed_mbps keeps its previous
value and the void return type gives callers no way to notice.  Is that
intended?

mlx5_lag_get_devices_oper_speed() propagates the error from
mlx5_port_oper_linkspeed() -> mlx5_port_query_eth_proto() ->
ACCESS_REG(PTYS), so an FW command error or a query during a health/reset
window lands here.

> +
> +void mlx5_lag_reset_agg_speed(struct mlx5_lag *ldev)
> +{
> +	lockdep_assert_held(&ldev->lock);
> +
> +	ldev->agg_speed_mbps = 0;
> +}
> +
> +#ifdef CONFIG_MLX5_ESWITCH
>  static void mlx5_lag_modify_device_vports_speed(struct mlx5_core_dev *mdev,
>  						u32 speed)
>  {
> @@ -1541,17 +1564,10 @@ void mlx5_lag_set_vports_agg_speed(struct mlx5_lag *ldev)
>  	u32 speed;
>  	int pf_idx;
>  
> -	if (ldev->mode == MLX5_LAG_MODE_MPESW) {
> -		if (mlx5_lag_get_devices_oper_speed(ldev, &speed))
> -			return;
> -	} else {
> -		speed = ldev->tracker.bond_speed_mbps;
> -		if (speed == SPEED_UNKNOWN)
> -			return;
> -	}
> +	mlx5_lag_update_agg_speed(ldev);
> +	speed = ldev->agg_speed_mbps;
>  
> -	/* If speed is not set, use the sum of max speeds of all PFs */
> -	if (!speed && mlx5_lag_get_devices_max_speed(ldev, &speed))
> +	if (!speed)
>  		return;

[Severity: Medium]
Can this reprogram hardware with a stale speed?  The !speed test cannot
distinguish a freshly computed value from a leftover non-zero cache, so
after a failed PTYS query mlx5_lag_set_vports_agg_speed() continues into
mlx5_lag_modify_device_vports_speed() and writes the previous aggregate
into vport->agg_max_tx_speed / MODIFY_VPORT_STATE for every non-uplink
vport.

Before this patch the MPESW path aborted on query failure and the
non-MPESW path did not touch PTYS at all (it used
tracker.bond_speed_mbps), so a failing query left the hardware untouched
instead of reprogramming the last known value.  The same stale value is
then handed to mlx5_ib via mlx5_lag_query_aggregated_speed() and reported
as the current port rate.

Would returning an int from mlx5_lag_update_agg_speed(), or invalidating
the cache on failure, be preferable here?

> @@ -2068,6 +2085,28 @@ static int mlx5_handle_changeinfodata_event(struct mlx5_lag *ldev,
>  	return 1;
>  }
>  
> +/* Returns speed in Mbps. */
> +int mlx5_lag_query_aggregated_speed(struct mlx5_core_dev *mdev, u32 *speed)
> +{
> +	struct mlx5_lag *ldev;
> +	int ret = 0;
> +
> +	ldev = mlx5_lag_dev(mdev);
> +	if (!ldev)
> +		return -ENODEV;
> +
> +	mutex_lock(&ldev->lock);
> +	*speed = ldev->agg_speed_mbps;
> +	if (*speed == 0)
> +		ret = -EINVAL;
> +	mutex_unlock(&ldev->lock);

[Severity: Medium]
Does the validity window of this cache match the LAG-active state that
mlx5_ib uses to choose the bond path?  The replaced
mlx5_lag_query_bond_speed() read tracker.bond_speed_mbps, which is set by
the netdev event that triggered bonding and is never cleared on
deactivation, so the failure conditions of the two getters differ.

At activation, mlx5_do_bond() sets the ROCE mode (so mlx5_lag_is_roce()
is already true) and then calls mlx5_lag_rescan_dev_locked(), which by its
own comment drops ldev->lock while the mlx5_ib aux device is probed and
ib_register_device() publishes the device.  Only afterwards is the cache
populated:

	mlx5_lag_rescan_dev_locked(ldev, dev0, true);
	...
	if (!shared_fdb)
		mlx5_lag_set_vports_agg_speed(ldev);

mlx5_lag_shared_fdb_create() has the same ordering, calling
mlx5_lag_rescan_dev_locked() and mlx5_lag_reload_ib_reps_from_locked()
before mlx5_lag_set_vports_agg_speed().

A UVERBS_METHOD_QUERY_PORT_SPEED issued in that window reaches
mlx5_ib_query_port_speed_from_bond(), reads agg_speed_mbps == 0 and gets
-EINVAL back to userspace, where the pre-patch code returned a speed.

On teardown there is a similar ordering in mlx5_deactivate_lag():

	mlx5_lag_reset_vports_speed(ldev);	/* zeroes agg_speed_mbps */
	dev0 = mlx5_lag_pf(ldev, master_idx)->dev;
	ldev->mode = MLX5_LAG_MODE_NONE;

mlx5_ib samples mlx5_lag_is_roce()/mlx5_lag_is_sriov() under lag_lock and
only then takes ldev->lock, so it can observe "LAG active" followed by a
zeroed cache.

Note also that the peer helper mlx5_ib_query_port_speed_from_vport()
treats an unavailable speed as a fallback rather than an error:

	if (vport_state == VPORT_STATE_DOWN || max_tx_speed == 0)
		/* Value 0 indicates field not supported, fallback */
		return mlx5_ib_query_port_speed_from_port(dev, port_num, speed);

Should from_bond() fall back to mlx5_ib_query_port_speed_from_port() as
well instead of propagating -EINVAL?

> +
> +	if (ret == -EINVAL)
> +		mlx5_core_dbg(mdev, "aggregated speed is unknown\n");
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(mlx5_lag_query_aggregated_speed);

[ ... ]
