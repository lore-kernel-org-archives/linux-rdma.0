Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07FB013C9C4
	for <linux-rdma@vger.kernel.org>; Mon,  5 Oct 2026 04:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791176258; cv=pass; b=aXSWIWYoiKaVCpmBk7vIvUuO4/dQ+4mCEz5O/1/yPExMA3rMET/3x7RHgr18fqGGGrxa5Ee5CPy9zvb33tnsJBQTMr8sP8gaMueO40sKcw2d1NdEJGMd4aKmWXFtKzBhBQ346DY8O2R9kEwok6KWiDppJOlTKzpCCfDUeK6/nx0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791176258; c=relaxed/simple;
	bh=DtOfma5MPjlTA7AJUO+fjtKRY4VF59cg25jlM6rQ7Pg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tEWUB2SEGc9kYnJJ9S4upPNGFBWD3ZOqQZNQjJQl1Gs3gmFdqCwQ1lSjnb4PU+i9HQVLof159WRkDX9ManV4AnlYBhXqyMetNuOTGwO09V83sWVXTexUG3/sA4C0+89QTy5M01gOlUj7h9QITNsCDIbzBisFDSXxqCC6EMpVhuw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b=ErXR7xkT; arc=pass smtp.client-ip=74.125.228.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="ErXR7xkT"
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a5d8fe8912so124505a12.2
        for <linux-rdma@vger.kernel.org>; Sun, 04 Oct 2026 21:57:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791176253; cv=none;
        d=google.com; s=arc-20260327;
        b=osBkQDMsuZpTUYB9IWW2/EZDyBij+xtFj47CtmN53m6DHd4uPQ1afJeH1igtafDCNP
         7RtXLeVTX4HJNvD7MePj6GyH3ZmrJSkdPhynlvIG34VEysqWR/6ieTlt5608tAC9BBCv
         /nU2IpnMTDjtVVZbmf2AvQa6ViNKCFbg4u7Q59Kf2I8yw/6vwsvbBzT87/GGUgRUaUFu
         WTmG5HrJko44aoO+y9qgSJ6XYI/MDE7OkNHBMFR3AZz0DQbA60IZ5wMKHdGnDpIwfeA3
         zHGtnRSTUVvBMiyyA7gz/b2LgYmQjff0xnq/jMvrXPzNeq9PswLzQAKY+RiaCSXrzstV
         Uq3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ldf5q0KJzU01llaoPctyqNRPOtaXKGmPGYAJmWxRprM=;
        fh=rB9r9pm9eMBeFPAJJA0BBLt9cE8rKqfoAxgROW25N34=;
        b=X6SDCQP6HYS4ieyGaUKzvyImvDfzJUOncaE9lwhIgZY3on8ONcPEY9e0t2T8cl7Ze4
         Ns+OBVV7Jg7nVVttNUXNlcdcruAztZ7VrMZlGECkQ7pRmPCNuQlohrBgPcS8q1Nho74U
         TDq1GC2684V7knk9uaUM2w7xtVAxsdBCv7WRc6kY1eQExpxMi3NQyI4Ew8oBQ5JkubZA
         2OUqth+17UmFiLvsWHTcIQbh+W7WrkpmeyBy5/i+xiNnOLytOd0EiYQhrC3310dpwt7Y
         hkERuQ8WxF5fslZWzUs4njzRnIGabPtTtk3vglWqVE+TJtWQ0ELyuxRGiuHiCaDs1AsX
         1yGA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1791176253; x=1791781053; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ldf5q0KJzU01llaoPctyqNRPOtaXKGmPGYAJmWxRprM=;
        b=ErXR7xkTtHU9Oce+731OYcl3dITzj9lTiPGkJqAStGNoHqZN5hR/3YYC81EPCPxlvB
         49Mjq9dxUH1HdzrekHAi2DUPPa/+lGiBidoYZzUGKCwaO2Y3jmp4tf98DOxAIth8AjEq
         tUBVFZ/srKNZ63Bvidr+s5G/3z9hpkycEYYITMtO/8SA4BFtYcJossxxQjIpVOPkVa9v
         iZeYQLDXW+OpUTy3BH57Ko+lUdJaIqRuIvxENB6p2JywinZRgZyhHc8cZrS23NHnOT0P
         LIKiFcVk5fGrpJtj46yYPwA99NbuQDebMTWEBVzOA5tz2XoJb4MAhrsekCRVYeoOH4Zt
         v6oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791176253; x=1791781053;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ldf5q0KJzU01llaoPctyqNRPOtaXKGmPGYAJmWxRprM=;
        b=g3Np87JBr0QX93SYi44c/7W5eeCPQcQzpbduRplxnLxUDJFizXrUP+Uh8iDVLCTPZ4
         dcAxSKfeskg6Wh5/8IHLOvITXqYJUu+vbRn4Mb2C5U/LYYpr8ZhEDWH9wT5cffXs3Q9m
         aeKFgcCvgZK+Hqm170lRyBskkl7gYe7+WCROln4WEvFGE1WD8BKB3UuxpIV8S37Mn6d4
         anxwdjMzfXHX0p0nWeCKMHnf7kh3eYA4U2g5Yc7jXdP/X9NeY+MKrrGBSgPDOVOXptJC
         qKhTwfoufspNR6j3bYj5dE0ECywhCDUvaM5Cvr6GYJHijapLQEK9t5kGjQPBBfw9fz7+
         szfQ==
X-Forwarded-Encrypted: i=1; AKwUvBxssqR3lcn3dIG6VIZGaDsf70wKd4u8UcobjDcXHRdBVb+Ss1d/Toy/mvqrTiDx4tzknLrUI2jgxO+L@vger.kernel.org
X-Gm-Message-State: AFuF++kX0ImVGYZL2rUAWdM9ZVx9gkkaBDovvY7010bWtytZNZj4I06S
	RgYeDJ1xGmibUwTwyS2lIGd4a1peFJUjLL6KYARj7xIOzjhi+2D6PO2w83Gw1zCN8VfhWIyxjLG
	b3M8KLPrevH8SbZFakt1UKK2s+RVfXChgT3PohfkedA==
X-Gm-Gg: AYBFou1/BarA+hJ0+2xyq5RXj19UyDBeKw5CjoXQTOKa36Lc499+J1yHXgV1gIbMfLK
	7/aQ4+3RSY67A8lz1OuPSFAm/PU7ZXPEh+ThaoOanvuYOmP6/o0P1TsiBNx4gHdi0G86w0CKEqX
	SmBCwiMhfOozaT5ygfETKjnESCbmpm3iDiM/9mtZtOAvDqqWrTRejtOaJVxbBDrAplt5REk+tGb
	K+PIk3OA+11R3yHvMoRuY4TMu+Y93Jcko2aGJ/QWnQmLd+75oHKwcHjEhMYTKTdhbooo3Tz0s4c
	ggfuukjC7/76cEKbDpR/XlJW9SWp48JRSS5fLpewuB8PZu6AdgDH6ZM=
X-Received: by 2002:a17:907:7296:b0:c12:6db4:4bf4 with SMTP id
 a640c23a62f3a-c2e4a7292f1mr783960966b.0.1791176253197; Sun, 04 Oct 2026
 21:57:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260921-rtrs-fix-ib-drain-rq-v1-1-11b1637958ba@proton.me>
 <20260928191837.GC563127@unreal> <CAMGffEn2HGaj_20v0eQCTvk_akKM1RL-WQbUSXx0VND47PEhJw@mail.gmail.com>
In-Reply-To: <CAMGffEn2HGaj_20v0eQCTvk_akKM1RL-WQbUSXx0VND47PEhJw@mail.gmail.com>
From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date: Mon, 5 Oct 2026 06:57:21 +0200
X-Gm-Features: AclHuK9k5cTpzxbEHriXq1AXf5k_lZt1PaMuCp4V222ovefk7uK6kijw2FR7XTI
Message-ID: <CAMGffEkM0-jrWzX8Joa4w6uXAg-xhQf8OQyMX0v8uJc_3q73OA@mail.gmail.com>
Subject: Re: [PATCH] RDMA/rtrs-clt: Fix recv repost to satisfy ib_drain_rq
To: Leon Romanovsky <leon@kernel.org>, quanyeyang@proton.me
Cc: "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Farhad Alemi <farhad.alemi@berkeley.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 29, 2026 at 9:20=E2=80=AFAM Jinpu Wang <jinpu.wang@cloud.ionos.=
com> wrote:
>
> On Mon, Sep 28, 2026 at 9:18=E2=80=AFPM Leon Romanovsky <leon@kernel.org>=
 wrote:
> >
> > On Mon, Sep 21, 2026 at 07:04:47AM -0700, Quanye Yang via B4 Relay wrot=
e:
> > > From: Quanye Yang <quanyeyang@proton.me>
> > >
> > > On disconnect the client error recovery path calls ib_drain_qp(), whi=
ch
> > > requires one free RQ slot and that no recv WQEs are posted while the
> > > queue is being drained.
> > >
> > > The legacy recv completion path deferred reposting invalidate receive=
s
> > > and instead posted two empty recv WQEs when handling RDMA-with-IMM
> > > responses marked with invalidation.  If an invalidate receive never
> > > arrived, each such response increased RQ occupancy by one until
> > > ib_post_recv() started returning -ENOMEM and __ib_drain_rq() failed w=
ith:
> > >
> > >   failed to drain recv queue: -12
> > >
> > > Repost one empty recv WQE for every receive completion, including leg=
acy
> > > SEND_WITH_INV invalidates, and only while the path is still connected
> > > so CQ polling cannot race with ib_drain_qp().  Size IO connection RQs=
 to
> > > 2 * queue_depth + 1 to match the posted recv count and leave the drai=
n
> > > slot.
> >
> > Could you clarify what =E2=80=9Clegacy=E2=80=9D means in this commit me=
ssage?
> > Haris, Jack, does this patch look good to you?
> >
> I will check in the coming days. A bit unsure about the removal of
> rtrs_post_recv_empty_x2,
> want to check into history if there is any side effect.
> > Thanks
>
> Thanks.
> >
> > >
> > > Tested with a synthetic RTRS client flooding unpaired
> > > RTRS_IO_RSP_W_INV_IMM messages; error recovery no longer triggers
> > > __ib_drain_rq() warnings.
> > >
> > > Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
> > > Signed-off-by: Quanye Yang <quanyeyang@proton.me>
> > > Tested-by: Quanye Yang <quanyeyang@proton.me>
> > > Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> > > Link: https://lore.kernel.org/linux-rdma/CA+0ovCihE2_pxLimjmmR8NMz4g-=
ie8dvvq1jmAj-Om33y3Vzfg@mail.gmail.com
The change looks fine, please refine the commit message as Leon asked.
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> > > ---
> > >  drivers/infiniband/ulp/rtrs/rtrs-clt.c | 45 ++++++++++++------------=
----------
> > >  1 file changed, 15 insertions(+), 30 deletions(-)
> > >
> > > diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infinib=
and/ulp/rtrs/rtrs-clt.c
> > > index eac38b57b00d..ee6d5c3de16c 100644
> > > --- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> > > +++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> > > @@ -577,25 +577,21 @@ static struct ib_cqe io_comp_cqe =3D {
> > >       .done =3D rtrs_clt_rdma_done
> > >  };
> > >
> > > -/*
> > > - * Post x2 empty WRs: first is for this RDMA with IMM,
> > > - * second is for RECV with INV, which happened earlier.
> > > - */
> > > -static int rtrs_post_recv_empty_x2(struct rtrs_con *con, struct ib_c=
qe *cqe)
> > > +static int rtrs_clt_repost_recv(struct rtrs_clt_con *con)
> > >  {
> > > -     struct ib_recv_wr wr_arr[2], *wr;
> > > -     int i;
> > > +     struct rtrs_clt_path *clt_path =3D to_clt_path(con->c.path);
> > > +     int err;
> > >
> > > -     memset(wr_arr, 0, sizeof(wr_arr));
> > > -     for (i =3D 0; i < ARRAY_SIZE(wr_arr); i++) {
> > > -             wr =3D &wr_arr[i];
> > > -             wr->wr_cqe  =3D cqe;
> > > -             if (i)
> > > -                     /* Chain backwards */
> > > -                     wr->next =3D &wr_arr[i - 1];
> > > -     }
> > > +     if (READ_ONCE(clt_path->state) !=3D RTRS_CLT_CONNECTED)
> > > +             return 0;
> > >
> > > -     return ib_post_recv(con->qp, wr, NULL);
> > > +     err =3D rtrs_post_recv_empty(&con->c, &io_comp_cqe);
> > > +     if (err) {
> > > +             rtrs_err(con->c.path, "rtrs_post_recv_empty(): %pe\n",
> > > +                      ERR_PTR(err));
> > > +             rtrs_rdma_error_recovery(con);
> > > +     }
> > > +     return err;
> > >  }
> > >
> > >  static void rtrs_clt_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
> > > @@ -650,19 +646,7 @@ static void rtrs_clt_rdma_done(struct ib_cq *cq,=
 struct ib_wc *wc)
> > >                       rtrs_wrn(con->c.path, "Unknown IMM type %u\n",
> > >                                 imm_type);
> > >               }
> > > -             if (w_inval)
> > > -                     /*
> > > -                      * Post x2 empty WRs: first is for this RDMA wi=
th IMM,
> > > -                      * second is for RECV with INV, which happened =
earlier.
> > > -                      */
> > > -                     err =3D rtrs_post_recv_empty_x2(&con->c, &io_co=
mp_cqe);
> > > -             else
> > > -                     err =3D rtrs_post_recv_empty(&con->c, &io_comp_=
cqe);
> > > -             if (err) {
> > > -                     rtrs_err(con->c.path, "rtrs_post_recv_empty(): =
%pe\n",
> > > -                              ERR_PTR(err));
> > > -                     rtrs_rdma_error_recovery(con);
> > > -             }
> > > +             rtrs_clt_repost_recv(con);
> > >               break;
> > >       case IB_WC_RECV:
> > >               /*
> > > @@ -678,6 +662,7 @@ static void rtrs_clt_rdma_done(struct ib_cq *cq, =
struct ib_wc *wc)
> > >
> > >                       return  rtrs_clt_rkey_rsp_done(con, wc);
> > >               }
> > > +             rtrs_clt_repost_recv(con);
> > >               break;
> > >       case IB_WC_RDMA_WRITE:
> > >               /*
> > > @@ -1693,7 +1678,7 @@ static int create_con_cq_qp(struct rtrs_clt_con=
 *con)
> > >               clt_path->s.dev_ref++;
> > >               /* QD * (REQ + RSP + FR REGS or INVS) + drain */
> > >               max_send_wr =3D min(wr_limit, clt_path->queue_depth * 4=
 + 1);
> > > -             max_recv_wr =3D min(wr_limit, clt_path->queue_depth * 3=
 + 1);
> > > +             max_recv_wr =3D min(wr_limit, clt_path->queue_depth * 2=
 + 1);
> > >               max_send_sge =3D 2;
> > >       }
> > >       atomic_set(&con->c.sq_wr_avail, max_send_wr);
> > >
> > > ---
> > > base-commit: 93f51579e7df248780214094418f205253383cc5
> > > change-id: 20260921-rtrs-fix-ib-drain-rq-61dc85d0d759
> > >
> > > Best regards,
> > > --
> > > Quanye Yang <quanyeyang@proton.me>
> > >
> > >
