Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082D1414429
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 21:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791409213; cv=none; b=fL6YNLdtFc53tNiunXtmZM4DGhiVX+gxsk+n+NYLwUKpmm8yTVztmwELLnKQ75Q7m6ocIPfZLt6AzxXXEpF4Hp9ALO0N3A0nV7asjNljMQXYLsWc8xgW0W5GlT47krJB8SZtLTYw2pdrGQgKp9eiKBx9hhNMe6NWPn6tWa+7iqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791409213; c=relaxed/simple;
	bh=TvO7SuAQRIdLk7+9/x+5PXT+rvoWhlXok1rDOyN6CiU=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=oEXCL8oiL5s8YnteYIWhYsiDLhH6569WfNZW9SwzFmzbi3aPpAdt8LjPW3NoKo0/YLV8Kf4Wc5Xb1Rci60JC+pRwMrA3v2Vg6cU7rp9GaoHndSlhY6uJtNPF3uWC/I6brbFMdqwsyY91t7/A34Dg6Fnf6R3RqQGWZoIhiihEY68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sq9Csx5b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sq9Csx5b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E71B61F000FF;
	Wed,  7 Oct 2026 21:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791409211;
	bh=+i5bbWRrOKCgeSaqkbJyhfl7VhOQ1lHDHnd7iHH9mkU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Sq9Csx5bPl/BcmZ1Wecxy7A0mJuH4OU4ccxylEbWMEXsuX8mzgPZAGiIwWzpH/3NF
	 PNBuCELYJmBg9xNhp780Mx/ALmfDP7oesg22oY26J6qCiAtK+txnLI+j6n00ldHBHP
	 +375hVi9I66bQG7Vm9wFBUrrsU3muCckdYqVZFoMufc3EJsHGr+Dw1V+Imv00MwAuL
	 0vaVki/B0rSOvbDpIHmnTMOKD7ds1VZfQnTidcqG9RIMuw7z/3xq6+X4BW49MvFQO+
	 hnAj0H6KCUI1cPj3NDs4RiDEZJiKV7wuLvrCKw1s/jSVQMeMJ1SH7SA4k15KCczvFh
	 FHaUEnmOsFC7w==
Message-ID: <sashiko-outbox-163398@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/2] RDMA/rxe: copy send WQE to kernel buffer before
 processing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tristan Madani" <tristmd@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261007212737.1989004-2-tristmd@gmail.com>
References: <20261007212737.1989004-1-tristmd@gmail.com>
 <20261007212737.1989004-2-tristmd@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 21:40:10 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 8 potential issue(=
s) to consider:
- [High] rxe: Silent QP stall on invalid WQE num_sge
- [High] rxe: Stale WQE cache reuse across QP resets
- [High] rxe: Data clobbering of flush error state in rxe_requester
- [High] rxe: Out-of-bounds array read via unvalidated WQE opcode
- [High] rxe: TOCTOU info leak during WQE copy due to compiler reload
- [High] rxe: Uninitialized kernel memory transmission on inline sends
- [High] rxe: RDMA READ retries broken due to missing DMA state writeback
- [Medium] rxe: FORTIFY_SOURCE field-spanning write warning in req_next_wqe=
 memcpy
--

commit 99abb995a563e5638c46b6895ade6985823dd689
Author: Tristan Madani <tristan@talencesecurity.com>

    RDMA/rxe: copy send WQE to kernel buffer before processing

This commit introduces a local kernel-private copy of the requester Work Qu=
eue
Entries (WQEs) to prevent TOCTOU vulnerabilities during send queue processi=
ng.
It copies the WQE fields into a local buffer before validation and uses
targeted writes to update the shared completion state. A validity flag trac=
ks
when the cached WQE is active for reuse across multi-packet sends.

> diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/=
rxe/rxe_req.c
> index 53f7c1e7fe55b..025a41145c408 100644
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
Does omitting DMA state updates here break RDMA READ retries?

To protect against TOCTOU attacks, this writeback deliberately omits
DMA state updates like resid and cur_sge.

However, the untouched req_retry() function reads wqe->dma.resid directly
from the shared WQE to calculate the retry PSN offset:

    npsn =3D (wqe->dma.length - wqe->dma.resid) / qp->mtu;

Because the shared resid is never updated by the processing path anymore,
req_retry() incorrectly computes that no progress was made. This sends
retries from the beginning of the buffer and breaks RDMA READ response stat=
e.

[ ... ]

> @@ -193,6 +215,24 @@ static struct rxe_send_wqe *req_next_wqe(struct rxe_=
qp *qp)
>  	}
>  	spin_unlock_irqrestore(&qp->state_lock, flags);
> =20
> +	/* Reuse the existing kernel-private copy if still valid */
> +	if (qp->req.send_wqe_valid && qp->req.shared_wqe =3D=3D wqe)
> +		return &qp->req.send_wqe.wqe;

[Severity: High]
Can this erroneously reuse a stale cached WQE across QP resets?

When a QP transitions to IB_QPS_RESET, rxe_qp_reset() resets the queue
indices to 0 but does not clear qp->req.send_wqe_valid.

If the QP is later transitioned back to RTS and userspace posts a new WQE at
index 0, req_next_wqe() evaluates this condition. Since the address matches
the pre-reset WQE at index 0, it incorrectly reuses the stale cached WQE
instead of copying and processing the newly posted WQE.

> +
> +	/* Copy WQE from userspace-mapped shared queue to kernel-private
> +	 * buffer to prevent TOCTOU races on DMA state fields.
> +	 */
> +	num_sge =3D wqe->dma.num_sge;
> +	if (unlikely(num_sge > qp->sq.max_sge)) {
> +		rxe_dbg_qp(qp, "invalid num_sge in send WQE\n");
> +		return NULL;
> +	}

[Severity: High]
Does returning NULL here stall the queue?

If this validation fails, it returns NULL. The caller rxe_requester() handl=
es
a NULL return by exiting the task loop and returning -EAGAIN. Because the W=
QE
is not explicitly failed with an error status, the queue consumer index is
never advanced and the QP is not transitioned to IB_QPS_ERR. The QP will
silently hang forever, repeatedly trying to process this malformed WQE.

> +	copy_size =3D sizeof(*wqe) + num_sge * sizeof(struct rxe_sge);
> +	memcpy(&qp->req.send_wqe.wqe, wqe, copy_size);

[Severity: Medium]
Will this memcpy trigger a FORTIFY_SOURCE warning or panic?

The destination pointer &qp->req.send_wqe.wqe is strongly typed to the wqe
member of the wrapper struct, so the compiler evaluates __builtin_object_si=
ze
as exactly sizeof(struct rxe_send_wqe). When num_sge > 0, copy_size exceeds
this struct size, which can trigger a __fortify_memcpy_chk warning for a
field-spanning write into the adjacent sge array.

[Severity: High]
Is there a TOCTOU info leak here due to a compiler reload during memcpy?

The variable num_sge is read from shared memory, validated against
qp->sq.max_sge, and used to compute copy_size.

If userspace maliciously inflates wqe->dma.num_sge in shared memory after
the local variable is read but before memcpy executes, the copied struct
header will contain the inflated num_sge value.

Because memcpy only copies bytes up to the original copy_size, the trailing
SGE array elements in the local buffer remain uninitialized. The secondary
validation in rxe_requester() reads the modified num_sge from the local cop=
y,
validates it against max_sge, and processes the uninitialized SGE elements,
potentially leaking kernel memory to the network.

[Severity: High]
Will this transmit uninitialized kernel memory on inline sends?

For inline sends, the payload resides in the inline_data flex array followi=
ng
the WQE header, often with num_sge =3D=3D 0.

If num_sge is 0, the copy_size calculation results in strictly copying the =
WQE
header, entirely omitting the inline data payload. When the requester later
processes the packet, it reads the payload from the local copy's inline_data
union array, transmitting uninitialized kernel memory instead of the user's
data.

> +	qp->req.shared_wqe =3D wqe;
> +	qp->req.send_wqe_valid =3D true;
> +
> +	wqe =3D &qp->req.send_wqe.wqe;
>  	wqe->mask =3D wr_opcode_mask(wqe->wr.opcode, qp);

[Severity: High]
Can this result in an out-of-bounds array read?

At this point, wqe->wr.opcode has just been copied from userspace and is
entirely unvalidated. wr_opcode_mask() uses this opcode directly as an
array index into rxe_wr_opcode_info, which can lead to an out-of-bounds
kernel memory read and a system crash.

>  	return wqe;
>  }

[ ... ]

> @@ -839,8 +888,10 @@ int rxe_requester(struct rxe_qp *qp)
>  	goto out;
>  err:
>  	/* update wqe_index for each wqe completion */
> -	qp->req.wqe_index =3D queue_next_index(qp->sq.queue, qp->req.wqe_index);
>  	wqe->state =3D wqe_state_error;
> +	rxe_req_writeback_wqe(qp);

[Severity: High]
Does this writeback clobber the flush error state with stale cached data?

If a QP enters IB_QPS_ERR while a WQE is locally cached, rxe_requester()
fetches the shared WQE directly via __req_next_wqe(). It assigns
wqe->status =3D IB_WC_WR_FLUSH_ERR and jumps to err:, setting
wqe->state =3D wqe_state_error directly on the shared WQE.

Then it calls rxe_req_writeback_wqe(qp). Since qp->req.send_wqe_valid is
still true, the writeback function writes the stale local->status and
local->state over the shared WQE, erasing the flush error state and
potentially stalling completions.

> +	qp->req.wqe_index =3D queue_next_index(qp->sq.queue, qp->req.wqe_index);
> +	qp->req.send_wqe_valid =3D false;
>  	rxe_qp_error(qp);
>  exit:
>  	ret =3D -EAGAIN;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007212737.1989=
004-1-tristmd@gmail.com?part=3D1
