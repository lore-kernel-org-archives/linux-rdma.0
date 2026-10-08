Received: from mta1.migadu.com (out-140.mta1.migadu.com [95.215.58.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2FD36E48C
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 19:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791488098; cv=none; b=eAg1eE2xCck6MVpyYwpdiVewmGghQaIijU21Bu5SrLrlngdp0EkCGBD0fIiyee8dcjLb6ulRkGTzjVPciRffBKcT1rW8BYbkPJkqKpJwlNYTMHs2BwEeKZhD+8cnSK2frFD9dql44S+tMuOFN/X0CamwA88MyhWZvv7NYGXKnF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791488098; c=relaxed/simple;
	bh=ZLu1/9Vl0Eujq1tNoIQ2+huha25E71FuirvOXYa78/o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=avfp2arQXFgPhkylxF1tBHNcPb97IbFd8s1B5/IEiPMcrmuvSQxvN3PnW1vZr+9j0hCPtQcDJ3A99YO9NftCFU9H1OpaAyhn3ci1sDzCqNQpQv9H9JDYRJVXBCQtb1Dn4UgxqVF/wIFNHG8e6wTK2u1GdunCz0QLVkFbd8u0KLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PRs9AwZD; arc=none smtp.client-ip=95.215.58.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PRs9AwZD"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ZLu1/9Vl0Eujq1tNoIQ2+huha25E71FuirvOXYa78/o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791488093; v=1; x=1792092893;
 b=PRs9AwZDaf83lojRrIfcbUbZ/wBJPbsjCp8Ob4jwpPPgQdP+bJk3sQd5QDr9RaT1+b2ryEDK
 H8V8Pc7Yzhjrrdf7uA0nsvqgDTFTs5XAF5JVdpW/RtWyqqy/A0slmZ9dqHhNoRPR8ObExSnn/uf
 aqOSECDZBawLaH6RBOqJ58dk=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 70c35ff2cd21d911;
	Thu, 08 Oct 2026 19:34:53 +0000
X-Mizu-Trace-ID: 70c35ff2cd21d911
X-Migadu-Flow: FLOW_OUT
Message-ID: <2d95155a-3701-4090-80d1-45e63e7471fa@linux.dev>
Date: Thu, 8 Oct 2026 12:34:49 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/2] RDMA/rxe: fix TOCTOU races in send WQE processing
To: Tristan Madani <tristmd@gmail.com>, yanjun.zhu@linux.dev
Cc: linux-rdma@vger.kernel.org, jgg@ziepe.ca, leon@kernel.org,
 zyjzyj2000@gmail.com, tristan@talencesecurity.com
References: <20261007223222.2342804-1-tristmd@gmail.com>
 <714b1a9e-560d-4fbb-9dfa-6f1fee5cb13f@linux.dev>
 <179146091623.3840242.8978910812704841884@gmail.com>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <179146091623.3840242.8978910812704841884@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2026/10/8 5:01, Tristan Madani 写道:
> Hi Yanjun,
>
> Thanks for flagging the Sashiko review. I went through all 8 findings
> across both patches.
>
> One was a genuine issue: the memcpy size used qp->sq.max_sge * sizeof(sge),
> which truncates when max_inline_data is not a multiple of sizeof(struct
> ib_sge). For example, if a QP is created with max_inline_data=20, the
> integer division gives max_sge=1, and only 16 bytes of the flex array are
> copied instead of 20. v5 fixes this by using qp->sq.max_inline directly,
> which is the exact data portion size stored at QP creation.
>
> The remaining 7 seem to be false positives:
>
>    - FORTIFY_SOURCE (raised on both patches): struct rxe_send_wqe ends
>      with struct rxe_dma_info which contains __DECLARE_FLEX_ARRAY, so
>      __builtin_object_size returns (size_t)-1. The merged receive-path
>      fix (d6ab440240a04) uses the same pattern without issues.
>
>    - Inline data / sge_offset / resid / cur_sge validation: these fields
>      were already unvalidated against max_inline before this series. The
>      requester path bounds-checks num_sge and cur_sge (lines 754-760 in
>      rxe_req.c); adding resid/sge_offset validation is a valid hardening
>      improvement, but it is a pre-existing gap, not introduced here.
>
>    - wr_opcode_mask() OOB via untrusted opcode: the call existed at the
>      same location before this series. We did not add it.
>
>    - DMA state writeback for RDMA READ retry: on retry, the requester
>      changes the WQE state via smp_store_release(). The completer's
>      smp_load_acquire() detects the change, bypasses the reuse path, and
>      takes a fresh copy from shared memory with the original DMA offsets.
>
>    - ERR flush path barriers: when send_wqe_valid is false, writes go
>      directly to shared memory, which is identical to the pre-patch
>      behavior.
>
>    - Shared pointer for wqe_state_posted: posted WQEs cause the
>      completer to return COMPST_DONE/COMPST_EXIT without processing.
>
> v5 is already sent with the max_inline fix:
>    https://lore.kernel.org/linux-rdma/20261008093740.3034881-1-tristmd@gmail.com/

Thanks a lot. I checked the V5 patchset, and Sashiko is still 
complaining about quite a few things. I’m not sure whether the latest 
complaints from Sashiko are different from the previous ones or if they 
are essentially the same issues.

BTW, the V5 patchset is not a standalone patchset. Maybe there is 
something wrong with the way the patchset was sent out.

The following steps can be used to generate and send the latest patchset 
as a standalone patchset:

1. git format-patch -2 -n -s -o ./tmp --cover-letter -v 6
This command generates the patchset, including the cover letter, in the 
`./tmp` directory.

2. git send-email --to linux-rdma@vger.kernel.org --to xxx --to xxx ... 
./tmp/*
This command sends all the patches in ./tmp/ as a standalone patchset.

Thanks,

Yanjun Zhu

>
> Best,
> Tristan

-- 
Best Regards,
Yanjun.Zhu

