From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Fri, 15 Apr 2016 12:18:11 -0600
Message-ID: <20160415181811.GA22322@obsidianresearch.com>
References: <20160414164550.GC6247@obsidianresearch.com>
 <20160414174830.GA11641@rhel.sc.intel.com>
 <20160414180540.GA12554@obsidianresearch.com>
 <20160414184200.GA10416@phlsvsds.ph.intel.com>
 <20160414185659.GB12997@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB041C34@ORSMSX109.amr.corp.intel.com>
 <20160414212702.GA14137@obsidianresearch.com>
 <20160415000242.GA18400@rhel.sc.intel.com>
 <20160415044124.GA16805@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0422AE@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0422AE-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Apr 15, 2016 at 05:30:03PM +0000, Hefty, Sean wrote:
> > I'm not excited about changing the rdma_cm and uverbs char names, we
> > have a big investment in training and userspace around that. I'd
> > rather have something that does more than what its name implies,
> > so imagine uverbs as hfi if that helps...
> 
> Changing from write to ioctl breaks everything.  IMO, a name change
> hardly matters, and makes it trivial to see which interface should
> be used.

No, the dev name is sysadmin visible, the ioctl vs write choice is
invisible.

We have a big investment in training sysadmins on the security model
around /dev/uverbs particularly, deployment of udev rules, distro
setups, etc. Needlessly changing that name means work for sysadmins.

We should not change it for trivial reasons.

> > > int uverbs_fd = ioctl(hsi_fd, RDMA_GET_DRIVER_OPS_FD, "verbs");
> > > int psm2_fd = ioctl(hsi_fd, RDMA_GET_DRIVER_OPS_FD, "psm2.intel.com");
> > 
> > Again the *DRIVER* word is key, it really is only for driver specific
> > stuff.
> 
> One _could_ argue that this should be
> "verbs.[device|vendor|technology]", since we ultimately end up
> dropping into device specific calls, and this just changes where the
> multiplexing is done.

That feels like it would be horrible for the user space side? Every
ioctl site needs a switch statement for all the possibilities?

How would the existing code sharing work on the kernel side?

Hurm, I don't know - the only other 'APIs' I can thing of using a
techinque like this are Web focused ones, (eg HTTP UPGRADE and others)
and I have very little idea on the good/bads over time in that space.

One plus side I guess is it is an obvious place to put request_module,
which is something our subsystem has historically been lacking.

The driver bypass fd was a technique I came up with specifically to
deal with the qib/hfi issue.. IMHO, it is ugly, but the problem is
also very ugly, so maybe it is OK. It is less ugly than every driver
having a dedicated cdev..

> > I see no big problem with somewhat orthogonal interfaces as groups of
> > ioctls on the same fd. libfabric shows that is basically a workable
> > model. Sharing security/discovery/etc is a reasonable enough commonality.
> 
> If we consider a completely non-verbs device, what unrelated code
> and modules must be loaded for that device to export its interfaces
> to user space?  Force loading the infiniband stack for a non-IB
> device seems like the wrong approach.

I'm not even slightly concerned about that. This is HPC, if you care
about a 100k kernel module you are doing something wrong.

If someone really cares then design a CONFIG option to compile out the
stuff they don't want.

And again.. The non-verbs community hasn't really standardized on
*anything* hardware facing. It is just impossible, as a kernel
community to have any rational discussion on what to provide as a
common API when we have no idea what even the requirements are.

The two banner non-verbs hardwares (usNIC and qib/hfi) seem *totally*
different and, perhaps tellingly, currently, don't need the kernel do
anything beyond administrate secure access to some proprietary
hardware.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
