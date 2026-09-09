Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393A757F75C
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 16:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788970896; cv=none; b=vDnygBTqcwxpU+Lpf3QRcgk3KEwBRb0vl+Sy3XBwMpnDkedoYzGVHdhf1kOCxlMSkad/pbDsVNTidudXSklMj3a3K6Rh3NLJtIlRJncGG1EOWMUtsnzVAlwrkR0JhDAfeNMogV7Y/VWiCgIuk4pClxFmfZyjouUEU/IcbZqMnJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788970896; c=relaxed/simple;
	bh=0FRPRxoHLvVCqrgYTp/mGsY+w6yucLrkHJTOGNnMgXU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oNNjCdge+wY+/zOUTNYRYuxaFuV8fLcrYfr2vISpQbf6xcsI7MmEBm+JZ0s0WmkAtegNhjJHO+U6D/1zBqybnvJuzQ6PVPonPpyOoPks3lzm/a16UyGz/qRGAPWrALyvHqD9TDLRsej746WlcW/N1WZT3WYtiqrVI5QhHQPpFgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eKQocJB6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eKQocJB6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4231F000FF;
	Wed,  9 Sep 2026 16:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788970895;
	bh=DMWZ7O8NZjE0ESvkfDDLp4bEU1ZTHbNBKOvXDNGMBa4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eKQocJB692zbCQlGcP/EvBuitfKDTlh4D3hjA61xG/AkqxPQwloKq94Bg8/T2HsW6
	 +ImGdClbyki8r3J9k2Cg/exCCZRHqlRRJJtVX0kV2pu4xce0nVeFedny8h8Xj8+XMJ
	 z+WVhPJEQEC2ongxjpb+P84q1w7qDdq7bLnPTA6SbB5R3H1uqU/ETv/v3RHuccRi7H
	 jQ6kuYeob3f64lkp76JBEgjV7jZm8MTJL3eFqJwbEqfFmrpGH6tYQCoFz2eS4ilJbG
	 /d5io6mKF2UF07B5CLtjX/Gr+PHq6kvzE/TPIu4cBqKK/gR7enGrH37Mh8q4a1FbP1
	 9dOfS5SBrFk6Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] RDMA/rxe: Use validated num_sge in local buffer
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nicolas Morey" <nmorey@suse.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260909160132.1491248-1-nmorey@suse.com>
References: <20260909160132.1491248-1-nmorey@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 16:21:34 +0000
Message-Id: <20260909162134.EC4231F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] The receive WQE's DMA state fields (specifically `cur_sge`, `s=
ge_offset`, `length`, and `resid`) are copied directly from shared user mem=
ory without validation or initialization. This leads to out-of-bounds array=
 indexing and heap read/write in `copy_data()`.
- [Critical] The send path reads WQEs directly from the user-space shared r=
ing buffer without making a local copy. All WQE fields, including `cur_sge`=
, `num_sge`, `sge_offset`, and `resid`, are subject to Time-Of-Check to Tim=
e-Of-Use (TOCTOU) races.
- [High] The local variable `num_sge` is read from shared user-memory `wqe-=
>dma.num_sge` without using `READ_ONCE()`, creating a compiler double-fetch=
 vulnerability between the bounds check and the `memcpy` size calculation.
--

commit 81af792b3b2b8089fc7af5abfac657516fe3ed47
Author: Nicolas Morey <nmorey@suse.com>

RDMA/rxe: Use validated num_sge in local buffer

This commit addresses a time-of-check to time-of-use heap overflow
in the receive path of rdma/rxe. It explicitly assigns the validated
num_sge to the locally copied wqe to prevent an attacker from modifying it
during the copy.

> diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw=
/rxe/rxe_resp.c
> index b1ea720aa34f9..ba3b2d23b36b7 100644
> --- a/drivers/infiniband/sw/rxe/rxe_resp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_resp.c
> @@ -288,6 +288,7 @@ static enum resp_states get_srq_wqe(struct rxe_qp *qp)
>  	}
>  	size =3D sizeof(*wqe) + num_sge * sizeof(struct rxe_sge);
>  	memcpy(&qp->resp.srq_wqe, wqe, size);
> +	qp->resp.srq_wqe.wqe.dma.num_sge =3D num_sge;

[Severity: High]
This isn't a bug introduced by this patch, but does the read of num_sge
above this memcpy() in get_srq_wqe() require a READ_ONCE()?

	num_sge =3D wqe->dma.num_sge;
	if (unlikely(num_sge > srq->rq.max_sge)) {
		...
	}
	size =3D sizeof(*wqe) + num_sge * sizeof(struct rxe_sge);

Since wqe->dma.num_sge is in shared user-memory, can the compiler reload it
after the bounds check?

If an attacker modifies it concurrently in the shared mmap'd ring buffer,
could this result in an enormously large size calculation, causing memcpy()
to write far past the fixed-size local srq_wqe buffer into adjacent rxe_qp
fields?

[Severity: Critical]
This is a pre-existing issue, but are the other dma state fields like
cur_sge validated after being copied from shared memory here?

If an attacker crafts a wqe with an extremely large cur_sge, when
copy_data() in drivers/infiniband/sw/rxe/rxe_mr.c uses it as an array index:

	struct rxe_sge *sge =3D &dma->sge[dma->cur_sge];

could this result in an out-of-bounds kernel memory read past the local
srq_wqe structure and potential memory corruption?

> =20
>  	qp->resp.wqe =3D &qp->resp.srq_wqe.wqe;
>  	queue_advance_consumer(q, QUEUE_TYPE_FROM_CLIENT);
> @@ -328,6 +329,7 @@ static enum resp_states rxe_get_recv_wqe(struct rxe_q=
p *qp)
>  	}
>  	size =3D sizeof(*wqe) + num_sge * sizeof(struct rxe_sge);
>  	memcpy(&qp->resp.srq_wqe, wqe, size);
> +	qp->resp.srq_wqe.wqe.dma.num_sge =3D num_sge;
> =20
>  	qp->resp.wqe =3D &qp->resp.srq_wqe.wqe;
>  	return RESPST_CHK_LENGTH;

[Severity: Critical]
This is also a pre-existing issue, but does the send path have a similar
time-of-check to time-of-use vulnerability that should be addressed?

In drivers/infiniband/sw/rxe/rxe_req.c:rxe_requester(), num_sge and cur_sge
are checked directly against the shared ring buffer without making a local
copy:

	if (unlikely(wqe->dma.num_sge > qp->sq.max_sge ||
		     (wqe->dma.resid &&
		      wqe->dma.cur_sge >=3D qp->sq.max_sge))) {

Can an attacker thread modify cur_sge to a massive value immediately after
this check?

Later in rxe_req.c:finish_packet(), the shared memory wqe pointer is passed
directly to copy_data():

	err =3D copy_data(qp->pd, 0, &wqe->dma,
			payload_addr(pkt), payload,
			RXE_FROM_MR_OBJ);

which recalculates the array index from the unvalidated shared memory:

	struct rxe_sge *sge =3D &dma->sge[dma->cur_sge];

Could this cause an out-of-bounds array access beyond the vmalloc allocation
of the ring buffer?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909160132.1491=
248-1-nmorey@suse.com?part=3D1
