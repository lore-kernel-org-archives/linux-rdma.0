From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH WIP 28/43] IB/core: Introduce new fast registration API
Date: Thu, 20 Aug 2015 13:05:59 +0300
Message-ID: <55D5A687.90102@dev.mellanox.co.il>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-29-git-send-email-sagig@mellanox.com>
 <20150722165012.GC6443@infradead.org>
 <20150722174401.GG26909@obsidianresearch.com>
 <55B0BEB4.9080702@dev.mellanox.co.il>
 <20150723175535.GE25174@obsidianresearch.com>
 <55D46EE8.4060701@dev.mellanox.co.il>
 <20150819173751.GB22646@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150819173751.GB22646-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>> 1. if register - call ib_map_mr_sg (which calls dma_map_sg)
>>     else do dma_map_sg
>> 2. if registered - call ib_dma_unmap_sg (which calles dma_unmap_sg)
>>     else do dma_unmap_sg
>
>  From what I've seen in the ULPs the flow control is generally such
> that the MR is 'consumed' even if it isn't used by a send.

Not really. if registration is not needed, an MR is not consumed. In
fact, in svcrdma the IB code path never uses those, and the iWARP code
path always use those for RDMA_READs and not RDMA_WRITEs. Also, isert
use those only when signature is enabled and registration is required.

>
> So lkey usage is simply split into things that absolutely don't need a
> MR, and things that maybe do. The maybe side can go ahead and always
> consume the MR resource, but optimize the implementation to a SG list
> to avoid a performance hit.
>
> Then the whole API becomes symmetric. The ULP says, 'here is a
> scatterlist list and a lkey MR, make me a ib_sg list' and the core
> either packes it as is into the sg, or it spins up the MR and packs
> that.

Always consuming an MR resource is an extra lock acquire given these
are always kept in a pool structure.

>> I'm thinking we should keep dma_map_sg out of ib_map_mr_sg, and leave
>> it to the ULP like it does today (at least in the first stage...)
>
> I'm fine with first stage, but we still really do need to figure how
> how to get better code sharing in our API here..
>
> Maybe we can do the rkey side right away until we can figure out how
> to harmonize the rkey sg/mr usage?

I'm fine with that. I agree we still need to do better.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
