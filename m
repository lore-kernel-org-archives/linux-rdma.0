Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263E02F5A36
	for <linux-rdma@vger.kernel.org>; Sun, 26 Jul 2026 08:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785054065; cv=none; b=YtQFvwfANlxKh3xiY/sYO/ZGibpy4HP2PbeWtu9xrA756byHTc5jkkvaDR+KpD/PJhN7J+XjU+I/alrS4HUscbSnB6SYf+u/knzSmAML67xgwTZhe/tJ5CIyB/TMMzgPtSMF6bZ1S9Gg05H6ao7KCQTqDEd5vV8XVXByQr2YQJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785054065; c=relaxed/simple;
	bh=PzHeivD2sC1VFqy3J2Q+sTUx0CWK5c0cCEYfBkNq0ao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZbUrkUxbcU6NRaHzttjMhMNrBpCG/5KB8f8vwMuPXhTVc9JHWbhKlOx4kdkg3zTLbPA+5/BL2YWx0EbaA2Nm56P65m1yU1n5V1YA+8ZMoCn3drDxwfpk6UXWMx/97qh6KIcnYqo7LotIaRZclCyyefwRtt9Dbfm3c+GuYgtsQyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l8sfhBDm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l8sfhBDm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1868D1F000E9;
	Sun, 26 Jul 2026 08:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785054063;
	bh=M6BO2QZSCWrnl2GoRvVetlK3hpQp+X4j8k8QWw9tn6Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=l8sfhBDmg0xUukevM8mmybTMlP0n5yL4hDs37FH1dVV3tr5MOQXIW/l8BZyzCNGQE
	 PSC4pdDOyVkp3hqz95TLP/SJ+YjP3jZ0bIsel46q7RvzM08OXbUiWOPesrA9e2ehfa
	 j3IgvFSC/JrqrgeL42FEADzq+4GVvj/f2uS5mvcO+i46PtNoVcrcA9sf6fUKrrk4En
	 ZCdvgc2kgK3EdOGwu7lU3OaZdlKuVU6+c0c6mu8ncnN73ygMHNq+TiWJV9us0czrLu
	 cl2ci5wnfnB/w1o8g6nVuFUA59dAC9pKfDyRdJvcHTktCWErGdEula5vA09MRdri5u
	 zCip3FhtticXA==
Date: Sun, 26 Jul 2026 11:20:58 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: Weiming Shi <bestswngs@gmail.com>, security@kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>, Zhu Yanjun <zyjzyj2000@gmail.com>,
	Qiang Hong <wanbafv@gmail.com>, Xinyu Ma <mmmxny@gmail.com>,
	Shaomin Chen <eeesssooo020@gmail.com>,
	Rui Ding <threonine42@gmail.com>, Miao Zhao <muel@nova.gal>,
	RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH] RDMA/rxe: Restore HMM_PFN_WRITE check in ODP write paths
Message-ID: <20260726082058.GE12003@unreal>
References: <20260725094805.916278-1-bestswngs@gmail.com>
 <1b99ae23-a5b0-4e3b-80b5-1538d0e0a7fe@linux.dev>
 <b70a8092-60a8-46bd-8a06-82e41f59a76b@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b70a8092-60a8-46bd-8a06-82e41f59a76b@linux.dev>

On Sat, Jul 25, 2026 at 07:12:42PM -0700, Zhu Yanjun wrote:
> While exploiting this ODP flaw in soft-RoCE for privilege escalation
> in practice might require specific conditions, enforcing the HMM_PFN_WRITE
> check is undoubtedly the right choice to enforce strict access control
> and eliminate the security risk.
> 
> The special handling for pmem flush (keeping it read-only) is also a nice
> and correct touch.

Zhu, we already asked you, please reduce the amount of AI-generated
emails.

> 
> Let us wait for the feedback from Leon and Jason.

There is nothing we can do here, as it is not available in Patchwork
or lore. Please post the patch to the mailing list.

Thanks

> 
> Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
> 
> Zhu Yanjun
> 
> 在 2026/7/25 17:08, Zhu Yanjun 写道:
> > 
> > 在 2026/7/25 2:48, Weiming Shi 写道:
> > > Commit 0b261d7c1cd3 ("RDMA/rxe: Break endless pagefault loop for RO
> > > pages") dropped the access permission test from rxe_check_pagefault()
> > > and left only HMM_PFN_VALID. A page faulted in read-only, for example
> > > a page-cache folio behind a PROT_READ file mapping, then satisfies the
> > > check and ODP write operations (RDMA WRITE, RDMA READ response, SEND
> > > payload, atomics) modify it through kmap without ever breaking CoW.
> > > 
> > > An unprivileged user can register an ODP MR over such a mapping and
> > > have incoming RDMA traffic overwrite the page cache of a file it only
> > > holds O_RDONLY, including /etc/passwd or setuid binaries. This is the
> > > same primitive class as Dirty COW and CVE-2022-2590.
> > > 
> > > mlx5 has the missing invariant: its ODP path sets the device write bit
> > > only for pfns that carry HMM_PFN_WRITE. Restore it in rxe by requiring
> > > HMM_PFN_WRITE in rxe_check_pagefault() for every operation except
> > > RXE_PAGEFAULT_RDONLY. A write to a non-writable VMA now fails the one
> > > fault attempt with -EPERM from hmm_vma_fault() instead of re-faulting
> > > forever. For a writable VMA the fault breaks CoW and the write lands
> > > in the private page.
> > > 
> > > Keep pmem flushes on the read-only check. arch_wb_cache_pmem() never
> > > modifies memory, and the FLUSH access bits do not make the umem
> > > writable, so classifying flushes as writes would make every flush
> > > against a flush-only MR fail.
> > > 
> > > Fixes: 0b261d7c1cd3 ("RDMA/rxe: Break endless pagefault loop for RO
> > > pages")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> > > Reported-by: Shaomin Chen <eeesssooo020@gmail.com>
> > > Reported-by: Rui Ding <threonine42@gmail.com>
> > > Reported-by: Miao Zhao <muel@nova.gal>
> > > Tested-by: Qiang Hong <wanbafv@gmail.com>
> > > Tested-by: Xinyu Ma <mmmxny@gmail.com>
> > > ---
> > >   drivers/infiniband/sw/rxe/rxe_odp.c | 16 +++++++++++-----
> > >   1 file changed, 11 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c
> > > b/drivers/infiniband/sw/rxe/rxe_odp.c
> > > index ff904d5e54a73..174bb2efc3c6a 100644
> > > --- a/drivers/infiniband/sw/rxe/rxe_odp.c
> > > +++ b/drivers/infiniband/sw/rxe/rxe_odp.c
> > > @@ -124,19 +124,23 @@ int rxe_odp_mr_init_user(struct rxe_dev *rxe,
> > > u64 start, u64 length,
> > >   }
> > >     static inline bool rxe_check_pagefault(struct ib_umem_odp
> > > *umem_odp, u64 iova,
> > > -                       int length)
> > > +                       int length, bool write)
> > >   {
> > >       bool need_fault = false;
> > > +    u64 access = HMM_PFN_VALID;
> > >       u64 addr;
> > >       int idx;
> > >   +    if (write)
> > > +        access |= HMM_PFN_WRITE;
> > > +
> > >       addr = iova & (~(BIT(umem_odp->page_shift) - 1));
> > >         /* Skim through all pages that are to be accessed. */
> > >       while (addr < iova + length) {
> > >           idx = (addr - ib_umem_start(umem_odp)) >>
> > > umem_odp->page_shift;
> > >   -        if (!(umem_odp->map.pfn_list[idx] & HMM_PFN_VALID)) {
> > > +        if ((umem_odp->map.pfn_list[idx] & access) != access) {
> > >               need_fault = true;
> > >               break;
> > >           }
> > > @@ -159,6 +163,7 @@ static unsigned long
> > > rxe_odp_iova_to_page_offset(struct ib_umem_odp *umem_odp, u
> > >   static int rxe_odp_map_range_and_lock(struct rxe_mr *mr, u64 iova,
> > > int length, u32 flags)
> > >   {
> > >       struct ib_umem_odp *umem_odp = to_ib_umem_odp(mr->umem);
> > > +    bool write = !(flags & RXE_PAGEFAULT_RDONLY);
> > >       bool need_fault;
> > >       int err;
> > >   @@ -167,7 +172,7 @@ static int rxe_odp_map_range_and_lock(struct
> > > rxe_mr *mr, u64 iova, int length, u
> > >         mutex_lock(&umem_odp->umem_mutex);
> > >   -    need_fault = rxe_check_pagefault(umem_odp, iova, length);
> > > +    need_fault = rxe_check_pagefault(umem_odp, iova, length, write);
> > >       if (need_fault) {
> > >           mutex_unlock(&umem_odp->umem_mutex);
> > >   @@ -177,7 +182,7 @@ static int rxe_odp_map_range_and_lock(struct
> > > rxe_mr *mr, u64 iova, int length, u
> > >           if (err < 0)
> > >               return err;
> > >   -        need_fault = rxe_check_pagefault(umem_odp, iova, length);
> > > +        need_fault = rxe_check_pagefault(umem_odp, iova, length,
> > > write);
> > >           if (need_fault) {
> > >               mutex_unlock(&umem_odp->umem_mutex);
> > >               return -EFAULT;
> > > @@ -339,8 +344,9 @@ int rxe_odp_flush_pmem_iova(struct rxe_mr *mr,
> > > u64 iova,
> > >       int err;
> > >       u8 *va;
> > >   +    /* A flush never modifies memory; read-only access suffices. */
> > >       err = rxe_odp_map_range_and_lock(mr, iova, length,
> > > -                     RXE_PAGEFAULT_DEFAULT);
> > > +                     RXE_PAGEFAULT_RDONLY);
> > >       if (err)
> > >           return err;
> > 
> -- 
> Best Regards,
> Yanjun.Zhu
> 
> 
