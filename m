Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793367257;
	b=MHhuYxeHUQ6QlzO1IAiUglrcxAdAMKnl9HTx90L7DsnoBs5caGfDzbCaWer1YW+r811D
	 1FV8ZoGPd4FsFkyGxnKcQUGPkYBH7ckC6+gnyMtML/YY/f+gc5QqgbhQ0f0yGQabLJJH5
	 Bly1NWYG/6o0tzT97ohRi88gt5UPQP0Pn+5Ez16ehX4v2LQoZci2Q70L7neByhjraOjWV
	 cDIFMbnDHt7T36fUEVpVQ7n+DPJ79stOEnEpeZOBH7RtDpp5molHhHSONYtZTYu80AUQu
	 vx8J4L99KPoKRdlRsgB4zffJhUxUJFCTGJLTqhd+PfsMDcsWhUqbzhqHDOLnYIbSmIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793367257;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=lPEJy8PiLlOofpWGDf2SL7kz6PqadmcFQxUol8ZR75A=;
	b=RschAScB67DxlHEc25MRuzT7CG9UTARXMHgwWy3fY+VJLBmIUuNqpchVpdYXuueWcMsn
	 Br6sohEthRA4v5PJFYxeFNrkiN9th+wN8VyRrrz2eOCaXQ03kwQAKQ4bybRtJJog7s2zm
	 TGDfK+cTDCjvLIJJg4hDQLBIQVvHskocYbYjzuGy+GEWYy0CfOQWPPAvzAjnxqrPDCVt7
	 3TnHLRd7ner5ijfZSO68qdbukTlH3R2oDKwCJ1VBCgLPC8zyhIQeDuReadklJQ8CqHzhI
	 9UF0C4MtbNrKTD28F4+o9XB6a4UrPC+UNhk7ac9lqmQOx1QQeuuj/skkR7evoR0X7bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SK6esX+o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BA5606A31C
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 13:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SK6esX+o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0A721F000C1;
	Fri, 30 Oct 2026 13:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793367257;
	bh=lPEJy8PiLlOofpWGDf2SL7kz6PqadmcFQxUol8ZR75A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SK6esX+oeuvGEDGM7Vb0UFv/VeF+TdSmi8IREymbR5QcsaWexl1SVr0vdNzhbm1SX
	 sX8SgXwVvUNVTGOk7pOO6IeoKAUueFrg91+f0huwXU5zVni5jirVVwL9G9U8L1kqYo
	 r8Tqkt6S6QaI2sQMLGp8YQZZ1ZY9+JhXNljfF8T1grwWiwWrclWglMny7KM8ImEyap
	 mOf2pbqKkzR3Ls+n3pJPZQk0TMtumfGpVQkJIgyGt1k4J2WN0PGyCbUCej29OX6efC
	 Z9+9383m/tJusgJAZOqvIZNkIIbDV/IhyygkayL/Hy9ZsdMyz6PGPiDpos4B7E48UM
	 1NRBIdYD1xrSQ==
Message-ID: <sashiko-outbox-191063@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v6 09/10] RDMA/mana_ib: Handle error CQEs for
 RC QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261030130038.4040789-10-kotaranov@linux.microsoft.com>
References: <20261030130038.4040789-1-kotaranov@linux.microsoft.com>
 <20261030130038.4040789-10-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 13:34:16 +0000
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
- [High] RDMA/mana_ib: handle_error_cqe() leaves active GSI QPs on CQ error=
 lists
--

commit 1bb70d4df95cbf22f7fdb1b2cc6c47bc5b5ed6d5
Author: Konstantin Taranov <kotaranov@microsoft.com>

RDMA/mana_ib: Handle error CQEs for RC QPs

This commit adds handling for hardware error CQEs on RC QPs, deferring the
transition to the ERR state via a workqueue so that other work queues can be
flushed. It also cleans pending CQEs upon QP reset and tracks deferred error
state to avoid transitioning reset and reused QPs to ERR.

> diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana=
/cq.c
> index 74597c07f1cba..a707664f5ab8b 100644
> --- a/drivers/infiniband/hw/mana/cq.c
> +++ b/drivers/infiniband/hw/mana/cq.c

[ ... ]

> @@ -516,6 +594,79 @@ static bool handle_psn_cqe(struct mana_ib_qp *qp, u3=
2 psn,
>  	return consumed;
>  }
> =20

[ ... ]

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
> +		if (send) {
> +			if (!mana_complete_send_dependencies(qp, mmq, shadow_wqe, poll))
> +				return false;
> +
> +			mana_complete_send(qp, mmq, poll, vendor_err);
> +		} else {
> +			mana_fill_wc(qp, poll, shadow_wqe, IB_WC_RECV, vendor_err);
> +			shadow_queue_advance_consumer(shadow_q);
> +		}
> +	}
> +
> +	/* Hardware has stopped DMA for the queues flushed below. */
> +	if (send) {
> +		if (list_empty(&qp->send_err_node))
> +			list_add_tail(&qp->send_err_node, &cq->send_err_qp_list);
> +	} else {
> +		if (list_empty(&qp->recv_err_node))
> +			list_add_tail(&qp->recv_err_node, &cq->recv_err_qp_list);
> +	}
> +	if (qp->ibqp.qp_type !=3D IB_QPT_GSI)
> +		mana_ib_schedule_qp_error(qp);

[Severity: High]
As reported by Sashiko on v5 [1], in handle_error_cqe(), mana_ib_schedule_q=
p_error()
is skipped when qp->ibqp.qp_type =3D=3D IB_QPT_GSI, but qp->send_err_node or
qp->recv_err_node is still unconditionally added to cq->send_err_qp_list or
cq->recv_err_qp_list.

QPs are only removed from those error lists in mana_remove_qp_from_cqs() on=
 a
transition to IB_QPS_RESET in mana_ib_modify_qp_state(), or during QP
destruction:

drivers/infiniband/hw/mana/qp.c:mana_ib_modify_qp_state() {
	if (attr_mask & IB_QP_STATE) {
		switch (attr->qp_state) {
		case IB_QPS_RESET:
			mana_remove_qp_from_cqs(qp, true);
			...
			break;
		default:
			break;
		}
}

However, the MAD layer never transitions a GSI QP to IB_QPS_RESET. On a GSI
send error, ib_mad_send_done() -> ib_mad_send_error() transitions the QP fr=
om
IB_QPS_SQE back to IB_QPS_RTS and reposts the WRs via ib_post_send() ->
mana_ib_post_send_ud():

drivers/infiniband/hw/mana/wr.c:mana_ib_post_send_ud() {
	...
	if (ring_sq) {
		mana_gd_wq_ring_doorbell(mdev_to_gc(mdev), queue);
		mana_ib_notify_flush(qp->ibqp.send_cq, &qp->send_err_node);
	}
}

Because qp->send_err_node remains on cq->send_err_qp_list while the GSI QP =
is
active in IB_QPS_RTS, won't mana_flush_completions() immediately software-f=
lush
all in-flight and newly posted GSI WRs with IB_WC_WR_FLUSH_ERR, causing
ib_mad_send_done() to DMA-unmap buffers while hardware still owns them and
permanently breaking GSI traffic on the port? Similarly, if a receive error
occurs while the GSI RQ remains active in RTS, adding qp->recv_err_node wou=
ld
flush all pre-posted GSI receive WRs.

Should adding the QP to cq->send_err_qp_list and cq->recv_err_qp_list also =
be
skipped for IB_QPT_GSI (or cleaned up when transitioning back to IB_QPS_RTS=
)?

[1] https://lore.kernel.org/r/20261017064413.995985-10-kotaranov@linux.micr=
osoft.com

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030130038.4040=
789-1-kotaranov@linux.microsoft.com?part=3D9
