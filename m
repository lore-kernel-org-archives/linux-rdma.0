From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 12/15] IB/pvrdma: Add the main driver module for PVRDMA
Date: Thu, 8 Sep 2016 18:25:42 +0300
Message-ID: <20160908152541.GA3352@yuval-lap.mynet>
References: <1470266864-16888-1-git-send-email-aditr@vmware.com>
 <1470266864-16888-13-git-send-email-aditr@vmware.com>
 <20160901132024.GA26356@yuval-lap.mynet>
 <BLUPR0501MB836EF38D944CD38F8897C07C5F80@BLUPR0501MB836.namprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BLUPR0501MB836EF38D944CD38F8897C07C5F80-84Rf5TRaNBMVDhIuTCx1aJLWcSx1hRipwIZJ9u9yWa8oOQlpcoRfSA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pv-drivers <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "Jorgen S. Hansen" <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 07, 2016 at 07:41:42PM +0000, Adit Ranadive wrote:
> ...
> 
> > > +
> > > +	if (pdev_net->vendor != PCI_VENDOR_ID_VMWARE ||
> > > +	    pdev_net->device != PCI_DEVICE_ID_VMWARE_VMXNET3) {
> > > +		dev_err(&pdev->dev, "failed to find paired vmxnet3
> > device\n");
> > > +		pci_dev_put(pdev_net);
> > > +		ret = -ENODEV;
> > > +		goto err_free_cq_ring;
> > > +	}
> > 
> > Any reason to enforce to this netdev only?
> 
> Yes, we expose our device to the guest as a dual function PCIe device with
> Ethernet (VMXNet3) and RDMA (PVRDMA) capabilities. We use the VMXNet3
> netdev to find the Ethernet properties required in the PVRDMA module.

So on a guest with 4 VMWare RDMA devices i will have an extra 4 VMXNet3
devices.
And so on.

> 
> Thanks,
> Adit
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
