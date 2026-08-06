Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B73486654;
	Thu,  6 Aug 2026 17:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786037042; cv=none; b=TX9dcgCrgTLD6TIHHldiJsxNTxN3lm/VLJ1/+wQfwvZFVEKHknDpLlm3Itornn2G/rZVr1tLMI1iD+viEAR+RO7poWKeBT/A9MKoEUb/Z1Jr145tuXlHaIWdybDv0kthUaWUBC/oHcizhE7ZdgcamvOim5DdjtwfILc1rKKTX40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786037042; c=relaxed/simple;
	bh=LLCMlGp/dNU4/YXJOKYjeDbFMIQ/4YN0i8V9/lxy3/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tiJas8W9XLrI7nluyLKhFhWAaugJfYFnSd3+N/DNgsb28yPKdvw9aAdhcB9OjVk0l9tPzJ5sHCaGI/x/PXBknPN8NlYTD8iVedbOUq5sfok/Cma2wGFDYVo0nUqyapnsIPawtjdvmyRnbs5X8OHKKxOrP5+PKFCzy+dI/2nxSeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RbZqzc0M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RbZqzc0M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C931F000E9;
	Thu,  6 Aug 2026 17:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786037040;
	bh=arL3uPMxzvHke73EKxi+k5ULmMVjqiDhfvCDbx5wLFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RbZqzc0MWZuwtWCtOhOvhgr0z0FAnv40765lQgye3YWTt7jeLdlw0KPvokEILYj1h
	 Kq1EbC/gvcvq/D2dK/ZXYPDyALl0/P11OTLqYBoiApXY0YQia4aJEQ/WMGpWlHKx6h
	 fTzs6z2fPazfI6LkRM7Lkb65I4SNYI6MKcN704HFsfp+EuNZNmHb94yEF85SBGDB1z
	 6PSZrbd0TsON6BJFgHXd8xxqyx54UFcBEPZgRYqKNG0EjNDco+RjFj0zORrYtZ7ekn
	 qtanDR9jDbwyJCxO+wk5DnJUkf2BhlhhuLU1scX0qV+z6ROelNotQTszBTFv2Zhibm
	 jrRQ3dIseh8ZQ==
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
Subject: Re: [PATCH net v3 3/6] net: mana: free HWC comp_buf after destroying the EQ
Date: Thu,  6 Aug 2026 10:23:59 -0700
Message-ID: <20260806172359.2945799-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260803234355.636038-4-longli@microsoft.com>
References: <20260803234355.636038-4-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
---
net: mana: free HWC comp_buf after destroying the EQ

This moves the kfree(hwc_cq->comp_buf) in mana_hwc_destroy_cq() to after
the CQ and EQ have been destroyed, so a late EQ handler calling
mana_hwc_comp_event() cannot dereference freed memory.  A comment is
added describing the fencing that makes the new order safe.

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index cbb56c7647876..d701c427fe47b 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> @@ -384,14 +384,20 @@ static void mana_hwc_comp_event(void *ctx, struct gdma_queue *q_self)
>  
>  static void mana_hwc_destroy_cq(struct gdma_context *gc, struct hwc_cq *hwc_cq)
>  {
> -	kfree(hwc_cq->comp_buf);
> -
>  	if (hwc_cq->gdma_cq)
>  		mana_gd_destroy_queue(gc, hwc_cq->gdma_cq);
>  
> +	/* comp_buf is reached only by mana_hwc_comp_event(), which the
> +	 * EQ handler invokes via cq_table[id].  The CQ destroy above
> +	 * already cleared that slot and ran synchronize_rcu(), so no
> +	 * handler can reach comp_buf once it returns.  Destroying the EQ
> +	 * here additionally tears down the IRQ (defense in depth) before
> +	 * comp_buf and hwc_cq are freed below.
> +	 */

[Severity: Low]
Does the EQ destroy really tear down the IRQ here?

mana_gd_destroy_queue() for GDMA_EQ calls mana_gd_destroy_eq(), whose whole
body is:

	if (flush_evenets) {
		err = mana_gd_test_eq(gc, queue);
		...
	}

	mana_gd_deregister_irq(queue);

	if (queue->eq.disable_needed)
		mana_gd_disable_queue(queue);

and mana_gd_deregister_irq() only unlinks the EQ from the shared IRQ's
list:

	spin_lock_irqsave(&gic->lock, flags);
	list_for_each_entry_rcu(eq, &gic->eq_list, entry) {
		if (queue == eq) {
			list_del_rcu(&eq->entry);
			break;
		}
	}
	spin_unlock_irqrestore(&gic->lock, flags);

	synchronize_rcu();

There is no free_irq() and no mana_gd_put_gic() on this path; the only
free_irq() in gdma_main.c lives in mana_gd_put_gic(), which the HWC path
reaches from mana_gd_remove_irqs() instead.  The MSI-X line stays
registered and keeps firing for the other EQs sharing it.

So the actual fence appears to be RCU in both steps (the cq_table slot
clear plus synchronize_rcu() in mana_gd_destroy_cq(), and the list_del_rcu()
plus synchronize_rcu() above), not IRQ teardown.

The same wording appears in the commit message:

    Destroy the CQ and EQ first -- the EQ teardown deregisters the IRQ and
    fences in-flight handlers -- then free comp_buf and hwc_cq.

Could the comment and the changelog be reworded to say the EQ is
deregistered from the shared IRQ's RCU list, rather than that the IRQ is
torn down?  The comment and the changelog also disagree on which step is
load bearing: the comment treats the EQ destroy as "defense in depth"
while the changelog presents it as the mechanism that fences handlers.

> +
>  	if (hwc_cq->gdma_eq)
>  		mana_gd_destroy_queue(gc, hwc_cq->gdma_eq);
>  
> +	kfree(hwc_cq->comp_buf);
>  	kfree(hwc_cq);
>  }
>  

[Severity: Medium]
This isn't a bug introduced by this patch, but the same window the patch
closes for comp_buf still exists for hwc->rxq and hwc->txq, so the fix
looks asymmetric.  In mana_hwc_destroy_channel() the work queues are
freed before the CQ/EQ teardown that does the cq_table clear and the
synchronize_rcu() calls:

	if (hwc->txq)
		mana_hwc_destroy_wq(hwc, hwc->txq);

	if (hwc->rxq)
		mana_hwc_destroy_wq(hwc, hwc->rxq);

	if (hwc->cq)
		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);

mana_hwc_destroy_wq() releases the DMA buffer and the hwc_wq itself with
no fencing, and the GDMA_RQ/GDMA_SQ cases of mana_gd_destroy_queue() are
empty:

	mana_hwc_dealloc_dma_buf(hwc, hwc_wq->msg_buf);

	if (hwc_wq->gdma_wq)
		mana_gd_destroy_queue(hwc->gdma_dev->gdma_context,
				      hwc_wq->gdma_wq);

	kfree(hwc_wq);

In that window mana_hwc_comp_event() is still published in cq_table[id]
and reaches the event handlers with ctx == hwc:

		if (completions[i].is_sq)
			hwc_cq->tx_event_handler(hwc_cq->tx_event_ctx, ...);
		else
			hwc_cq->rx_event_handler(hwc_cq->rx_event_ctx, ...);

and mana_hwc_rx_event_handler() then dereferences the freed rxq:

	if (WARN_ON_ONCE(hwc_rxq->gdma_wq->id != gdma_rxq_id))
		return;

	rq = hwc_rxq->gdma_wq;
	...
	rq_base_addr = hwc_rxq->msg_buf->mem_info.dma_handle;

Can a completion delivered in that window read freed hwc_wq/hwc_dma_buf
memory, and repost into the already dma-unmapped RQ ring via
mana_hwc_post_rx_wqe()?  hwc->rxq and hwc->txq are also left set after
being freed.

For the record, this ordering does get corrected later in the same series
by "net: mana: fix HWC teardown safety with setup_active flag and destroy
ordering", where mana_hwc_destroy_channel() destroys the CQ before the
work queues.  Would it make sense to fold that reordering in here, or note
the dependency, so this patch does not land with only half of the window
closed?
