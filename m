From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: question about mlx5 MSI-X assignment
Date: Mon, 2 Oct 2017 14:36:23 -0600
Message-ID: <20171002203623.GC13149@obsidianresearch.com>
References: <78728626-4430-4C57-A0ED-79777416963C@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <78728626-4430-4C57-A0ED-79777416963C-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 02, 2017 at 03:10:22PM -0400, Chuck Lever wrote:

> RPC-over-RDMA in v4.14 always uses a compvec of 0. Due to the above observed behavior,
> this means that interrupts for both of these cards always route to socket 0, even though
> the CX-4 is affined to socket 1.

I think, broadly speaking, the NUMA abstractions in RDMA need work,
and this is one of the areas... So I think what you are seeing is that
this just doesn't make much sense today and there isn't really a good
plan here. I'm sure something can be hacked together by futzing with
the compvec.

Ideally, if a ULP wishes to use a specific NUMA domain, then it should
communicate that in the native kernel language for talking about NUMA
domains and not translate into the goofy compvec.

This applies broadly to not only the interrupt, but all driver
allocations related to a QP/CQ, maybe even to short lived
MRs.. Depending on what performs well.. Generally putting memory
closer to the reader is a good idea.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
