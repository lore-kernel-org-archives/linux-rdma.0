Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ACA637DAD7;
	Sat,  5 Sep 2026 20:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788638548; cv=none; b=M5Axq4J2DgGpMEEmXzdnyQ54KTsS5qJ+AjGlbWY5jWYvx5W+QWJwFeaGz/YJ8OZbky1ArMslNHGtF1wDRB+S4voU6PcNG77x2jidh9KqxGnvBCeimIDWtovX64KdMSSKdyEiYcjxkoks4xDAEusaudxm3qqeqk1mm3NLSqblPhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788638548; c=relaxed/simple;
	bh=vhXWLvacXwpyHQmgyaO/LuDzTK4oSFxW55k11HsC18s=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KzOxIFWi9yJtKkIvOty4TfDa8EHDUdJqWfgABeyZ4oA3t1UHwbypwnIwtbZw55DdAfIEOdZBUp9a7Ey4LseGOlxs1leTazocvzh0h6BN4j488kHlydjZ/57rGZpVy9t99RFHuyMecfnVZkgmgC9+qRTm6VnbGp+74zftt0Sa81s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mxPdcT/Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mxPdcT/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB7AC1F00A3A;
	Sat,  5 Sep 2026 20:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788638546;
	bh=jrBxM1Xi/jaTWSDWTw3qxm+ACf9Q/ym6vaxSweyVH/Y=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=mxPdcT/QWgjrgNrZt/gNZVrzqI9WG/j1QB0o41h31LEIry/oHDDqRDbsRNWgnn5az
	 JMAPDcTXTquu2e4O0pyD+vGS+tb4p0sqtVaRkvZE3jEiI5zWj3hJyAtACubUV/1h7c
	 WLZawmPZswfbFe4gVEmanxOFCsmbfuMA63A9nIQovWUQ/97OK+9GqLj0TEpE6cmHFh
	 tLExwL6chKnhONkvhCoInL41jT0MzcyxGnThQOYwUml47ZKwhxWZfD2fFDsdYJKXBW
	 UxbX8Es2xwUZcqg/CySKuvoMEKbTcjNKr5oGQCPyAV92VM4E8YjdpeOjHbLQ9t1Bu1
	 a2lxXpBENGXIA==
Subject:
 Re: [PATCH net-next v4 3/4] net: mana: support concurrent HWC requests
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
Date: Sat, 05 Sep 2026 20:02:24 +0000
Message-ID: <178863854444.219967.8113748215248370324@kernel.org>
In-Reply-To: <20260901200018.3194525-4-longli@microsoft.com>
References: <20260901200018.3194525-4-longli@microsoft.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 12 potential
issue(s) to consider:

Critical: 0 · High: 0 (2) · Medium: 7 · Low: 5

- [Medium] mana_hwc_send_request() no longer releases the message slot
  when the wait budget is zero (the deleted `if (wait_ms == 0) goto…
- [Medium] mana_hwc_destroy_channel() is silently reordered so that
  mana_hwc_destroy_cq() runs before mana_hwc_destroy_wq(txq)/(rxq), and…
- [Medium] The new gc->hwc_lock contract documented in
  include/net/mana/gdma.h enumerates the readers of gc->hwc.driver_data…
- [Medium] mana_hwc_get_msg_index() returns -ETIMEDOUT whenever
  down_timeout() on hwc->sema expires, i.e. also for plain slot…
- [Medium] mana_hwc_create_channel() publishes gc->hwc.driver_data (now
  under gc->hwc_lock, with a comment claiming 'the lock orders the hwc…
- [Medium] The new `cancelled` short-circuit in mana_hwc_send_request()
  returns ctx->error directly via `goto out`, bypassing the…
- [Medium] The patch newly reads/writes hwc->hwc_timeout under
  gc->hwc_lock in mana_need_log() and mana_serv_reset(), implying the…
- [Low] Commit message / code mismatch on two points.
- [Low] The commit message presents late-response slot reuse as becoming
  unsafe only once more than one slot is in use ('With more than one…
- [Low] The patch fixes a user-visible defect — a timed-out HWC command
  released its slot while the device could still answer, so a later…
- [Low] The lifetime scheme for hw_channel_context is hand-rolled from
  three cooperating pieces spread across two files and two structs:…
- [Low] Three comments added by this patch contradict the code.

Pre-existing issues:
- [High] mana_hwc_destroy_cq() frees callback-reachable state before the
  EQ that drives the callback is deregistered: it does…
- [High] mana_hwc_destroy_channel() frees the HWC queue and message DMA
  buffers even when DESTROY_HWC failed.

--

net: mana: support concurrent HWC requests

This patch prepares the MANA hardware channel for more than one in-flight
request: a per-queue lock around WQE posting, a bounded wait for a message
slot, a channel_up flag plus an active-sender count so teardown can drain
senders before freeing the channel, and retention of a slot whose request
timed out while the device may still answer.

Two notes on the changelog itself before the diff.

[Severity: Low]

> With more than one slot in use, a timed-out command also stops being
> harmless to retire.

Is this accurate at the current depth?  With HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH
every command uses slot 0, and before this patch a timed-out command released
slot 0 while the device could still answer.

mana_hwc_handle_resp() correlates a response purely by msg_id:

	if (!test_bit(msg_id, hwc->inflight_msg_res.map)) { ... }
	ctx = hwc->caller_ctx + msg_id;
	...
	memcpy(ctx->output_buf, resp_msg, resp_len);

So command A's late response could be copied into command B's buffer and
complete B, already at depth 1.

Does the change that keeps the response-side reference (ctx->responded = true;
abandoned = true; in mana_hwc_send_request()) therefore fix an already
reachable wrong-command completion, rather than only a hazard created by the
later depth increase?

[Severity: Low]

Related to the above: the retained response-side reference corrects a
user-visible defect (a later command reusing a slot id could be completed with
the previous command's payload and status), but the trailers carry no Fixes:
tag.  Would

  Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")

be appropriate here?

> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> index a023d3e1a95de..9e7efce669ae0 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> @@ -162,6 +162,8 @@ static int mana_gd_init_registers(struct pci_dev *pdev)
>  bool mana_need_log(struct gdma_context *gc, int err)
>  {
>  	struct hw_channel_context *hwc;
> +	bool need_log = true;
> +	unsigned long flags;
>  
>  	if (err != -ETIMEDOUT)
>  		return true;
> @@ -169,11 +171,13 @@ bool mana_need_log(struct gdma_context *gc, int err)
>  	if (!gc)
>  		return true;
>  
> +	spin_lock_irqsave(&gc->hwc_lock, flags);
>  	hwc = gc->hwc.driver_data;
>  	if (hwc && hwc->hwc_timeout == 0)
> -		return false;
> +		need_log = false;
> +	spin_unlock_irqrestore(&gc->hwc_lock, flags);
>  
> -	return true;
> +	return need_log;
>  }

[ ... ]

> @@ -393,9 +397,27 @@ static int mana_gd_detect_devices(struct pci_dev *pdev)
>  int mana_gd_send_request(struct gdma_context *gc, u32 req_len, const void *req,
>  			 u32 resp_len, void *resp)
>  {
> -	struct hw_channel_context *hwc = gc->hwc.driver_data;
> +	struct hw_channel_context *hwc;
> +	unsigned long flags;
> +	int err;
> +
> +	spin_lock_irqsave(&gc->hwc_lock, flags);
> +	hwc = gc->hwc.driver_data;
> +	if (!hwc) {
> +		spin_unlock_irqrestore(&gc->hwc_lock, flags);
> +		return -ENODEV;
> +	}
> +	hwc->active_senders++;
> +	spin_unlock_irqrestore(&gc->hwc_lock, flags);
> +
> +	err = mana_hwc_send_request(hwc, req_len, req, resp_len, resp);
>  
> -	return mana_hwc_send_request(hwc, req_len, req, resp_len, resp);
> +	spin_lock_irqsave(&gc->hwc_lock, flags);
> +	if (--hwc->active_senders == 0)
> +		wake_up(&gc->hwc_drain_waitq);
> +	spin_unlock_irqrestore(&gc->hwc_lock, flags);
> +
> +	return err;
>  }
>  EXPORT_SYMBOL_NS(mana_gd_send_request, "NET_MANA");

[Severity: Low]

This isn't a bug, but the hw_channel_context lifetime is now hand-rolled
from three pieces spread over two files and two structs:

  - gc->hwc_lock, initialised in mana_gd_probe()
  - hwc->active_senders, a field of the hw_channel.c-owned object but
    incremented and decremented here in gdma_main.c
  - gc->hwc_drain_waitq, a gdma_context-lifetime field that
    mana_hwc_create_channel() re-initialises on every channel creation

Would a kref on the channel, or an rwsem/percpu_ref taken by senders and
write-acquired by mana_hwc_destroy_channel(), express the same intent with one
primitive and keep the accounting inside hw_channel.c?

> @@ -716,6 +738,7 @@ static void mana_serv_reset(struct pci_dev *pdev)
>  {
>  	struct gdma_context *gc = pci_get_drvdata(pdev);
>  	struct hw_channel_context *hwc;
> +	unsigned long flags;
>  	int ret;
>  
>  	if (!gc) {
> @@ -725,14 +748,17 @@ static void mana_serv_reset(struct pci_dev *pdev)
>  		return;
>  	}
>  
> +	spin_lock_irqsave(&gc->hwc_lock, flags);
>  	hwc = gc->hwc.driver_data;
>  	if (!hwc) {
> +		spin_unlock_irqrestore(&gc->hwc_lock, flags);
>  		dev_err(&pdev->dev, "MANA service: no HWC\n");
>  		goto out;
>  	}
>  
>  	/* HWC is not responding in this case, so don't wait */
>  	hwc->hwc_timeout = 0;
> +	spin_unlock_irqrestore(&gc->hwc_lock, flags);

[Severity: Medium]

What does gc->hwc_lock protect for hwc->hwc_timeout here and in
mana_need_log()?  Every other access to that field is unlocked:

  mana_hwc_send_request()      if (hwc->hwc_timeout > 1)
                                       hwc->hwc_timeout = 1;
  mana_hwc_get_msg_index()     down_timeout(&hwc->sema,
                                       msecs_to_jiffies(hwc->hwc_timeout))
  mana_hwc_init_event_handler() case HWC_DATA_CFG_HWC_TIMEOUT:
                                       hwc->hwc_timeout = val;

The last one runs from hard IRQ.  So the lockset intersection over all
accesses is empty.

Can this interleaving lose the zero sentinel?

CPU A (sender, just timed out)        CPU B (mana_serv_reset)
------------------------------        ------------------------------
reads hwc->hwc_timeout (30000)
                                      spin_lock_irqsave(&gc->hwc_lock)
                                      hwc->hwc_timeout = 0;
                                      spin_unlock_irqrestore(...)
hwc->hwc_timeout = 1;

Every following teardown command then waits 1 ms instead of 0 and
mana_need_log() starts returning true again, which is the log spam the zero
sentinel exists to suppress.  Should the writers take the same lock, or should
the field simply use READ_ONCE()/WRITE_ONCE()?

> @@ -1339,6 +1365,16 @@ static int mana_gd_create_dma_region(struct gdma_dev *gd,
>  	if (gmi->nr_pages == 0 && !MANA_PAGE_ALIGNED(gmi->virt_addr))
>  		return -EINVAL;
>  
> +	/* No RCU needed: this runs only on the data-path queue-creation
> +	 * path (mana_gd_create_mana_eq/mana_gd_create_mana_wq_cq, called
> +	 * by mana_en under RTNL and by mana_ib RDMA verbs, or during
> +	 * init).  Every teardown path — mana_gd_remove, mana_gd_suspend,
> +	 * and the HWC reset/service path (which goes through
> +	 * mana_gd_suspend) — drains those consumers via mana_rdma_remove()
> +	 * + mana_remove() before mana_hwc_destroy_channel() clears
> +	 * gc->hwc.driver_data, so no concurrent destroy can race with
> +	 * this dereference.
> +	 */
>  	hwc = gc->hwc.driver_data;
>  	req_msg_size = struct_size(req, page_addr_list, num_page);
>  	if (req_msg_size > hwc->max_req_msg_size)
> @@ -1544,7 +1580,17 @@ int mana_gd_verify_vf_version(struct pci_dev *pdev)
>  	struct hw_channel_context *hwc;
>  	int err;
>  
> +	/* No RCU needed: this runs only inside mana_gd_setup, on the
> +	 * probe and resume paths.  The PCI/PM core holds device_lock
> +	 * across .probe/.resume and .remove/.suspend, so setup cannot
> +	 * overlap teardown of the same device.  The HWC reset/service
> +	 * path is additionally serialized by GC_IN_SERVICE and runs
> +	 * suspend (destroy) then resume (this) sequentially in one work
> +	 * item.  driver_data was just set by mana_hwc_create_channel
> +	 * earlier in this same setup call, so it is live here.
> +	 */
>  	hwc = gc->hwc.driver_data;
> +

[Severity: Medium]

The new contract on gc->hwc_lock in include/net/mana/gdma.h enumerates the
readers of gc->hwc.driver_data as mana_gd_send_request(), mana_need_log() and
mana_serv_reset().  Are there not three more readers that dereference the same
pointer with neither the lock nor an active_senders reference, and with no NULL
check?

	mana_gd_create_dma_region()
		hwc = gc->hwc.driver_data;
		if (req_msg_size > hwc->max_req_msg_size)

	mana_gd_verify_vf_version()
		hwc = gc->hwc.driver_data;
		err = mana_gd_query_hwc_timeout(pdev, &hwc->hwc_timeout);

	mana_ib_gd_create_dma_region() in drivers/infiniband/hw/mana/main.c
		hwc = gc->hwc.driver_data;
		request_buf = kzalloc(hwc->max_req_msg_size, GFP_KERNEL);

mana_hwc_destroy_channel() now also clears driver_data at the very start of
teardown instead of after kfree(hwc), so for these readers the stale-pointer
window becomes a NULL pointer for the whole teardown, including the
mana_smc_teardown_hwc() polling.  The mana_ib reader is not mentioned in the
new contract at all.

Should the enumerated list be corrected, or the invariant actually enforced at
these sites?  The driver's own comment in mana_hwc_destroy_queues() notes that
the PM device_lock and the GC_IN_SERVICE service path "do not exclude each
other", which makes the "no concurrent destroy can race with this
dereference" claim above hard to verify.

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index 0056bdd8c53f5..91fcf7c092113 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> @@ -6,7 +6,11 @@
>  #include <net/mana/hw_channel.h>
>  #include <linux/vmalloc.h>
>  
> -/* Acquire a free inflight message slot, waiting for one if all are in use. */
> +/* Acquire a free message slot from the inflight bitmap, waiting for one if
> + * all are in use.  Returns -ENODEV if the channel is being torn down, or
> + * -ETIMEDOUT if a prior HWC command has timed out (preserving the error
> + * code callers expect).
> + */
>  static int mana_hwc_get_msg_index(struct hw_channel_context *hwc, u16 *msg_id)
>  {
>  	struct gdma_resource *r = &hwc->inflight_msg_res;
> @@ -14,12 +18,32 @@ static int mana_hwc_get_msg_index(struct hw_channel_context *hwc, u16 *msg_id)
>  	unsigned long flags;
>  	u32 index;
>  
> -	down(&hwc->sema);
> +	/* Bounded wait for a slot.  A timed-out request keeps its slot until
> +	 * the device answers for it, so the semaphore is never posted back
> +	 * for that slot and a caller expires here rather than blocking on a
> +	 * release that is not coming.  Teardown reclaims those slots, which
> +	 * posts the semaphore and releases anyone waiting below.
> +	 */
> +	if (down_timeout(&hwc->sema, msecs_to_jiffies(hwc->hwc_timeout)))
> +		return -ETIMEDOUT;

[Severity: Medium]

This returns -ETIMEDOUT for any expiry of the semaphore wait, including plain
slot contention on a healthy channel.  The changelog says:

> Slots held this way are counted, so a channel that is merely busy can be
> told from one where nothing will ever free a slot again.

Where is that counted?  struct hw_channel_context gains channel_up,
active_senders and the per-slot resp_pending, and this function inspects no
request state before choosing the errno, so busy and dead produce the same
return value.

In-tree consumers treat -ETIMEDOUT as a faulty device:

	mana_gf_stats_work_handler()
		if (err == -ETIMEDOUT) {
			ac->hwc_timeout_occurred = true;
			memset(&ac->hc_stats, 0, sizeof(ac->hc_stats));
			...
			mana_schedule_serv_work(gc, GDMA_EQE_HWC_RESET_REQUEST);

	mana_gd_probe()
		if (err == -ETIMEDOUT || err == -EPROTO) { ... schedule
		    delayed recovery work ... }

Can contention on a live channel therefore trigger a full reset cycle or a PCI
rescan?  The changelog cites mlx5 as precedent, and mlx5 returns -EBUSY for
this case rather than a timeout errno.

[ ... ]

> @@ -101,6 +126,7 @@ static void mana_hwc_handle_resp(struct hw_channel_context *hwc, u32 resp_len,
>  {
>  	const struct gdma_resp_hdr *resp_msg = rx_req->buf_va;
>  	struct hwc_caller_ctx *ctx;
> +	bool release;
>  	int err;
>  
>  	if (!test_bit(msg_id, hwc->inflight_msg_res.map)) {
> @@ -113,15 +139,32 @@ static void mana_hwc_handle_resp(struct hw_channel_context *hwc, u32 resp_len,
>  
>  	spin_lock(&ctx->lock);
>  
> -	/* Honour a response only while the sender owns the slot (output_buf
> -	 * published) and has not already been answered; otherwise drop it as
> -	 * premature, stale or duplicate without touching the refcount.
> +	/* The sender has not published its buffer yet, so nothing asked for
> +	 * this response.  Keep the slot reserved and drop the message.
>  	 */
> -	if (!ctx->output_buf || ctx->responded) {
> +	if (!ctx->output_buf && !ctx->responded) {
>  		spin_unlock(&ctx->lock);
>  		mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
>  		return;
>  	}

[ ... ]

> @@ -593,6 +637,7 @@ static int mana_hwc_create_wq(struct hw_channel_context *hwc,
>  	hwc_wq->gdma_wq = queue;
>  	hwc_wq->queue_depth = q_depth;
>  	hwc_wq->hwc_cq = hwc_cq;
> +	spin_lock_init(&hwc_wq->lock);
>  
>  	err = mana_hwc_alloc_dma_buf(hwc, q_depth, max_msg_size,
>  				     &hwc_wq->msg_buf);
> @@ -610,7 +655,7 @@ static int mana_hwc_create_wq(struct hw_channel_context *hwc,
>  	return err;
>  }
>  
> -static int mana_hwc_post_tx_wqe(const struct hwc_wq *hwc_txq,
> +static int mana_hwc_post_tx_wqe(struct hwc_wq *hwc_txq,
>  				struct hwc_work_request *req,
>  				u32 dest_virt_rq_id, u32 dest_virt_rcq_id,
>  				bool dest_pf)
> @@ -649,7 +694,11 @@ static int mana_hwc_post_tx_wqe(const struct hwc_wq *hwc_txq,
>  	req->wqe_req.inline_oob_data = tx_oob;
>  	req->wqe_req.client_data_unit = 0;
>  
> +	/* Serialize WQE posting — multiple senders may call concurrently. */
> +	spin_lock(&hwc_txq->lock);
>  	err = mana_gd_post_and_ring(hwc_txq->gdma_wq, &req->wqe_req, NULL);
> +	spin_unlock(&hwc_txq->lock);
> +
>  	if (err)
>  		dev_err(dev, "Failed to post WQE on HWC SQ: %d\n", err);
>  	return err;

[Severity: Low]

The changelog says:

> - Add a per-queue lock to hwc_wq; mana_gd_post_and_ring() is not safe
>   to call concurrently on the same queue.

mana_hwc_create_wq() runs spin_lock_init(&hwc_wq->lock) for both the RQ and
the SQ, but only mana_hwc_post_tx_wqe() takes it.  mana_hwc_post_rx_wqe()
still takes a const struct hwc_wq * and posts unlocked:

	static int mana_hwc_post_rx_wqe(const struct hwc_wq *hwc_rxq, ...)
		err = mana_gd_post_and_ring(hwc_rxq->gdma_wq, &req->wqe_req, NULL);

So hwc->rxq->lock is initialised and never used.  Is the RQ meant to be
covered, or should the description say the SQ only?

Also, the comment added on gdma_context::hwc_drain_waitq speaks of "the last
sender's atomic_dec", but active_senders is a plain unsigned int updated under
gc->hwc_lock (if (--hwc->active_senders == 0) wake_up(...)), and
hw_channel.h documents the same field as "Protected by gc->hwc_lock".

[ ... ]

> @@ -817,6 +899,15 @@ int mana_hwc_create_channel(struct gdma_context *gc)
>  	gd->pdid = INVALID_PDID;
>  	gd->doorbell = INVALID_DOORBELL;
>  
> +	/* Publish driver_data last, under hwc_lock: the lock orders the hwc
> +	 * initialisation above before the pointer becomes visible and
> +	 * serialises the publish against the control-plane readers in
> +	 * mana_gd_send_request(), mana_need_log() and mana_serv_reset().
> +	 */
> +	spin_lock_irqsave(&gc->hwc_lock, flags);
> +	gc->hwc.driver_data = hwc;
> +	spin_unlock_irqrestore(&gc->hwc_lock, flags);
> +
>  	/* mana_hwc_init_queues() only creates the required data structures,
>  	 * and doesn't touch the HWC device.
>  	 */

[Severity: Medium]

Is "publish driver_data last" accurate here?  The state a sender touches first
is initialised after this store:

	spin_lock_irqsave(&gc->hwc_lock, flags);
	gc->hwc.driver_data = hwc;		/* visible now */
	spin_unlock_irqrestore(&gc->hwc_lock, flags);
	...
	err = mana_hwc_init_queues(hwc, HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH, ...)
		-> mana_hwc_init_inflight_msg()
			sema_init(&hwc->sema, num_msg);
			mana_gd_alloc_res_map(num_msg, &hwc->inflight_msg_res);

hwc comes from kzalloc, so in that window hwc->sema has count 0 with
wait_list = {NULL, NULL} and inflight_msg_res.{map,size,lock} are all zero.

Can the new channel_up gate reject a sender in that window?  It is only
evaluated after the blocking wait:

	if (down_timeout(&hwc->sema, msecs_to_jiffies(hwc->hwc_timeout)))
		return -ETIMEDOUT;

	spin_lock_irqsave(&r->lock, flags);

	if (!hwc->channel_up) {

With count 0, down_timeout() enters ___down_common() and does
list_add_tail(&waiter.list, &sem->wait_list) on a NULL-linked list head, and
mana_gd_send_request() has already taken a sender reference on the strength of
a non-NULL pointer alone.

The publish-before-init predates the patch (the baseline had gd->driver_data =
hwc at the top of the same function), so this is not newly introduced, but
should the publish move after mana_hwc_init_queues(), given the comment now
claims the ordering?

> @@ -851,11 +942,120 @@ int mana_hwc_create_channel(struct gdma_context *gc)
>  
>  void mana_hwc_destroy_channel(struct gdma_context *gc)
>  {
> +	/* This is the only destroy entry point.  driver_data is read
> +	 * plainly here (teardown is serialised against other teardown);
> +	 * it is cleared under hwc_lock below before hwc is freed.
> +	 */
>  	struct hw_channel_context *hwc = gc->hwc.driver_data;
> +	unsigned long flags;
>  
>  	if (!hwc)
>  		return;
>  
> +	/* Prevent new requests from starting.  Clear channel_up under the
> +	 * bitmap lock so get_msg_index() cannot acquire a slot and increment
> +	 * active_senders after this point.  Senders already waiting on the
> +	 * semaphore are released by the force-completion loop below, which
> +	 * returns every in-flight slot -- including the ones a timed-out
> +	 * request was holding; each released waiter sees the flag clear and
> +	 * posts its permit straight back, so they drain in turn.
> +	 *
> +	 * Gate on the bitmap rather than on channel_up: reading the flag
> +	 * unlocked and only then taking the lock would let a concurrent
> +	 * setup publish it in between and leave the channel up.  A zero
> +	 * num_inflight_msg means mana_gd_alloc_res_map() never ran, so the
> +	 * lock is not initialised yet -- and no sender can exist either.
> +	 */
> +	if (hwc->num_inflight_msg) {
> +		spin_lock_irqsave(&hwc->inflight_msg_res.lock, flags);
> +		hwc->channel_up = false;
> +		spin_unlock_irqrestore(&hwc->inflight_msg_res.lock, flags);
> +	}
> +
> +	/* Clear the pointer under hwc_lock so new callers in
> +	 * mana_gd_send_request() see NULL and return -ENODEV.  The lock
> +	 * makes the readers' "load driver_data + active_senders++"
> +	 * atomic against this store, so once it returns no new sender can
> +	 * take a reference; the active_senders drain below waits out those
> +	 * that already did, before their hwc is freed.
> +	 */
> +	spin_lock_irqsave(&gc->hwc_lock, flags);
> +	gc->hwc.driver_data = NULL;
> +	spin_unlock_irqrestore(&gc->hwc_lock, flags);

[ ... ]

> @@ -871,14 +1071,36 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
>  	}
>  	gc->max_num_cqs = 0;
>  
> +	/* Destroy the HWC CQ object before the TXQ and RQ.  The
> +	 * active_senders drain above already guarantees no sender is
> +	 * still reaching the CQ through txq->hwc_cq.
> +	 */
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
> +	/* Safety net: the force-complete loop above dropped the
> +	 * response-side reference of every occupied slot and the sender
> +	 * drain released the matching sender references, so nothing should
> +	 * still be set here.  Release anything that is, rather than leak it.
> +	 */
> +	if (hwc->caller_ctx) {
> +		struct hwc_caller_ctx *ctx;
> +		int i;
> +
> +		for (i = 0; i < hwc->num_inflight_msg; i++) {
> +			if (!test_bit(i, hwc->inflight_msg_res.map))
> +				continue;
> +
> +			ctx = &hwc->caller_ctx[i];
> +			hwc_ctx_put(hwc, ctx);
> +		}
> +	}

[Severity: Medium]

The CQ destruction is hoisted above the TXQ and RXQ destruction, and the
changelog does not mention it.  Is this a fix for a pre-existing
use-after-free?  Destroying the CQ is what deregisters the HWC EQ:

  mana_hwc_destroy_cq() -> mana_gd_destroy_queue(eq) -> mana_gd_destroy_eq()
    -> mana_gd_deregister_irq() -> list_del_rcu() + synchronize_rcu()

In the old order a live interrupt could reach
mana_hwc_handle_resp() -> mana_hwc_post_rx_wqe(hwc->rxq, ...) and dereference
hwc->caller_ctx after both had been freed by mana_hwc_destroy_wq() and
kfree(hwc->caller_ctx).  Should this carry its own patch and a Fixes: tag so
it can be backported on its own?

Separately, the appended "safety net" loop says by its own comment that
nothing should still be set.  If a bit is still set there, the refcount model
has been violated; would a WARN_ON be better than silently putting the
reference?

[Severity: High]

This isn't a bug introduced by this patch, but the helper called here frees
callback-reachable state before the EQ that drives the callback is
deregistered:

	static void mana_hwc_destroy_cq(struct gdma_context *gc, struct hwc_cq *hwc_cq)
	{
		kfree(hwc_cq->comp_buf);

		if (hwc_cq->gdma_cq)
			mana_gd_destroy_queue(gc, hwc_cq->gdma_cq);

		if (hwc_cq->gdma_eq)
			mana_gd_destroy_queue(gc, hwc_cq->gdma_eq);

Only the last call reaches mana_gd_deregister_irq() with its list_del_rcu() +
synchronize_rcu(), and the HWC IRQ is released later still, in
mana_gd_remove_irqs() after mana_hwc_destroy_channel() returns.  Can a
concurrent interrupt therefore use freed memory?

CPU A (destroy)                       CPU B (mana_gd_intr)
------------------------------        ------------------------------
kfree(hwc_cq->comp_buf)
mana_gd_destroy_queue(gdma_cq)
  (frees DMA ring + struct)
                                      mana_hwc_comp_event(ctx, q_self)
                                        completions = hwc_cq->comp_buf;
                                        mana_gd_poll_cq(q_self, completions,
                                                        queue_depth);
mana_gd_destroy_queue(gdma_eq)
  synchronize_rcu()                     /* writes into freed comp_buf */

The comment added above states the teardown deliberately tolerates a live
interrupt still delivering a response, so does this ordering need fixing for
that reasoning to hold?

[Severity: High]

This is also a pre-existing issue rather than something this patch
introduces, but the queue and message DMA buffers are freed here even when
DESTROY_HWC failed just above:

	if (hwc->setup_active) {
		if (!mana_smc_teardown_hwc(&gc->shm_channel, false))
			hwc->setup_active = false;
		else
			dev_err(hwc->dev, "Failed to tear down HWC\n");
	}
	gc->max_num_cqs = 0;

	if (hwc->cq)
		mana_hwc_destroy_cq(...);
	if (hwc->txq)
		mana_hwc_destroy_wq(hwc, hwc->txq);
	if (hwc->rxq)
		mana_hwc_destroy_wq(hwc, hwc->rxq);

mana_smc_teardown_hwc() explains why waiting matters:

	/* Read shmem response (polling for VF possession) and validate.
	 * For teardown, waiting for response is required to ensure hardware
	 * invalidates MST entries before software frees memory.
	 */

On failure setup_active is deliberately left set, meaning the PF may still be
using the queues, yet the coherent EQ/CQ/SQ/RQ rings and message buffers go
back to the DMA allocator.  Can the device keep DMAing into memory that has
been reassigned?  Since this series is what introduced the setup_active
bookkeeping, would it make sense to skip the frees (and leak) when that
teardown fails?

[ ... ]

> @@ -955,7 +1178,25 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
>  	/* The response-side reference (from get_msg_index) keeps the slot
>  	 * alive if hardware responds right after the doorbell.
>  	 */
> -	err = mana_hwc_post_tx_wqe(txq, tx_wr, dest_vrq, dest_vrcq, false);
> +	/* Submit under the slot lock, so mana_hwc_destroy_channel() cannot
> +	 * cancel this request between the check and the doorbell: it takes
> +	 * the same lock, so it either cancels before this runs -- and the
> +	 * request is never handed to the device -- or after, when the
> +	 * request is genuinely in flight.  Posting is a WQE write plus a
> +	 * doorbell, so it does not sleep.
> +	 */
> +	spin_lock_irqsave(&ctx->lock, flags);
> +	cancelled = ctx->responded;
> +	if (cancelled)
> +		err = ctx->error;
> +	else
> +		err = mana_hwc_post_tx_wqe(txq, tx_wr, dest_vrq, dest_vrcq,
> +					   false);
> +	spin_unlock_irqrestore(&ctx->lock, flags);
> +
> +	if (cancelled)
> +		goto out;
> +
>  	if (err) {
>  		dev_err(hwc->dev, "HWC: Failed to post send WQE: %d\n", err);
>  		goto out;

[Severity: Medium]

Can this path return success for a command that was never posted?

mana_hwc_handle_resp() accepts a response as soon as output_buf is published,
which happens before the doorbell:

	if (!ctx->output_buf && !ctx->responded) {
		...drop...
	}
	...
	ctx->responded = true;
	...
	ctx->status_code = resp_msg->status;
	memcpy(ctx->output_buf, resp_msg, resp_len);
	ctx->error = err;			/* 0 on a well-formed message */

So a response arriving in that window (a device duplicate for a previously
reused slot, or, in a confidential VM, a host-supplied hwc_msg_id the driver
already treats as untrusted) leaves ctx->responded == true and
ctx->error == 0.  The new block then takes cancelled = true, err = 0, skips
mana_hwc_post_tx_wqe() and does goto out, which falls into done: return err.

The check_status: block is the only place the device status is validated:

	check_status:
		if (err)
			goto done;

		if (status && status != GDMA_STATUS_MORE_ENTRIES) { ... err = -EPROTO; }

Before this patch the same injected response still reached check_status:.
Should the cancelled path fall through to check_status:, or refuse to report
success when the request was never handed to the device?

The out: comment also states "Only reached before the request reached the
hardware, so no response can ever arrive for it", which the cancelled path
reaches after a response has already been applied.

> @@ -972,9 +1213,23 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
>  		ctx->output_buf = NULL;
>  		err = ctx->error;
>  		status = ctx->status_code;
> +		if (err == -EINPROGRESS) {
> +			/* Give up on this request in the same critical section
> +			 * that clears output_buf, so a response can never
> +			 * observe the slot as "sender has not published yet"
> +			 * and be discarded as premature -- that would strand
> +			 * the slot, because only a response frees it.
> +			 *
> +			 * Keep the response-side reference: the device may
> +			 * still answer, so the slot stays taken until it does
> +			 * and must not be handed to another request.
> +			 */
> +			ctx->responded = true;
> +			abandoned = true;
> +		}
>  		spin_unlock_irqrestore(&ctx->lock, flags);
>  
> -		if (err != -EINPROGRESS) {
> +		if (!abandoned) {
>  			/* A response raced in just after the timeout, so the
>  			 * hardware is alive: keep the channel and report what
>  			 * that response said rather than a timeout.  It may
> @@ -986,29 +1241,25 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
>  			goto check_status;
>  		}
>  
> -		if (wait_ms != 0)
> +		if (wait_ms != 0) {
>  			dev_err(hwc->dev, "Command 0x%x timed out: %u ms\n",
>  				command, wait_ms);
>  
> -		err = -ETIMEDOUT;
> -
> -		/* No-wait teardown (hwc_timeout == 0) is expected to expire;
> -		 * just release the slot so the next teardown command can reuse
> -		 * it.
> -		 */
> -		if (wait_ms == 0)
> -			goto out;
> +			/* Genuine timeout: shorten later waits so subsequent
> +			 * commands fail fast instead of each draining the
> +			 * full timeout.
> +			 */
> +			if (hwc->hwc_timeout > 1)
> +				hwc->hwc_timeout = 1;
> +		}
>  
> -		/* Genuine timeout: shorten later waits so subsequent commands
> -		 * fail fast instead of each draining the full timeout.
> -		 */
> -		if (hwc->hwc_timeout > 1)
> -			hwc->hwc_timeout = 1;
> +		err = -ETIMEDOUT;
>  
> -		/* Release the slot via out:; a late response no longer touches
> -		 * it, so the sender must drop the reference here.
> +		/* Drop only the sender's reference; the response-side one is
> +		 * what keeps the slot reserved.
>  		 */
> -		goto out;
> +		hwc_ctx_put(hwc, ctx);
> +		goto done;
>  	}

[Severity: Medium]

The wait_ms == 0 fast path that released the slot is dropped here.  Does that
strand the channel on the no-wait teardown path?

mana_serv_reset() sets hwc->hwc_timeout = 0 before the suspend sequence, so
the first command expires immediately in
wait_for_completion_timeout(&ctx->comp_event, 0), takes the abandoned branch,
and keeps its bitmap bit and its semaphore permit for good.

Every later command then fails before a WQE is built, because
mana_hwc_get_msg_index() does:

	if (down_timeout(&hwc->sema, msecs_to_jiffies(hwc->hwc_timeout)))
		return -ETIMEDOUT;

and ___down_common() has:

	if (unlikely(timeout <= 0))
		goto timed_out;

At the bootstrap depth used by this patch that is exactly one teardown command
reaching the device; the remaining ones (disable vport, destroy WQ/CQ objects,
destroy DMA regions) are dropped, and mana_need_log() returns false while
hwc_timeout == 0, so nothing is logged either.  The changelog only justifies
retaining slots for requests that "reached the hardware" and does not discuss
removing this deliberate no-wait release.

> diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
> index 308950f9b54b0..f97f63f8fee41 100644
> --- a/include/net/mana/gdma.h
> +++ b/include/net/mana/gdma.h
> @@ -468,6 +468,21 @@ struct gdma_context {
>  	/* Hardware communication channel (HWC) */
>  	struct gdma_dev		hwc;
>  
> +	/* destroy_channel() waits here for all HWC senders to exit.
> +	 * Lives on gc (not hwc) so wake_up() after the last sender's
> +	 * atomic_dec doesn't dereference freed hwc memory.
> +	 */
> +	wait_queue_head_t	hwc_drain_waitq;

[Severity: Low]

Three comments added by this patch look inconsistent with the code.

There is no atomic_dec: active_senders is a plain unsigned int and
mana_gd_send_request() does

	if (--hwc->active_senders == 0)
		wake_up(&gc->hwc_drain_waitq);

under gc->hwc_lock, which is also what hw_channel.h documents.

In mana_hwc_destroy_channel(), "A zero num_inflight_msg means
mana_gd_alloc_res_map() never ran, so the lock is not initialised yet" reads
inverted.  mana_hwc_init_queues() calls mana_hwc_init_inflight_msg() first,
which runs sema_init() and mana_gd_alloc_res_map() (bitmap_zalloc() +
spin_lock_init()), and only assigns hwc->num_inflight_msg = q_depth after the
CQ and WQ creations succeed.  So a failure in mana_hwc_create_cq() or
mana_hwc_create_wq() leaves num_inflight_msg == 0 with the lock initialised
and the bitmap allocated.

Finally, the new kerneldoc on mana_hwc_get_msg_index() lists only -ENODEV and
-ETIMEDOUT, while the WARN_ON_ONCE(index >= r->size) branch added in the same
hunk returns -EIO.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260901200018.3194525-1-longli%40microsoft.com
