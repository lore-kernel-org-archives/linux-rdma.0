From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC ABI V2 5/8] RDMA/core: Add new ioctl interface
Date: Wed, 20 Jul 2016 19:38:46 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1607201934090.24483@east.gentwo.org>
References: <1468941812-32286-1-git-send-email-matanb@mellanox.com> <1468941812-32286-6-git-send-email-matanb@mellanox.com> <alpine.DEB.2.20.1607192021500.5828@east.gentwo.org> <53dd8337-0779-341e-49f5-ad675269bfe6@mellanox.com> <alpine.DEB.2.20.1607200448370.12616@east.gentwo.org>
 <0fc727fd-bc35-b2bd-f4a7-04efd937d4c3@mellanox.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0fc727fd-bc35-b2bd-f4a7-04efd937d4c3-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 20 Jul 2016, Matan Barak wrote:

> If you use only one file (ie rdma_uapi), how will strace know which internal
> RDMA device is used?
> It'll need to same some bits for the entire session to figure that out.

Yes I thought that was the current approach? I do not like that approach.

> Currently uverbs and rdma-cm IDRs are separated. If we would like to introduce
> a semantics where rdma-cm opens the device (and maybe even access the device's
> objects) it needs to somehow share ids with the ib_dev context.
> So do you suggest that rdma-cm will get a fd and open the required device on
> this fd while returning a handle bounded to this fd (you still need to bind
> the fd to its objects due to security reasons).

Both operate on the same device. So they would use the same device handle
(descriptor).

> > Additional system calls would allow a straightforward war to control
> > passing the descriptor on exec and other fuunky things (see manpage
> > for fcntl f.e.). The usual machinery for device descriptor control and
> > management would come in almost for free.
> >
> >
>
> That's exactly where we stand right now. There are some supporters for
> unifying all devices to one file. Even if you want to unify rdma-cm to the
> same fd and open the device through it, strace can't know which physical
> device is used.

strace can know the device through the descriptor in the same way as done
for character and block devices if we would follow the convention of one
descriptor referring to one device. strace cannot know that if you use a
single file for multiple devices.

I think the idea of using a single file as a way to do RPC calls to a
subsystem needs to be retired. Operations occur on devices and ioctls
refer
to devices.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
