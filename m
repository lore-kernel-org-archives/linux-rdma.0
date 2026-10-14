Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2AEE4A8A0C;
	Wed, 14 Oct 2026 08:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791965764; cv=none; b=qRVTDdM+fE/2lrcCwFi+mFEbvNanPN3xcWXyE88M7xoskicbqSbCNkCIWiUTTrx1iy/prln9I1gxaYgwpuTM8LwVP2rZaZIQ3Rd2Te4tnmLAvtsM1RVAPNxjf/VgAqjUBnm55Onnq/5g+VAfJY6R+g2CEs0UCstlIX8l79Y1XYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791965764; c=relaxed/simple;
	bh=zNF5Yl7mX1A61QlZ1wXD88M+xm60I3mzQdwZrMXXgp0=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sq6YMA0szblINp9TXkrIlgkE7Ku91CoNK2B1RLXjvCcO2qS/fTpb/caoa3vAoDcRM3EqaX1Mh+V7iAABgy1AejK8s+d1r28BdxQvCQUobBzRSjG1+xAf61sc505BRKavC5z9msKDheRcVjOOsT1YWJZ/dTsD3RH/Sb9+RQLUKck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bh111hgz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bh111hgz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D33F01F00898;
	Wed, 14 Oct 2026 08:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791965758;
	bh=TfqZP990l4gEzr0DO9/7kSoN3/RjbJNeCusG0/AUn0U=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Bh111hgz0DJtGE1bNffnYmWeq5YS6zQro1gb2kyZ65njkzW0Pip2qyNZDJI/tIHGD
	 IfM6NpAZzae1Qq8/NE2+MyWKcLY2zbnhDnCT3/YuDN68Ht1Vokfm7CciOtWC0Ua+bE
	 LWfs2YcnmJwR7tKkwExDOXEK2I06RtANqmuLLpH3nuuOUxGNqzrFYj6+v5cTmXwRCJ
	 yjhrhHn5Lt0xE66+T3GbRv1LRDxy9zt4HvIEmm0/X/mTDpUM+AZ5TCKACTrXhHmw/s
	 yFze3dpRz1z/kjhao2zF/unvj7siZr0tXNGAhA0uogb7zg8gjX2NEIoj2HLtPwEUsd
	 VldIKxhBZCyEA==
Subject:
 Re: [PATCH net-next v7 3/4] net: mana: support concurrent HWC requests
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
Date: Wed, 14 Oct 2026 08:15:56 +0000
Message-ID: <179196575640.434549.9102950927041409151@kernel.org>
In-Reply-To: =?utf-8?q?=3C08f833983788be99fc73b856dd4822826b5876f7=2E1791561?=
 =?utf-8?q?995=2Egit=2Eweh=40linux=2Emicrosoft=2Ecom=3E?=
References: =?utf-8?q?=3C08f833983788be99fc73b856dd4822826b5876f7=2E17915619?=
 =?utf-8?q?95=2Egit=2Eweh=40linux=2Emicrosoft=2Ecom=3E?=
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 4 potential
issue(s) to consider.

Critical: 0 · High: 2 · Medium: 0 (2) · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] Once a timed-out request quarantines the HWC's only slot, every
  later request on a dead channel fails with -EBUSY instead of…
- [High] A slot can be freed and given to a new sender while the RX
  handler still holds ctx->lock on it.
- [Low] The title says the patch adds "support concurrent HWC requests",
  and the message says it allows "independent message IDs to make…
- [Low] If mana_hwc_publish_channel() finds the slot occupied (a
  WARN_ON_ONCE case), mana_hwc_create_channel() calls the full…

Pre-existing issues:
- [Medium] After one timeout, mana_hwc_timeout_reduce() permanently
  lowers hwc_timeout to 1 ms.
- [Medium] mana_hwc_rx_event_handler() returns early when msg_id >=
  num_inflight_msg, and on that path it does not repost rx_req, even…

--

net: mana: support concurrent HWC requests

This patch replaces the depth-one HWC timeout latch with per-slot sender
and response reference counting. It also serializes SQ posting, returns
-EBUSY when admission slots are exhausted, and moves hwc_timeout to atomic
helpers. Channel publication and teardown are restructured around a new
gc->hwc_lock and a sender drain.

Link: https://lore.kernel.org/r/20260908035201.402424-4-longli@microsoft.com
Link: https://lore.kernel.org/r/20260914175044.2a26bb46@kernel.org

> net: mana: support concurrent HWC requests

[ ... ]

> This preserves response-buffer withdrawal and timeout quarantine while
> allowing independent message IDs to make progress.

[Severity: Low]
Does this describe the commit accurately on its own?

At this commit, mana_hwc_create_bootstrap_channel() always sizes the
channel with HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH, which is 1. That gives
one semaphore permit and a one-bit map, so no requests can run
concurrently yet. The visible change here is the new error and timeout
behaviour.

Larger depths only arrive with the next patch in the series, "net: mana:
add dynamic HWC queue depth with reinit path". Could the message say so?

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index 89b6e30863dae..9fdd84ccba653 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> @@ -6,57 +6,122 @@
>  #include <net/mana/hw_channel.h>
>  #include <linux/vmalloc.h>
>  
> -static int mana_hwc_get_msg_index(struct hw_channel_context *hwc, u16 *msg_id)
> +u32 mana_hwc_timeout_read(const struct hw_channel_context *hwc)

[ ... ]

> +static int mana_hwc_get_msg_index(struct hw_channel_context *hwc, void *resp,
> +				  u32 resp_len,
> +				  struct hwc_caller_ctx **caller_ctx)
>  {
>  	struct gdma_resource *r = &hwc->inflight_msg_res;
>  	struct hwc_caller_ctx *ctx;
>  	unsigned long flags;
> +	bool channel_up;
> +	u32 wait_ms;
>  	u32 index;
>  
> -	down(&hwc->sema);
> +	wait_ms = mana_hwc_timeout_read(hwc);
> +	if (down_timeout(&hwc->sema, msecs_to_jiffies(wait_ms))) {
> +		spin_lock_irqsave(&r->lock, flags);
> +		channel_up = hwc->channel_up;
> +		spin_unlock_irqrestore(&r->lock, flags);
>  
> -	spin_lock_irqsave(&r->lock, flags);
> +		/* Slot pressure is not evidence that the HWC stopped responding. */
> +		return channel_up ? -EBUSY : -ENODEV;
> +	}

[Severity: High]
Is -EBUSY the right return value when the slot is held by a request that
timed out?

At this commit the channel has a single slot. On timeout,
mana_hwc_wait_for_response() marks the request abandoned but leaves
resp_pending set:

    if (err == -EINPROGRESS) {
        ctx->responded = true;
        abandoned = true;
    }

So the bitmap bit and the semaphore permit stay held until a late response
arrives or teardown runs. Only that one caller sees -ETIMEDOUT.

Nothing on the timeout path clears channel_up. Every later sender
therefore fails down_timeout() here and gets -EBUSY. Before this series,
and with the latch from the earlier patch in the series, those senders
got -ETIMEDOUT.

The recovery triggers only check for -ETIMEDOUT. For example, in
mana_gf_stats_work_handler():

    err = mana_query_gf_stats(ac);
    if (err == -ETIMEDOUT) {
        ...
        mana_schedule_serv_work(gc, GDMA_EQE_HWC_RESET_REQUEST);

The recovery path in mana_gd_probe() and the rescan in mana_serv_reset()
check only err == -ETIMEDOUT || err == -EPROTO.

Suppose another command, such as ethtool PHY stats, vport config or an
RDMA command, times out first. Would the gf_stats work then keep getting
-EBUSY every 2 seconds, so the HWC reset is never scheduled and the device
stays wedged?

Logging is affected too. Once mana_gd_cancel_hwc_timeout() sets the
timeout to 0 in mana_serv_reset(), the first command sent during
mana_gd_suspend() is quarantined immediately. Every later command returns
-EBUSY. Since mana_need_log() only suppresses -ETIMEDOUT, each of them is
logged with dev_err.

The commit message describes -EBUSY as admission pressure that "must not
make callers start dead-channel recovery". When abandoned requests hold
the slots, isn't -EBUSY actually a sign of a dead channel?

[ ... ]

> @@ -97,40 +162,54 @@ static void mana_hwc_handle_resp(struct hw_channel_context *hwc, u32 resp_len,
>  				 struct hwc_work_request *rx_req, u16 msg_id)
>  {
>  	const struct gdma_resp_hdr *resp_msg = rx_req->buf_va;
> +	struct gdma_resource *r = &hwc->inflight_msg_res;
>  	struct hwc_caller_ctx *ctx;
> +	bool release;
>  	int err;
>  
> -	if (!test_bit(msg_id, hwc->inflight_msg_res.map)) {
> +	spin_lock(&r->lock);
> +	if (!test_bit(msg_id, r->map)) {
> +		spin_unlock(&r->lock);
>  		dev_err(hwc->dev, "hwc_rx: invalid msg_id = %u\n", msg_id);
>  		mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
>  		return;
>  	}

[Severity: Medium]
This is a pre-existing issue, not one introduced by this patch. This path
reposts the receive buffer, but the out-of-range check in
mana_hwc_rx_event_handler() does not:

    msg_id = READ_ONCE(resp->response.hwc_msg_id);
    if (msg_id >= hwc->num_inflight_msg) {
        dev_err(hwc->dev, "HWC RX: wrong msg_id=%u\n", msg_id);
        return;
    }

With a depth of 1, wouldn't a single out-of-range msg_id from the device
leave the RQ with no posted buffers for the rest of the channel's life?
With the new -EBUSY behaviour above, that starved channel would also never
trigger recovery.

>  
>  	ctx = hwc->caller_ctx + msg_id;
> -
>  	spin_lock(&ctx->lock);
> -	if (!ctx->output_buf) {
> +	spin_unlock(&r->lock);
> +
> +	/* Consume the response-side reference exactly once. This releases a
> +	 * quarantined slot after its late response arrives.
> +	 */
> +	release = ctx->resp_pending;
> +	ctx->resp_pending = false;

[Severity: High]
Can this slot be freed and handed to a new sender while the handler still
holds ctx->lock?

After r->lock is dropped, the handler keeps reading and writing
resp_pending, responded, output_buf and output_buflen, and it calls
memcpy() and complete(). When release is false, it does all of this
without holding a reference.

The last hwc_ctx_put() goes through mana_hwc_put_msg_index(). That
function clears the bit under r->lock only and never takes ctx->lock.
mana_hwc_get_msg_index() then reinitializes the slot, also under r->lock
only:

    refcount_set(&ctx->refcnt, 2);
    ctx->output_buf = resp;
    ctx->output_buflen = resp_len;
    ...
    ctx->responded = false;
    ctx->resp_pending = true;

Take a duplicate response for a msg_id whose first response has already
completed the request. The responded branch suggests duplicates are meant
to be tolerated:

CPU1 (duplicate response)      CPU2 (original sender)
mana_hwc_handle_resp()
  test_bit() succeeds
  spin_lock(&ctx->lock)
  spin_unlock(&r->lock)
                               mana_hwc_wait_for_response()
                                 /* already past its ctx->lock section */
                                 hwc_ctx_put()   /* last reference */
                                   bitmap_clear(r->map, ...)
                                   up(&hwc->sema)

CPU3 (new sender)
mana_hwc_get_msg_index()
  rewrites refcnt, output_buf, output_buflen, resp_pending, responded
  under r->lock only, while CPU1 still holds ctx->lock

Possible outcomes:

The duplicate can overwrite the new resp_pending with false. Or the new
sender's mana_hwc_submit_request() can see responded == true and fail
with -ENODEV. Either way refcnt never reaches zero, so the slot and its
permit leak until teardown, and with depth 1 every later request gets
-EBUSY.

The stale duplicate can be copied into the new caller's output buffer and
complete that request.

On weakly ordered CPUs, the handler could pair a new output_buf with a
stale output_buflen, or with NULL.

The struct hwc_caller_ctx comment says "Once its bitmap bit is set, lock
protects every field below except msg_id and refcnt". The commit message
says the slot is released "only after both sides have finished".

Would it work to initialize the slot while holding ctx->lock nested inside
r->lock, which matches the existing r->lock then ctx->lock order? Or to
clear the bitmap bit while holding ctx->lock?

[ ... ]

> @@ -983,13 +1115,151 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)

[ ... ]

> +	err = mana_hwc_create_bootstrap_channel(hwc);
> +	if (err) {
> +		mana_hwc_release_channel(hwc);
> +		return err;
> +	}
> +
> +	err = mana_hwc_publish_channel(hwc);
> +	if (err) {
> +		mana_hwc_release_channel(hwc);
> +		return err;
> +	}

[Severity: Low]
mana_hwc_publish_channel() fails only when its WARN_ON_ONCE() finds the
slot occupied. In that case this calls the full mana_hwc_release_channel()
on the new, unpublished hwc.

That function also resets gc-wide state that belongs to whichever channel
holds the slot. It frees gc->cq_table, zeroes gc->max_num_cqs, clears
gc->hwc.gdma_context, and resets the doorbell and pdid.

If SMC teardown fails on this path, mana_hwc_retain_channel() finds the
slot occupied and only logs. The hwc and its queues are then leaked with
no owner.

Does this case need a narrower unwind? It can only happen if channel
creation runs concurrently without serialization, which the normal
lifecycle doesn't do.

[ ... ]

> @@ -1004,108 +1274,86 @@ static int mana_hwc_response_status(struct hw_channel_context *hwc,

[ ... ]

> +static int mana_hwc_wait_for_response(struct hw_channel_context *hwc,
> +				      struct hwc_caller_ctx *ctx,
> +				      u32 command)
>  {

[ ... ]

> +	if (wait_ms)
> +		dev_err(hwc->dev, "Command 0x%x timed out: %u ms\n",
> +			command, wait_ms);
> +
> +	mana_hwc_timeout_reduce(hwc);
> +	hwc_ctx_put(hwc, ctx);
> +
> +	return -ETIMEDOUT;

[Severity: Medium]
This isn't a bug introduced by this patch, but mana_hwc_timeout_reduce()
permanently lowers hwc_timeout to 1 ms after a single timeout.

Once a late response frees the slot, later commands are posted to the
firmware and abandoned after about one jiffy, while the firmware may still
be executing them. Callers like mana_gd_create_mana_wq_cq() then free the
DMA memory those commands refer to.

The code before this series behaved the same way. This patch actually
posts less often, since a slot is reused only after its late response
arrives.

Could the driver and the device still end up disagreeing about state here,
with the device writing by DMA into freed memory?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1791561995.git.weh%40linux.microsoft.com
