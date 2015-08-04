From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 20/22] IB/iser: Support up to 8MB data transfer in a
 single command
Date: Wed, 5 Aug 2015 00:21:02 +0300
Message-ID: <CAJ3xEMgXSTOB-dd5LSvH3Z2oNjyEL3Q=0HeCBn9veBifqW4r-Q@mail.gmail.com>
References: <1438243595-32288-1-git-send-email-sagig@mellanox.com>
	<1438243595-32288-21-git-send-email-sagig@mellanox.com>
	<55BA3EF6.6080800@opengridcomputing.com>
	<55BDCE4D.5080601@dev.mellanox.co.il>
	<25F51949-82B5-4BA8-8472-6056BC43C747@ornl.gov>
	<55C0F1FF.7010207@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55C0F1FF.7010207-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 4, 2015 at 8:10 PM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>
>>>> Why SIZE_4K and not PAGE_SIZE?
>>>
>>>
>>> Yes, I'll change that to PAGE_SIZE.
>>>
>>> Thanks.
>>
>>
>> Would non-4KB pages (e.g. PPC 64KB) be an issue? Would this work between
>> hosts with different page sizes?
>
>
> iser was always using 4K segments for reasons I don't perfectly
> understand. Maybe Or can comment on this? I do plan to move it to work
> with system page size (soon I hope).

Yep, back when we integrated the code upstream, we were testing on
IA64 too - where the system page size was 16KB but for some reasons
SGs provided by the block layer were many times NON FMR aligned if you
worked with 16KB FMR chunks. I would recommend to test on PPC64 and if
possible on IA64 before/after removing the usage of 4k segments.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
