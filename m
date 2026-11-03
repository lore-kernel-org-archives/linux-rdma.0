Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793704401;
	b=QkqhaH6M5fcdGXlf6ONvHH+5o+tB7uB3Cv8hGhY+L1ydB+GELQpOAjhRwGC5uYE45Kvc
	 T1cih+REP4sIMYRkmE3agcGIpSW+bO9gVsmsnVOsPruu8coTB7vxBDPDVYJv1MSmfCfQW
	 F3ixeVYH7p8pqs43YLveO4gPMdQRTyjv7NPKRJIkpoRIfvSpDdQxBrs5PCT6mmIvw0okY
	 R2E6+v8ggkxcvYGy0DPrNyb03F7HSRiM9b62ICSXCNBEDaD0i3qQ+p7dmvVwX+AsyfXaB
	 B3t87BlqYrafQGIXPDEOI+xTbdBbrWyA8XSiaJ6VALyHrlgQR6H/ewJLU5H9+NiyDkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793704401;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=b88mMa6q3vn81VQVZ7qj0eZrExcQvEYoSqEEzaJAbOs=;
	b=WBwOehzsu6tXEIpEx7RTH7SoQgXJBxDbOgZEhC5k3XbhSQ/Vfe61EsKl+Y24FCyRKECI
	 x9dNIxBlTclSwmQ4Q8FWdhH/hHMdhF3zSZGqRLuFiKDq6osT9rQ+xpidVYugoxuXRH63E
	 rGm806MXv7YH3H5cYkW3BVOQDuqk6FI3cTcWLI8BpCzEIHUJTl/Ssa/JwHBSgRM4hatn4
	 PvgyzkPGHeco3mVFIe79bvJjapoOgXVZb4ejI1kJkbpu911S65pjZqkWknTDvwL07rZzN
	 tXr/11quvhZvzghi8eIt56wMeVUx8Meo1yeHR1rTnVgd5tbt6p4Ed/50LQMWP6CDByQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nj1xem4n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB55B606A83E;
	Tue,  3 Nov 2026 11:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nj1xem4n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF271F00919;
	Tue,  3 Nov 2026 11:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793704400;
	bh=b88mMa6q3vn81VQVZ7qj0eZrExcQvEYoSqEEzaJAbOs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nj1xem4nw55U7loFCKPcw/3rk2Slx+LRXcrB5am0XSNKQ5F6XlwH2V16TtMxYKFfo
	 NvQK7TyVJ+ae0fQvKvOYGeXqJco5HnGjbfhCu8iI/pVEoQiDNaBhyHpUiWQQ5FavDg
	 Eqt6fYHPLm/XDbptcaSfM38Se4a+p/JQpIME7ilq5HTMqf9UC0lN4mEZyG4ndV7k9r
	 1drl64/xQvRweN8Hy6AL43a2HBdl2BPBQd24nS4Jpk0U24A3SqG/QktAlnPz4FYIbK
	 7jjPyQXNy1rZ8bRq24J4xoo8tojPndnNf1w8CEWWBbWujI2u3iorbcqItas7C49xS0
	 +5e+slhDAN1NQ==
Date: Tue, 3 Nov 2026 13:13:14 +0200
From: Leon Romanovsky <leon@kernel.org>
To: David Hu <dhu@x6u.co>
Cc: sashiko-reviews@lists.linux.dev, linux-rdma@vger.kernel.org
Subject: Re: [PATCH rdma-next v3 5/6] RDMA/irdma: Support UMEM attribute for
 CQ creation
Message-ID: <20261103111314.GB264423@unreal>
References: <20261016202909.1289496-1-dhu@x6u.co>
 <20261016202909.1289496-6-dhu@x6u.co>
 <sashiko-outbox-174933@kernel.org>
 <CABdL-LQUmwnxs43kZfZX1Py-WS8EzEA3JFfgpSCGW6szT9Pe2w@mail.gmail.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABdL-LQUmwnxs43kZfZX1Py-WS8EzEA3JFfgpSCGW6szT9Pe2w@mail.gmail.com>

On Wed, Oct 21, 2026 at 05:06:22PM -0400, David Hu wrote:
> On Fri, Oct 16, 2026 at 4:56 PM <sashiko-bot@kernel.org> wrote:
> >
> > Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> > - [Critical] RDMA/irdma: integer overflow in irdma_setup_umode_cq() CQ page calculation
> > - [High] RDMA/irdma: unaligned CQ and shadow UMEMs bypass 4K page offset check
> > --
> >
> > commit 79df0143a3db151761db4b97121b37dcf76bacb9
> > Author: David Hu <xuehaohu@google.com>
> >
> > RDMA/irdma: Support UMEM attribute for CQ creation
> >
> > This commit adds support for one-step CQ creation using
> > UVERBS_ATTR_CREATE_CQ_BUF_UMEM and IRDMA_IB_ATTR_CREATE_CQ_SHADOW_BUF_UMEM
> > to pin user buffers and set up hardware PBL entries directly from UMEM. It
> > also updates irdma_cq_free_rsrc() and irdma_resize_cq() to release UMEM and
> > PBLE resources when the user ring reference count reaches zero.
> >
> > > diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
> > > index 4b7e9c2d9cff5..02ed7ab99e48d 100644
> > > --- a/drivers/infiniband/hw/irdma/verbs.c
> > > +++ b/drivers/infiniband/hw/irdma/verbs.c
> >
> > [ ... ]
> >
> > > @@ -2746,14 +2768,18 @@ static int irdma_setup_umode_cq(struct irdma_device *iwdev,
> > >                               struct irdma_cq_init_info *info,
> > >                               struct uverbs_attr_bundle *attrs)
> > >  {
> > > +     struct irdma_cq_uk_init_info *ukinfo = &info->cq_uk_init_info;
> > >       struct ib_udata *udata = &attrs->driver_udata;
> > >       struct irdma_create_cq_req req = {};
> > >       struct irdma_pci_f *rf = iwdev->rf;
> > > +     struct irdma_sc_dev *dev = &rf->sc_dev;
> > >       struct irdma_ucontext *ucontext;
> > >       struct irdma_cq_mr *cqmr_shadow;
> > >       struct irdma_cq_mr *cqmr;
> > >       unsigned long flags;
> > > +     bool cqe_64byte_ena;
> > >       int err_code;
> > > +     u8 cqe_size;
> > >
> > >       iwcq->user_mode = true;
> > >       ucontext = rdma_udata_to_drv_context(udata, struct irdma_ucontext,
> > > @@ -2767,26 +2793,87 @@ static int irdma_setup_umode_cq(struct irdma_device *iwdev,
> > >       if (err_code)
> > >               return err_code;
> > >
> > > -     spin_lock_irqsave(&ucontext->cq_reg_mem_list_lock, flags);
> > > -     iwcq->iwpbl = irdma_get_pbl((unsigned long)req.user_cq_buf,
> > > -                                 &ucontext->cq_reg_mem_list);
> > > -     spin_unlock_irqrestore(&ucontext->cq_reg_mem_list_lock, flags);
> > > -     if (!iwcq->iwpbl)
> > > -             return -EPROTO;
> > > +     cqe_64byte_ena = dev->hw_attrs.uk_attrs.feature_flags & IRDMA_FEATURE_64_BYTE_CQE ?
> > > +                      true : false;
> > > +     cqe_size = cqe_64byte_ena ? 64 : 32;
> > > +
> > > +     if (uverbs_attr_is_valid(attrs, UVERBS_ATTR_CREATE_CQ_BUF_UMEM)) {
> > > +             struct ib_umem *umem;
> > > +             struct irdma_mem_reg_req cq_req = {};
> > > +             u8 shadow_pgcnt = (rf->sc_dev.hw_attrs.uk_attrs.feature_flags &
> > > +                                IRDMA_FEATURE_CQ_RESIZE) ? 0 : IRDMA_SHADOW_PGCNT;
> > > +             u32 min_size;
> > > +
> > > +             cq_req.cq_pages = DIV_ROUND_UP(ukinfo->cq_size * cqe_size,
> > > +                                            IRDMA_HW_PAGE_SIZE);
> > > +             min_size = (cq_req.cq_pages + shadow_pgcnt) << IRDMA_HW_PAGE_SHIFT;
> >
> > [Severity: Critical]
> > Can ukinfo->cq_size * cqe_size overflow 32-bit arithmetic or truncate when
> > assigned to the __u16 cq_req.cq_pages field here?
> >
> > Unlike irdma_create_cq() and irdma_resize_cq(), irdma_create_user_cq() and
> > irdma_alloc_cq() do not check attr->cqe > rf->max_cqe before setting
> > ukinfo->cq_size:
> >
> > drivers/infiniband/hw/irdma/verbs.c:irdma_create_user_cq() {
> >         err_code = cq_validate_flags(attr->flags, dev->hw_attrs.uk_attrs.hw_rev);
> >         if (err_code)
> >                 return err_code;
> >
> >         if (udata->outlen < IRDMA_CREATE_CQ_MIN_RESP_LEN)
> >                 return -EINVAL;
> >
> >         err_code = irdma_alloc_cq(iwdev, iwcq, attr, &info);
> > }
> >
> > Because ukinfo->cq_size is u32, cqe_size is u8 (32 or 64), and
> > cq_req.cq_pages in struct irdma_mem_reg_req is __u16, a large user-supplied
> > UVERBS_ATTR_CREATE_CQ_CQE value (such as 0x00400040 or 0x04000040 when
> > cqe_size is 64) causes cq_req.cq_pages to wrap or truncate to 1.
> >
> > When that happens, min_size becomes 4096 bytes, ib_umem_get_cq_buf() pins a
> > single 4KB page, and irdma_setup_q_pbl_from_umem() accepts the 1-page UMEM
> > in PBLE_LEVEL_0 physical mode while __irdma_create_cq() ->
> > irdma_sc_cq_create() programs the unvalidated cq->cq_uk.cq_size into the
> > hardware CQP WQE. Could this allow hardware DMA writes beyond the single
> > pinned page?
> 
> This is pre-existing, not an issue in practice, since rdma-core
> (libirdma, in `ucreate_cq`) userspace rejects such case.
> 
> In theory, this could be an issue if we look only at the driver. Happy
> to send a new patch for this, or fold this into v4 ( if v4 is needed )

In practice, we should focus on the driver alone. We cannot assume that rdma-core
is safe or harmless to the kernel.

Thanks
