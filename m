Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793810631;
	b=bgSXFAAz1im9t78M+oJXQnMH/+M3lG/OhQ0aHqD/3EaJM64Sk6VPLJo0HMryqnSObVlD
	 0QyqcpK96Ep9VD4KZVEEYslaeVZ+hbPcUIIm9s/w07M1v8iZQVi9wPLtNi1lRG9AUjDkh
	 Qjote95BJzf0x0kghZo2yGhADB4b0eRCYl4wo6uC4uLs+5GRE9vHW4F9fpB9uM1gL3Jlo
	 VhVgJfuhQR73SUJauR1xH5xeqsImZylWYcW+lzd4UX8B62UkpPk9ulyCfX7ghaV2a/aFK
	 zqUr22oqdEUZ4OdOXEna9SqqJ8EnY2qM/+S9+ql3BsIF6pCgId/tGzYPv1VkBQcHqbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793810631;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Cm1Xi7ZgjVTT8XCTDtqau/pv7h8b/TJXohmLVDe6r08=;
	b=Be3WLWGC5nURhYJK2ETa65U+OiXQR8ePJUnYc/gp1E6+PVjCwBWLHutEk07L7MDES8b/
	 CxEX9Ut2E9JFcD9FBx50BNHP/IgGNYXQ3KBbdXrld8Wq6juIFtp7yohtvHzJtZNML3bvI
	 qjaR3rlblV0/rcADbPWjMX2GBFrrBzU/LMIJbCmCHGZgnvY1MnroItputCHfylCjdGc3k
	 cdHYFjF3zmHP7/7E1Ir2/00HGRAMXxWz4xEy6ikHN1goJc9s8jRFFwn3fhYQ5bZjEqn5G
	 iJyia0TDR+G1GqHfhyd1HZkbuqhOXX2IixgLUg2AlrQlaG0D4Qk3+ozC9Apk2Plgqkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="J/vmcL1e";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D7A606D809
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 16:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J/vmcL1e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699791F0093A;
	Wed,  4 Nov 2026 16:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810630;
	bh=Cm1Xi7ZgjVTT8XCTDtqau/pv7h8b/TJXohmLVDe6r08=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=J/vmcL1eR2KEavCEnGPJndO1/xIRtNI1NltbX9NApJS1oDZCMrr2pQGAKZeEnZvid
	 N+7Y4CdBJgKunbZpFrkqlWsqwvFLR3Ukc0835z+JEq3tNB6fD3tBioRfo9ahWyvTIS
	 r1s8BpgIW52cS2AZVwDmfbkTvG9RZaVJiLTplsRWtrDYheFXPCrCq9tzcS3sg4oIUr
	 MWPYM8cCJcrYhufA5duqUent1YX6jUT8clh+1XMRmj2lmhh18P6rWWMOobATDnHYQ4
	 T8T6wwqT+mWN/+ES8diKdDs6QLppH0uj+LKSDunyW/AmKRze5q2khg2AQcgMgvK8SO
	 AtvPaMxDD5tEA==
Message-ID: <sashiko-outbox-197669@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 16/23] RDMA/mlx5: Ignore completion events for
 a CQ without a handler
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103163949.1554-17-yishaih@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
 <20261103163949.1554-17-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 16:43:50 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] RDMA/mlx5: missing acquire/release on comp_handler in mlx5_ib_cq_c=
omp()
--

commit 74de7436d2c18504b739bcbd6ccce8e1cfa93dc1
Author: Yishai Hadas <yishaih@nvidia.com>

RDMA/mlx5: Ignore completion events for a CQ without a handler

This commit skips calling ibcq->comp_handler in mlx5_ib_cq_comp() when no
completion handler is set, preventing a NULL function pointer call if a
hostile NIC raises an unsolicited completion event on a CQ without a
handler.

> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5=
/cq.c
> index 5cc86c3f93f3e..f955eb762051d 100644
> --- a/drivers/infiniband/hw/mlx5/cq.c
> +++ b/drivers/infiniband/hw/mlx5/cq.c
> @@ -46,7 +46,12 @@ static void mlx5_ib_cq_comp(struct mlx5_core_cq *cq, s=
truct mlx5_eqe *eqe)
>  {
>  	struct ib_cq *ibcq =3D &to_mibcq(cq)->ibcq;
> =20
> -	ibcq->comp_handler(ibcq, ibcq->cq_context);
> +	/*
> +	 * A CQ created without a handler (devr->c0) is never armed, but a
> +	 * hostile NIC can still raise a completion event for it.
> +	 */
> +	if (ibcq->comp_handler)
> +		ibcq->comp_handler(ibcq, ibcq->cq_context);

[Severity: High]
When a kernel CQ is allocated via __ib_alloc_cq() (such as dev->umrc.cq in
mlx5r_umr_resource_init()), dev->ops.create_cq() publishes the CQ into the
completion EQ radix tree via mlx5_ib_create_cq() -> mlx5_core_create_cq() ->
mlx5_eq_add_cq() while cq->comp_handler is still NULL.

After create_cq() returns, __ib_alloc_cq() initializes cq->dim and the poll
context before setting cq->comp_handler:

drivers/infiniband/core/cq.c:__ib_alloc_cq() {
	...
	ret =3D dev->ops.create_cq(cq, &cq_attr, NULL);
	if (ret)
		goto out_free_wc;

	rdma_dim_init(cq);

	switch (cq->poll_ctx) {
	case IB_POLL_DIRECT:
		comp_handler =3D ib_cq_completion_direct;
		break;
	case IB_POLL_SOFTIRQ:
		comp_handler =3D ib_cq_completion_softirq;
		irq_poll_init(&cq->iop, IB_POLL_BUDGET_IRQ, ib_poll_handler);
		break;
	case IB_POLL_WORKQUEUE:
	case IB_POLL_UNBOUND_WORKQUEUE:
		comp_handler =3D ib_cq_completion_workqueue;
		INIT_WORK(&cq->work, ib_cq_poll_work);
		cq->comp_wq =3D (cq->poll_ctx =3D=3D IB_POLL_WORKQUEUE) ?
				ib_comp_wq : ib_comp_unbound_wq;
		break;
	...
	}

	cq->comp_handler =3D comp_handler;
}

If a hostile NIC raises an unsolicited completion event for the newly
created CQN on another CPU while __ib_alloc_cq() is setting up the poll
context, mlx5_eq_comp_int() -> mlx5_ib_cq_comp() reads and invokes
ibcq->comp_handler with plain loads.

Because ibcq in mlx5_ib_cq_comp() is derived from cq (&to_mibcq(cq)->ibcq)
rather than from the loaded ibcq->comp_handler pointer, there is no address
dependency between reading ibcq->comp_handler and accessing fields of ibcq
inside the completion handler, and neither irq_poll_init() nor INIT_WORK()
provides a release barrier before cq->comp_handler =3D comp_handler.

Could a weakly ordered CPU or the compiler reorder the stores to cq->iop,
cq->work, cq->comp_wq, or cq->dim with the store and load of comp_handler,
causing ib_cq_completion_softirq() or ib_cq_completion_workqueue() to see
uninitialized poll context fields (such as a NULL iop->poll or cq->comp_wq)?
Should __ib_alloc_cq() use smp_store_release(&cq->comp_handler,
comp_handler) paired with smp_load_acquire(&ibcq->comp_handler) in
mlx5_ib_cq_comp()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103163949.1554=
-1-yishaih@nvidia.com?part=3D16
