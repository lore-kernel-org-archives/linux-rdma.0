From: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
Date: Tue, 13 Oct 2009 08:38:16 +0200
Message-ID: <20091013063816.GB9470@elte.hu>
References: <1253198976.14935.27.camel@laptop> <adazl8td35u.fsf@cisco.com> <adatyz1d17q.fsf@cisco.com> <20090929171332.GD14405@elf.ucw.cz> <20090930094456.GD24621@elte.hu> <20090930160232.GZ22310@obsidianresearch.com> <20091012181944.GF17138@elte.hu> <20091012193048.GA20313@obsidianresearch.com> <20091012202046.GA7648@elte.hu> <4AD41373.8010108@inria.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4AD41373.8010108-MZpvjPyXg2s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Brice Goglin <Brice.Goglin-MZpvjPyXg2s@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


* Brice Goglin <Brice.Goglin-MZpvjPyXg2s@public.gmane.org> wrote:

> Ingo Molnar wrote:
> > * Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> >
> >   
> >> On Mon, Oct 12, 2009 at 08:19:44PM +0200, Ingo Molnar wrote:
> >>
> >>     
> >>>> After that point the scheme is perfectly lossless.
> >>>>         
> >>> Well if it can OOM it's not lossless, obviously. You just define 
> >>> "event loss" to be equivalent to "Destruction of the universe." ;-)
> >>>       
> >> It can't OOM once the ummunotify registration is done - when an event 
> >> occurs it doesn't allocate any memory and it doesn't loose events.
> >>     
> >
> > Well, it has built-in event loss via the UMMUNOTIFY_FLAG_HINT mechanism: 
> > any double events on the same range will cause an imprecise event to be 
> > recorded and cause the loss of information.
> >   
> 
> The target (MPI) application doesn't care about how many events are 
> coming here. It just needs to know whether something has been 
> invalidated in the range. If so, it destroy the whole RDMA window 
> anyway. So it's actually _good_ that multiple events are merged into a 
> single one: the application only has to process a single event per 
> partially-invalidated range.

it's not unconditionally good as the fuzzy-merge-events rule:

                        events[n].flags      = UMMUNOTIFY_EVENT_FLAG_HINT;
                        events[n].hint_start = max(reg->start, reg->hint_start);
                        events[n].hint_end   = min(reg->end, reg->hint_end);

in essence merges flushes into a single interval - which inevitably 
might include areas of memory that were not flushed at all.

For example these two flushes:

  [...]          [...]

Would be merged into:

  [..................]

Btw., isnt the above max/min logic buggy, causing lost events? Shouldnt 
it be:

                        events[n].hint_start = min(reg->start, reg->hint_start);
                        events[n].hint_end   = max(reg->end, reg->hint_end);

?

	Ingo
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
