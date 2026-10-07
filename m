Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D71352C4F
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 06:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791355567; cv=none; b=MIsyiD/zWFsR1UPEbnSRuA2xDIZSR+wdVsniZY3JsjspK5erJwsghb7BQQ2XkajgQx6nkPFCONJvzkL9cuoC/PeLqpuDWeB1t/jctnRbiEHjhoGSKb6MJsJaQspRjxjHO1Vj1qoco/k6ewLI3AemNxDIvcDF71Pq8lheGZ6bd1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791355567; c=relaxed/simple;
	bh=I3UPZ/E6gRzFzOm8aEnJjeiM0IvXALzl0D7sHpZuErk=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=tP1dwCgTCtA8dvhKEWqCTgEgoVN0hhQQbo51scQDZlbHB/RCMtMeiv6MVzOahHEjgUz+zPfXvdn5ZAoSH6aDCQZ2PX3D292iBk/DrDD5KM9tBdQ36eH+a8OgVCNMv189dK2odGALtWRuvmFr3s8Orh5SPi9tTX30cH9qcrY8484=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dXCic5bW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dXCic5bW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923D31F0089D;
	Wed,  7 Oct 2026 06:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791355566;
	bh=Pv2BswnRRuJY/Buv7CWlO9iq5w8uAqrc0otygo4vBuU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dXCic5bWW4zX1E7K9xbXjwLK8/RQ6JYMo/GE3yq1e08ZJdpe1NTkl7+515kcB7J7J
	 0lVoGYMHMZzJG6CCp2ZwTJWVusJwAy1YPM9IIy/7wwSITwIP9R9OE+biQioFu3aE4J
	 niLTV2swg7Jb0WI75QTWgy5mJoZzeBSzXbYDjFjFnTAeR65jRt77GUMtvraTIG38FR
	 +nwIvfsCDcmStvJrlBDi+xmTxaSM3XbqG+yFoJgWmtLx1pIGb1pq4Ln+w4fh8Ac6JS
	 L8NW4xjSYpo9Drp41hbvMCliHvZPezZkiBkH5y1zTx4WvXCccu0iGawnf7baNiPNGE
	 VKEHy169dQJKQ==
Message-ID: <sashiko-outbox-162684@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/rxe: validate receive WQE cursor after snapshot
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sung Byeongchan" <tjdqudcks0424@naver.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261007063029.26073-1-tjdqudcks0424@naver.com>
References: <20261007063029.26073-1-tjdqudcks0424@naver.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 06:46:06 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] rdma/rxe: malformed WQE check wedges SRQ and drops error CQE
- [High] rxe: Missing READ_ONCE() on user-mapped num_sge allows double-fetch
--

commit 9a901f2aad88cef9dab9b3e49e87d7bb3dc7cd00
Author: Sung Byeongchan <tjdqudcks0424@naver.com>

RDMA/rxe: validate receive WQE cursor after snapshot

This commit adds validation for the receive WQE cursor before installing the
snapshot in the responder. It ensures that the copied num_sge matches the
size used for the copy and requires cur_sge to be within bounds. The checks
are applied to both per-QP and shared receive queues.

> diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw=
/rxe/rxe_resp.c
> index 02b16e2b49b8f..f059434eead13 100644
> --- a/drivers/infiniband/sw/rxe/rxe_resp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_resp.c
> @@ -288,8 +288,15 @@ static enum resp_states get_srq_wqe(struct rxe_qp *q=
p)
>  	}
>  	size =3D sizeof(*wqe) + num_sge * sizeof(struct rxe_sge);

[Severity: High]
Since num_sge is read from user-mapped memory in wqe->dma.num_sge earlier in
the function without READ_ONCE(), can the compiler re-fetch the value for t=
his
size calculation or the snapshot validation check below?

If the compiler re-fetches the value after a malicious user modifies it, co=
uld
it lead to a heap buffer overflow in memcpy(), or bypass the
wqe->dma.num_sge !=3D num_sge equality check?

>  	memcpy(&qp->resp.srq_wqe, wqe, size);
> +	wqe =3D &qp->resp.srq_wqe.wqe;
> +	if (unlikely(wqe->dma.num_sge !=3D num_sge ||
> +		     (wqe->dma.resid && wqe->dma.cur_sge >=3D num_sge))) {
> +		spin_unlock_irqrestore(&srq->rq.consumer_lock, flags);
> +		rxe_dbg_qp(qp, "invalid num_sge/cur_sge in SRQ entry\n");
> +		return RESPST_ERR_MALFORMED_WQE;
> +	}

[Severity: High]
If we return early here, we skip calling queue_advance_consumer(). Will this
permanently wedge the shared receive queue because the malformed WQE is nev=
er
consumed, potentially causing a denial of service to all other connections
sharing this queue?

Additionally, because qp->resp.wqe is never set, when do_complete() is call=
ed
later:

drivers/infiniband/sw/rxe/rxe_resp.c:do_complete() {
    ...
    if (!wqe)
        goto finish;
    ...
}

Will this incorrectly skip generating the mandatory error CQE for the
malformed WQE, violating the IB specification (Section 10.8.3.1)?

> =20
> -	qp->resp.wqe =3D &qp->resp.srq_wqe.wqe;
> +	qp->resp.wqe =3D wqe;
>  	queue_advance_consumer(q, QUEUE_TYPE_FROM_CLIENT);
>  	count =3D queue_count(q, QUEUE_TYPE_FROM_CLIENT);

[ ... ]

> @@ -328,8 +335,14 @@ static enum resp_states rxe_get_recv_wqe(struct rxe_=
qp *qp)
>  	}
>  	size =3D sizeof(*wqe) + num_sge * sizeof(struct rxe_sge);
>  	memcpy(&qp->resp.srq_wqe, wqe, size);
> +	wqe =3D &qp->resp.srq_wqe.wqe;
> +	if (unlikely(wqe->dma.num_sge !=3D num_sge ||
> +		     (wqe->dma.resid && wqe->dma.cur_sge >=3D num_sge))) {
> +		rxe_dbg_qp(qp, "invalid num_sge/cur_sge in recv WQE\n");
> +		return RESPST_ERR_MALFORMED_WQE;
> +	}

[Severity: High]
Similarly to get_srq_wqe(), does returning here without setting qp->resp.wqe
cause do_complete() to skip generating the proper error CQE?

While the WQE is eventually consumed by flush_recv_queue() for normal QPs,
does skipping do_complete() here result in an incorrect generic flush error
CQE instead of the required local QP operation error CQE?

> =20
> -	qp->resp.wqe =3D &qp->resp.srq_wqe.wqe;
> +	qp->resp.wqe =3D wqe;
>  	return RESPST_CHK_LENGTH;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007063029.2607=
3-1-tjdqudcks0424@naver.com?part=3D1
