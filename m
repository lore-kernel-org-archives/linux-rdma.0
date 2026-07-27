Received: from mail-pf1-f228.google.com (mail-pf1-f228.google.com [209.85.210.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0E23BED7B
	for <linux-rdma@vger.kernel.org>; Mon, 27 Jul 2026 06:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785135423; cv=none; b=f3bwLzdYA21tzdPjYKUxZeso8TjPvRXKGyJMRmv5CBq1lokrH/K58zT65yHOH8wMTjMt8ENv8v0y5LdtLmHz81NRx7tyD30ed6SodC0aHUlZBAs2/2xcGQAZ7JbuTiuWoq41TEhx8/Hl0vnL4mSMBQnvzm8orkd5hUwn27+evMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785135423; c=relaxed/simple;
	bh=k6eS/KdCecCnV8fnS49xUbx49YU66O64tVMPL4THIr0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WNzQFFwhcEmXKqjyXljCMhqM7pRmDzxHnikwlCzo9VlKgRz1KGf9p/E1WgwXGl8PsgV7KCsKAJomSv85Hd5JNYlqd1xWoPil6rXBDVX9rB5GGNP4pfukzZRFih4v84gELYHx7BaqwU7ignnucGplfNPLxZJB0a54TmIQc1IOgjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=R8uo8rVR; arc=none smtp.client-ip=209.85.210.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="R8uo8rVR"
Received: by mail-pf1-f228.google.com with SMTP id d2e1a72fcca58-848595b338cso2570012b3a.0
        for <linux-rdma@vger.kernel.org>; Sun, 26 Jul 2026 23:57:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785135421; x=1785740221;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tMjxupfZpzbYJ/Ome1FA8f7WUY3AH3qbNivb29LeNdk=;
        b=Dk48YQhAMScDlMNJooB7ivW8z1M1gNm7MIX/9RhjOXIc8MLeD1cY+Ho0IOWriB7KOD
         HPl9yYWnw1/FPwTjTHMVR7b3dwGdO3JqJNW4+g5etn3/zjge14631sroh0SC76g1E/fZ
         ELI7mL4muQKysdzFRyWnqWC0WpKRV/sUN1fT1fi+dbspNDRs4LQNagsGq/LsrFsV8erF
         WnWda2uKBE1ANpj/UXduSvVn4IzzZUJ3dQnhr23nWeZdqHNuQSeA7uXhLK3ZXqjvd7B/
         D3YynYZ7f96UuLBY38szMTMhqFPo2K1RYoK9tHmB7fSRlXChdOxQhKEJZInsjvJmyHJX
         tmxg==
X-Forwarded-Encrypted: i=1; AHgh+RptayUFUdwnfWdDdcODgM+BfjB7LSuudJBUFr72iU64IvT0LASkoLw6gNRQIaeX40qUU8tT7I0qTWrf@vger.kernel.org
X-Gm-Message-State: AOJu0YxCaXRRb+gvmUbm9eHZYoZ3J1aBY0TjqKXeXRZ25i/3IVjX3Rd5
	RZiX3W4uUaG9eckEiAhLt5ZBjDF/q6qa7IyPK5Fv2Aq69zxAzIyOQ0602/F+vaOcf8ww9ZfFS3Y
	qt6/Ea0mAzbBaYpw2q5ClB/F4eavNqnEyvBaOO2xJx0X4vaoyPfvQVIx1ETLcheXTobNxxPvzVU
	yDusBaUhY/WImjHulqmD44mc4nKOqAMK31zP2TSzCuSbnhcu7n037tQwSzYkuV+hKKpntFPnQd2
	6OVo4Qne/Ih22mqew==
X-Gm-Gg: AR+sD11d3su514mQljKX0Ue2OZT9wX+EkT+0McEbVkvf2P3wGokOZ0TTLw7G1attKgu
	sOLT6eCmjB3kPdmDblK5UPJIFjzRZ6dyCwsXzhLs5fstlC33MEghv+koCIaTg/IAduZMHnoMXNt
	fxjf37WI20TPHBri/zMwvAC4VDXKPQgb9Tbin6EHdcjfZbYS6oBud4KYMwEsN0NbtNXN+3WKXNB
	3sZ5HQEpjE8I3122VN6EznjSyqJN7IFzRUe1fxfj2zpt27RuN5qR0nQOJBSfgokXhSUFOmGcOBY
	dmhFYhDOxFMIJ1/L0/XSArnaEjdx2OXTuhCMsjPVwjvkkKEhESaf1Yb1sp5HOVggbQyOI4AsbLB
	lDQgx4Q/uYFg0lbKUo1i8zRhL9rn/C+SUIyefjsGasZ3hW5/G/DqJ7dTFpoCrkGOQs2xa4mZpn/
	TKgX/OLSCoNmYjfT2AQEtyxu3hJDTfBsC+T3HP
X-Received: by 2002:a05:6a00:9515:b0:848:2f6e:e52d with SMTP id d2e1a72fcca58-84e595e157cmr5823034b3a.65.1785135421106;
        Sun, 26 Jul 2026 23:57:01 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-84e53274581sm500360b3a.1.2026.07.26.23.57.00
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jul 2026 23:57:01 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-4412c255fd4so1266885fac.3
        for <linux-rdma@vger.kernel.org>; Sun, 26 Jul 2026 23:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785135419; x=1785740219; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tMjxupfZpzbYJ/Ome1FA8f7WUY3AH3qbNivb29LeNdk=;
        b=R8uo8rVRD7RNwPPNOnGsj/nfCqw2VcOkQe1Tm47dWZrOOOpgkMv0UVktMRSgtZynF3
         SdNovmkgxHf41Uoh9tTtzmurZAFbBs/rvgd9QtOHzurAdJR5s28MeX1OwYUM4JurrR2Y
         qKkj7yGzu+YCj7tm6YSRDI8dp+q3sW3SQbXEQ=
X-Forwarded-Encrypted: i=1; AHgh+RpH/KC0ipc97R+ZJNyLSHCD6cSlffSISu8uU1L2njGJYsX/nQOO7Xlo2IiTT3lQmyAIlwvg0xLH6QbM@vger.kernel.org
X-Received: by 2002:a05:6870:36d1:b0:457:b657:b084 with SMTP id 586e51a60fabf-457f245310cmr6666943fac.18.1785135419502;
        Sun, 26 Jul 2026 23:56:59 -0700 (PDT)
X-Received: by 2002:a05:6870:36d1:b0:457:b657:b084 with SMTP id
 586e51a60fabf-457f245310cmr6666923fac.18.1785135418992; Sun, 26 Jul 2026
 23:56:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260721115440.24021-1-selvin.xavier@broadcom.com>
 <20260721115440.24021-4-selvin.xavier@broadcom.com> <20260727062128.GI12003@unreal>
In-Reply-To: <20260727062128.GI12003@unreal>
From: Selvin Xavier <selvin.xavier@broadcom.com>
Date: Mon, 27 Jul 2026 12:26:46 +0530
X-Gm-Features: AUfX_mzSfoNAuG3GjKvX1fO_qRcYkEDNDayW0KZOIEHZv8H4dbIyZS0gl_hDFtI
Message-ID: <CA+sbYW1Zxm9KhfqtSZodpgcSE2ARfrq4YMS_s1+Xo=H_Qd+WsA@mail.gmail.com>
Subject: Re: [PATCH for-next v4 3/4] RDMA/bnxt_re: Add uverbs object handle
 path for CQ/SRQ toggle page
To: Leon Romanovsky <leon@kernel.org>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, andrew.gospodarek@broadcom.com, 
	kalesh-anakkur.purayil@broadcom.com, sriharsha.basavapatna@broadcom.com, 
	alhouseenyousef@gmail.com, Jason Gunthorpe <jgg@nvidia.com>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="00000000000093a0fa0657923ac5"

--00000000000093a0fa0657923ac5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 27, 2026 at 11:51=E2=80=AFAM Leon Romanovsky <leon@kernel.org> =
wrote:
>
> On Tue, Jul 21, 2026 at 04:54:39AM -0700, Selvin Xavier wrote:
> > The current GET_TOGGLE_MEM ioctl requires the caller to supply
> > a type enum and a raw hardware queue ID (RES_ID). The kernel
> > looks up the CQ or SRQ by that ID without verifying that the
> > caller owns the resource.
> >
> > Add a new, preferred code path that accepts standard uverbs
> > object handles (BNXT_RE_TOGGLE_MEM_CQ_HANDLE /
> > BNXT_RE_TOGGLE_MEM_SRQ_HANDLE) instead. The uverbs core validates
> > that the handle belongs to the calling context as part of resolving
> > it, so this path no longer needs the driver's own XArray lookup for
> > ownership checking. As with the legacy path, the toggle_entry's own
> > mmap-entry refcount (not a CQ/SRQ uobject reference) is what pins
> > the toggle page for the life of the GET_TOGGLE_MEM handle.
> >
> > Only newer rdma-core versions support this path, if the
> > driver reports the supported resp mask
> > (BNXT_RE_UCNTX_CMASK_TOGGLE_MEM_UOBJ_SUPPORT).
> > The existing TYPE + RES_ID path is retained for backward
> > compatibility with older rdma-core.
> >
> > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
> > ---
> >  drivers/infiniband/hw/bnxt_re/ib_verbs.c |  2 +
> >  drivers/infiniband/hw/bnxt_re/uapi.c     | 55 +++++++++++++++++++++---
> >  include/uapi/rdma/bnxt_re-abi.h          |  4 ++
> >  3 files changed, 56 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infinib=
and/hw/bnxt_re/ib_verbs.c
> > index 0ff862ca982c..a14b17d4261f 100644
> > --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > @@ -4872,6 +4872,8 @@ int bnxt_re_alloc_ucontext(struct ib_ucontext *ct=
x, struct ib_udata *udata)
> >       if (_is_modify_qp_rate_limit_supported(dev_attr->dev_cap_flags2))
> >               resp.comp_mask |=3D BNXT_RE_UCNTX_CMASK_QP_RATE_LIMIT_ENA=
BLED;
> >
> > +     resp.comp_mask |=3D BNXT_RE_UCNTX_CMASK_TOGGLE_MEM_UOBJ_SUPPORT;
> > +
> >       if (udata->inlen) {
> >               rc =3D ib_copy_validate_udata_in_cm(
> >                       udata, ureq, comp_mask,
> > diff --git a/drivers/infiniband/hw/bnxt_re/uapi.c b/drivers/infiniband/=
hw/bnxt_re/uapi.c
> > index 97bc0e755511..feaf98631fc5 100644
> > --- a/drivers/infiniband/hw/bnxt_re/uapi.c
> > +++ b/drivers/infiniband/hw/bnxt_re/uapi.c
> > @@ -237,16 +237,52 @@ static int UVERBS_HANDLER(BNXT_RE_METHOD_GET_TOGG=
LE_MEM)(struct uverbs_attr_bund
> >       if (IS_ERR(ib_uctx))
> >               return PTR_ERR(ib_uctx);
> >
> > +     uctx =3D container_of(ib_uctx, struct bnxt_re_ucontext, ib_uctx);
> > +
> > +     /* New path: updated libbnxt_re passes the CQ or SRQ uverbs handl=
e */
> > +     if (uverbs_attr_is_valid(attrs, BNXT_RE_TOGGLE_MEM_CQ_HANDLE)) {
> > +             struct bnxt_re_cq *cq;
> > +
> > +             res_uobj =3D uverbs_attr_get_uobject(attrs,
> > +                                                BNXT_RE_TOGGLE_MEM_CQ_=
HANDLE);
> > +             if (IS_ERR(res_uobj))
> > +                     return PTR_ERR(res_uobj);
> > +             cq =3D container_of(res_uobj->object, struct bnxt_re_cq, =
ib_cq);
> > +             if (!cq->toggle_entry)
> > +                     return -EOPNOTSUPP;
> > +             mmap_offset =3D rdma_user_mmap_get_offset(&cq->toggle_ent=
ry->rdma_entry);
> > +             if (!mmap_offset)
> > +                     return -EOPNOTSUPP;
> > +             kref_get(&cq->toggle_entry->rdma_entry.ref);
> > +             toggle_entry =3D cq->toggle_entry;
> > +             goto alloc_tmem;
> > +     } else if (uverbs_attr_is_valid(attrs, BNXT_RE_TOGGLE_MEM_SRQ_HAN=
DLE)) {
> > +             struct bnxt_re_srq *srq;
> > +
> > +             res_uobj =3D uverbs_attr_get_uobject(attrs,
> > +                                                BNXT_RE_TOGGLE_MEM_SRQ=
_HANDLE);
> > +             if (IS_ERR(res_uobj))
> > +                     return PTR_ERR(res_uobj);
> > +             srq =3D container_of(res_uobj->object, struct bnxt_re_srq=
, ib_srq);
> > +             if (!srq->toggle_entry)
> > +                     return -EOPNOTSUPP;
> > +             mmap_offset =3D rdma_user_mmap_get_offset(&srq->toggle_en=
try->rdma_entry);
> > +             if (!mmap_offset)
> > +                     return -EOPNOTSUPP;
> > +             kref_get(&srq->toggle_entry->rdma_entry.ref);
> > +             toggle_entry =3D srq->toggle_entry;
> > +             goto alloc_tmem;
> > +     }
> > +
> >       err =3D uverbs_get_const(&res_type, attrs, BNXT_RE_TOGGLE_MEM_TYP=
E);
> >       if (err)
> >               return err;
> > -
> > -     uctx =3D container_of(ib_uctx, struct bnxt_re_ucontext, ib_uctx);
> >       err =3D uverbs_copy_from(&res_id, attrs, BNXT_RE_TOGGLE_MEM_RES_I=
D);
> >       if (err)
> >               return err;
> >
> >       /*
> > +      * Legacy path: old libbnxt_re sends TYPE + RES_ID.
> >        * Hold xa_lock across xa_load + kref_get so that a concurrent
> >        * bnxt_re_destroy_cq/srq cannot call __xa_erase and remove the
> >        * toggle_entry between our load and our reference on it.
> > @@ -297,6 +333,7 @@ static int UVERBS_HANDLER(BNXT_RE_METHOD_GET_TOGGLE=
_MEM)(struct uverbs_attr_bund
> >       if (!mmap_offset)
> >               return -EOPNOTSUPP;
> >
> > +alloc_tmem:
> >       tmem =3D kzalloc_obj(*tmem);
> >       if (!tmem) {
> >               rdma_user_mmap_entry_put(&toggle_entry->rdma_entry);
> > @@ -343,10 +380,10 @@ DECLARE_UVERBS_NAMED_METHOD(BNXT_RE_METHOD_GET_TO=
GGLE_MEM,
> >                                           UA_MANDATORY),
> >                           UVERBS_ATTR_CONST_IN(BNXT_RE_TOGGLE_MEM_TYPE,
> >                                                enum bnxt_re_get_toggle_=
mem_type,
> > -                                              UA_MANDATORY),
> > +                                              UA_OPTIONAL),
> >                           UVERBS_ATTR_PTR_IN(BNXT_RE_TOGGLE_MEM_RES_ID,
> >                                              UVERBS_ATTR_TYPE(u32),
> > -                                            UA_MANDATORY),
> > +                                            UA_OPTIONAL),
> >                           UVERBS_ATTR_PTR_OUT(BNXT_RE_TOGGLE_MEM_MMAP_P=
AGE,
> >                                               UVERBS_ATTR_TYPE(u64),
> >                                               UA_MANDATORY),
> > @@ -355,7 +392,15 @@ DECLARE_UVERBS_NAMED_METHOD(BNXT_RE_METHOD_GET_TOG=
GLE_MEM,
> >                                               UA_MANDATORY),
> >                           UVERBS_ATTR_PTR_OUT(BNXT_RE_TOGGLE_MEM_MMAP_L=
ENGTH,
> >                                               UVERBS_ATTR_TYPE(u32),
> > -                                             UA_MANDATORY));
> > +                                             UA_MANDATORY),
> > +                         UVERBS_ATTR_IDR(BNXT_RE_TOGGLE_MEM_CQ_HANDLE,
> > +                                         UVERBS_OBJECT_CQ,
> > +                                         UVERBS_ACCESS_READ,
> > +                                         UA_OPTIONAL),
> > +                         UVERBS_ATTR_IDR(BNXT_RE_TOGGLE_MEM_SRQ_HANDLE=
,
> > +                                         UVERBS_OBJECT_SRQ,
> > +                                         UVERBS_ACCESS_READ,
> > +                                         UA_OPTIONAL));
> >
> >  DECLARE_UVERBS_NAMED_METHOD_DESTROY(BNXT_RE_METHOD_RELEASE_TOGGLE_MEM,
> >                                   UVERBS_ATTR_IDR(BNXT_RE_RELEASE_TOGGL=
E_MEM_HANDLE,
> > diff --git a/include/uapi/rdma/bnxt_re-abi.h b/include/uapi/rdma/bnxt_r=
e-abi.h
> > index a4599d7b736a..c0ee9ce389ac 100644
> > --- a/include/uapi/rdma/bnxt_re-abi.h
> > +++ b/include/uapi/rdma/bnxt_re-abi.h
> > @@ -57,6 +57,8 @@ enum {
> >       BNXT_RE_UCNTX_CMASK_POW2_DISABLED =3D 0x10ULL,
> >       BNXT_RE_UCNTX_CMASK_MSN_TABLE_ENABLED =3D 0x40,
> >       BNXT_RE_UCNTX_CMASK_QP_RATE_LIMIT_ENABLED =3D 0x80ULL,
> > +      /* Some reserved fields to manage compatibility with Out of tree=
 drivers */
>
> Selvin,
>
> What did you mean with this comment?
This CMASK tracks the feature compatibility. Broadcom distributes an
out-of-tree driver
with some of the features that are not available in the upstream
driver. Some of these
features are debug only or features applicable for the next revision
of the chip (which is not
supported yet in the upstream driver). Since we want our inbox
libraries to work with
the out-of-tree drivers (and vice versa),  we are maintaining ABI
compatibility and I will
have to keep reserved/holes in the feature definition of this
compatibility mask.

Thanks
>
> Thanks
>
> > +     BNXT_RE_UCNTX_CMASK_TOGGLE_MEM_UOBJ_SUPPORT =3D 0x400000ULL,
> >  };
> >
> >  enum bnxt_re_wqe_mode {
> > @@ -218,6 +220,8 @@ enum bnxt_re_var_toggle_mem_attrs {
> >       BNXT_RE_TOGGLE_MEM_MMAP_PAGE,
> >       BNXT_RE_TOGGLE_MEM_MMAP_OFFSET,
> >       BNXT_RE_TOGGLE_MEM_MMAP_LENGTH,
> > +     BNXT_RE_TOGGLE_MEM_CQ_HANDLE,
> > +     BNXT_RE_TOGGLE_MEM_SRQ_HANDLE,
> >  };
> >
> >  enum bnxt_re_toggle_mem_attrs {
> > --
> > 2.39.3
> >

--00000000000093a0fa0657923ac5
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIVXQYJKoZIhvcNAQcCoIIVTjCCFUoCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
ghLKMIIGqDCCBJCgAwIBAgIQfofDCS7XZu8vIeKo0KeY9DANBgkqhkiG9w0BAQwFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSNjETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMzA0MTkwMzUzNTNaFw0yOTA0MTkwMDAwMDBaMFIxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWduIEdDQyBS
NiBTTUlNRSBDQSAyMDIzMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAwjAEbSkPcSyn
26Zn9VtoE/xBvzYmNW29bW1pJZ7jrzKwPJm/GakCvy0IIgObMsx9bpFaq30X1kEJZnLUzuE1/hlc
hatYqyORVBeHlv5V0QRSXY4faR0dCkIhXhoGknZ2O0bUJithcN1IsEADNizZ1AJIaWsWbQ4tYEYj
ytEdvfkxz1WtX3SjtecZR+9wLJLt6HNa4sC//QKdjyfr/NhDCzYrdIzAssoXFnp4t+HcMyQTrj0r
pD8KkPj96sy9axzegLbzte7wgTHbWBeJGp0sKg7BAu+G0Rk6teO1yPd75arbCvfY/NaRRQHk6tmG
71gpLdB1ZhP9IcNYyeTKXIgfMh2tVK9DnXGaksYCyi6WisJa1Oa+poUroX2ESXO6o03lVxiA1xyf
G8lUzpUNZonGVrUjhG5+MdY16/6b0uKejZCLbgu6HLPvIyqdTb9XqF4XWWKu+OMDs/rWyQ64v3mv
Sa0te5Q5tchm4m9K0Pe9LlIKBk/gsgfaOHJDp4hYx4wocDr8DeCZe5d5wCFkxoGc1ckM8ZoMgpUc
4pgkQE5ShxYMmKbPvNRPa5YFzbFtcFn5RMr1Mju8gt8J0c+dxYco2hi7dEW391KKxGhv7MJBcc+0
x3FFTnmhU+5t6+CnkKMlrmzyaoeVryRTvOiH4FnTNHtVKUYDsCM0CLDdMNgoxgkCAwEAAaOCAX4w
ggF6MA4GA1UdDwEB/wQEAwIBhjBMBgNVHSUERTBDBggrBgEFBQcDAgYIKwYBBQUHAwQGCisGAQQB
gjcUAgIGCisGAQQBgjcKAwwGCisGAQQBgjcKAwQGCSsGAQQBgjcVBjASBgNVHRMBAf8ECDAGAQH/
AgEAMB0GA1UdDgQWBBQAKTaeXHq6D68tUC3boCOFGLCgkjAfBgNVHSMEGDAWgBSubAWjkxPioufi
1xzWx/B/yGdToDB7BggrBgEFBQcBAQRvMG0wLgYIKwYBBQUHMAGGImh0dHA6Ly9vY3NwMi5nbG9i
YWxzaWduLmNvbS9yb290cjYwOwYIKwYBBQUHMAKGL2h0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5j
b20vY2FjZXJ0L3Jvb3QtcjYuY3J0MDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwuZ2xvYmFs
c2lnbi5jb20vcm9vdC1yNi5jcmwwEQYDVR0gBAowCDAGBgRVHSAAMA0GCSqGSIb3DQEBDAUAA4IC
AQCRkUdr1aIDRmkNI5jx5ggapGUThq0KcM2dzpMu314mJne8yKVXwzfKBtqbBjbUNMODnBkhvZcn
bHUStur2/nt1tP3ee8KyNhYxzv4DkI0NbV93JChXipfsan7YjdfEk5vI2Fq+wpbGALyyWBgfy79Y
IgbYWATB158tvEh5UO8kpGpjY95xv+070X3FYuGyeZyIvao26mN872FuxRxYhNLwGHIy38N9ASa1
Q3BTNKSrHrZngadofHglG5W3TMFR11JOEOAUHhUgpbVVvgCYgGA6dSX0y5z7k3rXVyjFOs7KBSXr
dJPKadpl4vqYphH7+P40nzBRcxJHrv5FeXlTrb+drjyXNjZSCmzfkOuCqPspBuJ7vab0/9oeNERg
nz6SLCjLKcDXbMbKcRXgNhFBlzN4OUBqieSBXk80w2Nzx12KvNj758WavxOsXIbX0Zxwo1h3uw75
AI2v8qwFWXNclO8qW2VXoq6kihWpeiuvDmFfSAwRLxwwIjgUuzG9SaQ+pOomuaC7QTKWMI0hL0b4
mEPq9GsPPQq1UmwkcYFJ/Z4I93DZuKcXmKMmuANTS6wxwIEw8Q5MQ6y9fbJxGEOgOgYL4QIqNULb
5CYPnt2LeiIiEnh8Uuh8tawqSjnR0h7Bv5q4mgo3L1Z9QQuexUntWD96t4o0q1jXWLyrpgP7Zcnu
CzCCBYMwggNroAMCAQICDkXmuwODM8OFZUjm/0VRMA0GCSqGSIb3DQEBDAUAMEwxIDAeBgNVBAsT
F0dsb2JhbFNpZ24gUm9vdCBDQSAtIFI2MRMwEQYDVQQKEwpHbG9iYWxTaWduMRMwEQYDVQQDEwpH
bG9iYWxTaWduMB4XDTE0MTIxMDAwMDAwMFoXDTM0MTIxMDAwMDAwMFowTDEgMB4GA1UECxMXR2xv
YmFsU2lnbiBSb290IENBIC0gUjYxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMTCkdsb2Jh
bFNpZ24wggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQCVB+hzymb57BTKezz3DQjxtEUL
LIK0SMbrWzyug7hBkjMUpG9/6SrMxrCIa8W2idHGsv8UzlEUIexK3RtaxtaH7k06FQbtZGYLkoDK
RN5zlE7zp4l/T3hjCMgSUG1CZi9NuXkoTVIaihqAtxmBDn7EirxkTCEcQ2jXPTyKxbJm1ZCatzEG
xb7ibTIGph75ueuqo7i/voJjUNDwGInf5A959eqiHyrScC5757yTu21T4kh8jBAHOP9msndhfuDq
jDyqtKT285VKEgdt/Yyyic/QoGF3yFh0sNQjOvddOsqi250J3l1ELZDxgc1Xkvp+vFAEYzTfa5MY
vms2sjnkrCQ2t/DvthwTV5O23rL44oW3c6K4NapF8uCdNqFvVIrxclZuLojFUUJEFZTuo8U4lptO
TloLR/MGNkl3MLxxN+Wm7CEIdfzmYRY/d9XZkZeECmzUAk10wBTt/Tn7g/JeFKEEsAvp/u6P4W4L
sgizYWYJarEGOmWWWcDwNf3J2iiNGhGHcIEKqJp1HZ46hgUAntuA1iX53AWeJ1lMdjlb6vmlodiD
D9H/3zAR+YXPM0j1ym1kFCx6WE/TSwhJxZVkGmMOeT31s4zKWK2cQkV5bg6HGVxUsWW2v4yb3BPp
DW+4LtxnbsmLEbWEFIoAGXCDeZGXkdQaJ783HjIH2BRjPChMrwIDAQABo2MwYTAOBgNVHQ8BAf8E
BAMCAQYwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQUrmwFo5MT4qLn4tcc1sfwf8hnU6AwHwYD
VR0jBBgwFoAUrmwFo5MT4qLn4tcc1sfwf8hnU6AwDQYJKoZIhvcNAQEMBQADggIBAIMl7ejR/ZVS
zZ7ABKCRaeZc0ITe3K2iT+hHeNZlmKlbqDyHfAKK0W63FnPmX8BUmNV0vsHN4hGRrSMYPd3hckSW
tJVewHuOmXgWQxNWV7Oiszu1d9xAcqyj65s1PrEIIaHnxEM3eTK+teecLEy8QymZjjDTrCHg4x36
2AczdlQAIiq5TSAucGja5VP8g1zTnfL/RAxEZvLS471GABptArolXY2hMVHdVEYcTduZlu8aHARc
phXveOB5/l3bPqpMVf2aFalv4ab733Aw6cPuQkbtwpMFifp9Y3s/0HGBfADomK4OeDTDJfuvCp8g
a907E48SjOJBGkh6c6B3ace2XH+CyB7+WBsoK6hsrV5twAXSe7frgP4lN/4Cm2isQl3D7vXM3PBQ
ddI2aZzmewTfbgZptt4KCUhZh+t7FGB6ZKppQ++Rx0zsGN1s71MtjJnhXvJyPs9UyL1n7KQPTEX/
07kwIwdMjxC/hpbZmVq0mVccpMy7FYlTuiwFD+TEnhmxGDTVTJ267fcfrySVBHioA7vugeXaX3yL
SqGQdCWnsz5LyCxWvcfI7zjiXJLwefechLp0LWEBIH5+0fJPB1lfiy1DUutGDJTh9WZHeXfVVFsf
rSQ3y0VaTqBESMjYsJnFFYQJ9tZJScBluOYacW6gqPGC6EU+bNYC1wpngwVayaQQMIIGkzCCBHug
AwIBAgIMPLvp1FinrmXIXZzjMA0GCSqGSIb3DQEBCwUAMFIxCzAJBgNVBAYTAkJFMRkwFwYDVQQK
ExBHbG9iYWxTaWduIG52LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWduIEdDQyBSNiBTTUlNRSBDQSAy
MDIzMB4XDTI1MDYyMDEzNTI0NFoXDTI3MDYyMTEzNTI0NFowgdoxCzAJBgNVBAYTAlVTMRMwEQYD
VQQIEwpDYWxpZm9ybmlhMREwDwYDVQQHEwhTYW4gSm9zZTEZMBcGA1UEYRMQTlRSVVMrREUtNjYx
MDExNzEPMA0GA1UEBBMGWGF2aWVyMQ8wDQYDVQQqEwZTZWx2aW4xFjAUBgNVBAoTDUJST0FEQ09N
IElOQy4xIzAhBgNVBAMMGnNlbHZpbi54YXZpZXJAYnJvYWRjb20uY29tMSkwJwYJKoZIhvcNAQkB
FhpzZWx2aW4ueGF2aWVyQGJyb2FkY29tLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBALyww4rAbY/uRJ/p/H3RRc0ipz0vxZgIXUdvhNOrG9uErj7X64vntdJTkcN1BOWQC1xpmt5e
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
yQXRJ8N58JpbjME05ufFzT0zYEyvS5abhLGaEgdqRWEwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEH
ATAcBgkqhkiG9w0BCQUxDxcNMjYwNzI3MDY1NjU5WjBcBgkqhkiG9w0BCQ8xTzBNMAsGCWCGSAFl
AwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBBzAL
BglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAHsYD/rLXnAVcltsFfd612BIIMze9T6yxkrz8
IW9uTJCTUyM1zc65pKEHWW82j2oOMxturZLTMRKBY3Q5e+sLEr0ExMPMqo4HsFM5A0FuvI2XZKyy
It+UhVEBdjXf9voXu3A191OpkUOdJwaeUnDI2cRVDn9NGDvVt9dLaCu+p4xw4cQZ54aiwpIZhZVY
ZJRXEyBKgT11Fh7UvJj7/l4bTfPsTCbtP9j7nzkFrc9vq+e0IeGfa6JOpneklNnsNSMKMShJcIer
FLXySGJlZFlbixQRNpMAweLffL9nmCduJVwEOGw+xDb+TEtiv5OMrjHaP1ZqQixuG9fNSIBDrFua
6g==
--00000000000093a0fa0657923ac5--
