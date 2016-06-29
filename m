From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Upcoming libibverbs release
Date: Wed, 29 Jun 2016 13:27:30 -0600
Message-ID: <20160629192730.GA18394@obsidianresearch.com>
References: <20160627181758.GD23540@obsidianresearch.com>
 <20160628050246.GB3584@leon.nu>
 <20160628162028.GA27518@obsidianresearch.com>
 <20160628170549.GE3584@leon.nu>
 <20160628211858.GB5786@obsidianresearch.com>
 <20160629120920.GA24151@infradead.org>
 <20160629183414.GD17031@obsidianresearch.com>
 <017301d1d236$8496b030$8dc41090$@opengridcomputing.com>
 <20160629185757.GA17839@obsidianresearch.com>
 <017801d1d23a$a3836b10$ea8a4130$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <017801d1d23a$a3836b10$ea8a4130$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Matan Barak' <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 29, 2016 at 02:15:46PM -0500, Steve Wise wrote:

> > I think you start by realizing that nobody uses your git releases
> > anyhow.
> > 
> 
> Not true.  RedHat, for one, does.

I mean no users.

> > Everyone uses either a distro or OFED release and those are already
> > co-ordinated outside your control.
> 
> I don't know who "everyone" is, but at least some of the distros get
> the

everyone = users

> libcxgb3/4 packages from releases I publish and announce on
> linux-rdma.  Chelsio recommends to RedHat exactly which libcxb
> release to pull in for each of their OS releases.  They are not
> necessarily tied to an OFED release either.  Ditto for SUSE,
> although they may still take from OFED packages.

And that doesn't really change, you just recommend a libibverbs
release or libibverbs patch.

> From what I've experienced, the distros don't take patches for
> libraries at all.  They take discreet releases that are published by
> the maintainer of that

Your view might be a bit specialized because a plugin 'library' is a
very special case. Generally the distros will have tight controls on
library updates to guarentee no change to the ABI/API. Often they
won't accept new upstream library versions at all, instead only
backporting necessary fixes.

For instance, if you add the new CQ API support the libcxgb (or any
new API for that matter) then the provider will no longer compile on
the RH released libibverbs and either Doug will have to work on a
backport basis, or you will have to jump through configure hoops to
make it compile.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
