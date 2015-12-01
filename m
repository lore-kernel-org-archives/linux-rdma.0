From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 5/6] IB core: Fix ib_sg_to_pages()
Date: Tue, 1 Dec 2015 11:10:29 -0800
Message-ID: <565DF0A5.6040102@sandisk.com>
References: <565DE3EC.2070002@sandisk.com> <565DE49D.4020102@sandisk.com>
 <565DE7D0.4080408@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <565DE7D0.4080408-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/01/2015 10:32 AM, Sagi Grimberg wrote:
>> Fix the code for detecting gaps and disable the code for chunking.
>> A gap occurs not only if the second or later scatterlist element
>> is not aligned but also if any scatterlist element other than the
>> last does not end at a page boundary. Disable the code for chunking.
>
> So can you explain what went wrong with the code? If ib_sg_to_pages()
> supports chunking, then sg elements are allowed not to end at a page
> boundary if it is physically contig to the next sg and then the next
> is chunked. Care to explain how did ib_sg_to_pages mess up?

With the upstream implementation, if the previous element ends at a page 
boundary (last_end_dma_addr == dma_addr) but the current element does 
not start at a page boundary (page_addr != dma_addr) then the current 
element is mapped. I think this is wrong because this condition 
indicates a gap and hence that ib_sg_to_pages() should stop iterating in 
this case.

>> Ensure that this function returns a negative error code instead of
>> zero if the first set_page() call fails.
>
> Umm, my recollection was to make ib_map_mr_sg return the largest prefix
> mapped. I don't mind a negative error in this case, but isn't zero an
> implicit error (given you didn't want to map 0 sg elements)?
>
> If we do agree on this we need to change ib_map_mr_sg documentation
> accordingly.

How ib_sg_to_pages() reports to its caller that mapping the first 
scatterlist element failed is not important to me. I included that 
change in this patch because I noticed that in the upstream SRP 
initiator does not consider ib_map_mr_sg() returning zero as an error. I 
think either ib_sg_to_pages() or ib_map_mr_sg() should be modified such 
that "no pages have been mapped" is handled as a mapping failure.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
