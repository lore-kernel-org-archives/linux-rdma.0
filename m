Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A302488D9C;
	Thu,  6 Aug 2026 17:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786037049; cv=none; b=Xo3GvH/RzKdNhRoymmeErAOu9+HgPB6Jwepbc/VaAoezdY0iA07U1Kd3V3RiDEhwwOMIJLYfQybs5KncfL8W6UWTQBsag0FlR1OUIXdh4PZOzRnLFgk74/A7aC0/5prPg7ZN+pONGI9Eiv2pKQfcquJ+36EFHBl+kZK0rAAphjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786037049; c=relaxed/simple;
	bh=D4qBMxvKEK/UfcZAA+jRLuxQxgKAMuQGz/CQQOl2wV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ASra9QokfIE3kq21Q/RL3KiyMUqw4aQDj6nXasccn6xv1odRP3zTQrnkvOJk4e/Rvi3VsaQdDPrCOm8oYyup1VC3460wNLdB6vmif1Y+e4RPOjn7rcq1pWhKP3DixLdbTkdoAxkcJa29EbNbbRNpPDh2Ub9crSJh63VRlZeIXO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N0grWskL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N0grWskL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A30F1F00A3D;
	Thu,  6 Aug 2026 17:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786037047;
	bh=QFSlFQrz+V1eZbb+2pu7LddrBTLcDKcpVHJTQAGpRNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N0grWskL+D1WjD3jMzzWj0oyOdBJ9LIeoxRrsxzZdHdF0iUZwsBVlo+j9bdeXXN0D
	 DSVOayz/9fsRigpTKJ1REMAohD8fPbpUNcEO1Y8IMKyyCbq5pv8wX61vsO5NjAMDEi
	 +mXjXfw486XPIzXofFcVC+vUW66yq1DxwdhwfhGyXedqwVCvGYzFX1BjhZVKY8rhRB
	 plLrs1NaWtNkBhvHuipQi+Vo50tRt1OKWuNQd916lltYKbKL5wfMJ2KcQCWLQ/QrLJ
	 odPnPf9qjU3tCO2Pzy+X5vM1GGd44oXgqAO5hg+DNPz3v0gNYxVVu4Se/LxlExO6OF
	 MBKvSJjxmMIJA==
From: Jakub Kicinski <kuba@kernel.org>
To: longli@microsoft.com
Cc: Jakub Kicinski <kuba@kernel.org>,
	kotaranov@microsoft.com,
	davem@davemloft.net,
	pabeni@redhat.com,
	edumazet@google.com,
	andrew+netdev@lunn.ch,
	jgg@ziepe.ca,
	leon@kernel.org,
	haiyangz@microsoft.com,
	kys@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	shradhagupta@linux.microsoft.com,
	horms@kernel.org,
	ernis@linux.microsoft.com,
	stephen@networkplumber.org,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v3 6/6] net: mana: fix stale HWC response after command timeout
Date: Thu,  6 Aug 2026 10:24:04 -0700
Message-ID: <20260806172405.2946281-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260803234355.636038-7-longli@microsoft.com>
References: <20260803234355.636038-7-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
---
net: mana: fix stale HWC response after command timeout

This reworks the MANA HWC command slot lifetime so a late response cannot
memcpy into a caller buffer that is already gone, and cannot complete a
different command through a recycled msg_id.  Each caller_ctx gains a
spinlock, a refcount and an -EINPROGRESS sentinel, the semaphore is
replaced by a waitqueue plus the inflight bitmap, and a first timeout
latches a new hwc_timed_out flag.

A few questions about the new slot lifetime and the timeout latch below.

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index 1603968d7989a..d92032b466af2 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> @@ -7,25 +7,49 @@
>  #include <linux/pci.h>
>  #include <linux/vmalloc.h>
>  
> +/* Acquire a free message slot from the inflight bitmap.  Returns
> + * -ETIMEDOUT if a prior HWC command has timed out (preserving the
> + * error code callers expect).
> + */
>  static int mana_hwc_get_msg_index(struct hw_channel_context *hwc, u16 *msg_id)
>  {
>  	struct gdma_resource *r = &hwc->inflight_msg_res;
>  	unsigned long flags;
>  	u32 index;
>  
> -	down(&hwc->sema);
> +	for (;;) {
> +		spin_lock_irqsave(&r->lock, flags);
>  
> -	spin_lock_irqsave(&r->lock, flags);
> +		if (hwc->hwc_timed_out) {
> +			spin_unlock_irqrestore(&r->lock, flags);
> +			return -ETIMEDOUT;
> +		}
>  
> -	index = find_first_zero_bit(hwc->inflight_msg_res.map,
> -				    hwc->inflight_msg_res.size);
> +		index = find_first_zero_bit(r->map, r->size);
> +		if (index < r->size) {
> +			struct hwc_caller_ctx *ctx;
> +
> +			bitmap_set(r->map, index, 1);
> +			ctx = &hwc->caller_ctx[index];
> +			reinit_completion(&ctx->comp_event);
> +			refcount_set(&ctx->refcnt, 1);
> +			ctx->responded = false;
> +			ctx->msg_id = index;
> +			ctx->error = -EINPROGRESS;
> +			spin_unlock_irqrestore(&r->lock, flags);
> +			break;
> +		}

[Severity: High]
bitmap_set() publishes the slot to the response path here, while the
response-side reference is only taken much later in
mana_hwc_send_request():

	/* Take handle_resp's ref before posting ... */
	refcount_inc(&ctx->refcnt);

In between, mana_hwc_handle_resp() already accepts the slot.  Its only
gates are the range check and a lockless test_bit():

	if (!test_bit(msg_id, hwc->inflight_msg_res.map)) {
		dev_err(hwc->dev, "hwc_rx: invalid msg_id = %u\n", msg_id);
		mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
		return;
	}

and it ends with an unconditional hwc_ctx_put().  msg_id comes from
host-writable DMA memory (READ_ONCE()d out of the RX buffer), and
responded is false for a fresh allocation, so the new duplicate guard
does not catch a response naming a slot that is still in this pre-post
window.

Can such a response drop refcnt 1->0, clear the bitmap bit and wake
msg_waitq while the sender still owns the slot?  If so, does that give:

  - the sender's refcount_inc() running on 0, i.e. a "refcount_t:
    addition on 0; use-after-free" splat plus permanent saturation,
    leaking that slot for good;

  - another sender being handed the same msg_id, sharing both
    txq->msg_buf->reqs[msg_id] and the same hwc_caller_ctx, so one
    command completes with the other command's payload, which is the
    cross-completion this patch is meant to remove;

  - a spurious complete() letting wait_for_completion_timeout() succeed
    with ctx->error still -EINPROGRESS, so -115 is handed back to
    callers?

The same window also covers the req_len > tx_wr->buf_len path that jumps
to out:, whose new comment states "no WQE was submitted so handle_resp()
cannot race here" and "refcount is 1".  Can the slot already have been
released by then, making that hwc_ctx_put() a second release?

[Severity: Medium]
comp_event, refcnt, responded, msg_id and error are (re)initialised here
under inflight_msg_res.lock only, while mana_hwc_handle_resp() reads and
writes responded and error under ctx->lock only and never takes
inflight_msg_res.lock.  The intersection of the two locksets is empty,
even though the header comment names ctx->lock as the protecting lock.

bitmap_set() runs before these field writes in the same critical section
and handle_resp()'s visibility gate is a lockless test_bit(), so can a CQ
interrupt on another CPU observe the bit, take ctx->lock and interleave
with this initialisation?  It could then see the stale responded == true
from the previous generation and silently drop a real response, or set
responded/error and complete() while they are being reset, after which
its hwc_ctx_put() consumes the new generation's initial reference.

reinit_completion() also writes x->done = 0 without the completion's
wait.lock, while handle_resp() calls complete() under ctx->lock.  Can a
completion be lost or spuriously observed that way?

> +		spin_unlock_irqrestore(&r->lock, flags);
>  
> -	bitmap_set(hwc->inflight_msg_res.map, index, 1);
> +		wait_event(hwc->msg_waitq,
> +			   hwc->hwc_timed_out ||
> +			   !bitmap_full(r->map, r->size));
>  
> -	spin_unlock_irqrestore(&r->lock, flags);
> +		if (hwc->hwc_timed_out)
> +			return -ETIMEDOUT;
> +	}

[Severity: Low]
hwc_timed_out is written under inflight_msg_res.lock in
mana_hwc_send_request(), but read as a plain load both in this
wait_event() condition and in the check right after it.  bitmap_full()
also reads r->map outside r->lock while other CPUs modify the same words
with non-atomic bitmap_set()/bitmap_clear().  Would READ_ONCE()/
WRITE_ONCE() (or evaluating the bitmap under r->lock) be preferable here
to keep KCSAN quiet?

Related: the read-modify-write in the timeout path

	if (hwc->hwc_timeout > 1)
		hwc->hwc_timeout = 1;

is unlocked while mana_hwc_init_event_handler() also writes hwc_timeout
from EQ interrupt context.  That access is not introduced by this patch,
it is in the baseline, but the patch makes the value load-bearing since a
zero or degraded value now latches the whole channel.

>  
>  	*msg_id = index;
> -
>  	return 0;
>  }
>  
> @@ -35,10 +59,17 @@ static void mana_hwc_put_msg_index(struct hw_channel_context *hwc, u16 msg_id)
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&r->lock, flags);
> -	bitmap_clear(hwc->inflight_msg_res.map, msg_id, 1);
> +	bitmap_clear(r->map, msg_id, 1);
>  	spin_unlock_irqrestore(&r->lock, flags);
>  
> -	up(&hwc->sema);
> +	wake_up(&hwc->msg_waitq);
> +}
> +
> +static void hwc_ctx_put(struct hw_channel_context *hwc,
> +			struct hwc_caller_ctx *ctx)
> +{
> +	if (refcount_dec_and_test(&ctx->refcnt))
> +		mana_hwc_put_msg_index(hwc, ctx->msg_id);
>  }
>  
>  static int mana_hwc_verify_resp_msg(const struct hwc_caller_ctx *caller_ctx,
> @@ -114,22 +145,44 @@ static void mana_hwc_handle_resp(struct hw_channel_context *hwc, u32 resp_len,
>  		resp_len = 0;
>  	}
>  
> -	err = mana_hwc_verify_resp_msg(ctx, resp_msg, resp_len);
> -	if (err)
> -		goto out;
> +	spin_lock(&ctx->lock);
>  
> -	ctx->status_code = resp_msg->status;
> +	if (ctx->responded) {
> +		/* A response for this slot was already delivered; this is a
> +		 * duplicate or replayed one.  Drop it so the hwc_ctx_put()
> +		 * a first response performs is not done twice, which would
> +		 * over-release the slot while the sender still owns it.
> +		 */
> +		spin_unlock(&ctx->lock);
> +		mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
> +		return;
> +	}
> +	ctx->responded = true;
>  
> -	memcpy(ctx->output_buf, resp_msg, resp_len);
> -out:
> -	ctx->error = err;
> +	err = mana_hwc_verify_resp_msg(ctx, resp_msg, resp_len);
>  
> -	/* Must post rx wqe before complete(), otherwise the next rx may
> -	 * hit no_wqe error.
> +	if (!err && ctx->output_buf) {
> +		ctx->status_code = resp_msg->status;
> +		memcpy(ctx->output_buf, resp_msg, resp_len);
> +		ctx->error = 0;
> +	} else if (ctx->output_buf) {
> +		/* Only overwrite error if the sender hasn't timed out
> +		 * or been force-completed by destroy.  When output_buf
> +		 * is NULL, a terminal error (-ENODEV or timeout) has
> +		 * already been set — preserve it so the sender doesn't
> +		 * see a spurious success.
> +		 */
> +		ctx->error = err;
> +	}

[Severity: Low]
Is this comment accurate?  It says that when output_buf is NULL "a
terminal error (-ENODEV or timeout) has already been set".

On the timeout path mana_hwc_send_request() only NULLs ctx->output_buf
and assigns its local err; ctx->error keeps the -EINPROGRESS sentinel
written by mana_hwc_get_msg_index().  Grepping
drivers/net/ethernet/microsoft, the only ENODEV in hw_channel.c is inside
this comment.

The comment also mentions senders "force-completed by destroy", but
mana_hwc_destroy_channel() tears down the CQ and WQs and kfree()s
caller_ctx without ever completing ctx->comp_event or writing ctx->error.

Could the comment be reworded to describe what the code actually
guarantees?

> +
> +	/* Post RX WQE before completing — the next response may arrive
> +	 * immediately and needs a posted buffer.
>  	 */
>  	mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
> -
>  	complete(&ctx->comp_event);
> +	spin_unlock(&ctx->lock);
> +
> +	hwc_ctx_put(hwc, ctx);
>  }
>  
>  static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
> @@ -216,7 +269,12 @@ static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
>  
>  		switch (type) {
>  		case HWC_DATA_CFG_HWC_TIMEOUT:
> -			hwc->hwc_timeout = val;
> +			/* A zero timeout would make every command time out
> +			 * immediately and latch hwc_timed_out, disabling the
> +			 * channel.  Ignore it and keep the positive default.
> +			 */
> +			if (val)
> +				hwc->hwc_timeout = val;
>  			break;

[Severity: Medium]
This guard covers the reconfig EQE, but is the other device-supplied
source of the same field covered?  mana_gd_query_hwc_timeout() still
does:

	*timeout_val = resp.timeout_ms;

and mana_gd_verify_vf_version() calls it as
mana_gd_query_hwc_timeout(pdev, &hwc->hwc_timeout), so a device-reported
timeout_ms of 0 reaches hwc->hwc_timeout unfiltered.

With the new code, does the next command then wait msecs_to_jiffies(0),
time out immediately and latch hwc_timed_out, after which every command
fails with -ETIMEDOUT out of mana_hwc_get_msg_index() without being
posted, for the remaining life of the channel?

>  
>  		case HWC_DATA_HW_LINK_CONNECT:
> @@ -708,7 +766,7 @@ static int mana_hwc_init_inflight_msg(struct hw_channel_context *hwc,
>  {
>  	int err;
>  
> -	sema_init(&hwc->sema, num_msg);
> +	init_waitqueue_head(&hwc->msg_waitq);

[Severity: Low]
The commit message says:

  Replace the depth-1 semaphore with a waitqueue + bitmap so a slot held
  past a timeout does not deadlock admission and timed-out waiters can be
  released.

Was the semaphore depth-1?  The removed line is sema_init(&hwc->sema,
num_msg), and mana_hwc_init_queues() calls
mana_hwc_init_inflight_msg(hwc, q_depth), so it admitted up to q_depth
concurrent senders, matching the bitmap size.

The reason a counting semaphore no longer fits looks like the fact that a
bitmap bit can now outlive its sender (held by handle_resp's reference),
which desynchronises the semaphore count from bitmap occupancy.  Could
the message be corrected, given this is a Fixes:-tagged patch headed for
stable?

>  
>  	err = mana_gd_alloc_res_map(num_msg, &hwc->inflight_msg_res);
>  	if (err)

[ ... ]

> @@ -999,13 +1062,17 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
>  	struct hwc_wq *txq = hwc->txq;
>  	struct gdma_req_hdr *req_msg;
>  	struct hwc_caller_ctx *ctx;
> +	unsigned long flags;
>  	u32 dest_vrcq = 0;
>  	u32 dest_vrq = 0;
>  	u32 command;
> +	u32 status;
>  	u16 msg_id;
>  	int err;
>  
> -	mana_hwc_get_msg_index(hwc, &msg_id);
> +	err = mana_hwc_get_msg_index(hwc, &msg_id);
> +	if (err)
> +		return err;
>  
>  	tx_wr = &txq->msg_buf->reqs[msg_id];
>  

[ ... ]

> @@ -1034,8 +1104,14 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
>  		dest_vrcq = hwc->pf_dest_vrcq_id;
>  	}
>  
> +	/* Take handle_resp's ref before posting — hardware can respond
> +	 * immediately after the doorbell ring.
> +	 */
> +	refcount_inc(&ctx->refcnt);
> +
>  	err = mana_hwc_post_tx_wqe(txq, tx_wr, dest_vrq, dest_vrcq, false);
>  	if (err) {
> +		refcount_dec(&ctx->refcnt);
>  		dev_err(hwc->dev, "HWC: Failed to post send WQE: %d\n", err);
>  		goto out;
>  	}
> @@ -1046,31 +1122,86 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
>  			dev_err(hwc->dev, "Command 0x%x timed out: %u ms\n",
>  				command, hwc->hwc_timeout);
>  
> -		/* Reduce further waiting if HWC no response */
> +		/* NULL out output_buf so a late handle_resp() won't write
> +		 * into the caller's buffer after the sender returns, then
> +		 * check whether handle_resp() already delivered a valid
> +		 * response between the timeout firing and this lock
> +		 * acquisition — ctx->error != -EINPROGRESS means it ran.
> +		 */
> +		spin_lock_irqsave(&ctx->lock, flags);
> +		ctx->output_buf = NULL;
> +		err = ctx->error;
> +		status = ctx->status_code;
> +		spin_unlock_irqrestore(&ctx->lock, flags);
> +
> +		if (err != -EINPROGRESS) {
> +			/* handle_resp() delivered a valid response just after
> +			 * the timeout fired.  The hardware is alive, so use
> +			 * the response and leave the channel usable; do not
> +			 * latch hwc_timed_out or degrade hwc_timeout for what
> +			 * turned out to be a transient race.
> +			 */
> +			hwc_ctx_put(hwc, ctx);
> +			goto check_status;
> +		}
> +
> +		/* Genuine timeout: no response arrived.  Reduce further
> +		 * waiting, and mark the channel timed out under the bitmap
> +		 * lock so get_msg_index() cannot acquire new slots after this.
> +		 */
>  		if (hwc->hwc_timeout > 1)
>  			hwc->hwc_timeout = 1;
>  
> +		spin_lock_irqsave(&hwc->inflight_msg_res.lock, flags);
> +		hwc->hwc_timed_out = true;
> +		spin_unlock_irqrestore(&hwc->inflight_msg_res.lock, flags);
> +		wake_up_all(&hwc->msg_waitq);

[Severity: High]
Once hwc_timed_out is set here, is anything expected to clear it?
Grepping drivers/net/ethernet/microsoft and include/net/mana, this is the
only write besides the kzalloc zeroing, so the flag stays set for the
life of the hw_channel_context.

From then on mana_hwc_get_msg_index() bails out before a slot is even
allocated:

	if (hwc->hwc_timed_out) {
		spin_unlock_irqrestore(&r->lock, flags);
		return -ETIMEDOUT;
	}

so mana_hwc_post_tx_wqe() is never reached and no doorbell is rung for
any later command.  Every GDMA control command funnels through
mana_gd_send_request()->mana_hwc_send_request(), including the teardown
commands mana_gd_disable_queue(), mana_gd_destroy_dma_region() and
mana_gd_deregister_device(), all of which treat errors as non-fatal and
then dma_free_coherent() the backing pages anyway.

Before this patch those commands were still built, posted and the
doorbell rung (only the wait was shortened to 1 ms), so the device did
act on destroy and disable requests.  Can this leave the device holding
registered DMA regions that point at freed pages, which is the situation
the comment in mana_hwc_destroy_channel() describes as risking memory
corruption on systems without an IOMMU?

The commit message describes the latch only as:

  On a genuine timeout the channel is marked hwc_timed_out and further
  mana_hwc_get_msg_index() callers fail with -ETIMEDOUT instead of
  reusing a slot whose response may still arrive.

Could it state that the latch is channel-wide, unconditional and never
cleared, given the per-slot refcount already prevents reuse of a msg_id
whose response is outstanding?

[Severity: High]
Is the driver's own zero-timeout mode affected here too?  mana_serv_reset()
in gdma_main.c does:

	/* HWC is not responding in this case, so don't wait */
	hwc->hwc_timeout = 0;

	dev_info(&pdev->dev, "MANA reset cycle start\n");

	mana_gd_suspend(pdev, PMSG_SUSPEND);

and mana_gd_suspend() runs mana_rdma_remove() (which sends
mana_gd_deregister_device()), mana_remove(&gc->mana, true) and
mana_gd_cleanup_device(), all of which issue HWC commands.

For the first of those, wait_for_completion_timeout() with
msecs_to_jiffies(0) returns 0, ctx->error is still -EINPROGRESS, so this
branch runs: hwc->hwc_timeout > 1 is false and hwc_timed_out is set
unconditionally.  Do the remaining teardown commands then abort in
mana_hwc_get_msg_index() without ever reaching the SQ, turning the
intended fire-and-forget teardown into no teardown at all while the
buffers are still freed?

The patch already guards the device-reported value with if (val) for this
exact reason.  Should the in-driver zero assignment be handled as well,
for instance by not latching when hwc_timeout is 0, since mana_need_log()
already treats hwc_timeout == 0 as a legitimate "don't wait, don't log"
state?

>  
>  		err = -ETIMEDOUT;
> -		goto out;
> +		hwc_ctx_put(hwc, ctx);
> +		goto done;
>  	}
>  
> -	if (ctx->error) {
> -		err = ctx->error;
> -		goto out;
> -	}
> +	/* NULL output_buf so a late handle_resp() won't memcpy into
> +	 * the caller's buffer after the sender exits.  Read error and
> +	 * status_code under the same lock — after hwc_ctx_put the slot
> +	 * may be reused and these fields overwritten.
> +	 */
> +	spin_lock_irqsave(&ctx->lock, flags);
> +	ctx->output_buf = NULL;
> +	err = ctx->error;
> +	status = ctx->status_code;
> +	spin_unlock_irqrestore(&ctx->lock, flags);
> +	hwc_ctx_put(hwc, ctx);
> +
> +check_status:
> +	if (err)
> +		goto done;

[ ... ]

> +
> +	err = 0;
> +	goto done;
>  out:
> -	mana_hwc_put_msg_index(hwc, msg_id);
> +	/* Pre-post error paths: no WQE was submitted so handle_resp()
> +	 * cannot race here.  refcount is 1 (no second ref taken).
> +	 */
> +	ctx = hwc->caller_ctx + msg_id;
> +	spin_lock_irqsave(&ctx->lock, flags);
> +	ctx->output_buf = NULL;
> +	spin_unlock_irqrestore(&ctx->lock, flags);
> +	hwc_ctx_put(hwc, ctx);
> +done:
>  	return err;
>  }
> diff --git a/include/net/mana/hw_channel.h b/include/net/mana/hw_channel.h
> index 3d8543acb5cc0..5a55cedf0607a 100644
> --- a/include/net/mana/hw_channel.h
> +++ b/include/net/mana/hw_channel.h
> @@ -173,6 +173,23 @@ struct hwc_caller_ctx {
>  
>  	u32 error; /* Linux error code */
>  	u32 status_code;

[Severity: Low]
error stays declared as u32 while mana_hwc_get_msg_index() now stores
ctx->error = -EINPROGRESS into it, and mana_hwc_send_request() reads it
back into an int and compares it as signed with if (err != -EINPROGRESS).
The decision whether to latch the whole channel therefore depends on an
out-of-range u32 to int conversion rather than on the declared type.

Should the field become int error, matching its own "Linux error code"
comment, or the sentinel be made unsigned-safe?

> +
> +	/* Protects output_buf against concurrent access from
> +	 * handle_resp() (CQ interrupt) and the sender timeout path.
> +	 */
> +	spinlock_t lock;
> +
> +	/* Tracks sender + handle_resp ownership.  The last put
> +	 * (refcount reaches 0) releases the bitmap slot.
> +	 */
> +	refcount_t refcnt;
> +	u16 msg_id;
> +
> +	/* Set under lock by the first handle_resp() for this slot so a
> +	 * duplicate or replayed response is dropped instead of consuming
> +	 * the response-side reference a second time.
> +	 */
> +	bool responded;
>  };
>  
>  struct hw_channel_context {
> @@ -193,13 +210,19 @@ struct hw_channel_context {
>  	u32 hwc_timeout;
>  
> +	/* Set on first HWC timeout.  Causes get_msg_index() to return
> +	 * -ETIMEDOUT instead of waiting, draining all queued senders.
> +	 */
> +	bool hwc_timed_out;
> +

Could this comment also note that the state is never cleared, so it is
terminal for the lifetime of the channel?
