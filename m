From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH 1/2] IB/hfi1: Try slot reset before secondary bus reset
Date: Tue, 19 Jun 2018 18:21:43 -0400
Message-ID: <2593baec-8a28-a3e7-7ebf-7c21addda0b8@codeaurora.org>
References: <1524167784-5911-1-git-send-email-okaya@codeaurora.org>
 <20180619214346.GD33049@bhelgaas-glaptop.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180619214346.GD33049@bhelgaas-glaptop.roam.corp.google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: linux-pci@vger.kernel.org, sulrich@codeaurora.org, timur@codeaurora.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, "open list:HFI1 DRIVER" <linux-rdma@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Dennis Dalessandro <dennis.dalessandro@intel.com>, open list <linux-kernel@vger.kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-rdma@vger.kernel.org

On 6/19/2018 5:43 PM, Bjorn Helgaas wrote:
>> Hotplug driver removes the device from system when a link down interrupt
>> is observed and performs re-enumeration when link up interrupt is observed.
>>
>> This conflicts with what this code is trying to do. Try secondary bus reset
>> only if pci_reset_slot() fails/unsupported.
> Hi Sinan,
> 
> We had a bunch of discussion here but not sure we ever reached a
> consensus.  It did seem like we'd like to avoid putting hotplug
> knowledge in drivers, though.  What do you think the path forward is?
> 

There are multiple issues. 

We discussed the need for a retrain API on this thread. However, retrain API may
not be enough for this particular usage as the device might need a full link training
sequence following firmware load including a hot reset message. I don't think we can
remove the bus reset usage in this code.

I'd like to start with a small one to address your comment here.

"I think my concern is that knowledge about this reset/link down/hotplug issue is
leaking out and we'll end up with different reset interfaces that may
or may not result in hotplug events.  This seems like a confusing API
because it's hard to explain which interface a driver should use."

I'm thinking of removing pci_reset_slot() and pci_try_reset_slot() functions
as an exported API and fold them into pci_reset_bus() and  pci_try_reset_bus()
API respectively.

This is what happens when you insert a fatal error to a hotplug slot. See multiple
link up/down messages.

/_#_[__333.699731]_pcieport_0001:00:00.0:_AER:_Uncorrected_(Fatal)_error_received:_id=0000
[  333.748116] pcieport 0001:00:00.0: PCIe Bus Error: severity=Uncorrected (Fatal), type=Transaction Layer, id
[  333.816044] pcieport 0001:00:00.0:   device [17cb:0404] error status/mask=00040000/00400000
[  333.871581] pcieport 0001:00:00.0:    [18] Malformed TLP          (First)
[  333.914675] pcieport 0001:00:00.0:   TLP Header: 40000001 000000ff 00000000 00000000
[  333.968397] pciehp 0001:00:00.0:pcie004: Slot(2): Link Down
[  334.043234] iommu: Removing device 0001:01:00.4 from group 0
[  334.095952] iommu: Removing device 0001:01:00.3 from group 0
[  334.144644] iommu: Removing device 0001:01:00.2 from group 0
[  334.194653] iommu: Removing device 0001:01:00.1 from group 0
[  334.243564] pciehp 0001:00:00.0:pcie004: Slot(2): Link Up
[  334.282556] iommu: Removing device 0001:01:00.0 from group 0
[  334.330994] pciehp 0001:00:00.0:pcie004: Slot(2): Link Up event queued; currently getting powered off
[  334.890587] pciehp 0001:00:00.0:pcie004: Timeout on hotplug command 0x13f1 (issued 282900 msec ago)
[  335.070190] pciehp 0001:00:00.0:pcie004: Slot(2): Link Down
[  335.106960] pciehp 0001:00:00.0:pcie004: Slot(2): Link Down event queued; currently getting powered on
[  335.191119] pcieport 0001:00:00.0: AER: Device recovery failed
[  346.590153] pciehp 0001:00:00.0:pcie004: Timeout on hotplug command 0x17f1 (issued 10250 msec ago)

As a suggestion:

1. If the device belongs to a slot, do slot reset. 
2. Otherwise, do bus reset.

Since Oza's DPC/AER patch to refactor fatal error handling, both hotplug driver
and AER/DPC driver will try removing devices and perform enumeration on link events/AER events.

Perfect environment for race condition without a change.

-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
