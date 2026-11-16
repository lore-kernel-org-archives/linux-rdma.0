Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794837269;
	b=FL518/h4CsjcQDKb9AJrtE9Ddq4YgedGvC2XspDT2Tp9A33ZXRTCtPO1Awbg6VH4rdt+
	 50IIt8OLsyk0TZ7zhEe9s0QJloj3rX2DsBZJ0Qu7046DZpbYJqm5reevHKP9BxUh4+oSd
	 0oSWSL+slhpUbLnS3e32LlCVnp9eBUjgPVJYyIAZi/jO7ayr8GVWEqlfS/3Z2F3YBRJxA
	 Gvrg5Ci34lj4kXC3xeCuOyiTDmYT43Iz5AFcAxMAhWtFNVyt0hB1pcMuPv7UlaAwB/iOe
	 oym/eqjuXBBHchlUb238AlkXR6TAr4UMl26f1UNwKlNC85OoBnMINbQR7adlhsIFymg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794837269;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=0721GlFT6hShZ7jRM2+1S2tjfPyDooe45lJaqDtewXo=;
	b=xrPMDO/u6JkPZY8T93HO3hbdgRGXN/6rotDae33PabMxwKyb/MZYs9hYvUhUG9wsuXRz
	 FBpNs1B0nApYC13XNmRNWGdgJBSKSLTwb6/S7Zq1LS9s0bYXg42lTa5X7Yop1rwc6pNjX
	 BIGsEL2e4Tolc2NcWf6QfbL9YYn2uhCwU/HHXfRu4M9UU7cX5qCMHR4OhDyq/MHE8Y4P4
	 pbdxoaGxBSb4d6YMdauGajF/SnTCL1mWeeWPqiZiw2JlpbxHMN88iBpX7VGAFgDrJTNZs
	 YslJM38UGAMCA1KktTkErPxK73kxfXTToBuWFkjLKt0g93Cjnl8+NJlIXn7cctWoZrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cNIKa8r0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD65760A2622;
	Mon, 16 Nov 2026 13:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cNIKa8r0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CEE91F000C5;
	Mon, 16 Nov 2026 13:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794837269;
	bh=0721GlFT6hShZ7jRM2+1S2tjfPyDooe45lJaqDtewXo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=cNIKa8r0rE0HqLiiTCIDiyk/9lgGWtj3NGAOjDTigwDgNbd6//XD4KJv4CJLfTxZ7
	 S4ArhACQZwLZ9WfwBpdrk0HmXD5zXhZuunJWCAdnul7i4JjUxPmvyVGiHcvVyH91D+
	 qj4hVj8v+UKBTBG2lZwut6zrzzsRb1meAFLmMHP2T2rTijvxy18GmIhtg4NqPHN/h5
	 W4K2NCtI77I9pWKsqn1GT0SNp5KHvrvF5RwjSIJEoNBj/uhZBx3sMTqIDoOpJVJwwN
	 HZ08FEPg58VyRB2jEATkG+EpEDoMDf5f+Cjb95/FOEtxP0SvCxKWz5QR1ntZbAQAIL
	 wwykmeZlHZuSw==
Subject:
 Re: [PATCH net v3] net: mana: Avoid waiting on dead HWC after device reset
From: netdev-bot+sashiko@kernel.org
To: sahilchandna@linux.microsoft.com
Cc: haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, kotaranov@microsoft.com, horms@kernel.org,
 ernis@linux.microsoft.com, gargaditya@linux.microsoft.com,
 mawasthi@linux.microsoft.com, kees+treewide@kernel.org,
 schakrabarti@linux.microsoft.com, leitao@debian.org,
 linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 stable@vger.kernel.org
Date: Mon, 16 Nov 2026 13:54:27 +0000
Message-ID: <179483726776.3136.399784833950391727@kernel.org>
In-Reply-To: <20261112085226.878780-1-sahilchandna@linux.microsoft.com>
References: <20261112085226.878780-1-sahilchandna@linux.microsoft.com>
X-sashiko-severity: High
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

Thank you for your contribution! Sashiko AI review found 6 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 3 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] If mana_gd_dev_reset() fails, mana_dealloc_queues() lowers
  hwc_timeout to 1 ms (cmpxchg at mana_en.c:3889) before any teardown…
- [Medium] The wait before a function-wide device reset drops from 120 s
  to about 300 ms.
- [Medium] The patch claims to bound how long mana_dealloc_queues() holds
  RTNL when the hardware is unresponsive ('This replaces the 120s drain…
- [Medium] net: mana: premature TX NAPI deletion in mana_dealloc_queues()
- [Low] mana_hwc_destroy_channel() now skips mana_smc_teardown_hwc() when
  hwc_dead is set, but its comment still says 'If it's non-zero, the HWC…
- [Low] The comment above mana_need_log() still says '/* Suppress logging
  when we set timeout to zero */'.

--

net: mana: Avoid waiting on dead HWC after device reset

This patch replaces the 120 s sleep-based TX drain in mana_dealloc_queues()
with synchronous CQ polling of up to about 300 ms per queue, then resets the
device if sends are still pending. A successful reset sets a new hwc_dead
flag, which makes mana_hwc_send_request() fail fast and skips
mana_fence_rqs() and the SHM teardown handshake; a failed reset lowers
hwc_timeout to 1 ms.

Link to v2: https://lore.kernel.org/all/20261030125009.3758592-1-sahilchandna@linux.microsoft.com/

> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> index ab942d5bfe058..94ee3b61527d6 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> @@ -153,7 +153,9 @@ bool mana_need_log(struct gdma_context *gc, int err)
>  		return true;
>  
>  	hwc = gc->hwc.driver_data;
> -	if (hwc && hwc->hwc_timeout == 0)
> +	if (hwc &&
> +	    (READ_ONCE(hwc->hwc_timeout) == 0 ||
> +	     READ_ONCE(hwc->hwc_dead)))
>  		return false;

[Severity: Low]
This isn't a bug, but the comment above mana_need_log() still reads:

/* Suppress logging when we set timeout to zero */

With this change, every -ETIMEDOUT is also suppressed once hwc_dead is set,
even when hwc_timeout is non-zero. That includes the new fail-fast returns
from mana_hwc_send_request(). So callers such as mana_destroy_wq_obj(),
mana_pf_deregister_filter(), mana_gd_destroy_dma_region() and the "Failed
to disable vPort" message in mana_dealloc_queues() log nothing.

Could the comment be updated to cover the hwc_dead case too?

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index fb9f38f65911c..ca9dcbfea9e46 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c

[ ... ]

> @@ -819,7 +819,11 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
>  	 * non-zero, the HWC worked and we should tear down the HWC here.
>  	 */
>  	if (gc->max_num_cqs > 0) {
> -		mana_smc_teardown_hwc(&gc->shm_channel, false);
> +		if (READ_ONCE(hwc->hwc_dead))
> +			dev_warn(hwc->dev,
> +				 "HWC unavailable, skip SHM teardown handshake\n");
> +		else
> +			mana_smc_teardown_hwc(&gc->shm_channel, false);
>  		WRITE_ONCE(gc->max_num_cqs, 0);
>  	}

[Severity: Low]
The comment just above still says the HWC should be torn down here whenever
max_num_cqs is non-zero. mana_smc_teardown_hwc() also describes the
handshake as required:

drivers/net/ethernet/microsoft/mana/shm_channel.c:mana_smc_teardown_hwc() {
    ...
	/* Read shmem response (polling for VF possession) and validate.
	 * For teardown, waiting for response is required to ensure hardware
	 * invalidates MST entries before software frees memory.
	 */
    ...
}

Right after this branch, mana_hwc_destroy_channel() frees the HWC queues,
caller_ctx and the hwc itself.

Skipping the handshake is only safe if a successful mana_gd_dev_reset()
guarantees the device has dropped those MST entries. Is that assumption
written down anywhere?

The pcie_flr() kernel-doc says it initiates FLR "unconditionally on @dev
without checking any flags and DEVCAP". A 0 return shows that the device's
config space is readable again, not that the reset actually happened. If
the FLR were ignored, hwc_dead would be set on a live device and the
handshake would be skipped. I couldn't check from the tree whether MANA
always honours FLR.

Could these comments explain why the handshake can be skipped after a
reset?

[ ... ]

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index 38249e092090a..739021aa09b38 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c

[ ... ]

> @@ -3799,42 +3809,110 @@ static int mana_dealloc_queues(struct net_device *ndev)

[ ... ]

> +				tx_cq->budget = 0;
> +				for (retry = 0; retry <= MANA_TX_DRAIN_RETRIES;
> +				     retry++) {
> +					do {
> +						tx_cq->work_done = 0;
> +						mana_poll_tx_cq(tx_cq);
> +					} while (tx_cq->work_done);
> +
> +					if (!atomic_read(&txq->pending_sends) ||
> +					    trigger_flr ||
> +					    READ_ONCE(hwc->hwc_dead))
> +						break;
> +					if (retry < MANA_TX_DRAIN_RETRIES)
> +						msleep(100);
>  				}
> -				break;
> +			}
> +
> +			pending = atomic_read(&txq->pending_sends);
> +
> +			if (!trigger_flr && pending > 0) {
> +				trigger_flr = true;
> +				flr_txq_id = txq->gdma_txq_id;
> +				flr_pending = pending;
> +			}
> +		}

[Severity: Medium]
This cuts the wait before a device reset from 120 s to about 300 ms. If any
queue still has pending_sends after the first poll and three more 100 ms
apart, trigger_flr is set and mana_gd_dev_reset() runs.

mana_gd_dev_reset() calls pcie_flr() on PCI and cdx_dev_reset() on CDX. So
it resets the whole function, including the HWC and every vPort, not just
the stalled queue.

On success, hwc_dead is set. Nothing clears it until
mana_hwc_destroy_channel() frees the hwc. Until then, every HWC request
from any port or from mana_ib fails with -ETIMEDOUT in
mana_hwc_send_request().

Recovery depends on mana_gf_stats_work_handler() getting -ETIMEDOUT and
calling mana_schedule_serv_work(). mana_cdx_bus_ops does not set
schedule_serv_work. Does the device stay dead on CDX?

mana_dealloc_queues() also runs on every ndo_stop and mana_detach() (MTU,
channel, ring and XDP changes), not only during recovery. A device that is
just slow or briefly paused would have finished draining within the old
120 s window. Now it gets a function-level reset.

Is 300 ms known to be long enough before a reset this disruptive? It would
help if the commit message explained why 300 ms was chosen. It could also
say that the reset is function-wide and that the device stays unusable
until a service reset.

> +		if (trigger_flr && !READ_ONCE(hwc->hwc_dead)) {
> +			/* Completions never arrived: the device is
> +			 * unresponsive. Issue device reset and
> +			 * mark the HWC dead so subsequent HWC commands
> +			 * fail fast instead of each waiting the full
> +			 * hwc_timeout.
> +			 */
> +			err = mana_gd_dev_reset(gd->gdma_context);

[Severity: Medium]
The commit message says:

  "This replaces the 120s drain timeout with at most 300 ms of sleep per
  queue."

However, mana_gd_dev_reset() still runs synchronously here, with RTNL and
the netdev instance lock held. On PCI this calls pcie_flr():

drivers/pci/pci.c:pcie_flr() {
    ...
	if (!pci_wait_for_pending_transaction(dev))
		pci_err(dev, "timed out waiting for pending transaction; performing function level reset anyway\n");
    ...
	msleep(100);

	ret = pci_dev_wait(dev, "FLR", PCIE_RESET_READY_POLL_MS);
    ...
}

pci_dev_wait() keeps sleeping, doubling the delay each time, until the
Command register reads back valid. It gives up only after about 60 s.

This reset is issued exactly when the driver has decided the device is
unresponsive. If the device does not come back from FLR, can RTNL be held
for about another 60 s here?

After that, the reset-failure path also reaches mana_fence_rqs(), which
sleeps 100 ms per RXQ when the fence fails.

> +			if (err) {
> +				netdev_err(ndev, "device reset failed %d with %d pkts pending in txq %u\n",
> +					   err, flr_pending, flr_txq_id);
> +
> +				/* reduce timeout if device reset failed */
> +				timeout = READ_ONCE(hwc->hwc_timeout);
> +				if (timeout > 1)
> +					cmpxchg(&hwc->hwc_timeout, timeout, 1);
> +			} else {
> +				WRITE_ONCE(hwc->hwc_dead, true);
>  			}
>  		}

[Severity: High]
If mana_gd_dev_reset() fails, hwc_timeout drops to 1 ms here, before any
teardown command has been sent. The commit message explains why the
commands are still posted:

  "If the reset fails, the device may not have been reset and may still
  access memory, so teardown commands are still posted"

hwc_dead stays false, so mana_disable_vport_rx(), mana_fence_rqs(),
mana_destroy_wq_obj() and mana_gd_destroy_dma_region() are all posted.
But mana_hwc_send_request() now waits only 1 ms for each reply:

	timeout = READ_ONCE(hwc->hwc_timeout);
	if (!wait_for_completion_timeout(&ctx->comp_event,
					 (msecs_to_jiffies(timeout)))) {

Any firmware reply slower than 1 ms gives -ETIMEDOUT, and the callers
ignore it.

The pending TX SKBs are unmapped and freed in the loop just below. After
that, mana_destroy_rxqs(), mana_destroy_txq() and mana_destroy_eq() free
the RX buffers, queue rings and DMA-region memory. mana_gd_destroy_queue()
frees the memory whether or not the destroy succeeded:

drivers/net/ethernet/microsoft/mana/gdma_main.c:mana_gd_destroy_queue() {
    ...
	mana_gd_destroy_dma_region(gc, gmi->dma_region_handle);
	mana_gd_free_memory(gmi);
	kfree(queue);
}

Can the device then DMA into memory that has already been freed?

Before this patch, the first teardown command on this path waited the full
hwc_timeout. If the HWC still worked, every teardown command was
acknowledged before memory was freed. This path is also much easier to
reach now, since the reset follows a 300 ms stall instead of 120 s.

The 1 ms value also stays in place until the HWC is rebuilt. A timed-out
msg_id slot is freed and handed out again right away through
find_first_zero_bit(), and ctx->comp_event is initialised only once, when
the HWC is set up. mana_hwc_handle_resp() matches a reply to its caller
only by msg_id:

drivers/net/ethernet/microsoft/mana/hw_channel.c:mana_hwc_handle_resp() {
    ...
	ctx = hwc->caller_ctx + msg_id;
	err = mana_hwc_verify_resp_msg(ctx, resp_msg, resp_len);
    ...
	memcpy(ctx->output_buf, resp_msg, resp_len);
    ...
	complete(&ctx->comp_event);
}

So a late reply to one request can complete a later request that got the
same slot.

The mana_en commands catch this with the msg_type check in
mana_verify_resp_hdr(), so mana_destroy_wq_obj() won't accept a stale
fence reply. mana_gd_destroy_dma_region() checks only resp.hdr.status:

	err = mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
	if (err || resp.hdr.status) {

Could a stale reply with status 0 be accepted here as a successful
GDMA_DESTROY_DMA_REGION?

Would it be safer to keep the normal hwc_timeout for the teardown commands
when the reset fails?

[ ... ]

> @@ -3799,42 +3809,110 @@ static int mana_dealloc_queues(struct net_device *ndev)
>  	 * a txq because it may not timely see apc->port_is_up being cleared
>  	 * to false, but it doesn't matter since mana_start_xmit() drops any
>  	 * new packets due to apc->port_is_up being false.
> -	 *
> -	 * Drain all the in-flight TX packets.
> -	 * A timeout of 120 seconds for all the queues is used.
> -	 * This will break the while loop when h/w is not responding.
> -	 * This value of 120 has been decided here considering max
> -	 * number of queues.
> +	 * Drain the in-flight TX completions for each queue. TX is already
> +	 * stopped, so pending_sends can no longer grow. For each queue,
> +	 * disable NAPI so it cannot run at the same time as this drain,
> +	 * then poll its CQ for up to 300 ms. If sends are still missing,
> +	 * the hardware is not responding: reset the device and mark the
> +	 * HWC dead so that later HWC commands fail fast.
>  	 */
>
>  	if (apc->tx_qp) {
>  		for (i = 0; i < apc->num_queues; i++) {
> +			struct napi_struct *napi;
> +			struct mana_cq *tx_cq;
> +			int pending;
> +
> +			if (!apc->tx_qp[i])
> +				continue;
> +
> +			tx_cq = &apc->tx_qp[i]->tx_cq;
>  			txq = &apc->tx_qp[i]->txq;
> -			tsleep = 1000;
> -			while (atomic_read(&txq->pending_sends) > 0 &&
> -			       time_before(jiffies, timeout)) {
> -				usleep_range(tsleep, tsleep + 1000);
> -				tsleep <<= 1;
> -			}
> -			if (atomic_read(&txq->pending_sends)) {
> -				err = mana_gd_dev_reset(gd->gdma_context);
> -				if (err) {
> -					netdev_err(ndev, "device reset failed %d with %d pkts pending in txq %u\n",
> -						   err,
> -					    atomic_read(&txq->pending_sends),
> -					    txq->gdma_txq_id);
> +			napi = &tx_cq->napi;
> +
> +			if (txq->napi_initialized) {
> +				/* Stop the NAPI poll so it cannot run
> +				 * concurrently with the synchronous drain.
> +				 */
> +				napi_synchronize(napi);
> +				napi_disable_locked(napi);
> +				cancel_work_sync(&tx_cq->dim.work);
> +
> +				/* Poll the CQ until no sends are outstanding,
> +				 * sleeping 100 ms between polls. Poll once
> +				 * if earlier queue was stuck or device
> +				 * has already been reset.
> +				 * A zero budget frees skbs via the non-NAPI
> +				 * path, which is required outside softirq.
> +				 */
> +				tx_cq->budget = 0;
> +				for (retry = 0; retry <= MANA_TX_DRAIN_RETRIES;
> +				     retry++) {
> +					do {
> +						tx_cq->work_done = 0;
> +						mana_poll_tx_cq(tx_cq);
> +					} while (tx_cq->work_done);
> +
> +					if (!atomic_read(&txq->pending_sends) ||
> +					    trigger_flr ||
> +					    READ_ONCE(hwc->hwc_dead))
> +						break;
> +					if (retry < MANA_TX_DRAIN_RETRIES)
> +						msleep(100);
>  				}
> -				break;
> +			}
> +
> +			pending = atomic_read(&txq->pending_sends);
> +
> +			if (!trigger_flr && pending > 0) {
> +				trigger_flr = true;
> +				flr_txq_id = txq->gdma_txq_id;
> +				flr_pending = pending;
> +			}
> +		}
> +
> +		if (trigger_flr && !READ_ONCE(hwc->hwc_dead)) {
> +			/* Completions never arrived: the device is
> +			 * unresponsive. Issue device reset and
> +			 * mark the HWC dead so subsequent HWC commands
> +			 * fail fast instead of each waiting the full
> +			 * hwc_timeout.
> +			 */
> +			err = mana_gd_dev_reset(gd->gdma_context);
> +			if (err) {
> +				netdev_err(ndev, "device reset failed %d with %d pkts pending in txq %u\n",
> +					   err, flr_pending, flr_txq_id);
> +
> +				/* reduce timeout if device reset failed */
> +				timeout = READ_ONCE(hwc->hwc_timeout);
> +				if (timeout > 1)
> +					cmpxchg(&hwc->hwc_timeout, timeout, 1);
> +			} else {
> +				WRITE_ONCE(hwc->hwc_dead, true);
>  			}
>  		}
>
>  		for (i = 0; i < apc->num_queues; i++) {
> +			struct napi_struct *napi;
> +			struct mana_cq *tx_cq;
> +
> +			if (!apc->tx_qp[i])
> +				continue;
> +
> +			tx_cq = &apc->tx_qp[i]->tx_cq;
> +			napi = &tx_cq->napi;
> +
>  			txq = &apc->tx_qp[i]->txq;
>  			while ((skb = skb_dequeue(&txq->pending_skbs))) {
>  				mana_unmap_skb(skb, apc);
>  				dev_kfree_skb_any(skb);
>  			}
>  			atomic_set(&txq->pending_sends, 0);
> +
> +			if (txq->napi_initialized) {
> +				netif_napi_del_locked(napi);
> +				txq->napi_initialized = false;
> +			}
>  		}
>  	}
>

[Severity: Medium]
This deletes the TX NAPI and clears txq->napi_initialized long before
the SQ object is destroyed and the TX CQ is detached.

mana_destroy_txq() was arranged so that mana_gd_detach_cq(),
netif_napi_del_locked() and clearing napi_initialized all happen
together, after mana_destroy_wq_obj(GDMA_SQ). Its comment says this is
so a completion EQE that arrives before the WQ is destroyed still finds
the CQ, and so one grace period covers both mana_gd_intr() and NAPI
users.

With this change, the TX CQ is still published in gc->cq_table[], and
the EQ is still live, while mana_disable_vport_rx(), mana_fence_rqs(),
mana_destroy_rxqs() and mana_destroy_wq_obj() run. A completion EQE for
this CQ in that window reaches mana_schedule_napi() on a napi_struct
that has already been through netif_napi_del_locked().

The memory stays valid until kvfree() in mana_destroy_txq(). The
NAPI_STATE_SCHED bit left set by napi_disable_locked() probably keeps
this from doing real harm. Still, this is exactly the ordering
mana_destroy_txq() was written to avoid.

When mana_destroy_txq() runs later, napi_initialized is already false
for every queue, so its detach/del block is skipped. The CQ is then
detached from mana_deinit_cq() -> mana_gd_destroy_queue() ->
mana_gd_destroy_cq(), which calls synchronize_net() again. That gives
two grace periods per TX queue under RTNL, where there used to be one.

I assume napi_initialized is cleared here so that mana_destroy_txq()
does not call napi_synchronize() and napi_disable_locked() a second
time. Both would spin forever on the NAPI_STATE_SCHED bit left by the
first disable.

Could that be avoided without moving the deletion? For example, the
disabled state could be tracked separately from napi_initialized, so
that mana_destroy_txq() skips only the synchronize/disable step. The
detach and netif_napi_del_locked() would then still happen together
after mana_destroy_wq_obj().

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261112085226.878780-1-sahilchandna%40linux.microsoft.com
