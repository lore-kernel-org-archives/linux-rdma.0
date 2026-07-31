Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7121D2FFFA4;
	Fri, 31 Jul 2026 16:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785517049; cv=none; b=KunLFsvnj1AY6/7uDiigSPlOsXm3jV9yQZMd6jJFYFQ8F6jW+sbnSTnfNo4LbKEnQjxFacyH9gMo0rIlvYhFF/mKIEi9efm4YoG1/VzPxAdeNddLwgpDEfbxp3z2XAsfCokr50n6cwk0AP5XvKNAAE9DtmabEG4GxEtgvDjf0sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785517049; c=relaxed/simple;
	bh=XJM7279h+Yj3A3zgcpixVvnyJmiW2VMDoNofwRg6Dgg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u5GQelii5TGMrq6BTBqqR8gGZPu7TK1bqUsqL159oeGeGR/7LQiSVf3UnIGxiZ+y7phT033/zjwUbgQDcAbJa00zBshqT63GRXQ0gW6+3w8XaIJS9Zg0Thz0vOhCa6mVJY9M/Vx7jxkgutyF8rBaiQlXvFiC02eq2nHwlpjy4tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M/JWp6O2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M/JWp6O2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 625091F00AC4;
	Fri, 31 Jul 2026 16:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785517048;
	bh=IyAsbXXV2p1aDsgxm2hy2xqrSUBtvpVaiO7mx1IfkqI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=M/JWp6O2FPiAUqpPmM7XUuIdwQp8OT76RZnpZlt0Lw4vv+jMy4x++gALYD7wTTqk3
	 nj594wC9DfAOpaw5uoynV+KwXKIbFutB8dxdOA2CR/BcIB60MWbpHzBX85WL+mirqj
	 VBHX+jWACuNOPWL99oBvNHdcsRUmJYjqxdhjvabF0T0Meggoh8oAZrOIJm4yT8cWcz
	 NANVb9xq44C/nufJaDCo0LKDKOQ10LYhEZiWbSReULyV8OuuTWptutcVgz1R9NSLMt
	 LKoL3lK2axJ1oV93P+MJtqQaVomWVLthk4f/C7DqdWlEtupN5XJcxTyR2N+v0Igk+a
	 ohn7jP0whpL1g==
Date: Fri, 31 Jul 2026 17:57:22 +0100
From: Simon Horman <horms@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Carolina Jubran <cjubran@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Daniel Jurgens <danielj@nvidia.com>, Gal Pressman <gal@nvidia.com>,
	Jiri Pirko <jiri@resnulli.us>, Kees Cook <kees@kernel.org>,
	Leon Romanovsky <leon@kernel.org>, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, Maher Sanalla <msanalla@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>,
	Or Har-Toov <ohartoov@nvidia.com>, Parav Pandit <parav@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>, Shay Drori <shayd@nvidia.com>
Subject: Re: [PATCH net] net/mlx5e: Move representor vnic reporter to eswitch
 devlink port
Message-ID: <20260731165722.GK51943@horms.kernel.org>
References: <20260729070059.2421788-1-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729070059.2421788-1-tariqt@nvidia.com>

On Wed, Jul 29, 2026 at 10:00:59AM +0300, Tariq Toukan wrote:

...

> @@ -252,6 +275,16 @@ int mlx5_esw_offloads_devlink_port_register(struct mlx5_eswitch *esw, struct mlx
>  		mlx5_core_dbg(dev, "Failed to register port resources: %d\n",
>  			      err);
>  
> +	rep = mlx5_eswitch_vport_rep(esw, vport_num);
> +	reporter = devl_port_health_reporter_create(
> +		&dl_port->dl_port, &mlx5_esw_rep_vnic_reporter_ops, rep);

Hi Caroila, and Tariq,

I'm wondering if you could take a look over the following which appears at
https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260729070059.2421788-1-tariqt%40nvidia.com

  Can rep or rep->esw be NULL at this point?

  mlx5_eswitch_vport_rep() is a plain lookup with no NULL check here:

  eswitch_offloads.c:mlx5_eswitch_get_rep() {
	return xa_load(&esw->offloads.vport_reps, vport);
  }

  and rep->esw is only assigned lazily. In mlx5_esw_offloads_rep_add() the
  assignment sits after the continue that is taken whenever no rep_ops are
  registered yet, which is the state at probe time when
  esw_offloads_init_reps() creates the reps:

  eswitch_offloads.c:mlx5_esw_offloads_rep_add() {
	rep = kzalloc_obj(*rep);
	...
	for (rep_type = 0; rep_type < NUM_REP_TYPES; rep_type++) {
		if (!esw->offloads.rep_ops[rep_type]) {
			atomic_set(&rep->rep_data[rep_type].state,
				   REP_UNREGISTERED);
			continue;
		}
		...
		rep->esw = esw;
	}
  }

  The only other writer is mlx5_eswitch_register_vport_reps_blocked(),
  which runs from the mlx5_core.eth-rep auxiliary driver probe
  (mlx5e_rep_probe() -> mlx5_eswitch_register_vport_reps()):

  eswitch_offloads.c:mlx5_eswitch_register_vport_reps_blocked() {
	esw->offloads.rep_ops[rep_type] = ops;
	mlx5_esw_for_each_rep(esw, i, rep) {
		if (likely(mlx5_eswitch_vport_has_rep(esw, rep->vport))) {
			rep->esw = esw;
			...
  }

  Is that probe guaranteed to have succeeded before ports are registered?
  esw_mode_change() discards the mlx5_rescan_drivers_locked() return value
  and sets esw->mode = mode regardless, and add_drivers() only warns when
  add_adev() fails:

  dev.c:add_drivers() {
	priv->adev[i] = add_adev(dev, i);
	if (IS_ERR(priv->adev[i])) {
		mlx5_core_warn(dev, "Device[%d] (%s) failed to load\n", ...);
		/* We continue to rescan drivers and leave to the caller ... */

  In that case rep_ops[REP_ETH] stays NULL, rep->esw stays NULL, and
  mlx5_eswitch_load_vport() -> mlx5_esw_offloads_load_rep() ->
  mlx5_esw_offloads_devlink_port_register() still installs a live reporter.
  Would a subsequent "devlink health diagnose <dev>/<port> reporter vnic"
  then oops on rep->esw->dev in mlx5_esw_rep_vnic_reporter_diagnose(),
  with the devlink instance lock held?

  The old code could not hit this because the reporter was created from the
  REP_ETH load callback, i.e. only after rep_ops were registered and
  rep->esw was set. Note also that mlx5_esw_offloads_rep_remove() does
  check the same lookup result for NULL, which this call site does not.

  Since struct mlx5_devlink_port already carries a struct mlx5_vport
  pointer, which gives both vport->dev and vport->vport and whose lifetime
  matches the port exactly, could dl_port->vport be used as the reporter
  priv instead of the rep?

> +	if (IS_ERR(reporter))
> +		mlx5_core_dbg(dev,
> +			      "Failed to create vnic health reporter for vport %d: %pe\n",
> +			      vport_num, reporter);
> +	else
> +		dl_port->vnic_reporter = reporter;
> +
>  	return 0;
>  
>  rate_err:

...
