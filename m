Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ACF63A4F30
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 12:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789735686; cv=none; b=MIOqj3H1BI9yIe6rr8kCMmSYSgsGvLiRjzvAI1EtQ8YGkEXFrKLSL9PJvKIFJhT1z1XsEbp28zhbYvEH6EDqSxcsWShcoiyX3UpZR3NJjKJhCI+T8/nFUJKkLUorIDAWj1GRcKcbcBOEWIogJ0KcDe0Y8kysllB+Gl3ixyrScD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789735686; c=relaxed/simple;
	bh=kpn3kjuks8ApCtHVMPgKSBwNy+Ai0q3aCEzlEipjnx4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=inDUMmqA37W2KbGxZD7iFQBzX6zdFT6EyeskflomrQNdMtk4pBPcleQCqHEDOTZ0GLz/ujti/5kj6RwAqquydK9v0B4cSUUHvOdktS2tP8jWVb3hrfUs7Lo+QYscjlzsAqN+iWoSMi9A7r1dK5V1iM2dDQWbctR4o3JM/cbBV78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dohHI+o3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dohHI+o3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47F21F000FF;
	Fri, 18 Sep 2026 12:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789735683;
	bh=vlLAm1z70pEy11fWlZhcDf/0HJM2opIQH7+stuoGsPk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dohHI+o3glLz0k620VFfXPWVKWldBH2RkqkeovUqUnd6J9Xd5rYm+9MPN9TmBLc/E
	 3plukvemqbaOqsl3X46WHeeOdy70nSzmLxSNmXNeN/1c4Dg9fgoXbAUbyE/fha5SkG
	 knHfz5+vFv3gGDRPqIhWAu3fYcfEGLZNCnRSIZxHLgX898scsZQTaspy0h0wIFFlUS
	 LIStEqXikBFYjpfIo4/3s8BtSRSpAiE2oD9bXUka6xLWtu4ZhUKNmT/pNXOurWiDq1
	 T7yaXtsb0I+2yxZttH8UPl25XwtmE4hvrs+YYuYN1YzBFcw6mevxkKCYFJcb9Brk/5
	 KB615oxmxcB/A==
Date: Fri, 18 Sep 2026 15:47:59 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Cheng Xu <chengyou@linux.alibaba.com>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, KaiShen@linux.alibaba.com
Subject: Re: [PATCH for-next v2 1/4] RDMA/erdma: Support non-contiguous
 kernel QP buffers
Message-ID: <20260918124759.GX13683@unreal>
References: <20260827082523.36294-1-chengyou@linux.alibaba.com>
 <20260827082523.36294-2-chengyou@linux.alibaba.com>
 <20260903091033.GY24140@unreal>
 <07bb48b7-5a44-51d1-0b55-d9960f63aab2@linux.alibaba.com>
 <78e1d57a-7c12-482b-c274-2d9c7991ab1a@linux.alibaba.com>
 <20260910153351.GU13683@unreal>
 <f1d33bae-f016-5928-197f-817e1017a345@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f1d33bae-f016-5928-197f-817e1017a345@linux.alibaba.com>

On Fri, Sep 11, 2026 at 10:41:52AM +0800, Cheng Xu wrote:
> 
> 
> On 9/10/26 11:33 PM, Leon Romanovsky wrote:
> > On Wed, Sep 09, 2026 at 02:21:37PM +0800, Cheng Xu wrote:
> >>
> >>
> >> On 9/3/26 8:38 PM, Cheng Xu wrote:
> >>>
> >>>
> >>> On 9/3/26 5:10 PM, Leon Romanovsky wrote:
> >>>> On Thu, Aug 27, 2026 at 04:25:20PM +0800, Cheng Xu wrote:
> >>>>> A single coherent allocation for kernel QP queues can fail for large
> >>>>> queues when memory is fragmented.
> >>>>>
> >>>>> Allocate page-sized coherent buffers and describe them with the existing
> >>>>> MTT. Keep the userspace QP path unchanged.
> >>>>>
> >>>>> Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
> >>>>> ---
> >>>>>  drivers/infiniband/hw/erdma/erdma_cq.c    |   4 +-
> >>>>>  drivers/infiniband/hw/erdma/erdma_qp.c    |  38 +++--
> >>>>>  drivers/infiniband/hw/erdma/erdma_verbs.c | 195 +++++++++++++---------
> >>>>>  drivers/infiniband/hw/erdma/erdma_verbs.h |  44 ++++-
> >>>>>  4 files changed, 179 insertions(+), 102 deletions(-)
> >>>>
> >>>> <...>
> >>>>
> >>
> >> <...>
> >>
> >>>>
> >>>>> +struct erdma_buf_list {
> >>>>> +	void *buf;
> >>>>> +	dma_addr_t dma_addr;
> >>>>> +};
> >>>>
> >>>> This struct is very similar to scatter-gather list, why don't you use it
> >>>> directly?
> >>>
> >>> Good idea. I will use struct scatterlist in the next revision.
> >>
> >> Hi Leon,
> >>
> >> I switched to scatterlist in v3, but Sashiko pointed out an issue with
> >> using sg_set_buf() and sg_virt() on dma_alloc_coherent() memory [1].
> >>
> >> To handle this correctly, the driver would still need to retain the
> >> original CPU addresses returned by dma_alloc_coherent(). Using scatterlist
> >> does not simplify this implementation: we still need separate storage for
> >> the CPU addresses, and the only scatterlist field we actually need is the
> >> DMA address. A small structure holding both addresses would therefore be
> >> simpler.
> > 
> > Sashiko thinks that you are creating SG list to feed it to dma_map_sg()
> > later which is not. You are using SG as simple database and you will get
> > iterators for free.
> > 
> > cpu_address = sg_page()
> > dma_address = sg_dma_address()
> > 
> 
> Hi Leon,
> 
> Maybe I misunderstood something. My understanding of Sashiko's concern is
> that the CPU address returned by dma_alloc_coherent() is not guaranteed to
> be valid for virt_to_page(), as used by sg_set_buf(). Consequently, the
> struct page later returned by sg_page() may be invalid.
> 
> Although this works on the x86 platforms we tested, it may not be portable
> to architectures where coherent memory is remapped outside the linear
> mapping. From this perspective, would a small structure that explicitly
> stores the CPU and DMA addresses, similar to those used by HNS and mlx5, be
> more appropriate than scatterlist here?

Yes, let's use them directly, without SG. Sorry for the confusion in my
previous comment.

Thanks

> 
> I collected some information related to this below [1][2][3].
> 
> [1] include/linux/scatterlist.h:
> 
> #ifdef CONFIG_DEBUG_SG
> 	BUG_ON(!virt_addr_valid(buf));
> #endif
> sg_set_page(sg, virt_to_page(buf), buflen, offset_in_page(buf));
> 
> [2] kernel/dma/mapping.c:
> 
> /*
>  * The whole dma_get_sgtable() idea is fundamentally unsafe ...
>  * 1. Not all memory allocated via the coherent DMA APIs is backed by
>  *    a struct page
>  */
> 
> [3] drivers/infiniband/hw/mthca/mthca_memfree.c:
> 
> /* We use sg_set_buf for coherent allocs, which assumes low memory */

I wouldn't hold my breath about the validity of that comment. It was written
a long time ago.

> 
> Thanks,
> Cheng Xu
> 
> 
> > Thanks
> > 
> 
