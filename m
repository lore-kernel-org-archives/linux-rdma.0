Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793380437;
	b=XSBbqEO+rbQtV7PFkFABR5vPJyvUcoNx3W9NoXKU1tGquR2A7qCe6tMPWyCnUCxAsZ03
	 0t6EJc4pwi4CLyJyysabIAw4U5X6ve8eztrng8/mt4pi4i6oKA5HnQHsDp6Wr1QfVfQfh
	 4UJ6HNMBpuJMCWS61/pvF+mudr4LPgGoS5u6YrFE25d3B56zE9Tp4Zw8gDJ+9YldryRag
	 cRMFpy/IEceoexi//Xcd/WewUq7GHyXfOVvGTBUw4UcZp9zs40+uA4YdaOHk/cxAIky5c
	 ctNTTVmTw57c7ZTjlDNSune42BULtAkXe+y+ZJps9FVEePycdt5AwBeFp9a/wWW5qtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793380437;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=eQHosl9evnh8oxhYpi04SLv11kjXoP6SfwtiliFKkT0=;
	b=5pkHxQp5sNjtzt+u2kOXLROsjG/wBtqrPfsEzPvtWN87x3KUHFiaLvPWxSM7UqXcgNO7
	 pL+f2TTgeNjTmwHz5Du4MF+wpVQM5bCkQgTBSsYudN92sbk+aeQCd9y/fSDPfhA90/K2/
	 KsGR8A2kDVzg15hUedcGcAbOQvaNsZrcE6xHqOJyLnnwG2tpcaGDv2eRJPx217jyXUoer
	 VvT+JVY8T9/bbP5YFR2FuejH9aLenCMvFbg7V6bXTHPoY9VVWBWKY4HnoEF8eUEXABTfZ
	 zgdjWvdr9pEMzwrM89O27iqq5Tl4lmCjFkDMkmSOiuOHBJzwUSM6fFBoX51bkkc1oCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dHO+mhWc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BB760A3802
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 17:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dHO+mhWc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B1B1F00A24;
	Fri, 30 Oct 2026 17:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793380436;
	bh=eQHosl9evnh8oxhYpi04SLv11kjXoP6SfwtiliFKkT0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dHO+mhWcz65hL4ZWTfKPoUVJNsRTdD63v4849vSQWQyjhehEnr5OeuxmXqMvMHOpu
	 ytDfr6ha4rg8Hpz6S8Led/iVo6o9c4epRw9q1QFLHCEIogTvhxYAWFPPGddhni5+oJ
	 WTcf3JROlc39Zlcnsg7ickp8h3/ga5KvuLwQzWe60JG/ue4Ed/gTmUS99Rgr3N5AbW
	 NffdddTAFsedG8W0v4kLPKBurvX1kN3N3DJ7of/6LL087BIFfuXJKF3/wSzOG44hBM
	 FUDlqDxoRF9OfcBOckCKvY2/vN82zckLOU7gAXDNcURR3hjAGd5iK0zA8ocn1OAnj1
	 /xjny3uG00fvw==
Message-ID: <sashiko-outbox-191314@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 2/2] RDMA/rxe: copy send WQE to kernel buffer in
 completer path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tristan Madani" <tristmd@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261030165044.2799619-3-tristan@talencesecurity.com>
References: <20261030165044.2799619-1-tristan@talencesecurity.com>
 <20261030165044.2799619-3-tristan@talencesecurity.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 17:13:55 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] RDMA/rxe: stale comp_wqe cache across RNR retry in rxe_completer()
- [High] RDMA/rxe: unvalidated shared state and status in get_wqe() hit WAR=
N_ON_ONCE
--

commit 249927ff74c8311cd6d2280c79ed9338f558aefd
Author: Tristan Madani <tristmd@gmail.com>

RDMA/rxe: copy send WQE to kernel buffer in completer path

This commit copies send WQEs from the userspace-mapped shared queue into a
completer-private buffer in get_wqe() to prevent TOCTOU races, reuses the
local copy while processing multi-packet responses, validates the opcode and
SGE fields, and writes back DMA progress on completion and retry.

> diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c b/drivers/infiniband/sw=
/rxe/rxe_comp.c
> index 1390e861bd1d7..b8bc710dc75e9 100644
> --- a/drivers/infiniband/sw/rxe/rxe_comp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_comp.c
> @@ -137,22 +137,87 @@ void rxe_comp_queue_pkt(struct rxe_qp *qp, struct s=
k_buff *skb)

[ ... ]

> +	/* Pairs with smp_store_release() in rxe_req_writeback_wqe() */
> +	state =3D smp_load_acquire(&wqe->state);
> +	if (state =3D=3D wqe_state_posted) {
> +		*wqe_p =3D NULL;
> +		return pkt ? COMPST_DONE : COMPST_EXIT;
> +	}
> +
> +	/* Reuse existing local copy if still processing same WQE
> +	 * with unchanged state (preserves DMA progress for multi-packet ops)
> +	 */
> +	if (qp->comp.comp_wqe_valid && qp->comp.shared_wqe =3D=3D wqe &&
> +	    qp->comp.comp_wqe.wqe.state =3D=3D state) {
> +		wqe =3D &qp->comp.comp_wqe.wqe;
> +		*wqe_p =3D wqe;
> +		goto check_state;
> +	}
> +
> +	/* Copy shared WQE to kernel-private buffer.
> +	 * Copy size matches the queue element data area.
> +	 */
> +	qp->comp.shared_wqe =3D wqe;
> +	memcpy(&qp->comp.comp_wqe, wqe,
> +	       sizeof(*wqe) + max_t(int,
> +				qp->sq.max_sge * sizeof(struct ib_sge),
> +				qp->sq.max_inline));
> +	qp->comp.comp_wqe_valid =3D true;
> +
> +	/* Preserve the state we observed via smp_load_acquire()
> +	 * since memcpy may have overwritten it with a stale read.
> +	 */
> +	qp->comp.comp_wqe.wqe.state =3D state;
> +
> +	/* Reject corrupted opcode or SGE indices, error the QP */
> +	if (unlikely(qp->comp.comp_wqe.wqe.wr.opcode > IB_WR_REG_MR) ||
> +	    qp->comp.comp_wqe.wqe.dma.num_sge > qp->sq.max_sge ||
> +	    (qp->comp.comp_wqe.wqe.dma.resid &&
> +	     qp->comp.comp_wqe.wqe.dma.cur_sge >=3D qp->sq.max_sge)) {
> +		qp->comp.comp_wqe.wqe.status =3D IB_WC_LOC_QP_OP_ERR;
> +		wqe =3D &qp->comp.comp_wqe.wqe;
> +		*wqe_p =3D wqe;
> +		return COMPST_ERROR;
> +	}
> +
> +	wqe =3D &qp->comp.comp_wqe.wqe;
> +	*wqe_p =3D wqe;
> =20
> +check_state:
>  	/* WQE does not require an ack */
>  	if (wqe->state =3D=3D wqe_state_done)
>  		return COMPST_COMP_WQE;

[Severity: High]
Can userspace trigger the WARN_ON_ONCE(wqe->status =3D=3D IB_WC_SUCCESS) in
rxe_completer() or force get_wqe() to overwrite qp->comp.comp_wqe mid-read?

In get_wqe() in drivers/infiniband/sw/rxe/rxe_comp.c, state is loaded from =
the
userspace-mapped shared queue and wqe (including wqe->status) is copied into
qp->comp.comp_wqe. At check_state, get_wqe() then checks:

	/* WQE caused an error */
	if (wqe->state =3D=3D wqe_state_error)
		return COMPST_ERROR;

When COMPST_ERROR runs in rxe_completer():

		case COMPST_ERROR:
			WARN_ON_ONCE(wqe->status =3D=3D IB_WC_SUCCESS);
			do_complete(qp, wqe);
			rxe_qp_error(qp);
			goto exit;

If userspace writes wqe->state =3D wqe_state_error with wqe->status =3D
IB_WC_SUCCESS in the mmap'd send queue ring (or overwrites shared->status =
=3D 0
after rxe_req_writeback_wqe() sets wqe_state_error), get_wqe() returns
COMPST_ERROR without ensuring wqe->status !=3D IB_WC_SUCCESS. This hits
WARN_ON_ONCE(wqe->status =3D=3D IB_WC_SUCCESS) in rxe_completer() and causes
do_complete() to see IB_WC_SUCCESS, skipping mandatory error CQE generation
for unsignaled WRs.

In addition, get_wqe() only reuses qp->comp.comp_wqe when
qp->comp.comp_wqe.wqe.state =3D=3D state. If userspace toggles wqe->state i=
n the
shared ring between response packets of a multi-packet RDMA READ (for examp=
le
between wqe_state_pending and wqe_state_processing), won't get_wqe() discard
the cached local copy and overwrite qp->comp.comp_wqe from untrusted shared
memory on each packet?

[ ... ]

> @@ -809,6 +878,8 @@ int rxe_completer(struct rxe_qp *qp)
>  				 * rnr timer has fired
>  				 */
>  				qp->req.wait_for_rnr_timer =3D 1;
> +				rxe_comp_writeback_wqe(qp);
> +				qp->comp.comp_wqe_valid =3D false;
>  				rxe_dbg_qp(qp, "set rnr nak timer\n");

[Severity: High]
Can qp->comp.comp_wqe become stale across an RNR retry if rxe_completer()
runs again before rnr_nak_timer fires?

In rxe_completer() in drivers/infiniband/sw/rxe/rxe_comp.c, COMPST_RNR_RETRY
sets qp->req.wait_for_rnr_timer =3D 1, writes back and invalidates
qp->comp.comp_wqe_valid, and arms qp->rnr_nak_timer, while qp->req.need_ret=
ry
remains 0 until rnr_nak_timer() fires.

However, the early exit check at the top of rxe_completer() only checks
qp->req.need_retry:

	if (qp->req.need_retry)
		goto exit;

If rxe_completer() runs again before rnr_nak_timer expires (for example on
the next iteration of rxe_sender(), or when send_task is scheduled by
rxe_post_send(), rxe_comp_queue_pkt(), or rxe_skb_tx_dtor()), it enters
COMPST_GET_WQE -> get_wqe(). Because req_retry() has not run yet, the shared
WQE still has state =3D=3D wqe_state_pending (or wqe_state_processing), so
get_wqe() copies the pre-retry WQE (with its old first_psn and last_psn) ba=
ck
into qp->comp.comp_wqe and sets qp->comp.comp_wqe_valid =3D true.

When rnr_nak_timer() later fires, rxe_requester() in
drivers/infiniband/sw/rxe/rxe_req.c runs:

	if (unlikely(qp->req.need_retry && !qp->req.wait_for_rnr_timer)) {
		req_retry(qp);
		qp->req.need_retry =3D 0;
		qp->req.send_wqe_valid =3D false;
	}

This does not clear qp->comp.comp_wqe_valid, and rxe_requester() immediately
retransmits the WQE with updated PSN bounds and sets shared->state back to
wqe_state_pending. When the retried response arrives, get_wqe() sees
qp->comp.comp_wqe_valid =3D=3D true, qp->comp.shared_wqe =3D=3D wqe, and
qp->comp.comp_wqe.wqe.state =3D=3D state (both wqe_state_pending), so it re=
uses
the stale pre-retry comp_wqe. For a partially completed multi-packet RDMA
READ where first_psn advanced on retry, won't check_ack() compare pkt->psn
against the stale wqe->first_psn and transition the QP to COMPST_ERROR?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030165044.2799=
619-1-tristan@talencesecurity.com?part=3D2
