Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793374514;
	b=l9BgSbijpzy8xJd1o3kuEuPvq+EgkKJk57KKSjsvjXlN6o/L/chYDFahABnoxHOl5y2R
	 2sW+rVYuCHk7BxzvVvKlmwMDCCLyFaG1OsYk4GZuRllFn7k1hcs9lmmEED5/poYRpFUC3
	 0nv/2XHxLj+odiogCQwBkFplvowiLFVgG403fu6LRGNbp71KEstJkWky5N9VpxyaPhWbF
	 o3s51D1IKE6DNLucGFWimuOvZUZ13pgssqZD+u9wmlxeDszWSGqhZROsULuvHCz5KlJKf
	 Kr2Mogk5+Xqgo/IjwlozG4hZMelfrfsCyE0mBBDVlx6OHSl/awB990JRhZGbvh3S1AA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793374514;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=NK5SI/0OA/hU6EqJT2rvdDGabiuGrRnF9pN8CqJM9wM=;
	b=ekZtCGzW+UPqDvGpXFn6QPYZbIaonXomANgROVQAHxzj0KFWF125fgvdCzzvTJ6VFHub
	 aWjpjq9R6i5HrXq+6S+qXEdYYjUp/gW+t7cqOduuQl4469A5g5WryjeHYw/OGG9pFBFw+
	 0rUp0JmMPMOlrXFaAhgdykV8V1dwj+x2kOSJjUjDfpUPYS/n1mRRpQ239otLl7+7dtmvt
	 qwHN+b9y2zSNIJcKhfLu7m3V4pEzmDHCF+Yvje9fWCiz1ga3gKIfJwu+UYPZX2sGwcJWd
	 aec0iD6XLvMrbIWPzMXJ1ZIWVhk92vZ8I00KoEP0JvR2guvpomC8Y698ddmm6LUECug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TDTcC2UM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08509606A31F
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 15:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TDTcC2UM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 681F51F000C1;
	Fri, 30 Oct 2026 15:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793374513;
	bh=NK5SI/0OA/hU6EqJT2rvdDGabiuGrRnF9pN8CqJM9wM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TDTcC2UMHVNd9gMYx+4g3TTjxWToGJSJIldX1kOcdh3x6zjr9dgZX6pDpgkAVKp8S
	 t0fEhlzx7k0VJOyJxBcHTPdI/qwi8YllG3+G1eDuhC8BZLMnTqZWVhyNs+fBiLj9Kv
	 422QmOuZM8on8EuBoMr6ZmIMnMboN49fBCFzDCqRm3P75xM2m+NYCVeH28uFxvwlfR
	 tTpmuQLY4CzB+lobJRWI5rY1roRbg46e6pK1GAhXy7eL+p+03PwFVHSGFmDfMlqLkM
	 39S9KnGSW8w08Roifw3jhN/mb02vOLUjJwrIRz33otSk5o0nXeFKA1csSsTEyW2m0d
	 UoB/ZoFTqXJ5g==
Message-ID: <sashiko-outbox-191178@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 1/2] RDMA/rxe: copy send WQE to kernel buffer before
 processing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tristan Madani" <tristmd@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261030151558.1458444-2-tristan@talencesecurity.com>
References: <20261030151558.1458444-1-tristan@talencesecurity.com>
 <20261030151558.1458444-2-tristan@talencesecurity.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 15:35:12 +0000
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
- [Critical] RDMA/rxe: out-of-bounds read from qp->req.send_wqe in finish_p=
acket()
--

commit 7ddcf04d6a32c8caa9ab909cc0cf868ac66e4fb8
Author: Tristan Madani <tristmd@gmail.com>

RDMA/rxe: copy send WQE to kernel buffer before processing

This commit copies send WQEs from the userspace-mapped send queue into a
kernel-private buffer in req_next_wqe() before processing, writing updated
status, state, and DMA progress fields back to the shared queue.

> diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/=
rxe/rxe_req.c
> index 4f353abd76f55..11c9c3259220b 100644
> --- a/drivers/infiniband/sw/rxe/rxe_req.c
> +++ b/drivers/infiniband/sw/rxe/rxe_req.c
[ ... ]
> @@ -193,7 +213,28 @@ static struct rxe_send_wqe *req_next_wqe(struct rxe_=
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

[Severity: Critical]
As reported by Sashiko on v6 [1], can redirecting wqe to qp->req.send_wqe.w=
qe
cause an out-of-bounds read from qp->req.send_wqe in finish_packet() for an
IB_WR_ATOMIC_WRITE work request?

In rxe_verbs.h, qp->req.send_wqe reserves RXE_MAX_SGE entries (512 bytes)
after wqe:

	struct {
		struct rxe_send_wqe	wqe;
		struct ib_sge		sge[RXE_MAX_SGE];
	} send_wqe;

When a user QP posts a WQE in the mmap'd send queue with wqe->wr.opcode set=
 to
IB_WR_ATOMIC_WRITE, wqe->dma.num_sge =3D 0, wqe->dma.cur_sge =3D 0, and
wqe->dma.resid =3D 4096, the num_sge and cur_sge check in rxe_requester() p=
asses
when qp->sq.max_sge >=3D 1.

rxe_requester() then computes payload from wqe->dma.resid and only caps it =
at
mtu (up to 4096 bytes):

	mtu =3D get_mtu(qp);
	payload =3D (mask & (RXE_WRITE_OR_SEND_MASK | RXE_ATOMIC_WRITE_MASK)) ?
			wqe->dma.resid : 0;
	if (payload > mtu) {
		...
		payload =3D mtu;
	}

When rxe_requester() calls finish_packet(), the RXE_ATOMIC_WRITE_MASK branch
copies payload bytes directly from wqe->dma.atomic_wr without checking that
payload is sizeof(u64) (8 bytes) or fits within the copied buffer:

	if (pkt->mask & RXE_ATOMIC_WRITE_MASK) {
		memcpy(payload_addr(pkt), wqe->dma.atomic_wr, payload);
		wqe->dma.resid -=3D payload;
	}

If payload exceeds the copied tail size, memcpy() reads uninitialized bytes
from qp->req.send_wqe.sge, and if payload exceeds 512 bytes, it reads past =
the
end of qp->req.send_wqe into the rest of struct rxe_qp and adjacent slab
memory before transmitting the packet. Should finish_packet() or
rxe_requester() validate that payload =3D=3D 8 for RXE_ATOMIC_WRITE_MASK an=
d fits
within the copied WQE data area?

[1] https://lore.kernel.org/r/20261026001405.1698455-2-tristan@talencesecur=
ity.com

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030151558.1458=
444-1-tristan@talencesecurity.com?part=3D1
