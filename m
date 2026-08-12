Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B3D494832;
	Wed, 12 Aug 2026 23:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786578425; cv=none; b=OZd9E2sjqV316u55IkSOfEVI7yiE94uLfNamoe2fVr9ULjJBy7QeBMnpO5Yb+3oUStsnlNXKYk3ays0fUIMY+TUkLle6/t4RJRkOw1PP4pKN2W5xUECwlcKb4VKCekle8OIN4xSPG/KHh8ZCRXBa7P2LpsHjSQyRz1s+omLGVDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786578425; c=relaxed/simple;
	bh=6DIiyJDyRU+kgzMknfZ1amk87JKfx0/vTvWfnlTUr4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JVoxJw4XioYHOzQyGyzb5FIIO9ONuM940cVsgX8bNY+MeQkmg6yxp2yCSL+pJ3jdmOKYOnwWoSjtnuOFs0uMvsvWq8dc4PUNRNej5fYNxoFLw4rSYcOtCZan8ckgSJ/2tuYGdK7VAvu0xXCxsF1h8ZP64rUH5xzQfKAzGF+NNN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ic3aABFQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ic3aABFQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538151F000E9;
	Wed, 12 Aug 2026 23:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786578420;
	bh=nbBBH9J/nBZyRqh9C5ICJbucII3oxxiwEKexP5U99MY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ic3aABFQdHuk+wmwQnf3A/ShalvanWwkbhgrgiqvUiOrW1uOnA5f70jHF2nVPnl5J
	 1b5AE7y1gvkbxOAVGRdVgZhkxTn0KR+BUH21LYJNLua8YXYPpOfKLXBjztEGuvHPqW
	 /zInqdFUx/AsGKFDyho2hWGLFOArj6Zw1igam660qis4JY/AL2/eaBV13fuhp3jwDm
	 vz11fIZMh7kf0WcHSuONy2JAokwb5XqkWEb2nx73g/3E8ui9XM3W3ybIPatDHd8Aao
	 hBHX2poHarz+HhSi0TvVhvcTqkIjklUYyULpsPQvfvAz356BxjTCzgcIuYt2nKqyAB
	 izOCn1LvJxxag==
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
Subject: Re: [PATCH net v6 6/7] net: mana: fix stale HWC response after command timeout
Date: Wed, 12 Aug 2026 16:46:59 -0700
Message-ID: <20260812234659.2193596-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260811023823.2391255-7-longli@microsoft.com>
References: <20260811023823.2391255-7-longli@microsoft.com>
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

This adds a per-slot spinlock, a refcount and an -EINPROGRESS sentinel to
struct hwc_caller_ctx so a late HWC response cannot memcpy() into a
returned sender's buffer or complete a recycled msg_id.  The counting
semaphore guarding slot admission is replaced with a waitqueue plus the
inflight bitmap, and a new hwc_timed_out latch rejects further slot
requests after a genuine command timeout.

A few questions below about the new ownership rules, the latch, and the
matching comments/changelog text.

> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> index d40f25a1a74a7..d4c7426750016 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> @@ -310,7 +310,12 @@ static int mana_gd_query_hwc_timeout(struct pci_dev *pdev, u32 *timeout_val)
>  	if (err || resp.hdr.status)
>  		return err ? err : -EPROTO;
>  
> -	*timeout_val = resp.timeout_ms;
> +	/* A zero timeout would make every HWC command time out immediately
> +	 * and latch the channel (see the HWC_DATA_CFG_HWC_TIMEOUT handler).
> +	 * Ignore a zero from the device and keep the caller's positive value.
> +	 */
> +	if (resp.timeout_ms)
> +		*timeout_val = resp.timeout_ms;
>  
>  	return 0;
>  }

[Severity: Medium]
The changelog justifies this hunk and the HWC_DATA_CFG_HWC_TIMEOUT hunk
with:

  "Because the timeout latch keys off wait_for_completion_timeout()
  returning immediately, a zero hwc_timeout would time out every command
  at once and latch the whole channel."

Can a zero hwc_timeout actually reach the latch?  In
mana_hwc_send_request() the zero case is exempted before hwc_timed_out is
written:

	if (wait_ms == 0)
		goto out;
	...
	WRITE_ONCE(hwc->hwc_timed_out, true);

and the new admission gate plus the wait_event() condition in
mana_hwc_get_msg_index() also skip the latch when hwc_timeout == 0.  The
comment added to mana_hwc_init_event_handler() repeats the same rationale
("A zero timeout would make every command time out immediately and latch
hwc_timed_out, disabling the channel").

The effect of a device-reported zero looks different: every command turns
into a fire-and-forget post returning -ETIMEDOUT with an unfilled response
buffer.

Could the stated reason for silently overriding a firmware-supplied
timeout be restated to match what the code does?

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index 959886434d07f..759b65040a159 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> @@ -7,25 +7,77 @@
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
> +		/* Reject new admissions once the channel has latched a genuine
> +		 * timeout -- but not for a deliberate no-wait teardown, where
> +		 * mana_serv_reset() sets hwc_timeout = 0 to best-effort post
> +		 * the teardown commands.  Without this exception an earlier
> +		 * timeout would block those teardown commands here before the
> +		 * hwc_timeout == 0 path in mana_hwc_send_request() can run.
> +		 */
> +		if (hwc->hwc_timed_out && hwc->hwc_timeout != 0) {
> +			spin_unlock_irqrestore(&r->lock, flags);
> +			return -ETIMEDOUT;
> +		}

[Severity: Medium]
This gate is a two-variable predicate, but only hwc_timed_out is written
under r->lock.  hwc_timeout is written with plain stores and no lock by:

  mana_hwc_init_event_handler()   /* HWC_DATA_CFG_HWC_TIMEOUT, EQ interrupt */
  mana_hwc_rx_leak_wqe()          /* hwc->hwc_timeout = 1, EQ interrupt */
  mana_hwc_send_request()         /* if (hwc->hwc_timeout > 1) ... = 1, outside
                                     inflight_msg_res.lock */
  mana_serv_reset()               /* hwc->hwc_timeout = 0 */
  mana_hwc_destroy_channel()      /* hwc->hwc_timeout = 0 */

None of them takes inflight_msg_res.lock and none uses WRITE_ONCE() to
pair with the new READ_ONCE() readers, so the two halves of the gate are
never updated together.

Can that give these outcomes?

  - mana_serv_reset() sets hwc_timeout = 0 precisely so the remaining
    teardown commands bypass the latch; an interrupt-context store of a
    non-zero hwc_timeout (reconfig event or mana_hwc_rx_leak_wqe()) makes
    the gate true again and every remaining teardown command is rejected
    with -ETIMEDOUT.

  - A teardown sender that passed this gate with hwc_timeout == 0 then
    reads wait_ms = hwc->hwc_timeout locklessly; if the interrupt store
    lands in between it takes the genuine-timeout branch and latches
    hwc_timed_out for the whole channel.

>  
> -	index = find_first_zero_bit(hwc->inflight_msg_res.map,
> -				    hwc->inflight_msg_res.size);
> +		index = find_first_zero_bit(r->map, r->size);
> +		if (index < r->size) {
> +			struct hwc_caller_ctx *ctx;
> +
> +			ctx = &hwc->caller_ctx[index];
> +			reinit_completion(&ctx->comp_event);
> +			/* Initialise the slot before publishing its inflight
> +			 * bit below.  The response-side reference is taken
> +			 * here, under r->lock, so a stale or duplicate response
> +			 * that lands before mana_hwc_send_request() posts the
> +			 * request cannot drop the refcount to zero and free the
> +			 * slot under the sender.  One reference is the sender's;
> +			 * the other is released by mana_hwc_handle_resp().
> +			 */
> +			refcount_set(&ctx->refcnt, 2);
> +			ctx->responded = false;
> +			ctx->msg_id = index;
> +			ctx->error = -EINPROGRESS;
> +			/* Publish the slot last.  mana_hwc_handle_resp() honours
> +			 * a response only after the sender sets ctx->output_buf
> +			 * (under ctx->lock, after this function returns), so the
> +			 * initialisation above is always visible before any
> +			 * response is acted on.
> +			 */
> +			bitmap_set(r->map, index, 1);
> +			spin_unlock_irqrestore(&r->lock, flags);
> +			break;
> +		}
> +		spin_unlock_irqrestore(&r->lock, flags);
>  
> -	bitmap_set(hwc->inflight_msg_res.map, index, 1);
> +		wait_event(hwc->msg_waitq,
> +			   (READ_ONCE(hwc->hwc_timed_out) &&
> +			    READ_ONCE(hwc->hwc_timeout) != 0) ||
> +			   !bitmap_full(r->map, r->size));

[Severity: Medium]
hwc_timeout is now part of this wait predicate, but is anything waking
msg_waitq when hwc_timeout changes?

The only wakeups added are mana_hwc_put_msg_index() and the wake_up_all()
that follows the latch in mana_hwc_send_request().

A sender that sleeps here while hwc_timed_out is already set and
hwc_timeout == 0 (the mana_serv_reset() window) has a false exit
condition.  When hwc_timeout later becomes non-zero, from
mana_hwc_init_event_handler() or mana_hwc_rx_leak_wqe(), the predicate
becomes true but no wake_up() is issued, so the task stays in
TASK_UNINTERRUPTIBLE sleep until some slot happens to be freed.

mana_hwc_destroy_channel() also sets hwc->hwc_timeout = 0 and tears
everything down without waking msg_waitq.

>  
> -	spin_unlock_irqrestore(&r->lock, flags);
> +		/* Same no-wait teardown exception as the entry gate above:
> +		 * when hwc_timeout == 0 do not bail on the latch, wait for a
> +		 * slot to free so the best-effort teardown command can still
> +		 * be posted instead of spinning here.
> +		 */
> +		if (READ_ONCE(hwc->hwc_timed_out) &&
> +		    READ_ONCE(hwc->hwc_timeout) != 0)
> +			return -ETIMEDOUT;
> +	}
>  
>  	*msg_id = index;
> -
>  	return 0;
>  }
>  
> @@ -35,10 +87,17 @@ static void mana_hwc_put_msg_index(struct hw_channel_context *hwc, u16 msg_id)
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
> @@ -116,22 +175,41 @@ static void mana_hwc_handle_resp(struct hw_channel_context *hwc, u32 resp_len,
>  		resp_len = 0;
>  	}
>  
> -	err = mana_hwc_verify_resp_msg(ctx, resp_msg, resp_len);
> -	if (err)
> -		goto out;
> -
> -	ctx->status_code = resp_msg->status;
> +	spin_lock(&ctx->lock);
> +
> +	/* Honour a response only while the sender is actively waiting on
> +	 * this slot -- that is, it has published ctx->output_buf and not yet
> +	 * reclaimed it.  A NULL output_buf means the sender has not posted
> +	 * its request yet (so this is a premature, stale or forged response
> +	 * that must not complete the slot and let it be freed while the real
> +	 * request is still in flight) or it already timed out and took
> +	 * ownership back.  ctx->responded drops a second, duplicate response.
> +	 * In all these cases drop the response without touching the refcount
> +	 * or the completion; the genuine response, the sender or the teardown
> +	 * path still balances the references.
> +	 */
> +	if (!ctx->output_buf || ctx->responded) {
> +		spin_unlock(&ctx->lock);
> +		mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
> +		return;
> +	}
> +	ctx->responded = true;

[Severity: High]
This is a pre-existing issue and not introduced by this patch (the
baseline also freed the slot on timeout and correlated responses purely by
hwc_msg_id), but the changelog says the misdelivery case is now closed.
Is it?

Responses are still matched only by the reusable msg_id.
mana_hwc_verify_resp_msg() checks lengths only, and this gate accepts any
response whose slot has output_buf published and responded == false; no
activity_id or msg_type is compared against the posted request.

With q_depth == HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH == 1:

sender A: mana_hwc_post_tx_wqe() posts the command, wait_ms == 0 expires,
          "if (wait_ms == 0) goto out;" NULLs output_buf, drops both
          references, mana_hwc_put_msg_index() clears bit 0
sender B: mana_hwc_get_msg_index() hands back index 0 again,
          refcount_set(&ctx->refcnt, 2), ctx->responded = false,
          reinit_completion(), then publishes its own output_buf
device:   late response for A's command arrives with msg_id 0
          mana_hwc_handle_resp() sees output_buf != NULL and !responded,
          memcpy()s into B's buffer, stores status_code, complete()

Two further variants of the same correlation gap:

ctx->output_buf is published before the request is copied, tagged with
req_msg->req.hwc_msg_id and posted, so a duplicate or delayed response
landing in that window is accepted and completes the slot before the
hardware has seen the command.

The earlier test_bit(msg_id, hwc->inflight_msg_res.map) check in
mana_hwc_handle_resp() is done without ctx->lock, so the slot can be
released by the old sender and re-armed by a new one between that test and
this spin_lock(&ctx->lock).

>  
> -	memcpy(ctx->output_buf, resp_msg, resp_len);
> -out:
> +	err = mana_hwc_verify_resp_msg(ctx, resp_msg, resp_len);
> +	if (!err) {
> +		ctx->status_code = resp_msg->status;
> +		memcpy(ctx->output_buf, resp_msg, resp_len);
> +	}
>  	ctx->error = err;
>  
> -	/* Must post rx wqe before complete(), otherwise the next rx may
> -	 * hit no_wqe error.
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
> @@ -218,7 +296,12 @@ static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
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
>  
>  		case HWC_DATA_HW_LINK_CONNECT:

[ ... ]

> @@ -1041,8 +1135,11 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
>  	}
>  
>  	ctx = hwc->caller_ctx + msg_id;
> +
> +	spin_lock_irqsave(&ctx->lock, flags);
>  	ctx->output_buf = resp;
>  	ctx->output_buflen = resp_len;
> +	spin_unlock_irqrestore(&ctx->lock, flags);
>  
>  	req_msg = (struct gdma_req_hdr *)tx_wr->buf_va;
>  	if (req)
> @@ -1058,43 +1155,134 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
>  		dest_vrcq = hwc->pf_dest_vrcq_id;
>  	}
>  
> +	/* handle_resp()'s reference was taken in mana_hwc_get_msg_index(),
> +	 * so hardware responding immediately after the doorbell ring cannot
> +	 * release the slot before this sender is done with it.
> +	 */
>  	err = mana_hwc_post_tx_wqe(txq, tx_wr, dest_vrq, dest_vrcq, false);
>  	if (err) {
>  		dev_err(hwc->dev, "HWC: Failed to post send WQE: %d\n", err);
>  		goto out;
>  	}
>  
> +	wait_ms = hwc->hwc_timeout;
>  	if (!wait_for_completion_timeout(&ctx->comp_event,
> -					 (msecs_to_jiffies(hwc->hwc_timeout)))) {
> -		if (hwc->hwc_timeout != 0)
> +					 msecs_to_jiffies(wait_ms))) {
> +		if (wait_ms != 0)
>  			dev_err(hwc->dev, "Command 0x%x timed out: %u ms\n",
> -				command, hwc->hwc_timeout);
> +				command, wait_ms);
> +
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
> +		err = -ETIMEDOUT;
> +
> +		/* A deliberate no-wait send -- mana_serv_reset() sets
> +		 * hwc_timeout = 0 when the HWC is already unresponsive and it
> +		 * only needs to best-effort post the teardown commands -- is
> +		 * expected to expire here.  Do not latch hwc_timed_out for it:
> +		 * that would make mana_hwc_get_msg_index() reject the remaining
> +		 * teardown commands before they are even posted.  Release the
> +		 * slot through the out: path so the next command can reuse it,
> +		 * matching the pre-refcount behaviour where every command was
> +		 * posted and only the wait was skipped.
> +		 */
> +		if (wait_ms == 0)
> +			goto out;

[Severity: Medium]
This isn't a bug introduced by this patch (the baseline released the slot
immediately on timeout too), but does releasing the slot right after the
doorbell also release the TX request buffer while the device may still own
it?

mana_hwc_post_tx_wqe() hands the bus address of
txq->msg_buf->reqs[msg_id].buf_va to the device:

	sge->address = (u64)req->buf_sge_addr;
	...
	err = mana_gd_post_and_ring(hwc_txq->gdma_wq, &req->wqe_req, NULL);

and mana_hwc_tx_event_handler() is WARN-only, so there is no per-WQE SQ
completion tracking; the buffer is only known to be consumed when the
response arrives.  On this path (and after a genuine timeout once
mana_serv_reset() sets hwc_timeout = 0) the next command takes the same
msg_id and memcpy()s a new request over that buffer, so firmware can
DMA-read a mixture of two requests.

The changelog's invariant, "a msg_id whose response is still outstanding
is never handed to a new request", does not seem to cover this TX-buffer
ownership aspect.

>  
> -		/* Reduce further waiting if HWC no response */
> +		/* Genuine timeout: no response arrived.  Reduce further
> +		 * waiting, and mark the channel timed out under the bitmap
> +		 * lock so get_msg_index() cannot acquire new slots after this.
> +		 */
>  		if (hwc->hwc_timeout > 1)
>  			hwc->hwc_timeout = 1;
>  
> -		err = -ETIMEDOUT;
> +		spin_lock_irqsave(&hwc->inflight_msg_res.lock, flags);
> +		WRITE_ONCE(hwc->hwc_timed_out, true);
> +		spin_unlock_irqrestore(&hwc->inflight_msg_res.lock, flags);
> +		wake_up_all(&hwc->msg_waitq);

[Severity: High]
Is hwc_timed_out ever cleared again?  Grepping the tree it is only ever
written true, so after one command timeout every later
mana_hwc_get_msg_index() returns -ETIMEDOUT and the command is not posted
at all — no TX WQE and no doorbell.

The device-side teardown commands (GDMA_DESTROY_DMA_REGION,
GDMA_DISABLE_QUEUE, GDMA_DEREGISTER_DEVICE, the MANA WQ/RQ-object and
vport destroy commands) all travel over the HWC, and their callers free
the memory regardless of the error:

drivers/net/ethernet/microsoft/mana/gdma_main.c:mana_gd_destroy_queue() {
	...
	mana_gd_destroy_dma_region(gc, gmi->dma_region_handle);
	mana_gd_free_memory(gmi);
	kfree(queue);
}

Can this leave the device with DMA regions, memory keys and queues still
registered in its MST-PTE tables, holding DMA rights over pages just
returned to the page allocator, with no invalidating command even
attempted?

Before this patch the same command was still posted and only the wait was
shortened to 1 ms, so a merely slow or transiently unresponsive device
still processed the teardown.  The one escape from the latch
(hwc_timeout == 0) is set only by mana_serv_reset(), so ordinary
remove/unbind/suspend paths do not get it.

The driver's own setup_active comment in mana_hwc_destroy_channel()
deliberately leaks HWC buffers rather than free memory the device may
still DMA into; should the teardown commands get a similar exemption from
the latch?

> +
> +		/* Release the slot through out:, which also drops the
> +		 * response-side reference taken in mana_hwc_get_msg_index().
> +		 * A late response for this slot cannot drop it -- once the
> +		 * sender NULLs output_buf, mana_hwc_handle_resp() early-returns
> +		 * without touching the refcount -- so the sender must free it
> +		 * here, otherwise the slot bit would leak until channel
> +		 * teardown.
> +		 */
>  		goto out;
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

[ ... ]

>  out:
> -	mana_hwc_put_msg_index(hwc, msg_id);
> +	/* Reached by the pre-post error paths (request never submitted), by
> +	 * the deliberate no-wait teardown, and by a genuine timeout (request
> +	 * posted, but no valid response arrived).  In every case the sender
> +	 * must drop the response-side reference taken in
> +	 * mana_hwc_get_msg_index() and its own.  Guard against a stale or
> +	 * forged response that raced in first: latch ->responded under the
> +	 * lock so any later handle_resp() is a no-op, and drop the response-
> +	 * side reference here only if handle_resp() has not already done so.
> +	 */
> +	ctx = hwc->caller_ctx + msg_id;
> +	spin_lock_irqsave(&ctx->lock, flags);
> +	ctx->output_buf = NULL;
> +	drop_resp_ref = !ctx->responded;
> +	ctx->responded = true;
> +	spin_unlock_irqrestore(&ctx->lock, flags);
> +	if (drop_resp_ref)
> +		refcount_dec(&ctx->refcnt);
> +	hwc_ctx_put(hwc, ctx);
> +done:
>  	return err;
>  }

[Severity: Medium]
The changelog states:

  "The slot is released only when both the sender and handle_resp()
  have dropped their reference, so a msg_id whose response is still
  outstanding is never handed to a new request."

Does the out: path keep that invariant?  Both the no-wait teardown
(wait_ms == 0) and the genuine timeout reach out: with the request already
posted, and out: force-drops the response-side reference itself before
dropping the sender's, so hwc_ctx_put() -> mana_hwc_put_msg_index() clears
the inflight bit while the command is still outstanding.

Reuse of that msg_id is then blocked only by the
"hwc_timed_out && hwc_timeout != 0" gate in mana_hwc_get_msg_index(),
which is deliberately bypassed exactly when hwc_timeout == 0, i.e. the
mana_serv_reset() window.

Two related documentation points:

The mana_hwc_handle_resp() comment says "the genuine response, the sender
or the teardown path still balances the references", but
mana_hwc_destroy_channel() does no refcount handling at all, it just does
kfree(hwc->caller_ctx).

The changelog says a stale or early response "drops only the
response-side reference".  In the code an early response with
output_buf == NULL returns without touching the refcount at all.

> diff --git a/include/net/mana/hw_channel.h b/include/net/mana/hw_channel.h
> index 8340abd36af61..23bf83e2a3ec6 100644
> --- a/include/net/mana/hw_channel.h
> +++ b/include/net/mana/hw_channel.h
> @@ -171,8 +171,25 @@ struct hwc_caller_ctx {
>  	void *output_buf;
>  	u32 output_buflen;
>  
> -	u32 error; /* Linux error code */
> +	int error; /* Linux error code (negative errno or 0) */
>  	u32 status_code;
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

[Severity: Low]
This isn't a bug, but the responded comment says it is "Set under lock by
the first handle_resp() for this slot", while mana_hwc_send_request()'s
out: path sets it too:

	drop_resp_ref = !ctx->responded;
	ctx->responded = true;

on paths where no hardware response was received at all: pre-post
failures where the request was never submitted, the no-wait teardown, and
genuine timeouts.  Should the comment say the flag means "response handled
or response-side reference cancelled"?

>  
>  struct hw_channel_context {

[ ... ]

> @@ -206,6 +224,11 @@ struct hw_channel_context {
>  	 */
>  	u32 rx_leaked_wqe;
>  
> +	/* Set on first HWC timeout.  Causes get_msg_index() to return
> +	 * -ETIMEDOUT instead of waiting, draining all queued senders.
> +	 */
> +	bool hwc_timed_out;
> +

[Severity: Low]
This isn't a bug either, but the comment describes the reject and drain as
unconditional.  The admission gate, the wait_event() condition and the
post-wait recheck in mana_hwc_get_msg_index() all qualify the latch with
hwc_timeout != 0.

With hwc_timeout == 0, the state mana_serv_reset() installs on a live
channel, new senders are still admitted, and senders already parked in
wait_event() are not released by the wake_up_all() that follows the latch:
they re-evaluate the condition, find it false and sleep again waiting for
a free bitmap slot.  The flag is also not set for the wait_ms == 0 expiry.

Could the comment mention that qualification?

>  	/* Set after mana_smc_setup_hwc() succeeds (hardware has active
>  	 * MST entries).  Cleared only after mana_smc_teardown_hwc()
>  	 * succeeds, on both the recoverable establish_channel path and the
