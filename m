From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Potential lost receive WCs (was "[PATCH WIP 38/43]")
Date: Fri, 24 Jul 2015 14:46:04 -0600
Message-ID: <20150724204604.GA28244@obsidianresearch.com>
References: <7824831C-3CC5-49C4-9E0B-58129D0E7FFF@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7824831C-3CC5-49C4-9E0B-58129D0E7FFF-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 24, 2015 at 04:26:00PM -0400, Chuck Lever wrote:
> Basically RPC work flow stopped because an RPC reply never
> arrived.

Oh, that is what I expect to see.. Remebmer the cq upcall is edge
triggered, so if you leave stuff in the cq then you don't get another
upcall until another CQE is added. If adding another CQE is somehow
contingent on the CQE left behind then the scheme deadlocks.

The CQE is not lost because calling ib_poll_cq from outside the upcall
will return it.

To confirm lost you need to see ib_poll_cq return no results and
confirm an expected CQE is missing.

The driver is expected to avoid racing with the upcall and guarentee
new CQEs will trigger no matter how many CQEs are consumed by the ULP.

So, as Steve said, if the ULP leaves CQEs behind then it must do
something to guarantee that ib_poll_cq is eventually called to collect
them, or not care about forward progress on the CQ.

Does that make sense and explain what you saw?

If yes, I recommend revising the commit and comment language. CQEs are
not lost, only the upcall isn't happening.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
