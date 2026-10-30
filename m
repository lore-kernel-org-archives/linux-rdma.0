Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793379871;
	b=n4knyzJl70BIeTZ8OlQUfKuoROmjHpIJ26KLtTXkPwbT7Y938gJt7P781UUSHQWLxQlZ
	 tuyimXdxJA0bVXD4JCxle2Rnp19rvZoTN9jpo5gHgR/UpIJd5fCeGYIlKz3jG+rtORQgO
	 0WmkzrCSpnH1OjRQd46Ni3L/R/PpK07VlYiLK9515rcNwKEO0ELWNM2Sp73VME4zYeMiU
	 OGkpBvoWRozXX5g0jrzCeVQixncd25F/THeMAfWJLvnUw07xS2RH5bdhQYx4uDhZhX1JY
	 gd63MovfIe+eSnJnXpCG4/MyT8Zr2uT9XXY3XDgW6WUBhlShhbUMsEz3TKOEAhs6DZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793379871;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=i12BBfNCzeSKi2Vzn7r3DkRnvb2mhk1BvDxaIaX5yE8=;
	b=dPiDu4sNY4Dr8DxWI4oOG0BFfOPL4HRTHI7ic46jtRKbUU5dJE3I7wgWUfGD7KnKupfr
	 PtD85h7w38Qb5TgUFPp767aG6/cx6UhyuIkVG5P7PWl1Yr/OI0KkFQgKVBVRHIPEjlFyl
	 FA6bR97DClyQaURT6/hPQrdTqHnjNP1H+F828DkERU7bGtbFfMY7IpLcXRGXzQJxqb6qg
	 7lA1bEekJcnscNScGwX6TFwr9Zk9HGztprRI7G8YQfcigz60/Q91nQxBJsdCHmdwvXZmr
	 xyWBdULG3+TbuDGoOsQXt3x/6o96QPpJG0lTDeS3BZuIbhsswgB8jCWVzZXy4mChVAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j+khnjw+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00E5606A31A
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 17:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j+khnjw+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE4F1F000C1;
	Fri, 30 Oct 2026 17:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793379870;
	bh=i12BBfNCzeSKi2Vzn7r3DkRnvb2mhk1BvDxaIaX5yE8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j+khnjw+Q4wrSBSDAfTtzPkKQcAVkBO20CQpMI9LjZJ7VpZ60xrksPtDkLEFWPkgc
	 0Y5re1UuTKVtiSRHqmZ26SNM+ts+/CiJ6HbQUqzZ3MTNHEQa23HynYtQmABSAJsWXD
	 VPukCS+BmtqqvzC5nc8GWalqTSwpECoOQyYI6Iytb/EtIC4bHCHVL6S7KD/Z3G8YtX
	 HLwiWlJ1On0RY/P5DpYg9LsjtLQGSk40kj1c6kXR37u9yAWMIdwT12XHrNPwzzZVe0
	 67TrAfm9KGHe4ovbAaa8BCSXNqO1OntJegkp1IYms9yEaIxsWKXyt5pVS1Gl72qzBF
	 0AgDnJEU+0FMA==
Message-ID: <sashiko-outbox-191303@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 1/2] RDMA/rxe: copy send WQE to kernel buffer before
 processing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tristan Madani" <tristmd@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261030165044.2799619-2-tristan@talencesecurity.com>
References: <20261030165044.2799619-1-tristan@talencesecurity.com>
 <20261030165044.2799619-2-tristan@talencesecurity.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 17:04:30 +0000
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
- [Critical] RDMA/rxe: broken atomic write resid check in req_next_wqe() al=
lows OOB read
--

commit c2bf5201e4676c1f9f9acad4282470fc916075a3
Author: Tristan Madani <tristmd@gmail.com>

RDMA/rxe: copy send WQE to kernel buffer before processing

This commit copies send WQEs from the userspace-mapped send queue into a
kernel-private buffer in req_next_wqe() before processing, writing updated
fields back to the shared queue via rxe_req_writeback_wqe().

> diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/=
rxe/rxe_req.c
> index 4f353abd76f55..45e0e97d17926 100644
> --- a/drivers/infiniband/sw/rxe/rxe_req.c
> +++ b/drivers/infiniband/sw/rxe/rxe_req.c
[ ... ]
> @@ -193,7 +213,35 @@ static struct rxe_send_wqe *req_next_wqe(struct rxe_=
qp *qp)
>  	}
>  	spin_unlock_irqrestore(&qp->state_lock, flags);
> =20
> -	wqe->mask =3D wr_opcode_mask(wqe->wr.opcode, qp);
> +	/* Reuse the existing kernel-private copy if still valid */
> +	if (qp->req.send_wqe_valid && qp->req.shared_wqe =3D=3D wqe)
> +		return &qp->req.send_wqe.wqe;
> +
> +	/* Copy WQE from userspace-mapped shared queue to kernel-private
> +	 * buffer. Copy size matches the queue element data area.
> +	 */
> +	memcpy(&qp->req.send_wqe, wqe, sizeof(*wqe) +
> +	       max_t(int, qp->sq.max_sge * sizeof(struct ib_sge),
> +		    qp->sq.max_inline));
> +	qp->req.shared_wqe =3D wqe;
> +	qp->req.send_wqe_valid =3D true;
> +
> +	wqe =3D &qp->req.send_wqe.wqe;
> +
> +	/* Prevent OOB in wr_opcode_mask() for corrupted opcodes.
> +	 * Mask 0 causes next_opcode() to fail, moving QP to error state.
> +	 */
> +	if (unlikely(wqe->wr.opcode > IB_WR_REG_MR))
> +		wqe->mask =3D 0;
> +	else
> +		wqe->mask =3D wr_opcode_mask(wqe->wr.opcode, qp);
> +
> +	/* Atomic writes carry exactly sizeof(u64) payload.
> +	 * Reject oversized resid to prevent OOB read in finish_packet().
> +	 */
> +	if (unlikely((wqe->mask & RXE_ATOMIC_WRITE_MASK) &&
> +		     wqe->dma.resid > sizeof(u64)))
> +		wqe->mask =3D 0;
>  	return wqe;
>  }

[Severity: Critical]
Does this atomic write resid check in req_next_wqe() in
drivers/infiniband/sw/rxe/rxe_req.c actually reject an IB_WR_ATOMIC_WRITE W=
QE
posted with wqe->dma.resid > sizeof(u64), or can finish_packet() still read
out of bounds past qp->req.send_wqe?

First, wqe->mask is populated by wr_opcode_mask(), which returns flags from
enum rxe_wr_mask (bits 0..7, where WR_ATOMIC_WRITE_MASK is BIT(7)). Testing
wqe->mask against RXE_ATOMIC_WRITE_MASK from enum rxe_hdr_mask (BIT(27))
always evaluates to false.

Second, even if wqe->mask is set to 0, rxe_requester() and next_opcode() do
not reject a WQE based on wqe->mask =3D=3D 0 when wqe->wr.opcode is
IB_WR_ATOMIC_WRITE. In rxe_requester():

	if (wqe->mask & WR_LOCAL_OP_MASK) {
		...
	}
	...
	opcode =3D next_opcode(qp, wqe, wqe->wr.opcode);
	if (unlikely(opcode < 0)) {
		wqe->status =3D IB_WC_LOC_QP_OP_ERR;
		goto err;
	}

	mask =3D rxe_opcode[opcode].mask;

next_opcode() -> next_opcode_rc() switches directly on wqe->wr.opcode witho=
ut
checking wqe->mask:

	case IB_WR_ATOMIC_WRITE:
		return IB_OPCODE_RC_ATOMIC_WRITE;

rxe_requester() then sets mask and pkt.mask from rxe_opcode[opcode].mask
(which has RXE_ATOMIC_WRITE_MASK set), clamps payload to mtu (up to 4096
bytes), and calls finish_packet():

	if (pkt->mask & RXE_ATOMIC_WRITE_MASK) {
		memcpy(payload_addr(pkt), wqe->dma.atomic_wr, payload);
		wqe->dma.resid -=3D payload;
	}

Would this read up to 4096 bytes starting at
qp->req.send_wqe.wqe.dma.atomic_wr, reading past the 512-byte
qp->req.send_wqe.sge array into adjacent memory?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030165044.2799=
619-1-tristan@talencesecurity.com?part=3D1
