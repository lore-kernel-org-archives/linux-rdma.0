From: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3 1/5] RDMA/core: Transport-independent access flags
Date: Tue, 14 Jul 2015 16:50:53 -0400
Message-ID: <55A5762D.8010009@talpey.com>
References: <559EF332.7060103@redhat.com> <20150709225306.GA30741@obsidianresearch.com> <559FC710.1050307@talpey.com> <20150710161108.GA19042@obsidianresearch.com> <CCB6E837-88FF-4DBB-976D-4CF56396A1A1@ogc.us> <55A24571.60902@dev.mellanox.co.il> <00e201d0be6a$e49bc910$add35b30$@opengridcomputing.com> <20150714192941.GA26292@obsidianresearch.com> <00e401d0be6b$d3952750$7abf75f0$@opengridcomputing.com> <20150714195511.GB7716@infradead.org> <20150714202943.GB26927@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150714202943.GB26927-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Sagi Grimberg' <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Steve Wise' <swise-/Yg/VP3ZvrM@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, 'Oren Duer' <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/14/2015 4:29 PM, Jason Gunthorpe wrote:
> On Tue, Jul 14, 2015 at 12:55:11PM -0700, 'Christoph Hellwig' wrote:
>> On Tue, Jul 14, 2015 at 02:32:31PM -0500, Steve Wise wrote:
>>> You mean "should not", yea?
>>>
>>> Ok.  I'll check for iWARP.  But don't tell me to remove the transport-specific hacks in this series when I post it! ;)
>>
>> Just curious if there are any holes in this little scheme to deal with
>> the lkey mess:
>>
>>   (1) make sure all drivers that currently do not set
>>       IB_DEVICE_LOCAL_DMA_LKEY but which can safely use ib_get_dma_mr
>>       call it underneath at device setup time, and tear it down before
>>       removal.
>
> Yes, I'd like this.
>
> local_dma_lkey appears to be global, it works with any PD.

Only if it's supported, right? There's an attribute that a provider uses
to expose it. For example, I would not expect a virtualized provider to
be able to support this.

>
> ib_get_dma_mr is tied to a PD, so it cannot replace local_dma_lkey at
> the struct device level.

Correct, and by design, in fact. In most implementations, a different
token is returned for each call, in fact.

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
