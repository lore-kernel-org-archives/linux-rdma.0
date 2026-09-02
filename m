Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082544A8A13
	for <linux-rdma@vger.kernel.org>; Wed,  2 Sep 2026 16:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367739; cv=pass; b=WAkIVYMzN0j3V40mx2L8f0hQn8F2tVkh+hBRDdPmsbCH/50YnBhZh5xyZI9391kKtKmAmSS+XraBiEwJ27DjDLiHA49E1UedY7/YSpkCRKeQ9bF/KFBzRrweE0R+LdepVCkEZLYjlFXy1bJC8PVFt+jY9in+WQ0t0WVmswQ2CgI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367739; c=relaxed/simple;
	bh=XYkJRYoV1HNAeSeUYGdPMaepouf9MvMiK/gkMich3kY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EU3yDENW7vDCEctz99+QyZLN9RbDN6uIf1N+kaEaohFj2z7oFC5B+q26otT43P3XzflwuNAQrAxokTqRIcHNT4CWPp3iGuUUCope07iol5OgQf6xXGdCSwnrbfbKXmPSzzgLQl7fiZi/rpLj2cjfhGzbNyIEiDm7Emf18KOoGlw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b=CTOdsFHI; arc=pass smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="CTOdsFHI"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c166ec26696so21156166b.0
        for <linux-rdma@vger.kernel.org>; Wed, 02 Sep 2026 09:48:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788367735; cv=none;
        d=google.com; s=arc-20260327;
        b=XPTP2ZKPSw2JF196puf1QRhAPSzpVkKC4gH5DCuZEfGr7eJEdelEkJKxriuTyM1cjv
         eKSzWbbPfXiaKc6t9ytfpiVcCKv26XoNMElNvZJfPo4R5K2IWJBDiRFdWQtfMzPM4s8C
         sq2m+K7L19x70NOVFNzm7WpaY8wROSl7aRIXYHJEeHUNdRCGaqfU7wHbFDdU6sdCEKbd
         ZIdzYeDT0ty9W7z5FoNsF9gNV7vLc0UdTukJr+H6P8t1f2z1YMKhrRbonxfOsX17Yh3l
         w5Wwzw9AhlDv0lVoc2EWR5jo81H5xsFG15dafqDLeqSybqZX8s+7SZPVFVnrHsSILH7D
         gfVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=c+zZDLZrzFygr/kaoUDVb3zzLB8Z2nkBsMg0+94/Yy0=;
        fh=RpxXL5vOWhxP3wQtZ9ECJZGzQGzD9IXkhBhZ2uvkXwQ=;
        b=mqnzXvwtTw0kPopyZZxdrsbsEVaSmKNR8v+x7tEnwTuk9TuLxLRrllY2A/b89AP0uj
         tXaxVdanCE1R+XBKhV6u9uqF+oh9bBBe24LqwyhEjTaOVdwii3nKXHfPpsIsDeXMq/mq
         PQjnYrK4fyVtRTtU5Z5ExuTD7XaCLtAo19N1EPCs4iy6aS5QP+lsrYsHWoeiMWJ4fBXF
         P6DLEYxBQNrxRVNBGpwH2fu53MV4tIQTx8POHjBKXC6AzeQ4QUC82sgatruU5wyVdylh
         di6zCPsNxq5OQp06hat9nDIyuOoUiUCqVfpzUsaNshJyk7YnWp6m06AgjPRPo3ZwXxBg
         V1dw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1788367735; x=1788972535; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=c+zZDLZrzFygr/kaoUDVb3zzLB8Z2nkBsMg0+94/Yy0=;
        b=CTOdsFHIj00YsZ/DQEeHqPdgEuI6/fqQdVbKeKk1rVmoE3jlI1lcpP+jZ/AeHAs256
         SEeSfAzFwEpYVgWCRUkvB+WR6KJPC7HvIGj6n0V1Zg6lxdGuF1MQU1XDC98QbFwix9G8
         qyVyw8wM6wVMrwGxxTM7lKmyz7hrw//2utj1qdsMyKzl1Y6SD9zdW57/ow5Z9TOJVhhk
         tGmHFbYXJc+e6cvCKgmPfaitojykqcqhzlr4au60nP9oRZeqJxH4dUbtEnG5qYoxtsFH
         vNFSrXSBLsM4kk1V1LtJAubixWGtQzjUW/QP4tYVzvRpb19RkbvHxRB0sdO/IspuPdVc
         0Y0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788367735; x=1788972535;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c+zZDLZrzFygr/kaoUDVb3zzLB8Z2nkBsMg0+94/Yy0=;
        b=g4i2vr+zz3LGWeLDUFvNlHG+Yrj6x5hdsve7/uXKeB70/5H9oZ9uNn3EJ/PDXhotmQ
         /1x4mhSKsF//i2ZTfAS3mjuwAcEtHRid8x87S1AkSFPYJXHkVZsacj2K84HJTIqWAG5D
         xAiZ4m03TZ0XFxZ0fnIOV/d1fte3EXryaekrSniGVY5M4WoZB2BzW83JuwB8jpJFFBMW
         yaUdInX7t6M0DPEmtLwa1wM39s73YwKz9mETXhLw3+WjRV1FBZN4AgAh0KcaRPoeiSoQ
         sKJzO/3rg6YtaOQ8m4zjtuZ5O9eCjUBEgXXGc5UXA/oct/Kw/A/XJGw+pVmIcAvxIIlF
         y/NQ==
X-Forwarded-Encrypted: i=1; AKwUvBwy4HZY8qIWnv70lwyFluj+e9IEYVb2XYNg4Xe88qoUJVO6UI7eev3wMTAp4C7q+mmLP8hQ60K0wke1@vger.kernel.org
X-Gm-Message-State: AFuF++l4HLcIDUzoXK8uFunOXgCFZGWpgez98plmoGU8M62VHVVMRvnw
	GTV1g+rl8lnk6J3E6CudRYr8JpdoHJnBIOlL478YFYSqD6tC3CVIi5FhkTeyBkWbJMzfpFzgc0T
	3xxILDSRysSCeU1PRzVsm2EOZq5dHvXZUq/VWmoyCnw==
X-Gm-Gg: AYBFou1jx8OZKC+HqLShOsgA2cpMoy9dxg7P9KOPMxt9CtjhHfvCJTgNYlmrrHBK6n8
	oxhdZnwK2Vw64Fb0AHv6NT9MhYOWQvzEyXLxNzAZi27ZWEdctWpAH9M2nOJrqGJ00E65i8HDb03
	nRgPWG2TqBzxNkC8mazViqNxrngsUhjRDyORoy0RzYWbQ5nnEhFq0XB90Pv7/q54Mq1Ir/yOyE/
	ew8pIEFse09cAPnOW2UcwtqRHZ05MjDW/fsywRl5Om0Y+XBCWEZNpCOf1N0ioxaitnzOBXIad3V
	KQg6EIkrl0Sw9EcKM2WHRAnOUPRIZGUwczB/hw5lY2eSK1Cs+kQO0/yq9Qaih0cnzxvA4oiq2Cj
	Pl80oyZVAGu0F
X-Received: by 2002:a17:907:9405:b0:c25:2ded:ad36 with SMTP id
 a640c23a62f3a-c25d4c9659cmr211413866b.0.1788367735185; Wed, 02 Sep 2026
 09:48:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260830-rdma-rtrs-clt-cq-pool-leak-v1-1-b169434fd3df@proton.me> <20260902162518.GW24140@unreal>
In-Reply-To: <20260902162518.GW24140@unreal>
From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date: Wed, 2 Sep 2026 18:48:44 +0200
X-Gm-Features: AcwNN1XFdGQqS1dSNDFwEx4DS2Ose8g86nKoPp3TAhbxN7pNr8uBNxboksiPoSQ
Message-ID: <CAMGffEmz_QSy2TLM5OBQ5GUaOiRozkLyuTNOXV8f9CnbvhPYSQ@mail.gmail.com>
Subject: Re: [PATCH] RDMA/rtrs-clt: Fix CQ pool leak when connect is interrupted
To: Leon Romanovsky <leon@kernel.org>, quanyeyang@proton.me
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+d396918a29afb8543e1c@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Leon, hi Quanye,

I had a look at the report. The syzbot bug seems to be triggered with
smbdirect (ib_dev[syz2] removed), so I'm not sure how this change in
RTRS client would fix that issue.

Thanks,
Jinpu

On Wed, Sep 2, 2026 at 6:25=E2=80=AFPM Leon Romanovsky <leon@kernel.org> wr=
ote:
>
> On Sun, Aug 30, 2026 at 03:09:55PM +0800, Quanye Yang via B4 Relay wrote:
> > From: Quanye Yang <quanyeyang@proton.me>
> >
> > The client borrows shared CQ credits in the ADDR_RESOLVED handler via
> > ib_cq_pool_get(), before the peer is connected. create_cm() can return
> > -ERESTARTSYS from wait_event_interruptible_timeout() without destroying
> > the CM ID. The init_conns() and stop-and-destroy paths then call
> > destroy_con_cq_qp() while cq is still NULL (no PUT) and only afterwards
> > rdma_destroy_id().
> >
> > CMA serializes the handler against rdma_destroy_id() with handler_mutex=
,
> > but that does not order the GET against destroy_con_cq_qp(). If
> > ADDR_RESOLVED has already passed the DESTROYING check, it can take
> > con_mutex, GET credits, and then lose the con to kfree. Device
> > unregister later hits WARN_ON(cq->cqe_used) in ib_cq_pool_cleanup().
> >
> > Set a per-connection flag under con_mutex before CQ/QP teardown so a
> > racing ADDR_RESOLVED cannot borrow credits after teardown has begun.
> >
> > Reported-by: syzbot+d396918a29afb8543e1c@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=3Dd396918a29afb8543e1c
> > Fixes: 3b89e92c2a95 ("RDMA/rtrs: Use new shared CQ mechanism")
> > Signed-off-by: Quanye Yang <quanyeyang@proton.me>
> > ---
> > Fix a syzbot WARNING in ib_cq_pool_cleanup(): an ADDR_RESOLVED handler
> > can ib_cq_pool_get() after connection teardown has already skipped the
> > matching PUT.
> >
> > Reproduced on rxe with rnbd-client only (no rtrs server): write
> > map_device with path=3Dip:127.0.0.1, interrupt create_cm() with a signa=
l,
> > then rdma link delete. Device unregister no longer reports leftover
> > cqe_used after this change.
> > ---
> >  drivers/infiniband/ulp/rtrs/rtrs-clt.c | 8 ++++++++
> >  drivers/infiniband/ulp/rtrs/rtrs-clt.h | 2 ++
> >  2 files changed, 10 insertions(+)
>
> Haris, Jack?
>
> Thanks
