From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Status of "ummunot" branch?
Date: Wed, 5 Jun 2013 11:14:26 -0600
Message-ID: <20130605171426.GC30184@obsidianresearch.com>
References: <EF66BBEB19BADC41AC8CCF5F684F07FC4F657918@xmb-rcd-x01.cisco.com>
 <51ADA761.2080107@mellanox.com>
 <51ADB948.5080903@mellanox.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F659155@xmb-rcd-x01.cisco.com>
 <51ADD489.3020902@mellanox.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65AE40@xmb-rcd-x01.cisco.com>
 <51AEE53C.2090603@mellanox.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65C855@xmb-rcd-x01.cisco.com>
 <51AF3FA8.7000900@mellanox.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65D5D3@xmb-rcd-x01.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <EF66BBEB19BADC41AC8CCF5F684F07FC4F65D5D3-nsZYYkk5h5QQ2GdVW7+PtKBKnGwkPULj@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 05, 2013 at 04:53:48PM +0000, Jeff Squyres (jsquyres) wrote:
> On Jun 5, 2013, at 6:39 AM, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> 
> > Perhaps I'm missing something, but I believe ODP deals with the first
> > two problems in the list (slide 8), even if it doesn't solve them
> > completely.
> 
> Unfortunately, it does not.  If we could register(0 ... 2^64) and
> never have to worry about registered memory, that might be cool
> (depending on how that actually works) -- more below.
> 
> See this blog post that describes the freed registered memory issue:
> 
>     http://blogs.cisco.com/performance/registered-memory-rma-rdma-and-mpi-implementations/
> 
> and consider the following valid user code:
> 
> a = malloc(x);    // a gets (va=0x100, pa=0x12345) back from malloc
> MPI_Send(a, ...); // MPI registers 0x100 for len=x, and saves (0x100,x) in reg cache
> free(a);
> a = malloc(x);    // a gets (va=0x100, pa=0x98765) back from malloc
> MPI_Send(a, ...); // MPI sees a=0x100 and things that it is already registered
> // ...kaboom
> 
> In short, MPI has to intercept free/sbrk/whatever so that it can
> update its registration cache.

ODP is supposed to completely solve this problem. The HCA's view and
Kernels view of virtual to physical mapping becomes 100% synchronized,
and there is no 'kaboom'. The kernel updates the HCA after the free,
and after the 2nd malloc to 100% match the current virtual memory map
in the process.

MPI still has to register the memory in the first place..

.. and somehow stuff has to be managed to avoid HCA page faults in
   common cases
.. and the feature must be discoverable
.. and and and ..

The biggest issue to me is going to be efficiently prefetching receive
buffers so that RNR acks are avoided in all common cases...

> solves the MPI-must-catch-free-sbrk-etc. issues...?  And therefore,
> having some kind of ummunotify-like functionality as a verb would be
> a Very Good Thing.

AFAIK the ummunotify user space API was nak'd by the core kernel
guys. I got the impression people thought it would be acceptable as a
rdma API, not a general API. So it is waiting on someone to recast the
function within verbs to make progress...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
