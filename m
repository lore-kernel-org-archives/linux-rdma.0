From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH 1/2] IB/hfi1: Try slot reset before secondary bus reset
Date: Fri, 22 Jun 2018 12:04:02 -0400
Message-ID: <98c4531b-0b64-b9e1-ef95-562d1613d893@codeaurora.org>
References: <1524167784-5911-1-git-send-email-okaya@codeaurora.org>
 <20180619214346.GD33049@bhelgaas-glaptop.roam.corp.google.com>
 <2593baec-8a28-a3e7-7ebf-7c21addda0b8@codeaurora.org>
 <20180622140125.GD108993@bhelgaas-glaptop.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180622140125.GD108993@bhelgaas-glaptop.roam.corp.google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: linux-pci@vger.kernel.org, sulrich@codeaurora.org, timur@codeaurora.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, "open list:HFI1 DRIVER" <linux-rdma@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Dennis Dalessandro <dennis.dalessandro@intel.com>, open list <linux-kernel@vger.kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, linux-arm-kernel@lists.infradead.org, Alex Williamson <alex.williamson@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On 6/22/2018 10:01 AM, Bjorn Helgaas wrote:
>> Since Oza's DPC/AER patch to refactor fatal error handling, both
>> hotplug driver and AER/DPC driver will try removing devices and
>> perform enumeration on link events/AER events.
>>
>> Perfect environment for race condition without a change.
> Yeah, this looks like a bit of a mess.  I guess we're getting two
> interrupts (AER interrupt and hotplug interrupt) and we should
> coordinate their handling somehow.  I don't have a proposal.  This
> race could happen independent of the device reset paths, of course.

I was hoping for pci_reset_slot() to avoid this but it turns out
the root port does not have any slot pointers set on my system even though
hotplug is enabled. 

Slot pointer is only set for the child objects.

https://patchwork.kernel.org/patch/10351515/

 * A PCI bus may host multiple slots, each slot may support a reset mechanism
 * independent of other slots.  For instance, some slots may support slot power
 * control.  In the case of a 1:1 bus to slot architecture, this function may
 * wrap the bus reset to avoid spurious slot related events such as hotplug.
 * Generally a slot reset should be attempted before a bus reset.  All of the
 * function of the slot and any subordinate buses behind the slot are reset
 * through this function.  PCI config space of all devices in the slot and
 * behind the slot is saved before and restored after reset.


-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
