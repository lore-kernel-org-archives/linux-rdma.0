From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC ABI V2 5/8] RDMA/core: Add new ioctl interface
Date: Thu, 21 Jul 2016 00:00:34 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1607202340280.26638@east.gentwo.org>
References: <1468941812-32286-1-git-send-email-matanb@mellanox.com> <1468941812-32286-6-git-send-email-matanb@mellanox.com> <alpine.DEB.2.20.1607192021500.5828@east.gentwo.org> <53dd8337-0779-341e-49f5-ad675269bfe6@mellanox.com> <alpine.DEB.2.20.1607200448370.12616@east.gentwo.org>
 <20160720172143.GG21460@obsidianresearch.com> <alpine.DEB.2.20.1607201950160.24804@east.gentwo.org> <20160721015613.GB8279@obsidianresearch.com> <alpine.DEB.2.20.1607202132080.26260@east.gentwo.org> <20160721032803.GA12093@obsidianresearch.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160721032803.GA12093-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 20 Jul 2016, Jason Gunthorpe wrote:

> > device_id is useless if the driver is already determined by the device filehanle.
>
> It isn't useless, it preserves the self describing property that is
> the kernel standard for ioctls.

What? Never heard about that and certainly do not see that in the ioctls I
have used. Something like the device is specified on on some special
sockets that control network stack behavior and other control files.

> But the kernel has that implicit knowledge for ioctls as well and we
> still go through the trouble in Documentation/ioctl/ioctl-number.txt
> to make them globally unique. device_id is exactly the same thing.

Nope. device_id is not part of the ioctl number. The uniqueness only
applies to the functionality requested from the device. Please do not mix
that up with device identification.


> In otherwords, we are going to do something like this:
>
> arg.driver_id = MLX4;
> arg.driver_op = MLX4_FROBNICATE;
> ioctl(IB_DRIVER_DO_SOMETHING,arg);

Uhhh.. The first argument to ioctl specifies the device!!! The
established way of doing things would be:

f = open("/dev/rdma/mlx5_0")

err = ioctl(f, IOCTL_RDMA_DO_SOMETHING, parameters)

>> Something like strace looks at this and sees
> IB_DRIVER_DO_SOMETHING,driver_id,driver_op and knows excatly how to
> parse arg (struct mlx4_op_frobincate).

Well there is no need to do that with the standard way. The filehandle
identifies the driver. No need to modify strace and no need to
schlepp the device_id around.


> And it can tell it apart from this:
>
> arg.driver_id = MLX5;
> arg.driver_op = MLX5_BROBNICATE;
> ioctl(IB_DRIVER_DO_SOMETHING,arg);
>
> Which would have a different layout for arg.
>
> Which is *exactly* what you expect for ioctl, and is the basic kernel
> standard.

I am sorry but ioctl really has a device parameter the first one. ioctls
without specifying a device do not exist as you seem to assume here.
Please read the manpage.


> Think of driver_id and driver_op as being a 32 bit globally unique
> value assigned to every driver function, run under the
> IB_DRIVER_DO_SOMETHING multiplexor.

No multiplexer please. Lets operate on the device specified.

> > Well that concept is for a packetized protocol stack. In that kind of a
> > system packets can be routed over multiple devices depending on the
> > address. We do not have that in the IB stack.
>
> We do have routing, RDMA_CM does it. Only once the connection is
> established does it crystalize into specific hardware, which is
> basically the same process as the net stack, rdma_cm uses the same
> routing table functions to determine the RDMA device to route the QP
> too, which is part of the problem with having things spread across all
> these distinct FDs. They don't coorporate like they need to.

OMG. And now we are adding vendor specific extensions. This is going to be
great fun to use. Case statements for vendor specific extension after we
have figured out which device to use?

Trivially the routing function could return a filehandle to use

> .. and there is also the issue of namespaces :| People want RDMA
> namespaces, which I think really clouds how these per-device file
> descriptors would sanely work, esepcially with the separate RDMA CM
> fd.

Namespaces already work for filehandles and always have. Look how devices
are handled in different namespaces.

> > > /dev/pts/ptmx, /dev/mapper/control, /dev/btrfs-control, etc, etc are
> > > all examples of multi-device control fds similar to the proposed
> > > single char dev.
> >
> > Yes but those are not used for communications. They are used to control a
> > subsystem and access to those requires special priviledges. We are talking
> > about a device accessible witout special priviledges to do data
> > communications. /dev/rdmaXXXX to control global behavior of the stack
> > for all processes would be fine. But we are controlling the interaction of
> > a process with a device.
>
> Eh? btrfs-control is mutliplexed across all mounted block devices used
> by BTRFS, I wouldn't say it is any different than what we are talking
> about with rdma.

But this is used to modify the operations of btrfs and do administration.
We are discussing here an endpoint establishing connections and
configurations specific to an application.

> Do you have an actual use for the currently somewhat broken fine-grained
> permissions we have with uverbs0 ?

Well a file exposed to one namespace and not another comes to mind.

A system may have multiple RDMA adapters and you want one application
running under one userid to have access to one and not the other. The
system may run a variety of more or less trustworthy apps and you would
like to restrict access. This is not possible with the existing scheme.

Also the filehandle trivially allows security subsystems to monitor the
usage of a device. One can identify all processes using one RDMA device
that may be going down etc etc.

> The only people a single char dev really impacts are users with
> multiple cards, and I think that is fairly rare..

Hmmm.... This is not rare here. We have both Ethernet RDMA and IB RDMA
devices (and sometimes multiple) in our systems.

> > Right lets get rid of it. device specific files only.
>
> There is a good reason why we bundle ports together - that is part of
> how the IN spec works for PDs, APM and connection management. It is
> not something we should throw away.

Ok what do those terms mean?

> Even if we wanted to we just don't have the overall infrastructure to
> restrict on a port by port basis (SELinux should ultimately fix that,
> but SELinux will work the same in both single and multi char dev models)

We already have the security infrastructure to control access by
filehandle both single device and multiple device. The multiplexer device
will cause additional security concerns because the ioctl packet must be
inspected to find the device. Please do not do this.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
