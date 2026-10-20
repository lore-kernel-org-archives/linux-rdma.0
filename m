Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.177
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792537605;
	b=kD2i+kNDKtIa2LKX72lnBnt4DaxHo8aXkjJWgmLU5TD+7VTPNAbd2Yla5R1bJBYU6IIP
	 r4UxQxyOzEBhR1cNkFEHPUIdVfwXakfSq3nv8RTOpY1OrHTRtmEia1uUx0PyJrGvmOjUT
	 Y6e4q3z5XPppnF7qVhPABCi/jYJ2FyEcNYxn3VIGOTd3uOqHk9tAwWsoTDrXsxrJAFQ8f
	 NwY3fUbZkc5O3tq9fOUWKkKcv+3ZNILJOF2ahft3K6a7tmWkOSTh0FDXhLdRaVSCEhne/
	 Oj9f9YPzPXGRTd3fQsOyeZFZ/eVtj77iccJMfdcmJ+n8qrJ+d0hPoyEuJAmI3Odaejw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792537605;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=va6egunWkEGRYKak1VVc3OBpB5rdaiauwOcFiqC3P6w=;
	b=D9woy+VqZTuiBEhstBly9fDq8DsRUoAyR7OMtRzn7nCn1Be6Mo/T4rz44k0A41qE2rK0
	 o6FbqbAWMjIl9G25CGIhLCmD9t8BNU69mkmAWkJipCka5G2l9qzE5XnrwrZXWIzOeY5wu
	 a5tE02JR+5a8/mdRHV7lap/Fw/ztcDm8EfCR/oMXjz1eYeRP+qfeCbU8/H/QZE4wTMGF0
	 0AM1EUx6brT1kCt+4eyu1D7HTyd4CJqA5pZzEzn119qYc3DOA9TbRdkz1KpDAyFHknxEN
	 QghB55eOAfke8SURaxo647J4ms0f4JnXHVqUmKRgJW4eb7kQlVnRxR2Ya3j2sPjzTLA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=x6u.co;
	spf=pass smtp.mailfrom=x6u.co;
	dkim=pass header.d=x6u.co header.i=@x6u.co header.a=rsa-sha256 header.s=google header.b=JjDtBwsV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.177
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552C8606A31A
	for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 23:06:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 552C8606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=x6u.co
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=x6u.co header.i=@x6u.co header.a=rsa-sha256 header.s=google header.b=JjDtBwsV
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-33bf40b0c8bso344630eec.0
        for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 16:06:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792537604; cv=none;
        d=google.com; s=arc-20260327;
        b=rdk8o2DI42L+08+FLymo8+9tySk7EXFqYqGm1KzzFvHUlD42csrWQ3PgyaL4qtF2JV
         yv4ryx7Qv7fq9OYUHUpUf7PfkPfgfgX9dZhXkIzpZFVuXlAG+YabhKzryLTUe0dFCsuK
         Jg2s6zSy9JZyhyTWz4flIVD6u4taZZJDP+uM6cyt1nkA45Kp2LyndaE+uSuWNrYYPnqJ
         MlnWTamYUdgOEaSoIaq3LC75MoehSL1cAfiql+sY9fHC91NcEIH0d+VDyg9IsYWgH6Wz
         GsrChvp487AHZo7jmrLGy8rLcZl99EzgXXshYIITifnsHEucyemQbkOZCNSVrzawMRCU
         vXsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=va6egunWkEGRYKak1VVc3OBpB5rdaiauwOcFiqC3P6w=;
        fh=Je+XfjZZELYMeUFG782y9M4oZFPTVtwBgMoamcbwTg0=;
        b=jTIMt3B/Es0tJ0ckOy7LV9OEwy2XOqSBzL+68CxeCL3Rs39C37zeD0RW6wA+FQgORj
         QtG1n2uO9t4PAKh+QLksGJ0ACfQzdg5ljiUe/7qGSAfDmamovUv77ehUKrtBH5FA6WUK
         bVMQbyijnV/2MDfVKY4zWibeJ7RGkzwUfn2cras8i+Xw4fiZwVnHNFYBgWeqDr5W6dpm
         G7y/PyKCVIIu6qyGONaeGd/7Mz14oLyy/7XUG0uy5Tisza+HjNdpWL9oEtTdy0vUFZlx
         WyQLgM1KOpoZJP5LOSq7ZC9gdkN9nEJWANVEDch9y9L5KCLmOKwNwCSCVTY1W0cTgD2N
         adHg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=x6u.co; s=google; t=1792537604; x=1793142404; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=va6egunWkEGRYKak1VVc3OBpB5rdaiauwOcFiqC3P6w=;
        b=JjDtBwsV3IPGtFsq93v+q9uWpJsX9A5u2vcdjRw+fxYxOO5X3GWWZGYkj1NuA+H8RG
         Eezqgushc+2VlGO1gkcPT/fZvQWxek9/JMipLnmxE1ylAIwN4IBjbCVJ6pALGbpFwQjb
         z1geN3BN7REPhuWXtEho49eI5L9vqOZ9Mm3RqU1gCCkWF3H74/elTbH+iDe5D5OqqY44
         L5NtekzVjTmtOOC3yBLCa3yUsBbIdMUofqlXk5G7dJXclcjEVlb0rrHwc6HLoPXKZYns
         FZMx8NzspN40jyzGVqm9+z3xUCW7yW4rDz6piI9uQk8HgcUnDWPH+WLNLrDNW6wHIsca
         l5Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792537604; x=1793142404;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=va6egunWkEGRYKak1VVc3OBpB5rdaiauwOcFiqC3P6w=;
        b=dI3rGa3XYQr/WVICIjnIFIGO9svhAKtJTNawxuh++s8PBQpHBkd9rbYnXqCxlwPjEd
         lZ88ZPgq0T3HdW+Yb6xj2xXqBZL7HUB88uA0ZYESdNb4mBhdSLrNBauzMDQq+yu6FXVQ
         uK85VIFmQZEh74vrKHft/gm/V28JtuBZnBkB8wCKmo3pdmUaKO/4mql++c9M3H9m9cV6
         boba0jntzegR3TTcc2O94BOVr9YriY6o7wM3fhfSRukad1WBGlZLg0RgGFzCgaTjbeA3
         HyuoqGT0UGcuBqfppqCLD619Uq/erjG2hAF30IxYMelJlAdBkO98Vd2o9rPa0+r6xDWo
         tqGA==
X-Gm-Message-State: AFq9FYJ1G/k0q51c/pFs/sGfn2IxmmXjisWv6G8ztx8xuC7nX/7vElsV
	Tj+LwkBZonQKFXAEHrTo2GEdIgvG5Bw+3AgV9uXA+XvyMzzHyx8rN4oJqKnGrI1zGd6BP9rFZmZ
	ukyxuRAuOryXTpA4bKzoA0zRCOFxRX9w68lpSqnhDYOLXx5DEtfxzyCh4
X-Gm-Gg: AYBFou1V7UxB2zT+i3QZ0KPBNZUY7bFAvYGTAKg49C+ugFKpb8tBDaA/arTyeZZdVeA
	1XdK5Hnoi0RD1Vn241/fua0n7noIYA0uUZSOHljfd6GEUj5jvKXhO98VR0x/GWXFceKPy1DNpuR
	WwP9YGX3HsU8uKZmzqOluqLC1oOLB46vb5bzVa6qeAjEApkfu82B1cUB5Ern1yHVkPpfIGtcuTZ
	VSZIl54x2lKDEUKZEjebOEoM+Rq3gOT0UweRTRoZ512bWsA7I20y/fWnXoPFMpknEmHEBXMN16T
	DjrF8UXz5gFwBrGEH6LP3v6PvP1OhUEV2UQZZLn0Pd0LSbUZvs8hKKJU/Wvrvv82FKy8y6iUmvp
	Nj5vg6tNVBWzWcvyArF2L2cjZ91AQtydw9QFmLuDG8nblLG85use9
X-Received: by 2002:a05:7301:150e:b0:35c:8abb:b4ae with SMTP id
 5a478bee46e88-3674f21ac5cmr985386eec.25.1792537603985; Tue, 20 Oct 2026
 16:06:43 -0700 (PDT)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261016202909.1289496-1-dhu@x6u.co> <20261016202909.1289496-4-dhu@x6u.co>
 <sashiko-outbox-174922@kernel.org>
In-Reply-To: <sashiko-outbox-174922@kernel.org>
From: David Hu <dhu@x6u.co>
Date: Tue, 20 Oct 2026 19:06:32 -0400
X-Gm-Features: AclHuK-t7bu1YsPmx0t33N8Kecw-SsexQz8g2itTSLrXXxZiXwZB62bKOmc9ccc
Message-ID: <CABdL-LTgFTwJPTD0vyScNsvCSAW_04TgOyO1swVBgHxDcmJsfg@mail.gmail.com>
Subject: Re: [PATCH rdma-next v3 3/6] RDMA/irdma: Support UMEM attribute for
 QP creation
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 16, 2026 at 4:46=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [Critical] RDMA/irdma: invalid sg_page() on dmabuf QP umem in irdma_cop=
y_user_pgaddrs()
> --
>
> commit 200a925805870f2d575192eafe96be3cef694b7d
> Author: David Hu <xuehaohu@google.com>
>
> RDMA/irdma: Support UMEM attribute for QP creation
>
> This commit adds support for the 1-step queue buffer creation model for Q=
Ps
> via UVERBS_ATTR_CREATE_QP_BUF_UMEM and ib_umem_get_attr(), while retainin=
g
> backward compatibility with the legacy 2-step MR registration model.
>
> > diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/h=
w/irdma/verbs.c
> > index b2ffdc8e3d677..ab25445f38282 100644
> > --- a/drivers/infiniband/hw/irdma/verbs.c
> > +++ b/drivers/infiniband/hw/irdma/verbs.c
> [ ... ]
> > @@ -713,6 +708,52 @@ static int irdma_setup_umode_qp(struct irdma_ucont=
ext *ucontext,
> >               ukinfo->rq_size =3D ukinfo->rq_depth >> ukinfo->rq_shift;
> >       }
> >
> > +     if (attrs && uverbs_attr_is_valid(attrs, UVERBS_ATTR_CREATE_QP_BU=
F_UMEM)) {
> > +             struct irdma_mem_reg_req qp_req =3D {};
> > +             struct ib_umem *umem;
> > +             u32 total;
> > +
> > +             /* Legacy context does not provide depth info */
> > +             if (!ucontext->use_raw_attrs)
> > +                     return -EOPNOTSUPP;
> > +
> > +             qp_req.sq_pages =3D DIV_ROUND_UP(ukinfo->sq_depth * IRDMA=
_QP_WQE_MIN_SIZE,
> > +                                            IRDMA_HW_PAGE_SIZE);
> > +             /* In case srq is used, this will be a single page */
> > +             qp_req.rq_pages =3D DIV_ROUND_UP(ukinfo->rq_depth * IRDMA=
_QP_WQE_MIN_SIZE,
> > +                                            IRDMA_HW_PAGE_SIZE);
> > +             total =3D qp_req.sq_pages + qp_req.rq_pages + IRDMA_SHADO=
W_PGCNT;
> > +
> > +             umem =3D ib_umem_get_attr(&iwdev->ibdev, attrs,
> > +                                     UVERBS_ATTR_CREATE_QP_BUF_UMEM,
> > +                                     total << IRDMA_HW_PAGE_SHIFT,
> > +                                     IB_ACCESS_LOCAL_WRITE);
> > +             if (IS_ERR(umem))
> > +                     return PTR_ERR(umem);
> > +
> > +             iwqp->iwpbl =3D irdma_setup_q_pbl_from_umem(iwdev, umem,
> > +                                                       iwqp->ibqp.pd,
> > +                                                       IRDMA_MEMREG_TY=
PE_QP,
> > +                                                       &qp_req);
> [ ... ]
> > @@ -3532,6 +3574,64 @@ static void irdma_free_iwmr(struct irdma_mr *iwm=
r)
> >       kfree(iwmr);
> >  }
> >
> > +static struct irdma_pbl *irdma_setup_q_pbl_from_umem(struct irdma_devi=
ce *iwdev,
> > +                                                  struct ib_umem *regi=
on,
> > +                                                  struct ib_pd *pd,
> > +                                                  enum irdma_memreg_ty=
pe reg_type,
> > +                                                  struct irdma_mem_reg=
_req *req)
> > +{
> > +     struct irdma_pbl *iwpbl;
> > +     struct irdma_mr *iwmr;
> > +     u32 total;
> > +     u8 lvl;
> > +     int err;
> > +
> > +     /* iWarp: Catch page not starting on OS page boundary */
> > +     if (!rdma_protocol_roce(&iwdev->ibdev, 1) && ib_umem_offset(regio=
n))
> > +             return ERR_PTR(-EINVAL);
>
> [Severity: Critical]
> Can passing an IB_UVERBS_BUFFER_TYPE_DMABUF descriptor via
> UVERBS_ATTR_CREATE_QP_BUF_UMEM cause a NULL pointer dereference or write =
to
> the wrong page during iWARP connection establishment?
>
> In irdma_setup_umode_qp(), ib_umem_get_attr() resolves the buffer descrip=
tor
> through __ib_umem_get_desc_dir(), which accepts both IB_UVERBS_BUFFER_TYP=
E_VA
> and IB_UVERBS_BUFFER_TYPE_DMABUF. Previously, IRDMA_MEMREG_TYPE_QP MRs co=
uld
> only be registered via irdma_reg_user_mr() -> ib_umem_get_va(), whereas
> irdma_reg_user_mr_dmabuf() hardcoded IRDMA_MEMREG_TYPE_MEM.
>
> When irdma_setup_q_pbl_from_umem() calls irdma_handle_q_mem() ->
> irdma_setup_pbles() -> irdma_copy_user_pgaddrs(), the driver extracts the
> first SQ page from the scatterlist:
>
> drivers/infiniband/hw/irdma/verbs.c:irdma_copy_user_pgaddrs() {
>         if (iwmr->type =3D=3D IRDMA_MEMREG_TYPE_QP)
>                 iwpbl->qp_mr.sq_page =3D sg_page(region->sgt_append.sgt.s=
gl);
> }
>
> and irdma_setup_virt_qp() assigns iwqp->page =3D qpmr->sq_page, while
> iwqp->sc_qp.qp_uk.sq_base remains NULL for a user-mode QP.
>
> On an iWARP device, irdma_accept() and irdma_cm_event_connected() map
> iwqp->page to write the LSMM or RTT WQE:
>
> drivers/infiniband/hw/irdma/cm.c:irdma_accept() {
>         if (iwqp->page)
>                 iwqp->sc_qp.qp_uk.sq_base =3D kmap_local_page(iwqp->page)=
;
>
>         cm_node->lsmm_size =3D accept.size + conn_param->private_data_len=
;
>         irdma_sc_send_lsmm(&iwqp->sc_qp, iwqp->ietf_mem.va, cm_node->lsmm=
_size,
>                            ibmr->lkey);
> }
>
> drivers/infiniband/hw/irdma/cm.c:irdma_cm_event_connected() {
>         if (iwqp->page)
>                 iwqp->sc_qp.qp_uk.sq_base =3D kmap_local_page(iwqp->page)=
;
>         irdma_sc_send_rtt(&iwqp->sc_qp, read0);
>         if (iwqp->page)
>                 kunmap_local(iwqp->sc_qp.qp_uk.sq_base);
> }
>
> With a dmabuf-backed ib_umem, calling sg_page() on the scatterlist breaks=
 in
> two ways:
>
> 1. When CONFIG_DMABUF_DEBUG is enabled (where dma_buf_wrap_sg_table() cle=
ars
>    page_link) or when the exporter does not populate struct page pointers
>    (such as uverbs_dmabuf or P2P/MMIO exporters), sg_page() returns NULL.
>    This leaves iwqp->page NULL, so irdma_accept() and
>    irdma_cm_event_connected() skip kmap_local_page() and pass a NULL
>    qp_uk->sq_base into irdma_sc_send_lsmm() / irdma_sc_send_rtt(), which
>    immediately dereferences qp_uk->sq_base->elem.
>
> 2. Even when sg_page() is populated by a system-RAM exporter, if userspac=
e
>    passes a non-zero page-aligned offset within a coalesced multi-page SG
>    entry, ib_umem_dmabuf_map_pages() advances sg_dma_address(sg) and
>    decrements sg_dma_len(sg) in place without updating sg->page_link:
>
>    drivers/infiniband/core/umem_dmabuf.c:ib_umem_dmabuf_map_pages() {
>                 if (cur <=3D start && start < cur + sg_dma_len(sg)) {
>                         unsigned long offset =3D start - cur;
>
>                         umem_dmabuf->first_sg =3D sg;
>                         umem_dmabuf->first_sg_offset =3D offset;
>                         sg_dma_address(sg) +=3D offset;
>                         sg_dma_len(sg) -=3D offset;
>                         cur +=3D offset;
>                 }
>    }
>
>    As a result, sg_page(region->sgt_append.sgt.sgl) points to the start o=
f
>    that SG segment rather than the SQ page at the requested offset, causi=
ng
>    kmap_local_page(iwqp->page) to map and overwrite the wrong page.
>
> Should irdma_setup_q_pbl_from_umem() (or irdma_setup_umode_qp()) reject
> region->is_dmabuf, at least when !rdma_protocol_roce(&iwdev->ibdev, 1) (o=
r
> unconditionally if dmabuf queue rings are not supported)?
>

For irdma, dma-buf heap based queue is only supported on RoCEv2 (CVM),
not for iWARP.
So this is not an issue in practice.
