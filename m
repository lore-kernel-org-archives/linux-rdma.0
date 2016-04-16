From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Sat, 16 Apr 2016 12:22:04 -0400
Message-ID: <20160416162203.GA6279@rhel>
References: <20160414184200.GA10416@phlsvsds.ph.intel.com>
 <20160414185659.GB12997@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB041C34@ORSMSX109.amr.corp.intel.com>
 <20160414212702.GA14137@obsidianresearch.com>
 <20160415000242.GA18400@rhel.sc.intel.com>
 <20160415044124.GA16805@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0422AE@ORSMSX109.amr.corp.intel.com>
 <20160415181811.GA22322@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB042530@ORSMSX109.amr.corp.intel.com>
 <20160415220340.GB24204@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160415220340.GB24204-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Apr 15, 2016 at 04:03:40PM -0600, Jason Gunthorpe wrote:
> On Fri, Apr 15, 2016 at 09:04:26PM +0000, Hefty, Sean wrote:
> > 
> > I wasn't referring to a software interface, but interface to the HW.
> > A device like usNIC should not have to depend on ib_core and ib_mad
> > because it wants to expose its interfaces up to user space.  That
> > makes no sense.  I'm pretty sure that we're going to continue to
> > disagree on this.
> 
> That is a kapi issue.

I'm confused, how is a device wanting to expose its interface to user space a
kapi issue?

> 
> The problem with usnic is that it is a totally unique un-generic thing
> that tried to abuse an existing uapi to get into the kernel.
> 
> qib/hfi's psm cdev interface is basically in the same boat.

I really did not track the usnic additions but I don't see how we have _abused_
any uapi?

Recognizing that PSM != Verbs, we have exported a new uAPI which directly
access our PSM specific hardware.  With the exception of the write/writev issue
(which this series fixes); How is creating a char device abusing an existing
uapi?

> 
> The RDMA_DRIVER_OPS thing is one way to deal with expanding our
> subsystem to cover a generic class of kernel-DMA-bypass devices -
> especially those that don't have any sort of industry-standard or
> common API.
> 
> There is no reason a future kapi couldn't support null's on the verbs
> driver ops and let a driver only use RDMA_DRIVER_OPS. usnic probably
> would have been a lot better off like that - make it very clear it has
> nothing to do with verbs, rdma, standards, etc.

These statements conflict with your previous argument regarding the use of the
/dev/infiniband/uverbsX devices...

How can it be __clear__ that a device has "nothing to do with verbs, rdma,
standards, etc.", when the device the user is opening is called

/dev/infiniband/uverbsX

?

To me opening /dev/hfi1_X is pretty clear that this is not an infiniband nor a
verbs interface...

I think you make a _lot_ of _good_ points regarding the use of a common cdev.
I also recognize the pragmatism of using /dev/infiniband/uverbsX.

However, I think we need to be honest with ourselves about what your proposal
does.

I am still not clear what would have happened had we not exported a verbs
device _at_ _all_.  In that case would creating a cdev even be a concern?
Where and how would hfi1 fit into the kernel if we did not export a verbs
interface at all?

I truely don't know the answer to these questions.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
