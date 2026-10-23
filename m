Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792783925;
	b=yU2eQZ4eSPf85k0pw4Y4Ce7/jWbJo0drfAC+FWN3oGfOyC2/I6iU4RkPkAzwn8M7ZfUw
	 I4GLUmko4ylY2io/GHHU2Lll16xrmMZm8l8LNaavN3u87cM3TGZCXMzHMklchXAO5Os4X
	 KCyvZlCDvNFB+CIsvUfNdHshSD9djECrh2lsDrqw2j33gEhrEw8u+7wjRU4bbXE6+4APo
	 zdMYz6Fv+WoaAZhotY5ds+BWL0qMtX1WfFgr2GFnhRqb7McPVgAWSztLS3GhTm4WdHHTH
	 jTv4y04+8P/o6TPPoYeQT0sph7L4vM1YXZebH1WzzCjPPfiPtRAwBuMYuBaYFqe914A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792783925;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=2DFro75mFV2yMfPdKi75JdAToek6yhz4qwNePJaks38=;
	b=3LHKI7mrZNID44ZrvQgNlZ+vasVvIzlQt82qNKjNfWhng+gUKhiAMgxC2Ldh2vaKTGv3
	 Xr0CGDqpSrlSk8ogups6KIX2RXxI7zaDjJHLLDWw1HBpX6CuPocLa1k13n+O1FrK7u9FM
	 DqEyv6oy3TISprNW8tmk4rhXg3wdTz8VH6DZxQv8tecP9KLE+/LAJrewHiCmuAJgENNrD
	 +mCl/JL65kVBuZYAc5JzSs82bQyNnHzblZYmSjzvaD3QrznL6UvzFPiWFk/YnI+j+Uc+7
	 uSUvNBbrhdn2U/K1Ixm0gzGtqdp/Z8O2lONx13SuG7c5qef3KKbTe15DwKmOmmrW9Pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z4Y6trXs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D6F606A328;
	Fri, 23 Oct 2026 19:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z4Y6trXs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11C171F031E3;
	Fri, 23 Oct 2026 19:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792783925;
	bh=2DFro75mFV2yMfPdKi75JdAToek6yhz4qwNePJaks38=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Z4Y6trXs+D56tbhW5a3v5tZ17CA8KtvIb4g64SGv7+TFiRXDy4+E5r2Hry9F8IZYS
	 yVKlP2d/f4qDV5bTeXzc7foBA2k1TVRgUgQrAs6nemmAtHxD0IYWavkLqb67kB/b2j
	 ZtMBJVSlPpL8K9Q/CP9dGcSggXWear7gQTQfL1qoyVK8rvtCrW1TYGJzlh35gAVTa4
	 dKeUHHfVZdiToaZaoWPWXDznEIdkHw8MSuzi8BcR1G6BwYKJ9oc6FVD4rxEVrFuCkx
	 qV1a94xz6yTdsThENWssF+WnmG55kW968tFJfgIdMOH/YS02gCbf1uSaQDh/S8WR71
	 4TV5n3fFkY9mQ==
Message-ID: <sashiko-outbox-183122@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net V2 3/4] {RDMA,net}/mlx5: notify IB uplink on LAG
 aggregate speed change
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261022193053.3815866-4-tariqt@nvidia.com>
References: <20261022193053.3815866-1-tariqt@nvidia.com>
 <20261022193053.3815866-4-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 19:32:04 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] RDMA/mlx5: use-after-free of ib_device from lag_event() on teardown
- [Medium] net/mlx5: LAG speed change notified before updating eswitch vpor=
t speeds
--

commit 5dd9a6a9f1014a459afa674b27b22373d933dc51
Author: Or Har-Toov <ohartoov@nvidia.com>

{RDMA,net}/mlx5: notify IB uplink on LAG aggregate speed change

This commit adds MLX5_DRIVER_EVENT_LAG_SPEED_CHANGE to notify the mlx5 IB
driver when the cached LAG aggregate speed changes, dispatching
IB_EVENT_DEVICE_SPEED_CHANGE to RDMA consumers.

> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/ml=
x5/main.c
> index 6594d38cf1993..cfa7c7ba2b737 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -3690,6 +3690,16 @@ static int lag_event(struct notifier_block *nb, un=
signed long event, void *data)
>  			rdma_roce_rescan_port(ibdev, portnum + 1);
>  		}
>  		break;
> +	case MLX5_DRIVER_EVENT_LAG_SPEED_CHANGE: {
> +		struct ib_event speed_event =3D {};
> +
> +		if (!dev->ib_active)
> +			break;
> +		speed_event.device =3D ibdev;
> +		speed_event.event =3D IB_EVENT_DEVICE_SPEED_CHANGE;
> +		ib_dispatch_event(&speed_event);
> +		break;
> +	}

[Severity: High]
Can this race with __mlx5_ib_remove() and cause a use-after-free of
struct ib_device on ib_wq?

In drivers/infiniband/core/cache.c, ib_dispatch_event() does not deliver
the event synchronously inside lag_event(). Instead, it queues a work item
with an unreferenced pointer to ibdev onto ib_wq:

drivers/infiniband/core/cache.c:ib_dispatch_event() {
	...
	INIT_WORK(&work->work, ib_generic_event_task);

	work->event =3D *event;
	...
	queue_work(ib_wq, &work->work);
}

The RDMA core drains ib_wq during ib_unregister_device() via
__ib_unregister_device() -> ib_cache_cleanup_one() ->
flush_workqueue(ib_wq), which runs in MLX5_IB_STAGE_IB_REG cleanup.

However, in drivers/infiniband/hw/mlx5/main.c, dev->lag_events is
unregistered in mlx5_eth_lag_cleanup() under MLX5_IB_STAGE_ROCE, which is
an earlier stage than MLX5_IB_STAGE_IB_REG and therefore runs after
MLX5_IB_STAGE_IB_REG during the reverse-order teardown loop in
__mlx5_ib_remove():

drivers/infiniband/hw/mlx5/main.c:__mlx5_ib_remove() {
	dev->ib_active =3D false;

	/* Number of stages to cleanup */
	while (stage) {
		stage--;
		if (profile->stage[stage].cleanup)
			profile->stage[stage].cleanup(dev);
	}

	kfree(dev->port);
	ib_dealloc_device(&dev->ib_dev);
}

If lag_event() on ldev->wq checks dev->ib_active just before
__mlx5_ib_remove() sets dev->ib_active =3D false, __mlx5_ib_remove() can
complete MLX5_IB_STAGE_IB_REG cleanup (including flush_workqueue(ib_wq))
before lag_event() calls ib_dispatch_event(&speed_event).

When MLX5_IB_STAGE_ROCE cleanup then calls mlx5_eth_lag_cleanup() ->
mlx5e_lag_event_unregister() -> blocking_notifier_chain_unregister(), it
only waits for lag_event() to finish queuing the work item, not for ib_wq
to execute it. __mlx5_ib_remove() then calls ib_dealloc_device(&dev->ib_dev)
while ib_generic_event_task() is still pending on ib_wq, so
ib_generic_event_task() -> ib_dispatch_event_clients() in
drivers/infiniband/core/device.c can dereference event->device after it has
been freed.

>  	default:
>  		return NOTIFY_DONE;
>  	}
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/=
net/ethernet/mellanox/mlx5/core/lag/lag.c
> index 05e6d0aa31fcf..afe0b9909f2dc 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> @@ -1540,8 +1540,24 @@ static int mlx5_lag_get_devices_oper_speed(struct =
mlx5_lag *ldev,
>  	return 0;
>  }
> =20
> +void mlx5_lag_notify_speed_change(struct mlx5_lag *ldev)
> +{
> +	struct lag_func *pf;
> +	int idx;
> +
> +	idx =3D mlx5_lag_get_dev_index_by_seq(ldev, MLX5_LAG_P1);
> +	if (idx < 0)
> +		return;
> +	pf =3D mlx5_lag_pf(ldev, idx);
> +	if (!pf)
> +		return;
> +	blocking_notifier_call_chain(&pf->dev->priv.lag_nh,
> +				     MLX5_DRIVER_EVENT_LAG_SPEED_CHANGE, NULL);
> +}
> +
>  int mlx5_lag_update_agg_speed(struct mlx5_lag *ldev)
>  {
> +	u32 old_speed;
>  	u32 speed;
>  	int err;
> =20
> @@ -1553,7 +1569,11 @@ int mlx5_lag_update_agg_speed(struct mlx5_lag *lde=
v)
>  		return err;
>  	}
> =20
> +	old_speed =3D READ_ONCE(ldev->agg_speed_mbps);
>  	WRITE_ONCE(ldev->agg_speed_mbps, speed);
> +	if (speed !=3D old_speed)
> +		mlx5_lag_notify_speed_change(ldev);
> +
>  	return 0;
>  }

[Severity: Medium]
In switchdev mode, does notifying here fire IB_EVENT_DEVICE_SPEED_CHANGE
before the eswitch vport speeds have been updated in firmware?

In drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c,
mlx5_lag_set_vports_agg_speed() calls mlx5_lag_update_agg_speed() before
iterating over the PFs to update the vport speeds via
mlx5_lag_modify_device_vports_speed():

drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c:mlx5_lag_set_vports_agg_s=
peed() {
	if (mlx5_lag_update_agg_speed(ldev))
		return;
	...
	mlx5_ldev_for_each(pf_idx, 0, ldev) {
		...
		mlx5_lag_modify_device_vports_speed(mdev, speed);
	}
}

On the switchdev representor ib_device, mlx5_ib_query_port_speed_rep() in
drivers/infiniband/hw/mlx5/main.c only reads the cached bond speed for the
uplink representor port, while non-uplink VF/SF representor ports on the
same ib_device query MLX5_VPORT_STATE_OP_MOD_ESW_VPORT from firmware:

drivers/infiniband/hw/mlx5/main.c:mlx5_ib_query_port_speed_rep() {
	if (rep->vport =3D=3D MLX5_VPORT_UPLINK) {
		if (mlx5_lag_is_sriov(mdev))
			return mlx5_ib_query_port_speed_from_bond(dev,
								  port_num,
								  speed);

		return mlx5_ib_query_port_speed_from_port(dev, port_num,
							  speed);
	}

	op_mod =3D MLX5_VPORT_STATE_OP_MOD_ESW_VPORT;
	return mlx5_ib_query_port_speed_from_vport(dev->mdev, op_mod,
						   rep->vport, true, speed, dev,
						   port_num);
}

If a consumer of the switchdev representor ib_device queries port speeds
upon receiving IB_EVENT_DEVICE_SPEED_CHANGE, could non-uplink representor
ports still return the old max_tx_speed from firmware because
mlx5_lag_modify_device_vports_speed() has not finished yet?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022193053.3815=
866-1-tariqt@nvidia.com?part=3D3
