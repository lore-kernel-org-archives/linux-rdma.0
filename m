Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625BC49EC75
	for <linux-rdma@vger.kernel.org>; Thu,  3 Sep 2026 12:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788439208; cv=none; b=ZKB3JmBNlL4z6l0zj/jWh6P2EAHAP8Dl+Ue+65xV5CYJPbeRn2cywHVEA3139L84Vi4pobgwTVX2j3RVZJZbrVY8Htzysaj5MIjKvRG5w6l5IDgZ6gZ2jl3HCIdjjUkand44ZJtYVI0rwy/aL7cBRoQuG2l21ZYGLpCjafQqyW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788439208; c=relaxed/simple;
	bh=1DTEyZ9jiqnJzcZSAEO7di7nFVYVuemp4sLwu8rbr+E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ASNl0dqJ8bZTLsh/H/GPh20XwB4iUg8mbDjdPCf3T4U7Vb90yJBsPcoHa3hPUiLbjWp5cfNULmcDxYIQoJLCJaub5G+kwkYz0HotRNwR0bUBoWZx4hXfyMOIA5pPM0Wq/2+DK6AMFhHtrgT4KZ66fzFv3+Chh442+l9tEg+fW60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=VeagGMWz; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="VeagGMWz"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788439203; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=pBjP6MPhO15WkBxzlIFbM+8KAn6B2Tond4jVXH3je7E=;
	b=VeagGMWz0eT7x8+mHDozZfGR90UuR4RPZgMV6UHvuis2EsCaxW7bD5Z8ClWgP+5ZASCUMsGW2YFMe7x0ptnUL1bYNKq76gzi+lrv3u6S41mDeiylmUCqmUYh2hR6d6JdU0SLyOiaG/DigRWrLwDTOutEQeUDgb4zdw8y/Uv/ydA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0XAFwLNT_1788439202;
Received: from 30.221.104.67(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0XAFwLNT_1788439202 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 03 Sep 2026 20:40:03 +0800
Message-ID: <9cd75ed4-9486-3fd6-4812-2786467abd08@linux.alibaba.com>
Date: Thu, 3 Sep 2026 20:40:02 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH for-next v2 3/4] RDMA/erdma: Unify userspace and kernel
 queue buffer management
Content-Language: en-US
To: Leon Romanovsky <leon@kernel.org>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, KaiShen@linux.alibaba.com
References: <20260827082523.36294-1-chengyou@linux.alibaba.com>
 <20260827082523.36294-4-chengyou@linux.alibaba.com>
 <20260903091246.GZ24140@unreal>
From: Cheng Xu <chengyou@linux.alibaba.com>
In-Reply-To: <20260903091246.GZ24140@unreal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 9/3/26 5:12 PM, Leon Romanovsky wrote:
> On Thu, Aug 27, 2026 at 04:25:22PM +0800, Cheng Xu wrote:
>> Userspace and kernel space queue buffers use separate helpers despite
>> sharing MTT metadata and lifetime rules. Manage both through
>> erdma_mem_init() and erdma_mem_uninit(), while keeping backing allocation
>> and release type-specific.
>>
>> Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
>> ---
>>  drivers/infiniband/hw/erdma/erdma_verbs.c | 281 ++++++++++++++--------
>>  drivers/infiniband/hw/erdma/erdma_verbs.h |  17 +-
>>  2 files changed, 191 insertions(+), 107 deletions(-)
>>
>> diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.c b/drivers/infiniband/hw/erdma/erdma_verbs.c
>> index b0a47c82cbdf..aaef2b3621b0 100644
>> --- a/drivers/infiniband/hw/erdma/erdma_verbs.c
>> +++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
>> @@ -19,9 +19,9 @@
>>  #include "erdma_cm.h"
>>  #include "erdma_verbs.h"
> 
> <...>
> 
>> -static int get_mtt_entries(struct erdma_dev *dev, struct erdma_mem *mem,
>> -			   u64 start, u64 len, int access, u64 virt,
>> -			   unsigned long req_page_size, bool force_continuous)
>> +static void erdma_mem_free(struct erdma_dev *dev, struct erdma_mem *mem)
>>  {
>> -	int ret = 0;
>> +	switch (mem->type) {
>> +	case ERDMA_UMEM:
>> +		if (mem->umem) {
> 
> I expect that if you call to this function, mem->umem is already valid.
> 

Sure, I will fix it.

Thanks,
Cheng Xu

>> +			ib_umem_release(mem->umem);
>> +			mem->umem = NULL;
>> +		}
>> +		break;
>> +	case ERDMA_KMEM:
>> +		erdma_kmem_free(dev, mem);
>> +		break;
>> +	default:
>> +		break;
>> +	}
>> +}
>>  
> 
> Thanks
