Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE753D9DA7;
	Wed, 14 Oct 2026 08:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791965187; cv=none; b=o3bosUHwopQzXn/N06t6EXTeh5S3niLhQCFaHp4zBNRFP6w4SIwzKKOBjv/3MUXZn5XsNaFUjE2/KUoTTfo7oNPNqY48t25DmGaQikOvkEX2Gb/CKiBnEcMZqwBIg1KqmsU3RcuAUZh5HnY+6xBoDsb5B8bmU2VA0QLX8x5fF6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791965187; c=relaxed/simple;
	bh=MG7Cl5ygUA5uIolS5giim+vF1nEOaG9L8t/xDZFxbFA=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=g0udMW25qxdwblDSuf3hhJxqxYCCe9hg0g5ywRfRL0gimF5Hb0WRedZ96ZDnBq0WQj2al/gyK9GqmavYk360OdvZnl8wMB2qLsi0qHnkK0UFdbXI+aN12UN1z0leyyO8dWYvc1NWVF4dzcNojUOkux9JngtFSUohyXuEkPDCbSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LQjilNVJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LQjilNVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 039E01F000FF;
	Wed, 14 Oct 2026 08:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791965186;
	bh=jI66Z/iPXZKk3ShJ7/C514MCHSuVE9iVO1re9PQetzU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LQjilNVJOOqoawILNqMVl/gaokeTjSSVk+M7gc5gv5UFfMt1Q4akgNKtUztcid67g
	 mRF9yXrb6irV0fgJVMyx1lEvscgep/85i460cd3mYbdca/aLR0zjCLsItRuQSjk5Cu
	 uouyzPTiNbjNCHklBT/yV8wu1IZAr85gPwRANbxTZbH+Laky/P2NdBsPmFShp6LfvW
	 2j/M+/foiiiN3gPiN0PKIAHhcFtpxDiSz0Ovh+hs8Yqvw463lkMj98PL4yw85ggX9u
	 KHEvLsOR6UQZVLmdWj1/d/pFq26HY/jqnxqLxOdY/Ub1VvV4JwKrzevB9xygs2RELs
	 w7zaxiVhWkZTg==
Message-ID: <sashiko-outbox-170992@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v7 1/4] net: mana: prepare HWC ownership for
 safe reinitialization
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <e6ef84d7481de34f259d2b244f7994e3f1d9ab6f.1791561995.git.weh@linux.microsoft.com>
References: <cover.1791561995.git.weh@linux.microsoft.com>
 <e6ef84d7481de34f259d2b244f7994e3f1d9ab6f.1791561995.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 08:06:25 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] net/mana: use-after-free in mana_gd_process_eqe() due to missing R=
CU grace period for CQ
- [Medium] net/mana: memory leak of software structures on HWC teardown fai=
lure
- [Low] net/mana: missing WRITE_ONCE in mana_gd_destroy_cq creates data race
--

commit 361a37c1499976f2c320b5cabc5e1273595fd5dd
Author: Long Li <longli@microsoft.com>

net: mana: prepare HWC ownership for safe reinitialization

Dynamic HWC queue sizing tears down the bootstrap queues and establishes a
second channel before publishing it. Prepare the existing HWC ownership and
teardown paths so that sequence cannot free or reuse state still reachable
by either the PF or an EQ handler.

Link: https://lore.kernel.org/r/20260908035201.402424-2-longli@microsoft.com
Link: https://lore.kernel.org/r/20260908035201.402424-5-longli@microsoft.com
Link: https://lore.kernel.org/r/178910960115.219967.13830871915506436112@ke=
rnel.org

> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/ne=
t/ethernet/microsoft/mana/gdma_main.c
> index ae0ed700b3b93..69da65a405a46 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
[ ... ]
> @@ -765,11 +766,16 @@ static void mana_gd_process_eqe(struct gdma_queue *=
eq)
>  	switch (type) {
>  	case GDMA_EQE_COMPLETION:
>  		cq_id =3D eqe->details[0] & 0xFFFFFF;
> -		if (WARN_ON_ONCE(cq_id >=3D gc->max_num_cqs))
> +		/* The IRQ handler's RCU read-side section protects the table
> +		 * until HWC teardown has fenced its EQ and waited for readers.
> +		 */
> +		cq_table =3D smp_load_acquire(&gc->cq_table);
> +		if (!cq_table || cq_id >=3D READ_ONCE(gc->max_num_cqs))
>  			break;
> =20
> -		cq =3D gc->cq_table[cq_id];
> -		if (WARN_ON_ONCE(!cq || cq->type !=3D GDMA_CQ || cq->id !=3D cq_id))
> +		cq =3D READ_ONCE(cq_table[cq_id]);

[Severity: High]
During HWC teardown, the dedicated HWC EQ is fenced (which includes a
synchronize_rcu() wait), and then the HWC CQ is destroyed. The CQ memory is
freed without a subsequent RCU grace period. Can a concurrently running IRQ
handler for a different active EQ (like an ENET EQ) read the CQ pointer from
cq_table just before it is cleared, and dereference it after it is freed he=
re?

Since the PF is untrusted, could a malicious or compromised PF send an HWC =
CQ
completion event to a different EQ? The synchronize_rcu() in the EQ teardown
doesn't protect the CQ because the CQ is removed from cq_table after that w=
ait.

[Severity: Low]
This problem wasn't introduced by this patch, but by upgrading the reader to
READ_ONCE() here, it highlights that mana_gd_destroy_cq() clears the CQ tab=
le
entry using a plain write:

    gc->cq_table[id] =3D NULL;

For normal networking queues, this happens before the EQ is fenced, so the =
EQ
handler may concurrently execute the READ_ONCE(cq_table[cq_id]). Should this
writer be updated to WRITE_ONCE() to prevent a formal data race?

> +		if (!cq || WARN_ON_ONCE(cq->type !=3D GDMA_CQ ||
> +					cq->id !=3D cq_id))
>  			break;
> =20
>  		if (cq->cq.callback)
[ ... ]
> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/n=
et/ethernet/microsoft/mana/hw_channel.c
> index 3bca4b683134b..b1d972968f0d7 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
[ ... ]
> @@ -808,30 +885,56 @@ int mana_hwc_create_channel(struct gdma_context *gc)
[ ... ]
>  void mana_hwc_destroy_channel(struct gdma_context *gc)
>  {
>  	struct hw_channel_context *hwc =3D gc->hwc.driver_data;
> +	struct gdma_queue **old_cq_table;
> +	int err;
> =20
>  	if (!hwc)
>  		return;
> =20
> -	/* gc->max_num_cqs is set in mana_hwc_init_event_handler(). If it's
> -	 * non-zero, the HWC worked and we should tear down the HWC here.
> +	/* An unacknowledged destroy leaves the PF's mappings live.  Fence
> +	 * software dispatch, but retain every PF-visible allocation.
>  	 */
> -	if (gc->max_num_cqs > 0) {
> -		mana_smc_teardown_hwc(&gc->shm_channel, false);
> -		gc->max_num_cqs =3D 0;
> +	err =3D mana_smc_teardown_hwc(&gc->shm_channel, false,
> +				    &hwc->setup_active);
> +	if (err) {
> +		dev_err(hwc->dev,
> +			"HWC teardown failed: %d, retaining PF-visible resources\n",
> +			err);
> +		mana_hwc_fence_channel(gc, hwc);
> +		return;
>  	}

[Severity: Medium]
If mana_smc_teardown_hwc() fails, mana_hwc_destroy_channel() returns early =
to
prevent the PF from writing to reallocated DMA buffers. However, does this
early return skip the deallocation of CPU-side software structures like hwc,
hwc->caller_ctx, and gc->cq_table?

Since these structures are pure software allocations and not DMA-mapped
PF-visible memory, should they be freed even if the hardware is unresponsiv=
e?

During driver unload (mana_gd_remove), vfree(gc) is eventually called, which
destroys the parent gdma_context and permanently leaks the retained
gc->hwc.driver_data (hwc) and gc->cq_table on this error path.

> =20
> +	/* Fence the EQ before releasing any state its handlers can reach. */
> +	if (hwc->cq)
> +		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);
> +

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1791561995.gi=
t.weh@linux.microsoft.com?part=3D1
