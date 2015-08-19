From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH WIP 28/43] IB/core: Introduce new fast registration API
Date: Wed, 19 Aug 2015 14:56:24 +0300
Message-ID: <55D46EE8.4060701@dev.mellanox.co.il>
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

So I had a go with moving the DMA mapping into ib_map_mr_sg() and
it turns out mapping somewhat poorly if the ULP _may_ register memory
or just send sg_lists (like storage targets over IB/iWARP). So the ULP
will sometimes use the DMA mapping and sometimes it won't... feels
kinda off to me...

it's much saner to do:
1. dma_map_sg
2. register / send-sg-list
3. unregister (if needed)
4. dma_unmap_sg

then:
1. if register - call ib_map_mr_sg (which calls dma_map_sg)
    else do dma_map_sg
2. if registered - call ib_dma_unmap_sg (which calles dma_unmap_sg)
    else do dma_unmap_sg

this kinda forces ULP to completely separate these code paths with
with very little sharing.

Also, at the moment, when ULPs are doing either FRWR or FMRs
its a pain to get a non-intrusive conversion.

I'm thinking we should keep dma_map_sg out of ib_map_mr_sg, and leave
it to the ULP like it does today (at least in the first stage...)

Thoughts?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
