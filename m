Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DEE43A0B3F
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 22:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791413285; cv=none; b=A4a2a4na90iNvnpD4oo6cu/M6Qs1IYTdID4tH0TQvmNG1+NycACoLr2+fL8fwV6qH7PtIpqspyEMnRH0VtmwYBD9urg4d8yRp5J3WZZoi8b7FlO/6tf96/doZyD/bETRAHcZ70jmiNjlzgjLOzVRe/uWwxxoXK4aFj3q97hDdlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791413285; c=relaxed/simple;
	bh=+0x53Ik7FIMOhkkghmFNfgD2r4AQOjOacCiLADMX8nI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=enwDxMuJpmOAeK1ISDWUAn13YmFVoNZKKwH4wtM5OfRJFZ0U+IQWnv8SztywcHb3fcOfBiTM2Zi5jMbHIjD3jLKRQs3FCOzS6RWlw5Xh1j+yiBhvCL/dQB68tga3qxppzlepqsR/wNJxPsy4L4os6tW4k0Ec1NCWQwyHzpwxm64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RxnGEWbq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RxnGEWbq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19DAE1F000FF;
	Wed,  7 Oct 2026 22:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791413284;
	bh=wuEK3tKq0146bXDXR5NkJKFX+LtFzRDJHrl2yughJfw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RxnGEWbqAAVdAoFy8UgXxVCbghZ/WAcBRMpxH/A0mVqvSWrhQXlBwHQF7T0uSEm6x
	 hALgetuGMEilw1xkJWI81CwQmuVNCRB+UMdFUkdXBajm1gGaV0Oj4pz7iIPFpUE6C7
	 TYjyrzfTYiuaBSs0YkG3XakBEDtSJ7Fn5VlklzxnjqWhzd349mOkDDizvYNGl3f+fk
	 9hPU+CIiUO+XQZ3eCwINNP36gVED9gkJNtvO/DD9d8RV3NC05Xx7MAGMyg3N1CnRuA
	 /QfxyuuYLSuURiQxmlhUZAoCHTTn3pzHjt9EhKukcaMRLGs1xe5OZWzNmu0p3L8opp
	 Uf3HM1tbfn9oA==
Message-ID: <sashiko-outbox-163423@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 2/2] RDMA/rxe: copy send WQE to kernel buffer in
 completer path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tristan Madani" <tristmd@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261007223222.2342804-3-tristmd@gmail.com>
References: <20261007223222.2342804-1-tristmd@gmail.com>
 <20261007223222.2342804-3-tristmd@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 22:48:03 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] rdma/rxe: data corruption in RDMA READ retry due to private WQ=
E DMA state
- [High] rdma/rxe: TOCTOU / lockless torn read of wqe->state during memcpy
- [High] RDMA/rxe: memcpy into WQE buffer triggers FORTIFY_SOURCE panic
- [High] RDMA/rxe: TOCTOU bypass in completer WQE copy via timeout retry pa=
th
--

commit 59f69c9fb12619fc21466b561c2742dd05e89831
Author: Tristan Madani <tristan@talencesecurity.com>
Date:   Wed Oct 7 22:32:22 2026 +0000

    RDMA/rxe: copy send WQE to kernel buffer in completer path
   =20
This patch aims to prevent TOCTOU races by copying send WQEs to a kernel
private buffer during completion processing. It uses an acquire/release
pattern to observe state transitions and writes back completion status
and rd_atomic state to the shared memory queue.

> diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c b/drivers/infiniband/sw=
/rxe/rxe_comp.c
> index 1390e861bd1d7..ca31093fdf3aa 100644
> --- a/drivers/infiniband/sw/rxe/rxe_comp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_comp.c
[ ... ]
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

[Severity: Critical]
Does this omit writing back the advanced dma.resid and dma.sge_offset fields
to the shared WQE?

If a multi-packet RDMA READ response experiences a network drop and triggers
a requester retry, the requester will read the shared WQE where dma.resid
still equals dma.length. This causes it to re-request data from the original
starting iova.

>  static inline enum comp_state get_wqe(struct rxe_qp *qp,
>  				      struct rxe_pkt_info *pkt,
>  				      struct rxe_send_wqe **wqe_p)
>  {
>  	struct rxe_send_wqe *wqe;
> +	u32 state;
[ ... ]
> +	/* Pairs with smp_store_release() in rxe_req_writeback_wqe() */
> +	state =3D smp_load_acquire(&wqe->state);
> +	if (state =3D=3D wqe_state_posted) {
> +		*wqe_p =3D wqe;
> +		return pkt ? COMPST_DONE : COMPST_EXIT;
> +	}

[Severity: High]
If state is wqe_state_posted, this assigns the shared memory pointer direct=
ly
to wqe_p without making a local copy.

If a timeout triggers this path, rxe_completer() transitions to
COMPST_ERROR_RETRY where it re-reads wqe->state from this shared pointer.
Could a concurrent userspace modification change the state to bypass the
wqe_state_posted check, leading to COMPST_ERROR where it re-reads
wqe->status directly from shared memory?

If userspace races to set wqe->status to IB_WC_SUCCESS, could this trigger
the WARN_ON_ONCE(wqe->status =3D=3D IB_WC_SUCCESS) in rxe_completer() and
subsequently process a corrupted WQE?

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

[Severity: Critical]
Could this reuse logic cause memory corruption during an RDMA READ retry?

Because rxe_comp_writeback_wqe() does not sync the advanced DMA state to
shared memory, a retried request will re-request the beginning of the
data. However, the requester's retry rewinds the shared WQE state to
wqe_state_posted and back to wqe_state_pending.

This allows the state check here to succeed, meaning the completer reuses
its private WQE containing the advanced DMA pointer. Won't the completer
then write the re-transmitted beginning data into the middle of the local
buffer?

> +
> +	/* Copy shared WQE to kernel-private buffer. Copy the full
> +	 * element (max_sge SGEs) so that inline data, which shares
> +	 * the flex array with SGEs, is always captured.
> +	 */
> +	qp->comp.shared_wqe =3D wqe;
> +	memcpy(&qp->comp.comp_wqe.wqe, wqe,
> +	       sizeof(*wqe) + qp->sq.max_sge * sizeof(struct rxe_sge));

[Severity: High]
This problem wasn't introduced by this patch, but it appears here and was
also introduced in the requester path in the previous patch of this series.

Because the destination pointer specifically targets the wqe field
(&qp->comp.comp_wqe.wqe), the compiler evaluates the object size strictly
as sizeof(struct rxe_send_wqe).

When max_sge > 0, the size exceeds the bounds of the wqe field. When
CONFIG_FORTIFY_SOURCE=3Dy is enabled, will this trigger a runtime
field-spanning write warning or panic? Would it be safer to copy into
the enclosing struct address, such as &qp->comp.comp_wqe?

[Severity: High]
Is there a Time-of-Check to Time-of-Use race when copying the state?

The memcpy is an unordered bulk copy that re-reads wqe->state from shared
memory. A concurrent requester could update the WQE fields in shared memory
during this copy. Because memcpy provides no memory ordering, it could copy
the new state but an old status.

> +	qp->comp.comp_wqe_valid =3D true;
> +	if (qp->comp.comp_wqe.wqe.dma.num_sge > qp->sq.max_sge)
> +		qp->comp.comp_wqe.wqe.dma.num_sge =3D qp->sq.max_sge;
> +
> +	wqe =3D &qp->comp.comp_wqe.wqe;
> +	*wqe_p =3D wqe;
> =20
> +check_state:
>  	/* WQE does not require an ack */
> -	if (wqe->state =3D=3D wqe_state_done)
> +	if (wqe->state =3D=3D wqe_state_done)

[Severity: High]
Here, the code checks if wqe->state =3D=3D wqe_state_done using the value
inside the locally copied WQE.

Since this evaluates the re-read state from the memcpy rather than the
state local variable acquired safely via smp_load_acquire() earlier, could
this defeat the memory barrier and cause the completer to process a done
WQE with stale fields?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007223222.2342=
804-1-tristmd@gmail.com?part=3D2
