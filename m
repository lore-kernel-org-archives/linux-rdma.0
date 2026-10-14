Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FE14AF9D4;
	Wed, 14 Oct 2026 08:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791965763; cv=none; b=a7OZXhCxudIjNsfZwkOgJ5SWzIWcdIENb+68aCXjkgCozQ06qUD9tyUei01os9ZUBDm/iJG51+6iLdS9cTsfOliVphR78BaFVcxS4gfLdSWct1nGy2YXv3FE7xR1OHh/4X8piUmt37l0PCBeX0sCJgPAAW4G/4pmMkEu6t0jCp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791965763; c=relaxed/simple;
	bh=XbwMR7GA4SHlmfiyY8DT+uWhgSvpRG7p5bd88hwT79Q=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AF8YlcOeass7sysAr6EYcFmds9CsLlI1FZCoYEgDcoDrYvENcFB9mYgOqJGWs531Qtwi9PCYMbHqd60/TiJDBBomXJLFf68imwpkoiVRBHQ2KYXcLG5JIZ/wU2NSIMTYLBsqcJeEWNyWRhRa2tuB3y5+/4dDhlx9AUOvyoBIqXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PGY2gnl9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PGY2gnl9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A491F00893;
	Wed, 14 Oct 2026 08:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791965756;
	bh=BaQUQUfUcWIR/HjJvuHdH9S3f80c2dR3SBdNFR+TFUI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=PGY2gnl9D/BwcmgnUwNT+ZU2GJQOd/vfnme68v/bHqu5u45Bpk6OBxbr8EBCI965o
	 pTug0InQdwv2mVT1Abf26ejqF/kcITi6QYMxTakyn1dhA80a4h2BJTTQuzFQ8RZ5wJ
	 z2WTL12AmLG+ddVyoL8mb1jxU1LiSHiQXoIl7E51nTLWV4PnTQuyaV0v6x4W+z6YkW
	 h9P3ULmkOKXpXA3zgCvhliANuxjEgE57H+Z2Fb4BtxyNxSWsJIObNF9TOmpoMWz/Lt
	 rxX6kQAnPrKFh4+fqSmwdnEGM7jYLvsu7IFY96r912gfdV8QcpULYd0qfM2IWQRaed
	 tbtxff0n5E9uw==
Subject: Re: [PATCH net-next v7 2/4] net: mana: give each HWC message slot its
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
Date: Wed, 14 Oct 2026 08:15:54 +0000
Message-ID: <179196575434.434549.4428132041097324407@kernel.org>
In-Reply-To: =?utf-8?q?=3Cb6a611e9de0f67b48ddde2948e257128df1e90fc=2E1791561?=
 =?utf-8?q?995=2Egit=2Eweh=40linux=2Emicrosoft=2Ecom=3E?=
References: =?utf-8?q?=3Cb6a611e9de0f67b48ddde2948e257128df1e90fc=2E17915619?=
 =?utf-8?q?95=2Egit=2Eweh=40linux=2Emicrosoft=2Ecom=3E?=
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
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] At this commit, one genuine HWC timeout sets the channel-wide
  latch hwc->hwc_timed_out, in mana_hwc_put_msg_index(..., true) called…
- [Low] This patch fixes real bugs that exist in the baseline driver,
  including a memory-safety bug, but carries no Fixes: tag and no stable…

--

net: mana: give each HWC message slot its own completion state

This commit adds a per-slot spinlock to hwc_caller_ctx. The lock protects
output_buf, error and status_code. The commit also reinitializes the
completion and result state when a slot is acquired, and adds a
channel-wide hwc_timed_out latch that rejects new requests after a genuine
timeout. Status handling and request cleanup are split into helpers.

Link: https://lore.kernel.org/r/20260908035201.402424-3-longli@microsoft.com
Link: https://lore.kernel.org/r/20260908035201.402424-4-longli@microsoft.com

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index b1d972968f0d7..89b6e30863dae 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c

[ ... ]

> @@ -16,9 +17,22 @@ static int mana_hwc_get_msg_index(struct hw_channel_context *hwc, u16 *msg_id)
>  
>  	spin_lock_irqsave(&r->lock, flags);
>  
> +	if (hwc->hwc_timed_out) {
> +		spin_unlock_irqrestore(&r->lock, flags);
> +		up(&hwc->sema);
> +		return -ETIMEDOUT;
> +	}

[Severity: Medium]
After one genuine timeout, mana_hwc_send_request() calls
mana_hwc_finish_request(hwc, ctx, msg_id, true). That sets
hwc->hwc_timed_out in mana_hwc_put_msg_index(). Nothing clears the flag
until the hwc is freed and mana_hwc_create_channel() allocates a new one.

After that point, does every mana_hwc_get_msg_index() call return
-ETIMEDOUT without posting anything to the SQ? That would include teardown
commands.

For example, mana_gd_destroy_queue() ignores the result of the destroy
command and frees the host memory anyway:

drivers/net/ethernet/microsoft/mana/gdma_main.c:mana_gd_destroy_queue() {
    ...
	mana_gd_destroy_dma_region(gc, gmi->dma_region_handle);
	mana_gd_free_memory(gmi);
	kfree(queue);
}

If the device was only slow and not dead, could it keep a DMA region
mapping that points at freed host pages?

mana_serv_reset() in gdma_pci.c does this:

	/* HWC is not responding in this case, so don't wait */
	hwc->hwc_timeout = 0;

With a zero timeout, the first suspend command now latches the channel,
so the rest of the suspend-time destroy commands are never posted. Before
this patch they were posted.

The firmware HWC_DATA_CFG_HWC_TIMEOUT update in
mana_hwc_init_event_handler() changes hwc_timeout but cannot clear the
latch. Runtime timeout users such as mana_gf_stats_work_handler() will
also see later commands fail without being sent until the reset runs.

The next patch in the series, "net: mana: support concurrent HWC
requests", removes hwc_timed_out. It replaces the latch with per-slot
quarantine, which a late response or teardown releases. So this only
affects this intermediate commit, either during bisection or if this
patch is backported alone.

Could this commit avoid the channel-wide latch so that every commit in the
series is bisect-safe?

> +
>  	index = find_first_zero_bit(hwc->inflight_msg_res.map,
>  				    hwc->inflight_msg_res.size);
>  
> +	ctx = &hwc->caller_ctx[index];
> +	reinit_completion(&ctx->comp_event);
> +	ctx->output_buf = NULL;
> +	ctx->output_buflen = 0;
> +	ctx->error = -EINPROGRESS;
> +	ctx->status_code = 0;

[Severity: Low]
This isn't a bug in the new code. These changes, together with the
output_buf handling under ctx->lock, fix problems that exist in the
baseline driver, but the commit has no Fixes: tag and no Cc: stable.

In the baseline, the bootstrap channel has depth one, so every request
uses msg_id 0. Three problems follow from that.

First, mana_hwc_get_msg_index() never called reinit_completion(). A late
complete() for a request that had already timed out left comp_event done.
The next wait_for_completion_timeout() then returned at once, with stale
error and status_code values and a response buffer that was never filled.

Second, mana_hwc_handle_resp() only checked test_bit(msg_id) before
memcpy(ctx->output_buf, ...). There is a window between bitmap_set() in
mana_hwc_get_msg_index() and this assignment in mana_hwc_send_request():

	ctx->output_buf = resp;

A stale response arriving in that window could pass the check and copy
into the previous caller's output_buf. That buffer is often on the stack,
such as the resp in mana_gd_query_hwc_timeout(), and that function has
already returned.

Third, a late response arriving after the next request had set its bit
and output_buf would be accepted as the answer to that request.

The commit message does say "A late response therefore cannot copy through
a pointer to caller storage whose lifetime has ended". Without a Fixes:
tag, though, stable trees won't pick this up. A plain backport of this
patch would also carry the hwc_timed_out latch that the next patch
removes.

Would it make sense to send a self-contained fix for these, with a Fixes:
tag, to net separately?

> +
>  	bitmap_set(hwc->inflight_msg_res.map, index, 1);
>  
>  	spin_unlock_irqrestore(&r->lock, flags);

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1791561995.git.weh%40linux.microsoft.com
