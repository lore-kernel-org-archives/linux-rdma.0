Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E3536CDE9;
	Thu,  6 Aug 2026 17:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786037039; cv=none; b=RI8ZTYMO45R7+SAHYeKpfzffPdx6CvXsRK4e9DCGVZzzywRpNJjsr2+onZQIRclgn8NvA/dUsEE+f85po/m/vhtu9B4yLD56QQVXhdeUm1WOyUK0Njh0dB8z3JOXIKPrd72hSrS5wZHEfzJXU+o1j0L+fUMlM09CxLTz45KphAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786037039; c=relaxed/simple;
	bh=/5B4r9rDDI9zovsJzZ4leowU9iCnR9L50Mx8lvlxEpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cVVnNOeNzlXDaldcN4gtGeqw/pBRwOgSBXkCi0KiekP6Xv0hmFCJ7xHk96xi9jC0eJ86E+KqztfYBDuordSToGr1Z80m86gXzpRn7pHg+tmXQD419OdH+XC5VLhZx8VvtwODR4cS7MqEgT2Efligr7VgBu0lqTQrtQ8OFPnlWxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BFGZhgVU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BFGZhgVU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DBF31F000E9;
	Thu,  6 Aug 2026 17:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786037037;
	bh=hnKwPgPtIxZlHOr8foGjOidkg0GKfnnnomXxmpFPUAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BFGZhgVUmv4xK6MTKKXggslBFQ8r1C6E89gPFykaJGTyY6OaibOMXgb4FL19sHOmE
	 TUXkGmv/n4LecvT+bUsOgWpBbH5kMib+UDaoBLdy/x7vXo3fl3z1js9vHBBeZ+/x8b
	 8I3E22ykAwT1KJ+eu+WWmk8wPi8J3fVmiqZcLGjbiX0aza/mpWVvQkR2qSFDyAMWrf
	 U70g0T6nv2gMX9rP97GnCWAWBS2W+aMFwILqvS4b+M2ELTDOcWIHC4U1Wp6SRDaBM6
	 3pvETw2tKywrWaq2MBkgBGK5cryExrJICg5jp7bvNvMjukLdyapUgwXBUwdVL1JbKo
	 dinCC+KdfyMow==
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
Subject: Re: [PATCH net v3 1/6] net: mana: RCU-protect gc->cq_table lookups against concurrent CQ destroy
Date: Thu,  6 Aug 2026 10:23:53 -0700
Message-ID: <20260806172353.2945444-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260803234355.636038-2-longli@microsoft.com>
References: <20260803234355.636038-2-longli@microsoft.com>
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

This puts gc->cq_table under RCU: the base pointer and the entries are
annotated __rcu, the EQ interrupt handler reads them with
rcu_dereference(), publishers use rcu_assign_pointer(), and teardown
clears the slot and calls synchronize_rcu() before the CQ is freed.

A few questions on the teardown latency and on the lifetime rule the new
gdma.h comment documents.

> diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana/cq.c
> index f2547989f4229..2bf4be21cede7 100644
> --- a/drivers/infiniband/hw/mana/cq.c
> +++ b/drivers/infiniband/hw/mana/cq.c

[ ... ]

> @@ -149,23 +157,49 @@ int mana_ib_install_cq_cb(struct mana_ib_dev *mdev, struct mana_ib_cq *cq)

[ ... ]

> +	rcu_assign_pointer(cq_table[cq->queue.id], NULL);
> +
> +	/* Wait for in-flight EQ handlers that may have loaded the old
> +	 * pointer via rcu_dereference() to finish before freeing.
> +	 */
> +	synchronize_rcu();
> +	kfree(gdma_cq);
>  }

> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> index e8b7ffb47eb98..fa6fcc2475c1a 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c

[ ... ]

> @@ -743,10 +744,11 @@ static void mana_gd_process_eqe(struct gdma_queue *eq)
>  	switch (type) {
>  	case GDMA_EQE_COMPLETION:
>  		cq_id = eqe->details[0] & 0xFFFFFF;
> -		if (WARN_ON_ONCE(cq_id >= gc->max_num_cqs))
> +		cq_table = rcu_dereference(gc->cq_table);
> +		if (WARN_ON_ONCE(cq_id >= gc->max_num_cqs || !cq_table))
>  			break;
>  
> -		cq = gc->cq_table[cq_id];
> +		cq = rcu_dereference(cq_table[cq_id]);
>  		if (WARN_ON_ONCE(!cq || cq->type != GDMA_CQ || cq->id != cq_id))
>  			break;

[Severity: High]

This isn't a bug introduced by this patch - the baseline had the same
"if (WARN_ON_ONCE(cq_id >= gc->max_num_cqs)) break; cq = gc->cq_table[cq_id];"
pattern - but the patch rewrites these lines and documents the RCU scheme
as the complete safety argument for cq_table, while the bound that guards
every index stays outside the published object.

mana_hwc_establish_channel() freezes the element count at vcalloc() time
and publishes only the pointer, but gc->max_num_cqs keeps being written
straight from a device-supplied EQE payload:

hw_channel.c:mana_hwc_init_event_handler() {
	...
		case HWC_INIT_DATA_MAX_NUM_CQS:
			gd->gdma_context->max_num_cqs = val;
			break;
	...
}

That handler stays installed as the HWC EQ eq.callback for the whole
device lifetime, and mana_gd_process_eqe() dispatches any
GDMA_EQE_HWC_INIT_DATA to it from hard IRQ context, with no coupling to the
currently published table.

If the PF raises gc->max_num_cqs above the allocated element count, does
rcu_dereference(cq_table[cq_id]) then read past the end of the vcalloc'ed
array, and can the value read there be used as
cq->cq.callback(cq->cq.context, cq)?

Separately, the gc->max_num_cqs load carries no address dependency on the
rcu_dereference()d base pointer. Can a reader therefore pair a freshly
published table with a stale bound, producing a spurious hard-IRQ
WARN_ON_ONCE and a silently dropped completion?

Would storing the element count inside or alongside the published
allocation be more robust than trusting a device-writable, non-RCU field?

[ ... ]

> @@ -1053,15 +1055,28 @@ static void mana_gd_create_cq(const struct gdma_queue_spec *spec,
>  static void mana_gd_destroy_cq(struct gdma_context *gc,
>  			       struct gdma_queue *queue)
>  {
> +	struct gdma_queue __rcu **cq_table;
>  	u32 id = queue->id;
>  
> -	if (id >= gc->max_num_cqs)
> +	/* No rcu_read_lock() here: mana_gd_destroy_cq() runs only on the
> +	 * CQ-destroy/teardown path, where the base cq_table is stable.  See
> +	 * the lifecycle note on gdma_context::cq_table in gdma.h for why the
> +	 * "true" predicate is sound.
> +	 */
> +	cq_table = rcu_dereference_protected(gc->cq_table, true);
> +	if (!cq_table || id >= gc->max_num_cqs)
>  		return;
>  
> -	if (!gc->cq_table[id])
> +	if (!rcu_access_pointer(cq_table[id]))
>  		return;
>  
> -	gc->cq_table[id] = NULL;
> +	rcu_assign_pointer(cq_table[id], NULL);
> +
> +	/* Wait for in-flight EQ handlers that may have loaded the old
> +	 * pointer via rcu_dereference() to finish before the caller
> +	 * frees the CQ memory.
> +	 */
> +	synchronize_rcu();
>  }

[Severity: High]

Is one grace period per CQ acceptable on this path? mana_gd_destroy_cq()
is reached once per TX queue and once per RX queue during netdev teardown:

mana_en.c:mana_destroy_txq() {
	for (i = 0; i < apc->num_queues; i++) {
		...
		mana_deinit_cq(apc, &apc->tx_qp[i]->tx_cq);
}

mana_deinit_cq() -> mana_gd_destroy_queue() -> mana_gd_destroy_cq(), and
mana_destroy_rxq() does the same for &rxq->rx_cq.

With MANA_MAX_NUM_QUEUES == 64 that is up to about 128 serialized RCU
grace periods per ifdown, MTU change, ethtool -L, ethtool -G, XDP attach
or queue reset. Those loops run with rtnl_lock() held (mana_detach() has
ASSERT_RTNL(), and the same loops use napi_disable_locked() /
netif_napi_del_locked(), so the netdev instance lock is held too).

Since RTNL is system-wide, does this stall every other network
configuration operation on the machine for the accumulated duration?

The same question applies to mana_ib_remove_cq_cb() in
drivers/infiniband/hw/mana/cq.c, which now blocks for a full grace period
on each user-triggered ib_destroy_cq() and once per ind_tbl entry in the
mana_ib_create_qp_rss() unwind loop.

mana_ib_remove_cq_cb() frees the per-CQ struct gdma_queue itself, so would
kfree_rcu() give the same guarantee without blocking? For the netdev path,
could all slots be cleared first and a single grace period taken per
teardown batch instead of one per CQ?

The changelog describes the change as annotation plus a deferred free;
would it be worth mentioning the new teardown latency so backporters know
CQ-destroy and ifdown timing changes by orders of magnitude?

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

[Severity: High]

This is a pre-existing check-then-use pattern and not introduced by this
patch, but the patch rewrites exactly these lines.

cq->id and gc->max_num_cqs are validated once, then re-read separately -
one for the allocation size, one as the array index. Both fields are
written from the HWC EQ interrupt handler:

hw_channel.c:mana_hwc_init_event_handler() {
	...
		case HWC_INIT_DATA_CQID:
			hwc->cq->gdma_cq->id = val;
			break;
	...
		case HWC_INIT_DATA_MAX_NUM_CQS:
			gd->gdma_context->max_num_cqs = val;
			break;
	...
}

The HWC EQ is already armed and delivering EQEs here, since this code only
runs after GDMA_EQE_HWC_INIT_DONE completed hwc_init_eqe_comp.

If the device emits an extra or duplicate GDMA_EQE_HWC_INIT_DATA in the
window between the WARN_ON() check, the vcalloc() and the indexed store
(smaller MAX_NUM_CQS or larger CQID), do the validated expression and the
used expression diverge, writing the cq pointer at a device-chosen offset
past the end of the fresh vcalloc'ed table?

Would snapshotting both values into locals before the check and using only
the snapshot for the allocation size and the index close this?

[ ... ]

> diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
> index 0c395917b2144..0b48ded0aecda 100644
> --- a/include/net/mana/gdma.h
> +++ b/include/net/mana/gdma.h
> @@ -418,7 +418,26 @@ struct gdma_context {
>  
>  	/* This maps a CQ index to the queue structure. */
>  	unsigned int		max_num_cqs;
> -	struct gdma_queue	**cq_table;
> +	/* Both the base pointer and each entry are RCU-managed.  The fast
> +	 * path (mana_gd_process_eqe) reads the base via rcu_dereference()
> +	 * under rcu_read_lock(), so the table is freed with
> +	 * rcu_assign_pointer(NULL) + synchronize_rcu() and an in-flight
> +	 * reader can never observe freed memory.
> +	 *
> +	 * The slow paths -- mana_gd_destroy_cq() and the CQ install/remove
> +	 * callers (mana_create_txq/_rxq, mana_ib_install/remove_cq_cb) --
> +	 * instead read the base with rcu_dereference_protected(cq_table,
> +	 * true).  The bare "true" is justified by teardown ordering, not by
> +	 * a lock: the base table is replaced+freed only by
> +	 * mana_hwc_destroy_channel() (and the create-time reinit), and every
> +	 * teardown path first runs mana_remove() + mana_rdma_remove(), which
> +	 * synchronously drain the netdev and the IB device
> +	 * (unregister_netdevice / ib_unregister_device) that bound all
> +	 * install/remove callers; the reinit case runs before either
> +	 * consumer is probed.  So no slow-path caller can run while the base
> +	 * table is being freed.
> +	 */
> +	struct gdma_queue	__rcu * __rcu *cq_table;

[Severity: Medium]

Is the statement "every teardown path first runs mana_remove() +
mana_rdma_remove(), which synchronously drain the netdev and the IB device
(unregister_netdevice / ib_unregister_device)" accurate for the suspend
and shutdown paths?

mana_gd_suspend() (also reached from the reset service work via
mana_serv_reset()) and mana_gd_shutdown() both call
mana_remove(&gc->mana, true), and the suspending branch deliberately keeps
the netdev registered:

mana_en.c:mana_remove() {
	...
		if (suspending) {
			/* No need to unregister the ndev. */
			rtnl_unlock();
			continue;
		}

		unregister_netdevice(ndev);
	...
}

RTNL is then dropped and mana_gd_cleanup_device() ->
mana_hwc_destroy_channel() runs:

	old_cq_table = rcu_replace_pointer(gc->cq_table, NULL, true);
	synchronize_rcu();
	vfree(old_cq_table);

mana_detach(ndev, false) also calls netif_device_detach() while leaving
apc->port_st_save == true, so a concurrent RTNL reconfiguration in that
window (mana_change_mtu(), mana_set_channels(), mana_set_ringparam(), XDP
set) takes the "if (!from_close && !netif_device_present(ndev)) return 0;"
early return in mana_detach() and proceeds into mana_attach() ->
mana_alloc_queues() -> mana_create_txq(), which does:

	cq_table = rcu_dereference_protected(gc->cq_table, true);
	if (WARN_ON(!cq_table || cq->gdma_id >= gc->max_num_cqs)) {
	...
	rcu_assign_pointer(cq_table[cq->gdma_id], cq->gdma_cq);

These installers are writers, not RCU readers, so synchronize_rcu() does
not wait for them, and the !cq_table test is a check rather than
protection. Can this store land in the vfree()d table?

One step I could not confirm: mana_attach() first issues
mana_query_vport_cfg() over the HWC after mana_gd_deregister_device(), and
whether the PF still answers that is device behaviour; on the
mana_serv_reset() path hwc->hwc_timeout is 0 so the command times out, and
on PM suspend userspace is frozen, which leaves the reboot /
mana_gd_shutdown() window as the plausible case. The unsynchronized writer
predates this patch, but the lifetime rule stated here is new, so should
the invariant be corrected (serialize base replacement against the
installers, or run the installers under rcu_read_lock())?

One more on the same comment: mana_gd_destroy_cq() is listed as covered by
this rule, but it is called from inside mana_hwc_destroy_channel() itself
(mana_hwc_destroy_cq() -> mana_gd_destroy_queue() -> mana_gd_destroy_cq()),
a few statements before that function replaces and vfree()s the base
table. Should that intra-function ordering be spelled out here as well,
since it is what actually makes that caller's "true" predicate sound?
