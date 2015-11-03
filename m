From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: shrink struct ib_send_wr V4
Date: Mon, 2 Nov 2015 18:28:21 -0700
Message-ID: <20151103012821.GA24650@obsidianresearch.com>
References: <5631839B.30300@redhat.com>
 <56318B37.20207@redhat.com>
 <20151029115114.GA18466@lst.de>
 <56360148.8060608@mellanox.com>
 <20151101180609.GC13943@kroah.com>
 <5637EFC8.4010300@redhat.com>
 <20151102233726.GA18251@kroah.com>
 <5637F97C.5090205@redhat.com>
 <20151103001845.GA24206@obsidianresearch.com>
 <56380535.5040101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56380535.5040101-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 02, 2015 at 07:52:05PM -0500, Doug Ledford wrote:
> It shouldn't be.  I reviewed those changes and they looked right (given
> the limitations).  All you needed was to boot with nopat on the kernel
> command line to get the old kernel behavior and it would continue to
> work as before, and it would print out a message telling you to do so if
> you hadn't already.

Alright, that was done after it was pretty clear the driver was
useless and I stopped looking at that part of the series. I don't know
why we made Luis jump through such hoops instead of just deleting it
right then and there.

> > For amso1100, kernel ULPs has never been its target.  Didn't we only
> > recently got any support for iWARP in iSER?

I don't like that reasoning. In 4.4 we expect some ULPs to work on
iWarp, and amso110 can't do it. That is a big reason why the driver
is getting chopped.

> > The reason I lobbied to get rid of them is specifically because they
> > don't work and maintaining them (ie the driver and the single-use ULP
> > codepath side) is a huge pain. Keeping them around and keeping them
> > compiling defeats the entire point. Just delete them, we don't need to
> > wait for 4.6.
> 
> That's not true.  User space continues to work, and amso1100 shouldn't
> be greatly negatively impacted by recent changes.  Nor should ipath.

So what if user space works? The kernel consumers are known broken.

We've commited to removing the driver from the kernel. We have support
of the driver authors to do this. We have found no users or
testers. We've committed to removing the ULP support (ie MR-only code
is being ripped out).

*WHY* spend an ounce of time fixing up code that *NO-ONE* will ever
even run? Wasted effort. Just delete them now.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
