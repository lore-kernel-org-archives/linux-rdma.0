From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
Date: Wed, 30 Sep 2009 10:02:32 -0600
Message-ID: <20090930160232.GZ22310@obsidianresearch.com>
References: <aday6omhz9d.fsf@cisco.com> <1253187028.8439.2.camel@twins> <adafxalejiq.fsf@cisco.com> <adaab0tej5c.fsf@cisco.com> <1253198976.14935.27.camel@laptop> <adazl8td35u.fsf@cisco.com> <adatyz1d17q.fsf@cisco.com> <20090929171332.GD14405@elf.ucw.cz> <20090930094456.GD24621@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090930094456.GD24621-X9Un+BFzKDI@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>
Cc: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 30, 2009 at 11:44:56AM +0200, Ingo Molnar wrote:
> > > OK.  It would be nice to tie into something more general, but I 
> > > think I agree -- perf counters are missing the filtering and the "no 
> > > lost events" that ummunotify does have. [...]
> 
> Performance events filtering is being worked on and now with the proper 
> non-DoS limit you've added you can lose events too, dont you? So it's 
> all a question of how much buffering to add - and with perf events too 
> you can buffer arbitrary large amount of events.

No, the ummunotify does not loose events, that is the fundamental
difference between it and all tracing schemes.

Every call to ibv_reg_mr is paired with a call to ummunotify to create
a matching watcher. Both calls allocate some kernel memory, if one
fails the entire operation fails and userspace can do whatever it does
on memory allocation failure.

After that point the scheme is perfectly lossless.

Performance event filtering would use the same kind of kernel memory,
call ibv_reg_mr, then install a filter, both allocate kernel memory,
if one fails the op fails. But then when the ring buffer overflows
you've lost events.

All the tracing schemes are lossy - since they loose events when the
ring buffer fills up. So to do that we either need to make a recovery
scheme of some sort, or make trace points that are blocking..

So, here is a concrete proposal how ummunotify could be absorbed by
perf events tracing, with filters.
- The filter expression must be able to trigger on a MMU event,
  triggering on the intersection of the MMU event address range and
  filter expression address range.
- The traces must be choosen so that there is exactly one filter
  expression per ibv_reg_mr region
- Each filter has a clearable saturating counter that increments every
  time the filter matches an event
- Each filter has a 64 bit user space assigned tag.
- An API similar to ummunotify exists:
     struct perf_filter_tag foo[100]
     int rc = perf_filters_read_and_clear_non_zero_counters(foo,100);
- Optionally - the mmap ring would contain only 64 bit user space
  filter tags, not trace events.

This would then duplicate the functions of ummunotify, including the
lossless collection of events. The flow would more or less be the
same:

 struct my_data *ptr = calloc()
 ptr->reg_handle = ibv_reg_mr(base,len)
 ptr->filter_handle = perf_filter_register("string matching base->len",ptr)

 [..]
 // fast path
 if (atomically(perf_map->head) != last_perf_map_head) {
     struct perf_filter_tag foo[100]
     int rc = perf_filters_read_and_clear_non_zero_counters(foo,100);
     for (unsigned int i = 0; i != rc; i++)
         ((struct my_data *)foo[i])->invalid = 1;

     perf_empty_mmap_ring(perf_map);
 }

If 'optionally' is done then the app can trundle through the mmap
and only use the above syscall loop if the mmap overflows. That would
be quite ideal.

It also must be guarenteed that when a trace point is hit the mmap
atomics are updated and visible to another user space thread before
the trace point returns - otherwise it is not synchronous enough and
will be racey.

> A question: what is the typical size/scope of the rbtree of the watched 
> regions of memory in practical (test) deployments of the ummunofity 
> code?

Jeff can you comment?

IIRC it is many tens (hundreds?) of thousands of watches.

> Per tracepoint filtering is possible via the perf event patches Li Zefan 
> has posted to lkml recently, under this subject:

Performance of the filter add is probably a bit of a concern..

Regards,
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
