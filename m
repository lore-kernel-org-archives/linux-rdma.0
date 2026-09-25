Received: from mta0.migadu.com (out-136.mta0.migadu.com [91.218.175.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE7D21ADC7
	for <linux-rdma@vger.kernel.org>; Fri, 25 Sep 2026 17:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790357020; cv=none; b=G267GUbzU7fR+d5/7sWYLbWfr+mbPYNp8Bh6NQUAjcmQIH72VM+ZjUFTV42dnwptcIT2DgC2x+t2LYuYK1ee/SqaacS6HlrcvbWyODdanaH4JpORgs9q8bQY1V++6kIQjYxxYqd2VWVLbTQhKzf+ZB3dN61HFajpJL0vsJRSwes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790357020; c=relaxed/simple;
	bh=DvSwOBl9rUyzYoOiKT7csDZEmRx0NRvkRpouyG/+Nls=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JyCHnl2UVsdXUJHwpFNmyTAlmAWJuoKU54eXAhPDMl3lOKp/7WHCe8TGSvWM8RyKj6/AHF5k+ibw+NsZHAH40r0djjDc6c8TPux4Kb264zJU2sazQ35UABWXESaWb45RG99o13W5/ZJAaLhmMf2K1Fhcf735zanRgFx/6uIKCmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qZphp/U9; arc=none smtp.client-ip=91.218.175.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qZphp/U9"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=DvSwOBl9rUyzYoOiKT7csDZEmRx0NRvkRpouyG/+Nls=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790357013; v=1; x=1790961813;
 b=qZphp/U90RWXxwBnmGxUu4gPvi5hpmySTpuEDCo2yak+Ti6QUd2oHCHliTkqAf6hDXqE+hUO
 Ekvu50oim6jqSkajSU/bp09IWdu8PjlOg5p/WZouhrcD72xSBi8L9pydlGlj04vnfR8oENPl4Lv
 mFADjxMhsTpWcGBGyb0elEBM=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9d1b89c9f59fa43c;
	Fri, 25 Sep 2026 17:23:33 +0000
X-Mizu-Trace-ID: 9d1b89c9f59fa43c
X-Migadu-Flow: FLOW_OUT
Message-ID: <a1ef2c45-431f-4dad-b812-0b6cccf9ecc5@linux.dev>
Date: Fri, 25 Sep 2026 10:23:28 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/rxe: Validate inline data range in user WQEs
To: Jiale Yao <yaojiale02@163.com>
Cc: linux-rdma@vger.kernel.org
References: <20260924100515.502912-1-yaojiale02@163.com>
 <20260924101736.9FA281F000FF@smtp.kernel.org>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260924101736.9FA281F000FF@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2026/9/24 3:17, sashiko-bot@kernel.org 写道:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Critical] RDMA/rxe: TOCTOU bypass of inline WQE validation
> --
> 
> commit e272f5be8d762ea2e78301c1339c440a19e1130b
> Author: Jiale Yao <yaojiale02@163.com>
> 
> RDMA/rxe: Validate inline data range in user WQEs
> 
> This commit adds bounds validation for the inline data range in user WQEs to
> prevent kernel memory disclosure or vmalloc out-of-bounds accesses. It checks
> the offset and length against the per-WQE inline area to ensure they fit.
> 
> Link: https://lore.kernel.org/all/20260708224534.1206-1-security@auditcode.ai/
> 
>> diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
>> index 53f7c1e7fe55b..06b7669d7f737 100644
>> --- a/drivers/infiniband/sw/rxe/rxe_req.c
>> +++ b/drivers/infiniband/sw/rxe/rxe_req.c
>> @@ -716,6 +716,15 @@ int rxe_requester(struct rxe_qp *qp)
>>   		goto err;
>>   	}
>>   
>> +	if (unlikely((wqe->wr.send_flags & IB_SEND_INLINE) &&
>> +		     (wqe->dma.sge_offset > qp->sq.max_inline ||
>> +		      wqe->dma.resid >
>> +		      qp->sq.max_inline - wqe->dma.sge_offset))) {
> 
> [Severity: Critical]
> Since wqe points directly to a memory-mapped ring buffer shared with
> userspace, can this validation be bypassed via a TOCTOU race?
> 
> A malicious userspace program could provide a valid sge_offset here to
> pass the bounds check, but then concurrently modify wqe->dma.sge_offset
> in shared memory to an out-of-bounds value.
> 
> When finish_packet() executes later on:
> 
> finish_packet() {
>      ...
>      u8 *tmp = &wqe->dma.inline_data[wqe->dma.sge_offset];
>      ...
> }
> 
> Could it re-fetch the modified, now out-of-bounds sge_offset directly
> from shared memory, resulting in the same kernel memory disclosure or
> vmalloc out-of-bounds access this patch intends to fix?

Hi, Jiale

Please fix the problem that Sashiko mentioned. Then send out a new commit.

Thanks a lot.
Yanjun Zhu

> 
>> +		rxe_dbg_qp(qp, "invalid inline data range in send wqe\n");
>> +		wqe->status = IB_WC_LOC_QP_OP_ERR;
>> +		goto err;
>> +	}
>> +
>>   	if (rxe_wqe_is_fenced(qp, wqe)) {
>>   		qp->req.wait_fence = 1;
>>   		goto exit;
> 

