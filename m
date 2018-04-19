From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH 1/2] IB/hfi1: Try slot reset before secondary bus reset
Date: Thu, 19 Apr 2018 16:35:20 -0400
Message-ID: <0049ffa6-0735-160d-d504-09966839caf4@codeaurora.org>
References: <1524167784-5911-1-git-send-email-okaya@codeaurora.org>
 <20180419202632.GE14063@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180419202632.GE14063@ziepe.ca>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>, Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, sulrich@codeaurora.org, timur@codeaurora.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, "open list:HFI1 DRIVER" <linux-rdma@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 4/19/2018 4:26 PM, Jason Gunthorpe wrote:
> On Thu, Apr 19, 2018 at 03:56:23PM -0400, Sinan Kaya wrote:
>> The infiniband adapter might be connected to a PCI hotplug slot. Performing
>> secondary bus reset on a hotplug slot causes PCI link up/down interrupts.
>>
>> Hotplug driver removes the device from system when a link down interrupt
>> is observed and performs re-enumeration when link up interrupt is observed.
>>
>> This conflicts with what this code is trying to do. Try secondary bus reset
>> only if pci_reset_slot() fails/unsupported.
>>
>> Signed-off-by: Sinan Kaya <okaya@codeaurora.org>
>>  drivers/infiniband/hw/hfi1/pcie.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/infiniband/hw/hfi1/pcie.c b/drivers/infiniband/hw/hfi1/pcie.c
>> index 83d66e8..75f49e3 100644
>> +++ b/drivers/infiniband/hw/hfi1/pcie.c
>> @@ -908,7 +908,8 @@ static int trigger_sbr(struct hfi1_devdata *dd)
> 
> The code above this hunk is:
> 
> /*
>  * Trigger a secondary bus reset (SBR) on ourselves using our parent.
>  *
>  * Based on pci_parent_bus_reset() which is not exported by the
>  * kernel core.
>  */
> static int trigger_sbr(struct hfi1_devdata *dd)
> {
> 
> [..]
> 
> This really seems like something the PCI core should be helping with,
> drivers shouldn't be doing stuff like this. I get the feeling this
> should be a common need if drivers support various error recovery
> schemes?

pci_parent_bus_reset() still doesn't deal with hotplug. We need to call
a variation of pci_slot_reset() before calling pci_parent_bus_reset().

	rc = pci_dev_reset_slot_function(dev, 0);
	if (rc != -ENOTTY)
		return rc;
	return pci_parent_bus_reset(dev, 0);

VFIO driver does this.

			/* User has access, do the reset */
			ret = slot ? pci_try_reset_slot(vdev->pdev->slot) :
				     pci_try_reset_bus(vdev->pdev->bus);

I assumed the responsibility is at the driver to call the right API it likes.

-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
