From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Fri, 26 Aug 2016 21:50:47 -0600
Message-ID: <20160827035047.GA23049@obsidianresearch.com>
References: <01dc01d1fcb0$a1dd3ed0$e597bc70$@opengridcomputing.com>
 <20160822214352.GB11695@obsidianresearch.com>
 <20160823185441.GA1233@obsidianresearch.com>
 <cabbd0a7-0918-a8dd-d1e5-0b079f0c4604@redhat.com>
 <20160825173916.GC20612@obsidianresearch.com>
 <20160825195246.GI1916@redhat.com>
 <20160825201306.GA5421@obsidianresearch.com>
 <20160826154206.GK1916@redhat.com>
 <20160826222725.GA8553@obsidianresearch.com>
 <5421f173-384d-faef-0eab-518db6dad0e5@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5421f173-384d-faef-0eab-518db6dad0e5-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 26, 2016 at 11:00:22PM -0400, Doug Ledford wrote:

> The most recent upstream libibverbs includes -fno-strict-aliasing
> now so it can be dropped from the extra stuff in the Fedora spec
> file.

Looking at strict-aliasing is the last build issue, I'd like to
minimize the places we turn it on, so if we have been shipping
libraries that never needed it I don't want to blanket enable
it. Ideally we could run with -fstrict-aliasing, but I realize how
hard that can be..

Do you know there are confirmed bugs without -fno-strict-aliasing?

> 2) Static libraries. Do we want to continue to provide these?

> I'm ready to drop static libraries.

Great.

> > 3) Version numbers. What version numbers do we give to the sub
> >    packages? I guess this is very distro specific.
>
> You can not give different versions to sub-packages.  Or, allow me to be
> more precise:  You can't use the Version: tag on sub-packages, it
> resets

Okay, I should also clarify that when putting this all together I need
to consider Debian as well. I'm happy if RH wants to just use a jumbo
RPM, but that doesn't match Debian Policy regarding shared libraries
[my suggestions were informed by Debian Policy].

So I may look at deb packaging to guide the cmake install components
then, and try and get someone from the Debian community involved. I
started with RPM because that seems to be what most of our developers
use.

> >    I don't want to dictate what distros should do, but this is best
> >    done with support from the build system upstream, so some guidance
> >    on what to do is needed to finish the cmake stuff. (see #6)
> 
> I'm inclined to wrap it all up into a single package. librdmacm,
> libibcm, libibumad, libibverbs, providers, all of it.

Okay, so just simple rdma-libs, rdma-utils, rdma-libs-devel works for
you? Nothing more to do then.

> I would also be inclined to contribute the rdma scripts we have as
> part of the package too.  I think some of them can use some cleanups
> if they are going to become an upstream item instead of a RH
> specific item, but otherwise they work well.  If I did that, I would
> also welcome appropriate similar scripts for OSes that use different
> tools than RH OSes.

This sounds like a good idea.

>> 5) Valgrind - I've noticed CentOS forces valgrind on, and Debian
> Agree.  Changing the default on this when present is good.

Will do.

> > 7) NDEBUG - As upstream do we want this set or left unset for a
> >    release build. It eliminates all asserts and a few other things.
> >    I'm not sure what is being done today, but the %cmake rpmbuild
> >    default forces it on. (IMHO, upstream should decide this, not
> >    downstream?)
> 
> I think I would set this.  But I'm flexible.  Basically, I know end
> users want Valgrind.  We've had multiple requests to enable it.
> They

Okay, any thoughts on when assert should be enabled then? It is
useless to code it if we just compile it out in all builds.

Maybe non-packaging builds can default to leave assert in or
something?

> > 9) libtool .la files. I preserved them, but if distros don't want them
> >    I'd love to ditch them.
> 
> Drop them.

Yay, I think debian agrees.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
