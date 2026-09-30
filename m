Received: from mta0.migadu.com (out-53.mta0.migadu.com [91.218.175.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA7D5187DE
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 17:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788298; cv=none; b=Du1wXPtBNUZ5jrkYLgipN/MKq7iMjj6YBqAvrVa+0TFP+PYKXqtElW3HKFJ1IE3XpxrhcZgZCxzbDwWViPc8lZT5DjCyoEehaPwu5kfAwz3OqPpfGbu9IvhQT80PXx8KnNNkQ2TmoTu7sV3/q8oOs6LmCsw8qlGp/kY9GElVOC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788298; c=relaxed/simple;
	bh=q5K0AcqDLe8XTvMk7uopG7wAvJkrh1iAh9I+lmHq5L8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GjfbKee2d3LN8iOxSVw2VBQp5/rFpdQwfeO/BHhTbutFtiEQ9oZY66McbrPEkZdEHBUG6F32wRpnH3IqupQVm+feDq7HSwPw/PVvdA5nFr0BkoSVnHSi2hUuJ7gVTUz8FxdBcpl3l9Sqi3Bk/tacJuwTZiHOKwRCM1YVulnu/IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NxQriMZd; arc=none smtp.client-ip=91.218.175.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NxQriMZd"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=q5K0AcqDLe8XTvMk7uopG7wAvJkrh1iAh9I+lmHq5L8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790788293; v=1; x=1791393093;
 b=NxQriMZde1ebTf1UZvoxLY1qdzbwqrGhcBXTVjj/IoZlC/olBt/LI+V8DJY/mcfCc9OF7zr0
 o9iRz33kV0QZPvOZJ4eO27qAEYzrI5alBVbwJPhsVB7DRNd+rVDGsjw51UnchpkBX9Z3vyG15Zi
 V/76Q2oviNZbJSj8jZDbOAF0=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e8cd9d1295c459ea;
	Wed, 30 Sep 2026 17:11:33 +0000
X-Mizu-Trace-ID: e8cd9d1295c459ea
X-Migadu-Flow: FLOW_OUT
Message-ID: <bbdfe4ca-5aaf-468f-a232-b514036e6f60@linux.dev>
Date: Wed, 30 Sep 2026 10:11:30 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/rxe: bound the WQE opcode before indexing
 rxe_wr_opcode_info[]
To: AYS <ays511.kr@gmail.com>, zyjzyj2000@gmail.com
Cc: linux-rdma@vger.kernel.org, security@kernel.org
References: <CAPAqSgY_3HQwokvRpErRfZvT32CJODXSsd0=TE985exOkZ2WHA@mail.gmail.com>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <CAPAqSgY_3HQwokvRpErRfZvT32CJODXSsd0=TE985exOkZ2WHA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2026/9/30 7:31, AYS 写道:
> wr_opcode_mask() indexes the global rxe_wr_opcode_info[] array with a
> caller-supplied opcode and no bounds check. For a user QP the WQE comes from
> an mmap'd SQ ring, so wqe->wr.opcode is an attacker-controlled __u32 read back
> by the requester (req_next_wqe() -> rxe_requester()); rxe_post_send() takes
> the qp->is_user branch and never runs validate_send_wr(), whose only opcode
> check is itself !wr_opcode_mask() (it indexes before it checks).
> rxe_wr_opcode_info[] has entries only up to IB_WR_REG_MR, so an out-of-range
> opcode reads out of bounds and the result is used as a mask and dereferenced;
> observed as a KASAN global-out-of-bounds "Read of size 4" and a wild-pointer
> oops.
> 
> Return a zero mask for an out-of-range opcode, matching how validate_send_wr()
> already treats a zero mask (an invalid WR), so no path indexes the array out
> of bounds.
> 
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>
> ---
> Notes (not part of the commit):
> Reproduced on a KASAN x86-64 build of 7.3-rc4 as uid 1000. Present unchanged
> in mainline 551c722f4080 (2026-09-29) and rdma for-next. Compile-tested
> (KASAN+RDMA_RXE), not runtime-tested. Found through manual review; per
> security-bugs.rst this is public and a reproducer can be shared on request.
> IB_WR_REG_MR is the highest index the array initializes; an
> ARRAY_SIZE(rxe_wr_opcode_info) bound would be equivalent but the array is
> extern to this header.
> 
>   drivers/infiniband/sw/rxe/rxe_loc.h | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h
> b/drivers/infiniband/sw/rxe/rxe_loc.h
> index 64d636bf80fd..dcc0788db90a 100644
> --- a/drivers/infiniband/sw/rxe/rxe_loc.h
> +++ b/drivers/infiniband/sw/rxe/rxe_loc.h
> @@ -184,6 +184,9 @@ void rxe_comp_queue_pkt(struct rxe_qp *qp, struct
> sk_buff *skb);
> 
>   static inline unsigned int wr_opcode_mask(int opcode, struct rxe_qp *qp)
>   {
> + if (unlikely(opcode < 0 || opcode > IB_WR_REG_MR))
> + return 0;

Would you like to read coding-style.rst in kernel document, rewrite the 
above code snippet, then resend this commit?
Thanks a lot.

Yanjun Zhu

> +
>    return rxe_wr_opcode_info[opcode].mask[qp->ibqp.qp_type];
>   }
> 
> --
> 2.43.0

