Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF7B48D872
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 09:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791453270; cv=none; b=JcmXmPN1QqQObuq3S8hJ1In8XI66dH0/tSML5r3ELShZ2ZMkCaNmcnjXS2R/1JzvzI7oTKwIArQlIhe2WSgRkzcHK4TW/ipJfh+11kOo1AI7ygPeIe315+hVrXbz0IkoBdP7x1s8U55J6338bW9yWhHC+BljBgpzk87D5LbW7Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791453270; c=relaxed/simple;
	bh=HRHuJBlT1VFkI9qGwaPTE5DlSlAKtsj990ClGjKTw0w=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=FbkvO6e+h7FLYaWAdwK51ALPqJ+fzNMYDT1VzZRsQaWdHP8CBmybmwY1tnHK8gwW9ZXP6vcWXmdXwTKg1D+61IvqkQEn4gyY6rKEVa06g/sA9u8zfi5AnXUBKkZf/Umo1ZZ5mzbJE2nSX0PHkFYiA6EWdy4uDCxpHD7mMy0F98s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mdGnq8+l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mdGnq8+l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844C71F000FF;
	Thu,  8 Oct 2026 09:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791453267;
	bh=4yKfNkrDhxQC0LEKVSbDkEXuodw0bOUtJE4NUgBhFcs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mdGnq8+l+b1UfC9RlAeqHbTlf5nXRytjCMwGGgsU8uC41WpjLeGucJCizY4a1PUmA
	 rU/gwsIid29L9GrUeGy+FAL9yt2EhRFyg79hnQ/66jzGvYxkx1Ji28Ae4WG0vSVsMU
	 rvj/sIHjL+X7Mo0dNYo13gaicwIW8AFT6rl5DOf3XgfwwZ+pUkgkMCvs2xzHEdyJW6
	 2qwMBySmSrb/MBm9OoSSoScbE9n1Bo7SowEvBfKZokcMMKMg4jrI0KtmDlk1HdXZsw
	 SE6yg7TDKUMNfuItFB0R8bQIoQs+wsggiz90bzTKDQasaTU/t91OWdPBP8xMdWjRNb
	 yt5qiwJF1MNOg==
Message-ID: <sashiko-outbox-163967@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 1/2] RDMA/rxe: copy send WQE to kernel buffer before
 processing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tristan Madani" <tristmd@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261008093740.3034881-2-tristmd@gmail.com>
References: <20261007223222.2342804-1-tristmd@gmail.com>
 <20261008093740.3034881-1-tristmd@gmail.com>
 <20261008093740.3034881-2-tristmd@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 09:54:26 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] rxe: kernel heap leak via unvalidated inline WQE fields
- [High] rxe: out-of-bounds read in wr_opcode_mask() via untrusted userspac=
e WQE opcode
- [Medium] rdma/rxe: Missing memory barrier in IB_QPS_ERR flush path violat=
es concurrency model
--

commit ffc0feb820a2586eb777f9f2b8fd3b594b8c06e6
Author: Tristan Madani <tristan@talencesecurity.com>

RDMA/rxe: copy send WQE to kernel buffer before processing

The rxe send queue is mapped into userspace via mmap. The requester
processes Work Queue Entries (WQEs) directly from this shared buffer
without first copying them to kernel memory. Userspace can modify WQE
fields (num_sge, sge_offset, SGE entries) between kernel reads,
leading to inconsistent state in copy_data().

> diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/=
rxe/rxe_req.c
> index 53f7c1e7fe55b..5bd6bcad2ab97 100644
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
> +	 * buffer. Use max_inline as copy size since it covers both SGEs
> +	 * and inline data, which share the flex array.
> +	 */
> +	memcpy(&qp->req.send_wqe.wqe, wqe,
> +	       sizeof(*wqe) + qp->sq.max_inline);
> +	qp->req.shared_wqe =3D wqe;
> +	qp->req.send_wqe_valid =3D true;
> +
> +	wqe =3D &qp->req.send_wqe.wqe;
>  	wqe->mask =3D wr_opcode_mask(wqe->wr.opcode, qp);

[Severity: High]
Does this code perform an out-of-bounds read of rxe_wr_opcode_info[]?

The opcode in the WQE comes directly from userspace without validation. It =
is
passed to wr_opcode_mask():

drivers/infiniband/sw/rxe/rxe_loc.h:wr_opcode_mask() {
    return rxe_wr_opcode_info[opcode].mask[qp->ibqp.qp_type];
}

If a malicious user provides an out-of-bounds opcode (e.g. 0xFFFFFFFF), cou=
ld
it read unmapped kernel memory or use garbage memory as an opcode mask?

[ ... ]

> @@ -666,6 +706,7 @@ int rxe_requester(struct rxe_qp *qp)
>  		wqe =3D __req_next_wqe(qp);
>  		spin_unlock_irqrestore(&qp->state_lock, flags);
>  		if (wqe) {
> +			qp->req.send_wqe_valid =3D false;
>  			wqe->status =3D IB_WC_WR_FLUSH_ERR;
>  			goto err;

[Severity: Medium]
Does this bypass the required memory barriers for updating the WQE in shared
memory?

Since qp->req.send_wqe_valid is set to false here, the subsequent call to
rxe_req_writeback_wqe() at the err label will be a no-op. The WQE state and
status are directly modified on the shared memory WQE:

err:
	wqe->state =3D wqe_state_error;
	rxe_req_writeback_wqe(qp);

Without the intended smp_store_release() or WRITE_ONCE() macros, could
the completer or userspace observe wqe_state_error before the status update
is visible?

>  		} else {
>  			goto exit;
>  		}

[ ... ]

> @@ -695,6 +737,7 @@ int rxe_requester(struct rxe_qp *qp)
>  	if (unlikely(qp->req.need_retry && !qp->req.wait_for_rnr_timer)) {
>  		req_retry(qp);
>  		qp->req.need_retry =3D 0;
> +		qp->req.send_wqe_valid =3D false;
>  	}
> =20
>  	wqe =3D req_next_wqe(qp);

[Severity: High]
Does this code allow an out-of-bounds read of the kernel heap memory when
processing IB_SEND_INLINE WQEs?

Just below this in rxe_requester(), num_sge and cur_sge are bounds checked,
but sge_offset and resid are not validated against qp->sq.max_inline:

drivers/infiniband/sw/rxe/rxe_req.c:rxe_requester() {
	...
	if (unlikely(wqe->dma.num_sge > qp->sq.max_sge ||
		     (wqe->dma.resid &&
		      wqe->dma.cur_sge >=3D qp->sq.max_sge))) {
		rxe_dbg_qp(qp, "invalid num_sge/cur_sge in send wqe\n");
	...
}

Because this patch relocates the WQE into a kmalloc'd kernel buffer, can
a malicious user supply large values for sge_offset and resid to leak
adjacent kernel heap memory when the payload is copied to the network packe=
t?

drivers/infiniband/sw/rxe/rxe_req.c:finish_packet() {
        ...
		if (wqe->wr.send_flags & IB_SEND_INLINE) {
			u8 *tmp =3D &wqe->dma.inline_data[wqe->dma.sge_offset];

			memcpy(payload_addr(pkt), tmp, payload);
        ...
}

[ ... ]

> @@ -839,8 +884,10 @@ int rxe_requester(struct rxe_qp *qp)
>  	goto out;
>  err:
>  	/* update wqe_index for each wqe completion */
> -	qp->req.wqe_index =3D queue_next_index(qp->sq.queue, qp->req.wqe_index);
>  	wqe->state =3D wqe_state_error;
> +	rxe_req_writeback_wqe(qp);
> +	qp->req.wqe_index =3D queue_next_index(qp->sq.queue, qp->req.wqe_index);
> +	qp->req.send_wqe_valid =3D false;
>  	rxe_qp_error(qp);
>  exit:
>  	ret =3D -EAGAIN;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008093740.3034=
881-1-tristmd@gmail.com?part=3D1
