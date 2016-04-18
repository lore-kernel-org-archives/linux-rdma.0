From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Mon, 18 Apr 2016 11:55:59 -0600
Message-ID: <20160418175559.GC13865@obsidianresearch.com>
References: <20160414185659.GB12997@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB041C34@ORSMSX109.amr.corp.intel.com>
 <20160414212702.GA14137@obsidianresearch.com>
 <20160415000242.GA18400@rhel.sc.intel.com>
 <20160415044124.GA16805@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0422AE@ORSMSX109.amr.corp.intel.com>
 <20160415181811.GA22322@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB042530@ORSMSX109.amr.corp.intel.com>
 <20160415220340.GB24204@obsidianresearch.com>
 <20160416162203.GA6279@rhel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160416162203.GA6279@rhel>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Apr 16, 2016 at 12:22:04PM -0400, Ira Weiny wrote:
> On Fri, Apr 15, 2016 at 04:03:40PM -0600, Jason Gunthorpe wrote:
> > On Fri, Apr 15, 2016 at 09:04:26PM +0000, Hefty, Sean wrote:
> > > 
> > > I wasn't referring to a software interface, but interface to the HW.
> > > A device like usNIC should not have to depend on ib_core and ib_mad
> > > because it wants to expose its interfaces up to user space.  That
> > > makes no sense.  I'm pretty sure that we're going to continue to
> > > disagree on this.
> > 
> > That is a kapi issue.
> 
> I'm confused, how is a device wanting to expose its interface to user space a
> kapi issue?

The kapi forces all RDMA devices to implement a set of verbs function
pointers and has no way to opt out of that slice of the API. Doing
that requires linking the driver module to ib_core/ib_mad/etc and
using symbols that have no relevance to the driver.

> > There is no reason a future kapi couldn't support null's on the verbs
> > driver ops and let a driver only use RDMA_DRIVER_OPS. usnic probably
> > would have been a lot better off like that - make it very clear it has
> > nothing to do with verbs, rdma, standards, etc.
> 
> These statements conflict with your previous argument regarding the use of the
> /dev/infiniband/uverbsX devices...

It really doesn't conflict. As I keep saying, I don't really care if
uverbs is more than verbs, or not even verbs, it has *become* the uAPI
access point for the RDMA subsystem, and we are fairly stuck with the
name..

> I am still not clear what would have happened had we not exported a verbs
> device _at_ _all_.  In that case would creating a cdev even be a concern?
> Where and how would hfi1 fit into the kernel if we did not export a verbs
> interface at all?

IIRC, usnic tried other places but ended up here??

Basically, no maintainer would take a networking driver that doesn't
live in one of the networking subsystems. Drivers generally don't just
get to opt-out of the established common APIs. This is why is so
tasteless to propose a hfi1 eeprom cdev, for instance.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
