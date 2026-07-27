Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373313DCDA7
	for <linux-rdma@vger.kernel.org>; Mon, 27 Jul 2026 09:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785143276; cv=none; b=Uav9kXaMbxM/DGrtsZv7Xmik9M8Ckc6StdDk1c2pnhoWl4tN9cwktZCuP1vk47wiqJVOBq5Eu3E5OBW3osMRmUvGs8pQU9MxNAMrMlMyM1oi0hN1piiWKMDISlVBfMo89hcp6LXLXUqpilaNyE1UWicIqVmKpvdtnNPjmE+05Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785143276; c=relaxed/simple;
	bh=vaZVcZeXZqeXt+detpBh5X7mw907qJmQy2PnltZ8Chk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f6YOu/+0L8A7smRuhOXkydVdeZ4rgnrV6Hx6PkwuRoM6b+N5JqtRIXm6W2wlt0ACzCX2ohQt2voXLK4RKDl8iYrzLWIIE6sUPREtbRslC6BY3Vvu8AzjFD0dRn/E2f+n876oTC75EcXrDl2bIsQU9CavLizeoGfShfPRgqoBBUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XYNj31RP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XYNj31RP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10AE61F000E9;
	Mon, 27 Jul 2026 09:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785143274;
	bh=GThcWPBj2Ag01UGXIXOYJd57lFVct8B72wUEVBLQjAI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XYNj31RPSr1a9ae42mR98NXnVGAs+cUcLlcR3FYU38j6MglCktET2AOt/L0GmH6TK
	 9U66A73Wfugsd7yMZJ2MpvcK6uBWcilLUAeSQ3m2K0/JCW2A0HfxqgTTeUGECncPUl
	 IM6T6eg0AUNStCY/2En8D6lls9h2CrE6aDnfFai0iCJDT5RSyHvFQW3d2DP1KUqDok
	 QLNbGkCMjnCF68lV3X+FmkSVUB1Ssyggc5KubUy/vBygA3vPE29MjpsHICDxcHbKGQ
	 WKKsr5jt35cxkGOH3erBg/NsIH8sUwwESUO3SoK70woPvFf+rXK5M2Eof8OOk2zCai
	 84A2dXssEPmjg==
Date: Mon, 27 Jul 2026 12:07:50 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Selvin Xavier <selvin.xavier@broadcom.com>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com, kalesh-anakkur.purayil@broadcom.com,
	sriharsha.basavapatna@broadcom.com, alhouseenyousef@gmail.com,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH for-next v4 3/4] RDMA/bnxt_re: Add uverbs object handle
 path for CQ/SRQ toggle page
Message-ID: <20260727090750.GK12003@unreal>
References: <20260721115440.24021-1-selvin.xavier@broadcom.com>
 <20260721115440.24021-4-selvin.xavier@broadcom.com>
 <20260727062128.GI12003@unreal>
 <CA+sbYW1Zxm9KhfqtSZodpgcSE2ARfrq4YMS_s1+Xo=H_Qd+WsA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+sbYW1Zxm9KhfqtSZodpgcSE2ARfrq4YMS_s1+Xo=H_Qd+WsA@mail.gmail.com>

On Mon, Jul 27, 2026 at 12:26:46PM +0530, Selvin Xavier wrote:
> On Mon, Jul 27, 2026 at 11:51 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Tue, Jul 21, 2026 at 04:54:39AM -0700, Selvin Xavier wrote:
> > > The current GET_TOGGLE_MEM ioctl requires the caller to supply
> > > a type enum and a raw hardware queue ID (RES_ID). The kernel
> > > looks up the CQ or SRQ by that ID without verifying that the
> > > caller owns the resource.
> > >
> > > Add a new, preferred code path that accepts standard uverbs
> > > object handles (BNXT_RE_TOGGLE_MEM_CQ_HANDLE /
> > > BNXT_RE_TOGGLE_MEM_SRQ_HANDLE) instead. The uverbs core validates
> > > that the handle belongs to the calling context as part of resolving
> > > it, so this path no longer needs the driver's own XArray lookup for
> > > ownership checking. As with the legacy path, the toggle_entry's own
> > > mmap-entry refcount (not a CQ/SRQ uobject reference) is what pins
> > > the toggle page for the life of the GET_TOGGLE_MEM handle.
> > >
> > > Only newer rdma-core versions support this path, if the
> > > driver reports the supported resp mask
> > > (BNXT_RE_UCNTX_CMASK_TOGGLE_MEM_UOBJ_SUPPORT).
> > > The existing TYPE + RES_ID path is retained for backward
> > > compatibility with older rdma-core.
> > >
> > > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > > Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
> > > ---
> > >  drivers/infiniband/hw/bnxt_re/ib_verbs.c |  2 +
> > >  drivers/infiniband/hw/bnxt_re/uapi.c     | 55 +++++++++++++++++++++---
> > >  include/uapi/rdma/bnxt_re-abi.h          |  4 ++
> > >  3 files changed, 56 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > > index 0ff862ca982c..a14b17d4261f 100644
> > > --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > > +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > > @@ -4872,6 +4872,8 @@ int bnxt_re_alloc_ucontext(struct ib_ucontext *ctx, struct ib_udata *udata)
> > >       if (_is_modify_qp_rate_limit_supported(dev_attr->dev_cap_flags2))
> > >               resp.comp_mask |= BNXT_RE_UCNTX_CMASK_QP_RATE_LIMIT_ENABLED;
> > >
> > > +     resp.comp_mask |= BNXT_RE_UCNTX_CMASK_TOGGLE_MEM_UOBJ_SUPPORT;
> > > +
> > >       if (udata->inlen) {
> > >               rc = ib_copy_validate_udata_in_cm(
> > >                       udata, ureq, comp_mask,
> > > diff --git a/drivers/infiniband/hw/bnxt_re/uapi.c b/drivers/infiniband/hw/bnxt_re/uapi.c
> > > index 97bc0e755511..feaf98631fc5 100644
> > > --- a/drivers/infiniband/hw/bnxt_re/uapi.c
> > > +++ b/drivers/infiniband/hw/bnxt_re/uapi.c
> > > @@ -237,16 +237,52 @@ static int UVERBS_HANDLER(BNXT_RE_METHOD_GET_TOGGLE_MEM)(struct uverbs_attr_bund
> > >       if (IS_ERR(ib_uctx))
> > >               return PTR_ERR(ib_uctx);
> > >
> > > +     uctx = container_of(ib_uctx, struct bnxt_re_ucontext, ib_uctx);
> > > +
> > > +     /* New path: updated libbnxt_re passes the CQ or SRQ uverbs handle */
> > > +     if (uverbs_attr_is_valid(attrs, BNXT_RE_TOGGLE_MEM_CQ_HANDLE)) {
> > > +             struct bnxt_re_cq *cq;
> > > +
> > > +             res_uobj = uverbs_attr_get_uobject(attrs,
> > > +                                                BNXT_RE_TOGGLE_MEM_CQ_HANDLE);
> > > +             if (IS_ERR(res_uobj))
> > > +                     return PTR_ERR(res_uobj);
> > > +             cq = container_of(res_uobj->object, struct bnxt_re_cq, ib_cq);
> > > +             if (!cq->toggle_entry)
> > > +                     return -EOPNOTSUPP;
> > > +             mmap_offset = rdma_user_mmap_get_offset(&cq->toggle_entry->rdma_entry);
> > > +             if (!mmap_offset)
> > > +                     return -EOPNOTSUPP;
> > > +             kref_get(&cq->toggle_entry->rdma_entry.ref);
> > > +             toggle_entry = cq->toggle_entry;
> > > +             goto alloc_tmem;
> > > +     } else if (uverbs_attr_is_valid(attrs, BNXT_RE_TOGGLE_MEM_SRQ_HANDLE)) {
> > > +             struct bnxt_re_srq *srq;
> > > +
> > > +             res_uobj = uverbs_attr_get_uobject(attrs,
> > > +                                                BNXT_RE_TOGGLE_MEM_SRQ_HANDLE);
> > > +             if (IS_ERR(res_uobj))
> > > +                     return PTR_ERR(res_uobj);
> > > +             srq = container_of(res_uobj->object, struct bnxt_re_srq, ib_srq);
> > > +             if (!srq->toggle_entry)
> > > +                     return -EOPNOTSUPP;
> > > +             mmap_offset = rdma_user_mmap_get_offset(&srq->toggle_entry->rdma_entry);
> > > +             if (!mmap_offset)
> > > +                     return -EOPNOTSUPP;
> > > +             kref_get(&srq->toggle_entry->rdma_entry.ref);
> > > +             toggle_entry = srq->toggle_entry;
> > > +             goto alloc_tmem;
> > > +     }
> > > +
> > >       err = uverbs_get_const(&res_type, attrs, BNXT_RE_TOGGLE_MEM_TYPE);
> > >       if (err)
> > >               return err;
> > > -
> > > -     uctx = container_of(ib_uctx, struct bnxt_re_ucontext, ib_uctx);
> > >       err = uverbs_copy_from(&res_id, attrs, BNXT_RE_TOGGLE_MEM_RES_ID);
> > >       if (err)
> > >               return err;
> > >
> > >       /*
> > > +      * Legacy path: old libbnxt_re sends TYPE + RES_ID.
> > >        * Hold xa_lock across xa_load + kref_get so that a concurrent
> > >        * bnxt_re_destroy_cq/srq cannot call __xa_erase and remove the
> > >        * toggle_entry between our load and our reference on it.
> > > @@ -297,6 +333,7 @@ static int UVERBS_HANDLER(BNXT_RE_METHOD_GET_TOGGLE_MEM)(struct uverbs_attr_bund
> > >       if (!mmap_offset)
> > >               return -EOPNOTSUPP;
> > >
> > > +alloc_tmem:
> > >       tmem = kzalloc_obj(*tmem);
> > >       if (!tmem) {
> > >               rdma_user_mmap_entry_put(&toggle_entry->rdma_entry);
> > > @@ -343,10 +380,10 @@ DECLARE_UVERBS_NAMED_METHOD(BNXT_RE_METHOD_GET_TOGGLE_MEM,
> > >                                           UA_MANDATORY),
> > >                           UVERBS_ATTR_CONST_IN(BNXT_RE_TOGGLE_MEM_TYPE,
> > >                                                enum bnxt_re_get_toggle_mem_type,
> > > -                                              UA_MANDATORY),
> > > +                                              UA_OPTIONAL),
> > >                           UVERBS_ATTR_PTR_IN(BNXT_RE_TOGGLE_MEM_RES_ID,
> > >                                              UVERBS_ATTR_TYPE(u32),
> > > -                                            UA_MANDATORY),
> > > +                                            UA_OPTIONAL),
> > >                           UVERBS_ATTR_PTR_OUT(BNXT_RE_TOGGLE_MEM_MMAP_PAGE,
> > >                                               UVERBS_ATTR_TYPE(u64),
> > >                                               UA_MANDATORY),
> > > @@ -355,7 +392,15 @@ DECLARE_UVERBS_NAMED_METHOD(BNXT_RE_METHOD_GET_TOGGLE_MEM,
> > >                                               UA_MANDATORY),
> > >                           UVERBS_ATTR_PTR_OUT(BNXT_RE_TOGGLE_MEM_MMAP_LENGTH,
> > >                                               UVERBS_ATTR_TYPE(u32),
> > > -                                             UA_MANDATORY));
> > > +                                             UA_MANDATORY),
> > > +                         UVERBS_ATTR_IDR(BNXT_RE_TOGGLE_MEM_CQ_HANDLE,
> > > +                                         UVERBS_OBJECT_CQ,
> > > +                                         UVERBS_ACCESS_READ,
> > > +                                         UA_OPTIONAL),
> > > +                         UVERBS_ATTR_IDR(BNXT_RE_TOGGLE_MEM_SRQ_HANDLE,
> > > +                                         UVERBS_OBJECT_SRQ,
> > > +                                         UVERBS_ACCESS_READ,
> > > +                                         UA_OPTIONAL));
> > >
> > >  DECLARE_UVERBS_NAMED_METHOD_DESTROY(BNXT_RE_METHOD_RELEASE_TOGGLE_MEM,
> > >                                   UVERBS_ATTR_IDR(BNXT_RE_RELEASE_TOGGLE_MEM_HANDLE,
> > > diff --git a/include/uapi/rdma/bnxt_re-abi.h b/include/uapi/rdma/bnxt_re-abi.h
> > > index a4599d7b736a..c0ee9ce389ac 100644
> > > --- a/include/uapi/rdma/bnxt_re-abi.h
> > > +++ b/include/uapi/rdma/bnxt_re-abi.h
> > > @@ -57,6 +57,8 @@ enum {
> > >       BNXT_RE_UCNTX_CMASK_POW2_DISABLED = 0x10ULL,
> > >       BNXT_RE_UCNTX_CMASK_MSN_TABLE_ENABLED = 0x40,
> > >       BNXT_RE_UCNTX_CMASK_QP_RATE_LIMIT_ENABLED = 0x80ULL,
> > > +      /* Some reserved fields to manage compatibility with Out of tree drivers */
> >
> > Selvin,
> >
> > What did you mean with this comment?
> This CMASK tracks the feature compatibility. Broadcom distributes an
> out-of-tree driver
> with some of the features that are not available in the upstream
> driver. Some of these
> features are debug only or features applicable for the next revision
> of the chip (which is not
> supported yet in the upstream driver). Since we want our inbox
> libraries to work with
> the out-of-tree drivers (and vice versa),  we are maintaining ABI
> compatibility and I will
> have to keep reserved/holes in the feature definition of this
> compatibility mask.

There are still plenty of numbers available, and the numbering is
entirely up to you. We do not want any association with OOT code.
Once you run out of available numbers, we will ask you to use those
reserved in the hole.

I will remove this line when applying the patch. Is that OK?

Thanks

> 
> Thanks
> >
> > Thanks
> >
> > > +     BNXT_RE_UCNTX_CMASK_TOGGLE_MEM_UOBJ_SUPPORT = 0x400000ULL,
> > >  };
> > >
> > >  enum bnxt_re_wqe_mode {
> > > @@ -218,6 +220,8 @@ enum bnxt_re_var_toggle_mem_attrs {
> > >       BNXT_RE_TOGGLE_MEM_MMAP_PAGE,
> > >       BNXT_RE_TOGGLE_MEM_MMAP_OFFSET,
> > >       BNXT_RE_TOGGLE_MEM_MMAP_LENGTH,
> > > +     BNXT_RE_TOGGLE_MEM_CQ_HANDLE,
> > > +     BNXT_RE_TOGGLE_MEM_SRQ_HANDLE,
> > >  };
> > >
> > >  enum bnxt_re_toggle_mem_attrs {
> > > --
> > > 2.39.3
> > >


