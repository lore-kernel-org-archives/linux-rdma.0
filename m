Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0783115B8
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 07:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792221131; cv=none; b=POWQKZait2LgNKINuhyxWUq0S5Dyzk6qNSFr98cg8dPA0aGN/VMCz/SyoE7zgiejSSV2Foung/dKAUOdWPVBi+Gc0mfWpz6cWMzuessIAd1c8QwjKna6cgPT+/BVH31YaLS3377kx/7Fsy027avQRFyY2gQeo5d8dNs8b0sOYXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792221131; c=relaxed/simple;
	bh=E89C/eNYoH0bXDLUzbov22DgFibtKKqIcORZMNd+CSI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=ppvNPdY9ZEeMdwKDwJaqr+D0iywJ3WnL/4QPiqwr61eRH+7JSvtMnTbw714As3KPYfvCTqFcVLvEBEs221nznlrdJRanO0qsqmg7a0HMNxnz3wygL7IrbT6u3BVANMogWvlFoYeXiRKogXMPp5DZFJep2zW4d9KPH0TUz56BjsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PrQm6PrS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PrQm6PrS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07CD1F000C4;
	Sat, 17 Oct 2026 07:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792221129;
	bh=JrL/s57//2YlBIbJflYlEFBN2NDC6gGEF5cN2KuD43U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PrQm6PrSr5D+6xR6PkDUXkZtmMaV7L0ybX/luy/jIagtRfVdnBg9dtl0HWbN3CEMA
	 QlpYT8CQU67cBaJyYXDbC2VNCym4MnnXVwAYjzKC0cyVSKlzmJpegbFNahzaa27i4x
	 53HuLinIGhOje9eRsnAqtRNsQIjSRf/UrC6eOok4rPas9leI9sGjO9rVZ0JrAPwLsk
	 fX5I0bhr865/vM5v6CkJsemANDp3nFOzftER8c5Y4VpouBDQ5Dm7o4tUrjPTiCrFmB
	 KKUXtZJWP3gZlJDSqQYe59vWDMKItv781bXwOekZAi1HEtNXBHQ/5pT/Rge1v4shMo
	 bGszyfef4S62Q==
Message-ID: <sashiko-outbox-175364@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v5 08/10] RDMA/mana_ib: Flush and notify CQs
 when kernel QPs enter ERR
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261017064413.995985-9-kotaranov@linux.microsoft.com>
References: <20261017064413.995985-1-kotaranov@linux.microsoft.com>
 <20261017064413.995985-9-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 07:12:09 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] RDMA/mana_ib: missing CQ notification for WRs posted after IB_QPS_=
ERR
- [High] RDMA/mana_ib: lost software flush notification in mana_ib_arm_cq()
- [Medium] RDMA/mana_ib: missing IB_POLL_DIRECT check in mana_ib_post_send_=
ud()
--

commit 254e0a6be9165a866ac991ad943bce590f88dfb0
Author: Konstantin Taranov <kotaranov@microsoft.com>

RDMA/mana_ib: Flush and notify CQs when kernel QPs enter ERR

This commit links kernel QPs onto the CQ error lists when transitioning to
IB_QPS_ERR and invokes the CQ completion handlers so pending work requests
can be software-flushed.

> diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana=
/cq.c
> index cd77e305c38f9..080f09f3c634e 100644
> --- a/drivers/infiniband/hw/mana/cq.c
> +++ b/drivers/infiniband/hw/mana/cq.c
> @@ -589,7 +589,7 @@ static void mana_drain_gsi_sq(struct mana_ib_qp *qp)
>  		list_add_tail(&qp->send_err_node, &cq->send_err_qp_list);
>  	spin_unlock_irqrestore(&cq->cq_lock, flags);
> =20
> -	if (cq->ibcq.comp_handler)
> +	if (cq->ibcq.poll_ctx !=3D IB_POLL_DIRECT && cq->ibcq.comp_handler)
>  		cq->ibcq.comp_handler(&cq->ibcq, cq->ibcq.cq_context);
>  }

[Severity: Medium]
Should mana_ib_post_send_ud() in drivers/infiniband/hw/mana/wr.c also check
for IB_POLL_DIRECT before invoking comp_handler?

With this commit, mana_ib_modify_qp_state() calls mana_add_qp_to_error_cqs()
for any kernel QP entering IB_QPS_ERR, including kernel UD QPs, which links
qp->send_err_node onto send_cq->send_err_qp_list.

When mana_ib_post_send_ud() subsequently posts a WR on that QP, it checks
send_err_node and calls comp_handler without checking poll_ctx:

drivers/infiniband/hw/mana/wr.c:mana_ib_post_send_ud() {
	...
	spin_lock_irqsave(&cq->cq_lock, flags);
	flush_send =3D !list_empty(&qp->send_err_node);
	spin_unlock_irqrestore(&cq->cq_lock, flags);

	if (flush_send && cq->ibcq.comp_handler)
		cq->ibcq.comp_handler(&cq->ibcq, cq->ibcq.cq_context);
}

If the kernel UD QP uses a send CQ created with IB_POLL_DIRECT, will calling
comp_handler invoke ib_cq_completion_direct() and trigger its WARN_ONCE()?

> diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana=
/qp.c
> index cd2bc39fce6ec..e8c479c96cbf7 100644
> --- a/drivers/infiniband/hw/mana/qp.c
> +++ b/drivers/infiniband/hw/mana/qp.c
> @@ -771,6 +771,27 @@ static int mana_ib_create_uc_qp(struct ib_qp *ibqp, =
struct ib_pd *ibpd,
>  	return err;
>  }
> =20
> +static void mana_add_qp_to_error_cqs(struct mana_ib_qp *qp)
> +{
> +	struct mana_ib_cq *send_cq =3D container_of(qp->ibqp.send_cq, struct ma=
na_ib_cq, ibcq);
> +	struct mana_ib_cq *recv_cq =3D container_of(qp->ibqp.recv_cq, struct ma=
na_ib_cq, ibcq);
> +	unsigned long flags;
> +
> +	if (WARN_ON_ONCE(qp->ibqp.uobject))
> +		return;
> +
> +	/* Keep ERR QPs linked until reset/destroy, including later drain WRs. =
*/
> +	spin_lock_irqsave(&send_cq->cq_lock, flags);
> +	if (list_empty(&qp->send_err_node))
> +		list_add_tail(&qp->send_err_node, &send_cq->send_err_qp_list);
> +	spin_unlock_irqrestore(&send_cq->cq_lock, flags);
> +
> +	spin_lock_irqsave(&recv_cq->cq_lock, flags);
> +	if (list_empty(&qp->recv_err_node))
> +		list_add_tail(&qp->recv_err_node, &recv_cq->recv_err_qp_list);
> +	spin_unlock_irqrestore(&recv_cq->cq_lock, flags);
> +}

[Severity: High]
Can work requests posted concurrently with or after the transition to
IB_QPS_ERR be left unpolled in the shadow queues?

Once the QP is in IB_QPS_ERR in hardware, MANA hardware ignores WQ doorbells
for that QP and generates no hardware CQEs for subsequently posted WRs.

Unlike mana_ib_post_send_ud(), which checks !list_empty(&qp->send_err_node)
under cq->cq_lock and invokes cq->ibcq.comp_handler after ringing the
doorbell, mana_ib_post_send_rc(), mana_ib_post_recv_rc(), and
mana_ib_post_recv_ud() in drivers/infiniband/hw/mana/wr.c only queue the WR
to shadow_sq, shadow_mmq, or shadow_rq and ring the doorbell without checki=
ng
send_err_node or recv_err_node or invoking comp_handler:

drivers/infiniband/hw/mana/wr.c:mana_ib_post_send_rc() {
	...
	if (ring_sq)
		mana_gd_wq_ring_doorbell(mdev_to_gc(mdev),
					 qp->rc_qp.queues[MANA_RC_SEND_QUEUE_REQUESTER].kmem);

	spin_unlock_irqrestore(&qp->sq_lock, flags);
	return err;
}

At this commit, __ib_drain_sq() and __ib_drain_rq() call
ib_modify_qp(IB_QPS_ERR) and then post the drain WR via ib_post_send() or
ib_post_recv() without calling comp_handler again. If the CQ poll triggered
by mana_ib_notify_error_cqs() runs and finishes mana_ib_poll_cq() before the
drain WR is posted to shadow_sq or shadow_rq, wait_for_completion() hangs.

Even with the later commits in this series ("RDMA/mana_ib: Drain kernel
receive and send queues", which adds custom mana_ib_drain_sq() and
mana_ib_drain_rq() callbacks that call cq->comp_handler after posting the
drain WR, and "RDMA/mana_ib: Handle error CQEs for RC QPs", which adds
mana_ib_qp_error_work), any WR posted concurrently with or after
mana_ib_modify_qp(IB_QPS_ERR) outside mana_ib_drain_sq() or
mana_ib_drain_rq() =E2=80=94 for example when mana_ib_qp_error_work asynchr=
onously
moves the QP to IB_QPS_ERR while a ULP is posting WRs, or when a ULP moves
the QP to IB_QPS_ERR and posts a WR directly =E2=80=94 will be queued to th=
e shadow
queue after mana_ib_notify_error_cqs() without re-triggering CQ polling.

Should mana_ib_post_send_rc(), mana_ib_post_recv_rc(), and
mana_ib_post_recv_ud() also check whether the QP is on the CQ error list and
notify the CQ, similar to mana_ib_post_send_ud()?

[ ... ]

> @@ -1107,12 +1133,27 @@ static void mana_ib_modify_qp_state(struct ib_qp =
*ibqp, struct ib_qp_attr *attr,
>  						     SET_ARM_BIT, MANA_PSN_CLIENT_OFFSET);
>  		}
>  	}
> +
> +	return notify;
> +}
> +
> +static void mana_ib_notify_error_cqs(struct mana_ib_qp *qp)
> +{
> +	struct ib_cq *send_cq =3D qp->ibqp.send_cq;
> +	struct ib_cq *recv_cq =3D qp->ibqp.recv_cq;
> +
> +	if (send_cq->poll_ctx !=3D IB_POLL_DIRECT && send_cq->comp_handler)
> +		send_cq->comp_handler(send_cq, send_cq->cq_context);
> +	if (recv_cq !=3D send_cq && recv_cq->poll_ctx !=3D IB_POLL_DIRECT &&
> +	    recv_cq->comp_handler)
> +		recv_cq->comp_handler(recv_cq, recv_cq->cq_context);
>  }

[Severity: High]
Can the software flush notification in mana_ib_notify_error_cqs() be lost on
IB_POLL_SOFTIRQ CQs if ib_poll_handler() is concurrently finishing a poll?

For IB_POLL_SOFTIRQ CQs, irq_poll_softirq() keeps IRQ_POLL_F_SCHED set in
cq->iop.state throughout __ib_process_cq() until ib_poll_handler() calls
irq_poll_complete(&cq->iop). Consider the following sequence:

CPU 0                                   CPU 1
ib_poll_handler()
  __ib_process_cq()
    mana_ib_poll_cq()
      mana_flush_completions()
      spin_unlock_irqrestore(&cq->cq_lock)
    /* executing wc->wr_cqe->done() */
                                        mana_ib_modify_qp()
                                          mana_add_qp_to_error_cqs()
                                          mana_ib_notify_error_cqs()
                                            ib_cq_completion_softirq()
                                              irq_poll_sched(&cq->iop)
                                              /* IRQ_POLL_F_SCHED still set,
                                               * returns without scheduling=
 */
  irq_poll_complete(&cq->iop)
  ib_req_notify_cq(cq,
    IB_CQ_NEXT_COMP |
    IB_CQ_REPORT_MISSED_EVENTS)
    mana_ib_arm_cq()

In mana_ib_arm_cq() in drivers/infiniband/hw/mana/cq.c,
IB_CQ_REPORT_MISSED_EVENTS only checks cq->has_pending_cqe:

drivers/infiniband/hw/mana/cq.c:mana_ib_arm_cq() {
	...
	spin_lock_irqsave(&cq->cq_lock, irq_flags);
	mana_ib_cq_doorbell(cq, SET_ARM_BIT);
	if (flags & IB_CQ_REPORT_MISSED_EVENTS)
		missed =3D cq->has_pending_cqe;
	spin_unlock_irqrestore(&cq->cq_lock, irq_flags);

	return missed ? 1 : 0;
}

Because mana_ib_arm_cq() does not check whether send_err_qp_list or
recv_err_qp_list has unconsumed WQEs in shadow_sq, shadow_mmq, or shadow_rq,
and software-flushed WRs do not generate hardware CQ interrupts, won't
mana_ib_arm_cq() return 0 and leave the error QP's pending WRs (or a drain =
WR
notified via comp_handler during that window) unpolled?

[ ... ]

>
>base-commit: 978361dd2ccff357d4fe6aac6ce057d1bfae8312

([978361dd2ccf: RDMA/mana_ib: Implement software flushing of RC QPs])
([254e0a6be916: RDMA/mana_ib: Flush and notify CQs when kernel QPs enter ER=
R])
([daeb2bf3de14: RDMA/mana_ib: Drain kernel receive and send queues])
([33d06de2231e: RDMA/mana_ib: Handle error CQEs for RC QPs])
([a966dc60ab42: RDMA/mana_ib: Report port events for RC])
([acdb8e2b2de9: RDMA/mana_ib: Implement modify_qp for UC])
([763b5797538e: RDMA/mana_ib: Set the correct syndrome properly in CQE])
([32de7988de0a: RDMA/mana_ib: Configure interrupt coalescing timer for RC])
([bc57232325f5: RDMA/mana_ib: Set RC transport capabilities])
([737b4ca9ed86: RDMA/mana_ib: Enable the RC support])

--=20
2.51.0

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261017064413.9959=
85-1-kotaranov@linux.microsoft.com?part=3D8
