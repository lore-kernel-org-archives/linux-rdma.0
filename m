Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEE8361666;
	Sat, 19 Sep 2026 23:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789861298; cv=none; b=Rx8C3wHz9NZXZe8BOKRgTlzQT/DxWwa72xDVc+hnEOT4DNtYqzRMK8zNUCPOncOZ1oGjS23qIlHII7dsMCCdnfZP70APTfd/LemTaSB6jBv6tYeybSepJvdKnXTTaCNoppmyhnoebMKmChUCnrlgfxC+htWFTbq41LT42qDtGfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789861298; c=relaxed/simple;
	bh=Z4d0x7Dr0ejzRJSdmL0N5bRKOKfhQS5xdU0SN08NMIM=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=G8UALOpnxF1vpNnf8BY7YrB1LUHACgrhjvFXuSiozRGTSx0wI0iHx4BywfxBG6JVFIbN9wWbP7djHinlK3hvFRxG17/vbIAJMBwvTo+acvKDNwyD4MGlUOHaWVfufuADgHOVxLfTHLtI9fneE6oLxKW/4vR7jzmTiKy9FhYAOsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E8WmbXsK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E8WmbXsK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 880BC1F000FF;
	Sat, 19 Sep 2026 23:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789861296;
	bh=P3BhPCNyAJH8twPsTqtFEK4OWwZX5PkOKGOiNq1guII=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=E8WmbXsKQ05pL1m5YUi9cldGd7pMdUhcNKP3VFNx//2VjUXpuGAw4KFc3gqdr04Bg
	 0rgfHKL85CYr/+kw4WpguD/d89J5X/IW6oFqrrdziLD2GXBKPHfSPvXdseFj8GWqK2
	 USs6HGfCuNS/gg34siu8npEtc4ILyILs4inYaCwr7pW4gE6iSrGyI/4NibAPxorZ8u
	 uchJ2PbcIqE+pHRlU30v3uVEe9sF0xjE5eDGhUJdxsQEDC0BE+OhqpoEv4pnMC4eVl
	 S7KpHaFdU9rCYw8qtaQCV4xgGdi06jWcfc7C+WYBXWXe7QBxB2JdlUmNbLNc5tsDQE
	 DkF5liNT/peDQ==
Subject: Re: [PATCH net 1/2] net/mlx5: Bound the command interface drain so
 teardown cannot hang
From: netdev-bot+sashiko@kernel.org
To: dcostantino@meta.com
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, moshe@nvidia.com, eranbe@nvidia.com,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Sat, 19 Sep 2026 23:41:35 +0000
Message-ID: <178986129510.22033.3641334936353721588@kernel.org>
In-Reply-To: <20260915225941.554568-2-dcostantino@meta.com>
References: <20260915225941.554568-2-dcostantino@meta.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 8 potential
issue(s) to consider:

Critical: 0 · High: 3 · Medium: 5 · Low: 0

- [High] mlx5_cmd_change_mod() writes dev->cmd.mode unconditionally
  (cmd.c:1732) even when cmd_sem_down_all() has just reported that the…
- [High] With the drain bounded, teardown now proceeds while firmware
  still owns command-interface DMA, and two frees on that path are not…
- [High] The partial-drain path lets a genuinely live command remain in
  flight when destroy_async_eqs() proceeds to destroy the cmd EQ, which…
- [Medium] Commit message contradicts the code (and the code's own
  comment) for mlx5_cmd_allowed_opcode().
- [Medium] mlx5_cmd_allowed_opcode() can now silently decline to apply a
  narrowing request (cmd.c:1717-1721) but still returns void, and…
- [Medium] In cmd_sem_down_all() the page-queue semaphore is never even
  attempted once the register-slot loop exhausts the shared deadline,…
- [Medium] cmd_sem_down_all() budgets a single command timeout for up to
  max_reg_cmds + 1 sequential semaphore acquisitions (one `end` computed…
- [Medium] mlx5_cmd_allowed_opcode() writes cmd->allowed_opcode =
  CMD_ALLOWED_OPCODE_ALL unconditionally on the failed-drain path, on…

--

net/mlx5: Bound the command interface drain so teardown cannot hang

This replaces the unbounded down() loops in mlx5_cmd_allowed_opcode() and
mlx5_cmd_change_mod() with a shared helper, cmd_sem_down_all(), that bounds
each acquisition by the command timeout and warns instead of blocking when
the interface does not drain.  A matching cmd_sem_up_all() releases only
what was acquired.

A few questions about the changelog and the new code below.

>From the changelog:

> Bound the wait by the command timeout, which is the longest a command that
> is merely in flight can legitimately take, and update the field without a
> full drain if it expires.

and

> Failing to drain is worth a warning but not a hang: the entries still
> holding units have already timed out, so they are the least likely to be
> disturbed by the update, and the alternative is an unrecoverable teardown.

[Severity: Medium]
Does the code match this description for mlx5_cmd_allowed_opcode()?

For any opcode other than CMD_ALLOWED_OPCODE_ALL the field is not updated
when the drain expires, only a warning is printed, so the narrowing
requested by create_async_eqs() (MLX5_CMD_OP_CREATE_EQ) and
destroy_async_eqs() (MLX5_CMD_OP_DESTROY_EQ) is dropped rather than
applied.

The in-code comment added by the same hunk argues the opposite safety model
from the changelog, namely that updating without a drain would hand
firmware-owned mailboxes back to dev->cmd.pool.

Meanwhile mlx5_cmd_change_mod() does write dev->cmd.mode unconditionally
after a failed drain, so the two callers behave differently on the timeout
path.

Could the changelog describe that asymmetry, and note that a
mlx5_cmd_allowed_opcode() call can now become a no-op?  This matters for
the stable backport this is tagged for.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> index 84583dc5eb1c0..571ed540957b1 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> @@ -1656,36 +1656,81 @@ static void create_debugfs_files(struct mlx5_core_dev *dev)
>  	debugfs_create_file("run", 0200, dbg->dbg_root, dev, &fops);
>  }
>  
> -void mlx5_cmd_allowed_opcode(struct mlx5_core_dev *dev, u16 opcode)
> +/* Drain the command interface so that cmd->allowed_opcode and cmd->mode can be
> + * updated without an in flight command straddling the change.  A command that
> + * timed out keeps its index, and with it its semaphore unit, until firmware
> + * completes it - which may never happen - so bound the wait by the command
> + * timeout instead of blocking forever.  Returns the number of cmd->vars.sem
> + * units taken, and reports separately whether the page queue unit was taken;
> + * both have to be handed back by cmd_sem_up_all().
> + */
> +static int cmd_sem_down_all(struct mlx5_core_dev *dev, bool *pages_sem)
>  {
> +	unsigned long end = jiffies + msecs_to_jiffies(mlx5_tout_ms(dev, CMD));

[Severity: Medium]
Is one command timeout enough budget for max_reg_cmds + 1 sequential
acquisitions?  A single deadline is computed here and shared by every
down_timeout() below.

mlx5_tout_ms(dev, CMD) is also the per-command bound used by
cmd_work_handler() and wait_func(), so a device with no stalled command at
all can fail this drain: a command posted shortly after the drain started
may legitimately still be in flight when the shared deadline expires.

Doesn't that make the degraded paths reachable in normal operation, and
contradict the changelog claim that "the entries still holding units have
already timed out"?  Would a per-acquisition deadline, or a budget scaled
by the slot count, bound the wait without failing on a busy but healthy
interface?

>  	struct mlx5_cmd *cmd = &dev->cmd;
> +	long left;
>  	int i;
>  
> -	for (i = 0; i < cmd->vars.max_reg_cmds; i++)
> -		down(&cmd->vars.sem);
> -	down(&cmd->vars.pages_sem);
> +	for (i = 0; i < cmd->vars.max_reg_cmds; i++) {
> +		left = end - jiffies;
> +		if (left <= 0 || down_timeout(&cmd->vars.sem, left))
> +			break;
> +	}

[Severity: High]
Can returning here without a full drain let a genuinely live command
coexist with destruction of the command EQ, and turn into a read of freed
DMA memory?

If such a command's waiter took the events branch in wait_func() (it read
cmd->mode before the flip), it expires and calls:

  wait_func_handle_exec_timeout()
    mlx5_cmd_eq_recover()
      mlx5_eq_async_int(&eq->irq_nb, ASYNC_EQ_RECOVER, NULL)
        next_eqe_sw(eq)          /* walks eq->frag_buf */

while the teardown thread runs:

  destroy_async_eqs()
    cleanup_async_eq(dev, &table->cmd_eq, "cmd")
      destroy_async_eq()
        destroy_unmap_eq()
          mlx5_frag_buf_free(dev, &eq->frag_buf);

mlx5_cmd_eq_recover() uses &dev->priv.eq_table->cmd_eq unconditionally and
serializes only on eq_async->lock, which destroy_unmap_eq() does not take.
The garbage read out of the freed ring is then dispatched through
atomic_notifier_call_chain(&eqt->nh[eqe->type], ...), so a bogus
MLX5_EVENT_TYPE_CMD could reach mlx5_cmd_comp_handler().

cb_timeout_handler() reaches mlx5_cmd_eq_recover() the same way for
asynchronous commands, and teardown does not flush that delayed work
before destroying the EQ.

Before this patch the unbounded drain guaranteed no command was in flight
past the update, so neither entry point could run concurrently with cmd EQ
destruction.  The follow-up patch in the series does not address this
either, since its cancel_delayed_work_sync() runs later, in
mlx5_cmd_disable(), after the EQs are gone.

>  
> -	cmd->allowed_opcode = opcode;
> +	left = end - jiffies;
> +	*pages_sem = left > 0 && !down_timeout(&cmd->vars.pages_sem, left);

[Severity: Medium]
Is this pages_sem attempt reachable at all after the loop above breaks?

down_timeout() only returns non-zero once it has consumed the whole
remaining timeout (___down_common() returns -ETIME after schedule_timeout()
has expired), so on the break path jiffies has already reached end and the
recomputed left is <= 0.

That makes *pages_sem unconditionally false whenever a register slot timed
out: cmd->vars.pages_sem is never touched even if the page queue slot was
completely idle, and mlx5_cmd_change_mod() then flips dev->cmd.mode with
the page queue not drained.

>  
> -	up(&cmd->vars.pages_sem);
> -	for (i = 0; i < cmd->vars.max_reg_cmds; i++)
> +	if (i < cmd->vars.max_reg_cmds)
> +		mlx5_core_warn(dev, "command interface did not drain, %d of %d slots still busy\n",
> +			       cmd->vars.max_reg_cmds - i, cmd->vars.max_reg_cmds);
> +	if (!*pages_sem)
> +		mlx5_core_warn(dev, "command interface did not drain, page queue slot still busy\n");

[Severity: Medium]
Following on from the above, does this second warning misattribute the
failure?  Given left is provably <= 0 after the loop breaks, "page queue
slot still busy" is printed whenever a register slot timed out, even
though pages_sem was never contended and never even sampled.

[Severity: High]
With the drain now warning and continuing, does teardown reach two frees
that are not gated on firmware being finished with the memory?

destroy_async_eqs() proceeds to cleanup_async_eq(dev, &table->cmd_eq),
and with the register slots stalled the DESTROY_EQ command fails
(-ETIMEDOUT, -EAGAIN from mlx5_cmd_all_stalled(), or -ENXIO), yet
destroy_unmap_eq() frees the buffer anyway:

  err = mlx5_cmd_destroy_eq(dev, eq->eqn);
  if (err)
          mlx5_core_warn(dev, "failed to destroy a previously created eq: eqn %d\n",
                         eq->eqn);

  mlx5_frag_buf_free(dev, &eq->frag_buf);

so firmware is left with a live EQ programmed at DMA addresses that have
just been released.

Teardown then continues into mlx5_cmd_disable() -> free_cmd_page(), which
dma_free_coherent()s cmd->cmd_alloc_buf.  That page still holds the
mlx5_cmd_layout of every retained (timed out) entry with status_own ==
CMD_OWNER_HW, and remove_one() has not yet disabled bus mastering.

Before this patch, teardown of a device with a stalled slot hung inside
mlx5_cmd_allowed_opcode(), so mlx5_unload() never reached these frees with
retained entries.

The follow-up patch in the series ("net/mlx5: Don't return firmware-owned
command mailboxes to the DMA pool") does close the mailbox, entry-leak and
cb_timeout_work parts of this via cmd_reclaim_stalled_ents(), but it does
not gate destroy_unmap_eq()'s frag_buf free and keeps free_cmd_page()
unconditional, so these two remain at the end of the series.

> +
> +	return i;
> +}
> +
> +static void cmd_sem_up_all(struct mlx5_core_dev *dev, int nr, bool pages_sem)
> +{
> +	struct mlx5_cmd *cmd = &dev->cmd;
> +
> +	if (pages_sem)
> +		up(&cmd->vars.pages_sem);
> +	while (nr--)
>  		up(&cmd->vars.sem);
>  }
>  
> -static void mlx5_cmd_change_mod(struct mlx5_core_dev *dev, int mode)
> +void mlx5_cmd_allowed_opcode(struct mlx5_core_dev *dev, u16 opcode)
>  {
>  	struct mlx5_cmd *cmd = &dev->cmd;
> -	int i;
> +	bool pages_sem;
> +	int nr;
>  
> -	for (i = 0; i < cmd->vars.max_reg_cmds; i++)
> -		down(&cmd->vars.sem);
> -	down(&cmd->vars.pages_sem);
> +	nr = cmd_sem_down_all(dev, &pages_sem);
>  
> -	cmd->mode = mode;
> +	/* Narrowing the set is only safe once the interface has drained.
> +	 * mlx5_cmd_comp_handler() reads !opcode_allowed() as "no real
> +	 * firmware completion is expected" and releases the entry, so
> +	 * narrowing while a command is still posted would hand its mailboxes
> +	 * back to dev->cmd.pool with firmware still able to write them.
> +	 * Widening back to CMD_ALLOWED_OPCODE_ALL is always safe.
> +	 */

[Severity: Medium]
Is widening really always safe?  opcode_allowed() is evaluated twice for
the same entry and both evaluations have to agree.

First in cmd_work_handler(), which takes a reference and then, because the
opcode is not allowed, completes the entry without ringing the doorbell:

  cmd_ent_get(ent); /* for the _real_ FW event on completion */
  /* Skip sending command to fw if internal error */
  if (mlx5_cmd_is_down(dev) || !opcode_allowed(&dev->cmd, ent->op)) {
          ent->ret = -ENXIO;
          mlx5_cmd_comp_handler(dev, 1ULL << ent->idx, true);
          return;
  }

and again in mlx5_cmd_comp_handler(), where dropping that reference is
conditional:

  if (!forced || /* Real FW completion */
      mlx5_cmd_is_down(dev) || /* No real FW completion is expected */
      !opcode_allowed(cmd, ent->op))
          cmd_ent_put(ent);

If the unconditional widening store below lands between the two, all three
terms are false and cmd_ent_put() is skipped for a command firmware never
saw.  The refcount then never reaches zero, so cmd_free_index() and
up(&cmd->vars.sem) never run and the slot, its semaphore unit, the
mlx5_cmd_work_ent and its mailboxes are lost.

Doesn't that recreate the never-returned-unit condition this commit exists
to fix, for the drain paths and mlx5_cmd_flush()?  Before this patch the
store required every sem unit while cmd_work_handler() holds one for this
entry, so the window did not exist.  The follow-up patch reclaims such
entries at mlx5_cmd_disable(), so the loss lasts until unload rather than
forever, but the race window itself stays open at the end of the series.

> +	if (opcode == CMD_ALLOWED_OPCODE_ALL ||
> +	    (nr == cmd->vars.max_reg_cmds && pages_sem))
> +		cmd->allowed_opcode = opcode;
> +	else
> +		mlx5_core_warn(dev, "leaving command opcodes unrestricted, interface did not drain\n");

[Severity: Medium]
Should the callers be able to see that the narrowing was declined?
mlx5_cmd_allowed_opcode() still returns void and neither in-tree call site
was updated.

create_async_eqs() and destroy_async_eqs() install the restriction
precisely so that, while the command EQ is being created or destroyed, only
MLX5_CMD_OP_CREATE_EQ / MLX5_CMD_OP_DESTROY_EQ can be posted.  That
restriction is what makes cmd_work_handler() and cmd_exec() short-circuit
every other opcode to -ENXIO via opcode_allowed().

After this hunk the invariant can quietly not hold, and destroy_async_eqs()
continues into mlx5_cmd_use_polling() and cleanup_async_eq(dev,
&table->cmd_eq) with unrelated commands still admitted to firmware.

>  
> -	up(&cmd->vars.pages_sem);
> -	for (i = 0; i < cmd->vars.max_reg_cmds; i++)
> -		up(&cmd->vars.sem);
> +	cmd_sem_up_all(dev, nr, pages_sem);
> +}
> +
> +static void mlx5_cmd_change_mod(struct mlx5_core_dev *dev, int mode)
> +{
> +	bool pages_sem;
> +	int nr;
> +
> +	nr = cmd_sem_down_all(dev, &pages_sem);
> +	dev->cmd.mode = mode;

[Severity: High]
Can writing dev->cmd.mode here after a partial drain reintroduce the
indefinite hang this patch sets out to remove?

The full drain was the only thing serializing cmd->mode against the two
reads that belong to one command's lifetime.  cmd_work_handler() latches it
before the doorbell:

  cmd_mode = cmd->mode;
  ...
  /* a command latched as CMD_MODE_EVENTS is never polled here */

and wait_func() re-reads the live value:

  if (cmd->mode == CMD_MODE_POLLING || ent->polling)
          wait_for_completion(&ent->done);

so an events-mode command whose waiter observes CMD_MODE_POLLING takes the
untimed wait_for_completion().

CPU0                                    CPU1
cmd_work_handler()
  cmd_mode = CMD_MODE_EVENTS
  ring doorbell
                                        destroy_async_eqs()
                                          mlx5_cmd_use_polling()
                                            mlx5_cmd_change_mod()
                                              partial drain
                                              dev->cmd.mode = CMD_MODE_POLLING
                                            mlx5_eq_notifier_unregister()
                                          cleanup_async_eq(cmd_eq)
wait_func()
  reads CMD_MODE_POLLING
  wait_for_completion(&ent->done)  /* nothing left to complete it */

The notifier is unregistered right after the store and the command EQ is
destroyed next, so no completion source remains and the submitter stays in
D state, which is the state the changelog is trying to eliminate.

Before this patch the store required every cmd->vars.sem unit, and
mlx5_cmd_invoke() holds the entry's reference (hence its unit) across all
of wait_func(), so no in-flight command could straddle the change.

On a related note, cmd->mode and cmd->allowed_opcode are now plain
unannotated loads and stores shared between process context, the cmd
workqueue and the EQ path with no lock at all on the timeout path.

The follow-up patch in the series adds cmd_reclaim_stalled_ents() in
mlx5_cmd_disable() but never complete()s ent->done, so this waiter still
hangs at the end of the series.

> +	cmd_sem_up_all(dev, nr, pages_sem);
>  }
>  
>  static int cmd_comp_notifier(struct notifier_block *nb,

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260915225941.554568-1-dcostantino%40meta.com
