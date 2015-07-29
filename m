From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Potential lost receive WCs (was "[PATCH WIP 38/43]")
Date: Wed, 29 Jul 2015 16:47:59 -0400
Message-ID: <E855E210-F640-4104-9B35-2A75DF1BF2E3@oracle.com>
References: <7824831C-3CC5-49C4-9E0B-58129D0E7FFF@oracle.com> <20150724204604.GA28244@obsidianresearch.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150724204604.GA28244-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason-


On Jul 24, 2015, at 4:46 PM, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> On Fri, Jul 24, 2015 at 04:26:00PM -0400, Chuck Lever wrote:
>> Basically RPC work flow stopped because an RPC reply never
>> arrived.
> 
> Oh, that is what I expect to see.. Remebmer the cq upcall is edge
> triggered, so if you leave stuff in the cq then you don't get another
> upcall until another CQE is added. If adding another CQE is somehow
> contingent on the CQE left behind then the scheme deadlocks.
> 
> The CQE is not lost because calling ib_poll_cq from outside the upcall
> will return it.
> 
> To confirm lost you need to see ib_poll_cq return no results and
> confirm an expected CQE is missing.

I tested this again, now with the patches that ensure invalidate
WRs are complete before allowing more RPCs to be dispatched. I
set the poll budget to three ib_wc's per receive upcall.

During a write-intensive workload, the RPC workflow pauses. After
a minute the RPC upper layer emits a retransmit for the missing
work, which generates a fresh server reply and RECV completion.

At that point I see a duplicate XID, which is a sign that the
original CQE was still on the CQ but no upcall was done.

The RPC workflow then resumes.


> The driver is expected to avoid racing with the upcall and guarentee
> new CQEs will trigger no matter how many CQEs are consumed by the ULP.
> 
> So, as Steve said, if the ULP leaves CQEs behind then it must do
> something to guarantee that ib_poll_cq is eventually called to collect
> them, or not care about forward progress on the CQ.
> 
> Does that make sense and explain what you saw?

It seems to, yes.

The design of the current upcall handler is based on the assumption
that the provider will call again immediately if there are still
CQEs to consume. Apparently this is true for some providers, and not
for others, and I misunderstood that when I put this together last
year.

The budgeting mechanism that I copied from another kernel ULP seems
inappropriate for xprtrdma. Perhaps it's unnecessary since sending
RPCs is flow controlled based on the reply traffic.


> If yes, I recommend revising the commit and comment language. CQEs are
> not lost, only the upcall isn't happening.

I would like to change the upcall handler to poll until ib_poll_cq
says the CQ is empty, but I don't understand this remark:

> The idea that you can completely drain the CQ during the upcall is
> inherently racey, so this cannot be the answer to whatever the problem
> is..

I thought IB_CQ_REPORT_MISSED_EVENTS was supposed to close the race
windows here. And Section 8.2.5 of draft-hilland-rddp-verbs
recommends dequeuing all existing CQEs.


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
