From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH 1/2] IB/hfi1: Try slot reset before secondary bus reset
Date: Mon, 23 Apr 2018 16:17:23 -0400
Message-ID: <f7022685-9c99-7d49-a2f3-07b387d96e8d@codeaurora.org>
References: <1524167784-5911-1-git-send-email-okaya@codeaurora.org>
 <20180419202632.GE14063@ziepe.ca>
 <20180419214722.GO28657@bhelgaas-glaptop.roam.corp.google.com>
 <290e9530-dcde-9c10-7ae0-59ac4c509db4@codeaurora.org>
 <20180420140049.GP28657@bhelgaas-glaptop.roam.corp.google.com>
 <20180420090420.03fb1e6c@w520.home>
 <10d9cf68-29ed-d205-a25f-b8dade53cdd8@codeaurora.org>
 <20180423131044.53471670@w520.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180423131044.53471670@w520.home>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org, sulrich@codeaurora.org, timur@codeaurora.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, "open list:HFI1 DRIVER" <linux-rdma@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Alex Deucher <alexander.deucher@amd.com>, Rajat Jain <rajatja@google.com>
List-Id: linux-rdma@vger.kernel.org

On 4/23/2018 3:10 PM, Alex Williamson wrote:
>> But, we need to think about what to do about VFIO and other endpoint
>> initiated reset cases. My suggestion was to move this into a single API and
>> remove all other APIs from include/linux/pci.h.
> I'm a little confused about the relation between reset and retrain.
> AIUI we can retrain the link without any sort of endpoint reset and if
> some sort of driver/firmware setup is required on the endpoint to
> achieve the target link speed, then I'd think we only want to retrain.

I'm guessing on why you may want to do a secondary bus reset instead of just
retrain bit in the PCI Express Capabilities register...

The maximum link speed is embedded into the TS1s that are exchanged during
initial link training. 

If device only advertises gen1 during boot, no matter what you do with retrain
bit link may not reach to gen3.

A lot of guess here.

-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
