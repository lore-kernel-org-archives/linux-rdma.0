Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538783803DF;
	Fri, 11 Sep 2026 06:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789109623; cv=none; b=i7zXLjSK4gUpUQ3I/hD3t5ke+JFbcwDGACD272tG+BBpNhZkaJ0Dp41FePXFQPtE/Mt5O+uqFn4T2jetFzYV7W+YUwWGnamy64WNxQD+JU8uoWCfYkRCIfy86GPz5GmEgmuvBGoo3zviiIPYstmdVX4k5zx31+zOlb/naO5k80o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789109623; c=relaxed/simple;
	bh=7jukiRDIQUe98DOlCWGj00+XVBxaD6qe6aDh1w82DGg=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YxjDEWbmVqv2KU4RV2mH5xKyNaLuaN8hqQsBLoMRG1mBtUrBPVpp3a2REQ852Vj+CO9I3PK42IEbBWojdChpSWoxv3VDkQA3UPthbkmXOqu6kPN6rAb+LR7Xod2vZBUSp9gTgN82usF5GoDJf0XGt95ke6c6Ixn1t6XRfUj/gZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GlgUb6no; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GlgUb6no"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C6691F00899;
	Fri, 11 Sep 2026 06:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789109608;
	bh=snprWzUSgbKVG/P47RkBXhtyoJ+JYJhl5Vp4QkYh3b0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=GlgUb6no7XIiM36oO/8ENvyzGupSPUJ/NdDsjVfZoyA2b1H7y09TKAcFVEv4nW+J8
	 W68cqWpVekf4YX0HUondRpdk/x2c0+qz/5rFkyWguzr00qy9jpX0I2vGInwXx+OV3+
	 uoFhHlgXoGCBCAQhtFIxKhO5kcDWkO09OehcUwEXbQX+ZnONg5GBhBSJO27VPv1lQL
	 P2Zqv9R2BYMzNhUl2JNTKwZJElriRI8K/6zkF+OI0o1krd6sUqLPzgJU2REiZHevT/
	 a8an2NbbQlA8xZnLrzAshcZWSR9rCFomwSAaenB5QjJRMnM5X/4LLMhq7evjDN6yk6
	 ln7BfRUAxrlPQ==
Subject: Re: [PATCH net-next v5 4/4] net: mana: add dynamic HWC queue depth
 with reinit path
From: netdev-bot+sashiko@kernel.org
To: longli@microsoft.com
Cc: longli@kernel.org, kotaranov@microsoft.com, kuba@kernel.org,
 davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
 andrew+netdev@lunn.ch, jgg@ziepe.ca, leon@kernel.org, haiyangz@microsoft.com,
 kys@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
 shradhagupta@linux.microsoft.com, horms@kernel.org, ernis@linux.microsoft.com,
 stephen@networkplumber.org, shirazsaleem@microsoft.com,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 11 Sep 2026 06:53:26 +0000
Message-ID: <178910960684.219967.7896357652375395801@kernel.org>
In-Reply-To: <20260908035201.402424-5-longli@microsoft.com>
References: <20260908035201.402424-5-longli@microsoft.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 4 potential
issue(s) to consider:

Critical: 0 · High: 3 (1) · Medium: 1 (1) · Low: 0

- [High] The new re-init and bootstrap-fallback blocks in
  mana_hwc_create_channel() unpublish the CQ table in the wrong order:…
- [High] The new reinit_fallback block treats a failed DESTROY_HWC as
  fatal (`if (mana_smc_teardown_hwc(&gc->shm_channel, false)) {…
- [High] mana_hwc_establish_channel() now sets `gc->hwc.doorbell =
  INVALID_DOORBELL;` (UINT_MAX) at the top of every establish, after…
- [Medium] The commit message states "Advertise support in the driver-
  version request", but GDMA_DRV_CAP_FLAG_1_DYN_HWC_QUEUE_DEPTH cannot…

Pre-existing issues:
- [High] The new guard in mana_hwc_establish_channel() validates the HWC
  doorbell only against the INVALID_DOORBELL sentinel (UINT_MAX); it…
- [Medium] mana_hwc_destroy_cq() frees resources that the still-live HWC
  EQ interrupt handler can reach before the EQ is deregistered:…

--

net: mana: add dynamic HWC queue depth with reinit path

This rebuilds the depth-one HWC bootstrap queues at the device-advertised
maximum depth, capped at 128, and keeps the 24-bit reported depth in a u32
with bounded DMA allocations. It adds a bootstrap fallback path that tears
down and rebuilds at depth one when the larger-depth teardown, rebuild or
re-establishment fails.

No Link: tags in the commit header.

A few questions below about the new reinit and fallback paths.

> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> index eb88bae2b14d8..78424e1d884f1 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> @@ -1260,15 +1260,17 @@ static void mana_gd_create_cq(const struct gdma_queue_spec *spec,
>  static void mana_gd_destroy_cq(struct gdma_context *gc,
>  			       struct gdma_queue *queue)
>  {
> +	struct gdma_queue **cq_table = READ_ONCE(gc->cq_table);
>  	u32 id = queue->id;
>  
> -	if (id >= gc->max_num_cqs)
> +	/* HWC re-establishment can fail before allocating the CQ table. */
> +	if (!cq_table || id >= gc->max_num_cqs)
>  		return;
>  
> -	if (!gc->cq_table[id])
> +	if (!cq_table[id])
>  		return;
>  
> -	gc->cq_table[id] = NULL;
> +	cq_table[id] = NULL;
>  }

[ ... ]

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index a4f7346d285f7..750ee8f729994 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c

[ ... ]

> @@ -771,6 +780,15 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
>  	struct gdma_queue *cq = hwc->cq->gdma_cq;
>  	int err;
>  
> +	/* Do not reuse dimensions or routing IDs from a previous establish. */
> +	hwc->hwc_init_q_depth_max = 0;
> +	hwc->hwc_init_max_req_msg_size = 0;
> +	hwc->hwc_init_max_resp_msg_size = 0;
> +	gc->hwc.doorbell = INVALID_DOORBELL;
> +	gc->hwc.pdid = INVALID_PDID;
> +	hwc->pf_dest_vrq_id = 0;
> +	hwc->pf_dest_vrcq_id = 0;
> +

[Severity: High]
Is it safe to set gc->hwc.doorbell to INVALID_DOORBELL here while the HWC
EQ is already registered on the shared msix 0 interrupt?

mana_hwc_init_queues() has already run mana_gd_create_eq() ->
mana_gd_register_irq() -> list_add_rcu(&queue->entry, &gic->eq_list), so
mana_gd_process_eq_events() can run at any point after
mana_smc_setup_hwc() writes the shared-memory request. At the end of every
batch it arms unconditionally:

drivers/net/ethernet/microsoft/mana/gdma_main.c:mana_gd_process_eq_events() {
	...
	mana_gd_ring_doorbell(gc, eq->gdma_dev->doorbell, eq->type, eq->id,
			      head, SET_ARM_BIT);
	...
}

and mana_gd_ring_doorbell() forms the MMIO address with no validity check:

	void __iomem *addr = gc->db_page_base + gc->db_page_size * db_index;
	...
	writeq(e.as_uint64, addr);

Only GDMA_EQE_HWC_INIT_EQ_ID_DB repopulates gd->doorbell in
mana_hwc_init_event_handler(). If the first delivered batch does not start
with that event, does the writeq() run with db_index == 0xFFFFFFFF, i.e.
roughly 17 TiB past the ioremapped BAR0 window?

The field is also written from hard IRQ context (gd->doorbell =
eq_db.doorbell;) while this store is a plain process-context store with no
WRITE_ONCE() or barrier. Since the reinit path calls
mana_hwc_establish_channel() two or three times per probe, does this
multiply the window rather than close it?

>  	init_completion(&hwc->hwc_init_eqe_comp);
>  
>  	err = mana_smc_setup_hwc(&gc->shm_channel, false,
> @@ -789,6 +807,14 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
>  	*max_req_msg_size = hwc->hwc_init_max_req_msg_size;
>  	*max_resp_msg_size = hwc->hwc_init_max_resp_msg_size;
>  
> +	/* Reject a missing doorbell before the channel test. This neither
> +	 * validates its BAR range nor protects earlier IRQ rearming.
> +	 */
> +	if (gc->hwc.doorbell == INVALID_DOORBELL) {
> +		dev_err(hwc->dev, "HWC: no doorbell in init data\n");
> +		return -EPROTO;
> +	}
> +

[Severity: High]
This isn't a bug introduced by this patch, but since a doorbell sanity
check is being added right here, could it also cover the BAR range?

The value comes from a 16-bit device-controlled field and is stored with no
validation:

drivers/net/ethernet/microsoft/mana/hw_channel.c:mana_hwc_init_event_handler() {
	...
	eq_db.as_uint32 = event->details[0];
	hwc->cq->gdma_eq->id = eq_db.eq_id;
	gd->doorbell = eq_db.doorbell;
	...
}

It is then consumed unchecked by mana_gd_ring_doorbell() from the EQ rearm,
from mana_gd_ring_cq() on the HWC CQ and from mana_gd_wq_ring_doorbell() on
the HWC SQ/RQ. The driver already has the corresponding check for the
PF-reported db_id:

drivers/net/ethernet/microsoft/mana/gdma_main.c:mana_gd_register_device() {
	...
	if (gc->db_page_off + gc->db_page_size * ((u64)resp.db_id + 1) > gc->bar0_size) {
		dev_err(gc->dev, "Doorbell ID %u out of range\n", resp.db_id);
		return -EPROTO;
	}
	...
}

With a 4 KiB doorbell page, a reported index of 0x8000 gives a 128 MiB
offset, well outside a typical VF BAR0. Can the writeq() then land outside
the ioremapped region at a device-chosen offset? The commit message notes
the gap ("does not cover BAR bounds"), so was leaving it open intentional?

>  	/* Both were set in mana_hwc_init_event_handler(). */
>  	if (WARN_ON(cq->id >= gc->max_num_cqs))
>  		return -EPROTO;

[ ... ]

> @@ -846,13 +878,44 @@ static int mana_hwc_init_queues(struct hw_channel_context *hwc, u16 q_depth,
>  	return err;
>  }
>  
> +/* Bring-up only: requires no senders or concurrent lifecycle operations.
> + * This helper does not unpublish the HWC or drain senders.
> + */
> +static void mana_hwc_destroy_queues(struct hw_channel_context *hwc)
> +{
> +	struct gdma_context *gc = hwc->gdma_dev->gdma_context;
> +
> +	/* The CQ helper deregisters the HWC EQ before returning. */
> +	if (hwc->cq) {
> +		mana_hwc_destroy_cq(gc, hwc->cq);
> +		hwc->cq = NULL;
> +	}

[Severity: Medium]
This is a pre-existing ordering issue rather than something this patch
introduces, but the comment says the CQ helper deregisters the EQ before
returning, and that only happens as the last step:

drivers/net/ethernet/microsoft/mana/hw_channel.c:mana_hwc_destroy_cq() {
	kfree(hwc_cq->comp_buf);

	if (hwc_cq->gdma_cq)
		mana_gd_destroy_queue(gc, hwc_cq->gdma_cq);

	if (hwc_cq->gdma_eq)
		mana_gd_destroy_queue(gc, hwc_cq->gdma_eq);
	...
}

The list_del_rcu()/synchronize_rcu() pair that actually drains in-flight EQ
users lives in mana_gd_deregister_irq(), reached only from the final
gdma_eq destroy. During the first two frees the EQ is still on
gic->eq_list.

Can an interrupt in that window reach mana_hwc_comp_event() and use the
already freed comp_buf?

drivers/net/ethernet/microsoft/mana/hw_channel.c:mana_hwc_comp_event() {
	...
	completions = hwc_cq->comp_buf;
	comp_read = mana_gd_poll_cq(q_self, completions, hwc_cq->queue_depth);
	...
}

An HWC init EQE in the same window would instead reach
mana_hwc_init_event_handler(), which writes hwc->cq->gdma_eq->id and
hwc->cq->gdma_cq->id while those objects are being freed, since hwc->cq is
only cleared after mana_hwc_destroy_queues() returns. Would destroying the
EQ first, before comp_buf and the gdma_cq, close this?

> +
> +	kfree(hwc->caller_ctx);
> +	hwc->caller_ctx = NULL;
> +
> +	if (hwc->txq) {
> +		mana_hwc_destroy_wq(hwc, hwc->txq);
> +		hwc->txq = NULL;
> +	}
> +
> +	if (hwc->rxq) {
> +		mana_hwc_destroy_wq(hwc, hwc->rxq);
> +		hwc->rxq = NULL;
> +	}
> +
> +	mana_gd_free_res_map(&hwc->inflight_msg_res);
> +	hwc->num_inflight_msg = 0;
> +}
> +

[ ... ]

> @@ -896,8 +959,132 @@ int mana_hwc_create_channel(struct gdma_context *gc)
>  		goto out;
>  	}
>  
> +	if (q_depth_max > HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH) {

[ ... ]

> +		err = mana_smc_teardown_hwc(&gc->shm_channel, false);
> +		if (err) {
> +			dev_err(hwc->dev,
> +				"Failed to teardown HWC for reinit: %d\n",
> +				err);
> +			goto reinit_fallback;
> +		}
> +
> +		hwc->setup_active = false;
> +
> +		/* Unpublish the CQ and drain its EQ before freeing the table. */
> +		mana_hwc_destroy_queues(hwc);
> +
> +		old_cq_table = gc->cq_table;
> +		gc->cq_table = NULL;
> +		gc->max_num_cqs = 0;
> +		synchronize_rcu();
> +		vfree(old_cq_table);

[Severity: High]
Is the store order here inverted with respect to what the readers check?

The pre-existing teardown in mana_hwc_destroy_channel() clears the bound
first and only drops the pointer at the very end (gc->max_num_cqs = 0; ...
vfree(gc->cq_table); gc->cq_table = NULL;). Here the pointer goes away
first, leaving a state where the bound check passes but the pointer is
NULL.

The surviving hard IRQ consumer validates only the bound:

drivers/net/ethernet/microsoft/mana/gdma_main.c:mana_gd_process_eqe() {
	...
	cq_id = eqe->details[0] & 0xFFFFFF;
	if (WARN_ON_ONCE(cq_id >= gc->max_num_cqs))
		break;

	cq = gc->cq_table[cq_id];
	...
}

That is exactly the case the patch guards against in mana_gd_destroy_cq()
with READ_ONCE() plus a NULL check, but mana_gd_process_eqe() has neither.

Beyond the adjacent-store window, is there a much longer one? The
subsequent mana_hwc_init_queues() re-registers the HWC EQ on msix 0 before
mana_hwc_establish_channel() runs, and the hard IRQ init handler sets
gd->gdma_context->max_num_cqs = val from HWC_INIT_DATA_MAX_NUM_CQS while
gc->cq_table is still NULL. The vcalloc() that repopulates it only happens
after the up-to-60 s wait_for_completion_timeout() returns. Would a
GDMA_EQE_COMPLETION delivered in that window pass the bound check and
dereference NULL plus cq_id * 8, then call through the loaded value as
cq->cq.callback?

Also, since the reclaim now relies on synchronize_rcu(), should these be
WRITE_ONCE()/rcu_assign_pointer() stores rather than plain ones?

> +
> +		err = mana_hwc_init_queues(hwc, q_depth_max,
> +					   max_req_msg_size,
> +					   max_resp_msg_size);
> +		if (err) {
> +			dev_err(hwc->dev, "Failed to reinit HWC: %d\n", err);
> +			goto reinit_fallback;
> +		}

[ ... ]

> +	}
> +
> +	goto skip_reinit;
> +
> +reinit_fallback:
> +	/* A failed handshake leaves queue ownership uncertain. */
> +	if (hwc->setup_active) {
> +		if (mana_smc_teardown_hwc(&gc->shm_channel, false)) {
> +			dev_err(hwc->dev,
> +				"Failed to tear down HWC before bootstrap fallback\n");
> +			goto out;
> +		}
> +		hwc->setup_active = false;
> +	}

[Severity: High]
Does this abort actually avoid freeing memory the device may still own?

The goto out lands in mana_hwc_destroy_channel(), which retries the
teardown once and then continues regardless of the result:

drivers/net/ethernet/microsoft/mana/hw_channel.c:mana_hwc_destroy_channel() {
	...
	if (hwc->setup_active) {
		if (!mana_smc_teardown_hwc(&gc->shm_channel, false))
			hwc->setup_active = false;
		else
			dev_err(hwc->dev, "Failed to tear down HWC\n");
	}
	gc->max_num_cqs = 0;

	/* Deregister the HWC EQ before freeing the work queues. */
	if (hwc->cq)
		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);
	...
}

So a third failure is logged and then mana_hwc_destroy_cq() and
mana_hwc_destroy_wq() run mana_gd_destroy_queue() ->
mana_gd_free_memory() -> dma_free_coherent(), plus vfree(gc->cq_table) and
kfree(hwc), with hwc->setup_active still true.

mana_smc_teardown_hwc() states the requirement explicitly:

drivers/net/ethernet/microsoft/mana/shm_channel.c:mana_smc_teardown_hwc() {
	...
	/* Read shmem response (polling for VF possession) and validate.
	 * For teardown, waiting for response is required to ensure hardware
	 * invalidates MST entries before software frees memory.
	 */
	...
}

Can the coherent EQ/CQ/SQ/RQ rings and HWC message buffers then be returned
to the page allocator while the hardware MST entries still map them, and
with hwc freed so no later safe teardown is possible? The ignore-the-failure
behaviour in mana_hwc_destroy_channel() predates this series, but this abort
path is newly reachable, and the commit message says the intent is to
"never test queues after an indeterminate destroy result".

[ ... ]

> diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
> index 571a533e62e64..22dd7c9cecc8a 100644
> --- a/include/net/mana/gdma.h
> +++ b/include/net/mana/gdma.h
> @@ -692,6 +692,9 @@ enum {
>  /* Driver supports dynamic interrupt moderation - DIM */
>  #define GDMA_DRV_CAP_FLAG_1_DYN_INTERRUPT_MODERATION BIT(28)
>  
> +/* Driver supports dynamic queue depth for HWC */
> +#define GDMA_DRV_CAP_FLAG_1_DYN_HWC_QUEUE_DEPTH BIT(29)
> +

[Severity: Medium]
The commit message says "Advertise support in the driver-version request."
Can this flag gate the new behaviour at all?

GDMA_DRV_CAP_FLAGS1 is only transmitted by mana_gd_verify_vf_version(),
which runs after the HWC has been created:

drivers/net/ethernet/microsoft/mana/gdma_main.c:mana_gd_setup() {
	...
	err = mana_hwc_create_channel(gc);
	if (err)
		goto remove_irq;

	err = mana_gd_verify_vf_version(pdev);
	...
}

By then mana_hwc_create_channel() has already consumed
HWC_INIT_DATA_QUEUE_DEPTH and performed the DESTROY_HWC plus second
ESTABLISH_HWC cycle, and the verify request itself travels over the rebuilt
channel. So the rebuild in mana_hwc_create_channel() is taken purely from
the device-reported depth:

	if (q_depth_max > HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH) {

Unlike other capabilities in this driver, there is no PF acknowledgment
check (GDMA_PF_CAP_FLAG_1_* in gc->pf_cap_flags1) before acting.

In the baseline, hwc_init_q_depth_max was stored but never acted on, since
mana_hwc_test_channel() was always called with
HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH. Does existing hardware that already
reports a depth above one now perform an extra shared-memory
teardown/establish per probe, each with mana_smc_poll_register() polling and
a 60 * HZ wait_for_completion_timeout()? And can probe now fail through the
reinit_fallback goto out paths where it previously succeeded at depth one?

Could the commit message describe the flag as informational only, and
mention the behaviour change on PF firmware that never saw the new bit?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260908035201.402424-1-longli%40microsoft.com
