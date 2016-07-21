From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC ABI V2 5/8] RDMA/core: Add new ioctl interface
Date: Thu, 21 Jul 2016 10:41:33 -0600
Message-ID: <20160721164133.GD19849@obsidianresearch.com>
References: <53dd8337-0779-341e-49f5-ad675269bfe6@mellanox.com>
 <alpine.DEB.2.20.1607200448370.12616@east.gentwo.org>
 <20160720172143.GG21460@obsidianresearch.com>
 <alpine.DEB.2.20.1607201950160.24804@east.gentwo.org>
 <20160721015613.GB8279@obsidianresearch.com>
 <alpine.DEB.2.20.1607202132080.26260@east.gentwo.org>
 <20160721032803.GA12093@obsidianresearch.com>
 <alpine.DEB.2.20.1607202340280.26638@east.gentwo.org>
 <20160721054439.GA19329@obsidianresearch.com>
 <alpine.DEB.2.20.1607210202400.29415@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1607210202400.29415-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 21, 2016 at 02:11:56AM -0500, Christoph Lameter wrote:
> On Wed, 20 Jul 2016, Jason Gunthorpe wrote:
> 
> > > Well there is no need to do that with the standard way. The filehandle
> > > identifies the driver. No need to modify strace and no need to
> > > schlepp the device_id around.
> >
> > Nope, that isn't how strace works, strace never checks the filehandle.
> 
> Ok why would strace check a filehandle in the first place? The descriptor
> is the filehandle and you can simply find the operation that created that
> file descriptor to find the device it refers to.

strace is stateless and can attach to a running process, it can't
watch for open() to figure things out. This is also why it doesn't
inspect the filehandle...

We don't *need* strace to work, but it should would be nice :|

> > I mean in IB, we don't have the ability to securely strip a single
> > port out of a device. This is why /dev/uverbs0 referes to both ports
> > on a card. Adding that ability would damage API capabilities we have.
> 
> We could easily do that following naming conventions for partitions or so.
> Why would doing so damage the API capabilities? Seems that they are
> sufficiently screwed up already. Cleaning that up could help quite a bit.

The current API is problematic because we try to both be like netdev
in that all devices are accessible (rdma_cm) and at the same with with
individual per-device chardevs (uverbs0).

The mismatch sucks and the two do not get along together as well at
they should, which leads to even more goofyness in the design of
things like rdma_cm :(

So, if you want to move fully to the per-char-dev model then I think
we'd give up the global netdev like behaviors, things like
listen(0.0.0) and output route selection, and so forth. I doubt there
is any support for that.

If we go the other way to a full netdev-like module then we give up
fine grained (currently mildly broken) file system permissions.

> > There is no proposal to eliminate the multiplexors, I don't even know
> > how that could work...
> 
> I thought I just tried to outline how that could work. Consistently use
> the device semantics already provided in the kernel and use the
> functionality through ioctls, fnctls etc etc as already provided.

You haven't explained how we can mesh the rdma_cm, netdev-like
listen(0.0.0.0) type semantics, continue to implement multi-port APM
functionality, share PDs across ports, etc, etc. These are all the
actual things done today that break when we drop the multiplexors.

This isn't a simple API that is 1:1 tied to a single physical object,
it is a sprawling thing with lots of built-in cross-device semantics. :(

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
