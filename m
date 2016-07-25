From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC ABI V2 5/8] RDMA/core: Add new ioctl interface
Date: Mon, 25 Jul 2016 12:01:19 -0600
Message-ID: <20160725180119.GB18773@obsidianresearch.com>
References: <20160720172143.GG21460@obsidianresearch.com>
 <alpine.DEB.2.20.1607201950160.24804@east.gentwo.org>
 <20160721015613.GB8279@obsidianresearch.com>
 <alpine.DEB.2.20.1607202132080.26260@east.gentwo.org>
 <20160721032803.GA12093@obsidianresearch.com>
 <alpine.DEB.2.20.1607202340280.26638@east.gentwo.org>
 <20160721054439.GA19329@obsidianresearch.com>
 <alpine.DEB.2.20.1607210202400.29415@east.gentwo.org>
 <20160721164133.GD19849@obsidianresearch.com>
 <alpine.DEB.2.20.1607251104370.23039@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1607251104370.23039-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 25, 2016 at 11:30:48AM -0500, Christoph Lameter wrote:

> > > We could easily do that following naming conventions for partitions or so.
> > > Why would doing so damage the API capabilities? Seems that they are
> > > sufficiently screwed up already. Cleaning that up could help quite a bit.
> >
> > The current API is problematic because we try to both be like netdev
> > in that all devices are accessible (rdma_cm) and at the same with with
> > individual per-device chardevs (uverbs0).
> 
> Device? uverbs is not a device. A particular connectx3 connected to the
> pci bus is. And it should follow establish naming conventions etc. Please
> lets drop the crap that is there now. If you use the notion of a device
> the way it is designed to then we would have less issues.

device in the RDMA sense, a device has a specific set of properties
related specifically to RDMA and the libibverbs API is designed around
this notion. We can't totally get rid of it, if we change the kernel
communication then 'device' has to be emulated somehow in userspace.

I don't know what you mean by 'device the way it is designed now' -
what infrastructure are you talking about?

> > So, if you want to move fully to the per-char-dev model then I think
> > we'd give up the global netdev like behaviors, things like
> > listen(0.0.0) and output route selection, and so forth. I doubt there
> > is any support for that.
> 
> Can the official listen() syscall be made to work over
> infiniband devices? That would be best maybe?

I have no idea if this is feasible, AFAIK nobody is looking into that
option.

If we do that, then we get a fd out of the standard scheme, what is
that FD? How does it get linked back to the actual driver ioctl interface?

> I think in general one does the connection initiation via TCP and IP
> protocol regardless... So really infiniband does only matter as the
> underlying protocol over which we have imposed IP semantics via IPoIB.

No, it is mostly all done over native protocols, not IP. IP is just
used for ARP and the routing table.

> > If we go the other way to a full netdev-like module then we give up
> > fine grained (currently mildly broken) file system permissions.
> 
> Maybe go with a device semantic and not with full netdev because this is
> not a classic packet based network.

Well, what do you mean? We are emulating netdev and strongly linking
ipoib netdev devices to the RDMA infrastructure - that is the mismatch
I keep talking about.

> > You haven't explained how we can mesh the rdma_cm, netdev-like
> > listen(0.0.0.0) type semantics, continue to implement multi-port APM
> > functionality, share PDs across ports, etc, etc. These are all the
> > actual things done today that break when we drop the multiplexors.
> 
> I am not not *the* expert on this. Frankly this whole RDMA request stuff
> is not that interesting. The basic thing that the RDMA API needs to do for
> my use case is fast messaging bypassing the kernel. And having gazillion
> of special ioctls on the site is not that productive. Can we please reuse
> the standard system calls and ioctls as much as possible?

I know it is not interesting for you, but this is the majority use
model for RDMA, so it has to be the main purpose for the design.

Your DPDK-like use case really has little need for most of the RDMA
API.

> No idea what you mean by multiport "APMs". There is an obvius way to
> aggreate devices by creating a new one like done in the storage subsystem.

That APM is a special RDMA feature for fast fail over and recovery, it
has dedicated hardware support and at least with our current API
cannot be modeled with device stacking. It is functionally different
from teaming/bonding like we see in ethernet.

> Sharing PDs? Those are from the same address space using multiple devices.
> It would be natural to share that in such a case since they are more bound
> to the memory layout of a single process and not so much to the devices.
> So PDs could be per process instead of per device.

I generally agree that we got this upside down, Devices/ports should
have been created under PDs.

But the fact remains, the hardware we have is very restricted on how
PD resources can be shared between ports. Today only ports on the same
RDMA device can share a PD. That is why we have the upside down model..

So, when I talk about sharing a PD, I mean in the sense that an app
cannot just create a single PD and use that for all RDMA. It currently
needs a PD per RDMA device.

I don't know if anyone is thinking this is a pain point.

> Yes please simplify this sprawl as much as possible. Follow standard
> convention instead of reinvention things like device aggregation.

I can't help that IBTA created a different scheme for device
aggregation, addressing, and basically everything else. 'standard
convention' in the kernel really just means ethernet, and this isn't
like ethernet, except superficially.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
