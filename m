Received: from mta0.migadu.com (out-72.mta0.migadu.com [91.218.175.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F43E1EFFA1
	for <linux-rdma@vger.kernel.org>; Mon,  5 Oct 2026 00:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791160201; cv=none; b=n7f7qJzMjnnBcQ3fTY0s2yaKkiWTjHHaUQ9bgxdWvaro5qFSES+Fp5FfOBY25y5GXjXWKhZYMvVKCqYibCzgKzVgbL6IZbch7zwC+razv6lJgAhiKAvAxL2Zr/7+TO81FNyY23+IRlVEFfunuorGRg6P56GBoneFfoMMZviF4js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791160201; c=relaxed/simple;
	bh=B3/DFcp+SyH8b+Kah5V3t9QdusNse+6V3nxVXGVaM10=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=k5si+BvCf3id+9jTrG49weFEEhEdDBq7bxjncoBNOdi0iOm6dWkdhvxwLIJFl4yWwvhlXYUz7wqRtgLBXf0/wU/VjcFdd2FypcDJGkTao/x1MbhclTJYXnGiYaqyWwrCh/JVBEI3jIABdV14EfDIW1ecMvNp7opAT7z3zruzPAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iOV56fZH; arc=none smtp.client-ip=91.218.175.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iOV56fZH"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=B3/DFcp+SyH8b+Kah5V3t9QdusNse+6V3nxVXGVaM10=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791160196; v=1; x=1791764996;
 b=iOV56fZHygNFX4pDskHJRgtUivQns04tYHDWyziB6cERI82HfFpgpZdGyCWi1os5GX0PXhn9
 aXdxmWG9jMJ2ItbDep8o0tJRZ64R2IkTejkvdz5lNRX+7Iu7IePZf/ISqxFhI7+Pg9j0W76YEmP
 2RswZHCIxhRWpFsqBy+Tejuw=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8d3e8eaf5c7ddbfd;
	Mon, 05 Oct 2026 00:29:46 +0000
X-Mizu-Trace-ID: 8d3e8eaf5c7ddbfd
X-Migadu-Flow: FLOW_OUT
Message-ID: <009f918c-f77a-4b46-ab6d-96d81e1ed87d@linux.dev>
Date: Sun, 4 Oct 2026 17:29:42 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] RDMA/rxe: Validate inline data range in user WQEs
To: Jiale Yao <yaojiale02@163.com>, Zhu Yanjun <zyjzyj2000@gmail.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Doug Ledford <dledford@redhat.com>, Moni Shoua <monis@mellanox.com>,
 Haggai Eran <haggaie@mellanox.com>, Kamal Heib <kamalh@mellanox.com>,
 Amir Vadai <amirv@mellanox.com>, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
References: <20261004064445.1488753-1-yaojiale02@163.com>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20261004064445.1488753-1-yaojiale02@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2026/10/3 23:44, Jiale Yao 写道:
> For a user QP, the send queue is an mmap'd ring which userspace writes
> directly.  rxe_post_send() only schedules the send task for such a QP,
> so userspace can also change WQE fields while rxe_requester() processes
> the WQE.
> 
> Commit 126c757e4cd46f866ddc283143b58eb4d9bf52cd ("RDMA/rxe:
> Validate num_sge/cur_sge before indexing wqe->dma.sge[]") added bounds
> checks for two members of the userspace-controlled dma structure, but
> left sge_offset unchecked.  For an inline WQE, finish_packet() uses that
> value directly as an index into inline_data[] and copies dma.resid bytes
> from the resulting pointer into the packet payload.
> 
> A local user with access to uverbs can therefore put an out-of-range
> sge_offset in the mmap'd SQ ring.  This can disclose kernel memory in the
> outgoing packet or cause a vmalloc out-of-bounds access.
> 
> Since sge_offset comes from shared memory, validating it in
> rxe_requester() and then reading it again in finish_packet() leaves a
> TOCTOU window.  Load it exactly once with READ_ONCE() in finish_packet(),
> validate that local value, and use the same value for the copy and update.
> Check the offset first and use subtraction for the length check to avoid
> an integer overflow.
> 
> I reproduced this on Linux 7.3-rc4 with an RC user QP, IB_SEND_INLINE,
> a 64-byte residual length, and sge_offset set to 0x100000.  KASAN
> reported:
> 
>    BUG: KASAN: vmalloc-out-of-bounds in rxe_requester+0x1f27/0x4940
>    Read of size 64 at addr ffffc90000191250 by task kworker/u16:0/12
>    Workqueue: rxe_wq do_work
>    Call Trace:
>     __asan_memcpy
>     rxe_requester+0x1f27/0x4940
>     rxe_sender+0xe/0x30
>     do_work+0x184/0x3d0
>     process_scheduled_works+0x7c0/0xf10

Conceptually, wqe->dma.sge_offset is runtime state that should be 
exclusively managed by the kernel, but mapping the SQ into user space 
via mmap exposes it to untrusted asynchronous writes.

Beyond finish_packet(), every reader of sge_offset across the driver 
(such as in rxe_sge.c and rxe_resp.c) must treat it as untrusted input.

We should audit all access points to ensure they consistently use a 
READ_ONCE() local snapshot followed by underflow-safe bounds checks. 
Longer term, moving kernel-managed progress state into kernel-private 
memory would eliminate this attack surface entirely.

Yanjun Zhu

> 
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Link: https://lore.kernel.org/all/20260708224534.1206-1-security@auditcode.ai/
> Signed-off-by: Jiale Yao <yaojiale02@163.com>
> ---
> 
> Notes:
>      Changes in v3:
>      - Read sge_offset from the shared WQE with READ_ONCE(), as requested.
>      
>      Changes in v2:
>      - Copy sge_offset into a local variable in finish_packet(), validate that
>        value, and reuse it for the memcpy and update.
> 
>   drivers/infiniband/sw/rxe/rxe_req.c | 14 +++++++++++---
>   1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
> index 24f5c044363f..9be753d2e5dd 100644
> --- a/drivers/infiniband/sw/rxe/rxe_req.c
> +++ b/drivers/infiniband/sw/rxe/rxe_req.c
> @@ -503,6 +503,7 @@ static int finish_packet(struct rxe_qp *qp, struct rxe_av *av,
>   			 struct sk_buff *skb, u32 payload)
>   {
>   	int err;
> +	u32 sge_offset;
>   
>   	err = rxe_prepare(av, pkt, skb);
>   	if (err)
> @@ -510,12 +511,19 @@ static int finish_packet(struct rxe_qp *qp, struct rxe_av *av,
>   
>   	if (pkt->mask & RXE_WRITE_OR_SEND_MASK) {
>   		if (wqe->wr.send_flags & IB_SEND_INLINE) {
> -			u8 *tmp = &wqe->dma.inline_data[wqe->dma.sge_offset];
> +			sge_offset = READ_ONCE(wqe->dma.sge_offset);
> +			if (unlikely(sge_offset > qp->sq.max_inline ||
> +				     payload >
> +				     qp->sq.max_inline - sge_offset)) {
> +				rxe_dbg_qp(qp, "invalid inline data range in send wqe\n");
> +				return -EINVAL;
> +			}
>   
> -			memcpy(payload_addr(pkt), tmp, payload);
> +			memcpy(payload_addr(pkt),
> +			       &wqe->dma.inline_data[sge_offset], payload);
>   
>   			wqe->dma.resid -= payload;
> -			wqe->dma.sge_offset += payload;
> +			wqe->dma.sge_offset = sge_offset + payload;
>   		} else {
>   			err = copy_data(qp->pd, 0, &wqe->dma,
>   					payload_addr(pkt), payload,

