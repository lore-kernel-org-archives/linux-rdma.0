Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2A93F4854;
	Fri,  4 Sep 2026 04:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788497202; cv=none; b=UqxEy+/IACphAsXh/Nn867oOWqfNUcp0WmhaXeCoDxFbB5fTdvkoGi1l802zEOI64vWLjTdTMK1JL5v6mRDRXTd2JFV8r8UhBFJIZb+FMxv0MCx6qQXXoTvf3eDXNILejJlEI40csatGOS3wn2SGTASSvvadiNCi2CqZS/LhSII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788497202; c=relaxed/simple;
	bh=dXwdsTmKjudN3RT7q+HKMg35ChGVuq0rtAvD9bPETvY=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CybyV3/Zwffmd9MpagBt40R8hb/tROAtXTN3Dx/EfF5C6LTy16iskpx5DNUTTXR/03/3DoTjj9MfXN9sUPh53UuqxI6Mrl+y+I9EDUCPR4RJnyg95iXyDMB2yDjOR4CP6YKGr55fx88TMr2C3+zAQ7MdrqOAJMU+UYFHdHnEFec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hRoaZhf8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hRoaZhf8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C748F1F00A3E;
	Fri,  4 Sep 2026 04:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788497200;
	bh=Mr7Qk9K7+Vzh6ZpFrrIhTro04iPZcSdZlyslfVoABeA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=hRoaZhf8UWm9rC0JkwuQf/q1u2N1tyz0m5FfgDlDsbgpGm30T+FbCZnfhFHcce4K+
	 pcJzmQY6ZUkCPcDRm3Bd+yfkXRbEfSpSoCHs0rzsi5ILUGWoBhN6TBd9wvefGWbbvf
	 FuVm+3hQbnUYEVJNmALAJPx4xiUEr4xEU/oOtfc+0HAFOIpvInQMR0RgzdVTEWidZE
	 8GiS09HGeZoIADGbHr+rXZ5xHM4WWAuPtMDB9MTj8mxVjATqcfLm5cwzNo/pKUDWua
	 d6RsNgvn2noSVepgRA+be8BJRohNUayInkNOOzChKJq6sd5XBQZ84Z3TbYoENn61R9
	 0lwJDVLBPU3pA==
Subject: Re: [PATCH net-next v3 02/13] net: mana: share the EQ pool across a
 queue-set swap
From: netdev-bot+sashiko@kernel.org
To: longli@microsoft.com
Cc: kotaranov@microsoft.com, kuba@kernel.org, davem@davemloft.net,
 pabeni@redhat.com, edumazet@google.com, andrew+netdev@lunn.ch, jgg@ziepe.ca,
 leon@kernel.org, haiyangz@microsoft.com, kys@microsoft.com,
 wei.liu@kernel.org, decui@microsoft.com, shradhagupta@linux.microsoft.com,
 horms@kernel.org, ernis@linux.microsoft.com, stephen@networkplumber.org,
 shirazsaleem@microsoft.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Fri, 04 Sep 2026 04:46:39 +0000
Message-ID: <178849719939.4131868.8782384593868319521@kernel.org>
In-Reply-To: <20260901014442.2945689-3-longli@microsoft.com>
References: <20260901014442.2945689-3-longli@microsoft.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 2 · Low: 1

- [Medium] The patch makes the EQ pool port-owned and grows it against
  the *live* port context from inside the allocation phase, while the…
- [Medium] mana_grow_eqs()
  (drivers/net/ethernet/microsoft/mana/mana_en.c:1835) is the first NIC…
- [Low] mana_qset_scratch_alloc()'s kernel-doc
  (drivers/net/ethernet/microsoft/mana/mana_en.c:3983-3985) still…

--

net: mana: share the EQ pool across a queue-set swap

The EQ array moves from the queue set to the port, so a queue-set swap no
longer needs old + new MSI-X vectors. mana_create_eq() now sizes the array
to apc->max_queues and tracks how many EQs exist in apc->num_eqs, and a new
mana_grow_eqs() adds EQs on demand from mana_alloc_qset().

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index b9d9543d1a6dc..bd80658cf3efc 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c

[ ... ]

> @@ -1814,6 +1821,72 @@ int mana_create_eq(struct mana_port_context *apc)
>  }
>  EXPORT_SYMBOL_NS(mana_create_eq, "NET_MANA");
>  
> +/**
> + * mana_grow_eqs - make sure the port has at least @need EQs
> + * @apc:  port context
> + * @need: number of EQs the new queue set requires
> + *
> + * EQs are bound to MSI-X vectors, so the pool is port-owned and shared across
> + * a swap: peak usage is max(old, new), not the sum. Grow-only, up to
> + * apc->max_queues.
> + *
> + * Return: 0 on success, negative error code on failure.
> + */
> +static int mana_grow_eqs(struct mana_port_context *apc, unsigned int need)
> +{
> +	struct gdma_dev *gd = apc->ac->gdma_dev;
> +	struct gdma_context *gc = gd->gdma_context;
> +	struct gdma_queue_spec spec = {};
> +	struct gdma_irq_context *gic;
> +	unsigned int i;
> +	int err;
> +	int msi;
> +
> +	if (WARN_ON(!apc->eqs))
> +		return -EINVAL;
> +
> +	if (need > apc->max_queues)
> +		return -EINVAL;
> +
> +	if (need <= apc->num_eqs)
> +		return 0;
> +
> +	spec.type = GDMA_EQ;
> +	spec.monitor_avl_buf = false;
> +	spec.queue_size = EQ_SIZE;
> +	spec.eq.callback = NULL;
> +	spec.eq.context = apc->eqs;
> +	spec.eq.log2_throttle_limit = LOG2_EQ_THROTTLE;
> +
> +	for (i = apc->num_eqs; i < need; i++) {
> +		msi = (i + 1) % gc->num_msix_usable;
> +
> +		gic = mana_gd_get_gic(gc, !gc->msi_sharing, &msi);
> +		if (IS_ERR(gic)) {
> +			err = PTR_ERR(gic);
> +			goto out;
> +		}
> +		spec.eq.msix_index = msi;
> +
> +		err = mana_gd_create_mana_eq(gd, &spec, &apc->eqs[i].eq);

[Severity: Medium]
This looks like the first NIC path that creates an EQ while the port is up
and its MSI-X vectors are already delivering interrupts.  Can a vector
interrupt land on the EQ before it is initialized?

mana_gd_create_mana_eq() -> mana_gd_create_eq() publishes the queue to the
handler list first:

gdma_main.c:mana_gd_create_eq() {
	...
	queue->id = INVALID_QUEUE_ID;
	...
	err = mana_gd_register_irq(queue, spec);
	...
	queue->eq.callback = spec->eq.callback;
	queue->eq.context = spec->eq.context;
	queue->head |= INITIALIZED_OWNER_BIT(log2_num_entries);
	...
}

gdma_main.c:mana_gd_register_irq() {
	...
	spin_lock_irqsave(&gic->lock, flags);
	list_add_rcu(&queue->entry, &gic->eq_list);
	spin_unlock_irqrestore(&gic->lock, flags);
}

and the hardirq handler walks that list under RCU only:

gdma_main.c:mana_gd_intr() {
	rcu_read_lock();
	list_for_each_entry_rcu(eq, eq_list, entry) {
		gic->handler(eq);
	}
	rcu_read_unlock();
}

With head still 0 and a zeroed ring, does mana_gd_process_eq_events() miss
its early return?

gdma_main.c:mana_gd_process_eq_events() {
	...
		old_bits = (eq->head / num_eqe - 1) & GDMA_EQE_OWNER_MASK;
		/* No more entries */
		if (owner_bits == old_bits) {
			if (i == 0)
				return;
	...
}

old_bits computes as 7 while owner_bits reads 0, so the handler would
consume zeroed EQEs, advance eq->head and ring the doorbell while
queue->id is still INVALID_QUEUE_ID.  The window spans the
mana_gd_create_hw_eq() and mana_gd_test_eq() HWC round trip.

The sharing precondition holds when gc->msi_sharing is set, and also when
an RDMA EQ already sits on the same index, since that path takes the vector
without setting the NIC bitmap bit:

drivers/infiniband/hw/mana/main.c:mana_ib_create_eqs() {
	...
		gic = mana_gd_get_gic(gc, false, &msi);
	...
}

Would this show up as an intermittent EQ creation failure in
mana_gd_test_eq(), or as missed events on the new queue set?  gdma_main.c is
unchanged across this series, and mana_grow_eqs() is still called on a live
port by mana_grow_qset() at the end of it.

> +		if (err) {
> +			dev_err(gc->dev, "Failed to grow EQ %u : %d\n", i, err);
> +			mana_gd_put_gic(gc, !gc->msi_sharing, msi);
> +			goto out;
> +		}
> +		apc->eqs[i].eq->eq.irq = gic->irq;
> +		mana_create_eq_debugfs(apc, i);
> +		apc->num_eqs = i + 1;
> +	}
> +
> +	return 0;
> +out:
> +	/* Keep whatever was created: the running queue set still needs its
> +	 * own EQs, and the extras are reused by the next attempt.
> +	 */
> +	return err;
> +}
> +

[ ... ]

> @@ -3926,14 +3996,14 @@ struct mana_port_context *mana_qset_scratch_alloc(struct mana_port_context *apc)
>  
>  	*scratch = *apc;
>  
> -	/* Owns no queues yet. */
> -	scratch->eqs		= NULL;
> +	/* EQs stay shared with the live port: they are a vector-backed
> +	 * resource and must not be duplicated for the new set.
> +	 */
>  	scratch->tx_qp		= NULL;
>  	scratch->rxqs		= NULL;
>  	scratch->indir_table	= NULL;
>  	scratch->rxobj_table	= NULL;
>  	scratch->default_rxobj	= INVALID_MANA_HANDLE;
> -	scratch->mana_eqs_debugfs = NULL;

[Severity: Low]
With these two assignments gone, the kernel-doc just above
mana_qset_scratch_alloc() no longer matches the code:

 * Builds a heap copy of @apc that shares its vport identity but owns no
 * queues, so the existing allocators and destroyers can run against it
 * without touching the live context.

After *scratch = *apc the scratch aliases apc->eqs, apc->num_eqs and the
live apc->mana_eqs_debugfs dentry.  mana_destroy_eq() is an exported
NET_MANA symbol taking any struct mana_port_context *, and it does
debugfs_remove_recursive(apc->mana_eqs_debugfs) plus destroy and
kfree(apc->eqs), so running it against a scratch as the doc invites would
tear down the live port's EQs and EQ debugfs tree.

No caller does that today, either here or at the end of the series, so this
is a stale comment rather than a live bug.  Should the wording call out
that EQs and the EQ debugfs dentry are the exception?

>  
>  	/* Never consume the live set's pre-allocated RX buffers; the swap path
>  	 * has no post-teardown allocation to de-risk.
> @@ -3959,7 +4029,8 @@ void mana_qset_scratch_free(struct mana_port_context *scratch)
>   * installed set keeps serving traffic meanwhile. On error nothing is left
>   * allocated.
>   */
> -int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
> +int mana_alloc_qset(struct mana_port_context *apc,
> +		    struct mana_port_context *scratch, unsigned int num_queues,
>  		    unsigned int rx_queue_size, unsigned int tx_queue_size,
>  		    u32 priv_flags, struct mana_qset *out)
>  {
> @@ -3981,13 +4052,20 @@ int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
>  	if (err)
>  		goto cleanup_rxq_array;
>  
> -	err = mana_create_eq(scratch);
> +	/* Grow the port's shared EQ pool if this set needs more. The pool
> +	 * belongs to @apc, not to either queue set, so both sets can be
> +	 * live at once without double-booking MSI-X vectors.
> +	 */
> +	err = mana_grow_eqs(apc, num_queues);
>  	if (err)
>  		goto cleanup_rss;
>  
> +	scratch->eqs = apc->eqs;
> +	scratch->num_eqs = apc->num_eqs;
> +

[Severity: Medium]
Two documented contracts appear to be contradicted by this call.

The comment retained right above mana_alloc_qset() still says:

 * installed set keeps serving traffic meanwhile. On error nothing is left
 * allocated.

but the cleanup_eq label is deleted here and mana_grow_eqs() ends with:

out:
	/* Keep whatever was created: the running queue set still needs its
	 * own EQs, and the extras are reused by the next attempt.
	 */
	return err;

so a failed rebuild permanently raises apc->num_eqs and the port's MSI-X
footprint.  Should the "on error nothing is left allocated" wording be
adjusted, or the growth unwound?

The second one is the header comment this patch rewrites (see the
include/net/mana/mana.h hunk below): mana_grow_eqs(apc, num_queues) writes
apc->eqs[i].eq and apc->num_eqs and creates children under the live
apc->mana_eqs_debugfs while the old set is installed and TX is enabled, not
inside mana_publish_qset().

For what it is worth, the "nothing is left allocated" half is repaired
later in this series: mana_alloc_qset() stops growing EQs and
mana_grow_qset() unwinds with mana_shrink_eqs(apc, apc->num_queues) on
failure.  The header claim about where the live context is mutated still
reads the same at the end of the series, while mana_grow_qset() keeps
calling mana_grow_eqs() during allocation.

>  	err = mana_create_txq(scratch, ndev);
>  	if (err)
> -		goto cleanup_eq;
> +		goto cleanup_rss;
>  
>  	err = mana_add_rx_queues(scratch, ndev);
>  	if (err)
> @@ -4005,8 +4083,6 @@ int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
>  	 */
>  	mana_destroy_rxqs(scratch);
>  	mana_destroy_txq(scratch);
> -cleanup_eq:
> -	mana_destroy_eq(scratch);
>  cleanup_rss:
>  	mana_cleanup_indir_table(scratch);
>  cleanup_rxq_array:

[ ... ]

> diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
> index 356aaa652fa6f..2117a30116c26 100644
> --- a/include/net/mana/mana.h
> +++ b/include/net/mana/mana.h

[ ... ]

> @@ -710,13 +714,14 @@ int mana_attach(struct net_device *ndev);
>  int mana_detach(struct net_device *ndev, bool from_close);
>  
>  /* Pre-allocate + swap reconfiguration. Allocation and teardown run against a
> - * scratch context, so the live port context is only ever mutated with TX
> - * disabled.
> + * scratch context, so the live port context is mutated only inside
> + * mana_publish_qset() with TX disabled. Both sets share a port-owned EQ pool.
>   */

Is this claim accurate once mana_grow_eqs() exists?  The allocation phase
mutates the live @apc: apc->eqs[i].eq, apc->num_eqs and new debugfs
children under apc->mana_eqs_debugfs are all written from
mana_alloc_qset() -> mana_grow_eqs(), with the old set still installed and
TX enabled, so the mutation is not confined to mana_publish_qset().

>  struct mana_port_context *
>  mana_qset_scratch_alloc(struct mana_port_context *apc);
>  void mana_qset_scratch_free(struct mana_port_context *scratch);
> -int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
> +int mana_alloc_qset(struct mana_port_context *apc,
> +		    struct mana_port_context *scratch, unsigned int num_queues,
>  		    unsigned int rx_queue_size, unsigned int tx_queue_size,
>  		    u32 priv_flags, struct mana_qset *out);
>  void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset);

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260901014442.2945689-1-longli%40microsoft.com
