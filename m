From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: ipath now and then (was [PATCH] IB/core: export struct ib_port)
Date: Wed, 11 Nov 2009 13:35:50 -0800
Message-ID: <1257975350.992.324.camel@chromite.mv.qlogic.com>
References: <15ddcffd0911111318h425c43f6ya136d8f4aaa6883e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <15ddcffd0911111318h425c43f6ya136d8f4aaa6883e-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Olson <dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2009-11-11 at 13:18 -0800, Or Gerlitz wrote:
> On Wed, Nov 11, 2009 at 11:06 PM, Dave Olson <dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org> wrote:
> > And yes, the ib_ipath is being fully deprecated.  The "full set" of
> > patches that adds ib_qib upstream will include a subset that drops
> > ib_ipath.   All the bug fixes and feature work have been done for ib_qib
> 
> It was brought up in few occasions that the ipath driver can be
> changed such that it becomes a software IBoE driver (e.g use packet
> socket with the IBoE ether type for the IB L2 emulation).
> If it doesn't have to serve for the qlogic HCA anymore, this
> transformation might be even eaiser.
> I wonder if its better to remove it now and maybe return it later with
> the new facelift or leave it till the change is done.
> 
> Or.

I don't understand what you are suggesting.
The kernel module name ib_ipath and/or directory name
drivers/infiniband/hw/ipath could be reused for some
other purpose certainly.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
