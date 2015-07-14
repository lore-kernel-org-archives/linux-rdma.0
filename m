From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V3 1/5] RDMA/core: Transport-independent access flags
Date: Tue, 14 Jul 2015 12:10:36 +0300
Message-ID: <55A4D20C.2000904@dev.mellanox.co.il>
References: <559BFE03.4020709@dev.mellanox.co.il>
 <20150707213628.GA5661@obsidianresearch.com>
 <559CD174.4040901@dev.mellanox.co.il>
 <20150708190842.GB11740@obsidianresearch.com> <559D983D.6000804@talpey.com>
 <20150708233604.GA20765@obsidianresearch.com>
 <559E54AB.2010905@dev.mellanox.co.il>
 <20150709170142.GA21921@obsidianresearch.com>
 <20150711102538.GB14741@infradead.org> <55A4134C.2040301@talpey.com>
 <20150713201538.GA11681@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150713201538.GA11681-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/13/2015 11:15 PM, Jason Gunthorpe wrote:
> On Mon, Jul 13, 2015 at 03:36:44PM -0400, Tom Talpey wrote:
>> On 7/11/2015 6:25 AM, 'Christoph Hellwig' wrote:
>>> I think what we need to support for now is FRMR as the primary target,
>>> and FMR as a secondar[y].
>>
>> FMR is a *very* bad choice, for several reasons.
>
> If an API can transparently support FMR, then I think it can also
> transparently support ib_get_phys_mr as an alternative, they look
> pretty similar... ?

Having an API that does FRMR/FMR/PHYS_MR is even worse from the ULP
PoV. If you expose an API that might schedule (PHYS_MR) it limits the
context that the caller is allowed to call in.

I'm 100% against an registration API that *might* schedule.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
