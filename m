Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDADD18787A
	for <linux-rdma@vger.kernel.org>; Fri, 11 Sep 2026 02:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789094519; cv=none; b=OfVcG2PgnUF5jMBSwz2n3LC52CQgn3GFSu2IF0648Qr7gxx6F+JyoKaa/5Tt22f1U7WFgRqvcNrmcDu4w3Ju3vShQ5VwY8vKNNHL9IBQFk8l8TGhDCtRH8b2camT8dGZY2slKJy/mjde9Oclb3SolklVRrC906Vsbky4WOfwp8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789094519; c=relaxed/simple;
	bh=ESP0FX0/w3x4afTOtCMns82vqHA10tbh+mj6CQ6nTgc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TVBJdZp+H7aPcGlHGphO2gYswOURkeoRR9sb0aSkWtkRNKHwj/Oe2PiI2TxhJbXonI9a18poAuPVCi5E7SxkZ0h+kgBDeHQF7xh8tscLcT4Ho5xmgWC+5U3CYY14TdG3XdXYX++68BdEAkpa1c4J3GN3F/M3vAWDWKy5bYyNPO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=NT9fLQok; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="NT9fLQok"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789094514; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=n2P2020oMD82FKDJEN38xmUKm1L2aN7nf6yV7/rTqxE=;
	b=NT9fLQok8gU2plJX6CsJ4Jx7YFYBuxRXGmtOl4NK+Vda2n5vuyb60t6jyzA6dvXOxJzHmZapzt7+zEF+E3TbJSxHJEv8BzJNhBy7WpcnkhIcoIUbWtFX5QKZ6Q2y/3TWiRwJSh+0kY1KHK7vk7+kccUUfUvXITyLPUvvsmSCTq4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0XAj1abi_1789094512;
Received: from 30.221.104.67(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0XAj1abi_1789094512 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 11 Sep 2026 10:41:53 +0800
Message-ID: <f1d33bae-f016-5928-197f-817e1017a345@linux.alibaba.com>
Date: Fri, 11 Sep 2026 10:41:52 +0800
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
From: Cheng Xu <chengyou@linux.alibaba.com>
In-Reply-To: <20260910153351.GU13683@unreal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 9/10/26 11:33 PM, Leon Romanovsky wrote:
> On Wed, Sep 09, 2026 at 02:21:37PM +0800, Cheng Xu wrote:
>>
>>
>> On 9/3/26 8:38 PM, Cheng Xu wrote:
>>>
>>>
>>> On 9/3/26 5:10 PM, Leon Romanovsky wrote:
>>>> On Thu, Aug 27, 2026 at 04:25:20PM +0800, Cheng Xu wrote:
>>>>> A single coherent allocation for kernel QP queues can fail for large
>>>>> queues when memory is fragmented.
>>>>>
>>>>> Allocate page-sized coherent buffers and describe them with the existing
>>>>> MTT. Keep the userspace QP path unchanged.
>>>>>
>>>>> Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
>>>>> ---
>>>>>  drivers/infiniband/hw/erdma/erdma_cq.c    |   4 +-
>>>>>  drivers/infiniband/hw/erdma/erdma_qp.c    |  38 +++--
>>>>>  drivers/infiniband/hw/erdma/erdma_verbs.c | 195 +++++++++++++---------
>>>>>  drivers/infiniband/hw/erdma/erdma_verbs.h |  44 ++++-
>>>>>  4 files changed, 179 insertions(+), 102 deletions(-)
>>>>
>>>> <...>
>>>>
>>
>> <...>
>>
>>>>
>>>>> +struct erdma_buf_list {
>>>>> +	void *buf;
>>>>> +	dma_addr_t dma_addr;
>>>>> +};
>>>>
>>>> This struct is very similar to scatter-gather list, why don't you use it
>>>> directly?
>>>
>>> Good idea. I will use struct scatterlist in the next revision.
>>
>> Hi Leon,
>>
>> I switched to scatterlist in v3, but Sashiko pointed out an issue with
>> using sg_set_buf() and sg_virt() on dma_alloc_coherent() memory [1].
>>
>> To handle this correctly, the driver would still need to retain the
>> original CPU addresses returned by dma_alloc_coherent(). Using scatterlist
>> does not simplify this implementation: we still need separate storage for
>> the CPU addresses, and the only scatterlist field we actually need is the
>> DMA address. A small structure holding both addresses would therefore be
>> simpler.
> 
> Sashiko thinks that you are creating SG list to feed it to dma_map_sg()
> later which is not. You are using SG as simple database and you will get
> iterators for free.
> 
> cpu_address = sg_page()
> dma_address = sg_dma_address()
> 

Hi Leon,

Maybe I misunderstood something. My understanding of Sashiko's concern is
that the CPU address returned by dma_alloc_coherent() is not guaranteed to
be valid for virt_to_page(), as used by sg_set_buf(). Consequently, the
struct page later returned by sg_page() may be invalid.

Although this works on the x86 platforms we tested, it may not be portable
to architectures where coherent memory is remapped outside the linear
mapping. From this perspective, would a small structure that explicitly
stores the CPU and DMA addresses, similar to those used by HNS and mlx5, be
more appropriate than scatterlist here?

I collected some information related to this below [1][2][3].

[1] include/linux/scatterlist.h:

#ifdef CONFIG_DEBUG_SG
	BUG_ON(!virt_addr_valid(buf));
#endif
sg_set_page(sg, virt_to_page(buf), buflen, offset_in_page(buf));

[2] kernel/dma/mapping.c:

/*
 * The whole dma_get_sgtable() idea is fundamentally unsafe ...
 * 1. Not all memory allocated via the coherent DMA APIs is backed by
 *    a struct page
 */

[3] drivers/infiniband/hw/mthca/mthca_memfree.c:

/* We use sg_set_buf for coherent allocs, which assumes low memory */

Thanks,
Cheng Xu


> Thanks
> 
