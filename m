From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Thu, 14 Apr 2016 22:41:24 -0600
Message-ID: <20160415044124.GA16805@obsidianresearch.com>
References: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
 <20160414164550.GC6247@obsidianresearch.com>
 <20160414174830.GA11641@rhel.sc.intel.com>
 <20160414180540.GA12554@obsidianresearch.com>
 <20160414184200.GA10416@phlsvsds.ph.intel.com>
 <20160414185659.GB12997@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB041C34@ORSMSX109.amr.corp.intel.com>
 <20160414212702.GA14137@obsidianresearch.com>
 <20160415000242.GA18400@rhel.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160415000242.GA18400-no5AT4YuGWKtqXYlAKuG4QC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 14, 2016 at 08:02:43PM -0400, Ira Weiny wrote:
> > A driver using this interface can retain a handle to the kernel side
> > of the uverbs (eg, it can access the idrs). This means the driver
> > interface can re-use objects created on the uverbs interface, eg a PD,
> > CQ, QP, etc, so it covers a far broader application space with code
> > re-use than an isolated cdev possibly can.
> 
> CQs and QPs will never, ever, be used by psm.  They are just not part of the
> hardware...

A common API needs to support more than only psm..

> I think if we are going to merge into a single device it should be a more
> fabric agnostic device.  Perhaps /dev/hsi (for high speed interconnect).

I'm not excited about changing the rdma_cm and uverbs char names, we
have a big investment in training and userspace around that. I'd
rather have something that does more than what its name implies,
so imagine uverbs as hfi if that helps...

> int uverbs_fd = ioctl(hsi_fd, RDMA_GET_DRIVER_OPS_FD, "verbs");
> int psm2_fd = ioctl(hsi_fd, RDMA_GET_DRIVER_OPS_FD, "psm2.intel.com");

Again the *DRIVER* word is key, it really is only for driver specific
stuff.

Interfaces promoted to core may as well just be ioctls on the master
fd. The drivers benefit from another fd because it allows conflicting
ioctl/mmap/readv, but the core code would not have such needs. Is
there a strong reason to have another fd?

I see no big problem with somewhat orthogonal interfaces as groups of
ioctls on the same fd. libfabric shows that is basically a workable
model. Sharing security/discovery/etc is a reasonable enough commonality.

> int uverbs2_fd = ioctl(hsi_fd, RDMA_GET_DRIVER_OPS_FD, "verbs2.0");

We don't really need to do that since we can just add the new ioctls
directly to the fd.

> > Maybe 'psm.intel.com' was a bad choice, but I wanted to be clear this
> > wasn't a dumping ground for any and all driver crap (like eeprom,
> > etc). Just the high speed focused API. Perhaps 'sdma.intel.com' or
> > something?

> I think psm.intel.com is appropriate.  sdma is different.

Well, except, it doesn't seem to do psm. The 12 ioctls don't seem to
look anything like psm from what I can tell. They are used to build
psm in user space, but somehow I suspect they could build lots of
different things???

> This proposal also gives us time to get the verbs2.0 interface baked while the
> existing /dev/infiniband/* interfaces are still present.

I don't see a problem upgrading in place. 

Jason

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
