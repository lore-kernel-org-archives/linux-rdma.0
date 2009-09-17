From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
Date: Thu, 17 Sep 2009 16:49:36 +0200
Message-ID: <1253198976.14935.27.camel@laptop>
References: <aday6omhz9d.fsf@cisco.com> <1253187028.8439.2.camel@twins>
	 <adafxalejiq.fsf@cisco.com>  <adaab0tej5c.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaab0tej5c.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2009-09-17 at 07:32 -0700, Roland Dreier wrote:
> > So getting those events in the kernel is no problem -- we have the MMU
>  > notifier hooks that tell us exactly what we need to know.  The issue is
>  > purely the way userspace registers interest in address ranges, and how
>  > to kernel returns the events.
>  > 
>  > For perf counters it seems that one would have to create a new counter
>  > for each address range... is that correct?  And also I don't know if
>  > perf counter has an analog for the fast path optimization that
>  > ummunotify provides via a mmap'ed generation counter (a quick way for
>  > userspace to see 'nothing happened since last time you checked').
> 
> Oh I forgot... ummunotify also preallocates everything etc. so that
> there is no way for events to be lost.  Which saves userspace from
> having to trash everything cached and start over, which it would have to
> do if it misses an invalidate event.
> 
> And AFAIK, pref counters does have the possibility of overflowing a
> buffer and losing an event, right?

Well, you cannot pre-allocate everything, either you get back-logged
evens in kernel space leading to a kernel DoS, or you loose events.

Perf counters have two modes, a RO mmap() and a RW mmap(). The RO mode
will automagically overwrite its tail data without regard for userspace
having observed it.

In the RW mode userspace has to advance the tail, the kernel will drop
events when full and insert a PERF_EVENT_LOST event once there is room
again.

Hmm, or are you saying you can only get 1 event per registered range and
allocate the thing on registration? That'd need some registration limit
to avoid DoS scenarios.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
