Received: from mta1.migadu.com (out-3.mta1.migadu.com [95.215.58.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547093C9EE4
	for <linux-rdma@vger.kernel.org>; Thu,  1 Oct 2026 16:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790873062; cv=none; b=lG+n2TpQWqLdf/+6AtvV4vkmTWvUVi+2ierwUap4pKOPVEqDlbzETuwK0DnVUPAuyW7rTtkt6fBxN/LnTau8hxnc/CoTkEVPBQZUcJlCvOmPKFKBN0htWNICrUWawHid0lRXyfkOpQmmko1w4X71q3ugjlh4xevuq0punXOB2PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790873062; c=relaxed/simple;
	bh=T4wjYouYqNhpf0olLiIFhMQzwgd7885PhfzdcX4Lgw4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=irR2oC8ttW8AyZGeYtGmKVuxCe/dXYKZHw5n1DdpXlXYQkckVDQcoMk256nNqlf9w4xMW8FoElqekksg98dLuBS1LTn4DO/U8lwNM1l+lZapoQb5mpHYDQjM9HxMl2zBE8ooxPub87cBbwy6eFgU1pMq+fwhbMCrMXrTvOQj8Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=a+uvoSTP; arc=none smtp.client-ip=95.215.58.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="a+uvoSTP"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=T4wjYouYqNhpf0olLiIFhMQzwgd7885PhfzdcX4Lgw4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790873057; v=1; x=1791477857;
 b=a+uvoSTPADoNrKpDndDz8RKM5dt9xpk/quQHEzA5JKrior+nH5hU9kSYzmg6KCkj0ZaGEyAp
 nCjBMUTwJH1GgrXaBAkj6bj/jygM8mVOTcqXJpHUZRBymayiNkX3Kvz36/zFhY6Nxe6cdftM7Xn
 wHEt1MUW2IkQHJdZFNZWyiJ4=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 70ba9d7c9878f394;
	Thu, 01 Oct 2026 16:44:15 +0000
X-Mizu-Trace-ID: 70ba9d7c9878f394
X-Migadu-Flow: FLOW_OUT
Message-ID: <6b905836-2cf1-4687-b4a8-b065a09b30db@linux.dev>
Date: Thu, 1 Oct 2026 09:44:10 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/rxe: validate cur_sge on the receive path before
 indexing dma->sge[]
To: Greg KH <gregkh@linuxfoundation.org>, AYS <ays511.kr@gmail.com>
Cc: zyjzyj2000@gmail.com, linux-rdma@vger.kernel.org, security@kernel.org
References: <CAPAqSgbjxGEJ5PketUCyUNu8Zcs5yrbSjSD7NVgPpJ3GGQWRsA@mail.gmail.com>
 <2026093031-deferral-excitable-9009@gregkh>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <2026093031-deferral-excitable-9009@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2026/9/30 8:34, Greg KH 写道:
> On Thu, Oct 01, 2026 at 12:15:52AM +0900, AYS wrote:
>> A user QP's receive queue is an mmap'd ring: the user provider writes the
>> WQEs and post_recv does not touch them, so every field of struct
>> rxe_recv_wqe is attacker controlled. When the responder takes a WQE it
>> validates only dma.num_sge (rxe_get_recv_wqe()/get_srq_wqe()); dma.cur_sge,
>> dma.sge_offset and dma.resid are copied into qp->resp.srq_wqe unchecked.
>>
>> copy_data() then uses cur_sge as an index immediately --
>> struct rxe_sge *sge = &dma->sge[dma->cur_sge];
>> -- and dereferences it (sge->length) before the in-loop
>> "dma->cur_sge >= dma->num_sge" test, which only runs after the first sge++.
>> cur_sge is a u32, so this reads far out of bounds of the RXE_MAX_SGE-entry
>> dma->sge[] embedded in the kmalloc-2k struct rxe_qp: an information leak (the
>> out-of-bounds sge->length is recoverable through the work-completion status)
>> and a DoS. The send queue already got this check in commit 126c757e4cd4; the
>> receive path did not.
>>
>> Reject an out-of-range cur_sge in copy_data() before the first sge
>> dereference. This also covers the send retry path and is harmless to the
>> kernel ULP path, which always sets cur_sge = 0.
>>
>> Fixes: 8700e3e7c485 ("Soft RoCE driver")
>> Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>
> 
> Does not match the "From:" line :(
> 
> No cc: stable?
> 
> No Assisted-by: line?

In v2, this Assisted-by tag has been added.

Yanjun Zhu>
> thanks,
> 
> greg k-h

