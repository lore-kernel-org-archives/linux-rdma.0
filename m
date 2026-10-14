Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEAB32DF12F;
	Wed, 14 Oct 2026 08:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791965760; cv=none; b=OHfvfna/p8vRgeDbHlIw9RlFCTxBRmyVM84G4XmZolCwkVptDVM042hh+GUnHUFNpmAvotdlJxVBJc87CbNYE1P/DbDKiITwNe/ttjnaDXIDL8MFTNiEtg10FyUSRp/SuvvKq+K0HsdLXwfICsNgrAaljfbkgRVI7pJOIYZFQWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791965760; c=relaxed/simple;
	bh=2jHraSM8gerMveGFk6yAHU5tsQJcGHpyjshG8LI/98w=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LmC+AhtNu/KnABMsxhqjujciFiz5AOu7x4iI9prkWMYulCEr35GLlNn+q5YqijQR9zKgkkFZQPhdoUNrrQ0JXthDb/a2drb87oFrafRVAKBaHQmvISXhXEyPPPBItH96cPP0Acq4il8Qb6XDnt/jcyh4QaGRSfe+QOKWlQqILxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NmzWUG4i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NmzWUG4i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF55F1F000FF;
	Wed, 14 Oct 2026 08:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791965754;
	bh=6J+b/MSX0XJJ5rJPg1yYa1sWErOsZtUUW8k1SqTEZ+k=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=NmzWUG4iBN4O+O2elROqR+/b0XqswNVkOKOSqndbzGpntY25wk1Ik+/FNS4kOooK3
	 2QUThz0QbXDW07x5xKr9aoxAxxagFryws3KgJaUA1A8MalhGR5ZA5RitqJg8jCjtLC
	 uF1i5qna+V4iq5wYduw0qhU9oSqWw+gvpp8knjn5VcmiiLKgGurRxc5wXQlZsakeRB
	 TbycszVNw1jztneQZsjmX03chv/MvExLmaRrQyaSx2n+CQ/OQiKX0A1GTrhj2qGeP/
	 0we8e79vB4CGDsOl1M7rc4Dq7Yh3IwaRyqmXNIXwuqB+xvmu4eV5H900Jf/xjZZQrP
	 NqdEahv+fEz7Q==
Subject: Re: [PATCH net-next v7 1/4] net: mana: prepare HWC ownership for safe
 reinitialization
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
Date: Wed, 14 Oct 2026 08:15:52 +0000
Message-ID: <179196575238.434549.10775387794024020898@kernel.org>
In-Reply-To: =?utf-8?q?=3Ce6ef84d7481de34f259d2b244f7994e3f1d9ab6f=2E1791561?=
 =?utf-8?q?995=2Egit=2Eweh=40linux=2Emicrosoft=2Ecom=3E?=
References: =?utf-8?q?=3Ce6ef84d7481de34f259d2b244f7994e3f1d9ab6f=2E17915619?=
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

Critical: 0 · High: 0 (2) · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] When DESTROY_HWC is not acknowledged,
  mana_hwc_destroy_channel() only calls mana_hwc_fence_channel() and…
- [Low] The commit is described as preparation for dynamic HWC queue
  sizing, but it fixes real bugs in the existing single-channel code.

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but it breaks the
  reader lifetime model the patch documents.
- [High] This problem wasn't introduced by this patch.

--

net: mana: prepare HWC ownership for safe reinitialization

This patch serializes the ESTABLISH_HWC and DESTROY_HWC shared-memory
transactions with a mutex. It tracks PF ownership with setup_active, and
when DESTROY_HWC is not acknowledged it fences the HWC context but does
not free it. It also snapshots the bootstrap CQ count and id, publishes
cq_table with release/acquire ordering, frees the table only after an RCU
grace period, and destroys the HWC EQ before the CQ and completion buffer.

Link: https://lore.kernel.org/r/20260908035201.402424-2-longli@microsoft.com
Link: https://lore.kernel.org/r/20260908035201.402424-5-longli@microsoft.com
Link: https://lore.kernel.org/r/178910960115.219967.13830871915506436112@kernel.org

> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> index ae0ed700b3b93..69da65a405a46 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c

[ ... ]

> @@ -765,11 +766,16 @@ static void mana_gd_process_eqe(struct gdma_queue *eq)
>  	switch (type) {
>  	case GDMA_EQE_COMPLETION:
>  		cq_id = eqe->details[0] & 0xFFFFFF;
> -		if (WARN_ON_ONCE(cq_id >= gc->max_num_cqs))
> +		/* The IRQ handler's RCU read-side section protects the table
> +		 * until HWC teardown has fenced its EQ and waited for readers.
> +		 */
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
>  
>  		if (cq->cq.callback)

[Severity: High]
This isn't a bug introduced by this patch, but it affects the lifetime
model this comment describes. The comment says table readers are protected
only by the IRQ handler's RCU read-side section. The reader dereferences
cq->type, cq->id and cq->cq.callback without taking a reference.

Does mana_ib follow that model? mana_ib_remove_cq_cb() in
drivers/infiniband/hw/mana/cq.c also writes to this table:

	kfree(gc->cq_table[cq->queue.id]);
	gc->cq_table[cq->queue.id] = NULL;

It frees the object before clearing the slot and never waits for a grace
period. mana_ib_destroy_cq() calls it before the hardware CQ is destroyed,
so the CQ can still raise completion EQEs:

	mana_ib_remove_cq_cb(mdev, cq);

	/* Ignore return code as there is not much we can do about it.
	 * The error message is printed inside.
	 */
	mana_ib_gd_destroy_cq(mdev, cq);

Say an EQ interrupt on another CPU has already loaded the slot here. Can
it then read freed memory and call through cq->cq.callback? A local RDMA
user can reach this by calling ibv_destroy_cq() on an armed CQ.

mana_ib_install_cq_cb() also publishes the object with a plain store:

	gc->cq_table[cq->queue.id] = gdma_cq;

There is no release ordering. On weakly ordered architectures such as
arm64, could the READ_ONCE() reader above see the pointer before type, id
and callback are initialized?

The series does not change cq.c.

[Severity: High]
This is also a pre-existing issue, not introduced by this patch. The cq_id
here comes from the device's EQE. Nothing checks that cq->cq.parent is the
EQ that delivered the event.

The generic destroy path, mana_gd_destroy_queue()->mana_gd_destroy_cq(),
only does this:

	gc->cq_table[id] = NULL;

Then mana_gd_destroy_queue() frees the queue memory and calls
kfree(queue) without waiting for a grace period.

mana_dealloc_queues() frees the datapath CQs while their parent EQs and
the HWC EQ are still registered:

	mana_destroy_rxqs(apc);
	mana_destroy_txq(apc);
	mana_destroy_eq(apc);

Suppose an EQ interrupt on another CPU loaded the CQ pointer before the
slot was cleared. Could it then read cq->type, cq->id and cq->cq.callback
from freed memory and call the callback? The EQE could be stale, or a
malicious host could post a datapath CQ id on the HWC EQ.

The synchronize_rcu() added in mana_hwc_destroy_channel() only protects
the cq_table allocation itself.

For the HWC CQ, the mana and mana_ib EQs are destroyed in mana_remove()
and mana_rdma_remove() before mana_gd_cleanup(). So the HWC claim in the
commit message holds under normal ordering.

[ ... ]

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index 3bca4b683134b..b1d972968f0d7 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c

[ ... ]

> @@ -382,16 +386,49 @@ static void mana_hwc_comp_event(void *ctx, struct gdma_queue *q_self)
>  	mana_gd_ring_cq(q_self, SET_ARM_BIT);
>  }
>  
> -static void mana_hwc_destroy_cq(struct gdma_context *gc, struct hwc_cq *hwc_cq)
> +static int mana_hwc_publish_cq(struct gdma_context *gc,
> +			       struct gdma_queue *cq)
>  {
> -	kfree(hwc_cq->comp_buf);
> +	struct gdma_queue **cq_table = READ_ONCE(gc->cq_table);
> +	u32 id = READ_ONCE(cq->id);
>  
> -	if (hwc_cq->gdma_cq)
> -		mana_gd_destroy_queue(gc, hwc_cq->gdma_cq);

[ ... ]

> +static void mana_hwc_destroy_cq(struct gdma_context *gc, struct hwc_cq *hwc_cq)
> +{
> +	/* Destroy the EQ first: it deregisters the IRQ and drains in-flight
> +	 * handlers, so none can touch the CQ after it is freed.
> +	 */
>  	if (hwc_cq->gdma_eq)
>  		mana_gd_destroy_queue(gc, hwc_cq->gdma_eq);
>  
> +	/* Safe to free now that the EQ handler is fenced. */
> +	if (hwc_cq->gdma_cq)
> +		mana_gd_destroy_queue(gc, hwc_cq->gdma_cq);
> +
> +	kfree(hwc_cq->comp_buf);
>  	kfree(hwc_cq);
>  }

[Severity: Low]
The commit message calls this preparation for dynamic HWC queue sizing.
This reordering also seems to fix a use-after-free in the existing
single-channel code.

Before this patch, mana_hwc_destroy_cq() freed comp_buf and then the CQ.
The IRQ was only deregistered later, when the EQ was destroyed. An HWC EQ
interrupt could arrive in that window. One example is the
mana_hwc_create_channel() failure unwind after ESTABLISH_HWC timed out
while the PF was still live. The interrupt could then run
mana_hwc_comp_event()->mana_gd_poll_cq() on the freed comp_buf.

The old mana_hwc_destroy_channel() also ignored the return value of
mana_smc_teardown_hwc(). It freed the PF-visible EQ/CQ/RQ/SQ DMA memory
even when DESTROY_HWC was not acknowledged.

The old WARN_ON(cq->id >= gc->max_num_cqs) in
mana_hwc_establish_channel() could also be triggered by the host, which
panics a guest booted with panic_on_warn.

Could these fixes be split out with Fixes: tags, so they can go to net and
stable separately from the reinitialization preparation?

[ ... ]

> @@ -759,6 +829,13 @@ int mana_hwc_create_channel(struct gdma_context *gc)
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
>  	hwc = kzalloc_obj(*hwc);

[ ... ]

> @@ -808,30 +885,56 @@ int mana_hwc_create_channel(struct gdma_context *gc)

[ ... ]

>  void mana_hwc_destroy_channel(struct gdma_context *gc)
>  {
>  	struct hw_channel_context *hwc = gc->hwc.driver_data;
> +	struct gdma_queue **old_cq_table;
> +	int err;
>  
>  	if (!hwc)
>  		return;
>  
> -	/* gc->max_num_cqs is set in mana_hwc_init_event_handler(). If it's
> -	 * non-zero, the HWC worked and we should tear down the HWC here.
> +	/* An unacknowledged destroy leaves the PF's mappings live.  Fence
> +	 * software dispatch, but retain every PF-visible allocation.
>  	 */
> -	if (gc->max_num_cqs > 0) {
> -		mana_smc_teardown_hwc(&gc->shm_channel, false);
> -		gc->max_num_cqs = 0;
> +	err = mana_smc_teardown_hwc(&gc->shm_channel, false,
> +				    &hwc->setup_active);
> +	if (err) {
> +		dev_err(hwc->dev,
> +			"HWC teardown failed: %d, retaining PF-visible resources\n",
> +			err);
> +		mana_hwc_fence_channel(gc, hwc);
> +		return;
>  	}

[Severity: Medium]
Does this leak the retained hw_channel_context when the gdma_context
itself is freed?

On this path gc->hwc.driver_data still points at hwc. The only code that
releases it is the retry at the top of mana_hwc_create_channel(), and that
only runs if the same gc is set up again. mana_gd_cleanup() returns as if
teardown had completed and does not tell its callers that a context was
retained.

mana_gd_remove() in gdma_pci.c then does:

	mana_gd_cleanup(gc);

	xa_destroy(&gc->irq_contexts);

	pci_iounmap(pdev, gc->bar0_va);

	vfree(gc);

The mana_gd_probe() unwind does the same through its free_gc label. On an
unresponsive HWC, mana_serv_reset() goes through suspend, then resume
returns -ETIMEDOUT, then mana_serv_rescan() removes the device.

Each of these paths loses the following:

  hwc
  caller_ctx
  the inflight_msg_res bitmap
  the gc->cq_table vmalloc
  comp_buf
  the hwc_cq/hwc_wq/gdma_queue wrappers
  the DMA-coherent queue and message buffers

The PF can never reach the software-only allocations, so keeping them
does not appear to buy any safety.

If the PF stays unresponsive, the probe recovery loop repeats: probe fails
with -ETIMEDOUT, recovery work runs a rescan, and probe runs again. Each
pass would leak one full context.

The final patch in the series keeps this behaviour through
mana_hwc_release_channel()->mana_hwc_retain_channel(), and gdma_pci.c is
not changed.

Could the software-only state be freed here? Alternatively, could the
retained ownership be reported to the callers of mana_gd_cleanup()?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1791561995.git.weh%40linux.microsoft.com
