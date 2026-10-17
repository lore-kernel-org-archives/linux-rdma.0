Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF82641A4F9
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 07:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792221787; cv=none; b=mgFVjWC1G0a4IS4NiNc+ET0mMNZr0lQll3llDkjwtvkbiyBquBKv7oBei+u1IS+cbKRvT7fBjw5KlpJ6V7JBivIkGioAWitgYXrnFCmta4/qhtirQsXJjTgq1N0pW8gCPvPSdPwXT1EA+ysDrSfQP3Y75v41AYsLNKc1aXg2bCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792221787; c=relaxed/simple;
	bh=/zL+RVp+VK6BfMw1XHM6A0byro3MiiWICTJ/hQnA1FM=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Jc0TixQ9K99Dr73qd6Og51A7jDNySHelRvsQlQ98ezRLcwFS35fdX25EV4nAcHvhjVDHw4B9EHuMCqit5u7Ax147mTcKDAIblWlfpu5ClcmISLxx7Cp5bdf+ueWzN3QxcU59ymxpYjL36Cgb5JIsfQXb69KaRBxUVKWGMvlINn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hSxZHInZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hSxZHInZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E76BF1F000C4;
	Sat, 17 Oct 2026 07:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792221784;
	bh=AHNYkMnU5VjSkLq4TL7p4yHKnaxS6B5AydTV0sCFwXA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hSxZHInZ8KBFqTkbt8c7Xd4osKKgwjrM0Xkfhx92P/iEDtVzVETgTunm/Eb+76zsw
	 JdaVPWbnQbh73fvR+mTGR19X10HRD2RUpwGX6HzqhbLyqKdr5UiLUr6kpIH8Jwh/QX
	 hpMZChUEeDdbqn1P/x8jARcKxGUYbql8eV157R46vtwe0TwfzOZSmydumxyeD+EaL3
	 kY+QRxWysqEeuxOLRlRhl/x5SGiLJdJPbss224F85UiBvd5VyQefDAt5z/B7nJN4VA
	 a97bgizIXlIFFF4HYwbQK8k8K3ropr0c1ePwMyu08NdAuf0rE4usgj96NIfKw9MYlU
	 p4x0emLlEpJXg==
Message-ID: <sashiko-outbox-175367@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v5 09/10] RDMA/mana_ib: Handle error CQEs for
 RC QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261017064413.995985-10-kotaranov@linux.microsoft.com>
References: <20261017064413.995985-1-kotaranov@linux.microsoft.com>
 <20261017064413.995985-10-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 07:23:03 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [High] RDMA/mana_ib: handle_error_cqe() fails to retire fenced WQE depend=
encies
- [High] RDMA/mana_ib: mana_ib_modify_qp() does not cancel error_work on QP=
 reset
- [High] RDMA/mana_ib: handle_error_cqe() adds active GSI QPs to CQ error l=
ists
- [High] RDMA/mana_ib: unchecked shadow queue advancement in handle_error_c=
qe()
- [High] RDMA/mana_ib: premature WR software flush in handle_error_cqe() be=
fore HW ERR
--

commit 75bf7e7dda34f9cbdab6ae2d0e0c7423140a1078
Author: Konstantin Taranov <kotaranov@microsoft.com>

RDMA/mana_ib: Handle error CQEs for RC QPs

This commit adds hardware error CQE decoding for RC QPs, completing the
failing shadow entry with the CQE vendor status and deferring the QP
transition to the error state via a workqueue so other work queues can be
flushed.

> diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana=
/cq.c
> index 080f09f3c634e..a66fe0cc92b4a 100644
> --- a/drivers/infiniband/hw/mana/cq.c
> +++ b/drivers/infiniband/hw/mana/cq.c

[ ... ]

> @@ -493,6 +516,71 @@ static bool handle_psn_cqe(struct mana_ib_qp *qp, u3=
2 psn,
>  	return consumed;
>  }
> =20
> +static bool mana_cqe_is_send(struct mana_ib_qp *qp, struct gdma_comp *cq=
e)
> +{
> +	u32 qtype =3D cqe->wq_num & MANA_QID_SUBTYPE_MASK;
> +
> +	if (qp->ibqp.qp_type !=3D IB_QPT_RC)
> +		return cqe->is_sq;
> +
> +	return cqe->is_sq ? (qtype =3D=3D MANA_QID_SUBTYPE_SREQ ||
> +			    qtype =3D=3D MANA_QID_SUBTYPE_MMQ) :
> +			    qtype =3D=3D MANA_QID_SUBTYPE_RREQ;
> +}
> +
> +static void mana_ib_schedule_qp_error(struct mana_ib_qp *qp)
> +{
> +	/* CQ polling cannot sleep; teardown drains this reference before freei=
ng. */
> +	refcount_inc(&qp->refcount);
> +	if (!schedule_work(&qp->error_work))
> +		mana_put_qp_ref(qp);
> +}
> +
> +static bool handle_error_cqe(struct mana_ib_cq *cq, struct mana_ib_qp *q=
p,
> +			     struct gdma_comp *cqe, struct mana_cq_poll *poll)
> +{
> +	bool mmq =3D cqe->is_sq && (cqe->wq_num & MANA_QID_SUBTYPE_MASK) =3D=3D=
 MANA_QID_SUBTYPE_MMQ;
> +	struct mana_rdma_cqe *rdma_cqe =3D (struct mana_rdma_cqe *)cqe->cqe_dat=
a;
> +	bool send =3D mana_cqe_is_send(qp, cqe);
> +	u32 vendor_err =3D rdma_cqe->error.vendor_error;
> +	struct shadow_wqe_header *shadow_wqe;
> +	struct shadow_queue *shadow_q;
> +
> +	if (send && qp->ibqp.qp_type =3D=3D IB_QPT_RC) {
> +		/* The error PSN/FSN belongs to the failing WQE, not a success. */
> +		if (!mana_advance_send(qp, mmq, rdma_cqe->error.psn - 1, poll))
> +			return false;
> +		if (poll->produced =3D=3D poll->budget)
> +			return false;
> +	}
> +
> +	if (!send)
> +		shadow_q =3D &qp->shadow_rq;
> +	else if (mmq)
> +		shadow_q =3D &qp->shadow_mmq;
> +	else
> +		shadow_q =3D &qp->shadow_sq;
> +
> +	shadow_wqe =3D shadow_queue_get_next_to_consume(shadow_q);
> +	if (shadow_wqe) {
> +		mana_fill_wc(qp, poll, shadow_wqe,
> +			     send ? shadow_wqe->send_opcode : IB_WC_RECV, vendor_err);
> +		shadow_queue_advance_consumer(shadow_q);
> +	}

[Severity: High]
When a fenced send WQE fails with CQE_TYPE_ERROR, does this code fail to
retire the older fenced dependencies on the companion shadow queue before
completing the failing WQE?

In mana_advance_send(), the loop checks PSN_LT() before checking
MANA_WQ_FENCE_WC:

drivers/infiniband/hw/mana/cq.c:mana_advance_send()
	while ((shadow_wqe =3D shadow_queue_get_next_to_consume(shadow))) {
		if (PSN_LT(seq, mmq ? shadow_wqe->fsn : shadow_wqe->wqe_offset_or_psn))
			break;
		if (poll->produced =3D=3D poll->budget)
			return false;
		if (shadow_wqe->flags & MANA_WQ_FENCE_WC) {
			...
		}
		mana_complete_send(qp, mmq, poll, VENDOR_ERR_OK);
	}

Because handle_error_cqe() passes rdma_cqe->error.psn - 1 as seq,
mana_advance_send() breaks out of the loop before reaching the failing WQE's
MANA_WQ_FENCE_WC check. handle_error_cqe() then directly consumes the faili=
ng
shadow_wqe from shadow_q (also skipping the gdma_queue tail update performed
by mana_complete_send()) and adds the QP to cq->send_err_qp_list.

When mana_flush_completions() subsequently runs at the end of
mana_ib_poll_cq(), any older unsignaled WRs on the companion shadow queue
(such as IB_WR_REG_MR or IB_WR_LOCAL_INV posted before the fence that alrea=
dy
succeeded in hardware) are still unconsumed and get flushed via
mana_complete_send(..., VENDOR_ERR_SW_FLUSHED), emitting spurious
IB_WC_WR_FLUSH_ERR completions out of order after the dependent failing WQE.

---

[Severity: High]
Can calling mana_advance_send(qp, mmq, rdma_cqe->error.psn - 1, poll) and
unconditionally popping the head of shadow_q in handle_error_cqe() falsely
complete unacknowledged WRs with IB_WC_SUCCESS or consume mismatched shadow
WQEs?

In mana_ib_post_sq(), all non-MMQ send WRs (IB_WR_SEND, IB_WR_RDMA_WRITE,
IB_WR_RDMA_READ) are recorded in qp->shadow_sq and posted to SREQ, whereas
only IB_WR_RDMA_READ posts a WQE to RREQ:

drivers/infiniband/hw/mana/wr.c:mana_ib_post_sq()
	if (wr->opcode =3D=3D IB_WR_RDMA_READ) {
		struct gdma_queue *rq =3D qp->rc_qp.queues[MANA_RC_RECV_QUEUE_REQUESTER].=
kmem;
		struct rdma_recv_oob recv_oob =3D {0};

		recv_oob.psn_start =3D qp->sq_psn;
		recv_oob.msn =3D qp->sq_ssn;
		...
		err =3D mana_gd_post_work_request(rq, &wqe_req, &wqe_info);

Because mana_cqe_is_send() maps both SREQ and RREQ to send =3D true (and
mmq =3D false), an error CQE on RREQ (such as VENDOR_ERR_RX_NOT_EMPTY_ON_DI=
SABLE
when the QP transitions to IB_QPS_ERR, or an RREQ WQE error) carries the
IB_WR_RDMA_READ PSN, skipping over any preceding unacknowledged IB_WR_SEND =
or
IB_WR_RDMA_WRITE entries in qp->shadow_sq. Calling mana_advance_send() with
rdma_cqe->error.psn - 1 retires those earlier unacknowledged or unexecuted
shadow_sq entries (and any fenced shadow_mmq entries) with VENDOR_ERR_OK
(IB_WC_SUCCESS).

Additionally, shadow_queue_get_next_to_consume(shadow_q) does not verify th=
at
shadow_wqe matches rdma_cqe->error.psn. If both SREQ and RREQ emit error CQ=
Es
for the same IB_WR_RDMA_READ, or if a disable-generated error CQE is polled
after the queue was already advanced or flushed, won't handle_error_cqe()
consume the next unrelated WQE from shadow_q with vendor_err?

> +
> +	if (send) {
> +		if (list_empty(&qp->send_err_node))
> +			list_add_tail(&qp->send_err_node, &cq->send_err_qp_list);
> +	} else {
> +		if (list_empty(&qp->recv_err_node))
> +			list_add_tail(&qp->recv_err_node, &cq->recv_err_qp_list);
> +	}
> +	if (qp->ibqp.qp_type !=3D IB_QPT_GSI)
> +		mana_ib_schedule_qp_error(qp);
> +
> +	return true;
> +}

[Severity: High]
What happens when handle_error_cqe() processes an error CQE on a GSI QP?

mana_ib_schedule_qp_error(qp) is skipped when qp->ibqp.qp_type =3D=3D IB_QP=
T_GSI
so the GSI QP remains in IB_QPS_RTS, but qp->send_err_node or
qp->recv_err_node is still added unconditionally to cq->send_err_qp_list or
cq->recv_err_qp_list.

Won't mana_flush_completions() then immediately flush all other posted GSI
WRs with IB_WC_WR_FLUSH_ERR while hardware still owns their DMA buffers in
RTS, and won't mana_ib_post_send_ud() / mana_ib_post_recv_ud() continue
flushing every future WR posted to that GSI queue for the remainder of the
QP's lifetime?

---

[Severity: High]
For RC QPs, does adding the QP to cq->send_err_qp_list or
cq->recv_err_qp_list here cause mana_flush_completions() to software-flush
in-flight WRs before qp->error_work has transitioned the hardware queues to
IB_QPS_ERR?

In mana_ib_poll_cq(), mana_flush_completions() runs before returning:

drivers/infiniband/hw/mana/cq.c:mana_flush_completions()
	list_for_each_entry(qp, &cq->send_err_qp_list, send_err_node) {
		while (poll->produced < poll->budget) {
			sq_wqe =3D shadow_queue_get_next_to_consume(&qp->shadow_sq);
			mmq_wqe =3D shadow_queue_get_next_to_consume(&qp->shadow_mmq);
			if (!sq_wqe && !mmq_wqe)
				break;
			next_is_sq =3D next_shadow_wqe_is_sq(sq_wqe, mmq_wqe);
			mana_complete_send(qp, !next_is_sq, poll, VENDOR_ERR_SW_FLUSHED);
		}
		if (poll->produced =3D=3D poll->budget)
			return;
	}

Because cq->send_err_qp_list flushes both shadow_sq and shadow_mmq across
SREQ, RREQ, and MMQ, an error CQE on one hardware queue will immediately
return IB_WC_WR_FLUSH_ERR for in-flight WRs on the other hardware queues
while they are still active in RTS (before mana_ib_qp_error_work() runs
mana_ib_gd_modify_qp() to stop them and calls mana_add_qp_to_error_cqs()).
Could this allow ULPs to unmap or free DMA buffers while hardware is still
accessing them?

> diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana=
/qp.c
> index e8c479c96cbf7..04755bec015ed 100644
> --- a/drivers/infiniband/hw/mana/qp.c
> +++ b/drivers/infiniband/hw/mana/qp.c

[ ... ]

> @@ -1183,6 +1187,20 @@ int mana_ib_modify_qp(struct ib_qp *ibqp, struct i=
b_qp_attr *attr,
>  	return ret;
>  }
> =20
> +static void mana_ib_qp_error_work(struct work_struct *work)
> +{
> +	struct mana_ib_qp *qp =3D container_of(work, struct mana_ib_qp, error_w=
ork);
> +	struct ib_qp_attr attr =3D { .qp_state =3D IB_QPS_ERR };
> +	int ret;
> +
> +	ret =3D mana_ib_modify_qp(&qp->ibqp, &attr, IB_QP_STATE, NULL);
> +	if (ret)
> +		ibdev_err(qp->ibqp.device, "Failed to move QP %u to ERR: %d\n",
> +			  qp->ibqp.qp_num, ret);
> +
> +	mana_put_qp_ref(qp);
> +}

[Severity: High]
If a consumer resets a QP to IB_QPS_RESET via mana_ib_modify_qp() after
polling error/flush completions (or after a VENDOR_ERR_RX_NOT_EMPTY_ON_DISA=
BLE
CQE schedules qp->error_work), can a pending mana_ib_qp_error_work() run
afterward and force the reset or re-initialized QP back into IB_QPS_ERR?

In mana_ib_modify_qp_state(), transitioning to IB_QPS_RESET removes the QP
from the CQs and resets the shadow queues:

drivers/infiniband/hw/mana/qp.c:mana_ib_modify_qp_state()
	if (attr_mask & IB_QP_STATE) {
		switch (attr->qp_state) {
		case IB_QPS_RESET:
			mana_remove_qp_from_cqs(qp, true);
			break;
		default:
			break;
		}
		if (attr->qp_state =3D=3D IB_QPS_ERR) {
			mana_add_qp_to_error_cqs(qp);
			notify =3D true;
		}
	}

However, qp->error_work is not cancelled on IB_QPS_RESET, and
mana_ib_qp_error_work() unconditionally calls mana_ib_modify_qp() with
IB_QPS_ERR when it executes.

> =20
>  static int mana_ib_destroy_qp_rss(struct mana_ib_qp *qp,
>  				  struct ib_rwq_ind_table *ind_tbl,

[ ... ]

=E5=AE=8C=E7=BE=8E=E7=BB=93=E6=9D=9F=EF=BC=8C=E7=A1=AE=E4=BF=9D=E6=9C=80=E5=
=90=8E=E6=9C=89=E4=B8=80=E7=A9=BA=E8=A1=8C=E3=80=82
 Let's make sure I don't output the Chinese note at the end! Let me check t=
he exact output.commit 75bf7e7dda34f9cbdab6ae2d0e0c7423140a1078
Author: Konstantin Taranov <kotaranov@microsoft.com>

RDMA/mana_ib: Handle error CQEs for RC QPs

This commit adds hardware error CQE decoding for RC QPs, completing the
failing shadow entry with the CQE vendor status and deferring the QP
transition to the error state via a workqueue so other work queues can be
flushed.

> diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana=
/cq.c
> index 080f09f3c634e..a66fe0cc92b4a 100644
> --- a/drivers/infiniband/hw/mana/cq.c
> +++ b/drivers/infiniband/hw/mana/cq.c

[ ... ]

> @@ -493,6 +516,71 @@ static bool handle_psn_cqe(struct mana_ib_qp *qp, u3=
2 psn,
>  	return consumed;
>  }
> =20
> +static bool mana_cqe_is_send(struct mana_ib_qp *qp, struct gdma_comp *cq=
e)
> +{
> +	u32 qtype =3D cqe->wq_num & MANA_QID_SUBTYPE_MASK;
> +
> +	if (qp->ibqp.qp_type !=3D IB_QPT_RC)
> +		return cqe->is_sq;
> +
> +	return cqe->is_sq ? (qtype =3D=3D MANA_QID_SUBTYPE_SREQ ||
> +			    qtype =3D=3D MANA_QID_SUBTYPE_MMQ) :
> +			    qtype =3D=3D MANA_QID_SUBTYPE_RREQ;
> +}
> +
> +static void mana_ib_schedule_qp_error(struct mana_ib_qp *qp)
> +{
> +	/* CQ polling cannot sleep; teardown drains this reference before freei=
ng. */
> +	refcount_inc(&qp->refcount);
> +	if (!schedule_work(&qp->error_work))
> +		mana_put_qp_ref(qp);
> +}
> +
> +static bool handle_error_cqe(struct mana_ib_cq *cq, struct mana_ib_qp *q=
p,
> +			     struct gdma_comp *cqe, struct mana_cq_poll *poll)
> +{
> +	bool mmq =3D cqe->is_sq && (cqe->wq_num & MANA_QID_SUBTYPE_MASK) =3D=3D=
 MANA_QID_SUBTYPE_MMQ;
> +	struct mana_rdma_cqe *rdma_cqe =3D (struct mana_rdma_cqe *)cqe->cqe_dat=
a;
> +	bool send =3D mana_cqe_is_send(qp, cqe);
> +	u32 vendor_err =3D rdma_cqe->error.vendor_error;
> +	struct shadow_wqe_header *shadow_wqe;
> +	struct shadow_queue *shadow_q;
> +
> +	if (send && qp->ibqp.qp_type =3D=3D IB_QPT_RC) {
> +		/* The error PSN/FSN belongs to the failing WQE, not a success. */
> +		if (!mana_advance_send(qp, mmq, rdma_cqe->error.psn - 1, poll))
> +			return false;
> +		if (poll->produced =3D=3D poll->budget)
> +			return false;
> +	}
> +
> +	if (!send)
> +		shadow_q =3D &qp->shadow_rq;
> +	else if (mmq)
> +		shadow_q =3D &qp->shadow_mmq;
> +	else
> +		shadow_q =3D &qp->shadow_sq;
> +
> +	shadow_wqe =3D shadow_queue_get_next_to_consume(shadow_q);
> +	if (shadow_wqe) {
> +		mana_fill_wc(qp, poll, shadow_wqe,
> +			     send ? shadow_wqe->send_opcode : IB_WC_RECV, vendor_err);
> +		shadow_queue_advance_consumer(shadow_q);
> +	}

[Severity: High]
When a fenced send WQE fails with CQE_TYPE_ERROR, does this code fail to
retire the older fenced dependencies on the companion shadow queue before
completing the failing WQE?

In mana_advance_send(), the loop checks PSN_LT() before checking
MANA_WQ_FENCE_WC:

drivers/infiniband/hw/mana/cq.c:mana_advance_send()
	while ((shadow_wqe =3D shadow_queue_get_next_to_consume(shadow))) {
		if (PSN_LT(seq, mmq ? shadow_wqe->fsn : shadow_wqe->wqe_offset_or_psn))
			break;
		if (poll->produced =3D=3D poll->budget)
			return false;
		if (shadow_wqe->flags & MANA_WQ_FENCE_WC) {
			...
		}
		mana_complete_send(qp, mmq, poll, VENDOR_ERR_OK);
	}

Because handle_error_cqe() passes rdma_cqe->error.psn - 1 as seq,
mana_advance_send() breaks out of the loop before reaching the failing WQE's
MANA_WQ_FENCE_WC check. handle_error_cqe() then directly consumes the faili=
ng
shadow_wqe from shadow_q (also skipping the gdma_queue tail update performed
by mana_complete_send()) and adds the QP to cq->send_err_qp_list.

When mana_flush_completions() subsequently runs at the end of
mana_ib_poll_cq(), any older unsignaled WRs on the companion shadow queue
(such as IB_WR_REG_MR or IB_WR_LOCAL_INV posted before the fence that alrea=
dy
succeeded in hardware) are still unconsumed and get flushed via
mana_complete_send(..., VENDOR_ERR_SW_FLUSHED), emitting spurious
IB_WC_WR_FLUSH_ERR completions out of order after the dependent failing WQE.

---

[Severity: High]
Can calling mana_advance_send(qp, mmq, rdma_cqe->error.psn - 1, poll) and
unconditionally popping the head of shadow_q in handle_error_cqe() falsely
complete unacknowledged WRs with IB_WC_SUCCESS or consume mismatched shadow
WQEs?

In mana_ib_post_sq(), all non-MMQ send WRs (IB_WR_SEND, IB_WR_RDMA_WRITE,
IB_WR_RDMA_READ) are recorded in qp->shadow_sq and posted to SREQ, whereas
only IB_WR_RDMA_READ posts a WQE to RREQ:

drivers/infiniband/hw/mana/wr.c:mana_ib_post_sq()
	if (wr->opcode =3D=3D IB_WR_RDMA_READ) {
		struct gdma_queue *rq =3D qp->rc_qp.queues[MANA_RC_RECV_QUEUE_REQUESTER].=
kmem;
		struct rdma_recv_oob recv_oob =3D {0};

		recv_oob.psn_start =3D qp->sq_psn;
		recv_oob.msn =3D qp->sq_ssn;
		...
		err =3D mana_gd_post_work_request(rq, &wqe_req, &wqe_info);

Because mana_cqe_is_send() maps both SREQ and RREQ to send =3D true (and
mmq =3D false), an error CQE on RREQ (such as VENDOR_ERR_RX_NOT_EMPTY_ON_DI=
SABLE
when the QP transitions to IB_QPS_ERR, or an RREQ WQE error) carries the
IB_WR_RDMA_READ PSN, skipping over any preceding unacknowledged IB_WR_SEND =
or
IB_WR_RDMA_WRITE entries in qp->shadow_sq. Calling mana_advance_send() with
rdma_cqe->error.psn - 1 retires those earlier unacknowledged or unexecuted
shadow_sq entries (and any fenced shadow_mmq entries) with VENDOR_ERR_OK
(IB_WC_SUCCESS).

Additionally, shadow_queue_get_next_to_consume(shadow_q) does not verify th=
at
shadow_wqe matches rdma_cqe->error.psn. If both SREQ and RREQ emit error CQ=
Es
for the same IB_WR_RDMA_READ, or if a disable-generated error CQE is polled
after the queue was already advanced or flushed, won't handle_error_cqe()
consume the next unrelated WQE from shadow_q with vendor_err?

> +
> +	if (send) {
> +		if (list_empty(&qp->send_err_node))
> +			list_add_tail(&qp->send_err_node, &cq->send_err_qp_list);
> +	} else {
> +		if (list_empty(&qp->recv_err_node))
> +			list_add_tail(&qp->recv_err_node, &cq->recv_err_qp_list);
> +	}
> +	if (qp->ibqp.qp_type !=3D IB_QPT_GSI)
> +		mana_ib_schedule_qp_error(qp);
> +
> +	return true;
> +}

[Severity: High]
What happens when handle_error_cqe() processes an error CQE on a GSI QP?

mana_ib_schedule_qp_error(qp) is skipped when qp->ibqp.qp_type =3D=3D IB_QP=
T_GSI
so the GSI QP remains in IB_QPS_RTS, but qp->send_err_node or
qp->recv_err_node is still added unconditionally to cq->send_err_qp_list or
cq->recv_err_qp_list.

Won't mana_flush_completions() then immediately flush all other posted GSI
WRs with IB_WC_WR_FLUSH_ERR while hardware still owns their DMA buffers in
RTS, and won't mana_ib_post_send_ud() / mana_ib_post_recv_ud() continue
flushing every future WR posted to that GSI queue for the remainder of the
QP's lifetime?

---

[Severity: High]
For RC QPs, does adding the QP to cq->send_err_qp_list or
cq->recv_err_qp_list here cause mana_flush_completions() to software-flush
in-flight WRs before qp->error_work has transitioned the hardware queues to
IB_QPS_ERR?

In mana_ib_poll_cq(), mana_flush_completions() runs before returning:

drivers/infiniband/hw/mana/cq.c:mana_flush_completions()
	list_for_each_entry(qp, &cq->send_err_qp_list, send_err_node) {
		while (poll->produced < poll->budget) {
			sq_wqe =3D shadow_queue_get_next_to_consume(&qp->shadow_sq);
			mmq_wqe =3D shadow_queue_get_next_to_consume(&qp->shadow_mmq);
			if (!sq_wqe && !mmq_wqe)
				break;
			next_is_sq =3D next_shadow_wqe_is_sq(sq_wqe, mmq_wqe);
			mana_complete_send(qp, !next_is_sq, poll, VENDOR_ERR_SW_FLUSHED);
		}
		if (poll->produced =3D=3D poll->budget)
			return;
	}

Because cq->send_err_qp_list flushes both shadow_sq and shadow_mmq across
SREQ, RREQ, and MMQ, an error CQE on one hardware queue will immediately
return IB_WC_WR_FLUSH_ERR for in-flight WRs on the other hardware queues
while they are still active in RTS (before mana_ib_qp_error_work() runs
mana_ib_gd_modify_qp() to stop them and calls mana_add_qp_to_error_cqs()).
Could this allow ULPs to unmap or free DMA buffers while hardware is still
accessing them?

> diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana=
/qp.c
> index e8c479c96cbf7..04755bec015ed 100644
> --- a/drivers/infiniband/hw/mana/qp.c
> +++ b/drivers/infiniband/hw/mana/qp.c

[ ... ]

> @@ -1183,6 +1187,20 @@ int mana_ib_modify_qp(struct ib_qp *ibqp, struct i=
b_qp_attr *attr,
>  	return ret;
>  }
> =20
> +static void mana_ib_qp_error_work(struct work_struct *work)
> +{
> +	struct mana_ib_qp *qp =3D container_of(work, struct mana_ib_qp, error_w=
ork);
> +	struct ib_qp_attr attr =3D { .qp_state =3D IB_QPS_ERR };
> +	int ret;
> +
> +	ret =3D mana_ib_modify_qp(&qp->ibqp, &attr, IB_QP_STATE, NULL);
> +	if (ret)
> +		ibdev_err(qp->ibqp.device, "Failed to move QP %u to ERR: %d\n",
> +			  qp->ibqp.qp_num, ret);
> +
> +	mana_put_qp_ref(qp);
> +}

[Severity: High]
If a consumer resets a QP to IB_QPS_RESET via mana_ib_modify_qp() after
polling error/flush completions (or after a VENDOR_ERR_RX_NOT_EMPTY_ON_DISA=
BLE
CQE schedules qp->error_work), can a pending mana_ib_qp_error_work() run
afterward and force the reset or re-initialized QP back into IB_QPS_ERR?

In mana_ib_modify_qp_state(), transitioning to IB_QPS_RESET removes the QP
from the CQs and resets the shadow queues:

drivers/infiniband/hw/mana/qp.c:mana_ib_modify_qp_state()
	if (attr_mask & IB_QP_STATE) {
		switch (attr->qp_state) {
		case IB_QPS_RESET:
			mana_remove_qp_from_cqs(qp, true);
			break;
		default:
			break;
		}
		if (attr->qp_state =3D=3D IB_QPS_ERR) {
			mana_add_qp_to_error_cqs(qp);
			notify =3D true;
		}
	}

However, qp->error_work is not cancelled on IB_QPS_RESET, and
mana_ib_qp_error_work() unconditionally calls mana_ib_modify_qp() with
IB_QPS_ERR when it executes.

> =20
>  static int mana_ib_destroy_qp_rss(struct mana_ib_qp *qp,
>  				  struct ib_rwq_ind_table *ind_tbl,

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261017064413.9959=
85-1-kotaranov@linux.microsoft.com?part=3D9
