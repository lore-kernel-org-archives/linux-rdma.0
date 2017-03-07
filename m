From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 1/2] device: Stop requiring that struct device is
 embedded in struct pci_dev
Date: Tue, 7 Mar 2017 16:54:58 +0000
Message-ID: <1488905685.2739.1.camel@sandisk.com>
References: <20170307003549.3872-1-bart.vanassche@sandisk.com>
         <20170307003549.3872-2-bart.vanassche@sandisk.com>
         <20170307045236.GC3913@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170307045236.GC3913@kroah.com>
Content-Language: en-US
Content-ID: <39E300E4ED01114DA33B8098C8AA4F11@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "parav@mellanox.com" <parav@mellanox.com>, "sebott@linux.vnet.ibm.com" <sebott@linux.vnet.ibm.com>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, "dwmw2@infradead.org" <dwmw2@infradead.org>, "bhelgaas@google.com" <bhelgaas@google.com>, "dledford@redhat.com" <dledford@redhat.com>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-03-07 at 05:52 +0100, Greg Kroah-Hartman wrote:
> Somehow all other subsystems work just fine, don't instantly think that
> the driver core needs to bend to the will of the IB code, because you
> are somehow "special".  Hint, you aren't :)

Hi Greg,

In another e-mail Parav compared IB drivers with networking drivers. But I
think that's a bad comparison: in the networking stack it's the network
driver itself that sets up and triggers DMA while in the IB stack it's the
upper layer protocol (ULP) driver that calls the functions defined in struc=
t
dma_ops. For some IB HW drivers (hfi1, qib and rdma_rxe) the ULP driver mus=
t
use the DMA mapping operations from lib/dma-virt.c while for all other IB H=
W
drivers the ULP driver must use the PCI DMA mapping functions. The ib_dma_*=
()
functions select the right DMA mapping operations - either the PCI DMA
mapping operations or those from lib/dma-virt.c. My question to you is how =
we
should organize struct ib_device such that we can get rid of the ib_dma_*()
helper functions. How to make sure that the to_pci_dev() translation works
correctly for the device structure that is embedded in struct ib_device?
Should a pointer to struct pci_dev be embedded in struct device (as done in
patch 1/2 in this series) or should the struct device in ib_device be chang=
ed
into a struct pci_dev and should the pci_dev information from
/sys/devices/pci*/*/* be duplicated into the pci_dev information in struct
ib_device (/sys/devices/pci*/*/*/infiniband/*)? For the latter approach, wo=
uld
there be a risk that the duplicated information becomes inconsistent?

Thanks,

Bart.
