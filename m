Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA838156F45;
	Sun,  6 Sep 2026 09:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788685315; cv=none; b=ltjYhjUFD3ZBORh4sjXwoXG/t+5c8v0MOBdtmO8YvPjhjVdEw49bNtLOxuC7QEuO2T/4Y1Ou8oAV6dokd6IBABcwBUjyMXGxed1A+414Qg+LVj16H+sH97MWPForrzggzNyQ4XhhcFXDGUunrNP4vfEwWyYaoBLPWXslIrq6pmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788685315; c=relaxed/simple;
	bh=ADtRkJFIXKF4ZfDEdehj+/8daSdtcnZO+TkzylPKLsE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pV8peDjQxBdXNQKnrgXM3IbdDSY8ZsNs/9dFr7un85sEFhdCyVzzvqNEGmndSWo81e/BpEda8jRC51RfYQEpMzFs5KsylfhQbWqzcT3gOYK44te2ABth2wMs5AinuoqldRvjRaUBYyvlZmeCDMC6OqJBa37mqcpsbGAxvtlUlaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZHlzRQ5f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZHlzRQ5f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7486C1F00A3A;
	Sun,  6 Sep 2026 09:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788685314;
	bh=ljtxyM91lO3GnxZDSs6ub63lKW8FDslzfQ0eWlzCKtk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZHlzRQ5fysNOWAqtmb0WUQwOMalzLeWpbB3D7dX1fKSkqyeOcA4+W0ccGP9JCieb4
	 1hCIgK2/pOk8R2PW+Ky9cPmzihLvo9N+q4jE/w7H11K7vUFSI2c0uZNkFbjWVhPL7J
	 KNA4cnDjfyTuAj9dxsCz6E8tfz0Idj0DZK+o8UfEuSdttcSvQbJ7Lsy7JLm4eG13rt
	 5G86KCApm3JwMmxXBRkhkX+i8PsPQ+v78TdPAXBI67IFs8cNZDIyA87e3NqVsDkNuT
	 pVyOxre2qExawgxVKV+PygmEEsW9+zV9JfZkb9cZjgNOdmONboll2QFoed8/a2r5GA
	 vrKdNHEI1+vmw==
Date: Sun, 6 Sep 2026 12:01:49 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Norbert Szetei <norbert@doyensec.com>
Cc: linux-rdma@vger.kernel.org, Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/rxe: Reject prefetch of a non-ODP MR
Message-ID: <20260906090149.GB13683@unreal>
References: <521D5E74-89E3-43C0-81C7-AC0BE52591E7@doyensec.com>
 <20260901075611.GG24140@unreal>
 <874DA83D-C81E-4858-B9E7-D2A3BFE0137D@doyensec.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874DA83D-C81E-4858-B9E7-D2A3BFE0137D@doyensec.com>

On Fri, Sep 04, 2026 at 09:49:26AM +0200, Norbert Szetei wrote:
> On Sep 1, 2026, at 09:56, Leon Romanovsky <leon@kernel.org> wrote:
> > 
> > On Thu, Aug 27, 2026 at 12:51:20PM +0200, Norbert Szetei wrote:
> >> rxe_ib_advise_mr_prefetch() and rxe_ib_prefetch_sg_list() look up the MR
> >> by lkey and hand it to rxe_odp_do_pagefault_and_lock() without checking
> >> that it is an ODP MR. That path runs to_ib_umem_odp() on mr->umem, and
> >> for a non-ODP MR mr->umem is a plain struct ib_umem from ib_umem_get(),
> >> so the container_of() in to_ib_umem_odp() lands past the end of the
> >> object and ib_umem_odp_map_dma_and_lock() reads its ib_umem_odp fields
> >> out of bounds.
> >> 
> >> lookup_mr() validates the lkey, PD, access and state but not the MR
> >> type, and IB_UVERBS_ADVISE_MR_ADVICE_PREFETCH is accepted for any MR.
> >> 
> >>  BUG: KASAN: slab-out-of-bounds in ib_umem_odp_map_dma_and_lock+0x884/0x8a0
> >>  Read of size 8 at addr ffff88810a3ebcf0 by task advi/921
> >>   ib_umem_odp_map_dma_and_lock+0x884/0x8a0
> >>   rxe_ib_advise_mr+0x543/0xad0
> >>   ib_uverbs_handler_UVERBS_METHOD_ADVISE_MR+0x446/0x530
> >>   ib_uverbs_cmd_verbs+0x2b3c/0x3b20
> >>   ib_uverbs_ioctl+0x1e3/0x310
> >>  Allocated by task 921:
> >>   __ib_umem_get_va+0x13e/0xae0
> >>   rxe_mr_init_user+0x2ae/0xb00
> >>   rxe_reg_user_mr+0x337/0x510
> >>  The buggy address belongs to the object at ffff88810a3ebc80
> >>   which belongs to the cache kmalloc-96 of size 96
> >> 
> >> Reject a non-ODP MR after lookup_mr() in both the synchronous and
> >> asynchronous prefetch arms.
> >> 
> >> Fixes: 3576b0df1588 ("RDMA/rxe: Implement synchronous prefetch for ODP MRs")
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Norbert Szetei <norbert@doyensec.com>
> >> ---
> >> drivers/infiniband/sw/rxe/rxe_odp.c | 11 +++++++++++
> >> 1 file changed, 11 insertions(+)
> >> 
> >> diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c b/drivers/infiniband/sw/rxe/rxe_odp.c
> >> index e870efa7a0a3..5c9dde3501a0 100644
> >> --- a/drivers/infiniband/sw/rxe/rxe_odp.c
> >> +++ b/drivers/infiniband/sw/rxe/rxe_odp.c
> >> @@ -472,6 +472,11 @@ static int rxe_ib_prefetch_sg_list(struct ib_pd *ibpd,
> >> return -EINVAL;
> >> }
> >> 
> >> + if (unlikely(!is_odp_mr(mr))) {
> >> + rxe_put(mr);
> >> + return -EOPNOTSUPP;
> >> + }
> > 
> > The idea is correct, but the implementation needs some improvement.
> > 
> > RXE stores the access flags in the MR, including IB_ACCESS_ON_DEMAND,
> > which indicates that the MR was created as an ODP MR. lookup_mr()
> > should check this flag and perform the lookup accordingly.
> 
> Do you mean lookup_mr() should take IB_ACCESS_ON_DEMAND into account, so that
> the existing (access & mr->access) != access test rejects the non-ODP MR?

I expected lookup_mr(..., IB_ACCESS_ON_DEMAND) to be called and to
perform all the necessary checks internally.

> 
> rxe_rereg_user_mr() with IB_MR_REREG_ACCESS assigns mr->access directly, and
> IB_ACCESS_ON_DEMAND is part of RXE_ACCESS_SUPPORTED_MR. So userspace can set
> that flag on a plain MR after registration, without the umem changing. Am I
> missing something there?

I assume this is a bug that needs to be fixed.

Thanks

> 
> Thanks.
> 
> > 
> > Thanks.
> 
> 
