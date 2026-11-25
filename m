Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795609820;
	b=vZwKBDlRxNSay0MkBI2fhEGQeJiWaiIXgw+ysg3ntq0ahwAgRKMT2oRTwEp7S6ybP4Zk
	 ZdJ4ZQpQQp7Broc55S4SPntGwb5Xoe/fkExZ89HHppg41jA+X5xjydtLZMMd+c3gcw1tc
	 S4pm53sXZnLab0lK+KAgPFngtDrnpmoJrIoX9ZRy6r9MkjLaVNkF6TnN5mu1eUbcJ5pJo
	 scTsmU+f4Yr/0QuRGGboH8MywLwJjyazHjLMvv/OO2JOT1C8sPiWCnJIBpT9BkuHOhNps
	 fu6OUcbXq4GS4jcoQGf3JIEaMjJx7kduN6xZDQueleRh80HU0OHByNv6vJPWDslrNAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795609820;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=wBlqBzFHzganMG7CKEDL3xTHXHdaV7tzUIeO4cXhCZM=;
	b=GGz5EqFuy3kckQg2dPZht3dW8v/2Xo+IeCS8h/CzEwThq1QAWRQ3hox6Of3pjLu83o36
	 LzcfNrnwFvzgf5rjBHBnMllQMMCe2nmBv0joCG6y3UFqMbYDDGDkAbOG18jimCXA2W24H
	 IiH7aeQJG+MzohcbU2ejDCyfeB/VKnF4O9XAgvF7JRi1Qtb1rqTzLThb5km9sRfZn/VwC
	 QJ3ts7OGQowko/paZ86d6qiPSMQEMwKvytcSgPi/7GKn91p1SfSPu45uGP/yjBjBawreh
	 pkjrg8tUDVSCRlpuyep7f2fVPh2z3jPsCVsvq6rVRtompasClv7U1KePqAxjs0NHwBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YinD38xM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7026F606A323;
	Wed, 25 Nov 2026 12:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YinD38xM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107EF1F000CF;
	Wed, 25 Nov 2026 12:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795609819;
	bh=wBlqBzFHzganMG7CKEDL3xTHXHdaV7tzUIeO4cXhCZM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YinD38xMnf1TSY0thnBj8LiLos8K5YnUlxUam4OfIltHUNUSDq7HGoV2iT1X+LLrS
	 k1pvK4b9eq5urkifF7kzeLq2vV7QRpl5MaCZwuE2aK+N32qzc/1SnypqePcuugg+Mf
	 pjTpiQhlMJTEBMWZafe2dAdNapi4IYIhoUglu/al6OqMdXqCe1ffZTRhvxdfIEq9ZU
	 ScnOBp6D26MFRaHh2wVqksXA/EHPp6Hk9nR/ktYeZ8+0ZnNGPsNVqt7+IryrPSM8JP
	 piShzWUwPgIidEIC/ySZySk6i0Wy37/PhJ1b1daUXFhJqxFQgmPPNwHyoXlKpMLEbe
	 rSOLNA5JMpuKg==
Date: Wed, 25 Nov 2026 14:30:15 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Cygnus Qiu <eritque-arcus@ikuyo.dev>
Cc: zyjzyj2000@gmail.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2] RDMA/rxe: reject ODP accesses that wrap the iova space
Message-ID: <20261125123015.GZ14811@unreal>
References: <20261121215426.50988-1-eritque-arcus@ikuyo.dev>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261121215426.50988-1-eritque-arcus@ikuyo.dev>

On Sat, Nov 21, 2026 at 04:54:26PM -0500, Cygnus Qiu wrote:
> rxe_check_pagefault() decides whether an ODP access needs a page fault
> by walking its pages, and bounds the page index against the umem inside
> that walk. When iova + length wraps past 2^64 the loop does not run, so
> neither that bound nor the HMM_PFN_VALID and HMM_PFN_WRITE checks apply,
> and no fault is taken. __rxe_odp_mr_copy() and the atomic write and
> flush helpers then index map.pfn_list[] with (iova - ib_umem_start()) >>
> page_shift, which the registrant controls: ib_uverbs_reg_mr() only
> requires the MR's iova to share the page offset of the user address. The
> entry read past pfn_list[] goes to hmm_pfn_to_page(), and that page is
> copied to or from the peer.
> 
> rxe_check_pagefault() also keeps the index in an int, so an index of
> 2^32 or more can be truncated to a value that passes the bound, while
> the flush and atomic write helpers use the full unsigned long.
> 
> Reject a wrapping range in rxe_odp_map_range_and_lock(), before the
> fault path, whose umem range check wraps the same way, and keep the
> index in an unsigned long.
> 
> Found with afb-afl, an LLM-driven kernel audit/repro pipeline; the fix
> and this changelog were also drafted with LLM assistance. Reproduced on
> an unmodified KASAN build of mainline by an unprivileged user with a
> self-connected rxe QP. An RDMA READ at the end of a two-page ODP MR
> whose iova range ends at 2^64:
> 
>   BUG: KASAN: slab-out-of-bounds in rxe_odp_mr_copy+0x35f/0x410
>   Read of size 8 at addr ffff8881037a2210 by task kworker/u16:0/13
>   The buggy address is located 0 bytes to the right of
>    allocated 16-byte region [ffff8881037a2200, ffff8881037a2210)
>   Oops: general protection fault, maybe for address 0xffff888103d0c04a: 0000 [#1] SMP KASAN NOPTI
>   RIP: 0010:memcpy+0xc/0x30

Always provide full dmesg stack trace in the commit message.

> 
> An ATOMIC WRITE to an MR whose iova is 2^44 above the umem start:
> 
>   BUG: unable to handle page fault for address: ffffed11202b3194
>   RIP: 0010:rxe_odp_do_atomic_write+0x131/0x2f0
> 
> With this patch both are NAKed with no report, and an in-range READ and
> ATOMIC WRITE return the same results as before. The wrap was not tried
> on the flush path. The rdma-core v65.0 tests, ODP included, pass on rxe
> with and without this patch.
> 
> Fixes: 2fae67ab63db ("RDMA/rxe: Add support for Send/Recv/Write/Read with ODP")
> Cc: stable@vger.kernel.org # 6.15.x: 7797bbb0e86f: RDMA/rxe: bound the ODP page index against the umem in rxe_check_pagefault()
> Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
> Signed-off-by: Cygnus Qiu <eritque-arcus@ikuyo.dev>
> ---
> Changes in v2:
> - Use check_add_overflow() for the wrap check, as Zhu Yanjun suggested.
>   The tests above were re-run on v2 with the same results.
> - The author name changed since v1; the address is the same.
> - v1: https://lore.kernel.org/r/20261120060000.302440-1-eritque-arcus@ikuyo.dev
> 
> Tested on mainline 4405c18c95d2 (v7.4-rc3+) in QEMU. Applies to
> rdma.git for-rc and for-next.
> 
> This completes commit 7797bbb0e86f, whose bound sits in the loop that
> a wrapping range skips; stable trees need that commit first.
> 
> Without KASAN, an RDMA READ or WRITE at the end of the range reads or
> overwrites a physical page the registrant chooses. On a lab kernel with
> CONFIG_RANDOMIZE_BASE=n this was taken from an unprivileged user to
> uid 0; with KASLR the chain also needs an address leak. The rxe link
> has to be created by an administrator; the trigger needs only the
> uverbs device. A reproducer and the test logs are available on request.
> 
>  drivers/infiniband/sw/rxe/rxe_odp.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c b/drivers/infiniband/sw/rxe/rxe_odp.c
> index 9d27244f89bc..f28b5008aae4 100644
> --- a/drivers/infiniband/sw/rxe/rxe_odp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_odp.c
> @@ -125,7 +125,7 @@ static inline bool rxe_check_pagefault(struct ib_umem_odp *umem_odp, u64 iova,
>  	bool need_fault = false;
>  	u64 access = HMM_PFN_VALID;
>  	u64 addr;
> -	int idx;
> +	unsigned long idx;
>  
>  	if (write)
>  		access |= HMM_PFN_WRITE;
> @@ -167,10 +167,14 @@ static int rxe_odp_map_range_and_lock(struct rxe_mr *mr, u64 iova, int length, u
>  	bool write = !(flags & RXE_PAGEFAULT_RDONLY);
>  	bool need_fault;
>  	int err;
> +	u64 end;
>  
>  	if (unlikely(length < 1))
>  		return -EINVAL;
>  
> +	if (check_add_overflow(iova, (u64)length, &end))

The right fix is to make sure that length is right type from the
beginning and not this mix of unsigned int, int, size_t and u64.

In addition I would expect that this check will be much earlier in the
call chain.

Thanks

> +		return -EFAULT;
> +
>  	mutex_lock(&umem_odp->umem_mutex);
>  
>  	need_fault = rxe_check_pagefault(umem_odp, iova, length, write);
> -- 
> 2.56.1
> 
