From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 06/10] IB/core: Enable to query QP types
 supported by IB device on a port
Date: Sun, 18 Dec 2016 23:07:47 +0200
Message-ID: <CAJ3xEMgRbJ4fJMgBmPTWuj7mjoJxs4Pr9yrNOagWR-SUL890wQ@mail.gmail.com>
References: <1480258296-27032-1-git-send-email-leon@kernel.org>
 <1480258296-27032-7-git-send-email-leon@kernel.org> <20161216201158.GE12582@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161216201158.GE12582-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 16, 2016 at 10:11 PM, ira.weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>
> On Sun, Nov 27, 2016 at 04:51:32PM +0200, Leon Romanovsky wrote:
> > From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > Add qp_type_cap port attribute which is a bit field representation
> > of the ib_qp_type enum. This will allow applications to query what QP
> > types are supported by an IB device instance on a specific port.
> >
> > The qp_type_cap port attribute is set by the core according to the
> > protocol supported for the device port. This holds for all the
> > providers with the exception of two RoCE drivers that don't implement
> > UD and UC. To handle that, they (hns and qedr) are patched to remove
> > these QPs from what's the core has set for them as supported.
> >
> > Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> >  drivers/infiniband/core/device.c          | 28 ++++++++++++++++++++++++++++
> >  drivers/infiniband/hw/hns/hns_roce_main.c |  3 +++
> >  drivers/infiniband/hw/qedr/verbs.c        |  2 ++
> >  include/rdma/ib_verbs.h                   |  1 +
> >  4 files changed, 34 insertions(+)
> >
> > diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> > index 760ef60..f7abde2 100644
> > --- a/drivers/infiniband/core/device.c
> > +++ b/drivers/infiniband/core/device.c
> > @@ -646,6 +646,31 @@ void ib_dispatch_event(struct ib_event *event)
> >  }
> >  EXPORT_SYMBOL(ib_dispatch_event);
> >
> > +static void get_port_qp_types(const struct ib_device *device, u8 port_num,
> > +                           struct ib_port_attr *port_attr)
> > +{
> > +     if (rdma_cap_ib_smi(device, port_num))
> > +             port_attr->qp_type_cap |= BIT(IB_QPT_SMI);
> > +
> > +     if (rdma_cap_ib_cm(device, port_num))
> > +             port_attr->qp_type_cap |= BIT(IB_QPT_GSI);
>
> This is not accurate.  The IB CM is not the same as having QP1 supported.
>

Ira,

Looking on the kernel mad module code, I see they (your code..) 1st
check that rdma_cap_ib_mad(device, port) is true, and next just
blindly attempt to open GSI QP (call create_mad_qp([...], IB_QPT_GSI)
on the device/port.

I guess this is correct by elimination only if the smi cap is false...
b/c if the mad cap is set and the smi cap is true, it's possible that
GSI isn't supported for the port under some proprietary protocol. So
what is per your design a clear robust way to determine if GSI is
supported on the device/port?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
