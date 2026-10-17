Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732011925BC
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 07:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792220498; cv=none; b=cE6zGxSLFL4r/DvRfBCPE0ZaEESds6ioydvSHgHUpwvBqEqDLhU7IXdkzEbL5+zXtsbi9ErqdAciS2oUGwKvfPx0xdjx3HmiYagFq/ZEZX5kYviekZK3V+9Z4uVz3ZwRghxo9o3zB2fz4Aqajmx6TeIFnfJVIlK8ymLmfAn+Kj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792220498; c=relaxed/simple;
	bh=I9soT+ka3H8/Za3RNVUj8Lk1SN7bIA9e6kuyOsuZtFI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=TT/57EeQuqm4vZlD7FZqp9YJX3DrLRPQOXs1gm0zaIjDfVHndq4YdtOVW+ZQj6SDne8f4zX/OMBcqcYHWd9f+qRYldSfLrEoOaL9IIgpFlKSWsyoSh6F2sYT0R9M0pP8K3QVAUr3Wo0vHiI1VHhKbyE4F2nKaL20UohzPHBzTs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lGLQrgIE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lGLQrgIE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C441F000C4;
	Sat, 17 Oct 2026 07:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792220497;
	bh=JKNEfU38IOYuwQxbHUYz5fS5lSm41JZRaHJNOMoq+KQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lGLQrgIEI0gvLV7bADbenzJ4yIqo6bPnboKQIR9emn3RbsPDC3KiYvyTzmU3KkLFk
	 gfpGguUpuLbKKfLCO32Lh4GxWu2j+GYY15OHDpyGKXA9xfQi/pi59BLqNi9g1aQ+sg
	 ga+6ke0xENc50/smfemCVzPQlNTvE15co9uQFz1oKiuJ4ZmRQ72pe8sXdgUvcTmrk/
	 BgC73u6Fnp2PIxp8o15sqgTH4aeONlbKeSUfqs12Oyiz6IHvOnHJ/yIcka5/PfypRB
	 n68zzUkg/papdIy13icJnR7luVT6QctYeXeh5VGgMRFNzTYgUYEVlvwTGltxo8U8VG
	 dAyY8NJn8xcnw==
Message-ID: <sashiko-outbox-175357@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v5 10/10] RDMA/mana_ib: Drain kernel receive
 and send queues
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261017064413.995985-11-kotaranov@linux.microsoft.com>
References: <20261017064413.995985-1-kotaranov@linux.microsoft.com>
 <20261017064413.995985-11-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 07:01:36 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] RDMA/mana_ib: lost poll wakeup in mana_ib_drain_sq() and mana_ib_d=
rain_rq()
--

commit cdad9731bfb8c6291bf5161e04f6798a87eaf888
Author: Konstantin Taranov <kotaranov@microsoft.com>

RDMA/mana_ib: Drain kernel receive and send queues

This commit implements the core drain_rq and drain_sq device operations for
mana_ib RC QPs by transitioning the QP to IB_QPS_ERR, posting a marker WR,
and waiting for its completion.

> diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana=
/qp.c
> index 04755bec015ed..8557453d39194 100644
> --- a/drivers/infiniband/hw/mana/qp.c
> +++ b/drivers/infiniband/hw/mana/qp.c
> @@ -1381,3 +1381,106 @@ int mana_ib_destroy_qp(struct ib_qp *ibqp, struct=
 ib_udata *udata)
> =20
>  	return -ENOENT;
>  }
> +
> +struct mana_ib_drain_cqe {
> +	struct ib_cqe cqe;
> +	struct completion done;
> +};
> +
> +static void mana_ib_drain_qp_done(struct ib_cq *cq, struct ib_wc *wc)
> +{
> +	struct mana_ib_drain_cqe *cqe =3D container_of(wc->wr_cqe,
> +						     struct mana_ib_drain_cqe,
> +						     cqe);
> +	complete(&cqe->done);
> +}
> +
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
> +	const struct ib_send_wr *bad_swr;
> +	struct ib_cq *cq =3D ibqp->send_cq;
> +	int ret;
> +
> +	if (ibqp->qp_type !=3D IB_QPT_RC) {
> +		ibdev_err(ibqp->device, "SQ drain is only supported for RC QPs (type %=
u)\n",
> +			  ibqp->qp_type);
> +		return;
> +	}
> +
> +	ret =3D ib_modify_qp(ibqp, &attr, IB_QP_STATE);
> +	if (ret) {
> +		ibdev_err(ibqp->device, "Failed to drain SQ: modify QP returned %d\n",=
 ret);
> +		return;
> +	}
> +
> +	sdrain.cqe.done =3D mana_ib_drain_qp_done;
> +	init_completion(&sdrain.done);
> +
> +	ret =3D ib_post_send(ibqp, &swr.wr, &bad_swr);
> +	if (ret) {
> +		ibdev_err(ibqp->device, "Failed to post SQ drain WR: %d\n", ret);
> +		return;
> +	}
> +
> +	if (cq->poll_ctx !=3D IB_POLL_DIRECT && cq->comp_handler)
> +		cq->comp_handler(cq, cq->cq_context);
> +
> +	if (cq->poll_ctx =3D=3D IB_POLL_DIRECT) {
> +		while (!wait_for_completion_timeout(&sdrain.done, HZ / 10))
> +			ib_process_cq_direct(cq, -1);
> +	} else {
> +		wait_for_completion(&sdrain.done);
> +	}
> +}
> +
> +void mana_ib_drain_rq(struct ib_qp *ibqp)
> +{
> +	struct ib_qp_attr attr =3D { .qp_state =3D IB_QPS_ERR };
> +	struct mana_ib_drain_cqe rdrain;
> +	struct ib_recv_wr rwr =3D {
> +		.next =3D NULL,
> +		.wr_cqe =3D &rdrain.cqe,
> +	};
> +	struct ib_cq *cq =3D ibqp->recv_cq;
> +	int ret;
> +
> +	if (ibqp->qp_type !=3D IB_QPT_RC) {
> +		ibdev_err(ibqp->device, "RQ drain is only supported for RC QPs (type %=
u)\n",
> +			  ibqp->qp_type);
> +		return;
> +	}
> +
> +	ret =3D ib_modify_qp(ibqp, &attr, IB_QP_STATE);
> +	if (ret) {
> +		ibdev_err(ibqp->device, "Failed to drain RQ: modify QP returned %d\n",=
 ret);
> +		return;
> +	}
> +
> +	rdrain.cqe.done =3D mana_ib_drain_qp_done;
> +	init_completion(&rdrain.done);
> +
> +	ret =3D ib_post_recv(ibqp, &rwr, NULL);
> +	if (ret) {
> +		ibdev_err(ibqp->device, "Failed to post RQ drain WR: %d\n", ret);
> +		return;
> +	}
> +
> +	if (cq->poll_ctx !=3D IB_POLL_DIRECT && cq->comp_handler)
> +		cq->comp_handler(cq, cq->cq_context);
> +
> +	if (cq->poll_ctx =3D=3D IB_POLL_DIRECT) {
> +		while (!wait_for_completion_timeout(&rdrain.done, HZ / 10))
> +			ib_process_cq_direct(cq, -1);
> +	} else {
> +		wait_for_completion(&rdrain.done);
> +	}
> +}

[Severity: High]
Can mana_ib_drain_sq() and mana_ib_drain_rq() lose a wakeup and hang in
wait_for_completion() when cq->poll_ctx is IB_POLL_SOFTIRQ?

In mana_ib_drain_sq() and mana_ib_drain_rq(), ib_modify_qp() transitions
the QP to IB_QPS_ERR before the drain WR is posted. Inside
mana_ib_modify_qp(), mana_add_qp_to_error_cqs() adds the QP to the CQ error
lists and mana_ib_notify_error_cqs() immediately calls cq->comp_handler():

drivers/infiniband/hw/mana/qp.c:mana_ib_notify_error_cqs() {
	if (send_cq->poll_ctx !=3D IB_POLL_DIRECT && send_cq->comp_handler)
		send_cq->comp_handler(send_cq, send_cq->cq_context);
	if (recv_cq !=3D send_cq && recv_cq->poll_ctx !=3D IB_POLL_DIRECT &&
	    recv_cq->comp_handler)
		recv_cq->comp_handler(recv_cq, recv_cq->cq_context);
}

For IB_POLL_SOFTIRQ, cq->comp_handler is ib_cq_completion_softirq(), which
calls irq_poll_sched(&cq->iop), setting IRQ_POLL_F_SCHED and scheduling
ib_poll_handler():

drivers/infiniband/core/cq.c:ib_poll_handler() {
	completed =3D __ib_process_cq(cq, budget, cq->wc, IB_POLL_BATCH);
	if (completed < budget) {
		irq_poll_complete(&cq->iop);
		if (ib_req_notify_cq(cq, IB_POLL_FLAGS) > 0) {
			trace_cq_reschedule(cq);
			irq_poll_sched(&cq->iop);
		}
	}
	...
}

In __ib_process_cq(), mana_ib_poll_cq() takes cq->cq_lock, polls hardware
CQEs, calls mana_flush_completions() for currently queued shadow WQEs, and
releases cq->cq_lock. __ib_process_cq() then invokes wc->wr_cqe->done() for
those flushed entries while IRQ_POLL_F_SCHED is still set.

Also, during ib_drain_qp() when send_cq =3D=3D recv_cq, mana_flush_completi=
ons()
flushes both send_err_qp_list (including sdrain) and recv_err_qp_list in a
single mana_ib_poll_cq() call; __ib_process_cq() invokes sdrain.cqe.done()
on the first WC while still iterating through the remaining flushed RQ WCs
with IRQ_POLL_F_SCHED set, waking the caller to immediately enter
mana_ib_drain_rq().

If mana_ib_drain_sq() or mana_ib_drain_rq() posts its drain WR into
shadow_sq or shadow_rq after mana_ib_poll_cq() drops cq->cq_lock and then
calls cq->comp_handler() -> irq_poll_sched(&cq->iop) before
ib_poll_handler() reaches irq_poll_complete(&cq->iop), irq_poll_sched() sees
IRQ_POLL_F_SCHED is already set and returns as a no-op.

When ib_poll_handler() then calls irq_poll_complete(&cq->iop) followed by
ib_req_notify_cq(cq, IB_POLL_FLAGS) -> mana_ib_arm_cq(), mana_ib_arm_cq()
only checks cq->has_pending_cqe:

drivers/infiniband/hw/mana/cq.c:mana_ib_arm_cq() {
	spin_lock_irqsave(&cq->cq_lock, irq_flags);
	mana_ib_cq_doorbell(cq, SET_ARM_BIT);
	if (flags & IB_CQ_REPORT_MISSED_EVENTS)
		missed =3D cq->has_pending_cqe;
	spin_unlock_irqrestore(&cq->cq_lock, irq_flags);

	return missed;
}

Because mana_ib_arm_cq() does not check for unconsumed software-flushed
shadow WQEs on send_err_qp_list or recv_err_qp_list and the QP in
IB_QPS_ERR will not produce hardware CQEs for the drain WR,
mana_ib_arm_cq() returns 0 and cq->iop is never rescheduled.

Should this synchronize with the softirq poll context using
irq_poll_disable(&cq->iop) and irq_poll_enable(&cq->iop) when invoking the
completion handler (similar to mlx4, mlx5, and hns), or report pending
error QP shadow WQEs in mana_ib_arm_cq()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261017064413.9959=
85-1-kotaranov@linux.microsoft.com?part=3D10
