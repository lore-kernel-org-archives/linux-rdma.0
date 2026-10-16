Received: from mta0.migadu.com (out-68.mta0.migadu.com [91.218.175.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2459395D8E
	for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 02:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792118154; cv=none; b=a/Yhshx1ptpISQn2L1L/MbatIVSICrj5amk0vmbgP7a1cU5vQM/KektmK29t0jb7KjIjjbF4MdvI3hO6TooS5ldFQLJs1Yd0prd6JGVatmPvHdRYkAp5ytVfLrsvANRomDittoQLZsX8ikNeFt/QHrUWIdzykGpOdiHNq+YVvyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792118154; c=relaxed/simple;
	bh=S4NoMBi0G7N0mzREwUz3QrXUzhW9WoiBlKR+otTxqJ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X1RK8lrYACmrLypESbmQIQB/T9k1QNqq6xOcA4LnjGYS1d8BltXo99P+76wg4jJ4L2oWWbkJRQrTbK48ah7WOzuiPFoqc91jBRWjPp3nPMnsTdzRS3WXOjqiAC1nlvZebt1AGaCnuVmlfwp5+dBBzf9gzTYjlee1SAZEM3lAhOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QO2od4ns; arc=none smtp.client-ip=91.218.175.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QO2od4ns"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=S4NoMBi0G7N0mzREwUz3QrXUzhW9WoiBlKR+otTxqJ4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792118150; v=1; x=1792722950;
 b=QO2od4nsPQwkePaARf0bViHk/0wcXKK5KXAThGnqeK+hCsTTLpmSWDCcmDArE0ma72IR9j1O
 ZT44uW+2o2p0FYpErFVJkn8wtRZy37EX4SrAC4Dz+vOplxDFAsHtEFBzc2nCLIXgo/SPTBoDXDo
 9jFh1b9DtWkA3iQztaHFOcrY=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id cfb9d46c77c05127;
	Fri, 16 Oct 2026 02:35:50 +0000
X-Mizu-Trace-ID: cfb9d46c77c05127
X-Migadu-Flow: FLOW_OUT
Date: Fri, 16 Oct 2026 10:36:09 +0800
From: Chenguang Zhao <chenguang.zhao@linux.dev>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>, Cosmin Ratiu <cratiu@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Jianbo Liu <jianbol@nvidia.com>,
	Jiri Pirko <jiri@resnulli.us>, Leon Romanovsky <leon@kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>, Shay Drori <shayd@nvidia.com>
Subject: Re: [PATCH net] net/mlx5: Attach late uplink netdev to loaded
 representors
Message-ID: <20261016023609.GA318264@pc>
References: <20261006110219.257714-1-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261006110219.257714-1-tariqt@nvidia.com>

On Tue, Oct 06, 2026 at 02:02:19PM +0300, Tariq Toukan wrote:
> From: Jianbo Liu <jianbol@nvidia.com>
> 
> mlx5e_vport_uplink_rep_load() returns success when the uplink netdev is
> missing, so the ETH rep is marked loaded with a NULL netdev, the IB rep
> copies that NULL association, and nothing repairs it later. Unbind
> mlx5_core.eth.<N> in legacy mode, enter switchdev, bind it again, and
> rdma link show still reports no netdev on the uplink port. The netdev
> also keeps the NIC profile instead of the uplink rep profile.
> 
> Add an attach_uplink_netdev rep op, run from the existing reload-reps
> work once mlx5_core_uplink_netdev_set() reports a netdev. ETH re-runs
> the uplink load, switching profile and setting rpriv->netdev; IB redoes
> ib_device_set_netdev(). Deferring to the work keeps the devlink lock
> out of probe context.
> 
> Fixes: 6b4be64fd9fe ("net/mlx5e: Harden uplink netdev access against device unbind")
> Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
> Reviewed-by: Shay Drori <shayd@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>  drivers/infiniband/hw/mlx5/ib_rep.c           | 24 +++++++++++++
>  .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 15 ++++++++
>  .../net/ethernet/mellanox/mlx5/core/eswitch.h |  3 ++
>  .../mellanox/mlx5/core/eswitch_offloads.c     | 35 +++++++++++++++++++
>  .../net/ethernet/mellanox/mlx5/core/main.c    |  3 ++
>  include/linux/mlx5/eswitch.h                  |  5 +++
>  6 files changed, 85 insertions(+)
> 
> diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband/hw/mlx5/ib_rep.c
> index 65d8767d1830..f9931a94157a 100644
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
> +
> +	for (i = 0; i < dev->num_ports; i++)
> +		if (dev->port[i].rep == rep)
> +			return ib_device_set_netdev(&dev->ib_dev, ndev, i + 1);
> +
> +	return 0;
> +}
> +
>  static const struct mlx5_eswitch_rep_ops rep_ops = {
>  	.load = mlx5_ib_vport_rep_load,
>  	.unload = mlx5_ib_vport_rep_unload,
>  	.get_proto_dev = mlx5_ib_rep_to_dev,
> +	.attach_uplink_netdev = mlx5_ib_vport_uplink_rep_attach_netdev,
>  };
>  
>  static void mlx5_ib_register_peer_vport_reps(struct mlx5_core_dev *mdev)
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> index 88a170e40bd9..19812bf6a830 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> @@ -1490,10 +1490,24 @@ mlx5e_vport_uplink_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *
>  	rpriv->netdev = netdev;
>  	err = mlx5e_netdev_change_profile(netdev, dev,
>  					  &mlx5e_uplink_rep_profile, rpriv);
> +	if (err)
> +		rpriv->netdev = NULL;
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
> +}
> +
>  static void
>  mlx5e_vport_uplink_rep_unload(struct mlx5e_rep_priv *rpriv)
>  {
> @@ -1741,6 +1755,7 @@ static const struct mlx5_eswitch_rep_ops rep_ops = {
>  	.unload = mlx5e_vport_rep_unload,
>  	.get_proto_dev = mlx5e_vport_rep_get_proto_dev,
>  	.event = mlx5e_vport_rep_event,
> +	.attach_uplink_netdev = mlx5e_vport_uplink_rep_attach_netdev,
>  };
>  
>  static int mlx5e_rep_probe(struct auxiliary_device *adev,
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
> index 8b1f93b13ea9..3dd6931f13cd 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
> @@ -1012,6 +1012,7 @@ mlx5_esw_lag_demux_rule_create(struct mlx5_eswitch *esw, u16 vport_num,
>  			       struct mlx5_flow_table *lag_ft);
>  void mlx5_esw_reps_block(struct mlx5_eswitch *esw);
>  void mlx5_esw_reps_unblock(struct mlx5_eswitch *esw);
> +void mlx5_esw_offloads_uplink_netdev_attach(struct mlx5_core_dev *dev);
>  #else  /* CONFIG_MLX5_ESWITCH */
>  /* eswitch API stubs */
>  static inline int  mlx5_eswitch_init(struct mlx5_core_dev *dev) { return 0; }
> @@ -1098,6 +1099,8 @@ mlx5_esw_host_functions_enabled(const struct mlx5_core_dev *dev)
>  
>  static inline void mlx5_esw_reps_block(struct mlx5_eswitch *esw) {}
>  static inline void mlx5_esw_reps_unblock(struct mlx5_eswitch *esw) {}
> +static inline void
> +mlx5_esw_offloads_uplink_netdev_attach(struct mlx5_core_dev *dev) {}
>  
>  static inline bool
>  mlx5_esw_vport_vhca_id(struct mlx5_eswitch *esw, u16 vportn, u16 *vhca_id)
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> index eb74b6260168..cf61bd76889c 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> @@ -4842,6 +4842,29 @@ mlx5_eswitch_register_vport_reps_blocked(struct mlx5_eswitch *esw,
>  	}
>  }
>  
> +static void mlx5_eswitch_attach_uplink_netdev(struct mlx5_eswitch *esw,
> +					      struct mlx5_eswitch_rep *uplink)
> +{
> +	const struct mlx5_eswitch_rep_ops *ops;
> +	int type;
> +	int err;
> +
> +	for (type = 0; type < NUM_REP_TYPES; type++) {
> +		if (atomic_read(&uplink->rep_data[type].state) != REP_LOADED)
> +			continue;
> +
> +		ops = esw->offloads.rep_ops[type];
> +		if (!ops || !ops->attach_uplink_netdev)
> +			continue;
> +
> +		err = ops->attach_uplink_netdev(esw->dev, uplink);
> +		if (err)
> +			esw_warn(esw->dev,
> +				 "Failed to attach uplink netdev to rep type %d, err(%d)\n",
> +				 type, err);
> +	}
> +}
> +
>  static void mlx5_eswitch_reload_reps_blocked(struct mlx5_eswitch *esw)
>  {
>  	struct mlx5_eswitch_rep *uplink;
> @@ -4862,6 +4885,8 @@ static void mlx5_eswitch_reload_reps_blocked(struct mlx5_eswitch *esw)
>  		return;
>  	}
>  
> +	mlx5_eswitch_attach_uplink_netdev(esw, uplink);
> +
>  	if (mlx5_get_sd(esw->dev) && !mlx5_lag_is_active(esw->dev))
>  		return;
>  
> @@ -4886,6 +4911,16 @@ static void mlx5_eswitch_reload_reps(struct mlx5_eswitch *esw)
>  	mlx5_esw_reps_unblock(esw);
>  }
>  
> +void mlx5_esw_offloads_uplink_netdev_attach(struct mlx5_core_dev *dev)
> +{
> +	struct mlx5_eswitch *esw = dev->priv.eswitch;
> +
> +	if (!mlx5_esw_allowed(esw))
> +		return;
> +
> +	mlx5_esw_add_work(esw, mlx5_eswitch_reload_reps, GFP_KERNEL);
> +}
> +
>  static void
>  mlx5_eswitch_register_vport_reps_locked(struct mlx5_eswitch *esw,
>  					const struct mlx5_eswitch_rep_ops *ops,
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> index 5f28d906c35b..ab93c807b58c 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> @@ -278,6 +278,9 @@ void mlx5_core_uplink_netdev_set(struct mlx5_core_dev *dev, struct net_device *n
>  	mlx5_blocking_notifier_call_chain(dev, MLX5_DRIVER_EVENT_UPLINK_NETDEV,
>  					  netdev);
>  	mutex_unlock(&dev->mlx5e_res.uplink_netdev_lock);
> +
> +	if (netdev)
> +		mlx5_esw_offloads_uplink_netdev_attach(dev);
>  }
>  
>  void mlx5_core_uplink_netdev_event_replay(struct mlx5_core_dev *dev)
> diff --git a/include/linux/mlx5/eswitch.h b/include/linux/mlx5/eswitch.h
> index a0dd162baa78..e823fbe7ff40 100644
> --- a/include/linux/mlx5/eswitch.h
> +++ b/include/linux/mlx5/eswitch.h
> @@ -43,6 +43,11 @@ struct mlx5_eswitch_rep_ops {
>  		     struct mlx5_eswitch_rep *rep,
>  		     enum mlx5_switchdev_event event,
>  		     void *data);
> +	/* Attach an uplink netdev that showed up only after the uplink
> +	 * representor was already loaded.
> +	 */
> +	int (*attach_uplink_netdev)(struct mlx5_core_dev *dev,
> +				    struct mlx5_eswitch_rep *rep);
>  };
>  
>  struct mlx5_eswitch_rep_data {
> 
> base-commit: d5a007b9b457c915ab1a53227e8939e4018aa97a
> -- 
> 2.44.0
> 
Hi all,

I’m wondering if we could add a check during mode configuration to
disallow mode switching when the device is unbound.

Maybe we can call `mlx5_uplink_netdev_get()` within `mlx5_devlink_eswitch_mode_set()`
to retrieve the netdev, and return `-ENODEV` if it comes back NULL.

What do you think about this approach?

Thanks
Chenguang
