From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH 1/2] IB/hfi1: Try slot reset before secondary bus reset
Date: Mon, 23 Apr 2018 13:28:22 -0400
Message-ID: <10d9cf68-29ed-d205-a25f-b8dade53cdd8@codeaurora.org>
References: <1524167784-5911-1-git-send-email-okaya@codeaurora.org>
 <20180419202632.GE14063@ziepe.ca>
 <20180419214722.GO28657@bhelgaas-glaptop.roam.corp.google.com>
 <290e9530-dcde-9c10-7ae0-59ac4c509db4@codeaurora.org>
 <20180420140049.GP28657@bhelgaas-glaptop.roam.corp.google.com>
 <20180420090420.03fb1e6c@w520.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180420090420.03fb1e6c@w520.home>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Alex Williamson <alex.williamson@redhat.com>, Bjorn Helgaas <helgaas@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org, sulrich@codeaurora.org, timur@codeaurora.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, "open list:HFI1 DRIVER" <linux-rdma@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Alex Deucher <alexander.deucher@amd.com>, Rajat Jain <rajatja@google.com>
List-Id: linux-rdma@vger.kernel.org

On 4/20/2018 11:04 AM, Alex Williamson wrote:
> Is there a concern here about whether the endpoint device driver or the
> PCI core really knows better about link retraining?  This makes me
> remember my unfinished (and need to revisit) Pericom quirk[1] where
> errata in the PCIe switch requires that upstream and downstream links
> are balanced (ie. same link rate) or else enabling ACS results in
> packets not properly flowing through the switch.  If an endpoint driver
> starts deciding to retrain links, overriding quirks in the PCI core,
> then such topology manipulation isn't possible.  Why does the
> driver .probe() function think it can retrain at a higher link rate
> than PCI core?  Thanks,

The example given is for some serdes firmware load to happen in probe and
then performing a retrain to reach to a better speed.

It becomes a chicken and egg problem. 

1. Endpoint HW trains to gen1 by default pre-boot.
2. PCI core enumerates the device.
3. Endpoint driver gets loaded
4. Driver does the firmware programming followed by a link retrain.

I think it is the responsibility of the PCI core to provide reset APIs.
However, expecting endpoint drivers to be knowledgeable about hotplug is
too much.

We can certainly contain AER change into pci directory by moving the slot
reset function to drivers/pci.h file.

But, we need to think about what to do about VFIO and other endpoint
initiated reset cases. My suggestion was to move this into a single API and
remove all other APIs from include/linux/pci.h.

Coming back to this patch...

Do we need a retrain API with the speed that driver wants to reach to?
API can return what was actually accomplished. The quirk from Alex can
run inside this API to make a decision on what speed do we actually want
to reach to for a given PCI topology by reprogramming the target link speed
field.

-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
