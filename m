From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V4 9/9] IB/mlx4: Enable mlx4_ib support for MODIFY_QP_EX
Date: Tue, 17 Sep 2013 10:50:17 -0700
Message-ID: <CAL1RGDUmv_+z8eMJHQ4ksh4Ai-Xspcv5y0+EUxkaX220ZJLWkg@mail.gmail.com>
References: <1378824099-22150-1-git-send-email-ogerlitz@mellanox.com>
 <1378824099-22150-10-git-send-email-ogerlitz@mellanox.com>
 <CAGgPuS1tAiyA3TZ5_fpua3ue6JrZ9ruS+O+QU-7t28i0dZ7cUw@mail.gmail.com>
 <52319B38.5070807@mellanox.com> <CAGgPuS07Vp6Zrd=cXmZeNps_S6wOswOoXHbp5Ec14tAy5aS5=A@mail.gmail.com>
 <5231B28E.4090605@mellanox.com> <20130912172252.GA4611@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130912172252.GA4611-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Devesh Sharma <desh.t2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, monis <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, matanb <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 12, 2013 at 10:22 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> On Thu, Sep 12, 2013 at 03:24:46PM +0300, Or Gerlitz wrote:
> > Let me clarify this. The idea is that current RoCE applications will
> > run as is after they update "their" librdmacm, since its this
> > library that works with the new uverbs entries.

> Or, we are not supposed to break userspace. You can't insist that a
> user space library be updated in-sync with the kernel.

Agree.  This "IP based addressing" for RoCE looks like a big problem
at the moment.  Let me reiterate my understanding, and you guys can
correct me if I get something wrong:

 - current addressing scheme is broken for virtualization use cases,
because VMs may not know about what VLANs are in use.  (also there are
issues around bonding modes that use different Ethernet addresses)

 - proposed change requires:

   * all systems must update kernel at the same time, because old and
new kernels cannot talk to each other

   * all systems must update librdmacm when they update the kernel,
because old librdmacm does not work with new kernel

I understand that we want to fix the issue around VLAN tagged traffic
from VMs, but I don't see how we can break the whole stack to
accomplish that.  Isn't there some incremental way forward?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
