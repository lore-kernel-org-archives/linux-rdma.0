Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF59D39CD03;
	Sat,  5 Sep 2026 20:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788638546; cv=none; b=iaYB4/VrmKlevjqBk/WVK7y8+1wxCNdChhdD65jgOkJ12ctwSknYM2fID9PTCE2fyKo6R1mKhrnsX7lkpI4SGGjhUar8SbSWi0kVWpfVSmECRV/QsEj1tWb/b8ZX2XdJawsdYlkIWGTqAJFTkFMj7v8CZB+4nKKhyE+6a5kGF0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788638546; c=relaxed/simple;
	bh=Eh7j79LltdEhbFXLEOfDa/4ckG1S/BO7yXamAut27gw=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZXbOYNWlhK1o15UpQj2itd49THSSrCZ6w3HjBzdWDgoHMOXBLb5EwSpjAxVrHVXZYfcCJM1J+t2fCfnW1xIkwKMnafOhQpuGdbiN3Ek+ZLSscl62yfGAx9TO57TqRWn9t2Ap4YUnIrzUuuytag+4PM7R4TWKb035DbqXCDH9uE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JWi1FO//; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JWi1FO//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 177E21F00A3D;
	Sat,  5 Sep 2026 20:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788638544;
	bh=tJ3RTnL9cbwl0xGJoQH5aoBhDgNqxELUJRhZqlGjmh4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=JWi1FO//DqXBzCkseKiGqNQPYoSn/IdLnnTu9QeKy0RmmJnx2AU9aMU1/rn2fMotB
	 VMj4U5K4FwLP76WJjlnhQJDushR6Wqr+pQO+49fTypIeuqP0uGcU0FBGkQg0kGhBfm
	 WsaH2nHTHMk7vRlfEZy/x/g2t0pgXzrSYSrKblshcRn6p0aghAyxxP9SKvatu5Zcz+
	 mQ+BXl+sJl2qpF8mCC97rEqq6dhjwUuLg3OszTfS/S9KVZX9ecy6HYpn22MA3yevIP
	 LTvV1umDTP+AwY2xtPae2koimydjxWXvFPsdJqPW5J9Ofu51fKRa8yxXfeEUgTjG+7
	 xgHjlkRH1bt4w==
Subject: Re: [PATCH net-next v4 2/4] net: mana: give each HWC message slot its
 own completion state
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
Date: Sat, 05 Sep 2026 20:02:22 +0000
Message-ID: <178863854264.219967.12861557359369286638@kernel.org>
In-Reply-To: <20260901200018.3194525-3-longli@microsoft.com>
References: <20260901200018.3194525-3-longli@microsoft.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider:

Critical: 0 · High: 0 (2) · Medium: 2 (2) · Low: 0

- [Medium] Undisclosed behavioural changes bundled into a patch whose
  changelog says "No functional change is intended" and never mentions…
- [Medium] The patch adds a guard in mana_gd_query_hwc_timeout()
  (gdma_main.c:343) plus an in-tree comment declaring that a device-…

Pre-existing issues:
- [High] mana_hwc_rx_event_handler()
  (drivers/net/ethernet/microsoft/mana/hw_channel.c:315-318) returns…
- [High] mana_gd_query_hwc_timeout() sanitises only the zero case of the
  device-reported timeout and still accepts any other u32 (`struct…
- [Medium] DISCARDED (fixed later in this series).
- [Medium] DISCARDED (fixed later in this series).

--

net: mana: give each HWC message slot its own completion state

Each HWC message slot gains a per-slot spinlock, a refcount held by the
sender and the response handler, and a responded flag, so the sender's
timeout path and mana_hwc_handle_resp() can own the slot independently.
ctx->error also changes from u32 to int, and mana_gd_query_hwc_timeout()
now ignores a device-reported timeout of zero.

> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> index f92b2d0bf926e..a023d3e1a95de 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> @@ -331,7 +331,13 @@ static int mana_gd_query_hwc_timeout(struct pci_dev *pdev, u32 *timeout_val)
>  	if (err || resp.hdr.status)
>  		return err ? err : -EPROTO;
>  
> -	*timeout_val = resp.timeout_ms;
> +	/* Zero is the driver's own "do not wait, do not log" sentinel, set by
> +	 * mana_serv_reset() when the HWC has stopped responding.  A zero from
> +	 * the device would enter that state instead: ignore it and keep the
> +	 * caller's positive value.
> +	 */
> +	if (resp.timeout_ms)
> +		*timeout_val = resp.timeout_ms;
>  
>  	return 0;
>  }

[Severity: Medium]
The changelog says "No functional change is intended at the current queue
depth of one" and never mentions gdma_main.c, but this hunk changes
behaviour on its own.  The caller is:

  mana_gd_query_hwc_timeout(pdev, &hwc->hwc_timeout);

and hwc_timeout == 0 is the driver's own sentinel:

  mana_need_log():
	if (hwc && hwc->hwc_timeout == 0)
		return false;

So a device answering GDMA_QUERY_HWC_TIMEOUT with 0 previously disabled
all HWC waiting and all HWC logging.  Is this hunk a fix that wants its
own patch and a Fixes: tag rather than being folded into a preparation
patch?

Two further semantic changes in mana_hwc_send_request() are not described
either.  The timeout path now reports a response that raced in after the
wait expired:

		if (err != -EINPROGRESS) {
			hwc_ctx_put(hwc, ctx);
			goto check_status;
		}

which returns that response's status (possibly -EPROTO) instead of
-ETIMEDOUT, and skips the hwc->hwc_timeout = 1 clamp.  And the new
"!ctx->output_buf || ctx->responded" gate in mana_hwc_handle_resp() stops
a response arriving after its sender timed out from being memcpy'd through
a stale ctx->output_buf that usually pointed into a dead stack frame.

Could the changelog spell these out, or could they be split off?

[Severity: Medium]
The new comment states that a device-supplied value of 0 must be rejected
because 0 is reserved for internal driver state.  The other writer of the
same field, fed from the same device-controlled source, is not changed:

  mana_hwc_init_event_handler():
		case HWC_DATA_CFG_HWC_TIMEOUT:
			hwc->hwc_timeout = val;
			break;

Can a GDMA_EQE_HWC_SOC_RECONFIG_DATA event carrying HWC_DATA_CFG_HWC_TIMEOUT
with val == 0 install exactly the state this guard is meant to prevent?
msecs_to_jiffies(0) would make every subsequent command expire at once,
mana_hwc_send_request() would take the new "No-wait teardown
(hwc_timeout == 0) is expected to expire" branch for ordinary commands
(skipping both the error log and the clamp), and mana_need_log() would
suppress the diagnostics.

Should the zero check live where hwc_timeout is assigned, so both ingest
points agree?

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index 75fdccdc8c482..0056bdd8c53f5 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> @@ -19,6 +21,17 @@ static int mana_hwc_get_msg_index(struct hw_channel_context *hwc, u16 *msg_id)
>  	index = find_first_zero_bit(hwc->inflight_msg_res.map,
>  				    hwc->inflight_msg_res.size);
>  
> +	ctx = &hwc->caller_ctx[index];
> +	reinit_completion(&ctx->comp_event);
> +	/* Take both references (sender + handle_resp) before publishing the
> +	 * slot, so an early response cannot free it under the sender.
> +	 */
> +	refcount_set(&ctx->refcnt, 2);
> +	ctx->responded = false;
> +	ctx->msg_id = index;
> +	ctx->error = -EINPROGRESS;
> +
> +	/* Publish the slot last, after it is fully initialised. */
>  	bitmap_set(hwc->inflight_msg_res.map, index, 1);
>  
>  	spin_unlock_irqrestore(&r->lock, flags);
> @@ -40,6 +53,13 @@ static void mana_hwc_put_msg_index(struct hw_channel_context *hwc, u16 msg_id)
>  	up(&hwc->sema);
>  }
>  
> +static void hwc_ctx_put(struct hw_channel_context *hwc,
> +			struct hwc_caller_ctx *ctx)
> +{
> +	if (refcount_dec_and_test(&ctx->refcnt))
> +		mana_hwc_put_msg_index(hwc, ctx->msg_id);
> +}
> +

[ ... ]

> @@ -90,22 +110,35 @@ static void mana_hwc_handle_resp(struct hw_channel_context *hwc, u32 resp_len,
>  	}
>  
>  	ctx = hwc->caller_ctx + msg_id;
> -	err = mana_hwc_verify_resp_msg(ctx, resp_msg, resp_len);
> -	if (err)
> -		goto out;
>  
> -	ctx->status_code = resp_msg->status;
> +	spin_lock(&ctx->lock);
>  
> -	memcpy(ctx->output_buf, resp_msg, resp_len);
> -out:
> +	/* Honour a response only while the sender owns the slot (output_buf
> +	 * published) and has not already been answered; otherwise drop it as
> +	 * premature, stale or duplicate without touching the refcount.
> +	 */
> +	if (!ctx->output_buf || ctx->responded) {
> +		spin_unlock(&ctx->lock);
> +		mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
> +		return;
> +	}
> +	ctx->responded = true;

[Severity: High]
This isn't a bug introduced by this patch, but every drop path in
mana_hwc_handle_resp() now carefully reposts the RX WQE, including the new
premature/stale/duplicate path above and the invalid-bitmap-bit path, while
the caller still has one path that does not:

  mana_hwc_rx_event_handler():
	msg_id = READ_ONCE(resp->response.hwc_msg_id);
	if (msg_id >= hwc->num_inflight_msg) {
		dev_err(hwc->dev, "HWC RX: wrong msg_id=%u\n", msg_id);
		return;
	}

rx_req has already been resolved at that point, and RX WQEs are armed only
once at bring-up:

  mana_hwc_test_channel():
	for (i = 0; i < q_depth; i++) {
		req = &hwc_rxq->msg_buf->reqs[i];
		err = mana_hwc_post_rx_wqe(hwc_rxq, req);

afterwards they are only re-armed from mana_hwc_handle_resp().  Since
msg_id comes from the shared DMA response buffer, can a host writing a
value >= hwc->num_inflight_msg drop the only RQ buffer at the bootstrap
depth of one, leaving every later mana_hwc_send_request() to time out
forever?  The same early return is still there at the end of the series.

>  
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

[Severity: Medium]
This is a pre-existing ordering issue rather than something this patch
introduces, but the patch adds more accesses after complete().
mana_hwc_destroy_channel() frees the work queues before the CQ/EQ:

	if (hwc->txq)
		mana_hwc_destroy_wq(hwc, hwc->txq);

	if (hwc->rxq)
		mana_hwc_destroy_wq(hwc, hwc->rxq);

	if (hwc->cq)
		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);

and only mana_hwc_destroy_cq() reaches mana_gd_deregiser_irq(), whose
list_del_rcu() plus synchronize_rcu() fences off an in-flight EQ handler.
hwc->rxq and hwc->txq are not set to NULL either.

If mana_smc_teardown_hwc() failed and the device still delivers a response
in that window, can mana_hwc_post_rx_wqe(hwc->rxq, rx_req) here touch the
freed hwc_wq and msg_buf?  The hwc_ctx_put(hwc, ctx) added after complete()
also touches ctx->refcnt, ctx->msg_id, hwc->inflight_msg_res and hwc->sema.

For the record, the destroy order is corrected later in this series, where
the CQ is destroyed before the TXQ and RQ after channel_up is cleared and
active_senders drained, so this comment only applies to the intermediate
state at this commit.

[ ... ]

> @@ -902,43 +952,108 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
>  		dest_vrcq = hwc->pf_dest_vrcq_id;
>  	}
>  
> +	/* The response-side reference (from get_msg_index) keeps the slot
> +	 * alive if hardware responds right after the doorbell.
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
> +					 msecs_to_jiffies(wait_ms))) {

[Severity: High]
This problem wasn't introduced by this patch, but the patch hardens the
same assignment against the benign value while leaving the damaging one
unchecked.  resp.timeout_ms is a plain u32 and lands directly in
hwc->hwc_timeout, so wait_ms here is fully device-controlled.

__msecs_to_jiffies() returns MAX_JIFFY_OFFSET for any value whose signed
interpretation is negative, i.e. >= 0x80000000, and
wait_for_completion_timeout() sleeps in TASK_UNINTERRUPTIBLE.

Can a device that reports timeout_ms = 0xffffffff and then stops answering
wedge the calling thread indefinitely, with no way to kill it?  Even
0x7fffffff gives roughly a 24 day wait, and HWC commands are issued from
paths holding rtnl_lock.  The event path in mana_hwc_init_event_handler()
stores up to 0xffffff ms unbounded as well.  Would a clamp against a sane
maximum at both writers be appropriate?  The gap is still present at the
end of the series.

[ ... ]

>  out:
> -	mana_hwc_put_msg_index(hwc, msg_id);
> +	/* Error, no-wait teardown, or timeout: drop the sender's and the
> +	 * response-side references.  Latch ->responded so a racing response
> +	 * is a no-op, and only drop the response-side ref if it has not.
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
This is pre-existing behaviour rather than something the patch introduces,
and the changelog already acknowledges it, but it may be worth spelling out
what happens in this intermediate state.

On a genuine timeout this path drops both references, so
mana_hwc_put_msg_index() clears the bitmap bit and posts the semaphore
while a response for that msg_id may still be in flight.

mana_hwc_get_msg_index() then hands the same index (always 0 at depth one)
to the next command and resets the slot:

	refcount_set(&ctx->refcnt, 2);
	ctx->responded = false;

so the old response passes the gate in mana_hwc_handle_resp():

	if (!ctx->output_buf || ctx->responded) {

Does that mean the stale payload is memcpy'd into the new caller's buffer,
ctx->error set to 0, and complete() waking the new sender, which returns
success carrying another command's response?

The next patch in the series keeps the response-side reference across a
timeout so the slot is never handed out again until the device answers,
which removes this window; the note is only about the state at this commit.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260901200018.3194525-1-longli%40microsoft.com
