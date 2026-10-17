Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C78C353A87;
	Sat, 17 Oct 2026 15:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792251566; cv=none; b=MM4ie7AQp/8JE4bnyvC/XB6n2CD3KNjT/pn4wmjbJ0ij2LMH5Xrw+4bbpBRgNvnkzL7ojQcFwNtAJeO77mIlsR9bRpC7X28Eq0SUGD7sgyvBp0Ed/DoOiiTFHGq3ak6VM52SdNd9FwU8+JkXsbLGjesNg2vBIcrWkpUAUidbNDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792251566; c=relaxed/simple;
	bh=7boXGZZOqBs1QxdlmdTNCjgxYvKpgnwoLu8Dzs6hwOI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=kkBjOkzr7cJkuPLeiufyqZvnieGA1+9YHshIyWWwr4jJeT0H7HAudi6ev8qnw6Fzh0pH1ZMXlxD2hGfX8uDyocMoRiQezNI9s03iVhGLGgO8GE0DXJcGdE8CearqzzNnw5rdS/41bIjJp+vC14Xx+2VRuTnxGWjYTv3CrnEpa+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SSD6ulB3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SSD6ulB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 951501F000C5;
	Sat, 17 Oct 2026 15:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792251564;
	bh=9qD/6IXOTdOzBSaIKQ8Ej0q671dPVWbgJ2yjtKtBXiw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SSD6ulB3YupXegdsql94e9ebU/5uYEoKuOgTe6+BGhBCLyLZ5bSCEQtkXjU4Y2QmO
	 NPCODqKeAll8barsdf3pGwp/kIMb39u+zV0wwrUbVJpp6QLJhwyIT1lkOHWfLAB3Nd
	 IgO8hDbboo4esv5IgVYo/Kxo2/Cuo6wfoPecj0SIXu/c4KGepWepWVT9DchQ2+zHHp
	 /TvwuFz4UjcG7NTTA6P7vib+4CLt/Wq1jG9I0qZ2w8J2V1VbbaE7S4qtZniGp7j2Qr
	 hvTFDzalAS7azMI07pmbXj9OXv9NuN3VpAJnIBvSGPX4ecMGDBEYKyWI/tBF0iK9v2
	 dfOurhFumPGZg==
Message-ID: <sashiko-outbox-175602@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v7 02/13] net: mana: share the EQ pool across a
 queue-set swap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org, bpf@vger.kernel.org
In-Reply-To: <9b7e62cc70138f8940a32869da44c1260748be14.1791710735.git.weh@linux.microsoft.com>
References: <cover.1791710735.git.weh@linux.microsoft.com>
 <9b7e62cc70138f8940a32869da44c1260748be14.1791710735.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 15:39:24 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] mana_ib_remove_cq_cb: Use-After-Free due to missing RCU synchroniz=
ation
- [High] net: mana: Unbounded RTNL stall during queue teardown if EQ is dead
- [High] mana: NULL pointer dereference in mana_gd_process_eqe()
--

commit 5cede1970aed52e8e7cc0e961f84924a35708274
Author: Long Li <longli@microsoft.com>

net: mana: share the EQ pool across a queue-set swap

This patch makes the EQ pool port-owned so overlapping queue sets share EQs
instead of requiring new allocations. It initializes EQ callbacks and
throttles before IRQ publication, introduces a lockless RCU pattern for
CQ table publication, and modifies CQ teardown to flush events and wait
for RCU readers.

> diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana=
/cq.c
> index d4e5e3f912689..0b6ad2547e0ef 100644
> --- a/drivers/infiniband/hw/mana/cq.c
> +++ b/drivers/infiniband/hw/mana/cq.c
> @@ -155,7 +155,8 @@ int mana_ib_install_cq_cb(struct mana_ib_dev *mdev, s=
truct mana_ib_cq *cq)
>  	gdma_cq->type =3D GDMA_CQ;
>  	gdma_cq->cq.callback =3D mana_ib_cq_handler;
>  	gdma_cq->id =3D cq->queue.id;
> -	gc->cq_table[cq->queue.id] =3D gdma_cq;
> +	/* Pairs with the acquire load in mana_gd_process_eqe(). */
> +	smp_store_release(&gc->cq_table[cq->queue.id], gdma_cq);
>  	return 0;
>  }

[Severity: High]
This patch converts the IB CQ table publication into a lockless RCU pattern,
but does the teardown path in mana_ib_remove_cq_cb() also need to be update=
d?

If a hardware EQ completion occurs concurrently while mana_ib_remove_cq_cb()
is tearing down the CQ, it calls kfree(gc->cq_table[cq->queue.id]) directly
without an RCU grace period. The hardirq handler (mana_gd_process_eqe)
reads this via smp_load_acquire() and dereferences the freed pointer,
leading to a use-after-free.

Should mana_ib_remove_cq_cb() use cmpxchg() and synchronize_rcu() for
teardown, similar to what was added for Ethernet CQs in
mana_gd_destroy_cq()?

[ ... ]
> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/ne=
t/ethernet/microsoft/mana/gdma_main.c
> index ae0ed700b3b93..078b3666947a4 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> @@ -768,7 +768,8 @@ static void mana_gd_process_eqe(struct gdma_queue *eq)
>  		if (WARN_ON_ONCE(cq_id >=3D gc->max_num_cqs))
>  			break;
> =20
> -		cq =3D gc->cq_table[cq_id];
> +		/* Match release publication of the CQ and its callback state. */
> +		cq =3D smp_load_acquire(&gc->cq_table[cq_id]);

[Severity: High]
Can gc->cq_table be NULL when this acquire load executes?

During channel initialization, mana_hwc_establish_channel() communicates
with the hardware. The hardware begins executing and sends
GDMA_EQE_HWC_INIT_DATA events to the EQ, including HWC_INIT_DATA_MAX_NUM_CQ=
S,
which populates gc->max_num_cqs.

However, gc->cq_table is not allocated via vcalloc() until after the
hardware initialization completes and mana_hwc_establish_channel() resumes.
If the hardware sends a spurious or unexpected GDMA_EQE_COMPLETION event in
this window, the bounds check passes because gc->max_num_cqs is already set.
The handler then executes smp_load_acquire() before the table is actually
allocated, which would result in a NULL pointer dereference.

[ ... ]
> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/=
ethernet/microsoft/mana/mana_en.c
> index 7586972e78e09..4b2c8039b8fa3 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
[ ... ]
> @@ -2653,12 +2712,25 @@ static void mana_schedule_napi(void *context, str=
uct gdma_queue *gdma_queue)
> =20
>  static void mana_deinit_cq(struct mana_port_context *apc, struct mana_cq=
 *cq)
>  {
> -	struct gdma_dev *gd =3D apc->ac->gdma_dev;
> +	struct gdma_context *gc =3D apc->ac->gdma_dev->gdma_context;
> +	struct gdma_queue *gdma_cq =3D cq->gdma_cq;
> +	struct gdma_queue *eq;
> +	int err;
> =20
> -	if (!cq->gdma_cq)
> +	if (!gdma_cq)
>  		return;
> =20
> -	mana_gd_destroy_queue(gd->gdma_context, cq->gdma_cq);
> +	eq =3D gdma_cq->cq.parent;
> +	if (gdma_cq->id < gc->max_num_cqs && eq &&
> +	    eq->id !=3D INVALID_QUEUE_ID) {
> +		/* Flush queued events after WQ teardown, before removing this CQ. */
> +		err =3D mana_gd_test_eq(gc, eq);
> +		if (err && mana_en_need_log(apc, err))
> +			netdev_err(apc->ndev, "Failed to flush EQ %u for CQ %u: %d\n",
> +				   eq->id, gdma_cq->id, err);
> +	}
> +
> +	mana_gd_destroy_queue(gc, gdma_cq);
>  }

[Severity: High]
Could this sequential mana_gd_test_eq() call lead to an unbounded RTNL
stall if an EQ stops delivering interrupts?

If an EQ is dead but the hardware channel remains responsive,
mana_gd_test_eq() will wait its full 30-second timeout.

Since mana_deinit_cq() is called sequentially for every single TX and RX
queue during teardown (via mana_destroy_txq() and mana_destroy_rxqs()),
a typical device with 64 queues would experience a 30-second timeout
per queue. This could result in an unrecoverable stall of over an hour
while holding the global RTNL lock, blocking all networking management.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1791710735.gi=
t.weh@linux.microsoft.com?part=3D2
