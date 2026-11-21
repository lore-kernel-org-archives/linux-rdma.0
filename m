Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795278574;
	b=D+nNyxq9uvsEUXczKobsYOGRrGduij8tHl2uVpXFDM6kOm7yq5Eu451XA/AdDmEd8Vo/
	 TqL2zi9IaeOVIoC7GSLzfZGnN7QpaS6nQnYDsqTibV8EVkrkgAd5rIzyqVzYm2U7ZcZYi
	 m4kZzGTtcoQYjjYfP39Y95Hy+P+eE0zrDciahRyOsN+wu6jnNrFOxb3PydstmOiqBEtTc
	 Y+Neh0hXvuzY2wkr+e+sxOXdLL4W88NbvOSEGlxHReYdhQhtLSJZ1nxS+R19DyUwhaHOY
	 o79KXJVJeiwG+K+onlRscWv5vUcjPvTEqp1h45MxvC4py+JVnaWgLcnK3d79lqnj8lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795278574;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=/gvhPLIVhCoxfejxGP171pEQlCwakQHiu1fq9DJdqP0=;
	b=rvcpUxIMPbhadJaTCuONzyYrMAZ+rFl6x0ZkiGKwymKdA0Z+a3IJtbf5WQgGpYdbaG01
	 iSvOBxd99hFPCA+MP8HzJSU0i2s2frIUsZme3INlwB0dOn1uMqtJQcFjOfa08AGgu8Sq9
	 QA4AHGZKzr4DQyRCStuEWOX3pjiCfCMBP1Po5RgCBEh13MpZJZDVfjngfrpyrlcc1HTQh
	 HFIhZWOMWNxmbaGyfKcxfDhHdm5ri50TvACN7mQbationgGZxHDZuWcZUNC8uIrrFeYu1
	 JsyUx7e3QIrxmhiARByLW8JX4COuBTH2bz0HA6QoRSTy6vXnd4DLD3EoB6Xe9MCaSiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f4gRizVT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E31606A331;
	Sat, 21 Nov 2026 16:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f4gRizVT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A891F000C0;
	Sat, 21 Nov 2026 16:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795278574;
	bh=/gvhPLIVhCoxfejxGP171pEQlCwakQHiu1fq9DJdqP0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=f4gRizVTQZflQ8m1Dtia7NvYwVC4X6V94nR10u7nGFrbVAgunw20qY292yIUUc8fa
	 s8mGhnojRxlG6QzXxvURV/1ag3NboCIBl6Jb2xX01+niVxysO+2P1cNcHaqnDaBZnX
	 gajCj/t51KVp521bjSwQlzDk61cjvZKoJ7/6RQkjWqtnyw24yyRtJnkiTD/BMGJeNW
	 K9BZdsusXmSItdeRu6HSb50xbZSUKkRedaKEiBr287y81q5v79UlgktfUvYdPJw+S3
	 tLOV9ZtmggRv5JNcNocFJ+7EgNDTWCghdEgSJF5OvGCKfk8SCQZ7sAP7ixfvwm8YKO
	 g5gSPHcrK4SfQ==
Subject:
 Re: [PATCH net-next v11 3/4] net: mana: support concurrent HWC requests
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
 mawasthi@linux.microsoft.com, weh@microsoft.com, edumazet@kernel.org,
 shacharr@microsoft.com
Date: Sat, 21 Nov 2026 16:29:31 +0000
Message-ID: <179527857180.3135.15262062177473658662@kernel.org>
In-Reply-To: <45db2acd8f03421191f5b3a9f4bd7ce9e9259b33.1794751992.git.weh@linux.microsoft.com>
References: <45db2acd8f03421191f5b3a9f4bd7ce9e9259b33.1794751992.git.weh@linux.microsoft.com>
X-sashiko-severity: Critical
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

Thank you for your contribution! Sashiko AI review found 5 potential
issue(s) to consider.

Critical: 1 · High: 2 · Medium: 2 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Critical] When a kernel CQ destroy is rejected locally,
  mana_ib_destroy_cq() leaves a dangling CQ callback, and a later…
- [High] EQ references to MSI-X/IRQ contexts (GIC references) that are
  kept after a rejected EQ destroy break mana_gd_remove_irqs() and the…
- [High] RDMA/mana_ib: returning errors in mana_ib_destroy_qp() breaks
  teardown
- [Medium] mana_create_eq() (mana_en.c) and mana_ib_create_eqs()
  (infiniband main.c) skip mana_gd_put_gic() whenever…
- [Medium] The Ethernet objects that are kept after a rejected destroy
  become unreachable, so they leak permanently on every service-reset…

--

net: mana: support concurrent HWC requests

This patch gives each HWC message slot separate sender and response
references. Timed-out requests are quarantined until their late response
arrives, and admission now waits on a waitqueue instead of a semaphore.
It also adds a "locally rejected" error class (-ENOTCONN/-ENODEV/-EMSGSIZE)
and propagates it through the Ethernet and RDMA destroy paths, so that
memory the device may still own is retained instead of freed.

Link: https://lore.kernel.org/r/20260908035201.402424-4-longli@microsoft.com
Link: https://lore.kernel.org/r/20260914175044.2a26bb46@kernel.org
Link: https://lore.kernel.org/r/179196575640.434549.9102950927041409151@kernel.org
Link: https://lore.kernel.org/r/179250339266.3135.15035365058593192217@kernel.org
Link: https://lore.kernel.org/r/179455240021.2199510.18244084352437360589@kernel.org

> diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana/cq.c
> index 843e2c64b32bc..95b7c250494b1 100644
> --- a/drivers/infiniband/hw/mana/cq.c
> +++ b/drivers/infiniband/hw/mana/cq.c

[ ... ]

> @@ -169,16 +170,14 @@ int mana_ib_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
>  
>  	mdev = container_of(ibdev, struct mana_ib_dev, ib_dev);
>  
> -	mana_ib_remove_cq_cb(mdev, cq);
> -
> -	/* Ignore return code as there is not much we can do about it.
> -	 * The error message is printed inside.
> -	 */
> -	mana_ib_gd_destroy_cq(mdev, cq);
> +	err = mana_ib_gd_destroy_cq(mdev, cq);
> +	if (mana_gd_is_request_rejected(err) ||
> +	    READ_ONCE(cq->queue.retain_dma))
> +		return err ? err : -ENOTCONN;

[Severity: Critical]
Can this leave a dangling CQ callback for kernel CQs, which then runs on
freed memory?

For a kernel CQ, mana_ib_install_cq_cb() puts cq->queue.kmem into the
global table, and its context points back at the mana_ib_cq:

    gdma_cq->cq.context = cq;
    gdma_cq->cq.callback = mana_ib_cq_handler;
    gc->cq_table[cq->queue.id] = gdma_cq;

Before this patch the entry was always detached by
mana_ib_destroy_queue()->mana_gd_destroy_queue(kmem)->mana_gd_destroy_cq().
With the early return above, neither mana_ib_remove_cq_cb() nor
mana_ib_destroy_queue() runs when the destroy is rejected.

ib_free_cq() does not honour the driver's error, though:

drivers/infiniband/core/cq.c:ib_free_cq() {
    ...
	else
		ret = cq->device->ops.destroy_cq(cq, NULL);
	WARN_ONCE(ret, "Destroy of kernel CQ shouldn't fail");
	kfree(cq->wc);
	kfree(cq);
}

The freed mana_ib_cq can therefore still be reached through gc->cq_table.
mana_gd_process_eqe() indexes that table with the cq_id from any EQE,
whether it comes from an RDMA EQ, a still-live Ethernet EQ or the HWC EQ:

    cq = READ_ONCE(cq_table[cq_id]);
    ...
    if (cq->cq.callback)
        cq->cq.callback(cq->cq.context, cq);

mana_ib_cq_handler() then loads cq->ibcq.comp_handler from the freed
object and calls through it.

One way to reach this is mana_serv_reset()->mana_gd_cancel_hwc_timeout().
After that, mana_gd_suspend()->mana_rdma_remove()->ib_unregister_device()
tears down the GSI QP and calls ib_free_cq(). mana_ib_gd_destroy_cq() is
rejected with -ENOTCONN because no slot is free and the timeout is 0. A
single 30s timeout on the depth-one channel has the same effect, since it
quarantines the only slot.

mana_ib_retain_qp() is a second trigger. After a rejected UD/GSI QP
destroy in a create unwind, it sets retain_dma on the kernel send/recv
CQs, so their later destroy also takes this early return.

The WARN_ONCE in ib_free_cq() also fires every time this path is taken.

Should the software callback for kernel CQs be withdrawn here
unconditionally, even when the DMA memory has to be retained?

>  
> -	mana_ib_destroy_queue(mdev, &cq->queue);
> +	mana_ib_remove_cq_cb(mdev, cq);
>  
> -	return 0;
> +	return mana_ib_destroy_queue(mdev, &cq->queue);
>  }

[ ... ]

> diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
> index 858bbc325eb29..7d5a8fc7380d7 100644
> --- a/drivers/infiniband/hw/mana/main.c
> +++ b/drivers/infiniband/hw/mana/main.c

[ ... ]

> @@ -841,7 +862,8 @@ int mana_ib_create_eqs(struct mana_ib_dev *mdev)
>  
>  	err = mana_gd_create_mana_eq(mdev->gdma_dev, &spec, &mdev->fatal_err_eq);
>  	if (err) {
> -		mana_gd_put_gic(gc, false, 0);
> +		if (!mana_gd_is_request_rejected(err))
> +			mana_gd_put_gic(gc, false, 0);
>  		return err;
>  	}

[Severity: High]
Can a rejected destroy here leave the driver tracking a QP that the
RDMA core then frees anyway?

mana_ib_destroy_ud_qp(), mana_ib_destroy_rc_qp() and
mana_ib_destroy_uc_qp() now return before mana_table_remove_qp() and
mana_remove_qp_from_cqs() when the HWC rejects the command. The core
does not treat that error as "object still exists" in every caller.

First, ib_destroy_qp_user() returns the error without calling
ib_qp_usecnt_dec(), so the PD and CQ usecnt stay elevated. For the
kernel GSI QP this is on the same reset path as the CQ issue above:
mana_serv_reset()->mana_gd_cancel_hwc_timeout(), then
mana_gd_suspend()->mana_rdma_remove()->mana_ib_remove().

mana_drain_gsi_sqs() first links the GSI QP onto the MAD CQ's
send_err_qp_list and schedules cq->work. ib_unregister_device() then
reaches ib_mad_port_close()->destroy_mad_qp(), which gets -ENOTCONN.
ib_free_cq() hits WARN_ON_ONCE(atomic_read(&cq->usecnt)) and returns
without cancelling the CQ work. ib_dealloc_pd() warns, port_priv is
freed, and ib_dealloc_device() frees the mana_ib_dev. The queued CQ
work and later EQEs still reach the QP through mdev->qp_table_wq and
the CQ error lists, so they run on freed memory.

Second, the create_qp() unwind in drivers/infiniband/core/verbs.c
ignores the destroy_qp() return value at its err_security label and
does kfree(qp) unconditionally. mana_table_store_qp() has already run
at that point, so mdev->qp_table_wq keeps a pointer to the freed QP.
mana_get_qp_ref() then hands that pointer to mana_ib_event_handler()
on the next GDMA_EQE_RNIC_QP_FATAL.

Third, on uverbs close or disassociation, uverbs_destroy_ufile_hw()
falls back to RDMA_REMOVE_DRIVER_FAILURE. That path warns and frees
the uobject anyway. The undestroyed QP stays in mdev->qp_table_wq,
and its event handler dereferences the freed qp->uobject. The new
error returns from mana_ib_destroy_wq() and mana_ib_destroy_cq() have
the same problem on this path.

None of this needs unusual user action. A service reset, or a single
timeout on the depth-one channel, is enough to make the destroys
reject.

Could the destroy paths always drop the software state (qp table
entry, CQ error lists, CQ callbacks) and retain only the PF-owned DMA
mappings and umem, the way the Ethernet paths retain queue memory? If
the verbs object itself really has to stay alive, how is that meant
to work with core callers that cannot handle a failed destroy?

[Severity: Medium]
Does this leak the GIC reference when the rejected command was not the
EQ disable?

Both this call site and the matching one in mana_create_eq() in mana_en.c
decide whether to keep the GIC from the errno class alone. The assumption
is that a rejected errno means the device still owns the vector. But
mana_gd_create_mana_eq() also returns a rejected errno in cases where no
device EQ refers to the vector.

First, mana_gd_create_dma_region() can be rejected before any IRQ or EQ
exists. The region is still GDMA_INVALID_DMA_REGION and disable_needed is
false, so this branch frees the memory and still returns -ENOTCONN/-ENODEV:

    if (!mana_gd_is_request_rejected(err) ||
        (gmi->dma_region_handle == GDMA_INVALID_DMA_REGION &&
         !queue->eq.disable_needed))
        mana_gd_free_memory(gmi);

Second, mana_gd_create_hw_eq() can be rejected while disable_needed is
still false. Third, mana_gd_test_eq() can be rejected after create_hw_eq()
succeeded, and the cleanup disable then completes. In both cases
mana_gd_create_eq() keeps the original rejected err, because it only
remaps when the destroy itself is rejected:

    if (mana_gd_is_request_rejected(mana_gd_destroy_eq(gc, false, queue)))
        err = -ENOTCONN;

In each of these cases the reference from mana_gd_get_gic() is never
dropped, and in dedicated-MSI mode the msi_bitmap bit also stays set.

Could mana_gd_create_mana_eq() report whether the vector is still in use
by the device, instead of the callers inferring it from the errno?

[ ... ]

>  void mana_ib_destroy_eqs(struct mana_ib_dev *mdev)
>  {
>  	struct gdma_context *gc = mdev_to_gc(mdev);
> -	int i, msi;
> +	int err, i, msi;
>  
> -	mana_gd_destroy_queue(gc, mdev->fatal_err_eq);
> -	mana_gd_put_gic(gc, false, 0);
> +	err = mana_gd_destroy_queue(gc, mdev->fatal_err_eq);
> +	if (!mana_gd_is_request_rejected(err))
> +		mana_gd_put_gic(gc, false, 0);

[Severity: High]
What releases this retained GIC reference later?

Neither mana_ib_destroy_eqs() nor mana_destroy_eq() in mana_en.c keeps
the EQ anywhere afterwards; mana_destroy_eq() frees apc->eqs right after
this loop. mana_gd_remove_irqs() was not updated and still drops exactly
one reference per irq_contexts entry:

drivers/net/ethernet/microsoft/mana/gdma_pci.c:mana_gd_remove_irqs() {
    ...
	xa_for_each(&gc->irq_contexts, msi, gic)
		mana_gd_put_gic(gc, false, msi);

	WARN_ON(!xa_empty(&gc->irq_contexts));

	pci_free_irq_vectors(pdev);
    ...
}

If an EQ destroy was rejected, that GIC keeps a reference of 1. free_irq()
and xa_erase() never run for it, the WARN_ON fires, and
pci_free_irq_vectors() frees vectors whose handlers are still requested.

On the next mana_gd_resume() for the same gc,
mana_gd_setup_irqs()->mana_gd_get_gic() finds the stale entry:

    gic = xa_load(&gc->irq_contexts, msix_index);
    if (gic) {
        refcount_inc(&gic->refcount);
        ...
        goto out;
    }

request_irq() is never called on the newly allocated vector, and the old
gic->irq is used instead. msi 0 is shared between fatal_err_eq and the
HWC EQ, so would the new HWC come up without a working interrupt after a
service reset?

The path is mana_serv_reset()->mana_gd_cancel_hwc_timeout(), then
mana_gd_suspend()->mana_rdma_remove()->mana_ib_destroy_eqs(), where
mana_gd_disable_queue() gets -ENOTCONN. mana_destroy_eq() then does the
same for each Ethernet EQ, and finally mana_gd_cleanup() calls
mana_gd_remove_irqs().

>  
>  	for (i = 0; i < mdev->ib_dev.num_comp_vectors; i++) {
> -		mana_gd_destroy_queue(gc, mdev->eqs[i]);
>  		msi = (i + 1) % gc->num_msix_usable;
> -		mana_gd_put_gic(gc, false, msi);
> +		err = mana_gd_destroy_queue(gc, mdev->eqs[i]);
> +		if (!mana_gd_is_request_rejected(err))
> +			mana_gd_put_gic(gc, false, msi);
>  	}
>  
>  	kfree(mdev->eqs);

[ ... ]

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index 744e6ceb7d2b9..1af0ed35c5988 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c

[ ... ]

> @@ -2730,21 +2733,29 @@ static void mana_destroy_txq(struct mana_port_context *apc)

[ ... ]

> +		if (mana_gd_is_request_rejected(err)) {
> +			if (apc->tx_qp[i]->tx_cq.gdma_cq)
> +				mana_gd_detach_cq(gc,
> +						  apc->tx_qp[i]->tx_cq.gdma_cq);
> +			continue;
> +		}
> +
>  		mana_deinit_cq(apc, &apc->tx_qp[i]->tx_cq);
>  
>  		mana_deinit_txq(apc, &apc->tx_qp[i]->txq);

[Severity: Medium]
After the continue, what still points to the retained tx_qp[i]?

The loop is followed by:

    kfree(apc->tx_qp);
    apc->tx_qp = NULL;

So the retained mana_tx_qp, its CQ/SQ queues and their DMA memory become
unreachable. mana_destroy_rxq() is similar. It returns before
page_pool_destroy(), the RX page frees and kvfree(rxq), and the caller
then sets apc->rxqs[idx] to NULL. mana_destroy_eq() also skips the EQ
free and the GIC put, then calls kfree(apc->eqs).

This patch also makes mana_serv_reset() call mana_gd_cancel_hwc_timeout()
before mana_gd_suspend(). With the timeout at 0, the first teardown
command is posted and abandoned. Every later admission in
mana_hwc_try_get_msg_index() then returns -ENOTCONN:

    if (!mana_hwc_timeout_read(hwc) ||
        (u32)atomic_read(&hwc->abandoned_msgs) == r->size)
        err = -ENOTCONN;

As a result, most destroys in mana_remove()->mana_dealloc_queues() take
these retain branches on every service reset. In the baseline those
commands were posted, returned -ETIMEDOUT, and the memory was freed.

Is this unbounded per-reset leak intended? The commit message says:

  "Preserve the baseline cleanup policy for commands that were actually
  posted and then timed out or received PF errors"

It does not mention that the cancellation in mana_serv_reset() turns most
reset-time teardown into local rejection. If the objects have to be
retained, could they be kept somewhere they can be reclaimed once the
function has been reset, instead of being orphaned?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1794751992.git.weh%40linux.microsoft.com
