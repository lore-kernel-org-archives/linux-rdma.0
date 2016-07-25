From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC ABI V2 5/8] RDMA/core: Add new ioctl interface
Date: Mon, 25 Jul 2016 11:30:48 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1607251104370.23039@east.gentwo.org>
References: <53dd8337-0779-341e-49f5-ad675269bfe6@mellanox.com> <alpine.DEB.2.20.1607200448370.12616@east.gentwo.org> <20160720172143.GG21460@obsidianresearch.com> <alpine.DEB.2.20.1607201950160.24804@east.gentwo.org> <20160721015613.GB8279@obsidianresearch.com>
 <alpine.DEB.2.20.1607202132080.26260@east.gentwo.org> <20160721032803.GA12093@obsidianresearch.com> <alpine.DEB.2.20.1607202340280.26638@east.gentwo.org> <20160721054439.GA19329@obsidianresearch.com> <alpine.DEB.2.20.1607210202400.29415@east.gentwo.org>
 <20160721164133.GD19849@obsidianresearch.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160721164133.GD19849-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 21 Jul 2016, Jason Gunthorpe wrote:

> > Ok why would strace check a filehandle in the first place? The descriptor
> > is the filehandle and you can simply find the operation that created that
> > file descriptor to find the device it refers to.
>
> strace is stateless and can attach to a running process, it can't
> watch for open() to figure things out. This is also why it doesn't
> inspect the filehandle...

Well you can still lookup in the file handle in /proc/pid/.... if you want
that. Not sure why you are so focused on this.

> We don't *need* strace to work, but it should would be nice :|

It *is* nice. And it works fine for devices. Lets ensure that devices
are used in a standard way in the IB subsystem so that we can take full
advantage of the syscall infrastructure and the standard system calls.

> > We could easily do that following naming conventions for partitions or so.
> > Why would doing so damage the API capabilities? Seems that they are
> > sufficiently screwed up already. Cleaning that up could help quite a bit.
>
> The current API is problematic because we try to both be like netdev
> in that all devices are accessible (rdma_cm) and at the same with with
> individual per-device chardevs (uverbs0).

Device? uverbs is not a device. A particular connectx3 connected to the
pci bus is. And it should follow establish naming conventions etc. Please
lets drop the crap that is there now. If you use the notion of a device
the way it is designed to then we would have less issues.

> So, if you want to move fully to the per-char-dev model then I think
> we'd give up the global netdev like behaviors, things like
> listen(0.0.0) and output route selection, and so forth. I doubt there
> is any support for that.

Can the official listen() syscall be made to work over
infiniband devices? That would be best maybe?

I think in general one does the connection initiation via TCP and IP
protocol regardless... So really infiniband does only matter as the
underlying protocol over which we have imposed IP semantics via IPoIB.

> If we go the other way to a full netdev-like module then we give up
> fine grained (currently mildly broken) file system permissions.

Maybe go with a device semantic and not with full netdev because this is
not a classic packet based network.

> You haven't explained how we can mesh the rdma_cm, netdev-like
> listen(0.0.0.0) type semantics, continue to implement multi-port APM
> functionality, share PDs across ports, etc, etc. These are all the
> actual things done today that break when we drop the multiplexors.

I am not not *the* expert on this. Frankly this whole RDMA request stuff
is not that interesting. The basic thing that the RDMA API needs to do for
my use case is fast messaging bypassing the kernel. And having gazillion
of special ioctls on the site is not that productive. Can we please reuse
the standard system calls and ioctls as much as possible?

No idea what you mean by multiport "APMs". There is an obvius way to
aggreate devices by creating a new one like done in the storage subsystem.

Sharing PDs? Those are from the same address space using multiple devices.
It would be natural to share that in such a case since they are more bound
to the memory layout of a single process and not so much to the devices.
So PDs could be per process instead of per device.

> This isn't a simple API that is 1:1 tied to a single physical object,
> it is a sprawling thing with lots of built-in cross-device semantics. :(

Yes please simplify this sprawl as much as possible. Follow standard
convention instead of reinvention things like device aggregation.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
