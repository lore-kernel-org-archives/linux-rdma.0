From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Potential lost receive WCs (was "[PATCH WIP 38/43]")
Date: Wed, 29 Jul 2015 15:15:57 -0600
Message-ID: <20150729211557.GA16284@obsidianresearch.com>
References: <7824831C-3CC5-49C4-9E0B-58129D0E7FFF@oracle.com>
 <20150724204604.GA28244@obsidianresearch.com>
 <E855E210-F640-4104-9B35-2A75DF1BF2E3@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <E855E210-F640-4104-9B35-2A75DF1BF2E3-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 29, 2015 at 04:47:59PM -0400, Chuck Lever wrote:

> Apparently this is true for some providers, and not for others, and
> I misunderstood that when I put this together last year.

Really? In kernel providers? Interesting, those are probably wrong...

> > The idea that you can completely drain the CQ during the upcall is
> > inherently racey, so this cannot be the answer to whatever the problem
> > is..

This comment was directed toward using a complete drain to cover up a
driver bug.

A full drain to guarentee ULP progress is OK and the driver must make
sure that case isn't racey.

Which is done via:

> I thought IB_CQ_REPORT_MISSED_EVENTS was supposed to close the race
> windows here.

Basically:
 * Don't call ib_req_notify_cq unless you think the CQ is empty
 * Don't expect an upcall untill you call ib_req_notify_cq
 * Call ib_req_notify_cq last

> And Section 8.2.5 of draft-hilland-rddp-verbs recommends dequeuing
> all existing CQEs.

The drivers we have that don't dequeue all the CQEs are doing
something like NAPI polling and have other mechanisms to guarentee
progress. Don't copy something like budget without copying the other
mechanisms :)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
