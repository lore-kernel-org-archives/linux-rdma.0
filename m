Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017688;
	b=UiGxQTEjpHJFh6exQHSQjtwq/69+EZgd0jorKkR8jv4pbm+RmqSBOE1GAlmpbw4nhhBJ
	 4G/X8GbVUdtvign1WjweqgClMPIMHpv/hT2Ki6L9A/Bjc0XtNyny5ln3LZj3ACVu61bAt
	 TCKiwhkjYuMSfiYKaD8DRFzg5njrLKRCiC7AYlk5KzJg3fdPaSe7VTHfYKTFjkmW+zw38
	 5T8mBF7CYEWN4Gw6wIORUZ1M1Hx3EwUZVovwfVCZr6brI0u5NqZzODOCkWSgDZyzvibax
	 E6Un9oV6HwUCb2XM9DzrCk1iMa9wWtG/b6QKeWsIpmP+vg2xAOyU/FD47lH7oRLqe5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017688;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=cZRFw/Cjww35iujiqXHHNdAn+2wX+SxDrxLrRxf+LE0=;
	b=Q26hCDwK4HJq/WL3eEPrz/T7h1XMPHQbcsFuhLztCdtbnv8BA0wYtI+QoQbUyz7P6D0B
	 za7r7wf4v6cek7DB9OAj7TzKkKTe/SkSHlRcmZYNe7r9WnVmDbP+xVSUI/yuJERX+nLzd
	 k2wKai5p/0jfufE/3zFSc1926dobOzCUfB+Ur2DXO9VSgmyzWioHjApU6dldp2dynkhzE
	 d2D7dPtP/SweDtMzTIF8A6xiO6KRvDrOcqBGkSyP9dpaRH9ZcVdL7qUZPLaA8IgegQN+0
	 uU4D/OrOEd5YqOYF3w7+1nsa9XtzI/empLViXVacO3UMJHiwmJ9bxYJHvwUHPlIQRbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MIHSjrJo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE467606A32C;
	Wed, 18 Nov 2026 16:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MIHSjrJo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5297B1F000C6;
	Wed, 18 Nov 2026 16:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795017688;
	bh=cZRFw/Cjww35iujiqXHHNdAn+2wX+SxDrxLrRxf+LE0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MIHSjrJoVsf63UVtW2KIRg0guTCkRD2dmYU0Q79uMV9LENF+BVohX6I2oioIMMKXC
	 sC0DdqYhX5TpmHwtI0ImMFG63XYTDepJk6gUElOMd+xF8wMDOlxis6Zghw10fR0Hl1
	 rX+qLGQLewCPAjrn+twvhAmG/rscSIcoePIiIGPo548wP9tvWOWwEJx+gHC4+qWI2r
	 c6trBZg0eRJBTgxI591M0Cfc2jgK43l3muB5lHwzyl5fgnaNaabjKYL+rhbEgyx+1a
	 ecAlkJ6gT/s14NDE+DG9Je2uCkozfj4VIvrW88pLI+YvEPhZrWijVWI6xEE7i8tOO5
	 QKwOTscE4S/Lw==
Message-ID: <sashiko-outbox-221402@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v11 3/4] net: mana: support concurrent HWC
 requests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <45db2acd8f03421191f5b3a9f4bd7ce9e9259b33.1794751992.git.weh@linux.microsoft.com>
References: <cover.1794751992.git.weh@linux.microsoft.com>
 <45db2acd8f03421191f5b3a9f4bd7ce9e9259b33.1794751992.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 16:01:27 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [High] net: mana: skipped mana_gd_put_gic() on EQ teardown breaks
  remove_irqs()
- [High] RDMA/mana_ib: returning errors in mana_ib_destroy_qp() breaks
  teardown
- [High] RDMA/mana_ib: mana_ib_destroy_cq() leaves dangling callback on
  rejection
- [Medium] net: mana: leaked GIC ref when mana_gd_create_mana_eq() is
  rejected
--

commit 2f3af75d69a80c300f076a62ab2f24d6ea93aab2
Author: Long Li <longli@microsoft.com>

net: mana: support concurrent HWC requests

This commit adds reference-counted HWC caller slots, serializes SQ
posting, quarantines timed-out HWC slots, and propagates local HWC
request rejections across MANA Ethernet and RDMA teardown paths.

Link: https://lore.kernel.org/r/20260908035201.402424-4-longli@microsoft.com
Link: https://lore.kernel.org/r/20260914175044.2a26bb46@kernel.org
Link: https://lore.kernel.org/r/179196575640.434549.9102950927041409151@ker=
nel.org
Link: https://lore.kernel.org/r/179250339266.3135.15035365058593192217@kern=
el.org
Link: https://lore.kernel.org/r/179455240021.2199510.18244084352437360589@k=
ernel.org

> diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana=
/cq.c
> index 843e2c64b32bc..95b7c250494b1 100644
> --- a/drivers/infiniband/hw/mana/cq.c
> +++ b/drivers/infiniband/hw/mana/cq.c
> @@ -169,16 +170,14 @@ int mana_ib_destroy_cq(struct ib_cq *ibcq, struct i=
b_udata *udata)
> =20
>  	mdev =3D container_of(ibdev, struct mana_ib_dev, ib_dev);
> =20
> -	mana_ib_remove_cq_cb(mdev, cq);
> -
> -	/* Ignore return code as there is not much we can do about it.
> -	 * The error message is printed inside.
> -	 */
> -	mana_ib_gd_destroy_cq(mdev, cq);
> +	err =3D mana_ib_gd_destroy_cq(mdev, cq);
> +	if (mana_gd_is_request_rejected(err) ||
> +	    READ_ONCE(cq->queue.retain_dma))
> +		return err ? err : -ENOTCONN;
> =20
> -	mana_ib_destroy_queue(mdev, &cq->queue);
> +	mana_ib_remove_cq_cb(mdev, cq);
> =20
> -	return 0;
> +	return mana_ib_destroy_queue(mdev, &cq->queue);
>  }

[Severity: High]
Does returning early here leave a dangling CQ callback in
gc->cq_table[cq->queue.id]?

For kernel CQs, ib_free_cq() and the error path of __ib_alloc_cq() free
the ib_cq even when destroy_cq() returns an error; for user CQs,
uverbs_destroy_ufile_hw() falls back to RDMA_REMOVE_DRIVER_FAILURE and
frees cq->ibcq.uobject.  Because mana_ib_remove_cq_cb() and
mana_gd_detach_cq() (called via mana_ib_destroy_queue() ->
mana_gd_destroy_queue() for kernel CQs) are both skipped when
mana_ib_gd_destroy_cq() is rejected or retain_dma is set, a subsequent
completion EQE will invoke mana_ib_cq_handler() on the freed CQ or
uobject.

> diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana=
/qp.c
> index 15c5d6cefd628..5e4eed814d61b 100644
> --- a/drivers/infiniband/hw/mana/qp.c
> +++ b/drivers/infiniband/hw/mana/qp.c

[ ... ]

> @@ -1030,12 +1093,11 @@ static int mana_ib_destroy_rc_qp(struct mana_ib_q=
p *qp, struct ib_udata *udata)
>  	if (err)
>  		return err;
> =20
> -	mana_table_remove_qp(mdev, qp);
> +	err =3D mana_ib_gd_destroy_rnic_qp(mdev, qp);
> +	if (mana_gd_is_request_rejected(err))
> +		return err;
> =20
> -	/* Ignore return code as there is not much we can do about it.
> -	 * The error message is printed inside.
> -	 */
> -	mana_ib_gd_destroy_rnic_qp(mdev, qp);
> +	mana_table_remove_qp(mdev, qp);
>  	for (i =3D 0; i < MANA_RC_QUEUE_TYPE_MAX; ++i)
>  		mana_ib_destroy_queue(mdev, &qp->rc_qp.queues[i]);
> =20
> @@ -1052,11 +1114,11 @@ static int mana_ib_destroy_uc_qp(struct mana_ib_q=
p *qp, struct ib_udata *udata)
>  	if (err)
>  		return err;
> =20
> +	err =3D mana_ib_gd_destroy_rnic_qp(mdev, qp);
> +	if (mana_gd_is_request_rejected(err))
> +		return err;
> +
>  	mana_table_remove_qp(mdev, qp);
> -	/* Ignore return code as there is not much we can do about it.
> -	 * The error message is printed inside.
> -	 */
> -	mana_ib_gd_destroy_rnic_qp(mdev, qp);
>  	for (i =3D 0; i < MANA_UC_QUEUE_TYPE_MAX; ++i)
>  		mana_ib_destroy_queue(mdev, &qp->uc_qp.queues[i]);
> =20
> @@ -1073,16 +1135,16 @@ static int mana_ib_destroy_ud_qp(struct mana_ib_q=
p *qp, struct ib_udata *udata)
>  	if (err)
>  		return err;
> =20
> +	err =3D mana_ib_gd_destroy_ud_qp(mdev, qp);
> +	if (mana_gd_is_request_rejected(err))
> +		return err;
> +
>  	mana_table_remove_qp(mdev, qp);
>  	mana_remove_qp_from_cqs(qp, false);
> =20
>  	destroy_shadow_queue(&qp->shadow_rq);
>  	destroy_shadow_queue(&qp->shadow_sq);
> =20
> -	/* Ignore return code as there is not much we can do about it.
> -	 * The error message is printed inside.
> -	 */
> -	mana_ib_gd_destroy_ud_qp(mdev, qp);
>  	for (i =3D 0; i < MANA_UD_QUEUE_TYPE_MAX; ++i)
>  		mana_ib_destroy_queue(mdev, &qp->ud_qp.queues[i]);

[Severity: High]
Can returning an error from mana_ib_destroy_{rc,uc,ud}_qp() before
mana_table_remove_qp() and mana_remove_qp_from_cqs() cause a
use-after-free during device removal or HWC reset recovery?

During mana_serv_reset() -> mana_gd_suspend() -> mana_rdma_remove() ->
mana_ib_remove(), mana_drain_gsi_sqs() adds the kernel GSI QP to the MAD
CQ's send_err_qp_list and schedules cq->work.  When ib_unregister_device()
then closes the MAD port, mana_ib_destroy_ud_qp() returns -ENOTCONN, which
causes ib_destroy_qp_user() to abort without dropping port_priv->cq->usecnt
or removing the QP from send_err_qp_list and mdev->qp_table_wq.
ib_free_cq() then hits WARN_ON_ONCE(atomic_read(&cq->usecnt)) and skips
cancelling cq->work before ib_dealloc_device() frees mdev, leaving
ib_cq_poll_work() and EQE handlers to dereference freed memory.

In addition, create_qp()'s err_security unwind in
drivers/infiniband/core/verbs.c ignores the return value of destroy_qp()
and frees qp, and uverbs_destroy_ufile_hw() frees qp->uobject on
RDMA_REMOVE_DRIVER_FAILURE, both leaving a freed QP in mdev->qp_table_wq.

> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/ne=
t/ethernet/microsoft/mana/gdma_main.c
> index fc460d83fb800..0160ad55a21ff 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c

[ ... ]

> @@ -1117,7 +1181,8 @@ static int mana_gd_create_eq(struct gdma_dev *gd,
>  	return 0;
>  out:
>  	dev_err(dev, "Failed to create EQ: %d\n", err);
> -	mana_gd_destroy_eq(gc, false, queue);
> +	if (mana_gd_is_request_rejected(mana_gd_destroy_eq(gc, false, queue)))
> +		err =3D -ENOTCONN;
>  	queue->eq.msix_index =3D INVALID_PCI_MSIX_INDEX;
>  	return err;
>  }

[ ... ]

> @@ -1385,7 +1451,10 @@ int mana_gd_create_mana_eq(struct gdma_dev *gd,
>  out:
>  	dev_err(gc->dev, "Failed to create queue type %d of size: %u, err: %d\n=
",
>  		spec->type, spec->queue_size, err);
> -	mana_gd_free_memory(gmi);
> +	if (!mana_gd_is_request_rejected(err) ||
> +	    (gmi->dma_region_handle =3D=3D GDMA_INVALID_DMA_REGION &&
> +	     !queue->eq.disable_needed))
> +		mana_gd_free_memory(gmi);
>  free_q:
>  	kfree(queue);
>  	return err;

[Severity: Medium]
Does mana_gd_create_mana_eq() cause its callers (mana_create_eq() and
mana_ib_create_eqs()) to leak the GIC reference and MSI-X bitmap entry when
an HWC request is rejected before the hardware EQ exists, or when
mana_gd_destroy_eq() succeeds after mana_gd_test_eq() is rejected?

In both cases queue->eq.disable_needed is false and queue is freed, yet
mana_gd_create_mana_eq() still returns a rejected error code (-ENOTCONN or
-ENODEV), so the callers skip mana_gd_put_gic().  Also, if
mana_gd_create_dma_region() succeeded and mana_gd_create_eq() then fails
before mana_gd_create_hw_eq() consumes gmi->dma_region_handle, the unwind
path never calls mana_gd_destroy_dma_region().

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/=
ethernet/microsoft/mana/mana_en.c
> index 744e6ceb7d2b9..1af0ed35c5988 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c

[ ... ]

> @@ -1791,8 +1793,8 @@ void mana_destroy_eq(struct mana_port_context *apc)
>  			continue;
> =20
>  		msi =3D eq->eq.msix_index;
> -		mana_gd_destroy_queue(gc, eq);
> -		mana_gd_put_gic(gc, !gc->msi_sharing, msi);
> +		if (!mana_gd_is_request_rejected(mana_gd_destroy_queue(gc, eq)))
> +			mana_gd_put_gic(gc, !gc->msi_sharing, msi);
>  	}
> =20
>  	kfree(apc->eqs);

[Severity: High]
Does skipping mana_gd_put_gic() here and in mana_ib_destroy_eqs() break
mana_gd_remove_irqs() and mana_cdx_remove_irqs() during device reset or
removal?

When HWC requests are rejected (for example after mana_serv_reset() calls
mana_gd_cancel_hwc_timeout()), mana_gd_destroy_queue() returns -ENOTCONN
after deregistering the EQ from gic->eq_list, and the callers free
apc->eqs and mdev->eqs without dropping their gic->refcount references.
When mana_gd_cleanup() then runs mana_gd_remove_irqs() or
mana_cdx_remove_irqs(), it calls mana_gd_put_gic() only once per vector:

drivers/net/ethernet/microsoft/mana/gdma_pci.c:mana_gd_remove_irqs() {
	...
	xa_for_each(&gc->irq_contexts, msi, gic)
		mana_gd_put_gic(gc, false, msi);

	WARN_ON(!xa_empty(&gc->irq_contexts));

	pci_free_irq_vectors(pdev);
}

For any vector whose refcount was elevated by both setup_hwc_irqs and an
EQ (such as MSI 0 used by fatal_err_eq, shared MSI vectors, or all vectors
on CDX and non-dynamic MSI-X), refcount_dec_and_test(&gic->refcount) does
not reach zero, so free_irq() and xa_erase() are skipped before
WARN_ON(!xa_empty(&gc->irq_contexts)) and pci_free_irq_vectors() /
msi_domain_free_irqs_all(), leaving the IRQ handlers registered when gc is
freed or resumed.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1794751992.gi=
t.weh@linux.microsoft.com?part=3D3
