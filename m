From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC ABI V2 5/8] RDMA/core: Add new ioctl interface
Date: Thu, 21 Jul 2016 02:11:56 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1607210202400.29415@east.gentwo.org>
References: <1468941812-32286-6-git-send-email-matanb@mellanox.com> <alpine.DEB.2.20.1607192021500.5828@east.gentwo.org> <53dd8337-0779-341e-49f5-ad675269bfe6@mellanox.com> <alpine.DEB.2.20.1607200448370.12616@east.gentwo.org> <20160720172143.GG21460@obsidianresearch.com>
 <alpine.DEB.2.20.1607201950160.24804@east.gentwo.org> <20160721015613.GB8279@obsidianresearch.com> <alpine.DEB.2.20.1607202132080.26260@east.gentwo.org> <20160721032803.GA12093@obsidianresearch.com> <alpine.DEB.2.20.1607202340280.26638@east.gentwo.org>
 <20160721054439.GA19329@obsidianresearch.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160721054439.GA19329-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 20 Jul 2016, Jason Gunthorpe wrote:

> > Well there is no need to do that with the standard way. The filehandle
> > identifies the driver. No need to modify strace and no need to
> > schlepp the device_id around.
>
> Nope, that isn't how strace works, strace never checks the filehandle.

Ok why would strace check a filehandle in the first place? The descriptor
is the filehandle and you can simply find the operation that created that
file descriptor to find the device it refers to.

> > We already have the security infrastructure to control access by
> > filehandle both single device and multiple device. The multiplexer device
> > will cause additional security concerns because the ioctl packet must be
> > inspected to find the device. Please do not do this.
>
> I mean in IB, we don't have the ability to securely strip a single
> port out of a device. This is why /dev/uverbs0 referes to both ports
> on a card. Adding that ability would damage API capabilities we have.

We could easily do that following naming conventions for partitions or so.
Why would doing so damage the API capabilities? Seems that they are
sufficiently screwed up already. Cleaning that up could help quite a bit.

> We already have two command multiplexor fds in the current design and
> they have exactly the security concerns you allude to. This is why we
> have a SELinux patch set under consideration because labeling dev
> nodes is not nearly enough. This is why the  namespace patches are
> incomplete, etc..

Ok then this is the opportunity to get rid of these things.

> There is no proposal to eliminate the multiplexors, I don't even know
> how that could work...

I thought I just tried to outline how that could work. Consistently use
the device semantics already provided in the kernel and use the
functionality through ioctls, fnctls etc etc as already provided.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
