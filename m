From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 12/15] IB/pvrdma: Add the main driver module for PVRDMA
Date: Thu, 8 Sep 2016 18:40:30 +0000
Message-ID: <BLUPR0501MB8363F127350C61014711C86C5FB0@BLUPR0501MB836.namprd05.prod.outlook.com>
References: <1470266864-16888-1-git-send-email-aditr@vmware.com>
 <1470266864-16888-13-git-send-email-aditr@vmware.com>
 <20160901132024.GA26356@yuval-lap.mynet>
 <BLUPR0501MB836EF38D944CD38F8897C07C5F80@BLUPR0501MB836.namprd05.prod.outlook.com>
 <20160908152541.GA3352@yuval-lap.mynet>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160908152541.GA3352-Hxa29pjIrESt9MVyvc/JHg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pv-drivers <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "Jorgen S. Hansen" <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 08, 2016 at 08:25:55 -0700, Yuval Shaia wrote:
> On Wed, Sep 07, 2016 at 07:41:42PM +0000, Adit Ranadive wrote:
> > ...
> >
> > > > +
> > > > +	if (pdev_net->vendor !=3D PCI_VENDOR_ID_VMWARE ||
> > > > +	    pdev_net->device !=3D PCI_DEVICE_ID_VMWARE_VMXNET3) {
> > > > +		dev_err(&pdev->dev, "failed to find paired vmxnet3
> > > device\n");
> > > > +		pci_dev_put(pdev_net);
> > > > +		ret =3D -ENODEV;
> > > > +		goto err_free_cq_ring;
> > > > +	}
> > >
> > > Any reason to enforce to this netdev only?
> >
> > Yes, we expose our device to the guest as a dual function PCIe device w=
ith
> > Ethernet (VMXNet3) and RDMA (PVRDMA) capabilities. We use the
> VMXNet3
> > netdev to find the Ethernet properties required in the PVRDMA module.
>=20
> So on a guest with 4 VMWare RDMA devices i will have an extra 4 VMXNet3
> devices.
> And so on.

I wouldn't consider them as extra. They are just part of the PVRDMA device
really. It's just that they aren't integrated with the PVRDMA device in the=
 PCI
space.
Also, wouldn't it be the same if you had 4 RoCE cards on a Linux box?
You would have 4 ethernet devices as well ..
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
