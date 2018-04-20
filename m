From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH 1/2] IB/hfi1: Try slot reset before secondary bus reset
Date: Fri, 20 Apr 2018 10:23:18 -0400
Message-ID: <b4e36805-d81d-714a-069e-c209834b87d4@codeaurora.org>
References: <1524167784-5911-1-git-send-email-okaya@codeaurora.org>
 <20180419202632.GE14063@ziepe.ca>
 <20180419214722.GO28657@bhelgaas-glaptop.roam.corp.google.com>
 <290e9530-dcde-9c10-7ae0-59ac4c509db4@codeaurora.org>
 <20180420140049.GP28657@bhelgaas-glaptop.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180420140049.GP28657@bhelgaas-glaptop.roam.corp.google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org, sulrich@codeaurora.org, timur@codeaurora.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, "open list:HFI1 DRIVER" <linux-rdma@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Alex Deucher <alexander.deucher@amd.com>, Rajat Jain <rajatja@google.com>, Alex Williamson <alex.williamson@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On 4/20/2018 10:00 AM, Bjorn Helgaas wrote:
> [+cc Rajat, Alex because of their interest in the reset/hotplug issue]
> 
> For context, Sinan's patch is this:
> 
>> diff --git a/drivers/infiniband/hw/hfi1/pcie.c b/drivers/infiniband/hw/hfi1/pcie.c
>> index 83d66e8..75f49e3 100644
>> --- a/drivers/infiniband/hw/hfi1/pcie.c
>> +++ b/drivers/infiniband/hw/hfi1/pcie.c
>> @@ -908,7 +908,8 @@ static int trigger_sbr(struct hfi1_devdata *dd)
>>          * delay after a reset is required.  Per spec requirements,
>>          * the link is either working or not after that point.
>>          */
>> -       pci_reset_bridge_secondary_bus(dev->bus->self);
>> +       if (pci_reset_slot(dev->slot))
>> +               pci_reset_bridge_secondary_bus(dev->bus->self);
> 
> On Thu, Apr 19, 2018 at 06:19:32PM -0400, Sinan Kaya wrote:
>> On 4/19/2018 5:47 PM, Bjorn Helgaas wrote:
>>>> Bjorn, would be appropriate to export pci_parent_bus_reset() or some
>>>> variation therin??
>>> I agree it would be really nice if the PCI core could help out somehow
>>> so we could get some of this code out of individual drivers.
> 
> What I was really thinking here was about the whole Gen3 transition
> thing, not the reset thing by itself.
> 
>> I can create a function called pci_reset_link() and move both slot and
>> secondary bus reset inside.
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

Yes, you are on track. Basically; for all callers in drivers directory,
I was trying to call hotplug reset as in (1/2) of this patch before
secondary bus reset.

I learnt about this during our DPC+hotplug interaction thread here:

https://patchwork.kernel.org/project/linux-pci/list/?submitter=77241

Existing issues:
https://marc.info/?l=linux-pci&m=152336615707640&w=2
https://www.spinics.net/lists/linux-pci/msg70614.html


> 
> I'm having a hard time articulating my thoughts here.  I think my
> concern is that knowledge about this reset/link down/hotplug issue is
> leaking out and we'll end up with different reset interfaces that may
> or may not result in hotplug events.  This seems like a confusing API
> because it's hard to explain which interface a driver should use.

I think we should go ahead and combine slot reset and secondary bus
reset into a single API and hide the other ones (pci_reset_slot() and
pci_reset_bridge_secondary_bus()) from external users. This way,
people don't have to query if system supports hotplug or not like VFIO
does.

Other drivers (AER/IB) not doing this are broken in hotplug systems today.


> 
> Bjorn
> 


-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
