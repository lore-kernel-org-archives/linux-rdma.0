Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793386283;
	b=yOapeRA8WKXdeKPGFwdr5USt3X++DtmBPoWYDCoJfUVsdvcvyBXv7RT0CgDrlvZkkWHz
	 6tb/W+yLQ2A7TiYg/0CGUKkfQeLl8GNI/LzY/VpJbt4cUEuC0xjXdWq0UIACRJx8kzMRP
	 6Kyn6kOvLXEPsyJ+tkxGUIh8O1ARSd6AG6e1FGlqe1VQbcyaNNPQK0wNmMIdvS8HKdwgJ
	 Djg93eRaM5RFOAYCEMSGtZMokK1jvynwr4UnxKN6H1Lq+d7UY6MHEPtyp+kXNt9c5o8Qg
	 S6bAmsxZsBMFp4+Kp8A3Z/XDfuLttF5EUf6Aggfuazpvk8QKlme4WdvcdlNJNd6B6Dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793386283;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=qrGfF40MF/uhZUi2tUgV70oxS03FOLwE41uzskojOE4=;
	b=YQYWosI5p21VegeUJ8ZOQSv8n4dSs6wvXxel7uTsRu7mXr80XEUCZ+4RT9MfHGBhCl82
	 pVzXWsnQ/+hVo9ubn9oh1LAvL1D5GUpJwfKv7j0GY/mg2261eHUGy7UHU4xXXfCzWkIKX
	 gKHmwxoWFxHknQRsaRYWzoc1ZNDEYF7NwZhMNLTEM97qVCvr3XWSbqV5I9460MMKosqEs
	 P61sjkyatQlhgV7iEsZgARb4sWMt1onyrcA77kaSrrXt712TEWC+IbmTxo6PEclOyD0h/
	 ZBx0m0+46+8eV7zA4b8WWg4686ZrIGBT7uHbX1seRBbjnRF7NY8WXJNHzBdHNXlxuhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VWVYtAJb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E518E606A32A
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 18:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VWVYtAJb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3081F00A16;
	Fri, 30 Oct 2026 18:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793386282;
	bh=qrGfF40MF/uhZUi2tUgV70oxS03FOLwE41uzskojOE4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VWVYtAJbjKeUD41JcZH2y9DI3er+ZUpf/+ZOtQ3TS9BTVvs950hdV4sJi/PwEcRmZ
	 AKxQAmJbpeZrMRNSgn3kuetrgKuWmO2NoGBs5wRditCALcfCCU6AD7kU65pEpO6lVe
	 a3kfOacNKGuaYeuGEUbAxMYQgIA7QnfuleVsdbf37FIb3DwBM344IG8dOLlQJUENmJ
	 bGK8+82twJibe2qHlGQVSGPISGKc/01NGbZgKM5G9AuXuxqyhmx9xv+cq4Pb3tN/sP
	 QP0DgNaEcfT9ZOPBLtnNXMHFmuoJe8tZB9yFKixPMcPwKBudGHEFcfBHlxEBXN8Lsd
	 6mi5iSktI4+Rg==
Message-ID: <sashiko-outbox-191416@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 1/2] RDMA/rxe: copy send WQE to kernel buffer before
 processing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tristan Madani" <tristmd@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261030183409.195671-2-tristan@talencesecurity.com>
References: <20261030183409.195671-1-tristan@talencesecurity.com>
 <20261030183409.195671-2-tristan@talencesecurity.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 18:51:21 +0000
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
- [Medium] RDMA/rxe: uninitialized skb pad leak for short atomic write in r=
eq_next_wqe()
- [Low] RDMA/rxe: build failure in rxe_requester() due to undeclared comp_w=
qe_valid
--

commit af65ad7c40a27fdf3681a52375dd72c8fe8b0691
Author: Tristan Madani <tristmd@gmail.com>

RDMA/rxe: copy send WQE to kernel buffer before processing

This commit copies send WQEs from the userspace-mapped shared send queue in=
to
a kernel-private buffer in req_next_wqe() before processing, validates the =
WR
opcode and atomic write residual length, and writes updated WQE fields back
to the shared queue.

> diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/=
rxe/rxe_req.c
> index 4f353abd76f55..ff1ec143d41f1 100644
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
> +	 * Clamp oversized resid to prevent OOB read in finish_packet().
> +	 */
> +	if (unlikely((wqe->mask & WR_ATOMIC_WRITE_MASK) &&
> +		     wqe->dma.resid > sizeof(u64)))
> +		wqe->dma.resid =3D sizeof(u64);
>  	return wqe;
>  }

[Severity: Medium]
Can an undersized wqe->dma.resid on an IB_WR_ATOMIC_WRITE WQE leak
uninitialized skb padding bytes onto the wire?

In req_next_wqe(), wqe->dma.resid is only clamped when it exceeds
sizeof(u64). If a user RC QP sets wqe->dma.resid in the mmap'd send queue
to a smaller value that is not a multiple of 4 (for example, 1..3 or 5..7),
rxe_requester() sets payload =3D wqe->dma.resid and init_req_packet() alloc=
ates
an skb with pad =3D (-payload) & 0x3 trailing bytes.

In finish_packet(), bth_pad(pkt) trailing bytes are only zeroed under
RXE_WRITE_OR_SEND_MASK, while RXE_ATOMIC_WRITE_MASK only copies payload
bytes:

	if (pkt->mask & RXE_ATOMIC_WRITE_MASK) {
		memcpy(payload_addr(pkt), wqe->dma.atomic_wr, payload);
		wqe->dma.resid -=3D payload;
	}

When rxe_xmit_packet() computes the ICRC and transmits the packet, those 1 =
to
3 uninitialized pad bytes from alloc_skb() are included in the packet. Shou=
ld
req_next_wqe() check wqe->dma.resid !=3D sizeof(u64) instead of only
wqe->dma.resid > sizeof(u64)?

[ ... ]
> @@ -702,6 +758,8 @@ int rxe_requester(struct rxe_qp *qp)
>  	if (unlikely(qp->req.need_retry && !qp->req.wait_for_rnr_timer)) {
>  		req_retry(qp);
>  		qp->req.need_retry =3D 0;
> +		qp->req.send_wqe_valid =3D false;
> +		qp->comp.comp_wqe_valid =3D false;
>  	}
> =20
>  	wqe =3D req_next_wqe(qp);

[Severity: Low]
Does building the tree at this commit fail because comp_wqe_valid is not yet
a member of struct rxe_comp_info?

In rxe_requester(), the retry block sets qp->comp.comp_wqe_valid =3D false,
but struct rxe_comp_info in drivers/infiniband/sw/rxe/rxe_verbs.h does not
define comp_wqe_valid until the next patch in the series ("RDMA/rxe: copy
send WQE to kernel buffer in completer path"):

struct rxe_comp_info {
	u32			psn;
	int			opcode;
	int			timeout;
	int			timeout_retry;
	int			started_retry;
	u32			retry_cnt;
	u32			rnr_retry;
};

Should this assignment (and the corresponding note in the commit message) be
moved to the second patch so that each commit in the series compiles cleanly
during bisection?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030183409.1956=
71-1-tristan@talencesecurity.com?part=3D1
