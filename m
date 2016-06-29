From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: Upcoming libibverbs release
Date: Wed, 29 Jun 2016 14:15:46 -0500
Message-ID: <017801d1d23a$a3836b10$ea8a4130$@opengridcomputing.com>
References: <3b89c411-72be-ddc5-5ebf-009eeee29692@redhat.com> <4ec1d8e6-a908-bb49-a137-415856ec6faa@dev.mellanox.co.il> <20160627181758.GD23540@obsidianresearch.com> <20160628050246.GB3584@leon.nu> <20160628162028.GA27518@obsidianresearch.com> <20160628170549.GE3584@leon.nu> <20160628211858.GB5786@obsidianresearch.com> <20160629120920.GA24151@infradead.org> <20160629183414.GD17031@obsidianresearch.com> <017301d1d236$8496b030$8dc41090$@opengridcomputing.com> <20160629185757.GA17839@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160629185757.GA17839-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Matan Barak' <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> > I have a concern about the loss of control that might happen.  For example,
now
> > I can release a new libcxgb4 whenever it works for me.  I wouldn't want to
give
> > that up and require everyone's blessing/coordination to release bug fixes
that
> > are completely in libcxgb4.  How can we handle this with a single repo for
all
> > the provider libs?
> 
> I think you start by realizing that nobody uses your git releases
> anyhow.
> 

Not true.  RedHat, for one, does.

> Everyone uses either a distro or OFED release and those are already
> co-ordinated outside your control.

I don't know who "everyone" is, but at least some of the distros get the
libcxgb3/4 packages from releases I publish and announce on linux-rdma.  Chelsio
recommends to RedHat exactly which libcxb release to pull in for each of their
OS releases.  They are not necessarily tied to an OFED release either.   Ditto
for SUSE, although they may still take from OFED packages.

> 
> Changing the place the distro gets the patches from makes no real
> difference to you or your users. However, it does make the distro's
> life simpler by having only one place to look for patches.
> 

>From what I've experienced, the distros don't take patches for libraries at all.
They take discreet releases that are published by the maintainer of that
library.  Doug, correct me if I'm wrong.  But that is how things are working
today at least for libcxgb*.   This is different from the kernel, where distros
pull in commits for fixes.

> I'd expect that provider-only patches would have a fast path into the
> combined git head, since they don't really need any consensus, and
> that is enough to get them into the backport/release cycle for the
> above channels.
>

Yes, and I'm asking that we figure this out before we cram all these libraries
into one git repo.  And again, currently I think distros pull release tarballs
and not from any git trees for the rdma provider libraries...
 
Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
