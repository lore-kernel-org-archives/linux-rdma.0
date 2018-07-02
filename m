From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH V4 4/7] PCI: Unify try slot and bus reset API
Date: Mon, 2 Jul 2018 16:40:10 -0400
Message-ID: <9674e845-765c-cc16-654e-21036038f2d5@codeaurora.org>
References: <1530214274-21139-1-git-send-email-okaya@codeaurora.org>
 <1530214274-21139-4-git-send-email-okaya@codeaurora.org>
 <CAHp75VcYbeRTiggEiQnEV6DKR=F47RxNR0FZ+E-XKPpq8VNpqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHp75VcYbeRTiggEiQnEV6DKR=F47RxNR0FZ+E-XKPpq8VNpqw@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-pci@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Bjorn Helgaas <bhelgaas@google.com>, Alex Williamson <alex.williamson@redhat.com>, Alexey Kardashevskiy <aik@ozlabs.ru>, Peter Xu <peterx@redhat.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, "open list:HFI1 DRIVER" <linux-rdma@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:VFIO DRIVER" <kvm@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 6/29/2018 5:43 PM, Andy Shevchenko wrote:
>> +int pci_try_reset_bus(struct pci_dev *pdev)
>> +{
>> +       bool slot = false;
>> +
>> +       if (!pci_probe_reset_slot(pdev->slot))
>> +               slot = true;
>> +
>> +       return slot ? __pci_try_reset_slot(pdev->slot) :
>> +                       __pci_try_reset_bus(pdev->bus);
> This can be as simple as
> 
>   return pci_probe_reset_slot(pdev->slot) ?
>     __pci_try_reset_bus(pdev->slot) : __pci_try_reset_slot(pdev->bus);
> 
> 

done

-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
