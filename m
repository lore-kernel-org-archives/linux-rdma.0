Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794552400;
	b=w7y+h5VM/RE2fwuRmulTEVF6YhLhF3paeoGPl063zXVOAEYX9BWpO/ziSkmExskjFoVI
	 lXRSOBKltkij5MDP47RtW+Zbpdx08YxAby9WPD6nQBrUTiBXi/km2ehcxTINFNo9ZFYaZ
	 +3z6vSisjNNwcw6aDlggjcl7eDJ5YMarHJsmm1NxF2Z/htVr+0yIkzZL5SKQqiWPiDjEC
	 yRXUm5oeqgTNqf87Ele6oVZ8u9skQv7kUbmg7k2mKdM5d8A8NxBP2zvLikXL4nkrVj4q0
	 Al3YI+0fNyzExwwpqokJ2wqrYxi/mgM0IyyGkfghyjRF8OJIjL+yWd1uj3S90H26xEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794552400;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=cg/WRIGqozw9MhRldw7MsIg3h6aKYtIP6pTMrFQ+1Gc=;
	b=3TlLP6daR+N64obRGFVTpC4JCmTw+17v6z7x0ArxQxtd75U04awQrITsDVuku9Ss8dVR
	 iNxMRklM+4KJrtvizKKXe0hKUWjG6scoYITmeQOYcbSGFD64w/Zp8WjLff7vg6O3U+0tO
	 FwX90cUJV84miDCd9Bg8vlRBcjf62/PlEEeFNX89skKuLsTmxZLVarvFSfpSSU7HYJ5Q1
	 APcbsCW3sCh9HdDg5I6g1ow5gB6LR1HKQoLEUxvBesBHKVU13zkIH7/XKk2LpQqshf/yY
	 UMqIAE4UOUqSUxaWA1o/rnqD1J++E1HDEuaGYp+xOcX/Gz3tE/XiWe3kqyJJ0t+w9Dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c7FLxbvq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF25606A88F;
	Fri, 13 Nov 2026 06:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c7FLxbvq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954321F000C4;
	Fri, 13 Nov 2026 06:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794552400;
	bh=cg/WRIGqozw9MhRldw7MsIg3h6aKYtIP6pTMrFQ+1Gc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=c7FLxbvqGIDo+QWpICjrMKbIlvAWc148scq4rk8rO3zX2rG+5MkAr7fi5mTbZYlEl
	 3CGqfhqzi40g67UZ8pt5HPZ8USYp0A20WJ2rqOr+8KnuE1e8PuA5QlZIdyuygwRcPu
	 LBF6lnX4INO5rwHdOHqJspN2pxglGQ+GRunsPteZ71jAK/UcDtyP91yW4enNvv5IMy
	 yKVIJZBYONhcD+LRMq5o7mnJT/yJlSYgCJ/KWbBcDUTUX++YoBP9A9/gsqD3ITqahG
	 sNZjzOKG3Kp1sRONVGWxWzjE7oqiIgG88ul/JGMOlAwmeOM3W07MnOESwOG8VxkiiI
	 RMCX0qYXEcBDg==
Subject: Re: [PATCH net-next v10 2/4] net: mana: give each HWC message slot
 its own completion state
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
 mawasthi@linux.microsoft.com, weh@microsoft.com, edumazet@kernel.org
Date: Fri, 13 Nov 2026 06:46:38 +0000
Message-ID: <179455239815.2199510.4673285259543925635@kernel.org>
In-Reply-To: <d3c71452bb2938a5c1fcfebb32d44827eaea94e9.1794208055.git.weh@linux.microsoft.com>
References: <d3c71452bb2938a5c1fcfebb32d44827eaea94e9.1794208055.git.weh@linux.microsoft.com>
X-sashiko-severity: Low
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

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The patch closes memory-safety and wrong-result bugs that are
  reachable in the baseline, but it carries no Fixes: tag and no stable…

Pre-existing issues:
- [Medium] At this commit, a late response for a request that already
  timed out can be delivered to the next request that reuses the same…
- [Medium] At this commit, mana_hwc_handle_resp() copies resp_len bytes,
  a value the device supplies via rx_oob->tx_oob_data_size, from the RX…
- [Medium] At this commit, the timeout path in mana_hwc_send_request()
  frees the msg_id slot through mana_hwc_finish_request() while the SQ…
- [Medium] mana_hwc_rx_event_handler() returns without calling
  mana_hwc_post_rx_wqe(hwc->rxq, rx_req) when the device-supplied…

--

net: mana: give each HWC message slot its own completion state

This adds a per-slot spinlock to struct hwc_caller_ctx. The lock protects
the caller's output buffer, the Linux error and the device status.

The output buffer is published only while the sender waits and is
withdrawn before every return. Completion and result state are
reinitialized when a slot is acquired, and status handling and cleanup
move into helpers.

Link: https://lore.kernel.org/r/20260908035201.402424-3-longli@microsoft.com
Link: https://lore.kernel.org/r/20260908035201.402424-4-longli@microsoft.com
Link: https://lore.kernel.org/r/179196575434.434549.4428132041097324407@kernel.org
Link: https://lore.kernel.org/r/179196575640.434549.9102950927041409151@kernel.org

> Protect the caller's output buffer, Linux error and device status with a
> per-slot lock. Publish the output buffer only while the sender is waiting
> and withdraw it before every return. A late response cannot copy through a
> pointer to caller storage whose lifetime has ended.
>
> Reinitialize completion and result state under both the allocation and
> per-slot locks when acquiring the slot.

[Severity: Low]
These changes fix bugs that can already be hit in the baseline, but the
commit has no Fixes: tag and no stable note. Should it have them?

Before this patch, mana_hwc_send_request() set ctx->output_buf = resp and
never cleared it. On timeout it called mana_hwc_put_msg_index() and
returned. A late response in mana_hwc_handle_resp() could then memcpy()
through ctx->output_buf into the stack frame of a caller that had already
returned.

The baseline also never reinitialized comp_event after the
init_completion() in mana_hwc_test_channel(). A complete() that landed
after a timeout carried over to the next user of the slot. That user then
returned immediately with stale error and status and an unfilled response
buffer.

Both become easier to hit once hwc_timeout drops to 1 ms after the first
timeout.

Would something like this be appropriate?

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")

This commit only partly closes the late-response problem. Could the
message also tell backporters that the follow-up "net: mana: support
concurrent HWC requests" is needed too?

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index 9e0964072af9a..6f0ccdeffc4f9 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c

[ ... ]

> @@ -90,14 +100,21 @@ static void mana_hwc_handle_resp(struct hw_channel_context *hwc, u32 resp_len,
>  	}
>  
>  	ctx = hwc->caller_ctx + msg_id;
> -	err = mana_hwc_verify_resp_msg(ctx, resp_msg, resp_len);
> -	if (err)
> -		goto out;
>  
> -	ctx->status_code = resp_msg->status;
> +	spin_lock(&ctx->lock);
> +	if (!ctx->output_buf) {
> +		spin_unlock(&ctx->lock);
> +		mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
> +		return;
> +	}
>  
> -	memcpy(ctx->output_buf, resp_msg, resp_len);
> -out:
> +	err = mana_hwc_verify_resp_msg(ctx, resp_msg, resp_len);
> +	if (!err) {
> +		ctx->status_code = resp_msg->status;
> +		memcpy(ctx->output_buf, resp_msg, resp_len);

[Severity: Medium]
This isn't a bug introduced by this patch, but can this memcpy() read past
the end of the RX slot?

Here resp_len comes from the device through rx_oob->tx_oob_data_size.
mana_hwc_verify_resp_msg() only checks it against the caller's buffer:

	if (resp_len > caller_ctx->output_buflen)
		return -EPROTO;

Nothing in mana_hwc_send_request() keeps the caller's resp_len (which
becomes output_buflen) at or below rx_req->buf_len, which is
max_req_msg_size. If a caller passes a larger resp_len, a buggy or
malicious device could make this copy pull adjacent RX DMA slots into the
caller's buffer.

The later patch "net: mana: add dynamic HWC queue depth with reinit path"
fixes this. There, mana_hwc_get_msg_index() rejects any resp_len above
min(hwc->rx_msg_size_limit, hwc->max_req_msg_size).

> +	}
> +
> +	ctx->output_buf = NULL;
>  	ctx->error = err;
>  
>  	/* Must post rx wqe before complete(), otherwise the next rx may
> @@ -106,6 +123,7 @@ static void mana_hwc_handle_resp(struct hw_channel_context *hwc, u32 resp_len,
>  	mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
>  
>  	complete(&ctx->comp_event);
> +	spin_unlock(&ctx->lock);
>  }

[Severity: Medium]
This isn't a bug introduced by this patch, but the caller of this
function, mana_hwc_rx_event_handler(), drops the RX buffer when the device
sends an out-of-range msg_id:

	msg_id = READ_ONCE(resp->response.hwc_msg_id);
	if (msg_id >= hwc->num_inflight_msg) {
		dev_err(hwc->dev, "HWC RX: wrong msg_id=%u\n", msg_id);
		return;
	}

rx_req is already known at this point. Should this path call
mana_hwc_post_rx_wqe(hwc->rxq, rx_req) before it returns?

As written, each such completion permanently removes one buffer from the
HWC RQ. After q_depth of them the RQ is empty, and later responses have no
buffer to land in. This still looks present at the end of the series.

[ ... ]

> @@ -1048,11 +1105,24 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,

[ ... ]

>  	if (!wait_for_completion_timeout(&ctx->comp_event,
> -					 (msecs_to_jiffies(hwc->hwc_timeout)))) {
> +					 msecs_to_jiffies(hwc->hwc_timeout))) {

[ ... ]

>  		if (hwc->hwc_timeout != 0)
>  			dev_err(hwc->dev, "Command 0x%x timed out: %u ms\n",
>  				command, hwc->hwc_timeout);
> @@ -1061,27 +1131,16 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
>  		if (hwc->hwc_timeout > 1)
>  			hwc->hwc_timeout = 1;
>  
> -		err = -ETIMEDOUT;
> -		goto out;
> +		mana_hwc_finish_request(hwc, ctx, msg_id);
> +		return -ETIMEDOUT;

[Severity: Medium]
This isn't a bug introduced by this patch, but can a late response for a
request that timed out still reach the next request that reuses the same
msg_id?

Sender A times out and calls
mana_hwc_finish_request()->mana_hwc_put_msg_index(), which clears the
bitmap bit right away. Sender B then gets the same index from
find_first_zero_bit(), publishes ctx->output_buf = resp_B and posts its
request.

When A's late response arrives, mana_hwc_handle_resp() checks only the
msg_id and whether ctx->output_buf is non-NULL:

	spin_lock(&ctx->lock);
	if (!ctx->output_buf) {

Both checks pass for B's slot. A's response would then be copied into B's
buffer and complete B, and B would return A's data and status.

The commit message says this is not solved here. The later patch "net:
mana: support concurrent HWC requests" handles it by keeping a timed-out
slot quarantined. The slot stays reserved until the late response arrives
or mana_hwc_stop_channel() cancels it.

[Severity: Medium]
This is a pre-existing issue, but is the TX DMA buffer for this msg_id safe
to reuse at this point?

The SQ WQE posted by mana_hwc_post_tx_wqe() points at
txq->msg_buf->reqs[msg_id].buf_va, and the device may not have consumed it
yet. mana_hwc_get_msg_index() uses find_first_zero_bit(), so the next
sender usually gets the same index and overwrites that buffer:

	req_msg = (struct gdma_req_hdr *)tx_wr->buf_va;
	if (req)
		memcpy(req_msg, req, req_len);

Could the device then read a mix of the old and new request contents?

The later patch "net: mana: support concurrent HWC requests" keeps the
slot's bitmap bit, and with it the TX buffer, until the late response
arrives or mana_hwc_stop_channel() cancels it.

>  	}

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1794208055.git.weh%40linux.microsoft.com
