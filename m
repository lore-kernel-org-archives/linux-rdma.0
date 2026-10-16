Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B013B05AC
	for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 20:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792184210; cv=none; b=d5u3SV708hWk6kS2pKFYHrAJnBdJPHKizeth2mAghmtBkM/6lzxr+XqjuSm/+CnI7mLVZ94Hwdo6McUydiIdYY3AClPncnys0klBNm9+DcW6/ofrMtrIsKbS1s5IFa9fvroAOuzCzrkNacBEEuH4Xkc4p2Ky1W9LTmBVPwVfeH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792184210; c=relaxed/simple;
	bh=IApkED6pQiHmmn1p+gwlqJ/GMTokhJqMfEfbE822eS0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=tgTHNqN8xRJhkmhjinj4+GzcS181dDBFSolmh3N4xrFgL2tu7vAbVnjXygDQHE3vbfkzVffdb3WtlAIfWrPGMts9y/miJb0VsjQtDEM3qnT1ZVa6FaAxFViAgdC1Bim2vu5XuAiEmk3oQRD6UQUZ4KMYmpFIJ8r3Kzn98gO5lXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fAEJFGa5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fAEJFGa5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 577161F000C4;
	Fri, 16 Oct 2026 20:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792184208;
	bh=IRBMvEUVnj+EQjO2cXdPEcmGi/c1/mg9T+abcRyeWXw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fAEJFGa5g4MPyNmvhmvf59CvOwTFIXWePDoL6s1PrcEe9Yz8tEsjA/VmPuI7vTMTA
	 /CL4+2v1MwdfE895JYx5EuawjBOjUbgiyIG50QF6QmHSZOGtV7wqnP4Vlp7F/J6+Cq
	 dRA+s2uLdqP86CuVnyCQRk+JTMs0rzxs8GS/5qoHhUlgyiOjcvyzuLVNfm66Nig9sJ
	 WwwBfwSf8Ok2fuPH7IgvuB8ZGNN0lmnkjWTdorPqqba95qGFv/I+m77U8EvUMLCh9j
	 UpUFC679f0vBb2XPlWOqL2slk3HyZXoRjC9mgzdt/FoKi1OjyzGU9Y2HMLky2DnWS0
	 Z81/V4usUcrAQ==
Message-ID: <sashiko-outbox-174933@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v3 5/6] RDMA/irdma: Support UMEM attribute for
 CQ creation
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Hu" <dhu@x6u.co>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261016202909.1289496-6-dhu@x6u.co>
References: <20261016202909.1289496-1-dhu@x6u.co>
 <20261016202909.1289496-6-dhu@x6u.co>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 20:56:47 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] RDMA/irdma: integer overflow in irdma_setup_umode_cq() CQ page=
 calculation
- [High] RDMA/irdma: unaligned CQ and shadow UMEMs bypass 4K page offset ch=
eck
--

commit 79df0143a3db151761db4b97121b37dcf76bacb9
Author: David Hu <xuehaohu@google.com>

RDMA/irdma: Support UMEM attribute for CQ creation

This commit adds support for one-step CQ creation using
UVERBS_ATTR_CREATE_CQ_BUF_UMEM and IRDMA_IB_ATTR_CREATE_CQ_SHADOW_BUF_UMEM
to pin user buffers and set up hardware PBL entries directly from UMEM. It
also updates irdma_cq_free_rsrc() and irdma_resize_cq() to release UMEM and
PBLE resources when the user ring reference count reaches zero.

> diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/=
irdma/verbs.c
> index 4b7e9c2d9cff5..02ed7ab99e48d 100644
> --- a/drivers/infiniband/hw/irdma/verbs.c
> +++ b/drivers/infiniband/hw/irdma/verbs.c

[ ... ]

> @@ -2746,14 +2768,18 @@ static int irdma_setup_umode_cq(struct irdma_devi=
ce *iwdev,
>  				struct irdma_cq_init_info *info,
>  				struct uverbs_attr_bundle *attrs)
>  {
> +	struct irdma_cq_uk_init_info *ukinfo =3D &info->cq_uk_init_info;
>  	struct ib_udata *udata =3D &attrs->driver_udata;
>  	struct irdma_create_cq_req req =3D {};
>  	struct irdma_pci_f *rf =3D iwdev->rf;
> +	struct irdma_sc_dev *dev =3D &rf->sc_dev;
>  	struct irdma_ucontext *ucontext;
>  	struct irdma_cq_mr *cqmr_shadow;
>  	struct irdma_cq_mr *cqmr;
>  	unsigned long flags;
> +	bool cqe_64byte_ena;
>  	int err_code;
> +	u8 cqe_size;
> =20
>  	iwcq->user_mode =3D true;
>  	ucontext =3D rdma_udata_to_drv_context(udata, struct irdma_ucontext,
> @@ -2767,26 +2793,87 @@ static int irdma_setup_umode_cq(struct irdma_devi=
ce *iwdev,
>  	if (err_code)
>  		return err_code;
> =20
> -	spin_lock_irqsave(&ucontext->cq_reg_mem_list_lock, flags);
> -	iwcq->iwpbl =3D irdma_get_pbl((unsigned long)req.user_cq_buf,
> -				    &ucontext->cq_reg_mem_list);
> -	spin_unlock_irqrestore(&ucontext->cq_reg_mem_list_lock, flags);
> -	if (!iwcq->iwpbl)
> -		return -EPROTO;
> +	cqe_64byte_ena =3D dev->hw_attrs.uk_attrs.feature_flags & IRDMA_FEATURE=
_64_BYTE_CQE ?
> +			 true : false;
> +	cqe_size =3D cqe_64byte_ena ? 64 : 32;
> +
> +	if (uverbs_attr_is_valid(attrs, UVERBS_ATTR_CREATE_CQ_BUF_UMEM)) {
> +		struct ib_umem *umem;
> +		struct irdma_mem_reg_req cq_req =3D {};
> +		u8 shadow_pgcnt =3D (rf->sc_dev.hw_attrs.uk_attrs.feature_flags &
> +				   IRDMA_FEATURE_CQ_RESIZE) ? 0 : IRDMA_SHADOW_PGCNT;
> +		u32 min_size;
> +
> +		cq_req.cq_pages =3D DIV_ROUND_UP(ukinfo->cq_size * cqe_size,
> +					       IRDMA_HW_PAGE_SIZE);
> +		min_size =3D (cq_req.cq_pages + shadow_pgcnt) << IRDMA_HW_PAGE_SHIFT;

[Severity: Critical]
Can ukinfo->cq_size * cqe_size overflow 32-bit arithmetic or truncate when
assigned to the __u16 cq_req.cq_pages field here?

Unlike irdma_create_cq() and irdma_resize_cq(), irdma_create_user_cq() and
irdma_alloc_cq() do not check attr->cqe > rf->max_cqe before setting
ukinfo->cq_size:

drivers/infiniband/hw/irdma/verbs.c:irdma_create_user_cq() {
	err_code =3D cq_validate_flags(attr->flags, dev->hw_attrs.uk_attrs.hw_rev);
	if (err_code)
		return err_code;

	if (udata->outlen < IRDMA_CREATE_CQ_MIN_RESP_LEN)
		return -EINVAL;

	err_code =3D irdma_alloc_cq(iwdev, iwcq, attr, &info);
}

Because ukinfo->cq_size is u32, cqe_size is u8 (32 or 64), and
cq_req.cq_pages in struct irdma_mem_reg_req is __u16, a large user-supplied
UVERBS_ATTR_CREATE_CQ_CQE value (such as 0x00400040 or 0x04000040 when
cqe_size is 64) causes cq_req.cq_pages to wrap or truncate to 1.

When that happens, min_size becomes 4096 bytes, ib_umem_get_cq_buf() pins a
single 4KB page, and irdma_setup_q_pbl_from_umem() accepts the 1-page UMEM
in PBLE_LEVEL_0 physical mode while __irdma_create_cq() ->
irdma_sc_cq_create() programs the unvalidated cq->cq_uk.cq_size into the
hardware CQP WQE. Could this allow hardware DMA writes beyond the single
pinned page?

> +
> +		umem =3D ib_umem_get_cq_buf(&iwdev->ibdev, attrs, min_size,
> +					  IB_ACCESS_LOCAL_WRITE);
> +		if (IS_ERR(umem))
> +			return PTR_ERR(umem);
> +
> +		iwcq->iwpbl =3D irdma_setup_q_pbl_from_umem(iwdev, umem, NULL,
> +							  IRDMA_MEMREG_TYPE_CQ, &cq_req);
> +		if (IS_ERR(iwcq->iwpbl)) {
> +			err_code =3D PTR_ERR(iwcq->iwpbl);
> +			iwcq->iwpbl =3D NULL;
> +			ib_umem_release(umem);
> +			return err_code;
> +		}
> +	} else {
> +		if (!req.user_cq_buf)
> +			return -EINVAL;
> +
> +		spin_lock_irqsave(&ucontext->cq_reg_mem_list_lock, flags);
> +		iwcq->iwpbl =3D irdma_get_pbl((unsigned long)req.user_cq_buf,
> +					    &ucontext->cq_reg_mem_list);
> +		spin_unlock_irqrestore(&ucontext->cq_reg_mem_list_lock, flags);
> +		if (!iwcq->iwpbl)
> +			return -EPROTO;
> +	}
> =20
>  	cqmr =3D &iwcq->iwpbl->cq_mr;
> =20
>  	if (rf->sc_dev.hw_attrs.uk_attrs.feature_flags &
>  	    IRDMA_FEATURE_CQ_RESIZE) {
> -		spin_lock_irqsave(&ucontext->cq_reg_mem_list_lock, flags);
> -		iwcq->iwpbl_shadow =3D
> -			irdma_get_pbl((unsigned long)req.user_shadow_area,
> -				      &ucontext->cq_reg_mem_list);
> -		spin_unlock_irqrestore(&ucontext->cq_reg_mem_list_lock, flags);
> +		if (uverbs_attr_is_valid(attrs, IRDMA_IB_ATTR_CREATE_CQ_SHADOW_BUF_UME=
M)) {
> +			struct ib_umem *shadow_umem;
> +			struct irdma_mem_reg_req shadow_req =3D {
> +				.cq_pages =3D IRDMA_SHADOW_PGCNT,
> +			};
> +
> +			shadow_umem =3D
> +				ib_umem_get_attr(&iwdev->ibdev, attrs,
> +						 IRDMA_IB_ATTR_CREATE_CQ_SHADOW_BUF_UMEM,
> +						 IRDMA_SHADOW_AREA_SIZE << 3,
> +						 IB_ACCESS_LOCAL_WRITE);
> +			if (IS_ERR(shadow_umem))
> +				return PTR_ERR(shadow_umem);
> +
> +			iwcq->iwpbl_shadow =3D
> +				irdma_setup_q_pbl_from_umem(iwdev, shadow_umem, NULL,
> +							    IRDMA_MEMREG_TYPE_CQ,
> +							    &shadow_req);

[Severity: High]
What happens on RoCE if userspace passes a non-4KB-aligned buffer in
UVERBS_ATTR_CREATE_CQ_BUF_UMEM or IRDMA_IB_ATTR_CREATE_CQ_SHADOW_BUF_UMEM?

In irdma_setup_q_pbl_from_umem(), the page-offset check is skipped on RoCE,
and region->address is passed as virt to irdma_alloc_iwmr():

drivers/infiniband/hw/irdma/verbs.c:irdma_setup_q_pbl_from_umem() {
	/* iWarp: Catch page not starting on OS page boundary */
	if (!rdma_protocol_roce(&iwdev->ibdev, 1) && ib_umem_offset(region))
		return ERR_PTR(-EINVAL);

	iwmr =3D irdma_alloc_iwmr(region, &iwdev->ibdev, pd, region->address, reg_=
type);
}

Inside irdma_alloc_iwmr(), ib_umem_find_best_pgsz(region, SZ_4K, virt)
compares the virtual address alignment against the physical page offset, so
the intra-page offset cancels out and returns SZ_4K even when
region->address is not 4KB-aligned.

Later, irdma_handle_q_mem() -> irdma_setup_pbles() ->
irdma_copy_user_pgaddrs() populates the PBL using
rdma_block_iter_dma_address(&biter), which masks off the low 12 bits
(~(iwmr->page_size - 1)). Doesn't this set info->cq_base_pa (or the PBLE
entries) and info->shadow_area_pa to offset 0 of the 4KB page rather than
the user buffer's offset within the page, causing the hardware to DMA to or
from the wrong offset in that page?

[ ... ]

>  		cqmr_shadow =3D &iwcq->iwpbl_shadow->cq_mr;
>  		info->shadow_area_pa =3D cqmr_shadow->cq_pbl.addr;
>  	} else {

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016202909.1289=
496-1-dhu@x6u.co?part=3D5
