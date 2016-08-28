From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH v3 05/15] IB/pvrdma: Add paravirtual rdma device
Date: Sun, 28 Aug 2016 15:50:40 +0000
Message-ID: <BLUPR0501MB836722093410C6E827D5092C5EE0@BLUPR0501MB836.namprd05.prod.outlook.com>
References: <1470266864-16888-1-git-send-email-aditr@vmware.com>
 <1470266864-16888-6-git-send-email-aditr@vmware.com>
 <20160825095920.GB14419@yuval-lap.uk.oracle.com>
 <20160828130657.GM594@leon.nu> <20160828134146.GA13965@yuval-lap>
 <20160828135048.GO594@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160828135048.GO594-2ukJVAZIZ/Y@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pv-drivers <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "Jorgen S. Hansen" <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Aug 28, 2016 at 06:50:56 -0700, Leon Romanovsky wrote:
> On Sun, Aug 28, 2016 at 04:41:47PM +0300, Yuval Shaia wrote:
> > On Sun, Aug 28, 2016 at 04:06:57PM +0300, Leon Romanovsky wrote:
> > > On Thu, Aug 25, 2016 at 12:59:21PM +0300, Yuval Shaia wrote:
> > > > On Wed, Aug 03, 2016 at 04:27:34PM -0700, Adit Ranadive wrote:
> > > > > This patch adds the main device-level structures and functions to=
 be used
> > > > > to provide RDMA functionality. Also, we define conversion functio=
ns from
> > > > > the IB core stack structures to the device-specific ones.
> > > > >
> > > > > Changes v2->v3:
> > > > >  - Removed VMware vendor id redefinition.
> > > > >  - Removed the boolean in pvrdma_cmd_post.
> > > > >
> > > > > Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > > > > Reviewed-by: George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > > > > Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > > > > Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > > > > Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > > > > ---
> > > > >  drivers/infiniband/hw/pvrdma/pvrdma.h | 456 ++++++++++++++++++++=
++++++++++++++
> > > > >  1 file changed, 456 insertions(+)
> > > > >  create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma.h
> > > > >

...

> > > > > +
> > > > > +/*
> > > > > + * VMware PVRDMA PCI device id.
> > > > > + */
> > > > > +#define PCI_DEVICE_ID_VMWARE_PVRDMA	0x0820
> > > >
> > > > I don't see a reason to define it locally in the driver.
> > > > Suggesting to move it to include/linux/pci_ids.h
> > >
> > > Interesting,
> > > We already discussed it.
> >
> > I believe the discussion was about vendor ID.
> > As far as i see it - suggestion applies also to device ID.
> >
>=20
> Yes, all PCI_DEVICE_ID_... defines are needed to be in pci_ids.h file.
>=20
> Thanks

Looking at the header in pci_ids.h file we should only add it there if the =
definition will be
shared between multiple drivers. That's not case for the PVRDMA device id s=
o I believe
this definition can stay here.
I have moved the VMXNET3 device id there since we now use it in the PVRDMA =
driver too.

Thanks,
Adit
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
