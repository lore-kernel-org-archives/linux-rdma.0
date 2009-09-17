From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
Date: Thu, 17 Sep 2009 08:45:29 -0700
Message-ID: <adatyz1d17q.fsf@cisco.com>
References: <aday6omhz9d.fsf@cisco.com> <1253187028.8439.2.camel@twins>
	<adafxalejiq.fsf@cisco.com> <adaab0tej5c.fsf@cisco.com>
	<1253198976.14935.27.camel@laptop> <adazl8td35u.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adazl8td35u.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> (Roland Dreier's message of "Thu, 17
	Sep 2009 08:03:25 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > > > Hmm, or are you saying you can only get 1 event per registered range and
 > > > allocate the thing on registration? That'd need some registration limit
 > > > to avoid DoS scenarios.
 > > 
 > > Yes, that's what I do.  You're right, I should add a limit... although
 > > their are lots of ways for userspace to consume arbitrary amounts of
 > > kernel resources already.
 > 
 > I'd be good to work at reducing that number, not adding to it ;-)

Yes, definitely.  I'll add a quick ummunotify module parameter that
limits the number of registrations per process.

 > But yeah, I currently don't see a very nice match to perf counters.

OK.  It would be nice to tie into something more general, but I think I
agree -- perf counters are missing the filtering and the "no lost
events" that ummunotify does have.  And I'm not sure it's worth messing
up the perf counters design just to jam one more not totally related
thing in.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
