From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next V2 0/9] Add completion timestamping support
Date: Sat, 6 Jun 2015 03:16:18 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1506060304480.29634@east.gentwo.org>
References: <1433074457-26437-1-git-send-email-ogerlitz@mellanox.com> <1433098827.114391.179.camel@redhat.com> <CAAKD3BBo9A5AV9Uv-q1TgSQ6hs-oSUn5QsUT+5+6mk1RwW7AUA@mail.gmail.com> <1433157904.114391.188.camel@redhat.com> <20150601164322.GA14391@obsidianresearch.com>
 <1433255724.114391.225.camel@redhat.com> <20150602180844.GD17776@obsidianresearch.com> <CAJ3xEMjZqwJC8=HrMBv_eSVKVtLW7qjVZNjtuD28octGPtYu6w@mail.gmail.com> <20150603204633.GE7902@obsidianresearch.com> <alpine.DEB.2.11.1506031953500.11879@east.gentwo.org>
 <20150604042540.GA8837@obsidianresearch.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150604042540.GA8837-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 3 Jun 2015, Jason Gunthorpe wrote:

> On Wed, Jun 03, 2015 at 07:55:58PM -0500, Christoph Lameter wrote:
>
> > I thknk the raw cycles and the rought oscillator speed are fine.
>
> Time keeping is designed to adjust for 100's of ppm drift between
> clocks.

What time keeping? Ntp? pptp is supposed to be accurate to 10s of ns and
we would need an accuracy in that range.

> A communications clock source will be spec'd to be below 200ppm in
> accuracy. IB clocks are below 100 ppm, and PCI-E is 300ppm (approx, I
> didn't check, order of magnitue is close)

Well that is not usable. ns are a billionth of a second which is the unit
of measurement of these activities here. A send action can be around 600-1000ns.
If we are off by 200ppm then that is 200 microseconds meaning 200000 ns.
And its our experience that these clocks can be off by milliseconds in
practice.

> That translates into 0.0625 Hz. for a 312.5 MHz ethernet reference clock

Ok that is around 3ns per cycle? And you think the accuracy is therefore
in femtoseconds? I have never seen something that accurate. Wish something
like that would exist. Maybe in some labs that provide the source of
global timekeeping?

> Compared to 5,000,000 Hz in error from rounding.

Huh?

> So no, I disagree that rough is fine for anything.

I am sorry but the practical issues that we are dealing with in
timekeeping today shows just the opposite. For a true comparison of clocks
with nanosecond accuracy you would need time corrected values and that is
a challenge due to the variances of the clocks that we see.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
