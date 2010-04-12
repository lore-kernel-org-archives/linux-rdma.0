From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] ummunotify: Userspace support for MMU notifications
Date: Mon, 12 Apr 2010 17:59:37 -0600
Message-ID: <20100412235937.GF15629@obsidianresearch.com>
References: <1271053337-7121-1-git-send-email-ebmunson@us.ibm.com> <20100412160359.1d9074dc.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100412160359.1d9074dc.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Eric B Munson <ebmunson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 12, 2010 at 04:03:59PM -0700, Andrew Morton wrote:

> > As discussed in <http://article.gmane.org/gmane.linux.drivers.openib/61925>
> > and follow-up messages, libraries using RDMA would like to track
> > precisely when application code changes memory mapping via free(),
> > munmap(), etc.  Current pure-userspace solutions using malloc hooks
> > and other tricks are not robust, and the feeling among experts is that
> > the issue is unfixable without kernel help.
> 
> But this info could be reassembled by tracking syscall activity, yes? 
> Perhaps some discussion here explaining why the (possibly enhanced)
> ptrace, audit, etc interfaces are unsuitable.

Just to summarize some of the key points of this thingy, as related to
your comments:
 1) It is really very narrowly focused on a particular problem MPI and
    RDMA have due to the way their APIs don't really match. Roland
    tried to make the interface general..  Maybe that is a mistake ..
 2) A 'self-tracing' scheme is used, again, because of an API
    mistmatching between a MPI library and it's own
    applications. Attempting to hook the appropriate calls has
    proven unsatisfactory (missing cases, and slow).
 3) Being intended for MPI applications, performance is a huge
    concern. Synchronous operation is very undesirable. Tracing APIs
    are lossy - and there is no recovery option if an event is lost.
 4) Realistically the only thing MPI cares about is if a virtual page
    is unmapped/remapped. Loosing events is unacceptable.
 5) This isn't really tracing. There is no queue. There aren't really
    events. This works more like the diry/access bit in a page table,
    it doesn't matter how many times something has been modified, only
    that it has at least once since last time you looked.
    
    This means the memory used is proportional to the number of
    page-ranges you watch, and the number of events against those
    page-ranges doesn't matter. No other API has this property.

Basically, this entire scheme is designed to detect that when a == b,
the internal state held by some_mpi_call is no longer valid, in
this kind of situation:
 a = mmap(ONE_PAGE);
 some_mpi_call(a);
 munmap(a);
 b = mmap(ONE_PAGE);   // Kernel picks b == a
 some_mpi_call(b);

All the races you point out, just don't matter for the MPI use
case. Essentially, if the app hits those races, then it is using the
MPI library in a buggy way.

That said, this could be explained better in the documentation file. :)

I'm sure Eric can go through the rest of your questions in greater
detail..

> > +  Userspace can use the generation counter as a quick check to avoid
> > +  system calls; if the value read from the mapped kernel counter is
> > +  still equal to the value returned in user_cookie_counter for the
> > +  most recent LAST event retrieved, then no further events have been
> > +  queued and there is no need to try a read() on the ummunotify file
> > +  descriptor.
> 
> I _guess_ that works OK on 32-bit, as long as userspace _only_ compares
> this value with some previous one.
> 
> umm, no, there's still a race I think.  If the counter increases from
> 0x00000000ffffffff to 0x0000000100000000 then userspace could see this
> as two events when using this scheme.

The only case that matters for the generation counter optimization is
a false negative. As long as user space does:

u64 val = *counter;
if (val != last_counter)
   last_counter = val;

Then you can get false positives as you point out, but never a false
negative. A false positive results in an extra syscall and the kernel
just returns no data.

Regards,
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
