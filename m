Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792514808;
	b=Db6X4PJdXJqIdJtnL58howogk0ojHcQr6gMl6Fom+GkrB5hW5Tngz/bk0kBXeXhRSS7L
	 9SvZAGNEEH6c2RhdLGgxrKOnPCLyKYu+1utLLttEduYFFxnl8828TL3RimKnxOd49f04H
	 W4uiGpdLswxMcE/r9P4SkWHSdYANheWq8qnNqG/aP0H+QsS/aunBML51Jm13vRV73YeWM
	 REZq99kM64LDZ8Ma1xZLwmyK3ESXS9WoGdxKG4WpY4j0op6lQDXteKCCkOWhm1ujF8jLp
	 9DE+jYebdj4CCcpjGgVHK06MD5Z6qcQznJm9GlKGZkrJKDJRAeNNTWpNodEPrcBNPRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792514808;
	h=Received:Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 X-sashiko-severity:Content-Type:Content-Transfer-Encoding:
	 MIME-Version;
	bh=vA+kgYgSyB8dW3GEhElq7y9BZFLviAInyi/TBsrCsUM=;
	b=Qc+1hrnvM7gjIIPrOB1ieJ1duJ9Tl0FOUjvH7G5sxbpnIBbY4ZUAJWCzL2GFL+XLwryh
	 wzHcxv/MY0G02M6CvDje2P3xQDXBtjlcapQB9+k/KHt0EEDezwJUNawV+MIMJNVKsrGZV
	 ULQMWzAGlJBQ2xPRzyBrRCeEA548YUHkgrw01dztuFMx5WtIUegooTiORxXam0rNNr5lw
	 LtqyARw6eoeD0zqJ/wtyp4Oiy8YIp9/OaX0spfP2YuzVwxPTebxPZWqCXssHz/NYLcO9U
	 NE6sRJ48+KodokYjw7sHmqSn8SZTHHJ4DOG8DKl7Dsf9azJuK5MZ5j0Cy3WaxoXLFpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB95606A32D;
	Tue, 20 Oct 2026 16:46:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D7E1F000C9;
	Tue, 20 Oct 2026 16:46:46 +0000 (UTC)
Subject: Re: [PATCH net-next v7 02/13] net: mana: share the EQ pool across a
 queue-set swap
From: netdev-bot+sashiko@kernel.org
To: weh@linux.microsoft.com
Cc: longli@kernel.org, kotaranov@microsoft.com, kuba@kernel.org,
 davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
 andrew+netdev@lunn.ch, jgg@ziepe.ca, leon@kernel.org, haiyangz@microsoft.com,
 wei.liu@kernel.org, decui@microsoft.com, shradhagupta@linux.microsoft.com,
 horms@kernel.org, ernis@linux.microsoft.com, stephen@networkplumber.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, sdf@fomichev.me, daniel@iogearbox.net, hawk@kernel.org,
 ast@kernel.org, john.fastabend@gmail.com, weh@microsoft.com,
 edumazet@kernel.org
Date: Tue, 20 Oct 2026 16:46:15 +0000
Message-ID: <179251477587.3135.9865943982532798656@kernel.org>
In-Reply-To: =?utf-8?q?=3C9b7e62cc70138f8940a32869da44c1260748be14=2E1791710?=
 =?utf-8?q?735=2Egit=2Eweh=40linux=2Emicrosoft=2Ecom=3E?=
References: =?utf-8?q?=3C9b7e62cc70138f8940a32869da44c1260748be14=2E17917107?=
 =?utf-8?q?35=2Egit=2Eweh=40linux=2Emicrosoft=2Ecom=3E?=
X-sashiko-severity: Medium
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

Critical: 0 · High: 0 (1) · Medium: 1 (1) · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] Every Ethernet CQ teardown now adds a blocking
  mana_gd_test_eq() on its parent EQ (mana_deinit_cq()) and an…
- [Low] This feature patch ('share the EQ pool across a queue-set swap')
  bundles two fixes for bugs that can be hit today, with no Fixes: tag,…
- [Low] A comment in struct mana_port_context (include/net/mana/mana.h)
  is out of date.

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but the patch's
  new reader protocol does not cover it, and the commit message says it…
- [Medium] This problem wasn't introduced by this patch, but the HWC
  teardown frees CQ callback state before IRQ readers are drained.

--

net: mana: share the EQ pool across a queue-set swap

This commit makes the MANA EQ pool port-owned. The old and new queue sets
in a swap now share EQs, and mana_grow_eqs() grows the pool when needed.

It also moves cq_table publication to release/acquire and adds a per-CQ
EQ flush plus an RCU grace period when a CQ is torn down. EQ
initialization now happens before IRQ registration, and the DMA region is
released when EQ creation fails.

> diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana/cq.c
> index d4e5e3f912689..0b6ad2547e0ef 100644
> --- a/drivers/infiniband/hw/mana/cq.c
> +++ b/drivers/infiniband/hw/mana/cq.c
> @@ -155,7 +155,8 @@ int mana_ib_install_cq_cb(struct mana_ib_dev *mdev, struct mana_ib_cq *cq)
>  	gdma_cq->type = GDMA_CQ;
>  	gdma_cq->cq.callback = mana_ib_cq_handler;
>  	gdma_cq->id = cq->queue.id;
> -	gc->cq_table[cq->queue.id] = gdma_cq;
> +	/* Pairs with the acquire load in mana_gd_process_eqe(). */
> +	smp_store_release(&gc->cq_table[cq->queue.id], gdma_cq);
>  	return 0;
>  }

[Severity: High]
This is a pre-existing issue, not one introduced by this patch. This patch
adds a release/acquire and RCU reader protocol for cq_table. Shouldn't the
matching RDMA remover change as well?

mana_ib_remove_cq_cb() still frees the published gdma_queue before it
clears the slot, and it never waits for IRQ readers:

drivers/infiniband/hw/mana/cq.c:mana_ib_remove_cq_cb() {
    ...
	kfree(gc->cq_table[cq->queue.id]);
	gc->cq_table[cq->queue.id] = NULL;
}

mana_ib_destroy_cq() calls it before the hardware CQ is destroyed:

	mana_ib_remove_cq_cb(mdev, cq);
	...
	mana_ib_gd_destroy_cq(mdev, cq);

So the CQ can still raise EQEs at that point. Raw/RSS QPs attach these CQs
to the port's mpc->eqs[] pool, which this patch makes long-lived.

At the same time, mana_gd_process_eqe() runs under rcu_read_lock() in
mana_gd_intr() and does:

	cq = smp_load_acquire(&gc->cq_table[cq_id]);
	if (WARN_ON_ONCE(!cq || cq->type != GDMA_CQ || cq->id != cq_id))
		break;

	if (cq->cq.callback)
		cq->cq.callback(cq->cq.context, cq);

Suppose another CPU has already loaded the pointer when kfree() runs. Could
it read freed memory and call through a function pointer taken from it?

After destroy returns, the IB core also frees the mana_ib_cq that
mana_ib_cq_handler() dereferences.

The other CQ removers now unpublish, call synchronize_rcu(), and then
free, as mana_gd_destroy_cq() does. This is the last plain cq_table store
left, yet the commit message says:

    The HWC and RDMA sites need the matching stores, not changes to
    their teardown or recovery policies.

Does that hold for mana_ib_remove_cq_cb()? Userspace can reach it through
ibv_destroy_cq() while completions are still arriving on the same EQ. The
code still looks unchanged at the end of the series.

> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> index ae0ed700b3b93..078b3666947a4 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c

[ ... ]

> @@ -1030,17 +1031,17 @@ static int mana_gd_create_eq(struct gdma_dev *gd,
>  		return -EINVAL;
>  	}
>  
> +	queue->eq.callback = spec->eq.callback;
> +	queue->eq.context = spec->eq.context;
> +	queue->head |= INITIALIZED_OWNER_BIT(log2_num_entries);
> +	queue->eq.log2_throttle_limit = spec->eq.log2_throttle_limit ?: 1;
> +
>  	err = mana_gd_register_irq(queue, spec);
>  	if (err) {
>  		dev_err(dev, "Failed to register irq: %d\n", err);
>  		return err;
>  	}
>  
> -	queue->eq.callback = spec->eq.callback;
> -	queue->eq.context = spec->eq.context;
> -	queue->head |= INITIALIZED_OWNER_BIT(log2_num_entries);
> -	queue->eq.log2_throttle_limit = spec->eq.log2_throttle_limit ?: 1;
> -
>  	if (create_hwq) {
>  		err = mana_gd_create_hw_eq(gc, queue);
>  		if (err)

[ ... ]

> @@ -1273,8 +1273,10 @@ int mana_gd_create_mana_eq(struct gdma_dev *gd,
>  	queue->gdma_dev = gd;
>  
>  	err = mana_gd_create_eq(gd, spec, true, queue);
> -	if (err)
> +	if (err) {
> +		mana_gd_destroy_dma_region(gc, gmi->dma_region_handle);
>  		goto out;
> +	}
>  
>  	*queue_ptr = queue;
>  	return 0;

[Severity: Low]
This isn't a bug, but both of these changes look like fixes for problems
that exist today, separate from the queue-set swap. The commit message
says the reorder ensures "a live shared IRQ cannot observe an
uninitialized EQ". It also says the DMA region release "closes an
existing unwind gap".

Before this patch, mana_gd_create_eq() linked the queue into gic->eq_list
with list_add_rcu() in mana_gd_register_irq(). That happened before
eq.callback, eq.context, the owner bit and log2_throttle_limit were set.
With msi_sharing, mana_gd_intr() could walk the new EQ while its head and
owner phase were still zero.

Also, when mana_gd_create_eq() failed, mana_gd_create_mana_eq() only
called mana_gd_free_memory(). That leaked the DMA region registered by
mana_gd_create_dma_region().

Both paths are reachable without any queue-set swap, through
mana_alloc_queues()->mana_create_eq() and through RDMA's
mana_ib_create_eqs().

Would it make sense to split these into separate patches with Fixes: tags,
so stable can pick them up?

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index 3bca4b683134b..aefb8646cd79c 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> @@ -702,7 +702,8 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
>  	if (!gc->cq_table)
>  		return -ENOMEM;
>  
> -	gc->cq_table[cq->id] = cq;
> +	/* Pairs with the acquire load in mana_gd_process_eqe(). */
> +	smp_store_release(&gc->cq_table[cq->id], cq);
>  
>  	return 0;
>  }

[Severity: Medium]
This is a pre-existing issue, not one introduced by this patch, but the
HWC teardown path doesn't get the new grace period either.
mana_hwc_destroy_channel() does:

	if (gc->max_num_cqs > 0) {
		mana_smc_teardown_hwc(&gc->shm_channel, false);
		gc->max_num_cqs = 0;
	}

Because max_num_cqs is now 0, mana_gd_destroy_cq() returns early on its
id >= gc->max_num_cqs check and skips synchronize_rcu(). Then
mana_hwc_destroy_cq() does:

	kfree(hwc_cq->comp_buf);

	if (hwc_cq->gdma_cq)
		mana_gd_destroy_queue(gc, hwc_cq->gdma_cq);

	if (hwc_cq->gdma_eq)
		mana_gd_destroy_queue(gc, hwc_cq->gdma_eq);

The EQ is deregistered and RCU-synchronized only after comp_buf and the
gdma_cq have already been freed.

An HWC EQ handler could still be running mana_hwc_comp_event() after
mana_smc_teardown_hwc() returns. That can happen with threaded or
preempted IRQ handling, or with a late HWC response during removal,
suspend or reset. Can that handler then touch the freed comp_buf through:

	completions = hwc_cq->comp_buf;

or touch the freed gdma_cq? The commit message deliberately leaves the
HWC teardown policy alone, so this only points out the remaining gap.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index 7586972e78e09..4b2c8039b8fa3 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c

[ ... ]

> @@ -2653,12 +2712,25 @@ static void mana_schedule_napi(void *context, struct gdma_queue *gdma_queue)
>  
>  static void mana_deinit_cq(struct mana_port_context *apc, struct mana_cq *cq)
>  {
> -	struct gdma_dev *gd = apc->ac->gdma_dev;
> +	struct gdma_context *gc = apc->ac->gdma_dev->gdma_context;
> +	struct gdma_queue *gdma_cq = cq->gdma_cq;
> +	struct gdma_queue *eq;
> +	int err;
>  
> -	if (!cq->gdma_cq)
> +	if (!gdma_cq)
>  		return;
>  
> -	mana_gd_destroy_queue(gd->gdma_context, cq->gdma_cq);
> +	eq = gdma_cq->cq.parent;
> +	if (gdma_cq->id < gc->max_num_cqs && eq &&
> +	    eq->id != INVALID_QUEUE_ID) {
> +		/* Flush queued events after WQ teardown, before removing this CQ. */
> +		err = mana_gd_test_eq(gc, eq);
> +		if (err && mana_en_need_log(apc, err))
> +			netdev_err(apc->ndev, "Failed to flush EQ %u for CQ %u: %d\n",
> +				   eq->id, gdma_cq->id, err);
> +	}
> +
> +	mana_gd_destroy_queue(gc, gdma_cq);
>  }

[Severity: Medium]
How much slower does teardown get with this? Every Ethernet CQ now does a
blocking mana_gd_test_eq() on its parent EQ here. It also does an
unconditional synchronize_rcu() in mana_gd_destroy_cq():

	cmpxchg(&gc->cq_table[id], queue, NULL);
	synchronize_rcu();

Both run one CQ at a time from mana_destroy_txq() and mana_destroy_rxq().
They hold RTNL and the netdev instance lock, and they run on close,
detach, reset, create unwind and queue-set free.

mana_gd_test_eq() takes gc->eq_test_event_mutex, sends
GDMA_GENERATE_TEST_EQE over the HWC, and waits up to 30 * HZ. TX CQ i and
RX CQ i share EQ i. After that, mana_destroy_eq()->mana_gd_destroy_eq()
flushes each EQ again and adds another grace period in
mana_gd_deregister_irq().

So teardown seems to go from N test-EQ round trips and N grace periods to
3N of each. synchronize_rcu() now also runs for CQs that were never
published; the old code returned early when the slot was empty.

A failed flush is only logged. Suppose an EQ stops delivering test events
while the HWC still answers. Wouldn't each CQ on that EQ wait the full 30
seconds, and then mana_gd_destroy_eq() wait again?

Would one flush per distinct EQ, plus one grace period after all slots
are cleared, be enough here? This still seems to be the case at the end
of the series.

[ ... ]

> diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
> index 1d91b62299f56..12a65145cd3fd 100644
> --- a/include/net/mana/mana.h
> +++ b/include/net/mana/mana.h
> @@ -574,7 +574,9 @@ struct mana_port_context {
>  
>  	u8 mac_addr[ETH_ALEN];
>  
> +	/* Port-owned EQ pool: max_queues slots, num_eqs populated. */
>  	struct mana_eq *eqs;
> +	unsigned int num_eqs;
>  	struct dentry *mana_eqs_debugfs;
>  
>  	enum TRI_STATE rss_state;

[Severity: Low]
This isn't a bug, but an older comment further down in struct
mana_port_context still says:

	/* Create num_queues EQs, SQs, SQ-CQs, RQs and RQ-CQs, respectively. */
	unsigned int max_queues;
	unsigned int num_queues;

mana_destroy_eq() now iterates over num_eqs, which can exceed num_queues
after mana_grow_eqs(). Should that comment be updated as well? It is
still there at the end of the series.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1791710735.git.weh%40linux.microsoft.com
