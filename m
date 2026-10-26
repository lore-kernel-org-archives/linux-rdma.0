Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792978758;
	b=4kcetripm9Gnqg69AC0MyxEp/1Gk+d6oFaBZ/NEXZMUuscGA/v9r0PeXOemroaBEmNYc
	 KPHFlt955XE/7MhZqDhhNT8UHkza3e1gw8JoOF7ukR4eN2/ldIKOStCJ3LB86mfwJ+ZEl
	 cyOWmYY5K/xexHp199smdBKtPxRZTi/Pm4SvWjR9aOPKDKGUzl7JkogmHt/SR/R3Mf9sa
	 L3af/w89HTBr266kHcPth2NPo37/LfxBfPz2Pp//F3JpinojmyF/hOggj0SsjR5hmZj2s
	 Vt+MgWw2ucJpSeT7kApeKVEpev1FKqxJnyOigGNwzIJrKFvPOGUTum2tYazO5j+5Dxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792978758;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=mVslZ/Q/is1aLTlwJ+dtrXXyj4lChGTmZusMdhAwZgc=;
	b=hl2d9qtTeO+9BregrYOP9DBgMlZdXNICotrULAjQurCvBpEeLvo3zdRyPIJoapxkp9N7
	 vgf88v545yC5MoaujpT8TjQIf65YLmNE8MYkwt9SfWrz75z8lmez0v6cYdiBZNFr9JIoP
	 SIkj+6OJD/BdF/iQcEaFj0B+0VoMJvznvi+oSbByZlwmSKUTb7Kd+dQAFdVHfa7DpcyI6
	 /iEgZ2TJWPtFNxDhQccvY09+iufbhr6wP3qQIM3M4GNz1TmcBY56w30qA4EZJ2yU1bLMt
	 dNzl2tX19RQs9D1z2mWU0+DTyz74FIcM/iKlrvKLvW8Ms3wTs4LdX1hH//WPNIOm0Fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mu0Pz+W+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84983606A31A
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 01:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mu0Pz+W+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 164FE1F01825;
	Mon, 26 Oct 2026 01:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792978758;
	bh=mVslZ/Q/is1aLTlwJ+dtrXXyj4lChGTmZusMdhAwZgc=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=mu0Pz+W+BJjRjkWZQeShmMFwwPukOiXF48foL2lqL9IByos6zg5ZwZGKPd94H5OGj
	 PTqe+R2D9+G0e1QoYMwRWvwylug/rFhzu7Qh8BnbhEltrmDo3LxmlqxaFt00aqMY6I
	 r1xk0IPef4UUQKeKi6nYxNC/NzodVqLfw0lhUd1HNQinsfUV0bV3iuljZFCQ6UIWW0
	 SOAL0LHEU0fFSKj2TeIGtotpsif0YR9tVDDHbcrqMLbV4s9ufgFPFPry77dVz6WYIb
	 YINnVQ/cDnSY1sA8uDrXAhij7DPSk4+w/I00OmuDOfv6j1jhsxfmxgyrNsPotqsAsR
	 stpuTdvULI86w==
Message-ID: <sashiko-outbox-184584@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 2/2] RDMA/rxe: copy send WQE to kernel buffer in
 completer path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tristan Madani" <tristmd@gmail.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261026001405.1698455-3-tristan@talencesecurity.com>
References: <20261026001405.1698455-1-tristan@talencesecurity.com>
 <20261026001405.1698455-3-tristan@talencesecurity.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 01:39:17 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [Critical] RDMA/rxe: missing dma.cur_sge bounds check in get_wqe() allows=
 OOB read
- [High] RDMA/rxe: wrong opcode bound in get_wqe() breaks IB_WR_REG_MR and =
wedges SQ
- [High] RDMA/rxe: stale comp_wqe and unshared DMA state in get_wqe() break=
 READ retry
- [High] RDMA/rxe: TOCTOU races on wqe->state and shared wqe pointer in get=
_wqe()
- [High] RDMA/rxe: field-spanning memcpy() in get_wqe() triggers FORTIFY_SO=
URCE warn
--

commit 85eed619ea208c64c4708d3eee07f43c50d2a7e2
Author: Tristan Madani <tristmd@gmail.com>

RDMA/rxe: copy send WQE to kernel buffer in completer path

This commit copies send WQEs from the shared queue to a completer-private
kernel buffer in get_wqe() and sanitizes fields before processing
completions. It also writes back completion status and rd_atomic state
before advancing the consumer index.

> diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c b/drivers/infiniband/sw=
/rxe/rxe_comp.c
> index 1390e861bd1d7..6e72cfeb10ec8 100644
> --- a/drivers/infiniband/sw/rxe/rxe_comp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_comp.c
> @@ -137,22 +137,76 @@ void rxe_comp_queue_pkt(struct rxe_qp *qp, struct s=
k_buff *skb)
>  	rxe_sched_task(&qp->send_task);
>  }
> =20
> +/* Write back completer WQE fields to shared memory */
> +static void rxe_comp_writeback_wqe(struct rxe_qp *qp)
> +{
> +	struct rxe_send_wqe *shared =3D qp->comp.shared_wqe;
> +	struct rxe_send_wqe *local =3D &qp->comp.comp_wqe.wqe;
> +
> +	if (!qp->comp.comp_wqe_valid || !shared)
> +		return;
> +
> +	WRITE_ONCE(shared->status, local->status);
> +	WRITE_ONCE(shared->has_rd_atomic, local->has_rd_atomic);
> +}
> +
>  static inline enum comp_state get_wqe(struct rxe_qp *qp,
>  				      struct rxe_pkt_info *pkt,
>  				      struct rxe_send_wqe **wqe_p)
>  {
>  	struct rxe_send_wqe *wqe;
> +	u32 state;
> =20
>  	/* we come here whether or not we found a response packet to see if
>  	 * there are any posted WQEs
>  	 */
>  	wqe =3D queue_head(qp->sq.queue, QUEUE_TYPE_FROM_CLIENT);
> -	*wqe_p =3D wqe;
> =20
>  	/* no WQE or requester has not started it yet */
> -	if (!wqe || wqe->state =3D=3D wqe_state_posted)
> +	if (!wqe) {
> +		*wqe_p =3D NULL;
> +		return pkt ? COMPST_DONE : COMPST_EXIT;
> +	}
> +
> +	/* Pairs with smp_store_release() in rxe_req_writeback_wqe() */
> +	state =3D smp_load_acquire(&wqe->state);
> +	if (state =3D=3D wqe_state_posted) {
> +		*wqe_p =3D wqe;
>  		return pkt ? COMPST_DONE : COMPST_EXIT;
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

[Severity: High]
How does this reuse check interact with retries of partially completed
multi-packet RDMA READs?

During a multi-packet RDMA READ response, do_read() calls copy_data() on
&wqe->dma, which updates dma.resid, dma.cur_sge, and dma.sge_offset only in
qp->comp.comp_wqe.wqe. Because rxe_comp_writeback_wqe() only writes back
status and has_rd_atomic inside do_complete(), qp->comp.shared_wqe->dma in
qp->sq.queue is never updated as packets arrive.

If a timeout or NAK triggers a retry, req_retry() in
drivers/infiniband/sw/rxe/rxe_req.c reads wqe->dma.resid from the shared WQE
in qp->sq.queue:

	if (mask & WR_READ_MASK) {
		npsn =3D (wqe->dma.length - wqe->dma.resid) /
			qp->mtu;
		wqe->iova +=3D npsn * qp->mtu;
	}

Since shared_wqe->dma.resid was never decremented, npsn is 0, wqe->iova is
not advanced, and rxe_requester() re-requests the entire read from offset 0
with new first_psn and last_psn values while setting shared_wqe->state back
to wqe_state_pending.

In addition, qp->comp.comp_wqe_valid is not invalidated on retry. When the
retried read response arrives, get_wqe() sees:

	qp->comp.comp_wqe_valid && qp->comp.shared_wqe =3D=3D wqe &&
	qp->comp.comp_wqe.wqe.state =3D=3D state

(both wqe_state_pending) and reuses the pre-retry qp->comp.comp_wqe.wqe with
the stale first_psn and last_psn. Doesn't check_ack() then fail the PSN
comparison against wqe->first_psn and return COMPST_ERROR, moving the QP to
IB_QPS_ERR?

> +
> +	/* Copy shared WQE to kernel-private buffer. Use max_inline
> +	 * as copy size since it covers both SGEs and inline data,
> +	 * which share the flex array.
> +	 */
> +	qp->comp.shared_wqe =3D wqe;
> +	memcpy(&qp->comp.comp_wqe.wqe, wqe,
> +	       sizeof(*wqe) + qp->sq.max_inline);
> +	qp->comp.comp_wqe_valid =3D true;

[Severity: High]
Are there remaining TOCTOU windows on wqe->state and the shared wqe pointer
in get_wqe()?

1. When state =3D=3D wqe_state_posted above, get_wqe() sets *wqe_p =3D wqe
(pointing directly to the uncopied, unsanitized shared queue element) and
returns COMPST_EXIT when pkt is NULL. In rxe_completer():

	case COMPST_EXIT:
		if (qp->comp.timeout_retry && wqe) {
			state =3D COMPST_ERROR_RETRY;
			break;
		}
		...
	case COMPST_ERROR_RETRY:
		/* there is nothing to retry in this case */
		if (!wqe || (wqe->state =3D=3D wqe_state_posted))
			goto exit;

If wqe->state in shared memory changes after get_wqe() read it (for example,
via concurrent userspace modification of the mmap'd send queue) and
qp->comp.retry_cnt =3D=3D 0, COMPST_ERROR_RETRY transitions to COMPST_ERROR=
 and
calls do_complete(qp, wqe) directly on the uncopied shared WQE. Should
*wqe_p be set to NULL when state =3D=3D wqe_state_posted?

2. When state !=3D wqe_state_posted, memcpy() overwrites
qp->comp.comp_wqe.wqe.state with a second read from shared memory rather
than preserving the local state variable loaded via smp_load_acquire(). If
userspace mutates wqe->state in shared memory between smp_load_acquire() and
memcpy(), check_state can observe wqe_state_posted or wqe_state_error (with
wqe->status =3D=3D IB_WC_SUCCESS, triggering WARN_ON_ONCE in COMPST_ERROR).=
 Also,
across multi-packet responses, userspace can flip shared_wqe->state in the
mmap'd ring to make qp->comp.comp_wqe.wqe.state =3D=3D state false and force
get_wqe() to overwrite comp_wqe mid-operation.

[Severity: High]
Also, in struct rxe_comp_info in drivers/infiniband/sw/rxe/rxe_verbs.h,
comp_wqe is defined as:

	struct {
		struct rxe_send_wqe	wqe;
		struct ib_sge		sge[RXE_MAX_SGE];
	} comp_wqe;

Because memcpy() here (and in req_next_wqe() in
drivers/infiniband/sw/rxe/rxe_req.c from the previous patch) passes the inn=
er
member &qp->comp.comp_wqe.wqe instead of the outer struct &qp->comp.comp_wq=
e,
__member_size(&qp->comp.comp_wqe.wqe) is sizeof(struct rxe_send_wqe). Will
copying sizeof(*wqe) + qp->sq.max_inline bytes trigger a
CONFIG_FORTIFY_SOURCE field-spanning write warning whenever
qp->sq.max_inline > 0?

> +
> +	/* Sanitize attacker-controlled fields from the copy */
> +	if (unlikely(qp->comp.comp_wqe.wqe.wr.opcode > IB_WR_ATOMIC_WRITE)) {
> +		qp->comp.comp_wqe_valid =3D false;
> +		*wqe_p =3D NULL;
> +		return pkt ? COMPST_DONE : COMPST_EXIT;
> +	}

[Severity: High]
Won't checking wr.opcode > IB_WR_ATOMIC_WRITE reject kernel-issued
IB_WR_REG_MR work requests and wedge the send queue?

In include/rdma/ib_verbs.h, enum ib_wr_opcode defines:

	IB_WR_FLUSH =3D IB_UVERBS_WR_FLUSH,
	IB_WR_ATOMIC_WRITE =3D IB_UVERBS_WR_ATOMIC_WRITE,

	/* These are kernel only and can not be issued by userspace */
	IB_WR_REG_MR =3D 0x20,

IB_WR_ATOMIC_WRITE is 15, while IB_WR_REG_MR is 0x20 (32), which is why
wr_opcode_mask() in drivers/infiniband/sw/rxe/rxe_loc.h checks
opcode > IB_WR_REG_MR and wr_to_wc_opcode() in
drivers/infiniband/sw/rxe/rxe_comp.c handles IB_WR_REG_MR. Checking
wr.opcode > IB_WR_ATOMIC_WRITE here (as well as in req_next_wqe() in
drivers/infiniband/sw/rxe/rxe_req.c) rejects every IB_WR_REG_MR WQE posted =
by
kernel ULPs.

Furthermore, when this check triggers in get_wqe(), it sets *wqe_p =3D NULL=
 and
returns COMPST_DONE or COMPST_EXIT without advancing the SQ consumer index =
or
transitioning to COMPST_ERROR. Because the WQE remains at the head of
qp->sq.queue forever (and COMPST_EXIT sees wqe =3D=3D NULL, skipping
COMPST_ERROR_RETRY and calling reset_retry_timer(qp)), doesn't this
permanently wedge the send queue and re-arm retrans_timer in an infinite lo=
op?

> +	if (qp->comp.comp_wqe.wqe.dma.num_sge > qp->sq.max_sge)
> +		qp->comp.comp_wqe.wqe.dma.num_sge =3D qp->sq.max_sge;

[Severity: Critical]
Does get_wqe() also need to validate dma.cur_sge from the copied WQE?

In a user QP, shared_wqe->dma.cur_sge resides in the userspace-mapped send
queue buffer and can be modified by userspace before get_wqe() copies the W=
QE.
While dma.num_sge is clamped to qp->sq.max_sge here, dma.cur_sge is left
unchecked. When an RDMA READ or ATOMIC response arrives, do_read() or
do_atomic() passes &wqe->dma to copy_data() in
drivers/infiniband/sw/rxe/rxe_mr.c:

	struct rxe_sge		*sge	=3D &dma->sge[dma->cur_sge];
	u32			offset	=3D dma->sge_offset;
	u32			resid	=3D dma->resid;
	...
	if (sge->length && (offset < sge->length)) {
		mr =3D lookup_mr(pd, access, sge->lkey, RXE_LOOKUP_LOCAL);

Can an out-of-bounds dma.cur_sge index past qp->comp.comp_wqe.sge[RXE_MAX_S=
GE]
and read arbitrary kernel memory in copy_data()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026001405.1698=
455-1-tristan@talencesecurity.com?part=3D2
