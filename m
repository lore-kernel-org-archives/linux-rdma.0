Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A0E3B9920;
	Fri,  4 Sep 2026 04:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788497201; cv=none; b=u/gtWXPtJBAKhyRK9/R81DqR+ybcTfLtfMWTBHB+od/Mt0N5GlZdcm4ul8fenBdP1EPUh2KMd2rUczcsZG1GzsPHrs4jrmBFeiMP0YW7in+Yg+LcpfKE2Ja6JvXAJXJe/NZ/lEKB99mdH+5rTU7i5RfNexu4zFxBhVltuQU1fj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788497201; c=relaxed/simple;
	bh=7IUjLSHcxt0fmJCy/QKtVOfaJPL3D9mI05ICbADcxM8=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Hr7+3KlXhij5ryccSFApw1vtLUhTW0RCa15vFi/dENeUNl2wxo2O+lzzwRfPEheuuqvMcfuyl6TZuFp+tAwWVXLgaNNwXagy1znrZvqPYC9aiTtejbXSzvdPYt2N5PIuR4wa2FZkTwBm7sPHo1pWrNtdlgTDzunuvkXCb87rWhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J8ZfPPPE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J8ZfPPPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1893F1F00A3D;
	Fri,  4 Sep 2026 04:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788497199;
	bh=yhjIwVxa73fhe2bU0+aTkBlXH1qWUvZgQ7zbihERAwY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=J8ZfPPPEncg6DpmiKcmHoqzlhOgwqZcdQANnHga8XhwOjvMb6r7jMH/AUYGtopzw3
	 ANOlWBshn+Wq7gWZIdgpo6Rq8Crfes3liehCc3wqVtymc4tFB32NgSM1IL1OuJ2Dhg
	 cMhO6G81sOI1bC5UpMusNUeI91YmirkXIrueQtByCfRwz/Dx7bLyaaP6bM7abrDrR7
	 +LcUI//Ue8jMBmOVBQPluL6GDKJG96rbIB1aE9ylwZ4/mnjGPpv/Xn+HrpnV3Yzwir
	 g5/gfFw/O5tpenUX7KsfBwkpPHwy3+E4lsMvi1xXgsmDKOcJtmouhxcSimnD4vay7Y
	 msQu/aqkJpN9w==
Subject: Re: [PATCH net-next v3 01/13] net: mana: add queue-set allocation and
 teardown helpers
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
Date: Fri, 04 Sep 2026 04:46:37 +0000
Message-ID: <178849719763.4131868.4917085699227078071@kernel.org>
In-Reply-To: <20260901014442.2945689-2-longli@microsoft.com>
References: <20260901014442.2945689-2-longli@microsoft.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 8 potential
issue(s) to consider:

Critical: 0 · High: 2 · Medium: 3 · Low: 3

- [High] mana_drain_txqs() refuses to unmap/free pending TX SKBs when the
  fallback pci_try_reset_function() fails ("leaking pending TX buffers…
- [High] The drain's fallback reset was changed from an unconditional
  pcie_flr() to pci_try_reset_function(), which starts with…
- [Medium] The commit message claims "No functional change otherwise:
  nothing calls the new helpers yet", but the TX-drain rewrite changes…
- [Medium] After a successful function reset invalidates every port's
  queues, the sibling recovery this patch newly relies on can exit…
- [Medium] The drain fallback issues a PCI function-level reset and, on
  success, treats the function as usable: it bumps reset_gen, continues…
- [Low] include/net/mana/mana.h documents mana_context.reset_gen as
  "Bumped on every PCI function reset", and mana_drain_txqs() uses a…
- [Low] The commit message presents "That tears the vport down, so RDMA
  can claim it while released" as applying to all of the named…
- [Low] The live-path change from a bare pcie_flr() to a PCI-core-managed
  function reset is a user-visible correctness fix (the bare FLR wipes…

--

net: mana: add queue-set allocation and teardown helpers

This adds a mana_qset data model plus mana_qset_scratch_alloc(),
mana_alloc_qset() and mana_free_qset() so a queue set can be built and
retired against a scratch port context rather than by tearing the vport
down. It also moves the TX drain out of mana_dealloc_queues() into a new
mana_drain_txqs() and replaces the fallback pcie_flr() with
pci_try_reset_function().

No Link: tags are present in the commit message.

A few questions on the commit message first, then some on the diff.

> The ethtool reconfiguration paths (channel count, ring size, private
> flags), mana_change_mtu() and mana_xdp_set() rebuild the queues with
> mana_detach() then mana_attach(). That tears the vport down, so RDMA can
> claim it while released, and a failed mana_attach() leaves the port down
> with no way back but manual intervention.

[Severity: Low]
This isn't a bug, but does the RDMA part of that sentence hold for all of
the listed paths?

mana_set_channels() and mana_set_priv_flags() in mana_ethtool.c already
set apc->channel_changing = true across their detach/attach window:

	/* Block RDMA from grabbing the vport during detach/attach */
	apc->channel_changing = true;

and mana_cfg_vport() returns -EBUSY while that flag is set. The RDMA
exposure argument seems to apply to mana_set_ringparam(),
mana_change_mtu() and mana_xdp_set() only, while the failed-attach
argument applies to all of them. Could the wording be narrowed?

> The TX drain moves out of mana_dealloc_queues() so the new teardown path
> gets it too, and its fallback reset becomes pci_try_reset_function()
> rather than an open-coded pcie_flr(), which does not save and restore
> config space. Trylock because this runs under RTNL while removal takes
> the device lock first.

[Severity: Low]
This part reads as a correctness fix to the pre-existing fallback reset in
mana_dealloc_queues(), but the patch carries no Fixes: tag and declares no
functional change. Would it be better as a separate commit so it can be
considered for stable on its own?

> No functional change otherwise: nothing calls the new helpers yet.

[Severity: Medium]
Is the "no functional change otherwise" claim accurate for the live
teardown path (mana_close()/mana_detach()/mana_remove())? Three behaviour
changes seem to ride along:

- On a failed fallback reset, mana_drain_txqs() returns before the
  skb_dequeue() loop, so pending TX SKBs and their DMA mappings are now
  deliberately leaked. The baseline code ran that loop unconditionally
  after the pcie_flr() attempt.

- On a successful reset, mana_dealloc_queues() now walks ac->ports[] and
  queues sib->queue_reset_work for every other port, so unrelated netdevs
  get their queues torn down and rebuilt.

- mana_remove() now clears ac->ports[i], which is only justified by a code
  comment.

Could these be called out in the changelog?

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index 7a1ac853e3abc..b9d9543d1a6dc 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c

[ ... ]

> @@ -3679,15 +3684,115 @@ int mana_attach(struct net_device *ndev)
>  	return 0;
>  }
>  
> -static int mana_dealloc_queues(struct net_device *ndev)
> +/* Drain a set about to be destroyed: nothing new can reach it, so wait for the
> + * hardware to finish what it owns, then release every mapped SKB.
> + *
> + * The 120s budget is shared across all queues. On timeout the device is reset,
> + * since its buffers are about to be freed while it may still DMA into them; if
> + * that fails too they are leaked.
> + *
> + * Returns true only if a reset happened, taking every queue on the function
> + * down with it.
> + */
> +static bool mana_drain_txqs(struct mana_port_context *apc)
>  {
> -	struct mana_port_context *apc = netdev_priv(ndev);
>  	unsigned long timeout = jiffies + 120 * HZ;
> -	struct gdma_dev *gd = apc->ac->gdma_dev;
> +	struct gdma_context *gc = apc->ac->gdma_dev->gdma_context;
> +	bool quiesced = true;
> +	bool reset = false;
>  	struct mana_txq *txq;
>  	struct sk_buff *skb;
> -	int i, err;
>  	u32 tsleep;
> +	int i, err;
> +
> +	if (!apc->tx_qp)
> +		return false;
> +
> +	for (i = 0; i < apc->num_queues; i++) {
> +		if (!apc->tx_qp[i])
> +			continue;
> +
> +		txq = &apc->tx_qp[i]->txq;
> +
> +		/* The function was reset after this queue was created, so the
> +		 * device has stopped touching its buffers and the completions
> +		 * waited for below can never arrive. Without this the port
> +		 * would burn the full timeout under RTNL, then reset the
> +		 * function again on the way out.
> +		 */
> +		if (READ_ONCE(apc->ac->reset_gen) != txq->reset_gen)
> +			continue;
> +
> +		tsleep = 1000;
> +		while (atomic_read(&txq->pending_sends) > 0 &&
> +		       time_before(jiffies, timeout)) {
> +			usleep_range(tsleep, tsleep + 1000);
> +			tsleep <<= 1;
> +		}
> +		if (atomic_read(&txq->pending_sends)) {
> +			/* The device still owns these buffers, so reset it
> +			 * before they are freed. pci_try_reset_function()
> +			 * rather than pcie_flr(): it saves and restores config
> +			 * space, which a bare FLR wipes behind the PCI core's
> +			 * back. Trylock because RTNL is held here while the
> +			 * remove path takes the device lock first.
> +			 */
> +			err = pci_try_reset_function(to_pci_dev(gc->dev));

[Severity: High]
Can this reset ever happen on the remove path? mana_gd_remove() is the PCI
.remove callback, and the driver core invokes it with device_lock held:

mana_gd_remove() -> mana_remove() -> mana_detach() -> mana_dealloc_queues()
  -> mana_drain_txqs()

and pci_try_reset_function() begins with:

	if (!pci_dev_trylock(dev))
		return -EAGAIN;

on a mutex the calling thread already owns, so it looks like it can only
return -EAGAIN there. The old pcie_flr() had no lock dependency and did
stop the device, so on unbind with un-drained TX the device now appears to
never be reset while its queues are still destroyed below. Would
pci_reset_function_locked() (or __pci_reset_function_locked()) be the right
call for a caller that is already under device_lock?

> +			if (err) {
> +				netdev_err(apc->ndev,
> +					   "function reset failed: %d, %d pkts pending in txq %u\n",
> +					   err,
> +					   atomic_read(&txq->pending_sends),
> +					   txq->gdma_txq_id);
> +				quiesced = false;
> +			} else {
> +				/* Every queue on the function is dead now,
> +				 * including the ones this loop has not reached
> +				 * and those of the other ports.
> +				 */
> +				WRITE_ONCE(apc->ac->reset_gen,
> +					   apc->ac->reset_gen + 1);
> +
> +				/* Only a reset that actually happened takes the
> +				 * other ports down with it; reporting a failed
> +				 * one would rebuild them for nothing.
> +				 */
> +				reset = true;
> +			}
> +			break;
> +		}
> +	}
> +
> +	/* Only a reset that actually happened makes freeing these safe; without
> +	 * one the device still owns them. Leak instead, bounded at one SQ ring
> +	 * of skbs per queue.
> +	 */
> +	if (!quiesced) {
> +		netdev_err(apc->ndev,
> +			   "device not quiesced, leaking pending TX buffers instead of unmapping memory it can still DMA from\n");
> +		return reset;
> +	}

[Severity: High]
Does this leak-instead-of-unmap decision reach the callers?

The return value is reset, which is false both for a healthy drain and for
a failed reset, so neither mana_dealloc_queues() nor mana_free_qset() can
tell the two apart. Both then run unconditionally:

	mana_fence_rqs(apc);
	mana_destroy_rxqs(apc);
	mana_destroy_txq(apc);
	mana_destroy_eq(apc);

and mana_gd_destroy_queue() in gdma_main.c releases the SQ/CQ/EQ ring
memory regardless of whether the firmware-side destroy succeeded:

	mana_gd_destroy_dma_region(gc, gmi->dma_region_handle);
	mana_gd_free_memory(gmi);
	kfree(queue);

while mana_destroy_rxq() unmaps and frees the RX pages. So the pending SKB
mappings are kept, but the descriptor rings and RX buffers of the same
un-quiesced device go back to the page allocator. Can the device DMA into
that memory after it is reused?

> +
> +	for (i = 0; i < apc->num_queues; i++) {
> +		if (!apc->tx_qp[i])
> +			continue;
> +
> +		txq = &apc->tx_qp[i]->txq;
> +		while ((skb = skb_dequeue(&txq->pending_skbs))) {
> +			mana_unmap_skb(skb, apc);
> +			dev_kfree_skb_any(skb);
> +		}
> +		atomic_set(&txq->pending_sends, 0);
> +	}
> +
> +	return reset;
> +}

[ ... ]

> @@ -3705,41 +3810,27 @@ static int mana_dealloc_queues(struct net_device *ndev)
>  	 * new packets due to apc->port_is_up being false.
>  	 *
>  	 * Drain all the in-flight TX packets.
> -	 * A timeout of 120 seconds for all the queues is used.
> -	 * This will break the while loop when h/w is not responding.
> -	 * This value of 120 has been decided here considering max
> -	 * number of queues.
> +	 *
> +	 * If the drain had to reset the function to get there, every other
> +	 * port on the adapter lost its queues too, so schedule them for a
> +	 * rebuild. This port is being torn down here and needs no such
> +	 * treatment, and a down port stays down: with port_st_save false,
> +	 * detach and attach both skip the queue work.
>  	 */
> +	if (mana_drain_txqs(apc)) {
> +		struct mana_context *ac = apc->ac;
> +		unsigned int i;

[ ... ]

> +		for (i = 0; i < ac->num_ports; i++) {
> +			struct mana_port_context *sib;
>  
> -		for (i = 0; i < apc->num_queues; i++) {
> -			txq = &apc->tx_qp[i]->txq;
> -			while ((skb = skb_dequeue(&txq->pending_skbs))) {
> -				mana_unmap_skb(skb, apc);
> -				dev_kfree_skb_any(skb);
> -			}
> -			atomic_set(&txq->pending_sends, 0);
> +			if (!ac->ports[i] || ac->ports[i] == ndev)
> +				continue;
> +			sib = netdev_priv(ac->ports[i]);
> +			netdev_err(ac->ports[i],
> +				   "queues reset by a sibling port, scheduling rebuild\n");
> +			queue_work(ac->per_port_queue_reset_wq,
> +				   &sib->queue_reset_work);
>  		}
>  	}

[Severity: Medium]
Can this rebuild silently not happen? mana_per_port_queue_reset_work_handler()
gives up before detach/attach when the RX pre-allocation fails:

	err = mana_pre_alloc_rxbufs(apc, ndev->mtu, apc->num_queues);
	if (err) {
		netdev_err(ndev, "Insufficient memory for reset post tx stall detection\n");
		goto clear_flag;
	}

There is no retry and no state change on that branch, so under memory
pressure the sibling netdev stays with port_is_up true and
apc->tx_qp[]/apc->rxqs[] pointing at queues the function reset destroyed,
until someone does a manual ifdown/ifup. Should this branch requeue the
work or mark the port down?

> @@ -3763,6 +3854,278 @@ static int mana_dealloc_queues(struct net_device *ndev)
>  	return 0;
>  }
>  

[ ... ]

> +void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset)
> +{

[ ... ]

> +	if (mana_drain_txqs(scratch)) {
> +		/* The drain had to reset the function to stop the device
> +		 * touching those buffers. A function reset takes down every
> +		 * port on the adapter, not just this one, so rebuild them all
> +		 * - the same recovery mana_tx_timeout() relies on. A port that
> +		 * is already down has nothing to rebuild and its handler
> +		 * leaves it down.
> +		 */

[Severity: Medium]
After the function reset, what re-establishes the GDMA/HWC state that the
scheduled rebuilds need?

The driver registers no pci_error_handlers, so there is no reset_prepare or
reset_done callback, and pci_try_reset_function() only saves and restores
config space. The only path that re-bootstraps the device is:

mana_serv_reset() -> mana_gd_suspend()/mana_gd_resume()
  -> mana_gd_cleanup_device()/mana_gd_setup()

and that is not invoked here. Each queued queue_reset_work then re-enters
mana_attach() and issues HWC requests over a channel the reset destroyed,
while gc->cq_table[], the EQ/MSI-X bookkeeping and the cached vport and
queue handles still describe objects that no longer exist. The mana_ib
auxiliary device on the same function is also not told.

Is the comment's "the same recovery mana_tx_timeout() relies on" accurate?
That path never resets the function, so its HWC is still alive when the
rebuild runs.

> +		struct mana_port_context *apc = netdev_priv(scratch->ndev);
> +		struct mana_context *ac = apc->ac;
> +		struct mana_port_context *sib;
> +		unsigned int i;
> +
> +		netdev_err(scratch->ndev,
> +			   "device reset while retiring a queue set, scheduling port reset\n");
> +
> +		for (i = 0; i < ac->num_ports; i++) {
> +			if (!ac->ports[i])
> +				continue;
> +			sib = netdev_priv(ac->ports[i]);
> +			queue_work(ac->per_port_queue_reset_wq,
> +				   &sib->queue_reset_work);
> +		}
> +	}

[ ... ]

> diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
> index 83b7eff4646ea..356aaa652fa6f 100644
> --- a/include/net/mana/mana.h
> +++ b/include/net/mana/mana.h

[ ... ]

> @@ -537,6 +547,14 @@ struct mana_context {
>  	u8 bm_hostmode;
>  
>  	struct mana_ethtool_hc_stats hc_stats;
> +
> +	/* Bumped on every PCI function reset. A queue created before the
> +	 * current value can no longer be reached by the device, so its buffers
> +	 * need no drain. All access is under RTNL: the bump is a non-atomic
> +	 * read-modify-write, so a second writer would lose an increment.
> +	 */
> +	u32 reset_gen;

[Severity: Low]
Is "bumped on every PCI function reset" true? The only writer is
mana_drain_txqs(), right after its own successful pci_try_reset_function().

Resets initiated elsewhere leave it unchanged, for example:

  echo 1 > /sys/bus/pci/devices/<bdf>/reset

as well as secondary-bus/slot resets, EEH/AER recovery, and the driver's
own mana_serv_reset() -> mana_gd_suspend()/mana_gd_resume() cycle. There
is no reset_done callback anywhere under drivers/net/ethernet/microsoft/mana/
that would observe them, so mana_drain_txqs() still burns the full 120s
under RTNL and then resets the function again.

The effect is conservative rather than unsafe, so would either adding a
reset_done handler or narrowing the comment to resets issued by
mana_drain_txqs() be preferable?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260901014442.2945689-1-longli%40microsoft.com
