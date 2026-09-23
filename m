Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA35C3F3298
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 10:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790158677; cv=none; b=Xls691OwnHwTCjcfjsFDnm1wrtohhlBAvHI3A0AESyM1lVLWJr2g6YGgLuul9GOM3GoTWhjppn/hN4fdIh6yKRF1fBDJcFnwA0Ed382MUVdc10z6WDTxHg4G4hKUFEiobxHfChIaYqmXfc/IU2bF+gdeucynRtLDsrNog8RjTHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790158677; c=relaxed/simple;
	bh=TEtfZKMJy8nSnDN7bJEuMfBFPzwd6gLNnq1Ln3kU4b4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gMJChg/kT3itD84Qt9G/FUHGZr7ryZ5HEjFJPI94TjQaBrPtD9me8CKC3V7rrAnroKaQca7ZO0+TkHSc2bYAxfXTFQovpdz1LOXthHL6iac+l+fBH88ZnNUMfZkUlTXNfswhJ8VCb3H73lfbXdaMXN8HUBmhX4DTtRDmuBCU0X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=SrkOi4rj; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="SrkOi4rj"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790158660; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=lNwVRuWD0q6USs0u9WgoEJGHTmKJeSUT7DvF9Sy1lLk=;
	b=SrkOi4rjavHHVZvE8GAjEKUtozHLiClVWRsL6qtEphhP3466A+ZHR/sybSHZkOypGeHNOer0vaJwE/No3Tm+EGqlUFRuinGiUTG2b3qvXwczCgu2WbEWt75FDLGddalyLk30zCTOCKMseQkogAxHPn2oGpQdXb65+dpNp32KP4A=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0XBWp0Nr_1790158659;
Received: from 30.221.114.249(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0XBWp0Nr_1790158659 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 23 Sep 2026 18:17:40 +0800
Message-ID: <f1b0112c-962b-ede6-fcc8-5d6dc4ecc6a7@linux.alibaba.com>
Date: Wed, 23 Sep 2026 18:17:38 +0800
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
 <07bb48b7-5a44-51d1-0b55-d9960f63aab2@linux.alibaba.com>
 <78e1d57a-7c12-482b-c274-2d9c7991ab1a@linux.alibaba.com>
 <20260910153351.GU13683@unreal>
 <f1d33bae-f016-5928-197f-817e1017a345@linux.alibaba.com>
 <20260918124759.GX13683@unreal>
From: Cheng Xu <chengyou@linux.alibaba.com>
In-Reply-To: <20260918124759.GX13683@unreal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 9/18/26 8:47 PM, Leon Romanovsky wrote:
> On Fri, Sep 11, 2026 at 10:41:52AM +0800, Cheng Xu wrote:
>>
>>
>> On 9/10/26 11:33 PM, Leon Romanovsky wrote:
>>> On Wed, Sep 09, 2026 at 02:21:37PM +0800, Cheng Xu wrote:
>>>>
>>>>
>>>> On 9/3/26 8:38 PM, Cheng Xu wrote:
>>>>>
>>>>>
>>>>> On 9/3/26 5:10 PM, Leon Romanovsky wrote:
>>>>>> On Thu, Aug 27, 2026 at 04:25:20PM +0800, Cheng Xu wrote:
>>>>>>> A single coherent allocation for kernel QP queues can fail for large
>>>>>>> queues when memory is fragmented.
>>>>>>>
>>>>>>> Allocate page-sized coherent buffers and describe them with the existing
>>>>>>> MTT. Keep the userspace QP path unchanged.
>>>>>>>
>>>>>>> Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
>>>>>>> ---
>>>>>>>  drivers/infiniband/hw/erdma/erdma_cq.c    |   4 +-
>>>>>>>  drivers/infiniband/hw/erdma/erdma_qp.c    |  38 +++--
>>>>>>>  drivers/infiniband/hw/erdma/erdma_verbs.c | 195 +++++++++++++---------
>>>>>>>  drivers/infiniband/hw/erdma/erdma_verbs.h |  44 ++++-
>>>>>>>  4 files changed, 179 insertions(+), 102 deletions(-)
>>>>>>
>>>>>> <...>
>>>>>>
>>>>
>>>> <...>
>>>>
>>>>>>
>>>>>>> +struct erdma_buf_list {
>>>>>>> +	void *buf;
>>>>>>> +	dma_addr_t dma_addr;
>>>>>>> +};
>>>>>>
>>>>>> This struct is very similar to scatter-gather list, why don't you use it
>>>>>> directly?
>>>>>
>>>>> Good idea. I will use struct scatterlist in the next revision.
>>>>
>>>> Hi Leon,
>>>>
>>>> I switched to scatterlist in v3, but Sashiko pointed out an issue with
>>>> using sg_set_buf() and sg_virt() on dma_alloc_coherent() memory [1].
>>>>
>>>> To handle this correctly, the driver would still need to retain the
>>>> original CPU addresses returned by dma_alloc_coherent(). Using scatterlist
>>>> does not simplify this implementation: we still need separate storage for
>>>> the CPU addresses, and the only scatterlist field we actually need is the
>>>> DMA address. A small structure holding both addresses would therefore be
>>>> simpler.
>>>
>>> Sashiko thinks that you are creating SG list to feed it to dma_map_sg()
>>> later which is not. You are using SG as simple database and you will get
>>> iterators for free.
>>>
>>> cpu_address = sg_page()
>>> dma_address = sg_dma_address()
>>>
>>
>> Hi Leon,
>>
>> Maybe I misunderstood something. My understanding of Sashiko's concern is
>> that the CPU address returned by dma_alloc_coherent() is not guaranteed to
>> be valid for virt_to_page(), as used by sg_set_buf(). Consequently, the
>> struct page later returned by sg_page() may be invalid.
>>
>> Although this works on the x86 platforms we tested, it may not be portable
>> to architectures where coherent memory is remapped outside the linear
>> mapping. From this perspective, would a small structure that explicitly
>> stores the CPU and DMA addresses, similar to those used by HNS and mlx5, be
>> more appropriate than scatterlist here?
> 
> Yes, let's use them directly, without SG. Sorry for the confusion in my
> previous comment.
> 

Thanks for confirming. v4 keeps the small private structure as discussed.

Thanks,
Cheng Xu

> Thanks
> 
>>
>> I collected some information related to this below [1][2][3].
>>
>> [1] include/linux/scatterlist.h:
>>
>> #ifdef CONFIG_DEBUG_SG
>> 	BUG_ON(!virt_addr_valid(buf));
>> #endif
>> sg_set_page(sg, virt_to_page(buf), buflen, offset_in_page(buf));
>>
>> [2] kernel/dma/mapping.c:
>>
>> /*
>>  * The whole dma_get_sgtable() idea is fundamentally unsafe ...
>>  * 1. Not all memory allocated via the coherent DMA APIs is backed by
>>  *    a struct page
>>  */
>>
>> [3] drivers/infiniband/hw/mthca/mthca_memfree.c:
>>
>> /* We use sg_set_buf for coherent allocs, which assumes low memory */
> 
> I wouldn't hold my breath about the validity of that comment. It was written
> a long time ago.
> 
>>
>> Thanks,
>> Cheng Xu
>>
>>
>>> Thanks
>>>
>>
