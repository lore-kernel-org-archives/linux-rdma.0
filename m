Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29923B47E9;
	Fri, 25 Sep 2026 17:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790357619; cv=none; b=ASs/StQSY+VcUnlxHJrL9XXMwnp4BjDFUwL6/OOBbfcIA86o6WioOaN0NZAQ2ElxTMcvnko+JHD1EQlja87fpuZvf79sEjKcaWRGQ8y+45e9CNLc6U3hrbjMB1VBXTeKPBQllOzNbLYBIBqFtcEuU/hhbpZhULZzT/h19XjBdXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790357619; c=relaxed/simple;
	bh=TV4yxqwGlBIO/s9KtuBHZtB2aMeaGpIddunywzSN3A4=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SM71B9azrSSn4WLSFrCo76FT6DNqy+Sh7hPrSTGly6sRMvqInW4facYiLH0GIMxTsLuINUDwJzw/NRlb1s7q/Nt8MQTgbUVsrZQrdz2XdLHKo0eDjfrVcKoRD6NgsUMfrrca6yzT+EG2Ms8b9UOkDdTHemZL2/Z0nXNMMJK5PUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LSxbOt3c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LSxbOt3c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445BC1F000FF;
	Fri, 25 Sep 2026 17:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790357617;
	bh=bqGTF0V1Y0WTOM8Sv66edFtkbsbnpND4RrX1TawpZh0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=LSxbOt3cWX8UK73R/UrlQFd/H8wP8dHOlVB5UWQJvxcYABzlXJoZqbliiHokrFrAZ
	 x888WTKw92qle6H2jr4xXk5wOYR1hVyrfDY9rx6HHzw3JIyNzdbFKfnNZDkLde6UIN
	 9CWbqy0I8IGS9srhzP2WRCkyL//a/AUg1+xK0xhbOyFSEtZcZ1xI2fuztVQjC1nPs7
	 1Vbi805kfaqaqGDmzZnHbJjYEjxg03Y6Fa+gMtf9pVMrXiWa5nmYlqcY+ImTa0xMFj
	 QYVOTMVqFT/CAVNP5jXvZ1Px5pARzK3U/04IWX7+7Hb9C1RWLvocP4UTwYLnvEtA7H
	 biIdKOOIexdbg==
Subject: Re: [PATCH net-next 1/4] net: mana: Introduce gdma_bus_ops for
 bus-specific operations
From: netdev-bot+sashiko@kernel.org
To: mawasthi@linux.microsoft.com
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
 decui@microsoft.com, longli@microsoft.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 kotaranov@microsoft.com, horms@kernel.org, linux-hyperv@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, bpf@vger.kernel.org, nipun.gupta@amd.com,
 nikhil.agarwal@amd.com, gargaditya@linux.microsoft.com,
 ernis@linux.microsoft.com, kees@kernel.org, paulros@microsoft.com,
 mawasthi@microsoft.com
Date: Fri, 25 Sep 2026 17:33:35 +0000
Message-ID: <179035761582.2160803.15863427505342061487@kernel.org>
In-Reply-To: <20260924173054.589291-2-mawasthi@linux.microsoft.com>
References: <20260924173054.589291-2-mawasthi@linux.microsoft.com>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] mana_rdma_service_event() (mana_en.c:4033) gains `if
  (!gc->service_wq) return -EOPNOTSUPP;`, and the commit message does…
- [Low] The comment added above mana_gd_put_gic() (gdma_main.c:1754-1755)
  says it frees 'the vector once the last user is gone'.

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but PCI reset
  servicing is not serialized against device unbind or removal.
- [Medium] This problem wasn't introduced by this patch, but
  mana_dealloc_queues() calls mana_gd_dev_reset() (mana_en.c:3728) when…

--

net: mana: Introduce gdma_bus_ops for bus-specific operations

This commit adds a per-device gdma_bus_ops table. The shared GDMA core now
reaches interrupt allocation, IRQ lookup, device reset, servicing and
bus-specific capability bits through these callbacks, and the commit
provides a PCI implementation. It also moves common bring-up and teardown,
including the servicing workqueue, into mana_gd_setup() and
mana_gd_cleanup().

> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> index 8e9bfc1d6a2ae..b076760b2dc50 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c

[ ... ]

> @@ -1888,11 +1739,25 @@ static irqreturn_t mana_gd_intr(int irq, void *arg)

[ ... ]

> +/*
> + * Release a reference on the IRQ context backing an MSI vector, freeing
> + * the vector once the last user is gone.
> + */
>  void mana_gd_put_gic(struct gdma_context *gc, bool use_msi_bitmap, int msi)
>  {

[ ... ]

> @@ -1917,11 +1782,8 @@ void mana_gd_put_gic(struct gdma_context *gc, bool use_msi_bitmap, int msi)
>  	irq_update_affinity_hint(irq, NULL);
>  	free_irq(irq, gic);
>  
> -	if (gic->dyn_msix) {
> -		irq_map.virq = irq;
> -		irq_map.index = msi;
> -		pci_msix_free_irq(dev, irq_map);
> -	}
> +	if (gic->dyn_msix)
> +		ops->msix_free(gc, msi, irq);

[Severity: Low]
This isn't a bug, but is the new comment above mana_gd_put_gic() accurate?

On the last reference, free_irq() always runs. The vector itself is
released through ops->msix_free() only when gic->dyn_msix is set.

Preallocated vectors, such as in the non-dynamic PCI case, stay allocated
until the bus remove_irqs callback tears them down in bulk. Would wording
like "freeing the IRQ, and the vector if it was allocated dynamically" be
closer to what the code does?

[ ... ]

> @@ -2067,20 +1934,340 @@ void mana_gd_free_res_map(struct gdma_resource *r)

[ ... ]

> +static void mana_serv_reset(struct pci_dev *pdev)
> +{
> +	struct gdma_context *gc = pci_get_drvdata(pdev);
> +	struct hw_channel_context *hwc;
> +	int ret;

[ ... ]

> +	/* HWC is not responding in this case, so don't wait */
> +	hwc->hwc_timeout = 0;
> +
> +	dev_info(&pdev->dev, "MANA reset cycle start\n");
> +
> +	mana_gd_suspend(pdev, PMSG_SUSPEND);
> +
> +	msleep(MANA_SERVICE_PERIOD * 1000);
> +
> +	ret = mana_gd_resume(pdev);

[ ... ]

> +out:
> +	clear_bit(GC_IN_SERVICE, &gc->flags);
> +}

[ ... ]

> +static int mana_pci_schedule_serv_work(struct gdma_context *gc,
> +				       enum gdma_eqe_type type)
> +{

[ ... ]

> +	INIT_WORK(&mns_wk->serv_work, mana_serv_func);
> +	schedule_work(&mns_wk->serv_work);
> +	return 0;
> +}

[Severity: High]
This is a pre-existing issue, since this patch only moves and renames the
code, but is this servicing work serialized against device removal?

mana_pci_schedule_serv_work() queues mana_serv_func() on the system
workqueue. It holds only a pci_dev reference and a module reference, and
neither of those keeps the vzalloc'd gdma_context alive.

The worker then runs:

mana_serv_func()
  mana_do_service()
    mana_serv_reset()
      gc = pci_get_drvdata(pdev)
      hwc->hwc_timeout = 0
      mana_gd_suspend()
      msleep(MANA_SERVICE_PERIOD * 1000)
      mana_gd_resume()
      clear_bit(GC_IN_SERVICE, &gc->flags)

It holds neither device_lock() nor pci_lock_rescan_remove() at any point
in that sequence.

mana_gd_remove() does not flush or cancel this work, and it does not check
GC_IN_SERVICE before freeing gc:

mana_gd_remove() {
    ...
	mana_gd_cleanup(gc);

	xa_destroy(&gc->irq_contexts);

	pci_iounmap(pdev, gc->bar0_va);

	vfree(gc);
    ...
}

Suppose a sysfs unbind or a vPCI hot-remove happens during the 10 second
sleep. Could mana_gd_resume() then read NULL drvdata and dereference it in
mana_gd_setup(gc), or use the freed gc? The clear_bit() that follows would
also write into freed memory.

Destroying gc->service_wq in mana_gd_cleanup() doesn't drain this worker,
because the work runs on the system workqueue.

The later patch "net: mana: Move PCI transport code into gdma_pci.c" moves
this code unchanged, so the race is still present at the end of the series.

[ ... ]

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index 591fb4191d90d..62b89b3d60729 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c

[ ... ]

> @@ -3725,10 +3725,9 @@ static int mana_dealloc_queues(struct net_device *ndev)
>  				tsleep <<= 1;
>  			}
>  			if (atomic_read(&txq->pending_sends)) {
> -				err =
> -				    pcie_flr(to_pci_dev(gd->gdma_context->dev));
> +				err = mana_gd_dev_reset(gd->gdma_context);
>  				if (err) {
> -					netdev_err(ndev, "flr failed %d with %d pkts pending in txq %u\n",
> +					netdev_err(ndev, "device reset failed %d with %d pkts pending in txq %u\n",
>  						   err,
>  					    atomic_read(&txq->pending_sends),
>  					    txq->gdma_txq_id);

[Severity: Medium]
This isn't a bug introduced by this patch, but what happens if the reset
fails here? The failure is only logged, and mana_dealloc_queues() then
carries on:

		for (i = 0; i < apc->num_queues; i++) {
			txq = &apc->tx_qp[i]->txq;
			while ((skb = skb_dequeue(&txq->pending_skbs))) {
				mana_unmap_skb(skb, apc);
				dev_kfree_skb_any(skb);
			}
			atomic_set(&txq->pending_sends, 0);
		}

If the device was never actually reset, it still owns those pending TX
WQEs. Could it later DMA-read the buffers that were just unmapped and
freed?

For PCI, pcie_flr() returns before issuing the FLR only when
pci_dev_config_accessible() or pci_dev_reset_iommu_prepare() fails.

The new -EOPNOTSUPP return in mana_gd_dev_reset() can't be reached in this
series, because both PCI and CDX implement dev_reset. So this patch doesn't
make the path newly reachable.

[ ... ]

> @@ -4031,6 +4030,9 @@ int mana_rdma_service_event(struct gdma_context *gc, enum gdma_service_type even
>  		return 0;
>  	}
>  
> +	if (!gc->service_wq)
> +		return -EOPNOTSUPP;
> +
>  	serv_work = kzalloc_obj(*serv_work, GFP_ATOMIC);
>  	if (!serv_work)
>  		return -ENOMEM;

[Severity: Low]
Can this check ever be true? The commit message doesn't mention it.

mana_gd_setup() calls mana_gd_alloc_service_wq() before setup_hwc_irqs()
and mana_hwc_create_channel(). mana_gd_cleanup() destroys the HWC and the
IRQs before it calls mana_gd_free_service_wq().

mana_rdma_service_event() is only called from the HWC event handler. It
looks like it can never run while gc->service_wq is NULL.

On a related note, the comment added above mana_gd_alloc_service_wq()
says:

    /* The servicing workqueue is owned by the GDMA core because the queueing
     * sites live here and in mana_en.c, which every transport shares. Each bus
     * driver creates it during setup and destroys it during cleanup.
     */

The workqueue is created and destroyed by the core mana_gd_setup() and
mana_gd_cleanup(), not by the bus drivers.

gdma_main.c also never queues work on gc->service_wq. The only user is
mana_rdma_service_event(), and mana_pci_schedule_serv_work() uses
schedule_work() on the system workqueue.

Could the comment be updated to match the code, and the check dropped if
it can't be reached?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260924173054.589291-1-mawasthi%40linux.microsoft.com
