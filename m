From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Thu, 14 Apr 2016 20:02:43 -0400
Message-ID: <20160415000242.GA18400@rhel.sc.intel.com>
References: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
 <20160414164550.GC6247@obsidianresearch.com>
 <20160414174830.GA11641@rhel.sc.intel.com>
 <20160414180540.GA12554@obsidianresearch.com>
 <20160414184200.GA10416@phlsvsds.ph.intel.com>
 <20160414185659.GB12997@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB041C34@ORSMSX109.amr.corp.intel.com>
 <20160414212702.GA14137@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160414212702.GA14137-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 14, 2016 at 03:27:02PM -0600, Jason Gunthorpe wrote:
> On Thu, Apr 14, 2016 at 08:01:30PM +0000, Hefty, Sean wrote:
> > Dropping to just linux-rdma list for a more details uABI discussion
> > 
> > > As for the 'one char device', I actually think it would be really
> > > simple.
> > > 
> > > Add a new uverbs ioctl:
> > > 
> > >  int hfi1_fd = ioctl(uverbs_fd, RDMA_GET_DRIVER_OPS_FD, "psm2.intel.com");
> > > 
> > >  ioctl(hfi1_fd, HFI1_IOCTL_ASSIGN_CTXT, ...);
> > >  write(hfi1_fd, ...);
> > > 
> > > At least that gives us far better options for discovery and versioning
> > > of this stuff than a driver-specific char device.
> > 
> > I think it would help the discussion if the advantages/disadvantages
> > of this approach were described over just opening a driver specific
> > file.
> 
> This gives us a very easy way to associate a driver specific FD with
> RDMA device in the kernel, using the common discovery/id/naming
> scheme.
> 
> It lets drivers support multiple interfaces, so we get better ABI
> control and an easier way to migrate ABIs (eg qib to hfi1). It even
> handles this change hfi1/qib are about to do without requiring more
> syfs files, just request the new name and fall back to the old name if
> it fails.
> 
> It doesn't have the problem of what happens when *old* user space
> opens the *new* cdev - eg that seems like it will blow up with the
> proposed hfi1 patches.
> 
> We don't have to create a universe of unique char devices with all the
> related complexity: that includes permissions, selinux, and
> namespaces/containers. If you can access uverbs then you can access
> the driver ops too. This uniform permission model is already
> implemented by the large user space stack and distros.
> 
> A driver using this interface can retain a handle to the kernel side
> of the uverbs (eg, it can access the idrs). This means the driver
> interface can re-use objects created on the uverbs interface, eg a PD,
> CQ, QP, etc, so it covers a far broader application space with code
> re-use than an isolated cdev possibly can.

CQs and QPs will never, ever, be used by psm.  They are just not part of the
hardware...

> 
> On the other hand, I can think of no benefit to a driver specific
> /dev/ node. (this idea that 'psm' is somehow unrelated to the RDMA
> subsystem, and deserving its own cdev is silly)
> 
> > Because trying to form an application interface that's the
> > union of hardware interfaces seems problematic.  We _may_ be better
> > thinking in terms if an Infiniband Core + iWarp Core + PSM Core
> > (with appropriate code re-use between them), than viewing the entire
> > world as RDMA Core.
> 
> We have at least tried to merge rocee/ib/iwarp into a common API based
> upon their multi-vendor standards. That is what one calls the RDMA
> core.

The difference here is that roce/ib/iwarp were all QP based devices with very
similar semantics.

Following on Seans idea.

I think if we are going to merge into a single device it should be a more
fabric agnostic device.  Perhaps /dev/hsi (for high speed interconnect).

>From there we could use what you are proposing for a truly device agnostic
interface.  Those devices which export both verbs and psm would result in both
of these calls working.

int uverbs_fd = ioctl(hsi_fd, RDMA_GET_DRIVER_OPS_FD, "verbs");
int psm2_fd = ioctl(hsi_fd, RDMA_GET_DRIVER_OPS_FD, "psm2.intel.com");

If/when we define commonalities we can define a common interface and export
that or better yet just promote those to the hsi_fd directly.

Features, once vetted, can be promoted.

We could even start out with a second verbs interface to try things out.

int uverbs2_fd = ioctl(hsi_fd, RDMA_GET_DRIVER_OPS_FD, "verbs2.0");

> 
> I have no personal problem with adding more well defined things to the
> core, even if it doesn't strongly overlap the existing stuff.
> 
> However, that doesn't describe PSM. There is no PSM kernel uAPI
> interface.  The existing things are very low level hardware specific
> accelerator upcalls that seem to be used to cobble together the
> 'common' PSM interface in userspace. The only two pieces of hardware
> to implement PSM do not even use the same kernel API, seemingly by
> design.
> 
> Hardly something we can talk about as 'core'. This is the very
> definition of driver specific.
> 
> So what is needed here is the best way we can design to access those
> calls. I called it RDMA_GET_DRIVER_OPS_FD for a reason. *driver*
> specific calls. Userspace has to sort out the mess, and the uAPI
> driver specific facet naturally retires when the driver becomes
> disused.
> 
> Maybe 'psm.intel.com' was a bad choice, but I wanted to be clear this
> wasn't a dumping ground for any and all driver crap (like eeprom,
> etc). Just the high speed focused API. Perhaps 'sdma.intel.com' or
> something?
> 

I think psm.intel.com is appropriate.  sdma is different.

> > I say may because I haven't thought through the details.  But from a
> > high level, the IB core and PSM core appear to have basically no
> > overlap.
> 
> They overlap in device discovery, access control, hot plug/unplug and
> other boring core things. Just because the data motion is totally
> different doesn't mean they benefit at all from being apart.
> 
> If someone wants to define a set of PSM APIs and propose them as
> uverbs ioctls, then go for it.

This is part of the problem; PSM != verbs.

That is why I think it is most appropriate to have a separate set of ioctls.

This proposal also gives us time to get the verbs2.0 interface baked while the
existing /dev/infiniband/* interfaces are still present.

Ira

> 
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
