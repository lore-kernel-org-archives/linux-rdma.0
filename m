Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF15239CCFD
	for <linux-rdma@vger.kernel.org>; Sat, 10 Oct 2026 07:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791616044; cv=none; b=nSPyVBkhL+OXORVkZKxVqd9QkgC1VOpAaT2KPkCmfO5sym69b66SrOVarLHbMEzPcL9QVng7OBFKPEf0noAK+KdMegRtgTg0soL1pzqaL1zGvMwL516SF6i54IQdqSjFbvqHnLGYVmeUecEsaiFd1B/bzh6IQboEIV0ISpv5BGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791616044; c=relaxed/simple;
	bh=svD5ZEC+bQisafxa9FicrtoMnezsBXxjacDd1rKKVBk=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=SEgdHXcBXkdcKQXnlC+jit0WGBZ1c1vYKQtsJl/w0R8tbCLM6alj/3lx63DXNFmgQhgUnWjkP/OFI6D1cID0luK1ntBsYd3mPVB8vtHOLIxnWD45jAXuDIu9KctPtf1UcbAYZYEUtzQITMfmlPhsLpcnd9LA2li4+DVCYU8TOjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oux+Vxzf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oux+Vxzf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4141F000FF;
	Sat, 10 Oct 2026 07:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791616042;
	bh=QNgpvvz0vChub7tOMfacue/ugP9VU+LYxi7aYbh4jss=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oux+VxzfbYU42S0KHtyCYpRvCaP8m1COpuJAQIDoPuMeHcxU/FAXhQvDpdabcrPC3
	 sT1tNGh4FxRHWI/TFsWliUxmO/bcJYsKkrX14yOJGAOdMWSvL49Ra4FTjjSZaCEGs6
	 pOrkV/CCOWXcymHAN3DKxiC4TLzoZQ9aEFJEwggfv4PjwVetHe929KanEzDsOI/lea
	 Al0t2JXIaTG2lUAXPpLlj2nMTFFV8A5NsbfES1ez7uJQ5HzS9WkjLP+vddb4FhEYeK
	 QIjQwic79JSYkRDea2UlxXucBevQnDdk63RGlvZRCbSxli4gxoFLoT9rxP5+t8oCh/
	 Ay1sqFGjPAn1A==
Message-ID: <sashiko-outbox-166293@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v4 01/10] RDMA/mana_ib: Allocate and map
 fast-registration MRs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261010065443.3554193-2-kotaranov@linux.microsoft.com>
References: <20261010065443.3554193-1-kotaranov@linux.microsoft.com>
 <20261010065443.3554193-2-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 10 Oct 2026 07:07:22 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] rdma: missing bounds check on max_num_sg leading to integer overfl=
ow and OOB write
- [Low] rdma: hardware structure defined using compiler-dependent C bitfiel=
ds
--

commit 7ef4d39c8200798999dc9e55ae57d45e1ec08621
Author: Konstantin Taranov <kotaranov@microsoft.com>

RDMA/mana_ib: Allocate and map fast-registration MRs

Implement alloc_mr and map_mr_sg for memory-registration MRs.

> diff --git a/drivers/infiniband/hw/mana/mana_ib.h b/drivers/infiniband/hw=
/mana/mana_ib.h
> index 9173ca64d2e1e..da9b48b422a1c 100644
> --- a/drivers/infiniband/hw/mana/mana_ib.h
> +++ b/drivers/infiniband/hw/mana/mana_ib.h

[ ... ]

> +#define MANA_FMR_MST_ALIGNMENT 64
> +
> +struct mana_fmr_mst_entry {
> +	u32 reserved1;
> +	u32 reserved2		: 8;
> +	u32 page_size		: 5;
> +	u32 reserved3		: 3;
> +	u32 access_right	: 8;
> +	u32 addr_type		: 2;
> +	u32 reserved4		: 6;
> +	u32 reserved5[2];
> +	u64 start_va;
> +	u64 length;
> +	u32 reserved6[8];
> +}; /* HW DATA */

[Severity: Low]
This structure defines a hardware interface but uses C bitfields. Are there
risks of compiler-dependent memory layout causing portability issues when u=
sed
for hardware ABI?

> +
> +static inline u32 mana_ib_fmr_header_offset(u32 num_ptes)
> +{
> +	/* The header follows the PTEs with the required MST alignment. */
> +	return ALIGN(sizeof(u64) * num_ptes, MANA_FMR_MST_ALIGNMENT);
> +}

[Severity: High]
Could sizeof(u64) * num_ptes produce a 64-bit value that is silently trunca=
ted
by the u32 return type when num_ptes is very large?

[ ... ]

> diff --git a/drivers/infiniband/hw/mana/mr.c b/drivers/infiniband/hw/mana=
/mr.c
> index 1233685b4b890..34dcc50d0be96 100644
> --- a/drivers/infiniband/hw/mana/mr.c
> +++ b/drivers/infiniband/hw/mana/mr.c

[ ... ]

> +struct ib_mr *mana_ib_alloc_mr(struct ib_pd *ibpd, enum ib_mr_type mr_ty=
pe,
> +			       u32 max_num_sg)
> +{
> +	struct mana_ib_pd *pd =3D container_of(ibpd, struct mana_ib_pd, ibpd);
> +	struct gdma_create_mr_params mr_params =3D {};
> +	struct gdma_context *gc;
> +	struct mana_ib_dev *dev;
> +	struct mana_ib_mr *mr;
> +	int err;
> +
> +	dev =3D container_of(ibpd->device, struct mana_ib_dev, ib_dev);
> +	gc =3D mdev_to_gc(dev);
> +
> +	if (mr_type !=3D IB_MR_TYPE_MEM_REG)
> +		return ERR_PTR(-EOPNOTSUPP);
> +
> +	mr =3D kzalloc_obj(*mr);
> +	if (!mr)
> +		return ERR_PTR(-ENOMEM);
> +
> +	mr->fmr.max_ptes =3D max_num_sg;
> +	mr->fmr.size =3D mana_ib_fmr_buf_sz(max_num_sg);
> +	mr->fmr.ptes =3D dma_alloc_coherent(gc->dev, mr->fmr.size, &mr->fmr.dma=
_handle,
> +					  GFP_KERNEL);

[Severity: High]
Since max_num_sg is used without validation, is it possible for an excessiv=
ely
large value to result in an undersized allocation for mr->fmr.ptes, given t=
he
potential truncation in mana_ib_fmr_header_offset() called by
mana_ib_fmr_buf_sz()?

[ ... ]

> +static int mana_ib_set_page(struct ib_mr *ibmr, u64 addr)
> +{
> +	struct mana_ib_mr *mr =3D container_of(ibmr, struct mana_ib_mr, ibmr);
> +
> +	if (mr->fmr.pte_count >=3D mr->fmr.max_ptes)
> +		return -ENOMEM;
> +
> +	mr->fmr.ptes[mr->fmr.pte_count] =3D addr | MANA_PTE_VALID_MASK;
> +	mr->fmr.pte_count++;
> +
> +	return 0;
> +}

[Severity: High]
If mr->fmr.size was truncated to a small value, but mr->fmr.max_ptes retains
the original large max_num_sg value, would this bounds check be insufficien=
t to
prevent out-of-bounds writes into memory past the allocated DMA buffer?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261010065443.3554=
193-1-kotaranov@linux.microsoft.com?part=3D1
