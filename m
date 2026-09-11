Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF2842E407;
	Fri, 11 Sep 2026 06:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789109613; cv=none; b=sJEATNOzLDf8Ba4PAtW+sH3fHVEegmAVJPoYybJKtihZLBCA2/vdm1vjvTcNVHGQerMjxTYTk9B2M6hcjJ3nVag2rwFvkim7JZxqbLVp7ll7MMS3AjfWkK6JoIUNiFwkW8AAAXjYTi9I+Myn6FxXcmv00+D0sIsptBJM4+voVSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789109613; c=relaxed/simple;
	bh=BTk1YZDI+uDisbn4s5VtAu26iTR4cqp7ysNeJFhaD70=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uD0Zo27PDlOyix0yXX+rHCzo1QwphYghDQqihKtpv6u4Kt0ogmqHFArZd2/8hh8gFXuTfKXSercKc5Ac8A3NnUZgFtwlOjk+40IiW4mQb1WpeBLu2GTE8BtauW0kI+3sGe7r92d4kWThqTiU4w5V1xFTLgyRHCndmOfGOkaitEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oOvp20pp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oOvp20pp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93FE61F000FF;
	Fri, 11 Sep 2026 06:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789109602;
	bh=QErj2RuPUXOYAikXEmg5mKDTcSF6GR0WVee0QcGfDdI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=oOvp20ppAEoJnCsW/ZEut4/ns3yJOpSnAxMorUZN9eJk6HOqEA7a5r4+pFFrV6e/G
	 LqMrICaDj6Fz+yKNJT9AdPbmJ1S2KTDeN0uo2wuwo7QcmjNzLl71wJLXksYdklXZ+N
	 6Oaw1qPNhEdlumkh+ldQG4JJWDLuPNq9zTvkRKmpaxM4KI3nkFM0taKkD8FVmAX6f2
	 6ju8Ma3gEqgtcweZyjRxeIOUjHa7jtjpMbfttWAAywSnRB3tHgfOHT9i1iZXk1HEQN
	 aUXNh5aiArGyxEt1muwyATd+y43cOQZ4nVhuScwMCVDx0TldIeyTeCp5hioaRu+M/1
	 Odk1P9QspH8Mw==
Subject: Re: [PATCH net-next v5 1/4] net: mana: track when the HWC has been
 handed to the PF
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
Date: Fri, 11 Sep 2026 06:53:21 +0000
Message-ID: <178910960115.219967.13830871915506436112@kernel.org>
In-Reply-To: <20260908035201.402424-2-longli@microsoft.com>
References: <20260908035201.402424-2-longli@microsoft.com>
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

Critical: 0 · High: 0 (1) · Medium: 2 · Low: 0

- [Medium] The patch silently converts a real correctness fix but is
  presented as pure preparation and carries no Fixes: tag.
- [Medium] `hwc->setup_active` is written in `mana_smc_setup_hwc()`
  (shm_channel.c:149 and 237) and read/cleared in…

Pre-existing issues:
- [High] In `mana_hwc_destroy_channel()`
  (drivers/net/ethernet/microsoft/mana/hw_channel.c:818-824), a failed…

--

net: mana: track when the HWC has been handed to the PF

This adds a setup_active flag to struct hw_channel_context, set inside
mana_smc_setup_hwc() around the point where the ESTABLISH_HWC message is
published to the PF, and uses that flag instead of gc->max_num_cqs as the
gate for issuing DESTROY_HWC from mana_hwc_destroy_channel().

A few questions on the behaviour changes that come with this.

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index 263e7c4e29341..88e92e94e2e90 100644
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
> @@ -815,13 +815,13 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
>  	if (!hwc)
>  		return;
>  
> -	/* gc->max_num_cqs is set in mana_hwc_init_event_handler(). If it's
> -	 * non-zero, the HWC worked and we should tear down the HWC here.
> -	 */
> -	if (gc->max_num_cqs > 0) {
> -		mana_smc_teardown_hwc(&gc->shm_channel, false);
> -		gc->max_num_cqs = 0;
> +	if (hwc->setup_active) {
> +		if (!mana_smc_teardown_hwc(&gc->shm_channel, false))
> +			hwc->setup_active = false;

[Severity: Medium]

The changelog presents this as preparation work, but doesn't this hunk also
change behaviour on an existing failure path?

gc->max_num_cqs is only set once HWC_INIT_DATA_MAX_NUM_CQS arrives in
mana_hwc_init_event_handler(). So with the old gate, when ESTABLISH_HWC had
already been submitted but establish failed before that data arrived,
DESTROY_HWC was skipped entirely.

Two such cases in mana_hwc_establish_channel():

	if (!wait_for_completion_timeout(&hwc->hwc_init_eqe_comp, 60 * HZ))
		return -ETIMEDOUT;

and a failing mana_smc_read_response() inside mana_smc_setup_hwc(). In both
cases mana_hwc_create_channel() -> out: mana_hwc_destroy_channel() then went
on to free the EQ/CQ/RQ/SQ DMA memory whose frame addresses had already been
published to the PF.

mana_smc_teardown_hwc() documents why that ordering matters:

	/* Read shmem response (polling for VF possession) and validate.
	 * For teardown, waiting for response is required to ensure hardware
	 * invalidates MST entries before software frees memory.
	 */

Since the new gate closes that window, should this patch carry a Fixes: tag
and state that it fixes the skipped teardown, instead of being described as
tracking/preparation only?

> +		else
> +			dev_err(hwc->dev, "Failed to tear down HWC\n");
>  	}
> +	gc->max_num_cqs = 0;
>  
>  	if (hwc->txq)
>  		mana_hwc_destroy_wq(hwc, hwc->txq);

[Severity: High]

This isn't a bug introduced by this patch, since the pre-patch code ignored
the mana_smc_teardown_hwc() return value as well, but the new gate makes the
failing-teardown case reachable for every submitted-but-unconfirmed
establish, so it seems worth asking about here.

On failure the return value is only logged, setup_active is left true, and
execution falls straight through to:

	if (hwc->txq)
		mana_hwc_destroy_wq(hwc, hwc->txq);

	if (hwc->rxq)
		mana_hwc_destroy_wq(hwc, hwc->rxq);

	if (hwc->cq)
		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);
	...
	kfree(hwc);

Those helpers reach mana_hwc_dealloc_dma_buf() and mana_gd_destroy_queue()
-> mana_gd_free_memory() (dma_free_coherent), releasing exactly the four
regions whose frame addresses were handed to the PF by the ESTABLISH_HWC
writel loop.

mana_smc_teardown_hwc() fails when mana_smc_poll_register() times out after
roughly 20 seconds because the PF never returns aperture possession, or when
mana_smc_read_response() reports an error or an invalid response. In that
state its own comment says the MST entries may still be valid:

	 * For teardown, waiting for response is required to ensure hardware
	 * invalidates MST entries before software frees memory.

Can the device then keep writing EQEs/CQEs into pages handed back to the
allocator, or into unmapped pages once the IOMMU mapping is gone? The EQ
MSI-X is also released while the PF may still raise it, and kfree(hwc) drops
the state that would be needed to retry the teardown later.

The commit message says "Resources are still freed if teardown fails" - what
makes freeing safe here, given the comment above?

> diff --git a/drivers/net/ethernet/microsoft/mana/shm_channel.c b/drivers/net/ethernet/microsoft/mana/shm_channel.c
> index d21b5db06e509..3cf6a9f8e32c4 100644
> --- a/drivers/net/ethernet/microsoft/mana/shm_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/shm_channel.c
> @@ -129,9 +129,12 @@ void mana_smc_init(struct shm_channel *sc, struct device *dev,
>  	sc->base = base;
>  }
>  
> +/* Requires no outstanding HWC handover. *submitted records possible PF
> + * ownership, including when setup fails after submission.
> + */
>  int mana_smc_setup_hwc(struct shm_channel *sc, bool reset_vf, u64 eq_addr,
>  		       u64 cq_addr, u64 rq_addr, u64 sq_addr,
> -		       u32 eq_msix_index)
> +		       u32 eq_msix_index, bool *submitted)
>  {

[ ... ]

> @@ -229,6 +234,7 @@ int mana_smc_setup_hwc(struct shm_channel *sc, bool reset_vf, u64 eq_addr,
>  	/* Write 256-message buffer to shared memory (final 32-bit write
>  	 * triggers HW to set possession bit to PF).
>  	 */
> +	*submitted = true;
>  	dword = (u32 *)shm_buf;
>  	for (i = 0; i < SMC_APERTURE_DWORDS; i++)
>  		writel(*dword++, sc->base + i * SMC_BASIC_UNIT);

[Severity: Medium]

setup_active is stored here (and cleared at function entry) and is
read/cleared in mana_hwc_destroy_channel(), with no lock and no
READ_ONCE()/WRITE_ONCE(). What serializes the two contexts?

mana_schedule_serv_work() queues the worker on the system workqueue:

	INIT_WORK(&mns_wk->serv_work, mana_serv_func);
	schedule_work(&mns_wk->serv_work);

Neither mana_gd_remove() nor mana_gd_cleanup_device() cancels or flushes it,
and the worker path mana_serv_reset() -> mana_gd_suspend()/mana_gd_resume()
-> mana_gd_setup() -> mana_hwc_create_channel() -> mana_smc_setup_hwc() runs
without device_lock, so it can overlap remove/shutdown/PM.

That gives this interleaving on the single shared-memory aperture:

CPU0 mana_smc_setup_hwc()
	*submitted = true;
	writel() loop			/* ESTABLISH_HWC handed to PF */
	mana_smc_read_response()	/* polling */

CPU1 mana_hwc_destroy_channel()
	if (hwc->setup_active) {			/* reads true */
		if (!mana_smc_teardown_hwc(...))	/* writels DESTROY_HWC */

Can CPU0 then consume the DESTROY_HWC request header written by CPU1 (a
bogus -EPROTO), or CPU1 consume the ESTABLISH_HWC response, leaving the
PF/VF handover state inconsistent while both also race on the plain
read-modify-write of setup_active?

With the old gc->max_num_cqs > 0 gate this window was closed by accident,
because the counter is still zero during the setup handover, so the destroy
path issued no shared-memory access at all.

The underlying unserialized create-versus-destroy of the HWC context
predates this patch, and later in the series mana_hwc_destroy_channel()
gains the comment "The caller must serialize setup and teardown operations".
Would it help to state that requirement in this patch, next to the new
setup_active field, since this is where the flag starts gating aperture
access?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260908035201.402424-1-longli%40microsoft.com
