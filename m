Received: from mta1.migadu.com (out-47.mta1.migadu.com [95.215.58.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F0F3B71D2
	for <linux-rdma@vger.kernel.org>; Sun,  4 Oct 2026 03:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791085235; cv=none; b=N/XxaxDnpXMVWp2yKutYKDUyP9zV+7YCNdRTeV9egJwWVcW3fQ1pNKmdWwFyId5qujXn6woWuaA1ST2P0doJQZuLtxlQ2vZ8S4uY5LEk5Gox235foNV6GPGjG5LbjV3DmS8EyA5S27NFiOnbKKNWAK5wgpma3rluYMaOeD89o80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791085235; c=relaxed/simple;
	bh=9XI5oDKfgqwxPiZc+WN9nk/j6NwKcZCb46UrAnueEDE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qwEs26wc8lcnjgZzq+hd5V5++LFOoQHDjEu/8+GG6OzoEgP66ojuym47R4wZvlVk+BSz7FoUbo4GiwRQZauWEzt4gRuHnMnJrkUOyzTKDPiUSBBW2oWDs3/KVk83XQ78JpC8yGX7Pf23lbLzKAfxTF3oIFff9qUmYZjid9Upc4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=s3UPkK+p; arc=none smtp.client-ip=95.215.58.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="s3UPkK+p"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=9XI5oDKfgqwxPiZc+WN9nk/j6NwKcZCb46UrAnueEDE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791085231; v=1; x=1791690031;
 b=s3UPkK+psTqIpxbM9LiEl0BqIrolx2jeGtKMyuRXRZPI/CeDK6qvkqJNbOPhWP18wY3oRhE3
 NgLbm32AeDrlfBOr32cKSmvTGMJzVZwqVgfMOL5ed4W4ytTWeii0V12yhdfTw0PoQcpCNyyhaoN
 EfKT5BfhYnHR+o+7nHdDE31k=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 46b24044bb44b2d8;
	Sun, 04 Oct 2026 03:40:27 +0000
X-Mizu-Trace-ID: 46b24044bb44b2d8
X-Migadu-Flow: FLOW_OUT
Message-ID: <b0308d5c-19d6-4ae6-849f-d6b9f5f6b0a9@linux.dev>
Date: Sat, 3 Oct 2026 20:40:24 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] RDMA/rxe: bound the WQE opcode before indexing
 rxe_wr_opcode_info[]
To: Youngsung Ahn <ays511.kr@gmail.com>, Leon Romanovsky <leon@kernel.org>,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: linux-rdma@vger.kernel.org
References: <20261002164552.294749-1-ays511.kr@gmail.com>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20261002164552.294749-1-ays511.kr@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2026/10/2 9:45, Youngsung Ahn 写道:
> wr_opcode_mask() indexes the global rxe_wr_opcode_info[] array with
> a caller-supplied opcode and no bounds check. For a user QP the WQE
> comes from an mmap'd SQ ring, so wqe->wr.opcode is an
> attacker-controlled __u32 read back by the requester
> (req_next_wqe() -> rxe_requester()); rxe_post_send() takes the
> qp->is_user branch and never runs validate_send_wr(), whose only
> opcode check is itself !wr_opcode_mask() (it indexes before it
> checks). rxe_wr_opcode_info[] has entries only up to IB_WR_REG_MR,
> so an out-of-range opcode reads out of bounds and the result is used
> as a mask and dereferenced; observed as a KASAN global-out-of-bounds
> "Read of size 4" and a wild-pointer oops.
>
> Return a zero mask for an out-of-range opcode, matching how
> validate_send_wr() already treats a zero mask (an invalid WR), so no
> path indexes the array out of bounds.
>
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>

I checked this code snippet. The wr_opcode_mask() function is called in 
three places,

and this change does not introduce any problems in those call sites.

The logs also indicate that this change fixes the reported problem.

Reviewed-by: Zhu Yanjun yanjun.zhu@linux.dev

Zhu Yanjun

> Assisted-by: LLM
> ---
> Notes (not part of the commit):
> v3: no code change. Sent as a standalone message rather than as a reply to
> the v2 posting, and dropped the Cc: stable@vger.kernel.org trailer, both
> as asked on-list.
>
> On the question about req_retry(): req_retry() does not reject the WQE
> itself, it only re-posts it. A zero mask makes every "mask & WR_*" test
> there false, so an out-of-range opcode yields iova = 0, the dma cursor
> reset, and neither retry_first_write_send() nor the read fix-up; the WQE
> is left in wqe_state_posted. Once the requester dispatches it, wqe->mask
> stays 0 so WR_LOCAL_OP_MASK is not taken, and next_opcode() matches no
> case for an out-of-range wqe->wr.opcode and returns -EINVAL, so
> rxe_requester() sets wqe->status = IB_WC_LOC_QP_OP_ERR and takes the err
> path, which moves the QP to IB_QPS_ERR and lets the completer post the
> completion.
>
> wr_opcode_mask() is the single choke point all three callers
> (validate_send_wr(), req_next_wqe(), req_retry()) funnel through, and only
> validate_send_wr() rejects the WQE on a zero mask. In req_retry()
> wr_opcode_mask() is called at the top of the loop body, before the
> wqe_state_posted / wqe_state_done checks, so the out-of-bounds read
> happens even for WQEs the loop then skips.
>
> ARRAY_SIZE() is not usable here: rxe_opcode.h only declares "extern
> struct rxe_wr_opcode_info rxe_wr_opcode_info[]". IB_WR_REG_MR (32) is the
> highest index initialised in rxe_opcode.c, and on x86-64 the object is
> 1320 bytes with a 40-byte stride, i.e. 33 elements, so valid indices are
> 0..32.
>
> The bug was reproduced on an unpatched KASAN x86-64 build of 7.3-rc4, with
> the reproducer run as uid 1000 (the splat itself is attributed to the
> rxe_wq kworker, since that is where the WQE is consumed): KASAN
> global-out-of-bounds read of size 4 at rxe_wr_opcode_info, and an Oops or
> GPF for larger opcodes. Present unchanged in mainline 551c722f4080
> (2026-09-29). This patch itself is only compile-tested (KASAN +
> CONFIG_RDMA_RXE). I am posting the reproducer on-list in reply to the v2
> discussion of this patch.
>
>   drivers/infiniband/sw/rxe/rxe_loc.h | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
> index 64d636bf80fd..dcc0788db90a 100644
> --- a/drivers/infiniband/sw/rxe/rxe_loc.h
> +++ b/drivers/infiniband/sw/rxe/rxe_loc.h
> @@ -184,6 +184,9 @@ void rxe_comp_queue_pkt(struct rxe_qp *qp, struct sk_buff *skb);
>   
>   static inline unsigned int wr_opcode_mask(int opcode, struct rxe_qp *qp)
>   {
> +	if (unlikely(opcode < 0 || opcode > IB_WR_REG_MR))
> +		return 0;
> +
>   	return rxe_wr_opcode_info[opcode].mask[qp->ibqp.qp_type];
>   }
>   

-- 
Best Regards,
Yanjun.Zhu

