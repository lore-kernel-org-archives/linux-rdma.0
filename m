From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH 1/2] IB/hfi1: Try slot reset before secondary bus reset
Date: Fri, 20 Apr 2018 09:04:20 -0600
Message-ID: <20180420090420.03fb1e6c@w520.home>
References: <1524167784-5911-1-git-send-email-okaya@codeaurora.org>
        <20180419202632.GE14063@ziepe.ca>
        <20180419214722.GO28657@bhelgaas-glaptop.roam.corp.google.com>
        <290e9530-dcde-9c10-7ae0-59ac4c509db4@codeaurora.org>
        <20180420140049.GP28657@bhelgaas-glaptop.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180420140049.GP28657@bhelgaas-glaptop.roam.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Sinan Kaya <okaya@codeaurora.org>, Jason Gunthorpe <jgg@ziepe.ca>, Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org, sulrich@codeaurora.org, timur@codeaurora.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, "open list:HFI1 DRIVER" <linux-rdma@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Alex Deucher <alexander.deucher@amd.com>, Rajat Jain <rajatja@google.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, 20 Apr 2018 09:00:49 -0500
Bjorn Helgaas <helgaas@kernel.org> wrote:

> [+cc Rajat, Alex because of their interest in the reset/hotplug issue]
> 
> For context, Sinan's patch is this:
> 
> > diff --git a/drivers/infiniband/hw/hfi1/pcie.c b/drivers/infiniband/hw/hfi1/pcie.c
> > index 83d66e8..75f49e3 100644
> > --- a/drivers/infiniband/hw/hfi1/pcie.c
> > +++ b/drivers/infiniband/hw/hfi1/pcie.c
> > @@ -908,7 +908,8 @@ static int trigger_sbr(struct hfi1_devdata *dd)
> >          * delay after a reset is required.  Per spec requirements,
> >          * the link is either working or not after that point.
> >          */
> > -       pci_reset_bridge_secondary_bus(dev->bus->self);
> > +       if (pci_reset_slot(dev->slot))
> > +               pci_reset_bridge_secondary_bus(dev->bus->self);  
> 
> On Thu, Apr 19, 2018 at 06:19:32PM -0400, Sinan Kaya wrote:
> > On 4/19/2018 5:47 PM, Bjorn Helgaas wrote:  
> > >> Bjorn, would be appropriate to export pci_parent_bus_reset() or some
> > >> variation therin??  
> > > I agree it would be really nice if the PCI core could help out somehow
> > > so we could get some of this code out of individual drivers.  
> 
> What I was really thinking here was about the whole Gen3 transition
> thing, not the reset thing by itself.
> 
> > I can create a function called pci_reset_link() and move both slot and
> > secondary bus reset inside.  
> 
> What exactly is your patch fixing?  Is it the following?
> 
>   If the HFI link is not operating at 8GT/s, the driver's .probe()
>   method tries to transition it to 8GT/s, which involves resetting the
>   HFI device with pci_reset_bridge_secondary_bus().  If the HFI device
>   is in a hotplug slot, the reset causes a "Link Down" event, which
>   causes the pciehp driver to remove the HFI device and re-enumerate
>   it when the link comes back up.
> 
>   When pciehp removes the device, it calls the HFI .remove() method,
>   which is a problem because the .probe() method is still active.
> 
>   It looks like this should deadlock because __device_attach() holds
>   the device_lock while calling .probe() and the
>   device_release_driver() path tries to acquire it.
> 
> Your patch uses pci_reset_slot(), which connects with Rajat's work
> (06a8d89af551 ("PCI: pciehp: Disable link notification across slot
> reset")) to avoid hotplug events for intentional resets.
> 
> So I think I just reverse-engineered the whole rationale for your
> patch :)  Sorry about the long detour.
> 
> I'm having a hard time articulating my thoughts here.  I think my
> concern is that knowledge about this reset/link down/hotplug issue is
> leaking out and we'll end up with different reset interfaces that may
> or may not result in hotplug events.  This seems like a confusing API
> because it's hard to explain which interface a driver should use.

Is there a concern here about whether the endpoint device driver or the
PCI core really knows better about link retraining?  This makes me
remember my unfinished (and need to revisit) Pericom quirk[1] where
errata in the PCIe switch requires that upstream and downstream links
are balanced (ie. same link rate) or else enabling ACS results in
packets not properly flowing through the switch.  If an endpoint driver
starts deciding to retrain links, overriding quirks in the PCI core,
then such topology manipulation isn't possible.  Why does the
driver .probe() function think it can retrain at a higher link rate
than PCI core?  Thanks,

Alex

[1]https://lists.linuxfoundation.org/pipermail/iommu/2016-October/018890.html
