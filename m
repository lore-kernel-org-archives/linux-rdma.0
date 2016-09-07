From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH v3 12/15] IB/pvrdma: Add the main driver module for PVRDMA
Date: Wed, 7 Sep 2016 19:41:42 +0000
Message-ID: <BLUPR0501MB836EF38D944CD38F8897C07C5F80@BLUPR0501MB836.namprd05.prod.outlook.com>
References: <1470266864-16888-1-git-send-email-aditr@vmware.com>
 <1470266864-16888-13-git-send-email-aditr@vmware.com>
 <20160901132024.GA26356@yuval-lap.mynet>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160901132024.GA26356-Hxa29pjIrESt9MVyvc/JHg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pv-drivers <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "Jorgen S. Hansen" <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 01, 2016 at 06:21:06 -0700, Yuval Shaia wrote:
> Please see two comments inline.
>=20
> Yuval
>=20
> On Wed, Aug 03, 2016 at 04:27:41PM -0700, Adit Ranadive wrote:
> > This patch adds the support to register a RDMA device with the kernel
> > RDMA stack as well as a kernel module. This also initializes the
> > underlying virtual PCI device.
> >
> > Changes from v1: Addressed 32-bit build errors. Addressed comments by
> > Yuval Shaia.
> >
> > Changes v2->v3:
> >  - Removed boolean in pvrdma_cmd_post.
> >
> > Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/pvrdma/pvrdma_main.c | 1190
> > ++++++++++++++++++++++++++++
> >  1 file changed, 1190 insertions(+)
> >  create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_main.c

...

> > +
> > +static void pvrdma_netdevice_event_handle(struct pvrdma_dev *dev,
> > +					  unsigned long event)
> > +{
> > +	struct net_device *netdev;
> > +
> > +	netdev =3D dev->netdev;
>=20
> The above two lines are redundant, please remove., please remove.

Ok.

> > +	switch (event) {
> > +	case NETDEV_REBOOT:
> > +	case NETDEV_DOWN:
> > +		pvrdma_dispatch_event(dev, 1, IB_EVENT_PORT_ERR);
> > +		break;
> > +	case NETDEV_UP:
> > +		pvrdma_dispatch_event(dev, 1, IB_EVENT_PORT_ACTIVE);
> > +		break;
> > +	default:
> > +		dev_dbg(&dev->pdev->dev, "ignore netdevice event %ld on
> %s\n",
> > +			event, dev->ib_dev.name);
> > +		break;
> > +	}
> > +}
> > +

...

> > +
> > +	if (pdev_net->vendor !=3D PCI_VENDOR_ID_VMWARE ||
> > +	    pdev_net->device !=3D PCI_DEVICE_ID_VMWARE_VMXNET3) {
> > +		dev_err(&pdev->dev, "failed to find paired vmxnet3
> device\n");
> > +		pci_dev_put(pdev_net);
> > +		ret =3D -ENODEV;
> > +		goto err_free_cq_ring;
> > +	}
>=20
> Any reason to enforce to this netdev only?

Yes, we expose our device to the guest as a dual function PCIe device with
Ethernet (VMXNet3) and RDMA (PVRDMA) capabilities. We use the VMXNet3
netdev to find the Ethernet properties required in the PVRDMA module.

Thanks,
Adit
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
