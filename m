From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Upcoming libibverbs release
Date: Tue, 19 Jul 2016 14:09:57 -0600
Message-ID: <20160719200957.GB28288@obsidianresearch.com>
References: <20160627181758.GD23540@obsidianresearch.com>
 <20160628050246.GB3584@leon.nu>
 <20160628162028.GA27518@obsidianresearch.com>
 <20160628170549.GE3584@leon.nu>
 <022001d1d170$fda2c3e0$f8e84ba0$@opengridcomputing.com>
 <20160628211441.GA5786@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0663DA@ORSMSX109.amr.corp.intel.com>
 <20160629051956.GG3584@leon.nu>
 <20160629183042.GC17031@obsidianresearch.com>
 <babed655-b61f-e97b-2351-b1ea6692b18d@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <babed655-b61f-e97b-2351-b1ea6692b18d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Matan Barak' <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 19, 2016 at 03:57:03PM -0400, Doug Ledford wrote:
> On 6/29/2016 2:30 PM, Jason Gunthorpe wrote:
> > On Wed, Jun 29, 2016 at 08:19:56AM +0300, Leon Romanovsky wrote:
> >> On Tue, Jun 28, 2016 at 09:26:38PM +0000, Hefty, Sean wrote:
> >>>> The fundamental question is if it is acceptable for libibverbs to ship
> >>>> a new core provider agnostic API (cq polling) that is optional
> >>>> depending on provider.
> >>>>
> >>>> I say no, that is not acceptable.
> >>>
> >>> I agree - there's no compelling argument that the new calls can't work over all providers.
> >>
> >> I agree too, this is why code is provided and nothing stops from other provider to support it.
> > 
> > That isn't what I said, and it isn't what everyone is agreeing with.
> > 
> > I said an optinal API is not acceptable to ship.
> > 
> > That means 'nothing stops' is not enough - the patch author and
> > maintainer have the responsibility to ensure all providers work with
> > the API before shipping it.
> 
> That's not entirely true.  In the kernel, if someone cuts over stuff
> from one API to a replacement API, then yes, they are responsible for
> updating all of the users of the old API.  But if they create a new API
> that is in addition to the old API, then that's not the case.  This
> falls in that latter category.

This isn't the kernel. This is a user facing library that has to be
explained to end-developers.

Telling them to use API A if they detect mlx5 and API B otherwise is
madness, that might fly in the kernel, but it makes no sense
for libibverbs.

> That said, there is no reason that owners of various driver libraries
> can't update their own libraries to this API.  As we already discussed
> in another thread when Steve Wise brought up the issue of how things

We don't even have a single other implementation, not even mthca and
mlx4 that Mellanox is responsible for and it has been a long time
now..

> something here is not the same day they pick things up there, so we
> should have sufficient time to update libibverbs and then cut over the
> driver modules.  They don't have to happen on the same day.

Sure, but will that ever happen??

> What I don't want is a core compat layer in libibverbs.  The changes
> needed to support just the pull cq changes are not that drastic and they
> have benefit that would be lost in a compat layer, so I would rather see
> them done natively on a per library basis.

The benifit is not performance, it is a uniform single API that apps
can code against. If new apps are being run on older hardware then
then vendor should be motivated to natively implement the API. But we
should never tell an app writer they cannot use a core API because of
the driver.

The patch that was given to the ping example is is exactly the
horrible situation I do not want to put our app authors in, completely
duplicating CQ processing in the app makes no sense.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
