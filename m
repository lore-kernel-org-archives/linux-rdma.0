Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794404855;
	b=XUJP9XjHDJGy7jMsF9FM1fPrnQEc5UMK2Afhk9pyPVYBTwSZDyS8DWw+ziXBT8WPLAB7
	 vQcG96XKadsYBLSq4xsZg+L4CNJ/uqW8NWm8ebYste0I1JjmTccgMrvdPU2w6OdEupbTE
	 ciiX5et+EEketvqVObiyku1486NqNZEpypiRgYj+7QgRXpSLP/25RqRvcP5f/SqrkA9lQ
	 Rj9biIsyTlc/3Qm4GEd4DBeX9ZadNxzGZLofC4Fmot0fZTiR13vv/1ZeGawgKL7cv4ALd
	 kIz92H7rciFAu9GAWlVyDFcoAG5UV90LMF1ah1xxuh+QLKWq3u4cyrWOwEG8ToOWx2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794404855;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=G2Qbnq+c80yPFxQkgzthFx4dWO5qEddBNDQfDjfND9g=;
	b=Qe1F2pjd3YiIB5+GL6aPrSjlQxXnInqcB9Wd7Xkk9fgIBqOHfkmkHKxiJp44sduGbyUJ
	 /KqbENlED/SFydO62Dim1gQUSyzwTZaa+bR26BsKB2I2OLj2JhjlUtvHjiJ1tHmAHYTuv
	 1raGtPZt4qyh5HYrxv/ZJvLkb9SBW3NNNwgIt3OQ+QrPkuOrqUdOjqOGl99SGgK5li0UA
	 j6TWkK5DUy1HF0zoaZrqnHPNPhLRZkrbxdjo4vr9ozfv/etMjNvz96jdTRsAupoCl9vWt
	 jifJIp64KqW2PTLfriIWabJFoOmOV+SwzU6rOLa1Ia54l+TlYTw0Yjx2Gk8d9K6pwyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SaoxCeIM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCEE0606A330
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 13:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SaoxCeIM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 733331F00A05;
	Wed, 11 Nov 2026 13:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794404855;
	bh=G2Qbnq+c80yPFxQkgzthFx4dWO5qEddBNDQfDjfND9g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SaoxCeIM8bQDh3p4T8HEznA8tlGhKpTJq7UlZSeWY17MxL2V8/d1JaxblBqzH8HJO
	 CU4FzLXpJg71kOKdLnY7jpBRbmetIJ4qcfwqbCd3462y+reQju70NZOOsNc4Xq7+iv
	 mQSvG8Zxt3LWafk/oJxrJeA0aB7iX/vpb/Q2cyk75z0X33nRY538LO0OSVwO1irJFi
	 gPdMvdF0gvKegJ9g8SQXcuurBRFccglnWeWExq536H/ob9VHaeFexcs3BIwb1QZett
	 uOKU9vKWN04QWpG8wdT5OkI3YSP0Z/XcPOzspWMNLTWKitZ7eSrzX/nW8BKEzTngRb
	 WHQ97+ywno9IQ==
Message-ID: <sashiko-outbox-209110@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v10 9/9] RDMA/mana_ib: Handle error CQEs for
 kernel QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261111121417.1265896-10-kotaranov@linux.microsoft.com>
References: <20261111121417.1265896-1-kotaranov@linux.microsoft.com>
 <20261111121417.1265896-10-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 13:47:35 +0000
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
- [Medium] RDMA/mana_ib: race in mana_remove_qp_from_cqs() when send_cq
  =3D=3D recv_cq
--

commit a21cd9814010904d171e9602dc8b61668d553074
Author: Konstantin Taranov <kotaranov@microsoft.com>

RDMA/mana_ib: Handle error CQEs for kernel QPs

This commit decodes hardware error CQEs on kernel QPs, defers moving
failing QPs to the ERR state via a work item, and cleans pending CQEs on
QP reset.

> diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana=
/qp.c
> index c021e58817628..837e5c46ed778 100644
> --- a/drivers/infiniband/hw/mana/qp.c
> +++ b/drivers/infiniband/hw/mana/qp.c
[ ... ]
> @@ -774,15 +777,19 @@ static void mana_remove_qp_from_cqs(struct mana_ib_=
qp *qp, bool reset)
>  	list_del_init(&qp->send_err_node);
>  	/* Keep shadow reset serialized with hardware polling and SW flushing. =
*/
>  	if (reset) {
> +		mana_ib_cq_clean(send_cq, qp);
>  		reset_shadow_queue(&qp->shadow_sq);
>  		reset_shadow_queue(&qp->shadow_mmq);
>  	}
>  	spin_unlock_irqrestore(&send_cq->cq_lock, flags);
> =20
>  	spin_lock_irqsave(&recv_cq->cq_lock, flags);
>  	list_del_init(&qp->recv_err_node);
> -	if (reset)
> +	if (reset) {
> +		if (recv_cq !=3D send_cq)
> +			mana_ib_cq_clean(recv_cq, qp);
>  		reset_shadow_queue(&qp->shadow_rq);
> +	}
>  	spin_unlock_irqrestore(&recv_cq->cq_lock, flags);
>  }

[Severity: Medium]
When send_cq =3D=3D recv_cq, can a concurrent mana_ib_poll_cq() between the=
se
two critical sections flush receive shadow WQEs whose hardware CQEs were
already invalidated?

mana_ib_cq_clean() checks mana_ib_cqe_matches_qp() using cqe_info.is_sq,
so the first call invalidates both SQ and RQ CQEs for qp in the shared CQ.
Dropping cq_lock before unlinking qp->recv_err_node and resetting
qp->shadow_rq opens a window for mana_ib_poll_cq():

CPU0                                CPU1
mana_remove_qp_from_cqs(qp, true)
  spin_lock(&cq->cq_lock)
  list_del_init(&qp->send_err_node)
  mana_ib_cq_clean(cq, qp)
    /* invalidates SQ and RQ CQEs */
  reset_shadow_queue(&qp->shadow_sq)
  reset_shadow_queue(&qp->shadow_mmq)
  spin_unlock(&cq->cq_lock)
                                    mana_ib_poll_cq()
                                      spin_lock(&cq->cq_lock)
                                      mana_poll_cqe()
                                        /* skips invalidated RQ CQEs */
                                      mana_flush_completions()
                                        /* flushes qp->shadow_rq as
                                         * IB_WC_WR_FLUSH_ERR */
                                      spin_unlock(&cq->cq_lock)
  spin_lock(&cq->cq_lock)
  list_del_init(&qp->recv_err_node)
  reset_shadow_queue(&qp->shadow_rq)
  spin_unlock(&cq->cq_lock)

If recv_cq =3D=3D send_cq, unlinking qp->recv_err_node and resetting
qp->shadow_rq inside the first critical section (and skipping the second
lock acquisition) would keep the CQ clean and shadow queue resets atomic.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111121417.1265=
896-1-kotaranov@linux.microsoft.com?part=3D9
