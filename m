Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793046733;
	b=ubUA4jqJfp8hp8lMjY8Nirmtxg5bLZK/iDIJsjtSwcorV+0tQkeNZfQLeTeEIYTImSfG
	 mVyU6oe6O2OBZsbXIn8oPFnPeQ35wxvCUvCfv3jwEtWNObxTSg/KGcu1t1Sjjg9tAi1JQ
	 fl1C++UQM/9/ApjtD7ocy16niHyjzf6VimZQTVg/Au40wDuJW3nminC40Ag5Mw4jCF24Z
	 yFi4akkhPigdQSFyVKcO6pIFGLkyfiNGL4FhN5WS0cQ4qPooxIGMInzkE0f64y+gxHXvg
	 xZrbHqwcx6X/hjTtYtTSG4tqXoTMQRGHhcCbsVLGEXL6SGpPEv3rvoy8FtDSn5Ul7Lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793046733;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=WLSSNphe2t25gveuhQlDdNE5rvwvF50Zw1dxiVqEoXc=;
	b=mXndlytUsNMSmE/QpUBpYC2ZRpKdivTXHaaZSn/UFTPcudCM3QBG/nhvTIowZFyCllIi
	 KzqosmLukg2Oq6hfIw1zCfbGIjFNn21Cbd1nDaEfWHpU1IQq5T5eM7EYEr1lgvetcqZIm
	 6ZHAmf5GHB2MjGYFtY15vP7Fue9pJpDuyaIUiifmZKZVo+A8A2a64r2DzbgSm1JYZ4De6
	 GNixwB8ap+jDnTNg/4d4AcFMp7nFW/tClCDl0hvmzIEGr807kFdjLrfBv3qufmxyaZOMw
	 Zw9Od2tOMdJ4QPwhBIqrejGjSCPEM57sZtaxerE6OUv7U5ydgBvYDVix4569iSHYe3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NlJm4Ssb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8314F606A325;
	Mon, 26 Oct 2026 20:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NlJm4Ssb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1C71F01825;
	Mon, 26 Oct 2026 20:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793046733;
	bh=WLSSNphe2t25gveuhQlDdNE5rvwvF50Zw1dxiVqEoXc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=NlJm4SsbnT2kYHfVsAjuTwIhlcJuf8HmYODezDTZ4SxaYuxCOD2yvPsaCRqIg1Ngw
	 p9qvUFOu4NhHnpH8xCZNevt6UJBjy//5kFuy9VXLLMZYGbexQwA4oRP80VylLjt6qT
	 ZBVd5U59ephkf44s8ZOc49vvB0HdEgsGXQsu3SySQkcFZE55pSPEjGU3xgptrfQIpS
	 diDGoXeTF3vyqsqpoUvOeRd842+zfprSLsKJ04G7RINGdUakh5hCgW8myCKOIe0Aak
	 seXt+lLZU0wzgH0ClLNgkcqTbDKyd3G6bMV1rJAeZq0ZZutIs/rwDBvJA54uWkNXA9
	 g17TRina2ajPw==
Subject: Re: [PATCH net V2 3/4] {RDMA,net}/mlx5: notify IB uplink on LAG
 aggregate speed change
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 bhelgaas@google.com, cjubran@nvidia.com, cratiu@nvidia.com,
 edwards@nvidia.com, gal@nvidia.com, jgg@ziepe.ca, kees@kernel.org,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
 linux-rdma@vger.kernel.org, msanalla@nvidia.com, mbloch@nvidia.com,
 ohartoov@nvidia.com, saeedm@nvidia.com, shayd@nvidia.com
Date: Mon, 26 Oct 2026 20:32:11 +0000
Message-ID: <179304673172.3134.1508256184291095453@kernel.org>
In-Reply-To: <20261022193053.3815866-4-tariqt@nvidia.com>
References: <20261022193053.3815866-4-tariqt@nvidia.com>
X-sashiko-severity: High
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

Critical: 0 · High: 2 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The fix does not reach the IB uplink device in non-shared-FDB
  switchdev (SRIOV) LAG, although the commit message says it fixes the…
- [High] Use-after-free of struct ib_device through async event work
  queued by the new MLX5_DRIVER_EVENT_LAG_SPEED_CHANGE handler.
- [Medium] net/mlx5: LAG speed change notified before updating eswitch
  vport speeds

--

{RDMA,net}/mlx5: notify IB uplink on LAG aggregate speed change

This patch raises IB_EVENT_DEVICE_SPEED_CHANGE on the IB uplink device
when the cached LAG aggregate speed changes. mlx5_lag_update_agg_speed()
now calls a new helper, mlx5_lag_notify_speed_change(). The helper sends
MLX5_DRIVER_EVENT_LAG_SPEED_CHANGE on the P1 PF's lag_nh chain, and
lag_event() in mlx5_ib turns it into an IB async event.

> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index 6594d38cf1993..cfa7c7ba2b737 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -3690,6 +3690,16 @@ static int lag_event(struct notifier_block *nb, unsigned long event, void *data)
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

[Severity: High]
Can the work queued here outlive the ib_device?

ib_dispatch_event() copies the event, including the raw ibdev pointer,
into an ib_update_work and queues it on ib_wq. It takes no reference on
the device. Nothing synchronizes the dev->ib_active check with
__mlx5_ib_remove():

__mlx5_ib_remove() {
	dev->ib_active = false;

	/* Number of stages to cleanup */
	while (stage) {
		stage--;
		if (profile->stage[stage].cleanup)
			profile->stage[stage].cleanup(dev);
	}

	kfree(dev->port);
	ib_dealloc_device(&dev->ib_dev);
}

The stages are cleaned up in reverse order. In pf_profile and
raw_eth_profile, MLX5_IB_STAGE_IB_REG comes after MLX5_IB_STAGE_ROCE.
That means ib_unregister_device() runs first, including its last
flush_workqueue(ib_wq) in ib_cache_cleanup_one(). Only after that does
mlx5_eth_lag_cleanup()->mlx5e_lag_event_unregister() run.

One possible ordering:

CPU1 (bond work or mlx5_mpesw_speed_update_work, holding ldev->lock)
mlx5_lag_update_agg_speed()
  mlx5_lag_notify_speed_change()
    blocking_notifier_call_chain()      /* down_read(&lag_nh.rwsem) */
      lag_event()
        sees dev->ib_active == true
        <preempted>

CPU2 (rmmod mlx5_ib or auxiliary unbind)
__mlx5_ib_remove()
  dev->ib_active = false;
  mlx5_ib_stage_ib_reg_cleanup()
    ib_unregister_device()              /* last ib_wq flush */
  mlx5_eth_lag_cleanup()
    mlx5e_lag_event_unregister()
      blocking_notifier_chain_unregister()   /* waits on rwsem */

CPU1
        ib_dispatch_event()
          queue_work(ib_wq, &work->work);
    up_read(&lag_nh.rwsem)

CPU2
  ib_dealloc_device()
    ... ib_device_release()
      kfree_rcu(dev, rcu_head);

ib_wq worker
ib_generic_event_task()
  ib_dispatch_event_clients()
    down_read(&event->device->event_handler_rwsem);   /* freed */

The commit message says:

    blocking_notifier_chain_unregister() in mlx5_eth_lag_cleanup() takes the
    write side and cannot return until any in-flight callback has completed,
    so no event can be dispatched to a freed device after unregistration.

The rwsem waits for lag_event() to return. Does it also wait for the
ib_wq work that lag_event() queued? Nothing seems to flush ib_wq after
mlx5e_lag_event_unregister().

The existing mlx5_ib_event path seems to avoid this, because its
DEVICE_NOTIFIER stage is torn down before IB_REG. The last patch in this
series doesn't appear to change this path.

> +		break;
> +	}
>  	default:
>  		return NOTIFY_DONE;
>  	}
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> index 05e6d0aa31fcf..afe0b9909f2dc 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> @@ -1540,8 +1540,24 @@ static int mlx5_lag_get_devices_oper_speed(struct mlx5_lag *ldev,
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

[Severity: Medium]
Is the event sent before the vports it describes have been updated?

mlx5_lag_set_vports_agg_speed() calls mlx5_lag_update_agg_speed()
first. Only after that does it walk the PFs and push the new
max_tx_speed to each eswitch vport with MODIFY_VPORT_STATE:

mlx5_lag_set_vports_agg_speed() {
	if (mlx5_lag_update_agg_speed(ldev))
		return;
	...
	mlx5_ldev_for_each(pf_idx, 0, ldev) {
		...
		mlx5_lag_modify_device_vports_speed(mdev, speed);
	}
}

With this patch, mlx5_lag_update_agg_speed() calls
mlx5_lag_notify_speed_change() as soon as agg_speed_mbps is written.
So lag_event() queues IB_EVENT_DEVICE_SPEED_CHANGE on ib_wq while the
FW vport state still holds the old speed. This applies to
mlx5_do_bond(), mlx5_mpesw_speed_update_work() and
mlx5_lag_shared_fdb_create(), which all go through
mlx5_lag_set_vports_agg_speed().

On the switchdev representor ib_device, only the uplink port reads the
cached aggregate. The VF/SF representor ports on the same ib_device
query FW instead:

mlx5_ib_query_port_speed_rep() {
	if (rep->vport == MLX5_VPORT_UPLINK) {
		if (mlx5_lag_is_sriov(mdev))
			return mlx5_ib_query_port_speed_from_bond(...);
		...
	}

	op_mod = MLX5_VPORT_STATE_OP_MOD_ESW_VPORT;
	return mlx5_ib_query_port_speed_from_vport(dev->mdev, op_mod,
						   rep->vport, ...);
}

A consumer could handle the event and query ports 2..N before the
mlx5_lag_modify_device_vports_speed() loop has finished. It would then
read a stale max_tx_speed. I couldn't find anything that raises a
second IB_EVENT_DEVICE_SPEED_CHANGE on the representor ib_device once
the loop completes. In that case the stale value would be all the
consumer ever sees for that change.

The commit message says:

    That cache is where the IB layer now takes the effective speed
    from, so a consumer that queries after receiving the event is
    guaranteed to read the new value.

That holds for the uplink port. Does it hold for the other
representor ports on the same device?

Could the notification be sent from mlx5_lag_set_vports_agg_speed()
after the vport loop, instead of from mlx5_lag_update_agg_speed()? Or
is there a reason the event has to be raised before the vports are
updated? Any callers of mlx5_lag_update_agg_speed() outside
mlx5_lag_set_vports_agg_speed(), such as RoCE LAG, would presumably
still need their own notification.

[Severity: High]
Does this event reach the IB uplink device in switchdev (SRIOV) LAG
when shared FDB is not used? That is the case when
mlx5_lag_shared_fdb_supported() returns false and mlx5_do_bond() takes
the mlx5_activate_lag(..., MLX5_LAG_MODE_SRIOV, false) branch.

The event only goes to P1's lag_nh. mlx5_eth_lag_init() registers
lag_events only if LAG is already active when the IB device
initializes:

mlx5_eth_lag_init() {
	...
	ns = mlx5_get_flow_namespace(mdev, MLX5_FLOW_NAMESPACE_LAG);
	if (!ns || !mlx5_lag_is_active(mdev))
		return 0;
	...
	mlx5e_lag_event_register(dev);
	...
}

IB reps are loaded when switchdev mode is enabled, which is before the
bond forms. The non-shared-FDB branch of mlx5_do_bond() doesn't reload
or rescan the IB devices. Only the RoCE LAG and shared FDB paths do:

mlx5_do_bond() {
	...
		if (!shared_fdb)
			mlx5_lag_set_vports_agg_speed(ldev);
	} else if (mlx5_lag_should_modify_lag(ldev, do_bond)) {
		mlx5_modify_lag(ldev, &tracker);
		mlx5_lag_set_vports_agg_speed(ldev);
	...
}

mlx5_create_lag() also reinitializes the chain when LAG is activated,
which drops any earlier subscriber:

	BLOCKING_INIT_NOTIFIER_HEAD(&dev0->priv.lag_nh);

Without shared FDB, mlx5_ib_vport_rep_load() also leaves lag_master
pointing at the PF itself. So each PF's uplink IB device has
ibdev->mdev set to its own PF. A P2 uplink device would subscribe to
P2's lag_nh, if it subscribed at all, so an event sent only to P1 could
not reach it.

These uplink devices still report the cached aggregate, because
mlx5_ib_query_port_speed_rep() doesn't check for shared FDB:

	if (rep->vport == MLX5_VPORT_UPLINK) {
		if (mlx5_lag_is_sriov(mdev))
			return mlx5_ib_query_port_speed_from_bond(dev,
								  port_num,
								  speed);

In this setup, wouldn't the uplink IB device still get only the
immediate physical-port event, possibly before agg_speed_mbps is
updated, and nothing once the aggregate settles? That is the behavior
the commit message says it fixes:

    The uplink vport is deliberately skipped when pushing the aggregate
    speed, so the IB uplink device never gets a second event once the
    aggregate has settled.

Could the notification go through a chain on each PF that every mlx5_ib
device is always subscribed to, instead of only P1's lag_nh? The later
patch in this series, "net/mlx5: Lag, save and restore vport
max_tx_speed across LAG", doesn't appear to touch the notification path.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261022193053.3815866-1-tariqt%40nvidia.com
