Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A93446050;
	Fri, 11 Sep 2026 06:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789109617; cv=none; b=kunZyTxfDeUQdgqdpIdRmAA33tG8mCCu0MqoMFOU/gCOAGQKpELtuaEyU1u+FQAz2hPaMbc8B8yDwJHKRHNepJdnkM5gNbb9bewu0lRWN2UC57J9Cu1eFvNVbrIF3CSCscclZGrluyjMb4cg0qedhG6ZyC1Uk7clhX0As7ITgXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789109617; c=relaxed/simple;
	bh=V6PevJtMaldMBIuKhY5OTMTpsP8/OaTaZNJ6JwCg5Ig=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MD92Sno4u/gg8SkYAut1y8WR/YQVoTWtudLen4DIWz/XcJNem+xeSAWzEzvMhvweuFwYNynRGF0gM4wvLLHQHqdhvpOZHozVtmoQlcZWsTboRAt0dsEPox3JeXG2GA5+kyze1IE3TQqUqtdRHF31vHyvVcWOlq76/1biGvd+mvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gr3viyrh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gr3viyrh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565AA1F00893;
	Fri, 11 Sep 2026 06:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789109604;
	bh=OI582xf4NLba9h8yVtZBm9NmlvYnHp+pmv7cBxAtG6M=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=gr3viyrhJ6nmGb7jVSdDNiyVwgznsgn8megIpCB2JC/GIVfR7p7N4602dGfqJX2J6
	 Z7mLWFMQLlU6nOtAvMV/4XmOefrKyixZ7y4cURSS25eysYrumLi+bKRpROGcslRQL5
	 OeTTGHSOYzu29RgCt5IDaWRvJuQODqMDjfZVtXTp60xfSYPzwe/JJw6dZ06N28rHZx
	 2XZQAS/YM8hHm4iqdgM8x5fwsiQCSF6mlnh4nrMNrkrUfV9+fNjk9qQDOVI0FwWspr
	 ixAxcRbk9YVvVaw4soz/sZh7k1wvWHQbabxxgOEjuNojUJj0yaZA4ck7Er4n6g6Zr5
	 LeJzVQVnf5Dbg==
Subject: Re: [PATCH net-next v5 2/4] net: mana: give each HWC message slot its
 own completion state
From: netdev-bot+sashiko@kernel.org
To: longli@microsoft.com
Cc: longli@kernel.org, kotaranov@microsoft.com, kuba@kernel.org,
 davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
 andrew+netdev@lunn.ch, jgg@ziepe.ca, leon@kernel.org, haiyangz@microsoft.com,
 kys@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
 shradhagupta@linux.microsoft.com, horms@kernel.org, ernis@linux.microsoft.com,
 stephen@networkplumber.org, shirazsaleem@microsoft.com,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 11 Sep 2026 06:53:22 +0000
Message-ID: <178910960289.219967.5929065773405833614@kernel.org>
In-Reply-To: <20260908035201.402424-3-longli@microsoft.com>
References: <20260908035201.402424-3-longli@microsoft.com>
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

Critical: 0 · High: 0 (1) · Medium: 1 (1) · Low: 1

- [Medium] The commit message presents this patch as pure preparation
  ("Add per-slot locking, sender/response references and a responded…
- [Low] The new field comments added to struct hwc_caller_ctx in
  include/net/mana/hw_channel.h describe a narrower contract than…

Pre-existing issues:
- [High] In this patch, mana_hwc_send_request()'s out: label latches
  ctx->responded, clears output_buf and drops both the sender and the…
- [Medium] hwc->hwc_timeout is read and read-modify-written by senders in
  process context (`wait_ms = hwc->hwc_timeout;` and `if…

--

net: mana: give each HWC message slot its own completion state

This adds a per-slot spinlock, a sender/response reference pair and a
responded flag to struct hwc_caller_ctx, makes ctx->error signed, and
withdraws the caller's response buffer once the sender stops waiting.
It also ignores a zero timeout value in a GDMA_QUERY_HWC_TIMEOUT reply.

No Link: tags in the commit header.

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index 88e92e94e2e90..6605e7a9c481b 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c

[ ... ]

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

[Severity: Medium]
Should this hunk carry a Fixes: tag rather than being described as
preparation?

The commit message says:

    Add per-slot locking, sender/response references and a responded flag;
    make ctx->error signed. Stop copying after buffer withdrawal or
    completion.

"Stop copying after buffer withdrawal or completion" reads like a refactor
item, but at the baseline mana_hwc_send_request() released the message slot
on timeout while leaving ctx->output_buf and ctx->output_buflen pointing at
the caller's response buffer, which is usually on the caller's stack:

drivers/net/ethernet/microsoft/mana/gdma_main.c:mana_gd_query_hwc_timeout() {
	struct gdma_query_hwc_timeout_resp resp = {};
	...
	err = mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
}

The baseline mana_hwc_handle_resp() then copied a late response into that
pointer as soon as the bit was set again by the next sender:

	if (!test_bit(msg_id, hwc->inflight_msg_res.map)) {
		...
	}
	ctx = hwc->caller_ctx + msg_id;
	err = mana_hwc_verify_resp_msg(ctx, resp_msg, resp_len);
	...
	memcpy(ctx->output_buf, resp_msg, resp_len);

With HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH == 1 the same index is always
reused, so the write lands in a stack frame that has already returned, and
the length check runs against the stale output_buflen.

Is the new output_buf test here, together with the ctx->output_buf = NULL
withdrawal in mana_hwc_send_request(), what closes that window? If so, would
a Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network
Adapter (MANA)") and a mention of the corruption in the changelog make this
visible to stable? The changelog notes the work was re-targeted from a "net
fixes-only posting" to net-next, which makes the fix easy to miss.

>  
>  	err = mana_hwc_verify_resp_msg(ctx, resp_msg, resp_len);
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

[ ... ]

> @@ -878,8 +925,11 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
>  	}
>  
>  	ctx = hwc->caller_ctx + msg_id;
> +
> +	spin_lock_irqsave(&ctx->lock, flags);
>  	ctx->output_buf = resp;
>  	ctx->output_buflen = resp_len;
> +	spin_unlock_irqrestore(&ctx->lock, flags);

[ ... ]

> @@ -895,43 +945,108 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
> +	wait_ms = hwc->hwc_timeout;
>  	if (!wait_for_completion_timeout(&ctx->comp_event,
> -					 (msecs_to_jiffies(hwc->hwc_timeout)))) {
> -		if (hwc->hwc_timeout != 0)
> +					 msecs_to_jiffies(wait_ms))) {
> +		/* Clear output_buf so a late response cannot write the caller's
> +		 * buffer, then check whether one already arrived
> +		 * (error != -EINPROGRESS).
> +		 */
> +		spin_lock_irqsave(&ctx->lock, flags);
> +		ctx->output_buf = NULL;
> +		err = ctx->error;
> +		status = ctx->status_code;
> +		spin_unlock_irqrestore(&ctx->lock, flags);

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
> diff --git a/include/net/mana/hw_channel.h b/include/net/mana/hw_channel.h
> index befa09674ce56..b377e221aa5c8 100644
> --- a/include/net/mana/hw_channel.h
> +++ b/include/net/mana/hw_channel.h
> @@ -171,8 +171,24 @@ struct hwc_caller_ctx {
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
> +	/* Set by the first handle_resp(), or by the sender's timeout path,
> +	 * so a later or duplicate response is dropped.
> +	 */
> +	bool responded;
>  };

[Severity: Low]
These three comments look narrower than what hw_channel.c actually relies
on. Could they be extended?

The lock comment mentions output_buf only, but the out: block in
mana_hwc_send_request() also uses it to serialize ->responded and to decide
who owns the response-side reference:

	spin_lock_irqsave(&ctx->lock, flags);
	ctx->output_buf = NULL;
	drop_resp_ref = !ctx->responded;
	ctx->responded = true;
	spin_unlock_irqrestore(&ctx->lock, flags);

and ctx->error / ctx->status_code are read and written under the same lock
in both mana_hwc_handle_resp() and mana_hwc_send_request().

The responded comment says it is set "by the first handle_resp(), or by the
sender's timeout path", but the out: block above is also reached from the
req_len > tx_wr->buf_len rejection, from mana_hwc_post_tx_wqe() failure, and
from the no-wait teardown path where hwc_timeout is 0.

The error comment says "Linux error code (negative errno or 0)", while
mana_hwc_get_msg_index() stores -EINPROGRESS as an in-band "no response yet"
state that mana_hwc_send_request() special-cases with
if (err != -EINPROGRESS). Should that sentinel be documented next to the
field, since every reader of ->error has to know about it?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260908035201.402424-1-longli%40microsoft.com
