Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793810630;
	b=PPYF9HPhle/lE/E9Xtnic0OXpaaKEmHUJmKGxYUyxd2cEGbsjQ3bVLk5waaXXYUwunu4
	 eHJGv9EsJfqfBCSRyIDjGAsnLCR93Tgxb/cSUrk9R4GrmbYG7sK55vpGNYlbab1jrTJTI
	 wN6yO/wBjH5hMf6GTIx18Dju5bBeDbvuh3JvBpkhRht+ko7qFjXZRZZMdT5S+/AubX9os
	 eOSb6L006G5Pe7YXPBfIuwPcBNUsQf7t1gSlIKkPrX0ZUDXNRMWAVvmqO8shW5dXOey0y
	 hxzuThlgHQaQ8+5K7NpnEELgbdD+e/sRPeWWW1Ps28aNTOiVQYgInDpiODJp3k0hyiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793810630;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=x04+xYVNg1/eTe9fnE5KnHVbQ1bnmANu9i3fMSW+zUg=;
	b=ZaH36qTC3JzwUPOM0/BMp9rAaVF/CtdsElyAnuJDoftshuZF049lFXporE/2/cELeH1d
	 Z2GaQNTMmIWiQopTMSKsUSHHEIYhMVgzTH1iv8DXQ2H5xLMlItfknazvNHZEPCzK1R5It
	 1RpTOvEWAUdYgbhZLPuM1wD+BlyMOCZU7E+G+GhJmChNyr8jU9QjoOcDWlnUrfEgmbeO3
	 GwsHEv0AP3S3x7dFw2ROp4laBdsSaZlsOvW+SaLvIc9VUNsYfGdmMUATFwxeyTSE6mPE9
	 vJ87h2Ns+o96q1fo58SABgmyMYWTQUzqttjbKAGOaZDe1UNpRrPRARewIPtFyAmBIjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cWx2NySZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFB5606A33A
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 16:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cWx2NySZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC651F00919;
	Wed,  4 Nov 2026 16:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810630;
	bh=x04+xYVNg1/eTe9fnE5KnHVbQ1bnmANu9i3fMSW+zUg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cWx2NySZYHFePXqZiMebqQVNKKf+CxOaz9Jmt+K/ZbZAZ73HTehD8ir1GmfgUUE6+
	 CMJkS+2ZKHFUuGMFUMAl88hgsaVEoMYTpP/NAFJ1z+BsXCDpR1ouaZt1xoL1tD9FLC
	 ykIFGXWhbgg73cGZGa1SuyITQwTEdRGBNJRYCIAPHON0M74agc3sCEikFm7lsi25yL
	 0pP+vRHaAx6wYQdIoE+PEPRkVSUIAC99nhLtgR+314ftnfgeIuisEZ90PRGADcWV02
	 NOVIxWZmsOb+3nQzGTe9E38d6vxWOZIdCHkHsoDxmGYgZ+4T4DCBUgbPGk+3fkoTG3
	 j0aJoDnW2jPfA==
Message-ID: <sashiko-outbox-197668@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 15/23] RDMA/core: Set the CQ comp_handler
 after its poll context is set up
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103163949.1554-16-yishaih@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
 <20261103163949.1554-16-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 16:43:49 +0000
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
- [High] RDMA/core: comp_handler initialized after create_cq() in __ib_allo=
c_cq()
--

commit 08ca16c59be95a85d42f773522716fafbd346f19
Author: Yishai Hadas <yishaih@nvidia.com>

RDMA/core: Set the CQ comp_handler after its poll context is set up

This commit updates __ib_alloc_cq() to initialize the CQ poll context
(irq_poll, work_struct, and comp_wq) before setting cq->comp_handler and
arming the CQ via ib_req_notify_cq().

> diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
> index 12304c9a9403e..42e4d272f5ade 100644
> --- a/drivers/infiniband/core/cq.c
> +++ b/drivers/infiniband/core/cq.c
> @@ -217,6 +217,7 @@ struct ib_cq *__ib_alloc_cq(struct ib_device *dev, vo=
id *private, int nr_cqe,
>  		.cqe		=3D nr_cqe,
>  		.comp_vector	=3D comp_vector,
>  	};
> +	ib_comp_handler comp_handler;
>  	struct ib_cq *cq;
>  	int ret =3D -ENOMEM;
> =20
> @@ -248,19 +249,16 @@ struct ib_cq *__ib_alloc_cq(struct ib_device *dev, =
void *private, int nr_cqe,
> =20
>  	switch (cq->poll_ctx) {
>  	case IB_POLL_DIRECT:
> -		cq->comp_handler =3D ib_cq_completion_direct;
> +		comp_handler =3D ib_cq_completion_direct;
>  		break;
>  	case IB_POLL_SOFTIRQ:
> -		cq->comp_handler =3D ib_cq_completion_softirq;
> -
> +		comp_handler =3D ib_cq_completion_softirq;
>  		irq_poll_init(&cq->iop, IB_POLL_BUDGET_IRQ, ib_poll_handler);
> -		ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
>  		break;
>  	case IB_POLL_WORKQUEUE:
>  	case IB_POLL_UNBOUND_WORKQUEUE:
> -		cq->comp_handler =3D ib_cq_completion_workqueue;
> +		comp_handler =3D ib_cq_completion_workqueue;
>  		INIT_WORK(&cq->work, ib_cq_poll_work);
> -		ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
>  		cq->comp_wq =3D (cq->poll_ctx =3D=3D IB_POLL_WORKQUEUE) ?
>  				ib_comp_wq : ib_comp_unbound_wq;
>  		break;
> @@ -269,6 +267,15 @@ struct ib_cq *__ib_alloc_cq(struct ib_device *dev, v=
oid *private, int nr_cqe,
>  		goto out_destroy_cq;
>  	}
> =20
> +	/*
> +	 * The CQ is reachable from the completion interrupt once created. Set
> +	 * the handler only after the poll context it schedules is set up, and
> +	 * arm the CQ only after that.
> +	 */
> +	cq->comp_handler =3D comp_handler;

[Severity: High]
Since __ib_alloc_cq() calls dev->ops.create_cq(cq, &cq_attr, NULL) before
initializing the poll context and setting cq->comp_handler, can a completion
interrupt arriving right after dev->ops.create_cq() registers the CQ in the
device EQ table race with this initialization?

Unlike __ib_create_cq(), ib_uverbs_create_cq(), and
UVERBS_HANDLER(UVERBS_METHOD_CQ_CREATE), which set cq->comp_handler before
calling dev->ops.create_cq(), __ib_alloc_cq() calls dev->ops.create_cq() wh=
ile
cq->comp_handler is still NULL:

drivers/infiniband/core/cq.c:__ib_alloc_cq() {
	...
	ret =3D dev->ops.create_cq(cq, &cq_attr, NULL);
	if (ret)
		goto out_free_wc;

	rdma_dim_init(cq);

	switch (cq->poll_ctx) {
	...
}

At this commit, mlx5_ib_cq_comp() calls ibcq->comp_handler() without a NULL
check (until the subsequent commit "RDMA/mlx5: Ignore completion events for=
 a
CQ without a handler" adds an if (ibcq->comp_handler) check in mlx5):

drivers/infiniband/hw/mlx5/cq.c:mlx5_ib_cq_comp() {
	struct ib_cq *ibcq =3D &to_mibcq(cq)->ibcq;

	ibcq->comp_handler(ibcq, ibcq->cq_context);
}

Other RDMA drivers (such as efa_process_comp_eqe() in
drivers/infiniband/hw/efa/efa_main.c, mlx4_ib_cq_comp(),
mthca_cq_completion(), and cxgb4) also unconditionally invoke
cq->ibcq.comp_handler() without a NULL check once the CQ is inserted into t=
he
device CQ table during create_cq(), and cq->comp_handler is never set if the
default branch in switch (cq->poll_ctx) jumps to out_destroy_cq.

In addition, even in drivers that check if (ibcq->comp_handler) in their
completion interrupt handler (such as mlx5_ib_cq_comp() after the follow-up
commit and hns_roce_cq_completion()), the CQ is already reachable on other
CPUs while irq_poll_init(&cq->iop, ...), INIT_WORK(&cq->work, ...), and
cq->comp_wq are being initialized. Because cq->comp_handler =3D comp_handle=
r is
a plain store without release ordering (and the interrupt handler reads
ibcq->comp_handler without acquire ordering), can compiler or CPU store
reordering on weakly ordered architectures allow an interrupt handler on
another CPU to observe a non-NULL cq->comp_handler before the stores to
cq->iop, cq->work, or cq->comp_wq are visible?

Now that ib_req_notify_cq() is called after the switch (cq->poll_ctx) block,
would it be safer to initialize the poll context (cq->iop, cq->work, and
cq->comp_wq) and set cq->comp_handler before calling dev->ops.create_cq(),
leaving only rdma_dim_init() and ib_req_notify_cq() after create_cq()
succeeds?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103163949.1554=
-1-yishaih@nvidia.com?part=3D15
