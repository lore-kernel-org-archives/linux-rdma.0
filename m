Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8033B353A95;
	Wed, 12 Aug 2026 23:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786578414; cv=none; b=ew2KE9I9hzQkL+0lZ9Bg10fDChsftz9fM6A2Ad4M8RvtFreMX+TLaW5oSTTwikte5wUtYug21fyPC20qJZGhkYWZIphgTsDHBI0frVOLkvmu0erGDDTR1Xq4sGpCfOWn8H50HXE+Ll7ZquR6bgnSRuxydUE4lpDCHvoTc0Sajlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786578414; c=relaxed/simple;
	bh=z+f4m/1sTet3ZPa46+zkaB1hnBxzr7vdxstjhE1MMig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OBVbrH5Zgw2G+jzwzhfqQzBHaz2i0ehAGbuyXEtMR+vpnZg12lxrlo2HndRWZIEcwZ6KUkYF9VTHib88lHnhqlQlKr3/kHGK4sv7jvast6yF6CNOKsyrCrP2K69O9dq/URmhFqJWqu96kMUDxY6becaIXuARi+tApLvGFIQtcC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dOYB4a9B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dOYB4a9B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF4081F000E9;
	Wed, 12 Aug 2026 23:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786578412;
	bh=5xs5Z7CGKuoKKEaeuQhCBfB1ExSXbgL3G9xd6PeIQSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dOYB4a9Bjlq/Thi+G8NLxCaOVM6xmAr8NIr4FoMaSAnmESJwCYBifB/qz1ryzrZ6D
	 r4laEGKucLmczENdut+ktzpjbvJP70Xmc1njGzhiw1QbivCZYzu/N7gL8x/n0lao8O
	 0vovEKk3HtB+PlrDgJq0CD7VzSNCZ01O74L1zXVfDOghQG+dJySuCc1MBdnmSflD4T
	 7cw7m3RpqMx9jvJfuuwCoVlDefxnlg6EPDvc5V/YqOyAf62Gk2S//kRHW5CTPDYhW0
	 iaVTxkAd+VGfEitUmJauLegeCllN7RmZiiLAcTyvN4r7MCDt1iFF3bFHOaQvHTWm9S
	 7mDwFU715+YFQ==
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
Subject: Re: [PATCH net v6 1/7] net: mana: RCU-protect gc->cq_table lookups against concurrent CQ destroy
Date: Wed, 12 Aug 2026 16:46:50 -0700
Message-ID: <20260812234650.2193421-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260811023823.2391255-2-longli@microsoft.com>
References: <20260811023823.2391255-2-longli@microsoft.com>
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
net: mana: RCU-protect gc->cq_table lookups against concurrent CQ destroy

This puts gc->cq_table (base pointer and entries) under RCU so the EQ
interrupt handler can no longer dereference a CQ that a concurrent teardown
has freed.  Teardown clears the slot and takes a grace period before the CQ
memory is released, and the Ethernet paths are converted to a two-pass
quiesce/free so the grace periods are batched instead of one per CQ.

A few questions below.

> diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana/cq.c
> index f2547989f4229..73d97b2f5cf9b 100644
> --- a/drivers/infiniband/hw/mana/cq.c
> +++ b/drivers/infiniband/hw/mana/cq.c

[ ... ]

> @@ -149,23 +157,54 @@ int mana_ib_install_cq_cb(struct mana_ib_dev *mdev, struct mana_ib_cq *cq)
>  	gdma_cq->type = GDMA_CQ;
>  	gdma_cq->cq.callback = mana_ib_cq_handler;
>  	gdma_cq->id = cq->queue.id;
> -	gc->cq_table[cq->queue.id] = gdma_cq;
> +	rcu_assign_pointer(cq_table[cq->queue.id], gdma_cq);
>  	return 0;
>  }
>  
>  void mana_ib_remove_cq_cb(struct mana_ib_dev *mdev, struct mana_ib_cq *cq)
>  {
>  	struct gdma_context *gc = mdev_to_gc(mdev);
> +	struct gdma_queue __rcu **cq_table;
> +	struct gdma_queue *gdma_cq;
>  
> -	if (cq->queue.id >= gc->max_num_cqs || cq->queue.id == INVALID_QUEUE_ID)
> +	if (cq->queue.id == INVALID_QUEUE_ID)
>  		return;
>  
>  	if (cq->queue.kmem)
>  	/* Then it will be cleaned and removed by the mana */
>  		return;
>  
> -	kfree(gc->cq_table[cq->queue.id]);
> -	gc->cq_table[cq->queue.id] = NULL;
> +	/* No rcu_read_lock(): like mana_ib_install_cq_cb(), this runs within
> +	 * the IB device lifetime that mana_rdma_remove() drains before the
> +	 * base cq_table can be freed.  See gdma_context::cq_table in gdma.h.
> +	 */
> +	cq_table = rcu_dereference_protected(gc->cq_table, true);
> +	if (!cq_table || cq->queue.id >= gc->max_num_cqs)
> +		return;
> +	/* Removers for a given CQ are serialized by the IB core, so the slot
> +	 * is read and cleared without rcu_read_lock() or atomicity: a CQ is
> +	 * never torn down while a live QP references it (cq->usecnt), nor
> +	 * while the QP-create that installed the entry is still running (that
> +	 * create holds a reference on the CQ uobject across its error path,
> +	 * before usecnt is taken).  Any double-remove is therefore sequential
> +	 * -- the later caller sees the NULL stored below and returns.
> +	 */
> +	gdma_cq = rcu_dereference_protected(cq_table[cq->queue.id], true);
> +	/* Clear the slot only if it still holds the entry this CQ installed
> +	 * (gdma_cq->cq.context == cq).  If the id was already removed, or was
> +	 * recycled and republished for another CQ, leave the current entry
> +	 * intact instead of wiping a live one.
> +	 */
> +	if (!gdma_cq || gdma_cq->cq.context != cq)
> +		return;
> +
> +	rcu_assign_pointer(cq_table[cq->queue.id], NULL);

[Severity: Low]
The comment says the identity test protects against an id that "was
recycled and republished for another CQ", but the compare and the clear
are two separate accesses with nothing making them indivisible.  Both
mana_ib_remove_cq_cb() here and mana_gd_unpublish_cq() do:

    /* read */
    gdma_cq = rcu_dereference_protected(cq_table[cq->queue.id], true);
    if (!gdma_cq || gdma_cq->cq.context != cq)
            return;
    /* separate store */
    rcu_assign_pointer(cq_table[cq->queue.id], NULL);

The two sides of the table are also asymmetric: mana_ib_install_cq_cb()
refuses to publish into a non-NULL slot, but mana_create_txq() and
mana_create_rxq() publish with rcu_assign_pointer(cq_table[cq->gdma_id],
cq->gdma_cq) and no occupancy check at all.

So can this interleaving wipe a live entry?

    remover                              publisher
    reads slot, sees A
                                         stores B' into the same slot
    stores NULL                          (B' is now gone)

Since mana_gd_process_eqe() now drops a NULL slot silently, would every
completion for B' then be discarded with no diagnostic, and would B''s own
remover later see NULL and skip its kfree()?  Would a cmpxchg on the slot,
or a small lock covering cq_table entry mutation, make the conditional
clear actually atomic?

This does need the device to hand the same CQ id to two live consumers, so
I could not demonstrate it in practice; the pre-patch code cleared the slot
unconditionally, so the guard is still an improvement.

> +
> +	/* Wait for in-flight EQ handlers that may have loaded the old
> +	 * pointer via rcu_dereference() to finish before freeing.
> +	 */
> +	synchronize_rcu();
> +	kfree(gdma_cq);
>  }
>  
>  int mana_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags)
> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> index e8b7ffb47eb98..d40f25a1a74a7 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c

[ ... ]

> @@ -743,11 +744,30 @@ static void mana_gd_process_eqe(struct gdma_queue *eq)
>  	switch (type) {
>  	case GDMA_EQE_COMPLETION:
>  		cq_id = eqe->details[0] & 0xFFFFFF;
> +		cq_table = rcu_dereference(gc->cq_table);
> +		if (WARN_ON_ONCE(!cq_table))
> +			break;
> +
> +		/* Pair with the rcu_assign_pointer(gc->cq_table) release in
> +		 * mana_hwc_establish_channel(), which publishes the table
> +		 * after storing gc->max_num_cqs.  The rmb keeps this bound
> +		 * read ordered after the table load, so a shrinking
> +		 * re-establish cannot pair a stale, larger max_num_cqs with a
> +		 * newly published, smaller table and index out of bounds.
> +		 */
> +		smp_rmb();
>  		if (WARN_ON_ONCE(cq_id >= gc->max_num_cqs))
>  			break;
>  
> -		cq = gc->cq_table[cq_id];
> -		if (WARN_ON_ONCE(!cq || cq->type != GDMA_CQ || cq->id != cq_id))
> +		cq = rcu_dereference(cq_table[cq_id]);

[Severity: High]
This isn't a bug introduced by this patch, but at this commit the bound
used here is still mutable while a table is published.
mana_hwc_init_event_handler() writes it straight from EQ interrupt context
from a device-supplied value:

    case HWC_INIT_DATA_MAX_NUM_CQS:
            gd->gdma_context->max_num_cqs = val;

while the table itself is sized once in mana_hwc_establish_channel() with
vcalloc(gc->max_num_cqs, sizeof(*cq_table)).  A later, larger value would
inflate every bound test (cq_id >= gc->max_num_cqs here, cq->gdma_id >=
gc->max_num_cqs in mana_create_txq()/mana_create_rxq(), cq->queue.id >=
gc->max_num_cqs in mana_ib_install_cq_cb()) past the allocation, and a
smaller one would make mana_gd_unpublish_cq() return false so
mana_gd_destroy_cq() skips the grace period for a still-published CQ.

The gdma.h comment added by this patch states the invariant as already
holding ("max_num_cqs above is the size of cq_table and an upper bound on
valid CQ indices for the table's lifetime"), which only becomes true with
the last patch in this series, "net: mana: keep max_num_cqs immutable once
cq_table is allocated" -- that one moves the handler to
WRITE_ONCE(hwc->hwc_init_max_num_cqs, val) and has
mana_hwc_establish_channel() commit a single READ_ONCE() snapshot as both
the vcalloc() size and gc->max_num_cqs.  Should the documented contract
land together with the change that establishes it, or reference it?

> +		/* A NULL entry is expected while a concurrent teardown
> +		 * (e.g. ifdown or an MTU change) has unpublished this CQ but
> +		 * not yet freed it; the completion is stale, so drop it
> +		 * quietly rather than warning.
> +		 */
> +		if (!cq)
> +			break;
> +		if (WARN_ON_ONCE(cq->type != GDMA_CQ || cq->id != cq_id))
>  			break;
>  
>  		if (cq->cq.callback)
> @@ -1050,18 +1070,47 @@ static void mana_gd_create_cq(const struct gdma_queue_spec *spec,
>  	queue->cq.callback = spec->cq.callback;
>  }
>  
> -static void mana_gd_destroy_cq(struct gdma_context *gc,
> -			       struct gdma_queue *queue)
> +bool mana_gd_unpublish_cq(struct gdma_context *gc, struct gdma_queue *queue)
>  {
> +	struct gdma_queue __rcu **cq_table;
>  	u32 id = queue->id;
>  
> -	if (id >= gc->max_num_cqs)
> -		return;
> +	/* No rcu_read_lock() here: unpublish runs only on the
> +	 * CQ-destroy/teardown path, where the base cq_table is stable.  See
> +	 * the lifecycle note on gdma_context::cq_table in gdma.h for why the
> +	 * "true" predicate is sound.
> +	 */
> +	cq_table = rcu_dereference_protected(gc->cq_table, true);
> +	if (!cq_table || id >= gc->max_num_cqs)
> +		return false;
> +
> +	/* Clear the slot only if it still refers to this queue.  The
> +	 * Ethernet two-pass teardown unpublishes the same index twice, a
> +	 * grace period apart, and a CQ that legitimately recycled this id in
> +	 * between (e.g. a new RDMA CQ via mana_ib_install_cq_cb()) must not
> +	 * have its fresh entry wiped by the second pass.
> +	 */
> +	if (rcu_access_pointer(cq_table[id]) != queue)
> +		return false;
> +
> +	rcu_assign_pointer(cq_table[id], NULL);
> +	return true;
> +}
>  
> -	if (!gc->cq_table[id])
> +static void mana_gd_destroy_cq(struct gdma_context *gc,
> +			       struct gdma_queue *queue)
> +{
> +	/* A batched teardown may already have cleared the slot and taken the
> +	 * grace period; then there is nothing left to wait for.
> +	 */
> +	if (!mana_gd_unpublish_cq(gc, queue))
>  		return;
>  
> -	gc->cq_table[id] = NULL;
> +	/* Wait for in-flight EQ handlers that may have loaded the old
> +	 * pointer via rcu_dereference() to finish before the caller
> +	 * frees the CQ memory.
> +	 */
> +	synchronize_rcu();
>  }

[Severity: Medium]
mana_gd_unpublish_cq() returns false for two different states, and
mana_gd_destroy_cq() treats both as "nothing left to wait for":

  a) the slot is already NULL because a batched pass cleared it and
     already took the grace period, and

  b) rcu_access_pointer(cq_table[id]) != queue, i.e. this queue's entry
     was overwritten by another publisher and no grace period has been
     taken for this pointer.

In case (b), mana_gd_destroy_queue() then kfree()s the queue with no wait.
Can an in-flight mana_gd_process_eqe() that already did

    cq = rcu_dereference(cq_table[cq_id]);

on exactly that pointer go on to read cq->type / cq->id and call
cq->cq.callback(cq->cq.context, cq) after the free?

One route into state (b): for an RDMA kernel (kmem) CQ,
mana_ib_install_cq_cb() publishes the entry, mana_ib_remove_cq_cb()
returns early for kmem ("Then it will be cleaned and removed by the mana"),
so the entry stays published across mana_ib_gd_destroy_cq() which releases
the CQ id on the device, and is only cleared later via
mana_ib_destroy_queue() -> mana_gd_destroy_queue() -> mana_gd_destroy_cq().
If the device hands that id to an Ethernet CQ being created in that window,
mana_create_txq()/mana_create_rxq() overwrite the slot unconditionally, and
the identity test above then fails.

Would it be safer to distinguish "we cleared our slot", "never published"
and "our entry was overwritten", and still synchronize in the last case?

I could not confirm the device actually recycles ids inside that window, so
this may not be reachable in practice.

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index e3c24d50dad07..409e20caeccdc 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c

[ ... ]

> @@ -698,11 +699,15 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
>  	if (WARN_ON(cq->id >= gc->max_num_cqs))
>  		return -EPROTO;
>  
> -	gc->cq_table = vcalloc(gc->max_num_cqs, sizeof(struct gdma_queue *));
> -	if (!gc->cq_table)
> +	cq_table = vcalloc(gc->max_num_cqs, sizeof(*cq_table));
> +	if (!cq_table)
>  		return -ENOMEM;
>  
> -	gc->cq_table[cq->id] = cq;
> +	rcu_assign_pointer(cq_table[cq->id], cq);
> +	/* Publish the fully-initialised table last; pairs with the
> +	 * rcu_dereference(gc->cq_table) in mana_gd_process_eqe().
> +	 */
> +	rcu_assign_pointer(gc->cq_table, cq_table);
>  
>  	return 0;
>  }

[ ... ]

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index 92bb55935c1c4..5d215981bba83 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> @@ -2427,12 +2427,18 @@ static void mana_deinit_txq(struct mana_port_context *apc, struct mana_txq *txq)
>  
>  static void mana_destroy_txq(struct mana_port_context *apc)
>  {
> +	struct gdma_context *gc = apc->ac->gdma_dev->gdma_context;
>  	struct napi_struct *napi;
>  	int i;
>  
>  	if (!apc->tx_qp)
>  		return;
>  
> +	/* Pass 1: quiesce each CQ on the device and clear its cq_table slot.
> +	 * Taking one grace period below for the whole port avoids up to
> +	 * apc->num_queues serialized synchronize_rcu() calls (one per CQ in
> +	 * mana_gd_destroy_cq()) under RTNL on every teardown.
> +	 */

[Severity: Low]
This isn't a bug, but is "the whole port" accurate here?  RX and TX are
batched independently: mana_destroy_rxqs() unpublishes only the RX CQs and
calls synchronize_rcu(), then mana_destroy_txq() unpublishes only the TX
CQs and calls synchronize_rcu() again, and mana_detach() runs both back to
back:

    mana_destroy_rxqs(apc);
    mana_destroy_txq(apc);

The same pairing happens on the attach error path.  So each ifdown, MTU
change or ring reconfigure takes two grace periods per port rather than
one.

The commit message says the same thing:

    Clear all of a port's CQ slots first and take a single grace period
    per teardown instead

and the comment in mana_destroy_rxqs() reads "One grace period for the
whole port instead of one per RXQ".  Would "one grace period per RX batch
and one per TX batch" describe the result more precisely?

>  	for (i = 0; i < apc->num_queues; i++) {
>  		if (!apc->tx_qp[i])
>  			continue;
> @@ -2448,8 +2454,24 @@ static void mana_destroy_txq(struct mana_port_context *apc)
>  			apc->tx_qp[i]->txq.napi_initialized = false;
>  		}
>  
> -		if (apc->tx_qp[i]->tx_object != INVALID_MANA_HANDLE)
> -			mana_destroy_wq_obj(apc, GDMA_SQ, apc->tx_qp[i]->tx_object);
> +		if (apc->tx_qp[i]->tx_object != INVALID_MANA_HANDLE) {
> +			mana_destroy_wq_obj(apc, GDMA_SQ,
> +					    apc->tx_qp[i]->tx_object);
> +			apc->tx_qp[i]->tx_object = INVALID_MANA_HANDLE;
> +		}
> +
> +		if (apc->tx_qp[i]->tx_cq.gdma_cq)
> +			mana_gd_unpublish_cq(gc, apc->tx_qp[i]->tx_cq.gdma_cq);
> +	}
> +
> +	synchronize_rcu();
> +
> +	/* Pass 2: the slots are clear, so mana_gd_destroy_cq() skips its own
> +	 * grace period; free the CQ, the TXQ and the queue pair.
> +	 */
> +	for (i = 0; i < apc->num_queues; i++) {
> +		if (!apc->tx_qp[i])
> +			continue;
>  
>  		mana_deinit_cq(apc, &apc->tx_qp[i]->tx_cq);
>  

[ ... ]

> @@ -2987,16 +3054,31 @@ static void mana_destroy_rxqs(struct mana_port_context *apc)
>  	struct mana_rxq *rxq;
>  	u32 rxq_idx;
>  
> -	if (apc->rxqs) {
> +	if (!apc->rxqs)
> +		return;
>  
> -		for (rxq_idx = 0; rxq_idx < apc->num_queues; rxq_idx++) {
> -			rxq = apc->rxqs[rxq_idx];
> -			if (!rxq)
> -				continue;
> +	/* Pass 1: quiesce every RXQ's CQ and clear its cq_table slot. */
> +	for (rxq_idx = 0; rxq_idx < apc->num_queues; rxq_idx++) {
> +		rxq = apc->rxqs[rxq_idx];
> +		if (!rxq)
> +			continue;
>  
> -			mana_destroy_rxq(apc, rxq, true);
> -			apc->rxqs[rxq_idx] = NULL;
> -		}
> +		mana_quiesce_rxq(apc, rxq, true);
> +	}
> +
> +	/* One grace period for the whole port instead of one per RXQ. */
> +	synchronize_rcu();

[ ... ]

> diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
> index 0c395917b2144..0f591029d363b 100644
> --- a/include/net/mana/gdma.h
> +++ b/include/net/mana/gdma.h

[ ... ]

> @@ -496,6 +525,12 @@ int mana_gd_create_mana_wq_cq(struct gdma_dev *gd,
>  
>  void mana_gd_destroy_queue(struct gdma_context *gc, struct gdma_queue *queue);
>  
> +/* Clear a CQ's cq_table slot without waiting for a grace period.  Batched
> + * teardown paths clear several slots and then take a single synchronize_rcu();
> + * single-CQ callers use mana_gd_destroy_cq() instead, which also waits.
> + */
> +bool mana_gd_unpublish_cq(struct gdma_context *gc, struct gdma_queue *queue);

[Severity: Low]
This isn't a bug, but the comment directs includers of this header to an
API they cannot reach: mana_gd_destroy_cq() is static in gdma_main.c and is
not declared anywhere.  The reachable entry point is
mana_gd_destroy_queue(), which is EXPORT_SYMBOL_NS("NET_MANA") and
dispatches GDMA_CQ into the private helper.

mana_gd_unpublish_cq() itself is non-static and declared here, but has no
EXPORT_SYMBOL_NS("NET_MANA") unlike its header-declared siblings, so a
mana_ib user of it would not link; its only users (gdma_main.c and
mana_en.c) are both in mana.ko.

Would keeping the declaration in a mana-private header, or exporting it and
pointing the comment at mana_gd_destroy_queue(), avoid the situation this
patch already runs into -- mana_ib_remove_cq_cb() open-coding the same
unpublish-then-wait sequence with a different identity predicate
(gdma_cq->cq.context != cq) from the one in mana_gd_unpublish_cq()
(rcu_access_pointer(cq_table[id]) != queue)?

>  int mana_gd_poll_cq(struct gdma_queue *cq, struct gdma_comp *comp, int num_cqe);
>  
>  void mana_gd_ring_cq(struct gdma_queue *cq, u8 arm_bit);
-- 
pw-bot: cr
