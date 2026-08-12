Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A266320A00;
	Wed, 12 Aug 2026 23:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786578422; cv=none; b=YFeErtUKb/UIBm9twZyrq53cO4+scOpVhcZ+oiYS+8bpMEwDt1jBKzW3HFwjXQHa/mWxA+4XVrWbBKygNiq+NwiVRsXM9c5jr6fmjuau/1Ujz8OvA4xtYe7j8ypw80R8CELUmDeqL7QjwFSgtG1jl1QEY+ppSeaEV34+oXhTbgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786578422; c=relaxed/simple;
	bh=50ULJ9tZZ7khKB3f8aAm7XDe74rSn6I4XzpoOCetWfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kx/hcY4R/OXP2klSiwZM6Y3ejZyEy5eYFQwG05grXoYTdSfBanHY35RSqHpoy/AbxudFdosFp7SAHfta/suTpvzhlTANlif/Qn205Zo8eF64xF0eLHZyDPHB5GpnEvKPFDKhhLi3jsgXIzFkHSLusdcmQAcN/jfXu9PozbPN0hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ikhv7fJp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ikhv7fJp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C691F00A3D;
	Wed, 12 Aug 2026 23:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786578418;
	bh=fn2yMe/lTkO65NO0MYEj1Fz+T5QxcJXRX8oVbq3noEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ikhv7fJp5xO8JSl0sjvt/5gbLChnYCbgjRSlmmqYLreS5iyHvv/M0/x/Ae2XKol67
	 x361p4rnySw4crV5mHo5Defh3pubFFV9Z3x/l6e8kfNLXtDXW4GXZAQz1sDm9m2Oca
	 A+tlR6NAJILEuynoa+Qm36rNSaAU//2fwXP9hssdp3BzVHXkLo19Mjojb3sVPG+hMS
	 KJD8woScUHJ8+wiwBWAMVSKEm0LX1cO2gmxbhwavOnKyARNiVEl1m9aUUFbrRwG1np
	 JnU2RJdilx1+K/pWtGDKTYkyfpendowK/JXT+b6khmmKGUk/91WRn/1izabYP1jI9R
	 WV3bVBA5x4zJg==
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
Subject: Re: [PATCH net v6 5/7] net: mana: fix HWC teardown safety with setup_active flag and destroy ordering
Date: Wed, 12 Aug 2026 16:46:57 -0700
Message-ID: <20260812234657.2193564-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260811023823.2391255-6-longli@microsoft.com>
References: <20260811023823.2391255-6-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
---
net: mana: fix HWC teardown safety with setup_active flag and destroy ordering

This adds a setup_active flag to struct hw_channel_context to record that
mana_smc_setup_hwc() has activated device MST entries, reorders
mana_hwc_destroy_channel() so the HWC CQ (and with it the EQ IRQ
deregistration) is destroyed before the TXQ/RXQ buffers are freed, and
changes destroy_channel() to leak the HWC resources when
mana_smc_teardown_hwc() fails.

A few questions on the new flag placement and on the leak-on-failure
policy.

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index 5db8cfe2d8443..959886434d07f 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c

[ ... ]

> @@ -783,6 +784,20 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
>  
>  	init_completion(&hwc->hwc_init_eqe_comp);
>  
> +	/* Arm setup_active before issuing the setup command.
> +	 * mana_smc_setup_hwc() hands the queue PFNs to the PF, activating
> +	 * MST entries so the device can DMA into our queue buffers, before
> +	 * it can report a later failure such as a possession-poll timeout.
> +	 * Recording it up front guarantees the error path
> +	 * (mana_hwc_create_channel() -> mana_hwc_destroy_channel()) still
> +	 * tears the HWC down instead of freeing buffers the device may still
> +	 * write to.  Setting it for a rare pre-submission failure too is
> +	 * harmless -- the teardown is then a no-op the device ignores.  Do
> +	 * not also tear down here: a second teardown would double the
> +	 * hardware timeout on failure and mask the original error code.
> +	 */
> +	hwc->setup_active = true;
> +
>  	err = mana_smc_setup_hwc(&gc->shm_channel, false,
>  				 eq->mem_info.dma_handle,
>  				 cq->mem_info.dma_handle,

[Severity: High]

Is the claim that "the teardown is then a no-op the device ignores" true
for the most likely pre-submission failure?

mana_smc_setup_hwc() fails at its very first step, before anything is
written to the shared memory aperture:

drivers/net/ethernet/microsoft/mana/shm_channel.c:mana_smc_setup_hwc() {
	/* Ensure VF already has possession of shared memory */
	err = mana_smc_poll_register(sc->base, false);
	if (err) {
		dev_err(sc->dev, "Timeout when setting up HWC: %d\n", err);
		return err;
	}
	...
}

mana_smc_teardown_hwc() opens with the same poll:

drivers/net/ethernet/microsoft/mana/shm_channel.c:mana_smc_teardown_hwc() {
	/* Ensure already has possession of shared memory */
	err = mana_smc_poll_register(sc->base, false);
	if (err) {
		dev_err(sc->dev, "Timeout when tearing down HWC\n");
		return err;
	}
	...
}

So when the possession poll times out, no ESTABLISH_HWC message ever
reached the device, but setup_active is already set, the error path runs
mana_hwc_destroy_channel(), the teardown fails for the identical reason,
and the new "leaking resources" branch returns having freed nothing.

Does that leak the hwc struct, the inflight bitmap, the EQ/CQ/RQ/SQ gdma
queues with their dma_alloc_coherent buffers, comp_buf and both msg_buf
DMA buffers, in a case where the old gc->max_num_cqs > 0 gate skipped the
teardown entirely and freed everything?

Would arming the flag only after mana_smc_setup_hwc() returns success, or
distinguishing "message submitted" from "poll failed before submission",
avoid recording a teardown obligation the device never acquired?

[Severity: Medium]

This is a pre-existing issue and not introduced by this patch, but while
reading mana_hwc_establish_channel(): the bound check

	if (WARN_ON(cq->id >= gc->max_num_cqs))
		return -EPROTO;

	cq_table = vcalloc(gc->max_num_cqs, sizeof(*cq_table));
	...
	rcu_assign_pointer(cq_table[cq->id], cq);

re-reads both gc->max_num_cqs and cq->id after the check, while
mana_hwc_init_event_handler() writes both from EQ interrupt context
(HWC_INIT_DATA_MAX_NUM_CQS and HWC_INIT_DATA_CQID).

The later patch in this series, "net: mana: keep max_num_cqs immutable
once cq_table is allocated", snapshots both values into locals with
READ_ONCE() and commits gc->max_num_cqs once, so the check-then-use is
gone by the end of the series. Noted here only for completeness.

> @@ -869,6 +884,20 @@ int mana_hwc_create_channel(struct gdma_context *gc)
>  	u16 q_depth_max;
>  	int err;
>  
> +	/* A previous teardown may have failed and deliberately left the old
> +	 * HWC context reachable (see mana_hwc_destroy_channel()).  Retry the
> +	 * teardown now -- the device has since been reset -- before building
> +	 * a new channel, so we neither orphan the old context nor stack a
> +	 * second channel on one whose DESTROY_HWC never completed.  If it is
> +	 * still failing, return an error that steers mana_serv_reset() to a
> +	 * full PCI rescan instead of silently leaking another generation.
> +	 */
> +	if (gd->driver_data) {
> +		mana_hwc_destroy_channel(gc);
> +		if (gd->driver_data)
> +			return -ETIMEDOUT;
> +	}
> +
>  	hwc = kzalloc_obj(*hwc);
>  	if (!hwc)
>  		return -ENOMEM;

[Severity: High]

This retry is the only mechanism that can reclaim a retained generation.
Can it run on the probe failure path?

mana_hwc_destroy_channel() is void, so mana_gd_setup() cannot tell that
the teardown was incomplete and keeps unwinding, and mana_gd_probe() ends
at:

drivers/net/ethernet/microsoft/mana/gdma_main.c:mana_gd_probe() {
	...
free_gc:
	pci_set_drvdata(pdev, NULL);
	vfree(gc);
	...
}

That frees the gdma_context holding gd->driver_data and gc->shm_channel,
so DESTROY_HWC can never be issued for the retained context afterwards.
mana_gd_remove() also vfree()s gc after mana_gd_cleanup_device().

Since mana_gd_probe() schedules mana_dev_recovery_work every
MANA_SERVICE_PERIOD on -ETIMEDOUT, and mana_serv_reset() escalates to
mana_serv_rescan() (remove plus re-probe), does every cycle in which
DESTROY_HWC does not complete retain a fresh generation, paced by the PF?

For errnos other than -ETIMEDOUT/-EPROTO (for example the -ENOMEM from the
vcalloc in mana_hwc_establish_channel(), which now happens with
setup_active already armed) mana_serv_reset() does no rescan:

drivers/net/ethernet/microsoft/mana/gdma_main.c:mana_serv_reset() {
	ret = mana_gd_resume(pdev);
	if (ret == -ETIMEDOUT || ret == -EPROTO) {
		/* Perform PCI rescan on device if we failed on HWC */
		dev_err(&pdev->dev, "MANA service: resume failed, rescanning\n");
		mana_serv_rescan(pdev);
	...
}

Is the retained generation then abandoned with no recovery at all?

Would a bounded quarantine work better here, keeping at most one retained
generation reclaimed by the next successful teardown, or propagating the
teardown error so an owner of gc stays alive until reclamation is safe?

> @@ -926,11 +955,38 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
>  	if (!hwc)
>  		return;
>  
> -	/* gc->max_num_cqs is set in mana_hwc_init_event_handler(). If it's
> -	 * non-zero, the HWC worked and we should tear down the HWC here.
> +	/* Tear down the HWC if setup_hwc previously activated MST entries.
> +	 * This is the definitive flag — unlike max_num_cqs which depends
> +	 * on the init EQE arriving.
> +	 *
> +	 * If teardown fails the device may still have active MST entries
> +	 * and can DMA into the HWC queue buffers.  Freeing them would risk
> +	 * memory corruption on systems without an IOMMU to fault the stale
> +	 * DMA, so leak the HWC resources instead of handing the pages back
> +	 * to the allocator.  Keep setup_active set so the failure is not
> +	 * mistaken for a clean teardown.
>  	 */
> -	if (gc->max_num_cqs > 0)
> -		mana_smc_teardown_hwc(&gc->shm_channel, false);
> +	if (hwc->setup_active) {
> +		int td_err = mana_smc_teardown_hwc(&gc->shm_channel, false);
> +
> +		if (td_err) {
> +			dev_err(gc->dev,
> +				"HWC teardown failed: %d, leaking resources\n",
> +				td_err);
> +			return;
> +		}
> +
> +		hwc->setup_active = false;
> +	}

[Severity: Low]

This return is taken before mana_hwc_destroy_cq(), so the HWC EQ stays on
gic->eq_list and the CQ stays published in gc->cq_table while
mana_gd_cleanup_device() goes on to mana_gd_remove_irqs().

This does not appear to be a use-after-free. The HWC EQ registration takes
no gdma_irq_context reference:

drivers/net/ethernet/microsoft/mana/gdma_main.c:mana_gd_register_irq() {
	/* The caller acquired a GIC reference via mana_gd_get_gic().
	 * That refcount prevents mana_gd_put_gic() from erasing this
	 * irq_contexts entry concurrently.
	 */
	gic = xa_load(&gc->irq_contexts, msix_index);
	...
}

so mana_gd_put_gic() reaches refcount_dec_and_test() and calls free_irq(),
which unregisters mana_gd_intr() and waits out in-flight handlers before
any vfree(gc). In the window before that, an interrupt would only touch
the EQ/CQ/RQ/TXQ buffers this branch deliberately did not free.

What is left is stale state: the EQ's list node ends up pointing into a
kfree()d gic, and on a later retried teardown after a resume whose
mana_gd_setup() failed before mana_gd_setup_hwc_irqs(),
mana_gd_deregister_irq() can hit

	msix_index = queue->eq.msix_index;
	if (WARN_ON(msix_index >= gc->num_msix_usable))
		return;

with num_msix_usable == 0 and skip the list_del_rcu()/synchronize_rcu()
before the EQ is freed. Would it be reasonable to deregister the EQ IRQ
before taking the leak branch, so the retained buffers are unreachable
from the interrupt path even in the failure case?

> +
> +	/* Tear down the HWC CQ object first — mana_hwc_destroy_cq()
> +	 * both unpublishes the CQ from cq_table (+synchronize_rcu) and
> +	 * deregisters the HWC EQ from the interrupt handler list (via
> +	 * mana_gd_deregister_irq + synchronize_rcu), guaranteeing no
> +	 * interrupt handler can access RQ/TXQ buffers after this point.
> +	 */
> +	if (hwc->cq)
> +		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);
>  
>  	if (hwc->txq)
>  		mana_hwc_destroy_wq(hwc, hwc->txq);

[ ... ]

> diff --git a/include/net/mana/hw_channel.h b/include/net/mana/hw_channel.h
> index 787c6f96d5b57..8340abd36af61 100644
> --- a/include/net/mana/hw_channel.h
> +++ b/include/net/mana/hw_channel.h
> @@ -206,6 +206,15 @@ struct hw_channel_context {
>  	 */
>  	u32 rx_leaked_wqe;
>  
> +	/* Set after mana_smc_setup_hwc() succeeds (hardware has active
> +	 * MST entries).  Cleared only after mana_smc_teardown_hwc()
> +	 * succeeds, on both the recoverable establish_channel path and the
> +	 * terminal destroy_channel path.  If teardown fails it stays set:
> +	 * establish_channel() skips its retry and destroy_channel() leaks
> +	 * the HWC rather than free buffers the device may still DMA into.
> +	 */
> +	bool setup_active;
> +

[Severity: Low]

This isn't a runtime bug, but this comment describes different code than
what the patch implements, and it also contradicts the in-code comment
added to mana_hwc_establish_channel():

"Set after mana_smc_setup_hwc() succeeds" - mana_hwc_establish_channel()
sets it before the call and leaves it set when the call fails.

"Cleared only after mana_smc_teardown_hwc() succeeds, on both the
recoverable establish_channel path and the terminal destroy_channel path" -
mana_hwc_establish_channel() has no mana_smc_teardown_hwc() call and never
clears the flag; the single teardown call site and the single clear are
both in mana_hwc_destroy_channel().

"establish_channel() skips its retry" - mana_hwc_establish_channel() has no
retry.

Are these leftovers from the earlier version of the patch that tore down
inline? Could the comment be updated to match the current placement, so a
later reader does not move the assignment below mana_smc_setup_hwc() and
reopen the window this patch closes?

>  	struct hwc_caller_ctx *caller_ctx;
>  };
