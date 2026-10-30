Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793385228;
	b=oyxblznaiwV+LsLjAgbkOzDo8oRd07FD+VSiQ4YOiNn+P6s3F7cUPDX7ha7sq5RuxbU+
	 tiWIU5YyH5aA0uj41iO1e0AqV8d1x+GlOGNoe1F3vQOKDNGYqjBkU7EWSDwdBLP2uaQe3
	 rSfXypMUuAbweN3wxWTnswBa2KrA04Si7aKUwTwiHiYeQdaStZ8bAQ8+XR2M8kVQAYFSs
	 zSV//2+GSe6SAZlE2TSQF9kWmm2d+sfVq9RVeIC+drnU41DmtYM5F92BEspa+fWMK5SP2
	 7tZ+h3D4N+8SoylYErgdlGxKySNQ52vEiU0MjkSNXIvItUsF3T3kiAqaVR3koN5sXqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793385228;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=n+s5FGGcYwr65sgVMPtFGYslhUkE59pesnMOY/vd0Ec=;
	b=m58Yot+GRrY/fN9gb2Jeb5zEl54mCKYVUFoz2q/rWH2gwNJfYfyKY15+UpVk6D5pQaxG
	 vwqpGO+nRJcgsWNQQBhRX8iMatGbr368h2C+Kx5QpMFlQaMpMxP1uyOdVw1+935uvFAb6
	 WinelTnWO4ldgamDEh4oCFv+JpS3swS+DrLR3hlP4S9mMm5oFPmPf04zr+cV+Fp39E2V1
	 s3lCFoGJgScxCsPnPU0lFVCuZB3O2ynNreSf2rO9B4LRIQJ7rujPZ2Az6dlK8V/v8mUzG
	 q5pBB7eKPGGNlWKRC4VdHjtOV8NN32nbsVzxcXhYGv13mAey2xGy/Z1lvSjS2vzYwow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rqm7EYMq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9607F606A31A
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 18:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rqm7EYMq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ABE81F000C1;
	Fri, 30 Oct 2026 18:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793385228;
	bh=n+s5FGGcYwr65sgVMPtFGYslhUkE59pesnMOY/vd0Ec=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Rqm7EYMqYWBsBnU1PVI+5HL9VyD/em61cVfv/bJBUJmXaEbg9rShxyGpVTL+Yg9AT
	 KGViwAP/VKX/t7IPXSo+RDSe0E5MjGpt7a8q8Scb9rSDsvy6D7Z/k39xGCiF5V2MCk
	 dN7FHoHRXGGgaDcKZL5Sp5j2tRRIbwm/ZjqzwGQxKkV7FCJD1TZEnGRKtmIF4J528w
	 k7jc3UQNNzvbf3pbcbidaYMBiyb/5ApjvsmA0bTrU0Q0ei7EtMn4vN3rulzcpz7QSm
	 aVJE3qxvLDlJjrHxhUzZRICcw8aVQc3jEnqg4n3DUo7ZvS7sgAEj7lwU8xZ/9I9/5X
	 EhK31jlJzojbA==
Message-ID: <sashiko-outbox-191412@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v4 5/6] RDMA/irdma: Support UMEM attribute for
 CQ creation
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Hu" <dhu@x6u.co>
Cc: intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261030181512.2056056-6-dhu@x6u.co>
References: <20261030181512.2056056-1-dhu@x6u.co>
 <20261030181512.2056056-6-dhu@x6u.co>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 18:33:47 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] RDMA/irdma: wrong DMA direction in irdma_setup_umode_cq() via ib=
_umem_get_cq_buf()
--

commit 8981c5869a8245f4b87a31412a16b517815f3a39
Author: David Hu <xuehaohu@google.com>

RDMA/irdma: Support UMEM attribute for CQ creation

This commit adds support for one-step user-mode CQ buffer creation using
UVERBS_ATTR_CREATE_CQ_BUF_UMEM and IRDMA_IB_ATTR_CREATE_CQ_SHADOW_BUF_UMEM,
sets up hardware PBLEs directly from the pinned UMEMs, and adds UMEM and PB=
LE
cleanup in irdma_cq_free_rsrc() and irdma_resize_cq().

> diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/=
irdma/verbs.c
> index 9f4905fdb791a..41e56ab8aa6df 100644
> --- a/drivers/infiniband/hw/irdma/verbs.c
> +++ b/drivers/infiniband/hw/irdma/verbs.c

[ ... ]

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
> +
> +		umem =3D ib_umem_get_cq_buf(&iwdev->ibdev, attrs, min_size,
> +					  IB_ACCESS_LOCAL_WRITE);

[Severity: Medium]
When IRDMA_FEATURE_CQ_RESIZE is not set in
rf->sc_dev.hw_attrs.uk_attrs.feature_flags, the UMEM passed via
UVERBS_ATTR_CREATE_CQ_BUF_UMEM backs both the CQ ring and the trailing shad=
ow
area page (shadow_pgcnt is IRDMA_SHADOW_PGCNT, and irdma_setup_umode_cq()
later sets info->shadow_area_pa =3D cqmr->shadow from that same UMEM).

However, ib_umem_get_cq_buf() in drivers/infiniband/core/umem.c hardcodes
DMA_FROM_DEVICE instead of deriving DMA_BIDIRECTIONAL from
IB_ACCESS_LOCAL_WRITE:

drivers/infiniband/core/umem.c:ib_umem_get_cq_buf() {
	return ib_umem_get_from_attrs(device, attrs,
				      UVERBS_ATTR_CREATE_CQ_BUF_UMEM,
				      uverbs_create_cq_get_buffer_desc,
				      size, access, DMA_FROM_DEVICE);
}

Since the CPU writes the CQ head index to the shadow area and hardware reads
shadow_area_pa via DMA, mapping this UMEM with DMA_FROM_DEVICE omits IOMMU
read permissions (and skips CPU-to-device bounce buffer syncs).

Should irdma_setup_umode_cq() use ib_umem_get_attr() with
UVERBS_ATTR_CREATE_CQ_BUF_UMEM when IRDMA_FEATURE_CQ_RESIZE is not set (or
unconditionally, as noted in the commit message) so the buffer is mapped wi=
th
DMA_BIDIRECTIONAL?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030181512.2056=
056-1-dhu@x6u.co?part=3D5
