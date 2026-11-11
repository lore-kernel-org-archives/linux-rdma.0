Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794403560;
	b=ik5mnYKFqhJn7RfFSEqc+M9gGB5rzc7J/ekcqQsjZ28QrHcl6crZ7wJexi7nBKEr6tZb
	 Q1c0wV4cwgORGCxV7ejII3WF0RDumUbYK6LdQeuOPh4xcp7r7/Jgq+tcxGN8YUKKQ2F3C
	 +2/AmMBehBYqgS2cuRVt3rRMj8fl67eoEzZR0Yta8btGMw5OoWXFZ9Odl4m5qj/ByvgJf
	 TWr4175wyz8gEayae5ziVtDRRV1V24Sts2nCSVRIjkOklHOyva1RYBG8luN7iUDTFVQea
	 4PDGA9JqR8xC15piIbFo4KCRrZxRRgMAgWxADViu28INog0jb4NCA/c1oeFxoboUtAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794403560;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=8OHLHAC1/xO2y/mOPLdYPy9EIep69G6lhZW4pPcCfDY=;
	b=HNQ2LoGEcCwTYM4vSqJj29lVsxvgcnbf+i/pzX1pEd8MRXo/6tMS7JtTY4KvAdXtb/9o
	 egvOePPRlsUjWE8ivHev25vr0+KEQw0SiSkvdEkURQYObYuuqc192FP9oYCThZc44Cesd
	 qNBAdfPYCtEKiEXo9DL6WL1SQk8qj/V1+Np+z6WuRjbRuPCRO9KhZOPZBAcrbWPZeTtl0
	 7gCBjtPn6KTpxDprkvWyWhGd5UqhpjrIMU44iuYI5sA0ucdXPcg24V1SsaNtiYodlA/vi
	 ptNeExlXYaFOUqLOVk1CgUFLkawZxPpS3GVE7/cro1b9R1J6mJyqc8/G9pgTaXIJdZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iZTkvnCI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330F2606A31C
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 13:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iZTkvnCI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03731F00A05;
	Wed, 11 Nov 2026 13:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794403559;
	bh=8OHLHAC1/xO2y/mOPLdYPy9EIep69G6lhZW4pPcCfDY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iZTkvnCIPi9/EutYU2xbHiu67n/lQEUzMaCWeXTMW5DkRvmIDnZSPQN3P8U4eGT6p
	 v5luQUNrMhVJw4DxBtKTcpg7/+UCG8iVv7x4qtLkxmPv5V5mqkDNDxDqj29kwM8xqT
	 3tZe7z7ABZ1tDhY5xTH7sCXE4mtBMubB3DPaUvTCsyCYEJIVeqdMgcndFHtGJhQevm
	 16tZ/5h6fcOyJ36SLa+iOcWpQYjgdIpFye47GTrV/bi4+e4qeTziY1IEQtP3yDoRJD
	 L++boitZWSfq26hjPrBGo9rtvgxNt432a1ZoroybFYgpLbaATAEzkhBIAhs4VGkN7I
	 dgaGTD7yS8LPQ==
Message-ID: <sashiko-outbox-209073@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v10 7/9] RDMA/mana_ib: Poll RC completions
 using PSN and FSN progress
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261111121417.1265896-8-kotaranov@linux.microsoft.com>
References: <20261111121417.1265896-1-kotaranov@linux.microsoft.com>
 <20261111121417.1265896-8-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 13:25:59 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] RDMA/mana_ib: stale pending_cqe left on shared CQ in
  mana_remove_qp_from_cqs()
--

commit 806a276151b888efca6e4438e92abdefb2dc1d9e
Author: Konstantin Taranov <kotaranov@microsoft.com>

RDMA/mana_ib: Poll RC completions using PSN and FSN progress

This commit decodes RC receive, armed-PSN, and MMQ completions, retiring
requester and MMQ shadow entries using PSN and FSN progress while honoring
cross-queue fence dependencies and rearming the next signaled PSN.

> diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana=
/cq.c
> index 843e2c64b32bc..307383bfa4ac7 100644
> --- a/drivers/infiniband/hw/mana/cq.c
> +++ b/drivers/infiniband/hw/mana/cq.c

[ ... ]

> @@ -277,15 +283,18 @@ int mana_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_n=
otify_flags flags)
>  	struct mana_ib_cq *cq =3D container_of(ibcq, struct mana_ib_cq, ibcq);
>  	struct gdma_queue *gdma_cq =3D cq->queue.kmem;
>  	unsigned long irq_flags;
> +	bool missed =3D false;
> =20
>  	if (!gdma_cq)
>  		return -EINVAL;
> =20
>  	spin_lock_irqsave(&cq->cq_lock, irq_flags);
>  	mana_ib_cq_doorbell(cq, SET_ARM_BIT);
> +	if (flags & IB_CQ_REPORT_MISSED_EVENTS)
> +		missed =3D cq->has_pending_cqe;
>  	spin_unlock_irqrestore(&cq->cq_lock, irq_flags);
> =20
> -	return 0;
> +	return missed;
>  }

[ ... ]

> @@ -390,17 +425,108 @@ static void handle_rq_cqe(struct mana_ib_qp *qp, s=
truct gdma_comp *cqe,
>  	shadow_queue_advance_consumer(&qp->shadow_rq);
>  }

[ ... ]

>  static bool mana_handle_cqe(struct mana_ib_cq *cq, struct mana_ib_dev *m=
dev,
>  			    struct mana_cq_poll *poll)
>  {
>  	struct gdma_comp *cqe =3D &cq->pending_cqe;
>  	struct mana_rdma_cqe *rdma_cqe =3D (struct mana_rdma_cqe *)cqe->cqe_dat=
a;
>  	struct mana_ib_qp *qp =3D mana_get_qp_ref(mdev, cqe->wq_num, cqe->is_sq=
);
> +	bool consumed =3D true;
> =20
>  	if (!qp)
>  		return true;
> =20
>  	switch (rdma_cqe->cqe_type) {
> +	case CQE_TYPE_ARMED_CMPL:
> +		consumed =3D handle_psn_cqe(qp, rdma_cqe->rc_armed_completion.psn, pol=
l);
> +		break;
> +	case CQE_TYPE_LWR:
> +		consumed =3D handle_mmq_cqe(qp, rdma_cqe->rc_mm.fsn, poll);
> +		break;

[Severity: Medium]
Can destroying an RC QP leave a stale cq->pending_cqe on a shared CQ when
handle_psn_cqe() or handle_mmq_cqe() hits poll->budget?

When mana_advance_send() exhausts poll->budget, mana_handle_cqe() returns
false and mana_ib_poll_cq() leaves cq->has_pending_cqe set.  If that QP is
then destroyed before the remaining WQEs are polled, mana_ib_arm_cq() with
IB_CQ_REPORT_MISSED_EVENTS falsely reports a missed event, and if the
hardware queue ID is reused by a new QP before the next poll,
mana_ib_poll_cq() will process the destroyed QP's pending_cqe against the
new QP and prematurely retire its shadow WQEs.

Follow-up commit "RDMA/mana_ib: Handle error CQEs for kernel QPs" in this
series adds mana_ib_cq_clean() to mana_remove_qp_from_cqs(), but only
under if (reset), so mana_ib_destroy_rc_qp() calling
mana_remove_qp_from_cqs(qp, false) still leaves the destroyed QP's
pending_cqe and unpolled CQEs on the shared CQ.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111121417.1265=
896-1-kotaranov@linux.microsoft.com?part=3D7
