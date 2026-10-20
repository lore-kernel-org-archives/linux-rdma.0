Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792503393;
	b=j3/CVxamH5SP9QI1CVlIh14RsdZEpL7DzOnDljGZsRR88AV/uaU/zQoe8lus2V7zZQCS
	 f/sfGsQBqpzEJefpIqpnHpAnsLUgmmrw0NI1CG/KNsU7T79vM1i/YKpw2LenYpoPYcrZL
	 T94D0KEBMwi1K2OAaz2zc/fD4GcZJ8P/YdpS5GvoXg284QaqkR3O6sTlirG+rp9rxxsrC
	 w73St1GL/EYsijcVAwIazzF8zSH3O+CWQGknSNyaQSIsugrdooqPN7hNYe6M9oSZZrVh+
	 t3MYfqAxrlk38banxxU4X2YgHuuMIv3yRPa8zrAJi9bMtFuv+O287Z6nKXAy7mC0qsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792503393;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=akDqU9tn3xTYDRHY4OOSLobtGF5nF4BwKt+HSFtS3OY=;
	b=fyZevmbQzqZm9Q7UsqPM/g9DPY+codxK0R7Sl2LXx0aVZGFTP0Of+JlOA1X6lbngyg/8
	 LQNaxV4roU3cUYUyCc0E90jjMNadRzkqf4x0RAoL0OB6uzxCtpRZby2xssbYciKxA9frm
	 i3K7gV449Qo9aeCgGg4GPQzYIKnNZtSTWzJYWIKruIn0rydU0FwVmqon7rsah0p+24aJn
	 wEzzyfFgZFE+ZN7VyU3TF8nZUByBl/OVjIwtXNYz7cehjbGQVpab2BHK4cal1FX1yIjXG
	 1Z1nFuDfp+8EbIavTmp1Zew9sgAHIKvf3NKk6Dx/LHhoFwcPIZGCYmIIrdfNo85TIfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nlKffbiO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E095B60A382F;
	Tue, 20 Oct 2026 13:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nlKffbiO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7BC01F000C7;
	Tue, 20 Oct 2026 13:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792503392;
	bh=akDqU9tn3xTYDRHY4OOSLobtGF5nF4BwKt+HSFtS3OY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=nlKffbiONcMT5U8Hf/tTtb4BiUjDdzEU6t1Zwa4d0y7aUswEooedqePGkEmAe4sIE
	 OvXcKJwBJqqfOUT+CDJkAn2r58zJBC+ZMGrVT+dXTY8anPUho66i6HyltenxrFw+6E
	 GlmGwjZpVrBNM4YhDWOpFV4Nn7A3c1AkHg32ZV3Q/dEDhLPPNPKGEDbrKVPLvGIKyR
	 A0k3+ZGhNmYH/wrNI02aV7IAwlHekbFZYiQtOeL9DHfCX5lC15WlJgMzGgW9PMeL9O
	 7SGvigYO2lMOCrfUiIvlRV2Tvfp9W4G8K9TQnuNwZuD4iH/B417cw9wBuVCHRMse9R
	 T0qUTM22mSWRw==
Subject: Re: [PATCH net-next v8 2/4] net: mana: give each HWC message slot its
 own completion state
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
Date: Tue, 20 Oct 2026 13:36:30 +0000
Message-ID: <179250339038.3135.16651240191139289948@kernel.org>
In-Reply-To: =?utf-8?q?=3C6e6a337c466b86d93c52ea0adb5c7121ea3e9a7e=2E1791998?=
 =?utf-8?q?462=2Egit=2Eweh=40linux=2Emicrosoft=2Ecom=3E?=
References: =?utf-8?q?=3C6e6a337c466b86d93c52ea0adb5c7121ea3e9a7e=2E17919984?=
 =?utf-8?q?62=2Egit=2Eweh=40linux=2Emicrosoft=2Ecom=3E?=
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

- [Low] Commit "net: mana: give each HWC message slot its own completion
  state" fixes memory-safety and stale-completion bugs that go back to…

Pre-existing issues:
- [High] Cross-request response confusion after msg_id reuse.
- [Medium] mana_hwc_handle_resp() copies resp_len bytes from
  rx_req->buf_va.
- [Low] hwc->hwc_timeout is read and modified without synchronization.

--

net: mana: give each HWC message slot its own completion state

This patch adds a per-slot spinlock to struct hwc_caller_ctx. The lock
protects the output buffer, the error and the device status, and
output_buf is published only while the sender is waiting.
mana_hwc_get_msg_index() now reinitializes the completion and result
state when a slot is acquired. A response that races the timed wait is
returned instead of a false timeout, and status handling and cleanup are
split into mana_hwc_response_status() and mana_hwc_finish_request().

Link: https://lore.kernel.org/r/20260908035201.402424-3-longli@microsoft.com
Link: https://lore.kernel.org/r/20260908035201.402424-4-longli@microsoft.com
Link: https://lore.kernel.org/r/179196575434.434549.4428132041097324407@kernel.org
Link: https://lore.kernel.org/r/179196575640.434549.9102950927041409151@kernel.org

> Protect the caller's output buffer, Linux error and device status with a
> per-slot lock. Publish the output buffer only while the sender is waiting
> and withdraw it before every return. A late response cannot copy through a
> pointer to caller storage whose lifetime has ended.

[Severity: Low]
Should this patch carry a Fixes: tag?

Before this patch, mana_hwc_get_msg_index() set the bitmap bit before
mana_hwc_send_request() assigned ctx->output_buf. output_buf was also
never cleared when a sender returned.

A late response that passed the lockless test_bit() in
mana_hwc_handle_resp() could then memcpy() into a previous caller's
response buffer. Some callers pass on-stack buffers. For example,
mana_query_phy_stats() in mana_en.c has:

	struct mana_query_phy_stat_resp resp = {};

The old code also never called reinit_completion(). A complete() that
raced a timed-out sender left comp_event.done set. The next user of that
slot would then return immediately with stale error and status_code
values and an unfilled output buffer.

Both problems appear to date back to the original driver:

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")

Without a Fixes: tag, backporters have no signal that this patch closes
a memory corruption bug in released kernels. The complete fix also needs
"net: mana: support concurrent HWC requests" later in the series, which
finishes the late-response correlation work.

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index a1c1c6f32cafa..03a3a0e9d3f84 100644
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
> +	}

[Severity: Medium]
This isn't a bug introduced by this patch, but can this memcpy() read
past the end of the RX slot?

resp_len is the device-supplied rx_oob->tx_oob_data_size. The only upper
bound in mana_hwc_verify_resp_msg() is the caller's buffer size:

	if (resp_len > caller_ctx->output_buflen)
		return -EPROTO;

resp_len is never compared against rx_req->buf_len, which equals
hwc->max_req_msg_size.

Suppose a caller passes a resp_len larger than the RX slot, and a buggy
or malicious device reports an oversized length. The copy would then
read from adjacent RX slots or past the DMA allocation, and those bytes
would be returned to the caller.

No current caller with such a resp_len was found. This patch only moves
the existing verify and memcpy() under ctx->lock.

Later in the series, "net: mana: add dynamic HWC queue depth with reinit
path" makes mana_hwc_get_msg_index() reject resp_len >
min(hwc->rx_msg_size_limit, hwc->max_req_msg_size) with -EMSGSIZE before
a slot is taken. That closes this.

[ ... ]

> @@ -1046,11 +1103,23 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,

[ ... ]

>  	if (!wait_for_completion_timeout(&ctx->comp_event,
> -					 (msecs_to_jiffies(hwc->hwc_timeout)))) {
> +					 msecs_to_jiffies(hwc->hwc_timeout))) {
> +		spin_lock_irqsave(&ctx->lock, flags);
> +		ctx->output_buf = NULL;
> +		err = ctx->error;
> +		status = ctx->status_code;
> +		spin_unlock_irqrestore(&ctx->lock, flags);
> +
> +		if (err != -EINPROGRESS) {
> +			mana_hwc_finish_request(hwc, ctx, msg_id);
> +			return mana_hwc_response_status(hwc, command, err, status);
> +		}
> +
>  		if (hwc->hwc_timeout != 0)
>  			dev_err(hwc->dev, "Command 0x%x timed out: %u ms\n",
>  				command, hwc->hwc_timeout);
> @@ -1059,27 +1128,16 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
>  		if (hwc->hwc_timeout > 1)
>  			hwc->hwc_timeout = 1;

[Severity: Low]
This is a pre-existing issue, but can this check-and-store overwrite a
concurrent store of 0 to hwc->hwc_timeout?

mana_serv_reset() in gdma_pci.c sets the "never wait" value without any
synchronization:

	/* HWC is not responding in this case, so don't wait */
	hwc->hwc_timeout = 0;

Consider this sequence:

  1. A sender reads a value greater than 1.
  2. mana_serv_reset() stores 0.
  3. The sender stores 1.

Later senders then wait 1 ms instead of not waiting at all, and the
"timed out" log stops being suppressed.

The HWC_DATA_CFG_HWC_TIMEOUT case in mana_hwc_init_event_handler() also
writes hwc->hwc_timeout. The send path reads it several times with plain
loads.

This patch only reformats the wait expression here. Later in the series,
"net: mana: support concurrent HWC requests" moves all accesses to
mana_hwc_timeout_read(), mana_hwc_timeout_reduce(),
mana_hwc_timeout_update() and mana_hwc_timeout_cancel(). It also changes
mana_serv_reset() to call mana_gd_cancel_hwc_timeout().

>  
> -		err = -ETIMEDOUT;
> -		goto out;
> +		mana_hwc_finish_request(hwc, ctx, msg_id);
> +		return -ETIMEDOUT;
>  	}

[Severity: High]
This isn't a bug introduced by this patch, but can a late response for a
timed-out command be delivered to the next sender that reuses this
msg_id?

On this path, mana_hwc_finish_request()->mana_hwc_put_msg_index()
releases the slot immediately. mana_hwc_get_msg_index() always hands out
the lowest free index:

	index = find_first_zero_bit(hwc->inflight_msg_res.map,
				    hwc->inflight_msg_res.size);

With the depth-1 bootstrap queues, the next sender always gets the same
slot and publishes its own output_buf.

When the firmware response for the old command arrives,
mana_hwc_handle_resp() checks only the bitmap bit and that output_buf is
non-NULL:

	spin_lock(&ctx->lock);
	if (!ctx->output_buf) {

The old payload is then copied into the new sender's buffer, and the new
sender completes with the old command's status.

A caller such as mana_gd_destroy_dma_region() could then return success
for the wrong transaction. If the old response is shorter, the tail of
the buffer is left stale.

The commit message acknowledges this ("This does not solve late-response
correlation after ID reuse"). It is fixed later in the series by "net:
mana: support concurrent HWC requests". That patch keeps the
response-side reference (refcnt and resp_pending) and the admission
permit on a timed-out slot. The bitmap bit is then cleared only after
the late response is consumed, or at teardown.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1791998462.git.weh%40linux.microsoft.com
