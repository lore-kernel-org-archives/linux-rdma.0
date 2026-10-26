Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792979021;
	b=0vA73VLdB+ByGAwWciHxFXV8JlsgsK+xiqwgbdqrcUBoLHcYjeiKESKPiDxKJEIIv7V0
	 d06Lwue9s/fu8H8yu4zhpinbEdHk1W7KvRyvZuAuYbkRc6JQNo6u3ysgjZZCD1J+3kjcz
	 G1vNHvnO5dplNaqC0nD2kw/cwMSv1IS06UwEGlSlUxolfPhyChOdyKFVwIISneX2tJ56F
	 X76FP3qui8Y6mEqYrBAa2uYvVCC4C7x2jEfVx30vBYwruRa1Tiu75IBX+4rhiD8wagpZ3
	 dyLnOXWdLGJwLaE3zJsWLmhMX34Qt7bdzka9vaZv4zcScd6L9dXpNGvs20+9409zpXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792979021;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Y8fSSJUXs47/cZtz9/dGylI/jg2mBnYBYef0O/gcIY8=;
	b=zJboV10Ib7q2GBDU/sOZALlz6yEk0kLVUMhbfJ8InEuMH/KA48EbHZCMPvGL478ZsIMt
	 LQ5unoP9cATY5SI4rwgVQ/taGrFcQlkaQoXwH74qXl+Iu5G6Fp0Qaidd81g0TIarjdh9p
	 /OOgb5iqLrom/w15t/QUQ+2JtsOu7ZWZAjydJkiSupolwATWa5BxxTata4Ok2m05ExWO9
	 gBVbNNn8i6CWPwFA+BAE9zsZO3WZWnGUrJNhnb1oKEWe8ZfsO/MdvPBJJqPfIyOqqiw6V
	 NZUL4ZrnfG0tk//rI6nJ9Q5/FTplGwJyUD2PQzD1qKFsVW30dHafFe9wSGzjtHowndw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q6+GlMJJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B8D606A31A
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 01:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q6+GlMJJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 217351F01825;
	Mon, 26 Oct 2026 01:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792979021;
	bh=Y8fSSJUXs47/cZtz9/dGylI/jg2mBnYBYef0O/gcIY8=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=Q6+GlMJJxhFT30nS2MzcqXJzZEZQjpuAcoLHoZE/LIAO3d9TzWkKBEQoPGETRip6R
	 8B3j37VUWDaRVW56rDNxODjTAMgK1nt35t5DUdNbh24zMMhy7IH9T09bBlLyqMuqW8
	 zmlkbDISR8qq9HUecyQLMPuEsAx4XAXbmHgKho+V0ryRzYeHVyaj0mJ/XwDd6PYKIY
	 imKWdiAqG24NcHa16N1SwzSw24Q6IR5aiG56ef0Eq4txgs4z3ztfYkzIjtLKKrn5Wj
	 Kn56b0y4PE5n62oa4IgADTyK46xfJXVAwL/6mz21nBV9TGp/YzEq1QD2D38x60bg1T
	 Z/Zwrp/qpHJkg==
Message-ID: <sashiko-outbox-184588@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 1/2] RDMA/rxe: copy send WQE to kernel buffer before
 processing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tristan Madani" <tristmd@gmail.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261026001405.1698455-2-tristan@talencesecurity.com>
References: <20261026001405.1698455-1-tristan@talencesecurity.com>
 <20261026001405.1698455-2-tristan@talencesecurity.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 01:43:40 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:
- [Critical] RDMA/rxe: out-of-bounds read from qp->req.send_wqe in finish_p=
acket()
- [High] RDMA/rxe: req_next_wqe() rejects IB_WR_REG_MR and wedges send queue
- [High] RDMA/rxe: field-spanning memcpy() into send_wqe.wqe in req_next_wq=
e()
- [High] RDMA/rxe: missing dma.resid writeback in rxe_req_writeback_wqe() b=
reaks IB_WR_FLUSH
- [High] RDMA/rxe: clamping num_sge in req_next_wqe() bypasses rxe_requeste=
r() check
- [High] RDMA/rxe: out-of-bounds SGE walk in req_retry() and shared state r=
ead in req_next_wqe()
--

commit cba7cc46eb582b40f6f5480cd729885e3630e9ad
Author: Tristan Madani <tristmd@gmail.com>

RDMA/rxe: copy send WQE to kernel buffer before processing

This commit copies send WQEs from the userspace-mapped send queue into a
kernel-private buffer in req_next_wqe() before processing, sanitizes opcode
and num_sge fields on the local copy, and writes updated WQE state fields
back to the shared queue.

> diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/=
rxe/rxe_req.c
> index 4f353abd76f55..9df1776ee9ad7 100644
> --- a/drivers/infiniband/sw/rxe/rxe_req.c
> +++ b/drivers/infiniband/sw/rxe/rxe_req.c
> @@ -161,6 +161,26 @@ static void req_check_sq_drain_done(struct rxe_qp *q=
p)
>  	spin_unlock_irqrestore(&qp->state_lock, flags);
>  }
> =20
> +/* Write back requester WQE fields to shared memory using targeted
> + * stores so the completer and userspace observe consistent state.
> + */
> +static void rxe_req_writeback_wqe(struct rxe_qp *qp)
> +{
> +	struct rxe_send_wqe *shared =3D qp->req.shared_wqe;
> +	struct rxe_send_wqe *local =3D &qp->req.send_wqe.wqe;
> +
> +	if (!qp->req.send_wqe_valid || !shared)
> +		return;
> +
> +	WRITE_ONCE(shared->status, local->status);
> +	WRITE_ONCE(shared->first_psn, local->first_psn);
> +	WRITE_ONCE(shared->last_psn, local->last_psn);
> +	WRITE_ONCE(shared->mask, local->mask);
> +	WRITE_ONCE(shared->has_rd_atomic, local->has_rd_atomic);
> +	/* State must be last so the completer sees prior updates */
> +	smp_store_release(&shared->state, local->state);
> +}

[Severity: High]
Should rxe_req_writeback_wqe() also write local->dma.resid back to
shared->dma.resid so that IB_WR_FLUSH requests with a non-zero flush length
can complete?

When rxe_requester() processes an IB_WR_FLUSH WQE, init_req_packet() writes
wqe->dma.resid into the RETH header and finish_packet() then zeroes
wqe->dma.resid on the local copy:

drivers/infiniband/sw/rxe/rxe_req.c:finish_packet() {
	...
	} else if (pkt->mask & RXE_FLUSH_MASK) {
		/* oA19-2: shall have no payload. */
		wqe->dma.resid =3D 0;
	}
}

Because update_state() -> rxe_req_writeback_wqe() does not write dma.resid
back to qp->req.shared_wqe, shared->dma.resid in qp->sq.queue remains at its
original non-zero length (including when the completer later copies the WQE
in commit "RDMA/rxe: copy send WQE to kernel buffer in completer path").

When the responder replies with a zero-payload
IB_OPCODE_RC_RDMA_READ_RESPONSE_ONLY packet, rxe_completer() -> do_read()
calls copy_data() with payload_size(pkt) =3D=3D 0, which returns immediately
without modifying wqe->dma.resid, and then checks:

drivers/infiniband/sw/rxe/rxe_comp.c:do_read() {
	...
	if (wqe->dma.resid =3D=3D 0 && (pkt->mask & RXE_END_MASK))
		return COMPST_COMP_ACK;

	return COMPST_UPDATE_COMP;
}

With wqe->dma.resid still non-zero in the shared queue, do_read() returns
COMPST_UPDATE_COMP instead of COMPST_COMP_ACK, leaving the IB_WR_FLUSH WQE
uncompleted and hanging the send queue.

> +
>  static struct rxe_send_wqe *__req_next_wqe(struct rxe_qp *qp)
>  {
>  	struct rxe_queue *q =3D qp->sq.queue;
> @@ -193,6 +213,29 @@ static struct rxe_send_wqe *req_next_wqe(struct rxe_=
qp *qp)
>  	}
>  	spin_unlock_irqrestore(&qp->state_lock, flags);
> =20
> +	/* Reuse the existing kernel-private copy if still valid */
> +	if (qp->req.send_wqe_valid && qp->req.shared_wqe =3D=3D wqe)
> +		return &qp->req.send_wqe.wqe;
> +
> +	/* Copy WQE from userspace-mapped shared queue to kernel-private
> +	 * buffer. Use max_inline as copy size since it covers both SGEs
> +	 * and inline data, which share the flex array.
> +	 */
> +	memcpy(&qp->req.send_wqe.wqe, wqe,
> +	       sizeof(*wqe) + qp->sq.max_inline);

[Severity: High]
Will passing &qp->req.send_wqe.wqe as the destination to memcpy() trigger a
CONFIG_FORTIFY_SOURCE field-spanning write warning whenever
qp->sq.max_inline > 0?

In struct rxe_req_info (drivers/infiniband/sw/rxe/rxe_verbs.h), send_wqe is
defined as:

	struct {
		struct rxe_send_wqe	wqe;
		struct ib_sge		sge[RXE_MAX_SGE];
	} send_wqe;

Because .wqe is the inner struct member rather than the enclosing
&qp->req.send_wqe container, __member_size(&qp->req.send_wqe.wqe) evaluates
to sizeof(struct rxe_send_wqe). For any QP with qp->sq.max_inline > 0,
sizeof(*wqe) + qp->sq.max_inline exceeds sizeof(struct rxe_send_wqe) and
spans across .wqe into .sge, triggering fortify_memcpy_chk(). Should the
destination be &qp->req.send_wqe instead, matching the receive-side copies?

> +	qp->req.shared_wqe =3D wqe;
> +	qp->req.send_wqe_valid =3D true;
> +
> +	wqe =3D &qp->req.send_wqe.wqe;

[Severity: Critical]
Can copying only sizeof(*wqe) + qp->sq.max_inline bytes into
qp->req.send_wqe cause finish_packet() to read out of bounds past
qp->req.send_wqe.sge into struct rxe_qp and adjacent kernel heap memory on =
an
IB_WR_ATOMIC_WRITE request?

For a user RC QP (qp->is_user =3D=3D true), WQEs are read directly from the
mmap'd send queue ring without going through validate_send_wr(). In
rxe_requester(), payload for RXE_ATOMIC_WRITE_MASK is taken from the
user-controlled wqe->dma.resid and capped only at mtu (up to 4096 bytes):

drivers/infiniband/sw/rxe/rxe_req.c:rxe_requester() {
	...
	mtu =3D get_mtu(qp);
	payload =3D (mask & (RXE_WRITE_OR_SEND_MASK | RXE_ATOMIC_WRITE_MASK)) ?
			wqe->dma.resid : 0;
	if (payload > mtu) {
		...
		payload =3D mtu;
	}
}

Then finish_packet() copies payload bytes directly from wqe->dma.atomic_wr
into the packet payload:

drivers/infiniband/sw/rxe/rxe_req.c:finish_packet() {
	...
	if (pkt->mask & RXE_ATOMIC_WRITE_MASK) {
		memcpy(payload_addr(pkt), wqe->dma.atomic_wr, payload);
		wqe->dma.resid -=3D payload;
	}
}

Because wqe now points to &qp->req.send_wqe.wqe inside struct rxe_qp, where
only qp->sq.max_inline bytes were copied and sge[RXE_MAX_SGE] is 512 bytes,=
 a
user WQE with wr.opcode =3D IB_WR_ATOMIC_WRITE, dma.num_sge =3D 0, and
dma.resid =3D 4096 causes finish_packet() to copy up to 3584 bytes past
qp->req.send_wqe into the transmitted network packet (or uninitialized bytes
from qp->req.send_wqe.sge when payload > qp->sq.max_inline).

> +
> +	/* Sanitize attacker-controlled fields from the copy */
> +	if (unlikely(wqe->wr.opcode > IB_WR_ATOMIC_WRITE)) {
> +		qp->req.send_wqe_valid =3D false;
> +		return NULL;
> +	}

[Severity: High]
Doesn't rejecting wqe->wr.opcode > IB_WR_ATOMIC_WRITE here break fast memory
registration (IB_WR_REG_MR) for kernel ULPs and permanently wedge the send
queue whenever an opcode above IB_WR_ATOMIC_WRITE is encountered?

In include/rdma/ib_verbs.h, IB_WR_ATOMIC_WRITE is 15 while the kernel-only
IB_WR_REG_MR opcode is 0x20 (32):

include/rdma/ib_verbs.h:enum ib_wr_opcode {
	...
	IB_WR_FLUSH =3D IB_UVERBS_WR_FLUSH,
	IB_WR_ATOMIC_WRITE =3D IB_UVERBS_WR_ATOMIC_WRITE,

	/* These are kernel only and can not be issued by userspace */
	IB_WR_REG_MR =3D 0x20,
};

Because req_next_wqe() runs for both user and kernel QPs, any IB_WR_REG_MR
WQE posted by a kernel ULP matches wqe->wr.opcode > IB_WR_ATOMIC_WRITE,
making the IB_WR_REG_MR handling in rxe_do_local_ops() -> rxe_reg_fast_mr()
unreachable.

In addition, when req_next_wqe() returns NULL on this check, rxe_requester()
takes the !wqe path:

drivers/infiniband/sw/rxe/rxe_req.c:rxe_requester() {
	...
	wqe =3D req_next_wqe(qp);
	if (unlikely(!wqe))
		goto exit;
}

That exits with -EAGAIN without setting wqe->status =3D IB_WC_LOC_QP_OP_ERR,
without advancing qp->req.wqe_index, and without calling rxe_qp_error(qp),
leaving the rejected WQE at the head of the send queue indefinitely. Note
that wr_opcode_mask() in drivers/infiniband/sw/rxe/rxe_loc.h already bounds
checks opcode < 0 || opcode > IB_WR_REG_MR and returns 0 so that
rxe_requester() fails invalid opcodes via next_opcode() -> goto err.

> +	if (wqe->dma.num_sge > qp->sq.max_sge)
> +		wqe->dma.num_sge =3D qp->sq.max_sge;

[Severity: High]
If req_next_wqe() silently clamps wqe->dma.num_sge to qp->sq.max_sge on the
local copy, doesn't that bypass the error check in rxe_requester() and allow
malformed WQEs to be processed with an unclamped num_sge in shared memory?

In rxe_requester(), commit 126c757e4cd4 ("RDMA/rxe: Validate num_sge/cur_sge
before indexing wqe->dma.sge[]") added:

drivers/infiniband/sw/rxe/rxe_req.c:rxe_requester() {
	...
	if (unlikely(wqe->dma.num_sge > qp->sq.max_sge ||
		     (wqe->dma.resid &&
		      wqe->dma.cur_sge >=3D qp->sq.max_sge))) {
		rxe_dbg_qp(qp, "invalid num_sge/cur_sge in send wqe\n");
		wqe->status =3D IB_WC_LOC_QP_OP_ERR;
		goto err;
	}
}

Because req_next_wqe() clamps wqe->dma.num_sge before returning wqe to
rxe_requester(), the wqe->dma.num_sge > qp->sq.max_sge check in
rxe_requester() becomes unreachable dead code. Instead of failing the WQE
with IB_WC_LOC_QP_OP_ERR and moving the QP to error state, rxe_requester()
transmits the WQE with a truncated SGE list and transitions shared->state to
wqe_state_processing / wqe_state_pending while shared->dma.num_sge in
qp->sq.queue remains unclamped.

> +
>  	wqe->mask =3D wr_opcode_mask(wqe->wr.opcode, qp);
>  	return wqe;
>  }

[ ... ]

> @@ -702,6 +753,7 @@ int rxe_requester(struct rxe_qp *qp)
>  	if (unlikely(qp->req.need_retry && !qp->req.wait_for_rnr_timer)) {
>  		req_retry(qp);
>  		qp->req.need_retry =3D 0;
> +		qp->req.send_wqe_valid =3D false;
>  	}

[Severity: High]
Can req_retry() still walk out of bounds past the end of qp->sq.queue->buf
when operating on the shared WQE in userspace-mapped memory?

When a retry occurs on an in-flight SEND or RDMA WRITE WQE, req_retry()
accesses the shared WQE directly via queue_addr_from_index(qp->sq.queue,
wqe_index) and calls retry_first_write_send() -> advance_dma_data(&wqe->dma,
to_send):

drivers/infiniband/sw/rxe/rxe_req.c:req_retry() {
	...
		if (first) {
			first =3D 0;

			if (mask & WR_WRITE_OR_SEND_MASK) {
				npsn =3D (qp->comp.psn - wqe->first_psn) &
					BTH_PSN_MASK;
				retry_first_write_send(qp, wqe, npsn);
			}
}

drivers/infiniband/sw/rxe/rxe_mr.c:advance_dma_data() {
	...
	while (length) {
		unsigned int bytes;

		if (offset >=3D sge->length) {
			sge++;
			dma->cur_sge++;
			offset =3D 0;
			if (dma->cur_sge >=3D dma->num_sge)
				return -ENOSPC;
		}
}

Because req_next_wqe() only clamped dma.num_sge on the local copy (preventi=
ng
rxe_requester() from failing a WQE posted with dma.num_sge > qp->sq.max_sge)
or if userspace modifies the shared WQE before a retry, wqe->dma.num_sge in
qp->sq.queue->buf is unbounded in req_retry(). If the trailing SGEs have
sge->length =3D=3D 0 (and retry_first_write_send() also ignores the -ENOSPC
return value across its npsn loop), sge++ walks past the WQE SGE array and
off the end of the vmalloc_user() send queue buffer. (The completer path had
a similar exposure prior to follow-up commit "RDMA/rxe: copy send WQE to
kernel buffer in completer path", whereas req_retry() continues to operate
directly on the shared queue.)

Also, in req_next_wqe(), the IB_QPS_SQD check reads wqe->state from the
shared userspace buffer before checking qp->req.send_wqe_valid:

drivers/infiniband/sw/rxe/rxe_req.c:req_next_wqe() {
	...
	spin_lock_irqsave(&qp->state_lock, flags);
	if (unlikely((qp_state(qp) =3D=3D IB_QPS_SQD) &&
		     (wqe->state !=3D wqe_state_processing))) {
		spin_unlock_irqrestore(&qp->state_lock, flags);
		return NULL;
	}
	spin_unlock_irqrestore(&qp->state_lock, flags);

	/* Reuse the existing kernel-private copy if still valid */
	if (qp->req.send_wqe_valid && qp->req.shared_wqe =3D=3D wqe)
		return &qp->req.send_wqe.wqe;
}

Could userspace modify wqe->state in the shared buffer to stall an
in-progress multi-packet WQE during SQD or bypass SQD by writing
wqe_state_processing to a newly posted WQE?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026001405.1698=
455-1-tristan@talencesecurity.com?part=3D1
