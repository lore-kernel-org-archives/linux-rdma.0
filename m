From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: shrink struct ib_send_wr V4
Date: Mon, 2 Nov 2015 20:16:14 -0800
Message-ID: <20151103041614.GA14023@kroah.com>
References: <20151029115114.GA18466@lst.de>
 <56360148.8060608@mellanox.com>
 <20151101180609.GC13943@kroah.com>
 <5637EFC8.4010300@redhat.com>
 <20151102233726.GA18251@kroah.com>
 <5637F97C.5090205@redhat.com>
 <20151103001845.GA24206@obsidianresearch.com>
 <56380535.5040101@redhat.com>
 <20151103012821.GA24650@obsidianresearch.com>
 <563815F7.2090003@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <563815F7.2090003-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 02, 2015 at 09:03:35PM -0500, Doug Ledford wrote:
> On 11/02/2015 08:28 PM, Jason Gunthorpe wrote:
> > On Mon, Nov 02, 2015 at 07:52:05PM -0500, Doug Ledford wrote:
> >> It shouldn't be.  I reviewed those changes and they looked right (given
> >> the limitations).  All you needed was to boot with nopat on the kernel
> >> command line to get the old kernel behavior and it would continue to
> >> work as before, and it would print out a message telling you to do so if
> >> you hadn't already.
> > 
> > Alright, that was done after it was pretty clear the driver was
> > useless and I stopped looking at that part of the series. I don't know
> > why we made Luis jump through such hoops instead of just deleting it
> > right then and there.
> > 
> >>> For amso1100, kernel ULPs has never been its target.  Didn't we only
> >>> recently got any support for iWARP in iSER?
> > 
> > I don't like that reasoning. In 4.4 we expect some ULPs to work on
> > iWarp, and amso110 can't do it. That is a big reason why the driver
> > is getting chopped.
> > 
> >>> The reason I lobbied to get rid of them is specifically because they
> >>> don't work and maintaining them (ie the driver and the single-use ULP
> >>> codepath side) is a huge pain. Keeping them around and keeping them
> >>> compiling defeats the entire point. Just delete them, we don't need to
> >>> wait for 4.6.
> >>
> >> That's not true.  User space continues to work, and amso1100 shouldn't
> >> be greatly negatively impacted by recent changes.  Nor should ipath.
> > 
> > So what if user space works? The kernel consumers are known broken.
> 
> No, one kernel consumer that never worked on iWARP before now works on a
> different iWARP controller but doesn't work on the old iWARP controller.
>  Hardly the end of the world.
> 
> > We've commited to removing the driver from the kernel. We have support
> > of the driver authors to do this. We have found no users or
> > testers. We've committed to removing the ULP support (ie MR-only code
> > is being ripped out).
> > 
> > *WHY* spend an ounce of time fixing up code that *NO-ONE* will ever
> > even run? Wasted effort. Just delete them now.
> 
> You don't just "delete them now" because it denies anyone advanced
> warning of the change and denies them the chance to speak up in
> opposition to the driver's removal.  We queried the kernel community and
> found no one using it.  There are a lot of users out there that don't
> involve themselves in the kernel community at all.  For those users,
> there is a normal push back mechanism that involves the change trickling
> down into distros and then people complaining if they don't want the
> drivers removed.  We could speed that push back cycle up if the various
> distros proactively queried their customer's hardware usage.  But
> without either a query activity or a push back cycle, your assertion
> that "*NO-ONE* will ever even run?" is mere assumption not a statement
> of fact.

Moving things into the staging directory for 2 releases usually doesn't
bring out these types of users, they only show up every few years when
their distro kernel suddenly stops working on their hardware.

This too was something we discussed at the kernel summit, it's
recommended that you just delete the drivers from where they are now, no
need to move them to staging first.

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
