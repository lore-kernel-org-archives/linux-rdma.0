Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794320117;
	b=KWI6dPAsYj90xdaYDdh9rpfPCuuBTm0q9WnGN3xOhsIRzb2hFJaLwJ9iHZlQp5gNPk3q
	 yb12eTUFRkHlEwNvhsWalxf9vzhbE1Gbp4yv4CJjNTQR1k947vPJXdFzQYvgCC1UBgGPA
	 pUCoJZ0xjg+Fck5e0wLlo3QhlJmYNMdRoV3OMiq+WzGGWhMKvD05t2mARA7u6ZSg5Nd1/
	 tUZMnoF+Xhrx8IIxoHeYfvfuAA0PbnItD+rDhDDkFfkWLHGeSxpY1/iFbl0Eom3qWQYy2
	 pu2tnq6q8LoYqN1JeM6TM8PMSlCfwXaClhMcBlkCNAcJh/zfcofAgh9u/cLIGXn1X0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794320117;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=0Dm18Q21uzLDa+SFjO/50zAfSfPVF6OnzYSb94gMBS0=;
	b=eoVfHk2pyFJyb2bQ5XhLdBlOxDv4XoCt8vNW0Xuqc6nEWOpScKUlgUDc08BZDjXbSH2v
	 3AEAH8HnTXESVvdI05SbhKzal/6BYTWJmIftFrAE5HdHsEfxKXtSgYWpelydGogHIm1dK
	 6b9I7KreJyHPvAKz2DPhL3oPa1FKwo/ZiUC/63Su2kUW/mMxvSBiJ4aLSEplaxo28P8DY
	 WqS9rSs4qnYCumM9/kTnQiGGeUoelJ3SyKcOI2qvg4mByL7QlL8a4PqG1iAY35XYvx3BT
	 1X8TI8UA4Kqltn+KIvqaxc04N2I/mFBUqWrVUdBfCYjlmkf5GTEK5rvLLlT3kZD977A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MynuSu+X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4EB606A32E;
	Tue, 10 Nov 2026 14:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MynuSu+X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE3D1F0089F;
	Tue, 10 Nov 2026 14:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794320116;
	bh=0Dm18Q21uzLDa+SFjO/50zAfSfPVF6OnzYSb94gMBS0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=MynuSu+XZH3Q4eOVY7S4T5PVbNgRYFMIkCeZWYQMC1VE/yXYovnpp1v0OZxhMsWjc
	 Y1F/ZRuROcTmrJSSfcmxaeYWXRuCXfKw2zmqjoOtt7g4TyYYYgF9zWiuj46rMJRO7X
	 reMXto7MBsvKeKEv6LsCWe4tkMZ4TRABYTrcBloWPo+SHDMw9TKFTbePqUT5rugeiq
	 PFgbCzwJTSUsQ1Zbyzqh+zNY5rgRfG5DgYBvnzNtmfnYvgHvKYcYHqyKnBgZBIvAif
	 MzgeNerEEScbbV6vtF8p5TWRaGgdbkKypjO0pJdV7vl3A6TCLrUdAdHKrIluAlaZMM
	 MjcB0zVQUxmwg==
Subject:
 Re: [PATCH net-next] net: mana: Allocate queue MSI-X vectors on demand
From: netdev-bot+sashiko@kernel.org
To: ernis@linux.microsoft.com
Cc: haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, weh@microsoft.com,
 kotaranov@microsoft.com, horms@kernel.org, gargaditya@linux.microsoft.com,
 mawasthi@linux.microsoft.com, linux-hyperv@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, shradhagupta@linux.microsoft.com,
 sahilchandna@linux.microsoft.com
Date: Tue, 10 Nov 2026 14:15:15 +0000
Message-ID: <179432011525.994134.8778782846611490815@kernel.org>
In-Reply-To: <20261106063011.43293-1-ernis@linux.microsoft.com>
References: <20261106063011.43293-1-ernis@linux.microsoft.com>
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

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] On PCI devices with dynamic MSI-X, queue MSI-X vectors used to
  be created at probe and kept for the life of the device.
- [Low] The kernel-doc for struct gdma_bus_ops in include/net/mana/gdma.h
  is now wrong for the PCI bus.
- [Low] mana_gd_remove_irqs() now calls mana_gd_put_gic(gc, false, msi)
  once for every entry in gc->irq_contexts, under a new comment, "Only…

--

net: mana: Allocate queue MSI-X vectors on demand

This commit stops allocating every queue MSI-X vector at probe time on PCI
devices with dynamic MSI-X. Vectors are now allocated by mana_gd_get_gic()
when an EQ needs one. A new setup_dyn_affinity bus op sets affinity for
each vector as it is created, and PCI teardown now walks the irq_contexts
xarray.

> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_pci.c b/drivers/net/ethernet/microsoft/mana/gdma_pci.c
> index ed8925296c8a7..5aebf57eb4125 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_pci.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_pci.c

[ ... ]

> @@ -564,17 +485,12 @@ static int mana_gd_setup_remaining_irqs(struct pci_dev *pdev)
>  static void mana_gd_remove_irqs(struct pci_dev *pdev)
>  {
>  	struct gdma_context *gc = pci_get_drvdata(pdev);
> -	int i;
> -
> -	if (gc->max_num_msix < 1)
> -		return;
> -
> -	for (i = 0; i < gc->max_num_msix; i++) {
> -		if (!xa_load(&gc->irq_contexts, i))
> -			continue;
> +	struct gdma_irq_context *gic;
> +	unsigned long msi;
>  
> -		mana_gd_put_gic(gc, false, i);
> -	}
> +	/* Only the vectors an EQ asked for were ever created */
> +	xa_for_each(&gc->irq_contexts, msi, gic)
> +		mana_gd_put_gic(gc, false, msi);
>  
>  	WARN_ON(!xa_empty(&gc->irq_contexts));
>  

[Severity: Low]
Is this comment accurate? mana_gd_setup_irqs() still creates a gic with a
setup reference for every vector it allocates, before any EQ asks for one.
In dynamic mode that is the HWC vector 0. In msi_sharing mode it is the
whole 0..nvec-1 pool:

mana_gd_setup_irqs() {
    ...
	for (i = 0; i < nvec; i++) {
		msi = i;
		gic = mana_gd_get_gic(gc, false, &msi);
    ...
}

This loop also drops one reference per entry. For a dynamically created
vector at index > 0, the only references now belong to EQ owners
(mana_create_eq() in mana_en, and the comp/fatal EQs in mana_ib). So this
put drops a reference the PCI layer never took.

Every current teardown path runs mana_rdma_remove() and mana_remove()
before mana_gd_cleanup(), so I don't think this can cause a use-after-free
today.

Before this patch, a single leaked EQ reference on a dynamic vector left
the refcount above zero after this put, and the WARN_ON(!xa_empty()) below
fired. Now that reference is consumed without a warning and the vector is
freed. The leaking owner's later put would then hit WARN_ON(!gic) in
mana_gd_put_gic(). After a resume or reset it could instead drop a
reference on a new gic at the same index.

Could this put only the references the PCI layer itself took, so the
WARN_ON still catches such leaks?

[ ... ]

> @@ -593,14 +508,6 @@ static int mana_pci_setup_hwc_irqs(struct gdma_context *gc)
>  
>  static int mana_pci_setup_remaining_irqs(struct gdma_context *gc)
>  {
> -	int err;
> -
> -	err = mana_gd_setup_remaining_irqs(to_pci_dev(gc->dev));
> -	if (err) {
> -		dev_err(gc->dev, "Failed to setup remaining IRQs: %d", err);
> -		return err;
> -	}
> -

[Severity: Medium]
With the probe-time allocation gone, are the queue MSI-X vectors on
dynamic MSI-X PCI devices now freed and re-created on every queue
reconfiguration?

Before this patch, mana_gd_setup_dyn_irqs() took a base reference on each
gic at indices 1..num_msix_usable-1. The EQ put in mana_destroy_eq() then
only decremented the refcount. Now the EQ holds the only reference:

mana_detach()
  mana_dealloc_queues()
    mana_destroy_eq()
      mana_gd_put_gic(gc, !gc->msi_sharing, msi)
        refcount_dec_and_test() returns true
        irq_update_affinity_hint(irq, NULL)
        free_irq(irq, gic)
        ops->msix_free()          /* pci_msix_free_irq() */

and on the way back up:

mana_attach()
  mana_alloc_queues()
    mana_create_eq()
      mana_gd_get_gic()
        ops->msix_virq() returns -EINVAL
        ops->msix_alloc_at()      /* pci_msix_alloc_irq_at() */
        ops->setup_dyn_affinity()

This path runs on ifdown/ifup, MTU and channel changes, XDP attach/detach,
and any other mana_detach()/mana_attach() cycle.

mana_pci_setup_dyn_affinity() puts the driver's default placement back on
each new vector. Does that mean affinity set through
/proc/irq/N/smp_affinity, by an admin or by irqbalance, is lost on each of
these operations?

pci_msix_alloc_irq_at() can also return a different Linux IRQ number, which
affects tools that pin IRQs by number.

That allocation can also fail at runtime with -ENOSPC or -ENOMEM. Could an
MTU change or an ifdown/ifup then leave the interface unable to come back
up? Before this patch the vectors were reserved once at probe.

The commit message only describes the lower steady-state IRQ count. Should
it also say that vectors are now torn down and rebuilt on every queue
reconfiguration?

>  	if (!gc->msi_sharing) {
>  		gc->msi_bitmap = bitmap_zalloc(gc->num_msix_usable, GFP_KERNEL);
>  		if (!gc->msi_bitmap)

[ ... ]

> diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
> index c610fc1067e0d..fc8a0ef6c74e4 100644
> --- a/include/net/mana/gdma.h
> +++ b/include/net/mana/gdma.h
> @@ -443,6 +443,8 @@ struct gdma_context;
>   *	allocate their whole pool up front leave this NULL.
>   * @msix_free: Release a vector obtained from @msix_alloc_at. Only needed
>   *	by buses that implement @msix_alloc_at.
> + * @setup_dyn_affinity: Place a vector obtained from @msix_alloc_at on a
> + *	CPU. Only needed by buses that implement @msix_alloc_at.
>   * @msix_vec_count: Return the number of entries in the device MSI-X table,
>   *	used to clamp the vector count the core asks for. Buses that cannot
>   *	report a table size leave this NULL and the clamp is skipped.

[Severity: Low]
This isn't a bug, but this patch already edits this kernel-doc block.
Should the @setup_remaining_irqs and @remove_irqs entries be updated too?
They still say:

 * @setup_remaining_irqs: Set up the remaining interrupts once the device
 *	resource limits are known.
 * @remove_irqs: Release the interrupts set up by @setup_hwc_irqs and
 *	@setup_remaining_irqs.

After this patch, mana_pci_setup_remaining_irqs() sets up no interrupts.
It only allocates msi_bitmap and sets bit 0.

Queue vectors are now created in mana_gd_get_gic() through @msix_alloc_at
and @setup_dyn_affinity. They are freed by mana_gd_put_gic() when the last
EQ reference is dropped.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261106063011.43293-1-ernis%40linux.microsoft.com
