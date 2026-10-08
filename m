Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A7F3BB133;
	Thu,  8 Oct 2026 11:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791457359; cv=none; b=qyQCb6+ngui4tYGzHuX8+4/KP5VZHT++vj8euuv7f0xouhu0dlv0poq5bmXb7RHE+9I7TPqwF8O2EODGnYr1Anl0QYQOLOcU9couW2c7FOy0q3RibQlW5KLJIgsq1eFZWYIM2TbfXM63f0X6mg0LujzGL2T9uUE8LwEmMinOAf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791457359; c=relaxed/simple;
	bh=cA1/qTyrizotSdyjYFq5EvDJy8AvLphPYCzZtYLUz/0=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KwMODNFsvuLyxzHyUhK9237N0ZUDiUudDYyXZi5NbwNLG0OD+NQzd9Q+OYFMdHGnSrAZ5ROjY30F1S1ryPzckKUIogRo7FBKvUjOm0NntlVUqxYJ3iM9oK3lLd+WoVDcBsP0LHhnJ/Wk/oAnj8Jm6iINW3vPjk+AP8ZGOnhKl6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DD0mAYGC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DD0mAYGC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C27F1F000FF;
	Thu,  8 Oct 2026 11:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791457358;
	bh=hSn9I5hyWGPWbXQTaJKZRICemtTPKOmDhjSWyzwmKLU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=DD0mAYGC1sPDSraT/bkKPGKi+Ynlwx+NDiIAreGvMO8OZJQ4dDFK6uxcz1keiu1x2
	 CzrYQTnA+GMHKcFqQzTSgG+86gqJuuYj6nhJj5IqAS3L95yeExI3+2UZBdDLqwxmGA
	 R71dY3O6hN8cFTgAW68ymHFGIsVOLQ0dpCG/jWAItadVB3174ZX2rwXfX3FWU//HQs
	 kJPQ6/s3MKTdWEeuMMfegY3NXg+KsO0UYAXSLOkSJGm9DjWWC+fO/W0m5LtLNc2SM6
	 oT8ZTjh/kFdTmm3d50PK8D4rj4XuEmvSJfH0CDLCyvkLLJTlBjRCb+HdFq5nCCQVGB
	 7uKCMc01QMURQ==
Subject:
 Re: [PATCH net] net/mlx5: Attach late uplink netdev to loaded representors
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, cratiu@nvidia.com,
 dtatulea@nvidia.com, gal@nvidia.com, jgg@ziepe.ca, jianbol@nvidia.com,
 jiri@resnulli.us, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, mbloch@nvidia.com, saeedm@nvidia.com,
 shayd@nvidia.com
Date: Thu, 08 Oct 2026 11:02:36 +0000
Message-ID: <179145735679.434549.4674299238253522487@kernel.org>
In-Reply-To: <20261006110219.257714-1-tariqt@nvidia.com>
References: <20261006110219.257714-1-tariqt@nvidia.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 5 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 2 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] New error-path use-after-free in the attach path.
- [Medium] mlx5_ib_vport_uplink_rep_attach_netdev() always sets the
  uplink IB port's netdev to the rep's own ETH netdev, via…
- [Medium] The attach path now writes the uplink ETH rep's rpriv->netdev
  while the rep is already REP_LOADED and VF reps may be live.
- [Low] mlx5_eswitch_attach_uplink_netdev() runs on every pass of
  mlx5_eswitch_reload_reps_blocked(), not only after…
- [Low] _mlx5e_probe() calls mlx5_core_uplink_netdev_set(mdev, netdev),
  which now queues the reload-reps work.

--

net/mlx5: Attach late uplink netdev to loaded representors

This commit adds an attach_uplink_netdev rep op that runs from the
reload-reps work. It covers the case where the uplink netdev appears only
after the uplink representor was loaded. ETH re-runs the uplink load to
switch profile and set rpriv->netdev, and IB redoes ib_device_set_netdev().

> diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband/hw/mlx5/ib_rep.c
> index 65d8767d1830c..f9931a94157aa 100644
> --- a/drivers/infiniband/hw/mlx5/ib_rep.c
> +++ b/drivers/infiniband/hw/mlx5/ib_rep.c
> @@ -273,10 +273,34 @@ mlx5_ib_vport_rep_unload(struct mlx5_eswitch_rep *rep)
>  	}
>  }
>  
> +static int
> +mlx5_ib_vport_uplink_rep_attach_netdev(struct mlx5_core_dev *mdev,
> +				       struct mlx5_eswitch_rep *rep)
> +{
> +	struct mlx5_ib_dev *dev = mlx5_ib_rep_to_dev(rep);
> +	struct net_device *ndev;
> +	int i;
> +
> +	/* Shared FDB slave uplinks share the master's IB device. */
> +	if (!dev)
> +		return 0;
> +
> +	ndev = mlx5_ib_get_rep_netdev(rep->esw, rep->vport);
> +	if (!ndev)
> +		return -ENODEV;

[Severity: Low]
Should this return -ENODEV in the scenario the patch targets?

mlx5_eswitch_attach_uplink_netdev() runs on every pass of
mlx5_eswitch_reload_reps_blocked(). That work is also queued by
mlx5_eswitch_register_vport_reps_locked() whenever ETH or IB rep ops
register, not only after mlx5_core_uplink_netdev_set() reports a netdev.

Suppose eth is unbound in legacy mode and switchdev is then entered. The
ETH uplink rep is REP_LOADED with rpriv->netdev == NULL. When the IB rep
registers, the reload work loads the IB uplink rep and calls this op.
mlx5_ib_get_rep_netdev()->mlx5_eswitch_get_proto_dev()->
mlx5e_vport_rep_get_proto_dev() returns NULL, and the core logs:

    E-Switch: Failed to attach uplink netdev to rep type 1, err(-19)

This repeats on each reload-reps pass until eth is bound again. Would
returning 0 for a missing netdev be more appropriate here?

The commit message says the op is "run from the existing reload-reps work
once mlx5_core_uplink_netdev_set() reports a netdev". The comment in
struct mlx5_eswitch_rep_ops says something similar. The call in
mlx5_eswitch_reload_reps_blocked() does not depend on that condition,
though.

> +
> +	for (i = 0; i < dev->num_ports; i++)
> +		if (dev->port[i].rep == rep)
> +			return ib_device_set_netdev(&dev->ib_dev, ndev, i + 1);

[Severity: Medium]
Can this overwrite a netdev that LAG picked for this port?

This always sets the uplink IB port to the rep's own ETH netdev and does
not check for an existing association. For SR-IOV active-backup LAG,
lag_event() in drivers/infiniband/hw/mlx5/main.c points the uplink port
at the netdev carried by MLX5_DRIVER_EVENT_ACTIVE_BACKUP_LAG_CHANGE_LOWERSTATE.
That can be the peer's lower netdev:

    old_ndev = ib_device_get_netdev(ibdev, portnum + 1);
    ret = ib_device_set_netdev(ibdev, ndev, portnum + 1);

mlx5_eswitch_attach_uplink_netdev() calls this op for any REP_LOADED
uplink on every reload-reps pass. Those passes are queued at eth probe
and at rep ops registration, and the devl_trylock() retry in
esw_wq_handler() can delay them.

Suppose a pass runs after LAG has picked a different lower netdev. Would
it replace that choice, so RDMA reports the wrong netdev until the next
lower-state event?

> +
> +	return 0;
> +}
> +

[ ... ]

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> index 88a170e40bd93..19812bf6a8306 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> @@ -1490,10 +1490,24 @@ mlx5e_vport_uplink_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *
>  	rpriv->netdev = netdev;
>  	err = mlx5e_netdev_change_profile(netdev, dev,
>  					  &mlx5e_uplink_rep_profile, rpriv);
> +	if (err)
> +		rpriv->netdev = NULL;

[Severity: High]
Can this leave the netdev pointing at a freed rpriv?

An error from mlx5e_netdev_change_profile() does not always mean the
profile change was rolled back. When mdev->state is
MLX5_DEVICE_STATE_INTERNAL_ERROR:

    if (mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR) {
        mlx5e_netdev_init_profile(netdev, mdev, new_profile, new_ppriv);
        set_bit(MLX5E_STATE_DESTROYING, &priv->state);
        return -EIO;
    }

The netdev is left with priv->profile = &mlx5e_uplink_rep_profile and
priv->ppriv = rpriv, while rpriv->netdev is now cleared.

On the path through mlx5e_vport_uplink_rep_attach_netdev(),
mlx5_eswitch_attach_uplink_netdev() only logs the failure. The ETH rep
stays REP_LOADED. On the next unload, such as health recovery removing
the eth-rep aux device, mlx5e_vport_rep_unload() takes this branch:

    if (!netdev) {
        ppriv = rpriv;
        goto free_ppriv;
    }
    ...
free_ppriv:
    kvfree(ppriv); /* mlx5e_rep_priv */

That frees rpriv without calling mlx5e_vport_uplink_rep_unload(), so
mlx5e_netdev_attach_nic_profile() never runs.

On recovery, mlx5e_resume()->_mlx5e_resume()->mlx5e_attach_netdev()
calls profile->init_tx, which is mlx5e_init_rep_tx():

    struct mlx5e_rep_priv *rpriv = priv->ppriv;
    ...
    err = mlx5e_rep_neigh_init(rpriv);
    ...
    if (rpriv->rep->vport == MLX5_VPORT_UPLINK) {

Would this read and write the freed mlx5e_rep_priv? If rpriv->netdev had
stayed set, the unload path would have restored the NIC profile instead.

mlx5_enter_error_state() can set INTERNAL_ERROR asynchronously while the
attach work runs. The load path already had a similar kvfree-after-EIO
pattern, but the new attach caller and the new NULL assignment add
another way to reach it.

>  	mlx5_uplink_netdev_put(dev, netdev);
>  	return err;
>  }
>  
> +static int
> +mlx5e_vport_uplink_rep_attach_netdev(struct mlx5_core_dev *dev,
> +				     struct mlx5_eswitch_rep *rep)
> +{
> +	struct mlx5e_rep_priv *rpriv = mlx5e_rep_to_rep_priv(rep);
> +
> +	if (rpriv->netdev)
> +		return 0;
> +
> +	return mlx5e_vport_uplink_rep_load(dev, rep);

[Severity: Medium]
Is it safe to rewrite rpriv->netdev here while the uplink rep is already
REP_LOADED and VF reps may be live?

Before this patch, rpriv->netdev was only set inside ops->load. That
happened before the REP_LOADED transition that
mlx5_eswitch_get_proto_dev() checks.

On this path, mlx5e_vport_uplink_rep_load() publishes rpriv->netdev
first. mlx5e_netdev_change_profile() then detaches, cleans up and memsets
netdev_priv() before re-initializing it. On error the pointer goes back
to NULL.

The writer holds devlink and reps_lock. TC offload on VF reps holds
neither when it reads the uplink proto dev, and it dereferences the
result without a NULL check. For example, in get_route_and_out_devs():

    uplink_dev = mlx5_eswitch_uplink_get_proto_dev(esw, REP_ETH);

    rcu_read_lock();
    uplink_upper = netdev_master_upper_dev_get_rcu(uplink_dev);

and in mlx5e_route_lookup_ipv4_get():

    attr->fl.fl4.flowi4_oif = uplink_dev->ifindex;

parse_mirred() in en/tc/act/mirred.c does the same.

Could a flower rule added on a VF rep while the attach work runs see a
netdev whose priv is zeroed mid-change (priv->mdev == NULL in
mlx5e_is_uplink_rep())? Could it see the NULL written after a failed
change? Nothing such as READ_ONCE() or WRITE_ONCE() orders this pointer.

The NULL dereference in the window before eth is rebound comes from
6b4be64fd9fe and is pre-existing. What this patch adds is the uplink
profile changing while VF reps are loaded and handling TC.

> +}
> +

[ ... ]

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> index 5f28d906c35b6..ab93c807b58ce 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> @@ -278,6 +278,9 @@ void mlx5_core_uplink_netdev_set(struct mlx5_core_dev *dev, struct net_device *n
>  	mlx5_blocking_notifier_call_chain(dev, MLX5_DRIVER_EVENT_UPLINK_NETDEV,
>  					  netdev);
>  	mutex_unlock(&dev->mlx5e_res.uplink_netdev_lock);
> +
> +	if (netdev)
> +		mlx5_esw_offloads_uplink_netdev_attach(dev);

[Severity: Low]
This queues the reload-reps work from inside _mlx5e_probe(), and probe
keeps using priv afterwards:

    mlx5_core_uplink_netdev_set(mdev, netdev);
    mlx5e_params_print_info(mdev, &priv->channels.params);

When probe comes from a sysfs bind, the core devlink lock is not held.
esw_wq_handler() can then devl_trylock() and run
mlx5e_netdev_change_profile() on another CPU. That runs
mlx5e_detach_netdev(), profile->cleanup() and mlx5e_priv_cleanup() before
re-initializing priv.

Does the read of priv->channels.params race with that teardown? The
visible effect seems limited to wrong values in the informational log
line, but it is still a data race on priv.

>  }
>  
>  void mlx5_core_uplink_netdev_event_replay(struct mlx5_core_dev *dev)

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261006110219.257714-1-tariqt%40nvidia.com
