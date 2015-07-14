From: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3 1/5] RDMA/core: Transport-independent access flags
Date: Tue, 14 Jul 2015 08:12:34 -0400
Message-ID: <55A4FCB2.8090909@talpey.com>
References: <559BFE03.4020709@dev.mellanox.co.il> <20150707213628.GA5661@obsidianresearch.com> <559CD174.4040901@dev.mellanox.co.il> <20150708190842.GB11740@obsidianresearch.com> <559D983D.6000804@talpey.com> <20150708233604.GA20765@obsidianresearch.com> <559E54AB.2010905@dev.mellanox.co.il> <20150709170142.GA21921@obsidianresearch.com> <20150711102538.GB14741@infradead.org> <55A4134C.2040301@talpey.com> <20150714073756.GB7630@infradead.org> <55A4D4C6.6040907@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55A4D4C6.6040907-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/14/2015 5:22 AM, Sagi Grimberg wrote:
> On 7/14/2015 10:37 AM, 'Christoph Hellwig' wrote:
>> On Mon, Jul 13, 2015 at 03:36:44PM -0400, Tom Talpey wrote:
>>> On 7/11/2015 6:25 AM, 'Christoph Hellwig' wrote:
>>>> I think what we need to support for now is FRMR as the primary target,
>>>> and FMR as a secondar[y].
>>>
>>> FMR is a *very* bad choice, for several reasons.
>>>
>>> 1) It's not supported by very many devices, in fact it might even
>>> be thought to be obsolete.
>>
>> It's support by the Mellanox adapters,
>
> *Older* Mellanox adapters. mlx5 (and future drivers I assume) will
> no longer support FMRs.

Right, but drop the word "will". Mlx5 (the current ConnectX-4) doesn't
support FMR. It's only supported by mlx4 and mthca drivers.

>> Based on looking at the consumers and the above table I think FMR
>> are still the better fallback for devices that don't support FR,
>
> It's better if you want it fast.

Do you guys think FMR is actually "fast"? Because it's not. Measure it.
It might have been marginally faster than other schemes in like, 2007,
and only when the mempool was there to leave the registrations open.
Don't go back there.

Tom.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
