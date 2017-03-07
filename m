From: Parav Pandit <parav@mellanox.com>
Subject: RE: [PATCH 1/2] device: Stop requiring that struct device is embedded
 in struct pci_dev
Date: Tue, 7 Mar 2017 18:27:17 +0000
Message-ID: <VI1PR0502MB3008B179278931A3D2519A07D12F0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <20170307003549.3872-1-bart.vanassche@sandisk.com>
 <20170307003549.3872-2-bart.vanassche@sandisk.com>
 <20170307045236.GC3913@kroah.com> <1488905685.2739.1.camel@sandisk.com>
 <20170307171403.GA19293@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170307171403.GA19293@kroah.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "sebott@linux.vnet.ibm.com" <sebott@linux.vnet.ibm.com>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, "dwmw2@infradead.org" <dwmw2@infradead.org>, "bhelgaas@google.com" <bhelgaas@google.com>, "dledford@redhat.com" <dledford@redhat.com>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: gregkh@linuxfoundation.org [mailto:gregkh@linuxfoundation.org]
> Sent: Tuesday, March 7, 2017 11:14 AM
> To: Bart Van Assche <Bart.VanAssche@sandisk.com>
> Cc: linux-kernel@vger.kernel.org; linux-rdma@vger.kernel.org; Parav Pandi=
t
> <parav@mellanox.com>; sebott@linux.vnet.ibm.com;
> linux@armlinux.org.uk; hpa@zytor.com; mingo@redhat.com;
> dwmw2@infradead.org; bhelgaas@google.com; dledford@redhat.com;
> benh@kernel.crashing.org
> Subject: Re: [PATCH 1/2] device: Stop requiring that struct device is
> embedded in struct pci_dev
>=20
> On Tue, Mar 07, 2017 at 04:54:58PM +0000, Bart Van Assche wrote:
> > On Tue, 2017-03-07 at 05:52 +0100, Greg Kroah-Hartman wrote:
> > > Somehow all other subsystems work just fine, don't instantly think
> > > that the driver core needs to bend to the will of the IB code,
> > > because you are somehow "special".  Hint, you aren't :)
> >
> > Hi Greg,
> >
> > In another e-mail Parav compared IB drivers with networking drivers.
>=20
> Great, then notice that networking drivers don't need to do this type of =
crud
> :)
>=20

Well what I compared is:
netdev has struct device and it also has underlying pci_dev based device.
ibdev has struct device and it also has underlying pci_dev based device.
So let us try to treat them in same way wherever possible and keep setup ne=
eded in ib drivers.

> > But I think that's a bad comparison: in the networking stack it's the
> > network driver itself that sets up and triggers DMA while in the IB
> > stack it's the upper layer protocol (ULP) driver that calls the
> > functions defined in struct dma_ops. For some IB HW drivers (hfi1, qib
> > and rdma_rxe) the ULP driver must use the DMA mapping operations from

DMA mapping and allocation is done in different layer for its own reason un=
related to this change.
If rxe, qib, hfi1 point to right dma_device, can't we remove the ib_dma_*()=
?
