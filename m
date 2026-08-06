Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23D448664C;
	Thu,  6 Aug 2026 17:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786037047; cv=none; b=jfnXz9AHhHc21CyE7emQaMAAfMTKGV5BPsP9c+cJBNbrObmEkHdVKuzE1Rh6qhFhoz3K3VgPpaCyR1saT9xF5DfhpwgxZLHhjdL2iJZg/qlg3XGZyNZo0KVoFLO9xbYHoC7TcmEu29gQFxWKKUse//2JJonUn+9GhaheyHjYMkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786037047; c=relaxed/simple;
	bh=8q8rlRYVs4R8BborX7SZeHUIU+MeOWusgBftVz4oJ30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N9ybAjgFC7LLz7CVhgEOVWySPHGT45JcsszGfFRTn2ZpsnsMCFyUSSlUmaWtAovR/6JIXEpHnhv9rpvdbDQhuF92mMdgh0tK5VrQhTtBqCVfxeCflDtThsJrMpNU79F4n6jTWaYBr1iHb9oCdSWAsqbkEmiNcV+s2nPp/hoyec4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NCYRBl5J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NCYRBl5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EFF21F00A3A;
	Thu,  6 Aug 2026 17:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786037042;
	bh=lhssVueom1f94LhhPSz3iyfZrONCW9T8Dm3jZrxY83U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NCYRBl5JbS5cdh5/fy24kVGfdbqUfBbsx8pplMkrT5/pbviptFv/p0NO8/XYcEgS0
	 5AssZbtAqxTv756vrAeBjoNyJhohV51vHMteSrYZCGpMX2YcCPx+YEBUGL0dkDPz7O
	 Fvyujtr/8S2FShR1aRbjG4Y60k5ZRBxYQbahWpNBClAh5BhWXxg9McEHNktsxibe2F
	 mUIpVEtkecXL1m19qMT4+sKr2WLHVZTb4gNjGTiviwrKcPqa+zYU8bU+H8uofWbiUz
	 fiWOBrdde0VwTb0vCkqkQaHiYLTNA8SRTzPEUhJmV4+bazn5P+TPmuvZ2rw9gWaoLY
	 LT2hP2QXnFIiQ==
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
Subject: Re: [PATCH net v3 4/6] net: mana: validate hardware-supplied values in the HWC RX path
Date: Thu,  6 Aug 2026 10:24:00 -0700
Message-ID: <20260806172400.2945922-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260803234355.636038-5-longli@microsoft.com>
References: <20260803234355.636038-5-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
---
net: mana: validate hardware-supplied values in the HWC RX path

This adds validation of device-supplied lengths and indices in the HWC
receive path: the SGE pointer derived from inline_oob_size_div4 is bounds
checked, the SGE address must match the address posted for the slot, short
responses are rejected before hwc_msg_id is read, and hwc_msg_id and
resp_len are range checked in mana_hwc_handle_resp().  Most validation
early-returns now repost the RX WQE.

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index d701c427fe47b..e378b8ec97c9a 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> @@ -83,6 +83,17 @@ static void mana_hwc_handle_resp(struct hw_channel_context *hwc, u32 resp_len,
>  	struct hwc_caller_ctx *ctx;
>  	int err;
>  
> +	/* Validate msg_id is in range before using it to index bitmap
> +	 * and caller_ctx array.  Malicious firmware could send
> +	 * out-of-range msg_id causing out-of-bounds access.
> +	 */
> +	if (msg_id >= hwc->num_inflight_msg) {
> +		dev_err(hwc->dev, "hwc_rx: msg_id %u >= max %u\n",
> +			msg_id, hwc->num_inflight_msg);
> +		mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
> +		return;
> +	}
> +

[Severity: Low]
Is this branch reachable?  mana_hwc_handle_resp() has a single caller,
mana_hwc_rx_event_handler(), which already rejects the same condition
immediately before the call (unchanged context in the last hunk of this
patch):

	msg_id = READ_ONCE(resp->response.hwc_msg_id);
	if (msg_id >= hwc->num_inflight_msg) {
		dev_err(hwc->dev, "HWC RX: wrong msg_id=%u\n", msg_id);
		return;
	}

	mana_hwc_handle_resp(hwc, rx_oob->tx_oob_data_size, rx_req, msg_id);

msg_id is passed by value, so there is no second read from DMA memory and
the bound tested is the same hwc->num_inflight_msg.

The changelog says mana_hwc_handle_resp() "consumed lengths and indices
taken straight from device DMA without validation" and could "index out of
bounds", and lists "bounds-check hwc_msg_id in mana_hwc_handle_resp()
before indexing the inflight bitmap and caller_ctx" as one of the fixes.

Given the caller's pre-existing check, could hwc->inflight_msg_res.map or
hwc->caller_ctx actually be indexed out of bounds before this patch?  If
not, could the changelog describe this hunk as defence in depth instead,
since the Fixes: tag makes it a backport candidate?

[ ... ]

> @@ -261,19 +284,69 @@ static void mana_hwc_rx_event_handler(void *ctx, u32 gdma_rxq_id,
>  
>  	sge = (struct gdma_sge *)(wqe + 8 + dma_oob->inline_oob_size_div4 * 4);
>  
> -	/* Select the RX work request for virtual address and for reposting. */
> +	/* inline_oob_size_div4 is read from the WQE in device-accessible RQ
> +	 * memory, so a malicious host in a CVM (or buggy firmware) could set
> +	 * it to push the SGE past the RQ buffer.  Bounds-check the SGE it
> +	 * locates before dereferencing sge->address below.  A validly posted
> +	 * WQE keeps the SGE inside the ring (worst case ends exactly at the
> +	 * buffer boundary); reject anything that would read past it.  The
> +	 * slot cannot be trusted here, so leak this RX WQE rather than repost
> +	 * the wrong one -- as in the SGE-address mismatch path below.
> +	 */
> +	if ((u8 *)(sge + 1) > (u8 *)rq->queue_mem_ptr + rq->queue_size) {
> +		dev_err(hwc->dev, "HWC RX: SGE past RQ buffer, oob_div4=%u\n",
> +			dma_oob->inline_oob_size_div4);
> +		return;
> +	}

[Severity: Low]
Does this check assert the invariant the driver actually programs?  For
every HWC RQ WQE, mana_gd_post_work_request() in gdma_main.c forces the
layout:

	if (wq->type == GDMA_RQ) {
		if (client_oob_size != 0)
			return -EINVAL;

		client_oob_size = INLINE_OOB_SMALL_SIZE;

		max_wqe_size = GDMA_MAX_RQE_SIZE;
	}

so inline_oob_size_div4 is always 2 and the SGE always sits at wqe + 16
inside a single 32-byte GDMA_WQE_BU_SIZE WQE.

Since mana_gd_get_wqe_ptr() masks the offset into the ring, a WQE starts at
most at queue_size - 32, so the ring-wide comparison only rejects a
corrupted inline_oob_size_div4 when the completed WQE happens to be the
last BU of the ring.  For every other WQE all eight 3-bit values pass, and
sge->address is then read from somewhere in wqe + 8 ... wqe + 36, i.e. the
client OOB area, the real SGE's mem_key/size words, or the next WQE's
header.

Those bytes are then rejected by the index and address checks below, so the
visible effect is the leaked WQE discussed further down rather than
corruption.  Would checking inline_oob_size_div4 == 2 (or that the SGE lies
within this WQE's own 32-byte BU) be both stricter and cheaper here?

[Severity: Low]
Is the pointer that gets dereferenced provably the pointer that was
checked?  sge is computed from a plain load of dma_oob->inline_oob_size_div4,
and both dma_oob and sge point into the DMA-mapped RQ ring
(rq->queue_mem_ptr), which is shared host memory in a CVM.

The load is neither volatile nor barriered, and the field is already read a
second time for the dev_err() argument, so the compiler may rematerialize
the address computation at the later sge->address dereferences.  If the
host changed the field in between, the dereferenced SGE can sit past
queue_mem_ptr + queue_size, which is what the check was added to prevent.

sge->address is likewise loaded up to three times: for the rx_req_idx
computation, for the equality test, and for the dev_err().

A few lines below, the same function applies the opposite discipline to the
response header with an explicit comment about CVM TOCTOU:

	msg_id = READ_ONCE(resp->response.hwc_msg_id);

Would snapshotting inline_oob_size_div4 and sge->address once with
READ_ONCE() into locals, and checking and using only the locals, make the
two new checks consistent with that?

For the record, the index/address binding itself does look sound: since
mana_hwc_alloc_dma_buf() sets buf_sge_addr[i] == dma_handle +
i * max_resp_msg_size, the equality test can only pass for the slot that
matches the second load, so the double fetch cannot produce a mismatched
index/address pair.

> +
> +	/* Recover the originating RX slot from the SGE address.  Of the three
> +	 * terms here only sge->address lives in device-accessible RQ memory;
> +	 * rq_base_addr and max_resp_msg_size are driver-private constants.  An
> +	 * in-range but wrong/unaligned SGE (corrupted WQE, or a malicious host
> +	 * in a CVM) would otherwise truncate onto a neighbouring slot, letting
> +	 * us read a stale response that could complete the wrong, reused
> +	 * in-flight request.  Require the index to be in range AND the address
> +	 * to exactly match the value the driver posted for that slot.
> +	 */
>  	rq_base_addr = hwc_rxq->msg_buf->mem_info.dma_handle;
>  	rx_req_idx = (sge->address - rq_base_addr) / hwc->max_resp_msg_size;
>  
> -	if (rx_req_idx >= hwc_rxq->msg_buf->num_reqs) {
> -		dev_err(hwc->dev, "HWC RX: wrong rx_req_idx=%llu, num_reqs=%u\n",
> -			rx_req_idx, hwc_rxq->msg_buf->num_reqs);
> +	if (rx_req_idx >= hwc_rxq->queue_depth) {
> +		/* Cannot trust which WQE this is, so we cannot safely repost
> +		 * it; leak one RX WQE and bail.  An out-of-range index means
> +		 * a corrupted SGE from hardware (or host tampering), an
> +		 * unrecoverable device error.
> +		 */
> +		dev_err(hwc->dev, "HWC RX: SGE idx %llu out of range\n",
> +			rx_req_idx);
>  		return;
>  	}
>  
>  	rx_req = &hwc_rxq->msg_buf->reqs[rx_req_idx];
> +	if (sge->address != (u64)rx_req->buf_sge_addr) {
> +		/* In-range index but the address does not match what the
> +		 * driver posted for that slot; the same unrecoverable case,
> +		 * so leak this WQE rather than repost the wrong one.
> +		 */
> +		dev_err(hwc->dev, "HWC RX: invalid SGE address %llx (idx=%llu)\n",
> +			sge->address, rx_req_idx);
> +		return;
> +	}
> +

[Severity: Medium]
Can these two new returns drain the RQ credits to zero?

The comments describe them as leaking "one RX WQE", but nothing bounds how
often they can be taken, and the trigger values
(dma_oob->inline_oob_size_div4, sge->address) live in device-accessible RQ
memory, which the changelog itself treats as host-writable in a CVM.

The HWC WQs are created with spec.monitor_avl_buf = false, and nothing ever
advances rq->tail for HWC queues (queue->tail is only initialised to 0 in
mana_gd_create_hwc_queue(); the only wq->tail += num_units in the driver is
the ethernet path in mana_en.c).  The device's view of posted RQ buffers
therefore follows wq->head, which only advances through
mana_hwc_post_rx_wqe() -> mana_gd_post_and_ring():

	wq->head += wqe_size / GDMA_WQE_BU_SIZE;

So each early return without a repost permanently reduces the posted depth,
while hwc_rxq->queue_depth and msg_buf->num_reqs keep reporting the full
depth.

The out-of-range-index path already behaved this way before the patch; this
adds two more such paths.  After HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH
occurrences the RQ is empty, no HWC response can be received, and every
command times out.  Since the timeout path in mana_hwc_send_request()
latches hwc->hwc_timeout = 1 and there is no HWC re-arm or reset path, is
there any way out of that state?

Would it be reasonable to count the leaked WQEs and signal the device as
unusable (or reset the channel) once the posted depth drops, rather than
silently continuing?

>  	resp = (struct gdma_resp_hdr *)rx_req->buf_va;
>  
> +	/* Validate resp_len covers the response header before reading
> +	 * hwc_msg_id.  A short response leaves stale data from the
> +	 * previous buffer occupant, which could match a live slot and
> +	 * complete the wrong request.
> +	 */
> +	if (rx_oob->tx_oob_data_size < sizeof(*resp)) {
> +		dev_err(hwc->dev, "HWC RX: short resp_len=%u\n",
> +			rx_oob->tx_oob_data_size);
> +		mana_hwc_post_rx_wqe(hwc_rxq, rx_req);
> +		return;
> +	}
> +

[Severity: High]
Does this early return leave the waiting sender uncompleted?

At this point the slot has been positively identified (sge->address was
matched exactly against rx_req->buf_sge_addr), but the function returns
before hwc_msg_id is read, so no hwc_caller_ctx is completed.

Before this patch the same completion reached mana_hwc_handle_resp(), which
applies the identical predicate through mana_hwc_verify_resp_msg():

	if (resp_len < sizeof(*resp_msg))
		return -EPROTO;

and then failed and woke the sender:

	err = mana_hwc_verify_resp_msg(ctx, resp_msg, resp_len);
	if (err)
		goto out;
	...
out:
	ctx->error = err;
	mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
	complete(&ctx->comp_event);

Post-patch the sender instead sits in mana_hwc_send_request() for the whole
hwc->hwc_timeout and then latches the channel:

	if (!wait_for_completion_timeout(&ctx->comp_event,
					 (msecs_to_jiffies(hwc->hwc_timeout)))) {
		...
		/* Reduce further waiting if HWC no response */
		if (hwc->hwc_timeout > 1)
			hwc->hwc_timeout = 1;

		err = -ETIMEDOUT;

hwc_timeout is only assigned at channel creation, by an
HWC_DATA_CFG_HWC_TIMEOUT reconfig event, or to 0 on destroy, so it is never
restored and every later command waits 1 ms.  At the end of this series the
same branch also sets hwc->hwc_timed_out = true, after which
mana_hwc_get_msg_index() fails all future commands with -ETIMEDOUT.

Would it be better to hand the short response to mana_hwc_handle_resp()
(or otherwise complete the identified slot with -EPROTO) so a single
malformed response does not convert into a channel-wide failure?

Also, the comment says a short response "could match a live slot and
complete the wrong request".  Is that accurate for the pre-patch code?
mana_hwc_verify_resp_msg() rejected the length before the memcpy(), so no
stale bytes were copied into a caller buffer; the pre-patch outcome looks
like a spurious -EPROTO on one command.

[ ... ]
