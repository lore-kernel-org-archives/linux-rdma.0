From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next V2 0/9] Add completion timestamping support
Date: Sat, 6 Jun 2015 23:49:15 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1506062338140.4000@east.gentwo.org>
References: <1433074457-26437-1-git-send-email-ogerlitz@mellanox.com> <1433098827.114391.179.camel@redhat.com> <CAAKD3BBo9A5AV9Uv-q1TgSQ6hs-oSUn5QsUT+5+6mk1RwW7AUA@mail.gmail.com> <1433157904.114391.188.camel@redhat.com> <20150601164322.GA14391@obsidianresearch.com>
 <1433255724.114391.225.camel@redhat.com> <20150602180844.GD17776@obsidianresearch.com> <CAJ3xEMjZqwJC8=HrMBv_eSVKVtLW7qjVZNjtuD28octGPtYu6w@mail.gmail.com> <20150603204633.GE7902@obsidianresearch.com> <alpine.DEB.2.11.1506031953500.11879@east.gentwo.org>
 <20150604042540.GA8837@obsidianresearch.com> <alpine.DEB.2.11.1506060304480.29634@east.gentwo.org> <1433605546.40123.217.camel@redhat.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433605546.40123.217.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, 6 Jun 2015, Doug Ledford wrote:

> The ppm rating is based upon the speed of the clock, not time.  It's how
> many cycles of variance you are allowed from the target speed given in
> cycles / millions of cycles of the target clock frequency.  If you have
> a 312.5MHz clock, and your accuracy is specified as 100ppm, then the
> total clock variability is 312.5 * 100 = 31250 cycles (I suspect that
> this is an absolute variance, and so the tolerance would be +-1/2 of the
> total amount, but I don't know that for certain).

Ok well then you also have the problem that the clock may be off in
general already by a certain factor from the true speed of the flow of
time due to manufacturing variances etc. We are only talking about the
instabilty of the clock source while operating it seems?

> > I am sorry but the practical issues that we are dealing with in
> > timekeeping today shows just the opposite. For a true comparison of clocks
> > with nanosecond accuracy you would need time corrected values and that is
> > a challenge due to the variances of the clocks that we see.
>
> Jason's point, and one that isn't addressed yet, is that this might not
> be variance in the clocks and instead might be a design flaw in the API
> you are using and the way the clock speeds are passed to user space.
> Changing from int MHz to int KHz might solve your problem.

That sounds doable. Maybe we need to look at how clock speeds are
specified elsewhere?

man adtimex

gives some ways that this is done in the general API for clock adjustment.

Or maybe better look at IEEE 1588 for ways to specify the clock
characteristics?

http://www.nist.gov/el/isd/ieee/ieee1588.cfm

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
