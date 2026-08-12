Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E8F432BF9;
	Wed, 12 Aug 2026 23:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786578421; cv=none; b=ttZMkTmINBznjuFn/ghh5gsn/2zChO+AdpELflHc5n82W8nGYSMYBFHDutCFAJX8JHDgiwQ0A+N8JXfZXgUfLyPuubRoVRP00Vq0c4VuZ5F56qqN2P0oX34OH/erEONrgmXTGz2VwB2bLQyPbAPtps1nBPNiQ4f5Audi6ZRETUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786578421; c=relaxed/simple;
	bh=/+JjIYLkP6efivVkjyedQ/nuwMTFCNBB3TkfgcQSIHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ixDrbqb/6c1Mud7j73ZfFKcjeqLZBk9olyY7lH8rwJzrlcR4VInbGKaz6cKiCz+b/INWbEv5xBiGZyH9Kh7ix9DdbX844RhmiLrmSuILWjMVluY66eRtqG/OLoBZmnW3LqDHecdBsna1sJi3o3L2EEIsqO1MSVLQkHLqKjQteCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GS1KK276; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GS1KK276"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877BC1F00A3A;
	Wed, 12 Aug 2026 23:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786578417;
	bh=FzbHuGeTlnuBbeL7pJ5sYoTBM5rdeG1OVzJaskLtw8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GS1KK276l+lp6GWrLtE1Y+iv2A+AVA/3dyoIJLqA8M5ee5e7p4caSnsKR6aml1HMu
	 a3sbmntnDB85UavNS5GxpvOAFZLQna1sSrpnJihl3/0HRGguZNvpD+99gsyXLyPFs6
	 u+/OfS7VvhIUP2+x5GqcJ97iXFDNwUtuCQpTncALSFNLlmizscP4xDN48vOCr7NBV9
	 kjY/RKVN+FNP6E7T7ExWRwI3LSnKNFJeWo1DRO7khZko2GgXRj1dysoVp2DlHSoxwK
	 jDkaqfEh6LC8LdEcEuHzODLW5UzC9oWZFa6WDjqWFTDS1L6WVOClHhLfcdD2HK+B8H
	 TL/tLwCq544wA==
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
Subject: Re: [PATCH net v6 4/7] net: mana: validate hardware-supplied values in the HWC RX path
Date: Wed, 12 Aug 2026 16:46:55 -0700
Message-ID: <20260812234656.2193529-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260811023823.2391255-5-longli@microsoft.com>
References: <20260811023823.2391255-5-longli@microsoft.com>
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

This adds validation of device-supplied values in the HWC RX completion
path: the inline OOB size and the SGE address are snapshotted and checked
before use, the recovered RX slot index is bounds checked and the SGE
address must match the one the driver posted for that slot, and an
oversized response length is rejected.  Untrustworthy completions no
longer repost their RX WQE; those leaks are counted and, once they reach
the RQ depth, the command timeout is shortened.

No Link: tags are present in the commit header.

One question about the changelog before the diff:

[Severity: Medium]

> A short response is no longer rejected in the handler: it reaches
> mana_hwc_handle_resp(), whose mana_hwc_verify_resp_msg() fails it with
> -EPROTO and completes the waiting sender, so a single malformed response
> cannot convert into a channel-wide timeout.

Is this paragraph describing a change against the kernel tree, or against
an earlier revision of the patch?  In the parent commit,
mana_hwc_rx_event_handler() has no response-length check between

	resp = (struct gdma_resp_hdr *)rx_req->buf_va;

and the msg_id read, and this diff does not remove such a check, so there
is no short-response rejection in the handler being relaxed here.

Does the stated guarantee hold in the resulting code?  hwc_msg_id sits at
bytes 10-11 of struct gdma_msg_hdr:

include/net/mana/gdma.h:
struct gdma_msg_hdr {
	u32 hdr_type;
	u32 msg_type;
	u16 msg_version;
	u16 hwc_msg_id;
	u32 msg_size;
};

A response shorter than 12 bytes therefore does not contain the field the
handler reads.  If the bytes read there are out of range, the handler
returns early and mana_hwc_verify_resp_msg() is never reached, so no
sender is completed.  Could the paragraph be reworded to describe what the
code actually guarantees?

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index 19896bb5ce1a4..5db8cfe2d8443 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> @@ -83,6 +83,19 @@ static void mana_hwc_handle_resp(struct hw_channel_context *hwc, u32 resp_len,
>  	struct hwc_caller_ctx *ctx;
>  	int err;
>  
> +	/* Defence in depth: the sole caller, mana_hwc_rx_event_handler(),
> +	 * already rejects msg_id >= hwc->num_inflight_msg with the value it
> +	 * passes here by value, so this cannot be reached out of range.  Keep
> +	 * the guard at the indexing site so the bitmap and caller_ctx array
> +	 * are never indexed without a bound in view.
> +	 */
> +	if (msg_id >= hwc->num_inflight_msg) {
> +		dev_err(hwc->dev, "hwc_rx: msg_id %u >= max %u\n",
> +			msg_id, hwc->num_inflight_msg);
> +		mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
> +		return;
> +	}
> +
>  	if (!test_bit(msg_id, hwc->inflight_msg_res.map)) {
>  		dev_err(hwc->dev, "hwc_rx: invalid msg_id = %u\n", msg_id);
>  		mana_hwc_post_rx_wqe(hwc->rxq, rx_req);

[Severity: High]

This isn't a bug introduced by this patch, but while the msg_id guard is
being added here, is the bare test_bit() on hwc->inflight_msg_res.map
enough to own the slot?  At this commit the bit is tested without
inflight_msg_res.lock, and mana_hwc_send_request() releases the slot on
its timeout path:

out:
	mana_hwc_put_msg_index(hwc, msg_id);
	return err;

so a late or replayed response can find the bit set again for a reused
slot and then write through the previous caller's output_buf:

	ctx = hwc->caller_ctx + msg_id;
	...
	memcpy(ctx->output_buf, resp_msg, resp_len);

The new mana_hwc_rx_leak_wqe() latch below makes the abandon-and-reuse
path much easier to reach.  For completeness: this race is closed later in
the same series by "net: mana: fix stale HWC response after command
timeout", which adds per-slot lock, refcount and responded state and
NULLs output_buf under the lock on timeout, so no change is needed here if
the ordering of the series is kept.

[ ... ]

> @@ -237,18 +262,39 @@ static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
>  	}
>  }
>  
> +/* An RX WQE whose SGE the handler cannot trust is deliberately not
> + * reposted: reposting a slot we may have mis-identified could double-post
> + * a buffer the device still owns.  Each such leak permanently lowers the
> + * RQ's posted depth, so once the whole depth is gone the channel can no
> + * longer receive responses.  Make that terminal state explicit -- log it
> + * once and shorten the command timeout so callers fail fast -- rather than
> + * letting every later command drain its full timeout against a dead RQ.
> + */
> +static void mana_hwc_rx_leak_wqe(struct hw_channel_context *hwc)
> +{
> +	if (++hwc->rx_leaked_wqe == hwc->rxq->queue_depth) {
> +		dev_err(hwc->dev,
> +			"HWC RX: RQ exhausted after %u leaked WQEs; channel unusable\n",
> +			hwc->rx_leaked_wqe);
> +		hwc->hwc_timeout = 1;
> +	}
> +}

[Severity: High]

Is hwc->rxq->queue_depth ever greater than 1 here?  The header defines:

include/net/mana/hw_channel.h:
#define HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH 1

and that is the only depth used:

mana_hwc_create_channel()
  mana_hwc_init_queues(hwc, HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH, ...)
    mana_hwc_create_wq(..., q_depth, ...)
      hwc_wq->queue_depth = q_depth;

If so, ++hwc->rx_leaked_wqe == hwc->rxq->queue_depth is true on the first
call and hwc->hwc_timeout = 1 is latched immediately.

Does that mean one single unattributable completion, from any of the three
new early returns, permanently reduces every later HWC command to

	wait_for_completion_timeout(&ctx->comp_event,
				    msecs_to_jiffies(hwc->hwc_timeout))

with hwc_timeout == 1, returning -ETIMEDOUT?  The inputs that decide those
returns (rx_oob->wqe_offset, the WQE flags word, sge->address) all come
from the device-writable memory this patch treats as untrusted, and none of
the three paths establishes that a posted WQE was actually consumed, so a
single forged or stale completion would appear to disable vport
configuration, queries, RDMA setup and teardown for the life of the
device.

[Severity: High]

This isn't a bug introduced by this patch, but does the new
interrupt-context path make the following teardown behaviour reachable
from device input?  Once hwc_timeout is 1, mana_gd_destroy_queue() still
frees the memory whether or not the destroy-region command succeeded:

drivers/net/ethernet/microsoft/mana/gdma_main.c:mana_gd_destroy_queue() {
	...
	mana_gd_destroy_dma_region(gc, gmi->dma_region_handle);
	mana_gd_free_memory(gmi);
	kfree(queue);
}

mana_gd_destroy_dma_region() is itself an HWC command, so with the timeout
latched every unbind frees DMA regions whose device-side mappings were
never torn down.  mana_hwc_send_request() already collapses hwc_timeout to
1 after a genuine timeout, and this error return has always been ignored,
but previously that state required a real hardware stall and a failing
command in the log.  Should the leak accounting request a service reset
instead of silently forcing the fail-fast timeout from an interrupt?

[Severity: Medium]

Is hwc_timeout a safe place to record this terminal state?  The field has
other writers, and a host-supplied reconfig event overwrites it:

drivers/net/ethernet/microsoft/mana/hw_channel.c:mana_hwc_init_event_handler() {
	...
	case HWC_DATA_CFG_HWC_TIMEOUT:
		hwc->hwc_timeout = val;
	...
}

Because the leak helper tests with == rather than >=, the shortening can
never be applied a second time, so after such an event every later command
drains its full timeout against a dead RQ again, which is the behaviour
the comment above the helper says it avoids.

In the other direction, the store is unconditional, unlike the existing
guard in mana_hwc_send_request():

		if (hwc->hwc_timeout > 1)
			hwc->hwc_timeout = 1;

so it can raise hwc_timeout from the 0 sentinel that mana_serv_reset()
sets:

	/* HWC is not responding in this case, so don't wait */
	hwc->hwc_timeout = 0;

which mana_need_log() also consumes:

	if (hwc && hwc->hwc_timeout == 0)
		return false;

Would a separate sticky flag (and hwc->rx_leaked_wqe being reset when the
channel is re-established) express this state better?  As it stands
rx_leaked_wqe is never reset and no recovery is requested.

[Severity: Medium]

Should this store be annotated?  mana_hwc_rx_leak_wqe() runs in HWC
interrupt context:

mana_gd_intr() -> EQ handler -> mana_hwc_comp_event()
  -> mana_hwc_rx_event_handler() -> mana_hwc_rx_leak_wqe()

while the same field is read and read-modify-written from process context
with plain accesses in mana_hwc_send_request(), written by
mana_gd_query_hwc_timeout() through a request/response round trip, read
unlocked by mana_need_log() and used as a 0 sentinel by mana_serv_reset().
There is no common lock and no READ_ONCE()/WRITE_ONCE() here, so the
process-context update can be lost and the 0 sentinel can be resurrected
to 1 mid-reset.  A structurally identical field in the same series,
hwc_init_max_num_cqs, is annotated with WRITE_ONCE()/READ_ONCE() and a
comment; was the omission here intentional?

> +
>  static void mana_hwc_rx_event_handler(void *ctx, u32 gdma_rxq_id,
>  				      const struct hwc_rx_oob *rx_oob)
>  {

[ ... ]

> @@ -259,28 +305,76 @@ static void mana_hwc_rx_event_handler(void *ctx, u32 gdma_rxq_id,
>  	wqe = mana_gd_get_wqe_ptr(rq, rx_oob->wqe_offset / GDMA_WQE_BU_SIZE);
>  	dma_oob = (struct gdma_wqe *)wqe;
>  
> -	sge = (struct gdma_sge *)(wqe + 8 + dma_oob->inline_oob_size_div4 * 4);
> -
> -	/* Select the RX work request for virtual address and for reposting. */
> +	/* inline_oob_size_div4 lives in device-accessible RQ memory (shared
> +	 * and host-writable in a confidential VM), so snapshot it once and
> +	 * validate and use only the snapshot.  It is a bit-field, which
> +	 * READ_ONCE() cannot take the size of, so read the u32 flags word it
> +	 * shares through the union and extract the field from the local copy.
> +	 * The driver programs INLINE_OOB_SMALL_SIZE for every HWC RQ WQE via
> +	 * mana_gd_post_work_request(), so the only valid value is
> +	 * INLINE_OOB_SMALL_SIZE / 4, which puts the SGE at wqe + 16 inside
> +	 * this WQE's own BU.  Reject anything else -- the slot cannot be
> +	 * trusted, so leak this RX WQE rather than repost the wrong one.
> +	 */
> +	oob_snapshot.flags = READ_ONCE(dma_oob->flags);
> +	oob_div4 = oob_snapshot.inline_oob_size_div4;
> +	if (oob_div4 != INLINE_OOB_SMALL_SIZE / 4) {
> +		dev_err(hwc->dev, "HWC RX: unexpected inline_oob_size_div4=%u\n",
> +			oob_div4);
> +		mana_hwc_rx_leak_wqe(hwc);
> +		return;
> +	}
> +	sge = (struct gdma_sge *)(wqe + 8 + oob_div4 * 4);
> +
> +	/* Recover the originating RX slot from the SGE address.  Snapshot it
> +	 * once, for the same shared-memory reason: of the three terms only
> +	 * sge_addr comes from device memory; rq_base_addr and
> +	 * max_resp_msg_size are driver-private.  An in-range but wrong SGE
> +	 * would otherwise truncate onto a neighbouring slot, letting us read
> +	 * a stale response that could complete the wrong, reused in-flight
> +	 * request.  Require the index in range AND the address to exactly
> +	 * match the value the driver posted for that slot.
> +	 */
> +	sge_addr = READ_ONCE(sge->address);
>  	rq_base_addr = hwc_rxq->msg_buf->mem_info.dma_handle;
> -	rx_req_idx = (sge->address - rq_base_addr) / hwc->max_resp_msg_size;
> -
> -	if (rx_req_idx >= hwc_rxq->msg_buf->num_reqs) {
> -		dev_err(hwc->dev, "HWC RX: wrong rx_req_idx=%llu, num_reqs=%u\n",
> -			rx_req_idx, hwc_rxq->msg_buf->num_reqs);
> +	rx_req_idx = (sge_addr - rq_base_addr) / hwc->max_resp_msg_size;
> +
> +	if (rx_req_idx >= hwc_rxq->queue_depth) {
> +		/* Cannot identify the slot, so we cannot safely repost this
> +		 * WQE; leak it.  An out-of-range index means a corrupted SGE
> +		 * from hardware or host tampering.
> +		 */
> +		dev_err(hwc->dev, "HWC RX: SGE idx %llu out of range\n",
> +			rx_req_idx);
> +		mana_hwc_rx_leak_wqe(hwc);
>  		return;
>  	}

[Severity: Low]

Why was the bound changed from the array's own counter to a field of a
different structure?  The index is used immediately afterwards to index
hwc_rxq->msg_buf->reqs[], which is declared as:

include/net/mana/hw_channel.h:
	u32 num_reqs;
	struct hwc_work_request reqs[] __counted_by(num_reqs);

so num_reqs is the annotated bound for that array, while queue_depth is a
u16 in struct hwc_wq.  The two are equal only by construction:
mana_hwc_create_wq() sets hwc_wq->queue_depth = q_depth and separately
calls mana_hwc_alloc_dma_buf(hwc, q_depth, ...), which allocates
reqs[q_depth] and sets dma_buf->num_reqs = q_depth.  Nothing ties them
together, num_reqs becomes write-only in this file, and the change isn't
mentioned in the changelog even though every other added validation is.
Would keeping the check against msg_buf->num_reqs (and keeping num_reqs in
the error message) be preferable?

>  
>  	rx_req = &hwc_rxq->msg_buf->reqs[rx_req_idx];
> +	if (sge_addr != (u64)rx_req->buf_sge_addr) {
> +		/* In-range index but the address does not match what the
> +		 * driver posted for that slot; the same unrecoverable case,
> +		 * so leak this WQE rather than repost the wrong one.
> +		 */
> +		dev_err(hwc->dev, "HWC RX: invalid SGE address %llx (idx=%llu)\n",
> +			sge_addr, rx_req_idx);
> +		mana_hwc_rx_leak_wqe(hwc);
> +		return;
> +	}
> +

[Severity: Medium]

This isn't a problem introduced by this patch, but does the address match
establish the invariant the helper's comment relies on ("reposting a slot
we may have mis-identified could double-post a buffer the device still
owns")?  The check only shows that the WQE named by the device-supplied
completion offset still contains the OOB size and SGE address the driver
once wrote there, and that offset is masked into the ring rather than
rejected:

drivers/net/ethernet/microsoft/mana/gdma_main.c:mana_gd_get_wqe_ptr() {
	u32 offset = (wqe_offset * GDMA_WQE_BU_SIZE) & (wq->queue_size - 1);

	WARN_ON_ONCE((offset + GDMA_WQE_BU_SIZE) > wq->queue_size);
	...
}

RQ WQE memory keeps those driver-written values after the device consumes
the WQE, and mana_hwc_comp_event() dispatches on completions[i].is_sq
alone, without looking at rx_oob->vendor_err or eom, so a spurious, error
or replayed completion naming a still-owned slot passes both new checks
and gets reposted.  The HWC RQ is created with spec.monitor_avl_buf =
false, so mana_gd_post_work_request() does no free-space check and
wq->head simply advances past the number of buffers the driver owns.  Is
some per-slot posted/consumed state needed for the address match to mean
"this WQE was just consumed for this buffer"?

>  	resp = (struct gdma_resp_hdr *)rx_req->buf_va;
>  
> -	/* Read msg_id once from DMA buffer to prevent TOCTOU:
> -	 * DMA memory is shared/unencrypted in CVMs - host can
> -	 * modify it between reads.
> +	/* Read msg_id once from the DMA buffer to prevent TOCTOU: DMA memory
> +	 * is shared/unencrypted in CVMs, so the host can modify it between
> +	 * reads.  A short response is not rejected here; it is handed to
> +	 * mana_hwc_handle_resp() below, whose mana_hwc_verify_resp_msg()
> +	 * fails it with -EPROTO and completes the waiting sender, so one
> +	 * malformed response cannot stall the whole channel.
>  	 */
>  	msg_id = READ_ONCE(resp->response.hwc_msg_id);
>  	if (msg_id >= hwc->num_inflight_msg) {
>  		dev_err(hwc->dev, "HWC RX: wrong msg_id=%u\n", msg_id);
> +		mana_hwc_post_rx_wqe(hwc_rxq, rx_req);
>  		return;
>  	}

[Severity: Low]

Should these messages be rate limited?  All four rejection paths in this
handler use plain dev_err() from hardirq context with device-supplied
values ("unexpected inline_oob_size_div4=%u", "SGE idx %llu out of range",
"invalid SGE address %llx (idx=%llu)", "wrong msg_id=%u").  This path
previously returned without reposting, which bounded how often a host
could drive it; with the added mana_hwc_post_rx_wqe() a host that keeps
fabricating completions can repeat it indefinitely and flood the log,
which is unpleasant with a serial console.  dev_err_ratelimited(), or the
counter scheme used for the leak accounting, would avoid that.
