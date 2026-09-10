Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2623D38D400
	for <linux-rdma@vger.kernel.org>; Thu, 10 Sep 2026 15:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789054437; cv=none; b=BSr8R66Wi/s6GbOTTKtrKiXJv/HAm7ty5ZMNufVmRHlO6Mzw/hiNSFh8B6BEnWddoBYMOaePoDOTLkLIrqj8VJhfb3yaSqBq2N6FTr8FPTiLUytPHhbGvezgQ+IiII82pfWs/MTBmMvjhIVQUahdv309527F3jP//7kYrX/BUGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789054437; c=relaxed/simple;
	bh=FP6SHXIkz4JQyEXoYSFAyYS95KEHwcnliE7EQcSLhH4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IWY3okl+BCWFFoS2R9ZDoHV2/TrEhCG0mzokmxvJdM4HHYOyaDx36L9KCgtaJmipah8KZUDSKSZe+MB6RU+d/hQ2bRvWfreWc/+Trfj5helEdv7o8BPNXTiAgVQp7Ji38vi5Vdrhl4iLOz2DPyUmMui7fmV2M1FTGb+HrRzdo+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jXdEPJGn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jXdEPJGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE041F000FF;
	Thu, 10 Sep 2026 15:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789054435;
	bh=z8dvcAmVL/DnYTeCfWuv8GBnq+gBZvjbtG5rfiUEKMM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jXdEPJGnxF8IOHMVaVbTOIb3kS8p77FJ+nQgvfVYE6rOj1PwJ9Vk0ISNgL/bSXgSA
	 Er+wFtR38Rt7II5G5p0EbGbTEI4YK0hvQDspXfzpALi+VXGaT9FYwVuPbHp+dzEFAH
	 nDuIdxE5x2VinfvqAxqBCCI/3xI2Nc3HlRLNeCvf9k5PJBn1bV4pPvvDu0R+cxS09u
	 Caaej99u1FMDi3bMfo/CLiEvHiw+Zvt8khbTaiCnl8szCH5rR6O+pmxxwn/FHZgpf1
	 /e0RFXSmN6xdTDZ8VIELlPATWOa4WcnMPz6ve+jFJ07EWC3hF8gEm8uvFj6WSqNuVH
	 FaFr7tBSjzshQ==
Date: Thu, 10 Sep 2026 18:33:51 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Cheng Xu <chengyou@linux.alibaba.com>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, KaiShen@linux.alibaba.com
Subject: Re: [PATCH for-next v2 1/4] RDMA/erdma: Support non-contiguous
 kernel QP buffers
Message-ID: <20260910153351.GU13683@unreal>
References: <20260827082523.36294-1-chengyou@linux.alibaba.com>
 <20260827082523.36294-2-chengyou@linux.alibaba.com>
 <20260903091033.GY24140@unreal>
 <07bb48b7-5a44-51d1-0b55-d9960f63aab2@linux.alibaba.com>
 <78e1d57a-7c12-482b-c274-2d9c7991ab1a@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <78e1d57a-7c12-482b-c274-2d9c7991ab1a@linux.alibaba.com>

On Wed, Sep 09, 2026 at 02:21:37PM +0800, Cheng Xu wrote:
> 
> 
> On 9/3/26 8:38 PM, Cheng Xu wrote:
> > 
> > 
> > On 9/3/26 5:10 PM, Leon Romanovsky wrote:
> >> On Thu, Aug 27, 2026 at 04:25:20PM +0800, Cheng Xu wrote:
> >>> A single coherent allocation for kernel QP queues can fail for large
> >>> queues when memory is fragmented.
> >>>
> >>> Allocate page-sized coherent buffers and describe them with the existing
> >>> MTT. Keep the userspace QP path unchanged.
> >>>
> >>> Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
> >>> ---
> >>>  drivers/infiniband/hw/erdma/erdma_cq.c    |   4 +-
> >>>  drivers/infiniband/hw/erdma/erdma_qp.c    |  38 +++--
> >>>  drivers/infiniband/hw/erdma/erdma_verbs.c | 195 +++++++++++++---------
> >>>  drivers/infiniband/hw/erdma/erdma_verbs.h |  44 ++++-
> >>>  4 files changed, 179 insertions(+), 102 deletions(-)
> >>
> >> <...>
> >>
> 
> <...>
> 
> >>
> >>> +struct erdma_buf_list {
> >>> +	void *buf;
> >>> +	dma_addr_t dma_addr;
> >>> +};
> >>
> >> This struct is very similar to scatter-gather list, why don't you use it
> >> directly?
> > 
> > Good idea. I will use struct scatterlist in the next revision.
> 
> Hi Leon,
> 
> I switched to scatterlist in v3, but Sashiko pointed out an issue with
> using sg_set_buf() and sg_virt() on dma_alloc_coherent() memory [1].
> 
> To handle this correctly, the driver would still need to retain the
> original CPU addresses returned by dma_alloc_coherent(). Using scatterlist
> does not simplify this implementation: we still need separate storage for
> the CPU addresses, and the only scatterlist field we actually need is the
> DMA address. A small structure holding both addresses would therefore be
> simpler.

Sashiko thinks that you are creating SG list to feed it to dma_map_sg()
later which is not. You are using SG as simple database and you will get
iterators for free.

cpu_address = sg_page()
dma_address = sg_dma_address()

Thanks

> 
> I would like to switch back to a small structure holding the CPU and DMA
> addresses in v4. This would keep the implementation simpler while
> preserving the original addresses returned by dma_alloc_coherent().
> 
> [1] https://sashiko.dev/#/patchset/20260908033709.89898-1-chengyou%40linux.alibaba.com
> 
> Thanks,
> Cheng Xu
> 
> 
> > Thanks,
> > Cheng Xu
> > 
> >>
> >> Thanks
