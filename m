Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794552398;
	b=Bx7xsFnfbyvskYdM6Xm9mmJ6BRWqQ0Pifc44RjRHSAntfbpdwpHt1XtTivaz2LkgeyFv
	 ARsYqVGTahS2Akw9UFXRFa5AfDMIaX4yq4OePw4c2z8YfGcMzMNYzzEKRoIAa95zNiCtX
	 azG2UD351zfklfJ2ov3PMs1dha0SdSqAxCy5eTJTdu3/k+iN0rxi2iyre6owqTe/9qk5n
	 VbnTEg5kAKCgEnSmopJWy6TmCK4R8HknwArNIAwmyyB8B6QuKvKWU24dxHtcx8a8zOMhz
	 gypJu/w9n117fQ2mswsnU6bwCLEAM9RbkMzuYg3oz/3Z+N9Q16Swov/lNqC9OqPxy2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794552398;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=W9aNHR+9ho4lw5QATxSxxLNIpIaPX3iD6a7kircgoCs=;
	b=NmEx0VRHJKRNN0OPfa0EgZaFVDLxUuxLnD38uN7mlt59vK5Nij+mKW4plMYlYLqDRr68
	 R7ve0yqXTQHMjIa30OZSMBXu/UOgpCeXkrQhK/ZsdkQFyVbdR3WJ13wp6aVd4YqReS2ct
	 6zM3Ts0YpWvApwKrl61kVYWBG/jJuBi86YYZR7Y0+tktWhWTT+97NQVdtYqtHWMDeriBv
	 CTwVZXpINQCF1eJ2iXSg2Ro2irzn4tserraK3kqCbeEEOSyIGOGkkutTZChfw6QJhpFpj
	 wh1kdb1La1gKngh7hN7NjDoYPhq7DKGFKttfLGRP/gmssnein9q5RKwWCBKjMPFhm5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LwKTpf3P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B79B606A321;
	Fri, 13 Nov 2026 06:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LwKTpf3P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D90C1F000C5;
	Fri, 13 Nov 2026 06:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794552398;
	bh=W9aNHR+9ho4lw5QATxSxxLNIpIaPX3iD6a7kircgoCs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=LwKTpf3Pl/ImswHapdJdyngK7ea/Mgodbcfq5/aSqPmSg8HiZifSBFNpRwzNXHV0s
	 QdVz2pgN4/NwPx7PrTI9T7eBm3dwxX3e8XGIq6r1yWO4LfTe2IcUgllic75V/xoZH2
	 difq43mLCslA4tsBdPtxM4RmFZ3RggNcceIqUDwPle96YfhqbXdV+YAOQAdfqU06ol
	 LoixtSWRz4fOLeR+iNEJDhm5SlQMNxSts9+GQu95WiqXCI0CZ6n26vYtlSVZHT7AjM
	 JbvHjVNhHGyZIRwDyZG9KBam2O4IyikV7S/zk2P9x+5bsCHEl1nXzw32ie3QPh42rA
	 N3NR9tGEhl52w==
Subject: Re: [PATCH net-next v10 1/4] net: mana: prepare HWC ownership for
 safe reinitialization
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
Date: Fri, 13 Nov 2026 06:46:36 +0000
Message-ID: <179455239601.2199510.13335902064048081755@kernel.org>
In-Reply-To: <df083dc6ad8a8958398e04afe66ca2c5f4bfb040.1794208055.git.weh@linux.microsoft.com>
References: <df083dc6ad8a8958398e04afe66ca2c5f4bfb040.1794208055.git.weh@linux.microsoft.com>
X-sashiko-severity: Medium
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

Thank you for your contribution! Sashiko AI review found 6 potential
issue(s) to consider.

Critical: 0 · High: 0 (1) · Medium: 3 · Low: 3

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] An ESTABLISH_HWC that the PF explicitly rejects is still
  recorded as live PF ownership.
- [Medium] When DESTROY_HWC is not acknowledged, the retained HWC is
  eventually discarded through mana_gd_free_context() ->…
- [Medium] setup_active and the retained HWC mean 'the PF may still own
  the HWC queues', but a device reset never clears them, even though a…
- [Low] The commit is presented as preparation for dynamic HWC sizing,
  but it also fixes bugs that are reachable in the baseline driver.
- [Low] mana_gd_process_eqe() now drops two cases silently that used to
  WARN: a completion EQE whose CQ id is >= max_num_cqs…
- [Low] The new comment in mana_gd_process_eqe() says the IRQ RCU read-
  side section 'protects the table until HWC teardown has fenced its EQ…

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but the patch now
  documents RCU protection for cq_table in mana_gd_process_eqe(), and…

--

net: mana: prepare HWC ownership for safe reinitialization

This commit serializes ESTABLISH_HWC and DESTROY_HWC on the shared memory
channel and tracks PF ownership of the HWC queues with setup_active. When
DESTROY_HWC is not acknowledged, the HWC context is retained. It also
snapshots the bootstrap CQ count and id, publishes cq_table with
acquire/release ordering, and adds a final-disposal helper used when the
gdma_context is freed.

Link: https://lore.kernel.org/r/20260908035201.402424-2-longli@microsoft.com
Link: https://lore.kernel.org/r/20260908035201.402424-5-longli@microsoft.com
Link: https://lore.kernel.org/r/178910960115.219967.13830871915506436112@kernel.org
Link: https://lore.kernel.org/r/179196575238.434549.10775387794024020898@kernel.org
Link: https://lore.kernel.org/r/sashiko-outbox-170992@kernel.org

> Dynamic HWC queue sizing tears down the bootstrap queues and establishes a
> second channel before publishing it. Prepare the existing HWC ownership and
> teardown paths so that sequence cannot free or reuse state still reachable
> by either the PF or an EQ handler.

[Severity: Low]
The commit is described as preparation for dynamic HWC sizing. Several of
the changes, though, look like fixes for bugs that can be hit in the current
driver:

- mana_hwc_destroy_channel() ignored the return value of
  mana_smc_teardown_hwc(). It freed the HWC EQ/CQ/RQ/SQ DMA memory even
  when the PF never acknowledged DESTROY_HWC.

- mana_hwc_init_event_handler() wrote gd->gdma_context->max_num_cqs = val
  on every HWC_INIT_DATA_MAX_NUM_CQS event. A late event could raise the
  bound past the cq_table allocation and allow an out-of-bounds cq_table[]
  read in mana_gd_process_eqe().

- mana_hwc_establish_channel() used WARN_ON() on a CQ id and count supplied
  by the device.

- DESTROY_HWC was skipped whenever gc->max_num_cqs was 0, even after
  ESTABLISH_HWC had been submitted.

Could these be split out as separate fixes with Fixes: tags, or at least
described in the commit message, so they can be picked up for net and
stable?

> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> index ab942d5bfe058..8df130386da34 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c

[ ... ]

> @@ -796,11 +804,16 @@ static void mana_gd_process_eqe(struct gdma_queue *eq)
>  	switch (type) {
>  	case GDMA_EQE_COMPLETION:
>  		cq_id = eqe->details[0] & 0xFFFFFF;
> -		if (WARN_ON_ONCE(cq_id >= gc->max_num_cqs))
> +		/* The IRQ handler's RCU read-side section protects the table
> +		 * until HWC teardown has fenced its EQ and waited for readers.
> +		 */

[Severity: Low]
Does this comment match the teardown order? In mana_hwc_destroy_channel()
the table is withdrawn and freed before the HWC EQ is fenced:

	mana_hwc_clear_cq_table(gc);

	/* Fence the EQ before releasing the remaining HWC state. */
	if (hwc->cq)
		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);

mana_gd_fence_eq() is only called from inside mana_hwc_destroy_cq().

Readers are actually kept safe by the NULL release-store and the
synchronize_rcu() in mana_hwc_clear_cq_table(), not by an EQ fence.

Could the comment describe that instead? Otherwise a later change might
depend on an EQ fence that has not happened yet at this point.

> +		cq_table = smp_load_acquire(&gc->cq_table);
> +		if (!cq_table || cq_id >= READ_ONCE(gc->max_num_cqs))
>  			break;
>  
> -		cq = gc->cq_table[cq_id];
> -		if (WARN_ON_ONCE(!cq || cq->type != GDMA_CQ || cq->id != cq_id))
> +		cq = READ_ONCE(cq_table[cq_id]);
> +		if (!cq || WARN_ON_ONCE(cq->type != GDMA_CQ ||
> +					cq->id != cq_id))
>  			break;

[Severity: Low]
Two cases that used to WARN are now dropped silently: a completion for a CQ
id at or above max_num_cqs, and an empty cq_table slot. The commit message
does not mention this.

The comment in mana_destroy_txq() in mana_en.c still depends on the removed
WARN:

			/* Detach the CQ only after the WQ object is destroyed,
			 * so a completion EQE that arrives before then still
			 * finds the CQ in cq_table[] rather than hitting the
			 * WARN in mana_gd_process_eqe(). One grace period then
			 * covers both mana_gd_intr() and NAPI users.
			 */

Should that comment be updated, and should the commit message mention this
behavior change?

>  
>  		if (cq->cq.callback)

[Severity: High]
This is a pre-existing issue and was not introduced by this patch. Now that
the RCU protection of cq_table is documented here, though, mana_ib does not
seem to follow it. mana_ib_remove_cq_cb() in drivers/infiniband/hw/mana/cq.c
does:

	kfree(gc->cq_table[cq->queue.id]);
	gc->cq_table[cq->queue.id] = NULL;

The gdma_queue is freed before the slot is cleared, and nothing waits for a
grace period. mana_ib_destroy_cq() calls mana_ib_remove_cq_cb() before
mana_ib_gd_destroy_cq(), so the hardware CQ can still raise EQEs at that
point.

Can mana_gd_process_eqe() on another CPU load cq from cq_table[cq_id] and
then read cq->type, cq->id and cq->cq.callback from freed memory? That would
include calling through the freed callback pointer. In a CVM, the host could
also inject such EQEs.

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index fb9f38f65911c..9e0964072af9a 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c

[ ... ]

> @@ -759,6 +843,13 @@ int mana_hwc_create_channel(struct gdma_context *gc)
>  	u16 q_depth_max;
>  	int err;
>  
> +	/* Retry a retained context before assigning queues to the PF again. */
> +	if (gd->driver_data) {
> +		mana_hwc_destroy_channel(gc);
> +		if (gd->driver_data)
> +			return -ETIMEDOUT;
> +	}
> +

[Severity: Medium]
What happens to a retained context across a device reset? Only an
acknowledged DESTROY_HWC in mana_smc_teardown_hwc_locked() clears
setup_active, but a reset discards the PF-side HWC state anyway.

mana_serv_reset() does:

	mana_gd_suspend(pdev, PMSG_SUSPEND);

	msleep(MANA_SERVICE_PERIOD * 1000);

	ret = mana_gd_resume(pdev);
	if (ret == -ETIMEDOUT || ret == -EPROTO) {
		...
		mana_serv_rescan(pdev);

Suppose the SMC aperture reads as all-ones, or does not respond, while the
device is being serviced. mana_smc_poll_register() with reset=false treats
bit 31 as PF ownership and times out. mana_hwc_destroy_channel() then
retains the HWC instead of freeing it as it did before this patch.

On resume, mana_gd_resume()->mana_gd_setup()->mana_hwc_create_channel()
retries DESTROY_HWC for an HWC the reset already wiped, instead of creating
a new one.

If that retry fails, create returns -ETIMEDOUT and mana_serv_reset() falls
back to mana_serv_rescan(). That path also leaks the HWC DMA through
mana_gd_remove()->mana_gd_free_context().

Should a reset clear setup_active, or should this path use the reset-aware
SMC mode (reset_vf / SHMEM_VF_RESET_STATE)? Every caller currently passes
reset_vf=false.

[ ... ]

> @@ -852,9 +960,44 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
>  	kfree(hwc);
>  	gc->hwc.driver_data = NULL;
>  	gc->hwc.gdma_context = NULL;
> +}
>  
> -	vfree(gc->cq_table);
> -	gc->cq_table = NULL;
> +static void mana_hwc_free_retained_wq(struct hwc_wq *wq)
> +{
> +	if (!wq)
> +		return;
> +
> +	kfree(wq->msg_buf);
> +	kfree(wq->gdma_wq);
> +	kfree(wq);
> +}
> +
> +/* Final disposal after IRQ and service-work teardown, not a retry path.
> + * Free only software state: unacknowledged HWC DMA allocations stay live.
> + */
> +void mana_hwc_free_retained_channel(struct gdma_context *gc)
> +{
> +	struct hw_channel_context *hwc = gc->hwc.driver_data;
> +
> +	if (!hwc)
> +		return;
> +
> +	gc->hwc.driver_data = NULL;
> +	mana_hwc_clear_cq_table(gc);
> +
> +	if (hwc->cq) {
> +		kfree(hwc->cq->gdma_eq);
> +		kfree(hwc->cq->gdma_cq);
> +		kfree(hwc->cq->comp_buf);
> +		kfree(hwc->cq);
> +	}

[Severity: Medium]
These wrappers, together with wq->gdma_wq and wq->msg_buf in
mana_hwc_free_retained_wq(), hold the only mem_info.virt_addr and
dma_handle references to the coherent DMA of the HWC EQ, CQ, RQ and SQ
rings and both message buffers. After they are kfree()d,
mana_gd_free_memory() can never be called on those buffers.

Is there anything that bounds this leak? On the PCI probe path, a failure
with -ETIMEDOUT or -EPROTO frees gc via mana_gd_free_context() at free_gc.
It then schedules mana_dev_recovery_work, which probes again with a fresh
gc:

mana_gd_probe()
  mana_gd_setup()
    mana_hwc_create_channel()       /* ESTABLISH submitted, then fails */
      mana_hwc_destroy_channel()    /* DESTROY times out, retained */
  mana_gd_free_context()            /* wrappers freed, DMA leaked */
  schedule_delayed_work(&mana_dev_recovery_work.work, ...)

If a PF keeps hanging mid-transaction, does every recovery cycle leak
another set of HWC queues?

In mana_cdx_gd_remove(), cdx_clear_master() runs before
mana_gd_free_context(). On PCI remove, pci_disable_device() follows shortly
after it. Once bus mastering is off, could the retained DMA be freed
instead of leaked?

[ ... ]

> diff --git a/drivers/net/ethernet/microsoft/mana/shm_channel.c b/drivers/net/ethernet/microsoft/mana/shm_channel.c
> index d21b5db06e509..df9d05062dd57 100644
> --- a/drivers/net/ethernet/microsoft/mana/shm_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/shm_channel.c

[ ... ]

> @@ -229,6 +243,7 @@ int mana_smc_setup_hwc(struct shm_channel *sc, bool reset_vf, u64 eq_addr,
>  	/* Write 256-message buffer to shared memory (final 32-bit write
>  	 * triggers HW to set possession bit to PF).
>  	 */
> +	*submitted = true;
>  	dword = (u32 *)shm_buf;
>  	for (i = 0; i < SMC_APERTURE_DWORDS; i++)
>  		writel(*dword++, sc->base + i * SMC_BASIC_UNIT);

[Severity: Medium]
mana_hwc_establish_channel() passes &hwc->setup_active as submitted. What
happens when the PF explicitly rejects ESTABLISH_HWC?

For a well-formed response with a non-zero status, mana_smc_read_response()
returns -EPROTO:

	if (hdr.status != 0) {
		dev_err(sc->dev, "SMC operation failed: 0x%x\n", hdr.status);
		return -EPROTO;
	}

setup_active stays true in that case. mana_hwc_destroy_channel() then sends
DESTROY_HWC for a channel the PF said it never created.

If that DESTROY is also rejected or times out, the context stays in
gc->hwc.driver_data. Every later mana_hwc_create_channel() on this
gdma_context then only retries the teardown:

	if (gd->driver_data) {
		mana_hwc_destroy_channel(gc);
		if (gd->driver_data)
			return -ETIMEDOUT;
	}

Can this keep the HWC from coming back up on PM resume, or after
mana_serv_reset(), until the device is unbound? Should the flag be cleared
when the PF returns an explicit failure status, as opposed to an ambiguous
timeout?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1794208055.git.weh%40linux.microsoft.com
