From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
Date: Mon, 28 Sep 2009 15:40:57 -0600
Message-ID: <20090928214057.GX19540@obsidianresearch.com>
References: <aday6omhz9d.fsf@cisco.com> <20090915113434.GF1328@ucw.cz> <ada7hw0gsqz.fsf@cisco.com> <20090928204923.GA1960@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090928204923.GA1960-I/5MKhXcvmPrBKCeMvbIDA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 28, 2009 at 10:49:23PM +0200, Pavel Machek wrote:

> >  > I don't remember seeing discussion of this on lkml. Yes it  is in
> >  > -next...
> > 
> > eg http://lkml.org/lkml/2009/7/31/197 and followups, or search for v2
> > and earlier patches.
 
> Well... it seems little overspecialized. Just modifying libc to
> provide hooks you want looks like better solution.

That is what MPI people are doing today and their feedback is that it
doesn't work - there are a lot of ways to mess with memory and no good
choices to hook the raw syscalls and keep sensible performance.

The main focus of this is high performance MPI apps, so lower overhead
on critical paths like memory allocation is part of the point. It is
ment to go hand-in-hand with the specialized RDMA memory pinning
interfaces..

> >  > Basically it allows app to 'trace itself'? ...with interesting mmap()
> >  > interface, exporting int to userspace, hoping it behaves atomically...? 
> > 
> > Yes, it allows app to trace what the kernel does to memory mappings.  I
> > don't believe there's any real issue to atomicity of mmap'ed memory,
> > since userspace really just tests whether read value is == to old read
> > value or not.
> 
> That still needs memory barriers etc.. to ensure reliable operation,
> no?

No, I don't think so..

The application is expected to provide sequencing of some sort between
the memory call (mmap/munmap/brk/etc) and the int check - usually just
by running in the same thread, or through some kind of locking scheme.

As long as the mmu notifiers run immediately in the same context as
the mmap/etc then it should be fine.

For example, the most common problem to solve looks like this:

   x = mmap(...)
   do RDMA with x
   [..]
   mmunmap(x);

   [..]
   y = mmap(..);
   do RDMA with y
     if by chance x == y things explode.

So this API puts the int test directly before 'do RDMA with'.

Due to the above kind of argument the net requirement is either to
completely synchronously (and with low overhead) hook every
mmap/munmap/brk/etc call into the kernel and do the accounting work,
or have a very low over head check every time the memory region is
about to be used.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
