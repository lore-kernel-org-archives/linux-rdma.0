From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [RFC PATCH 00/28] Removing struct page from P2PDMA
Date: Tue, 2 Jul 2019 16:52:41 -0600
Message-ID: <49c7f848-3cd5-7225-0821-b19fb4547ad9@deltatee.com>
References: <20190627063223.GA7736@ziepe.ca>
 <6afe4027-26c8-df4e-65ce-49df07dec54d@deltatee.com>
 <20190627163504.GB9568@ziepe.ca>
 <4894142c-3233-a3bb-f9a3-4a4985136e9b@deltatee.com>
 <20190628045705.GD3705@ziepe.ca>
 <8022a2a4-4069-d256-11da-e6d9b2ffbf60@deltatee.com>
 <20190628172926.GA3877@ziepe.ca>
 <25a87c72-630b-e1f1-c858-9c8b417506fc@deltatee.com>
 <20190628190931.GC3877@ziepe.ca>
 <cb680437-9615-da42-ebc5-4751e024a45f@deltatee.com>
 <20190702224530.GD11860@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190702224530.GD11860@ziepe.ca>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Bjorn Helgaas <bhelgaas@google.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Stephen Bates <sbates@raithlin.com>
List-Id: linux-rdma@vger.kernel.org



On 2019-07-02 4:45 p.m., Jason Gunthorpe wrote:
> On Fri, Jun 28, 2019 at 01:35:42PM -0600, Logan Gunthorpe wrote:
> 
>>> However, I'd feel more comfortable about that assumption if we had
>>> code to support the IOMMU case, and know for sure it doesn't require
>>> more info :(
>>
>> The example I posted *does* support the IOMMU case. That was case (b1)
>> in the description. The idea is that pci_p2pdma_dist() returns a
>> distance with a high bit set (PCI_P2PDMA_THRU_HOST_BRIDGE) when an IOMMU
>> mapping is required and the appropriate flag tells it to call
>> dma_map_resource(). This way, it supports both same-segment and
>> different-segments without needing any look ups in the map step.
> 
> I mean we actually have some iommu drivers that can setup P2P in real
> HW. I'm worried that real IOMMUs will need to have the BDF of the
> completer to route completions back to the requester - which we can't
> trivially get through this scheme.

I've never seen such an IOMMU but I guess, in theory, it could exist.
The IOMMUs that setup P2P-like transactions in real hardware make use of
dma_map_resource(). There aren't a lot of users of this function (it's
actually been broken with the Intel IOMMU until I fixed it recently and
I'd expect there are other broken implementations); but, to my
knowledge, none of them have needed the BDF of the provider to date.

> However, maybe that is just a future problem, and certainly we can see
> that with an interval tree or otherwise such a IOMMU could get the
> information it needs.

Yup, the rule of thumb is to design for the needs we have today not
imagined future problems.

Logan
