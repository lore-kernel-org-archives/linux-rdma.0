Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.173
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793654897;
	b=FYWPWHIqYWZ7Dw1EiQswY/XJN12fq9wFLrihSweMQhyE+dhyTzp/f9lYKdSlRTVGvvfI
	 JHQNgnMt9EURWucBYpQ53u4hk76xWhgtvwt+y0ZaaEJH8jSTYuSp6oMG0XDoEtX+hdg3O
	 uOgfVTtwGes+gLpv9B9c9wIxfXcDY19TuLI+/ghfSqHVVj2fBuE2IjmqswEv4gM2KaBuB
	 mG6BWSVVuI5g3qlV6fztxQdTLnydRVuMwweC3ZXiQFDqyK3VbrLaUy0ZPFKoR6vRasihY
	 bviGw1vZfUkoYs5zHv4hpA8RswA5DUt1/Q6ZpjqO8bzl3u9PZ/iyQRY43K2g/7wpxWQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793654897;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=05WhMxae0rz15h1TGq0mYQ3vTYNApMzOi4Y++NBdM+w=;
	b=ET2I9O9H3swbo8r/QPz2K5kcKGEc7wLdJK2j9fuM8plDD5uXQH4nJSKRVsXtv8ZSowOu
	 dJQgt+zsEihkP5+ABflzcYh4ddqXXsuuz4ByXMVpWE9ttSbyUYq0kHxGJthQXIaFZxpxj
	 nooSls45ene8GRetFgeVG6J6U6Zt7/mULu4XhIpjhROcHiw5U4TuAn1Xyn8KxtDyMErA7
	 UFbiYguG1th9jm38F/U8uDXlFqOIqYtZbg10rClboKV8XvBOrLwLfZZV8fsaJNU9CCIGV
	 yNcglG59UuBknh4W6URys4h4GvLt1IZ9SwmwkE0U9HUh5nJzfFo5Qj0FpksEO5LXHQg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=x6u.co;
	spf=pass smtp.mailfrom=x6u.co;
	dkim=pass header.d=x6u.co header.i=@x6u.co header.a=rsa-sha256 header.s=google header.b=hEG4+6q+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.173
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3808A606A324
	for <linux-rdma@vger.kernel.org>; Mon,  2 Nov 2026 21:28:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3808A606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=x6u.co
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=x6u.co header.i=@x6u.co header.a=rsa-sha256 header.s=google header.b=hEG4+6q+
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-35b2c599f43so5962087eec.0
        for <linux-rdma@vger.kernel.org>; Mon, 02 Nov 2026 13:28:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793654895; cv=none;
        d=google.com; s=arc-20260327;
        b=DOo8uF2d4qZyAyMhqc/24lhztjMF+0GO9Cjo6RF3THGkg3/CtE9QOTO8sxp9kK4Jk0
         34vC7rStktTElD6mzsQnjPpA8f0ToSRiu8dq7wKh8MbdboQ+E4APaBpJpxWUgqPswGJK
         sLv61eCk+j76X3HJMDLxlII2fpZmfmQzDhJKsk0q8lSBsLI5NAnaZbxnwdUJabrXM1BY
         q9wq6CEy1yDIYzmftVnPQXBQ4hMmwklDwbeJSjfGCuwbMKpi7Ci1S1DCZa9NgA4Mxa90
         So9H3aDjbg8mkeFzf6BR0ABrnHebEIGJv2GJ6CJ6QMInfjUx1RRVv9f7+dW4dyEv7TP8
         n0AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=05WhMxae0rz15h1TGq0mYQ3vTYNApMzOi4Y++NBdM+w=;
        fh=6t8yjtqkLGjTOpT2lPKEXlx5HWZqQIKOMugbfiE1r2o=;
        b=YCNDYprKnWrc2lbkMqQbOGrmmce1duENN1a5m6xJIiLL1mYnRCvKO6YlOxcD+jdjnB
         irC/a/s4iu4koRg8SaQ6svqYO4IuXtOC4VAmtR8TaEmeyyur/qAO2wRww2YtioucaYdY
         FaU9MumM6EAwpYlAcBHW4tjoBBcasR7E1AreyYJR3bfCGWoxyZeauOoCI+L2uPRroliY
         I15MJN4nODEAorji1aZ9HQA+6cpjSS4xNL48+QnExDSyozQ1Pf+NZVMQFRoyFSe8wAtD
         5YoOniC3r18ldaCy1yYlIEHziJhEp3G3hTM9MwBtc5B3HZrenU1EY2ijJeuHxlfimgX0
         fbiw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=x6u.co; s=google; t=1793654895; x=1794259695; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=05WhMxae0rz15h1TGq0mYQ3vTYNApMzOi4Y++NBdM+w=;
        b=hEG4+6q+KyVPPUo8SnlyqwcXoS0RVm1MxiQlzJat8aHKaQZubChz3jtickPF9oSle7
         n0XuQtb0VtKXE7pRYtHKvihXPltq83G1g3fF2idqzO4R6gtMXFkNfIdb127clfcPdzzx
         kxNj4OcHvfdTxul0rW+cMIzXdlyn6gmPx4ib5OflV9fHuVV21yT+aXGjztyrydmTv1bU
         1zrTtt+sENlAM6Dn2g+3fl31l1l1nPXEKOQ+iIouzBiU0yEblZME2a3ZcetnIWoFPjGb
         AF8p0e3mI5+1+bCVbHRmt7aV4DcmQv+Ne8CPjnrl6kcEcRz4YRFV6dsIEOYMaUeQeJ5J
         O2GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793654895; x=1794259695;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=05WhMxae0rz15h1TGq0mYQ3vTYNApMzOi4Y++NBdM+w=;
        b=exPu80DiPWqjQvwR6B0sbpif5h/7YaAUMVm+oEfnYCSMUDML40LQ7QvaMy4odnZnvA
         qNktAgVqZSrATIikyr6xXsHvbT3L+1BY2LGkljrS/Cd0clen/i/JsfP5KpqaK7eFs3cz
         qSaxIVFJqxWgRUIl2xCrOntpxjq8abfKMZQ+9JHSvJyy+TIgXrMMe5/sNUFkHnitiH3t
         Oh2epUb841mCaUBtJIWopldliAtEKD+BEacSEpce12RfBVZI8jLMq9DzktR+Jl6KFL+W
         OTfkRmGW2IAteIWwoEglI/Zkr/d3U9OAALMgzP8ZKudww/HjMdUVWMdHpGBMjRhGJpyN
         bTVA==
X-Forwarded-Encrypted: i=1; AKwUvBzax7L5cyuCKc3c9p4+2CBYr9FySTEAsamqZAvEcIv48/GObR42+E9DqJjzDiqpTvnXd8Pj8NMtUXlL@vger.kernel.org
X-Gm-Message-State: APuU4Z84IIRH9ZOc3C1rawHGTmlAMvGMUfuFYjCYh2RVSQtda4kngJjq
	PtDCGtd36j7Xmqb9cH/nIZNVy2GXgP9Gv47nbXl8vIh+Wv4c4mJNOF9ndiv/dMM13sxLho0se48
	jJ+vaeSJhtA4kl0O6zQMj5qF/7XGxuC2Q1iacdNdm7OUyTzIDw8lZOw==
X-Gm-Gg: AYBFou3UmEg+5QSOKmMi9AfVTT4Eec/KlrItNH+SxyHhvqv91lBug7OrjOsXmwucpAG
	GIwSZ9MONX29ArbL38aI4ISKGdCbrv1qMVZHTpuKIE9hk5hCQUiPJnvISq6wPz/LgjdLRiUnGj4
	DesZ71rGONuz4Se3L9dV+eVOuU3xnL76uFcUpC6KjLLfhU80NV6AmX9uHCP/MOvsrU7yi+SNXoQ
	YuBsIkpu/Dw/5rXbZjTfXugqQ8d+UUvcO70ZlMHNdbS4Y8jB0kRrhMwU5DHU9Eus4lJjn/igApR
	6dcV+mfTTVx5pRqTxEh+ENiu7TyRNexI5PhSsG3p61HlQNmSvSbYsSnx7BIWJG2dwYiqRq/UVfv
	jSSdVo6uagXnp7+s9k4wX2UuoiYyhG5pHz2hkzPENBuXiabUqVdK0VR+9XtziAD9Zduj+D+VtEm
	5+2f3kuwiIWR9NGJecNAZyfD9IP1NQQDaQ2U8wbL9F0u/t
X-Received: by 2002:a05:7300:a9f:b0:369:fb01:2eb7 with SMTP id
 5a478bee46e88-36a4235f45emr16292049eec.13.1793654895131; Mon, 02 Nov 2026
 13:28:15 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261030181512.2056056-1-dhu@x6u.co> <20261030181512.2056056-6-dhu@x6u.co>
 <sashiko-outbox-191412@kernel.org>
In-Reply-To: <sashiko-outbox-191412@kernel.org>
From: David Hu <dhu@x6u.co>
Date: Mon, 2 Nov 2026 16:28:04 -0500
X-Gm-Features: AclHuK_7wNCsAnLumnQoSsGTieVm4sqRwJoszEVTk588c59ZDICEF5LaB7IXra8
Message-ID: <CABdL-LQPkSO74Fn+Cv1XxCmESq+7cNFG1-Km6FwqKYh_hQ+3AQ@mail.gmail.com>
Subject: Re: [PATCH rdma-next v4 5/6] RDMA/irdma: Support UMEM attribute for
 CQ creation
To: sashiko-reviews@lists.linux.dev
Cc: intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 30, 2026 at 2:33=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [Medium] RDMA/irdma: wrong DMA direction in irdma_setup_umode_cq() via =
ib_umem_get_cq_buf()
> --
>
> commit 8981c5869a8245f4b87a31412a16b517815f3a39
> Author: David Hu <xuehaohu@google.com>
>
> RDMA/irdma: Support UMEM attribute for CQ creation
>
> This commit adds support for one-step user-mode CQ buffer creation using
> UVERBS_ATTR_CREATE_CQ_BUF_UMEM and IRDMA_IB_ATTR_CREATE_CQ_SHADOW_BUF_UME=
M,
> sets up hardware PBLEs directly from the pinned UMEMs, and adds UMEM and =
PBLE
> cleanup in irdma_cq_free_rsrc() and irdma_resize_cq().
>
> > diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/h=
w/irdma/verbs.c
> > index 9f4905fdb791a..41e56ab8aa6df 100644
> > --- a/drivers/infiniband/hw/irdma/verbs.c
> > +++ b/drivers/infiniband/hw/irdma/verbs.c
>
> [ ... ]
>
> > @@ -2767,26 +2793,87 @@ static int irdma_setup_umode_cq(struct irdma_de=
vice *iwdev,
> >       if (err_code)
> >               return err_code;
> >
> > -     spin_lock_irqsave(&ucontext->cq_reg_mem_list_lock, flags);
> > -     iwcq->iwpbl =3D irdma_get_pbl((unsigned long)req.user_cq_buf,
> > -                                 &ucontext->cq_reg_mem_list);
> > -     spin_unlock_irqrestore(&ucontext->cq_reg_mem_list_lock, flags);
> > -     if (!iwcq->iwpbl)
> > -             return -EPROTO;
> > +     cqe_64byte_ena =3D dev->hw_attrs.uk_attrs.feature_flags & IRDMA_F=
EATURE_64_BYTE_CQE ?
> > +                      true : false;
> > +     cqe_size =3D cqe_64byte_ena ? 64 : 32;
> > +
> > +     if (uverbs_attr_is_valid(attrs, UVERBS_ATTR_CREATE_CQ_BUF_UMEM)) =
{
> > +             struct ib_umem *umem;
> > +             struct irdma_mem_reg_req cq_req =3D {};
> > +             u8 shadow_pgcnt =3D (rf->sc_dev.hw_attrs.uk_attrs.feature=
_flags &
> > +                                IRDMA_FEATURE_CQ_RESIZE) ? 0 : IRDMA_S=
HADOW_PGCNT;
> > +             u32 min_size;
> > +
> > +             cq_req.cq_pages =3D DIV_ROUND_UP(ukinfo->cq_size * cqe_si=
ze,
> > +                                            IRDMA_HW_PAGE_SIZE);
> > +             min_size =3D (cq_req.cq_pages + shadow_pgcnt) << IRDMA_HW=
_PAGE_SHIFT;
> > +
> > +             umem =3D ib_umem_get_cq_buf(&iwdev->ibdev, attrs, min_siz=
e,
> > +                                       IB_ACCESS_LOCAL_WRITE);
>
> [Severity: Medium]
> When IRDMA_FEATURE_CQ_RESIZE is not set in
> rf->sc_dev.hw_attrs.uk_attrs.feature_flags, the UMEM passed via
> UVERBS_ATTR_CREATE_CQ_BUF_UMEM backs both the CQ ring and the trailing sh=
adow
> area page (shadow_pgcnt is IRDMA_SHADOW_PGCNT, and irdma_setup_umode_cq()
> later sets info->shadow_area_pa =3D cqmr->shadow from that same UMEM).
>
> However, ib_umem_get_cq_buf() in drivers/infiniband/core/umem.c hardcodes
> DMA_FROM_DEVICE instead of deriving DMA_BIDIRECTIONAL from
> IB_ACCESS_LOCAL_WRITE:
>
> drivers/infiniband/core/umem.c:ib_umem_get_cq_buf() {
>         return ib_umem_get_from_attrs(device, attrs,
>                                       UVERBS_ATTR_CREATE_CQ_BUF_UMEM,
>                                       uverbs_create_cq_get_buffer_desc,
>                                       size, access, DMA_FROM_DEVICE);
> }
>
> Since the CPU writes the CQ head index to the shadow area and hardware re=
ads
> shadow_area_pa via DMA, mapping this UMEM with DMA_FROM_DEVICE omits IOMM=
U
> read permissions (and skips CPU-to-device bounce buffer syncs).
>
> Should irdma_setup_umode_cq() use ib_umem_get_attr() with
> UVERBS_ATTR_CREATE_CQ_BUF_UMEM when IRDMA_FEATURE_CQ_RESIZE is not set (o=
r
> unconditionally, as noted in the commit message) so the buffer is mapped =
with
> DMA_BIDIRECTIONAL?

This finding is not practical.

The AI finding alludes to a very narrow scenario on older HW (Gen 1,
iWarp) without CQ resize. With iommu on, `DMA_FROM_DEVICE` leads to
lack of IOMMU_READ for NIC iommu group, and leads to iommu faults,
while NIC tries to fetch CQ consumer index from shadow area in dram.
This will only happen for VA, since dma-buf in iWarp is rejected.

However, `UVERBS_ATTR_CREATE_CQ_BUF_UMEM` will never land in kernel in
case of VA, since `fill_attr_in_buf_umem` (in ucreate_cq) skips VA.

Further, switching to `ib_umem_get_attr()` would also mean mapping
DMA_BIDIRECTIONAL for cq buf for Gen2, and Gen3 (when cq resize is
possible), defeating the standards established in ib core.

>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030181512.20=
56056-1-dhu@x6u.co?part=3D5
