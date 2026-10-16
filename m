Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693C23909A8
	for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 20:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792183577; cv=none; b=SJ40H3YFl3KDHQ4IojzuNQBrOe5ob+vlySm51m8OvaPvLM6RyvEB7redo2g2UFmGDabGnQRcxvWVEK4tszC0RHDNTZy/DHB3bZeXlBi/AcxwtUVcjUrgpIxSb2aQTpFUuOH1hIDiLVHo71p7l5uiPIndsVLC7RwXe2rfxG55Oc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792183577; c=relaxed/simple;
	bh=mk7vSK46gj6yPa7UBEkItMbAXZ8LkaP8vKDJVB2xA1Q=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=RRUD+r4g9kRIDFkBPMoEQe9vCK8dGdEV7b+olzHx+EByaZnzHOHedvsxjtAKRdvRbK6o/h74Fpsp4JcCCR9bmsvIYwxpEoEqo5v5mVMyrcOv2eJQ1n62efS2lR4XBW0MrHo+0kqVRSY60/c/faXPuEO0R/UzHm8lZfRgmdo5RUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nSealeo8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nSealeo8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E981F000C4;
	Fri, 16 Oct 2026 20:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792183576;
	bh=c6K6f4Nmd6bKVCSkenAaqiosIzapZgNwVMZpHPKxmU4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nSealeo8A5FVqdcexcGo99C/zPrw07RJzFbcRUZ178A9a1H8Kl+pDgJqLVYvrL+oQ
	 D2soyu6kPnmTIgneKtv1UGSC//Rs1q/2l9TRgd2Ai7+2ON2rfVaqLJU8EAWSArEeu7
	 EgMSgFSzl79wuoGQzaPwp02xfHfgLzMHAdRRsVEuRfGJ6KTZwHPTurZWbZqbrpP9h8
	 Ny5lHCZi5JmYmlOS/kKki7AA4YINVJAoyoO0WSPSZV8yFO8Y9kEABwcVsDNZmP0SJq
	 4MJr5OPfs0eDV4mDwcrcxbL9IFsHx+jsuXIvHtYuWl61XffV/3lxFt2AqVLRh1Os3V
	 9SBJRS3wWPxaw==
Message-ID: <sashiko-outbox-174922@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v3 3/6] RDMA/irdma: Support UMEM attribute for
 QP creation
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Hu" <dhu@x6u.co>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261016202909.1289496-4-dhu@x6u.co>
References: <20261016202909.1289496-1-dhu@x6u.co>
 <20261016202909.1289496-4-dhu@x6u.co>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 20:46:15 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] RDMA/irdma: invalid sg_page() on dmabuf QP umem in irdma_copy_=
user_pgaddrs()
--

commit 200a925805870f2d575192eafe96be3cef694b7d
Author: David Hu <xuehaohu@google.com>

RDMA/irdma: Support UMEM attribute for QP creation

This commit adds support for the 1-step queue buffer creation model for QPs
via UVERBS_ATTR_CREATE_QP_BUF_UMEM and ib_umem_get_attr(), while retaining
backward compatibility with the legacy 2-step MR registration model.

> diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/=
irdma/verbs.c
> index b2ffdc8e3d677..ab25445f38282 100644
> --- a/drivers/infiniband/hw/irdma/verbs.c
> +++ b/drivers/infiniband/hw/irdma/verbs.c
[ ... ]
> @@ -713,6 +708,52 @@ static int irdma_setup_umode_qp(struct irdma_ucontex=
t *ucontext,
>  		ukinfo->rq_size =3D ukinfo->rq_depth >> ukinfo->rq_shift;
>  	}
> =20
> +	if (attrs && uverbs_attr_is_valid(attrs, UVERBS_ATTR_CREATE_QP_BUF_UMEM=
)) {
> +		struct irdma_mem_reg_req qp_req =3D {};
> +		struct ib_umem *umem;
> +		u32 total;
> +
> +		/* Legacy context does not provide depth info */
> +		if (!ucontext->use_raw_attrs)
> +			return -EOPNOTSUPP;
> +
> +		qp_req.sq_pages =3D DIV_ROUND_UP(ukinfo->sq_depth * IRDMA_QP_WQE_MIN_S=
IZE,
> +					       IRDMA_HW_PAGE_SIZE);
> +		/* In case srq is used, this will be a single page */
> +		qp_req.rq_pages =3D DIV_ROUND_UP(ukinfo->rq_depth * IRDMA_QP_WQE_MIN_S=
IZE,
> +					       IRDMA_HW_PAGE_SIZE);
> +		total =3D qp_req.sq_pages + qp_req.rq_pages + IRDMA_SHADOW_PGCNT;
> +
> +		umem =3D ib_umem_get_attr(&iwdev->ibdev, attrs,
> +					UVERBS_ATTR_CREATE_QP_BUF_UMEM,
> +					total << IRDMA_HW_PAGE_SHIFT,
> +					IB_ACCESS_LOCAL_WRITE);
> +		if (IS_ERR(umem))
> +			return PTR_ERR(umem);
> +
> +		iwqp->iwpbl =3D irdma_setup_q_pbl_from_umem(iwdev, umem,
> +							  iwqp->ibqp.pd,
> +							  IRDMA_MEMREG_TYPE_QP,
> +							  &qp_req);
[ ... ]
> @@ -3532,6 +3574,64 @@ static void irdma_free_iwmr(struct irdma_mr *iwmr)
>  	kfree(iwmr);
>  }
> =20
> +static struct irdma_pbl *irdma_setup_q_pbl_from_umem(struct irdma_device=
 *iwdev,
> +						     struct ib_umem *region,
> +						     struct ib_pd *pd,
> +						     enum irdma_memreg_type reg_type,
> +						     struct irdma_mem_reg_req *req)
> +{
> +	struct irdma_pbl *iwpbl;
> +	struct irdma_mr *iwmr;
> +	u32 total;
> +	u8 lvl;
> +	int err;
> +
> +	/* iWarp: Catch page not starting on OS page boundary */
> +	if (!rdma_protocol_roce(&iwdev->ibdev, 1) && ib_umem_offset(region))
> +		return ERR_PTR(-EINVAL);

[Severity: Critical]
Can passing an IB_UVERBS_BUFFER_TYPE_DMABUF descriptor via
UVERBS_ATTR_CREATE_QP_BUF_UMEM cause a NULL pointer dereference or write to
the wrong page during iWARP connection establishment?

In irdma_setup_umode_qp(), ib_umem_get_attr() resolves the buffer descriptor
through __ib_umem_get_desc_dir(), which accepts both IB_UVERBS_BUFFER_TYPE_=
VA
and IB_UVERBS_BUFFER_TYPE_DMABUF. Previously, IRDMA_MEMREG_TYPE_QP MRs could
only be registered via irdma_reg_user_mr() -> ib_umem_get_va(), whereas
irdma_reg_user_mr_dmabuf() hardcoded IRDMA_MEMREG_TYPE_MEM.

When irdma_setup_q_pbl_from_umem() calls irdma_handle_q_mem() ->
irdma_setup_pbles() -> irdma_copy_user_pgaddrs(), the driver extracts the
first SQ page from the scatterlist:

drivers/infiniband/hw/irdma/verbs.c:irdma_copy_user_pgaddrs() {
	if (iwmr->type =3D=3D IRDMA_MEMREG_TYPE_QP)
		iwpbl->qp_mr.sq_page =3D sg_page(region->sgt_append.sgt.sgl);
}

and irdma_setup_virt_qp() assigns iwqp->page =3D qpmr->sq_page, while
iwqp->sc_qp.qp_uk.sq_base remains NULL for a user-mode QP.

On an iWARP device, irdma_accept() and irdma_cm_event_connected() map
iwqp->page to write the LSMM or RTT WQE:

drivers/infiniband/hw/irdma/cm.c:irdma_accept() {
	if (iwqp->page)
		iwqp->sc_qp.qp_uk.sq_base =3D kmap_local_page(iwqp->page);

	cm_node->lsmm_size =3D accept.size + conn_param->private_data_len;
	irdma_sc_send_lsmm(&iwqp->sc_qp, iwqp->ietf_mem.va, cm_node->lsmm_size,
			   ibmr->lkey);
}

drivers/infiniband/hw/irdma/cm.c:irdma_cm_event_connected() {
	if (iwqp->page)
		iwqp->sc_qp.qp_uk.sq_base =3D kmap_local_page(iwqp->page);
	irdma_sc_send_rtt(&iwqp->sc_qp, read0);
	if (iwqp->page)
		kunmap_local(iwqp->sc_qp.qp_uk.sq_base);
}

With a dmabuf-backed ib_umem, calling sg_page() on the scatterlist breaks in
two ways:

1. When CONFIG_DMABUF_DEBUG is enabled (where dma_buf_wrap_sg_table() clears
   page_link) or when the exporter does not populate struct page pointers
   (such as uverbs_dmabuf or P2P/MMIO exporters), sg_page() returns NULL.
   This leaves iwqp->page NULL, so irdma_accept() and
   irdma_cm_event_connected() skip kmap_local_page() and pass a NULL
   qp_uk->sq_base into irdma_sc_send_lsmm() / irdma_sc_send_rtt(), which
   immediately dereferences qp_uk->sq_base->elem.

2. Even when sg_page() is populated by a system-RAM exporter, if userspace
   passes a non-zero page-aligned offset within a coalesced multi-page SG
   entry, ib_umem_dmabuf_map_pages() advances sg_dma_address(sg) and
   decrements sg_dma_len(sg) in place without updating sg->page_link:

   drivers/infiniband/core/umem_dmabuf.c:ib_umem_dmabuf_map_pages() {
		if (cur <=3D start && start < cur + sg_dma_len(sg)) {
			unsigned long offset =3D start - cur;

			umem_dmabuf->first_sg =3D sg;
			umem_dmabuf->first_sg_offset =3D offset;
			sg_dma_address(sg) +=3D offset;
			sg_dma_len(sg) -=3D offset;
			cur +=3D offset;
		}
   }

   As a result, sg_page(region->sgt_append.sgt.sgl) points to the start of
   that SG segment rather than the SQ page at the requested offset, causing
   kmap_local_page(iwqp->page) to map and overwrite the wrong page.

Should irdma_setup_q_pbl_from_umem() (or irdma_setup_umode_qp()) reject
region->is_dmabuf, at least when !rdma_protocol_roce(&iwdev->ibdev, 1) (or
unconditionally if dmabuf queue rings are not supported)?

> +
> +	iwmr =3D irdma_alloc_iwmr(region, &iwdev->ibdev, pd, region->address, r=
eg_type);
> +	if (IS_ERR(iwmr))
> +		return ERR_CAST(iwmr);
[ ... ]

=E0=A6=93=E0=A7=9F=E0=A6=BE=E0=A6=93! (Wait, let me make sure there is no e=
xtra text at the end! Oh! Why did those characters appear? Let me remove th=
at!)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016202909.1289=
496-1-dhu@x6u.co?part=3D3
