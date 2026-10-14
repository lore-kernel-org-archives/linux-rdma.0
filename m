Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECAD4E80DF
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 16:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791995977; cv=none; b=EhKevx4U21xwscxX7k5mn2YXdeJ05ggNslDRpwXqzbYSYM7p7Bhz+mPKMqkx9sXX8jodfTmZhzRXJ/l/et6ctiJQZfw+87ghZFUTbDTYt8ZGu0CyVij6tWreuJPxhNwuFzQtmr95C/P6a23VHXeFLygy40/aPKcv20FmqI0EiD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791995977; c=relaxed/simple;
	bh=FpreTvCblzxHt+JtO/O43FEKGeEexXJJT3eJqYx61Po=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=JhtgGKvyIgMetXI/Dotce4/qb4601ubs9bJgJ62v21ENEY08YqSgjimu6DbakG8DPSJHPvsUE6Xy3K9fK7hK7zvgkUnxg5XV+ONNFzHBgbWkETiDznmMLylRe2VA6VHG1X2D7sHKmBpOz4gupQHnjWaLYa7ifVLK63B1qsAf+Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ny+SKQ6c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ny+SKQ6c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C14211F000C4;
	Wed, 14 Oct 2026 16:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791995975;
	bh=aKhKcWPWyjOrIj7BKMRGvpBtRKIfisCvjQMJs6AXEc0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ny+SKQ6cDL7HtkfnD74Xa8lH71N8f5FNM177Jj+3q20D4EuWfcbcbvX6YPi1vQchX
	 bUcQKctnadG+aOPbl44DPFPiChcTj7rOSWC93q8L1LjHN2rwLdqw6Jy97ywbGtkn8K
	 lFLwoG2DZz7q69sTE5ylj0uiJjsss6VABrlyhdTBcdfDD6VXTuTelpDaBvzzWxU3Vl
	 tkXbQ/TyEzK1ZWiYp15qnZLAgE3JWxX44RXSlKN0BmKmzTwkM0UFJPP4K6Chd7p/YU
	 Qz6KzTe0cOxYBusLdYZIkMC339Hmi8QLd5GNYXy7Cr6FzxDjje0C2NFS5476GeDB93
	 IHxXBeSpDdujA==
Message-ID: <sashiko-outbox-171546@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2] RDMA/irdma: Check MR contiguity before
 PBLE alloc
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jacob Moroni" <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261014162144.4053279-1-jmoroni@google.com>
References: <20261014162144.4053279-1-jmoroni@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 16:39:35 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] irdma: double free of PBLE on MR reregistration HW failure
--

commit 448b999143bf40a6d4795a1e901ceab0ac8c8c2d
Author: Jacob Moroni <jmoroni@google.com>

RDMA/irdma: Check MR contiguity before PBLE alloc

This commit checks if a memory region is contiguous before attempting to
allocate PBLEs. This prevents unnecessary PBLE allocation failures from
causing memory registration to fail when a direct mapping could have been
used instead.

> diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/=
irdma/verbs.c
> index 71d7ae7baa478..f89c8516c57c0 100644
> --- a/drivers/infiniband/hw/irdma/verbs.c
> +++ b/drivers/infiniband/hw/irdma/verbs.c

[ ... ]

> @@ -3413,24 +3374,33 @@ static int irdma_reg_user_mr_type_mem(struct irdm=
a_mr *iwmr, int access,
>  {
>  	struct irdma_device *iwdev =3D to_iwdev(iwmr->ibmr.device);
>  	struct irdma_pbl *iwpbl =3D &iwmr->iwpbl;
> +	struct ib_umem *region =3D iwmr->region;
>  	u32 stag =3D 0;
> -	u8 lvl;
>  	int err;
> =20
> -	lvl =3D iwmr->page_cnt !=3D 1 ? PBLE_LEVEL_1 | PBLE_LEVEL_2 : PBLE_LEVE=
L_0;
>  	iwmr->access =3D access;
> =20
> -	err =3D irdma_setup_pbles(iwdev->rf, iwmr, lvl);
> -	if (err)
> -		return err;
> -
> -	if (lvl) {
> -		err =3D irdma_check_mr_contiguous(&iwpbl->pble_alloc,
> +	if (ib_umem_is_contiguous(region)) {
> +		/* HW needs a valid page size even without PBLEs, so use 4K. It
> +		 * behaves like a PBLE-backed region where the PBA must be page
> +		 * aligned. HW takes the page offset from the lower 12 VA bits.
> +		 */
> +		iwmr->page_size =3D SZ_4K;
> +		iwmr->pgaddrmem[0] =3D ALIGN_DOWN(ib_umem_start_dma_addr(region),
>  						iwmr->page_size);
> -		if (err) {
> -			irdma_free_pble(iwdev->rf->pble_rsrc, &iwpbl->pble_alloc);
> -			iwpbl->pbl_allocated =3D false;
> -		}
> +	} else {
> +		iwmr->page_size =3D ib_umem_find_best_pgsz(region,
> +				iwdev->rf->sc_dev.hw_attrs.page_size_cap,
> +				iwmr->ibmr.iova);
> +		if (unlikely(!iwmr->page_size))
> +			return -EOPNOTSUPP;
> +
> +		iwmr->page_cnt =3D ib_umem_num_dma_blocks(region,
> +							iwmr->page_size);
> +		err =3D irdma_setup_pbles(iwdev->rf, iwmr,
> +					PBLE_LEVEL_1 | PBLE_LEVEL_2);
> +		if (err)
> +			return err;
>  	}
> =20
>  	if (create_stag) {
>  		stag =3D irdma_create_stag(iwdev);
>  		if (!stag) {
>  			err =3D -ENOMEM;
>  			goto free_pble;
>  		}
> =20
>  		iwmr->stag =3D stag;
>  		iwmr->ibmr.rkey =3D stag;
>  		iwmr->ibmr.lkey =3D stag;
>  	}
> =20
>  	err =3D irdma_hwreg_mr(iwdev, iwmr, access);
>  	if (err)
>  		goto err_hwreg;
> =20
>  	return 0;
> =20
>  err_hwreg:
>  	if (stag)
>  		irdma_free_stag(iwdev, stag);
> =20
>  free_pble:
>  	if (iwpbl->pble_alloc.level !=3D PBLE_LEVEL_0 && iwpbl->pbl_allocated)
>  		irdma_free_pble(iwdev->rf->pble_rsrc, &iwpbl->pble_alloc);

[Severity: High]
If irdma_hwreg_mr() fails during memory registration, the free_pble error
path frees the PBLE allocator resources but does not clear
iwpbl->pbl_allocated.

When this occurs during MR reregistration in irdma_rereg_mr_trans(), the
error propagates up to the RDMA core, which retains the original MR.

Upon subsequent destruction of the MR in irdma_dereg_mr(), the driver
checks this stale flag:

	if (iwpbl->pbl_allocated)
		irdma_free_pble(iwdev->rf->pble_rsrc, &iwpbl->pble_alloc);

Could this double free corrupt the driver's internal memory management data
structures (irdma_prm_return_pbles), leading to kernel memory corruption?

> =20
>  	return err;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014162144.4053=
279-1-jmoroni@google.com?part=3D1
