Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795509175;
	b=0dps5U9IIsmUJpOGSCounQECGaQvRSbj6hkIDlRPjRI5Uf31Ho08J9f7Mr0PJJzBGgF2
	 aZgXC+93Af+7iuAp0i4Zr/ACKPqFok2BVXC/rlyWxnGqRK9xK121rpI9D1HCGP4Siyj8K
	 sr23VvFHyTwUbhqyLNyprf+HK0UPR1pQgud0Zmefvvoqh9b8iEwB6EU2KoRL7Wnki3kdj
	 ofP64NWlriBD/vic1l9NAd3VMNnIr2ZIXf1ofdprV3JGGOjgB9lQOAEo4xNMXPQhqSzM5
	 pF1aX6FRRnQKotbMbM3gtV3lKaMjArBa/NTfgpm+Dd9aXc5Mqig5/X2Z5XmqcHqYU9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795509175;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=HHCOhh1scpjZ1mmCtu+F0vsYxG67SpGIkKK48e5engo=;
	b=QN0BOdvBMLrYPht8yGPRAVmTxv6VG+rPlrx4T2t0ZK/n4fZXFpnUOfVb5TknAVrCmsJN
	 vtBkyopidfkSVONtzvwdd8Q3jqPjDJ4Xwzcvrk01c8cWMgf7HEqB1g3v9juKIwIDjawIp
	 QzQ/Igv/ClgyuXtv+UnOUrxJ/2nOslxAtPx5A14iCiPK3N6VDYmCSQy/iX1RYSuHAjSJ2
	 fhATsLT9mGeC58vvT2lby3U+f+p04XR4bVnmSSYresx9S4WZVn+eZOV03QYDIMqcvLKW2
	 Xl5Z+otLy4wJdQeGLcxFzHpEkclcADJ4W+brJEPlRlEQlMyYIL0Awqv9hojDXqv7GYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=me2h9mcx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46DF606A32C;
	Tue, 24 Nov 2026 08:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=me2h9mcx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7575F1F000D4;
	Tue, 24 Nov 2026 08:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795509175;
	bh=HHCOhh1scpjZ1mmCtu+F0vsYxG67SpGIkKK48e5engo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=me2h9mcxlMluavCfFcLHD5egTnJzc96IWSbdZ+m5pxTJ+gSS58RvAC+OjU+99sPmU
	 /VP9LOCEPbKohkBza2HTesoA3lH/HYomhua0E0KlzS7Qz03Iitltwlm65Zzpp4ICH2
	 DUvXePmh3kTsATBWstTlvo1igCmeCuTlhH2LZGvgRB7/e8owj96o93KiDRn6Yty6nn
	 ao3WvDFVyEAXWwh/oUCdJ9ibF1OJxm9kkAEwcxEvFqRJJIMsBo6p0mJ+lXCMVZlbcK
	 lwgS7C48J1XPTAghOpWNgscRHCVuzpFfVlHPK/bCiqybTtZ0GtCXJg2vRkoTAwxjhj
	 x6NWjhIwPLTDw==
Subject: Re: [PATCH net-next V2 5/5] net/mlx5: LAG, enable LAG over functions
 that do not represent a physical port
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 agoldberger@nvidia.com, gal@nvidia.com, jgg@ziepe.ca, leon@kernel.org,
 linux-rdma@vger.kernel.org, mbloch@nvidia.com, moshe@nvidia.com,
 ohartoov@nvidia.com, saeedm@nvidia.com, shayd@nvidia.com
Date: Tue, 24 Nov 2026 08:32:54 +0000
Message-ID: <179550917403.3135.6078772385370645877@kernel.org>
In-Reply-To: <20261120075959.2533702-6-tariqt@nvidia.com>
References: <20261120075959.2533702-6-tariqt@nvidia.com>
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

Thank you for your contribution! Sashiko AI review found 4 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 2 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] mlx5_lag_add_mdev() now lets any VF/SF that passes
  mlx5_virt_lag_is_supported() into the LAG, and nothing caps how many…
- [Medium] net/mlx5: LAG, empty debugfs member list in members_show() for
  virt_lag
- [Low] For a virt LAG, vport speed aggregation does nothing at all.
- [Low] The commit message does not mention that the exported
  mlx5_lag_is_mpesw() changes meaning.

--

net/mlx5: LAG, enable LAG over functions that do not represent a physical port

This patch lets VF/SF functions that sit behind a multi_uplink_eswitch
(num_lag_ports < 2) join a LAG, using mlx5_virt_lag_is_supported() to
detect them. Such members are not marked as ports. They do not register
the PORT_CHANGE, netdev or multipath FIB notifiers, and they do not add
netdevs to the LAG.

The patch also widens mlx5_lag_get_filter() and mlx5_lag_is_mpesw() for
virt LAG, makes mlx5_lag_get_num_ports() return at least 1, and stops
RDMA from assigning a TX port affinity for these functions.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> index 193fbe47fef15..2cd2319f93189 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c

[ ... ]

> @@ -2398,7 +2404,7 @@ int mlx5_ldev_add_mdev(struct mlx5_lag *ldev,
>  	fn->group_id = group_id;
>  	dev->priv.lag = ldev;
>  
> -	if (group_id)
> +	if (group_id || ldev->virt_lag)
>  		return 0;
>  
>  	xa_set_mark(&ldev->fns, idx, MLX5_LAG_XA_MARK_PORT);

[Severity: Medium]
Does this early return also leave the lag/members debugfs file empty
for every virt LAG device?

mlx5_lag_add_mdev() now lets virt-LAG capable functions through. On
success it calls mlx5_ldev_add_debugfs(dev), which creates the lag
directory, including the members file.

members_show() in lag/debugfs.c lists the members with:

	mlx5_ldev_for_each(i, 0, ldev)
		seq_printf(file, "%s\n",
			   dev_name(mlx5_lag_fn(ldev, i)->dev->device));

mlx5_ldev_for_each() uses MLX5_LAG_FILTER_PORTS, so
mlx5_get_next_lag_func() only walks entries marked with
MLX5_LAG_XA_MARK_PORT. A virt-LAG member returns here before
xa_set_mark() runs, so no entry in ldev->fns carries the mark.
Reading lag/members on such a device then always prints nothing, even
when the LAG has members.

This patch already switched mlx5_lag_get_filter() to
MLX5_LAG_FILTER_ALL for virt LAG because its members are not marked
as ports. Should members_show() use the same per-device filter, or
MLX5_LAG_FILTER_ALL when ldev->virt_lag is set, so the file reports
the real members? Or is the members file not meant to exist for a
virt LAG?

[Severity: Low]
Because of this early return for virt_lag, no virt-LAG member ever gets
MLX5_LAG_XA_MARK_PORT or the PORT_CHANGE notifier. Does that leave vport
speed aggregation doing nothing for a virt LAG?

mlx5_lag_enable_mpesw() calls mlx5_lag_shared_fdb_create() with
MLX5_LAG_FILTER_ALL, and that function then does:

	if (filter == MLX5_LAG_FILTER_PORTS || filter == MLX5_LAG_FILTER_ALL)
		mlx5_lag_set_vports_agg_speed(ldev);

mlx5_lag_set_vports_agg_speed(), mlx5_lag_get_devices_oper_speed() and
mlx5_lag_get_devices_max_speed() all iterate with mlx5_ldev_for_each(),
which only visits PORT-marked entries. For a virt LAG the summed speed
is 0, and the loop that calls mlx5_lag_modify_device_vports_speed() runs
zero times.

The skipped notifier, mlx5_lag_mpesw_port_change_event(), is the only
place that queues speed_update_work. So nothing would refresh the speed
later either.

Other virt-LAG paths in this series were moved to MLX5_LAG_FILTER_ALL
(for example mlx5_lag_get_devcom_comp()). If speed aggregation is not
meant to apply to virt LAG, should mlx5_lag_shared_fdb_create() skip the
call explicitly? If it is meant to apply, should the speed helpers and
the refresh trigger cover all members?

> @@ -2547,7 +2553,7 @@ void mlx5_lag_add_mdev(struct mlx5_core_dev *dev)
>  {
>  	int err;
>  
> -	if (!mlx5_lag_is_supported(dev))
> +	if (!mlx5_lag_is_supported(dev) && !mlx5_virt_lag_is_supported(dev))
>  		return;
>  
>  	if (mlx5_lag_register_hca_devcom_comp(dev))

[Severity: Medium]
Can the retry loop below this check spin forever once a virt LAG has 255
members?

mlx5_lag_add_mdev() gives up only on -EOPNOTSUPP:

	if (err == -EOPNOTSUPP) {
		mlx5_lag_unregister_hca_devcom_comp(dev);
		return;
	}
	if (err) {
		msleep(100);
		goto recheck;
	}

The devcom match key comes from mlx5_query_nic_sw_system_image_guid().
It is the system image GUID plus the load_balance_id and VF/SF flag
bytes. So every virt-LAG capable SF (or VF) of the same NIC in the same
netns would join the same ldev through __mlx5_lag_dev_add_mdev().

mlx5_ldev_add_mdev() allocates the slot with:

	err = xa_alloc(&ldev->fns, &idx, fn, XA_LIMIT(0, U8_MAX - 1),
		       GFP_KERNEL);

After 255 members this returns -EBUSY, and __mlx5_lag_dev_add_mdev()
passes it back unchanged. This happens when MPESW is not yet active;
otherwise the late-joiner -EOPNOTSUPP check returns first. The xarray
stays full between iterations, so mlx5_load() for the 256th function
would sleep and retry until some other member unloads.

An earlier patch in this series ("net/mlx5: E-switch, add match-metadata
allocator for nested VF/SF eswitches") already mentions the 0-254 slot
limit from this xa_alloc(). Before this patch, only vport_group_manager
PFs with 2..MLX5_MAX_PORTS lag ports reached this path, so the limit
could not be hit.

Should a permanent capacity error end the LAG join the same way
-EOPNOTSUPP does, instead of being retried like a transient error?

[ ... ]

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
> index 2d3e61541d8a1..0ef2d13d00968 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
> @@ -336,7 +336,7 @@ bool mlx5_lag_is_mpesw(struct mlx5_core_dev *dev)
>  	struct mlx5_lag *ldev = mlx5_lag_dev(dev);
>  
>  	return ldev && ldev->mode == MLX5_LAG_MODE_MPESW &&
> -	       __mlx5_lag_dev_is_port(ldev, dev);
> +	       (ldev->virt_lag || __mlx5_lag_dev_is_port(ldev, dev));
>  }
>  EXPORT_SYMBOL(mlx5_lag_is_mpesw);

[Severity: Low]
This isn't a bug, but the commit message does not say that the exported
mlx5_lag_is_mpesw() now returns true for every virt-LAG member, not only
for port-marked ones.

It also does not mention the change in mlx5_lag_get_filter():

	if (fn && (fn->group_id || ldev->virt_lag))
		return MLX5_LAG_FILTER_ALL;

With this change, mlx5_lag_get_dev_seq(), mlx5_lag_get_next_peer_mdev()
and the related helpers walk all members of a virt LAG.

Several places call mlx5_lag_is_mpesw():

  - eswitch_offloads.c (uplink destination type)
  - en_tc.c
  - en/tc_tun.c
  - ib_rep.c
  - a devlink parameter getter in eswitch.c, which reports the value to
    user space

Their behavior for VF/SF functions now changes. Could the commit message
describe these two changes?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261120075959.2533702-1-tariqt%40nvidia.com
