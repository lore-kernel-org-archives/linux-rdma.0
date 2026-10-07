Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879333AAF50
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 21:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791409764; cv=none; b=JFAO8I7QAR2lqinm6Rvip9Yg7WfJnK0QnWpZH82BHQwmStR6Z9PgUan4RAsowRNc1N2tn8pidFyHqwtBorLUWON2Jqoxf6VS6xEvYGngKZUJz886PStqAq62q1SjQ9tcCEhQAilsP5+VloL9F5IfAmd5R4/q9oekWqoercVCSLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791409764; c=relaxed/simple;
	bh=m6bm4w9oq8MyaseND+xRPMxfboqFYM9s+hSOBWWbUuE=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=GCWocpT5ho0F3oYjEiq3vShUMZG/izm17ATT+MkWZczruV8GNV+A6SoYvZB/n5V6OjvP4fJISUk7EPGw2+iYUJtRZUO3RYzo5nxPz4eWpSG4NZOdQ8f/9lC/knEnz+TRnNEa56d8f6g5AgvjKmqQ+8EdWedzaY5YbySZ/sqItGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RsbM/aHu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RsbM/aHu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B54631F000FF;
	Wed,  7 Oct 2026 21:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791409762;
	bh=jB6K7fV80O7qCb3zZVtxuR8kdD8Yqaif7PZdCpEnu6g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RsbM/aHu/s7sh2XioPTeKmLszATCVIPx5tsZulopoCuNnSxIWYLLQE8ZJ5r1O+wIX
	 I4UYPqktLSx63eUM9dj96tI5lav+Bd0+t0kBzOZHI2IWf8e5SP92oFU95jak1U8BUo
	 kIggBy6fIqln8CxdnXMZb4ut8MFp2IAGgy95PblIo38M1+QsZ+zR1WowzSf1pCbb4F
	 6MbY+jYM5moyqn/7vANuvGdJGasxb3vgfK6C8oo4Sdg1lIle1iPDu4VoRm+Pe0G7Vg
	 Ut/bo1q15SYlANLTtYer2pCs5P8b3oubx3FBCOXB/EwZk5Lpr8vZUs0W11LwLEMRrT
	 rwObwxljHFXLA==
Message-ID: <sashiko-outbox-163399@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/2] RDMA/rxe: copy send WQE to kernel buffer in
 completer path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tristan Madani" <tristmd@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261007212737.1989004-3-tristmd@gmail.com>
References: <20261007212737.1989004-1-tristmd@gmail.com>
 <20261007212737.1989004-3-tristmd@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 21:49:22 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [Critical] rdma/rxe: TOCTOU mitigation bypass allows overwriting kernel D=
MA progress
- [High] rdma/rxe: out-of-bounds read in get_wqe() due to incorrect num_sge=
 bounding
- [High] rdma/rxe: stale WQE reuse due to uncleared comp_wqe_valid on QP re=
set
- [High] rdma/rxe: TOCTOU double-fetch of num_sge due to missing READ_ONCE()
- [High] rdma/rxe: torn read of WQE state and status during memcpy causes s=
uccessful completion of failed WQE
--

commit 925c6c168a2ebbc13c604cb14fd0fda0918233a7
Author: Tristan Madani <tristan@talencesecurity.com>

    RDMA/rxe: copy send WQE to kernel buffer in completer path

The commit modifies the rxe driver's completer path to copy Work Queue
Entries (WQEs) to a kernel-private buffer to prevent TOCTOU modifications
from userspace. The copied WQE is reused across multi-packet operations
when the state is unchanged to preserve DMA progress. Field updates are
written back to the shared queue to ensure consistent completion values.

> diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c b/drivers/infiniband/sw=
/rxe/rxe_comp.c
> index 1390e861bd1d7..f57c4396c28cb 100644
> --- a/drivers/infiniband/sw/rxe/rxe_comp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_comp.c
[ ... ]
> @@ -142,17 +154,52 @@ static inline enum comp_state get_wqe(struct rxe_qp=
 *qp,
>  				      struct rxe_send_wqe **wqe_p)
>  {
>  	struct rxe_send_wqe *wqe;
> +	u32 state;
> +	unsigned int num_sge;
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
>  		return pkt ? COMPST_DONE : COMPST_EXIT;
> +	}
> =20
> +	/* Pairs with smp_store_release() in rxe_req_writeback_wqe() */
> +	state =3D smp_load_acquire(&wqe->state);
> +	if (state =3D=3D wqe_state_posted) {
> +		*wqe_p =3D wqe;
> +		return pkt ? COMPST_DONE : COMPST_EXIT;
> +	}
> +
> +	/* Reuse existing local copy if still processing same WQE
> +	 * with unchanged state (preserves DMA progress for multi-packet ops)
> +	 */
> +	if (qp->comp.comp_wqe_valid && qp->comp.shared_wqe =3D=3D wqe &&
> +	    qp->comp.comp_wqe.wqe.state =3D=3D state) {

[Severity: Critical]
If a malicious userspace application alters wqe->state in the shared ring
buffer mid-operation to a different but non-terminating value, will this
equality check fail?

If it fails, the completer will fall through and recopy the entire WQE from
shared memory into the kernel buffer qp->comp.comp_wqe.

Will this recopy overwrite the kernel's valid DMA progress (resid,
sge_offset, cur_sge) with the newly crafted dma state and lengths from
userspace, defeating the protection?

[Severity: High]
When a Queue Pair (QP) is transitioned to the RESET state via ib_modify_qp(=
),
rxe_qp_reset() is called. Does rxe_qp_reset() clear the newly introduced
qp->comp.comp_wqe_valid and qp->req.send_wqe_valid flags?

If these flags are not cleared, and userspace posts a new WQE after restart,
it is placed at queue index 0. The memory address wqe would evaluate to the
exact same pointer as the pre-reset operation.

Would this cause the completer to unexpectedly reuse the stale kernel-priva=
te
WQE, ignoring the newly posted operation's parameters?

> +		wqe =3D &qp->comp.comp_wqe.wqe;
> +		*wqe_p =3D wqe;
> +		goto check_state;
> +	}
> +
> +	/* Copy shared WQE to kernel-private buffer */
> +	num_sge =3D wqe->dma.num_sge;
> +	if (unlikely(num_sge > RXE_MAX_SGE))
> +		num_sge =3D RXE_MAX_SGE;
> +
> +	qp->comp.shared_wqe =3D wqe;
> +	memcpy(&qp->comp.comp_wqe.wqe, wqe,
> +	       sizeof(*wqe) + num_sge * sizeof(struct rxe_sge));

[Severity: High]
Since wqe->dma.num_sge is read from an mmap'd shared memory queue into num_=
sge
without using READ_ONCE(), is the C compiler permitted to optimize the code
by reloading the value from memory during the memcpy size calculation?

If an attacker in userspace concurrently modifies wqe->dma.num_sge to a lar=
ge
value after the bounds check, could the re-fetched value bypass the
RXE_MAX_SGE limit and cause memcpy to write out of bounds into the fixed-si=
ze
qp->comp.comp_wqe kernel buffer?

[Severity: High]
The code caps num_sge against the global maximum RXE_MAX_SGE (32) instead
of the queue's specific maximum qp->sq.max_sge.

If max_sge was configured to a small value (e.g., 1), the allocated queue
elements are much smaller. If a malicious element is near the end of the
vmalloc_user ring buffer, could the memcpy read past the allocated queue
memory?

Could this hit an unmapped guard page and cause a fatal kernel page fault,
or leak adjacent queue elements?

[Severity: High]
Because memcpy uses unordered loads to copy the WQE from shared memory, cou=
ld it
experience a torn read where it captures a new wqe->state (wqe_state_error)
but an old wqe->status (IB_WC_SUCCESS)?

> +	qp->comp.comp_wqe_valid =3D true;
> +	qp->comp.comp_wqe.wqe.dma.num_sge =3D num_sge;
> +
> +	wqe =3D &qp->comp.comp_wqe.wqe;
> +	*wqe_p =3D wqe;
> +
> +check_state:
>  	/* WQE does not require an ack */
>  	if (wqe->state =3D=3D wqe_state_done)
>  		return COMPST_COMP_WQE;

If get_wqe() later checks the local copy's state directly:

check_state:
	/* WQE caused an error */
	if (wqe->state =3D=3D wqe_state_error)
		return COMPST_ERROR;

Will the state machine transition to COMPST_ERROR but process the completion
as IB_WC_SUCCESS because the torn read missed the status update?

Does the local variable wqe need to be updated with the cleanly loaded state
variable from earlier, or should the status and state be read more carefull=
y?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007212737.1989=
004-1-tristmd@gmail.com?part=3D2
