Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793711196;
	b=lQeLMF2F5BjObBankrNIWQmYjHuaeIMfopaYk1LW66MgI8dnEjJH/YdKh4vaX16cr3lf
	 eT3R7wMOvLVMcm4ley0hVJ8Ca0O2DPpcWdZ5fUNRPYQyLso+FvymS/crDIP6/UoA4UGTJ
	 sQrnm9jwLkumnwjif/vFOzbn1Efax+5RVqoaJiHqjoFiF/iHHHR701eIf+Dp5xO1GKDL5
	 G4VXY1///d8Kn67xDPmWJ+vIiWXz3gXcbi9oHv/whV4+XX7NJ37rMCLwsC1lc4LfF7aaj
	 TmLRSGS2yzoKYKJCxA5LBdEo/28ViAgW0EXMUB+VjuZ1WlHUJghaBv5lUueXUXBz1uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793711196;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=GpnTD0Y8foNyYZLXMIcPDF4aNhJHeN2XBgEwyfG41to=;
	b=g+u4XG1RmE3+J2t9c6CGQ2Ds0eM3uJTT7tndWuGtf+/c+fjDwSHkCyObgogtoCtBeG/l
	 OczsLU4gTZ6OM8SPwfYBD6ZYccz0ljIxHRdlS3/BSjZq66FT82CqlM/7hhhXI1vRDrxZ+
	 hVKTj0EGPHhRZwNR0qxolh8ACUOSJq0lGSnjuy9PM+cqJ0Ul++XAWwz6tVd5BR8rmi6jm
	 mFAarMduAQGsG5Ba7Tld9QwvwzK/8aYwZVzJiHolQCIVBOtJxfBJVhtSTXCQhlWVYWPCF
	 WntjRzo+jn9A7IgZW33nhvUV6tDtvc/oWAD2q5nI+hnNiRvRD8rCtzrzyVubrg/xzOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M19R1cWi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740FA60850BA;
	Tue,  3 Nov 2026 13:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M19R1cWi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1580C1F00A15;
	Tue,  3 Nov 2026 13:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793711196;
	bh=GpnTD0Y8foNyYZLXMIcPDF4aNhJHeN2XBgEwyfG41to=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=M19R1cWi1iIgdzxrg5bA8vh/gO+eF1WBudfOveIotw0sC6L9MnxSlnfi8FJTG9GXq
	 0wgy6+KI7s4dJhXtBvZOicvixbhvht3J2bh6UmizYHexT1lJHv30LrvntKmQuLNsf/
	 hPAuvhZ4mY5PAsOmx08lNT3vm1pHHD3i2AJ93lKX9G5N0nsSXAnj0lMkRqC/xA/n57
	 Wi74+HJo3fou0XYnKoa9OspAI+jZ/Dv4sYTgetCyKItDUm/IEn9DMMSjCC1XwAs62B
	 r9AMOpoeHyhPBKsfrmYtKFAYDvsPdm8bhDFEn5hoqvdzEc63RIrlg/BvMEw1lNX2Vl
	 Nh+Ud6lqhsvmA==
Subject:
 Re: [PATCH net v2] net: mana: Avoid waiting on dead HWC after device reset
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
Date: Tue, 03 Nov 2026 13:06:34 +0000
Message-ID: <179371119457.488856.15091459505678902875@kernel.org>
In-Reply-To: <20261030125009.3758592-1-sahilchandna@linux.microsoft.com>
References: <20261030125009.3758592-1-sahilchandna@linux.microsoft.com>
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

Thank you for your contribution! Sashiko AI review found 6 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 4 (3) · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The new TX drain in mana_dealloc_queues()
  (drivers/net/ethernet/microsoft/mana/mana_en.c, lines 3822-3844)…
- [Medium] In mana_dealloc_queues(), hwc_dead is set only when
  mana_gd_dev_reset() succeeds: `if (err) netdev_err(...); else if (hwc)…
- [Medium] mana_hwc_send_request() checks hwc_dead and hwc_timeout
  locklessly (READ_ONCE at hw_channel.c:878 and 918-919), then posts the…
- [Medium] mana_hwc_send_request() now returns -ETIMEDOUT without posting
  the WQE whenever hwc_timeout == 0 (hw_channel.c:878-879 and 918-922),…
- [Low] The comment this patch rewrote in mana_destroy_txq()
  (mana_en.c:2733) says "Forget the SKBs freed in mana_dealloc_queue()…
- [Low] The timeout path of mana_hwc_send_request() does `if
  (READ_ONCE(hwc->hwc_timeout) > 1) WRITE_ONCE(hwc->hwc_timeout, 1);`…

Pre-existing issues:
- [Medium] This problem wasn't introduced by this patch, but in
  mana_dealloc_queues(), when mana_gd_dev_reset() fails after…
- [Medium] This problem wasn't introduced by this patch, but when
  wait_for_completion_timeout() expires in mana_hwc_send_request()…
- [Medium] This problem wasn't introduced by this patch, but
  mana_hwc_destroy_channel() (hw_channel.c:831-838) frees hwc->txq and…

--

net: mana: Avoid waiting on dead HWC after device reset

This patch replaces the sleep-based TX drain in mana_dealloc_queues(),
which could last up to 120s, with a bounded synchronous CQ poll (3
retries, 100 ms apart) after NAPI is disabled. If sends are still
pending it resets the device at most once. A successful reset sets a new
hwc_dead flag, which mana_hwc_send_request() checks together with
hwc_timeout == 0 so it can return -ETIMEDOUT without posting a WQE, and
mana_fence_rqs() and the SHM teardown handshake are skipped once
hwc_dead is set.

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index 3bca4b683134b..a50a36ba25710 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c

[ ... ]

> @@ -819,7 +819,12 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
>  	 * non-zero, the HWC worked and we should tear down the HWC here.
>  	 */
>  	if (gc->max_num_cqs > 0) {
> -		mana_smc_teardown_hwc(&gc->shm_channel, false);
> +		if (READ_ONCE(hwc->hwc_dead))
> +			dev_warn(hwc->dev,
> +				 "HWC unavailable, skip SHM teardown handshake\n");
> +		else
> +			mana_smc_teardown_hwc(&gc->shm_channel, false);
> +
>  		gc->max_num_cqs = 0;
>  	}

[Severity: Medium]
This is a pre-existing issue, not one introduced by this patch. Can the
rest of this teardown race with an HWC completion interrupt that is
already running on another CPU?

Setting gc->max_num_cqs = 0 is a plain store. It stops new CQ dispatch,
but it doesn't wait for a mana_hwc_comp_event() that is already in
progress. After that:

mana_hwc_destroy_channel()
  mana_hwc_destroy_wq(hwc, hwc->txq)    <- frees msg buffers and hwc_wq
  mana_hwc_destroy_wq(hwc, hwc->rxq)
  mana_hwc_destroy_cq()
    kfree(hwc_cq->comp_buf);
    mana_gd_destroy_queue(gc, hwc_cq->gdma_eq)
      ...
        mana_gd_deregister_irq()        <- list_del_rcu() + synchronize_rcu()

The only drain of the EQ callback happens after comp_buf and the work
queues have been freed. An in-flight handler uses hwc_cq->comp_buf, and
the tx/rx event handlers dereference hwc->txq and hwc->rxq. The hwc_dead
branch added here doesn't change this ordering.

> @@ -862,9 +867,17 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,

[ ... ]

> +	/* Fail fast before taking the HWC slot, after a device reset, a
> +	 * request already holding it may never complete.
> +	 */
> +
> +	if (!READ_ONCE(hwc->hwc_timeout) || READ_ONCE(hwc->hwc_dead))
> +		return -ETIMEDOUT;

[Severity: Medium]
Is it intended that hwc_timeout == 0 now means the WQE is never posted?
This check and the second one before mana_hwc_post_tx_wqe() return
-ETIMEDOUT without submitting anything whenever the timeout is 0, not
only after a device reset. Before this patch, a zero timeout meant the
WQE was still posted and wait_for_completion_timeout() was called with 0
jiffies.

mana_serv_reset() sets the zero timeout to mean "don't wait", and it
never resets the device:

	/* HWC is not responding in this case, so don't wait */
	WRITE_ONCE(hwc->hwc_timeout, 0);
	...
	mana_gd_suspend(pdev, PMSG_SUSPEND);

That path handles GDMA_EQE_HWC_RESET_REQUEST, gf_stats HWC timeouts and
probe-time recovery. Along mana_gd_suspend() -> mana_remove() ->
mana_detach() -> mana_dealloc_queues(), none of these commands reach the
hardware now: the MANA_CONFIG_VPORT_RX disable, the fences, and the
WQ/CQ object and DMA region destroys. An FLR only happens if TX sends
happen to be pending.

mana_destroy_rxq() still DMA-unmaps and frees the RX buffers and the
page pool while the hardware RQ and RX steering may still be live. The
SHM teardown that makes the hardware invalidate MST entries only runs
later, in mana_gd_cleanup(). If the RX data path is still active at that
point, can RX DMA land in buffers that were already unmapped and freed?

mana_fence_rqs() also still runs on this path, since only hwc_dead is
checked. Its msleep(100) per queue now waits on fences that were never
posted.

> +
>  	mana_hwc_get_msg_index(hwc, &msg_id);

[ ... ]

> @@ -897,6 +910,17 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,

[ ... ]

> +	timeout = READ_ONCE(hwc->hwc_timeout);
> +	if (timeout == 0 || READ_ONCE(hwc->hwc_dead)) {
> +		err = -ETIMEDOUT;
> +		goto out;
> +	}
> +
>  	err = mana_hwc_post_tx_wqe(txq, tx_wr, dest_vrq, dest_vrcq, false);

[Severity: Medium]
What serializes this lockless check against the
WRITE_ONCE(hwc->hwc_dead, true) in mana_dealloc_queues()?

Some HWC users don't hold RTNL, for example
mana_gf_stats_work_handler() -> mana_query_gf_stats() every 2 seconds,
or mana_ib verbs. They can run while mana_dealloc_queues() issues the
FLR. Such a request may already be posted when the FLR happens. It may
also pass this check, get preempted, and then post to the freshly reset
device.

Setting hwc_dead, or hwc_timeout = 0 in mana_serv_reset(), never
completes ctx->comp_event. That request then sleeps in
wait_for_completion_timeout() for the full captured timeout (60s in the
commit message's example).

The commit message says the driver returns "-ETIMEDOUT immediately
without submitting commands to hardware that cannot respond", but in
this window commands are still submitted and wait. Doesn't this also
delay the gf_stats worker's scheduling of the service reset by the same
amount?

>  	if (err) {
>  		dev_err(hwc->dev, "HWC: Failed to post send WQE: %d\n", err);
> @@ -904,14 +928,13 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
>  	}
>  
>  	if (!wait_for_completion_timeout(&ctx->comp_event,
> -					 (msecs_to_jiffies(hwc->hwc_timeout)))) {
> -		if (hwc->hwc_timeout != 0)
> -			dev_err(hwc->dev, "Command 0x%x timed out: %u ms\n",
> -				command, hwc->hwc_timeout);
> +					 (msecs_to_jiffies(timeout)))) {
> +		dev_err(hwc->dev, "Command 0x%x timed out: %u ms\n",
> +			command, timeout);
>  
>  		/* Reduce further waiting if HWC no response */
> -		if (hwc->hwc_timeout > 1)
> -			hwc->hwc_timeout = 1;
> +		if (READ_ONCE(hwc->hwc_timeout) > 1)
> +			WRITE_ONCE(hwc->hwc_timeout, 1);

[Severity: Low]
This read-check-write isn't atomic. If mana_serv_reset() runs
WRITE_ONCE(hwc->hwc_timeout, 0) between the READ_ONCE() and the
WRITE_ONCE() here, can the 0 be overwritten with 1?

With this patch, hwc_timeout == 0 is the sticky "don't submit" signal
for both new checks above. If it is lost, later requests during the
service-reset teardown take a slot, post a WQE and wait 1 ms instead of
failing fast. mana_need_log() also goes back to returning true for them.
Would a cmpxchg() here keep the zero from being lost?

>  
>  		err = -ETIMEDOUT;
>  		goto out;

[Severity: Medium]
This isn't a bug introduced by this patch. On this timeout path,
mana_hwc_put_msg_index() at the out label releases the slot while the
posted WQE is still outstanding, and ctx->comp_event is never
reinitialized. A late response is then handled by
mana_hwc_handle_resp():

	if (!test_bit(msg_id, hwc->inflight_msg_res.map)) {
	...
	memcpy(ctx->output_buf, resp_msg, resp_len);
	...
	complete(&ctx->comp_event);

If a new request has taken the same msg_id (find_first_zero_bit() tends
to hand out slot 0 again), can it get the old command's response? Can it
return immediately because of the leftover completion count?

If the handler passes test_bit() just before bitmap_clear() and is then
delayed, can memcpy() write into the stack buffer of a caller that has
already returned?

The 1 ms reduction after the first timeout is kept, which makes such
late responses more likely while the HWC is slow but not dead.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index 6b7c027e497ed..2bf17fdcfa2bd 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c

[ ... ]

> @@ -2725,10 +2730,10 @@ static void mana_destroy_txq(struct mana_port_context *apc)
>  			apc->tx_qp[i]->txq.napi_initialized = false;
>  		}
>  
> -		/* Forget the SKBs freed without being completed after a drain
> -		 * timeout, now that NAPI can't complete any. Doing it here also
> -		 * covers the queues that a lower channel count won't recreate,
> -		 * which could otherwise stay stopped.
> +		/* Forget the SKBs freed in mana_dealloc_queue() without
> +		 * completion, now that NAPI can't complete any. Doing it
> +		 * here also covers the queues that a lower channel count
> +		 * won't recreate, which could otherwise stay stopped.
>  		 */

[Severity: Low]
This isn't a bug, but there is no function called mana_dealloc_queue().
Should this say mana_dealloc_queues()?

Also, on the dealloc path the NAPI teardown block just above this
comment is now always skipped. mana_dealloc_queues() already calls
netif_napi_del_locked() and clears txq->napi_initialized before it calls
mana_destroy_txq(). Could the comment say that NAPI teardown for this
path now happens in mana_dealloc_queues()?

[ ... ]

> @@ -3774,42 +3784,104 @@ static int mana_dealloc_queues(struct net_device *ndev)

[ ... ]

>  	if (apc->tx_qp) {
>  		for (i = 0; i < apc->num_queues; i++) {

[ ... ]

> +			if (txq->napi_initialized) {
> +				/* Stop the NAPI poll so it cannot run
> +				 * concurrently with the synchronous drain.
> +				 */
> +				napi_synchronize(napi);
> +				napi_disable_locked(napi);
> +				cancel_work_sync(&tx_cq->dim.work);

[ ... ]

> +				tx_cq->budget = 0;
> +				for (retry = 0; retry < MANA_TX_DRAIN_RETRIES;
> +				     retry++) {
> +					do {
> +						tx_cq->work_done = 0;
> +						mana_poll_tx_cq(tx_cq);
> +					} while (tx_cq->work_done);
> +
> +					if (!atomic_read(&txq->pending_sends) ||
> +					    trigger_flr)
> +						break;
> +
> +					msleep(100);
>  				}
> -				break;
>  			}
> +
> +			pending = atomic_read(&txq->pending_sends);
> +
> +			if (!trigger_flr && pending > 0) {
> +				trigger_flr = true;
> +				flr_txq_id = txq->gdma_txq_id;
> +				flr_pending = pending;
> +			}

[Severity: Medium]
Is this drain window as long as it looks? On the last pass (retry == 2)
the loop polls, sees pending_sends > 0, does msleep(100), and then exits
without polling again. pending is read straight after that sleep.

pending_sends is only decremented in mana_poll_tx_cq(), and NAPI is
already disabled, so CQEs written during that final sleep are never
counted. In practice, completions are only seen if they arrive within
about 200 ms of napi_disable_locked(). Once trigger_flr is set, every
later queue gets a single poll.

If pending is still nonzero, mana_gd_dev_reset() resets the whole PCI
function:

    static int mana_pci_dev_reset(struct gdma_context *gc)
    {
            return pcie_flr(to_pci_dev(gc->dev));
    }

hwc_dead is then set, which affects every vPort and the RDMA aux device
until a service reset rebuilds the HWC.

The driver itself allows much longer TX stalls on healthy hardware, in
mana_probe_port():

    /* Recommended timeout based on HW FPGA re-config scenario. */
    ndev->watchdog_timeo = 15 * HZ;

Could a slow but working device get a function level reset here during a
routine close, MTU change, channel or ring change, or XDP attach?

The commit message says the device is reset "only if sends remain
unacknowledged", but acknowledgements that arrive during the final sleep
are never checked. Is there a hardware basis for the roughly 200-300 ms
budget?

> +		}
> +
> +		if (trigger_flr && !(hwc && hwc->hwc_dead)) {

[ ... ]

> +			err = mana_gd_dev_reset(gd->gdma_context);
> +			if (err)
> +				netdev_err(ndev, "device reset failed %d with %d pkts pending in txq %u\n",
> +					   err,
> +					   flr_pending,
> +					   flr_txq_id);
> +			else if (hwc)
> +				WRITE_ONCE(hwc->hwc_dead, true);
>  		}

[Severity: Medium]
What happens when mana_gd_dev_reset() fails here? trigger_flr means the
device already looks unresponsive, but the failure branch only logs an
error. hwc_dead stays false and hwc_timeout keeps the firmware value.

The reset can fail in several ways: pcie_flr() fails when pci_dev_wait()
times out, cdx_dev_reset() can fail, and mana_gd_dev_reset() returns
-EOPNOTSUPP when there is no dev_reset op. In that case both new checks
in mana_hwc_send_request() pass:

mana_dealloc_queues()
  mana_disable_vport_rx()
    ...
      mana_hwc_send_request()
        mana_hwc_post_tx_wqe()
        wait_for_completion_timeout()   <- full hwc_timeout, e.g. 60s

The !(hwc && hwc->hwc_dead) check doesn't skip mana_fence_rqs() either,
so each RX queue adds another 1 ms timeout plus msleep(100).

All of this runs under RTNL. Can the RTNL stall this patch is meant to
fix still happen when the reset fails?

>  
>  		for (i = 0; i < apc->num_queues; i++) {

[ ... ]

>  			txq = &apc->tx_qp[i]->txq;
>  			while ((skb = skb_dequeue(&txq->pending_skbs))) {
>  				mana_unmap_skb(skb, apc);
>  				dev_kfree_skb_any(skb);
>  			}

[Severity: Medium]
This isn't a bug introduced by this patch. When mana_gd_dev_reset()
fails above, this loop still unmaps and frees every SKB on
txq->pending_skbs. The device may still own WQEs for those
unacknowledged sends.

If the device is still alive, can it DMA-read through the stale IOVAs
into memory that has been freed and reused? With an IOMMU that would
show up as IOMMU faults. Without one, unrelated kernel data could be
sent on the wire.

The code before this patch did the same thing: it broke out of the loop
after the failed reset and then freed the SKBs.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261030125009.3758592-1-sahilchandna%40linux.microsoft.com
