From: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
Date: Mon, 12 Oct 2009 20:19:44 +0200
Message-ID: <20091012181944.GF17138@elte.hu>
References: <aday6omhz9d.fsf@cisco.com> <1253187028.8439.2.camel@twins> <adafxalejiq.fsf@cisco.com> <adaab0tej5c.fsf@cisco.com> <1253198976.14935.27.camel@laptop> <adazl8td35u.fsf@cisco.com> <adatyz1d17q.fsf@cisco.com> <20090929171332.GD14405@elf.ucw.cz> <20090930094456.GD24621@elte.hu> <20090930160232.GZ22310@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090930160232.GZ22310-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


* Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> On Wed, Sep 30, 2009 at 11:44:56AM +0200, Ingo Molnar wrote:
> > > > OK.  It would be nice to tie into something more general, but I 
> > > > think I agree -- perf counters are missing the filtering and the "no 
> > > > lost events" that ummunotify does have. [...]
> > 
> > Performance events filtering is being worked on and now with the 
> > proper non-DoS limit you've added you can lose events too, dont you? 
> > So it's all a question of how much buffering to add - and with perf 
> > events too you can buffer arbitrary large amount of events.
> 
> No, the ummunotify does not loose events, that is the fundamental 
> difference between it and all tracing schemes.
> 
> Every call to ibv_reg_mr is paired with a call to ummunotify to create 
> a matching watcher. Both calls allocate some kernel memory, if one 
> fails the entire operation fails and userspace can do whatever it does 
> on memory allocation failure.

We already support signal notification for perf events, and we also 
support two modi of perf ring-buffer overflow notification. Adding a 
third one that sends a signal when events are lost would be in line with 
that.

This would allow you to have the OOM semantics of requesting a SIGBUS - 
or user-space could do other things: like print a warning in the app or 
ignore the event overflow.

Which are all interesting things to do. (If you do that you might want 
to add that to 'perf top' or 'perf record' as well.)

> After that point the scheme is perfectly lossless.

Well if it can OOM it's not lossless, obviously. You just define "event 
loss" to be equivalent to "Destruction of the universe." ;-)

	Ingo
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
