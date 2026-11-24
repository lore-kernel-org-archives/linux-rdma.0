Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795531463;
	b=Vju+cnzxQwirJ20PWAkMKqYo8VlslMdm0wUjd9boCrVzLVqASrW69QT2dxQVXLLT8wPx
	 HowhxkteccV8b93uwUxhH9xzmG28xINMrbMdYUZyRbFqjEbZwNVMeD4Cyg9wa6q7dIxle
	 lfRMzBciMcqhHFJnEZOZi8q3RIKyVEfjCqfgIzcApjvyR5hihfBf3zhnG/UN5FPQx9d1v
	 FsseFtJoSDGSonOP7mcOdFbWGj6YpkqB1H4XIM2K6z4FLKQJMv4846KRXsffPgYHoKlx9
	 PONRQJKoPr0BjN6cBXzxhVeHA+yLcZRsv0vtXCl1M4g4elD+OOiAUQVTDMEq467d26A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795531463;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=T1IuR6AMGVikpecUaYqpWjoZc/RUPudxFkhEFjjMgz0=;
	b=Y6zom+1+M237nHgb4aoDahXIgSUoQUtw+ZtKdSd8IusBMkHh+uJd9KjiZrPwLqCWl35L
	 zhGOGko4V4gV3fvU+7l3uVRp2QOtQCdGMo0APx+6Vl9plhow5BuJ8CQIrf5bqqHqxLV73
	 6dKMW4Q30Rvo41sMZ/MGeaaNn9XTDqrzrkmhE8gZ6/nUJ9nv0Qo0YC+xj+aq4sxIRTJHJ
	 Fhyjr/cVV+yhWsZVirtEdHM+IZvAvk9FO6B4tWpcjjG/wArTS1yQgo5tFHhn6b9Amc/GR
	 djlQwPWCCv4BoBYd4e/MZG9Bokh9fF33us7ecf0ytmVFVA3TQjSiLdZFQYTalIChn4w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cloud.ionos.com;
	spf=pass smtp.mailfrom=ionos.com;
	dkim=pass header.d=cloud.ionos.com header.i=@cloud.ionos.com header.a=rsa-sha256 header.s=google header.b=In9mRvW7;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.52
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07362606A326
	for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 14:44:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07362606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.a=rsa-sha256 header.s=google header.b=In9mRvW7
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6bab10842f8so3992831a12.0
        for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 06:44:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795531461; cv=none;
        d=google.com; s=arc-20260327;
        b=FqDhD7dsgt70vNaQDcay3Gpo2h8pivliZIOaDXTP3cd9X9OtwDYvtaftYkgW9EYvJw
         VdHabuSNP4mGxkpwHsyK0gS6IbGzKLM0D+Ki9k5Q1SVkqz8bLA17LlEurOEnZRRp2UXL
         U8tgFA/4VNe4245iy/82tgmpP/ICvZ+Ff0JqSepEeCa+J/xd3xgYwfQzF5oc2Ba2zjlU
         pyL4f9yuS3LxDUU218R/tg/fA/TGk7x+ljAPIKqwCjYn65yW7tOpRqJvWeFeGmKoyKv5
         rGGM72HGdib4Lrs2hJ70oLbOggmfgMc0/iqLK7wMrIw1CNTZR4bY3YiVqOfWBq2paFEV
         4sfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=T1IuR6AMGVikpecUaYqpWjoZc/RUPudxFkhEFjjMgz0=;
        fh=PVRZ7bnWe/UogpGgKhCcEPnnlh4h1FYaRMLpw1VyyFw=;
        b=m7k8mHKZ3sY0CxcEaBb+rbwKDjANRd/dtDlOA3liQBG4FMwC3mrruJOPdVwn9qojmi
         clhnMXzeFObur3URKNQ6v6lBZNN+Yl6p8t/vjXvTHRqj7QYP1hnZwwa1Ur+x6Cim7+ZH
         pzKUWK5j5VyGd6+2Kfk5X4iqAQSjzNHZFBIr52r73NN+ORDv8PXqYOr7dnENCF/3qxQO
         1ybWkAufXvCScgNIH9Fcd7VAsF7lg4mb+MrzH1Y558R1bkOsE59e/bQuJ8zw6181W/YA
         EOnb157oa/pozoOhTCa+gXOrzVRsFzk98+WN2+ONu1fcPHIUVufe1k7PXv0LeuCojC1d
         jC9A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1795531461; x=1796136261; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=T1IuR6AMGVikpecUaYqpWjoZc/RUPudxFkhEFjjMgz0=;
        b=In9mRvW7XSuQWpCn4CKU64x+v+M/d6xJM+68Rb2nPZeq+veWgQwp5kX0LWFRhIb25p
         t7u+WCDp3+8M4tZx1Yl4S+MuDxGwXQxZwmH81MNdUsYrPWZUFPzOmUm/eyB2gEAbxuV0
         me441G2kndSPJJFw+FN1MWleAxRzJJw38xZZZFCdOHUHuEfPamgZTc72/JEfKtGL5Th6
         AcAdDNphTG/2zGgUSrREL11fdgs/omnWfT2RSltUad5QpqRqPwUA+452gMYZIngNOo9I
         Sbqwg3p3Jg7khB1wj/yzKw3eHj1zpYP4Cpu8aEQRyJtxg+H1eFJLGrdnlcKod0FCH3Bo
         Rp8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795531461; x=1796136261;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T1IuR6AMGVikpecUaYqpWjoZc/RUPudxFkhEFjjMgz0=;
        b=iNx57Bu210JwIm1kkF41w/nefD9uL5cUBCC4+Qhlm3IYDCJXS6ukDiT1HAeM7f0w9p
         mwAlAqoyq8rhA5mAv5LhzFYHRvAVoQUc3Xljuair7oDfOdwT2Ju6Rw20XKVBQ9EACeGj
         sjxOMZ0WgZGAHUBaO5ruSnslHEX3N2/c6zaiwoUxdK1+GR7h0dygEHsq4vD2eQR0RaNe
         G3B3CrHqs5NSTIPGw6jqHSFB+lHKmShnAg9jL1tBK5OtfRrTNVc7hYm8+bDWIbQ7esBi
         xpz8lRTrUQ1q94IGeUQme5+3Nsh6ZXNI0LADZgXLm+7jV48fHN6QCviU8o1UYqMYLiV5
         NOvw==
X-Gm-Message-State: APuU4Z/k6hne+x1Y7crrWug0TyrSzqyDPVX0CmyVQtc1SUo55bCUbIpv
	fz6p/4ZiDMXxj7c14OLkAsro1wfMCkrglGW26cPxMughKPGkGuNmMGq1AGp80rF9QDAMCVQcioe
	fPQroZC4ZGDm/qXqBxbYuo88g6IHJROyPk7jdMS6yWA==
X-Gm-Gg: AZFdTZfUqrnZLCcezzbQR6IdPSeAMHyJNP7zCnxRpsMgBa3Dz/Lmey2ylJvtrFCKlMM
	72gUfhzSj6KZuZ05pPY7bF0DK4W8vznDXQztxcecHu7o7yHLfAxs8X86PX1APpMPA6dWtThDAfP
	nO2UF3qeBrc3PWn9obriUR6ZDkYn59pJX4cwKiLoMjxDb9Vybpf+PgOV0dsz3aJ2LRt94/6Ho5O
	q6sY4hMzciVz93HW2nPV3VgegGffKfXXUdj1BnkdZE3vC0UMbGDxZGxqte63kfsekXEcU7Br2wm
	KrgGnILtQx05I6D35qNpbgvhykKtAH75dBTXjdr1sb6zSXN+nY+cZ/MAYEOYaKb4SBDGqwba+VL
	FZ55foSHY6Fdr+kQ/+Je2cUAURytZLGRvgOG/hCtkYaCvPmjMWEVTXxK/pHd9Oq4g+ba8NnMv/s
	QwjAoo5YZe5t2bhENq9w4tRag8+rhjrb7qJcCTb90p9nwz09HynT7qFN4BvUngdg1vI9daZohYk
	BM9oEmvISeubEMxbXkwO3ab
X-Received: by 2002:aa7:c25a:0:b0:6ba:13ce:6165 with SMTP id
 4fb4d7f45d1cf-6ba1fc1c63fmr9362514a12.15.1795531461258; Tue, 24 Nov 2026
 06:44:21 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261123143719.938876-1-haris.iqbal@ionos.com>
 <20261123143719.938876-4-haris.iqbal@ionos.com> <sashiko-outbox-229468@kernel.org>
In-Reply-To: <sashiko-outbox-229468@kernel.org>
From: Haris Iqbal <haris.iqbal@cloud.ionos.com>
Date: Tue, 24 Nov 2026 15:44:10 +0100
X-Gm-Features: Aa3M54q-ObbKvJOkH9qfhofxOtj3zvxYdYeoMBGSRe8sDWnU17Uevjpj2XqjTXY
Message-ID: <CAJpMwyjdn82+n+b7_M8VaFrDUNoCSF=FV91kxyMMmQCHdH0k_Q@mail.gmail.com>
Subject: Re: [PATCH 3/9] RDMA/rtrs-clt: Trigger error recovery when posting
 LOCAL_INV fails
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org, Jinpu Wang <jinpu.wang@ionos.com>, 
	Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 23, 2026 at 4:02=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [High] RDMA/rtrs-clt: early return in complete_rdma_req() leaks DMA
>   mappings
> --
>
> commit 61b2b66e033c3217c1bebe6348e99899004f5550
> Author: Jack Wang <jinpu.wang@ionos.com>
>
> RDMA/rtrs-clt: Trigger error recovery when posting LOCAL_INV fails
>
> This commit clears req->mr->need_inval and triggers RDMA error recovery
> when rtrs_inv_rkey() fails synchronously in complete_rdma_req().
>
> > diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniban=
d/ulp/rtrs/rtrs-clt.c
> > index de226e6ba1246..5ef912a472cda 100644
> > --- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> > +++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> > @@ -436,6 +436,19 @@ static void complete_rdma_req(struct rtrs_clt_io_r=
eq *req, int errno,
> >                       if (err) {
> >                               rtrs_err_rl(con->c.path, "Send INV WR key=
=3D%#x: %pe\n",
> >                                           req->mr->rkey, ERR_PTR(err));
> > +                             /*
> > +                              * No LOCAL_INV completion will fire, so =
the
> > +                              * rkey is still live on the HCA but we c=
annot
> > +                              * invalidate it from this context.  Clea=
r
> > +                              * need_inval so subsequent reapers don't
> > +                              * wait on an invalidate that will never
> > +                              * happen, and kick off error recovery so=
 the
> > +                              * QP (and MR) is torn down cleanly via
> > +                              * fail_all_outstanding_reqs() ->
> > +                              * complete_rdma_req(can_wait=3Dtrue).
> > +                              */
> > +                             req->mr->need_inval =3D false;
> > +                             rtrs_rdma_error_recovery(con);
> >                       } else if (can_wait) {
> >                               wait_for_completion(&req->inv_comp);
> >                       }
>
> [Severity: High]
> Does complete_rdma_req() leak the DMA mapping on req->sglist when called
> from fail_all_outstanding_reqs() on an in-flight request that still has
> req->mr->need_inval set?
>
> During recovery, rtrs_clt_stop_and_destroy_conns() drains QPs via
> stop_cm() and then runs fail_all_outstanding_reqs(), which calls
> complete_rdma_req() with can_wait =3D true and req->ref =3D=3D 1.
> complete_rdma_req() increments req->ref to 2 before rtrs_inv_rkey(), and
> neither the if (err) branch (when posting to the stopped QP fails) nor th=
e
> else if (can_wait) branch (where rtrs_clt_inv_rkey_done() only signals
> req->inv_comp without dropping a reference) decrements req->ref:
>
> drivers/infiniband/ulp/rtrs/rtrs-clt.c:complete_rdma_req() {
>         ...
>                         refcount_inc(&req->ref);
>                         err =3D rtrs_inv_rkey(req);
>                         if (err) {
>                                 ...
>                                 req->mr->need_inval =3D false;
>                                 rtrs_rdma_error_recovery(con);
>                         } else if (can_wait) {
>                                 wait_for_completion(&req->inv_comp);
>                         }
>                         if (!refcount_dec_and_test(&req->ref))
>                                 return;
>                 }
>                 ib_dma_unmap_sg(clt_path->s.dev->ib_dev, req->sglist,
>                                 req->sg_cnt, req->dir);
>         ...
> }
>
> refcount_dec_and_test(&req->ref) drops req->ref from 2 to 1 and returns
> early, skipping ib_dma_unmap_sg() and the clt_path->stats->inflight
> decrement right before fail_all_outstanding_reqs() fails over or complete=
s
> the request.

This is a real bug. We verified it internally.
And as mentioned, it is unrelated to the patch above.

We will send a separate patch for this bug.

>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123143719.93=
8876-1-haris.iqbal@ionos.com?part=3D3



--=20

Regards
-Haris
