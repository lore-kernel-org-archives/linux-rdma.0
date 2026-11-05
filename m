Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793894977;
	b=pdeQ5n4bFt/Z7LQjUhXN/cWazDlBowYVPWsErGRaEjxJBtTexrEg9m4kG20JzNpJ1yUQ
	 tabB8AQpTJQFCKIZVlfGj9n3SDnFJ9yV+VTjxNG6wGAkNyGpq9iViurH8+a0Zx5SlaRLy
	 LMAcyWabNFkSgKWVTtoiS/0RLbrODryRHi+ULId7IpiCcrd3EOAx0Rm0xjsz2liCmmanc
	 HCsXElMBZ1f27z9qxDseW+SF2Fn7rXKywHGYYjFzjJklLaVSW/J3qLt+H+16t4uqJyi1U
	 fUFTlq5l2PMnkr7OZrFIl/U+Qq2BX40BZ/jdXdmeLfbq5MxKS+yOMi3isnCOjqK3z9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793894977;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Sq45WZkafyQRStnwZGvLqMCet9YvKwwHk/3YiOI3syo=;
	b=tU9sXwqhdAL1FfNJ9I4/rGt0oNBhV7d55eNUlAv4jJEPeida8TMaWfYV/J9p/zZVswQY
	 E4QsXLfscUhW2ra+2iTQ5+OlRQfG+v9ee7URkIcSv8LdGxhietOGCnfpyX5Vq5AhwlISa
	 KwmCI1MKFDO5uI6WWQWDlt0CiskaToQC8rcfySuynwvUaBGLflwW7ro3rlklQVQmI7sIv
	 3zso7AI6N8hpwYlnGhEr3z+k5HVAMhlaPNs/qnZ4xNhe/O0uzFgXmMhhPFIFt6Kdqd1fu
	 5UcR/B9F92C7NpZGv5lOmq0XnFLquUr0bsI26q1WjHfIMpgw6acFdcn1p9mlMRyYy9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D8IXJyVo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2817606BE9E
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 16:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D8IXJyVo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E621F000C1;
	Thu,  5 Nov 2026 16:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793894976;
	bh=Sq45WZkafyQRStnwZGvLqMCet9YvKwwHk/3YiOI3syo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=D8IXJyVom420s27OVTKQuPLOmur3QUV+7oMNUM30XF9bOwcjj7ZnztdFX8sPHJOQo
	 nXnxQ8lRsGgY1BZbDSWZnfIBGJPzny7ZqYw69yyplEN/r+DJeWLYBwIgR4cofQxdZc
	 Tr5zMvwt1+N1fHjLw0RO/NHyXT3+RXKH+YMHfwmyggQkcH3NNRGblyL1eN0C9YkUtW
	 3SSY5j0odHaVsSpRElBZuyqeS6w4B/898P7x7szV/UcRjgh0aQJFppGNs9Y9spX8La
	 cMVMoxQQoR4eV3Ce2ALddODNTyAiZsndrqW0w877jiyXUL08Bgc2qZpJjJWZgA+ge0
	 FwEgeVEUpnp/A==
Message-ID: <sashiko-outbox-199433@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 11/15] RDMA/xsc: add RDMA PD/MR
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xin Tian" <tianx@yunsilicon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261104155715.37053-12-tianx@yunsilicon.com>
References: <20261104155650.37053-1-tianx@yunsilicon.com>
 <20261104155715.37053-12-tianx@yunsilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 16:09:36 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] RDMA/xsc: shift out of bounds in __xsc_ib_cont_pages() when addr i=
s 0
- [High] RDMA/xsc: negative shift and 32-bit overflow in __xsc_ib_populate_=
pas()
- [Medium] RDMA/xsc: skipped MPT deregistration for DMA MRs and repeat dere=
g in xsc_ib_dereg_mr()
- [Medium] RDMA/xsc: missing mr->ibmr.iova and page_size init in user MR re=
gistration
--

commit cab7841014d8407bdc13cf06eb834f8c3aa28962
Author: Xin Tian <tianx@yunsilicon.com>

RDMA/xsc: add RDMA PD/MR

This commit implements the protection domain and memory region verbs for the
xsc RDMA driver, including user MR, dmabuf MR, and DMA MR registration as w=
ell
as the corresponding firmware commands.

> diff --git a/drivers/infiniband/hw/xsc/mem.c b/drivers/infiniband/hw/xsc/=
mem.c
> new file mode 100644
> index 0000000000000..cb13766480f1c
> --- /dev/null
> +++ b/drivers/infiniband/hw/xsc/mem.c
> @@ -0,0 +1,160 @@
[ ... ]
> +static void __xsc_ib_cont_pages(struct ib_umem *umem, u64 addr,
> +				unsigned long max_page_shift,
> +				int *count, int *shift, int *ncont)
> +{
> +	unsigned long tmp;
> +	unsigned long m;
> +	u64 base =3D ~0, p =3D 0;
> +	u64 len, pfn;
> +	int i =3D 0;
> +	struct scatterlist *sg;
> +	int entry;
> +	/* TODO: need peer mem support */
> +	unsigned long page_shift =3D PAGE_SHIFT;
> +
> +	addr =3D addr >> page_shift;
> +	tmp =3D (unsigned long)addr;
> +	m =3D find_first_bit(&tmp, BITS_PER_LONG);
> +	if (max_page_shift)
> +		m =3D min_t(unsigned long, max_page_shift - page_shift, m);
> +	for_each_sgtable_dma_sg(&umem->sgt_append.sgt, sg, entry) {
> +		len =3D sg_dma_len(sg) >> page_shift;
> +		pfn =3D sg_dma_address(sg) >> page_shift;
> +		if (base + p !=3D pfn) {
> +			/* If either the offset or the new
> +			 * base are unaligned update m
> +			 */
> +			tmp =3D (unsigned long)(pfn | p);
> +			if (!IS_ALIGNED(tmp, 1UL << m))
> +				m =3D find_first_bit(&tmp, BITS_PER_LONG);
> +
> +			base =3D pfn;
> +			p =3D 0;
> +		}
> +
> +		p +=3D len;
> +		i +=3D len;
> +	}
> +
> +	if (i) {
> +		m =3D min_t(unsigned long, ilog2(roundup_pow_of_two(i)), m);
> +		*ncont =3D DIV_ROUND_UP(i, (1 << m));
> +	} else {
> +		m =3D 0;
> +		*ncont =3D 0;
> +	}
> +	*shift =3D page_shift + m;
> +	*count =3D i;
> +}
> +
> +void xsc_ib_cont_pages(struct ib_umem *umem, u64 addr,
> +		       int *count, int *shift, int *ncont)
> +{
> +	/* no limit for page_shift */
> +	__xsc_ib_cont_pages(umem, addr, 0, count, shift, ncont);
> +}

[Severity: High]
Can __xsc_ib_cont_pages() trigger a shift-out-of-bounds undefined behavior =
and
miscalculate the compound page size when addr >> page_shift is 0?

xsc_ib_cont_pages() calls __xsc_ib_cont_pages() with max_page_shift =3D=3D =
0. When
addr >> page_shift is 0 (or on 32-bit builds when the lower 32 bits of
addr >> page_shift are 0), find_first_bit(&tmp, BITS_PER_LONG) returns
BITS_PER_LONG and m is not clamped because max_page_shift is 0.

Inside the scatterlist loop, IS_ALIGNED(tmp, 1UL << m) then evaluates
1UL << BITS_PER_LONG, which is undefined behavior in C. On architectures th=
at
mask the shift count to BITS_PER_LONG - 1, 1UL << BITS_PER_LONG evaluates to
1UL, making IS_ALIGNED(tmp, 1UL) unconditionally true so m is never reduced=
 to
match unaligned or discontiguous scatterlist segments. The same happens if
pfn | p is 0 on the first segment.

Also, in DIV_ROUND_UP(i, (1 << m)), 1 << m uses a 32-bit signed int literal,
which overflows if m >=3D 31. Should m be clamped to a valid shift range an=
d use
1UL << m?

> +
> +static void __xsc_ib_populate_pas(struct xsc_ib_dev *dev, struct ib_umem=
 *umem,
> +				  int page_shift, size_t offset, size_t num_pages,
> +				  __be64 *pas, int access_flags, bool need_to_devide)
> +{
> +	unsigned long umem_page_shift =3D PAGE_SHIFT;
> +	int shift =3D page_shift - umem_page_shift;
> +	int mask =3D (1 << shift) - 1;
> +	int i =3D 0;
> +	int k, idx;
> +	u64 cur =3D 0;
> +	u64 base;
> +	int len;
> +	struct scatterlist *sg;
> +	int entry;
> +
> +	for_each_sgtable_dma_sg(&umem->sgt_append.sgt, sg, entry) {
> +		if (need_to_devide)
> +			len =3D sg_dma_len(sg) >> XSC_PAGE_SHIFT_4K;
> +		else
> +			len =3D sg_dma_len(sg) >> umem_page_shift;
> +		base =3D sg_dma_address(sg);
> +
> +		/* Skip elements below offset */
> +		if (i + len < offset << shift) {
> +			i +=3D len;
> +			continue;
> +		}
> +
> +		/* Skip pages below offset */
> +		if (i < offset << shift) {
> +			k =3D (offset << shift) - i;
> +			i =3D offset << shift;
> +		} else {
> +			k =3D 0;
> +		}
> +
> +		for (; k < len; k++) {
> +			if (!(i & mask)) {
> +				if (need_to_devide)
> +					cur =3D base + (k << XSC_PAGE_SHIFT_4K);
> +				else
> +					cur =3D base + (k << umem_page_shift);

[Severity: High]
Does __xsc_ib_populate_pas() produce a negative shift or misindex pas[] when
need_to_devide is true, and can k << XSC_PAGE_SHIFT_4K overflow 32-bit sign=
ed
arithmetic?

At the start of __xsc_ib_populate_pas(), umem_page_shift is hardcoded to
PAGE_SHIFT to compute shift =3D page_shift - umem_page_shift and
mask =3D (1 << shift) - 1. However, when need_to_devide is true, the loop
divides scatterlist segments into 4K units (XSC_PAGE_SHIFT_4K). On kernels
where PAGE_SHIFT > 12 (such as 64K-page arm64 kernels), passing
page_shift =3D=3D XSC_PAGE_SHIFT_4K makes shift negative, causing negative =
shift
undefined behavior in (1 << shift), (offset << shift), and (i >> shift). And
if page_shift > PAGE_SHIFT while need_to_devide is true, i counts 4K pages
while shift is relative to PAGE_SHIFT, causing pas[] entries to be skipped.

Additionally, k is declared as a 32-bit signed int, so k << XSC_PAGE_SHIFT_=
4K
and k << umem_page_shift are evaluated as 32-bit signed integers before bei=
ng
added to u64 base. Because the PCI layer configures a 2 GiB max DMA segment
size (SZ_2G), a 2 GiB segment has len =3D=3D 524288 (0x80000) 4K pages; whe=
n k
reaches 0x80000, k << 12 overflows 32-bit signed int to -2147483648 and
sign-extends to 0xffffffff80000000ULL when added to base.

> diff --git a/drivers/infiniband/hw/xsc/mr.c b/drivers/infiniband/hw/xsc/m=
r.c
> new file mode 100644
> index 0000000000000..b5dc088fcbbde
> --- /dev/null
> +++ b/drivers/infiniband/hw/xsc/mr.c
> @@ -0,0 +1,335 @@
[ ... ]
> +struct ib_mr *xsc_ib_get_dma_mr(struct ib_pd *pd, int acc)
> +{
> +	struct xsc_ib_dev *dev =3D to_xdev(pd->device);
> +	struct xsc_core_device *xdev =3D dev->xdev;
> +	struct xsc_register_mr_mbox_in *in;
> +	struct xsc_register_mr_request *req;
> +	struct xsc_ib_mr *mr;
> +	int err;
> +
> +	mr =3D kzalloc_obj(*mr, GFP_KERNEL);
> +	if (!mr)
> +		return ERR_PTR(-ENOMEM);
> +
> +	in =3D kzalloc_obj(*in, GFP_KERNEL);
> +	if (!in) {
> +		err =3D -ENOMEM;
> +		goto err_free;
> +	}
> +
> +	req =3D &in->req;
> +	req->pdn =3D cpu_to_be32(to_xpd(pd)->pdn);
> +	req->acc =3D convert_access(acc);
> +	req->va_base =3D 0;
> +	req->map_en =3D !(XSC_MPT_MAP_EN);
> +
> +	err =3D xsc_core_create_mkey(xdev, &mr->xmr);
> +	if (err)
> +		goto err_in;
> +	req->mkey =3D cpu_to_be32(mr->xmr.key);
> +	err =3D xsc_core_register_mr(xdev, &mr->xmr, in, sizeof(*in));
> +	if (err)
> +		goto err_reg_mr;
> +	kfree(in);
> +	mr->ibmr.lkey =3D mr->xmr.key;
> +	mr->ibmr.rkey =3D mr->xmr.key;
> +	mr->umem =3D NULL;
> +
> +	return &mr->ibmr;
[ ... ]
> +struct ib_mr *xsc_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
> +				 u64 virt_addr, int access_flags,
> +				 struct ib_dmah *dmah,
> +				 struct ib_udata *udata)
> +{
[ ... ]
> +	mr->umem =3D umem;
> +	mr->npages =3D npages;
> +	mr->ibmr.lkey =3D mr->xmr.key;
> +	mr->ibmr.rkey =3D mr->xmr.key;
> +	mr->ibmr.length =3D length;
> +	return &mr->ibmr;
> +
> +error:
> +	ib_umem_release(umem);
> +	return ERR_PTR(err);
> +}
> +
> +struct ib_mr *xsc_ib_reg_user_mr_dmabuf(struct ib_pd *pd, u64 offset,
> +					u64 length, u64 virt_addr,
> +					int fd, int access_flags,
> +					struct ib_dmah *dmah,
> +					struct uverbs_attr_bundle *attrs)
> +{
[ ... ]
> +	mr->umem =3D umem;
> +	mr->npages =3D npages;
> +	mr->ibmr.lkey =3D mr->xmr.key;
> +	mr->ibmr.rkey =3D mr->xmr.key;
> +	mr->ibmr.length =3D length;
> +
> +	return &mr->ibmr;
> +err_release:
> +	ib_umem_release(umem);
> +	return ERR_PTR(err);
> +}

[Severity: Medium]
Should xsc_ib_reg_user_mr() and xsc_ib_reg_user_mr_dmabuf() also initialize
mr->ibmr.iova and mr->ibmr.page_size?

Unlike the legacy write path in ib_uverbs_reg_mr(), the ioctl paths
UVERBS_METHOD_REG_MR and UVERBS_METHOD_REG_DMABUF_MR in uverbs_std_types_mr=
.c
do not set mr->iova, and UVERBS_METHOD_QUERY_MR copies mr->iova back to
userspace via UVERBS_ATTR_QUERY_MR_RESP_IOVA. Leaving mr->ibmr.iova and
mr->ibmr.page_size unset causes MR queries to report iova =3D=3D 0 instead =
of
virt_addr and leaves page_size as 0.

Also, since CONFIG_INFINIBAND_XSC does not depend on 64BIT, passing u64
start/offset and u64 length directly to ib_umem_get_va() and
ib_umem_dmabuf_get_pinned() truncates 64-bit values to 32-bit unsigned long
and size_t on 32-bit builds while programming the untruncated 64-bit length
into the MPT.

> +
> +int xsc_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
> +{
> +	struct xsc_ib_dev *dev =3D to_xdev(ibmr->device);
> +	struct xsc_ib_mr *mr =3D to_xmr(ibmr);
> +	struct ib_umem *umem =3D mr->umem;
> +	int err;
> +
> +	ibdev_dbg(&dev->ib_dev, "dereg mkey =3D 0x%x\n", mr->xmr.key);
> +
> +	if (mr->npages) {
> +		err =3D xsc_core_dereg_mr(dev->xdev, &mr->xmr);
> +		if (err) {
> +			ibdev_warn(&dev->ib_dev, "failed to dereg mr 0x%x (%d)\n",
> +				   mr->xmr.key, err);
> +			return err;
> +		}
> +	}
> +	err =3D xsc_core_destroy_mkey(dev->xdev, &mr->xmr);
> +	if (err) {
> +		ibdev_warn(&dev->ib_dev, "failed to destroy mkey 0x%x (%d)\n",
> +			   mr->xmr.key, err);
> +		return err;
> +	}

[Severity: Medium]
Why is xsc_core_dereg_mr() gated on mr->npages in xsc_ib_dereg_mr()?

In xsc_ib_get_dma_mr(), the driver calls xsc_core_register_mr(), which
programs the hardware MPT entry via XSC_CMD_OP_SET_MPT, while mr->npages
remains 0. When a DMA MR is later deregistered in xsc_ib_dereg_mr(), the
if (mr->npages) check skips xsc_core_dereg_mr() and only calls
xsc_core_destroy_mkey(), leaving the MPT entry programmed in firmware.

Conversely, for user MRs where mr->npages > 0, if xsc_core_dereg_mr() succe=
eds
but xsc_core_destroy_mkey() fails, xsc_ib_dereg_mr() returns an error witho=
ut
clearing mr->npages, so a subsequent retry will invoke xsc_core_dereg_mr() a
second time on the already-deregistered MR.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104155650.3705=
3-1-tianx@yunsilicon.com?part=3D11
