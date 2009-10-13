From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
Date: Tue, 13 Oct 2009 10:27:25 -0600
Message-ID: <20091013162725.GL18578@obsidianresearch.com>
References: <adazl8td35u.fsf@cisco.com> <adatyz1d17q.fsf@cisco.com> <20090929171332.GD14405@elf.ucw.cz> <20090930094456.GD24621@elte.hu> <20090930160232.GZ22310@obsidianresearch.com> <20091012181944.GF17138@elte.hu> <20091012193048.GA20313@obsidianresearch.com> <20091012202046.GA7648@elte.hu> <20091013040515.GI18578@obsidianresearch.com> <20091013064006.GC9470@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091013064006.GC9470-X9Un+BFzKDI@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>
Cc: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 13, 2009 at 08:40:06AM +0200, Ingo Molnar wrote:
> 
> * Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> 
> > On Mon, Oct 12, 2009 at 10:20:46PM +0200, Ingo Molnar wrote:
> > > It might be more acceptable because the flag-hint mechanism can at most 
> > > cause over-flushing - while with perf events we might miss to invalidate 
> > > a range altogether.
> > 
> > Right. Overflushing is not important, but missing an event entirely is 
> > not recoverable (at least within the current kernel APIs).
> 
> So if we detect event loss in the perf event case (should not happen 
> with sufficient buffering but it is a possibility the code should be 
> prepared for) then we can just flush the [0,-1ULL] range, right?

No, the reason overflushing within a registration is OK is because of
how the MPI APIs are defined and typically used. The map and
registration window will typically be 1:1 ie you malloc something and
then register it. It is an error to register beyond your malloced
space. So, in truth, the hint stuff isn't really essential for MPI.

flushing all ranges would result in data loss since ranges may be in
use at the time, and 'flush' is actually unregister/reregister - the
hardware cannot do in place atomic modify.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
