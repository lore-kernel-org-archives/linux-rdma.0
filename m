Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795443572;
	b=XNht6Oixmq9YSDBRDD83lQ61QScvvNqllHbteMxdQZSYD0JHuFYAEP8nOQszbVkezPAY
	 KIicgFfyfvdoVR/6pKblTM62hmG0+PxjZ0PxizaI6xktX+561ZLI0bmMsK96nT4mBg5zf
	 7YExMYKN5f3nOpF5fl433MYKnIamztkSvyujvwJ8gVzYaC+CjPjCo5Yj70QEG2vC/RS64
	 w0x7lo+AqD/ALHDqmsIdJMvh5uKyfzLTcmJuRVL4A7Golr2OuJeRSaizJnKdDCjLWlvNu
	 xmSdM2hC1MuDefTqs5ynGnWYI82q91FStvUU+6kQOEdx+BuV83gIIcZzDeZUJLI4Esw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795443572;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=IAXFOlKyfgOIfd7LKbnq7QQpi2lY40FSmuuFoCMyJZs=;
	b=Vxpeq1W1h1hUBI0h8xBUEWzdoEOFV3aAxZr+ORwoT2Dbgl4JMa9266ybqy8bt1adAp6j
	 g2jjOMm/wvM1yqkWa14Xf2nw7ttBkmgoWm+jlEB59rkjb1ln4xrQnJ9xgpjvL4gSMmoXn
	 o9uIU4kO/lQrYaJEjfqscsXIu67l/mrwDpxkcn52c9H7m8mQja1Ap658z9bl/tILPyPaG
	 78R92IlTvzQ9h1FEXfzQO0QuHWWB8ceZ3cWoB/mrfRFQGSDVYL9KlUzWpt675M1iusXY+
	 2HEBF7YTgC4TOndfiWMgSbGwFXTGDte/Qr36M32LjcwKyOVMKO+1f1DifOsBy/0Xr5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U8j2LsDn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EAE606A31E
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 14:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U8j2LsDn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8FE31F000EB;
	Mon, 23 Nov 2026 14:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795443571;
	bh=IAXFOlKyfgOIfd7LKbnq7QQpi2lY40FSmuuFoCMyJZs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=U8j2LsDnN/S8+T6jlyDmDlxpZ/touQedZbkofySlh7PbHZK9UI3W8yme10sToyGjg
	 1tBnP61Awu0MEaBs+3225ZvVz4glesM2e7WqqAED3ShgGFtnDzcMHkFUqYLcq0Uq3D
	 ZKH6IQ/ooZeOc54pebaXBUJ6HLt9qnmyeF9JzJeQ+iGNOa6kJCBD951pZDjicbkFhu
	 PLJmZ+9ayO+p690JsLlvaAJjtdecJTFVE6CXMMdolQms615rtV92yfYybrniuesVWK
	 JnZCbXVhkLOZzv+F66NbpvIkwqNMMP3e4ots1VwJsFWwu7ZxcFIxi6+AvcsFOXJL77
	 Ivu2F4RhybWug==
Message-ID: <sashiko-outbox-229387@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-rc] RDMA/rxe: Fail ATOMIC_WRITE WQEs whose length
 is not 8 bytes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrew Stellman" <astellman@stellman-greene.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261123140625.64448-1-astellman@stellman-greene.com>
References: <20261123140625.64448-1-astellman@stellman-greene.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 14:19:31 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] RDMA/rxe: unreachable atomic write length check in
  rxe_requester()
--

commit 53a7ca51888beabddbfd557ad8447b0102b0d59e
Author: Andrew Stellman <astellman@stellman-greene.com>

RDMA/rxe: Fail ATOMIC_WRITE WQEs whose length is not 8 bytes

This commit adds a check in rxe_requester() to fail IB_WR_ATOMIC_WRITE
WQEs with IB_WC_LOC_QP_OP_ERR when the payload length is not sizeof(u64).

> diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/=
rxe/rxe_req.c
> index 6e01fb18893bf..962aef824ccc2 100644
> --- a/drivers/infiniband/sw/rxe/rxe_req.c
> +++ b/drivers/infiniband/sw/rxe/rxe_req.c
> @@ -824,6 +824,11 @@ int rxe_requester(struct rxe_qp *qp)
>  	mtu =3D get_mtu(qp);
>  	payload =3D (mask & (RXE_WRITE_OR_SEND_MASK | RXE_ATOMIC_WRITE_MASK)) ?
>  			wqe->dma.resid : 0;
> +	/* use the local copies: a user QP's WQE can change under us */
> +	if ((mask & RXE_ATOMIC_WRITE_MASK) && payload !=3D sizeof(u64)) {
> +		wqe->status =3D IB_WC_LOC_QP_OP_ERR;
> +		goto err;
> +	}

[Severity: Medium]
Can payload ever differ from sizeof(u64) here when RXE_ATOMIC_WRITE_MASK
is set?

Earlier in rxe_requester(), req_next_wqe() copies the WQE into the
kernel-private buffer qp->req.send_wqe.wqe and forces wqe->dma.resid to
sizeof(u64) for atomic writes (added in a668a8564748 ("RDMA/rxe: copy
send WQE to kernel buffer before processing")):

drivers/infiniband/sw/rxe/rxe_req.c:req_next_wqe() {
    ...
	if (unlikely((wqe->mask & WR_ATOMIC_WRITE_MASK) &&
		     wqe->dma.resid !=3D sizeof(u64)))
		wqe->dma.resid =3D sizeof(u64);
	return wqe;
}

As a result, this new check is unreachable, and an IB_WR_ATOMIC_WRITE WQE
with wqe->dma.resid !=3D sizeof(u64) will still be clamped and sent as an
8-byte atomic write instead of failing with IB_WC_LOC_QP_OP_ERR.

Also, because this check runs after check_init_depth(), if the clamping in
req_next_wqe() is removed, a malformed atomic write WQE would consume or
stall on rd_atomic credits before failing.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123140625.6444=
8-1-astellman@stellman-greene.com?part=3D1
