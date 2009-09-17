From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
Date: Thu, 17 Sep 2009 16:43:13 +0200
Message-ID: <1253198593.14935.20.camel@laptop>
References: <aday6omhz9d.fsf@cisco.com> <1253187028.8439.2.camel@twins>
	 <adafxalejiq.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adafxalejiq.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2009-09-17 at 07:24 -0700, Roland Dreier wrote:
> > Anton Blanchard suggested a while back that this might be integrated
>  > with perf-counters, since perf-counters already does mmap() tracking and
>  > also provides events through an mmap()'ed buffer.
>  > 
>  > Has anybody looked into this?
> 
> I didn't see the original suggestion.  Certainly hooking in to existing
> infrastructure for user/kernel communication would be good.
> 
> The fit doesn't seem great to me, although I am rather naive about perf
> counters.  The problem that ummunotify is trying to solve is to let an
> app say 'for these 1000 address ranges (that possibly only cover a small
> part of my total address space), please let me know when the mappings
> are invalidated for any reason'.
> 
> So getting those events in the kernel is no problem -- we have the MMU
> notifier hooks that tell us exactly what we need to know.  The issue is
> purely the way userspace registers interest in address ranges, and how
> to kernel returns the events.
> 
> For perf counters it seems that one would have to create a new counter
> for each address range... is that correct?  And also I don't know if
> perf counter has an analog for the fast path optimization that
> ummunotify provides via a mmap'ed generation counter (a quick way for
> userspace to see 'nothing happened since last time you checked').

You're right in that perf-counter currently doesn't provide a way to
specify these ranges, we simply track all mmap() traffic.

The thing is that mmap() data is basically a side channel. For your
usage you'd basically have to open a NOP counter and only observe the
mmap data.

We could look at ways of adding ranges..

We do have a means of detecting if new data is available, we keep a data
head index. If that moves, you've got new stuff.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
