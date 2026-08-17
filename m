Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB7C3AF665;
	Mon, 17 Aug 2026 22:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787007335; cv=none; b=BcQcy0g2gKWMBSrdxCVGAc/nHkdTfsqB5YWqBYsFGvYinmzx+KXoM4aTKnKJx5TIcnSrYrauqTOabopPVNM8YvgocP7NauPNzSktAjamDL1Aiimt2F7zA9S42YQbIgC37iE53A8ba6TudS56H/ilkVt2mqLbgcn5j9Gy9ijVu28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787007335; c=relaxed/simple;
	bh=WvR1A718VoIJDUlE8QMl+7RzBad04csBhSiQi/jCrRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQakb4y3F1XsRGtO4G+Dsp4YjTglCWfRr+UDJpuqC3ZNVDtMbVZrPJHmiMwOukmbwMmYc5pY5O9/9rCMM8CJ811pTbg74TY3kYRxyib2s1cUAeHXIF3Ip/F3jTboHiEFKVZYPTweilqFgGS3r89Rd1o38/GVfGp1/nKb+EOlN/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nWNpezYK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nWNpezYK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4518A1F000E9;
	Mon, 17 Aug 2026 22:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787007333;
	bh=/IgWqQdHp6uzoRHSOYekL5iMUqiQQaj+SX+TKRQ6Chs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nWNpezYK1sbqog1hn6ULWX4BXH8LXkCqpAS6LAssn0h0+b9RSfPOlkTwB3O50q9aL
	 xVqJIu+AE6L4eUNx9KqgJ+gfG8ycGfcamYdgp/GG4bT7Nu7aIbdJXb/nI+PMaU+2hv
	 /Vuod3zrxX7POGr++4/cu8MgDB2sxn4nw766ivFlDbl1E9yUk9VHA9t1GNeJZ2dShv
	 WdZerHa0N9lpBNSZYc39sTzRLlti/CoFzc5kvHGC0XSr6jS0ECsHMRuYS8j+eLk4Az
	 sc0cSuDR/ThxiHOGBQdj6p85T4A6OV/lWbu79UtEQR0wXYm5vt+F+8GCwjh3o+OFrV
	 yajQBccjfcEnQ==
From: Jakub Kicinski <kuba@kernel.org>
To: tariqt@nvidia.com
Cc: Jakub Kicinski <kuba@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	frederic@kernel.org,
	gal@nvidia.com,
	leon@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	lirongqing@baidu.com,
	liyongkang01@baidu.com,
	mbloch@nvidia.com,
	paulmck@kernel.org,
	saeedm@nvidia.com
Subject: Re: [PATCH net-next V3] net/mlx5: Expedite notifier unregistration during device teardown
Date: Mon, 17 Aug 2026 15:55:31 -0700
Message-ID: <20260817225531.3703332-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260811062837.3196902-1-tariqt@nvidia.com>
References: <20260811062837.3196902-1-tariqt@nvidia.com>
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
net/mlx5: Expedite notifier unregistration during device teardown

This adds a new exported core helper,
atomic_notifier_chain_unregister_expedited(), which unlinks the notifier
block and then calls synchronize_rcu_expedited() instead of
synchronize_rcu().  Three mlx5 helpers (EQ notifier, FW event notifier,
IRQ notifier) are converted to it.

A few questions below about the commit message scope, the new API's
documented contract, and the expedited grace period being taken once per
notifier block.

> net/mlx5: Expedite notifier unregistration during device teardown
>
>     During device hot-unplug, the mlx5 driver expects quickly unregister
>     notification chains.
> ...
>     Introduce atomic_notifier_chain_unregister_expedited() to leverage
>     synchronize_rcu_expedited(), and use it significantly reducing wait
>     times in the following paths:
>      - Event Queue (EQ) notifier chain
>      - Firmware event notifier chain
>      - IRQ notifier chain

[Severity: Medium]
The change is described as a device hot-unplug optimization, but the
conversion happens inside three generic exported helpers with no gating on
teardown state, so every caller now takes an expedited grace period.  Could
the message be extended to cover the runtime paths that are affected too?

Verified non-hot-unplug callers include mlx5_cmd_use_polling() on command
mode switches, mlx5e_disable_async_events() on netdev close,
mlx5_eswitch_disable_locked() and mlx5_eswitch_event_handler_unregister()
on devlink eswitch-mode change and SR-IOV disable, the monitor-stats
disable loop in en/monitor_stats.c, pcie_cong_event cleanup, macsec and
ipsec cleanup, fw_tracer probe-time error rollback, LAG port removal,
clock/PPS cleanup, and mlx5_eq_notifier_unregister() in
drivers/vfio/pci/mlx5/cmd.c.

>     On x86-64 with HZ=1000, 64 networking channels:
>     - Average teardown time: 3.59s -> 1.9s (47% reduction)
>     On x86-64 with HZ=250, 64 networking channels:
>     - Average teardown time: 5.5s -> 1.9s (65% reduction)

Are these numbers configuration dependent?  synchronize_rcu_expedited()
falls back to a normal grace period when rcu_gp_is_normal() is set
(rcupdate.rcu_normal or rcu_normal_after_boot):

kernel/rcu/tree_exp.h:synchronize_rcu_expedited() {
	/* If expedited grace periods are prohibited, fall back to normal. */
	if (rcu_gp_is_normal()) {
		synchronize_rcu_normal();
		return;
	}
	...
}

and under CONFIG_TINY_RCU include/linux/rcutiny.h maps
synchronize_rcu_expedited() to plain synchronize_rcu(), so no reduction is
expected in those configurations.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
> index d11ec263d53c9..c86090cb58c6a 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
> @@ -1243,6 +1243,6 @@ int mlx5_eq_notifier_unregister(struct mlx5_core_dev *dev, struct mlx5_nb *nb)
>  {
>  	struct mlx5_eq_table *eqt = dev->priv.eq_table;
>  
> -	return atomic_notifier_chain_unregister(&eqt->nh[nb->event_type], &nb->nb);
> +	return atomic_notifier_chain_unregister_expedited(&eqt->nh[nb->event_type], &nb->nb);
>  }
>  EXPORT_SYMBOL(mlx5_eq_notifier_unregister);
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/events.c b/drivers/net/ethernet/mellanox/mlx5/core/events.c
> index 4d7f35b968761..753cb15cdeee1 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/events.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/events.c
> @@ -436,7 +436,7 @@ int mlx5_notifier_unregister(struct mlx5_core_dev *dev, struct notifier_block *n
>  {
>  	struct mlx5_events *events = dev->priv.events;
>  
> -	return atomic_notifier_chain_unregister(&events->fw_nh, nb);
> +	return atomic_notifier_chain_unregister_expedited(&events->fw_nh, nb);
>  }
>  EXPORT_SYMBOL(mlx5_notifier_unregister);
>  
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
> index 0f5b8bc7861eb..cb31e8c7a244f 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
> @@ -343,7 +343,7 @@ int mlx5_irq_detach_nb(struct mlx5_irq *irq, struct notifier_block *nb)
>  {
>  	int err = 0;
>  
> -	err = atomic_notifier_chain_unregister(&irq->nh, nb);
> +	err = atomic_notifier_chain_unregister_expedited(&irq->nh, nb);
>  	mlx5_irq_put(irq);
>  	return err;
>  }
> diff --git a/include/linux/notifier.h b/include/linux/notifier.h
> index 01b6c9d9956f9..156d958f98f05 100644
> --- a/include/linux/notifier.h
> +++ b/include/linux/notifier.h
> @@ -159,6 +159,8 @@ extern int blocking_notifier_chain_register_unique_prio(
>  
>  extern int atomic_notifier_chain_unregister(struct atomic_notifier_head *nh,
>  		struct notifier_block *nb);
> +extern int atomic_notifier_chain_unregister_expedited(struct atomic_notifier_head *nh,
> +		struct notifier_block *nb);

[Severity: Low]
Should the API comment block at the top of include/linux/notifier.h be
updated for the new symbol?  It currently reads:

 * atomic_notifier_chain_register() may be called from an atomic context,
 * but blocking_notifier_chain_register() and srcu_notifier_chain_register()
 * must be called from a process context.  Ditto for the corresponding
 * _unregister() routines.
 *
 * atomic_notifier_chain_unregister(), blocking_notifier_chain_unregister(),
 * and srcu_notifier_chain_unregister() _must not_ be called from within
 * the call chain.

The new helper is not listed in the second rule, and the first rule as
written would suggest it may be called from atomic context, which is not
true since synchronize_rcu_expedited() blocks and warns:

kernel/rcu/tree_exp.h:synchronize_rcu_expedited() {
	RCU_LOCKDEP_WARN(lock_is_held(&rcu_bh_lock_map) ||
			 lock_is_held(&rcu_lock_map) ||
			 lock_is_held(&rcu_sched_lock_map),
			 "Illegal synchronize_rcu_expedited() in RCU read-side critical section");
	...
}

Note the "Ditto ... _unregister()" inaccuracy is pre-existing and was not
introduced by this patch, since atomic_notifier_chain_unregister() already
calls synchronize_rcu(); only the omission of the new symbol from both
rules is new.

>  extern int blocking_notifier_chain_unregister(struct blocking_notifier_head *nh,
>  		struct notifier_block *nb);
>  extern int raw_notifier_chain_unregister(struct raw_notifier_head *nh,
> diff --git a/kernel/notifier.c b/kernel/notifier.c
> index 2f9fe7c30287f..9b35822fc2c02 100644
> --- a/kernel/notifier.c
> +++ b/kernel/notifier.c
> @@ -197,6 +197,30 @@ int atomic_notifier_chain_unregister(struct atomic_notifier_head *nh,
>  }
>  EXPORT_SYMBOL_GPL(atomic_notifier_chain_unregister);
>  
> +/**
> + *	atomic_notifier_chain_unregister_expedited - Remove notifier from an atomic notifier chain
> + *	@nh: Pointer to head of the atomic notifier chain
> + *	@n: Entry to remove from notifier chain
> + *
> + *	Removes a notifier from an atomic notifier chain and forcefully
> + *	accelerates the RCU grace period.

[Severity: Low]
Could this kernel-doc state that the caller must be in sleepable process
context and must not call it from within the notifier call chain?  Also,
"forcefully accelerates the RCU grace period" does not hold for
CONFIG_TINY_RCU, where include/linux/rcutiny.h defines
synchronize_rcu_expedited() as synchronize_rcu(), nor when
rcu_gp_is_normal() forces the normal grace period fallback.

> + *
> + *	Return: 0 on success, or -ENOENT on failure.
> + */
> +int atomic_notifier_chain_unregister_expedited(struct atomic_notifier_head *nh,
> +		struct notifier_block *n)
> +{
> +	unsigned long flags;
> +	int ret;
> +
> +	spin_lock_irqsave(&nh->lock, flags);
> +	ret = notifier_chain_unregister(&nh->head, n);
> +	spin_unlock_irqrestore(&nh->lock, flags);
> +	synchronize_rcu_expedited();
                    ^^^^

[Severity: High]
Does this put one expedited grace period per notifier block into paths that
unregister notifiers in a loop?  The synchronize_rcu_expedited() kernel-doc
asks for the opposite:

kernel/rcu/tree_exp.h:
 * implementations, it is still unfriendly to real-time workloads, so is
 * thus not recommended for any sort of common-case code.  In fact, if
 * you are using synchronize_rcu_expedited() in a loop, please restructure
 * your code to batch your updates, and then use a single synchronize_rcu()
 * instead.

The converted helpers are loop bodies.  In mlx5_eq_table_destroy():

	xa_for_each(&table->comp_eqs, index, eq)
		destroy_comp_eq(dev, eq, index);

and destroy_comp_eq() -> mlx5_eq_disable() -> mlx5_irq_detach_nb(), so the
64-channel device from the commit message performs 64 back-to-back
expedited grace periods, each IPI'ing every non-idle non-nohz online CPU.

mlx5_events_stop() is a second loop:

	for (i = ARRAY_SIZE(events_nbs_ref) - 1; i >= 0 ; i--)
		mlx5_eq_notifier_unregister(dev, &events->notifiers[i].nb);

as are the monitor-stats disable loop in en/monitor_stats.c and the LAG
port loops in lag/lag.c.

Would a _nosync unregister variant plus a single grace period after all
blocks are unlinked fit the documented guidance better?

There is also a repeatable userspace trigger.  In vfio_main.c,
vfio_ioctl_device_feature_logging_stop() calls
device->log_ops->log_stop(device), which reaches
mlx5vf_stop_page_tracker() -> _mlx5vf_free_page_tracker_resources() ->
mlx5_eq_notifier_unregister() in drivers/vfio/pci/mlx5/cmd.c, so a device
fd holder can alternate DMA_LOGGING_START/STOP and force an all-CPU IPI per
cycle.  With plain synchronize_rcu() only the caller waited; is the shift of
that cost onto every other CPU acceptable for isolated, nohz_full or RT
workloads, given the only mitigation is the administrative
rcupdate.rcu_normal=1?

> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(atomic_notifier_chain_unregister_expedited);
> +
-- 
pw-bot: cr
