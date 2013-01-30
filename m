From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: RDMA/cxgb4: Support on-chip SQs
Date: Wed, 30 Jan 2013 15:51:24 -0600
Message-ID: <510995DC.4020602@opengridcomputing.com>
References: <20130130210006.GA22134@elgon.mountain> <51099270.5070406@opengridcomputing.com> <20130130214425.GA5674@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130130214425.GA5674-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/30/2013 3:44 PM, Jason Gunthorpe wrote:
> On Wed, Jan 30, 2013 at 03:36:48PM -0600, Steve Wise wrote:
>> I wonder, then, what the correct service is to get the cpu physical
>> address from a kernel virtual address returned from
>> dma_alloc_coherent()?  I think this is correct as-is, since I think
>> dma_alloc_coherent() falls under the "directly mapped" addresses in
>> the virt_to_phys() prototype comment.
> DMA-API.txt says:
>
>   This routine allocates a region of <size> bytes of consistent memory.
>   It also returns a <dma_handle> which may be cast to an unsigned
>   integer the same width as the bus and used as the physical address
>   base of the region.
>
> So instead of virt_to_phys you should use dma_addr??

I don't think so.  The result of virt_to_phys() is used in 
remap_pfn_range() to map this memory into user space...  The dma_addr is 
give to HW for DMA operations.

> I think the note about 'directly mapped' refers to things the arch
> setups during early boot, not dma_alloc stuff.
>
> Jason

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
