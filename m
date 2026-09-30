Received: from mta1.formilux.org (mta1.formilux.org [51.159.59.229])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660A73CB56A
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 19:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.59.229
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795873; cv=none; b=R+l9ZcSrMLpGjIh9IKhMdiTWUHS8T+QLDP1RzTSmCLH+2Bvv9BC6f2Y0hSAbRK92SvyyUhQxP9zNsqph53gju2QZOE7MMdDtEbRlbhCQ3IY4zG+tqgtSINQoL7HyZANAza1LYTyYUlESk1IItX28efUrpPz5+tKCNz1XXd3gEUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795873; c=relaxed/simple;
	bh=FMuQ0g7/AttK6Ca6UA+tIjQy3zRntSydOUNgbeRhcHs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ghBFwINNdbPXBpTDNDDOEHYOodVFsySWkqdydo7VpE3EoSOTFmTIL9lV7yKxDtDrCA0N1pFezC1TWCR8D3Q20PITUWPaLh+NzJPnFUBrpTJa/kB2/JutBE0IJI6P4UNytS3OO0kK8/X+EN3bsaDaOISB1Fddvt5lohOqIAMuy58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=1wt.eu; spf=pass smtp.mailfrom=1wt.eu; dkim=pass (1024-bit key) header.d=1wt.eu header.i=@1wt.eu header.b=Ad26QGeu; arc=none smtp.client-ip=51.159.59.229
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=1wt.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=1wt.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=1wt.eu header.i=@1wt.eu header.b="Ad26QGeu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1wt.eu; s=mail;
	t=1790795862; bh=n9Pnc66qJpVgqe2kAd9Hwcaw3TKDga97O08OqQ13P0w=;
	h=From:Message-ID:From;
	b=Ad26QGeu8i/62dlEhMO3UE7+h2V06SWbHKha6Jfe8Z+QLZ5OwvH00uHg97y+1aKuZ
	 /ESZM72pcihIbC2iA036mVjA5DOm5Ybs1M3iFcjowM3uuQBp4Q7vs7dhv7I44TyxJU
	 u8gbnogGpGtLQ5reOauuh1dKtMAaw/P3qAw/CH64=
Received: from 1wt.eu (ded1.1wt.eu [163.172.96.212])
	by mta1.formilux.org (Postfix) with ESMTP id 07001C08D3;
	Wed, 30 Sep 2026 21:17:42 +0200 (CEST)
Date: Wed, 30 Sep 2026 21:17:41 +0200
From: Willy Tarreau <w@1wt.eu>
To: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: AYS <ays511.kr@gmail.com>, zyjzyj2000@gmail.com,
        linux-rdma@vger.kernel.org, security@kernel.org
Subject: Re: Subject: [PATCH] RDMA/rxe: bound the ODP page index against the
 umem in rxe_check_pagefault()
Message-ID: <ar1gVXr1ZXb52_uI@1wt.eu>
References: <CAPAqSgazQv2g+2CqefTrAnL-FLeN3w2g2JbPA-V5XfjSzrGxRw@mail.gmail.com>
 <81f485db-bd4a-4508-8e1a-0c97ffd418a6@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <81f485db-bd4a-4508-8e1a-0c97ffd418a6@linux.dev>

On Wed, Sep 30, 2026 at 09:52:30AM -0700, Zhu Yanjun wrote:
> 
> ? 2026/9/30 7:01, AYS ??:
> > An ODP MR's page array map.pfn_list[] is sized from the umem's start, but
> > rxe_check_pagefault() indexes it with an iova taken relative to that start
> > while the access was range-checked against the MR's iova (ibmr.iova).
> > reg_mr
> > only requires start and hca_va to share a page offset, so a user can
> > register
> > with hca_va = start + N*PAGE, and the index skew (hca_va - start) >>
> > PAGE_SHIFT then lands out of bounds of pfn_list[], which is read with no
> > bound
> > check. An unprivileged local user reaches this with a single RDMA
> > operation on
> > a self-connected rxe QP: observed as a KASAN slab-out-of-bounds read
> > and, when
> > the out-of-bounds qword looks like a writable HMM pfn, a write into an
> > attacker-influenced page.
> > 
> > Reject an index that leaves the umem and force the fault path, which
> > fails the
> > out-of-range access via the umem range check in
> > ib_umem_odp_map_dma_and_lock(). The downstream pfn_list[] users
> > (__rxe_odp_mr_copy() and the atomic helpers) run only after a successful
> > map,
> > so this check protects them as well.
> > 
> > Fixes: 2fae67ab63db ("RDMA/rxe: Add support for Send/Recv/Write/Read
> > with ODP")
> > Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>
> > ---
> > Notes (not part of the commit):
> > Reproduced on a KASAN x86-64 build of 7.3-rc4 as uid 1000; the data-only
> > write
> > primitive was used to reach uid 0 on a fully hardened build.
> > drivers/infiniband/sw/rxe/ is unchanged between 7.3-rc4 (93f51579e7df) and
> > mainline 551c722f4080 (2026-09-29) and rdma for-next, so both are
> > affected.
> > Compile-tested (KASAN+RDMA_RXE), not runtime-tested. Found through
> > AI-assisted
> > review; per Documentation/process/security-bugs.rst this is public and a
> > reproducer can be shared on request. A maintainer may prefer to also index
> > relative to ibmr.iova (as the non-ODP rxe_mr_iova_to_index() does) so
> > legitimately skewed MRs keep working; this patch takes the minimal, safe
> > route.
> > 
> >  drivers/infiniband/sw/rxe/rxe_odp.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c
> > b/drivers/infiniband/sw/rxe/rxe_odp.c
> > index ab21b620e94c..07a30c60fc62 100644
> > --- a/drivers/infiniband/sw/rxe/rxe_odp.c
> > +++ b/drivers/infiniband/sw/rxe/rxe_odp.c
> > @@ -136,6 +136,11 @@ static inline bool rxe_check_pagefault(struct
> > ib_umem_odp *umem_odp, u64 iova,
> >   while (addr < iova + length) {
> >   idx = (addr - ib_umem_start(umem_odp)) >> umem_odp->page_shift;
> > 
> > + if (idx >= ib_umem_odp_num_pages(umem_odp)) {
> > + need_fault = true;
> > + break;
> > + }
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/coding-style.rst?h=v7.3-rc5
> 
> Please follow coding-style.rst to rewrite the above code snippet, then
> resend this commit.

I think it's not a coding style issue but an email encoding issue. Please
refer to Documentation/process/email-clients.rst to figure how to fix the
mailer's setup.

Willy
