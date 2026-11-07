Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794083082;
	b=ROW9obSMw4kTbjwiFCPCk9O83drTTQGgyGkuoyE+7gp2K27Sn7P4NzGCICodtUuy2Rlb
	 JItFIJUcqoH1fxBv7fh4h3MLMj7pyzCze0BnOch/wk6hYQUAofo96T5dbvLtZRU6eQxzG
	 cSDP8SRJK+yqNOr+W6U58zFCceeg0edwDlqKikEemKErTbwJGGOcUoIsbYBE79IMAZAiC
	 CE81651CkETfN/w+w7PstqxzLv/NUwDIhB9J5zS4jMy4/J++unv3Ikhbzf1pUDR1d6IaH
	 GWJXNPM/E1upwDz7gL37OrclfrmvifBzydnPRpRJjIJbjbrNJw7It+K50MyckntW3kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794083082;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Yre4GilkIAFAcudSjzMPk/UneKEQo+pn5RJtt75meX8=;
	b=H2gYlX5NC+IlRhBEpAM3OyUjZ+Dxk1L/CmjQvyg2qnWZqx4tYFW5Y4SBnomyy26IqG1q
	 rjjuEztr5pRm4EobhzquG8MNQTxEh/QYiBTNQYUkyYKHx9bzwcsvLdAoQ9RVXDI5vtxzm
	 UU0wgK6xvnU6IjQu2wGbd0r/cw+KN4RATArrwlM81rzA/Tz9or/skjaoxeNAn7/27Cskm
	 F7a5axTKSvQi3bHq+LGm0Q/ZELxl3zcXaZxyq3epkpodEaIR5V06WLDAX8ITU/hlqZbTq
	 xfaP+gp/O2Kw5ocpgWAxb5zCMFGC2qCMjHkKTQQRbGgxZUu47xjHH8x/DiccODLZOCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GtPk4ZQo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF1F606A334;
	Sat,  7 Nov 2026 20:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GtPk4ZQo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF631F0089F;
	Sat,  7 Nov 2026 20:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794083081;
	bh=Yre4GilkIAFAcudSjzMPk/UneKEQo+pn5RJtt75meX8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=GtPk4ZQoJLISAQNDyu84x0tPZKAtqAZhXUJCfLiXCRLZ+8EXUAmPcBlLc8sLMNkV3
	 A4vIz9CNM3jpee3MX4Gk9VSRLljWX0Ofbq534V2xAGQYj2/rYhK/hVtpYGU1r6YX3N
	 KHqfuIOCQlf8Kbo+eBgIcEp5Yr42c4G/SWPvv1d9RhtRZJhUJoKo2h5Dnv+eRMi2OZ
	 ulfZO/wsYeJcePP1v3l5hTVjT//oGDthCC0CULcS8jWFg9ZAXEhF+4oZZyx8ODBZMy
	 EVBZxowoIsr7NizvFofOVcvA5UtFHbflBA1MNyBlhQR4H3pegYTbKlfsvtyTWjH3bn
	 BTdvJOyl3RJJw==
Subject:
 Re: [PATCH rdma-next 01/23] net/mlx5: Add mlx5_trigger_health_work_force()
From: netdev-bot+sashiko@kernel.org
To: yishaih@nvidia.com
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org,
 netdev@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, kuba@kernel.org, pabeni@redhat.com, edumazet@kernel.org,
 davem@davemloft.net, andrew+netdev@lunn.ch, dtatulea@nvidia.com,
 moshe@nvidia.com, maorg@nvidia.com
Date: Sat, 07 Nov 2026 20:24:40 +0000
Message-ID: <179408308027.994134.17949886966516055410@kernel.org>
In-Reply-To: <20261103163949.1554-2-yishaih@nvidia.com>
References: <20261103163949.1554-2-yishaih@nvidia.com>
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

Thank you for your contribution! Sashiko AI review found 6 potential
issue(s) to consider.

Critical: 0 · High: 2 · Medium: 2 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The forced path in mlx5_fw_fatal_reporter_err()
  (drivers/net/ethernet/mellanox/mlx5/core/health.c) tries only…
- [High] net/mlx5: forced health work recovers device when interface is
  already down
- [Medium] Nothing deduplicates force_fatal_report_work against
  fatal_report_work or against the device state.
- [Medium] A forced request is dropped with no record or retry if
  force_fatal_report_work runs while MLX5_DROP_HEALTH_WORK is set only…
- [Low] The patch changes the existing sensor-triggered recovery path
  (fatal_report_work, forced=false) in mlx5_fw_fatal_reporter_err().
- [Low] A forced, consumer-detected fault goes through the same devlink
  fw_fatal reporter path as a real firmware-fatal error.

--

net/mlx5: Add mlx5_trigger_health_work_force()

This adds mlx5_trigger_health_work_force(). It queues a new
force_fatal_report_work that runs the fatal health recovery with the error
state forced, whatever the health sensors report. Before forcing the error
state, the forced path stops the health poller and issues a fast teardown
of the HCA under intf_state_mutex. The function is exported for mlx5_ib,
which uses it later in the series.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
> index aeeb136f5ebc7..d000ac335fa7a 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
> @@ -627,18 +627,11 @@ mlx5_fw_fatal_reporter_dump(struct devlink_health_reporter *reporter,
>  	return err;
>  }
>  
> -static void mlx5_fw_fatal_reporter_err_work(struct work_struct *work)
> +static void mlx5_fw_fatal_reporter_err(struct mlx5_core_dev *dev, bool forced)
>  {

[ ... ]

>  	mutex_lock(&dev->intf_state_mutex);
>  	if (test_bit(MLX5_DROP_HEALTH_WORK, &health->flags)) {
> @@ -646,8 +639,26 @@ static void mlx5_fw_fatal_reporter_err_work(struct work_struct *work)
>  		mutex_unlock(&dev->intf_state_mutex);
>  		return;
>  	}

[Severity: Medium]
Can a forced request get lost here? If force_fatal_report_work runs while
MLX5_DROP_HEALTH_WORK is set only for a while, mlx5_fw_fatal_reporter_err()
logs "health works are not permitted at this stage" and returns. The
request is not recorded and not retried.

The FW sync reset flow opens such a window.
mlx5_sync_reset_set_reset_requested() sets the bit without holding
intf_state_mutex:

	mlx5_stop_health_poll(dev, true);

On abort or timeout, mlx5_sync_reset_clear_reset_requested() clears it
again:

	if (poll_health)
		mlx5_start_health_poll(dev);

A dropped sensor fault is caught again by the next poll_health(). A forced
fault cannot be, because the sensors never see it. So dev->state stays
MLX5_DEVICE_STATE_UP. The kernel-doc of mlx5_trigger_health_work_force()
says this API exists to prevent exactly that.

In the mlx5_ib consumer later in this series, umrc->state is already
MLX5_UMR_STATE_ERR at this point, and cq->poll_one is already
mlx5_ib_poll_one_stopped. The UMR waiters in mlx5r_umr_post_send_wait()
depend on the internal error flush to wake them, and they wait with no
timeout:

	wait_for_completion(&umr_context.done);

If the forced request is dropped this way, would those waiters hang
forever?

> +	/*
> +	 * The firmware might still be running, so stop it first. Do it under
> +	 * intf_state_mutex and only while UP, so the cmd interface is valid.
> +	 */
> +	if (forced && test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state)) {
> +		int err;
> +
> +		mlx5_stop_health_poll(dev, false);
> +		err = mlx5_cmd_fast_teardown_hca(dev);
> +		if (err)
> +			mlx5_core_err(dev, "Failed to stop the device before forcing the error state, err %d\n",
> +				      err);
> +	}

[Severity: High]
What happens here when MLX5_INTERFACE_STATE_UP is already clear? The
forced branch skips mlx5_stop_health_poll() and
mlx5_cmd_fast_teardown_hca(), but the function does not bail out. It
still calls enter_error_state(dev, true) and then continues into
mlx5_health_try_recover() or devlink_health_report().

A non-remove unload leaves the device in exactly that state.
mlx5_unload_one_devl_locked() does:

	clear_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state);
	mlx5_unload(dev);
	mlx5_function_teardown(dev, false);

mlx5_function_disable(dev, false) then calls
mlx5_stop_health_poll(dev, false), so MLX5_DROP_HEALTH_WORK is never
set. mlx5_suspend() and mlx5_devlink_reload_down() take this path.
mlx5_pci_err_detected() takes it too, before it drains the health wq.
None of them cancel force_fatal_report_work.

Suppose a consumer calls mlx5_trigger_health_work_force() just before
or during one of those unloads. The work runs once intf_state_mutex is
released. It finds MLX5_DROP_HEALTH_WORK clear and the interface down.
It then forces MLX5_DEVICE_STATE_INTERNAL_ERROR on a device whose cmd
interface mlx5_cmd_disable() has already shut down. The recovery then
runs:

mlx5_health_try_recover()
  mlx5_handle_bad_state()
    /* sensors clean, NIC never disabled by fast teardown */
    mlx5_disable_device()
      mlx5_error_sw_reset()
        /* can poll up to PCI_TOGGLE timeout for IFC disabled */
  mlx5_recover_device()
    mlx5_pci_slot_reset()
    mlx5_load_one_devl_locked(dev, true)

Does that reset and reload a device that was just suspended or
unloaded on purpose?

Devlink reload is affected as well. devl_lock is held from reload_down
to reload_up, so the work blocks on devl_lock, either directly or
inside devlink_health_report(), until reload_up has loaded the device
again. The work then forces the error state on the freshly reloaded,
healthy device and recovers it. If the report lands inside the
graceful period, it unloads the device with
mlx5_unload_one(dev, false) instead.

Should the forced path unlock and return when the interface is not UP,
instead of only skipping the teardown? Or should the non-remove unload
paths cancel force_fatal_report_work?

[Severity: High]
What happens here when mlx5_cmd_fast_teardown_hca() fails? It returns
-EOPNOTSUPP at once when MLX5_CAP_GEN(dev, fast_teardown) is 0. It can also
return -EIO, -EACCES or a command error. The failure is only logged, and
enter_error_state(dev, true) runs anyway. The HCA can then still be in
FULL_DRIVER mode with bus mastering enabled when dev->state becomes
MLX5_DEVICE_STATE_INTERNAL_ERROR.

>From that point, mlx5_internal_err_ret_value() fakes success for
TEARDOWN_HCA, DISABLE_HCA and the DESTROY_* commands. MANAGE_PAGES fails
with -ENXIO, so reclaim_pages_cmd() reclaims the firmware pages in
software:

	/* No hard feelings, we want our pages back! */

The recovery then runs:

mlx5_health_try_recover()
  mlx5_handle_bad_state()
    /* only warns "Expected to see disabled NIC but it is full driver" */
    mlx5_disable_device()
      mlx5_error_sw_reset()
        /* sensors are clean: no SW reset, only "NIC IFC still" logged */
      mlx5_unload_one_devl_locked()
        /* frees EQ/CQ/QP/RQ buffers and ICM pages */
  mlx5_recover_device()
    mlx5_pci_disable_device()   /* skipped for SFs */

Can the still-running HCA DMA into the freed queue buffers and ICM pages
before bus mastering is cleared? On the -ECANCELED branch,
mlx5_unload_one(dev, false) frees everything and the device is never
disabled.

Compare mlx5_try_fast_unload(). It falls back to force teardown and
enters the error state only after a teardown has succeeded:

	ret = mlx5_cmd_fast_teardown_hca(dev);
	if (!ret)
		goto succeed;

	ret = mlx5_cmd_force_teardown_hca(dev);
	if (!ret)
		goto succeed;
	...
	mlx5_start_health_poll(dev);
	return ret;

Does this path need a mlx5_cmd_force_teardown_hca() fallback, or bus
mastering cleared before the error state is forced? The commit message
says the work asks the firmware to stop "as the device might still be
running", but that does not happen when fast teardown is unsupported or
fails.

> +
> +	/*
> +	 * Enter the error state before unlocking, or an unload could send
> +	 * TEARDOWN_HCA to the stopped NIC, fail and skip function disable.
> +	 */
> +	enter_error_state(dev, forced);
>  	mutex_unlock(&dev->intf_state_mutex);
> -	enter_error_state(dev, false);

[Severity: Low]
This also changes the existing sensor-triggered path (fatal_report_work,
forced == false). enter_error_state(dev, false) runs mlx5_cmd_flush() and
the MLX5_DEV_EVENT_SYS_ERROR notifier chain. It used to run after
mutex_unlock(&dev->intf_state_mutex). It now runs with the mutex held, for
every firmware fatal recovery.

mlx5_enter_error_state() already calls enter_error_state() under the same
mutex, so this doesn't look like a deadlock. However, the new comment and
the commit message explain the move only for the forced case.

Could the commit message say that the non-forced path changes too?

>  	if (IS_ERR_OR_NULL(health->fw_fatal_reporter)) {
>  		devl_lock(devlink);
>  		if (mlx5_health_try_recover(dev))
> @@ -669,6 +680,33 @@ static void mlx5_fw_fatal_reporter_err_work(struct work_struct *work)
>  	}
>  }
>  

[ ... ]

> +static void mlx5_fw_fatal_reporter_force_err_work(struct work_struct *work)
> +{
> +	struct mlx5_core_health *health;
> +	struct mlx5_core_dev *dev;
> +	struct mlx5_priv *priv;
> +
> +	health = container_of(work, struct mlx5_core_health,
> +			      force_fatal_report_work);
> +	priv = container_of(health, struct mlx5_priv, health);
> +	dev = container_of(priv, struct mlx5_core_dev, priv);
> +
> +	mlx5_fw_fatal_reporter_err(dev, true);
> +}

[Severity: Low]
With forced == true, mlx5_fw_fatal_reporter_err() still reports through
the fw_fatal reporter as a firmware fatal error:

	fw_reporter_ctx.err_synd = health->synd;
	fw_reporter_ctx.miss_counter = health->miss_counter;
	if (devlink_health_report(health->fw_fatal_reporter,
				  "FW fatal error reported", &fw_reporter_ctx) == -ECANCELED) {

health->synd and health->miss_counter are firmware sensor values that have
nothing to do with the forced fault, and health->fatal_error is not set.
Will devlink health output show a firmware fatal event with a stale or zero
syndrome, and nothing that points to the consumer that triggered it?

Each forced event also counts toward the fw_fatal reporter's graceful
period. A second forced trigger inside that period (60s on a PF) makes
devlink_health_report() return -ECANCELED, and the driver then calls
mlx5_unload_one(dev, false). Should the commit message describe this?

[ ... ]

> @@ -759,6 +797,25 @@ void mlx5_trigger_health_work(struct mlx5_core_dev *dev)
>  		queue_work(health->wq, &health->fatal_report_work);
>  }
>  

[ ... ]

> +void mlx5_trigger_health_work_force(struct mlx5_core_dev *dev)
> +{
> +	struct mlx5_core_health *health = &dev->priv.health;
> +
> +	if (!mlx5_dev_is_lightweight(dev))
> +		queue_work(health->wq, &health->force_fatal_report_work);
> +}

[Severity: Medium]
Does anything deduplicate this against fatal_report_work, or check
dev->state? The two are separate work items on the ordered health->wq, so
queue_work() never merges them. The recovery path (mlx5_disable_device()
and mlx5_recover_device()) does not drain health->wq.

The forced branch in mlx5_fw_fatal_reporter_err() checks only
MLX5_DROP_HEALTH_WORK and MLX5_INTERFACE_STATE_UP. The peer helpers refuse
to run on a device that is already in error:

mlx5_enter_error_state():
	if (!err_detected && dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
		goto unlock;/* a previous error is still being handled */

mlx5_try_fast_unload():
	if (dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR) {
		mlx5_core_dbg(dev, "Device in internal error state, giving up\n");
		return -EAGAIN;
	}

Suppose poll_health() has already set MLX5_DEVICE_STATE_INTERNAL_ERROR
and queued fatal_report_work while the forced work is pending.
mlx5_internal_err_ret_value() fakes TEARDOWN_HCA as a success.
mlx5_cmd_fast_teardown_hca() then writes the iseg NIC state and polls for
up to the TEARDOWN timeout on a device in firmware fatal state. Later, the
queued fatal_report_work handles the same fault again on the device that
was just recovered.

The other order is also possible. A forced work queued while
fatal_report_work is recovering runs on the freshly loaded, healthy device.
It fast-tears it down and forces the error state.

In both orders, the second devlink_health_report() falls inside the
graceful period and returns -ECANCELED. mlx5_unload_one(dev, false) then
leaves the device unloaded instead of recovered. Is that intended?

The mlx5_ib consumer in this series switches cq->poll_one to
mlx5_ib_poll_one_stopped before it triggers, so a single UMR CQ cannot
trigger twice. A sensor fault and a forged CQE close together would still
be enough, for example when mlx5_ib_poll_cq() passes its mdev->state check
just before poll_health() sets the error state.

> +EXPORT_SYMBOL_GPL(mlx5_trigger_health_work_force);

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261103163949.1554-1-yishaih%40nvidia.com
