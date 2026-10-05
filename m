Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5329B47CA6D;
	Mon,  5 Oct 2026 12:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791202468; cv=none; b=YXB0mGyQb5Aax5yr3PtSda3pSvqN9fLMj0h+GbnYGIFo5kMxGvX3IYV3EkMhs8fj9hkc6S4v1MnSiKHBpj27DPKWM5/j/sJm80H6dtSJ8jY1aZClWEXp1rkT1mRU4UG8yqozm03Hmddu4pOkiOE0eGWe533Dw8eVgZx32eBafJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791202468; c=relaxed/simple;
	bh=SNsnIfFnFrv7ERvU9BJmAAQ6b0WKS+QkMy5FSGZnQaU=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QnKlFUewEtxsG8ttr8ytlLRKuTxk24mp0NNlAGb8k8CRmlckkEHcXEUC6GZpzf9qY1TJBqDVlc9xkcxWZJesQ06oBT57+DaD7+f3iU6o1CTzku6iu5uc0PIXahX9WxTJ1ZwveyOK3tQpP57zDumHjPGXaSRheYRWaewRHrqGyFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jbjn4Ezy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jbjn4Ezy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547501F00893;
	Mon,  5 Oct 2026 12:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791202467;
	bh=aVIb7jPoL1eesVxmqEjccrKuhRuUWn1hPHO9OIWOzHc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Jbjn4EzyLfk6iSe19ngfyhCkxM5Q6HPQX2LRWNHWE8CmtRpTFMVCbtUubbWPyeIom
	 Fqe2jTKSkq56cB5Rs6MNOGf7FgTVseekzrlHb0yTSRqX6NYHiZUyO9/QUkrAmwYkfB
	 KrbtrWO+9aPuRbjhNn/IFzszVMOI2jvmlVr+ZoW/hJhklWkF/g3honhDXHphCg6qjJ
	 fPozvqzMFdFxoQ6h9gco3Ce8Db64unHY642FAtFCOhKf+OUBiP4hh+X6lcRx67/Ap3
	 cPU3aL1fbP7q/QqwicW1VDdKAyuGTKPVktRnPCR4nZe6ZKWdKtz3MgjstXl5lVMNvV
	 cjj0hjpiUziyg==
Subject:
 Re: [PATCH net] net/mlx4: shut down catas recovery timer during teardown
From: netdev-bot+sashiko@kernel.org
To: runyu.xiao@seu.edu.cn
Cc: tariqt@nvidia.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, jianhao.xu@seu.edu.cn
Date: Mon, 05 Oct 2026 12:14:25 +0000
Message-ID: <179120246587.434549.3026247098770560135@kernel.org>
In-Reply-To: <20261004121259.1245171-1-runyu.xiao@seu.edu.cn>
References: <20261004121259.1245171-1-runyu.xiao@seu.edu.cn>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 (1) · Medium: 1 · Low: 0 (1)

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The commit message describes a race that the timer core
  already prevents, and the patch carries Fixes: and Cc: stable tags for…

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but device removal
  can deadlock with catas recovery.
- [Low] This problem wasn't introduced by this patch, but on the first-
  ever registration mlx4_stop_catas_poll() can run timer_shutdown_sync()…

--

net/mlx4: shut down catas recovery timer during teardown

This commit changes mlx4_stop_catas_poll() to call timer_shutdown_sync()
instead of timer_delete_sync(), so that poll_catas() cannot re-arm the
catas timer during teardown. The timer is set up again by timer_setup() in
mlx4_start_catas_poll() before it is reused.

> The catas error timer can rearm itself while the device is being
> stopped. If poll_catas() is running when timer_delete_sync() drops the
> timer-base lock, it can call mod_timer() after the deletion. The delete
> can then return with the timer queued again, allowing a subsequent callback
> to access teardown-owned MMIO state after it has been unmapped.

[Severity: Medium]
Can this sequence happen with timer_delete_sync()?

While the callback is running, __try_to_del_timer_sync() does not detach
the timer and returns -1:

kernel/time/timer.c:__try_to_del_timer_sync() {
    ...
	if (base->running_timer != timer) {
		ret = detach_if_pending(timer, base, true);
		if (shutdown)
			timer->function = NULL;
	}
    ...
}

__timer_delete_sync() keeps retrying until that changes:

	do {
		ret = __try_to_del_timer_sync(timer, shutdown);
		if (unlikely(ret < 0)) {
			del_timer_wait_running(timer);
			cpu_relax();
		}
	} while (ret < 0);

So the delete cannot return while poll_catas() is still running. After the
callback finishes, the next retry calls detach_if_pending() under the base
lock. That removes the timer that poll_catas() re-queued with mod_timer().

__mod_timer() also does not move a running timer to another base:

	if (likely(base->running_timer != timer)) {

The comment there says this lets timer_delete_sync() detect that the
handler has not finished yet. The timer_delete_sync() kerneldoc only rules
out add_timer_on() from the handler, and poll_catas() re-arms only with
mod_timer().

So timer_shutdown_sync() does not seem to change runtime behaviour for
this timer. The only other place that arms it is mlx4_start_catas_poll(),
and that calls timer_setup() first.

Could the race description and the Fixes: and Cc: stable tags be dropped,
with the change described as hardening instead? Or is there a different
re-arm path that the commit message should name?

> diff --git a/drivers/net/ethernet/mellanox/mlx4/catas.c b/drivers/net/ethernet/mellanox/mlx4/catas.c
> index edcc6f6626180..62574b790fd59 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/catas.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/catas.c
> @@ -305,7 +305,7 @@ void mlx4_stop_catas_poll(struct mlx4_dev *dev)
>  {
>  	struct mlx4_priv *priv = mlx4_priv(dev);
>  
> -	timer_delete_sync(&priv->catas_err.timer);
> +	timer_shutdown_sync(&priv->catas_err.timer);

[Severity: Low]
This isn't a bug introduced by this patch, but can this run on a
catas_err.timer that was never initialized?

On the first registration, mlx4_register_device() sets
MLX4_INTERFACE_STATE_UP before calling rescan_drivers_locked(). If
add_drivers() fails, it unregisters before mlx4_start_catas_poll() has
called timer_setup():

drivers/net/ethernet/mellanox/mlx4/intf.c:mlx4_register_device() {
    ...
	if (ret) {
		mlx4_unregister_device(dev);
		return ret;
	}

	mlx4_start_catas_poll(dev);
    ...
}

mlx4_unregister_device() only checks STATE_UP before calling
mlx4_stop_catas_poll(). That then calls timer_shutdown_sync() on a timer
that devlink_alloc() zeroed but timer_setup() never initialized.

Production kernels see no effect. With CONFIG_LOCKDEP, the zeroed
lockdep_map triggers a "trying to register non-static key" splat and
lockdep is turned off. With CONFIG_DEBUG_OBJECTS_TIMERS, debug_assert_init()
emits an ODEBUG warning. timer_delete_sync() behaved the same way before
this patch.

[Severity: High]
This is a pre-existing issue, but can device removal deadlock against
catas_work in this function?

mlx4_remove_one() takes devl_lock(devlink), sets
MLX4_INTERFACE_STATE_DELETION, and calls mlx4_unload_one() while still
holding the lock. That path reaches the flush here:

mlx4_remove_one()
  devl_lock(devlink)
  mlx4_unload_one()
    mlx4_unregister_device()
      mlx4_stop_catas_poll()
        flush_workqueue(dev->persist->catas_wq)

If the interface is already down, mlx4_catas_end() drains the same
workqueue through destroy_workqueue().

If poll_catas() has already queued catas_work, the worker first runs the
device reset. That can take a long time; the VF reset loop alone can run
for up to MLX4_COMM_TIME (10000 ms). Only then does the worker take the
devlink lock, before it checks DELETION:

drivers/net/ethernet/mellanox/mlx4/catas.c:mlx4_handle_error_state() {
	mlx4_enter_error_state(persist);
	devlink = priv_to_devlink(mlx4_priv(dev));
	devl_lock(devlink);
	mutex_lock(&persist->interface_state_mutex);
	if (persist->interface_state & MLX4_INTERFACE_STATE_UP &&
	    !(persist->interface_state & MLX4_INTERFACE_STATE_DELETION)) {
    ...
}

The remover waits for the work to finish, and the work waits for the
devlink lock that the remover holds. Neither wait has a timeout.

timer_shutdown_sync() only prevents future timer runs, so work that is
already queued is not covered. Could catas_wq be drained without holding
the devlink lock? Alternatively, mlx4_handle_error_state() could check
DELETION before calling devl_lock().

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261004121259.1245171-1-runyu.xiao%40seu.edu.cn
