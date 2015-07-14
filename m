From: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3 1/5] RDMA/core: Transport-independent access flags
Date: Tue, 14 Jul 2015 11:47:12 -0400
Message-ID: <55A52F00.3090905@talpey.com>
References: <559CD174.4040901@dev.mellanox.co.il> <20150708190842.GB11740@obsidianresearch.com> <559D983D.6000804@talpey.com> <20150708233604.GA20765@obsidianresearch.com> <559E54AB.2010905@dev.mellanox.co.il> <20150709170142.GA21921@obsidianresearch.com> <20150711102538.GB14741@infradead.org> <55A4134C.2040301@talpey.com> <20150713201538.GA11681@obsidianresearch.com> <55A4D20C.2000904@dev.mellanox.co.il> <20150714153619.GC11026@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150714153619.GC11026-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/14/2015 11:36 AM, 'Christoph Hellwig' wrote:
> On Tue, Jul 14, 2015 at 12:10:36PM +0300, Sagi Grimberg wrote:
>> Having an API that does FRMR/FMR/PHYS_MR is even worse from the ULP
>> PoV. If you expose an API that might schedule (PHYS_MR) it limits the
>> context that the caller is allowed to call in.
>>
>> I'm 100% against an registration API that *might* schedule.
>
> Oh, I had missed that PHYS_MR might sleep.  That might be the reasons
> why everyone is avoiding them despite Tom preferring them over FMR.

Any synchronous verb might sleep. They issue commands to the adapter
across the PCIe bus, and need to wait for the result. FMR does, too.
At least the work-request-based ones are explicit about waiting for
the completion.

Are you saying you want an API that does memory registration without
blocking AND without sending a work request to hardware, ever?



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
