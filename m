Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.193
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795296433;
	b=N3QDg3Wrv8t6YNH5aRm2pp6QFGwMQY8FOK9HB8g24h/tt+XN0TNo1qHAJ6hc/6Sat84A
	 fOjf7zB5uI2Kf66S/AxOQzGKgVerl+FZEKu6wKMx2RAPfgBTUn6ZYfK4cMFPRpIYs+oBx
	 VkyLQWvVPEx8H7vEBN9lnXoS6ZQjPvJWiQrPJI3YVTWYGAAxx3eaGYeAvs5MavBICDi8n
	 FugQEv0Nj08mtlv+lSIIZBcqaITjNZ+Obh3SHgZNqPaMsr6XnBzpy9lsLa4z/0DFmAQe4
	 yHJ5LnziBt45zNmNcBp1OiGjdVr1rgKzltGOG52C+VnU4aVZ6hqmM+Kv1/36cAqfqlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795296433;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=wTQhRjOCjFPLMuMZMUIfh4QWuDPBy9MWRjMzD2TViXQ=;
	b=IjQgvRI+/fbiEOp2kV+w/s388CimDQnjSwxzWb2w7Oy13XncEx9I1KGGumapxD6oa/YG
	 B+KryWQ/5kp4x6Fg35bXZ92MYlTpb0jHytUCZSL5Jq/NrY7frVyh2xBJkJwjvTHOv5h9C
	 2yY+pMTrcMmzuS/aOL82Vhc8W+hHzRKeFH3T7y5yhsqakz0rcpFnUPR35LliNRYSFjWq0
	 ZxesY882+gBc/rk4DgELrlDH4qJf+x59ub6Tu+B5EIjjpodH/PM8rFvbXvD0nLDyfv1Ma
	 fCtHz4i3TKgnkxsZ6zwJjkSBvyBAJr48ScklFKS0YWBEFHD278uO94OK5nYxY3pZ/5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=mHTXDwTh;
	arc=none smtp.remote-ip=91.218.175.193
Received: from mta0.migadu.com (out-193.mta0.migadu.com [91.218.175.193])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F2C606A335
	for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 21:27:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98F2C606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=mHTXDwTh
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=3x2ckrVI3z3NW2CiWPXuClHX9YfabFhGAYUL/kc5S9Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795296428; v=1; x=1795901228;
 b=mHTXDwThfaWQ+Y/UjT8R4P7zqZZZ1HKtPhsuUa+YaNy+gLwv92kzqaTjRAKvANRRQL+32twq
 LXAUw9Gt4DkL9gdt3JQ3A0Qn78eUE+iSMcEAxc6kxksVMI6w2/OYQ/U5pHv/auN3FV8pT4LA9YP
 Nz9m0us4b/fpy2BpSN4eLR/g=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 79f3b7fd43fc4ced;
	Sat, 21 Nov 2026 21:27:08 +0000
X-Mizu-Trace-ID: 79f3b7fd43fc4ced
X-Migadu-Flow: FLOW_OUT
Message-ID: <6462f655-303b-4df1-9ef0-b82bc482b55f@linux.dev>
Date: Sat, 21 Nov 2026 13:27:01 -0800
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/rxe: reject ODP accesses that wrap the iova space
To: Yiran Qiu <eritque-arcus@ikuyo.dev>, zyjzyj2000@gmail.com, jgg@ziepe.ca,
 leon@kernel.org, "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261120060000.302440-1-eritque-arcus@ikuyo.dev>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20261120060000.302440-1-eritque-arcus@ikuyo.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2026/11/19 22:00, Yiran Qiu 写道:
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
>    BUG: KASAN: slab-out-of-bounds in rxe_odp_mr_copy+0x35f/0x410
>    Read of size 8 at addr ffff8881037a2210 by task kworker/u16:0/13
>    The buggy address is located 0 bytes to the right of
>     allocated 16-byte region [ffff8881037a2200, ffff8881037a2210)
>    Oops: general protection fault, maybe for address 0xffff888103d0c04a: 0000 [#1] SMP KASAN NOPTI
>    RIP: 0010:memcpy+0xc/0x30
>
> An ATOMIC WRITE to an MR whose iova is 2^44 above the umem start:
>
>    BUG: unable to handle page fault for address: ffffed11202b3194
>    RIP: 0010:rxe_odp_do_atomic_write+0x131/0x2f0
>
> With this patch both are NAKed with no report, and an in-range READ and
> ATOMIC WRITE return the same results as before. The wrap was not tried
> on the flush path. The rdma-core v65.0 tests, ODP included, pass on rxe
> with and without this patch.
>
> Fixes: 2fae67ab63db ("RDMA/rxe: Add support for Send/Recv/Write/Read with ODP")
> Cc: stable@vger.kernel.org # 6.15.x: 7797bbb0e86f: RDMA/rxe: bound the ODP page index against the umem in rxe_check_pagefault()
> Signed-off-by: Yiran Qiu <eritque-arcus@ikuyo.dev>
> ---
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
>   drivers/infiniband/sw/rxe/rxe_odp.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c b/drivers/infiniband/sw/rxe/rxe_odp.c
> index 9d27244f89bc..2ab64f128e57 100644
> --- a/drivers/infiniband/sw/rxe/rxe_odp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_odp.c
> @@ -125,7 +125,7 @@ static inline bool rxe_check_pagefault(struct ib_umem_odp *umem_odp, u64 iova,
>   	bool need_fault = false;
>   	u64 access = HMM_PFN_VALID;
>   	u64 addr;
> -	int idx;
> +	unsigned long idx;
>   
>   	if (write)
>   		access |= HMM_PFN_WRITE;
> @@ -171,6 +171,9 @@ static int rxe_odp_map_range_and_lock(struct rxe_mr *mr, u64 iova, int length, u
>   	if (unlikely(length < 1))
>   		return -EINVAL;
>   
> +	if (unlikely(iova + length < iova))
> +		return -EFAULT;

Using the followings instead of the above.

"

u64 end;

if (check_add_overflow(iova, (u64)length, &end))

     return -EFAULT;

"

makes the 64-bit wrap-around check explicit and avoids ambiguity from 
implicit integer promotions.

Except that, I am fine with this commit.

Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>

Zhu Yanjun

> +
>   	mutex_lock(&umem_odp->umem_mutex);
>   
>   	need_fault = rxe_check_pagefault(umem_odp, iova, length, write);

-- 
Best Regards,
Yanjun.Zhu

