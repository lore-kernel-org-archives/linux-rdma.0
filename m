Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D663396591;
	Sat,  5 Sep 2026 20:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788638550; cv=none; b=W8EOgcJ9Yg3C1POFNzNM64tgfjCBzibh61heppGjF/0I6MQnU4tJS3b2/9A/xsBvZhH8P/5ZXxptNbxgvIXmWS4XerXhXVYMDVKw6nedaviI0Xb7xFxJOY/AbohNrfGJvfcV8t+9IJbmo6eeEbMFWxq0tL/+1SpX/gOklljwE6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788638550; c=relaxed/simple;
	bh=wZXPzT/xKmlEi7GGslrAZTeIHgx+G/0X3kyIZeuED0I=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CKJkbbSKhxtE1AD4VAYiJhcZvFxA3uXKGuGw4+8Lfn53sjrXfOakKuUcBrvfEr+SuI2mZYPFw1No563e1G3S7sXOpKXPq3nFm16jNbQpnkVhMmdoFwZlEuFz2nLt5cIffjUEWtDTdxxoZTVDHcT9ao92NntOYzITny6nuIbMvnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J02wcXXz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J02wcXXz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA15D1F00A3D;
	Sat,  5 Sep 2026 20:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788638548;
	bh=G0SAGa7S57M2sNkrkQV6iK6rrt58tY6JigLM71c338Y=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=J02wcXXzZtnz4L1Qc9YTIRH14mnCVrw2kjkeXY6MARXv80uJvetiL4v3lfmmhwHy0
	 ykPiD12ePigcURridFFY0IBmtP2I61QrhyRL0zIus+M4A4N/YPCbWvdWbPIqfxaVms
	 GKCpijrj5lOmuu7Av4KaTi3y2s/7FveSshKalWBMxlFj6DpBCq9UDw50FJNpdNCFli
	 AK2+4fnwh2EfzGXb4GNOtz0bBGfZYzhYdycerlSAtmwkXUWXTFgkYWr1p7eWEyo97L
	 8uvFZCAnQtKB08PD9oC3rDOkrN38aklchPXZjbNMDgRwld+4dgSeKZu/iB2PmwE9iH
	 /30NYGTF5E4og==
Subject: Re: [PATCH net-next v4 4/4] net: mana: add dynamic HWC queue depth
 with reinit path
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
Date: Sat, 05 Sep 2026 20:02:26 +0000
Message-ID: <178863854630.219967.11264470350603990060@kernel.org>
In-Reply-To: <20260901200018.3194525-5-longli@microsoft.com>
References: <20260901200018.3194525-5-longli@microsoft.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 6 potential
issue(s) to consider:

Critical: 0 · High: 3 (3) · Medium: 1 · Low: 2

- [High] The HWC doorbell page index is taken straight from the device
  (`gd->doorbell = eq_db.doorbell` in mana_hwc_init_event_handler(),…
- [High] NULL pointer dereference on the new reinit_fallback path.
- [High] The new INVALID_DOORBELL guard is placed after the write it is
  supposed to prevent.
- [Medium] Negotiated-dimension validation is not applied on every
  establish, contradicting the commit message.
- [Low] Commit message claims the pre-existing 'first establish omits the
  doorbell' unchecked-MMIO path is not addressed, while the new…
- [Low] Contradictory comments inside mana_hwc_create_channel(): the
  early publish stores gc->hwc.driver_data under gc->hwc_lock with a…

Pre-existing issues:
- [High] mana_hwc_destroy_cq() frees the CQ completion state before the
  EQ interrupt is fenced: it does kfree(hwc_cq->comp_buf), then…
- [High] The service-reset path and the PCI PM lifecycle can enter HWC
  teardown concurrently.
- [High] Service work is queued on the system workqueue and is never
  cancelled or flushed during driver teardown, so it can run against a…

--

net: mana: add dynamic HWC queue depth with reinit path

The HWC is bootstrapped at queue depth 1, then torn down and rebuilt at the
device-reported maximum depth so more management commands can be in flight,
with a fallback back to the bootstrap depth when the rebuild fails.  A new
capability flag advertises the support and the negotiated dimensions are
validated before they size DMA allocations.

A few questions on the doorbell handling, the dimension validation and the
fallback ordering below.

>From the commit message:

> Because that reset
> runs on every establish, a firmware that supplied the doorbell on the
> first one but omits it on the second would leave INVALID_DOORBELL
> behind, so refuse the channel in that case rather than let
> mana_gd_ring_doorbell() turn it into an unchecked write far outside the
> BAR.  The same write is already reachable without this patch when the
> very first establish omits the doorbell; that is pre-existing and not
> addressed here.

[Severity: Low]
Is this description of the scope accurate?  The new check sits in the
common body of mana_hwc_establish_channel(), so it also runs on the first
establish, not just the second one.

What remains unaddressed is something different: the doorbell is rung from
hard IRQ in mana_gd_process_eq_events() before the check can run at all, on
either establish (see the separate comment on the reset hunk).  Could the
wording say which part is actually still reachable?

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index 91fcf7c092113..83df4f194ee3b 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c

[ ... ]

> @@ -797,6 +806,21 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
>  	struct gdma_queue *cq = hwc->cq->gdma_cq;
>  	int err;
>  
> +	/* Clear the values a previous establish left behind so a firmware
> +	 * that omits an HWC_INIT_DATA_* item on this cycle cannot silently
> +	 * reuse stale dimensions from the last one.  The same applies to the
> +	 * routing identities: the queues are rebuilt from scratch, so a
> +	 * doorbell, PDID or PF destination left over from the previous
> +	 * channel does not describe them.
> +	 */
> +	hwc->hwc_init_q_depth_max = 0;
> +	hwc->hwc_init_max_req_msg_size = 0;
> +	hwc->hwc_init_max_resp_msg_size = 0;
> +	gc->hwc.doorbell = INVALID_DOORBELL;

[Severity: High]
Can this write happen before the guard added below can catch it?

The HWC EQ is armed from hard IRQ while the handshake is still running:

drivers/net/ethernet/microsoft/mana/gdma_main.c:mana_gd_process_eq_events() {
	...
	mana_gd_ring_doorbell(gc, eq->gdma_dev->doorbell, eq->type, eq->id,
			      head, SET_ARM_BIT);
	...
}

So the call chain is:

mana_gd_intr() -> mana_gd_process_eq_events() -> mana_gd_ring_doorbell()

If an EQE batch (INIT_DATA, INIT_DONE) is processed before
GDMA_EQE_HWC_INIT_EQ_ID_DB is consumed, gd->doorbell is still the sentinel
this hunk just stored, and mana_gd_ring_doorbell() does writeq() at
gc->db_page_base + gc->db_page_size * 0xffffffff, which is far outside the
ioremap'ed BAR0 window.  The guard below only runs after
wait_for_completion_timeout() returns.

On the second establish this also discards a doorbell index that was
already known good.  Would keeping (and range-checking) the index be
preferable to clearing it and checking afterwards?

> +	gc->hwc.pdid = INVALID_PDID;
> +	hwc->pf_dest_vrq_id = 0;
> +	hwc->pf_dest_vrcq_id = 0;
> +
>  	init_completion(&hwc->hwc_init_eqe_comp);
>  
>  	err = mana_smc_setup_hwc(&gc->shm_channel, false,
> @@ -815,6 +839,20 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
>  	*max_req_msg_size = hwc->hwc_init_max_req_msg_size;
>  	*max_resp_msg_size = hwc->hwc_init_max_resp_msg_size;
>  
> +	/* The doorbell was cleared before the handshake, so a firmware that
> +	 * signals INIT_DONE without sending GDMA_EQE_HWC_INIT_EQ_ID_DB
> +	 * leaves INVALID_DOORBELL behind.  mana_gd_ring_doorbell() turns
> +	 * that into gc->db_page_base + gc->db_page_size * 0xffffffff, an
> +	 * unchecked MMIO write far outside the mapped BAR, and the channel
> +	 * test below rings it.  Everything else the device reports either
> +	 * fails the dimension checks in mana_hwc_create_channel() or leaves
> +	 * the queues unable to complete, which that test already catches.
> +	 */
> +	if (gc->hwc.doorbell == INVALID_DOORBELL) {
> +		dev_err(hwc->dev, "HWC: no doorbell in init data\n");
> +		return -EPROTO;
> +	}

[Severity: High]
Does this catch anything other than the omission of
GDMA_EQE_HWC_INIT_EQ_ID_DB?

The doorbell index comes straight from the device in
mana_hwc_init_event_handler():

	case GDMA_EQE_HWC_INIT_EQ_ID_DB:
		eq_db.as_uint32 = event->details[0];
		hwc->cq->gdma_eq->id = eq_db.eq_id;
		gd->doorbell = eq_db.doorbell;

union hwc_init_eq_id_db declares doorbell as a 16-bit field, so the device
can never report UINT_MAX; only an omitted EQ_ID_DB produces the sentinel.
An in-field but out-of-BAR value such as 0xffff still reaches:

drivers/net/ethernet/microsoft/mana/gdma_main.c:mana_gd_ring_doorbell() {
	void __iomem *addr = gc->db_page_base + gc->db_page_size * db_index;
	...
	writeq(e.as_uint64, addr);
}

with a 4 KB doorbell page that is roughly 256 MB past the mapping.  The
driver already has the corresponding check on the peer path:

drivers/net/ethernet/microsoft/mana/gdma_main.c:mana_gd_register_device() {
	if (gc->db_page_off + gc->db_page_size * ((u64)resp.db_id + 1) > gc->bar0_size) {
		dev_err(gc->dev, "Doorbell ID %u out of range\n", resp.db_id);
		return -EPROTO;
	}
}

Would the same range test here work better, given it also subsumes the
sentinel case?

>  	/* Both were set in mana_hwc_init_event_handler(). */
>  	if (WARN_ON(cq->id >= gc->max_num_cqs))
>  		return -EPROTO;

[ ... ]

> @@ -872,13 +916,64 @@ static int mana_hwc_init_queues(struct hw_channel_context *hwc, u16 q_depth,
>  	return err;
>  }
>  
> +/* Tear down all HWC queues and free associated resources.  Used on
> + * the reinit-with-higher-queue-depth path and reinit fallback.
> + *
> + * PRECONDITION: must be called only during channel bring-up in
> + * mana_hwc_create_channel(), before the channel carries traffic:
> + * channel_up is still false, caller_ctx is not yet allocated, the
> + * data path is not probed yet, and active_senders is 0 — so no
> + * request or response user can reach these queues.  That is why this
> + * skips the hwc_lock-protected driver_data clear + active_senders
> + * drain that mana_hwc_destroy_channel() needs for the runtime
> + * teardown race; only the CQ-first ordering below (to fence off a
> + * pending interrupt) is required.  Bring-up itself runs under the
> + * PCI/PM device_lock, or under GC_IN_SERVICE on the service path;
> + * those two do not exclude each other, so a service reset racing a PM
> + * transition is not serialized — but that is pre-existing and applies
> + * equally to mana_hwc_destroy_channel(), which frees the same
> + * objects.  Calling this on a live, published channel would be a
> + * use-after-free.

[Severity: High]
This is a pre-existing issue and not introduced by this patch, but since
the comment documents the gap: can the two teardown contexts free the same
hwc twice?

mana_serv_reset() drives the suspend/resume cycle from a workqueue with no
device_lock held:

drivers/net/ethernet/microsoft/mana/gdma_main.c:mana_serv_reset() {
	spin_unlock_irqrestore(&gc->hwc_lock, flags);

	dev_info(&pdev->dev, "MANA reset cycle start\n");

	mana_gd_suspend(pdev, PMSG_SUSPEND);
	...
}

while .suspend and .remove run under device_lock, and GC_IN_SERVICE only
serializes service jobs against each other.  mana_hwc_destroy_channel()
then reads the pointer outside hwc_lock:

	struct hw_channel_context *hwc = gc->hwc.driver_data;

	if (!hwc)
		return;

so both callers can observe the same non-NULL hwc and both proceed to
destroy the CQ/TXQ/RXQ and kfree(hwc).  Is something else preventing that?

[Severity: High]
This is also pre-existing and not introduced by this patch, but related to
the service path named in the comment: is the service work ever cancelled
before gc is freed?

mana_schedule_serv_work() puts the item on the system workqueue:

	INIT_WORK(&mns_wk->serv_work, mana_serv_func);
	schedule_work(&mns_wk->serv_work);

while cleanup only drains the unrelated ordered queue:

drivers/net/ethernet/microsoft/mana/gdma_main.c:mana_gd_cleanup_device() {
	if (gc->service_wq) {
		destroy_workqueue(gc->service_wq);
		gc->service_wq = NULL;
	}
}

and mana_gd_remove() then does vfree(gc).  mana_serv_func() ->
mana_do_service() -> mana_serv_reset() takes gc from
pci_get_drvdata(pdev) and dereferences gc->hwc_lock and
gc->hwc.driver_data, so a worker that already read a valid pointer would
operate on freed memory.  Would a cancel_work_sync() for the pending item
in the remove path close that?

> + */
> +static void mana_hwc_destroy_queues(struct hw_channel_context *hwc)
> +{
> +	struct gdma_context *gc = hwc->gdma_dev->gdma_context;
> +
> +	/* Destroy CQ first to deregister the EQ from the interrupt
> +	 * handler list before freeing caller_ctx, TXQ, or RXQ memory.
> +	 * A pending interrupt handler could still reach handle_resp()
> +	 * which dereferences caller_ctx.
> +	 */
> +	if (hwc->cq) {
> +		mana_hwc_destroy_cq(gc, hwc->cq);
> +		hwc->cq = NULL;
> +	}

[Severity: High]
This isn't a bug introduced by this patch, but does mana_hwc_destroy_cq()
actually fence the interrupt before it frees its own state?

mana_hwc_destroy_cq() frees comp_buf and the GDMA CQ first, and only then
the EQ:

drivers/net/ethernet/microsoft/mana/hw_channel.c:mana_hwc_destroy_cq() {
	kfree(hwc_cq->comp_buf);

	if (hwc_cq->gdma_cq)
		mana_gd_destroy_queue(gc, hwc_cq->gdma_cq);

	if (hwc_cq->gdma_eq)
		mana_gd_destroy_queue(gc, hwc_cq->gdma_eq);
	...
}

but the IRQ removal and the RCU fence only happen in the EQ teardown:

drivers/net/ethernet/microsoft/mana/gdma_main.c:mana_gd_deregister_irq() {
	list_del_rcu(&eq->entry);
	...
	synchronize_rcu();
}

So a handler already inside its read section via mana_gd_intr() ->
mana_gd_process_eq_events() -> mana_gd_process_eqe() ->
mana_hwc_comp_event() can still touch the freed gdma_cq and the freed
comp_buf.  The comment here relies on the CQ-first ordering fencing off a
pending interrupt, which only holds for what is freed after
mana_hwc_destroy_cq() returns.  Would destroying/deregistering the EQ
before freeing comp_buf and the CQ be the right order?

> +
> +	kfree(hwc->caller_ctx);
> +	hwc->caller_ctx = NULL;

[ ... ]

> @@ -926,8 +1021,200 @@ int mana_hwc_create_channel(struct gdma_context *gc)
>  		goto out;
>  	}
>  
> +	/* The channel was bootstrapped at a minimal queue depth.  If the
> +	 * device reports a higher maximum, tear down and rebuild with
> +	 * the larger depth so more HWC commands can be in flight.
> +	 */
> +	if (q_depth_max > HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH) {

[ ... ]

> +		if (max_req_msg_size != HW_CHANNEL_MAX_REQUEST_SIZE ||
> +		    max_resp_msg_size != HW_CHANNEL_MAX_RESPONSE_SIZE ||
> +		    (u64)q_depth_max * max_req_msg_size >
> +			U32_MAX - MANA_PAGE_SIZE ||
> +		    (u64)q_depth_max * max_resp_msg_size >
> +			U32_MAX - MANA_PAGE_SIZE) {
> +			dev_err(hwc->dev,
> +				"HWC: invalid dims q=%u req=%u resp=%u\n",
> +				q_depth_max, max_req_msg_size,
> +				max_resp_msg_size);
> +			q_depth_max = HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH;
> +			goto skip_reinit;
> +		}

[Severity: Medium]
The commit message says "Reject a device-reported message size above the
driver maximum", but is that what happens here?

This is the only message-size validation added, and it is nested under
q_depth_max > HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH.  A device that reports
depth 0 or 1 together with arbitrary or zero HWC_INIT_DATA_MAX_REQUEST /
HWC_INIT_DATA_MAX_RESPONSE values never reaches this check;
mana_hwc_init_event_handler() stores them verbatim and
mana_hwc_establish_channel() hands them back unchecked.

When the depth is larger and the sizes do mismatch, the mismatch is not
rejected either - q_depth_max is reset and the code jumps to skip_reinit,
continuing on the already-established channel.

The backstop the commit message names also does not look like one:

	static int mana_hwc_test_channel(struct hw_channel_context *hwc, u16 q_depth,
					 u32 max_req_msg_size, u32 max_resp_msg_size)

neither max_req_msg_size nor max_resp_msg_size is read in the body, so it
cannot catch a contradictory or omitted size report.

Was returning an error intended for the mismatch case, and should the check
move out of the depth > bootstrap branch?

[ ... ]

> +	}
> +
> +	goto skip_reinit;
> +
> +reinit_fallback:
> +	/* Restore bootstrap-depth channel so the device remains functional.
> +	 * Free cq_table if it was allocated by a partially successful
> +	 * establish attempt.
> +	 */
> +	dev_warn(hwc->dev, "HWC reinit failed, falling back to bootstrap depth\n");
> +
> +	mana_hwc_destroy_queues(hwc);
> +
> +	old_cq_table = gc->cq_table;
> +	gc->cq_table = NULL;
> +	/* Clear the bound with the table, as above. */
> +	gc->max_num_cqs = 0;

[Severity: High]
Can this order oops on a NULL gc->cq_table?

mana_hwc_destroy_queues() runs before gc->max_num_cqs is cleared here, and
on this path gc->cq_table was already set to NULL by the reinit branch
above.  If the re-establish then failed after
mana_hwc_init_event_handler() stored HWC_INIT_DATA_MAX_NUM_CQS and
HWC_INIT_DATA_CQID from hard IRQ, but before gc->cq_table was allocated,
max_num_cqs is non-zero with a NULL table.  The new -EPROTO return for the
missing doorbell, the wait_for_completion_timeout() -ETIMEDOUT return and
the vcalloc() -ENOMEM return all leave that state.

mana_hwc_destroy_queues() -> mana_hwc_destroy_cq() ->
mana_gd_destroy_queue() then reaches:

drivers/net/ethernet/microsoft/mana/gdma_main.c:mana_gd_destroy_cq() {
	u32 id = queue->id;

	if (id >= gc->max_num_cqs)
		return;

	if (!gc->cq_table[id])
		return;
	...
}

which passes the bound and dereferences the NULL table.  The runtime
teardown avoids this by setting gc->max_num_cqs = 0 before
mana_hwc_destroy_cq().  Would zeroing gc->max_num_cqs and gc->cq_table
before the mana_hwc_destroy_queues() call here (and resetting
gc->max_num_cqs alongside the other stale init fields in
mana_hwc_establish_channel()) be enough?

> +	synchronize_rcu();
> +	vfree(old_cq_table);
> +

[ ... ]

> +skip_reinit:
> +
> +	/* No RCU needed: still in mana_hwc_create_channel, the
> +	 * pointer has not been published to concurrent senders yet.
> +	 */

[Severity: Low]
This comment and the publish earlier in the same function seem to disagree.
Earlier in mana_hwc_create_channel():

	/* Publish driver_data last, under hwc_lock: the lock orders the hwc
	 * initialisation above before the pointer becomes visible and
	 * serialises the publish against the control-plane readers in
	 * mana_gd_send_request(), mana_need_log() and mana_serv_reset().
	 */
	spin_lock_irqsave(&gc->hwc_lock, flags);
	gc->hwc.driver_data = hwc;
	spin_unlock_irqrestore(&gc->hwc_lock, flags);

so the pointer has been published by the time skip_reinit is reached.  What
keeps senders out is hwc->channel_up, which mana_hwc_get_msg_index()
tests.  Could the comment say that instead?

>  	err = mana_hwc_test_channel(gc->hwc.driver_data,
> -				    HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH,
> +				    hwc->num_inflight_msg,
>  				    max_req_msg_size, max_resp_msg_size);
>  	if (err) {
>  		dev_err(hwc->dev, "Failed to test HWC: %d\n", err);

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260901200018.3194525-1-longli%40microsoft.com
