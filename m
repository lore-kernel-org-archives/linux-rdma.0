From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V3 1/5] RDMA/core: Transport-independent access flags
Date: Wed, 15 Jul 2015 10:10:02 +0300
Message-ID: <55A6074A.7080002@dev.mellanox.co.il>
References: <20150709225306.GA30741@obsidianresearch.com>
 <559FC710.1050307@talpey.com> <20150710161108.GA19042@obsidianresearch.com>
 <55A00754.4010009@redhat.com> <55A01225.9000000@talpey.com>
 <20150710195420.GA31500@obsidianresearch.com>
 <20150711101736.GA14741@infradead.org>
 <20150713165748.GE23832@obsidianresearch.com>
 <20150714072536.GA7630@infradead.org> <55A4D0F1.7000909@dev.mellanox.co.il>
 <20150714172655.GB24403@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150714172655.GB24403-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/14/2015 8:26 PM, Jason Gunthorpe wrote:
> On Tue, Jul 14, 2015 at 12:05:53PM +0300, Sagi Grimberg wrote:
>
>> iser has it too. I have a similar patch with a flag for iser (its
>> behind a bulk of patches that are still pending though).
>
> Do we all agree and understand that stuff like this in
>
> drivers/infiniband/ulp/iser/iser_verbs.c
>
>          device->mr = ib_get_dma_mr(device->pd, IB_ACCESS_LOCAL_WRITE |
>                                     IB_ACCESS_REMOTE_WRITE |
>                                     IB_ACCESS_REMOTE_READ);
>
> Represents a significant security risk to the machine, and must be
> off be default?
>
> Can you take care of fixing this for iser?

I will. It is part of a patchset I have to support remote
invalidate in iser and isert.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
