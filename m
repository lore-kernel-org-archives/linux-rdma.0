From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RFC PATCH 00/28] Removing struct page from P2PDMA
Date: Tue, 2 Jul 2019 19:45:30 -0300
Message-ID: <20190702224530.GD11860@ziepe.ca>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cb680437-9615-da42-ebc5-4751e024a45f@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Bjorn Helgaas <bhelgaas@google.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Stephen Bates <sbates@raithlin.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 28, 2019 at 01:35:42PM -0600, Logan Gunthorpe wrote:

> > However, I'd feel more comfortable about that assumption if we had
> > code to support the IOMMU case, and know for sure it doesn't require
> > more info :(
> 
> The example I posted *does* support the IOMMU case. That was case (b1)
> in the description. The idea is that pci_p2pdma_dist() returns a
> distance with a high bit set (PCI_P2PDMA_THRU_HOST_BRIDGE) when an IOMMU
> mapping is required and the appropriate flag tells it to call
> dma_map_resource(). This way, it supports both same-segment and
> different-segments without needing any look ups in the map step.

I mean we actually have some iommu drivers that can setup P2P in real
HW. I'm worried that real IOMMUs will need to have the BDF of the
completer to route completions back to the requester - which we can't
trivially get through this scheme.

However, maybe that is just a future problem, and certainly we can see
that with an interval tree or otherwise such a IOMMU could get the
information it needs.

Jason
