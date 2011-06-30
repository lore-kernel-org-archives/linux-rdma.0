From: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: Re: [PATCH 04/14] SIWv2: Module initialization: siw_main.c
Date: Thu, 30 Jun 2011 18:23:04 +0200
Message-ID: <OFECAC7AF5.E3ED2EF9-ONC12578BF.004E5934-C12578BF.005A012E@ch.ibm.com>
References: <BANLkTi=E=FQonndVeROSQJkpWRH4sCwEfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTi=E=FQonndVeROSQJkpWRH4sCwEfA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Good point. I moved the three attributes to debugfs which
looks much more appropriate.

I also re-structured module initialization/device registration:
The siw module now registers with the netdevice subsystem
(register_netdevice_notifier()) to catch NETDEV_xx events,
which now also handles device state changes and later
device addition.

Before posting it as a proposed patch I wanted to discuss the
following. Currently, only NETDEV_REGISTER, NETDEV_UNREGISTER,
NETDEV_UP, NETDEV_DOWN are handled as following:
NETDEV_REGISTER:	Instantiate a siw device (ib_alloc_device()).
NETDEV_UP:		Register to ib_core (ib_register_device()),
			if the device has an interface address.
NETDEV_DOWN:	Unregister from ib_core (ib_unregister_device()).
NETDEV_UNREGISTER:Deallocate device (ib_dealloc_device())

Toggling the device UP and DOWN would end up un-/registering
with the ib_core. Maybe thats not appropriate and the device
should remain visible to ib_core? The CM appears to exclude
DOWN devices from connection management. With that, a siw device
would remain visible to ib_core until it gets UNREGISTERed.


Should the code handle other events such as NETDEV_CHANGEADDR?


Many thanks,
bernard.

linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org wrote on 06/18/2011 07:39:11 PM:

> On Thu, Jun 16, 2011 at 2:42 PM, Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
wrote:
> > ---
> > =A0drivers/infiniband/hw/siw/siw_main.c | =A0603
> ++++++++++++++++++++++++++++++++++
> > =A01 files changed, 603 insertions(+), 0 deletions(-)
> > =A0create mode 100644 drivers/infiniband/hw/siw/siw_main.c
> >
> > diff --git a/drivers/infiniband/hw/siw/siw_main.c
> b/drivers/infiniband/hw/siw/siw_main.c
> > [ ... ]
> > +static ssize_t show_stats(struct device *dev,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct device_att=
ribute *attr, char *buf)
> > +{
> > + =A0 =A0 =A0 struct siw_dev *siw_dev =3D container_of(dev, struct =
siw_dev,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0ofa_dev.dev);
> > +
> > + =A0 =A0 =A0 return sprintf(buf, "Allocated SIW Objects:\n"
> > +#if DPRINT_MASK > 0
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Global =A0 =A0 :\t%s=
: %d\n"
> > +#endif
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Device %s:\t"
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "%s: %d, %s: %d, %s: =
%d, %s: %d, %s: %d, %s: %d
\n",
> > +#if DPRINT_MASK > 0
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "WQEs", atomic_read(&=
siw_num_wqe),
> > +#endif
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 siw_dev->ofa_dev.name=
,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "PDs", atomic_read(&s=
iw_dev->num_pd),
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "QPs", atomic_read(&s=
iw_dev->num_qp),
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "CQs", atomic_read(&s=
iw_dev->num_cq),
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "SRQs", atomic_read(&=
siw_dev->num_srq),
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "MRs", atomic_read(&s=
iw_dev->num_mem),
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "CEPs", atomic_read(&=
siw_dev->num_cep));
> > +}
>
> The rules for sysfs, documented in Documentation/ABI/README, are:
> - One value per file.
> - All new sysfs attributes must be documented in Documentation/ABI.
>
> An alternative to following the above rules is moving attributes from
> sysfs to debugfs.
>
> Bart.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
