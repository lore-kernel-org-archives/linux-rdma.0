Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795176126;
	b=B0fr/3flxyuwisXVb7wLDaKnb2p6xq8oKNUDPBGqHq5OikqXFkeDCGf5jIsWOJkAcj+e
	 UL6D6slEvJHnAX9Cwnfcl2CQ13z7/QaPDP6CrTRImPA8WchN4IcwONAdnE3O25nu9+XA4
	 pdJnNQ63zs/uSc7o3x6ktcZYFowU9OxP9ZLRaYLR5uWC9Nhmn06r4/dj9+na+8ZaG1aqj
	 qOcaNaqDu0FNnL3+CJJoac2iFBk/aJNAMOHBAhZ3NZtF9DFiF9DvIUhoORblUIhhBfdUk
	 dMcp8zjWS8AMGWDseLnCH/i74L7uLq3di1g8Dz+A7tKrzlJDIg8VVj572bkYpCvcjwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795176126;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=5OfMrHGP0Nhxt0XLvDJZVUYBPAIRTacqZT17KMs53Zk=;
	b=GDg+D/9zovOJV3n1goAIReHsmIqs8fGh7a3GvxraFAEyks92O4/QzSYhN9r6n8E/CiLx
	 lKuKZeNq60ZBKhtqXYMRbSc+zEOkGDvr0oPnxU5jij+0LG8uiZsoozHLEcz/8WjgvPpFO
	 B4uxG+O9RbQqmIrfvxi40I4lJV21TC9VMK9a0BGe7xuZLZ77gE5W85aHP2RW/i0QI6gsM
	 HqYcahOOfvAJuZ6DR479Hgzj1T+lSKpJ6jjO3enqWvDMpaZZgUNgFO2XMVSatyu3Qw+MO
	 smkDX31mVeHQaK+wE+a+h4BTXuc9CyECAPO6B3+vxpFbpH4MA2lxlrqW8Xs6O+swl8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KZf03VzJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3885B606A325
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 12:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KZf03VzJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 886AE1F000C4;
	Fri, 20 Nov 2026 12:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795176125;
	bh=5OfMrHGP0Nhxt0XLvDJZVUYBPAIRTacqZT17KMs53Zk=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=KZf03VzJU8yIASaOJ3FgsKKlB90XnLpHviQWyCqmcn2j1MPGHLI9MtTUnO2gGRVyz
	 l6fT4oCEA4hJvhfEc3VXn0Rxyfh2qvJKPNfZ4MtwcVRHWiZAQWH4PRB66TmeUV59lr
	 OA3mAUHOzaz8yU+ug8aTPI1Cxx42C84OGnNX3qbYiuoMW0kveyKouYxVT/UVzvo27/
	 5WWTaMfeprcX84+8k3QVKDtzBkeUmvcjEunG647X4iCkErWC6WTXiLQ/1q1V5eWDFp
	 rC2F/gUw7rli4FkzStiTuymMcFUKHToqpEzcyMLMZ7x0XQF0l+KF/nd1X8ikoag/1N
	 MSPaK12HgKJwA==
Message-ID: <sashiko-outbox-225106@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v1] RDMA/rxe: Don't trust the user space SQ
 producer index
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shuai Liu" <847807867@qq.com>, linux-rdma@vger.kernel.org
In-Reply-To: <tencent_5B9FB1BCC8EF36C5E2128B7D4D54B867480A@qq.com>
References: <6adb54ac.d1cee5ca.8df35.0007.GAE@google.com>
 <tencent_5B9FB1BCC8EF36C5E2128B7D4D54B867480A@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 12:02:05 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] RDMA/rxe: requester and completer SQ index desync on
  out-of-range prod
- [Medium] RDMA/rxe: unvalidated SQ producer index read in
  rxe_qp_init_req()
- [Low] RDMA/rxe: wrong Fixes trailer and IB_QPS_ERR loop description
--

commit 216db84647f6c90b4699ba426a623f31c2b768e8
Author: Shuai Liu <847807867@qq.com>

> RDMA/rxe: Don't trust the user space SQ producer index
>
> The send queue producer index of a user space QP is stored in the
> queue buffer which is shared with and written by user space. The
> requester reads it without any validation in req_retry() and
> __req_next_wqe().
>
> The requester stops processing WQEs when its local WQE index equals
> the producer index. If user space writes an out of range producer
> index into the queue buffer, that comparison can never become true.
> Once the QP is put into the error state, rxe_requester() then keeps
> flushing the same (already errored) WQE forever: the flush loop
> advances the WQE index but req_retry() resets it back to the
> consumer index, and each pass calls rxe_qp_error() which reschedules
> the send task, so the loop never converges. The send task holds a
> reference to the QP for as long as this lasts, so ib_destroy_qp()
> waits for the QP reference to drop until it times out after 50
> seconds and the WARN_ON(!ret) fires in __rxe_cleanup():
>
>   WARNING: drivers/infiniband/sw/rxe/rxe_pool.c:212 at __rxe_cleanup
>   Call Trace:
>    __rxe_cleanup
>    rxe_destroy_qp
>    ...
>   rxe0: qp#17 rxe_destroy_qp: cleanup failed, err =3D -110
>
> Fix this by validating the producer index: if it is out of range,
> treat the send queue as empty. Verified with the syzbot reproducer
> in QEMU: without this patch every destroy_qp hangs for 50 seconds
> and hits the WARNING above; with this patch the reproducer runs
> cleanly.
>
> Reported-by: syzbot+fef38133c495aeb48297@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dfef38133c495aeb48297
> Fixes: 5bcf5a59c41e1 ("RDMA/rxe: Protext kernel index from user space")
> Signed-off-by: Shuai Liu <847807867@qq.com>

[Severity: Low]
Should the Fixes tag point to ae6e843fe08d ("RDMA/rxe: Add memory barriers
to kernel queues") instead?  In 5bcf5a59c41e ("RDMA/rxe: Protext kernel
index from user space"), producer_index() still masked the user-space value
with q->index_mask; ae6e843fe08d ("RDMA/rxe: Add memory barriers to kernel
queues") replaced producer_index() with queue_get_producer() and dropped
that mask.

Also, when qp_state(qp) =3D=3D IB_QPS_ERR, rxe_requester() jumps directly to
err: or exit: without reaching req_retry(); qp->req.wqe_index wraps back to
the consumer index via queue_next_index() at err: because queue_next_index()
masks with q->index_mask and never matches the out-of-range prod.

> diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/=
rxe/rxe_req.c
> index 6e01fb18893bf..4a78562d83b19 100644
> --- a/drivers/infiniband/sw/rxe/rxe_req.c
> +++ b/drivers/infiniband/sw/rxe/rxe_req.c
> @@ -48,6 +48,12 @@ static void req_retry(struct rxe_qp *qp)
>  	cons =3D queue_get_consumer(q, QUEUE_TYPE_FROM_CLIENT);
>  	prod =3D queue_get_producer(q, QUEUE_TYPE_FROM_CLIENT);
> =20
> +	/* The producer index is written by user space and cannot
> +	 * be trusted; treat an out of range index as an empty queue.
> +	 */
> +	if (unlikely(prod & ~q->index_mask))
> +		prod =3D cons;
> +
>  	qp->req.wqe_index	=3D cons;
>  	qp->req.psn		=3D qp->comp.psn;
>  	qp->req.opcode		=3D -1;
> @@ -188,7 +194,7 @@ static struct rxe_send_wqe *__req_next_wqe(struct rxe=
_qp *qp)
>  	unsigned int prod;
> =20
>  	prod =3D queue_get_producer(q, QUEUE_TYPE_FROM_CLIENT);
> -	if (index =3D=3D prod)
> +	if (unlikely(prod & ~q->index_mask) || index =3D=3D prod)
>  		return NULL;
>  	else
>  		return queue_addr_from_index(q, index);

[Severity: Medium]
Can treating out-of-range prod as an empty queue here desynchronize
qp->req.wqe_index from the completer's consumer index q->index?

queue_empty() in drivers/infiniband/sw/rxe/rxe_queue.h masks the index
difference with q->index_mask:

drivers/infiniband/sw/rxe/rxe_queue.h:queue_empty() {
	u32 prod =3D queue_get_producer(q, type);
	u32 cons =3D queue_get_consumer(q, type);

	return ((prod - cons) & q->index_mask) =3D=3D 0;
}

When user space writes a producer index where (prod & ~q->index_mask) !=3D 0
and ((prod - cons) & q->index_mask) !=3D 0, __req_next_wqe() treats the que=
ue
as empty and leaves qp->req.wqe_index at cons, while rxe_completer()
(via get_wqe() or flush_send_queue() -> queue_head() -> queue_empty()) sees
a non-empty queue and advances cons to prod & q->index_mask.  If user space
then writes an in-range prod equal to the new cons, __req_next_wqe() sees
index !=3D prod and processes or flushes already-consumed and unposted WQE
slots across the ring buffer.

In addition, if WQEs are already in flight (cons !=3D qp->req.wqe_index) wh=
en
user space sets upper bits in prod, clamping prod =3D cons in req_retry()
rewinds qp->req.wqe_index to cons and qp->req.psn to qp->comp.psn while
skipping the retry loop, leaving those in-flight WQEs stuck in
wqe_state_pending with exhausted DMA residuals.

Masking prod with q->index_mask in queue_get_producer() for
QUEUE_TYPE_FROM_CLIENT (as producer_index() did prior to ae6e843fe08d
("RDMA/rxe: Add memory barriers to kernel queues")) would keep the
requester, completer, and queue helpers consistent.

[Severity: Medium]
Does rxe_qp_init_req() also read an unvalidated user producer index into
qp->req.wqe_index?

drivers/infiniband/sw/rxe/rxe_qp.c:rxe_qp_init_req() {
	...
	err =3D rxe_init_sq(qp, init, udata, uresp);
	if (err)
		return err;

	qp->req.wqe_index =3D queue_get_producer(qp->sq.queue,
					       QUEUE_TYPE_FROM_CLIENT);
	...
}

rxe_init_sq() calls do_mmap_info(), which copies the mmap info to user space
and registers it in rxe->pending_mmaps before returning.  If user space maps
the buffer and writes to q->buf->producer_index before rxe_qp_init_req()
reads it, qp->req.wqe_index is initialized to an unvalidated value while
the consumer index q->index starts at 0, so a subsequent valid prod =3D=3D 0
causes __req_next_wqe() to see index !=3D prod and process unposted WQE slo=
ts
on an empty queue.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_5B9FB1BCC8E=
F36C5E2128B7D4D54B867480A@qq.com?part=3D1
