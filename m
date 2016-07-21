From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC ABI V2 5/8] RDMA/core: Add new ioctl interface
Date: Wed, 20 Jul 2016 21:28:03 -0600
Message-ID: <20160721032803.GA12093@obsidianresearch.com>
References: <1468941812-32286-1-git-send-email-matanb@mellanox.com>
 <1468941812-32286-6-git-send-email-matanb@mellanox.com>
 <alpine.DEB.2.20.1607192021500.5828@east.gentwo.org>
 <53dd8337-0779-341e-49f5-ad675269bfe6@mellanox.com>
 <alpine.DEB.2.20.1607200448370.12616@east.gentwo.org>
 <20160720172143.GG21460@obsidianresearch.com>
 <alpine.DEB.2.20.1607201950160.24804@east.gentwo.org>
 <20160721015613.GB8279@obsidianresearch.com>
 <alpine.DEB.2.20.1607202132080.26260@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1607202132080.26260-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 20, 2016 at 09:41:34PM -0500, Christoph Lameter wrote:
> On Wed, 20 Jul 2016, Jason Gunthorpe wrote:
> 
> > >
> > > But you already have that uniqueness if the ioctl filehandle provides
> > > that.
> >
> > The argument is that ioctls should be self-describing and never rely
> > on the filehandle to uniq them. That is basically standard in the
> > kernel, and why we have Documentation/ioctl/ioctl-number.txt
> > describing how to uniquely assign ioctl numbers.
> 
> Fully agree with that. But this statement does not relate to what we
> were talking about. So I guess I need to restate it one more time:

> device_id is useless if the driver is already determined by the device filehanle.

It isn't useless, it preserves the self describing property that is
the kernel standard for ioctls.

The filehandle major/minor will never uniquely describe the device, we
are not going to give mlx4,mlx5, etc unique major/minor numbers. Yes,
the kernel always implicitly knows what device driver the ioctl will
be delivered to.

But the kernel has that implicit knowledge for ioctls as well and we
still go through the trouble in Documentation/ioctl/ioctl-number.txt
to make them globally unique. device_id is exactly the same thing.

In otherwords, we are going to do something like this:

arg.driver_id = MLX4;
arg.driver_op = MLX4_FROBNICATE;
ioctl(IB_DRIVER_DO_SOMETHING,arg);

Something like strace looks at this and sees
IB_DRIVER_DO_SOMETHING,driver_id,driver_op and knows excatly how to
parse arg (struct mlx4_op_frobincate).

And it can tell it apart from this:

arg.driver_id = MLX5;
arg.driver_op = MLX5_BROBNICATE;
ioctl(IB_DRIVER_DO_SOMETHING,arg);

Which would have a different layout for arg.

Which is *exactly* what you expect for ioctl, and is the basic kernel
standard.

Think of driver_id and driver_op as being a 32 bit globally unique
value assigned to every driver function, run under the
IB_DRIVER_DO_SOMETHING multiplexor.

> > Some do, some don't. The rdma_cm requirement is more like
> > listen(0.0.0.0) which does not require special net device aggregation.
> 
> Well that concept is for a packetized protocol stack. In that kind of a
> system packets can be routed over multiple devices depending on the
> address. We do not have that in the IB stack.

We do have routing, RDMA_CM does it. Only once the connection is
established does it crystalize into specific hardware, which is
basically the same process as the net stack, rdma_cm uses the same
routing table functions to determine the RDMA device to route the QP
too, which is part of the problem with having things spread across all
these distinct FDs. They don't coorporate like they need to.

.. and there is also the issue of namespaces :| People want RDMA
namespaces, which I think really clouds how these per-device file
descriptors would sanely work, esepcially with the separate RDMA CM
fd.

> > /dev/pts/ptmx, /dev/mapper/control, /dev/btrfs-control, etc, etc are
> > all examples of multi-device control fds similar to the proposed
> > single char dev.
> 
> Yes but those are not used for communications. They are used to control a
> subsystem and access to those requires special priviledges. We are talking
> about a device accessible witout special priviledges to do data
> communications. /dev/rdmaXXXX to control global behavior of the stack
> for all processes would be fine. But we are controlling the interaction of
> a process with a device.

Eh? btrfs-control is mutliplexed across all mounted block devices used
by BTRFS, I wouldn't say it is any different than what we are talking
about with rdma.

Do you have an actual use for the currently somewhat broken fine-grained
permissions we have with uverbs0 ?

The only people a single char dev really impacts are users with
multiple cards, and I think that is fairly rare..

> > .. and bear in mind that /dev/uverbs0 doesn't even really make that
> > much sense as it aggregates two physical ports. There is already no
> > way to split permissions up by port, which is a logical thing to want
> > for some dual-rail configurations.
> 
> Right lets get rid of it. device specific files only.

There is a good reason why we bundle ports together - that is part of
how the IN spec works for PDs, APM and connection management. It is
not something we should throw away.

Even if we wanted to we just don't have the overall infrastructure to
restrict on a port by port basis (SELinux should ultimately fix that,
but SELinux will work the same in both single and multi char dev models)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
