From: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
Date: Wed, 30 Sep 2009 11:44:56 +0200
Message-ID: <20090930094456.GD24621@elte.hu>
References: <aday6omhz9d.fsf@cisco.com> <1253187028.8439.2.camel@twins> <adafxalejiq.fsf@cisco.com> <adaab0tej5c.fsf@cisco.com> <1253198976.14935.27.camel@laptop> <adazl8td35u.fsf@cisco.com> <adatyz1d17q.fsf@cisco.com> <20090929171332.GD14405@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090929171332.GD14405-I/5MKhXcvmPrBKCeMvbIDA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


* Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org> wrote:

> On Thu 2009-09-17 08:45:29, Roland Dreier wrote:
> > 
> >
[...]
> > OK.  It would be nice to tie into something more general, but I 
> > think I agree -- perf counters are missing the filtering and the "no 
> > lost events" that ummunotify does have. [...]

Performance events filtering is being worked on and now with the proper 
non-DoS limit you've added you can lose events too, dont you? So it's 
all a question of how much buffering to add - and with perf events too 
you can buffer arbitrary large amount of events.

> > [...]  And I'm not sure it's worth messing up the perf counters 
> > design just to jam one more not totally related thing in.

Nobody suggested details for any redesign yet (so far it seems like a 
perfect match, to me at least) so i'm wondering what messup you are 
referring to.

> I believe that extending perf counters to do what you want is better 
> than adding one more, very strange, user<->kernel interface.

Agreed.

Lemme react to the original description of the code:

>     git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git ummunotify
>
> This will get "ummunotify," a new character device that allows a 
> userspace library to register for MMU notifications; this is 
> particularly useful for MPI implementions (message passing libraries 
> used in HPC) to be able to keep track of what wacky things consumers 
> do to their memory mappings.

I test-pulled this code and had a look at it.

I think this could be done in a simpler, less limited, more generic, 
more useful form by using some variation of perf events.

You should be able to get all that you want by adding two TRACE_EVENT() 
tracepoints and using the existing perf event syscall to get the events 
to user-space.

Meaning that this:

  9 files changed, 1060 insertions(+), 1 deletions(-)

Would be replaced with something like:

  2 files changed, 100 insertions(+), 0 deletions(-)

[ the +100 lines would (roughly) would add tracepoints to 
  invalidate_page and invalidate_range_start. (possibly via 
  mmu_notifier_register() like the ummunotify code does) Most of that 
  linecount would be comments. ]

Another upside, beyond the reduction in complexity is that we'd have one 
less special char driver based ABI. Which is a big plus in my opinion, 
especially if this goes towards HPC folks and if it's used for real. Why 
should such a MM capability hidden behind a character device and an 
ioctl?

The perf event approach is beneficial to non-HPC as well: MM 
instrumentation for example - page range invalidates are interesting to 
all sorts of modi of analysis.

A question: what is the typical size/scope of the rbtree of the watched 
regions of memory in practical (test) deployments of the ummunofity 
code?

Per tracepoint filtering is possible via the perf event patches Li Zefan 
has posted to lkml recently, under this subject:

   [PATCH 0/6] perf trace: Add filter support

They are still being worked on but it's very clear that flexible 
in-kernel filtering support will be a natural part of the perf event 
design in the very near future, so if that alone is your reason not to 
use it it would be better if you helped us complete/test the filter 
support and use that, instead of a parallel framework.

Or if that's not desirable or not possible, or if there's any other 
technical roadblock, i'd like to know the particulars of that.

Thanks,

	Ingo
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
