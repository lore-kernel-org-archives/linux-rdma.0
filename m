Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91CB423A80
	for <linux-rdma@vger.kernel.org>; Thu,  3 Sep 2026 12:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788439137; cv=none; b=oAxSmA1fUmKRgIkwshw6bIoJoP7/bxwiwt3SZVmruuQZnBUv3eDY+PsQp4jHa+iS/NxKGRqNFYoO9EVknUfst2Mr05uXEQ1DmkcLoYjXzZQJJMX+9ZQsO730BtJxVI5iLPJKARjPY9wVybkLVARfw80ZnVoU0Up6Buf51guJE1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788439137; c=relaxed/simple;
	bh=QWYwWiahmym+4yuhASgmzFu87Kfq/qqPK98+6Ag4LRc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GxhJvtkHtcJo9tg/ZvcOzD9Vb9x+5YsJFtR7WyHVMVrvWgaV8NbfZjvnscrtywiZPUhjMFjO2MJzs9fi1q1aWXYnJo0BHmlHyUEtzQAwffZ76rF6B/rK5ptrO3mbz4vAiTaePlePsOMBGPeGxkFKhD1N123P2NryNhbG5ZaojDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=PSAClVZs; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="PSAClVZs"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788439130; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ddaJmXGpsOWiRELEAdp/woW0PSrTqi209z/sPgpvlxs=;
	b=PSAClVZs0pK74qz6kSbsq4ne/muuHRmO/R+owY0btxk+gcx3XSRssBnZQiJUQJnkRrkwXcsS/zd/vXVhJPezzyBcSLMZQepM7PuZ4VEIdFBpXKG/bVO6ri8i9Rjin27/YX9pT9i5n05SMP4P8j8ESQAJEMyexKesre/YVkuZTcA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0XAG3W6R_1788439129;
Received: from 30.221.104.67(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0XAG3W6R_1788439129 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 03 Sep 2026 20:38:50 +0800
Message-ID: <07bb48b7-5a44-51d1-0b55-d9960f63aab2@linux.alibaba.com>
Date: Thu, 3 Sep 2026 20:38:49 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH for-next v2 1/4] RDMA/erdma: Support non-contiguous kernel
 QP buffers
Content-Language: en-US
To: Leon Romanovsky <leon@kernel.org>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, KaiShen@linux.alibaba.com
References: <20260827082523.36294-1-chengyou@linux.alibaba.com>
 <20260827082523.36294-2-chengyou@linux.alibaba.com>
 <20260903091033.GY24140@unreal>
From: Cheng Xu <chengyou@linux.alibaba.com>
In-Reply-To: <20260903091033.GY24140@unreal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 9/3/26 5:10 PM, Leon Romanovsky wrote:
> On Thu, Aug 27, 2026 at 04:25:20PM +0800, Cheng Xu wrote:
>> A single coherent allocation for kernel QP queues can fail for large
>> queues when memory is fragmented.
>>
>> Allocate page-sized coherent buffers and describe them with the existing
>> MTT. Keep the userspace QP path unchanged.
>>
>> Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
>> ---
>>  drivers/infiniband/hw/erdma/erdma_cq.c    |   4 +-
>>  drivers/infiniband/hw/erdma/erdma_qp.c    |  38 +++--
>>  drivers/infiniband/hw/erdma/erdma_verbs.c | 195 +++++++++++++---------
>>  drivers/infiniband/hw/erdma/erdma_verbs.h |  44 ++++-
>>  4 files changed, 179 insertions(+), 102 deletions(-)
> 
> <...>
> 
>> +static void erdma_free_kmem(struct erdma_dev *dev, struct erdma_mem *mem)
>> +{
>> +	struct erdma_buf_list *buf_list;
>> +	u32 i;
>> +
>> +	if (!mem->kmem)
>> +		return;
> 
> Can it be null?

Yes. With the current init_kernel_qp() implementation, failures go
through the common free_kernel_qp() path instead of unwinding each
completed allocation in reverse order. As a result, erdma_free_kmem()
may be called more than once for partially initialized memory, and
mem->kmem can be NULL.

This is not ideal. I will add a separate preparatory patch to implement
explicit error unwinding in init_kernel_qp().

> 
>> +
>> +	buf_list = mem->kmem->buf_list;
>> +	if (buf_list) {
> 
> Write the unwinding section of erdma_alloc_kmem() to don't call to
> erdma_free_kmem().

Agreed. Patch #3 already refactors erdma_alloc_kmem() to unwind its
allocations explicitly instead of calling erdma_free_kmem(). However,
each intermediate patch should have correct error handling, so I will
move the change into this patch.

> 
>> +		for (i = 0; i < mem->page_cnt; i++)
>> +			if (buf_list[i].buf)
>> +				dma_free_coherent(&dev->pdev->dev, PAGE_SIZE,
>> +						  buf_list[i].buf,
>> +						  buf_list[i].dma_addr);
>> +		kfree(buf_list);
>> +	}
>> +
>> +	kfree(mem->kmem);
>> +	mem->kmem = NULL;
>> +}
>> +
>> +static int erdma_alloc_kmem(struct erdma_dev *dev, struct erdma_mem *mem,
>> +			    size_t size)
>> +{
>> +	struct erdma_buf_list *buf_list;
>> +	u32 i;
>> +
>> +	mem->type = ERDMA_KMEM;
>> +	mem->page_size = PAGE_SIZE;
>> +	mem->page_offset = 0;
>> +	mem->page_cnt = DIV_ROUND_UP(size, PAGE_SIZE);
>> +	mem->mtt_nents = mem->page_cnt;
>> +	mem->len = size;
>> +
>> +	mem->kmem = kzalloc_obj(*mem->kmem);
>> +	if (!mem->kmem)
>> +		goto err_free_mem;
> 
> There is no point to call to erdma_free_kmem() here and you can return
> immediately.
> 

Right. No kmem resource has been allocated at this point, so it should
return -ENOMEM directly. This is already handled in patch #3, and I
will move the change into this patch.

>> +
>> +	buf_list = kcalloc(mem->page_cnt, sizeof(*buf_list), GFP_KERNEL);
>> +	if (!buf_list)
>> +		goto err_free_mem;
> 
> Please write error unwinding explicitly.

Likewise. The explicit error-unwinding paths are already introduced in
patch #3. I will move them into this patch.


> 
>> +	mem->kmem->buf_list = buf_list;
>> +
>> +	for (i = 0; i < mem->page_cnt; i++) {
>> +		buf_list[i].buf = dma_alloc_coherent(&dev->pdev->dev, PAGE_SIZE,
>> +						     &buf_list[i].dma_addr,
>> +						     GFP_KERNEL);
>> +		if (!buf_list[i].buf)
>> +			goto err_free_mem;
>> +	}
>> +
>> +	mem->mtt = erdma_create_mtt(dev, MTT_SIZE(mem->page_cnt), true);
>> +	if (IS_ERR(mem->mtt)) {
>> +		mem->mtt = NULL;
> 
> Why? You will release mem anyway.
> 

This was needed because the current code lacks explicit error
unwinding. The common cleanup path only checks mem->mtt for NULL and
would otherwise pass the ERR_PTR to erdma_destroy_mtt().

This has the same root cause as the first issue, and I will fix it in
this patch as part of the same error-unwinding change.


>> +		goto err_free_mem;
>> +	}
>> +	for (i = 0; i < mem->page_cnt; i++)
>> +		mem->mtt->buf[i] = buf_list[i].dma_addr;
>> +
>> +	return 0;
>> +
>> +err_free_mem:
>> +	erdma_free_kmem(dev, mem);
>> +	return -ENOMEM;
>> +}
>> +
> 
> <...>
> 
>> +struct erdma_buf_list {
>> +	void *buf;
>> +	dma_addr_t dma_addr;
>> +};
> 
> This struct is very similar to scatter-gather list, why don't you use it
> directly?

Good idea. I will use struct scatterlist in the next revision.

Thanks,
Cheng Xu

> 
> Thanks
