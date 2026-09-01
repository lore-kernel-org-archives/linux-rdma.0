Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C594846D2CC;
	Tue,  1 Sep 2026 07:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788249378; cv=none; b=ey7zp+0n5s3D/fxvn5urXAz9d4UXXwVpsXwvDp959j0F/7L1Wdpbmb4rKQjfnPwHxKG2vFkZFmAE95AimJagSFTxiZj8xIlXcTW+BQPYFumEK+iDSLeErZ/CCdI19bRYrJocUlPSSlcSyEUyb8nStg06jmx1xPF7rK8nrEmrhJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788249378; c=relaxed/simple;
	bh=Smbof6t1OVUJnV0l7nT7KJo3L9p6mP4e6d0Jw/6h9qY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NdRPBcGBC1QnL/vuj7i726EzYbVATr5AOeGc8Y6CZ63LLFK33ZBED8MK+jOROGsfVndXKy4MlkcxMAye914hirWog31JCyY21j25C+FFKm2OdNI4IV0FCl6uSaWCo9c79jJOZA8nNje75W3/L18tRO3v/vH+ss4J08zwPpVqUGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TesDdUdg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TesDdUdg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF101F000E9;
	Tue,  1 Sep 2026 07:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788249375;
	bh=UrpsoI54tXKC9pjJXe8kVMxKXtKgOaLNbfSmxu8kiPc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TesDdUdgG/1oq4xIXlT2ElZAJQA4wdSyrBurFgD2V1GX1iWgNWcm9zwbCkhgK9QBk
	 o8kc62X+TIY4zN9fJc53LNXLBSfxDY227NE/qOGM86VsObv7xq63FKQefmTE4fKMdg
	 UWiKxkSjKzhLuf9tK0BaGi/HgGwOhW7E/88a4i+Gn7MX9LDGgUtOe0241K/TkEYmJi
	 0DoN060DNtfaBaWWeTO7aioktcVZhoPBYG/QvMbeW4MLnF4EP0nGiwSvxcENMPehsn
	 Li58S8i2yPUMXXrgroq1dk6WCvVB4uNhvo/Ee0uptH6sHgfUVzoC0lY96SynuznJic
	 N3bJ+Wa7W5fkw==
Date: Tue, 1 Sep 2026 10:56:11 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Norbert Szetei <norbert@doyensec.com>
Cc: linux-rdma@vger.kernel.org, Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/rxe: Reject prefetch of a non-ODP MR
Message-ID: <20260901075611.GG24140@unreal>
References: <521D5E74-89E3-43C0-81C7-AC0BE52591E7@doyensec.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521D5E74-89E3-43C0-81C7-AC0BE52591E7@doyensec.com>

On Thu, Aug 27, 2026 at 12:51:20PM +0200, Norbert Szetei wrote:
> rxe_ib_advise_mr_prefetch() and rxe_ib_prefetch_sg_list() look up the MR
> by lkey and hand it to rxe_odp_do_pagefault_and_lock() without checking
> that it is an ODP MR. That path runs to_ib_umem_odp() on mr->umem, and
> for a non-ODP MR mr->umem is a plain struct ib_umem from ib_umem_get(),
> so the container_of() in to_ib_umem_odp() lands past the end of the
> object and ib_umem_odp_map_dma_and_lock() reads its ib_umem_odp fields
> out of bounds.
> 
> lookup_mr() validates the lkey, PD, access and state but not the MR
> type, and IB_UVERBS_ADVISE_MR_ADVICE_PREFETCH is accepted for any MR.
> 
>   BUG: KASAN: slab-out-of-bounds in ib_umem_odp_map_dma_and_lock+0x884/0x8a0
>   Read of size 8 at addr ffff88810a3ebcf0 by task advi/921
>    ib_umem_odp_map_dma_and_lock+0x884/0x8a0
>    rxe_ib_advise_mr+0x543/0xad0
>    ib_uverbs_handler_UVERBS_METHOD_ADVISE_MR+0x446/0x530
>    ib_uverbs_cmd_verbs+0x2b3c/0x3b20
>    ib_uverbs_ioctl+0x1e3/0x310
>   Allocated by task 921:
>    __ib_umem_get_va+0x13e/0xae0
>    rxe_mr_init_user+0x2ae/0xb00
>    rxe_reg_user_mr+0x337/0x510
>   The buggy address belongs to the object at ffff88810a3ebc80
>    which belongs to the cache kmalloc-96 of size 96
> 
> Reject a non-ODP MR after lookup_mr() in both the synchronous and
> asynchronous prefetch arms.
> 
> Fixes: 3576b0df1588 ("RDMA/rxe: Implement synchronous prefetch for ODP MRs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Norbert Szetei <norbert@doyensec.com>
> ---
>  drivers/infiniband/sw/rxe/rxe_odp.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c b/drivers/infiniband/sw/rxe/rxe_odp.c
> index e870efa7a0a3..5c9dde3501a0 100644
> --- a/drivers/infiniband/sw/rxe/rxe_odp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_odp.c
> @@ -472,6 +472,11 @@ static int rxe_ib_prefetch_sg_list(struct ib_pd *ibpd,
>  			return -EINVAL;
>  		}
>  
> +		if (unlikely(!is_odp_mr(mr))) {
> +			rxe_put(mr);
> +			return -EOPNOTSUPP;
> +		}

The idea is correct, but the implementation needs some improvement.

RXE stores the access flags in the MR, including IB_ACCESS_ON_DEMAND,
which indicates that the MR was created as an ODP MR. lookup_mr()
should check this flag and perform the lookup accordingly.

Thanks.
