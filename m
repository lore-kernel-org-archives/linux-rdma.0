Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558ED48A2A0;
	Thu,  6 Aug 2026 17:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786037048; cv=none; b=NUCXcD66rSgjNF6XJIlkWKbepzkO8TyVUGOILprPu9ur3tKZWc8n3hNzT6D0H7I/YVCozLJ5EtD86e2mzkh6cMIiUUrn1D8TdzqQvF2ZVGD+ub1PbnHrlF1AHzLrq1czWuxZYXpTOUzhl86E47C+IKDyVjTAvsodz78cIc7uX78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786037048; c=relaxed/simple;
	bh=igc+Ne4W0w/fdOjIFXNX4qAvDMLNpjWKQQG35Px3or8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hecSU0qJflBFzPXrVbcaOWECulJBgQSNSTfyKyoWD4dCjJ/zqTBL/z7ce5CK23ADB5qgdcvBIbR93rohf3dPifMOyfDik0X6btnLttF/SJEe45MM8P/hYV6KlvbudabJUEKWmKJ9d0ENq9HVZA20/sba22hpGaeVmBonmM1o0w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mn0dgjpP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mn0dgjpP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13ABA1F000E9;
	Thu,  6 Aug 2026 17:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786037044;
	bh=PAN8QAW9NL5f+K+LGGQbeQzSnLMqBMVSyIIXg2nIKqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mn0dgjpPd61/Ci6WBZaPZBVMB8FFyn1hCEJk056UGDk/vRMWmN6SWsvydR0Q/kES4
	 bS0NlnxOMgaXfbZ+UtSRb+feIvzptFfCbRZssmrWsH3ADvvrJyWKsQJ3m4BTtvjbqM
	 Va/4d4a5sRADLybZ1uuJmVbUS3dq9tVWSJe8aeKHXyPF69vBKQAO+GduuOoTQIBF/l
	 UjQN1m6v5mogQumqL6xhbTpQTJqI8vg2wVlrHjdzMXFFAQ0Kct11Tfed2XH9q8XwOO
	 qtXhycoL53rXYPMbjALXKzbOdibUhwoqs848edOcVHMR63R/hd6Zx022Rm7zjKazhA
	 8jh7boY7zhRKA==
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
Subject: Re: [PATCH net v3 5/6] net: mana: fix HWC teardown safety with setup_active flag and destroy ordering
Date: Thu,  6 Aug 2026 10:24:02 -0700
Message-ID: <20260806172402.2946057-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260803234355.636038-6-longli@microsoft.com>
References: <20260803234355.636038-6-longli@microsoft.com>
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

This adds a setup_active flag to struct hw_channel_context so the driver
knows when the device has live MST entries, reorders
mana_hwc_destroy_channel() to destroy the HWC CQ (and thereby deregister
the EQ) before freeing the TXQ/RXQ buffers, and leaks the HWC resources
when mana_smc_teardown_hwc() fails instead of freeing memory the device
may still DMA into.

A few questions on the new error paths below.

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index e378b8ec97c9a..1603968d7989a 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c

[ ... ]

> @@ -768,20 +769,33 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
>  	if (err)
>  		return err;
>  
> -	if (!wait_for_completion_timeout(&hwc->hwc_init_eqe_comp, 60 * HZ))
> -		return -ETIMEDOUT;
> +	/* setup_hwc activated MST entries — hardware can now DMA into
> +	 * our queue buffers.  If anything below fails, we must tear
> +	 * down before returning so the caller doesn't need to track
> +	 * whether setup_hwc succeeded.
> +	 */
> +	hwc->setup_active = true;

[Severity: High]
This isn't a bug introduced by this patch, but now that setup_active is
the only gate for sending DESTROY_HWC, is the flag armed late?

mana_smc_setup_hwc() in shm_channel.c publishes the EQ/CQ/RQ/SQ frame
addresses to the PF with the last of its writel()s, and only then polls
for the response:

	/* Write 256-message buffer to shared memory (final 32-bit write
	 * triggers HW to set possession bit to PF).
	 */
	dword = (u32 *)shm_buf;
	for (i = 0; i < SMC_APERTURE_DWORDS; i++)
		writel(*dword++, sc->base + i * SMC_BASIC_UNIT);
	...
	err = mana_smc_read_response(...);
	if (err) {
		dev_err(sc->dev, "Error when setting up HWC: %d\n", err);
		return err;
	}

So an error return here does not mean the request never reached the PF.
mana_smc_read_response() can return -ETIMEDOUT after the 20 s poll in
mana_smc_poll_register() (the PF still owns shmem while it processes the
establish) or -EPROTO on a non-zero status.

In that case mana_hwc_establish_channel() returns with setup_active still
false, and the cleanup path frees the very buffers whose addresses were
handed to the PF:

mana_hwc_create_channel()
  out: mana_hwc_destroy_channel()
         if (hwc->setup_active)      /* false, no DESTROY_HWC is sent */
         mana_hwc_destroy_cq()       /* frees EQ/CQ DMA buffers */
         mana_hwc_destroy_wq()       /* frees RQ/SQ DMA buffers */

Should the flag be set before mana_smc_setup_hwc() is called, or on an
ambiguous failure, so that DESTROY_HWC is still attempted in this window?

>  
>  	*q_depth = hwc->hwc_init_q_depth_max;
>  	*max_req_msg_size = hwc->hwc_init_max_req_msg_size;
>  	*max_resp_msg_size = hwc->hwc_init_max_resp_msg_size;
>  
>  	/* Both were set in mana_hwc_init_event_handler(). */
> -	if (WARN_ON(cq->id >= gc->max_num_cqs))
> -		return -EPROTO;
> +	if (WARN_ON(cq->id >= gc->max_num_cqs)) {
> +		err = -EPROTO;
> +		goto teardown;
> +	}
>  
>  	cq_table = vcalloc(gc->max_num_cqs, sizeof(*cq_table));
> -	if (!cq_table)
> -		return -ENOMEM;
> +	if (!cq_table) {
> +		err = -ENOMEM;
> +		goto teardown;
> +	}
>  
>  	rcu_assign_pointer(cq_table[cq->id], cq);
>  	/* Publish the fully-initialised table last; pairs with the
> @@ -790,6 +804,16 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
>  	rcu_assign_pointer(gc->cq_table, cq_table);
>  
>  	return 0;
> +
> +teardown:
> +	{
> +		int td_err = mana_smc_teardown_hwc(&gc->shm_channel, false);
> +
> +		if (!td_err)
> +			hwc->setup_active = false;
> +
> +		return td_err ? td_err : err;
> +	}
>  }

[ ... ]

> @@ -907,11 +931,38 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
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

[Severity: Medium]
Does this early return also leak the objects the hardware cannot reach?

It skips the whole tail of mana_hwc_destroy_channel():

	kfree(hwc->caller_ctx);
	hwc->caller_ctx = NULL;
	mana_gd_free_res_map(&hwc->inflight_msg_res);
	...
	kfree(hwc);
	gc->hwc.driver_data = NULL;
	gc->hwc.gdma_context = NULL;

	old_cq_table = rcu_replace_pointer(gc->cq_table, NULL, true);
	synchronize_rcu();
	vfree(old_cq_table);

The comment in hw_channel.h calls this "the terminal destroy_channel
path", but mana_gd_cleanup_device() is also reached from
mana_gd_suspend(), from the mana_gd_probe() error path and from the
mana_gd_resume() error path, all on the same gdma_context.
mana_serv_reset() runs mana_gd_suspend() followed by mana_gd_resume()
exactly when the HWC is not responding (it sets hwc->hwc_timeout = 0),
which is when the DESTROY_HWC poll is most likely to time out.

On the following re-create, mana_hwc_create_channel() drops the last
pointer to the abandoned context:

	hwc = kzalloc_obj(*hwc);
	...
	gd->driver_data = hwc;

so hwc, hwc->caller_ctx and the inflight_msg bitmap become unreachable,
and mana_hwc_establish_channel() ends with a bare

	rcu_assign_pointer(gc->cq_table, cq_table);

which neither captures, synchronize_rcu()s nor vfree()s the table still
published by the previous instance. Would that leak one vcalloc'd
max_num_cqs table per failed reset cycle?

That also seems to differ from the contract this patch adds in gdma.h,
which says the base table is "replaced+freed only by
mana_hwc_destroy_channel() (and the create-time reinit)" — the
create-time reinit only replaces it. Would freeing these after
mana_gd_remove_irqs(), or at least having establish_channel() free or
warn on an already-published cq_table, keep the two consistent?

> +
> +		hwc->setup_active = false;
> +	}
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
> @@ -919,17 +970,6 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
>  	if (hwc->rxq)
>  		mana_hwc_destroy_wq(hwc, hwc->rxq);
>  
> -	if (hwc->cq)
> -		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);
> -
> -	/* Reset only after mana_hwc_destroy_cq() above has run with a valid
> -	 * max_num_cqs so mana_gd_destroy_cq() clears the CQ table slot and
> -	 * waits out in-flight EQ handlers (synchronize_rcu) before the CQ is
> -	 * freed.  Clearing it earlier would make that path early-return and
> -	 * skip the slot clear, leaving a dangling cq_table entry.
> -	 */
> -	gc->max_num_cqs = 0;
> -
>  	kfree(hwc->caller_ctx);
>  	hwc->caller_ctx = NULL;
>  
> diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
> index 0b48ded0aecda..74eccc80cf6b4 100644
> --- a/include/net/mana/gdma.h
> +++ b/include/net/mana/gdma.h
> @@ -416,7 +416,13 @@ struct gdma_context {
>  	/* L2 MTU */
>  	u16 adapter_mtu;
>  
> -	/* This maps a CQ index to the queue structure. */
> +	/* Size of cq_table, i.e. the largest valid CQ index + 1.  Set once
> +	 * when cq_table is allocated and treated as immutable for the
> +	 * table's lifetime (a bound only) -- it is never reset on teardown.
> +	 * cq_table == NULL is the sole "table torn down" signal, so every
> +	 * cq_table[id] access must guard with both !cq_table (gone) and
> +	 * id >= max_num_cqs (out of bounds).
> +	 */
>  	unsigned int		max_num_cqs;

[Severity: High]
This is a pre-existing issue, but is the "set once ... treated as
immutable" invariant actually enforced anywhere?

The only writer is mana_hwc_init_event_handler(), which stores the
device-supplied EQE payload unconditionally, with no check that
gc->cq_table is already non-NULL:

	case HWC_INIT_DATA_MAX_NUM_CQS:
		gd->gdma_context->max_num_cqs = val;
		break;

The size passed to vcalloc(gc->max_num_cqs, sizeof(*cq_table)) in
mana_hwc_establish_channel() is not recorded anywhere else, and the HWC
EQ callback stays registered for the channel's whole lifetime, so a later
GDMA_EQE_HWC_INIT_DATA event can raise the bound above the allocated
size. Then in mana_gd_process_eqe(), in hard IRQ context:

	cq_table = rcu_dereference(gc->cq_table);
	if (WARN_ON_ONCE(cq_id >= gc->max_num_cqs || !cq_table))
		break;

	cq = rcu_dereference(cq_table[cq_id]);
	if (WARN_ON_ONCE(!cq || cq->type != GDMA_CQ || cq->id != cq_id))

Can this read past the end of the vmalloc'd array and then dereference
whatever pointer-sized value it found (cq->type, cq->id, and on success
the indirect call cq->cq.callback)? The same bound guards the
rcu_assign_pointer() writes in mana_create_txq()/mana_create_rxq() and in
mana_ib_install_cq_cb():

	cq_table = rcu_dereference_protected(gc->cq_table, true);
	if (!cq_table || cq->queue.id >= gc->max_num_cqs)
		return -EINVAL;

Given that this patch makes the bound load-bearing by removing its reset,
would it be worth latching the allocated size in its own field, or
ignoring HWC_INIT_DATA_MAX_NUM_CQS once cq_table is non-NULL, alongside
the new documentation?

> diff --git a/include/net/mana/hw_channel.h b/include/net/mana/hw_channel.h
> index 73671f479399a..3d8543acb5cc0 100644
> --- a/include/net/mana/hw_channel.h
> +++ b/include/net/mana/hw_channel.h
> @@ -200,6 +200,15 @@ struct hw_channel_context {
>  	u32 pf_dest_vrcq_id;
>  	u32 hwc_timeout;
>  
> +	/* Set after mana_smc_setup_hwc() succeeds (hardware has active
> +	 * MST entries).  Cleared only after mana_smc_teardown_hwc()
> +	 * succeeds, on both the recoverable establish_channel path and the
> +	 * terminal destroy_channel path.  If teardown fails it stays set:
> +	 * establish_channel() skips its retry and destroy_channel() leaks
> +	 * the HWC rather than free buffers the device may still DMA into.
> +	 */
> +	bool setup_active;

[Severity: Medium]
setup_active records device-scoped state (MST entries programmed for this
VF), but it lives in the per-instance hw_channel_context. Does the leak
path lose that record?

After the teardown failure, mana_hwc_destroy_channel() returns with
setup_active still true on a context that mana_gd_cleanup_device() then
walks away from (it also goes on to call mana_gd_remove_irqs()). On the
next attempt:

mana_gd_resume()
  mana_gd_setup()
    mana_hwc_create_channel()
      hwc = kzalloc_obj(*hwc);      /* setup_active == false */
      gd->driver_data = hwc;        /* old context dropped */
      mana_hwc_establish_channel()  /* second ESTABLISH_HWC */

Since shm_channel.c pairs ESTABLISH_HWC with DESTROY_HWC, does this leave
the first HWC's MST entries armed for the device's lifetime, with a later
clean teardown sending only one DESTROY_HWC? That looks like it defeats
the stated intent that "the failure is not mistaken for a clean
teardown".

Would keeping the flag in struct gdma_context (which survives
suspend/resume, as shm_channel does), or refusing to re-establish while a
previous HWC is known live, keep the driver's record in step with the
device?

Cross-instance finding from sashiko-gemini (b1a5d3a1fd2b96eddef89c85fad512dd15f2a00ad5dda70d873898d2dd806258):
[Severity: Medium]
Redundant HWC teardown in `mana_hwc_establish_channel()` causes a double hardware timeout (up to 120s stall) and masks the original initialization error code.
