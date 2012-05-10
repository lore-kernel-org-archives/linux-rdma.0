From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] librdmacm/rsockets: Optimize synchronization to improve
 performance
Date: Thu, 10 May 2012 10:44:37 -0600
Message-ID: <20120510164437.GD6123@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A1D845@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A1D845-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 10, 2012 at 12:01:03AM +0000, Hefty, Sean wrote:

> A test that acquired and released a lock 2 billion times reported that
> the custom lock was roughly 20% faster than using the mutex.
> 26.6 seconds versus 33.0 seconds.

I think you are measuring the fact your call is inlined and pthreads
has an indirect jump - because internally pthreads implements the same
thing using a futex instead of a sem_t.

> in releasing a lock.  However, we keep the custom lock based on
> the results of the direct lock tests that were done.

This does hurt portability though, the GCC extension
__sync_fetch_and_add is not supported on all targets..

> As to the hotspot, the unlock in question occurs during rsend().  The
> hotspot may simply be the result of processing the send completion.

Are you using a stochastic profiler? It may show as a hot spot simply
because the unlock is a context switch point.
 
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
