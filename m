Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795587558;
	b=0mHHpJehk8vUiPiZX3RieoXgoKrWGgY892qJtm1f5G4jxVMHZKNn624sBrm88+zWo0vh
	 f4gMgappfwgH3778Vib+Fula8GCVaK7gohdK43kdHherMN6IJmWnCg22K9Pu1Dsa2NObE
	 M9/Qfk2DXhy05KDMleU7UcUmOS8OEeOCD6QOTjFj288rQ0v2RfBeEB3SbgPFuUZqY27x1
	 TifiGyzZakGrQK0UfPXV1E55WNkxRk9h/ld0+zRkGSSOQ4wnH5UNY1f3tfOfAKk7159TP
	 qMBjv2OD1in5eET9hdQBrxbrGCOWb5yr1eBUvA2MSMdIj3S7DMJlkZjrZBkGHmfxniA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795587558;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=7ModZTWshL37R2oIlK6xPJt89BfvMPH1OsprHLsEXyk=;
	b=TL3XZXNKFJpP641ozP0Y5NKGM2ljKH/XlhRzllrym/y2TGDzsGolSMV1tbWrCrRqAocV
	 zF4f3i9K59qkazG+VOJcyymJMqfx1wEox752w1KLuX1CXU49od/4XbGWDqkOM55Yzw3Y2
	 mVjTSjXFKyvcw0tGk4Z20YYnKphaErBXhKWzNMIS1yyeHIc/DuqjY/pGeMhSyHhg9KbSh
	 Calu6s3bhA6oY4/4KPB9gQ23A1sf0NysZ3hGdgshu5taF1VACevh+hMOpwSkkhA2A9bLY
	 F+9ohwlDXcbPHYPsH6fitB56YCNK7NcWfsjiD3b6MAcjsCkyFaZdUZkQpwHPyrw0mtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X0VO6d1j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CBF606A326
	for <linux-rdma@vger.kernel.org>; Wed, 25 Nov 2026 06:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X0VO6d1j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CEFC1F00342;
	Wed, 25 Nov 2026 06:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795587558;
	bh=7ModZTWshL37R2oIlK6xPJt89BfvMPH1OsprHLsEXyk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X0VO6d1jrWKQJWX8+nOSl00ryOM+rNhCjRjL7vUs4qHyKg+CLoKzUcFnRehDuZrwW
	 KiFEJp1uEdYGWaBGa4J0eswJnlw1K76XvcBk5pYLC+4MX+PRinc9b/IyBfYgZkpYG5
	 5N0akJzFoaA2S2rQGpV4qUPiJxXR+C5oJK4+vP8tvvEcJlk2Jwz5dhw6hVDPFKPaJu
	 16SLcdsq5V36F4yOT5DYyTKeBbPjO9JajpkOxLAxpcfji8MzVcCl/P5IHoe1AlSOHA
	 UrhxqeBw6quUswU9DXRQKXih0qG3Ko8hpSxF196AjtOXQ90PgGsz5zrpkqnNCUdjcm
	 /6Ar2AEYlWwaA==
Message-ID: <sashiko-outbox-232671@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/siw: don't complete a fenced READ twice on flush
Reply-To: sashiko-reviews@lists.linux.dev
To: "Cygnus Qiu" <eritque-arcus@ikuyo.dev>
Cc: linux-rdma@vger.kernel.org, "Chuck Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>
In-Reply-To: <20261125060646.155172-1-eritque-arcus@ikuyo.dev>
References: <20261125060646.155172-1-eritque-arcus@ikuyo.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 06:19:18 +0000
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
- [Medium] RDMA/siw: data race on tx_ctx bitfields clobbers orq_fence in
  siw_sq_flush()
--

commit 2dacef6eebec78b6dccffd22a13876b9c48ca403
Author: Cygnus Qiu <eritque-arcus@ikuyo.dev>

RDMA/siw: don't complete a fenced READ twice on flush

This commit gates completing a SIW_WR_QUEUED READ from the TX slot in
siw_sq_flush() on qp->tx_ctx.orq_fence so a READ already copied into the
ORQ is not completed twice.

> diff --git a/drivers/infiniband/sw/siw/siw_qp.c b/drivers/infiniband/sw/s=
iw/siw_qp.c
> index bb780e3904a21..2cc0f466e757f 100644
> --- a/drivers/infiniband/sw/siw/siw_qp.c
> +++ b/drivers/infiniband/sw/siw/siw_qp.c
> @@ -1188,10 +1188,11 @@ void siw_sq_flush(struct siw_qp *qp)
>  		if (tx_type(wqe) !=3D SIW_OP_READ_RESPONSE &&
>  		    ((tx_type(wqe) !=3D SIW_OP_READ &&
>  		      tx_type(wqe) !=3D SIW_OP_READ_LOCAL_INV) ||
> -		     wqe->wr_status =3D=3D SIW_WR_QUEUED))
> +		     (wqe->wr_status =3D=3D SIW_WR_QUEUED &&
> +		      qp->tx_ctx.orq_fence)))
>  			/*
> -			 * An in-progress Read Request is already in
> -			 * the ORQ
> +			 * A Read Request is already in the ORQ unless
> +			 * a full ORQ fenced it
>  			 */
>  			siw_sqe_complete(qp, &wqe->sqe, wqe->bytes,
>  					 SIW_WC_WR_FLUSH_ERR);

[Severity: Medium]
Can a concurrent update to qp->tx_ctx.tx_suspend clobber
qp->tx_ctx.orq_fence and cause siw_sq_flush() to drop or duplicate the
flush completion?

In struct siw_iwarp_tx, orq_fence and tx_suspend are u8 bitfields packed
into the same byte:

drivers/infiniband/sw/siw/siw.h:struct siw_iwarp_tx {
    ...
	u8 do_crc : 1; /* do crc for segment */
	u8 use_sendpage : 1; /* send w/o copy */
	u8 tx_suspend : 1; /* stop sending DDP segs. */
	u8 pad : 2; /* # pad in current fpdu */
	u8 orq_fence : 1; /* ORQ full or Send fenced */
	u8 in_syscall : 1; /* TX out of user context */
	u8 zcopy_tx : 1; /* Use TCP_SENDPAGE if possible */
};

siw_activate_tx_from_sq() and siw_check_tx_fence() update orq_fence under
qp->orq_lock, whereas siw_cm_llp_state_change() sets tx_suspend =3D 1 on
inbound TCP_CLOSE or TCP_CLOSE_WAIT without holding qp->orq_lock,
qp->sq_lock or qp->state_lock:

CPU0                                  CPU1
siw_activate_tx_from_sq()             siw_cm_llp_state_change()
  spin_lock(&qp->orq_lock)              /* load shared bitfield byte
  ...                                      (orq_fence =3D=3D 0) */
  qp->tx_ctx.orq_fence =3D 1;
  spin_unlock(&qp->orq_lock)
                                        cep->qp->tx_ctx.tx_suspend =3D 1;
                                          /* stores orq_fence =3D 0 */
                                      ...
                                      siw_sq_flush()
                                        /* orq_fence =3D=3D 0: skips comple=
ting
                                           fenced READ in tx_wqe(qp) */

If the clobber loses orq_fence =3D 1, the fenced READ is never moved to the
ORQ and siw_sq_flush() now skips completing it from tx_wqe(qp), hanging
callers waiting on SQ drain.  Conversely, if tx_suspend =3D 1 races with
siw_check_tx_fence() clearing orq_fence =3D 0 after copying the READ to the
ORQ, restoring orq_fence =3D 1 causes siw_sq_flush() to complete the READ
from both the ORQ and tx_wqe(qp).

Making orq_fence (or the concurrently accessed flags in struct
siw_iwarp_tx) a separate u8 field would avoid the shared-byte read-modify-
write race.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125060646.1551=
72-1-eritque-arcus@ikuyo.dev?part=3D1
