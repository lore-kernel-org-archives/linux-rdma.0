From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH WIP 28/43] IB/core: Introduce new fast registration API
Date: Sun, 26 Jul 2015 12:37:55 +0300
Message-ID: <55B4AA73.3090803@dev.mellanox.co.il>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-29-git-send-email-sagig@mellanox.com>
 <20150722165012.GC6443@infradead.org>
 <20150722174401.GG26909@obsidianresearch.com>
 <55B0BEB4.9080702@dev.mellanox.co.il>
 <20150723175535.GE25174@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150723175535.GE25174-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/23/2015 8:55 PM, Jason Gunthorpe wrote:
> On Thu, Jul 23, 2015 at 01:15:16PM +0300, Sagi Grimberg wrote:
>>> I was hoping we'd move the DMA flush and translate into here and make
>>> it mandatory. Is there any reason not to do that?
>>
>> The reason I didn't added it in was so the ULPs can make sure they meet
>> the restrictions of ib_map_mr_sg(). Allow SRP to iterate on his
>> SG list set partials and iSER to detect gaps (they need to dma map
>> for that).
>
> The ULP can always get the sg list's virtual address to check for
> gaps. Page aligned gaps are always OK.

I guess I can pull DMA mapping in there, but we will need an opposite
routine ib_umap_mr_sg() since it'll be weird if the ULP will do dma
unmap without doing the map...

>
> BTW, the logic in ib_sg_to_pages should be checking that directly, as
> coded, it won't work with swiotlb:
>
> // Only the first SG entry can start unaligned
> if (i && page_addr != dma_addr)
>      return EINVAL;
> // Only the last SG entry can end unaligned
> if ((page_addr + dma_len) & PAGE_MASK != end_dma_addr)
>   if (!is_last)
>       return EINVAL;
>
> Don't use sg->offset after dma mapping.
>
> The biggest problem with checking the virtual address is
> swiotlb. However, if swiotlb is used this API is basically broken as
> swiotlb downgrades everything to a 2k alignment, which means we only
> ever get 1 s/g entry.

Can you explain what do you mean by "downgrades everything to a 2k 
alignment"? If the ULP is responsible for a PAGE_SIZE alignment than
how would this get out of alignment with swiotlb?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
