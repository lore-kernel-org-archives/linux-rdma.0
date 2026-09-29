Received: from mail-lf2-f13.google.com (mail-lf2-f13.google.com [74.125.229.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878AC3A16B9
	for <linux-rdma@vger.kernel.org>; Tue, 29 Sep 2026 07:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.205
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790666424; cv=pass; b=aEWjQ0Ij8L32G70AcchxSFsLKXST7ULlv+q292Onc2sXDg+Tfk5dyfabx0zsRgkAzrj9Y+f04YhoenCwWAJgxqbhrCt01rlhPFaAJ54qBL0XwnlKPMra1Wi75Zp5Zb+hX6/RK64uEDKxZR7UuMWBPv0S2xWiHtyWbz5yeG8Rnb0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790666424; c=relaxed/simple;
	bh=5Kmevjg1xHSqM26VaebvRIGdDvKt8BWdBNElEBc4SL0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mbQe+GI8ClxtDAXq20eaqFpCsA6/JbxpWaXRnthUkOpS50/3vicyWcpXUT2m598AOc4940Ey1uRrpuaLUwRkiokuja0bF6Pjl6843O2HN9T5RKD5c9NxTj+MPoJqvq4IjCSKEM+qhtwwHLl+xOKHE95yk4pNEmxqV3PR1S5JOZQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b=a1rziFcT; arc=pass smtp.client-ip=74.125.229.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="a1rziFcT"
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5ba3314d872so11470e87.1
        for <linux-rdma@vger.kernel.org>; Tue, 29 Sep 2026 00:20:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790666420; cv=none;
        d=google.com; s=arc-20260327;
        b=D1BlmMCoyrSHo2GChoxCJ9pqfEFMuXvmlKLeBkDiwTKwULyYyKC2q8jMkhPNIoXt4w
         Xs95K9nfV6xFCpu5hYP4nfyOWxlbhp+c/3OUUEV83O2XMKvBhdXLir5fROJad9j12MaZ
         juZB236Sf9Aq//GPJV/w/+wlc+h4Fvck9LxqCALUFBAvUoC62tDiNYoZ124ZqkD5A8sq
         yptoPXCZYlU62zwhwtKeRP5vyhQKYWjNsXQ1rgA77rzIqLuaFGzxJO0zImhDIWL3jPNk
         4IbhhcJsIP6qiIi3mZJIXbmKCUxujCAsSeDIcb96EwPkP6JLWI5tA8d6OPImK655NBxq
         hkfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CIw1gdYiA+FYIXVK1bVEPzibrcfEB6rGYXJsvhUxjlE=;
        fh=zCLETIq37Ogf91OO4bUUwICS/DfXUG1UDEeIAlLfFgQ=;
        b=psj8S6RZRk7OxKaZGMYhH0RNwZFsF8i43/Fkh8cjx/MYacxa3W6pN8e3kyeM/C9TIP
         dfUsmHAMgHXRQYR2cKm4GJ6bbbk6NP6uzOCTRgLa2T1iLQ1plK/Dm43Helghty2Qltdo
         eHkyA/teAzHlDkWJd8Hhc3ZKZ7zadb8JUVHpfnIuWiL+k9NKaZxSUtbX5gqiCFZKI8hg
         ZCswDF+/wjqRIuIPgkjEwvsmm9kx3FdnOPzc2kX+gknw25bxytCCy8N+w27Vq8PSSTJp
         F2Q0hMUcFXFTXmO43MXdZ+g1bd3VOyKVm7TYayVdtkovjRS+KfuHZ/VmIPLpZrzh6c6E
         hnHw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1790666420; x=1791271220; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CIw1gdYiA+FYIXVK1bVEPzibrcfEB6rGYXJsvhUxjlE=;
        b=a1rziFcTGo5A4OM/Gtzcewzkn5FV2Qb0bx7x3+is5+lYnrXDhZWgDSqv7zdPE8fdeu
         Hmv5i4iv8w9fMAbpDBkHb6BCJfFynfveRhbgM+AjBCJxwTivYAmyMPI+BN3r3BH3SFtG
         QflEUtuClb0MxCvHwsjxPxp9qxtfvirdrrsbB6vlUfP0c7y2SFuLtxe2rakbCTcKDa/I
         jdmQdv8BQ0cYsPN9TxmKp+CFnf46OJIMt9VqBZ3N86sUqHikCSXRp4HTXmnStdzHYOkO
         A3iefR0EZAdogfEgO7sYta0ZXKTFA6AqkxYwzmTT9qydjbrdO71TC+Im67apn+/BQWeL
         FmKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790666420; x=1791271220;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CIw1gdYiA+FYIXVK1bVEPzibrcfEB6rGYXJsvhUxjlE=;
        b=02c/EuL2bLhPll6ZNdDc6JoR1LKtnR8K3ctEKdX3C8cbkzx5aHNFRg3aoVmzZ+iC0w
         7Uxh49qj37Ryx/LIwoQLwGum45hj99G6Z7i8r/bs4RTm80EjZJrOfPV27Uofitw8Ye0m
         bHde78rmB6TL2QISUssyNXkl+TW+XQZ8IB+spiODbY9+6KwRLB+qCbPwzdBGWsaNm7Y5
         Ek6aXh7SBJJ9LT0cC0SejYYbi0xLmF/eqIqp6l2sDSPXTg8Kf+Z3Qf0+zbSvc+w7KXds
         PnhiGnQmtZqSbNI5GiWIwYcb4I0pzs3HNT8ArgKiKs70q9Vd7PTuNUvdMC3BAM1CB02i
         /Yqg==
X-Forwarded-Encrypted: i=1; AKwUvByphG5vV5fWiu89g0vp5vm6qbEKQU40MauR9bejAi1AyxYUWW9gKz9pzJrRPraHyoq6mTfqGPiOGxRz@vger.kernel.org
X-Gm-Message-State: AFq9FYLt6m/dqZNuLq3+LjdF8rSPEO8qQBpjOov5MZj4ucOFiykGeoz8
	s7MGdYZbF38xS8c82ydwQ13PxcbTmhUvcsIddUftzsR0uXjq6NvmKA0ruGPYlJl0QxeVhXGS5sf
	F9D9IhcNCPxyTr5fk3+uRVTm8GL6ZzueMUCcLRDtQ3Q==
X-Gm-Gg: AYBFou1fl6j9fY2npkN+UE0oQZ/s6faHYMkGnM/5cacBRgS+zHckbn4S8KyYPVrBaVd
	4LTuql9MeHT4p/CbaAvXTs/+/M+E+aKSw79j/OojpemZrGeXsz3PKdH6XfaZV/be6lsD8sWmGde
	nq0SggPvon3uw8QxR8/ysDSIjdk+nq2YpB1+pTRFP9eKkn2bREfOKMOnxI0eiSol/F8yPrIJYpn
	j+xeJLyRz9t1KcTShQHUkgB0rAumo95CbrdHnt7fSfW1Mq/jukEAuazv3oOpQ6nNyMCVtDggYas
	MKRYpMwm6wUq5m8Er6CFWrKjSwZUT6myKLkOO318nEWeTFCTgPTUs1Po22fNMHdwwQ==
X-Received: by 2002:a05:651c:1614:b0:3a6:6e61:287c with SMTP id
 38308e7fff4ca-3a66e614517mr15313291fa.0.1790666420392; Tue, 29 Sep 2026
 00:20:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260921-rtrs-fix-ib-drain-rq-v1-1-11b1637958ba@proton.me> <20260928191837.GC563127@unreal>
In-Reply-To: <20260928191837.GC563127@unreal>
From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date: Tue, 29 Sep 2026 09:20:08 +0200
X-Gm-Features: AclHuK_95NVsJfv32vEcMprk6jZy6lNO3ONZKwWTNHqKlrxUEbgD70ZLFDv-TcI
Message-ID: <CAMGffEn2HGaj_20v0eQCTvk_akKM1RL-WQbUSXx0VND47PEhJw@mail.gmail.com>
Subject: Re: [PATCH] RDMA/rtrs-clt: Fix recv repost to satisfy ib_drain_rq
To: Leon Romanovsky <leon@kernel.org>
Cc: quanyeyang@proton.me, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Danil Kipnis <danil.kipnis@cloud.ionos.com>, linux-rdma@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Farhad Alemi <farhad.alemi@berkeley.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 28, 2026 at 9:18=E2=80=AFPM Leon Romanovsky <leon@kernel.org> w=
rote:
>
> On Mon, Sep 21, 2026 at 07:04:47AM -0700, Quanye Yang via B4 Relay wrote:
> > From: Quanye Yang <quanyeyang@proton.me>
> >
> > On disconnect the client error recovery path calls ib_drain_qp(), which
> > requires one free RQ slot and that no recv WQEs are posted while the
> > queue is being drained.
> >
> > The legacy recv completion path deferred reposting invalidate receives
> > and instead posted two empty recv WQEs when handling RDMA-with-IMM
> > responses marked with invalidation.  If an invalidate receive never
> > arrived, each such response increased RQ occupancy by one until
> > ib_post_recv() started returning -ENOMEM and __ib_drain_rq() failed wit=
h:
> >
> >   failed to drain recv queue: -12
> >
> > Repost one empty recv WQE for every receive completion, including legac=
y
> > SEND_WITH_INV invalidates, and only while the path is still connected
> > so CQ polling cannot race with ib_drain_qp().  Size IO connection RQs t=
o
> > 2 * queue_depth + 1 to match the posted recv count and leave the drain
> > slot.
>
> Could you clarify what =E2=80=9Clegacy=E2=80=9D means in this commit mess=
age?
> Haris, Jack, does this patch look good to you?
>
I will check in the coming days. A bit unsure about the removal of
rtrs_post_recv_empty_x2,
want to check into history if there is any side effect.
> Thanks

Thanks.
>
> >
> > Tested with a synthetic RTRS client flooding unpaired
> > RTRS_IO_RSP_W_INV_IMM messages; error recovery no longer triggers
> > __ib_drain_rq() warnings.
> >
> > Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
> > Signed-off-by: Quanye Yang <quanyeyang@proton.me>
> > Tested-by: Quanye Yang <quanyeyang@proton.me>
> > Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> > Link: https://lore.kernel.org/linux-rdma/CA+0ovCihE2_pxLimjmmR8NMz4g-ie=
8dvvq1jmAj-Om33y3Vzfg@mail.gmail.com
> > ---
> >  drivers/infiniband/ulp/rtrs/rtrs-clt.c | 45 ++++++++++++--------------=
--------
> >  1 file changed, 15 insertions(+), 30 deletions(-)
> >
> > diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniban=
d/ulp/rtrs/rtrs-clt.c
> > index eac38b57b00d..ee6d5c3de16c 100644
> > --- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> > +++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> > @@ -577,25 +577,21 @@ static struct ib_cqe io_comp_cqe =3D {
> >       .done =3D rtrs_clt_rdma_done
> >  };
> >
> > -/*
> > - * Post x2 empty WRs: first is for this RDMA with IMM,
> > - * second is for RECV with INV, which happened earlier.
> > - */
> > -static int rtrs_post_recv_empty_x2(struct rtrs_con *con, struct ib_cqe=
 *cqe)
> > +static int rtrs_clt_repost_recv(struct rtrs_clt_con *con)
> >  {
> > -     struct ib_recv_wr wr_arr[2], *wr;
> > -     int i;
> > +     struct rtrs_clt_path *clt_path =3D to_clt_path(con->c.path);
> > +     int err;
> >
> > -     memset(wr_arr, 0, sizeof(wr_arr));
> > -     for (i =3D 0; i < ARRAY_SIZE(wr_arr); i++) {
> > -             wr =3D &wr_arr[i];
> > -             wr->wr_cqe  =3D cqe;
> > -             if (i)
> > -                     /* Chain backwards */
> > -                     wr->next =3D &wr_arr[i - 1];
> > -     }
> > +     if (READ_ONCE(clt_path->state) !=3D RTRS_CLT_CONNECTED)
> > +             return 0;
> >
> > -     return ib_post_recv(con->qp, wr, NULL);
> > +     err =3D rtrs_post_recv_empty(&con->c, &io_comp_cqe);
> > +     if (err) {
> > +             rtrs_err(con->c.path, "rtrs_post_recv_empty(): %pe\n",
> > +                      ERR_PTR(err));
> > +             rtrs_rdma_error_recovery(con);
> > +     }
> > +     return err;
> >  }
> >
> >  static void rtrs_clt_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
> > @@ -650,19 +646,7 @@ static void rtrs_clt_rdma_done(struct ib_cq *cq, s=
truct ib_wc *wc)
> >                       rtrs_wrn(con->c.path, "Unknown IMM type %u\n",
> >                                 imm_type);
> >               }
> > -             if (w_inval)
> > -                     /*
> > -                      * Post x2 empty WRs: first is for this RDMA with=
 IMM,
> > -                      * second is for RECV with INV, which happened ea=
rlier.
> > -                      */
> > -                     err =3D rtrs_post_recv_empty_x2(&con->c, &io_comp=
_cqe);
> > -             else
> > -                     err =3D rtrs_post_recv_empty(&con->c, &io_comp_cq=
e);
> > -             if (err) {
> > -                     rtrs_err(con->c.path, "rtrs_post_recv_empty(): %p=
e\n",
> > -                              ERR_PTR(err));
> > -                     rtrs_rdma_error_recovery(con);
> > -             }
> > +             rtrs_clt_repost_recv(con);
> >               break;
> >       case IB_WC_RECV:
> >               /*
> > @@ -678,6 +662,7 @@ static void rtrs_clt_rdma_done(struct ib_cq *cq, st=
ruct ib_wc *wc)
> >
> >                       return  rtrs_clt_rkey_rsp_done(con, wc);
> >               }
> > +             rtrs_clt_repost_recv(con);
> >               break;
> >       case IB_WC_RDMA_WRITE:
> >               /*
> > @@ -1693,7 +1678,7 @@ static int create_con_cq_qp(struct rtrs_clt_con *=
con)
> >               clt_path->s.dev_ref++;
> >               /* QD * (REQ + RSP + FR REGS or INVS) + drain */
> >               max_send_wr =3D min(wr_limit, clt_path->queue_depth * 4 +=
 1);
> > -             max_recv_wr =3D min(wr_limit, clt_path->queue_depth * 3 +=
 1);
> > +             max_recv_wr =3D min(wr_limit, clt_path->queue_depth * 2 +=
 1);
> >               max_send_sge =3D 2;
> >       }
> >       atomic_set(&con->c.sq_wr_avail, max_send_wr);
> >
> > ---
> > base-commit: 93f51579e7df248780214094418f205253383cc5
> > change-id: 20260921-rtrs-fix-ib-drain-rq-61dc85d0d759
> >
> > Best regards,
> > --
> > Quanye Yang <quanyeyang@proton.me>
> >
> >
