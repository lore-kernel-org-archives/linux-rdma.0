From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC ABI V2 5/8] RDMA/core: Add new ioctl interface
Date: Wed, 20 Jul 2016 19:57:09 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1607201950160.24804@east.gentwo.org>
References: <1468941812-32286-1-git-send-email-matanb@mellanox.com> <1468941812-32286-6-git-send-email-matanb@mellanox.com> <alpine.DEB.2.20.1607192021500.5828@east.gentwo.org> <53dd8337-0779-341e-49f5-ad675269bfe6@mellanox.com> <alpine.DEB.2.20.1607200448370.12616@east.gentwo.org>
 <20160720172143.GG21460@obsidianresearch.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160720172143.GG21460-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 20 Jul 2016, Jason Gunthorpe wrote:

> > You specify the driver_id in the ioctl data structure. The driver in an
> > ioctl is specified by the descriptor. strace etc would have an easier time
> > if we would follow the standard conventions for devices and not add
> > another device_id somewhere.
>
> There isn't enough ioctl #'s for that. We probably need something like
> over 500 ioctls by the time we are done all the drivers and
> interfaces.. There is only about 100 reserved for RDMA today, and the
> ioctl space is looking pretty full to steal another 4 blocks.

That sounds crazy. Surely there is a way to reduce that number.

> So the basic proposal is to use only a small number of ioctls and
> have an 'extended ioctl #' in the struct.

Ok then you already have much less.

> The device_id part of the extension allows each driver to have its own
> globally unique number space without requireing another ioctl block.

But you already have that uniqueness if the ioctl filehandle provides
that.

> > Why would there be an issue of sharing data between multiple descriptors?
> > Data could be a subsystem specific state and not device specific if you
> > want to share.
>
> The state should be fd specific.

I think that is what we want. Driver specific ioctls and driver specific
types. If you want subsystem wide types then something special would have
to happen permissions wise.

> > Why do you need that information a second time if the descriptor already
> > provides the device information?
>
> Because the descriptor only indirectly implies a specific device.

If you require specify a device on ioctl then it will directly indicate
the device you are using. AFAICT this is the way its supposed to be.

> > and then run ioctls on that file to configure the device. That is very
> > similar to the traditional use of ioctls. Security for each device can be
> > controlled separately without inspecting the data being passed
> > (which
>
> It turns out that doesn't work today anyhow, since we have
> multi-device requirements in the rdma_cm and you end up with a rdma_cm
> descriptor that is world accessible and can interact with the network
> even without device permissions.

multi-device requirements in the network code require a new device that
aggregates the other ones. The aggregation device is not world accessible.
The same approach could be used for RDMA.

> > would require modifications to the security code). strace and
> > other tools would just natively know that the descriptor refers to a device.
>
> No, strace doesn't know what an open FD is, it just inspects the ioctl
> # and content to do its decode. Requiring strace to decode differently
> depending on what was opened would be the deviation from what we do
> today.

It is the  basic Unix convention to have a descriptor/file handle refer to
a device. There is nothing special required here from strace.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
