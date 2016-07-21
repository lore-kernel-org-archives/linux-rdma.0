From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC ABI V2 5/8] RDMA/core: Add new ioctl interface
Date: Wed, 20 Jul 2016 23:44:39 -0600
Message-ID: <20160721054439.GA19329@obsidianresearch.com>
References: <1468941812-32286-6-git-send-email-matanb@mellanox.com>
 <alpine.DEB.2.20.1607192021500.5828@east.gentwo.org>
 <53dd8337-0779-341e-49f5-ad675269bfe6@mellanox.com>
 <alpine.DEB.2.20.1607200448370.12616@east.gentwo.org>
 <20160720172143.GG21460@obsidianresearch.com>
 <alpine.DEB.2.20.1607201950160.24804@east.gentwo.org>
 <20160721015613.GB8279@obsidianresearch.com>
 <alpine.DEB.2.20.1607202132080.26260@east.gentwo.org>
 <20160721032803.GA12093@obsidianresearch.com>
 <alpine.DEB.2.20.1607202340280.26638@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1607202340280.26638-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 21, 2016 at 12:00:34AM -0500, Christoph Lameter wrote:
> On Wed, 20 Jul 2016, Jason Gunthorpe wrote:
> 
> > > device_id is useless if the driver is already determined by the device filehanle.
> >
> > It isn't useless, it preserves the self describing property that is
> > the kernel standard for ioctls.
> 
> What? Never heard about that and certainly do not see that in the ioctls I
> have used. Something like the device is specified on on some special
> sockets that control network stack behavior and other control files.

How many ioctls have you used that use a complex variable sized struct
as the parameter?

There are a few and they ones I've used are self-describing one way or
another. Perhaps they have an op code or something in the struct, or a
netlink-like format, or *something* but you don't need to know what
the fd is connected to in order to parse the struct. The ioctl # and
the argument should be enough to parse.

> > But the kernel has that implicit knowledge for ioctls as well and we
> >
> > arg.driver_id = MLX4;
> > arg.driver_op = MLX4_FROBNICATE;
> > ioctl(IB_DRIVER_DO_SOMETHING,arg);
> 
> Uhhh.. The first argument to ioctl specifies the device!!! The
> established way of doing things would be:

Yeah, I dropped it for brevity, because it doesn't really matter, we
all know ioctls work on fds...

> Well there is no need to do that with the standard way. The filehandle
> identifies the driver. No need to modify strace and no need to
> schlepp the device_id around.

Nope, that isn't how strace works, strace never checks the filehandle.

> > We do have routing, RDMA_CM does it. Only once the connection is
> > established does it crystalize into specific hardware, which is
> > basically the same process as the net stack, rdma_cm uses the same
> > routing table functions to determine the RDMA device to route the QP
> > too, which is part of the problem with having things spread across all
> > these distinct FDs. They don't coorporate like they need to.
> 
> OMG. And now we are adding vendor specific extensions. This is going to be
> great fun to use. Case statements for vendor specific extension after we
> have figured out which device to use?

There won't be case statements.

You are really surprised by the rdma_cm architecture??? I know it is
goofy, but we are stuck with it..

.. and we have been doing the un-described structs like you are asking
for today. libmlx4 just assumes the fd it is talking to is a mlx4
driver (because sysfs said so) and jams in untagged driver-specific
structs to the command flow. strace cannot parse them and there is no
kernel support for debugging or accidental misuse..

Adding a little tag to the driver specific struct seems totally
harmless, every iteration of the various proposals has had some kind
of struct tag one way or another. I don't know what you see strange
about this.

> Namespaces already work for filehandles and always have. Look how devices
> are handled in different namespaces.

People want to put different ports in different name spaces, the
uverbs fd is a full device thing, it doesn't work and doesn't make
sense as the namespace control point.

Heck, people want to put certain pkeys into namespaces.

The char dev alone is totally unsuitable for the namespace needs.

> Also the filehandle trivially allows security subsystems to monitor the
> usage of a device. One can identify all processes using one RDMA device
> that may be going down etc etc.

Not really, you can have rdma_cm things open listening that don't use
uverbs until a connection is triggered. Perhaps that is rare though.

> We already have the security infrastructure to control access by
> filehandle both single device and multiple device. The multiplexer device
> will cause additional security concerns because the ioctl packet must be
> inspected to find the device. Please do not do this.

I mean in IB, we don't have the ability to securely strip a single
port out of a device. This is why /dev/uverbs0 referes to both ports
on a card. Adding that ability would damage API capabilities we have.

We already have two command multiplexor fds in the current design and
they have exactly the security concerns you allude to. This is why we
have a SELinux patch set under consideration because labeling dev
nodes is not nearly enough. This is why the  namespace patches are
incomplete, etc..

There is no proposal to eliminate the multiplexors, I don't even know
how that could work...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
