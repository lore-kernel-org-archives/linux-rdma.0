Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F0642FCD8;
	Wed, 12 Aug 2026 23:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786578418; cv=none; b=SWbDUjfGWdXbd1XmmfoSLzxSK4S7dwdqXbz63YWSLsT0Y7WVJrCZJZ8/5wcv4gYPWG0wg1ssqjZBBnzaFTuDC3m9Yskm3W0Se9wdVJuVyDah1n/ob+JCREfgQ97cCxivxCh6TXGx9VjM0MzVvRuFLGfvwG6OxRx15xN6vWJn+/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786578418; c=relaxed/simple;
	bh=1xjMYVRz+vX2XjDUBN1TaLacpCoHbdK+bGvynwYN3Ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JKZyQjUMfW0NxRm6vg5Dnv75tp+u8MXv+NwU3oJhiZZdgaq53S0TL9aBH7CRZp/+OLnDawVLK70xWITcV00Nb8HhLvDqRHXXL1kjmKB16HwkRx6qh5qWik0sggS2j2wmSLX2YzdZasVGwgMYdTKwSr9B9rZBjccQZzQla8/PHgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WMLzSD7J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WMLzSD7J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483321F000E9;
	Wed, 12 Aug 2026 23:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786578415;
	bh=eH+8lAUHTR7lq6P+vciLOsPyDiQr5z+DQjqu9teuH18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WMLzSD7JLisllEhf1DIO3wznw8P2Y5StOB/ChX9Cr64gOL2zF1ZWw8mQmfx0jg7mt
	 D8pNfY0taHEpS9rJ6BjCqOFS6TdPjthj0OIQj6c9VyIaqT7b/2b3Stu1QbGvHYHiXZ
	 WoR0ighbZ9BeODYfIG885lOoEP0VcpjmKEgkp2Po3M3li/3daYqC1580pdClzNFyq4
	 /WgH4c7DFp8M0p0hdZUUf2qbX16Rl75OBnfIvJtL7cpea96Y6HHOvK0NVItYVnPrRq
	 ENrCZfYKbDW1529a33DnupO4xljrqBaFKuAUn/+2YraTbnw2ZHbilYKXTx0qmlS1NX
	 bbpP3sn72nuUw==
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
Subject: Re: [PATCH net v6 3/7] net: mana: free HWC comp_buf after destroying the EQ
Date: Wed, 12 Aug 2026 16:46:53 -0700
Message-ID: <20260812234654.2193489-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260811023823.2391255-4-longli@microsoft.com>
References: <20260811023823.2391255-4-longli@microsoft.com>
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
net: mana: free HWC comp_buf after destroying the EQ

This reorders mana_hwc_destroy_cq() so the EQ is destroyed first, then the
CQ, and only afterwards hwc_cq->comp_buf is freed.  The stated reason is
that mana_gd_destroy_queue() on the EQ deregisters the IRQ and waits out
in-flight handlers, fencing EQE dispatch before handler-reachable memory is
released.

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index 3f011ebbe7b3e..19896bb5ce1a4 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> @@ -384,14 +384,24 @@ static void mana_hwc_comp_event(void *ctx, struct gdma_queue *q_self)
>  
>  static void mana_hwc_destroy_cq(struct gdma_context *gc, struct hwc_cq *hwc_cq)
>  {
> -	kfree(hwc_cq->comp_buf);
> +	/* Destroy the EQ before the CQ.  mana_gd_destroy_queue() on the EQ
> +	 * deregisters its IRQ and waits out in-flight handlers, fencing all
> +	 * EQE dispatch — both the completion path and HWC init/reconfig
> +	 * events.  Freeing the CQ first would leave the EQ live and able to
> +	 * dispatch an event that dereferences hwc->cq->gdma_cq (e.g.
> +	 * mana_hwc_init_event_handler()) after it has been freed.
> +	 */
> +	if (hwc_cq->gdma_eq)
> +		mana_gd_destroy_queue(gc, hwc_cq->gdma_eq);

[Severity: Medium]
This isn't a bug introduced by this patch, but the ordering in the only
caller does not yet match the invariant the new comment states.  Does the
comment's claim that this point fences "all EQE dispatch — both the
completion path and HWC init/reconfig events" hold for the WQ objects the
same handlers touch?

At this commit mana_hwc_destroy_channel() frees the WQs before it gets
here:

	if (gc->max_num_cqs > 0)
		mana_smc_teardown_hwc(&gc->shm_channel, false);

	if (hwc->txq)
		mana_hwc_destroy_wq(hwc, hwc->txq);

	if (hwc->rxq)
		mana_hwc_destroy_wq(hwc, hwc->rxq);

	if (hwc->cq)
		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);

mana_hwc_destroy_wq() releases msg_buf (the DMA buffer plus reqs[]), the
gdma_wq and the hwc_wq itself, and hwc->txq / hwc->rxq are left dangling
rather than set to NULL.  The EQ is still on gic->eq_list and the HWC CQ is
still published in gc->cq_table at that point, since the only dispatch
fence (mana_gd_deregister_irq() -> list_del_rcu() + synchronize_rcu()) is
reached from the mana_gd_destroy_queue() call added here.

So can an EQE arriving in that window reach freed memory through
mana_gd_process_eqe() -> mana_hwc_comp_event() -> mana_hwc_rx_event_handler(),
which dereferences hwc->rxq and then:

	if (WARN_ON_ONCE(hwc_rxq->gdma_wq->id != gdma_rxq_id))
		return;

and later hwc_rxq->msg_buf->mem_info.dma_handle and
hwc_rxq->msg_buf->reqs[]?  The tx side has only a NULL check:

	WARN_ON_ONCE(!hwc_txq || hwc_txq->gdma_wq->id != gdma_txq_id);

which a freed-but-non-NULL pointer passes.  mana_hwc_init_event_handler()
similarly touches hwc->rxq->gdma_wq->id and hwc->txq->gdma_wq.

For what it's worth, a later commit in this series, "net: mana: fix HWC
teardown safety with setup_active flag and destroy ordering", reorders
mana_hwc_destroy_channel() to call mana_hwc_destroy_cq() before
mana_hwc_destroy_wq() for txq and rxq, so the final tree state does not
have this window.  Given this patch carries a Fixes: tag and would be a
stable backport candidate on its own, would it be worth folding the caller
reordering in here, or noting the dependency in the changelog?

>  
> +	/* comp_buf is reached only by mana_hwc_comp_event(), invoked from
> +	 * the now-fenced EQ handler, so it is safe to free once the EQ and
> +	 * CQ are gone.
> +	 */
>  	if (hwc_cq->gdma_cq)
>  		mana_gd_destroy_queue(gc, hwc_cq->gdma_cq);
>  
> -	if (hwc_cq->gdma_eq)
> -		mana_gd_destroy_queue(gc, hwc_cq->gdma_eq);
> -
> +	kfree(hwc_cq->comp_buf);
>  	kfree(hwc_cq);
>  }

[Severity: Medium]
This is a pre-existing issue, but moving the EQ destroy to the front of
this function changes which ring is handed back to the DMA allocator first
on the failure path.  Is that safe when the shared-memory teardown was
skipped?

mana_hwc_destroy_channel() gates the teardown on max_num_cqs and drops the
return value:

	/* gc->max_num_cqs is set in mana_hwc_init_event_handler(). If it's
	 * non-zero, the HWC worked and we should tear down the HWC here.
	 */
	if (gc->max_num_cqs > 0)
		mana_smc_teardown_hwc(&gc->shm_channel, false);

If mana_smc_setup_hwc() succeeded (MST entries active, device programmed
with the HWC ring addresses) but mana_hwc_establish_channel() then timed
out waiting on hwc_init_eqe_comp, max_num_cqs stays zero, the teardown is
skipped, and mana_hwc_destroy_cq() still runs.  The EQ ring is then the
first HWC ring released, via mana_gd_destroy_queue() ->
mana_gd_free_memory() -> dma_free_coherent().

For the HWC EQ, eq.disable_needed is false, so mana_gd_destroy_eq() issues
no device-side DISABLE_QUEUE, and mana_gd_deregister_irq() fences only the
driver's handlers.  Can the device still post an EQE into those pages after
they are freed?  shm_channel.c notes the dependency:

	/* Waiting for the hardware to invalidate the MST entries before the
	 * driver frees the queue memory */

The same later commit, "net: mana: fix HWC teardown safety with
setup_active flag and destroy ordering", replaces the max_num_cqs gate with
hwc->setup_active set before mana_smc_setup_hwc(), and on teardown failure
returns early and leaks the HWC resources instead of freeing memory the
device may still write to.  Should the ordering change here wait for that
gate, or at least mention the ordering dependency between the two patches?
