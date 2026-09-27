Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FA93624A6;
	Sun, 27 Sep 2026 19:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790536932; cv=none; b=jy59beYOTId+18QSN5vmMCXSGYdjWLoJ27dUCdHZvBnr5ZPGzam6mvmg1dpmFL9dcnGVgw9w1V85MypqdkET4zYHF5hDIO6gv4JEvVw6PshyKWExaQtG+Z5ou4Pp5qc6KMjOs/piOxSmU6u2QSLf9rnnaSYuETjYhU8zKiXzGpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790536932; c=relaxed/simple;
	bh=4pRDmSimJdkST8a9v2Hoe6TtEZ8i3sGNxrt+hHCPuM4=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ohIvJex4jQUAtgNV+NPNFa2YXgqRaTj0zvCNC7l81Rw0v0va/CqntWwhWidcXVDJnvsL7pEWe7kgFaWpuonDXlOrwv0vzVyDxwtZMVk0bgq2coMPZfnekwWsRA3QCc1ghVlAYn3P6hzQ3kIbvJKXaljeE1pIOZiKnUOvVHmDVoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D2piKuyW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D2piKuyW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75B61F000FF;
	Sun, 27 Sep 2026 19:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790536930;
	bh=8F9joFS01qCJideBiKfaAO8pAx41dj3zeQe2qLcDRW4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=D2piKuyWRA4EMNlpdsRmdjE4DMoxfBJQmYROJh+XGlIGDqufKgjyhZ7CBOLihp4WB
	 S1Vzv4MyhaRo90r79enRU/zVtos09dcfO20XqYLPL0mNYaL0PYeJO8oZwTSrgikDWn
	 M7JSBhnvTk2PumPar2IG/2hPPC3lJwGczBQhwq7GneUNhURT2zIjXO6mnT5ZGgXH70
	 vJa1hglH7xLt/pkqxtlq+Y7AGKOxtP/xaMXRcETgnfU03m28XIhO1TMfWc8I/ooeNo
	 GpP2LZOSPx+kYHVtwC1o4I+JUtW0xfpGLE9gNdm9O3985tH6yZZYLScoSKJHMEGjK6
	 nEKUVT6U/K1fQ==
Subject: Re: [PATCH net v2] net/mlx5: Don't return firmware-owned command
 mailboxes to the DMA pool
From: netdev-bot+sashiko@kernel.org
To: dcostantino@meta.com
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, moshe@nvidia.com, eranbe@nvidia.com,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Sun, 27 Sep 2026 19:22:09 +0000
Message-ID: <179053692935.3145.9499750768128839597@kernel.org>
In-Reply-To: <20260923190542.848049-1-dcostantino@meta.com>
References: <20260923190542.848049-1-dcostantino@meta.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 5 potential
issue(s) to consider.

Critical: 0 · High: 1 (2) · Medium: 3 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] Moving the mailbox free into cmd_ent_put() makes it run on
  whichever context drops the last reference, with nothing synchronising…
- [Medium] The commit message says an entry that firmware never completes
  "keeps its mailboxes for the lifetime of the device" and calls the…
- [Medium] Mailbox retention depends on which reference happens to be
  dropped last, not on whether firmware still owns the descriptor.
- [Medium] Retained mailboxes can outlive the dma_pool they came from,
  but are freed through whatever dev->cmd.pool points to at put time.
- [Low] The kernel-doc above mlx5_cmd_invoke() (cmd.c ~1252-1266) says
  that for !callback, 'ret < 0 : Command execution couldn't be submitted…

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but a command that
  times out while the device is up holds its command slot, and the slot…
- [High] This problem wasn't introduced by this patch, but on the
  synchronous path a sync timeout can race with a real completion and…

--

net/mlx5: Don't return firmware-owned command mailboxes to the DMA pool

This patch uses a new own_msgs flag to put off freeing a timed-out
command's mailboxes until the final cmd_ent_put() of the command entry.
It does this on both the synchronous and the callback paths. The aim is to
stop late firmware writes from landing in blocks already returned to the
mlx5_cmd dma_pool.

> An entry firmware never completes keeps its mailboxes for the lifetime of
> the device. dma_pool_destroy() then reports the pool busy and declines to
> free its pages, which is the memory safe outcome: the pages stay mapped,
> so a late write lands there rather than in memory handed back to the
> allocator.

[Severity: Medium]
Is "for the lifetime of the device" accurate here? The mlx5_cmd dma_pool
is created in mlx5_cmd_enable() and destroyed in mlx5_cmd_disable(). Those
run from mlx5_function_enable()/mlx5_function_disable() on every
load/unload cycle, not only at probe/remove:

mlx5_cmd_enable()
    cmd->pool = dma_pool_create("mlx5_cmd", mlx5_core_dma_dev(dev), size, align, 0);
    ...
    create_msg_cache(dev);

mlx5_cmd_disable()
    destroy_msg_cache(dev);
    free_cmd_page(dev, cmd);
    dma_pool_destroy(cmd->pool);

If a retained entry still holds blocks, dma_pool_destroy() skips
dma_free_coherent() for every page in the pool. That includes the pages
behind the message cache that destroy_msg_cache() has just returned:
512x1 + 32x2 + 16x16 + 8x256 + 2x512 = 3904 blocks of 1024 bytes.

So each command interface incarnation that ends with an unrecovered
timed-out mailbox appears to leak about 4 MB of DMA-coherent memory. The
entry and its msg structs are never freed either. Before this patch the
pool was torn down cleanly, because cmd_exec() had already freed the
mailboxes.

Two ways this can be reached:

- A MANAGE_PAGES timeout in
  mlx5_function_disable()->mlx5_reclaim_startup_pages(), followed by
  mlx5_core_disable_hca() and mlx5_cmd_disable().
- A timeout during mlx5_function_enable()/mlx5_function_open(), followed
  by the error unwind.

Later pool incarnations start fresh, so this happens once per
unrecovered timeout followed by a teardown, not on every later disable.

Given the Cc: stable tag, could the commit message describe this cost
more precisely?

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> index 84583dc5eb1c0..4051f97b2ae12 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c

[ ... ]

> @@ -207,6 +214,11 @@ static void cmd_ent_put(struct mlx5_cmd_work_ent *ent)
>  	}
>  	spin_unlock_irqrestore(&cmd->alloc_lock, flags);
>  
> +	if (ent->own_msgs) {
> +		mlx5_free_cmd_msg(dev, ent->out);
> +		free_msg(dev, ent->in);
> +	}
> +

[Severity: Medium]
Can a retained mailbox end up freed into a different dma_pool than the
one it was allocated from? These frees always go through whatever
dev->cmd.pool and dev->cmd.cache[] are when the last put happens.

One possible sequence:

1. A timed-out entry keeps its FW reference, with own_msgs set.

2. mlx5_cmd_disable() runs destroy_msg_cache() and dma_pool_destroy().
   The pool is busy, so its pages are kept, but the struct dma_pool is
   still kfree()d.

3. mlx5_cmd_enable() does memset(&cmd->vars, 0, ...), sets
   cmd->vars.bitmask = MLX5_CMD_MASK, and creates a new pool and cache.
   cmd->ent_arr[] is outside vars and is not cleared, so ent_arr[i]
   still points at the stale entry.

4. A non-forced completion for bit i arrives before slot i is reused.
   mlx5_cmd_comp_handler() finds PENDING_COMP clear, logs "Command
   completion arrived after timeout" and calls cmd_ent_put().

5. That is the final reference. mlx5_free_cmd_msg()->free_cmd_box() then
   calls dma_pool_free(dev->cmd.pool, ...) on the new pool with a block
   from the old one. Without DMAPOOL_DEBUG, pool_block_err() does not
   catch this. The block goes onto the new pool's free list, and the new
   pool's nr_active is decremented.

6. free_msg(dev, ent->in) also adds an old-pool cached msg to the rebuilt
   cache list.

After that, the new pool's nr_active can read 0 while another timed-out
entry still owns a real block. A later dma_pool_destroy() would then
dma_free_coherent() pages that firmware may still write to.

Before this patch, a stale final put only did cmd_free_index(), up() and
kfree(ent). It never touched the pool or the cache.

>  	cmd_free_ent(ent);
>  }
>  
> @@ -958,10 +970,6 @@ static void cb_timeout_handler(struct work_struct *work)
>  	cmd_ent_put(ent); /* for the cmd_ent_get() took on schedule delayed work */
>  }

[Severity: High]
Now that cmd_ent_put() can free mailboxes, can this put race with
command interface teardown?

cmd_work_handler() takes a reference for the timeout work:

    if (ent->callback && schedule_delayed_work(&ent->cb_timeout_work, timeout))
        cmd_ent_get(ent);

Take the "Async, recovered after timeout" case.
mlx5_cmd_eq_recover() recovers the EQE, and mlx5_cmd_comp_handler()
cannot cancel the running work, because cancel_delayed_work() returns
false. The handler drops the FW and consumer references, sets own_msgs
and calls the callback.

That leaves the put above in cb_timeout_handler(), running on
system_wq, as the final one. The same happens when a real completion
races with the timeout work.

In cmd_ent_put() the slot and semaphore are released under alloc_lock,
and the mailboxes are only freed after the lock is dropped:

    cmd_free_index(cmd, ent->idx);
    up(ent->page_queue ? &cmd->vars.pages_sem : &cmd->vars.sem);
    ...
    spin_unlock_irqrestore(&cmd->alloc_lock, flags);

    if (ent->own_msgs) {
        mlx5_free_cmd_msg(dev, ent->out);
        free_msg(dev, ent->in);
    }

The teardown paths don't wait for that free:

- mlx5_cmd_allowed_opcode() and mlx5_cmd_flush() only wait for the up().
- mlx5_cmd_cleanup_async_ctx() only waits for the callback.
- mlx5_cmd_disable() only flushes cmd->wq, not system_wq.

Suppose this worker is delayed just after the up(). Could
mlx5_cmd_disable() get through destroy_msg_cache() and dma_pool_destroy()
first? The pool is busy, so its struct is kfree()d. The worker would then
call dma_pool_free() on the freed pool, or on a newly created one, and
list_add_tail() onto a destroyed or re-initialised cache list.

[ ... ]

> @@ -1313,7 +1321,12 @@ static int mlx5_cmd_invoke(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *in,
>  		return 0; /* mlx5_cmd_comp_handler() will put(ent) */
>  
>  	err = wait_func(dev, ent);
> -	if (err == -ETIMEDOUT || err == -ECANCELED || err == -EBUSY)
> +	if (err == -ETIMEDOUT) {
> +		/* firmware may still DMA into the mailboxes; keep them */
> +		ent->own_msgs = true;
> +		goto out_free;
> +	}

[Severity: High]
This isn't a bug introduced by this patch, but can a sync timeout race
with a real completion and free ent and its messages while the IRQ side
is still using them?

CPU A: wait_func_handle_exec_timeout()
    ent->ret = -ETIMEDOUT;
    mlx5_cmd_comp_handler(dev, 1ULL << ent->idx, true);
        loses test_and_clear_bit(MLX5_CMD_ENT_STATE_PENDING_COMP)
        continue;

CPU B: EQ IRQ, mlx5_cmd_comp_handler(dev, vec, false)
    wins test_and_clear_bit(MLX5_CMD_ENT_STATE_PENDING_COMP)
    cmd_ent_put(ent);        /* refcount 2 -> 1 */
    ent->ts2 = ktime_get_ns();
    memcpy(ent->out->first.data, ent->lay->out, sizeof(ent->lay->out));
    dump_command(dev, ent, 0);
    ...
    complete(&ent->done);

On CPU A, wait_func() returns -ETIMEDOUT without waiting on ent->done
again. mlx5_cmd_invoke() sets own_msgs and makes the final
cmd_ent_put() (1 -> 0), which frees ent->out, ent->in and ent. CPU B may
still be writing ent->out and calling complete(&ent->done) at that point.

The same window existed before, with cmd_exec() freeing the messages
right after the put. This change moves the frees into that final put but
doesn't close the window.

[Severity: Low]
This isn't a bug, but the kernel-doc above mlx5_cmd_invoke() still says:

 * return value in case (!callback):
 *	ret < 0 : Command execution couldn't be submitted by driver

With this change, -ETIMEDOUT means the command was submitted and in/out
now belong to the entry, so the caller must not free them. Only
cmd_exec() knows this, through the new goto out_up. Could the comment
document the ownership transfer, so a future caller that frees on a
negative return doesn't double-free?

> +	if (err == -ECANCELED || err == -EBUSY)
>  		goto out_free;
>  
>  	ds = ent->ts2 - ent->ts1;
> @@ -1816,8 +1829,10 @@ static void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool force
>  								 ent->out,
>  								 ent->uout_size);
>  
> -				mlx5_free_cmd_msg(dev, ent->out);
> -				free_msg(dev, ent->in);
> +				/* firmware may still DMA into the mailboxes;
> +				 * keep them
> +				 */
> +				ent->own_msgs = true;
>  
>  				/* final consumer is done, release ent */
>  				cmd_ent_put(ent);

[Severity: High]
This is a pre-existing issue, not one introduced by this patch. It is
raised here because the patch handles exactly these retained entries.
Can a command that times out while the device is up hold its slot
semaphore forever, and leave mlx5_cmd_flush() spinning?

After the timeout, the forced mlx5_cmd_comp_handler() clears
PENDING_COMP but keeps the FW reference, because mlx5_cmd_is_down() is
false and the opcode is allowed. The final cmd_ent_put(), which does
up(&cmd->vars.sem), therefore only runs on a real completion.

enter_error_state() then sets MLX5_DEVICE_STATE_INTERNAL_ERROR and calls
mlx5_cmd_flush():

	for (i = 0; i < cmd->vars.max_reg_cmds; i++) {
		while (down_trylock(&cmd->vars.sem)) {
			mlx5_cmd_trigger_completions(dev);
			cond_resched();
		}
	}

For the timed-out entry, mlx5_cmd_trigger_completions() takes and drops
a temporary reference. The forced handler finds PENDING_COMP already
clear and hits continue without a put. cmd_comp_notifier() ignores real
EQEs once dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR, so the permit
never comes back.

This loop is reached from the fatal health reporter, PCI err_detected,
sync FW reset, and shutdown through
mlx5_try_fast_unload()->mlx5_enter_error_state(). Those callers hold
intf_state_mutex while it runs. On unload, the same held permit also
blocks the down() loops in mlx5_cmd_allowed_opcode() and
mlx5_cmd_change_mod().

Wouldn't recovery, unload and reboot all hang here?

[ ... ]

> @@ -2012,6 +2027,9 @@ static int cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
>  	if (callback && !err)
>  		return 0;
>  
> +	if (err == -ETIMEDOUT) /* the command entry owns the mailboxes now */
> +		goto out_up;
> +

[Severity: Medium]
Does this cover every case where firmware still owns the mailboxes?
Whether they are kept seems to depend on which reference is dropped
last, not on whether the descriptor is still owned by hardware.

First, a forced completion in mlx5_cmd_comp_handler() still drops the
FW reference when the device looks down:

			if (!forced || /* Real FW completion */
			     mlx5_cmd_is_down(dev) || /* No real FW completion is expected */
			     !opcode_allowed(cmd, ent->op))
				cmd_ent_put(ent);

mlx5_cmd_is_down() becomes true as soon as poll_health() sets
MLX5_DEVICE_STATE_INTERNAL_ERROR on a fatal sensor (for example
MLX5_SENSOR_FW_SYND_RFR). That happens before any reset or DMA
quiescence.

If wait_func_handle_exec_timeout() fires in that state, the put in
mlx5_cmd_invoke() is final. cmd_ent_put() then frees ent->in and ent->out
straight away, even though own_msgs was just set. On the async path the
put in cb_timeout_handler() is the final one.

Second, mlx5_cmd_flush()->mlx5_cmd_trigger_completions() force-completes
every allocated slot with MLX5_TRIGGERED_CMD_COMP, so ent->ret becomes
-ENXIO.

For sync commands, only -ETIMEDOUT is special-cased above. -ENXIO falls
through to out_out, and mlx5_free_cmd_msg()/free_msg() release blocks
for commands that have already been doorbelled. For callback commands,
own_msgs is set, but the is_down check drops the FW reference and the
trigger loop's cmd_ent_put() frees them.

If firmware completes one of these commands before the reset, couldn't
the late write land in a freed block, or in pool pages freed by a later
clean dma_pool_destroy()? That is the same corruption the commit message
describes.

The new "firmware may still DMA into the mailboxes; keep them" comments
promise a retention that these paths don't provide.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260923190542.848049-1-dcostantino%40meta.com
