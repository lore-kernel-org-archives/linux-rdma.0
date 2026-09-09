Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE66726A1AC
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 06:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788934911; cv=none; b=RTHG7JXhmK1kC6F6Na8dGPhR6nALjZR0W4SswTnQ8wi9LVw7p2vnRkR2KwAkG1Y7SgV1YVfQ0hAX2E4E4q+xgRhNpwGm4GYa4hGmU7jgKNM0vPqjRoSiLHAS13zbmliRmp/+fhLklsXueerCKRj26zAW1LuNIH2YqQh9VWzBaqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788934911; c=relaxed/simple;
	bh=1PORtQHOVufl1/zlrpy2xJ7mfhc82/k7QEWq4MFa1XI=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=OYneJ5FEcWkhjMzsb2/9SAd6Co+k2IUnSXn/DFXfpw3kJn10JmgPz4eptyxE+m9HqvY0UUuOvL/FTyfg6nC2BaSQUOh4Xk3AHNyBbPz5u/QTc6jSZIMJ/BsKOYEXX9LTJQB8WYyjtrcWFr0K/uytxZALU2douKaYLLKiaOneOKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=AxOHlgwF; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="AxOHlgwF"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788934899; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=/sGZlYdtnT8QDBXDCIW96/57QLTiNQ7j58XbpwvL1Lc=;
	b=AxOHlgwFRsld/6VOFexIC6gO4PLCZDDP3NoYFA4jJCdy+Pi4ZUVFz4nGdzw7rWlLONyqSrDcUAaF6lRp0U1wkvVuGLWyaW2NaXBTOD2XEYzbXxOtRka06T+tAYScs6HYWu1KGqBWYzGDBiYh8ZwTxE/b5sWxqiOF1BZDZZllPi8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0XAdxgwn_1788934897;
Received: from 30.221.104.67(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0XAdxgwn_1788934897 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 09 Sep 2026 14:21:38 +0800
Message-ID: <78e1d57a-7c12-482b-c274-2d9c7991ab1a@linux.alibaba.com>
Date: Wed, 9 Sep 2026 14:21:37 +0800
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
From: Cheng Xu <chengyou@linux.alibaba.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, KaiShen@linux.alibaba.com
References: <20260827082523.36294-1-chengyou@linux.alibaba.com>
 <20260827082523.36294-2-chengyou@linux.alibaba.com>
 <20260903091033.GY24140@unreal>
 <07bb48b7-5a44-51d1-0b55-d9960f63aab2@linux.alibaba.com>
In-Reply-To: <07bb48b7-5a44-51d1-0b55-d9960f63aab2@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 9/3/26 8:38 PM, Cheng Xu wrote:
> 
> 
> On 9/3/26 5:10 PM, Leon Romanovsky wrote:
>> On Thu, Aug 27, 2026 at 04:25:20PM +0800, Cheng Xu wrote:
>>> A single coherent allocation for kernel QP queues can fail for large
>>> queues when memory is fragmented.
>>>
>>> Allocate page-sized coherent buffers and describe them with the existing
>>> MTT. Keep the userspace QP path unchanged.
>>>
>>> Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
>>> ---
>>>  drivers/infiniband/hw/erdma/erdma_cq.c    |   4 +-
>>>  drivers/infiniband/hw/erdma/erdma_qp.c    |  38 +++--
>>>  drivers/infiniband/hw/erdma/erdma_verbs.c | 195 +++++++++++++---------
>>>  drivers/infiniband/hw/erdma/erdma_verbs.h |  44 ++++-
>>>  4 files changed, 179 insertions(+), 102 deletions(-)
>>
>> <...>
>>

<...>

>>
>>> +struct erdma_buf_list {
>>> +	void *buf;
>>> +	dma_addr_t dma_addr;
>>> +};
>>
>> This struct is very similar to scatter-gather list, why don't you use it
>> directly?
> 
> Good idea. I will use struct scatterlist in the next revision.

Hi Leon,

I switched to scatterlist in v3, but Sashiko pointed out an issue with
using sg_set_buf() and sg_virt() on dma_alloc_coherent() memory [1].

To handle this correctly, the driver would still need to retain the
original CPU addresses returned by dma_alloc_coherent(). Using scatterlist
does not simplify this implementation: we still need separate storage for
the CPU addresses, and the only scatterlist field we actually need is the
DMA address. A small structure holding both addresses would therefore be
simpler.

I would like to switch back to a small structure holding the CPU and DMA
addresses in v4. This would keep the implementation simpler while
preserving the original addresses returned by dma_alloc_coherent().

[1] https://sashiko.dev/#/patchset/20260908033709.89898-1-chengyou%40linux.alibaba.com

Thanks,
Cheng Xu


> Thanks,
> Cheng Xu
> 
>>
>> Thanks
