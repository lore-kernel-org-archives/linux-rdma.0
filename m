Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556564F6473
	for <linux-rdma@vger.kernel.org>; Wed, 16 Sep 2026 14:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789567483; cv=none; b=opazkHW/HNh0P8aSbJTHcj6t3vYZUxEa+xYpAmlVFNJVg4FnpAfHPxBaDAYQb1qSD3O6v1jsxNn3uHBGu1BF4EhwP+eB/eVc6FNeOxPWaU/X8NX+ALG2ZOKyXdgF2cJLT7EWQbAnVQIRU94/Z2blaC3aZDomIE7bOOVIRreeahA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789567483; c=relaxed/simple;
	bh=k81G0lp7nUIeRrEzMoVR4VeNV3OKeBEU+K6FsJMluXo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AiIgpatz2pSIQ/h5XXPdHe5oUiwdQ4h+/VFwdCbddEKxN5XfuhFJdQluA9jJNGYzJz8BmMjQGgx2FJzQn+cP1pCNHYbU0TmOD+aklabLOdx54Zwf2ccJ0Mx/rtHmPCkbZ2WzdQWm770B+5r+9XwLgfEIYrMLjs1VfwZkvJsUOik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V3DwsfJ4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V3DwsfJ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62DD1F00898;
	Wed, 16 Sep 2026 14:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789567481;
	bh=jJ5cBMB0su3JHmAvCizGneeSN/enHbqb6F/rx1msQpQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=V3DwsfJ4R1j4aubp5pZKnOaufSIBP+a1tiXaNBTEuZBdgsUq+hhVL72Qc3kXmHUxX
	 DybdlYQ7zsDs97AzpR6/EBsJvcHYEZPrKno3slGpxmhE6yRmDDu2oAcSnn3BU3WFfQ
	 nsSbIMFCnD6XrSzGgSUbHTSGLe9yX5kv0ybtmuf3LkPUOanX1rbKp+yhAK2QqdvIuS
	 fX1keFtBo8pmVyhfiyIJRuFFiR9NPVse1sDY4JsMKWGnOFmAEUU0uQrfFgvC9XgT6S
	 cw0ybABFUSPhq4xNiWqZtb5ElsuYiQkBEouasaic9w/LjBIsp2DVwHN9ighT6GXoKq
	 ZIpO+C8NL4BJw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 5/5] RDMA/mana_ib: Poll UD completions and
 flush software error QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260916134835.2380971-6-kotaranov@linux.microsoft.com>
References: <20260916134835.2380971-1-kotaranov@linux.microsoft.com>
 <20260916134835.2380971-6-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 14:04:41 +0000
Message-Id: <20260916140441.C62DD1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] RDMA/mana_ib: Data race on shadow queue indices during QP reset
- [High] RDMA/mana_ib: Stale CQEs are misattributed to new WQEs after QP re=
set
--

commit d61cdf2438fcd73314507c259677e884ff8f99a1
Author: Konstantin Taranov <kotaranov@microsoft.com>

RDMA/mana_ib: Poll UD completions and flush software error QPs

This commit introduces direct polling of hardware CQEs to build UD and GSI
work completions for mana_ib. It also replaces the all-QP CQ membership with
persistent send and receive error-QP lists to flush software error QPs.

> diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana=
/cq.c
> --- a/drivers/infiniband/hw/mana/cq.c
> +++ b/drivers/infiniband/hw/mana/cq.c
[ ... ]
> +static void mana_complete_send(struct mana_ib_qp *qp,
> +			       struct mana_cq_poll *poll, u32 vendor_error)
> +{
> +	struct shadow_queue *shadow =3D &qp->shadow_sq;
> +	struct shadow_wqe_header *wqe =3D shadow_queue_get_next_to_consume(shad=
ow);
> +	struct gdma_queue *queue;
> +
> +	if (!wqe)
> +		return;
> +
> +	if (vendor_error || !(wqe->flags & MANA_WQ_NO_SIGNAL_WC))
> +		mana_fill_wc(qp, poll, wqe, wqe->send_opcode, vendor_error);
> +
> +	queue =3D mana_qp_get_sq(qp)->kmem;
> +	queue->tail +=3D wqe->wqe_size_in_bu;
> +	shadow_queue_advance_consumer(shadow);
> +}

[Severity: High]
If a QP is transitioned to IB_QPS_RESET, reset_shadow_queue() rewinds
cons_idx to 0. Since the hardware GDMA CQ is not swept of stale CQEs
generated before or during the reset, will the poller later encounter these
stale CQEs when the QP is reused?

It appears mana_complete_send() might blindly pop the next shadow WQE (at
index 0) and complete it using the stale CQE data. Can a new WQE be
completed with the status, length, and immediate data of a pre-reset
operation because the CQE's tx_wqe_offset or rx_wqe_offset is not validated
against the shadow WQE?

> diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana=
/qp.c
> --- a/drivers/infiniband/hw/mana/qp.c
> +++ b/drivers/infiniband/hw/mana/qp.c
[ ... ]
> +static void mana_ib_modify_qp_state(struct ib_qp *ibqp, struct ib_qp_att=
r *attr,
> +				    int attr_mask, struct ib_udata *udata)
> +{
> +	struct mana_ib_qp *qp =3D container_of(ibqp, struct mana_ib_qp, ibqp);
> +
> +	if (udata)
> +		return;
> +
> +	if (attr_mask & IB_QP_STATE) {
> +		switch (attr->qp_state) {
> +		case IB_QPS_RESET:
> +			mana_remove_qp_from_cqs(qp);
> +			reset_shadow_queue(&qp->shadow_rq);
> +			reset_shadow_queue(&qp->shadow_sq);
> +			break;
> +		default:
> +			break;
> +		}
> +	}

[Severity: High]
When a userspace application transitions a QP to IB_QPS_RESET concurrently
with a thread polling the CQ, mana_remove_qp_from_cqs() removes it from the
software error lists but does not seem to synchronize with the active CQ
polling thread.

Does calling reset_shadow_queue() here create a data race? The function
performs unprotected plain writes of 0 to prod_idx and cons_idx:

drivers/infiniband/hw/mana/shadow_queue.h:reset_shadow_queue() {
        queue->prod_idx =3D 0;
        queue->cons_idx =3D 0;
}

The polling thread concurrently executes shadow_queue_advance_consumer(),
doing a read-modify-write on cons_idx. Can this corruption lead to
mismatched shadow WQEs and hardware completions, lost completions, or
out-of-bounds ring buffer accesses?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260916134835.2380=
971-1-kotaranov@linux.microsoft.com?part=3D5
