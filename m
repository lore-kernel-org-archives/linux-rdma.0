From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH v2 01/15] IB/pvrdma: Add paravirtual rdma device
Date: Thu, 28 Jul 2016 20:56:54 +0000
Message-ID: <BLUPR0501MB836FF004F1DB57D54B1588FC5000@BLUPR0501MB836.namprd05.prod.outlook.com>
References: <1468352205-9137-1-git-send-email-aditr@vmware.com>
 <1468352205-9137-2-git-send-email-aditr@vmware.com>
 <20160726053820.GE20674@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160726053820.GE20674-2ukJVAZIZ/Y@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org" <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "Jorgen S. Hansen" <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 26 Jul 2016 08:38:20 +0300 Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Tue, Jul 12, 2016 at 12:36:31PM -0700, Adit Ranadive wrote:
> > This patch adds the main device-level structures and functions to be used
> > to provide RDMA functionality. Also, we define conversion functions from
> > the IB core stack structures to the device-specific ones.
> >
> > Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/pvrdma/pvrdma.h | 459 ++++++++++++++++++++++++++++++++++
> >  1 file changed, 459 insertions(+)
> >  create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma.h

...

> > +/*
> > + * VMware PVRDMA vendor id and PCI device id.
> > + */
> > +#ifndef PCI_VENDOR_ID_VMWARE
> > +#define PCI_VENDOR_ID_VMWARE		0x15AD
> > +#endif
> 
> Any special reason to do it?
> You have this define in include/linux/pci_ids.h file.

Hmm, not necessarily. I believe it wasn't defined in some of the older
distros. We should be okay to remove it.

Thanks,
Adit

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
