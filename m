Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453A53D171B
	for <linux-rdma@vger.kernel.org>; Thu,  1 Oct 2026 16:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790870485; cv=none; b=cIzjZGZd/zjomjUBm+z/MERWdW5CWYDOZao9QSgGsrOqFIeRJn5vSW6B/6ulovm1Hp1IdasNcNieCYSJkFQV6xyCkdx04rNywnvdtG88pnzO9opKAzrlcQH090/E5N6cozMa5gXksB1be6MeHnzXlQNYG3RH2Wv320Wbx+sJoZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790870485; c=relaxed/simple;
	bh=6HEr9KRL0zXySaxz8N322/untwMxJ8GcBgIq4KeMoE8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=moC/Am6sne63FPPTetxyDIjVL1pZ66xj/44XUzg53BRWzMck3t0RCLKL58N4ndlPY7b4sViW0+ACOBfk4DJwtTZpyej2JHjghC8UEPoSIFO1YdCCR1U4wcpOILAzKhRJUPcHvCQ1JBs1rjbLgBVMqqEdAxJcmElsdPBG7UzeM+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RWvBZ1eS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RWvBZ1eS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19CAE1F000FF;
	Thu,  1 Oct 2026 16:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790870482;
	bh=1ng8UWwyuTrFTqvJX9+JJwjeYA8PRB0156Ix8lF8+os=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RWvBZ1eSV2ZSonQ8ugU+no6Mc8OhImG49ibq5+fXjDDkBkEwceO/O0hscDC4MxPGC
	 n3ImZZobvPS3obk5srYePMbKFj37lbl/Dd3TKTkfw27/Ch9LLOQUG0fuBOZprMrVyn
	 3+e6qYhxQ8Rh+J2GEWiK1esyvTQvCaaQUTGOO13WP9wsKteyLpPJkFqa+drQIvEqkI
	 4+OS4y/YIaZv9Alambzbw9kRxRetNLJBHaxCJZl895xAdFMAWeRIR8FyBUNbGCip7l
	 YSFr4+Ed5NpnM948umWp2gIMJXlJn9aV3hnoZxUBTsqPCSzevh8N0IuA6hhCMusgyC
	 AEYcPX58ZrssA==
Date: Thu, 1 Oct 2026 19:01:19 +0300
From: Leon Romanovsky <leon@kernel.org>
To: AYS <ays511.kr@gmail.com>
Cc: zyjzyj2000@gmail.com, linux-rdma@vger.kernel.org, security@kernel.org
Subject: Re: [PATCH] RDMA/rxe: bound the ODP page index against the umem in
 rxe_check_pagefault()
Message-ID: <20261001160119.GQ3401365@unreal>
References: <CAPAqSgYP5tNonJb4VRLBt_34R8rcdc-gTB_jjmT221FqW18hmQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPAqSgYP5tNonJb4VRLBt_34R8rcdc-gTB_jjmT221FqW18hmQ@mail.gmail.com>

On Thu, Oct 01, 2026 at 12:15:18AM +0900, AYS wrote:
> An ODP MR's page array map.pfn_list[] is sized from the umem's start, but
> rxe_check_pagefault() indexes it with an iova taken relative to that start
> while the access was range-checked against the MR's iova (ibmr.iova). reg_mr
> only requires start and hca_va to share a page offset, so a user can register
> with hca_va = start + N*PAGE, and the index skew (hca_va - start) >>
> PAGE_SHIFT then lands out of bounds of pfn_list[], which is read with no bound
> check. An unprivileged local user reaches this with a single RDMA operation on
> a self-connected rxe QP: observed as a KASAN slab-out-of-bounds read and, when
> the out-of-bounds qword looks like a writable HMM pfn, a write into an
> attacker-influenced page.
> 
> Reject an index that leaves the umem and force the fault path, which fails the
> out-of-range access via the umem range check in
> ib_umem_odp_map_dma_and_lock(). The downstream pfn_list[] users
> (__rxe_odp_mr_copy() and the atomic helpers) run only after a successful map,
> so this check protects them as well.
> 
> Fixes: 2fae67ab63db ("RDMA/rxe: Add support for Send/Recv/Write/Read with ODP")
> Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>
> ---
> Notes (not part of the commit):
> Reproduced on a KASAN x86-64 build of 7.3-rc4 as uid 1000; the data-only write
> primitive was used to reach uid 0 on a fully hardened build.
> drivers/infiniband/sw/rxe/ is unchanged between 7.3-rc4 (93f51579e7df) and
> mainline 551c722f4080 (2026-09-29) and rdma for-next, so both are affected.
> Compile-tested (KASAN+RDMA_RXE), not runtime-tested. Found through AI-assisted
> review; per Documentation/process/security-bugs.rst this is public and a
> reproducer can be shared on request. A maintainer may prefer to also index
> relative to ibmr.iova (as the non-ODP rxe_mr_iova_to_index() does) so
> legitimately skewed MRs keep working; this patch takes the minimal, safe route.
> 
>  drivers/infiniband/sw/rxe/rxe_odp.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c
> b/drivers/infiniband/sw/rxe/rxe_odp.c
> index ab21b620e94c..07a30c60fc62 100644
> --- a/drivers/infiniband/sw/rxe/rxe_odp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_odp.c
> @@ -136,6 +136,11 @@ static inline bool rxe_check_pagefault(struct
> ib_umem_odp *umem_odp, u64 iova,
>   while (addr < iova + length) {
>   idx = (addr - ib_umem_start(umem_odp)) >> umem_odp->page_shift;
> 
> + if (idx >= ib_umem_odp_num_pages(umem_odp)) {
> + need_fault = true;
> + break;
> + }
> +
>   if ((umem_odp->map.pfn_list[idx] & access) != access) {
>   need_fault = true;
>   break;

Please stop sending emails about RXE to security@ ML and use proper
email client to communicate with ML.

Thanks

> --
> 2.43.0
> 
