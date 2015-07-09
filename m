From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V3 1/5] RDMA/core: Transport-independent access flags
Date: Thu, 9 Jul 2015 11:47:45 +0300
Message-ID: <559E3531.5080306@dev.mellanox.co.il>
References: <001601d0b7f9$3e1d6d40$ba5847c0$@opengridcomputing.com>
 <559AAA22.1000608@dev.mellanox.co.il> <20150707090001.GB11736@infradead.org>
 <559B9891.8060907@dev.mellanox.co.il>
 <000b01d0b8bd$f2bfcc10$d83f6430$@opengridcomputing.com>
 <20150707161751.GA623@obsidianresearch.com>
 <559BFE03.4020709@dev.mellanox.co.il>
 <20150707213628.GA5661@obsidianresearch.com>
 <559CD174.4040901@dev.mellanox.co.il>
 <20150708190842.GB11740@obsidianresearch.com>
 <20150708203205.GA21847@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150708203205.GA21847-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/8/2015 11:32 PM, 'Christoph Hellwig' wrote:
> On Wed, Jul 08, 2015 at 01:08:42PM -0600, Jason Gunthorpe wrote:
>> Then, what is left is all remote MRs and maybe it will be clearer what
>> to do about them then...
>
>  From looking at that for a while the APIs needed seem pretty simple
> to me from a consumer perspective:
>
> struct rdma_mr *rmda_alloc_mr(struct ib_pd *pd, unsigned int nr_pages);

Why assuming that the mr spans pages?
I'd prefer if we consolidate on an existing mr allocation API
ib_create_mr() that receives a generic struct ib_mr_init_attr.

> void rdma_free_mr(struct rdma_mr *mr);
>
> /* updates *sg if the SG couldn't be fully registered due to offsets */
> int rdma_register_sg(struct rdma_mr *mr, struct scatterlist **sg,
> 		u32 *pkey, u32 *offset, u32 *len);

This is where I have a problem. Providing an API that may or may not
post a work request on my QP is confusing, and I don't understand its
semantics at all. Do I need to reserve slots on my QP? should I ask for
a completion? If we suppress the completion will I see an error
completion? What should I expect to find in the wr_id?

The stack is converging on FRWR as the primary registration method. Any
other methods will gradually be removed. I think that posting the work
request must never be implicit. We should focus on making the
registration work request better and hide the mechanics from the
consumer.

P.S. you probably didn't mean the argument pkey unless I'm completely
missing something...

> void rdma_unregister_sg(struct rdma_mr *mr, struct scatterlist *sg);

Same arguments here for local invalidate work request.

> Note that this assumes that the iSER bounce buffer hacks are replaced
> with the QUEUE_FLAG_SG_GAPS flags and a change to the SG_IO code to
> bounce buffer for vectored SG_IO calls.

Yea - that's on my todo's...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
