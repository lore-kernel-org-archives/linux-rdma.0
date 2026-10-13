Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D487C4F30F4
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 11:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791891972; cv=none; b=Re6Qc9YT7+za8i4BUiG5taCe7c194VMrAAvLQr2RKTg/6YNyWHb/3GHWp9AMkmGpJiKJfgpxQ3dH/mampfQL+m6Sn/Jl6SKrskXGhcJOL02ULNOwMYiqLqAueGa+lqr1LkKwGjRovfT6Mb0wxKb2SVC+a8+bwc7bY8G/kBsN/j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791891972; c=relaxed/simple;
	bh=AZxUgR0F6aytlkh6EzwbSHEx82IIAUg9iAT4i4fmxW4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=b10ge8y/eC1Ja+ctYqfjypR6WJLoue36HzTfNHXsipdPJeKkIejtORXSsRwzkSumepaP2e5O6IYurCC179uHaanylk7B3+GULklo3/BYaL7Od/g39QbiuWE+Q75AqmTT/tec6NTUQqjqLDQhtteqNoPkdpLiuhs4xOheYx5hlLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MT8FH/CI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MT8FH/CI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D071F0089A;
	Tue, 13 Oct 2026 11:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791891970;
	bh=bOn0LMDSYMn/W4vXSx5oJi0VA74dFHw0fr8CZZBsu0k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MT8FH/CIf6zgX5/r1ljPkPoXmdgFt5ziVArFR3/26GA7qLLmJ5EezZ/jakexMCppc
	 R3XQ50OluHIw3frIUE4IOlF/Bmslv5vLWWbxGLrQ8sfaXVIS4gB++dim9DwzTvJ8Mr
	 erIOamtXAQuk5t5ELfKIn6UTt5eG1dGXR5b9YJsKXERdci9QLxfRrzpw2LHtOHdkQT
	 /7uIk/H62kFFYPjY8hfOBfX+KFMa4gyXFqAiyvKnEYo5sQLpbXMjS80D7QbUrlKVH5
	 ATMoYHcSC870JPp/6RqdvTTSifcRgrw9muHPt23fmgnQ8tRJp8Lph8SI/ShbR/G7y8
	 6heDHs7pqAyJw==
Message-ID: <sashiko-outbox-169644@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 10/15] yunsilicon: add RDMA PD/MR
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xin Tian" <tianx@yunsilicon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261012114415.2471317-11-tianx@yunsilicon.com>
References: <20261012114352.2471317-1-tianx@yunsilicon.com>
 <20261012114415.2471317-11-tianx@yunsilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 11:46:10 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:
- [Critical] rdma/xsc: massive heap buffer overflow due to 32-bit truncatio=
n of npages
- [Critical] rdma/xsc: arbitrary physical memory exposure via unvalidated m=
map size
- [High] rdma/xsc: MPT resource leak on DMA MR deregistration due to npages=
 check
- [High] rdma/xsc: xsc_ib_get_dma_mr ignores ib_pd argument and hardcodes p=
dn to 0
- [High] drivers/infiniband: hw/xsc: unhandled xsc_reg_local_dma_mr failure
- [Medium] rdma/xsc: undefined behavior and zero-division on bitwise shifts=
 exceeding 31 bits
--

commit 858863cb9a838a1ac3899ebcbed7d2f60b3b8241
Author: Xin Tian <tianx@yunsilicon.com>

yunsilicon: add RDMA PD/MR

This commit adds protection domains and memory regions for the yunsilicon
RDMA driver. It introduces PD allocation, kernel and user MR registration
paths, and DMA address translation helpers.

> diff --git a/drivers/infiniband/hw/xsc/main.c b/drivers/infiniband/hw/xsc=
/main.c
> --- a/drivers/infiniband/hw/xsc/main.c
> +++ b/drivers/infiniband/hw/xsc/main.c
> @@ -343,45 +343,45 @@ static int xsc_ib_mmap(struct ib_ucontext *ibcontex=
t, struct vm_area_struct *vma
>  {
>  	struct xsc_ib_dev *dev =3D to_xdev(ibcontext->device);
>  	struct xsc_core_device *xdev =3D dev->xdev;
>  	unsigned long offset =3D vma->vm_pgoff << PAGE_SHIFT;
>  	resource_size_t reg_base;
>  	resource_size_t reg_size =3D vma->vm_end - vma->vm_start;

[ ... ]

>  	vma->vm_page_prot =3D pgprot_noncached(vma->vm_page_prot);
>  	return remap_pfn_range(vma, vma->vm_start, reg_base >> PAGE_SHIFT,
>  			       reg_size, vma->vm_page_prot);
>  }

[Severity: Critical]
Can this mapping size be safely used without validation?

In xsc_ib_mmap(), the requested mapping size is calculated entirely from
userspace input (reg_size =3D vma->vm_end - vma->vm_start). The function
checks the offset parameter to select a hardware base address, but it
doesn't validate whether reg_size exceeds the actual bounds of that
hardware region.

Passing this unvalidated reg_size directly to remap_pfn_range() could allow
userspace to map arbitrary adjacent physical memory or PCI MMIO regions.

> diff --git a/drivers/infiniband/hw/xsc/mem.c b/drivers/infiniband/hw/xsc/=
mem.c
> --- /dev/null
> +++ b/drivers/infiniband/hw/xsc/mem.c
> @@ -0,0 +1,161 @@

[ ... ]

> +static void __xsc_ib_cont_pages(struct ib_umem *umem, u64 addr,
> +				unsigned long max_page_shift,
> +				int *count, int *shift, int *ncont)
> +{

[ ... ]

> +		if (base + p !=3D pfn) {
> +			/* If either the offset or the new
> +			 * base are unaligned update m
> +			 */
> +			tmp =3D (unsigned long)(pfn | p);
> +			if (!IS_ALIGNED(tmp, 1 << m))
> +				m =3D find_first_bit(&tmp, BITS_PER_LONG);
> +
> +			base =3D pfn;
> +			p =3D 0;
> +		}

[Severity: Medium]
Could this result in undefined behavior and a zero division?

If the DMA address is 0 (which is a valid IOMMU DMA address), tmp will be
0, causing find_first_bit() to return BITS_PER_LONG (64). The subsequent
shift of a 32-bit signed literal (1 << m) will be shifted by 64 bits.

This undefined value is later used as a divisor:
*ncont =3D DIV_ROUND_UP(i, (1 << m));

Similarly, in xsc_ib_get_buf_offset() lower in this file,
page_size =3D 1 << page_shift will overflow for 2GB hugepages
(page_shift =3D=3D 31), incorrectly sign-extending the 64-bit page_mask.

> diff --git a/drivers/infiniband/hw/xsc/mr.c b/drivers/infiniband/hw/xsc/m=
r.c
> --- /dev/null
> +++ b/drivers/infiniband/hw/xsc/mr.c
> @@ -0,0 +1,313 @@

[ ... ]

> +struct ib_mr *xsc_ib_get_dma_mr(struct ib_pd *pd, int acc)
> +{

[ ... ]

> +	req =3D &in->req;
> +	req->acc =3D convert_access(acc);
> +	req->va_base =3D 0;
> +	req->map_en =3D !(XSC_MPT_MAP_EN);
> +
> +	err =3D xsc_core_create_mkey(xdev, &mr->xmr);

[Severity: High]
Does this code assign the protection domain to the DMA MR?

The req structure is zero-initialized via kzalloc_obj(), so req->pdn
defaults to 0. The ib_pd argument provided by the caller doesn't appear
to be assigned to req->pdn before calling xsc_core_register_mr().

This could cause the hardware to register the MR under PD 0, which might
break kernel components that allocate QPs in their own PDs and rely on
this DMA MR.

[ ... ]

> +struct ib_mr *xsc_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
> +				 u64 virt_addr, int access_flags,
> +				 struct ib_dmah *dmah,
> +				 struct ib_udata *udata)
> +{

[ ... ]

> +	pgsz =3D ib_umem_find_best_pgsz(umem, XSC_MR_PAGE_CAP_MASK, virt_addr);
> +	if (!pgsz) {
> +		ibdev_warn(&dev->ib_dev, "find best page size failed\n");
> +		err =3D -EINVAL;
> +		goto error;
> +	}
> +
> +	page_shift =3D order_base_2(pgsz);
> +	npages =3D ib_umem_num_dma_blocks(umem, pgsz);

[Severity: Critical]
Does this code truncate the block count?

ib_umem_num_dma_blocks() returns a 64-bit size_t block count, which is
being assigned to a 32-bit signed int npages.

For large memory regions, truncating this value causes the subsequent
buffer allocation in reg_create() to be undersized:

inlen =3D sizeof(*in) + sizeof(*in->req.pas) * npages;
in =3D xsc_vzalloc(inlen);

Then rdma_umem_for_each_dma_block() will execute based on the actual umem
blocks, writing 64-bit physical addresses far out of the allocated bounds.
Could this lead to a heap buffer overflow?

[ ... ]

> +int xsc_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
> +{

[ ... ]

> +	ibdev_dbg(&dev->ib_dev, "dereg mkey =3D 0x%x\n", mr->xmr.key);
> +
> +	if (mr->npages) {
> +		err =3D xsc_core_dereg_mr(dev->xdev, &mr->xmr);

[Severity: High]
Does this skip firmware deregistration for local DMA MRs?

xsc_ib_get_dma_mr() initializes a local DMA MR with req->pa_num =3D 0, which
results in mr->npages =3D 0, but it successfully allocates and configures an
MPT entry in hardware.

When deregistering, checking if (mr->npages) bypasses the
XSC_CMD_OP_DEREG_MR teardown command for these MRs. Will this leak MPT
resources for every DMA MR created and destroyed?

[ ... ]

> +void xsc_reg_local_dma_mr(struct xsc_core_device *dev)
> +{

[ ... ]

> +	err =3D xsc_core_register_mr(dev, NULL, &in, sizeof(in));
> +	if (err)
> +		dev_err(&dev->pdev->dev, "\n");
> +}

[Severity: High]
Is it safe to ignore this MR registration failure?

If xsc_core_register_mr() fails, the error is caught and printed, but the
function returns void without propagating the failure. The caller (init_one)
will then proceed to register the IB device and advertise
local_dma_lkey =3D 0xFF.

If components attempt to use this unregistered MKEY for DMA, won't the
hardware generate memory protection faults?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012114352.2471=
317-1-tianx@yunsilicon.com?part=3D10
