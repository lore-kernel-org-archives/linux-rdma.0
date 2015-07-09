From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V3 1/5] RDMA/core: Transport-independent access flags
Date: Thu, 9 Jul 2015 11:58:58 +0300
Message-ID: <559E37D2.9090103@dev.mellanox.co.il>
References: <559AAA22.1000608@dev.mellanox.co.il>
 <20150707090001.GB11736@infradead.org> <559B9891.8060907@dev.mellanox.co.il>
 <000b01d0b8bd$f2bfcc10$d83f6430$@opengridcomputing.com>
 <20150707161751.GA623@obsidianresearch.com>
 <559BFE03.4020709@dev.mellanox.co.il>
 <20150707213628.GA5661@obsidianresearch.com>
 <559CD174.4040901@dev.mellanox.co.il>
 <20150708190842.GB11740@obsidianresearch.com>
 <20150708203205.GA21847@infradead.org>
 <20150709000337.GE16812@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150709000337.GE16812-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/9/2015 3:03 AM, Jason Gunthorpe wrote:
> On Wed, Jul 08, 2015 at 01:32:05PM -0700, 'Christoph Hellwig' wrote:
>> On Wed, Jul 08, 2015 at 01:08:42PM -0600, Jason Gunthorpe wrote:
>>> Then, what is left is all remote MRs and maybe it will be clearer what
>>> to do about them then...
>>
>>  From looking at that for a while the APIs needed seem pretty simple
>> to me from a consumer perspective:
>>
>> struct rdma_mr *rmda_alloc_mr(struct ib_pd *pd, unsigned int nr_pages);
>> void rdma_free_mr(struct rdma_mr *mr);
>
> The major trouble with that is that the new MR types work by posting
> work to the send queue, that work creates the MR.
>
> I don't know all the details of how those schemes work, but it doesn't
> look like it fits into this model ?
>
> Maybe if rdma_register_sg was the only API and it accepted a QP, under
> the hood it could re-use a pooled/create a non-queued (F)MR, or issue
> FRMR, or work with indirect?

I think it's confusing to possibly do completely different registration
methods which has different implications on the consumer RDMA channel.

>
> It would be nice if it is that simple :)

It can be simple if we consolidate on a single method.

>
> Sagi, are FMRs, FRMRs and Indirect MRs documented any place? I can't
> recall off hand if FRMR was ever published by the IBTA?

I don't know if FMRs are in IBTA.
FRMRs are in under 10.6.3.7 FAST REGISTRATION (vol 1)
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
