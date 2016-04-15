From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Fri, 15 Apr 2016 16:03:40 -0600
Message-ID: <20160415220340.GB24204@obsidianresearch.com>
References: <20160414180540.GA12554@obsidianresearch.com>
 <20160414184200.GA10416@phlsvsds.ph.intel.com>
 <20160414185659.GB12997@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB041C34@ORSMSX109.amr.corp.intel.com>
 <20160414212702.GA14137@obsidianresearch.com>
 <20160415000242.GA18400@rhel.sc.intel.com>
 <20160415044124.GA16805@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0422AE@ORSMSX109.amr.corp.intel.com>
 <20160415181811.GA22322@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB042530@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB042530-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Apr 15, 2016 at 09:04:26PM +0000, Hefty, Sean wrote:
> > > If we consider a completely non-verbs device, what unrelated code
> > > and modules must be loaded for that device to export its interfaces
> > > to user space?  Force loading the infiniband stack for a non-IB
> > > device seems like the wrong approach.
> > 
> > I'm not even slightly concerned about that. This is HPC, if you care
> > about a 100k kernel module you are doing something wrong.
> 
> I wasn't referring to a software interface, but interface to the HW.
> A device like usNIC should not have to depend on ib_core and ib_mad
> because it wants to expose its interfaces up to user space.  That
> makes no sense.  I'm pretty sure that we're going to continue to
> disagree on this.

That is a kapi issue.

The problem with usnic is that it is a totally unique un-generic thing
that tried to abuse an existing uapi to get into the kernel.

qib/hfi's psm cdev interface is basically in the same boat.

The RDMA_DRIVER_OPS thing is one way to deal with expanding our
subsystem to cover a generic class of kernel-DMA-bypass devices -
especially those that don't have any sort of industry-standard or
common API.

There is no reason a future kapi couldn't support null's on the verbs
driver ops and let a driver only use RDMA_DRIVER_OPS. usnic probably
would have been a lot better off like that - make it very clear it has
nothing to do with verbs, rdma, standards, etc.

> The RDMA stack currently allows drivers to export their own
> interfaces directly to user space.

Which way do you mean?

> At this point, I see no reason why we should block a driver for
> following what has been an acceptable practice for years.  Dennis
> fixed the write/writev issue, which would make the hfi1 driver the
> only device in the RDMA tree with an acceptable interface.

Acceptable practice changes, and I feel it's been made very clear that
the subsystem is responsible for whatever insane uAPI people want to
cram into a driver.

So, now driver uapis have to be fully reviewed, and justified. cdev is
clearly not the way forward.

Plus, the 'kernel rule of threes', usnic and qib are two examples of an
ugly pattern. hfi is the third. Third person gets to refactor the
mess. Sorry.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
