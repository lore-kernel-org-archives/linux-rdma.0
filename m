From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v4 40/50] IB/hfi1: add sysfs routines and documentation
Date: Fri, 31 Jul 2015 10:13:45 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1507310957320.12455@east.gentwo.org>
References: <20150730191631.25256.95511.stgit@phlsvslse11.ph.intel.com> <20150730192109.25256.56498.stgit@phlsvslse11.ph.intel.com> <alpine.DEB.2.11.1507301541170.6551@east.gentwo.org> <32E1700B9017364D9B60AED9960492BC25778486@fmsmsx120.amr.corp.intel.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC25778486-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Debbage, Mark" <mark.debbage-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 31 Jul 2015, Marciniszyn, Mike wrote:

> > > > +HFI1
> > > > +
> > > > +  The hfi1 driver also creates these additional files:
> > > > +
> > > > +   hw_rev - hardware revision
> >=20
> > I'm checking on this to see if it is indeed a duplicate.
> >=20
>
> Our hardware architect has indicated there is not PCIe equivalent for this =
> case.

Please get someone knowledgeable at Intel to look at this. There is
a (rev 04) when using lspci on my nic here. This seems to be the hardware
revision.

00:19.0 Ethernet controller: Intel Corporation Ethernet Connection I217-LM
(rev 04)

lspci.c does the following and to get that info. See where
PCI_REVISION_ID is used:



static void
show_terse(struct device *d)
{
  int c;
  struct pci_dev *p = d->dev;
  char classbuf[128], devbuf[128];

  show_slot_name(d);
  printf(" %s: %s",
         pci_lookup_name(pacc, classbuf, sizeof(classbuf),
                         PCI_LOOKUP_CLASS,
                         p->device_class),
         pci_lookup_name(pacc, devbuf, sizeof(devbuf),
                         PCI_LOOKUP_VENDOR | PCI_LOOKUP_DEVICE,
                         p->vendor_id, p->device_id));
  if (c = get_conf_byte(d, PCI_REVISION_ID))
    printf(" (rev %02x)", c);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
