Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793706181;
	b=UK03N0YiKBUiSJ4Pp8WY6MOSEH8cXExtvwPuxO7qA5nUn1M4B7TaHZM6zurSHIujC9XW
	 0iURX/WCvbdMoXacfeUYpYoVr9NeG8NUeAaQi3m4M2378YJe0jZd5uWTPf+VjijlwhQbD
	 z6TJ9atFgpodj+GE6je7DUb9wJy9weCoiETvnMmwrJBLmNNQox0y/7lSw+GBdlPyYN1iY
	 RxARiIkbr+G61XtaGv/HYBPQmYmnhPDc08CmK1VUuei6yewuJQBufwfg0tuJAu01sRwFE
	 a/l9WxpjFGVFS8vyhQfhUc7LhYPTOMRvHBkctIZBDemy2d6dNhfOxwqRGYAlQQn/tVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793706181;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=BdgKMI/foV8vOYerI0Xy9aiATnZvVdLVnLAk8HR1TE4=;
	b=M4aqwh0PfkOik9/qbRUIozO33ch8etL/4kcYx5PQbttMJTIsjTxGlJOGj9DFr0pjrN3u
	 O2X54vNdS2w5nyxbqmiQh8jnUfE14J1fOwnwS65lcJ6xyI2AG7/Hj+5EMECqMm2fkKYtt
	 6H0PPTdWvAtCgOC5FX1x+PrkMZ770No1pbk4l9sTeomIR4wnJEj+9oQRUrTKNQzzO/qTv
	 vBiz/+XQ5VB3d9snMf9OZT2yiAP5JlYrJrbrqskOPsETyDnVSl5cQelAN36B8YLmYXoWw
	 dbm5f3KF+A5u6YmMHt+2+e0iTXvMOAza3JyCVaahn1bNfk7/nrUWdu25yzIK6mbP8FQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="nKr3/rpV";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00033606EEBA
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 11:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nKr3/rpV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4931F000C1;
	Tue,  3 Nov 2026 11:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793706180;
	bh=BdgKMI/foV8vOYerI0Xy9aiATnZvVdLVnLAk8HR1TE4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nKr3/rpVBIvXXY4VJ06TipdUodFKrL48e51hqbpn/yyShfRbif1IqbuFPMlGcp9Hp
	 zVSEPpBj/AwoXLXrtJ5sCzbBHHGLIYvAjKCi5Eb12TM1KBRr/loOacYvsc8SKIq8tc
	 gbvg+FGjx3ael3C3jhK2rPvdY0Hu3IaRbnkyTnYZdZ7b2aq/aTZLQb7kBxQKy8aeip
	 wAJbX9joXwJYEM7L+bERdytSkq5GAHDgA2iPFKirVJbZUGyL+Jr+RIoM3YwdmrUv4H
	 u0kZOCon98wTEhNe9iR+RmtLVgZ16evvm2gtbO34VYFrI3guhtK6Hn+sxZZ5yyMKRW
	 84ha4IyLqUGCw==
Message-ID: <sashiko-outbox-195171@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v8 7/9] RDMA/mana_ib: Poll RC completions
 using PSN and FSN progress
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103111729.729886-8-kotaranov@linux.microsoft.com>
References: <20261103111729.729886-1-kotaranov@linux.microsoft.com>
 <20261103111729.729886-8-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 11:42:59 +0000
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
- [High] RDMA/mana_ib: early budget return on unsignaled WQEs in mana_advan=
ce_send()
--

commit 9f65c018972a66e7f324e13ff6cdbb436c550724
Author: Konstantin Taranov <kotaranov@microsoft.com>

RDMA/mana_ib: Poll RC completions using PSN and FSN progress

This commit adds RC completion polling for receive completions, armed-PSN
notifications, and MMQ completions, retiring requester and MMQ shadow
entries using sequence numbers while honoring fence dependencies and
rearming the next signal PSN on armed completions.

> diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana=
/cq.c
> index 843e2c64b32bc..cd77e305c38f9 100644
> --- a/drivers/infiniband/hw/mana/cq.c
> +++ b/drivers/infiniband/hw/mana/cq.c

[ ... ]

> @@ -390,17 +425,105 @@ static void handle_rq_cqe(struct mana_ib_qp *qp, s=
truct gdma_comp *cqe,
>  	shadow_queue_advance_consumer(&qp->shadow_rq);
>  }
> =20
> +/*
> + * A fenced WQE can acknowledge the other send queue. Retire those depen=
dencies
> + * first, without losing the fence when the caller's WC array fills up.
> + */
> +static bool mana_advance_send(struct mana_ib_qp *qp, bool mmq, u32 seq,
> +			      struct mana_cq_poll *poll)
> +{
> +	struct shadow_queue *shadow =3D mmq ? &qp->shadow_mmq : &qp->shadow_sq;
> +	struct shadow_queue *other =3D mmq ? &qp->shadow_sq : &qp->shadow_mmq;
> +	struct shadow_wqe_header *shadow_wqe;
> +
> +	while ((shadow_wqe =3D shadow_queue_get_next_to_consume(shadow))) {
> +		if (PSN_LT(seq, mmq ? shadow_wqe->fsn : shadow_wqe->wqe_offset_or_psn))
> +			break;
> +		if (poll->produced =3D=3D poll->budget)
> +			return false;
> +		if (shadow_wqe->flags & MANA_WQ_FENCE_WC) {
> +			u32 dependency =3D mmq ? shadow_wqe->wqe_offset_or_psn : shadow_wqe->=
fsn;
> +			struct shadow_wqe_header *other_wqe;
> +
> +			while ((other_wqe =3D shadow_queue_get_next_to_consume(other))) {
> +				if (PSN_LT(dependency, mmq ? other_wqe->wqe_offset_or_psn :
> +							     other_wqe->fsn))
> +					break;
> +				mana_complete_send(qp, !mmq, poll, VENDOR_ERR_OK);
> +				if (poll->produced =3D=3D poll->budget)
> +					return false;
> +			}
> +		}
> +
> +		mana_complete_send(qp, mmq, poll, VENDOR_ERR_OK);
> +	}
> +
> +	return true;
> +}
> +
> +static bool handle_mmq_cqe(struct mana_ib_qp *qp, u32 fsn,
> +			   struct mana_cq_poll *poll)
> +{
> +	return mana_advance_send(qp, true, fsn, poll);
> +}
> +
> +static bool handle_psn_cqe(struct mana_ib_qp *qp, u32 psn,
> +			   struct mana_cq_poll *poll)
> +{
> +	struct mana_ib_dev *mdev =3D container_of(qp->ibqp.device, struct mana_=
ib_dev, ib_dev);
> +	struct shadow_wqe_header *shadow_wqe;
> +	struct gdma_queue *recv_q;
> +	bool consumed;
> +	u32 arm_psn;
> +
> +	if (qp->ibqp.qp_type !=3D IB_QPT_RC)
> +		return true;
> +
> +	recv_q =3D qp->rc_qp.queues[MANA_RC_RECV_QUEUE_REQUESTER].kmem;
> +
> +	consumed =3D mana_advance_send(qp, false, psn, poll);
> +	if (consumed) {
> +		shadow_wqe =3D shadow_queue_get_next_to_signal(&qp->shadow_sq);
> +		arm_psn =3D shadow_wqe ? shadow_wqe->wqe_offset_or_psn : psn + 1;
> +		arm_psn &=3D MANA_WQE_OFFSET_MASK;
> +		mana_gd_wq_ring_doorbell_ext(mdev_to_gc(mdev), recv_q, arm_psn,
> +					     SET_ARM_BIT, MANA_PSN_CLIENT_OFFSET);
> +	}
> +
> +	return consumed;
> +}

[Severity: High]
Can mana_advance_send() return false when only unsignaled WQEs remain to be
retired, causing handle_psn_cqe() to skip rearming the requester PSN
doorbell?

In mana_complete_send(), when vendor_error is VENDOR_ERR_OK, mana_fill_wc()
is only called when MANA_WQ_NO_SIGNAL_WC is not set:

	if (vendor_error || !(wqe->flags & MANA_WQ_NO_SIGNAL_WC))
		mana_fill_wc(qp, poll, wqe, wqe->send_opcode, vendor_error);

Unsignaled WQEs do not consume an entry in poll->wc or increment
poll->produced.

However, mana_advance_send() checks poll->produced =3D=3D poll->budget
unconditionally at the start of the outer loop before checking whether
shadow_wqe has MANA_WQ_NO_SIGNAL_WC set, and again at the end of the inner
fence loop right after mana_complete_send(qp, !mmq, poll, VENDOR_ERR_OK).

If a caller posts a signaled WR followed by an unsignaled WR that is
acknowledged by the same CQE (for example, a signaled IB_WR_REG_MR on MMQ
followed by a fenced unsignaled SQ WR, or a signaled SQ WR followed by an
unsignaled SQ WR covered by the same CQE_TYPE_ARMED_CMPL) and polls with
budget equal to the number of signaled WRs, completing the signaled WR
brings poll->produced to poll->budget. Before retiring the remaining
acknowledged unsignaled WQE, mana_advance_send() sees poll->produced =3D=3D
poll->budget and returns false.

When that happens via mana_handle_cqe() -> handle_psn_cqe(), consumed is
false, so handle_psn_cqe() skips calling mana_gd_wq_ring_doorbell_ext() on
recv_q and leaves cq->has_pending_cqe set even though no signaled WCs remain
for that CQE. If the caller waits for completions of subsequent signaled WRs
before polling again, hardware will not generate another CQE_TYPE_ARMED_CMPL
and the RC send queue can stall.

Should mana_advance_send() only check poll->produced =3D=3D poll->budget wh=
en the
next WQE to be completed does not have MANA_WQ_NO_SIGNAL_WC set?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103111729.7298=
86-1-kotaranov@linux.microsoft.com?part=3D7
