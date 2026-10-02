Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA510451996
	for <linux-rdma@vger.kernel.org>; Fri,  2 Oct 2026 09:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790932384; cv=none; b=NqOa7PM8w7fftabuywu32g+R5B1dxyQyzJGlTJCIwjrrScsln2SAT4D5tyDeWW4S+aLUwmrWmh07JOXC14UKK81FhkGRJFI0oNqTpMSqQNcvCU7qEs1V+BvcP8J+zwbPa7luCeUrjAXAFcwfub6kIr93FsSOnx7+n9ZAJ7bELMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790932384; c=relaxed/simple;
	bh=T5XcIVt1LoZtgC4f7em+UNiWOpKRRKPKNV2k+cAw3cc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BPZZrHHu0iinDCpN86noIZHQ76GaJ/vSxHLQngJEjA9a7MxmQtSJ75LTWztOF+8oBprVboH4zZIhvW9o9ndJPmTg1ThgHr7pZM6p5+9RYHHrdyUCPgD2Y0LwUt/1cLhaC5tDLZmYStbghxAjSZT140+l7BRsZApux7Zaq79rIPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ThtmY6e8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ThtmY6e8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7707C1F00898;
	Fri,  2 Oct 2026 09:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790932382;
	bh=hizZtDRBIGyswQi/Xu1wtnYnfUblF7zivddOYfwL8u4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ThtmY6e8SytU17LAVCQauNk9UQTGI25N8OYYwefmIIS1g24P0BJFzUxn+Vym0ZhMK
	 JaBEUofnjSkjAO4GgBqnq67aLuXfDw3txb3CSxaU2aGWyGvQE0UHTbWRKaUYZ5jIrw
	 lZtNwm1uGNZYLWFdua67dmLWV/KuBeUK3CHVCuO4AIZuHP5HRbJ586V9HeJqhp5hbW
	 HvaYWxJR4S2GEDUfBBioEp4+wfV6GaiIJ0qHsV5im4cYor43cKFFBKAtqaYG9oXEf4
	 097s9IBqmmgcmUvt21M/3s9eFmtmXDk/aqKtVgCLdq2r9D8qBN0rrZ+LqHmRcovEnW
	 F25gm6ffzxqag==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 10/10] RDMA/mana_ib: Drain kernel receive and
 send queues
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261001182015.1757203-11-kotaranov@linux.microsoft.com>
References: <20261001182015.1757203-1-kotaranov@linux.microsoft.com>
 <20261001182015.1757203-11-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 02 Oct 2026 09:13:02 +0000
Message-Id: <20261002091302.7707C1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] rdma/mana_ib: null pointer dereference in mana_ib_drain_sq() on UD=
/GSI QPs
- [Medium] rdma/mana_ib: user-triggerable WARN_ONCE via manual comp_handler=
 invocation for direct CQs
--

commit cbadbb6a8acdc7477a3606271c2a70d35b56708b
Author: Konstantin Taranov <kotaranov@microsoft.com>

RDMA/mana_ib: Drain kernel receive and send queues

This commit implements the core drain callbacks for the mana_ib driver
by moving the QP to the ERR state, posting a completion-bearing marker,
and waiting until that marker is flushed.

> diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana=
/qp.c
> index 0f60909cbe848..4e6f15fb4887b 100644
> --- a/drivers/infiniband/hw/mana/qp.c
> +++ b/drivers/infiniband/hw/mana/qp.c

[ ... ]

> +void mana_ib_drain_sq(struct ib_qp *ibqp)
> +{
> +	struct ib_qp_attr attr =3D { .qp_state =3D IB_QPS_ERR };
> +	struct mana_ib_drain_cqe sdrain;
> +	struct ib_rdma_wr swr =3D {
> +		.wr =3D {
> +			.next =3D NULL,
> +			.wr_cqe =3D &sdrain.cqe,
> +			.opcode =3D IB_WR_SEND,
> +		},
> +	};

[Severity: High]
Does this WR structure correctly handle IB_QPT_UD or IB_QPT_GSI queue types?

When mana_ib_drain_sq() is called on a UD QP, it submits this stack-allocat=
ed
ib_rdma_wr structure to ib_post_send(). The mana driver's send path in
mana_ib_post_send_ud_one() expects an ib_ud_wr structure and downcasts this
generic WR into it.

Because the ib_rdma_wr structure is smaller than ib_ud_wr, the downcast
results in an out-of-bounds stack read over the overlapping memory. This
causes the evaluated ah pointer to be NULL.

When the hardware scatter-gather list is built later via
gdma_sgl[0].address =3D ah->dma_handle, dereferencing the NULL ah pointer
causes a kernel panic.

Since unprivileged userspace applications can create and drain UD QPs via
uverbs, can this be exploited as a local denial-of-service vulnerability?

[ ... ]

> +	ret =3D ib_post_send(ibqp, &swr.wr, &bad_swr);
> +	if (ret) {
> +		ibdev_err(ibqp->device, "Failed to post SQ drain WR: %d\n", ret);
> +		return;
> +	}
> +
> +	if (cq->comp_handler)
> +		cq->comp_handler(cq, cq->cq_context);

[Severity: Medium]
Is it safe to execute the comp_handler here unconditionally before checking
if the CQ uses direct polling?

For CQs instantiated with IB_POLL_DIRECT, the RDMA core strictly assigns
ib_cq_completion_direct() to the comp_handler to emit a WARN_ONCE on any
unsolicited execution.

Unprivileged users can trigger QP draining via uverbs on direct polling CQs,
meaning they can trivially trip this warning.

If the system is configured with panic_on_warn, could this lead to an
unexpected denial of service?

> +
> +	if (cq->poll_ctx =3D=3D IB_POLL_DIRECT) {

[ ... ]

> +void mana_ib_drain_rq(struct ib_qp *ibqp)
> +{

[ ... ]

> +	ret =3D ib_post_recv(ibqp, &rwr, NULL);
> +	if (ret) {
> +		ibdev_err(ibqp->device, "Failed to post RQ drain WR: %d\n", ret);
> +		return;
> +	}
> +
> +	if (cq->comp_handler)
> +		cq->comp_handler(cq, cq->cq_context);

[Severity: Medium]
Similarly to the send queue drain, will this unconditional comp_handler
execution trigger the core's unsolicited completion warning for direct CQs?

> +
> +	if (cq->poll_ctx =3D=3D IB_POLL_DIRECT) {

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001182015.1757=
203-1-kotaranov@linux.microsoft.com?part=3D10
