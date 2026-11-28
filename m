Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795883993;
	b=fkRxgsI4yajJ3Ge/TWAB0xRwFkVBQfW64O9xZgPMapW+SWAUe3/A+0UOd9Tyb8Z7VXTe
	 7XbPgnGolM9zsZl6C5Oqcr3d8Zuh6R5XiDBMDVtLbVCk8oNIK/FlDyb5X15MqqU3O380r
	 cbUPRkHkC76rWYBD6MowmryIuIkxctKz5HAu3IdrsQB3kgJFbpJHiecVFjeXDs2Gam8p5
	 /NV7trvLQs7buCbT3XOgh3hCLNV/2MwUXH/6xiF8+NC+I13WZ72GyxrA1MCGMshCLCnFp
	 xdPy+FNHjKR9aBXKhPqx9fpRDrOhxymu3fV7LM26XlkF0PwvZlPP3gjLul7+OGnLZ2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795883993;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=qn6LMNicVfMg/B4YWT5Q+Gix1LmHpcsLlWyOcRLrIBI=;
	b=hxeKzqIrMSPqaIyTjApPra2JOkDTedPFq19Q7mrCEJ7roQh3P+nvzllJcJ2kp4LztilR
	 vX3krFvpwApaf7r5ZmnfNZgSkfOyofFrSSHmqZ2eaCRxNj0gYJYl785Ps36UGUtyezHkF
	 VjG6+G8MOH4u/5/Du0niJyf8yIsKAr2xOCXfUqas2pUEEpQ4Tir3juUDRmV3fTXgV0PtC
	 lbuDznudk8lIpsN7NY7eqYPS8TtMd3BSN8vOXMs57ZMmSd9S5/oDjQLYShAdlgH7z6YY9
	 IGPGx2GZr01K/VUkB/iQPdjL0770NOP0apT8MLoe4rZoBaSegFHzo0jzGkS15cmkcsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JsEXwXbB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E410606A32F;
	Sat, 28 Nov 2026 16:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JsEXwXbB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE46D1F00923;
	Sat, 28 Nov 2026 16:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795883993;
	bh=qn6LMNicVfMg/B4YWT5Q+Gix1LmHpcsLlWyOcRLrIBI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=JsEXwXbBTYIWBtRk9X5UKLFCDfwGcx5PN7xCM706nq7cnajrkVUN1j5UAMelr2i6O
	 HQjeKon2SPNuASYQ7S4ulcBzhDcb+HLHwsMNAeUkVZFA6z2mJGDOecMPtNS7sE8+Gi
	 egKm0fZLTzgasTp+nxYwUHhIov81y1dBysG63FqZg6cQcQF001a1AtaOzA8G70QIlW
	 0ZRcvBOJ7GpCSIL68Ifb4x0v2pljMIKpYdYF7O2iQaxxQQjvjswdRu/0lw1a2hFM/F
	 vOwtBXBvOiDTffDVYUoGLjgwYhuJEHb3RSOlTA15Pbtj67Bo4pFuXqkb8C29FkX8na
	 +FUqLpw4HDdMA==
Subject:
 Re: [PATCH net-next v12 4/5] net: mana: support concurrent HWC requests
From: netdev-bot+sashiko@kernel.org
To: weh@linux.microsoft.com
Cc: longli@kernel.org, kotaranov@microsoft.com, kuba@kernel.org,
 davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
 andrew+netdev@lunn.ch, jgg@ziepe.ca, leon@kernel.org, haiyangz@microsoft.com,
 wei.liu@kernel.org, decui@microsoft.com, shradhagupta@linux.microsoft.com,
 horms@kernel.org, ernis@linux.microsoft.com, stephen@networkplumber.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 gargaditya@linux.microsoft.com, kees+treewide@kernel.org, kees@kernel.org,
 mawasthi@linux.microsoft.com, weh@microsoft.com, edumazet@kernel.org,
 shacharr@microsoft.com
Date: Sat, 28 Nov 2026 16:39:51 +0000
Message-ID: <179588399135.3135.15300357859014042755@kernel.org>
In-Reply-To: <hwc-v12.91ec3eff9cb647d5bc5cc932b3c6f60c.4@linux.microsoft.com>
References: <hwc-v12.91ec3eff9cb647d5bc5cc932b3c6f60c.4@linux.microsoft.com>
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

Thank you for your contribution! Sashiko AI review found 4 potential
issue(s) to consider.

Critical: 0 · High: 2 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] After an HWC timeout, RDMA DESTROY_MR, DESTROY_DM and DESTROY_PD
  report success even if the PF never received them, and the callers…
- [High] mana_hwc_check_deadlines() runs before a reply is accepted (at
  the top of mana_hwc_handle_resp(), under r->lock) and before…
- [Medium] When any pending slot in a batch passes its deadline,
  mana_hwc_fail_pending(hwc, HWC_DMA_DRAINED) overwrites ctx->error on…
- [Low] The new comment on mana_need_log() says it suppresses only
  follow-on failures ("Once admission is closed, follow-on request…

--

net: mana: support concurrent HWC requests

This patch replaces the HWC semaphore and per-slot locks with a
submission list. Competing callers are batched behind one SQ doorbell,
and replies are tracked under the inflight map lock. When a posted
command passes a host-side deadline, the channel moves to HWC_TIMED_OUT
and later requests fail without being posted. A new
mana_gd_send_teardown_request() lets RDMA destroy paths report success
in that state.

> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> index 2d495db51d746..0ada3861e259f 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> @@ -142,22 +142,21 @@ int mana_gd_init_registers(struct gdma_context *gc)
>  		return mana_gd_init_vf_regs(gc);
>  }
>  
> -/* Suppress logging when we set timeout to zero */
> +/* Once admission is closed, follow-on request failures are expected. */
>  bool mana_need_log(struct gdma_context *gc, int err)
>  {
>  	struct hw_channel_context *hwc;
> +	unsigned long flags;
> +	bool log;
>  
> -	if (err != -ETIMEDOUT)
> -		return true;
> -
> -	if (!gc)
> +	if (!gc || (err != -ETIMEDOUT && err != -ENODEV))
>  		return true;
>  
> +	spin_lock_irqsave(&gc->hwc_lock, flags);
>  	hwc = gc->hwc.driver_data;
> -	if (hwc && hwc->hwc_timeout == 0)
> -		return false;
> -
> -	return true;
> +	log = hwc && READ_ONCE(hwc->state) == HWC_READY;
> +	spin_unlock_irqrestore(&gc->hwc_lock, flags);
> +	return log;
>  }

[Severity: Low]
Does this also hide the first timeout, the one that triggers the state
change? The comment says only follow-on failures are suppressed.

mana_hwc_check_deadlines() sets HWC_TIMED_OUT before the sender whose
deadline expired returns -ETIMEDOUT. That error then reaches callers
such as mana_gd_disable_queue(), mana_gd_destroy_dma_region(),
mana_gd_deregister_device() or mana_gd_destroy_eq(). By then
mana_need_log() sees a non-READY state, so their dev_err() is skipped.

This patch also removes the "Command 0x%x timed out: %u ms" message
from mana_hwc_send_request(). The only log left is:

    dev_err(hwc->dev, "HWC request %u timed out\n", i);

It prints a slot index rather than the opcode. Before this patch the
first timeout always logged the command. Could the opcode of the command
that timed out still be logged somewhere?

[ ... ]

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index a98e58b83f9c7..cf1b9c75b10e2 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> @@ -6,61 +6,103 @@

[ ... ]

> -static void mana_hwc_put_msg_index(struct hw_channel_context *hwc, u16 msg_id)
> +static void mana_hwc_fail_pending(struct hw_channel_context *hwc, int result)
>  {
>  	struct gdma_resource *r = &hwc->inflight_msg_res;
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&r->lock, flags);
> -	bitmap_clear(hwc->inflight_msg_res.map, msg_id, 1);
> -	spin_unlock_irqrestore(&r->lock, flags);
> +	unsigned int i;
> +
> +	lockdep_assert_held(&r->lock);
> +	for_each_set_bit(i, r->map, r->size) {
> +		struct hwc_caller_ctx *ctx = &hwc->caller_ctx[i];
> +
> +		/* Retirement also invalidates a reply not yet consumed. An
> +		 * ordinary stop has no such guarantee: keep a completed reply.
> +		 */
> +		if (!ctx->sender)
> +			continue;
> +		if (ctx->error != -EINPROGRESS && result != HWC_DMA_DRAINED)
> +			continue;
> +		ctx->error = result;
> +		complete(&ctx->comp_event);
> +	}
> +}

[Severity: Medium]
Can this throw away a reply the PF has already sent?

When result is HWC_DMA_DRAINED, the -EINPROGRESS check is skipped. A
slot whose reply has arrived and been stored (ctx->error == 0 and
ctx->reply set), but not yet consumed by its sender, gets overwritten.
mana_hwc_wait_for_response() then skips the memcpy into resp. The
caller gets -ETIMEDOUT, or 0 for a teardown request even if the PF
returned a failure status.

The commit message only says "Unanswered commands have no effect". An
answered CREATE_DMA_REGION, CREATE_MR or CREATE_PD did take effect on
the PF.

Would its handle be lost, leaving an orphaned PF object while the
caller's error path frees the backing gmi buffer or umem?

At this commit the bootstrap depth is 1, so a batch holds one entry and
this cannot trigger. The next patch in the series, "net: mana: use the
reported HWC queue depth", allows batches larger than one, and this
logic is unchanged at the end of the series.

The sequence would be:

  1. Command A is answered and its reply is stored.
  2. Command B's deadline expires before A's sender takes r->lock again.

[ ... ]

> @@ -86,44 +128,60 @@ static int mana_hwc_post_rx_wqe(const struct hwc_wq *hwc_rxq,

[ ... ]

>  static void mana_hwc_handle_resp(struct hw_channel_context *hwc, u32 resp_len,
>  				 struct hwc_work_request *rx_req, u16 msg_id)
>  {
> -	const struct gdma_resp_hdr *resp_msg = rx_req->buf_va;
> +	struct gdma_resource *r = &hwc->inflight_msg_res;
>  	struct hwc_caller_ctx *ctx;
> -	int err;
>  
> -	if (!test_bit(msg_id, hwc->inflight_msg_res.map)) {
> -		dev_err(hwc->dev, "hwc_rx: invalid msg_id = %u\n", msg_id);
> -		mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
> -		return;
> +	spin_lock(&r->lock);
> +	mana_hwc_check_deadlines(hwc);
> +	if (msg_id >= r->size || !test_bit(msg_id, r->map)) {
> +		dev_err_ratelimited(hwc->dev, "Unexpected HWC response ID %u\n",
> +				    msg_id);
> +		goto repost;
>  	}
>  
> -	ctx = hwc->caller_ctx + msg_id;
> -
> -	spin_lock(&ctx->lock);
> -	if (!ctx->output_buf) {
> -		spin_unlock(&ctx->lock);
> -		mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
> -		return;
> -	}
> +	ctx = &hwc->caller_ctx[msg_id];
> +	if (!ctx->pending)
> +		goto repost;
>  
> -	err = mana_hwc_verify_resp_msg(ctx, resp_msg, resp_len);
> -	if (!err) {
> -		ctx->status_code = resp_msg->status;
> -		memcpy(ctx->output_buf, resp_msg, resp_len);
> +	ctx->pending = false;
> +	if (!ctx->sender) {
> +		__clear_bit(msg_id, r->map);
> +		goto repost;
>  	}
> +	if (ctx->error != -EINPROGRESS)
> +		goto repost;

[Severity: High]
Should mana_hwc_check_deadlines() run before the reply in hand has been
accepted?

The deadline check uses only host jiffies:

    if (time_after_eq(now, ctx->deadline)) {
        WRITE_ONCE(hwc->state, HWC_TIMED_OUT);
        mana_hwc_fail_pending(hwc, HWC_DMA_DRAINED);

The deadline is set from the host doorbell write in
mana_hwc_post_batch(). Suppose the device wrote the reply within its
window, but the host handled it late (EQ interrupt latency, a
descheduled vCPU, steal time). This call then marks the channel timed
out and sets ctx->error. The reply being handled fails the -EINPROGRESS
check above and is reposted.

mana_hwc_wait_for_response() has the same ordering:

    for (;;) {
        remaining = mana_hwc_check_deadlines(hwc);
        if (ctx->error != -EINPROGRESS)
            break;

A waiter woken by wait_for_completion_timeout() at the deadline can
declare a timeout while the CQE is already in the ring but not yet
polled.

In that case the PF never reached its own timeout. By the commit
message's reasoning, it has not drained DMA or invalidated anything, yet
the driver treats the generation as drained.

Would non-teardown callers then get -ETIMEDOUT for commands the PF
executed, for example an answered CREATE_MR whose caller unwinds and
frees the umem? And would every later teardown request return 0 without
being posted, unpinning memory behind live PF objects?

HWC_DATA_CFG_HWC_TIMEOUT lets the PF shorten hwc_timeout for later
batches, so replies landing close to the deadline may not be unusual.

[ ... ]

> @@ -1058,108 +1201,183 @@ static int mana_hwc_response_status(struct hw_channel_context *hwc,

[ ... ]

> +	remaining = mana_hwc_check_deadlines(hwc);
> +	if (hwc->state == HWC_READY)
> +		return remaining;
>  
> -	tx_wr->msg_size = req_len;
> -	command = req_msg->req.msg_type;
> +	sub->err = hwc->state == HWC_TIMED_OUT ? HWC_DMA_DRAINED : -ENODEV;
> +	list_del_init(&sub->entry);
> +	return 0;
> +}

[ ... ]

> +	finish_wait(&hwc->admission_waitq, &wait);
> +	err = sub.err;
> +	if (!err)
> +		err = mana_hwc_wait_for_response(hwc, sub.id, hdr->req.msg_type,
> +						 resp_len, resp);
> +
> +	if (err == HWC_DMA_DRAINED)
> +		return teardown ? 0 : -ETIMEDOUT;
> +	return err;
>  }

[Severity: High]
Can this report a DESTROY_MR, DESTROY_DM or DESTROY_PD as successful
when the PF never received it?

Once mana_hwc_check_deadlines() moves the channel to HWC_TIMED_OUT,
mana_hwc_admit() gives every queued or new submission HWC_DMA_DRAINED
without staging it on the SQ. For teardown requests that turns into 0
here. So mana_ib_gd_destroy_mr(), mana_ib_gd_destroy_dm() and
mana_gd_destroy_pd() report success for a destroy that was never
posted.

The callers then release memory the device can still reach:

drivers/infiniband/hw/mana/mr.c:mana_ib_dereg_mr() {
    ...
	err = mana_ib_gd_destroy_mr(dev, mr->mr_handle);
	if (err)
		return err;

	if (mr->umem)
		ib_umem_release(mr->umem);
    ...
}

drivers/infiniband/hw/mana/mr.c:mana_ib_dealloc_dm() {
    ...
	err = mana_ib_gd_destroy_dm(dev, dm);
	if (err)
		return err;

	kfree(dm);
    ...
}

mana_ib_dealloc_mw() also goes through mana_ib_gd_destroy_mr().

One reachable path starts with any HWC response timeout followed by
reset recovery. For example, mana_gf_stats_work_handler() sees
-ETIMEDOUT and schedules GDMA_EQE_HWC_RESET_REQUEST. Recovery then runs
mana_rdma_remove()->ib_unregister_device()->mana_ib_dereg_mr().

Before this patch a timed-out destroy returned an error and the pages
stayed pinned.

The only justification in the commit message is:

  "On normal response timeout the PF drains old client DMA and
  invalidates outstanding commands."

Even taken as given, that covers in-flight DMA and outstanding commands.
Does it also cover MR, DM or PD objects that were created and
acknowledged earlier, and whose DESTROY was never posted?

The HWC teardown path in this same patch does not seem to rely on such
a guarantee. It keeps the HWC buffers mapped until DESTROY_HWC is
acknowledged. It also still expects late replies after HWC_TIMED_OUT,
through the pending and refill_needed tracking.

Is there a PF specification that could be cited for this? If not,
could teardown requests that were never posted keep returning an error?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/hwc-v12.91ec3eff9cb647d5bc5cc932b3c6f60c.0%40linux.microsoft.com
