Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF7F36F41C
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 22:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791413234; cv=none; b=lnTEt2kTCC6NXR9/l8e5tokJQMSB4y3UUA5/cJvrXLAMe5e+yYXEOSHgyGJuRIEmSTIdmsDi/ME20MXO5Q7OM1KqaUnUi1YPO906PmA/n9kiL33klM1M/nh8JIraCE9Tympp9t+KMWg91toR0gkGiV//HHRL0tTU52Vu89phjsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791413234; c=relaxed/simple;
	bh=EPKoXPnR6W6SNdpWqO8rPeIIGeHCEi05zHIAPk1wnCk=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Q3y2JbXuq0A/JvlP3zBJ5MJyDcm9VN7r5hcMiRE/EsH6XmSgzBSTvcl76vm4CtAXenaQmAm6O+d7G46XgA/D3PE2brTCi+UQET3J4haW29BhNLEGHrFdNBnLcRDiPvGCJSN9T3nrzIKxm0jWKlGu/hcM8ZQlgbGC3yxIsyePrkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jqXBavH2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jqXBavH2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C53801F000FF;
	Wed,  7 Oct 2026 22:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791413233;
	bh=tAttWHs9FqC3BNXfXXCphwMJJzDpRb94by/qeDN6hqc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jqXBavH2a+qcFIWWygzS3acSDLzA7pzDZr2Op7Bt46VSNYctcPOTd4zyxONJ217iC
	 LVxwYmQsdAzpDl8f1CcXM8rGx43xGYGrMHQup77bHmllPZUdRgJrRzRoquaC83355l
	 yd14UOnobCXC7od++5bXLoJ/3NBK0RkZR1aSbuOG+MlMxvBiqgFlS9cAH7nW7m/7RE
	 qn+6pKt3ATHkrHdsrSneZw71LwiOe9I+WLTotEpig2UGQsWNbS3cooW5PSVifGBwry
	 /J7kk23VR3uEE9rv8XsRu5jCYllopBRbysYD+OCRr0W5I9YKGSyZCuIgn+HmCm/RsT
	 i7qqJyuDHGQXg==
Message-ID: <sashiko-outbox-163420@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 1/2] RDMA/rxe: copy send WQE to kernel buffer before
 processing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tristan Madani" <tristmd@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261007223222.2342804-2-tristmd@gmail.com>
References: <20261007223222.2342804-1-tristmd@gmail.com>
 <20261007223222.2342804-2-tristmd@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 22:47:12 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] rdma: remote kernel heap information leak via unvalidated inli=
ne data length
- [High] mm: fortify_source field-spanning write warning in req_next_wqe me=
mcpy
- [High] mm: truncated memcpy of WQE flex array corrupts inline data
- [Medium] locking: missing memory barriers when flushing WQEs leads to sta=
le completion status
--

commit 05fdd210d6581da6d266954d4f637a96e6640c15
Author: Tristan Madani <tristan@talencesecurity.com>
Subject: RDMA/rxe: copy send WQE to kernel buffer before processing

This commit copies the requester WQE from a user-space mapped buffer to a
kernel-private buffer before processing to prevent Time-Of-Check to
Time-Of-Use (TOCTOU) modifications. It also introduces a local copy reuse
mechanism and targeted writebacks to the shared queue to prevent tearing.

> diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/=
rxe/rxe_req.c
> index 53f7c1e7fe55b..df0fa455cd9c1 100644
> --- a/drivers/infiniband/sw/rxe/rxe_req.c
> +++ b/drivers/infiniband/sw/rxe/rxe_req.c

[ ... ]

> @@ -193,6 +213,20 @@ static struct rxe_send_wqe *req_next_wqe(struct rxe_=
qp *qp)
>  	}
>  	spin_unlock_irqrestore(&qp->state_lock, flags);
> =20
> +	/* Reuse the existing kernel-private copy if still valid */
> +	if (qp->req.send_wqe_valid && qp->req.shared_wqe =3D=3D wqe)
> +		return &qp->req.send_wqe.wqe;
> +
> +	/* Copy WQE from userspace-mapped shared queue to kernel-private
> +	 * buffer. Copy the full element (max_sge SGEs) so that inline
> +	 * data, which shares the flex array with SGEs, is always captured.
> +	 */
> +	memcpy(&qp->req.send_wqe.wqe, wqe,
> +	       sizeof(*wqe) + qp->sq.max_sge * sizeof(struct rxe_sge));

[Severity: High]
Does this memcpy trigger a fortify_source field-spanning write warning?

The destination pointer &qp->req.send_wqe.wqe explicitly points to the wqe
member of the anonymous send_wqe struct, which has a size of 64 bytes. If
max_sge > 0, the copy length exceeds 64 bytes.

When compiled with CONFIG_FORTIFY_SOURCE=3Dy, __builtin_object_size(p, 1) b=
ounds
the destination to the exact size of the wqe member because it is embedded
inside an outer struct before the sge array. This detects the out-of-bounds
write and triggers a deterministic run-time field-spanning write warning,
potentially crashing the kernel if panic_on_warn is enabled.

[Severity: High]
Can this size calculation truncate the inline data if max_inline_data is not
a multiple of 16?

During QP initialization, qp->sq.max_sge is computed via integer division
(wqe_size / sizeof(struct ib_sge)). If max_inline_data is configured to a
value that is not a multiple of 16 (e.g., 20 bytes), wqe_size evaluates to
20, but max_sge evaluates to 1.

The memcpy size would then evaluate to 64 + 1 * 16 =3D 80 bytes, whereas the
inline data spans 20 bytes up to offset 84. This truncates the copy, leaving
the last 4 bytes of inline data uncopied. When finish_packet() reads the
inline data from the kernel buffer, will it transmit uninitialized or stale
kernel memory instead of the user's provided payload?

> +	qp->req.shared_wqe =3D wqe;
> +	qp->req.send_wqe_valid =3D true;
> +
> +	wqe =3D &qp->req.send_wqe.wqe;
>  	wqe->mask =3D wr_opcode_mask(wqe->wr.opcode, qp);
>  	return wqe;
>  }

[ ... ]

> @@ -666,6 +706,7 @@ int rxe_requester(struct rxe_qp *qp)
>  		wqe =3D __req_next_wqe(qp);
>  		spin_unlock_irqrestore(&qp->state_lock, flags);
>  		if (wqe) {
> +			qp->req.send_wqe_valid =3D false;
>  			wqe->status =3D IB_WC_WR_FLUSH_ERR;
>  			goto err;

[ ... ]

> @@ -695,6 +737,7 @@ int rxe_requester(struct rxe_qp *qp)
>  	if (unlikely(qp->req.need_retry && !qp->req.wait_for_rnr_timer)) {
>  		req_retry(qp);
>  		qp->req.need_retry =3D 0;
> +		qp->req.send_wqe_valid =3D false;
>  	}
> =20
>  	wqe =3D req_next_wqe(qp);

[Severity: Critical]
Does this introduce a remote kernel heap information leak for inline packet=
s?

By moving the WQE buffer to the kernel heap, we now need to validate bounds
that were previously safe to read from shared memory. For inline data packe=
ts,
wqe->dma.resid (which stores the user-provided payload length) is only boun=
ded
by qp->mtu (e.g. 4096). The validation checks in this function completely
ignore wqe->dma.resid and wqe->dma.sge_offset for inline sends.

Later in finish_packet(), the inline payload is copied into the network pac=
ket:

memcpy(payload_addr(pkt), &wqe->dma.inline_data[wqe->dma.sge_offset], paylo=
ad);

Could a malicious user set sge_offset =3D 0 and length to 4096? The memcpy
would read past the end of the qp->req.send_wqe allocation and leak adjacent
kernel heap memory into the outgoing network packet.

>  	if (unlikely(!wqe))
>  		goto exit;

[ ... ]

> @@ -839,8 +884,10 @@ int rxe_requester(struct rxe_qp *qp)
>  	goto out;
>  err:
>  	/* update wqe_index for each wqe completion */
> -	qp->req.wqe_index =3D queue_next_index(qp->sq.queue, qp->req.wqe_index);
>  	wqe->state =3D wqe_state_error;
> +	rxe_req_writeback_wqe(qp);

[Severity: Medium]
Does this fast-flush path miss memory barriers when updating the shared WQE?

When handling IB_QPS_ERR, this function sets qp->req.send_wqe_valid =3D fal=
se,
assigns wqe->status =3D IB_WC_WR_FLUSH_ERR directly, and then jumps to err:,
where it sets wqe->state =3D wqe_state_error; and calls rxe_req_writeback_w=
qe(qp).

Because qp->req.send_wqe_valid is false, rxe_req_writeback_wqe() returns
immediately without issuing the intended smp_store_release() memory barrier.

Could the CPU or compiler reorder the writes to status and state, causing
the completer polling the shared queue to observe wqe_state_error but read a
stale or uninitialized status?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007223222.2342=
804-1-tristmd@gmail.com?part=3D1
