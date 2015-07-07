From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V3 1/5] RDMA/core: Transport-independent access flags
Date: Tue, 7 Jul 2015 19:27:47 +0300
Message-ID: <559BFE03.4020709@dev.mellanox.co.il>
References: <20150705231831.12029.80307.stgit@build2.ogc.int>
 <20150705232158.12029.25472.stgit@build2.ogc.int>
 <559A340E.9000000@dev.mellanox.co.il>
 <001601d0b7f9$3e1d6d40$ba5847c0$@opengridcomputing.com>
 <559AAA22.1000608@dev.mellanox.co.il> <20150707090001.GB11736@infradead.org>
 <559B9891.8060907@dev.mellanox.co.il>
 <000b01d0b8bd$f2bfcc10$d83f6430$@opengridcomputing.com>
 <20150707161751.GA623@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150707161751.GA623-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 7/7/2015 7:17 PM, Jason Gunthorpe wrote:
> On Tue, Jul 07, 2015 at 09:05:15AM -0500, Steve Wise wrote:
>
>> I took the feedback from Christoph and Jason to mean I should remove
>> ib_get_dma_mr() entirely and pull its guts into rdma_get_dma_mr(),
>> and change all the users of ib_get_dma_mr() to use
>> rdma_get_dma_mr().  So the net result isn't a wrapper.  It would of
>> course still use rdma_device_access_flags()...
>
> Right, to the greatest extent possible.
>
> Keeping ib_get_dma_mr and the old flags around just means someone
> could go back and use the old flags.

It looks strange to me that there is a helper to get a transport
independent access_flags rdma_device_access_flags() that helps the
user to choose the correct access_flags for MR creation and fast
registration (which is more than OK), and having a wrapper that just
hides it from the user...

Doesn't it look odd to you?

>
> I expect well need to keep the driver entry point for user space, but
> we should be able to hide the API and flags from other modules.

dma_mr for user-space?? How can this be relevant for user-space?

>
> A wrapper is a reasonable way to stage through that transition..

I can't say that I completely agree here.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
