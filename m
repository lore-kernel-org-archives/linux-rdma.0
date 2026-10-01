Received: from mail-yw1-f226.google.com (mail-yw1-f226.google.com [209.85.128.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4432E3FE
	for <linux-rdma@vger.kernel.org>; Thu,  1 Oct 2026 05:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790832071; cv=none; b=JMhXrtWwzt+/P0q7mYTcRPYpVDI/MSvyIC1/XPd2IENTDAOD6SY2q95FsTeqPpfH4ClA7EiqGiJpX/6Ev0o3mq770g3n2ot02XKMJ5fCBK3R5mwybIdcBc4/ygRI7tDINGqJjoelFJdL09o4izBDHKPJrDUVz2/OEngE7ZM7YnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790832071; c=relaxed/simple;
	bh=HlhRNA2mBEgZu6G16+pBKT875p9Hh3KvacfDrFYlXOU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K843vlNzdjGdbCJhK6GzgBadpThVVraDjU0Sn9ofVyl0OKH7N28oZ0dWrmnaXgBI3HhgJUlxGdTFQGjrkr0v8MYg2rEnmuWK4h1/bqawyjmcIhD2iijHi9PJhnR6K7RkNmaHC2iw7czKrRWFaxFiwHwzOiuEn6YKQWDB8mPZVP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=AZdmbYl5; arc=none smtp.client-ip=209.85.128.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="AZdmbYl5"
Received: by mail-yw1-f226.google.com with SMTP id 00721157ae682-87005a0e052so12357917b3.2
        for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 22:21:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790832069; x=1791436869;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=q3kRk2em79L6Bsx2VvpYMbEO6nuq2QO6frnqV/IRh7c=;
        b=iu5ysSdtLkt1vtEb+KDogHlwtGli1BzrKKS1XDPN4m61BvExUxBwmRks2Cgya86+Ey
         MOfj8gM21V4O+/YJwk0IWEprZ08fBYtX4U9H7vlE/nOYSUpPuj9cwMQ05yfFVVVN6CsD
         vSAEUTw9fx7etYrYAUGSs9Oasl0S+S5MpQa7SoJFelMlovIAX8VfXviwzbAfWY1hk8yi
         Wjt1iq4w0WbOc2k8S/PjKjTTj76D5E0PrBzwyd5Mey3DS9kKSLtL8lMoXBcCGy3e1/BM
         epy6em0klZ7LowTNocAgXGjiqhLuI2JSUB5aqT7vCK+RlEabxpi/x3fYm60pog/x0vVu
         rscQ==
X-Forwarded-Encrypted: i=1; AKwUvBy6lQroXba4GOJ2BlF5P/OXQtGCQ7Mx0b02RzF0nclbFDDi9817BOeZW12553nVVHjKTdCeLRUVf/Gw@vger.kernel.org
X-Gm-Message-State: AFuF++lme4aIbCdUj99MTuvHkB4v959teMwsl0QGo8iC3IppHiqI1qlt
	Ay/uadr0L7clMQzLsmp9UT1MC1PnWnQuvKKrKAyxxndVPAnHUfsWGQxMKuAG7RLksq/MoEFzEwq
	4Q1x/BNWPSI5yfCMlrczX7lGwWnQikH8lkESPLLef+lFoUDWzkJdD6qN44/uJ6E+c6orTUVE4rv
	UWNfc05GBbpWrRjb+ihIjlyV1tlLXFYDFlUagkD9xV3lDumScoUyC0cYvwQELzAlrhEIYfsTtnl
	dF/sORyBEWG0mfEYA==
X-Gm-Gg: AYBFou3+XOo9xiAijmgoyuu+BGJiXaNRhWEKEcLN7SS0FFV/1EDLmBALxf9QL7e8011
	0dbsr/q0liPe1Ocy3vvq6UjsoAVlgUt6aGET8olh0cjLDprCAfnNiCZA2Hoo0vx1hBSlkWow7nm
	gCI+1CQ6HpRhTfj2EC6oSjQUpTIy3w88PhLAbzdiL83xJQJZunx07F0VJoL6foRc6W0UKHoqQap
	Gpzd66wa4lD4079pH3JpGfVr/YtUQyqRVnAC5E30hZBA6SGJx4PH2k1myIOH6XBeGsJ5WzMIXiw
	aI0+qDrEyIf1X4zUD4W8H13rhKbqlk/FRQnCVmhcf3pxKP9H6aziyPSqo9Ge+QEuc6s45QhB7g+
	m4Y90UrSVeDsZY2xPv6asHRfWbQpH9LG7RqM6OESxZ5pdfN0S7iH3A1o9Yob5TRX89N2fWHKBl1
	CqiBFL3kmGzqcuR9jDd2WQvhCJu9ItHk6DWEO5hR4=
X-Received: by 2002:a05:690e:438e:b0:672:f291:3bb3 with SMTP id 956f58d0204a3-6768341f131mr1044425d50.30.1790832068590;
        Wed, 30 Sep 2026 22:21:08 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-125.dlp.protect.broadcom.com. [144.49.247.125])
        by smtp-relay.gmail.com with ESMTPS id 956f58d0204a3-6769905a120sm80939d50.35.2026.09.30.22.21.08
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Sep 2026 22:21:08 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-45ecb9dd589so4627861fac.0
        for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 22:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1790832068; x=1791436868; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q3kRk2em79L6Bsx2VvpYMbEO6nuq2QO6frnqV/IRh7c=;
        b=AZdmbYl5HYiVQMYKVp+IRNJAabXM1DzIXxNUUhg6+oqf9RVp6xjO5ZDlzwqNv8Aw+h
         gPvbHTZ4JZ2d95ECWillR3+qKXtOK23E4FtRcEc3jHaVto0JyRwOOWmKYwzTKGTk8IHx
         YNOgPp1ONpIvelX0edgQ3g5mOJ5sOgW6+2jfg=
X-Forwarded-Encrypted: i=1; AKwUvByUcY+ahfVjt0fjx9kThxvvn958Vcwqv4M6d1Bage3kzaX1UbmXrrZWPPsFdJYvAv/Z+9GZn8H1ROBv@vger.kernel.org
X-Received: by 2002:a05:6820:4b03:b0:6d9:1ea8:72fc with SMTP id 006d021491bc7-6dcf4b66844mr3456425eaf.20.1790832067698;
        Wed, 30 Sep 2026 22:21:07 -0700 (PDT)
X-Received: by 2002:a05:6820:4b03:b0:6d9:1ea8:72fc with SMTP id
 006d021491bc7-6dcf4b66844mr3456414eaf.20.1790832067227; Wed, 30 Sep 2026
 22:21:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260807005138.771669-1-selvin.xavier@broadcom.com>
 <20260807005138.771669-3-selvin.xavier@broadcom.com> <179060533568.122959.5263400857499789390.b4-review@b4>
In-Reply-To: <179060533568.122959.5263400857499789390.b4-review@b4>
From: Selvin Xavier <selvin.xavier@broadcom.com>
Date: Thu, 1 Oct 2026 10:50:54 +0530
X-Gm-Features: AclHuK8iHRyU5329GjMLZTNaE52HvfMrZ-ztBih27WR_0ytMgGtrxra_rNi_yQQ
Message-ID: <CA+sbYW3tiSTxFsL-bm14X-g2tiKJUojqbohgEwmua8wWfoQizw@mail.gmail.com>
Subject: Re: [PATCH for-next 2/4] RDMA/bnxt_re: Prepare infrastructure for
 larger pages for Queue memory
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: leon@kernel.org, jgg@ziepe.ca, linux-rdma@vger.kernel.org, 
	andrew.gospodarek@broadcom.com, kalesh-anakkur.purayil@broadcom.com, 
	saravanan.vajravel@broadcom.com
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="00000000000044a521065cc09573"

--00000000000044a521065cc09573
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 28, 2026 at 7:52=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> > [ ... 39 lines skipped ... ]
> >  static int bnxt_re_setup_sginfo(struct bnxt_re_dev *rdev,
> >                               struct ib_umem *umem,
> >                               struct bnxt_qplib_sg_info *sginfo)
> >  {
> > +     struct bnxt_qplib_dev_attr *dev_attr =3D rdev->dev_attr;
> >       unsigned long page_size;
> > +     int page_shift;
> >
> >       if (!umem)
> >               return -EINVAL;
> >
> > -     page_size =3D ib_umem_find_best_pgsz(umem, SZ_4K, 0);
> > -     if (!page_size || page_size !=3D SZ_4K)
> > -             return -EINVAL;
> > +     if (bnxt_re_pbl_size_supported(dev_attr->dev_cap_ext_flags_1)) {
> > +             page_shift =3D bnxt_re_get_page_shift(umem, umem->address=
, dev_attr->page_size_cap);
> > +             if (page_shift < 0)
> > +                     return page_shift;
> > +     } else {
> > +             page_shift =3D __builtin_ctz(SZ_4K);
> > +     }
>
> This ib_umem_find_best_pgsz() should not be skipped, organize things
> so you have two size caps, mr_size_cap and pbl_size_cap and use them
> appropriately in all the right contexts.

>
> >
> > +     page_size =3D BIT(page_shift);
>
> So the helper does ffs and then it is shifted back?

bnxt_re_get_page_shift actually calls ib_umem_find_best_pgsz. But you
are right, we can optimize the helper to avoid the shifting back. WIll
rework.
>
> >       sginfo->umem =3D umem;
> >       sginfo->npages =3D ib_umem_num_dma_blocks(umem, page_size);
> >       sginfo->pgsize =3D page_size;
> > -     sginfo->pgshft =3D __builtin_ctz(page_size);
> > +     sginfo->pgshft =3D page_shift;
>
> Put the ffs here..
Ok sure.
>
> > [ ... 9 lines skipped ... ]
> > +     /*
> > +      * The FWO field passed in the CREATE_QP command is expressed in =
4K
> > +      * units, so the offset must be a multiple of 4K.
> > +      */
> > +     if (qplib_qp->sq.sg_info.fwo_offset & (SZ_4K - 1)) {
> > +             rc =3D -EINVAL;
> > +             goto fail;
> > +     }
>
> Failure does not seem right? If there are restrictions on what offset
> can be accepted then you need to feed that into
> ib_umem_find_best_pgsz() so it selects a page size that works with
> HW. Presumably if 4k is selected everything works, right?
Yes. 4K should work for QPs.
>
> I forget all the options, but mlx5 had similar restrictions so I think
> helpers should exist or almost exist..
>
> > [ ... 46 lines skipped ... ]
> > @@ -220,6 +239,8 @@ int bnxt_qplib_alloc_init_hwq(struct bnxt_qplib_hwq=
 *hwq,
> >               if (rc)
> >                       goto fail;
> >               hwq->level =3D PBL_LVL_0;
> > +             if (hwq_attr->type =3D=3D HWQ_TYPE_QUEUE)
> > +                     bnxt_qplib_adjust_lvl0_fwo(hwq, hwq_attr);
> >               goto done;
> >       }
> >
>  [Severity: High]
>  For PBL Level 0, the first-word offset (fwo_offset) is absorbed into the=
 base
>  address here. But if the queue requires PBL Level 1 or 2 (multi-page que=
ues),
>  the offset isn't adjusted in the PBL entries.
>
> Are you checking sashiko?
Yes. I am looking into sashiko. This message looks like a false
possitive.  The adjustment is required only for Level 0.
I will post a v2 after fixing some of the issues reported by sashiko
on my first patch series.
>
> --
> Jason

--00000000000044a521065cc09573
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
zJH6Ivyz2skA36zh/px/UmF2ORX4Y0CY6GtU8/vxuN2j4rd2medlyifwALUm+KI3SsD782IwKLCf
8bNhYGiw4YxsbyX7dV7O4SNQc5U9ktrSKH3D4SuTnK/xdjca5PiNI2NTcBVmP7+u2bvVLdRqISop
9dpRkJ6xxhGJjxakljIxHdcZLXltxX4YM0Onf3agcjY3boIqnVlDjBwSZX674ZU+YVrcIlcRcqs/
W83e6PmIRFwpkKOhuLNKSpW5mZoEQdpnxGwE9U7qLGECAwEAAaOCAd4wggHaMA4GA1UdDwEB/wQE
AwIFoDAMBgNVHRMBAf8EAjAAMIGTBggrBgEFBQcBAQSBhjCBgzBGBggrBgEFBQcwAoY6aHR0cDov
L3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyNnNtaW1lY2EyMDIzLmNydDA5Bggr
BgEFBQcwAYYtaHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyNnNtaW1lY2EyMDIzMGUG
A1UdIAReMFwwCQYHZ4EMAQUDAzALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgoDAjA0MDIGCCsGAQUF
BwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzBBBgNVHR8EOjA4MDag
NKAyhjBodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjZzbWltZWNhMjAyMy5jcmwwJQYD
VR0RBB4wHIEac2VsdmluLnhhdmllckBicm9hZGNvbS5jb20wEwYDVR0lBAwwCgYIKwYBBQUHAwQw
HwYDVR0jBBgwFoAUACk2nlx6ug+vLVAt26AjhRiwoJIwHQYDVR0OBBYEFJA9fV7cOoiN64ws5XPC
J5qtayo5MA0GCSqGSIb3DQEBCwUAA4ICAQBFCIF4AxAiXVz6gX5YfFEbIYtbGFifcfe+QGc5cfac
CSzIrQWUPXAYAef3G5WouD2AKwa2tPGJgK2L7n1r2W4NIvr93588EDVnGgfMfWaFsB8VlLsPlH8Y
fLfaTdN3OQPnFFp54yK9wv8AtTIiTQcailMw7QX5x5GE6HVZElxf0V0Ljc2NrUQLoYzHzAU+sysl
6JQzomxjIfuXiIiUfmnWQdhO95kQchRdOUAaguLTV+RRfPZ1p54dRmgGEpJtzjGLdsrLkZ2rCN5j
cOTTXyxJmvlgm9jfT0Uy5SOPHdq1jtZbQyXrNT4fQ07Odmq3xQCUTi+a59IiC+6V7nFJ8zyCSk+p
n/iGouvun/owYzTmFxB6sVLWZcaWz2Ufcm7b6nOYV+pwUS/n6+6oFRKmGLrl0CRCF0AOph5p81aV
kgKuS5oXBoDefJfjKHuu5lJVelBx3n++iMGMW9FWFmXErCHy2d+L42Raai5X2PL8jAmh+lpPRDX4
CT9jL6xWM5QkCBtxyVKuxGxxUY2wczmVcQ1nGh9mGghI04Scs4OtE8Qh9LMOe2PXzxcV6lpF+yay
B3fwJWxl7miwNFjWuu9M6Z+rcjm3JF5srcAu2fp/VzQD4AE5Kq7ywukMvlU4Y3X2t+D2eU1DH8pk
c8mM1CtQWfWUboaoLABVmYmYfihDvTURkzGCAlcwggJTAgEBMGIwUjELMAkGA1UEBhMCQkUxGTAX
BgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExKDAmBgNVBAMTH0dsb2JhbFNpZ24gR0NDIFI2IFNNSU1F
IENBIDIwMjMCDDy76dRYp65lyF2c4zANBglghkgBZQMEAgEFAKCBxzAvBgkqhkiG9w0BCQQxIgQg
2a1D9vQI4W0CL5A+3JEatA4QFrjPfcCehC9WRTxI12cwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEH
ATAcBgkqhkiG9w0BCQUxDxcNMjYxMDAxMDUyMTA4WjBcBgkqhkiG9w0BCQ8xTzBNMAsGCWCGSAFl
AwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBBzAL
BglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAWP7q6f2gMim6i9MA/fvtRvyMRTxnA92BL3u8
q08HbwW7qAfx/ndOAYKi/g+F9imvOcIXXmpklLSowe3RFrjITc9SCaSBJBl2tI1NuWm/QOs+7lmF
ISkb8yYFtQvySwhjVMSdRTMsKnUSD/fe9gtqwuEpC+YgflPpD7Dv2N3dSegGaSknrrehTPDcQ+3a
vnIYtF22KRD1AweFFHRwKo/NmA2rLTSYi+4p+QcX8VLX7Yfbtczcx4HhNQ9yUzWSITp6+gnEi1nK
3gMrsBrf6/uICEPrlcGySqTCC9+1V62EI6VA6vzMufG8RdQYWWMBmTyf2T1Wv0Nosn4FQfHonB4v
Rw==
--00000000000044a521065cc09573--
