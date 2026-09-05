Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6AF236C5AE;
	Sat,  5 Sep 2026 20:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788638544; cv=none; b=itN2OYHmC4b0UZ7TOT/4potxr4EXtsB0X0TGPivPrJ6OhQhRhyloylRpOeqT/XU4nQF/0ReJgesp2gT3fd8spJqSHZ7cxZhuu3+iACItVvIhCBym9a+tabgeaIu+98HnryAgPLiSpkE7VKAkzp6dCP3nlzjOOBFT+398Fd0ixYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788638544; c=relaxed/simple;
	bh=fcUCxxcBEpwCphCQ8aPJ+zpWnv9TVdxFaACAJnN5LT4=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YOaG3QvXrjWUMSC/BhVAeVAtl29dbrFewfWvJgyRwGKWmhGFAduAIRzivbSwI2v5V3jJbcXmqoXwCkwyyWYic9as3lAPup7wE/Ao1yRaNVREDKMY5OIXoobIZNlixmrxESRQQ0A0Q4iYUlFVrdW6xtToKEiN48TBr+Uc9PjJ8PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VtbrOBSX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VtbrOBSX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378341F00A3A;
	Sat,  5 Sep 2026 20:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788638542;
	bh=J5Ia008taJgxfufAhB2HEHHMOuhTk4WXO+X+xRAFacc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=VtbrOBSXyJg12NLSxeDKVfOUpD/8wmXtvV2cktEEPwQE2Yu31j24xBE5Sqx6JbZkS
	 jcOW86kQMUJQsAfj0BI+Vk75S+S+Gncaq32XRl0HDTh06BjBsenJxISZPZ0XRnpOSG
	 nwhzmAPTL1M2Rc6dVu+TTCdz5n6eJi1f12QBA+JDLQn1aHoYD/lP+y6FA0Unxtvfvs
	 tCfwUJ8/7JXfCQ3K9tGate1sW4OSCV6BcSJJv9bo196maBhHdvJ4S8EMK3Z2mEPouc
	 +Xk3fD8yEzE1x9RGe0oriyS93wZvKrnkzs54J004UEGfZYQPPyOCIdAMm8hsxNruTo
	 qHDR6gaUuIX7w==
Subject: Re: [PATCH net-next v4 1/4] net: mana: track when the HWC has been
 handed to the PF
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
Date: Sat, 05 Sep 2026 20:02:20 +0000
Message-ID: <178863854071.219967.16644612539187136296@kernel.org>
In-Reply-To: <20260901200018.3194525-2-longli@microsoft.com>
References: <20260901200018.3194525-2-longli@microsoft.com>
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

Critical: 0 · High: 0 (1) · Medium: 1 · Low: 1

- [Medium] Commit message mischaracterizes the change: "No functional
  change is intended for the current single-establish flow" is not…
- [Low] The teardown-failure branch of mana_hwc_destroy_channel() is an
  inert store, and the documentation added by the patch describes…

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but it is now
  explicitly acknowledged in code and left unfixed: when DESTROY_HWC…

--

net: mana: track when the HWC has been handed to the PF

The patch replaces the gc->max_num_cqs test in mana_hwc_destroy_channel()
with a new hw_channel_context::setup_active flag.  mana_smc_setup_hwc()
clears the flag on entry and sets it just before the ESTABLISH_HWC message
is written to shared memory, so teardown can tell whether the PF was ever
given the queue addresses.

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index 263e7c4e29341..75fdccdc8c482 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> @@ -683,7 +683,7 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
>  				 cq->mem_info.dma_handle,
>  				 rq->mem_info.dma_handle,
>  				 sq->mem_info.dma_handle,
> -				 eq->eq.msix_index);
> +				 eq->eq.msix_index, &hwc->setup_active);
>  	if (err)
>  		return err;
>  
> @@ -815,13 +815,20 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
>  	if (!hwc)
>  		return;
>  
> -	/* gc->max_num_cqs is set in mana_hwc_init_event_handler(). If it's
> -	 * non-zero, the HWC worked and we should tear down the HWC here.
> +	/* Tear down only if setup_hwc() handed the queues to the PF.  Until
> +	 * then the device never saw them, so there is nothing to undo.
>  	 */
> -	if (gc->max_num_cqs > 0) {
> -		mana_smc_teardown_hwc(&gc->shm_channel, false);
> -		gc->max_num_cqs = 0;
> +	if (hwc->setup_active) {

[Severity: Medium]
The commit message says:

    No functional change is intended for the current single-establish flow.

Is that accurate for the failure paths?  gc->max_num_cqs is written in
exactly one place, mana_hwc_init_event_handler():

	case HWC_INIT_DATA_MAX_NUM_CQS:
		gd->gdma_context->max_num_cqs = val;

so it stays zero until the PF has processed ESTABLISH_HWC and started
delivering bootstrap EQEs.  hwc->setup_active is set in
mana_smc_setup_hwc() immediately before the writel() loop, so the new
condition is a strict superset of the old one.

Two paths reach mana_hwc_destroy_channel() with gc->max_num_cqs still 0 and
now send DESTROY_HWC where they previously sent nothing:

mana_hwc_establish_channel()
	if (!wait_for_completion_timeout(&hwc->hwc_init_eqe_comp, 60 * HZ))
		return -ETIMEDOUT;

mana_smc_setup_hwc()
	err = mana_smc_read_response(sc, SMC_MSG_TYPE_ESTABLISH_HWC,
				     SMC_MSG_TYPE_ESTABLISH_HWC_VERSION,
				     reset_vf);
	if (err) {
		dev_err(sc->dev, "Error when setting up HWC: %d\n", err);
		return err;
	}

On those paths mana_smc_teardown_hwc() polls mana_smc_poll_register() for up
to 20 * 1000 iterations of usleep_range(1000, 2000) and then polls again
inside mana_smc_read_response(), so a failing probe or resume against a
wedged PF can now take tens of seconds longer than before.

Should the changelog describe the error-path change and the extra polling
delay instead of stating no functional change?  Since the newly attempted
teardown is also what closes the existing window where the queue memory is
freed while the PF still holds its addresses on the establish-timeout path,
would a Fixes: tag be appropriate here?

> +		/* Only a successful teardown invalidates the MST entries.  If
> +		 * it fails the device may still be using the queues, so leave
> +		 * the flag set rather than record a clean teardown.
> +		 */
> +		if (!mana_smc_teardown_hwc(&gc->shm_channel, false))
> +			hwc->setup_active = false;
> +		else
> +			dev_err(hwc->dev, "Failed to tear down HWC\n");
>  	}
> +	gc->max_num_cqs = 0;

[Severity: Low]
The comment explains that the flag is deliberately left set for a later
reader, but is there a reader left?  mana_hwc_destroy_channel() frees hwc a
few lines further down in the same function:

	kfree(hwc);
	gc->hwc.driver_data = NULL;

and mana_hwc_destroy_channel() is the only place that reads setup_active;
the only other references are the *submitted stores in mana_smc_setup_hwc()
and the &hwc->setup_active argument passed by
mana_hwc_establish_channel().  mana_hwc_create_channel() allocates a fresh
zeroed hw_channel_context, so a new attempt starts with setup_active ==
false regardless.

Does the else branch have any observable effect today, or is the retained
value discarded by the kfree(hwc) below?

>  
>  	if (hwc->txq)
>  		mana_hwc_destroy_wq(hwc, hwc->txq);

[Severity: High]
This isn't a bug introduced by this patch, but the new comment now states
the hazard explicitly while the code still proceeds: when
mana_smc_teardown_hwc() fails, "the device may still be using the queues",
yet the queue memory is freed unconditionally right here.

mana_hwc_destroy_wq() releases both the message buffer and the ring:

	mana_hwc_dealloc_dma_buf(hwc, hwc_wq->msg_buf);

	if (hwc_wq->gdma_wq)
		mana_gd_destroy_queue(hwc->gdma_dev->gdma_context,
				      hwc_wq->gdma_wq);

and both paths end in mana_gd_free_memory():

	dma_free_coherent(gmi->dev, PAGE_SIZE, gmi->pages_va[i],
			  gmi->pages_dma[i]);

mana_smc_teardown_hwc() documents why the response matters:

	/* Read shmem response (polling for VF possession) and validate.
	 * For teardown, waiting for response is required to ensure hardware
	 * invalidates MST entries before software frees memory.
	 */

A non-zero return therefore means the driver has no confirmation that the
MST entries were invalidated (mana_smc_poll_register() timed out, or the
response header did not confirm DESTROY_HWC).  Can the PF keep DMAing
completions and EQEs into pages that dma_free_coherent() has already
returned to the allocator in that case?  Would it be better to leak or
quarantine the HWC buffers when teardown is not confirmed rather than free
them?  The same log-only-and-continue sequence is still present at the tip
of the series (mana_hwc_destroy_channel() in c850f2d5).

> diff --git a/drivers/net/ethernet/microsoft/mana/shm_channel.c b/drivers/net/ethernet/microsoft/mana/shm_channel.c
> index d21b5db06e509..1ec8e3661721d 100644
> --- a/drivers/net/ethernet/microsoft/mana/shm_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/shm_channel.c
> @@ -144,6 +150,8 @@ int mana_smc_setup_hwc(struct shm_channel *sc, bool reset_vf, u64 eq_addr,
>  	int err;
>  	int i;
>  
> +	*submitted = false;
> +
>  	/* Ensure VF already has possession of shared memory */
>  	err = mana_smc_poll_register(sc->base, false);
>  	if (err) {

[Severity: Low]
The clear here is unconditional and happens before the three pre-handover
exits (poll timeout, non-page-aligned addresses, msix index outside
VECTOR_MASK).  If a future caller ever enters mana_smc_setup_hwc() with a
handover still outstanding, would one of those exits silently downgrade the
flag to "device untouched" and make mana_hwc_destroy_channel() skip
DESTROY_HWC?  I checked that every mana_smc_setup_hwc() call in
mana_hwc_create_channel() at the series tip is preceded by a successful
mana_smc_teardown_hwc() plus hwc->setup_active = false, so this is not
reachable today, only a trap for the next caller.

[ ... ]

> diff --git a/include/net/mana/hw_channel.h b/include/net/mana/hw_channel.h
> index 16feb39616c1b..237608b488e5e 100644
> --- a/include/net/mana/hw_channel.h
> +++ b/include/net/mana/hw_channel.h
> @@ -199,6 +199,16 @@ struct hw_channel_context {
>  	u32 pf_dest_vrcq_id;
>  	u32 hwc_timeout;
>  
> +	/* True once mana_smc_setup_hwc() has handed the ESTABLISH_HWC message
> +	 * to the PF, so the device may DMA into the HWC buffers.  That
> +	 * function clears it on entry and sets it at the handover, so only a
> +	 * failure before the handover leaves it false; a failure after it --
> +	 * including one reported by mana_hwc_establish_channel() -- leaves it
> +	 * set, which is what makes teardown attempt DESTROY_HWC.  Cleared
> +	 * again once that teardown succeeds.
> +	 */
> +	bool setup_active;
> +
>  	struct hwc_caller_ctx *caller_ctx;
>  };

[Severity: Low]
"Cleared again once that teardown succeeds" reads as state that survives an
attempt, but the field lives in the object that mana_hwc_destroy_channel()
kfree()s and that mana_hwc_create_channel() re-allocates zeroed.  Could the
comment say that the flag only lives for the lifetime of one
hw_channel_context?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260901200018.3194525-1-longli%40microsoft.com
