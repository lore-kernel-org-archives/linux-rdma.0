From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
Date: Wed, 30 Sep 2009 10:06:32 -0700
Message-ID: <ada63b0tl9j.fsf@cisco.com>
References: <aday6omhz9d.fsf@cisco.com> <1253187028.8439.2.camel@twins>
	<adafxalejiq.fsf@cisco.com> <adaab0tej5c.fsf@cisco.com>
	<1253198976.14935.27.camel@laptop> <adazl8td35u.fsf@cisco.com>
	<adatyz1d17q.fsf@cisco.com> <20090929171332.GD14405@elf.ucw.cz>
	<20090930094456.GD24621@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090930094456.GD24621-X9Un+BFzKDI@public.gmane.org> (Ingo Molnar's message of "Wed,
	30 Sep 2009 11:44:56 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>
Cc: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


 > Performance events filtering is being worked on and now with the proper 
 > non-DoS limit you've added you can lose events too, dont you? So it's 
 > all a question of how much buffering to add - and with perf events too 
 > you can buffer arbitrary large amount of events.

No, the idea for non-DoS for ummunotify is that we would limit the
number of regions the application can register; so an application might
hit the limit up front but no runtime loss of events once a region was
registered successfully.

 > I think this could be done in a simpler, less limited, more generic, 
 > more useful form by using some variation of perf events.
 > 
 > You should be able to get all that you want by adding two TRACE_EVENT() 
 > tracepoints and using the existing perf event syscall to get the events 
 > to user-space.

Yes, I would like to use perf events too.  Would it be plausible to
create a way for userspace to create a "counter" for each address range
being watched?  Then events would not be lost, because those counters
would become non-zero.

 > Meaning that this:
 >   9 files changed, 1060 insertions(+), 1 deletions(-)

Note that lots/ of the files touched here are in Documentation or are
one-line changes to Makefiles etc.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
