From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
Subject: RE: [PATCH 1/2] IB/hfi1: Try slot reset before secondary bus reset
Date: Thu, 19 Apr 2018 22:11:27 +0000
Message-ID: <BN6PR12MB1809BD30AA5B890C054F9832F7B50@BN6PR12MB1809.namprd12.prod.outlook.com>
References: <1524167784-5911-1-git-send-email-okaya@codeaurora.org>
 <20180419202632.GE14063@ziepe.ca>
 <20180419214722.GO28657@bhelgaas-glaptop.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180419214722.GO28657@bhelgaas-glaptop.roam.corp.google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Helgaas <helgaas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Sinan Kaya <okaya@codeaurora.org>, Bjorn Helgaas <bhelgaas@google.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "sulrich@codeaurora.org" <sulrich@codeaurora.org>, "timur@codeaurora.org" <timur@codeaurora.org>, "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, "open list:HFI1 DRIVER" <linux-rdma@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: Bjorn Helgaas [mailto:helgaas@kernel.org]
> Sent: Thursday, April 19, 2018 5:47 PM
> To: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Sinan Kaya <okaya@codeaurora.org>; Bjorn Helgaas
> <bhelgaas@google.com>; linux-pci@vger.kernel.org;
> sulrich@codeaurora.org; timur@codeaurora.org; linux-arm-
> msm@vger.kernel.org; linux-arm-kernel@lists.infradead.org; Mike
> Marciniszyn <mike.marciniszyn@intel.com>; Dennis Dalessandro
> <dennis.dalessandro@intel.com>; Doug Ledford <dledford@redhat.com>;
> open list:HFI1 DRIVER <linux-rdma@vger.kernel.org>; open list <linux-
> kernel@vger.kernel.org>; Deucher, Alexander
> <Alexander.Deucher@amd.com>
> Subject: Re: [PATCH 1/2] IB/hfi1: Try slot reset before secondary bus res=
et
>=20
> [+cc Alex, who might know why DRM drivers have their own PCIe Gen3
> code]
>=20
> On Thu, Apr 19, 2018 at 02:26:32PM -0600, Jason Gunthorpe wrote:
> > On Thu, Apr 19, 2018 at 03:56:23PM -0400, Sinan Kaya wrote:
> > > The infiniband adapter might be connected to a PCI hotplug slot.
> > > Performing secondary bus reset on a hotplug slot causes PCI link
> up/down interrupts.
> > >
> > > Hotplug driver removes the device from system when a link down
> > > interrupt is observed and performs re-enumeration when link up
> interrupt is observed.
> > >
> > > This conflicts with what this code is trying to do. Try secondary
> > > bus reset only if pci_reset_slot() fails/unsupported.
> > >
> > > Signed-off-by: Sinan Kaya <okaya@codeaurora.org>
> > > drivers/infiniband/hw/hfi1/pcie.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/infiniband/hw/hfi1/pcie.c
> > > b/drivers/infiniband/hw/hfi1/pcie.c
> > > index 83d66e8..75f49e3 100644
> > > +++ b/drivers/infiniband/hw/hfi1/pcie.c
> > > @@ -908,7 +908,8 @@ static int trigger_sbr(struct hfi1_devdata *dd)
> >
> > The code above this hunk is:
> >
> > /*
> >  * Trigger a secondary bus reset (SBR) on ourselves using our parent.
> >  *
> >  * Based on pci_parent_bus_reset() which is not exported by the
> >  * kernel core.
> >  */
> > static int trigger_sbr(struct hfi1_devdata *dd) {
> >
> > [..]
> >
> > This really seems like something the PCI core should be helping with,
> > drivers shouldn't be doing stuff like this. I get the feeling this
> > should be a common need if drivers support various error recovery
> > schemes?
> >
> > Bjorn, would be appropriate to export pci_parent_bus_reset() or some
> > variation therin??
>=20
> I agree it would be really nice if the PCI core could help out somehow so=
 we
> could get some of this code out of individual drivers.
>=20
> If fact, stepping back a few paces, this HFI reset path is part of a tran=
sition to
> PCIe gen3 signaling, and I'm not sure why *that* is in the driver either.
>=20
> There's an ongoing discussion [1] about why this gen3 code is in the driv=
er.
> Several DRM drivers include similar code (cik_pcie_gen3_enable(),
> si_pcie_gen3_enable()).
>=20
> I *thought* the hardware was supposed to automatically negotiate to the
> highest rate supported by both sides without any help at all from softwar=
e.
> But since several drivers have code to do it themselves, I wonder if I'm
> missing something, or maybe there's something the PCI core should be doin=
g
> that it isn't, and the driver code is basically working around that PCI c=
ore
> deficiency.

My understanding was that some platfoms only bring up the link in gen 1 mod=
e for compatibility reasons.  TBH, I'm not that familiar with how the links=
 come up on different platforms.

Alex
