Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D58485CC8;
	Thu,  6 Aug 2026 17:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786037040; cv=none; b=LQ3X7CBSyjmOwbAT3OqjZ0n/FZJCq3MrZmW7tYilvsVfewGue2YsxNi8+S4mg4YB9V4405Ckx6h/gZmZqUuMgkBOZ5uQcyaPUvTQsWNWRkxZEkYfW8quSXmYVcKbOTTfzt1eUjJKGvzpD3WjaF1GQxtoqJuZLMi1dJ7/YzZPcA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786037040; c=relaxed/simple;
	bh=jtAwKpUpDxLqBa3FZiyQjBP4FLau/jZU6K9nS5N00Rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I7CqGjax4OXAeKNWMxC+zRt6iYi7BlGz/3OKBJlUiLii+1gk1SQj3kdXHxfqm+EiTmhqYZap6AFmp1FlIEs9kcOmBPxZfINRNebNcVb7Ypw4TkttI8ONzDltDyGPr3HvuyRlc2eTjWFetYd/iJutKjzmC7YlwTW9uHThnSzgCZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eUb7cda1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eUb7cda1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9821F00A3A;
	Thu,  6 Aug 2026 17:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786037039;
	bh=6j+83Q1tkEfnGVFPa2fQ6Ny7gvcrMydNqlKg3UBxpxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eUb7cda1V/5K+frBvqlnIWNmgkOq2nPNxCqBDeyROX26ox3zCOLfiVxK/229eXJys
	 dfE3LsVDrFWzuiAWmfXAWWpP3Qlnr+UhQpPOMNc1d7ePWxcMKYHzJCUJZvMF982w7F
	 DLR64a8uLh2YqKqUBtRogaKAyKRsvMHKUG4zOg6DHiEZWoRsJLXFFhJyIToj3yGrE+
	 Up4svRlpZpuH6BihS9X1rqLoU/p29sLYf6vVnZVvFcu7MoisnHqq/pm8Z4LFp772ZF
	 dVktsITWs9sRSAoPk5N8FRcrrER1JhCgNVTS0v+WDD8RYo78ojd3PMMlrz2Yf5H2oj
	 QMtWUYDe1FrkQ==
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
Subject: Re: [PATCH net v3 2/6] net: mana: fix HWC RQ/SQ buffer size swap
Date: Thu,  6 Aug 2026 10:23:57 -0700
Message-ID: <20260806172357.2945651-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260803234355.636038-3-longli@microsoft.com>
References: <20260803234355.636038-3-longli@microsoft.com>
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
net: mana: fix HWC RQ/SQ buffer size swap

This swaps the sizes used when creating the HWC RQ and SQ so the RQ is
sized by max_resp_msg_size and the SQ by max_req_msg_size, adds
max_resp_msg_size to struct hw_channel_context, and uses it as the RX
slot stride in mana_hwc_rx_event_handler().  It also hoists the
num_inflight_msg / max_req_msg_size / max_resp_msg_size assignments in
mana_hwc_init_queues() above the mana_hwc_create_cq() call.

Two questions, both about the description rather than the mechanics of
the swap.

First, about this part of the changelog:

>     The HWC RQ receives responses and the SQ sends requests, but
>     mana_hwc_init_queues() sized the RQ with max_req_msg_size and the SQ with
>     max_resp_msg_size -- backwards.  A response larger than the undersized RQ
>     buffer could overflow it, and mana_hwc_rx_event_handler() recovered the
>     RX slot index by dividing by the wrong size (max_req_msg_size).

[Severity: Medium]
Can the described overflow or mis-indexing actually happen in this tree?
mana_hwc_init_queues() has a single caller, mana_hwc_create_channel(),
which passes two constants that are equal:

	err = mana_hwc_init_queues(hwc, HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH,
				   HW_CHANNEL_MAX_REQUEST_SIZE,
				   HW_CHANNEL_MAX_RESPONSE_SIZE);

include/net/mana/hw_channel.h:

	#define HW_CHANNEL_MAX_REQUEST_SIZE  0x1000
	#define HW_CHANNEL_MAX_RESPONSE_SIZE 0x1000

The hardware-reported sizes that mana_hwc_establish_channel() returns are
only handed to mana_hwc_test_channel(); the queues are never re-created
with them, so max_req_msg_size == max_resp_msg_size on every path both
before and after this patch.

Also, mana_hwc_post_rx_wqe() advertises the real slot length to the
device:

	sge->address = (u64)req->buf_sge_addr;
	sge->mem_key = hwc_rxq->msg_buf->gpa_mkey;
	sge->size = req->buf_len;

so the device is not told it may write more than one slot regardless of
max_resp_msg_size.

Given that, would it be worth saying in the changelog that the two sizes
are currently identical and that there is no observable misbehaviour,
i.e. that this is a latent-correctness cleanup?  With the

	Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")

tag and the wording above, a stable backporter is likely to read this as
a live buffer overflow fix.

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index 409e20caeccdc..cbb56c7647876 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> @@ -263,7 +263,7 @@ static void mana_hwc_rx_event_handler(void *ctx, u32 gdma_rxq_id,
>  
>  	/* Select the RX work request for virtual address and for reposting. */
>  	rq_base_addr = hwc_rxq->msg_buf->mem_info.dma_handle;
> -	rx_req_idx = (sge->address - rq_base_addr) / hwc->max_req_msg_size;
> +	rx_req_idx = (sge->address - rq_base_addr) / hwc->max_resp_msg_size;
>  
>  	if (rx_req_idx >= hwc_rxq->msg_buf->num_reqs) {
>  		dev_err(hwc->dev, "HWC RX: wrong rx_req_idx=%llu, num_reqs=%u\n",

[ ... ]

> @@ -721,6 +721,15 @@ static int mana_hwc_init_queues(struct hw_channel_context *hwc, u16 q_depth,
>  	if (err)
>  		return err;
>  
> +	/* Set the queue dimensions before creating the CQ: doing so
> +	 * registers mana_hwc_rx_event_handler(), which divides by
> +	 * hwc->max_resp_msg_size and range-checks hwc->num_inflight_msg.
> +	 * They must be valid before any RX completion can be delivered.
> +	 */
> +	hwc->num_inflight_msg = q_depth;
> +	hwc->max_req_msg_size = max_req_msg_size;
> +	hwc->max_resp_msg_size = max_resp_msg_size;

[Severity: Low]
Does this comment claim more than the reordering provides?  It says the
scalars must be valid before mana_hwc_create_cq() registers
mana_hwc_rx_event_handler(), but in that same window hwc->rxq and
hwc->txq are still NULL, since they are only assigned by the
mana_hwc_create_wq() calls further down.

mana_hwc_rx_event_handler() touches hwc->rxq well before it reaches
either hoisted field:

	struct hwc_wq *hwc_rxq = hwc->rxq;
	...
	if (WARN_ON_ONCE(hwc_rxq->gdma_wq->id != gdma_rxq_id))
		return;
	...
	rq_base_addr = hwc_rxq->msg_buf->mem_info.dma_handle;
	rx_req_idx = (sge->address - rq_base_addr) / hwc->max_resp_msg_size;

and mana_hwc_handle_resp() uses hwc->caller_ctx, which is only allocated
later in mana_hwc_test_channel().  The EQ callback registered by the same
mana_hwc_create_cq() call, mana_hwc_init_event_handler(), likewise
dereferences hwc->cq, hwc->rxq and hwc->txq:

	hwc->cq->gdma_eq->id = eq_db.eq_id;
	...
	hwc->rxq->gdma_wq->id = val;
	...
	hwc->txq->msg_buf->gpa_mkey = val;

So if a completion really could be delivered while mana_hwc_create_cq()
runs, the hoisted scalars would not help.  The window looks not to be
live anyway, because the device only learns the queue DMA addresses via
mana_smc_setup_hwc() in mana_hwc_establish_channel(), which runs after
mana_hwc_init_queues() has published everything, matching the existing
comment in mana_hwc_create_channel():

	/* mana_hwc_init_queues() only creates the required data structures,
	 * and doesn't touch the HWC device.
	 */

Could the comment and the matching changelog paragraph be reworded to say
the assignments are simply hoisted for clarity, rather than asserting
that RX completions can be safely handled at that point?  As written, a
later reader may take this window to be safe for handler execution.

>  	/* CQ is shared by SQ and RQ, so CQ's queue depth is the sum of SQ
>  	 * queue depth and RQ queue depth.
>  	 */
> @@ -733,23 +742,20 @@ static int mana_hwc_init_queues(struct hw_channel_context *hwc, u16 q_depth,
>  		goto out;
>  	}
>  
> -	err = mana_hwc_create_wq(hwc, GDMA_RQ, q_depth, max_req_msg_size,
> +	err = mana_hwc_create_wq(hwc, GDMA_RQ, q_depth, max_resp_msg_size,
>  				 hwc->cq, &hwc->rxq);
>  	if (err) {
>  		dev_err(hwc->dev, "Failed to create HWC RQ: %d\n", err);
>  		goto out;
>  	}
>  
> -	err = mana_hwc_create_wq(hwc, GDMA_SQ, q_depth, max_resp_msg_size,
> +	err = mana_hwc_create_wq(hwc, GDMA_SQ, q_depth, max_req_msg_size,
>  				 hwc->cq, &hwc->txq);
>  	if (err) {
>  		dev_err(hwc->dev, "Failed to create HWC SQ: %d\n", err);
>  		goto out;
>  	}
>  
> -	hwc->num_inflight_msg = q_depth;
> -	hwc->max_req_msg_size = max_req_msg_size;
> -
>  	return 0;

[ ... ]
