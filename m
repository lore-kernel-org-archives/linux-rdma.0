Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136E141A51B;
	Fri, 11 Sep 2026 06:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789109619; cv=none; b=ckOfdreA8lTC59/6hikaLi0hQQIZN3RjdiK9kQTwxwV2DZhu/2yPCLCdnANhEG4tyKhO2UAjE3TplV7o/pqgr5m/CmMIwIm3Ei5ngvtWIUzbOsN9RpTMkLHOZt4MVWzBwJPejG13gX6Z0S9UVk0ZF3YU2QqWxV8krgzAlsiFAH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789109619; c=relaxed/simple;
	bh=Ao53tg3Bj2hXfRSLUufvjCqC8vx/akB2JJJroZxhGwo=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QyJqz7t11V/vqjDUraB8hT2q4QjUFIVu/ofPrLmgk4I9eYHR6+VPWSC8PC10Pg3Kncue9NpkdMs4KLvgNf1F193u14uQjkcYo9ikYGywjTDk2oniO9khehsBfuyoa3esQ3YFqPGEBmje4GDRhxBdgn3P/iZ93tljZT+PM8E94iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=btCMPtwk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="btCMPtwk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C741F00898;
	Fri, 11 Sep 2026 06:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789109606;
	bh=hbsMukoVbcIi2ETjIRQxkApzQJCAhTWy9FcQGeDf4b8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=btCMPtwkxDQ0ktOCW2RkdMmZHqI1ZCIgqcsBe8y2hXPFTqNM4XAWQ0fnURDflZC9I
	 7lHTsRLzqD7Nq7fFdp7IlQVC7wlUabj6gIPUM/jZ695xjaF15i5WBkpFT84U/ibpTd
	 cPD1ZlHhIRYjG10VSsDpxajTLOHs7SjyInVcbSfTMPRNRKeL4GA0XXsm+WXxCf/H+P
	 SHF6L6T5/iM3GrNLc5S6b8ep5PPjmvhhw2ahFWiAzk0hBi+Plhv5jAjlGxMhkQL5Lb
	 GnVRNHRIVafodzvvQLTCrZe/cZuJoSh57YqmotRdrOWS0EcH/yxqRsIqI14WdYNRjy
	 YI0SvX2g5qs3A==
Subject:
 Re: [PATCH net-next v5 3/4] net: mana: support concurrent HWC requests
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
Date: Fri, 11 Sep 2026 06:53:24 +0000
Message-ID: <178910960473.219967.8374746820344130548@kernel.org>
In-Reply-To: <20260908035201.402424-4-longli@microsoft.com>
References: <20260908035201.402424-4-longli@microsoft.com>
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

Critical: 0 · High: 1 (1) · Medium: 1 (1) · Low: 2

- [High] mana_hwc_get_msg_index() converts pure FIFO-slot contention into
  -ETIMEDOUT: `if (down_timeout(&hwc->sema,…
- [Medium] The newly added gc->hwc_lock is documented as protecting
  hwc->hwc_timeout accesses in mana_need_log()/mana_serv_reset(), but…
- [Low] The patch closes a real, user-visible late-response
  misassociation bug (a timed-out request's slot was released…
- [Low] The new hwc_caller_ctx.resp_pending field is documented in
  include/net/mana/hw_channel.h as 'Response-side reference outstanding;…

Pre-existing issues:
- [High] mana_hwc_destroy_cq() frees the completion buffer as its very
  first action (`kfree(hwc_cq->comp_buf);`), then destroys the GDMA CQ,…
- [Medium] The new channel_up admission gate is evaluated only after
  blocking on hwc->sema and after acquiring hwc->inflight_msg_res.lock,…

--

net: mana: support concurrent HWC requests

This adds hwc_lock to protect HWC publication and sender accounting,
serializes SQ posting with a new per-wq spinlock, bounds FIFO slot
admission with down_timeout(), and quarantines timed-out requests until a
response or teardown releases the slot.  Teardown now stops admission,
force-completes outstanding requests and drains senders before destroying
the CQ, TXQ and RXQ.

A few questions below.

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index 6605e7a9c481b..a4f7346d285f7 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> @@ -6,7 +6,6 @@
>  #include <net/mana/hw_channel.h>
>  #include <linux/vmalloc.h>
>  
> -/* Acquire a free inflight message slot, waiting for one if all are in use. */
>  static int mana_hwc_get_msg_index(struct hw_channel_context *hwc, u16 *msg_id)
>  {
>  	struct gdma_resource *r = &hwc->inflight_msg_res;
> @@ -14,12 +13,30 @@ static int mana_hwc_get_msg_index(struct hw_channel_context *hwc, u16 *msg_id)
>  	unsigned long flags;
>  	u32 index;
>  
> -	down(&hwc->sema);
> +	/* FIFO slot admission has a separate budget from the response wait.
> +	 * Expiry reports -ETIMEDOUT even while earlier requests make progress,
> +	 * so callers may initiate recovery on contention alone.
> +	 */
> +	if (down_timeout(&hwc->sema, msecs_to_jiffies(hwc->hwc_timeout)))
> +		return -ETIMEDOUT;

[Severity: High]
Can pure slot contention here trigger a device reset on healthy hardware?

The channel is built at HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH == 1 in
mana_hwc_create_channel(), so sema_init() grants a single permit and any
two concurrent mana_gd_send_request() callers contend for it.  The loser
gets -ETIMEDOUT, which mana_gd_send_request() propagates unchanged.

Existing callers read that code as "the HWC is dead":

drivers/net/ethernet/microsoft/mana/gdma_main.c:mana_gd_probe() {
	if (err == -ETIMEDOUT || err == -EPROTO) {
		...
		schedule_delayed_work(&mana_dev_recovery_work.work, ...);
}

drivers/net/ethernet/microsoft/mana/gdma_main.c:mana_serv_reset() {
	ret = mana_gd_resume(pdev);
	if (ret == -ETIMEDOUT || ret == -EPROTO) {
		... mana_serv_rescan(pdev);
}

mana_serv_rescan() calls pci_stop_and_remove_bus_device() followed by
pci_rescan_bus().  In mana_en the gf-stats work latches
ac->hwc_timeout_occurred = true on -ETIMEDOUT and stops collecting stats
permanently.

The admission budget is also the same field the response-timeout path in
mana_hwc_send_request() shrinks:

	if (hwc->hwc_timeout > 1)
		hwc->hwc_timeout = 1;

and the field mana_serv_reset() sets to 0, so after either event
down_timeout() takes the expired path immediately for a second caller even
though the channel is responsive.

Would returning a distinguishable code for contention, such as -EBUSY or
-EAGAIN, avoid teaching every caller to reset the device on queue depth
pressure?  The commit message acknowledges this:

  "Admission expiry returns -ETIMEDOUT even for contention, so existing
  callers may reset a responsive channel."

Checking the end of the series, mana_hwc_get_msg_index() is byte-identical
there, so the later dynamic HWC queue depth work does not address this; it
only makes exhaustion less likely when the device advertises a depth
greater than one.

>  
>  	spin_lock_irqsave(&r->lock, flags);
>  
> -	index = find_first_zero_bit(hwc->inflight_msg_res.map,
> -				    hwc->inflight_msg_res.size);
> +	if (!hwc->channel_up) {
> +		spin_unlock_irqrestore(&r->lock, flags);
> +		up(&hwc->sema);
> +		return -ENODEV;
> +	}
> +
> +	/* The semaphore admits at most r->size holders at a time, so a slot
> +	 * acquired above always has a free bit waiting for it here.
> +	 */
> +	index = find_first_zero_bit(r->map, r->size);
> +	if (WARN_ON_ONCE(index >= r->size)) {
> +		spin_unlock_irqrestore(&r->lock, flags);
> +		up(&hwc->sema);
> +		return -EIO;
> +	}
>  
>  	ctx = &hwc->caller_ctx[index];
>  	reinit_completion(&ctx->comp_event);
> @@ -28,11 +45,12 @@ static int mana_hwc_get_msg_index(struct hw_channel_context *hwc, u16 *msg_id)
>  	 */
>  	refcount_set(&ctx->refcnt, 2);
>  	ctx->responded = false;
> +	ctx->resp_pending = true;

[Severity: Low]
The new field is documented in include/net/mana/hw_channel.h as:

	/* Response-side reference outstanding; protected by lock. */
	bool resp_pending;

but this initializing write runs under hwc->inflight_msg_res.lock only,
and ctx->lock is never taken in mana_hwc_get_msg_index().  Every other
write to the field (mana_hwc_handle_resp(), the timeout path and the out:
path of mana_hwc_send_request(), and mana_hwc_destroy_channel()) does hold
ctx->lock.

On the consumer side, mana_hwc_handle_resp() gates on a lock-free
test_bit(msg_id, hwc->inflight_msg_res.map) before acquiring ctx->lock, so
the publishing stores to responded/resp_pending and the bitmap bit share no
lock or barrier with the reader that consumes them.

Since msg_id comes from the RX buffer and is read with READ_ONCE() in
mana_hwc_rx_event_handler() precisely because the host can modify it, a
response for the freshly published msg_id can arrive between bitmap_set()
and the sender's first spin_lock(&ctx->lock).  If that handler observed the
new resp_pending == true together with a stale responded == true it would
consume the response-side reference, and a later sender timeout would then
drop the refcount to zero and reopen the late-response reuse window this
patch closes.

Should the comment name inflight_msg_res.lock plus the publication
ordering, or should the initialization move under ctx->lock?

>  	ctx->msg_id = index;
>  	ctx->error = -EINPROGRESS;
>  
>  	/* Publish the slot last, after it is fully initialised. */
> -	bitmap_set(hwc->inflight_msg_res.map, index, 1);
> +	bitmap_set(r->map, index, 1);
>  
>  	spin_unlock_irqrestore(&r->lock, flags);
>  

[ ... ]

> @@ -817,6 +873,11 @@ int mana_hwc_create_channel(struct gdma_context *gc)
>  	gd->pdid = INVALID_PDID;
>  	gd->doorbell = INVALID_DOORBELL;
>  
> +	/* Publish for setup; queue initialization below must precede senders. */
> +	spin_lock_irqsave(&gc->hwc_lock, flags);
> +	gc->hwc.driver_data = hwc;
> +	spin_unlock_irqrestore(&gc->hwc_lock, flags);
> +
>  	/* mana_hwc_init_queues() only creates the required data structures,
>  	 * and doesn't touch the HWC device.
>  	 */

[Severity: Medium]
This isn't a bug introduced by this patch, since the baseline also assigned
gd->driver_data = hwc before mana_hwc_init_queues(), but does the new
channel_up gate give the impression that lookups are now safe when it is
ordered after the blocking acquire?

driver_data is published here, while sema_init() and
mana_gd_alloc_res_map() (which allocates the bitmap and initializes
inflight_msg_res.lock) only run inside mana_hwc_init_queues() ->
mana_hwc_init_inflight_msg(), and caller_ctx plus channel_up = true only
appear later in mana_hwc_test_channel().

mana_gd_send_request() gates on nothing else:

	hwc = gc->hwc.driver_data;
	if (!hwc) { ... return -ENODEV; }
	hwc->active_senders++;

so a sender that observes the freshly published pointer reaches
mana_hwc_get_msg_index() and executes:

	if (down_timeout(&hwc->sema, msecs_to_jiffies(hwc->hwc_timeout)))

on a kzalloc'ed semaphore (count == 0, wait_list.next/prev == NULL, so
___down_common()'s list_add_tail() walks NULL pointers), then
spin_lock_irqsave(&r->lock, flags) on a never-initialized spinlock, all
before the channel_up check can reject it.

The same window exists in the depth-renegotiation path added later in the
series, which calls mana_hwc_destroy_queues() (frees the bitmap, kfrees
caller_ctx) and then mana_hwc_init_queues() again while driver_data stays
published.

I could not exhibit a concurrent sender, since mana_hwc_create_channel()
runs from mana_gd_setup() during probe and resume where the clients have
been removed or not yet probed.  Is the requirement stated by the two new
comments ("queue initialization below must precede senders", "The setup
caller must exclude concurrent HWC teardown") enforced anywhere in code?

[ ... ]

> @@ -864,14 +974,28 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
>  	}
>  	gc->max_num_cqs = 0;
>  
> +	/* Deregister the HWC EQ before freeing the work queues. */
> +	if (hwc->cq)
> +		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);
> +
>  	if (hwc->txq)
>  		mana_hwc_destroy_wq(hwc, hwc->txq);
>  
>  	if (hwc->rxq)
>  		mana_hwc_destroy_wq(hwc, hwc->rxq);
>  
> -	if (hwc->cq)
> -		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);

[Severity: High]
This is a pre-existing issue in the helper rather than something this patch
introduces, but since the comment here now makes mana_hwc_destroy_cq() the
fence for the interrupt handler, does that helper actually fence anything
before it frees the buffers the handler writes?

mana_hwc_destroy_cq() does:

	kfree(hwc_cq->comp_buf);

	if (hwc_cq->gdma_cq)
		mana_gd_destroy_queue(gc, hwc_cq->gdma_cq);

	if (hwc_cq->gdma_eq)
		mana_gd_destroy_queue(gc, hwc_cq->gdma_eq);

Only the last step reaches the barrier, via mana_gd_destroy_eq() ->
mana_gd_deregister_irq():

	list_del_rcu(&eq->entry);
	...
	synchronize_rcu();

Meanwhile the hard-IRQ callback writes into the buffer that was already
freed and dereferences the queue that was already destroyed:

	completions = hwc_cq->comp_buf;
	comp_read = mana_gd_poll_cq(q_self, completions, hwc_cq->queue_depth);

An interrupt taken in that interval reaches mana_gd_intr() -> the HWC EQ,
which is still on gic->eq_list -> mana_gd_process_eqe() ->
mana_hwc_comp_event(), so can this write into the kfree()d comp_buf?

The gc->max_num_cqs = 0 store just above helps for the completion path,
because mana_gd_process_eqe() does:

	if (WARN_ON_ONCE(cq_id >= gc->max_num_cqs))
		break;

but that plain store carries no barrier or RCU synchronization, so an
interrupt already inside mana_gd_process_eqe() on another CPU can still
pass the check, and the EQ-callback path has no such guard at all:
mana_hwc_init_event_handler() dereferences hwc->cq (for example
GDMA_EQE_HWC_INIT_EQ_ID_DB writing hwc->cq->gdma_eq->id) after it has been
kfree()d, and hwc->cq is not set to NULL here.

The window is also reachable when mana_smc_teardown_hwc() fails, since
mana_hwc_destroy_channel() only logs "Failed to tear down HWC" and
continues while the device may still be generating HWC EQEs and CQEs.

Would destroying and deregistering the EQ first, and freeing comp_buf and
the CQ last, close this?

[ ... ]

> @@ -965,43 +1101,40 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
>  		ctx->output_buf = NULL;
>  		err = ctx->error;
>  		status = ctx->status_code;
> +		if (err == -EINPROGRESS) {
> +			/* Publish abandonment with buffer withdrawal so a late
> +			 * response can reclaim the slot. Keep its reference.
> +			 */
> +			ctx->responded = true;
> +			abandoned = true;
> +		}
>  		spin_unlock_irqrestore(&ctx->lock, flags);

[Severity: Low]
This hunk, together with the resp_pending handling in
mana_hwc_handle_resp(), fixes a real misassociation on existing kernels:
the baseline timeout path did

out:
	mana_hwc_put_msg_index(hwc, msg_id);

while the hardware response was still outstanding, and
mana_hwc_handle_resp() dispatches purely on msg_id, so the next request
could take the same slot and be completed with the previous command's
response and buffer contents.

Should this carry a Fixes: tag and a description of the observable failure?
As posted the fix is bundled with unrelated behavioural changes (admission
timeout, sender draining, SQ posting serialization), so stable maintainers
have nothing to select on.

[ ... ]

> diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
> index 308950f9b54b0..571a533e62e64 100644
> --- a/include/net/mana/gdma.h
> +++ b/include/net/mana/gdma.h
> @@ -468,6 +468,15 @@ struct gdma_context {
>  	/* Hardware communication channel (HWC) */
>  	struct gdma_dev		hwc;
>  
> +	/* Sender drain; the final wakeup runs under hwc_lock. */
> +	wait_queue_head_t	hwc_drain_waitq;
> +
> +	/* Protects HWC publication, sender references, and short accesses in
> +	 * mana_need_log()/mana_serv_reset(). Setup and DMA-region readers
> +	 * still require lifecycle ordering. Not all timeout writers use it.
> +	 */
> +	spinlock_t		hwc_lock;

[Severity: Medium]
Does taking hwc_lock around the hwc_timeout accesses in mana_need_log() and
mana_serv_reset() provide any mutual exclusion, given that the remaining
writers and readers of that field do not take it?

Writers without the lock:

drivers/net/ethernet/microsoft/mana/hw_channel.c:mana_hwc_init_event_handler() {
		case HWC_DATA_CFG_HWC_TIMEOUT:
			hwc->hwc_timeout = val;
}

drivers/net/ethernet/microsoft/mana/hw_channel.c:mana_hwc_send_request() {
			if (hwc->hwc_timeout > 1)
				hwc->hwc_timeout = 1;
}

and mana_gd_verify_vf_version() passes &hwc->hwc_timeout to
mana_gd_query_hwc_timeout(), which writes through it unlocked.

Readers without the lock include wait_ms = hwc->hwc_timeout and the new
admission budget:

	if (down_timeout(&hwc->sema, msecs_to_jiffies(hwc->hwc_timeout)))

The first of those writers runs in hard-IRQ context, so
spin_lock_irqsave() in mana_need_log() only masks the local CPU and does
not exclude the same store on another CPU.

There is also an intent problem now that the field is a blocking budget:
the value is sampled before sleeping, so mana_serv_reset() setting

	hwc->hwc_timeout = 0;

under hwc_lock, specifically so that nothing waits, cannot shorten a wait
already in progress, and a reconfiguration EQE can restore a long timeout
in the middle of a reset cycle.

Would a single IRQ-safe lock for the field, or an explicit
READ_ONCE()/WRITE_ONCE() policy with defined update precedence, be a better
fit than the current "Not all timeout writers use it"?

>  
>  	/* Azure network adapter */
>  	struct gdma_dev		mana;
>  

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260908035201.402424-1-longli%40microsoft.com
