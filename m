Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA31382394;
	Sat, 19 Sep 2026 23:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789861300; cv=none; b=YNNf6I1kp2lTCLn0p5A7tOA501WHgPYWVmp0+vve2Kud98ZaiLgv96190ORk+f987+fR5raPDG2HSUIdB8zD6FkZxuXk86J7T13GWEfj0JoFPbbjvmITaQlqPEhQWCLYMwDRNI7zzUiRowV0n/bp565gNNkopF/YxAbN7flUobc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789861300; c=relaxed/simple;
	bh=af0RkmVeSa2tT+y3X3WnHXtb+cNV7KtucIqJOyVqhaI=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LH7XDiGC1HPVF0CaMgB7KAGDkdAq19Ck/RFt2w7dAiVP/TCVQycxSjRQugd/HSaZl0dQ9B17aBywg08EA5fCck6hTEPI/94eDnWlwvmsLPwKZliFF7obCTlwEZb34uPqwuYAdV2gUY76VHW/lkuki1XjZNF1OIimIjyt+4SOYX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hyq+oHHc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hyq+oHHc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8921F00893;
	Sat, 19 Sep 2026 23:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789861297;
	bh=7SNztyQrqwbe2uynFVTImZcezK2L2Za6yvNfudq65+g=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=hyq+oHHc/0BfMvOnW9qsrixzeGhT+IxshKu9DE/mKGtNxej7Z2sdrksECn4ofGLzl
	 GG21URGwdcL1oseXoY1z8R5UU5Q1NC2EvorFWN9Rg5G0PEaHKzCrkEnvTD0+NGbFVv
	 aEJR+qyz9j8lMJxoaTDICISJYF+LvhfRnqlGEUjeumvcWyhJdpFHKyyqKleMwzIl6h
	 0arXo3p8mNpGYdHP2ZuaWQ0qDTTPN7RS3buLBbjTSw4UZtynha5UslVGndo12kV7jN
	 lAhb1cR+e7LNzYNyqa+Rh4EAzZXzW9iVjo5+N7RETJZXydYetAYpUG70ln5ccjF1zd
	 9Tw6HV7E+3k9A==
Subject: Re: [PATCH net 2/2] net/mlx5: Don't return firmware-owned command
 mailboxes to the DMA pool
From: netdev-bot+sashiko@kernel.org
To: dcostantino@meta.com
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, moshe@nvidia.com, eranbe@nvidia.com,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Sat, 19 Sep 2026 23:41:36 +0000
Message-ID: <178986129649.22033.384713377066176112@kernel.org>
In-Reply-To: <20260915225941.554568-3-dcostantino@meta.com>
References: <20260915225941.554568-3-dcostantino@meta.com>
X-sashiko-severity: Critical
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 10 potential
issue(s) to consider:

Critical: 1 · High: 3 (4) · Medium: 5 · Low: 1

- [Critical] net/mlx5: data race on own_msgs causes DMA pool UAF
- [High] cmd_reclaim_stalled_ents() handles a still-pending
  cb_timeout_work by cancelling it and dropping only the reference it…
- [High] cmd_reclaim_stalled_ents() assumes the reference it drops is the
  last one — cmd_ent_put()'s new comment states "Nothing references the…
- [High] mlx5_cmd_change_mod() now updates dev->cmd.mode unconditionally
  even when cmd_sem_down_all() failed to drain the interface (it returns…
- [Medium] The commit message states "Five other paths reach
  mlx5_cmd_disable() without having issued it at all, among them the…
- [Medium] When cmd_reclaim_stalled_ents() runs with fw_stopped == false
  it clears ent->own_msgs, so cmd_ent_put()'s new release block is…
- [Medium] mlx5_function_disable() promotes a single successful
  DISABLE_HCA (plus !mlx5_cmd_is_down()) into a global verdict that…
- [Medium] The new mailbox retention is gated on the same retention
  condition as the entry reference, which contains the…
- [Medium] The new comment on mlx5_function_enable()'s unwind states
  "Nothing here has confirmed that firmware released the function" and…
- [Low] mlx5_cmd_invoke() now transfers ownership of the caller-supplied
  in/out mailbox messages to the command entry when it returns…

Pre-existing issues:
- [High] mlx5_cmd_flush() spins forever when a command timed out before
  the device entered the error state.
- [High] The newly added cancel_delayed_work_sync(&ent->cb_timeout_work)
  in cmd_reclaim_stalled_ents() runs far too late in teardown to make…
- [High] MLX5_CMD_ENT_STATE_FW_REF prevents a duplicate refcount
  decrement but does not keep the entry alive for the losing completion…
- [High] On the path where the patch deliberately withholds the mailboxes
  because firmware may still DMA (cmd_reclaim_stalled_ents(dev, false),…

--

net/mlx5: Don't return firmware-owned command mailboxes to the DMA pool

This transfers ownership of the in/out command mailboxes to the command
entry when a command times out, so they are released only on the entry's
final put, and adds cmd_reclaim_stalled_ents() plus a new fw_stopped
argument to mlx5_cmd_disable() to retire entries firmware never completed.

A few questions below, first on the commit message and then inline.

> Return the mailboxes to the pool only once firmware has confirmed it is
> finished with them.  A successful DISABLE_HCA is that confirmation, so
> check its result, which mlx5_function_disable() until now discarded, and
> pass it to mlx5_cmd_disable().  Five other paths reach mlx5_cmd_disable()
> without having issued it at all, among them the mlx5_function_enable()
> error path and the light init and unload paths; those pass false, the
> mailboxes stay allocated, and dma_pool_destroy() leaves the pool's pages
> mapped so a late write lands in memory the driver still owns.

[Severity: Medium]
Is this description of the call sites accurate?  After the patch there are
only two callers of mlx5_cmd_disable(), both in main.c: the err_cmd_cleanup
label of mlx5_function_enable(), which passes false, and
mlx5_function_disable(), which passes the computed fw_stopped.

The paths named as conservative here - mlx5_init_one_light()'s
query_hca_caps_err unwind, mlx5_uninit_one_light(), mlx5_unload_one_light(),
and mlx5_function_setup()/mlx5_function_teardown() - all reach
mlx5_cmd_disable() through mlx5_function_disable(), which does issue
DISABLE_HCA and can therefore pass fw_stopped == true and hand the stalled
commands' mailboxes back to the pool.

Note also that the false in mlx5_unload_one_light():

	mlx5_function_disable(dev, false);

is mlx5_function_disable()'s boot argument, not fw_stopped.  Could the
paragraph be reworded so a backporter reading it does not conclude those
paths keep the mailboxes?

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> index 571ed540957b1..890a2a2613ca0 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c

[ ... ]

> @@ -207,6 +214,15 @@ static void cmd_ent_put(struct mlx5_cmd_work_ent *ent)
>  	}
>  	spin_unlock_irqrestore(&cmd->alloc_lock, flags);
>  
> +	/* These were withheld from dev->cmd.pool because firmware still owned
> +	 * them.  Nothing references the entry any more, so whoever dropped the
> +	 * last reference has established that firmware is done with them.
> +	 */
> +	if (ent->own_msgs) {
> +		mlx5_free_cmd_msg(dev, ent->out);
> +		free_msg(dev, ent->in);
> +	}
> +
>  	cmd_free_ent(ent);
>  }

[Severity: High]
Can this release block run after the pool has already been destroyed?

cmd_reclaim_stalled_ents() only consumes MLX5_CMD_ENT_STATE_FW_REF plus its
own temporary reference, so it cannot know it dropped the last one.
mlx5_cmd_invoke() holds the cmd_alloc_ent() reference until its out_free:
put, and now sets ent->own_msgs = true before that put:

	if (err == -ETIMEDOUT) {
		...
		ent->own_msgs = true;
		goto out_free;
	}
	...
out_free:
	status = ent->status;
	cmd_ent_put(ent);

flush_workqueue(cmd->wq) at the top of mlx5_cmd_disable() waits for
cmd_work_handler(), not for that invoker, so:

thread A (mlx5_cmd_invoke)		thread B (mlx5_cmd_disable)
  wait_func() returns -ETIMEDOUT
  ent->own_msgs = true
					  cmd_reclaim_stalled_ents()
					    clears FW_REF, puts (refcnt >= 1)
					  destroy_msg_cache()
					  free_cmd_page()
					  dma_pool_destroy(cmd->pool)
  cmd_ent_put()  /* final */
    free_msg(dev, ent->in)
    mlx5_free_cmd_msg(dev, ent->out)
      free_cmd_box() ->
        dma_pool_free(dev->cmd.pool, ...)

dma_pool_destroy() ends with kfree(pool), so does that dma_pool_free() touch
a freed struct dma_pool - or, if mlx5_cmd_enable() has already installed a
new pool, return old-pool blocks into the new one?  free_msg() would also
push the inbox onto a cmd->cache[] list that destroy_msg_cache() already
drained and create_msg_cache() re-initialises.

On the same resumption, mlx5_cmd_comp_handler() does
memcpy(ent->out->first.data, ent->lay->out, ...) with ent->lay pointing into
the page free_cmd_page() just released.

> @@ -1059,9 +1071,19 @@ static void cmd_work_handler(struct work_struct *work)
>  
>  	if (ent->callback && schedule_delayed_work(&ent->cb_timeout_work, timeout))
>  		cmd_ent_get(ent);
> -	set_bit(MLX5_CMD_ENT_STATE_PENDING_COMP, &ent->state);
>  
>  	cmd_ent_get(ent); /* for the _real_ FW event on completion */
> +	/* Publish the reference, then its marker, and only then
> +	 * MLX5_CMD_ENT_STATE_PENDING_COMP.  Whoever clears PENDING_COMP owns
> +	 * the completion, so it has to see FW_REF already set or it will fail
> +	 * to drop the reference.  Ordering PENDING_COMP last is what
> +	 * guarantees that: mlx5_cmd_trigger_completions() can walk this slot
> +	 * as soon as cmd_alloc_index() published it, long before the doorbell.
> +	 */
> +	set_bit(MLX5_CMD_ENT_STATE_FW_REF, &ent->state);
> +	/* order FW_REF before PENDING_COMP, see the comment above */
> +	smp_mb__before_atomic();
> +	set_bit(MLX5_CMD_ENT_STATE_PENDING_COMP, &ent->state);

[Severity: High]
Slightly off to the side of this hunk, but in the same function: can the
mode snapshot taken here straddle a mode change and leave the caller waiting
forever?

cmd_work_handler() snapshots the mode when it posts:

	cmd_mode = cmd->mode;

while wait_func() reads the current global value afterwards:

	if (cmd->mode == CMD_MODE_POLLING || ent->polling)
		wait_for_completion(&ent->done);

With the bounded drain added by the earlier patch in this series,
"net/mlx5: Bound the command interface drain so teardown cannot hang",
mlx5_cmd_change_mod() now updates dev->cmd.mode even when cmd_sem_down_all()
timed out with units outstanding:

	nr = cmd_sem_down_all(dev, &pages_sem);
	dev->cmd.mode = mode;
	cmd_sem_up_all(dev, nr, pages_sem);

If the worker snapshotted CMD_MODE_EVENTS (so it does not poll) and the mode
flips to CMD_MODE_POLLING before the descheduled synchronous caller reads
it, the caller takes the unbounded wait_for_completion(&ent->done) branch
while nobody polls, and mlx5_cmd_use_polling() then unregisters the command
EQ notifier and destroy_async_eqs() destroys the EQ.

The sibling mlx5_cmd_allowed_opcode() got an explicit guard for the
incomplete-drain case:

	if (opcode == CMD_ALLOWED_OPCODE_ALL ||
	    (nr == cmd->vars.max_reg_cmds && pages_sem))

Should mlx5_cmd_change_mod() have the same guard, given this series is
otherwise about making teardown recoverable?

> @@ -1313,7 +1335,19 @@ static int mlx5_cmd_invoke(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *in,
>  		return 0; /* mlx5_cmd_comp_handler() will put(ent) */
>  
>  	err = wait_func(dev, ent);
> -	if (err == -ETIMEDOUT || err == -ECANCELED || err == -EBUSY)
> +	if (err == -ETIMEDOUT) {
> +		/* The command was posted to firmware and firmware never
> +		 * completed it.  Unless the device is already down,
> +		 * mlx5_cmd_comp_handler(forced) keeps this entry and its
> +		 * queue slot allocated because firmware may still complete
> +		 * it, so ent->lay->{in_ptr,out_ptr} keep referencing the
> +		 * mailboxes.  Take ownership of them so that cmd_exec()
> +		 * cannot hand them back to dev->cmd.pool.
> +		 */
> +		ent->own_msgs = true;
> +		goto out_free;
> +	}

[Severity: Critical]
What serialises ent->own_msgs between the invoker and the reclaim?

Both sides write it as a plain bool with no lock and no ordering
against the refcount:

  - mlx5_cmd_invoke() sets ent->own_msgs = true here, after
    wait_func() has returned -ETIMEDOUT, and only then drops the
    cmd_alloc_ent() reference at out_free:.
  - cmd_reclaim_stalled_ents() clears ent->own_msgs when
    !fw_stopped, deliberately, so that nothing is handed back to
    dev->cmd.pool.

flush_workqueue(cmd->wq) at the top of mlx5_cmd_disable() waits for
cmd_work_handler(), not for the synchronous issuer sitting in
mlx5_cmd_invoke(), so the two can interleave the other way round:

thread A (mlx5_cmd_invoke)		thread B (mlx5_cmd_disable)
  wait_func() returns -ETIMEDOUT
					  cmd_reclaim_stalled_ents()
					    ent->own_msgs = false
					    clears FW_REF, puts
					  destroy_msg_cache()
					  dma_pool_destroy(cmd->pool)
  ent->own_msgs = true
  cmd_ent_put()  /* final */
    mlx5_free_cmd_msg(dev, ent->out)
    free_msg(dev, ent->in)

The reclaim's put is not the final one here - thread A still holds the
allocation reference - so the decision the reclaim made is simply
overwritten, and thread A's put becomes the last one and runs the new
release block in cmd_ent_put().  That reaches free_cmd_box() ->
dma_pool_free() on a struct dma_pool that dma_pool_destroy() has
already kfree()d, or, if mlx5_cmd_enable() has meanwhile installed a
fresh pool, returns old-pool blocks into the new one.  free_msg() has
the matching problem for a cache-parented inbox: it pushes onto a
cmd->cache[] list that destroy_msg_cache() already drained and
create_msg_cache() re-initialised.

The same unordered write also defeats the mitigation in the other
direction: on a !fw_stopped teardown the reclaim clears own_msgs
precisely so a late firmware write lands in memory the driver still
owns, and this assignment silently puts the mailboxes back on the
free list where dma_pool_destroy() will dma_free_coherent() them.

Would it be cleaner to make ownership follow the same single-consumer
rule as the reference - i.e. set own_msgs only under cmd->alloc_lock,
or only in the path that wins the test_and_clear_bit() on
MLX5_CMD_ENT_STATE_FW_REF - so that exactly one side decides?  Or
does the reclaim need to wait for outstanding synchronous issuers
before mlx5_cmd_disable() tears the pool down at all?

[Severity: Low]
Would it be worth stating the new ownership rule in the comment block above
mlx5_cmd_invoke()?  That block enumerates the meaning of every return value:

 * return value in case (!callback):
 *	ret < 0 : Command execution couldn't be submitted by driver
 *	ret > 0 : Command execution couldn't be performed by firmware
 *	ret == 0: Command was executed by FW, Caller must check FW outbox status.

but says nothing about who owns in/out afterwards, and -ETIMEDOUT is also
the case where err < 0 no longer means "couldn't be submitted".  A second
caller written against that block would dma_pool_free() mailboxes the entry
still owns and whose final put frees again.

> @@ -1810,7 +1844,9 @@ static void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool force
>  				if (!forced) {
>  					mlx5_core_err(dev, "Command completion arrived after timeout (entry idx = %d).\n",
>  						      ent->idx);
> -					cmd_ent_put(ent);
> +					if (test_and_clear_bit(MLX5_CMD_ENT_STATE_FW_REF,
> +							       &ent->state))
> +						cmd_ent_put(ent);
>  				}
>  				continue;
>  			}

[Severity: High]
This is a pre-existing issue, not introduced by the patch, but does the new
marker fully close the double-completion the commit message describes?

Both executors start from a bare lookup with no reference:

	if (test_bit(i, &vector)) {
		ent = cmd->ent_arr[i];

The winner clears PENDING_COMP, consumes FW_REF, puts, and completes
ent->done; the synchronous caller then drops the allocation reference in
mlx5_cmd_invoke()'s out_free:, so cmd_ent_put() runs cmd_free_index() (which
NULLs cmd->ent_arr[idx]) and kfree()s the entry.

The loser then runs clear_bit(MLX5_CMD_ENT_STATE_TIMEDOUT, &ent->state),
test_and_clear_bit(MLX5_CMD_ENT_STATE_PENDING_COMP, &ent->state) and the new
test_and_clear_bit(MLX5_CMD_ENT_STATE_FW_REF, &ent->state) on that freed
entry, or on NULL if it read ent_arr[i] later.  The atomic marker protects
the refcount but not the object holding it - would the completion executors
need the reference-protected lookup mlx5_cmd_trigger_completions() already
uses?

	for_each_set_bit(i, &bitmask, (1 << cmd->vars.log_sz))
		cmd_ent_get(cmd->ent_arr[i]);

[Severity: High]
This isn't introduced by this patch either, but it is the same class of hang
the series is addressing, so worth raising here: mlx5_cmd_flush() can spin
forever on a slot that timed out while the device was still up.

Such an entry keeps its reference (the retention condition below is false
because mlx5_cmd_is_down() is false and the opcode is allowed), so
cmd_ent_put() never reaches cmd_free_index()/up(&cmd->vars.sem) and the
semaphore unit is gone for good.  enter_error_state() then does:

	dev->state = MLX5_DEVICE_STATE_INTERNAL_ERROR;
	mlx5_cmd_flush(dev);

and mlx5_cmd_flush() loops:

	while (down_trylock(&cmd->vars.sem)) {
		mlx5_cmd_trigger_completions(dev);
		cond_resched();
	}

For the timed-out slot, the forced completion finds PENDING_COMP already
clear and just continues at the hunk above, so the unit is never released
and the loop has no bound.  The first patch in the series bounded
mlx5_cmd_allowed_opcode() and mlx5_cmd_change_mod(); should mlx5_cmd_flush()
be bounded the same way?

> @@ -1818,9 +1854,11 @@ static void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool force
>  			if (ent->callback && cancel_delayed_work(&ent->cb_timeout_work))
>  				cmd_ent_put(ent); /* timeout work was canceled */
>  
> -			if (!forced || /* Real FW completion */
> +			if ((!forced || /* Real FW completion */
>  			     mlx5_cmd_is_down(dev) || /* No real FW completion is expected */
> -			     !opcode_allowed(cmd, ent->op))
> +			     !opcode_allowed(cmd, ent->op)) &&
> +			    test_and_clear_bit(MLX5_CMD_ENT_STATE_FW_REF,
> +					       &ent->state))
>  				cmd_ent_put(ent);

[Severity: Medium]
The mailbox retention is now gated on this same condition, which includes
mlx5_cmd_is_down(dev) - pure software state (INTERNAL_ERROR set by the health
poller, MLX5_CMDIF_STATE_DOWN set just before mlx5_cmd_disable(), or
pci_channel_offline()).

For a command that was posted and force-completed with ent->ret ==
-ETIMEDOUT while that is true, FW_REF is consumed here, so on the callback
path the else branch below frees both mailboxes immediately, and on the
synchronous path ent->own_msgs = true gives no protection because
mlx5_cmd_invoke()'s put becomes the final one and frees them straight away.
With the pool then clean, dma_pool_destroy() does dma_free_coherent() those
pages back to the page allocator with bus mastering still on.

The commit message covers only the -ENXIO variants:

> One related hole is left in place, pre-existing.  A command that was posted
> and then force completed with -ENXIO [...]

Does the -ETIMEDOUT plus mlx5_cmd_is_down() case take the same free path,
and if so should it be gated too or at least listed alongside the -ENXIO
holes?

> @@ -1861,8 +1899,22 @@ static void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool force
>  								 ent->out,
>  								 ent->uout_size);
>  
> -				mlx5_free_cmd_msg(dev, ent->out);
> -				free_msg(dev, ent->in);
> +				/* Same reasoning as the -ETIMEDOUT path in
> +				 * mlx5_cmd_invoke(): when the entry was
> +				 * retained just above, firmware may still DMA
> +				 * into ent->lay->{in_ptr,out_ptr}, so hand the
> +				 * mailboxes to the entry and let its last
> +				 * cmd_ent_put() release them.  Otherwise the
> +				 * driver has decided firmware is done and they
> +				 * go straight back to the pool, as before.
> +				 */
> +				if (test_bit(MLX5_CMD_ENT_STATE_FW_REF,
> +					     &ent->state)) {
> +					ent->own_msgs = true;
> +				} else {
> +					mlx5_free_cmd_msg(dev, ent->out);
> +					free_msg(dev, ent->in);
> +				}
>  
>  				/* final consumer is done, release ent */
>  				cmd_ent_put(ent);

[ ... ]

> @@ -2057,6 +2109,10 @@ static int cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
>  	if (callback && !err)
>  		return 0;
>  
> +	/* The mailboxes are owned by the command entry now */
> +	if (err == -ETIMEDOUT)
> +		goto out_up;
> +
>  	if (err > 0) /* Failed in FW, command didn't execute */
>  		err = deliv_status_to_err(err);

> @@ -2590,12 +2646,86 @@ int mlx5_cmd_enable(struct mlx5_core_dev *dev)
>  	return err;
>  }
>  
> -void mlx5_cmd_disable(struct mlx5_core_dev *dev)
> +/* Retire the entries that timed out and were never completed by firmware.
> + * Each still holds the reference a real completion would have dropped, and
> + * with it a command queue slot, a semaphore unit, its own allocation, and -
> + * since the timeout paths hand mailbox ownership to the entry - blocks of
> + * cmd->pool.  The mailboxes matter most: dma_pool_destroy() checks pool wide
> + * and all or nothing, so one stranded block makes it skip dma_free_coherent()
> + * for every page and then free the descriptors anyway, stranding the whole
> + * command pool - and its IOVA range under an IOMMU - on every teardown.
> + */
> +static void cmd_reclaim_stalled_ents(struct mlx5_core_dev *dev, bool fw_stopped)
> +{
> +	struct mlx5_cmd_work_ent *ent;
> +	struct mlx5_cmd *cmd = &dev->cmd;
> +	unsigned long flags;
> +	int i;
> +
> +	for (i = 0; i < (1 << cmd->vars.log_sz); i++) {
> +		/* Take a reference before dropping alloc_lock, otherwise a
> +		 * concurrent last put could free the entry under us.  Holding
> +		 * alloc_lock with the bit clear guarantees the refcount has
> +		 * not reached zero, because cmd_ent_put() sets that bit under
> +		 * the same lock before it frees anything.
> +		 */
> +		spin_lock_irqsave(&cmd->alloc_lock, flags);
> +		ent = test_bit(i, &cmd->vars.bitmask) ? NULL : cmd->ent_arr[i];
> +		if (ent)
> +			cmd_ent_get(ent);
> +		spin_unlock_irqrestore(&cmd->alloc_lock, flags);
> +
> +		if (!ent)
> +			continue;
> +
> +		/* cb_timeout_work sits on the system workqueue, which the
> +		 * flush_workqueue(cmd->wq) above does not cover.  Left queued
> +		 * it would run cb_timeout_handler() once the async EQs are
> +		 * gone and the caller has destroyed the message cache and the
> +		 * pool.  If it was still pending, drop the reference taken
> +		 * when it was scheduled.
> +		 */
> +		if (ent->callback &&
> +		    cancel_delayed_work_sync(&ent->cb_timeout_work))
> +			cmd_ent_put(ent);

[Severity: High]
Can this leave an async entry stranded with nobody left to complete it?

cancel_delayed_work_sync() returning true means the work was still queued,
which means the entry has not been completed: PENDING_COMP is still set, the
callback has not run, and ent->in/ent->out are still allocated.

Reference accounting for such an entry: cmd_alloc_ent() = 1,
schedule_delayed_work() = 2, the firmware-event get = 3.  Here the reclaim
adds one (4), the cancel puts (3), the FW_REF test_and_clear puts (2), the
trailing put (1).  The remaining one is the allocation reference, which for
callback commands is dropped only by:

				/* final consumer is done, release ent */
				cmd_ent_put(ent);
				callback(err, context);

inside mlx5_cmd_comp_handler().  By this point mlx5_unload() has already run
mlx5_eq_table_destroy() -> destroy_async_eqs(), so no completion can arrive,
and the work that would have force-completed it:

	ent->ret = -ETIMEDOUT;
	...
	mlx5_cmd_comp_handler(dev, 1ULL << ent->idx, true);

has just been cancelled.  So the callback is never invoked (a later
mlx5_cmd_cleanup_async_ctx() then waits forever in
wait_for_completion(&ctx->inflight_done)), the entry is never freed,
cmd_free_index() never runs, and because own_msgs is false for a
never-completed entry its mailboxes are never freed by anyone - leaving
pool->nr_active non-zero at the dma_pool_destroy() below and stranding the
pool even when fw_stopped is true.  Would force-completing the entry here,
as cb_timeout_handler() does, be the safer shape?

[Severity: High]
This isn't a bug introduced by this patch - cb_timeout_work was not
cancelled at teardown at all before it - but does the cancel land late
enough that it cannot prevent the use-after-free it is aimed at?

cb_timeout_handler() calls mlx5_cmd_eq_recover(dev) unconditionally, before
it checks PENDING_COMP, and mlx5_cmd_eq_recover() does:

	struct mlx5_eq_async *eq = &dev->priv.eq_table->cmd_eq;

	eqes = mlx5_eq_async_int(&eq->irq_nb, ASYNC_EQ_RECOVER, NULL);

The teardown order is mlx5_uninit_one() -> mlx5_unload() ->
mlx5_eq_table_destroy() -> destroy_async_eqs() (command EQ destroyed), then
mlx5_cleanup_once() -> mlx5_eq_table_cleanup() (kvfree of the table), then
mlx5_function_teardown() -> mlx5_function_disable() -> mlx5_cmd_disable() ->
cmd_reclaim_stalled_ents().

A cb_timeout_work firing anywhere in that window locks eq->lock and reads
EQEs out of freed memory, and the new synchronous cancel only waits for that
handler.  Should the cancellation happen before mlx5_eq_table_destroy() /
mlx5_eq_table_cleanup() rather than before dma_pool_destroy()?

> +
> +		/* The entry itself is never visible to firmware - the only
> +		 * addresses it is ever given are the mailbox and command
> +		 * queue DMA addresses - so it can always be retired.  Its
> +		 * mailboxes are a different matter: hand those back only once
> +		 * firmware has acknowledged it released the function.  If it
> +		 * has not, drop ownership without freeing.  dma_pool_destroy()
> +		 * then reports the pool busy and skips dma_free_coherent(),
> +		 * so the pages stay mapped and are never handed back to the
> +		 * allocator; a late write lands there harmlessly.
> +		 */
> +		if (!fw_stopped)
> +			ent->own_msgs = false;

[Severity: Medium]
Does clearing own_msgs here leak more than the DMA blocks, and is the leak
bounded?

cmd_ent_put() gates all mailbox cleanup on own_msgs, so with it cleared the
kmalloc'd struct mlx5_cmd_msg and struct mlx5_cmd_mailbox wrappers - which
firmware never sees, only mailbox->dma - lose their last pointer, and a
cache-parented inbox never gets back onto cmd->cache[] for
destroy_msg_cache() either.

dma_pool_destroy() is then all or nothing:

	if (pool->nr_active) {
		dev_err(pool->dev, "%s %s busy\n", __func__, pool->name);
		busy = true;
	}

	list_for_each_entry_safe(page, tmp, &pool->page_list, page_list) {
		if (!busy)
			dma_free_coherent(...);

so every page stays allocated while the descriptors and the pool are freed
anyway, and mlx5_cmd_enable() creates a fresh pool on the next load.  Since
mlx5_cmd_is_down() is true on health-recovery teardowns, fw_stopped == false
looks like the common case there - does that make this repeat once per
recovery or devlink reload with nothing bounding it?  Would freeing at least
the host-side descriptors be safe, given firmware only ever sees
mailbox->dma?

> +
> +		/* Only drop the firmware reference if it is really owed;
> +		 * test_and_clear_bit() makes this safe against a late real
> +		 * completion that got there first.
> +		 */
> +		if (test_and_clear_bit(MLX5_CMD_ENT_STATE_FW_REF, &ent->state)) {
> +			mlx5_core_warn(dev, "reclaiming outstanding cmd[%d]: %s(0x%x)\n",
> +				       i, mlx5_command_str(ent->op), ent->op);
> +			cmd_ent_put(ent);
> +		}
> +
> +		cmd_ent_put(ent);
> +	}
> +}
> +
> +void mlx5_cmd_disable(struct mlx5_core_dev *dev, bool fw_stopped)
>  {
>  	struct mlx5_cmd *cmd = &dev->cmd;
>  
>  	flush_workqueue(cmd->wq);
>  	clean_debug_files(dev);
> +	/* Before destroy_msg_cache(): a reclaimed inbox goes back on its cache
> +	 * list via free_msg(), and destroy_msg_cache() then frees it.
> +	 */
> +	cmd_reclaim_stalled_ents(dev, fw_stopped);
>  	destroy_msg_cache(dev);
>  	free_cmd_page(dev, cmd);
>  	dma_pool_destroy(cmd->pool);

[Severity: High]
This is a pre-existing choice that the commit message explicitly declines to
change:

> Note free_cmd_page() just below makes the opposite
> choice for the command queue page, which firmware writes lay->status_own
> into, and has since the driver was merged; this does not change that.

but does it leave the new mitigation inconsistent within one function?  On
the fw_stopped == false path the mailboxes are deliberately withheld (at the
cost of the whole pool), and two lines later free_cmd_page() does:

	dma_free_coherent(mlx5_core_dma_dev(dev), cmd->alloc_size, cmd->cmd_alloc_buf,
			  cmd->alloc_dma);

on the page firmware was given via cmdq_addr_h/l and writes lay->status_own
and the inline lay->out into, for the very same stalled slots.  For commands
whose output fits inline there is no out mailbox at all, so nothing is
withheld for them.  remove_one() runs mlx5_uninit_one() before
mlx5_pci_close(), so bus mastering is still on.

Would deferring or skipping free_cmd_page() on the !fw_stopped paths (or
gating both releases on the per-slot CMD_OWNER_HW bit) make the two
decisions agree?

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> index 5f28d906c35b6..88f0a8089a0e1 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> @@ -1164,18 +1164,33 @@ static int mlx5_function_enable(struct mlx5_core_dev *dev, bool boot, u64 timeou
>  	mlx5_core_disable_hca(dev, 0);
>  err_cmd_cleanup:
>  	mlx5_cmd_set_state(dev, MLX5_CMDIF_STATE_DOWN);
> -	mlx5_cmd_disable(dev);
> +	/* Nothing here has confirmed that firmware released the function */
> +	mlx5_cmd_disable(dev, false);

[Severity: Medium]
Is this comment consistent with the code just above it?  The unwind is a
fall-through ladder:

reclaim_boot_pages:
	mlx5_reclaim_startup_pages(dev);
stop_health_poll:
	mlx5_stop_health_poll(dev, boot);
	mlx5_core_disable_hca(dev, 0);
err_cmd_cleanup:
	mlx5_cmd_set_state(dev, MLX5_CMDIF_STATE_DOWN);
	mlx5_cmd_disable(dev, false);

so for failures of mlx5_core_set_issi(), mlx5_satisfy_startup_pages() and
mlx5_tout_query_dtor(), DISABLE_HCA is issued three lines above and its
result discarded - the same discard mlx5_function_disable() now stops doing
with the identical call.  The two callers of the new parameter therefore
treat the same evidence in opposite ways, and with false the reclaim strands
the whole command pool on every failed probe or reload attempt.  Should the
existing return value be captured here too, or the comment say why
DISABLE_HCA at this point is not meaningful?

>  
>  	return err;
>  }
>  
>  static void mlx5_function_disable(struct mlx5_core_dev *dev, bool boot)
>  {
> +	bool fw_stopped;
> +
>  	mlx5_reclaim_startup_pages(dev);
>  	mlx5_stop_health_poll(dev, boot);
> -	mlx5_core_disable_hca(dev, 0);
> +	/* A DISABLE_HCA that firmware really completed is it acknowledging
> +	 * that it has released the function, and so that it is done with the
> +	 * buffers the driver gave it.  mlx5_cmd_disable() needs to know,
> +	 * because it can only hand command mailboxes back to the DMA pool
> +	 * once that holds.
> +	 *
> +	 * A zero return is not sufficient on its own: mlx5_cmd_check() turns
> +	 * the -ENXIO from an interface that is already down into success for
> +	 * DISABLE_HCA, deliberately, so that reset flows proceed smoothly.
> +	 * That is exactly the case where nothing was posted and firmware
> +	 * acknowledged nothing, so require the interface to still be up.
> +	 */
> +	fw_stopped = !mlx5_core_disable_hca(dev, 0) && !mlx5_cmd_is_down(dev);
>  	mlx5_cmd_set_state(dev, MLX5_CMDIF_STATE_DOWN);
> -	mlx5_cmd_disable(dev);
> +	mlx5_cmd_disable(dev, fw_stopped);
>  }

[Severity: Medium]
Does one command's completion say anything about the mailboxes of the other
stalled slots?  With fw_stopped true, cmd_reclaim_stalled_ents() leaves
own_msgs set, so the final cmd_ent_put() dma_pool_free()s the mailboxes of
commands firmware never completed; pool->nr_active then reaches zero, so
dma_pool_destroy() really does dma_free_coherent() every page back to the
page allocator - while ent->lay->in_ptr/out_ptr still hold those addresses,
cmdq_addr_h/l is still programmed, and bus mastering is still enabled
(remove_one() runs mlx5_uninit_one() before mlx5_pci_close(), as the commit
message notes).

The patch's own evidence is firmware completing commands long after the
driver gave up ("Command completion arrived after timeout" logged hundreds of
times).  Is there a documented flush semantic tying DISABLE_HCA to
previously posted, uncompleted commands?

The driver already has a per-slot signal, used by poll_timeout():

		own = READ_ONCE(ent->lay->status_own);
		if (!(own & CMD_OWNER_HW)) {

Would gating the release on CMD_OWNER_HW per slot remove the dependence on
that assumption, and also let the fw_stopped == false paths reclaim the slots
firmware did quietly finish?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260915225941.554568-1-dcostantino%40meta.com
