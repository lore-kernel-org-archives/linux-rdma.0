From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Potential lost receive WCs (was "[PATCH WIP 38/43]")
Date: Thu, 30 Jul 2015 10:51:14 -0400
Message-ID: <2B721046-EC96-4768-8ECC-138FF4AE9D90@oracle.com>
References: <7824831C-3CC5-49C4-9E0B-58129D0E7FFF@oracle.com> <20150724204604.GA28244@obsidianresearch.com> <E855E210-F640-4104-9B35-2A75DF1BF2E3@oracle.com> <20150729211557.GA16284@obsidianresearch.com> <DC5354A4-3EB4-46FF-AA34-9AE26DD25031@oracle.com> <55B9CB78.9040501@dev.mellanox.co.il>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55B9CB78.9040501-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Jul 30, 2015, at 3:00 AM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> 
>>> The drivers we have that don't dequeue all the CQEs are doing
>>> something like NAPI polling and have other mechanisms to guarentee
>>> progress. Don't copy something like budget without copying the other
>>> mechanisms :)
>> 
>> OK, that makes total sense. Thanks for clarifying.
> 
> IIRC NAPI is soft-IRQ which chuck is trying to avoid.
> 
> Chuck, I think I was the one that commented on this. I observed a
> situation in iser where the polling loop kept going continuously
> without ever leaving the soft-IRQ context (high workload obviously).
> In addition to the polling loop hogging the CPU, other CQs with the
> same IRQ assignment were starved. So I suggested you should take care
> of it in xprtrdma as well.
> 
> The correct approach is NAPI. There is an equivalent for storage which
> is called blk_iopoll (block/blk-iopool.c) which sort of has nothing
> specific to block devices (also soft-IRQ context). I have attempted to
> convert iser to use it, but I got some unpredictable latency jitters so
> I stopped and didn't get a chance to pick it up ever since.
> 
> I still think that draining the CQ without respecting a quota is
> wrong, even if driverX has a glitch there.

The iWARP and IBTA specs disagree: they both recommend clearing
existing CQEs when handling a completion upcall. Thus the API is
designed with the expectation that consumers do not impose a poll
budget.

Any solution to the starvation problem, including quota + NAPI,
involves deferring receive work. xprtrdma already defers work.

Our completion handlers are lightweight. The bulk of receive
handling is done in softIRQ in a tasklet that handles each RPC
reply in a loop. It's more likely the tasklet loop, rather than
completion handling, is going to result in starvation.

The only issue we've seen so far is the reply tasklet can hog
one CPU because it is single-threaded across all transport
connections. Thus it is more effective for us to replace the
tasklet with a work queue where each RPC reply can be globally
scheduled and does not interfere with other work being done
by softIRQ.

In other words, the starvation issue seen in xprtrdma is not
in the receive handler, so fixing it there is likely to be
ineffective.


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
