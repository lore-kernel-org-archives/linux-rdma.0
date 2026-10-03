Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA3BF9C0;
	Sat,  3 Oct 2026 21:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791062286; cv=none; b=riAkSlps6z46IpI1Y6w3vNioLY7/19jxRXK1HVfbp4FNR5fDbTT8yuumJv2luTYvKsa3z7FnjJySm6+EQRaVvgLq+P3Dji4TCMo4z8fEbelXUp9qOwyaK1NZRu7hLfqPwK7EG4jCLjCEl5dw0Lbu0TkBPtSLpe/poFC3L188kxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791062286; c=relaxed/simple;
	bh=ZLsF2plflmbBcxSOGvzQeibWPYzBmA29ijqknDixIqo=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=l6lJ8BVTtGOIgnZYm2bMuHKwEQr6FA8o1dWcP/cqjK6oFLl64oCmzGSBJcg3imDgRzcAw9sUu5yTMr44PDbsauF+uXz1d7KbIHN81U7IKJWUqWfCRD7mHvviJYd0Hu68xlGOAc/nk1rdKcOAT9l6aMdmGsz4ll2hA42cQGf+rZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h9EAlRD7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h9EAlRD7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A64C1F0089B;
	Sat,  3 Oct 2026 21:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791062284;
	bh=xNYWnZe4divXd2C0N8UxZFaZN7XIrsH9DcMfpJRx3Q0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=h9EAlRD78HuKWx7B7N7B75d43/2UpRiQMUOnjnwJ/Rk7rFUyCDKjvzShQ5DX8PIJl
	 BkWVDdtCH7UX/ZAAamq6ZEJ5+qiH4xbq98V3Im5Uup1IyjMGLLX0Va7OBHhXFTOZXg
	 Sh/OeaIqNV02vGtaayapihRm/erZHLGttwusKp1I6s42qrUjgAmKgsggfy1BRM8W1G
	 PBG6WE2oNWAqMEbpNTWCAvjKG3YGOZP4gmB+ZtOIRIZQjVN8jRsyr0AugnvB/sWpXj
	 Oc8ZuncF48MZ+1SiYThiPrWD1ON642Ix+Bw/9Fc9jR/SniCPggf1m5G93Nfv8g0Vq9
	 +xekVY4ca+xjA==
Subject: Re: [PATCH net] net/mlx5: retain command mailboxes after timeout
From: netdev-bot+sashiko@kernel.org
To: manjunath.b.patil@oracle.com
Cc: saeedm@nvidia.com, leonro@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org, kuba@kernel.org
Date: Sat, 03 Oct 2026 21:18:03 +0000
Message-ID: <179106228380.434549.9362571159733636097@kernel.org>
In-Reply-To: <20261002205649.2029588-1-manjunath.b.patil@oracle.com>
References: <20261002205649.2029588-1-manjunath.b.patil@oracle.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 2 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] Retained mailboxes are freed after cmd_ent_put() has already
  released the slot.
- [High] A reset flush can now consume the retained FW reference while a
  software EQ-recovery pass is processing the late real completion for…
- [Medium] Mailboxes now owned by the entry are never released on normal
  command-interface teardown, so dma_pool_destroy() finds the pool busy…

--

net/mlx5: retain command mailboxes after timeout

After a command timeout, this patch gives the command entry ownership of
its input and output mailboxes, and cmd_free_ent() frees them on the final
reference. A new helper, mlx5_cmd_claim_completion(), takes the
PENDING_COMP claim and hands off the firmware reference under alloc_lock.
Triggered (reset) completions now drop a reference that an earlier timeout
kept.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> index 84583dc5eb1c0..22508b26972de 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> @@ -142,8 +142,19 @@ cmd_alloc_ent(struct mlx5_cmd *cmd, struct mlx5_cmd_msg *in,
>  	return ent;
>  }
>  
> +static void free_msg(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *msg);
> +static void mlx5_free_cmd_msg(struct mlx5_core_dev *dev,
> +			      struct mlx5_cmd_msg *msg);
> +
>  static void cmd_free_ent(struct mlx5_cmd_work_ent *ent)
>  {
> +	if (test_bit(MLX5_CMD_ENT_STATE_RETAIN_MSGS, &ent->state)) {
> +		struct mlx5_core_dev *dev = container_of(ent->cmd,
> +							  struct mlx5_core_dev, cmd);
> +
> +		mlx5_free_cmd_msg(dev, ent->out);
> +		free_msg(dev, ent->in);
> +	}
>  	kfree(ent);
>  }

[Severity: High]
Can these retained mailboxes be freed after the command DMA pool has
already been destroyed?

cmd_ent_put() releases the slot and the semaphore under alloc_lock. It
then drops the lock and only after that calls cmd_free_ent():

cmd_ent_put() {
    ...
	if (ent->idx >= 0) {
		cmd_free_index(cmd, ent->idx);
		up(ent->page_queue ? &cmd->vars.pages_sem : &cmd->vars.sem);
	}
	spin_unlock_irqrestore(&cmd->alloc_lock, flags);

	cmd_free_ent(ent);
}

With this patch, cmd_free_ent() calls dma_pool_free() on cmd->pool
through mlx5_free_cmd_msg(). free_msg() can also list_add the input msg
back onto msg->parent->head.

For an async command, cb_timeout_handler() runs on system_wq and holds its
own reference. Its forced mlx5_cmd_comp_handler() call sets RETAIN_MSGS and
TIMEDOUT and runs the user callback, so mlx5_async_ctx teardown stops
waiting. Only after that does it call cmd_ent_put().

The firmware reference can be dropped first, either by a late real
completion or by mlx5_cmd_trigger_completions(), which drops both the
firmware reference and its own temporary one. In that case the put in
cb_timeout_handler() is the final one.

Once that put calls up(), the down_trylock() loop in mlx5_cmd_flush() can
succeed. Error recovery or unload can then continue into
mlx5_cmd_disable():

	flush_workqueue(cmd->wq);
	clean_debug_files(dev);
	destroy_msg_cache(dev);
	free_cmd_page(dev, cmd);
	dma_pool_destroy(cmd->pool);

This flushes only cmd->wq. It does not flush system_wq or the
cb_timeout_work items.

Suppose the timeout worker is preempted after it drops alloc_lock and
resumes after this point. Would cmd_free_ent() then call dma_pool_free() on
a freed struct dma_pool, or add the input msg to a destroyed cache list?

Before this patch, this window only covered kfree(ent), which never
touched the pool.

[ ... ]

> @@ -1732,6 +1744,66 @@ static void free_msg(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *msg)
>  	}
>  }
>  
> +/*

[ ... ]

> + * A blocking timeout retains the mailboxes even when a real completion has
> + * claimed PENDING_COMP. That handler keeps its firmware-event reference until
> + * it finishes using the mailboxes. Keeping the reference transitions under
> + * alloc_lock prevents timeout, firmware, and reset from consuming the same
> + * reference.
> + */
> +static bool mlx5_cmd_claim_completion(struct mlx5_core_dev *dev,
> +				      struct mlx5_cmd_work_ent *ent, u64 vec,
> +				      bool forced, bool *drop_fw_ref)
> +{

[ ... ]

> +	} else if (!forced) {
> +		clear_bit(MLX5_CMD_ENT_STATE_TIMEDOUT, &ent->state);
> +		*drop_fw_ref = true;
> +	} else if (vec & MLX5_TRIGGERED_CMD_COMP) {
> +		/* Reset cannot receive a late firmware completion. */
> +		*drop_fw_ref = test_and_clear_bit(MLX5_CMD_ENT_STATE_TIMEDOUT,
> +						  &ent->state);
> +	}

[Severity: High]
Can a reset flush and a late real completion both drop the same retained
firmware reference here?

Start with entry A, which has already timed out (PENDING_COMP clear,
TIMEDOUT set). Only its firmware reference keeps it alive.

Thread R: another command's timeout calls mlx5_cmd_eq_recover(). That runs
mlx5_eq_async_int(ASYNC_EQ_RECOVER) in process context. cmd_comp_notifier()
passes its INTERNAL_ERROR check, and mlx5_cmd_comp_handler(dev, vec, false)
reads ent = cmd->ent_arr[i] without taking a reference.

Thread F: enter_error_state() sets INTERNAL_ERROR and calls
mlx5_cmd_flush()->mlx5_cmd_trigger_completions().
mlx5_eq_synchronize_cmd_irq() does not wait for R, because R is not running
in IRQ context.

The sequence would be:

F: cmd_ent_get(cmd->ent_arr[i])          /* temporary ref */
F: mlx5_cmd_claim_completion()
     vec & MLX5_TRIGGERED_CMD_COMP
     test_and_clear_bit(TIMEDOUT) -> true
   cmd_ent_put(ent)                      /* drops fw ref */
R: mlx5_cmd_claim_completion()
     !forced
     *drop_fw_ref = true                 /* unconditional */
   cmd_ent_put(ent)                      /* drops F's temp ref */
     -> refcount 0, ent_arr[i] = NULL, cmd_free_ent()
F: cmd_ent_put(cmd->ent_arr[i])          /* NULL or a new entry */

Would the trailing put in mlx5_cmd_trigger_completions() then dereference
NULL? Or would it drop a reference on an unrelated entry that has reused
slot i?

If F finishes completely first, R's claim would touch the freed entry
instead.

The comment above says:

    Keeping the reference transitions under alloc_lock prevents timeout,
    firmware, and reset from consuming the same reference.

The !forced branch does not check whether TIMEDOUT is still set, so does
the helper actually enforce this?

In the baseline, the triggered path never dropped the reference of an
entry with TIMEDOUT set, so this sequence stayed balanced.

[ ... ]

> @@ -2008,9 +2082,12 @@ static int cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
>  	}
>  
>  	err = mlx5_cmd_invoke(dev, inb, outb, out, out_size, callback, context,
> -			      pages_queue, token, force_polling);
> +			      pages_queue, token, force_polling, &retain_msgs);
>  	if (callback && !err)
>  		return 0;
> +	/* The entry releases retained DMA mailboxes with its final reference. */
> +	if (retain_msgs)
> +		goto out_up;

[Severity: Medium]
What releases these retained mailboxes on a normal command interface
teardown?

Take a command that times out while the interface is up and its opcode is
allowed. mlx5_cmd_claim_completion() sets RETAIN_MSGS and TIMEDOUT and
keeps the firmware reference. cmd_exec() now skips freeing inb and outb.

Only two things drop that reference: a later real completion, or a
MLX5_TRIGGERED_CMD_COMP flush. The flush only runs from
enter_error_state().

mlx5_function_disable() and the err_cmd_cleanup path in
mlx5_function_enable() call mlx5_cmd_disable() without either:

err_cmd_cleanup:
	mlx5_cmd_set_state(dev, MLX5_CMDIF_STATE_DOWN);
	mlx5_cmd_disable(dev);

mlx5_cmd_disable() then runs destroy_msg_cache() and
dma_pool_destroy(cmd->pool) while the retained blocks are still allocated.
dma_pool_destroy() sees nr_active != 0, prints "dma_pool_destroy mlx5_cmd
busy", and skips dma_free_coherent() for every page.

Does this leak all of the pool's coherent pages, including the ones backing
the whole message cache?

A retained cached input msg is also not on ch->head, so destroy_msg_cache()
never frees it.

Polling mode is active during mlx5_function_enable(), and it seems to reach
this easily:

cmd_work_handler() {
    ...
	if (cmd_mode == CMD_MODE_POLLING || poll_cmd) {
		poll_timeout(ent);
		/* make sure we read the descriptor after ownership is SW */
		rmb();
		mlx5_cmd_comp_handler(dev, 1ULL << ent->idx, !!ent->ret);
	}
}

There is no command EQ yet, so no late completion can arrive. If
MANAGE_PAGES, SET_ISSI or QUERY_ISSI times out and mlx5_function_enable()
then fails, the pool leaks.

Before this patch, cmd_exec() freed the mailboxes at timeout, so only the
ent struct and its slot leaked.

A less certain follow-on: if a triggered flush drops the retained
reference after mlx5_cmd_disable() has run, would cmd_free_ent() call
dma_pool_free() on the destroyed pool? cmd->pool is not cleared.

>  
>  	if (err > 0) /* Failed in FW, command didn't execute */
>  		err = deliv_status_to_err(err);

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261002205649.2029588-1-manjunath.b.patil%40oracle.com
