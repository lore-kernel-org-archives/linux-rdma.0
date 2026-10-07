Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157613ACA49
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 15:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791388121; cv=none; b=oD4tsFQzpOampSQwFovp66ujix7uXWtL6bFVqJGbHdVXR8fLkz1PNqHDkEeiEoZK2riLsF0zkzmvCtJNnjwBRBpyEgvSDfY+2VtW7ssyC+KRdDpYO3LDdjFTD1aNnHw/CJ25Y2ykAn4/NBmJ3F1hjpnNpCgiVXitVSKIkKBnQaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791388121; c=relaxed/simple;
	bh=jUC8qrQ82tGD2xq9j+P8wKeQx8GegMzLtKHvTk3PerM=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=hl3LnSkrIzArdM86q7GQDft5waZ6eehcgn7CIyVWMuGuJUvNHWzxg4kBJZSd4IWGGhOE7hMViYkZPx9kN3EvYaSw+2b4EkPVG/nXZecaqXrs5FGoZuDX/9PrcnRyK/beUDyqc0dcwkcwM2z3bjbHizUxvEkvH0NmZuKkmYPxQVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BJgBAvbW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BJgBAvbW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5AC1F000FF;
	Wed,  7 Oct 2026 15:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791388118;
	bh=PNgDNkvoWOttZWPeAql72e2Jh8Jy+tyYDf1UaCYNWVI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BJgBAvbWyBNcIgBAUXtGOwrGKlHc6VCuczqu2fH4DG41yUnAAXFseoalIEY16kIbm
	 rcfZ11+JFC8JvVlKadxr2jDe/IhuUE5DCVz20wdns0eLEaMBykBxjXP1wjE4ek+Lao
	 +gYaRvsESrGNGQvMLbxc4ZBqYMjhko4hZB5qaxKHv1Q49GSAbbJWTSyWe0WjoAzd0+
	 sCyu+spZHqKSPJ7bhsS1h8LeHXGKwmVLv2ObQEzStVnyJDZRQHfCXaIcvlg2WdEwO0
	 ri1gbf5kne8Wz+1KBCS08JksZgj3NaWgbXvekINlXs37Z/od0N31FL3tcB2g4Yip4e
	 iT2h43w77MzDQ==
Message-ID: <sashiko-outbox-163163@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v3 07/10] RDMA/mana_ib: Poll RC completions
 using PSN and FSN progress
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261007153330.2979799-8-kotaranov@linux.microsoft.com>
References: <20261007153330.2979799-1-kotaranov@linux.microsoft.com>
 <20261007153330.2979799-8-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 15:48:38 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] rdma/mana_ib: RC SQ queue->tail stalls due to missing wqe_size_in_=
bu initialization
- [High] rdma/mana_ib: mana_ib_arm_cq returns 0 when has_pending_cqe is tru=
e, missing events
--

commit e4f126a1330a4d8df81cbe90bf16cac4e71247c6
Author: Konstantin Taranov <kotaranov@microsoft.com>

RDMA/mana_ib: Poll RC completions using PSN and FSN progress

This commit decodes RC receive completions, armed-PSN notifications, and MMQ
completions. It retires requester and MMQ shadow entries using their
sequence numbers, honors cross-queue fence dependencies, and suppresses
successful WCs for unsignaled work requests.

> diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana=
/cq.c
> --- a/drivers/infiniband/hw/mana/cq.c
> +++ b/drivers/infiniband/hw/mana/cq.c

[ ... ]

> @@ -324,8 +330,19 @@ static void mana_complete_send(struct mana_ib_qp *qp,
>  	if (vendor_error || !(wqe->flags & MANA_WQ_NO_SIGNAL_WC))
>  		mana_fill_wc(qp, poll, wqe, wqe->send_opcode, vendor_error);
> =20
> -	queue =3D mana_qp_get_sq(qp)->kmem;
> -	queue->tail +=3D wqe->wqe_size_in_bu;
> +	if (mmq) {
> +		queue =3D qp->rc_qp.queues[MANA_RC_SEND_QUEUE_MMQ].kmem;
> +		queue->tail +=3D wqe->wqe_size_in_bu;
> +	} else {
> +		queue =3D mana_qp_get_sq(qp)->kmem;
> +		if (wqe->send_opcode =3D=3D IB_WC_RDMA_READ) {
> +			qp->rc_qp.queues[MANA_RC_RECV_QUEUE_REQUESTER].kmem->tail +=3D
> +				wqe->wqe_size_in_bu;
> +			queue->tail +=3D qp->rc_qp.wqe_size_in_bu;
> +		} else {
> +			queue->tail +=3D wqe->wqe_size_in_bu;

[Severity: High]
For RC Send and Write shadow WQEs, wqe_size_in_bu is left as 0 during
posting. When adding it to the queue tail here in mana_complete_send(),
could this stall space accounting because queue->tail won't advance?

This could eventually cause mana_gd_wq_avail_space() to calculate incorrect
available space, permanently hanging the RC send queue under standard
SEND/WRITE traffic.

> +		}
> +	}
>  	shadow_queue_advance_consumer(shadow);
>  }

[ ... ]

> @@ -390,17 +422,105 @@ static void handle_rq_cqe(struct mana_ib_qp *qp, s=
truct gdma_comp *cqe,

[ ... ]

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

[Severity: High]
Returning false here when poll->produced =3D=3D poll->budget causes a hardw=
are
CQE to be cached in software by setting cq->has_pending_cqe to true.

If an application subsequently calls ib_req_notify_cq() with
IB_CQ_REPORT_MISSED_EVENTS, wouldn't the driver return 0 because it misses
checking this software-cached CQE?

This could cause standard RDMA ULPs to hang permanently waiting for an
interrupt, as the CQ is falsely reported as empty.

> +		if (shadow_wqe->flags & MANA_WQ_FENCE_WC) {
> +			u32 dependency =3D mmq ? shadow_wqe->wqe_offset_or_psn : shadow_wqe->=
fsn;
> +			struct shadow_wqe_header *other_wqe;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007153330.2979=
799-1-kotaranov@linux.microsoft.com?part=3D7
