From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 20/22] IB/iser: Support up to 8MB data transfer in a
 single command
Date: Tue, 4 Aug 2015 20:10:23 +0300
Message-ID: <55C0F1FF.7010207@dev.mellanox.co.il>
References: <1438243595-32288-1-git-send-email-sagig@mellanox.com>
 <1438243595-32288-21-git-send-email-sagig@mellanox.com>
 <55BA3EF6.6080800@opengridcomputing.com>
 <55BDCE4D.5080601@dev.mellanox.co.il>
 <25F51949-82B5-4BA8-8472-6056BC43C747@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <25F51949-82B5-4BA8-8472-6056BC43C747-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>>> Why SIZE_4K and not PAGE_SIZE?
>>
>> Yes, I'll change that to PAGE_SIZE.
>>
>> Thanks.
>
> Would non-4KB pages (e.g. PPC 64KB) be an issue? Would this work between hosts with different page sizes?

iser was always using 4K segments for reasons I don't perfectly
understand. Maybe Or can comment on this? I do plan to move it to work
with system page size (soon I hope).
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
