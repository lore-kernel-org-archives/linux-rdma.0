From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Potential lost receive WCs (was "[PATCH WIP 38/43]")
Date: Thu, 30 Jul 2015 10:00:08 +0300
Message-ID: <55B9CB78.9040501@dev.mellanox.co.il>
References: <7824831C-3CC5-49C4-9E0B-58129D0E7FFF@oracle.com>
 <20150724204604.GA28244@obsidianresearch.com>
 <E855E210-F640-4104-9B35-2A75DF1BF2E3@oracle.com>
 <20150729211557.GA16284@obsidianresearch.com>
 <DC5354A4-3EB4-46FF-AA34-9AE26DD25031@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <DC5354A4-3EB4-46FF-AA34-9AE26DD25031-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> The drivers we have that don't dequeue all the CQEs are doing
>> something like NAPI polling and have other mechanisms to guarentee
>> progress. Don't copy something like budget without copying the other
>> mechanisms :)
>
> OK, that makes total sense. Thanks for clarifying.

IIRC NAPI is soft-IRQ which chuck is trying to avoid.

Chuck, I think I was the one that commented on this. I observed a
situation in iser where the polling loop kept going continuously
without ever leaving the soft-IRQ context (high workload obviously).
In addition to the polling loop hogging the CPU, other CQs with the
same IRQ assignment were starved. So I suggested you should take care
of it in xprtrdma as well.

The correct approach is NAPI. There is an equivalent for storage which
is called blk_iopoll (block/blk-iopool.c) which sort of has nothing
specific to block devices (also soft-IRQ context). I have attempted to
convert iser to use it, but I got some unpredictable latency jitters so
I stopped and didn't get a chance to pick it up ever since.

I still think that draining the CQ without respecting a quota is
wrong, even if driverX has a glitch there.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
